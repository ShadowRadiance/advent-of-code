// Since each button flips the state of the attached lights:
// - the current state can be modelled as an integer of size 2^numLights bits
// - the button can be modelled as an XOR of the current state with a number

import { chars } from "../../lib/parsing.ts";
import { reduce_add, reduce_min } from "../../lib/reduce_helpers.ts";

export interface Machine {
  size: number;
  desiredIndicatorLights: number;
  buttonBinaries: number[];
  buttonSchematics: number[][];
  joltageRequirements: number[];
}

const LINE_REGEXP = /\[(.*)\] \((.*)\) \{(.*)\}/;

export function parseMachine(s: string): Machine {
  const results = LINE_REGEXP.exec(s)!;
  const size = results[1].length;

  const desiredIndicatorLights = indicatorLights(results[1]);
  const buttonSchematics = results[2].split(") (")
    .map((s) => s.split(",").map((s) => parseInt(s)));
  const buttonBinaries = results[2].split(") (")
    .map((s) => buttonBinary(s, size));
  const joltageRequirements = results[3].split(",")
    .map((s) => parseInt(s));

  return {
    size,
    desiredIndicatorLights,
    buttonSchematics,
    buttonBinaries,
    joltageRequirements,
  };
}

function indicatorLights(s: string): number {
  return parseInt(s.replaceAll(".", "0").replaceAll("#", "1"), 2);
}

function buttonBinary(s: string, len: number): number {
  // 2,3 => "0".repeat(len).setAt(2,"1").setAt(3,"1")
  const base = chars("0".repeat(len));
  const indices = s.split(",").map((s) => parseInt(s));
  for (const index of indices) base[index] = "1";
  return parseInt(base.join(""), 2);
}

export function solveMachinePart1(machine: Machine): number {
  // return the smallest number of buttons to push to make lights -> desired

  // since each button performs "current XOR button" pressing multiple times
  // is unnecessary each is pressed 0 or 1 times.

  const variations = Math.pow(2, machine.buttonBinaries.length);

  let lowestButtonCountThatWorks = Infinity;

  for (let variation = 0; variation < variations; variation++) {
    if (variation === 0) continue; // the target is never "all off"
    const buttons = buttonsForVariation(variation, machine);
    if (buttons.length >= lowestButtonCountThatWorks) continue;
    if (testButtons(buttons, machine)) {
      lowestButtonCountThatWorks = buttons.length;
    }
  }

  return lowestButtonCountThatWorks;
}

function testButtons(buttons: number[], machine: Machine): boolean {
  // reset machine
  let lights = 0;
  // push the buttons
  for (const button of buttons) lights ^= button;
  // does it get the right lights?
  return lights === machine.desiredIndicatorLights;
}

function buttonsForVariation(variation: number, machine: Machine): number[] {
  const buttons = [];
  for (let btnIdx = 0; btnIdx < machine.buttonBinaries.length; btnIdx++) {
    if ((Math.pow(2, btnIdx) & variation) !== 0) {
      buttons.push(machine.buttonBinaries[btnIdx]);
    }
  }
  return buttons;
}

export function solveMachinePart2(machine: Machine): number {
  // each button push adds 1 to the joltage counters
  // return the smallest number of buttons to push to make joltage -> required
  // (without going over)

  // solve a system of equations
  // [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  // (where A-F are the buttons that target spots 0..3 in the joltage)
  // (0) 3 =                     wE + xF
  // (1) 5 =      tB                + xF
  // (2) 4 =         + uC + vD + wE
  // (3) 7 = sA + tB      + vD

  // [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
  // (where A-D are the buttons that target spots 0..5 in the joltage)
  // (0) 10 = sA + tB + uC
  // (1) 11 = sA      + uC + vD
  // (2) 11 = sA      + uC + vD
  // (3)  5 = sA + tB
  // (4) 10 = sA + tB + uC
  // (5)  5 =           uC

  // A.x = B

  // console.log(machine);

  const numberOfEquations = machine.joltageRequirements.length;
  const numberOfUnknowns = machine.buttonSchematics.length;

  const matrixA: number[][] = new Array(numberOfEquations);
  for (let i = 0; i < numberOfEquations; i++) {
    matrixA[i] = new Array(numberOfUnknowns);
    for (let j = 0; j < numberOfUnknowns; j++) {
      const pb = paddedButton(
        machine.buttonBinaries[j],
        machine.joltageRequirements.length,
      );
      matrixA[i][j] = affectsSlot(i, pb) ? 1 : 0;
    }
  }
  const matrixX: string[][] = new Array(numberOfEquations);
  for (let i = 0; i < numberOfEquations; i++) {
    matrixX[i] = [`x${i + 1}`];
  }
  const matrixB: number[][] = new Array(numberOfEquations);
  for (let i = 0; i < numberOfEquations; i++) {
    matrixB[i] = [machine.joltageRequirements[i]];
  }

  return 0;
}

function affectsSlot(slot: number, paddedButton: string): boolean {
  // button:                                  1001
  // if i is 2 we want to check for a 1 here: 01^3

  return (paddedButton[slot] === "1");
}

function paddedButton(button: number, size: number): string {
  return button.toString(2).padStart(size, "0");
}

const INFINITY = 999999999;

interface Deets {
  // coefficientMatrix[m][n] is 1 if pressing the nth button increases the mth counter
  //                            0 if pressing the nth button ignores the mth counter
  coefficientMatrix: number[][];
  // requiredJoltages is the list of required final values of each counter
  requiredJoltages: number[];
  // list of bounds for the number of times each button can be pressed
  // buttonBounds[i] is the min required value of a counter increased by btn i
  buttonBounds: number[];
}

