require 'minitest/autorun'
require 'parchment'

describe Parchment::Sheet do
  before do
    klass = Class.new{ include Parchment::Sheet }
    @sheet = klass.new
  end

  describe "ordinal_pages" do
    it "should have ordinal_pages accessors" do
      @sheet.must_respond_to :ordinal_pages
      @sheet.must_respond_to :ordinal_pages=
      @sheet.must_respond_to :ordinal_pages?
    end

    it "should mutate with ordinal_pages=" do
      @sheet.ordinal_pages = true
      @sheet.ordinal_pages.must_equal true
    end

    it "should alias reader as predicate" do
      @sheet.ordinal_pages = true
      @sheet.ordinal_pages?.must_equal true
    end
  end

  describe "current_page" do
    it "should have current_page accessors" do
      @sheet.must_respond_to :current_page
      @sheet.must_respond_to :current_page=
    end

    it "should mutate with current_page=" do
      @sheet.current_page = 3
      @sheet.current_page.must_equal 3
    end
  end

  describe "per_page" do
    it "should have per_page accessors" do
      @sheet.must_respond_to :per_page
      @sheet.must_respond_to :per_page=
    end

    it "should mutate with per_page=" do
      @sheet.per_page = 3
      @sheet.per_page.must_equal 3
    end
  end

  describe "first_page" do
    it "should have first_page accessors" do
      @sheet.must_respond_to :first_page
      @sheet.must_respond_to :first_page=
    end

    it "should mutate with first_page=" do
      @sheet.first_page = 3
      @sheet.first_page.must_equal 3
    end
  end

  describe "last_page" do
    it "should have last_page accessors" do
      @sheet.must_respond_to :last_page
      @sheet.must_respond_to :last_page=
    end

    it "should mutate with last_page=" do
      @sheet.last_page = 3
      @sheet.last_page.must_equal 3
    end
  end

  describe "next_page" do
    it "should have next_page accessors" do
      @sheet.must_respond_to :next_page
      @sheet.must_respond_to :next_page=
    end

    it "should mutate with next_page=" do
      @sheet.next_page = 3
      @sheet.next_page.must_equal 3
    end
  end

  describe "previous_page" do
    it "should have previous_page accessors" do
      @sheet.must_respond_to :previous_page
      @sheet.must_respond_to :previous_page=
    end

    it "should mutate with previous_page=" do
      @sheet.previous_page = 3
      @sheet.previous_page.must_equal 3
    end
  end

  describe "total_entries" do
    it "should have total_entries accessors" do
      @sheet.must_respond_to :total_entries
      @sheet.must_respond_to :total_entries=
    end

    it "should mutate with total_entries=" do
      @sheet.total_entries = 3
      @sheet.total_entries.must_equal 3
    end
  end

  describe "total_pages" do
    before do
      @sheet.total_entries = 10
      @sheet.per_page = 5
    end

    it "should be nil if total_entries is nil" do
      @sheet.total_entries = nil
      @sheet.total_pages.must_be_nil
    end

    it "should be nil if per_page is nil" do
      @sheet.per_page = nil
      @sheet.total_pages.must_be_nil
    end

    it "should be nil if per_page is 0" do
      @sheet.per_page = 0
      @sheet.total_pages.must_be_nil
    end

    it "should be 1 if total_entries is 0" do
      @sheet.total_entries = 0
      @sheet.total_pages.must_equal 1
    end

    it "should be total_entries/per_page if evenly divisible" do
      @sheet.total_pages.must_equal 2
    end

    it "should round up if not evenly divisible" do
      @sheet.per_page = 3
      @sheet.total_pages.must_equal 4
    end
  end
end
