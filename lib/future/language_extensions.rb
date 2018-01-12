require 'future/transform'

class Array
  def future_map(injected_networks = [])
    result = []

    final_nbayes = NBayes::Base.new

    result = map do |item|
      injected_predictions = injected_networks.map do |injected_network|
        selected_value = injected_network[:transform].call(item)
        value = Future::Transform.call(selected_value)
        output = injected_network[:network].network.classify(value)

        output[true]
      end

      if block_given?
        given_result = nil

        unless injected_predictions.empty?
          # TODO: tried to not use this, but forgot how
          given_result = injected_predictions.sum / injected_predictions.size >= 0.5
        end

        block_result = yield(item, given_result)
        final_nbayes.train(Future::Transform.call(item), block_result)
      end

      final_nbayes.classify(Future::Transform.call(item)).max_class
    end

    Future::Array.new(result, final_nbayes)
  end
end
