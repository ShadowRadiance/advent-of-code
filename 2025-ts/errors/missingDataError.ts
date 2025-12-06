export class MissingDataError extends Error {
  constructor(day: number) {
    super(`Day ${day} data.txt is not available`);
    Object.setPrototypeOf(this, MissingDataError.prototype);
  }
}
