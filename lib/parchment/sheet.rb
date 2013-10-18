# Mix into any Enumerable. The mixin gives you the eight attributes and
# one method described below.
#
# ordinal_pages?, first_page, and last_page are common to all sheets
# created by a sheaf and are configured, as available, when the sheaf
# creates a blank sheet.
#
# current_page, per_page, and total_entries control the filling of a
# sheet and are configured from parameters to the sheaf's paginate
# method.
#
# next_page and previous_page are configured, as available, when the
# sheaf fills the configured sheet.
module Parchment
  module Sheet
    # indicates whether the page identifiers in current_page,
    # first_page, last_page, previous_page, and next_page should be
    # considered ordinal or not.
    attr_accessor :ordinal_pages
    alias :ordinal_pages? :ordinal_pages

    # page identifier addressing this sheet within the sheaf.
    attr_accessor :current_page

    # number of items requested from the sheaf when filling the sheet.
    attr_accessor :per_page

    # page identifier addressing the first sheet within the sheaf.
    attr_accessor :first_page

    # page identifier addressing the final sheet within the sheaf, if
    # known.
    attr_accessor :last_page

    # page identifier addressing the immediately following sheet within
    # the sheaf, if there is one.
    attr_accessor :next_page

    # page identifier addressing the immediately preceding sheet within
    # the sheaf, if there is one and it is known.
    attr_accessor :previous_page

    # number of items in the sheaf, if known.
    attr_accessor :total_entries

    # number of sheets in the sheaf, if known. calculated from
    # total_entries and per_page.
    def total_pages
      return nil unless total_entries && per_page && per_page > 0
      return 1 if total_entries <= 0
      (total_entries / per_page.to_f).ceil
    end
  end
end
