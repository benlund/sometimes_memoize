module SometimesMemoize

  module ClassMethods
  
    def sometimes_memoized_instance_variable_names
      @sometimes_memoized_instance_variable_names ||= []
    end

    def sometimes_memoize(method_name)
      original_method_name = "#{method_name}_unmemoized"
      alias_method original_method_name, method_name
      self.sometimes_memoized_instance_variable_names << method_name
      define_method method_name do
        if self.currently_memoizing?
          if (val = self.instance_variable_get("@#{method_name}")).nil?
            val = self.send(original_method_name)
            self.instance_variable_set("@#{method_name}", val)            
          end
          val
        else
          self.send(original_method_name)
        end
      end
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def memoizing
    @currently_memoizing = true
    begin
      yield
    ensure
      @currently_memoizing = false
      self.class.sometimes_memoized_instance_variable_names.each{|mn| self.instance_variable_set("@#{mn}", nil)}
    end
  end

  def currently_memoizing?
    !!@currently_memoizing
  end

  def sometimes_memoizing(instance_variable_name)
    self.class.sometimes_memoized_instance_variable_names << instance_variable_name
    if self.currently_memoizing?
      if (val = self.instance_variable_get("@#{instance_variable_name}")).nil?
        val = yield
        self.instance_variable_set("@#{instance_variable_name}", val)
      end
      val
    else
      yield
    end
  end

end
