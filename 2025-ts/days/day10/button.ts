import { chars } from "../../lib/parsing.ts";

export class Button {
  name: string;
  schema: number[];
  binary: number;
  size: number;

  constructor(name: string, schema: number[], size: number) {
    this.name = name;
    this.schema = schema;
    this.size = size;
    this.binary = this.getBinary();
  }

  static parseButton(name: string, definition: string, size: number) {
    return new Button(
      name,
      definition
        .split(",")
        .map((s) => parseInt(s)),
      size,
    );
  }

  getBinary(): number {
    const base = chars("0".repeat(this.size));
    for (const connection of this.schema) base[connection] = "1";
    return parseInt(base.join(""), 2);
  }
}
