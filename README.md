# StateObjects

This is a State Machine implementation based on the http://en.wikipedia.org/wiki/State_pattern
From the classic book http://en.wikipedia.org/wiki/Design_Patterns
Each state is a separate class.
You can add methods to the state classes, but each state class must have implement the same list of methods.
State transitions are the responsibility of the state classes.

## Focus
Many other state machines focus on events and state transitions.
This state machine focuses on behavior.
The main benefit of this gem is to reduce conditional logic by removing #if checks in the model and moving the logic into the state objects. Using Composition in this way can go a long way to simplify Rails models.

This gem works well with ActiveRecord classes, however ActiveRecord is not required.  It can manage the state of regular Ruby objects as well.

## Installation

Add this line to your application's Gemfile:

    gem 'state_objects'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install state_objects

## Usage

    class WalkLights < ActiveRecord::Migration
      def change
        create_table :walk_lights do |t|
          t.string :color_state, :default => LightRedState.db_value
        end
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
    
    class WalkLight < ActiveRecord::Base
      extend StateObjects::ModelAdditions
      state_objects :color_state,
         LightGreenState,
         LightRedState 
      state_object_events :color_state, :change
                                                                                       
      scope :red,   where(WalkLight.color_state_red_occurs )    
      scope :green, where(WalkLight.color_state_green_occurs ) 
    end

    # now lets use it 
    north_south_elm_300_block = WalkLight.create(color_state: LightRedState.db_value)
    while (true)
      pause rand(200)  # keep the pedestrians guessing :-)
      north_south_elm_300_block.change
    end

### adds the following CLASS METHODS to WalkLight

* color_states
  returns a array of 2-value arrays suitable to fill a select tag
  The second example shows how to start the selection on a blank
    
     <%= select :walk_light, :color_state, WalkLight.color_states %>
     <%= select :walk_light, :color_state,  [['','']] + WalkLight.color_states %>
    
     assert_equal "['Walk', 'Dont Walk']",  WalkLight.color_state_js_list
    

adds the following INSTANCE METHODS to WalkLight

    color_state #  returns the single character value as in the db    
    color_state_label  # returns the current values label    
    color_state_symbol  # returns the current values symbol

* methods ending in '?' return boolean if the value is set
* methods ending in '!' set the value ( this does NOT save the model)
  
    color_state_red?  
    color_state_red! 
    
    color_state_green?
    color_state_green!
    
### example #1: Selection list

    walk_light = WalkLight.build(color_state: LightGreenState.db_value)
    walk_light.color_state_red!
    assert_equal 'R',                walk_light.color_state
    assert_equal :red,               walk_light.color_state_symbol
    assert_equal true,               walk_light.color_state_red?
    assert_equal "Dont Walk",        walk_light.color_state_label
    
    assert_equal [["Walk", "G"], ["Dont Walk", "R"]], WalkLight.color_states
    
### Example #2: Selection list

    <%=  select :walk_light, :color_state, WalkLight.color_states %> 
    

### Example #3: Radio button labels

    <% WalkLight.color_state_hash.each do | key, value | %>
        <%=  radio_button :walk_light, :color_state, key %> <%= value %><br />
    <% end %>
    
### Example #4:  adding scope with _occurs
It's now easy to add scopes with using _occurs, which will generate your where statement for you.

    scope :red,   where(WalkLight.color_state_red_occurs )     # => "(color_state ='R')"
    scope :green, where(WalkLight.color_state_green_occurs )   # => "(color_state ='G')"   
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks To
* Scott Baron (https://github.com/rubyist) - for helping with the unit tests.
