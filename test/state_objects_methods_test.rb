## ruby -Itest -Ilib test/state_objects_methods_test.rb
require 'test_helper'

#
# setup three classes for these tests
#
# 1. ModelUnderTest  -- declare selection_options_for to be tested
# 2. SiblingOfModelUnderTest -- make sure that no meta-level leaks occur
# 3. SubClassOfModel -- should have it's own copy of class variables
#

class SiblingOfModelUnderTest < SuperModel::Base
  extend StateObjects::ModelAdditions
end

class LightRedState  < StateObjects::Base
  state_object_values :red, 'R', "Dont Walk" 
  def change
    model.color_state_green!
    model.save!    
  end  
end        

class LightGreenState  < StateObjects::Base
  state_object_values :green, 'G', 'Walk' 
  def change
    model.color_state_red!
    model.save!    
  end  
end        

class ModelUnderTest < SuperModel::Base
  extend StateObjects::ModelAdditions
  state_objects :color_state,
     LightGreenState,
     LightRedState 
  state_object_events :color_state, :change
                                                                                   
end

# class SubClassOfModel < ModelUnderTest
#   selection_options_for :payment_method_option,
#             [:advanced, 'A', 'Advanced'],
#             [:ecash,    'E', 'ECash Account']
# end

class StateObjectsTest < Test::Unit::TestCase
  def setup
    @model  = ModelUnderTest
  end  

  def test_should_provide_symbol
    target =  @model.new
    target.color_state_red!
    assert_equal :red, target.color_state_symbol
  end
    
  def test_symbol_generation
    target =  @model.new
    # green
    target.color_state_green!
    assert target.color_state_green?
    assert !target.color_state_red?
    # red
    target.color_state_red!
    assert !target.color_state_green?
    assert target.color_state_red?
  end

  def test_sibling_of_target_not_effected_by_class_methods
      SiblingOfModelUnderTest.payment_method_options
      flunk "Should throw Exception" 
      rescue NoMethodError => ex
         assert true
      rescue
        flunk "wrong exception thrown"
  end

  # def test_each_subclass_has_own_symbols    
  #   assert_equal [["Advanced", "A"], ["ECash Account", "E"]] ,
  #                 SubClassOfModel.color_payment_method_options.sort 
  # end

  def test_default_status
    target =  @model.new
    target.color_state_red!
    assert_equal 'Dont Walk', target.color_state_label
    target.color_state = 'G'
    assert_equal 'Walk', target.color_state_label
  end

  def test_color_state_array    
    assert_equal [["Dont Walk", 'R'], ["Walk", "G"]].sort,  
                  @model.color_states.sort    
  end

  def test_color_state_js_list
    assert_equal "['Walk', 'Dont Walk']",
                 @model.color_state_js_list
  end
    
end
