import { BinaryParitySolver, parityString } from "./binary_parity_solver.ts";
import { Button } from "./button.ts";
import { Machine } from "./machine.ts";

type JoltageCache = Record<string, number | null>;

export function solveMachinePart2_withBifurcation(machine: Machine): number {
  // https://www.reddit.com/r/adventofcode/comments/1pk87hl/
  // @tenthmascot

  const solver = new BifurcationSolver(machine);
  return solver.minimumButtons(machine.joltageRequirements) ?? Infinity;
}

class BifurcationSolver {
  buttons: Button[];
  bps: BinaryParitySolver;
  cache: JoltageCache;

  constructor(machine: Machine) {
    this.buttons = machine.buttons;
    this.bps = new BinaryParitySolver(machine.size, machine.buttons);
    this.cache = {};
  }

  minimumButtons(reqJs: number[]): number | null {
    if (allZero(reqJs)) return 0;

    const key = reqJs.join(",");
    if (this.cache[key] !== undefined) {
      return this.cache[key];
    }

    const indicators = parityString(reqJs);
    let result = null;
    const pressesList = this.bps.parityMap.get(indicators);
    if (pressesList === undefined) {
      this.cache[key] = null;
      return this.cache[key];
    }

    for (const presses of pressesList!) {
      const reqJsAfter = [...reqJs];
      for (const button of presses) {
        for (const connection of button.schema) {
          reqJsAfter[connection] -= 1;
        }
      }
      if (anyNegative(reqJsAfter)) continue;

      const halfReqJsAfter = reqJsAfter.map((n) => n / 2);
      const numPressesForHalfReqJsAfter = this.minimumButtons(halfReqJsAfter);
      if (numPressesForHalfReqJsAfter === null) continue;
      const numPresses = presses.length + 2 * numPressesForHalfReqJsAfter;

      if (result === null) {
        result = numPresses;
      } else {
        result = Math.min(result, numPresses);
      }
    }

    this.cache[key] = result;
    return result;
  }
}

function allZero(arr: number[]): boolean {
  return arr.every((n) => n === 0);
}

function anyNegative(arr: number[]) {
  return arr.some((n) => n < 0);
}
