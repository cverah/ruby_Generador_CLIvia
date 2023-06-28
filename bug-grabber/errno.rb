module Errno
  class Enoent < StandardError
    def initialize(error = "JSON File is empty")
      super error
    end
  end
end
