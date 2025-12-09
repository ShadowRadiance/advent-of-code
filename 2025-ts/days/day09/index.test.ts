import { assertEquals } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { part_1, part_2 } from "./index.ts";

const data = heredoc(`
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
`);

Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data), "50");
});

Deno.test("part_2 returns the correct answer for the example", () => {
  assertEquals(part_2(data), "24");
});
