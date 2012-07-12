# EasyTable

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'easy_table'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy_table

## Usage

All examples assume that You are using Haml. Please, use Haml !

### Simplest example

```haml
= table_for(@people) do |t|
  - t.column :name
  - t.column :surname
```

This produces:

```haml
%table
  %thead
    %tr
      %th name
      %th surname
  %tbody
    %tr{id: 'person-1'}
      %td John
      %td Doe
```

Assuming `@people` is a collection consisting of one record, person with id = 1, John Doe


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
