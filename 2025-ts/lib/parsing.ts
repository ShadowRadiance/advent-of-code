export function sections(input: string): string[] {
  return input.split("\n\n");
}

export function lines(input: string): string[] {
  return input.split("\n");
}

export function chars(input: string): string[] {
  return input.split("");
}
