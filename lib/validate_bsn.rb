module ValidateBSN

  def self.valid?(value)

    int_value = value.to_i
    if int_value <= 99_999_999 or int_value >= 999_999_999
      return false
    end

    factor_index, sum, factors = -1, 0, [9,8,7,6,5,4,3,2,-1]
    value.to_s.each do |char|
      sum += char.to_i * factors[factor_index += 1]
    end % 11 == 0

  end

  module ActiveRecord

    def validates_bsn_format(*args)
      validates_each(*args) do |record, attr, value|
        record.errors.add(attr) unless ValidateBSN.valid?(value)
      end
    end

  end

end
