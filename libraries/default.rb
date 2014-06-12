class Chef
  class Recipe
    class Cleaner
      module Helpers
        def make_clean(value = {})
          Chef::Recipe::Cleaner.start_clean(value)
        end
      end
      def self.start_clean(value = {})
        @@values ||= []
        @@values.push value
      end
      def self.clean_list
        @@values ||= []
        @@values
      end
    end
  end
end