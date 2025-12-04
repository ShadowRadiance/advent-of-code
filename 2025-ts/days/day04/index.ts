import { Grid } from "../../lib/grid.ts";
import { Direction } from "../../lib/direction.ts";
import { Location } from "../../lib/location.ts";

/** --- Day 4: Printing Department ---
 *
 * You ride the escalator down to the printing department. They're clearly
 * getting ready for Christmas; they have lots of large rolls of paper
 * everywhere, and there's even a massive printer in the corner (to handle
 * the really big print jobs).
 *
 * Decorating here will be easy: they can make their own decorations. What
 * you really need is a way to get further into the North Pole base while the
 * elevators are offline.
 *
 * "Actually, maybe we can help with that," one of the Elves replies when you
 * ask for help. "We're pretty sure there's a cafeteria on the other side of
 * the back wall. If we could break through the wall, you'd be able to keep
 * moving. It's too bad all of our forklifts are so busy moving those big
 * rolls of paper around."
 *
 * If you can optimize the work the forklifts are doing, maybe they would have
 * time to spare to break through the wall.
 *
 * The rolls of paper (@) are arranged on a large grid; the Elves even have a
 * helpful diagram (your puzzle input) indicating where everything is located.
 *
 * For example:
 *
 * ..@@.@@@@.
 * @@@.@.@.@@
 * @@@@@.@.@@
 * @.@@@@..@.
 * @@.@@@@.@@
 * .@@@@@@@.@
 * .@.@.@.@@@
 * @.@@@.@@@@
 * .@@@@@@@@.
 * @.@.@@@.@.
 *
 * The forklifts can only access a roll of paper if there are fewer than four
 * rolls of paper in the eight adjacent positions. If you can figure out which
 * rolls of paper the forklifts can access, they'll spend less time looking
 * and more time breaking down the wall to the cafeteria.
 *
 * In this example, there are 13 rolls of paper that can be accessed by a
 * forklift (marked with x):
 *
 *   ..xx.xx@x.
 *   x@@.@.@.@@
 *   @@@@@.x.@@
 *   @.@@@@..@.
 *   x@.@@@@.@x
 *   .@@@@@@@.@
 *   .@.@.@.@@@
 *   x.@@@.@@@@
 *   .@@@@@@@@.
 *   x.x.@@@.x.
 *
 * Consider your complete diagram of the paper roll locations. How many rolls
 * of paper can be accessed by a forklift?
 */

export function part_1(input: string): string {
  // paperRoll accessible if 0-3 paperRolls adjacent (including diagonal)

  const grid = gridFromString(input);
  const grid2 = markGrid(grid);
  return grid2.count("X").toString();
}

/** --- Part Two ---
 */

export function part_2(_input: string): string {
  return `PENDING`;
}

function gridFromString(s: string) {
  return new Grid(s.split("\n").map((line) => chars(line)));
}

function chars(s: string) {
  return s.split("");
}

function markGrid(grid: Grid<string>) {
  return grid.mapCells((cell, rowIndex, colIndex) => {
    if (cell === "@" && accessible(rowIndex, colIndex, grid)) return "X";
    return cell;
  });
}

function accessible(y: number, x: number, grid: Grid<string>): boolean {
  // read surrounding elements, count rolls
  const directions = [
    new Direction(-1, -1),
    new Direction(-1, 0),
    new Direction(-1, 1),
    new Direction(0, -1),
    new Direction(0, 1),
    new Direction(1, -1),
    new Direction(1, 0),
    new Direction(1, 1),
  ];
  const base = new Location(x, y);
  const counter = (accumulator: number, dir: Direction) => {
    const loc = base.add(dir);
    const charAtLoc = grid.at(loc);
    if (charAtLoc === "@") accumulator += 1; // nothing if off grid
    return accumulator;
  };
  const count = directions.reduce(counter, 0);

  return count <= 3;
}
