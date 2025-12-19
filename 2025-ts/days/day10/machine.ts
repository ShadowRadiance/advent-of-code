import { chars } from "../../lib/parsing.ts";

export interface Machine {
  size: number;
  desiredIndicatorLights: number;
  buttonBinaries: number[];
  buttonSchematics: number[][];
  joltageRequirements: number[];
}

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

const LINE_REGEXP = /\[(.*)\] \((.*)\) \{(.*)\}/;

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
