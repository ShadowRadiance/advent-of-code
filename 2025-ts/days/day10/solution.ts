// Since each button flips the state of the attached lights:
// - the current state can be modelled as an integer of size 2^numLights bits
// - the button can be modelled as an XOR of the current state with a number

import { solveMachinePart2_withGaussianElimination } from "./linear_system_solution.ts";
import { Machine } from "./machine.ts";

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

  return solveMachinePart2_withGaussianElimination(machine);
  // 19293 in 0.603s

  // return solveMachinePart2_withBifurcation(machine);
}

function solveMachinePart2_withBifurcation(machine: Machine): number {
  // https://www.reddit.com/r/adventofcode/comments/1pk87hl/
  // @tenthmascot
  return 0;
}

//----- START BIFURCATION -----//

//----- END BIFURCATION -----//

function _zip<T>(xyz: T[], abc: T[]): T[][] {
  return xyz.map((item, idx) => [item, abc[idx]]);
}
