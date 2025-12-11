export const reduce_add = (acc: number, next: number) => (acc + next);
export const reduce_mul = (acc: number, next: number) => (acc * next);
export const reduce_max = (
  acc: number,
  next: number,
) => (next > acc ? next : acc);
export const reduce_min = (
  acc: number,
  next: number,
) => (next < acc ? next : acc);
