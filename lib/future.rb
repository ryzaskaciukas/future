require 'future/version'
require 'nbayes'

class Array
  def future_map(existing_networks = [])
    result = []

    existing_decision_trees = existing_networks.map do |network|
      training = network[:network]

      nbayes = NBayes::Base.new

      training.each do |line|
        nbayes.train(Future.transform(line.first), line.last)
      end

      {
        nbayes: nbayes,
        network: network,
      }
    end

    map do |item|
      existing_predictions = existing_decision_trees.map do |existing_decision_tree|
        puts [item[existing_decision_tree[:network][:real_getter].to_sym]]

        key = existing_decision_tree[:network][:real_getter].to_sym
        value = Future.transform(item[key])
        output = existing_decision_tree[:nbayes].classify(value)

        output[1]
      end

      final_nbayes = NBayes::Base.new
      existing_predictions.each do |existing_prediction|
        final_nbayes.train(Future.transform(item), existing_prediction)
      end

      output = final_nbayes.classify(Future.transform(item))
      yield(item, output.max_class)
    end
  end
end

module Future
  def self.transform(object)
    case object
    when String
      object.split(/\s+/)
    when Hash
      object.values
    else
      raise 'Not transform for object'
    end
  end

  def self.run
    real_descriptions = [
      'I code with laravel',
      'I like you',
    ]

    laravel_description_network = real_descriptions.future_map do |real_description|
      [real_description, !!real_description.match('laravel')]
    end

    labeled_laravel_people = [
      [{
        name: 'David',
      }, 1],
      [{
        name: 'Peter',
      }, 1],
    ]

    real_people = [
      {
        name: 'David',
        description: 'I must do laravel'
      },
    ]

    final = real_people.future_map([
      { network: labeled_laravel_people, real_getter: 'description' },
      { network: laravel_description_network, real_getter: 'description' },
    ]) do |person, works_with_laravel|
      [person, works_with_laravel]
    end

    p 'Final:'
    p final
  end
end
