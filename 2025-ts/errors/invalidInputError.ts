export class InvalidInputError extends Error {
  constructor() {
    super("Invalid Inputs: aoc2025 <day:1-12> <part:1-2>");
    Object.setPrototypeOf(this, InvalidInputError.prototype);
  }
}
