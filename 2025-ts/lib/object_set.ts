type IdentifierFunction<T> = (o: T) => string;

/**
 * Implements a Set for standard objects allowing objects to be "value-equal".
 * The value is determined either by a passed-in identifier function
 *  (values should generate the same id-string) or by a JSON-stringification
 *  by default.
 */
export class ObjectSet<T extends object> {
  items = new Map<string, T>();
  count = 0;

  identify: IdentifierFunction<T>;

  constructor(identifier: IdentifierFunction<T> = this._id) {
    this.identify = identifier;
  }

  _id(o: T): string {
    return JSON.stringify(o, Object.keys(o).sort());
  }

  has(o: T): boolean {
    return this.items.has(this.identify(o));
  }

  set(o: T): void {
    this.items.set(this.identify(o), o);
  }

  unset(o: T) {
    this.items.delete(this.identify(o));
  }

  clear(): void {
    this.items.clear();
  }

  get size(): number {
    return this.items.size;
  }

  // iterator
  values(): MapIterator<T> {
    return this.items.values();
  }

  // called by for...of
  [Symbol.iterator]() {
    return this.values();
  }
}
