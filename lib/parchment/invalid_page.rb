# Raised when a value passed to a Parchment::Sheaf's paginate method is
# non-sensical or out of bounds for that sheaf.
module Parchment
  class InvalidPage < ArgumentError; end
end
