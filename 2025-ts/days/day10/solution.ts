// Since each button flips the state of the attached lights:
// - the current state can be modelled as an integer of size 2^numLights bits
// - the button can be modelled as an XOR of the current state with a number

import { solveMachinePart2_withBifurcation } from "./bifurcation_solution.ts";
import { solveMachinePart2_withGaussianElimination } from "./linear_system_solution.ts";
import { Machine } from "./machine.ts";

export function solveMachinePart1(machine: Machine): number {
  // return the smallest number of buttons to push to make lights -> desired

  // since each button performs "current XOR button" pressing multiple times
  // is unnecessary each is pressed 0 or 1 times.

  const variations = Math.pow(2, machine.buttons.length);

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
  return lights === machine.lightPatternBinary;
}

function buttonsForVariation(variation: number, machine: Machine): number[] {
  const buttons = [];
  for (let btnIdx = 0; btnIdx < machine.buttons.length; btnIdx++) {
    if ((Math.pow(2, btnIdx) & variation) !== 0) {
      buttons.push(machine.buttons[btnIdx].binary);
    }
  }
  return buttons;
}

export function solveMachinePart2(machine: Machine): number {
  // each button push adds 1 to the joltage counters
  // return the smallest number of buttons to push to make joltage -> required
  // (without going over)

  const result1 = solveMachinePart2_withGaussianElimination(machine);
  // 19293 in 0.603s

  // console.log(`[${machine.joltageRequirements.join(",")}] => ${result1}`);

  const result2 = solveMachinePart2_withBifurcation(machine);
  if (result1 !== result2) console.log("Incorrect");
  return result2;
}

function _zip<T>(xyz: T[], abc: T[]): T[][] {
  return xyz.map((item, idx) => [item, abc[idx]]);
}
