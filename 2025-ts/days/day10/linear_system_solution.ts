// With credit to icub3d's Rust Solution
// https://github.com/icub3d/advent-of-code/blob/main/aoc_2025/src/bin/day10.rs

import { Grid } from "../../lib/grid.ts";
import { reduce_add } from "../../lib/reduce_helpers.ts";

const EPSILON = 1e-9;

interface Machine {
  size: number;
  desiredIndicatorLights: number;
  buttonBinaries: number[];
  buttonSchematics: number[][];
  joltageRequirements: number[];
}

export function solveMachinePart2_withGaussianElimination(
  machine: Machine,
): number {
  /* solve as a system of equations

    [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    (where A-F are the buttons that target spots 0..3 in the joltage)
    (0) 3 =                     wE + xF  ==> [0 0 0 0 1 1 || 3]
    (1) 5 =      tB                + xF  ==> [0 1 0 0 0 1 || 5]
    (2) 4 =         + uC + vD + wE       ==> [0 0 1 1 1 0 || 4]
    (3) 7 = sA + tB      + vD            ==> [1 1 0 1 0 0 || 7]

    After GE
      ==> [1 0 0 1 0 -1 || 2]  ==>  A     D  -F=2 ==> A = 2-D+F
          [0 1 0 0 0  1 || 5]  ==>    B      +F=5 ==> B = 5  -F
          [0 0 1 1 0 -1 || 1]  ==>      C+D  -F=1 ==> C = 1-D+F
          [0 0 0 0 1  1 || 3]  ==>          E+F=3 ==> E = 3  -F
    We now have 4 constrained variables (ABCE) and two free variables (DF)
    Check combinations of D and F (no larger than a maximum value)
    for a solution to the joltages.

    [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    (where A-D are the buttons that target spots 0..5 in the joltage)
    (0) 10 = sA + tB + uC                ==> [1 1 1 0 || 10]
    (1) 11 = sA      + uC + vD           ==> [1 0 1 1 || 11]
    (2) 11 = sA      + uC + vD           ==> [1 0 1 1 || 11]
    (3)  5 = sA + tB                     ==> [1 1 0 0 ||  5]
    (4) 10 = sA + tB + uC                ==> [1 1 1 0 || 10]
    (5)  5 =           uC                ==> [0 0 1 0 ||  5]

    After GE
      ==> [1 0 0  1 ||  6]   ==> A    +D= 6  ==> A =  6-D
          [0 1 0 -1 || -1]   ==>   B  -D=-1  ==> B = -1+D
          [0 0 1  0 ||  5]   ==>     C  = 5  ==> C =  5
          [0 0 0  0 ||  0]
          [0 0 0  0 ||  0]
          [0 0 0  0 ||  0]
    We now have 3 constrained variables (ABC) and one free variables (D)
    Check combinations of D (no larger than a maximum value)
    for a solution to the joltages.

    .etc.
  */
  let result = 0;
  const matrixInfo = MatrixInfo.fromMachine(machine);

  const idx = 0;
  const values = new Array(matrixInfo.independentColIdxs.length).fill(0);
  const min = Infinity;
  const max = Math.max(...machine.joltageRequirements);

  result = minViaDFS(matrixInfo, idx, values, min, max);
  return result;
}

class MatrixInfo {
  data: number[][];
  eqns: number;
  unks: number;
  rows: number;
  cols: number;
  dependentColIdxs: number[] = [];
  independentColIdxs: number[] = [];

  constructor(data: number[][], eqns: number, unks: number) {
    this.data = data;
    this.eqns = eqns;
    this.unks = unks;

    this.rows = eqns;
    this.cols = unks + 1;
  }

  static fromMachine(machine: Machine): MatrixInfo {
    const eqns = machine.joltageRequirements.length;
    const unks = machine.buttonSchematics.length;
    const data = Array.from(
      { length: eqns },
      () => Array.from({ length: unks + 1 }, () => (0)),
    );
    machine.buttonSchematics.forEach((schematic, btnIdx) => {
      schematic.forEach((connectedCounterIdx) => {
        if (connectedCounterIdx < eqns) data[connectedCounterIdx][btnIdx] = 1.0;
      });
    });
    machine.joltageRequirements.forEach((jRequirement, jCounterIdx) => {
      data[jCounterIdx][unks] = jRequirement;
    });

    const matrixInfo = new MatrixInfo(data, eqns, unks);
    matrixInfo.gaussianElimination();
    return matrixInfo;
  }

