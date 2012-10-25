# StateObjects

This is a State Machine implementation based on the http://en.wikipedia.org/wiki/State_pattern
From the classic book http://en.wikipedia.org/wiki/Design_Patterns
Each state is a separate class.
You can add methods to the state classes, but each state class must have implement the same list of methods.
State transitions are the responsibility of the state classes.

Since this was extracted from an application, the specs are currently still in the main application.  I will move the specs to this gem as soon as possible.

## Installation

Add this line to your application's Gemfile:

    gem 'state_objects'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install state_objects

## Usage

    class WalkLights < ActiveRecord::Migration
      def self.change
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
      state_object_events :change
                                                                                       
      scope :red,   where("color_state = #{LightRedState.db_value}" )    
      scope :green, where("color_state = #{LightGreenState.db_value}" )    
    end

    # now lets use it 
    north_south_elm_300_block = WalkLight.create(color_state: LightRedState.db_value)
    while (true)
      pause rand(200)  # keep the pedestrians guessing :-)
      north_south_elm_300_block.change
    end

### adds the following CLASS METHODS to WalkLight

TODO: there may be typos in the following.  It should be cleared up when I move the specs into the gem.

* color_states
  returns a array of 2-value arrays suitable to fill a select tag
  The second example shows how to start the selection on a blank
    
     <%= select :walk_light, :color_state, WalkLight.color_states %>
     <%= select :walk_light, :color_state,  [['','']] + WalkLight.color_states %>
    
     assert_equal  ['Walk', 'Dont Walk'],   WalkLight.color_state_hash.values
     assert_equal "['Walk', 'Dont Walk']",  WalkLight.color_state_js_list
    
    color_state_symbols  #  returns hash of symbols

adds the following INSTANCE METHODS to WalkLight

    color_state_hash
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
    assert_equal({"G"=>"Walk", "R"=>"Dont Walk",},    WalkLight.color_state_hash) 
    assert_equals({'G'=>:green, 'R'=>:red },          WalkLight.color_state_symbols) 
    
### Example #2: Selection list

    <%=  select :walk_light, :color_state, WalkLight.color_states %> 
    

### Example #3: Radio button labels

    <% WalkLight.color_state_hash.each do | key, value | %>
        <%=  radio_button :walk_light, :color_state, key %> <%= value %><br />
    <% end %>
    

### Example #4 in a java_script list

    color_state_js_list

    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
