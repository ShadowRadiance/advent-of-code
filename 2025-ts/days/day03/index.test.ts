import { assertEquals } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { part_1, part_2 } from "./index.ts";

const data = heredoc(`
  987654321111111
  811111111111119
  234234234234278
  818181911112111
`);

Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data), "357");
});

Deno.test("part_2 returns the correct answer for the example", () => {
  assertEquals(part_2(data), "PENDING");
});
