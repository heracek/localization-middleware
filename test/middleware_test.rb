require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class MiddlewareTest < Test::Unit::TestCase

  def check_locale_from_path_and_expected_path(path, expected_locale, expected_path)
    @middleware.instance_variable_set('@env', {'PATH_INFO' => path })
    assert_equal @middleware.send(:locale_from_url, path), expected_locale
    assert_equal @middleware.instance_variable_get('@env')['PATH_INFO'], expected_path
  end

  def setup
    @middleware = Localization::Middleware.new nil, [:en,:ru]
  end

  def test_root_matching_without_locale
    assert_nil @middleware.send :locale_from_url, '/'
    assert_equal ::I18n.default_locale, ::I18n.locale
  end

  def test_set_correct_locale
    assert_equal 'en', @middleware.send(:locale_from_url, '/en')
    assert_equal :en, @middleware.send(:set_locale)
    assert_equal :en, ::I18n.locale

    @middleware.send(:unset_locale)
    assert_equal ::I18n.default_locale, ::I18n.locale

    assert_equal 'ru', @middleware.send(:locale_from_url, '/ru')
    assert_equal :ru, @middleware.send(:set_locale)
    assert_equal :ru, ::I18n.locale

    @middleware.send(:unset_locale)
    assert_equal ::I18n.locale, I18n.default_locale
  end

  def test_set_incorrect_locale
    assert_nil @middleware.send(:locale_from_url, '/test')
    assert_nil @middleware.send(:set_locale)
    assert_equal ::I18n.locale, I18n.default_locale
  end

  def test_correct_locale_with_path
    check_locale_from_path_and_expected_path('/ru/test', 'ru', '/test')
  end

  def test_set_incorrect_locale_with_conflicting_path
    check_locale_from_path_and_expected_path('/running', nil, '/running')
  end

  def test_set_incorrect_locale_with_nonconflicting_path
    check_locale_from_path_and_expected_path('/test', nil, '/test')
  end

  def test_set_correct_locale_with_conflicting_path
    check_locale_from_path_and_expected_path('/ru/running', 'ru', '/running')
  end
end
