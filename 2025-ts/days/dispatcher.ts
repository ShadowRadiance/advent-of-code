import { MissingDayError } from "../errors/missingDayError.ts";
import { MissingPartError } from "../errors/missingPartError.ts";
import { MissingDataError } from "../errors/missingDataError.ts";
import * as day01 from "./day01/index.ts";
import * as day02 from "./day02/index.ts";
import * as day03 from "./day03/index.ts";
import * as day04 from "./day04/index.ts";
import * as day05 from "./day05/index.ts";
import * as day06 from "./day06/index.ts";

const dispatcher: ((data: string) => string)[][] = [
  [day01.part_1, day01.part_2],
  [day02.part_1, day02.part_2],
  [day03.part_1, day03.part_2],
  [day04.part_1, day04.part_2],
  [day05.part_1, day05.part_2],
  [day06.part_1, day06.part_2],
];

function dualNumber(input: number): string {
  if (input < 0) throw new Error("Invalid");
  if (input < 10) return `0${input}`;
  return `${input}`;
}

export function dispatch(day: number, part: number): string {
  if (day > dispatcher.length) throw new MissingDayError(day);
  if (part > dispatcher[day - 1].length) throw new MissingPartError(day, part);

  try {
    const fileName = `./days/day${dualNumber(day)}/data.txt`;
    const data = Deno.readTextFileSync(fileName);
    return (dispatcher[day - 1][part - 1])(data);
  } catch (e) {
    if ((e as Error).name === "NotFound") {
      throw new MissingDataError(day);
    }
    throw e;
  }
}
