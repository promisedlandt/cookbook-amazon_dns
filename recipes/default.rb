#
# Cookbook Name:: amazon_dns
# Recipe:: default
#
# Copyright (C) 2013 Nils Landt
#
# All rights reserved - Do Not Redistribute
#

include_recipe "gem_installation"

gem_installation "fog"
