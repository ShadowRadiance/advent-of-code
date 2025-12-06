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

  const reducer = (
    smallest: number,
    line: string,
    _idx: number,
    _arr: string[],
  ) => {
    const matches = line.match(matcher);
    if (matches === null) return smallest;
    const len = matches[0].length;
    return len >= smallest ? smallest : len;
  };
  const smallest = lines.reduce(reducer, Infinity);

  return " ".repeat(smallest);
}

function stripPrefix(prefix: string, s: string): string {
  return s.substring(prefix.length);
}
