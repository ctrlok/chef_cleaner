
include Chef::Recipe::Cleaner::Helpers

action :make_clean do
  make_clean :directory => new_resource.directory, 
             :exclude => new_resource.exclude,
             :report_only => new_resource.report_only,
             :notify => new_resource.notify
end