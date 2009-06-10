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
      @__validates_bsn_format = args
      validates_each(*args) do |record, attr, value|
        record.errors.add(attr) unless ValidateBSN.valid?(value)
      end
    end

  end

  module Matchers
    class ValidateBSNMatcher
      def initialize(model, *args)
        @model = model
        @expected = args
      end

      def matches?(*args)
        @actual = @model.class.instance_variable_get(:@__validates_bsn_format)
        @actual == @expected
      end

      def description
        "should have a validated BSN format"
      end

      def failure_message_for_should
        "expected #{@model.class.human_name} to have these BSN validation options: #{@expected.inspect}, but got #{@actual.inspect}"
      end

      def failure_message_for_should_not
        "expected #{@model.class.human_name} not to have these BSN validation options: #{@expected.inspect}, but got #{@actual.inspect}"
      end
    end

    def validate_bsn_format(*args)
      ValidateBSNMatcher.new(subject, *args)
    end
  end

  module Macros
    def self.included(base)
      base.send(:include, ValidateBSN::Matchers)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def should_validate_bsn_format(*args)
        it { should validate_bsn_format(*args) }
      end
      def should_not_validate_bsn_format(*args)
        it { should_not validate_bsn_format(*args) }
      end
    end
  end

end
