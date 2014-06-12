# encoding: utf-8
require 'rubygems'
require 'chef/handler'
require 'pry'

class Chef
  class Handler
    class Cleaner< Chef::Handler
      attr_reader :config
      def initialize(config = {})
        @files_nodelete ||= Array.new
        @marked ||= Array.new
        @config = config 
      end
      def report
        for dir in Chef::Recipe::Cleaner.clean_list
          @files_nodelete += nondelete(dir)
        end
        for dir in Chef::Recipe::Cleaner.clean_list
          clean(dir)
        end
      end

      private
      def mark(dir)
        Dir.open(dir[:directory]).select do |file|
          unless [".",".."].member?(file)
            unless @files_nodelete.member? File.join(dir[:directory], file) 
              unless dir[:exclude].member? file
                unless File.directory?(file)
                  if file.scan("/").empty?
                    file
                  end
                end
              end
            end
          end
        end
      end
      def remove_files(dir, marked)
        unless marked.empty?
          puts("Marked files for #{dir[:directory]} is:\n\t#{marked.join("\n\t")}")
          unless dir[:report_only]
            puts("Remove:\n")
            for file in marked
              File.delete(file)
              puts("\t#{file}")
            end
          end
        end
      end
      def nondelete(dir)
        array = all_resources.find_all do |i|
          if i.respond_to? "path"
              i.path =~ Regexp.new(dir[:directory])
          end
        end
        array.map do |resource|
          resource.path
        end
      end
      def clean(dir)
        marked = mark(dir)
        marked.map! do |file|
          File.join(dir[:directory], file) 
        end
        nil
        remove_files(dir, marked)
        unless dir[:notify].nil?
          unless dir[:report_only]
            puts "Running notify"
            `dir[:notify]`
          end
        end

      end
    end
  end
end