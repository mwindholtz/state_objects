module StateObjects
  module ModelAdditions  
    
    def state_object_events(id,*methods)  # :nodoc:
      unless self.respond_to?("#{id}_klasses")
        raise StateObjects::Error.new "Invalid call sequence. #state_objects must be defined before #state_object_events"
      end                     

      # check methods on State classes      
      self.send("#{id}_states").each do |klass|
        methods.each do |method|
          unless klass.new(nil).respond_to?(method)
            raise StateObjects::Error.new "Invalid state class #{klass} must implement ##{method}"
          end                     
        end
      end
      
      id = id.to_s  
      methods.each do |method|
        module_eval <<-EOF1
          def #{method}(*args)
            #{id}_state.#{method}(*args)
          end
        EOF1
      end 
    end # state_object_events
    alias state_object_accessors state_object_events 
    alias state_object_mutators  state_object_events 
  
    def state_objects(id, *opts)  # :nodoc:
      id = id.to_s
      id_klasses = id + '_klasses'
      class_eval <<-EOF
        class_attribute "#{id_klasses}".to_sym
        send("#{id_klasses}=".to_sym, {})             

        def self.#{id}_states 
          #{id_klasses}.values
        end

        def self.#{id}s   
          #{id_klasses}.map { |key, klass| [klass.label, key] }
        end

        def self.#{id}_js_list
          result = '['
          self.#{id}_states.each{ |klass| result = result + "'"+ klass.label + "', "}
          result.chop!.chop! if result.size > 2
          result + ']'
        end

        def #{id}_state_klass
          unless result = self.#{id_klasses}[self.#{id}]
            raise StateObjects::Error.new #{id} + " was not a valid state in: " +  self.#{id_klasses}.keys.join(', ') 
          end  
          result
        end            

        def #{id}_state
          #{id}_state_klass.new(self)
        end            
        
        def #{id}_label
          #{id}_state_klass.label
        end                                                   
        
        def #{id}_symbol
          #{id}_state_klass.symbol
        end

      EOF
      opts.each do |option_klass|
        [:symbol, :label, :db_value].each do |required_method|
          unless option_klass.respond_to?(required_method) 
            raise StateObjects::Error.new "Invalid State class ["+ option_klass.to_s + "]. Must implement a class method named: ##{required_method}.  Use #state_object_values to setup StateObject"
          end          
        end
        
        letter       = option_klass.db_value
        display_text = option_klass.label
        if(send(id_klasses).has_key?(letter))
          raise StateObjects::Error.new "Duplicate key during state_objects :" + id + ".  key: " + 
                 letter + ' for text: ' + display_text
        end
        send(id_klasses)[letter] = option_klass
        module_eval <<-EOF2
          def #{id}_#{option_klass.symbol}?
            self.#{id} == '#{letter}'
          end
          def #{id}_#{option_klass.symbol}!
            self.#{id} = '#{letter}'
          end
          def self.#{id}_#{option_klass.symbol}_occurs
            "(#{id} ='#{letter}')"
          end
        EOF2
      end # opts.each
    end # state_objects
  end  # ModelAdditions
end # StateObjects


