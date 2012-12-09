## ruby -Itest -Ilib test/state_object_values_test.rb
require 'test_helper'

#
# test bad data and exceptions
#
       
class NoStateObjectValues < StateObjects::Base
end

class ModelUnderTest < SuperModel::Base
  extend StateObjects::ModelAdditions
    
  begin                                             
    state_objects :no_state,
       NoStateObjectValues    
  rescue RuntimeError => ex
    @@ex_no_state_values = ex
  end

  def self.ex_no_state_values
    @@ex_no_state_values
  end

end

class StateObjectValuesTest < Test::Unit::TestCase
  def setup
    @model  = ModelUnderTest
  end

  def test_no_state_values
    assert_equal RuntimeError, ModelUnderTest.ex_no_state_values.class
    assert_equal "Invalid State class [NoStateObjectValues]. Must implement a class method named: #symbol.  Use #state_object_values to setup StateObject",
                  ModelUnderTest.ex_no_state_values.message
  end

end
