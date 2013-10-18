module Parchment
  module PerPage
    def default_per_page
      Parchment.per_page
    end

    def per_page(*args)
      @per_page = args.first if args.size > 0
      @per_page ? @per_page : default_per_page
    end

    def per_page=(value)
      self.per_page(value)
    end
  end
end
