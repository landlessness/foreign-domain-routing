module ForeignDomainRouting
  module RouteExtensions
    def self.included(base)
      base.alias_method_chain :recognition_conditions, :foreign_domain
    end

    def recognition_conditions_with_foreign_domain
      result = recognition_conditions_without_foreign_domain
      result << "ForeignDomainRouting.foreign_domain?(env[:host])" if conditions[:foreign_domain] == true
      result << "!ForeignDomainRouting.foreign_domain?(env[:host])" if conditions[:foreign_domain] == false
      result
    end
  end

  module RouteSetExtensions
    def self.included(base)
      base.alias_method_chain :extract_request_environment, :foreign_domain
    end

    def extract_request_environment_with_foreign_domain(request)
      extract_request_environment_without_foreign_domain(request).merge({ :host => request.host })
    end
  end
end

ActionController::Routing::RouteSet.send :include, ForeignDomainRouting::RouteSetExtensions
ActionController::Routing::Route.send :include, ForeignDomainRouting::RouteExtensions