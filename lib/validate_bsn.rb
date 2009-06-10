module ValidateBSN

  def self.valid?(value)
    v = value.to_i
    return false if v <= 99_999_999 or v >= 999_999_999
    j, sum, factors = -1, 0, [9,8,7,6,5,4,3,2,-1]
    value.to_s.each do |i|
      sum += i.to_i * factors[j += 1]
    end % 11 == 0
  end

  module ActiveRecordClassMethods

    def validates_bsn_format(*args)
      validates_each *args do |record, attr, value|
        record.errors.add(attr, :invalid_bsn) unless ValidateBSN.valid?(value)
      end
    end

  end

end
