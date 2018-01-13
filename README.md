# Future

*Welcome to the future, really.*

This is a proof-of-concept of what machine-learning-first programming language might look like.

I've implemented a future version of a `map` method in Ruby. It is usually done procedurially, but in the `Future` language it is done through a naive Bayes classifier. The classifier can be easily replaced by neural networks or some advanced tools like auto-ml.

Here's an example of how it works:
```ruby
descriptions = ['I code with laravel', 'I like it']

# this is a regular Ruby code you would write to map out
# whether the description matches text 'laravel'.
# What's different is that underneath it trained a naive Baynes classifier
laravel_description_network = descriptions.map do |description|
  !!description.match('laravel')
end
# => [true, false]
# Looks normal. But it actually got the result through the classifier and not procedurially.

# You can do the same for a title match:
titles = ['UI designer', 'php programmer']

php_title_network = titles.map do |title|
  !!title.match('php')
end
# => [false, true]

# Nothing special.
# Whats special is that you can now combine your already trained networks:
people = [
  { name: 'John', title: 'php dude', description: 'I must do laravel' },
  { name: 'Peter', title: 'non cool dude', description: 'I must do something about it' }
]

people_mapped_with_laravel = people.map([
  { network: laravel_description_network, transform: ->(person) { person[:description] } },
  { network: php_title_network, transform: ->(person) { person[:title] } }
]) do |person, combined_networks_result_works_with_laravel|
  { person[:name] => combined_networks_result_works_with_laravel }
end
# => [
  { 'John' => true },
  { 'Peter' => false }
]
# This `people.map` method combined the injected networks and trained the new combined
# network with it as inputs.
# `transform` key allows to transform the value of current `map` item to match to an already
# pretrained network.
# 
# So is the future?
```

## Why and how

Inspired by what the future of writing software might look like. 

Thanks to [Danielius](https://github.com/dvisockas) and [Mindaugas](https://github.com/kurmis) for exciting late-night talks about it.

## Installation

1. Clone this repository.
2. Install dependencies via:
```shell
$ bundle install
```
    
3. Run the test to see it in action:
```shell
$ ./bin/test_description_title
```
   
## Explanation

The usage is demonstrated in `lib/future.rb`
