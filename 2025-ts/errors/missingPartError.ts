export class MissingPartError extends Error {
  constructor(day: number, part: number) {
    super(`Day ${day} Part ${part} is not available`);
    Object.setPrototypeOf(this, MissingPartError.prototype);
  }
}
