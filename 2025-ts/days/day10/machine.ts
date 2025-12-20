import { Button } from "./button.ts";

export class Machine {
  static LINE_REGEXP = /\[(.*)\] \((.*)\) \{(.*)\}/;

  lightPattern: string;
  buttons: Button[];
  joltageRequirements: number[];
  originalLine: string;

  constructor(line: string) {
    this.originalLine = line;

    const results = Machine.LINE_REGEXP.exec(line)!;
    this.lightPattern = results[1];
    this.buttons = results[2]
      .split(") (")
      .map((s, ix) => Button.parseButton(`B${ix}`, s, this.size));
    this.joltageRequirements = results[3]
      .split(",")
      .map((s) => parseInt(s));
  }

  get size() {
    return this.lightPattern.length;
  }

  get lightPatternBinary(): number {
    return parseInt(
      this.lightPattern.replaceAll(".", "0").replaceAll("#", "1"),
      2,
    );
  }
}
