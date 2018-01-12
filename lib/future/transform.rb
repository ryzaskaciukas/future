module Future
  class Transform
    def self.call(object)
      case object
      when String
        object.split(/\s+/)
      when Hash
        object.to_a
      when TrueClass, FalseClass
        [object]
      else
        raise "No transform for object: #{object.class}"
      end
    end
  end
end
