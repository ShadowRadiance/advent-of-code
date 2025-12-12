import { assertEquals } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { part_1, part_2 } from "./index.ts";

const data = heredoc(`
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
`);

Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data), "13");
});

Deno.test("part_2 returns the correct answer for the example", () => {
  assertEquals(part_2(data), "43");
});
