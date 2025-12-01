import { MissingDayError } from "../errors/missingDayError.ts";
import { MissingPartError } from "../errors/missingPartError.ts";

const dispatcher: (() => string)[][] = [];

export function dispatch(day: number, part: number): string {
  if (day > dispatcher.length) throw new MissingDayError(day);
  if (part > dispatcher[day - 1].length) throw new MissingPartError(day, part);

  return (dispatcher[day - 1][part - 1])();
}
