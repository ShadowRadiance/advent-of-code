import { assertEquals } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { part_1, part_2 } from "./index.ts";

const data = heredoc(`
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
`);

Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data), "5");
});

Deno.test("part_2 returns the correct answer for the example", () => {
  assertEquals(part_2(data), "PENDING");
});
