import { MissingDayError } from "../errors/missingDayError.ts";
import { MissingPartError } from "../errors/missingPartError.ts";
import { MissingDataError } from "../errors/missingDataError.ts";

const dispatcher: ((data: string) => string)[][] = [];

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
