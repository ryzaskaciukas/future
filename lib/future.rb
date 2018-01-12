require 'future/version'
require 'future/language_extensions'
require 'future/array'

module Future
  def self.test_description_title
    descriptions = [
      'I code with laravel',
      'I like you',
    ]

    laravel_description_network = descriptions.map do |description|
      !!description.match('laravel')
    end

    titles = [
      'UI designer',
      'php programmer',
    ]

    php_title_network = titles.map do |title|
      !!title.match('php')
    end

    real_people = [
      {
        title: 'php dude',
        description: 'I must do laravel'
      },
      {
        title: 'non cool dude',
        description: 'I must do something about it'
      },
    ]

    people_mapped_with_laravel = real_people.map([
      {
        network: laravel_description_network,
        transform: ->(person) { person[:description] },
      },
      {
        network: php_title_network,
        transform: ->(person) { person[:title] }
      },
    ]) do |person, works_with_laravel|
      [person, works_with_laravel]
    end

    puts 'Results:'
    p people_mapped_with_laravel
  end
end
