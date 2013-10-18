require 'parchment/sheet'

# A subclass of Array mixing in Parchment::Sheet
module Parchment
  module Sheet
    class Basic < Array
      include ::Parchment::Sheet
    end
  end
end
