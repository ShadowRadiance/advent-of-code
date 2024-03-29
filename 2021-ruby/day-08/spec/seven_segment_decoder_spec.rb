require './seven_segment_decoder'
require './seven_segment_parser'

RSpec.describe "Seven Segment Decoder" do
  subject { SevenSegmentDecoder.new(parser.parse(data)) }
  let(:parser) { SevenSegmentParser.new }

  let(:data) {
    <<~DATA
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    DATA
  }

  describe "#decode" do
    it "decodes the 1s 4s 7s and 8s" do
      subject.decode
  
      expect([1,4,7,8].map { |i| subject.count_all(i) }.sum).to eq(26)
    end

    it "decodes all the digits" do
      subject.decode
      expect(subject.decoded_integers).to eq([
        8394,
        9781,
        1197,
        9361,
        4873,
        8418,
        4548,
        1625,
        8717,
        4315,
      ])
    end
  end

end