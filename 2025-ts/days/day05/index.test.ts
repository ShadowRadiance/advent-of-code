import { assertEquals } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { part_1, part_2 } from "./index.ts";

const data = heredoc(`
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
`);

Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data), "3");
});

Deno.test("part_2 returns the correct answer for the example", () => {
  assertEquals(part_2(data), "PENDING");
});
