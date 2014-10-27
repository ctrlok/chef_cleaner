include Chef::Recipe::Cleaner::Helpers

action :make_clean do
  make_clean new_resource
end

action :report do
  instance = make_clean new_resource
  instance.report = true
end