export class Vector {
  readonly x: number;
  readonly y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }

  add(other: Vector): Vector {
    return this.addXY(other.x, other.y);
  }

  addXY(x: number, y: number): Vector {
    return new Vector(this.x + x, this.y + y);
  }

  toString(): string {
    return `V(${this.x},${this.y})`;
  }
}

export class Vector3D {
  readonly x: number;
  readonly y: number;
  readonly z: number;

  constructor(x: number, y: number, z: number) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  get magnitude(): number {
    return Math.sqrt(
      (this.x * this.x) + (this.y * this.y) + (this.z * this.z),
    );
  }

  distance(other: Vector3D) {
    return (other.add(this.negative())).magnitude;
  }

  add(other: Vector3D): Vector3D {
    return this.addXYZ(other.x, other.y, other.z);
  }

  addXYZ(x: number, y: number, z: number): Vector3D {
    return new Vector3D(this.x + x, this.y + y, this.z + z);
  }

  negative(): Vector3D {
    return new Vector3D(-this.x, -this.y, -this.z);
  }

  toString(): string {
    return `V(${this.x},${this.y},${this.z})`;
  }
}
