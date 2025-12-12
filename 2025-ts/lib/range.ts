export class Range {
  lo: number;
  hi: number;

  constructor(lo: number, hi: number) {
    if (lo > hi) [lo, hi] = [hi, lo];

    this.lo = lo;
    this.hi = hi;
  }

  cover(n: number) {
    return this.lo <= n && this.hi >= n;
  }

  size() {
    return this.hi - this.lo + 1;
  }

  static collapse(r1: Range, r2: Range): Range[] {
    // r1.lo is expected to be <= r2.lo
    if (r1.lo > r2.lo) return Range.collapse(r2, r1);

    if (r1.hi >= r2.lo) {
      return [new Range(r1.lo, Math.max(r1.hi, r2.hi))];
    } else {
      return [r1, r2];
    }
  }
}
