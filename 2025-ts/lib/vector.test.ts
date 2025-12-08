import { expect } from "@std/expect";
import { describe, it } from "@std/testing/bdd";

import { Vector, Vector3D } from "./vector.ts";

describe("Vector", () => {
  const v = new Vector(3, 4);

  describe("constructor", () => {
    it("initializes the correct attributes", () => {
      expect(v.x).toEqual(3);
      expect(v.y).toEqual(4);
    });
  });
});

describe("Vector3D", () => {
  const v3d = new Vector3D(3, 4, 5);

  describe("constructor", () => {
    it("initializes the correct attributes", () => {
      expect(v3d.x).toEqual(3);
      expect(v3d.y).toEqual(4);
      expect(v3d.z).toEqual(5);
    });
  });

  describe("magnitude", () => {
    it("evaluates the magnitude of the vector", () => {
      expect(v3d.magnitude).toBeCloseTo(Math.sqrt(3 * 3 + 4 * 4 + 5 * 5));
    });
  });

  describe("distance", () => {
    it("evaluates the distance between two vectors", () => {
      const v3d2 = new Vector3D(0, 0, 0);
      expect(v3d.distance(v3d2)).toBeCloseTo(
        Math.sqrt(3 * 3 + 4 * 4 + 5 * 5),
      );
      const v3d3 = new Vector3D(-6, -8, -10);
      expect(v3d.distance(v3d3)).toBeCloseTo(
        Math.sqrt(9 * 9 + 12 * 12 + 15 * 15),
      );
    });
  });
});
