require 'minitest/autorun'
require 'parchment/sheet/basic'

describe Parchment::Sheet::Basic do
  before do
    @sheet = Parchment::Sheet::Basic.new
  end

  it "should be an enumerable" do
    @sheet.must_respond_to :each
  end

  it "should be a sheet" do
    @sheet.must_respond_to :current_page
  end
end
