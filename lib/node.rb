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
