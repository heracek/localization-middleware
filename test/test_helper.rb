require 'rubygems'
require 'test/unit'
require 'capybara'
require 'capybara/dsl'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'localization-middleware'

require File.join(File.dirname(__FILE__), 'test_app', 'config', 'boot')

I18n.locale = :en

class Test::Unit::TestCase
  include Capybara::DSL

  def app
    @app || Padrino.application
  end
end
