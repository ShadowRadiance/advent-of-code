import { assertEquals } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { part_1, part_2 } from "./index.ts";

const data = heredoc(`
  123 328  51 64
   45 64  387 23
    6 98  215 314
  *   +   *   +
`);

Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data), "4277556");
});

Deno.test("part_2 returns the correct answer for the example", () => {
  assertEquals(part_2(data), "3263827");
});
