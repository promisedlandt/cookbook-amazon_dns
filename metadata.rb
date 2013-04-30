name             "amazon_dns"
maintainer       "Nils Landt"
maintainer_email "cookbooks@promisedlandt.de"
license          "MIT"
description      "Manage Amazon Route 53 DNS system"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

# https://github.com/promisedlandt/cookbook-gem_installation
%w(gem_installation).each { |dep| depends dep }

%w(ubuntu debian).each { |os| supports os }
