// Day 1: Secret Entrance

// You arrive at the secret entrance to the North Pole base ready to start
// decorating. Unfortunately, the password seems to have been changed, so you
// can't get in. A document taped to the wall helpfully explains:
//
// "Due to new security protocols, the password is locked in the safe below.
// Please see the attached document for the new combination."
//
// The safe has a dial with only an arrow on it; around the dial are the
// numbers 0 through 99 in order. As you turn the dial, it makes a small click
// noise as it reaches each number.
//
// The attached document (your puzzle input) contains a sequence of rotations,
// one per line, which tell you how to open the safe. A rotation starts with
// an L or R which indicates whether the rotation should be to the left
// (toward lower numbers) or to the right (toward higher numbers). Then, the
// rotation has a distance value which indicates how many clicks the dial
// should be rotated in that direction.
//
// The dial starts by pointing at 50.
//
// You could follow the instructions, but your recent required official North
// Pole secret entrance security training seminar taught you that the safe is
// actually a decoy. The actual password is the number of times the dial is
// left pointing at 0 after any rotation in the sequence.
//
// Analyze the rotations in your attached document. What's the actual password
// to open the door?

export function part_1(input: string): string {
  const instructions = parseInstructions(input);

  let current = 50;
  let zeros = 0;
  instructions.forEach(({ direction, amount }) => {
    if (direction === "L") amount = -amount;
    current += amount;
    while (current < 0) current = current + 100;
    while (current > 99) current = current - 100;
    if (current === 0) zeros += 1;
  });

  return `${zeros}`;
}

// --- Part Two ---
//
// You're sure that's the right password, but the door won't open. You knock,
// but nobody answers. You build a snowman while you think.
//
// As you're rolling the snowballs for your snowman, you find another security
// document that must have fallen into the snow:
//
// "Due to newer security protocols, please use password method 0x434C49434B
// until further notice."
//
// You remember from the training seminar that "method 0x434C49434B" means
// you're actually supposed to count the number of times any click causes the
// dial to point at 0, regardless of whether it happens during a rotation or
// at the end of one.
//
// Be careful: if the dial were pointing at 50, a single rotation like R1000
// would cause the dial to point at 0 ten times before returning back to 50!
//
// Using password method 0x434C49434B, what is the password to open the door?

function parseInstructions(input: string) {
  const lines = input.split("\n");

  return lines.map((line) => {
    const direction = line.charAt(0);
    const amount = Number.parseInt(line.substring(1));
    return { direction: direction, amount: amount };
  });
}

function leftClick(current: number) {
  if (current === 0) return 99;
  return current - 1;
}
function rightClick(current: number) {
  if (current === 99) return 0;
  return current + 1;
}

export function part_2(input: string): string {
  const instructions = parseInstructions(input);

  let current = 50;
  let zeros = 0;
  instructions.forEach(({ direction, amount }) => {
    const click = (direction === "L") ? leftClick : rightClick;
    for (let i = 0; i < amount; i++) {
      current = click(current);
      if (current === 0) zeros++;
    }
  });

  return `${zeros}`;
}
