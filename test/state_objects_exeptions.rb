## ruby -Itest -Ilib test/state_objects_exceptions_test.rb
require 'test_helper'

#
# test bad data and exceptions
#

class ModelUnderTest < SuperModel::Base
  extend SelectionOptionsFor::ModelAdditions
    
  begin  
    selection_options_for :price_option,
            [:basic,  'B', 'Basic' ],
            [:cash,   'C', 'Cash Account '],
            [:cc,     'R','Credit Card Account'],
            123            
            
  rescue RuntimeError => ex
    @@exception_num = ex
  end

  def self.exception_num
    @@exception_num
  end

  begin  
    selection_options_for :status_option,
            [:basic,  'B', 'Basic' ],
            'Cash Account',
            [:cc, 'R','Credit Card Account']
            
  rescue RuntimeError => ex
    @@exception_string = ex
  end

  def self.exception_string
    @@exception_string
  end

  begin  
    selection_options_for :gender_option,
            [:male,     'B', 'Male' ],
            [:female,   'Female'],
            [:unknown,  'U', 'unknown' ]            
  rescue RuntimeError => ex
    @@exception_deprecated = ex
  end

  def self.exception_deprecated
    @@exception_deprecated
  end

end

class TranslateOptionsForExTest < Test::Unit::TestCase
  def setup
    @model  = ModelUnderTest
  end

  def test_invalid_num
    assert_equal RuntimeError, ModelUnderTest.exception_num.class
    assert_equal "Invalid item [123] in :price_option of type [Fixnum]. Expected Array",
                  ModelUnderTest.exception_num.message
  end

  def test_invalid_string
    assert_equal RuntimeError, ModelUnderTest.exception_string.class
    assert_equal "Invalid item [Cash Account] in :status_option of type [String]. Expected Array",
                  ModelUnderTest.exception_string.message
  end

  def test_deprecated_format
    assert_equal RuntimeError, ModelUnderTest.exception_deprecated.class
    assert_equal "Invalid number of items. 2 part definition is no longer supported.  Add the middle value for storage in the DB.",
                  ModelUnderTest.exception_deprecated.message
  end


end
