# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'parallels'
    config.vm.box = "parallels/ubuntu-12.04"
    config.vm.provider "parallels" do |v|
        v.optimize_power_consumption = false
        v.memory = 512
        v.cpus = 2
        v.update_guest_tools = true
    end
  else
    config.vm.box = "grammaruntu"
    config.vm.provider "virtualbox" do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "2"]
    end
  end
  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = "11.16.4"
  end

  config.vm.network "private_network", ip: "192.168.50.4"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  # config.berkshelf.enabled = false
  config.vm.provision "chef_solo" do |chef|
    # chef.cookbooks_path = ["#{chef_home}/site-cookbooks", "#{chef_home}/vendor/cookbooks", "#{chef_home}/vendor_patched"]
    # chef.cookbooks_path = ["./"]
    # chef.roles_path = "../my-recipes/roles"
    # chef.data_bags_path = "#{chef_home}/data_bags"
    chef.add_recipe "chef_cleaner::test"
    # chef.add_role "web"

    # You may also specify custom JSON attributes:
    # chef.json = { mysql_password: "foo" }
  end
end