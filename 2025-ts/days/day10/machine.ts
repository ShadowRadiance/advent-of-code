// Since each button flips the state of the attached lights:
// - the current state can be modelled as an integer of size 2^numLights bits
// - the button can be modelled as an XOR of the current state with a number

import { chars } from "../../lib/parsing.ts";

export interface Machine {
  size: number;
  currentIndicatorLights: number;
  desiredIndicatorLights: number;
  buttonSchematics: number[];
  joltageRequirements: number[];
}

const LINE_REGEXP = /\[(.*)\] \((.*)\) \{(.*)\}/;

export function parseMachine(s: string): Machine {
  const results = LINE_REGEXP.exec(s)!;
  const size = results[1].length;

  const currentIndicatorLights = 0;
  const desiredIndicatorLights = indicatorLights(results[1]);
  const buttonSchematics = results[2].split(") (")
    .map((s) => buttonSchematic(s, size));
  const joltageRequirements = results[3].split(",")
    .map((s) => parseInt(s));

  return {
    size,
    currentIndicatorLights,
    desiredIndicatorLights,
    buttonSchematics,
    joltageRequirements,
  };
}

function indicatorLights(s: string): number {
  return parseInt(s.replaceAll(".", "0").replaceAll("#", "1"), 2);
}

function buttonSchematic(s: string, len: number): number {
  // 2,3 => "0".repeat(len).setAt(2,"1").setAt(3,"1")
  const base = chars("0".repeat(len));
  const indices = s.split(",").map((s) => parseInt(s));
  for (const index of indices) base[index] = "1";
  return parseInt(base.join(""), 2);
}

export function solveMachinePart1(machine: Machine): number {
  // return the smallest number of buttons to push to make current -> desired

  // since each button performs "current XOR button" pressing multiple times
  // is unnecessary each is pressed 0 or 1 times.

  const variations = Math.pow(2, machine.buttonSchematics.length);

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
  machine.currentIndicatorLights = 0;
  // push the buttons
  for (const button of buttons) machine.currentIndicatorLights ^= button;
  // does it get the right lights?
  return machine.currentIndicatorLights === machine.desiredIndicatorLights;
}

function buttonsForVariation(variation: number, machine: Machine): number[] {
  const buttons = [];
  for (let btnIdx = 0; btnIdx < machine.buttonSchematics.length; btnIdx++) {
    if ((Math.pow(2, btnIdx) & variation) !== 0) {
      buttons.push(machine.buttonSchematics[btnIdx]);
    }
  }
  return buttons;
}
