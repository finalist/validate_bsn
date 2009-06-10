module ValidateBSN

  def self.valid?(value)
    return false if value.to_i <= 99_999_999 or value.to_i >= 999_999_999
    j, factors = -1, [9,8,7,6,5,4,3,2,-1]
    value.to_s.split(//).inject(0) do |sum, i|
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
