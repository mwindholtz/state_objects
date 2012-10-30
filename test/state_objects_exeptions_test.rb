## ruby -Itest -Ilib test/state_objects_exceptions_test.rb
require 'test_helper'

#
# test bad data and exceptions
#
                            
class LightGreenState  < StateObjects::Base
  state_object_values :green, 'G', 'Walk' 
end        

class ModelUnderTest < SuperModel::Base
  extend StateObjects::ModelAdditions
  state_objects :color_state,
     LightGreenState

  begin 
    state_object_events :color_state, :missing_event
                                                                                   
  rescue RuntimeError => ex
    @@exception_missing_event = ex
  end

  def self.exception_missing_event
    @@exception_missing_event
  end

end

class TranslateOptionsForExTest < Test::Unit::TestCase
  def setup
    @model  = ModelUnderTest
  end

  def test_exception_missing_event
    assert_equal RuntimeError, ModelUnderTest.exception_missing_event.class
    assert_equal "Invalid state class LightGreenState must implement #missing_event",
                  ModelUnderTest.exception_missing_event.message
  end 

end
