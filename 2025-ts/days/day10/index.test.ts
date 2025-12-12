import { assertEquals, assertThrows } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { parseInput, part_1, part_2 } from "./index.ts";
import { SkippedPartError } from "../../errors/skippedPartError.ts";

const data = heredoc(`
  [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
`);

Deno.test("parseInput parses the input into the correct structure", () => {
  const expected = [
    // [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    {
      size: 4,
      desiredIndicatorLights: parseInt("0110", 2),
      buttonSchematics: [
        parseInt("0001", 2), // (3)
        parseInt("0101", 2), // (1,3)
        parseInt("0010", 2), // (2)
        parseInt("0011", 2), // (2,3)
        parseInt("1010", 2), // (0,2)
        parseInt("1100", 2), // (0,1)
      ],
      joltageRequirements: [3, 5, 4, 7],
    },
    // [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    {
      size: 5,
      desiredIndicatorLights: parseInt("00010", 2),
      buttonSchematics: [
        parseInt("10111", 2), // (0,2,3,4),
        parseInt("00110", 2), // (2,3),
        parseInt("10001", 2), // (0,4),
        parseInt("11100", 2), // (0,1,2),
        parseInt("01111", 2), // (1,2,3,4),
      ],
      joltageRequirements: [7, 5, 12, 7, 2],
    },
    // [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    {
      size: 6,
      desiredIndicatorLights: parseInt("011101", 2),
      buttonSchematics: [
        parseInt("111110", 2), // (0,1,2,3,4),
        parseInt("100110", 2), // (0,3,4),
        parseInt("111011", 2), // (0,1,2,4,5),
        parseInt("011000", 2), // (1,2),
      ],
      joltageRequirements: [10, 11, 11, 5, 10, 5],
    },
  ];

  const results = parseInput(data);

  assertEquals(results, expected);
});

Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data), "7");
});

Deno.test("part_2 returns the correct answer for the example", () => {
  // assertEquals(part_2(data), "33");
  assertThrows(() => part_2(data), SkippedPartError, "Skipped Day 10 Part 2");
});
