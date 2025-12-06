import { assertEquals } from "@std/assert";

import { heredoc } from "./heredoc.ts";

Deno.test("heredoc strips the leading/trailing and common space prefix", () => {
  assertEquals(
    heredoc(`
      line 1
        line 2
    `),
    "line 1\n  line 2",
  );
});
