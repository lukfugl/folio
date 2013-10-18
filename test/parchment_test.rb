require 'minitest/autorun'
require 'parchment'

describe Parchment do
  it "should have a per_page attribute" do
    Parchment.must_respond_to :per_page
    Parchment.must_respond_to :per_page=
  end

  it "should allow setting by per_page=" do
    was = Parchment.per_page
    Parchment.per_page = 100
    Parchment.per_page.must_equal 100
    Parchment.per_page = was
  end

  it "should allow setting by argument to per_page" do
    was = Parchment.per_page
    Parchment.per_page(100)
    Parchment.per_page.must_equal 100
    Parchment.per_page = was
  end

  it "should default to 30" do
    Parchment.per_page.must_equal 30
  end
end
