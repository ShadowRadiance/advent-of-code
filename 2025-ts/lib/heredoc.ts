import { reduce_min } from "./reduce_helpers.ts";

const ALL_SPACES: RegExp = /^\s*$/;
const PREFIX_SPACES = /^ +/;
const PREFIX_TABS = /^\t+/;

// strips a leading (nothing-but-spaces) line
// strips a trailing (nothing-but-spaces) line
// if the first char of line 1 is a <SPC>
//   removes the common space-prefix from each line
// else if the first char of line 1 is a <TAB>
//   removes the common tab-prefix from each line
// else
//   doesn't remove anything
export function heredoc(s: string): string {
  const lines = s.split("\n");
  if (ALL_SPACES.test(lines[0])) lines.shift();
  if (ALL_SPACES.test(lines[lines.length - 1])) lines.pop();

  const firstChar = lines[0][0];
  if (firstChar !== " " && firstChar !== "\t") return lines.join("\n");

  const prefix = longestCommonPrefix(lines, firstChar);
  return lines.map((line: string) => stripPrefix(prefix, line)).join("\n");
}

function longestCommonPrefix(lines: string[], prefixChar: string): string {
  const matcher = prefixChar === " " ? PREFIX_SPACES : PREFIX_TABS;

  return " ".repeat(
    lines.map((line) => {
      if (ALL_SPACES.test(line)) return Infinity;
      const matches = line.match(matcher);
      return matches?.at(0)?.length ?? 0;
    }).reduce(reduce_min),
  );
}

function stripPrefix(prefix: string, s: string): string {
  return s.substring(prefix.length);
}
