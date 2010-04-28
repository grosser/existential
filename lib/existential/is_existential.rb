module Existential
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def is_existential
      send :include, InstanceMethods
    end
  end
  
  module InstanceMethods
    def can?(action, object)
      method = "allows_" << action.to_s << "_for?"
      if object.respond_to?(action)
        return object.send(method, self)
      end

      case action.to_sym
      when :show, :view then true
      else is_owner_of?(object)
      end
    end

    def is_owner_of?(object)
      return true if object == self
      return true if object.respond_to?(:user_id) and object.user_id == id
      return true if repond_to?(:admin?) and admin?
      false
    end
  end
end

ActiveRecord::Base.send :include, Existential
