import { InvalidInputError } from "./errors/invalidInputError.ts";
import { dispatch } from "./days/dispatcher.ts";

function aoc2025(day: number, part: number): string {
  const invalidInputs = isNaN(day) || isNaN(part) ||
    day < 1 || day > 12 ||
    part < 1 || part > 2;

  if (invalidInputs) throw new InvalidInputError();

  return dispatch(day, part);
}

(() => {
  const day = Number.parseInt(Deno.args[0], 10);
  const part = Number.parseInt(Deno.args[1], 10);

  try {
    const result: string = aoc2025(day, part);
    console.log(`AOC 2025 Day ${day} Part ${part}: ${result}`);
  } catch (e) {
    console.log((e as Error).message);
    console.log("Run aoc2025 <day:1-12> <part:1-2>");
  }
})();
