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
  const lines = input.split("\n");

  const instructions = lines.map((line) => {
    const direction = line.charAt(0);
    const amount = Number.parseInt(line.substring(1));
    return { direction: direction, amount: amount };
  });

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
