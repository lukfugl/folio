require 'minitest/autorun'
require 'parchment/sheaf/ordinal'

describe Parchment::Sheaf::Ordinal do
  before do
    @klass = Class.new do
      def build_sheet
        Parchment::Sheet::Basic.new
      end

      def fill_sheet(sheet)
      end

      include Parchment::Sheaf::Ordinal
    end
    @sheaf = @klass.new
  end

  describe "decorated build_sheet" do
    before do
      @sheet = @sheaf.build_sheet
      @sheet.per_page = 10
      @sheet.total_entries = 30
    end

    it "should have ordinal_pages=true" do
      @sheet.ordinal_pages.must_equal true
      @sheet.ordinal_pages?.must_equal true
    end

    it "should have first_page=1" do
      @sheet.first_page.must_equal 1
    end

    it "should have last_page=total_pages" do
      @sheet.last_page.must_equal @sheet.total_pages

      @sheet.total_entries = 0
      @sheet.last_page.must_equal @sheet.total_pages

      @sheet.total_entries = nil
      @sheet.last_page.must_equal @sheet.total_pages
    end

    it "should have next_page=nil when at end" do
      @sheet.current_page = 3
      @sheet.next_page.must_be_nil
    end

    it "should have next_page=current_page+1 when at end, despite set value" do
      @sheet.current_page = 3
      @sheet.next_page = 4
      @sheet.next_page.must_be_nil
    end

    it "should have next_page=current_page+1 when end known and not at end" do
      @sheet.current_page = 2
      @sheet.next_page.must_equal 3
    end

    it "should have next_page=current_page+1 when end known and not at end, despite set value" do
      @sheet.current_page = 2
      @sheet.next_page = nil
      @sheet.next_page.must_equal 3
    end

    it "should have next_page=current_page+1 when end unknown and not explicitly set" do
      @sheet.total_entries = nil
      @sheet.current_page = 2
      @sheet.next_page.must_equal 3
    end

    it "should have next_page=set value when end unknown and explicitly set" do
      @sheet.total_entries = nil
      @sheet.next_page = nil
      @sheet.current_page = 2
      @sheet.next_page.must_be_nil
    end

    it "should have previous_page=nil when at beginning" do
      @sheet.current_page = 1
      @sheet.previous_page.must_be_nil
    end

    it "should have previous_page=current_page-1 when not at beginning" do
      @sheet.current_page = 3
      @sheet.previous_page.must_equal 2
    end
  end

  describe "bounds checking on fill_sheet" do
    before do
      @sheet = @sheaf.build_sheet
      @sheet.per_page = 10
      @sheet.total_entries = 30
    end

    it "should raise on non-integer page" do
      @sheet.current_page = "non-integer"
      lambda{ @sheaf.fill_sheet(@sheet) }.must_raise Parchment::InvalidPage
    end

    it "should raise on negative page" do
      @sheet.current_page = -1
      lambda{ @sheaf.fill_sheet(@sheet) }.must_raise Parchment::InvalidPage
    end

    it "should raise on page of 0" do
      @sheet.current_page = 0
      lambda{ @sheaf.fill_sheet(@sheet) }.must_raise Parchment::InvalidPage
    end

    it "should raise on page greater than known last_page" do
      @sheet.current_page = 4
      lambda{ @sheaf.fill_sheet(@sheet) }.must_raise Parchment::InvalidPage
    end

    it "should not raise on page number between first_page and known last_page" do
      @sheet.current_page = 1
      @sheaf.fill_sheet(@sheet)

      @sheet.current_page = 3
      @sheaf.fill_sheet(@sheet)
    end

    it "should not raise on large page if last_page unknown" do
      @sheet.total_entries = nil
      @sheet.current_page = 100
      @sheaf.fill_sheet(@sheet)
    end
  end

  it "should behave like a Parchment::Sheaf" do
    @sheaf.must_respond_to :paginate
  end
end
