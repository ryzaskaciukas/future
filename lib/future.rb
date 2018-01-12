require 'future/version'
require 'nbayes'

class FutureArray < Array
  attr_accessor :initial_items
  attr_accessor :network

  def initialize(items, network)
    @initial_items = items
    @network = network

    super(items)
  end
end

class Array
  def future_map(injected_networks = [])
    result = []

    final_nbayes = NBayes::Base.new

    result = map do |item|
      injected_predictions = injected_networks.map do |injected_network|
        key = injected_network[:real_getter].to_sym
        value = Future.transform(item[key])
        output = injected_network[:network].network.classify(value)

        output[true]
      end

      if block_given?
        given_result = nil

        unless injected_predictions.empty?
          given_result = injected_predictions.sum / injected_predictions.size >= 0.5
        end

        block_result = yield(item, given_result)
        final_nbayes.train(Future.transform(item), block_result)
      end

      final_nbayes.classify(Future.transform(item)).max_class
    end

    FutureArray.new(result, final_nbayes)
  end
end

module Future
  def self.transform(object)
    case object
    when String
      object.split(/\s+/)
    when Hash
      object.to_a
    when TrueClass, FalseClass
      [object]
    else
      raise 'Not transform for object'
    end
  end

  def self.run
    descriptions = [
      'I code with laravel',
      'I like you',
    ]

    laravel_description_network = descriptions.future_map do |description|
      !!description.match('laravel')
    end

    titles = [
      'UI designer',
      'php programmer',
    ]

    php_title_network = titles.future_map do |title|
      !!title.match('php')
    end

    real_people = [
      {
        title: 'php dude',
        description: 'I must do laravel'
      },
    ]

    final = real_people.future_map([
      { network: laravel_description_network, real_getter: 'description' },
      { network: php_title_network, real_getter: 'title' },
    ]) do |person, works_with_laravel|
      [person, works_with_laravel]
    end

    p 'Final:'
    p final
  end
end
