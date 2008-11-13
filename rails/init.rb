require 'foreign_domain_routing'

ActionController::Base.send :include, ForeignDomainRouting::Controller

RAILS_DEFAULT_LOGGER.info("** ForeignDomainRouting: initialized properly")