actions :create

default_action :create

attribute :name,                  :kind_of => String
attribute :comment,               :kind_of => String, :default => ""
attribute :aws_access_key_id,     :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
