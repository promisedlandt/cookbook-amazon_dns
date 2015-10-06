actions :create_or_update

default_action :create_or_update

attribute :name,                  :kind_of => String
attribute :domain,                :kind_of => String
attribute :zone_id,               :kind_of => String
attribute :value,                 :kind_of => [String, Array]
attribute :addvalue,              :kind_of => [String, Array]
attribute :alias_target,          :kind_of => Hash
attribute :type,                  :kind_of => String, :equal_to => ["A", "CNAME", "MX", "SPF", "URL", "TXT", "NS", "SRV", "NAPTR", "PTR", "AAA", "SSHFP", "HFINO"], :default => "A"
attribute :ttl,                   :kind_of => [Integer, String], :default => 3600
attribute :weight,                :kind_of => [Integer, String], :callbacks => { "must be between 0 and 255" => Proc.new { |weight| weight.to_i.between?(0, 255) } }
attribute :aws_access_key_id,     :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
