# frozen_string_literal: true

require 'node'

RSpec.describe Node do
  context 'change calculator' do
    let(:tree) do
      Node.new(
        '÷',
        nil,
        Node.new(
          '+',
          nil,
          Node.new('', 7, nil, nil),
          Node.new(
            'x',
            nil,
            Node.new('-', nil,
                     Node.new('', 3, nil, nil),
                     Node.new('', 2, nil, nil)),
            Node.new('', 5, nil, nil)
          )
        ),
        Node.new('', 6, nil, nil)
      )
    end

    it 'prints the right expression' do
      expect(tree.to_s).to eq('((7 + ((3 - 2) x 5)) ÷ 6)')
    end

    it 'calcualte the exact result' do
      expect(tree.result).to eq(2)
    end
  end
end
