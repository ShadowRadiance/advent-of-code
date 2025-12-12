/** --- Day 9: Movie Theater ---
 *
 * You slide down the firepole in the corner of the playground and land in the
 * North Pole base movie theater!
 *
 * The movie theater has a big tile floor with an interesting pattern. Elves
 * here are redecorating the theater by switching out some of the square tiles
 * in the big grid they form. Some of the tiles are red; the Elves would like
 * to find the largest rectangle that uses red tiles for two of its opposite
 * corners. They even have a list of where the red tiles are located in the
 * grid (your puzzle input).
 *
 * For example:
 *
 * 7,1
 * 11,1
 * 11,7
 * 9,7
 * 9,5
 * 2,5
 * 2,3
 * 7,3
 *
 * Showing red tiles as # and other tiles as ., the above arrangement of red
 * tiles would look like this:
 *
 * ..............
 * .......#...#..
 * ..............
 * ..#....#......
 * ..............
 * ..#......#....
 * ..............
 * .........#.#..
 * ..............
 *
 * You can choose any two red tiles as the opposite corners of your rectangle;
 * your goal is to find the largest rectangle possible.
 *
 * For example, you could make a rectangle (shown as O) with an area of 24
 * between 2,5 and 9,7:
 *
 * ..............
 * .......#...#..
 * ..............
 * ..#....#......
 * ..............
 * ..OOOOOOOO....
 * ..OOOOOOOO....
 * ..OOOOOOOO.#..
 * ..............
 *
 * Or, you could make a rectangle with area 35 between 7,1 and 11,7:
 *
 * ..............
 * .......OOOOO..
 * .......OOOOO..
 * ..#....OOOOO..
 * .......OOOOO..
 * ..#....OOOOO..
 * .......OOOOO..
 * .......OOOOO..
 * ..............
 * You could even make a thin rectangle with an area of only 6 between
 * 7,3 and 2,3:
 *
 * ..............
 * .......#...#..
 * ..............
 * ..OOOOOO......
 * ..............
 * ..#......#....
 * ..............
 * .........#.#..
 * ..............
 *
 * Ultimately, the largest rectangle you can make in this example has area 50.
 * One way to do this is between 2,5 and 11,1:
 *
 * ..............
 * ..OOOOOOOOOO..
 * ..OOOOOOOOOO..
 * ..OOOOOOOOOO..
 * ..OOOOOOOOOO..
 * ..OOOOOOOOOO..
 * ..............
 * .........#.#..
 * ..............
 *
 * Using two red tiles as opposite corners, what is the largest area of any
 * rectangle you can make?
 */

import { Location } from "../../lib/location.ts";
import { ObjectSet } from "../../lib/object_set.ts";
import { lines } from "../../lib/parsing.ts";
import { Rectangle } from "../../lib/Rectangle.ts";

function parseRedTiles(s: string): Location[] {
  return lines(s)
    .map((line) => line.split(",").map((sNum) => Number.parseInt(sNum)))
    .map(([x, y]) => new Location(x, y));
}

function determineArea(a: Location, b: Location): number {
  const width = Math.abs(a.x - b.x) + 1;
  const height = Math.abs(a.y - b.y) + 1;
  return width * height;
}

export function part_1(input: string): string {
  const redTileLocations: Location[] = parseRedTiles(input);

  let largest = 0;
  for (let i = 0; i < redTileLocations.length; i++) {
    const first = redTileLocations[i];
    for (let j = i; j < redTileLocations.length; j++) {
      const second = redTileLocations[j];
      const area = determineArea(first, second);
      if (area > largest) largest = area;
    }
  }

  return `${largest}`;
}

function buildPotentialRectangles(redTileLocations: Location[]): Rectangle[] {
  const potentialRectangles: Rectangle[] = [];
  for (let i = 0; i < redTileLocations.length; i++) {
    const first = redTileLocations[i];
    for (let j = i + 1; j < redTileLocations.length; j++) {
      const second = redTileLocations[j];
      potentialRectangles.push(new Rectangle(first, second));
    }
  }
  return potentialRectangles;
}

function buildPolygonEdge(redTileLocations: Location[]): ObjectSet<Location> {
  const polygonEdge: ObjectSet<Location> = new ObjectSet<Location>();

  for (let i = 0; i < redTileLocations.length; i++) {
    if (i + 1 !== redTileLocations.length) {
      connect(redTileLocations[i], redTileLocations[i + 1], polygonEdge);
    } else {
      connect(redTileLocations[i], redTileLocations[0], polygonEdge);
    }
  }
  return polygonEdge;
}

