require 'rubygems'
require 'spec'
Dir.glob(File.join(File.dirname(__FILE__), "..", "lib", "*.rb")).each { |f| require f }

describe ValidateBSN do

  it "should allow valid bsn" do
    %w| 100000009 100000010 100000022 100000034 100000046 100000058 100000071 100000083 100000095 100000101 |.each do |bsn|
      ValidateBSN.should be_valid(bsn)
    end
  end

  it "should not allow invalid bsn" do
    %w| 100000008 100000011 10000000B 10000009 10000000009 |.each do |bsn|
      ValidateBSN.should_not be_valid(bsn)
    end

  end


end

describe ValidateBSN::ActiveRecord do

  subject do
    Class.new do
      extend ValidateBSN::ActiveRecord
    end
  end

  it "should validate each attribute given" do
    subject.should_receive(:validates_each).with(:bsn, :foo)
    subject.validates_bsn_format(:bsn, :foo)
  end

end
