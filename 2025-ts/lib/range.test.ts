import { expect } from "@std/expect";
import { describe, it } from "@std/testing/bdd";

import { Range } from "./range.ts";

describe("Range", () => {
  describe("constructor", () => {
    const r1 = new Range(1, 20);
    const r2 = new Range(20, 1);
    it("accepts two values", () => {
      expect(r1.lo).toEqual(1);
      expect(r1.hi).toEqual(20);
      expect(r2).toEqual(r1);
    });
  });

  describe("#cover", () => {
    const r1 = new Range(1, 20);
    it("returns false with an out of range value", () => {
      expect(r1.cover(0.9)).toBe(false);
      expect(r1.cover(20.01)).toBe(false);
    });

    it("returns true with an in range value", () => {
      expect(r1.cover(1)).toBe(true);
      expect(r1.cover(3)).toBe(true);
      expect(r1.cover(20)).toBe(true);
    });
  });

  describe("#size", () => {
    const r1 = new Range(1, 20);
    const r2 = new Range(5, 5);
    it("returns the size of the range", () => {
      expect(r1.size()).toEqual(20);
      expect(r2.size()).toEqual(1);
    });
  });

  describe(".collapse", () => {
    const r1 = new Range(1, 20);
    const r2 = new Range(21, 30);
    const r3 = new Range(16, 18);
    const r4 = new Range(19, 30);

    it("returns the two ranges if it cannot collapse them", () => {
      expect(Range.collapse(r1, r2)).toEqual([r1, r2]);
      expect(Range.collapse(r2, r3)).toEqual([r3, r2]);
      // note ^ it flips the results order
      // because they weren't in the expected order
    });

    it("returns the combined range if it can collapse them", () => {
      expect(Range.collapse(r1, r3)).toEqual([r1]);
      expect(Range.collapse(r1, r4)).toEqual([new Range(1, 30)]);
    });
  });
});
