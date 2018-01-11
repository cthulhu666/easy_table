require 'rubygems'
require 'bundler/setup'

require 'minitest/autorun'
require 'mocha/setup'

require 'active_model'
require 'action_controller'
require 'action_view'
require 'action_view/template'

require 'action_view/test_case'

require 'shoulda-context'

module Rails
  def self.env
    ActiveSupport::StringInquirer.new('test')
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'easy_table'

I18n.default_locale = :en

class ActionView::TestCase
  include EasyTable::ActionViewExtensions::TableHelper
end
