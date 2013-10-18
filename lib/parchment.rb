require "parchment/version"
require "parchment/sheaf"
require "parchment/sheet"
require "parchment/per_page"

module Parchment
  extend Parchment::PerPage
  per_page(30)
end
