include AmazonDNS::Connection

action :create do
  domain_name = new_resource.name[-1] == "." ? new_resource.name : new_resource.name + "."
  Chef::Log.info "Checking if Route53 zone exists: #{ domain_name }"

  zone_exists = false

  dns_connection.zones.each do |zone|
    # Maybe we don't have to do anything
    if zone.domain == domain_name
      zone_exists = true

      if zone.description.to_s == new_resource.comment
        Chef::Log.info "Already exists, nothing to do"
        zone_exists = true
      else
        # Updating is not supported by Amazon API. Destroying seems annoying with the zone id changes. May change in future
        Chef::Log.warn "Zone #{ domain_name } already exists, but can't update comment"
      end
    end
  end

  unless zone_exists
    Chef::Log.info "Creating Route53 zone #{ new_resource.name }"
    dns_connection.create_hosted_zone(new_resource.name, :comment => new_resource.comment)
  end
end
