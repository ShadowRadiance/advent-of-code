import { assertEquals } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { part_1, part_2 } from "./index.ts";

const data = heredoc(`
  0:
  ###
  ##.
  ##.

  1:
  ###
  ##.
  .##

  2:
  .##
  ###
  ##.

  3:
  ##.
  ###
  ##.

  4:
  ###
  #..
  ###

  5:
  ###
  .#.
  ###

  4x4: 0 0 0 0 2 0
  12x5: 1 0 1 0 2 2
  12x5: 1 0 1 0 3 2
`);

const testing = true;
Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data, testing), "NOT MAKING THE TEST PASS");
});

Deno.test("part_2 returns the correct answer for the example", () => {
  assertEquals(part_2(data), "THERE IS NO PART TWO");
});
