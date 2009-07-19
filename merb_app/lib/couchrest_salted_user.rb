class Merb::Authentication
  module Mixins
    module SaltedUser
      module CouchRestClassMethods
        def self.extended(base)
          base.class_eval do
            
            property :crypted_password
            property :salt
            
            validates_present        :password, :if => proc{|m| m.password_required?}
            validates_is_confirmed   :password, :if => proc{|m| m.password_required?}
            
            def save
              encrypt_password
              super
            end
          end # base.class_eval
          
        end # self.extended
        
        def authenticate(login, password)
          @u = by_login(:key => login).first
          @u && @u.authenticated?(password) ? @u : nil
        end
      end # DMClassMethods      
    end # SaltedUser
  end # Mixins
end # Merb::Authentication
