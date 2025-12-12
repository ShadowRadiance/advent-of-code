import { ArgumentError } from "../errors/argumentError.ts";
import { StopIteration } from "../errors/stopIteration.ts";
import { Location } from "./location.ts";
import { chars, lines } from "./parsing.ts";

function isStringGrid(grid: unknown): grid is Grid<string> {
  return (grid as Grid<string>) !== undefined;
}

export class Grid<T> {
  data: T[][];

  constructor(data: T[][]) {
    this.data = data;
  }

  validLocation(loc: Location) {
    return this.validLocationXY(loc.x, loc.y);
  }

  validLocationXY(x: number, y: number) {
    if (y < 0 || y >= this.data.length) return false;
    if (x < 0 || x >= this.data[y].length) return false;
    return true;
  }

  validateLocation(loc: Location) {
    this.validateLocationXY(loc.x, loc.y);
  }

  validateLocationXY(x: number, y: number) {
    if (!this.validLocationXY(x, y)) {
      throw new ArgumentError(`(${x},${y}) is not a valid location`);
    }
  }

  numRows() {
    return this.data.length;
  }

  numCols() {
    if (this.numRows() === 0) return 0;
    return this.data[0].length;
  }

  row(idx: number): T[] {
    return this.data[idx];
  }

  at(loc: Location): T | null {
    return this.atXY(loc.x, loc.y);
  }

  atXY(x: number, y: number): T | null {
    if (!this.validLocationXY(x, y)) return null;
    return this.data[y][x];
  }

  setAt(loc: Location, value: T): void {
    return this.setAtXY(loc.x, loc.y, value);
  }

  setAtXY(x: number, y: number, value: T): void {
    this.validateLocationXY(x, y);
    this.data[y][x] = value;
  }

  mapCells(
    callbackFn: (value: T, rowIndex: number, colIndex: number) => T,
  ): Grid<T> {
    return new Grid<T>(
      this.data.map((row, rowIndex) => {
        return row.map((cell, colIndex) => {
          return callbackFn(cell, rowIndex, colIndex);
        });
      }),
    );
  }

  forEachCell(
    callbackFn: (value: T, rowIndex: number, colIndex: number) => void,
  ): void {
    try {
      this.data.forEach((row, rowIndex) => {
        row.forEach((cell, colIndex) => {
          callbackFn(cell, rowIndex, colIndex);
        });
      });
    } catch (e) {
      if (!(e instanceof StopIteration)) throw e;
    }
  }

  representation(joiner?: string) {
    if (joiner === undefined) {
      if (isStringGrid(this)) joiner = "";
      else joiner = ", ";
    }

    return this.data.map((row) => row.join(joiner)).join("\n");
  }

  count(value: T) {
    let c: number = 0;
    this.forEachCell((cell) => {
      if (cell === value) c += 1;
    });
    return c;
  }

  find(target: T): Location | null {
    let location: Location | null = null;
    this.forEachCell((value, rIdx, cIdx) => {
      if (target === value) {
        location = new Location(cIdx, rIdx);
        throw new StopIteration();
      }
    });
    return location;
  }

  static gridFromString(s: string) {
    return new Grid(lines(s).map((line) => chars(line)));
  }
}
