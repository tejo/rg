# frozen_string_literal: true

require 'node'

RSpec.describe Node do
  context 'change calculator' do
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

RSpec.describe Tokenizer do
  let(:tokenizer) { Tokenizer.new }
  let(:expected_token) do
    [[:lparen, '('], [:lparen, '('], [:int, 7], [:op, '+'], [:lparen, '('], [:lparen, '('], [:int, 3], [:op, '-'],
     [:int, 2], [:rparen, ')'], [:op, 'x'], [:int, 5], [:rparen, ')'], [:rparen, ')'], [:op, '÷'], [:int, 6], [:rparen, ')']]
  end
  it 'finds the right tokens' do
    expect(tokenizer.parse('((7 + ((3 - 2) x 5)) ÷ 6)').map { |t| [t.type, t.value] }).to eq(expected_token)
  end
end

RSpec.describe Parser do
  let(:parser) { Parser.new(tokens) }
  let(:tokens) { Tokenizer.new.parse(expression) }

  context 'no matching parens' do
    let(:expression) { '((7 + ((3 - 2) x 5)) ÷ 6'  }
    it 'raise an erorr' do
      expect { parser }.to raise_error(ArgumentError)
    end
  end

  context '#parse' do
    def tokens(expression)
      Tokenizer.new.parse(expression)
    end
    it 'correctly parses 1 + 2' do
      expect(Parser.new(tokens('1 + 2')).parse).to eq({ deep_level: 1,
                                                        operator: '+',
                                                        type: :op,
                                                        left: {
                                                          deep_level: 1,
                                                          type: :int, value: 1
                                                        },
                                                        right: {
                                                          deep_level: 1,
                                                          type: :int,
                                                          value: 2
                                                        } })
    end

    it 'correctly parses (1 + 2) x 3' do
      expect(Parser.new(tokens('(1 + 2) x 3')).parse).to eq({
                                                              deep_level: 2,
                                                              type: :op,
                                                              operator: 'x',
                                                              left:
                                                            {
                                                              deep_level: 1,
                                                              type: :op,
                                                              operator: '+',
                                                              left: {
                                                                deep_level: 1,
                                                                type: :int,
                                                                value: 1
                                                              },
                                                              right: {
                                                                deep_level: 1,
                                                                type: :int,
                                                                value: 2
                                                              }
                                                            },
                                                              right: {
                                                                deep_level: 2,
                                                                type: :int,
                                                                value: 3
                                                              }
                                                            })
    end
  end
end
