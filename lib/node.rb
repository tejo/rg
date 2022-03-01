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

class Parser
  LPAREN = '('
  RPAREN = ')'

  def initialize(tokens)
    @tokens = tokens
    @deep_level = 0
    @ast = {}
    check_matching_parens
  end

  def check_matching_parens
    raise ArgumentError, 'no matching parens' unless
    @tokens.select { |t| t.value == LPAREN }.count == @tokens.select { |t| t.value == RPAREN }.count
  end

  def parse
    @expressions = []
    @tokens.each_index do |index|
      @expressions << next_token(index)
    end

    @expressions.compact!

    deepest_level = @expressions.group_by { |x| x[:deep_level] }.keys.max

    build_ast(deepest_level)
  end

  def next_token(index)
    token = @tokens[index]
    case token.type
    when :int
      {
        deep_level: @deep_level,
        type: :int,
        value: token.value
      }
    when :op
      @deep_level += 1
      {
        deep_level: @deep_level,
        type: :op,
        operator: token.value,
        left: next_token(index - 1),
        right: next_token(index + 1)
      }
    else
      # noop
    end
  end

  def build_ast(level)
    if @exp.nil?
      @exp = find_op(level)
    else
      @exp[:left] = find_op(level)
    end

    return @exp if @exp[:left].is_a?(Hash) && @exp[:left].is_a?(Hash)

    build_ast(level - 1)
  end

  def find_op(level)
    @expressions.select { |e| e[:deep_level].to_i == level && e[:type] == :op }.first
  end

  def find_value(level)
    @expressions.select { |e| e[:deep_level].to_i == level && e[:type] == :int }.first
  end
end
