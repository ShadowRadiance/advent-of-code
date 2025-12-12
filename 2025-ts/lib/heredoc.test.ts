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

Deno.test("Complex test", () => {
  assertEquals(
    heredoc(`
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
    `),
    "0:" + "\n" +
      "###" + "\n" +
      "##." + "\n" +
      "##." + "\n" +
      "" + "\n" +
      "1:" + "\n" +
      "###" + "\n" +
      "##." + "\n" +
      ".##" + "\n" +
      "" + "\n" +
      "2:" + "\n" +
      ".##" + "\n" +
      "###" + "\n" +
      "##." + "\n" +
      "" + "\n" +
      "3:" + "\n" +
      "##." + "\n" +
      "###" + "\n" +
      "##." + "\n" +
      "" + "\n" +
      "4:" + "\n" +
      "###" + "\n" +
      "#.." + "\n" +
      "###" + "\n" +
      "" + "\n" +
      "5:" + "\n" +
      "###" + "\n" +
      ".#." + "\n" +
      "###" + "\n" +
      "" + "\n" +
      "4x4: 0 0 0 0 2 0" + "\n" +
      "12x5: 1 0 1 0 2 2" + "\n" +
      "12x5: 1 0 1 0 3 2",
  );
});
