require 'parchment/sheaf'
require 'parchment/invalid_page'
require 'delegate'

# Mixing this into your source instead of Parchment::Sheave has the same
# requirements and benefits, except the responsibilities of the
# build_sheet and fill_sheet methods are narrowed.
#
# build_sheet no longer needs to configure ordinal_page, first_page, or
# last_page on the instantiated sheet; these values will all be inferred
# or hard coded instead. ordinal_page will always be true and first_page
# will always be 1. last_page is replaced by an alias to total_pages.
# build_sheet method now simply needs to choose a type of sheet to
# instantiate and return it.
#
# Similarly, fill_sheet no longer needs to configure next_page and
# last_page; they will be calculated from current_page, first_page, and
# last_page. Instead, the method can focus entirely on populating the
# sheet.
module Parchment
  module Sheaf
    module Ordinal
      class SheetDecorator < ::SimpleDelegator
        # hard coded values/calculations for some of the attributes
        def ordinal_pages
          true
        end
        alias :ordinal_pages? :ordinal_pages

        def first_page
          1
        end

        def last_page
          total_pages
        end

        def next_page=(value)
          @next_page = value
        end

        def next_page
          if last_page && current_page >= last_page
            # known last page and we've reached it. no next page (even if
            # explicitly set)
            nil
          elsif last_page || !defined?(@next_page)
            # (1) known last page and we haven't reached it (because we're not
            #     in the branch above), or
            # (2) unknown last page, but nothing set, so we assume an infinite
            #     stream
            # so there's a next page, and it's the one after this one
            current_page + 1
          else
            # just use what they set
            @next_page
          end
        end

        def previous_page
          current_page > first_page ? current_page - 1 : nil
        end
      end

      def build_sheet_with_decorator
        # wrap the sheet built by the host in the decorator
        ::Parchment::Sheaf::Ordinal::SheetDecorator.new(build_sheet_without_decorator)
      end

      def fill_sheet_with_bounds_checking(sheet)
        # perform bounds checking before passing it along
        raise ::Parchment::InvalidPage unless sheet.current_page.is_a?(Integer)
        raise ::Parchment::InvalidPage if sheet.current_page < sheet.first_page
        raise ::Parchment::InvalidPage if sheet.last_page && sheet.current_page > sheet.last_page
        fill_sheet_without_bounds_checking(sheet)
      end

      # otherwise acts like a normal sheaf
      include ::Parchment::Sheaf

      def self.included(klass)
        super

        # like ActiveSupport's alias_method_chain, but don't want to create a
        # dependency on ActiveSupport for just this.
        klass.send(:alias_method, :build_sheet_without_decorator, :build_sheet)
        klass.send(:alias_method, :build_sheet, :build_sheet_with_decorator)
        klass.send(:alias_method, :fill_sheet_without_bounds_checking, :fill_sheet)
        klass.send(:alias_method, :fill_sheet, :fill_sheet_with_bounds_checking)
      end
    end
  end
end
