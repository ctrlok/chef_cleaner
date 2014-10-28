Chef::Config.send('report_handlers') << Chef::Handler::Cleaner.new
