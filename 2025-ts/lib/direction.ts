import { Vector } from "./vector.ts";

export class Direction extends Vector {
  override add(dir: Direction): Direction {
    return this.addXY(dir.x, dir.y);
  }

  override addXY(x: number, y: number): Direction {
    return new Direction(this.x + x, this.y + y);
  }
}
