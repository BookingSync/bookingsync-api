module Sawyer
  class Resource
    # With below alias it's possible to pass ID or Sawyer::Resource
    # to edit/destroy methods
    def to_s
      id
    end
  end
end
