module ObjectView
  class AccessRBAC < ApplicationRecord
    def self.allow?(resource, label, role = nil, &block)
      yield if block_given?
      true
    end
    def self.node
      :none
    end
    def self.user
      @user || :nouser
    end
    def self.user=(u)
      @user = u
    end
    def self.explain
      "allways allow"
    end
  end
end