function connect(
  locA: Location,
  locB: Location,
  edge: ObjectSet<Location>,
): void {
  // either  or locA.y===locB.y (horizontal)
  // walk from locA toward locB adding to edge
  if (locA.x === locB.x) {
    // locA.x===locB.x (vertical)
    if (locA.y < locB.y) {
      // walk increasing Y
      for (let y = locA.y; y != locB.y; y++) edge.set(new Location(locA.x, y));
    } else {
      // walk decreasing Y
      for (let y = locA.y; y != locB.y; y--) edge.set(new Location(locA.x, y));
    }
  } else {
    // locA.y===locB.y (horizontal)
    if (locA.x < locB.x) {
      // walk increasing X
      for (let x = locA.x; x != locB.x; x++) edge.set(new Location(x, locA.y));
    } else {
      // walk decreasing X
      for (let x = locA.x; x != locB.x; x--) edge.set(new Location(x, locA.y));
    }
  }
}

function valid(rect: Rectangle, edge: ObjectSet<Location>) {
  // if any point on the edge lies fully inside rect (not on its edge)
  // then the rectangle is invalid
  for (const loc of edge) {
    if (rect.containsFully(loc)) {
      return false;
    }
  }
  return true;
}

/**
 * --- Part Two ---
 *
 * The Elves just remembered: they can only switch out tiles that are red or
 * green. So, your rectangle can only include red or green tiles.
 *
 * In your list, every red tile is connected to the red tile before and after
 * it by a straight line of green tiles. The list wraps, so the first red tile
 * is also connected to the last red tile. Tiles that are adjacent in your list
 * will always be on either the same row or the same column.
 *
 * Using the same example as before, the tiles marked X would be green:
 *
 * ..............
 * .......#XXX#..
 * .......X...X..
 * ..#XXXX#...X..
 * ..X........X..
 * ..#XXXXXX#.X..
 * .........X.X..
 * .........#X#..
 * ..............
 *
 * In addition, all of the tiles inside this loop of red and green tiles are
 * also green. So, in this example, these are the green tiles:
 *
 * ..............
 * .......#XXX#..
 * .......XXXXX..
 * ..#XXXX#XXXX..
 * ..XXXXXXXXXX..
 * ..#XXXXXX#XX..
 * .........XXX..
 * .........#X#..
 * ..............
 *
 * The remaining tiles are never red nor green.
 *
 * The rectangle you choose still must have red tiles in opposite corners, but
 * any other tiles it includes must now be red or green. This significantly
 * limits your options.
 *
 * For example, you could make a rectangle out of red and green tiles with an
 * area of 15 between 7,3 and 11,1:
 *
 * ..............
 * .......OOOOO..
 * .......OOOOO..
 * ..#XXXXOOOOO..
 * ..XXXXXXXXXX..
 * ..#XXXXXX#XX..
 * .........XXX..
 * .........#X#..
 * ..............
 *
 * Or, you could make a thin rectangle with an area of 3 between 9,7 and 9,5:
 *
 * ..............
 * .......#XXX#..
 * .......XXXXX..
 * ..#XXXX#XXXX..
 * ..XXXXXXXXXX..
 * ..#XXXXXXOXX..
 * .........OXX..
 * .........OX#..
 * ..............
 *
 * The largest rectangle you can make in this example using only red and green
 * tiles has area 24. One way to do this is between 9,5 and 2,3:
 *
 * ..............
 * .......#XXX#..
 * .......XXXXX..
 * ..OOOOOOOOXX..
 * ..OOOOOOOOXX..
 * ..OOOOOOOOXX..
 * .........XXX..
 * .........#X#..
 * ..............
 *
 * Using two red tiles as opposite corners, what is the largest area of any
 * rectangle you can make using only red and green tiles?
 */

export function part_2(input: string): string {
  const redTileLocations = parseRedTiles(input);
  const potentialRectangles = buildPotentialRectangles(redTileLocations);
  potentialRectangles.sort((a, b) => a.area - b.area).reverse();

  // In your list, every red tile is connected to the red tile before and
  // after it by a straight line of green tiles. The list wraps, so the first
  // red tile is also connected to the last red tile. Tiles that are adjacent
  // in your list will always be on either the same row or the same column.
  //
  // All of the tiles inside this loop of red and green tiles are also green
  const edge = buildPolygonEdge(redTileLocations);

  for (const potentialRectangle of potentialRectangles) {
    if (valid(potentialRectangle, edge)) {
      return potentialRectangle.area.toString();
    }
  }

  return `NOPE`;

  // 1m10s --> 1476550548
}
