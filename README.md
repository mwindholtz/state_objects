# StateObjects

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'state_objects'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install state_objects

## Usage

This is a State Machine implementation based on the http://en.wikipedia.org/wiki/State_pattern
From the classic book http://en.wikipedia.org/wiki/Design_Patterns

    class LightRedState  < StateObjects::Base
      state_object_values :red, 'R', "Don't Walk" 
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
      state_object_methods :change
    
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
