import { Button } from "./button.ts";

type Presses = Button[];
type ParityPattern = string;

export class BinaryParitySolver {
  size: number;
  buttons: Button[];
  parityMap: Map<ParityPattern, Presses[]>;

  constructor(size: number, buttons: Button[]) {
    this.size = size;
    this.buttons = buttons;
    this.parityMap = new Map<ParityPattern, Presses[]>();
    this.precomputePatternsAndCombos();
  }

  private precomputePatternsAndCombos(): void {
    // Precompute all possible indicator patterns and the combinations of button
    // presses that produce them.

    this.variations(this.buttons.length).forEach((combo) => {
      const values = new Array(this.size).fill(0);
      combo.forEach((btn) => pressButton(btn, values));
      const key = parityString(values);
      this.ensureParityMap(key).push(combo);
    });
  }

  private ensureParityMap(key: string): Presses[] {
    if (!this.parityMap.has(key)) this.parityMap.set(key, []);
    return this.parityMap.get(key)!;
  }

  private variations(n: number): Presses[] {
    const numVariations = Math.pow(2, n);
    const presses = [];
    for (let variation = 0; variation < numVariations; variation++) {
      presses.push(this.buttonsForVariation(variation));
    }
    return presses;
  }

  private buttonsForVariation(variation: number): Presses {
    const presses: Presses = [];
    this.buttons.forEach((btn, btnIdx) => {
      if ((Math.pow(2, btnIdx) & variation) !== 0) {
        presses.push(btn);
      }
    });
    return presses;
  }
}

export function parityValues(values: number[]): number[] {
  return values.map((v) => v % 2);
}

export function parityString(values: number[]): string {
  return parityValues(values).map((v) => (v === 0 ? "." : "#")).join("");
}

function pressButton(btn: Button, values: number[]) {
  btn.schema.forEach((connection) => values[connection]++);
}
