import { Location } from "./location.ts";

export class Rectangle {
  private _topLft!: Location;
  private _btmRgt!: Location;

  readonly wide: number;
  readonly high: number;
  readonly area: number;

  constructor(a: Location, b: Location) {
    this.recordCorners(a, b);
    this.wide = Math.abs(this.br.x - this.tl.x) + 1;
    this.high = Math.abs(this.br.y - this.tl.y) + 1;
    this.area = this.wide * this.high;
  }

  get tl(): Location {
    return this._topLft;
  }
  get br(): Location {
    return this._btmRgt;
  }

  private recordCorners(a: Location, b: Location) {
    // a is top left     [a  ]
    // b is bottom right [  b]
    if (a.x <= b.x && a.y <= b.y) {
      this._topLft = a;
      this._btmRgt = b;
      return;
    }

    // a is bottom left [  b]
    // b is top right   [a  ]
    if (a.x <= b.x && a.y > b.y) {
      this._topLft = new Location(a.x, b.y);
      this._btmRgt = new Location(b.x, a.y);
      return;
    }

    // a is top right   [  a]
    // b is bottom left [b  ]
    if (a.x > b.x && a.y <= b.y) {
      this._topLft = new Location(b.x, a.y);
      this._btmRgt = new Location(a.x, b.y);
      return;
    }

    // a is bottom right [b  ]
    // b is top left     [  a]
    if (a.x > b.x && a.y > b.y) {
      this._topLft = b;
      this._btmRgt = a;
      return;
    }
  }

  containsFully(loc: Location): boolean {
    return this.containsFullyXY(loc.x, loc.y);
  }

  containsFullyXY(x: number, y: number): boolean {
    return ((x > this.tl.x && x < this.br.x) &&
      (y > this.tl.y && y < this.br.y));
  }
}
