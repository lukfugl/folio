require 'parchment/sheaf/ordinal'
require 'parchment/sheet/basic'

# Extends any Enumerable to be a Parchment::Sheaf::Ordinal.
module Enumerable
  def build_sheet
    ::Parchment::Sheet::Basic.new
  end

  def fill_sheet(sheet)
    slice = self.each_slice(sheet.per_page).first(sheet.current_page)[sheet.current_page-1]
    if slice.nil?
      if sheet.current_page > sheet.first_page
        raise ::Parchment::InvalidPage
      else
        slice = []
      end
    end
    sheet.replace slice
  end

  include ::Parchment::Sheaf::Ordinal

  # this is crazy, but it essentially links in the methods defined on
  # the module we just included into Enumerable itself, so that things
  # that already included Enumerable can inherit them
  ::Parchment::Sheaf::Ordinal.instance_methods.each do |method|
    alias_method method, method
  end

  # things that already included Enumerable won't have extended the
  # PerPage, so the instance's default default_per_page method looking
  # at self.class.per_page won't work. point it back at
  # Parchment.per_page
  def default_per_page
    Parchment.per_page
  end
end
