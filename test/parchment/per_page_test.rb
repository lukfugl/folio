require 'minitest/autorun'
require 'parchment/per_page'

describe Parchment::PerPage do
  before do
    @klass = Class.new{ include Parchment::PerPage }
    @object = @klass.new
  end

  describe "default_per_page" do
    it "should be Parchment.per_page" do
      was = Parchment.per_page
      Parchment.per_page = 100
      @object.default_per_page.must_equal 100
      Parchment.per_page = was
    end
  end

  describe "per_page" do
    it "should return default_per_page if nil" do
      @klass.send(:define_method, :default_per_page) { 100 }
      @object.per_page = nil
      @object.per_page.must_equal 100
    end

    it "should return set value if non-nil" do
      @object.per_page = 100
      @object.per_page.must_equal 100
    end

    it "should allow setting through argument" do
      @object.per_page(100)
      @object.per_page.must_equal 100
    end
  end
end
