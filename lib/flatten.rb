# frozen_string_literal: true

class Flatten
  @return_array = []
  def self.to_flat(array)
    array.each do |element|
      if element.is_a? Array
        to_flat(element)
      else
        @return_array << element
      end
    end
    @return_array
  end
end
