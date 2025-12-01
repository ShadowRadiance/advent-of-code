import { assertEquals } from "@std/assert";
import { default as theredoc } from "theredoc";

import { part_1 } from "./index.ts";

Deno.test("part_1 returns the correct answer for the example", () => {
  const data = theredoc`
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
  `;

  assertEquals(part_1(data), "3");
});
