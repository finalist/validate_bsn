module ValidateBSN

  def self.valid?(value)

    int_val = value.to_i
    if int_val <= 99_999_999 or int_val >= 999_999_999
      return false
    end

    index, sum, factors = -1, 0, [9,8,7,6,5,4,3,2,-1]
    value.to_s.each_char do |char|
      sum += char.to_i * factors[index += 1]
    end

    sum % 11 == 0

  end

  module ActiveRecord

    def validates_bsn_format(*args)
      validates_each(*args) do |record, attr, value|
        record.errors.add(attr) unless ValidateBSN.valid?(value)
      end
    end

  end

end
