module StateObjects
  class Base

    def initialize(model)
      @model = model               
    end

    def self.state_object_values(*opts)  # :nodoc:
      class_eval <<-EOF
        def self.symbol
          '#{opts[0]}'.to_sym
        end
        def self.db_value
          '#{opts[1]}'
        end
        def self.label
          '#{opts[2]}'
        end
      EOF
    end

    protected 
      def model
        @model
      end

  end
end
