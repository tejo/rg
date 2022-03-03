# frozen_string_literal: true

require 'node'

RSpec.describe Node do
  context 'original expression tree' do
    let(:tree) do
      div(sum(val(7), mul(sub(val(3), val(2)), val(5))), val(6))
    end

    it 'prints the right expression' do
      expect(tree.to_s).to eq('((7 + ((3 - 2) x 5)) ÷ 6)')
    end

    it 'calculate the exact result' do
      expect(tree.result).to eq(2)
    end
  end
end

# EBN rules parser https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
# based on https://lukaszwrobel.pl/blog/math-parser-part-1-introduction/
RSpec.describe Parser do
  context 'improved expression tree' do
    let(:parser) do
     Parser.new
    end

    it 'prints the right expression' do
      parser.parse('((7 + ((3 - 2) x 5)) ÷ 6)')
      expect(parser.to_s).to eq('((7 + ((3 - 2) x 5)) ÷ 6)')
    end

    it 'calculate the exact result' do
      expect(parser.parse('((7 + ((3 - 2) x 5)) ÷ 6)')).to eq(2)
    end

    it 'respects operator priority' do
      expect(parser.parse('3 x 10 ÷ 5')).to eq(6)
    end
  end
end

RSpec.describe Tokenizer do
  let(:expected_token) do
    [[:lparen, '('], [:lparen, '('], [:int, 7], [:sum, '+'], [:lparen, '('], [:lparen, '('], [:int, 3], [:sub, '-'],
     [:int, 2], [:rparen, ')'], [:mul, 'x'], [:int, 5], [:rparen, ')'], [:rparen, ')'], [:div, '÷'], [:int, 6], [:rparen, ')'], [:eof, '']]
  end
  it 'finds the right tokens' do
    tokens = Tokenizer.new('((7 + ((3 - 2) x 5)) ÷ 6)').tokens
    expect(tokens.map { |t| [t.type, t.value] }).to eq(expected_token)
  end
end

RSpec.describe Parser do
  let(:parser) { Parser.new(tokens) }
  let(:tokens) { Tokenizer.new.parse(expression) }

  context 'no matching parens' do
    let(:expression) { '((7 + ((3 - 2) x 5)) ÷ 6' }
    it 'raise an erorr' do
      expect { parser }.to raise_error(ArgumentError)
    end
  end

  context '#parse' do
    let(:parser) { Parser.new }
    it 'correctly parses 1 + 2' do
      expect(parser.parse('1 + 2')).to eq(3)
    end

    it 'correctly parses ((7 + ((3 - 2) x 5)) ÷ 6)' do
      expect(parser.parse('((7 + ((3 - 2) x 5)) ÷ 6)')).to eq(2)
    end
  end
end