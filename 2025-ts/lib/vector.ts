export class Vector {
  readonly x: number;
  readonly y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }

  add(other: Vector): Vector {
    return this.addXY(other.x, other.y);
  }

  addXY(x: number, y: number): Vector {
    return new Vector(this.x + x, this.y + y);
  }
}
