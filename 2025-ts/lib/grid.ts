import { Location } from "./location.ts";

export class Grid<T> {
  data: T[][];

  constructor(data: T[][]) {
    this.data = data;
  }

  validLocationXY(x: number, y: number) {
    if (y < 0 || y >= this.data.length) return false;
    if (x < 0 || x >= this.data[y].length) return false;
    return true;
  }

  at(loc: Location): T | null {
    return this.atXY(loc.x, loc.y);
  }

  atXY(x: number, y: number): T | null {
    if (!this.validLocationXY(x, y)) return null;
    return this.data[y][x];
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

  representation() {
    // deno-lint-ignore no-this-alias
    const that = this;

    if (isStringGrid(that)) {
      return that.data.map((row) => row.join("")).join("\n");
    }

    return this.data.map((row) => row.join(", ")).join("\n");
  }

  count(value: T) {
    let c = 0;
    this.data.forEach((row) => {
      row.forEach((cell) => {
        if (cell === value) c += 1;
      });
    });
    return c;
  }
}

function isStringGrid(grid: unknown): grid is Grid<string> {
  return (grid as Grid<string>) !== undefined;
}
