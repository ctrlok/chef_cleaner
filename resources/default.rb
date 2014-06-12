actions(:make_clean)
default_action(:make_clean)

attribute(:directory, kind_of: String, name_attribute: true)
attribute(:exclude, kind_of: Array, :default => [])
attribute(:report_only, kind_of: [TrueClass, FalseClass], :default => false)
attribute(:notify, kind_of: String, :default => nil)
