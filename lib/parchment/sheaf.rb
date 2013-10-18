require 'parchment/per_page'

# Mix into any class implementing the following two methods:
# 
# +build_sheet+: Responsible for instantiating a Parchment::Sheet and
# configuring its ordinal_pages?, first_page, and last_page attributes;
# those values being common to any sheet returned from the sheaf. 
# 
# +fill_sheet+: Receives a Parchment::Sheet with the ordinal_pages?,
# first_page, last_page, current_page, per_page, and total_entries
# attributes configured, and populates the sheet with the corresponding
# items from the sheaf. Also sets appropriate values for the next_page
# and previous_page attributes on the sheet. If the value provided in
# the sheet's current_page cannot be interpreted as addressing a sheet
# in the sheaf, raises Parchment::InvalidPage.
# 
# In return, `Parchment::Sheaf` provides a the paginate method and
# per_page attributes described below.
module Parchment
  module Sheaf
    # Returns a page worth of items from the sheaf in a
    # Parchment::Sheet. accepts the following parameters:
    #
    # +page+: a page identifier addressing which sheet of the sheaf to
    # return. if not present, the first sheet will be returned. will
    # raise Parchment::InvalidPage if the provided value cannot be used
    # to address a sheet.
    #
    # +per_page+: number of items to attempt to include in the sheet. if not
    # present, defaults to the sheaf's per_page value. should only
    # include fewer items if the end of the sheaf is reached.
    #
    # +total_entries+: pre-calculated value for the total number of
    # items in the sheaf. may be nil, indicating the returned sheet
    # should have total_entries nil.
    #
    # if the sheaf implements a count method and the total_entries
    # parameter is not supplied, the sheet's total_entries will be set
    # from the count method.
    def paginate(options={})
      sheet = self.build_sheet
      sheet.current_page = options.fetch(:page) { sheet.first_page }
      sheet.per_page = options.fetch(:per_page) { self.per_page }
      sheet.total_entries = options.fetch(:total_entries) { self.respond_to?(:count) ? self.count : nil }
      self.fill_sheet(sheet)
      sheet
    end

    def default_per_page
      self.class.per_page
    end

    include ::Parchment::PerPage

    # this funny pattern is so that if a module (e.g.
    # Parchment::Sheaf::Ordinal) includes this module, it won't get the
    # per_page attribute, but will still be able to bestow that
    # attribute on any class that includes *it*. 
    module PerPageIncluder
      def included(klass)
        if klass.is_a?(Class)
          klass.extend ::Parchment::PerPage
        else
          klass.extend ::Parchment::Sheaf::PerPageIncluder
        end
      end
    end
    extend PerPageIncluder
  end
end
