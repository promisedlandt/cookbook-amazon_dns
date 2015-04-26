if defined?(ChefSpec)
  def create_amazon_dns_zone(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:amazon_dns_zone, :create, resource_name)
  end

  def create_or_update_amazon_dns_record(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:amazon_dns_record, :create_or_update, resource_name)
  end
end
