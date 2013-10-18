require 'minitest/autorun'
require 'parchment/sheaf'

describe Parchment::Sheaf do
  before do
    sheet_klass = Class.new do
      include Parchment::Sheet
    end

    @klass = Class.new do
      define_method :build_sheet do
        sheet = sheet_klass.new
        sheet.ordinal_pages = false
        sheet.first_page = :first
        sheet.last_page = :last
        sheet
      end

      def fill_sheet(sheet)
        sheet.next_page = :next
        sheet.previous_page = :previous
      end

      include Parchment::Sheaf
    end

    @sheaf = @klass.new
  end

  describe "paginate" do
    it "should get the sheet from the sheaf's build_sheet method" do
      sheet = @sheaf.paginate
      sheet.ordinal_pages.must_equal false
      sheet.first_page.must_equal :first
      sheet.last_page.must_equal :last
    end

    it "should pass the sheet through the sheaf's fill_sheet method" do
      sheet = @sheaf.paginate
      sheet.next_page.must_equal :next
      sheet.previous_page.must_equal :previous
    end

    it "should populate current_page and per_page before passing it to fill_sheet" do
      @klass.send(:define_method, :fill_sheet) do |sheet|
        sheet.current_page.wont_be_nil
        sheet.per_page.wont_be_nil
      end
      @sheaf.paginate
    end

    describe "page parameter" do
      it "should populate onto the sheet" do
        sheet = @sheaf.paginate(page: :current)
        sheet.current_page.must_equal :current
      end

      it "should default to the sheet's first_page" do
        sheet = @sheaf.paginate
        sheet.current_page.must_equal sheet.first_page
      end
    end

    describe "per_page parameter" do
      it "should populate onto the sheet" do
        sheet = @sheaf.paginate(per_page: 100)
        sheet.per_page.must_equal 100
      end

      it "should default to the sheaf's per_page" do
        @sheaf.per_page = 100
        sheet = @sheaf.paginate
        sheet.per_page.must_equal 100
      end
    end

    describe "total_entries parameter" do
      it "should populate onto the sheet" do
        sheet = @sheaf.paginate(total_entries: 100)
        sheet.total_entries.must_equal 100
      end

      it "should default to the nil if the sheaf does not implement count" do
        sheet = @sheaf.paginate
        sheet.total_entries.must_be_nil
      end

      it "should default to the result of count if the sheaf implements count" do
        @klass.send(:define_method, :count) { 100 }
        sheet = @sheaf.paginate
        sheet.total_entries.must_equal 100
      end

      it "should not-execute the count if total_entries provided" do
        called = false
        @klass.send(:define_method, :count) { called = true }
        @sheaf.paginate(total_entries: 100)
        called.must_equal false
      end

      it "should not-execute the count if total_entries provided as nil" do
        called = false
        @klass.send(:define_method, :count) { called = true }
        sheet = @sheaf.paginate(total_entries: nil)
        called.must_equal false
        sheet.total_entries.must_be_nil
      end
    end
  end

  describe "per_page class attribute" do
    it "should exist" do
      @klass.must_respond_to :per_page
      @klass.must_respond_to :per_page=
    end

    it "should be settable from per_page=" do
      @klass.per_page = 100
      @klass.per_page.must_equal 100
    end

    it "should be settable from per_page with argument" do
      @klass.per_page(100)
      @klass.per_page.must_equal 100
    end

    it "should default to Parchment.per_page" do
      was = Parchment.per_page
      Parchment.per_page = 50
      @klass.per_page.must_equal 50
      Parchment.per_page = was
    end
  end

  describe "per_page instance attribute" do
    it "should exist" do
      @sheaf.must_respond_to :per_page
      @sheaf.must_respond_to :per_page=
    end

    it "should be settable from per_page=" do
      @sheaf.per_page = 100
      @sheaf.per_page.must_equal 100
    end

    it "should be settable from per_page with argument" do
      @sheaf.per_page(100)
      @sheaf.per_page.must_equal 100
    end

    it "should default to class' per_page" do
      @klass.per_page = 50
      @sheaf.per_page.must_equal 50
    end
  end
end
