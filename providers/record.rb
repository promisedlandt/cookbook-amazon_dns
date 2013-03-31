include AmazonDNS::Connection

action :create_or_update do
  Chef::Log.fatal "Neither domain nor zone_id are set for #{ new_resource.name }, skipping" unless new_resource.domain || new_resource.zone_id
  Chef::Log.fatal "Neither value nor alias_target are set for #{ new_resource.name }, skipping" unless new_resource.value || new_resource.alias_target

  zone = nil
  ttl = new_resource.ttl.to_s

  if new_resource.zone_id
    # user has helpfully provided the zone_id
    zone = dns_connection.zones.get(new_resource.zone_id)
  else
    domain_name = new_resource.domain[-1] == "." ? new_resource.domain : new_resource.domain + "."
    dns_connection.zones.each do |dns_zone|
      if dns_zone.domain == domain_name
        zone = dns_zone
        break
      end
    end
  end

  if zone
    # Unlike the Web UI, setting a record via API needs full name, e.g. "subdomain.example.com" instead of just "subdomain"
    name_regexp = Regexp.new("#{ zone.domain.chomp(".") }\.?$")
    if name_regexp.match(new_resource.name)
      name = new_resource.name
    else
      name = "#{ new_resource.name }.#{ zone.domain }"
    end

    record_attributes = { :name => name,
                          :type => new_resource.type,
                          :value => Array(new_resource.value),
                          :alias_target => new_resource.alias_target,
                          :weight => new_resource.weight,
                          :ttl => ttl }

    Chef::Log.info "Checking if Route53 DNS record exists: #{ new_resource.name }"

    if record = zone.records.get(name, new_resource.type)
      if record.ttl == record_attributes[:ttl] &&
          (Array(record.value) == record_attributes[:value] || Array(record.alias_target) == record_attributes[:alias_target])

        # We're good
        Chef::Log.info "Record exists, nothing to update"
      else
        Chef::Log.info "Updating Route53 DNS record #{ new_resource.name }"
        record.modify(record_attributes)
      end
    else
      Chef::Log.info "Creating Route53 DNS record #{ new_resource.name }"
      zone.records.create(record_attributes)
    end
  else
    Chef::Log.fatal "Could not find zone for #{ new_resource.name }, zones #{ dns_connection.zones.collect { |zone| zone.domain }.join(", ") }"
  end

end
