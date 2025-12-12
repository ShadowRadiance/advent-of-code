// Since each button flips the state of the attached lights:
// - the current state can be modelled as an integer of size 2^numLights bits
// - the button can be modelled as an XOR of the current state with a number

import { chars } from "../../lib/parsing.ts";

export interface Machine {
  size: number;
  desiredIndicatorLights: number;
  buttonSchematics: number[];
  joltageRequirements: number[];
}

const LINE_REGEXP = /\[(.*)\] \((.*)\) \{(.*)\}/;

export function parseMachine(s: string): Machine {
  const results = LINE_REGEXP.exec(s)!;
  const size = results[1].length;

  const desiredIndicatorLights = indicatorLights(results[1]);
  const buttonSchematics = results[2].split(") (")
    .map((s) => buttonSchematic(s, size));
  const joltageRequirements = results[3].split(",")
    .map((s) => parseInt(s));

  return {
    size,
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
  // return the smallest number of buttons to push to make lights -> desired

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
  let lights = 0;
  // push the buttons
  for (const button of buttons) lights ^= button;
  // does it get the right lights?
  return lights === machine.desiredIndicatorLights;
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
        machine.buttonSchematics[j],
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
