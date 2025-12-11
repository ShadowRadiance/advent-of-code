export class SkippedPartError extends Error {
  constructor(day: number, part: number) {
    super(`Skipped Day ${day} Part ${part}`);
    Object.setPrototypeOf(this, SkippedPartError.prototype);
  }
}
