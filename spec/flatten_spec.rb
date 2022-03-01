# frozen_string_literal: true

require 'flatten'

RSpec.describe Flatten do
  context '.to_flat'
  it 'flatten an array' do
    expect(Flatten.to_flat([1, [2, [3]], 4])).to eq([1, 2, 3, 4])
  end
end
