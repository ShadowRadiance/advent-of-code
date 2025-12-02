import { assertEquals } from "@std/assert";
import { heredoc } from "../../lib/heredoc.ts";

import { part_1 } from "./index.ts";

const data = heredoc(`
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
`);

Deno.test("part_1 returns the correct answer for the example", () => {
  assertEquals(part_1(data), "3");
});
