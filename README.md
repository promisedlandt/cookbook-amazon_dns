# amazon_dns

Provides a set of LWRPs to manage Amazon Route 53 entries.

This works as a drop-in replacement for the [official route53 cookbook](http://community.opscode.com/cookbooks/route53), but adds a few features.

# Platforms

Tested on Ubuntu 12.04 and Debian 6.0.6.

# Requirements

Chef 11

# Examples

```
# Create a zone for example.com
amazon_dns_zone "example.com" do
  aws_access_key_id     "ASDASDASDASD"
  aws_secret_access_key "GSDFGSDFDFGF"
end


# Add subdomain1 to example.com
amazon_dns_record "subdomain1" do
  value "192.168.1.1"
  domain "example.com"
  aws_access_key_id     "ASDASDASDASD"
  aws_secret_access_key "GSDFGSDFDFGF"
end

# Let's add a CNAME record
amazon_dns_record "mail" do
  value "ghs.google.com"
  domain "example.com"
  type "CNAME"
  ttl 86400
  aws_access_key_id     "ASDASDASDASD"
  aws_secret_access_key "GSDFGSDFDFGF"
end

# Create an MX record after specifing credentials via node attribute
node.set[:amazon_dns][:aws_access_key_id] = "ASDASDASDASD"
node.set[:amazon_dns][:aws_secret_access_key] = "GSDFGSDFDFGF"

amazon_dns_record "example.com" do
  domain "example.com"
  type "MX"
  value "1 aspmx.l.google.com"
end
```

# Differences from Route53 cookbook

  * Ability to add zones
  * No need to specify zone_id, amazon_dns will look it up for you
  * Alias record support

# Authorization

You can either set the node attributes `node[:amazon_dns][:aws_access_key_id]` and `node[:amazon_dns][:aws_secret_access_key]`, or provide the same values with every resource call.  
See examples above.

# Alias records

Alias records are A or AAAA records that point to S3 Website Endpoints, Elastic Load Balancers or Route 53 record sets in the same zone.  
To utilize alias records, set the `alias_target` attribute of the amazon_dns_record resource to a hash containing the keys `:dns_name` for the endpoint, and `:hosted_zone_id` for the hosted zone id.

# Recipes

## amazon_dns::default

Installs the [fog gem](https://github.com/fog/fog), which is needed for the LWRPs.

# Attributes

Attribute | Description | Type | Default
----------|-------------|------|--------
aws_access_key_id | Access key ID, in case you don't want to specify it every time you call a resource |String
aws_secret_access_key | Secret access key, in case you don't want to specify it every time you call a resource | String

# Resources / Providers

## amazon_dns_zone

Creates a new Route53 zone.

### Attributes

Attribute | Description | Type | Default
----------|-------------|------|--------
name | name of the zone / domain | String | name
comment | Optional comment, will show up in the web interface | String | ""
aws_access_key_id | Your AWS access key ID | String
aws_secret_access_key | Your AWS secret access key | String

### Actions

Name | Description | Default
-----|-------------|--------
create | Create the zone | yes

## amazon_dns_record

### Attributes

Attribute | Description | Type | Default
----------|-------------|------|--------
name | Name of the dns entry, can be "subdomain" or "subdomain.example.com" | String | name
domain | Name of the domain to add the entry to (set this or zone_id) | String |
zone_id | Zone_id of the zone to add the entry to (set this or domain) | String |
value | Value for the DNS record. Not needed for alias records | String, Array | 
alias_target | Targets for alias records. Hash that needs they keys `:dns_name` and `:hosted_zone_id` | Hash
type | DNS record type | String | A
ttl | Time to live | Integer, String | 3600
weight | For weighted record sets | Integer, String |
aws_access_key_id | Your AWS access key ID | String
aws_secret_access_key | Your AWS secret access key | String

### Actions

Name | Description | Default
-----|-------------|--------
create_or_update | Create or update the record | yes