function gcd(a: number, b: number): number {
  a = Math.abs(a);
  b = Math.abs(b);
  while (b !== 0) {
    [a, b] = [b, a % b]; // Swap a and b, b becomes the remainder
  }
  return a;
}

function swapRows(
  matrix: number[][],
  joltages: number[],
  i: number,
  j: number,
): void {
  if (i !== j) {
    [matrix[i], matrix[j]] = [matrix[j], matrix[i]];
    [joltages[i], joltages[j]] = [joltages[j], joltages[i]];
  }
}

function swapCols(
  matrix: number[][],
  buttonBounds: number[],
  i: number,
  j: number,
): void {
  if (i !== j) {
    for (let row = 0; row < matrix.length; row++) {
      [matrix[row][i], matrix[row][j]] = [matrix[row][j], matrix[row][i]];
    }
    [buttonBounds[i], buttonBounds[j]] = [buttonBounds[j], buttonBounds[i]];
  }
}

function reduceRow(
  matrix: number[][],
  joltages: number[],
  i: number,
  j: number,
): void {
  if (matrix[i][i] !== 0) {
    const x = matrix[i][i];
    const y = -matrix[j][i];
    const denom = gcd(x, y);

    const newRowJ = []; // (y*matrix[i][k]+x*matrix[j][k])/d for k in range(len(matrix[i]));
    for (let k = 0; k < matrix[i].length; k++) {
      newRowJ.push(
        (y * matrix[i][k] + x * matrix[j][k]) / denom,
      );
    }

    matrix[j] = newRowJ;
    joltages[j] = (y * joltages[i] + x * joltages[j]) / denom;
  }
}

function pyBuildDeets(matrixA: number[][], machine: Machine): Deets {
  const bounds = [];
  for (let i = 0; i < machine.buttonSchematics.length; i++) {
    const bs = machine.buttonSchematics[i];
    const jrs = machine.joltageRequirements;
    bounds.push(bs.map((num) => jrs[num]).reduce(reduce_min));
  }

  return {
    coefficientMatrix: matrixA,
    requiredJoltages: machine.joltageRequirements,
    buttonBounds: bounds,
  };
}

// Reduce the matrix A by row, including back subsitution.
// Returns a Deets where:
//  the matrix is the reduced matrix in the form [D|p]
//    with D diagonal and p a matrix whose number of columns is the
//    number of free parameters for Ax = b.
//  requiredJoltages and buttonBounds are the adjusted versions of the
//    input paramters with the same names.
//  requiredJoltages is adjusted every time a row is reduced
//    and when rows are swapped
//  buttonBounds is adjusted when two columns are swapped (which is equivalent
//    to changing the order of two buttons).
function pyReduceABC(deets: Deets): Deets {
  const matrix = deets.coefficientMatrix;
  const bounds = deets.buttonBounds;
  const joltages = deets.requiredJoltages;

  for (let colIdx = 0; colIdx < matrix[0].length; colIdx++) {
    // Swap columns until there is one in position colIdx with at least
    // one non-zero element.
    const I = [];
    let k = colIdx;
    while (I.length === 0 && k < matrix[0].length) {
      swapCols(matrix, bounds, colIdx, k);
      for (let j = colIdx; j < matrix.length; j++) {
        I.push((matrix[j][colIdx] !== 0) ? j : 0);
      }
      k += 1;
    }

    // If no such column is found, we are done
    if (I.length === 0) break;

    // Swap rows so that matrix[colIdx][colIdx] is non-zero
    swapRows(matrix, joltages, colIdx, I[0]);

    for (let j = colIdx + 1; j < matrix.length; j++) {
      reduceRow(matrix, joltages, colIdx, j);
    }
  }

  // # Remove all rows of zero and check if the system is solvable
  // I = [i for i in range(len(matrix)) if any(a != 0 for a in matrix[i])]
  // matrix = [matrix[i] for i in I]
  // joltages = [joltages[i] for i in I]

  // # Back substitution
  // for i in range(len(matrix)-1, -1, -1):
  //   for j in range(i):
  //     reducerow(matrix, joltages, i, j)

  // return matrix, joltages, bounds

  return {
    buttonBounds: bounds,
    coefficientMatrix: matrix,
    requiredJoltages: joltages,
  };
}

function pyParamComb(nParam: number, bounds: number[]): number[][] {
  if (nParam === 0) return [[]];
  const ret = [];
  for (let i = 0; i < bounds[-nParam] + 1; i++) {
    for (const l of pyParamComb(nParam - 1, bounds)) {
      const s = [i, ...l];
      ret.push(s);
    }
  }
  return ret;
}

// Solve the integer linear system Ax = b, minimizing the sum of the
// coordinates of x.
function pySolveSystemMinSum(deets: Deets): number {
  const matrix = deets.coefficientMatrix;
  const nParam = matrix[0].length - matrix.length;

  let mins = INFINITY;
  for (const combo of pyParamComb(nParam, deets.buttonBounds)) {
    let sol = combo.reduce(reduce_add);
    for (let i = 0; i < matrix.length; i++) {
      const cc = [];
      for (let j = 0; j < combo.length; j++) {
        cc.push(combo[j] * matrix.at(i)!.at(matrix[0].length - nParam + j)!);
      }

      let s = deets.requiredJoltages[i] - cc.reduce(reduce_add);
      let a = s / matrix[i][i];
      // If a is negative or not integer, we skip this solution
      if (a < 0 || s % matrix[i][i] !== 0) {
        sol = INFINITY;
        break;
      }
      sol += a;
    }
    mins = Math.min(mins, sol);
  }
  return mins;
}

function solveForMachinePython(matrixA: number[][], machine: Machine): number {
  const deets = pyBuildDeets(matrixA, machine);
  const deets2 = pyReduceABC(deets);
  return pySolveSystemMinSum(deets2);
}
