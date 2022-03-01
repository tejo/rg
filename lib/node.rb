# frozen_string_literal: true

class Node
  def initialize(operator, value, left, right)
    @operator = operator
    @value = value
    @left = left
    @right = right
  end

  def result
    case @operator
    when 'x'
      @left.result * @right.result
    when '÷'
      @left.result / @right.result
    when '+'
      @left.result + @right.result
    when '-'
      @left.result - @right.result
    else
      @value.to_f
    end
  end

  def to_s
    case @operator
    when 'x'
      "(#{@left} x #{@right})"
    when '÷'
      "(#{@left} ÷ #{@right})"
    when '+'
      "(#{@left} + #{@right})"
    when '-'
      "(#{@left} - #{@right})"
    else
      @value.to_s
    end
  end
end

def sum(left, right)
  Node.new('+', nil, left, right)
end

def div(left, right)
  Node.new('÷', nil, left, right)
end

def sub(left, right)
  Node.new('-', nil, left, right)
end

def mul(left, right)
  Node.new('x', nil, left, right)
end

def val(value)
  Node.new('', value, nil, nil)
end

class Tokenizer
  RULES = {
    /\d+/ => :int,
    /[+\-÷x]/ => :op,
    /\(/ => :lparen,
    /\)/ => :rparen
  }

  def initialize
    @tokens = []
  end

  def parse(expression)
    @input = StringScanner.new(expression)

    until @input.eos?
      @input.skip(/\s+/)
      find_tokens
    end

    @tokens
  end

  private

  def find_tokens
    RULES.each do |regex, type|
      token = @input.scan(regex)
      @tokens << Token.new(type, token) if token
    end
  end
end

class Token
  attr_reader :type

  def initialize(type, value)
    @type = type
    @value = value
  end

  def value
    @type == :int ? @value.to_i : @value
  end
end
