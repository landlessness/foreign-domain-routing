require 'foreign_domain_routing/routing_extensions'

module ForeignDomainRouting
  DEFAULT_NATIVE_DOMAINS = {:development => ['localhost:3000'], :staging => ['staging.example.com'], :production => ['example.com'] }
  mattr_accessor :init_native_domains
  @@init_native_domains = DEFAULT_NATIVE_DOMAINS.dup
    
  def self.native_domains
    init_native_domains[RAILS_ENV.to_sym]
  end
  
  def self.native_domains=(value)
    init_native_domains[RAILS_ENV.to_sym] = value
  end

  def self.foreign_domain?(host)
    native_domains.each do |domain|
      return false if host =~ /#{domain}\Z/i
    end
    true
  end
  
  module Controller
    def self.included(controller)
      controller.helper_method(:foreign_domain?)
    end
    
    protected
    
    def foreign_domain?
      ForeignDomainRouting.foreign_domain?(request.host)
    end
  end
end