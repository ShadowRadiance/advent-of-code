import { Vector } from "./vector.ts";
import { Direction } from "./direction.ts";

export class Location extends Vector {
  override add(dir: Direction): Location {
    return this.addXY(dir.x, dir.y);
  }

  override addXY(x: number, y: number): Location {
    return new Location(this.x + x, this.y + y);
  }
}
