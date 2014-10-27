actions(:make_clean)
actions(:report)
default_action(:make_clean)

attribute(:directory, kind_of: String, name_attribute: true)
attribute(:exclude)
attribute(:report, kind_of: [TrueClass, FalseClass], :default => false)
attribute(:recursive, kind_of: [TrueClass, FalseClass], :default => false)
attribute(:notify, kind_of: String, :default => nil)
