# It's helpers class
class CleanerHelper
  # It's class for dirs who must to be clean.
  class Dir
    attr_reader :directory, :exclude, :notify 
    attr_accessor :files_to_remove, :files_to_keep, :files, :report
    def initialize(new_recource)
      @directory = Pathname(new_recource.directory)
      @exclude = Array(new_recource.exclude)
      @report = new_recource.report
      @notify = Array(new_recource.notify)
      @recursive = new_recource.recursive
      @files_to_remove = Array.new
      @files_to_keep = Array.new
    end
    def report?
      @report
    end
    def recursive?
      @recursive
    end
  end
end
class Chef
  class Recipe
    class Cleaner
      # Module for mixin with global object in providers/default.rb
      module Helpers
        def make_clean(new_recource = {})
          Chef::Recipe::Cleaner.start_clean(new_recource)
        end
      end
      # Create CleanerHelper::Dir object and push it to @@values array
      def self.start_clean(new_recource)
        dir = CleanerHelper::Dir.new(new_recource)
        @@values ||= []
        @@values.push dir
        dir
      end
      def self.clean_list
        @@values ||= []
        @@values
      end
    end
  end
end