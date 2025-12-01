export class MissingDayError extends Error {
  constructor(day: number) {
    super(`Day ${day} is not available`);
    Object.setPrototypeOf(this, MissingDayError.prototype);
  }
}
