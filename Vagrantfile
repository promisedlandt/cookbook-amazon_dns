# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "amazon-dns-berkshelf"

  config.omnibus.chef_version = :latest

  config.vm.box = "opscode-debian-7.8"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_debian-7.8_chef-provisionerless.box"

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      "recipe[amazon_dns::default]",
      "recipe[amazon_dns::_development]"
    ]
  end
end
