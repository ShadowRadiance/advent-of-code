export class StopIteration extends Error {
  constructor() {
    super("Stop Iteration");
    Object.setPrototypeOf(this, StopIteration.prototype);
  }
}