  valid(values: number[]): number | null {
    let total = values.reduce(reduce_add, 0);
    for (let row = 0; row < this.dependentColIdxs.length; row++) {
      let timesToPush: number = this.data[row].at(-1)!;
      this.independentColIdxs.forEach((indColIdx, valuesIdx) => {
        timesToPush -= this.data[row][indColIdx] * values[valuesIdx];
      });

      if (timesToPush < -EPSILON) return null;
      const rounded = Math.round(timesToPush);
      if (Math.abs(timesToPush - rounded) > EPSILON) return null;

      total += rounded;
    }
    return total;
  }

  gaussianElimination() {
    let pivot = 0;
    let col = 0;

    while (col < this.unks) {
      if (pivot >= this.eqns) {
        this.independentColIdxs.push(col);
        col += 1;
        continue;
      }

      // Find the best pivot row for this column.
      const { row: bestRow, val: bestValue } = this.bestPivotRow(pivot, col);

      // If the best value is zero, this is a free variable.
      if (bestValue === 0) {
        this.independentColIdxs.push(col);
        col += 1;
        continue;
      }

      // Swap rows and mark this column as dependent.
      this.swapRows(pivot, bestRow);
      this.dependentColIdxs.push(col);

      // Normalize pivot row.
      this.normalizeRow(pivot, col);

      // Eliminate this column in all other rows.
      this.zeroOutColumn(pivot, col);

      pivot += 1;
      col += 1;
    }
  }

  private zeroOutColumn(pivotRow: number, col: number): void {
    for (let r = 0; r < this.eqns; r++) {
      if (r != pivotRow) {
        const factor = this.data[r][col];
        if (Math.abs(factor) > EPSILON) {
          for (let c = col; c <= this.unks; c++) {
            const val = this.data[r][c];
            const pivotVal = this.data[pivotRow][c];
            this.data[r][c] = val - (factor * pivotVal);
          }
        }
      }
    }
  }

  private normalizeRow(row: number, col: number): void {
    const cols = this.data[0].length;
    const pivotValue = this.data[row][col];
    if (pivotValue === 1) return;
    for (let c = col; c < cols; c++) {
      this.data[row][c] /= pivotValue;
    }
  }

  private bestPivotRow(
    pivot: number,
    col: number,
  ): { row: number; val: number } {
    let largest = { val: -Infinity, row: -1 };

    for (let row = pivot; row < this.rows; row++) {
      const val = Math.abs(this.data[row][col]);
      if (val > largest.val) {
        largest = { val, row };
      }
    }
    return largest;
  }

  private swapRows(a: number, b: number): void {
    if (a === b) {
      return;
    }

    [this.data[a], this.data[b]] = [this.data[b], this.data[a]];
  }

  rep(): string {
    return new Grid(this.data).representation(" ");
  }
}

function minViaDFS(
  matrixInfo: MatrixInfo,
  independentIdx: number,
  values: number[],
  minSoFar: number,
  max: number,
): number {
  if (independentIdx === matrixInfo.independentColIdxs.length) {
    const total = matrixInfo.valid(values);
    if (total !== null) minSoFar = Math.min(minSoFar, total);
    return minSoFar;
  }

  // Try different values for the current independent variable.
  // let total: usize = values[..independentIdx].iter().sum();
  const total = values.slice(0, independentIdx).reduce(reduce_add, 0);
  for (let val = 0; val < max; val++) {
    // Optimization: If we ever go above our minSoFar, we can't possibly do better.
    if (total + val >= minSoFar) break;

    values[independentIdx] = val;
    minSoFar = minViaDFS(matrixInfo, independentIdx + 1, values, minSoFar, max);
  }

  return minSoFar;
}
