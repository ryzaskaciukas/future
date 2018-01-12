module Future
  class Array < ::Array
    attr_accessor :initial_items
    attr_accessor :network

    def initialize(items, network)
      @initial_items = items
      @network = network

      super(items)
    end
  end
end
