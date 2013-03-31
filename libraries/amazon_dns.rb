module AmazonDNS
  module Connection
    def dns_connection
      begin
        require "fog"
        Excon.defaults[:ssl_verify_peer] = false
      rescue LoadError
        Chef::Log.warn("Missing gem 'fog'")
      end

      @@dns_connection ||= ::Fog::DNS.new(:provider => "aws",
                                          :aws_access_key_id => new_resource.aws_access_key_id || node[:amazon_dns][:aws_access_key_id],
                                          :aws_secret_access_key => new_resource.aws_secret_access_key || node[:amazon_dns][:aws_secret_access_key])
    end
  end
end
