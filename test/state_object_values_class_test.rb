## ruby -Itest -Ilib test/state_object_values_class_test.rb
require 'test_helper'

class StateObjectUnderTest < StateObjects::Base
    
  begin 
    state_object_values :green, 'G'
  rescue RuntimeError => ex
    @@ex_incomplete_values = ex
  end

  def self.ex_incomplete_values
    @@ex_incomplete_values
  end

end

class StateObjectValuesClassTest < Test::Unit::TestCase
  def setup
    @model  = StateObjectUnderTest
  end

  def test_ex_incomplete_values
    assert_equal RuntimeError, StateObjectUnderTest.ex_incomplete_values.class
    assert_equal "#state_object_values Must have 3 arguments: symbol, db_value, label.  For Example: state_object_values :red,'R','Dont Walk'",
                  StateObjectUnderTest.ex_incomplete_values.message
  end

end
