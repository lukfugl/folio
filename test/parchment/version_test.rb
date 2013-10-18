require 'minitest/autorun'
require 'parchment'

describe Parchment do
  it "should have a version" do
    Parchment::VERSION.wont_be_nil
  end
end
