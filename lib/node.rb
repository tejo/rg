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
  attr_reader :tokens

  RULES = {
    /\d+/ => :int,
    /[+]/ => :sum,
    /-/ => :sub,
    /x/ => :mul,
    /÷/ => :div,
    /\(/ => :lparen,
    /\)/ => :rparen
  }.freeze

  def initialize(input)
    @tokens = []
    @current_token_index = 0
    parse(input)
    @tokens << Token.new(:eof, '')
  end

  def parse(expression)
    @input = StringScanner.new(expression)

    until @input.eos?
      @input.skip(/\s+/)
      find_tokens
    end
  end

  def get_next_token
    if @return_previous_token
      @return_previous_token = false
      return @previous_token
    end

    token = @tokens[@current_token_index]
    @current_token_index += 1

    @previous_token = token
    token
  end

  def revert
    @return_previous_token = true
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
  attr_reader :original_expression
  def parse(input)
    @original_expression = input
    @lexer = Tokenizer.new(input)

    expression_value = expression

    token = @lexer.get_next_token
    if token.type == :eof
      expression_value
    else
      raise 'End expected'
    end
  end

  def to_s
    @original_expression
  end

  protected

  def expression
    component1 = factor

    additive_operators = %i[sum sub]

    token = @lexer.get_next_token
    while additive_operators.include?(token.type)
      component2 = factor

      if token.type == :sum
        component1 += component2
      else
        component1 -= component2
      end

      token = @lexer.get_next_token
    end
    @lexer.revert

    component1
  end

  def factor
    factor1 = number

    multiplicative_operators = %i[mul div]

    token = @lexer.get_next_token
    while multiplicative_operators.include?(token.type)
      factor2 = number

      if token.type == :mul
        factor1 *= factor2
      else
        factor1 /= factor2
      end

      token = @lexer.get_next_token
    end
    @lexer.revert

    factor1
  end

  def number
    token = @lexer.get_next_token

    case token.type
    when :lparen
      value = expression

      expected_rparen = @lexer.get_next_token
      raise 'Unbalanced parenthesis' unless expected_rparen.type == :rparen
    when :int
      value = token.value
    else
      raise 'Not a number'
    end

    value
  end
end
