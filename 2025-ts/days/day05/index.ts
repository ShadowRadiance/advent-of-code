import { Range } from "../../lib/range.ts";

/**
 * --- Day 5: Cafeteria ---
 *
 * As the forklifts break through the wall, the Elves are delighted to
 * discover that there was a cafeteria on the other side after all.
 *
 * You can hear a commotion coming from the kitchen. "At this rate, we won't
 * have any time left to put the wreaths up in the dining hall!" Resolute in
 * your quest, you investigate.
 *
 * "If only we hadn't switched to the new inventory management system right
 * before Christmas!" another Elf exclaims. You ask what's going on.
 *
 * The Elves in the kitchen explain the situation: because of their
 * complicated new inventory management system, they can't figure out which
 * of their ingredients are fresh and which are spoiled. When you ask how
 * it works, they give you a copy of their database (your puzzle input).
 *
 * The database operates on ingredient IDs. It consists of a list of fresh
 * ingredient ID ranges, a blank line, and a list of available ingredient IDs.
 * For example:
 *
 * 3-5
 * 10-14
 * 16-20
 * 12-18
 *
 * 1
 * 5
 * 8
 * 11
 * 17
 * 32
 *
 * The fresh ID ranges are inclusive: the range 3-5 means that ingredient IDs
 * 3, 4, and 5 are all fresh. The ranges can also overlap; an ingredient ID
 * is fresh if it is in any range.
 *
 * The Elves are trying to determine which of the available ingredient IDs
 * are fresh. In this example, this is done as follows:
 *
 * Ingredient ID 1 is spoiled because it does not fall into any range.
 * Ingredient ID 5 is fresh because it falls into range 3-5.
 * Ingredient ID 8 is spoiled.
 * Ingredient ID 11 is fresh because it falls into range 10-14.
 * Ingredient ID 17 is fresh because it falls into range 16-20 as well as range 12-18.
 * Ingredient ID 32 is spoiled.
 *
 * So, in this example, 3 of the available ingredient IDs are fresh.
 *
 * Process the database file from the new inventory management system. How
 * many of the available ingredient IDs are fresh?
 */

interface Input {
  freshRanges: Range[];
  availableIngredients: number[];
}

function parseRangeLines(section: string): Range[] {
  return section.split("\n").map((line) => parseRangeLine(line));
}

function parseRangeLine(line: string): Range {
  const [lo, hi] = line.split("-");
  return new Range(Number.parseInt(lo), Number.parseInt(hi));
}

function parseIngredientLines(section: string): number[] {
  return section.split("\n").map((line) => parseIngredientLine(line));
}

function parseIngredientLine(line: string): number {
  return Number.parseInt(line);
}

function parseInput(input: string): Input {
  const [section1, section2] = input.split("\n\n");
  return {
    freshRanges: parseRangeLines(section1),
    availableIngredients: parseIngredientLines(section2),
  };
}

function ingredientIsFresh(id: number, ranges: Range[]) {
  return undefined !== ranges.find((range) => range.cover(id));
}

export function part_1(input: string): string {
  const state = parseInput(input);

  let countFresh = 0;
  state.availableIngredients.map((ingredientID) => {
    if (ingredientIsFresh(ingredientID, state.freshRanges)) {
      countFresh++;
    }
  });

  return `${countFresh}`;
}

/**
 * --- Part Two ---
 *
 * The Elves start bringing their spoiled inventory to the trash chute at the
 * back of the kitchen.
 *
 * So that they can stop bugging you when they get new inventory, the Elves
 * would like to know all of the IDs that the fresh ingredient ID ranges
 * consider to be fresh. An ingredient ID is still considered fresh if it is
 * in any range.
 *
 * Now, the second section of the database (the available ingredient IDs) is
 * irrelevant. Here are the fresh ingredient ID ranges from the above example:
 *
 * 3-5
 * 10-14
 * 16-20
 * 12-18
 *
 * The ingredient IDs that these ranges consider to be fresh are
 * 3, 4, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20. So, in this
 * example, the fresh ingredient ID ranges consider a total of 14 ingredient
 * IDs to be fresh.
 *
 * Process the database file again. How many ingredient IDs are considered to
 * be fresh according to the fresh ingredient ID ranges?
 */

export function part_2_bruteForce(input: string): string {
  const state = parseInput(input);

  const set = new Set();

  state.freshRanges.forEach((range) => {
    for (let index = range.lo; index <= range.hi; index++) {
      set.add(index.toString());
      // Set maximum size exceeded after 10s
    }
  });

  return `${set.size}`;
}

export function part_2(input: string): string {
  const state = parseInput(input);

  const ranges = collapse(state.freshRanges);
  // sum (now-distinct) range sizes
  const sum = ranges
    .map((range) => range.size())
    .reduce((acc, ct) => acc + ct);

  return `${sum}`;
}

function collapse(ranges: Range[]): Range[] {
  // sort by start (and then by end for same start)
  ranges.sort((a, b) => a.lo === b.lo ? a.hi - b.hi : a.lo - b.lo);

  // try to merge interval at each index into the interval at index -1
  // -- merge == replace at index-1, remove at index
  // if it merges, repeat without updating indices
  // if it won't merge, move on to the next index
  // break when index >= array length

  let index = 1;
  while (index < ranges.length) {
    const collapsedPair = Range.collapse(ranges[index - 1], ranges[index]);
    if (collapsedPair.length === 2) {
      index++;
    } else {
      ranges.splice(index - 1, 2, ...collapsedPair);
    }
  }

  return ranges;
}
