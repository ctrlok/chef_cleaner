include_recipe "chef_handler"

chef_handler "Chef::Handler::Cleaner" do
  # source "handler"
  supports :report => true
  arguments [
  ]
  action :nothing
end.run_action(:enable)