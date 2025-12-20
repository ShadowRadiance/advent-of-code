// Since each button flips the state of the attached lights:
// - the current state can be modelled as an integer of size 2^numLights bits
// - the button can be modelled as an XOR of the current state with a number

import { reduce_min } from "../../lib/reduce_helpers.ts";
import { solveMachinePart2_withBifurcation } from "./bifurcation_solution.ts";
import { BinaryParitySolver } from "./binary_parity_solver.ts";
import { solveMachinePart2_withGaussianElimination } from "./linear_system_solution.ts";
import { Machine } from "./machine.ts";

export function solveMachinePart1(machine: Machine): number {
  // return the smallest number of buttons to push to make lights -> desired

  const bps = new BinaryParitySolver(machine.size, machine.buttons);
  return bps.parityMap.get(machine.lightPattern)!
    .map((c) => c.length)
    .reduce(reduce_min);
}

export function solveMachinePart2(machine: Machine): number {
  // each button push adds 1 to the joltage counters
  // return the smallest number of buttons to push to make joltage -> required
  // (without going over)

  const result1 = solveMachinePart2_withGaussianElimination(machine);
  // 19293 in 0.603s

  // console.log(`[${machine.joltageRequirements.join(",")}] => ${result1}`);

  const result2 = solveMachinePart2_withBifurcation(machine);
  // 19293 in 0.340s

  if (result1 !== result2) {
    console.log(`Incorrect: ${result2} should be ${result1}`);
  } else {
    console.log(`CORRECT!!: ${result2} should be ${result1}`);
  }
  return result2;
}

function _zip<T>(xyz: T[], abc: T[]): T[][] {
  return xyz.map((item, idx) => [item, abc[idx]]);
}
