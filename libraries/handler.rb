require 'rubygems'
require 'chef/handler'

# This class is handler for chef. Main method is report, all other methods will called from it. 
class Chef
  class Handler
    class Cleaner< Chef::Handler

      # report:: is main method. It will run first. It will do:
      # 1. Recive dir list with arguments 
      # 2. Mark files for remove
      # 3. Remove files
      # 4. Make output
      def report
        dirs = recive_dirs_list
        for dir in dirs
          mark_files(dir)
        end
        # remove_file 
      end
      private

      # Recive dirs list from Chef::Recipe::Cleaner.clean_list
      def recive_dirs_list
        Chef::Recipe::Cleaner.clean_list
      end

      def mark_files(dir)
        dir.files = list_files(dir.directory, dir.recursive?)
        keep_files(dir)
        mark_as_dirty(dir)
        remove_files(dir)
        notify_user(dir)
        run_notify_command(dir)
      end

      # This method for listing files in directory
      def list_files(dirname, recursive)
        array = Array.new
        dirname.each_child do |file|
          file = file.realpath
          if file.directory? && recursive
            array = array + list_files(file, recursive)
          elsif !(file.directory?)
            array = array + Array(file)
          end
        end
        array
      end
      def keep_files(dir)
        # Find all files, who was updated with chef and contain our directory in "path" 
        array = all_resources.find_all{|i| i.path =~ Regexp.new("^" + dir.directory.to_s) if i.respond_to? "path"}
        # Add this files to files_to_keep dir variable
        dir.files_to_keep = array.map{|resource| Pathname(resource.path)}
        # Keep all files who are in exclude list
        for record in dir.exclude
          if record.is_a? Regexp
            # if record in exclude list is Regexp — we keep all files who can be parsed with regexp
            dir.files.each do |file_in| 
              dir.files_to_keep.push(file_in) if record =~ file_in.to_s
            end
          elsif record.respond_to? "to_s"
            file = Pathname(record)
            file = dir.directory + file unless file.absolute?
            dir.files_to_keep.push(file)
          end
        end
      end
      def mark_as_dirty(dir)
        dir.files_to_remove = dir.files - dir.files_to_keep 
      end
      # Remove all files from files_to_remove list, unless report is true
      def remove_files(dir)
        return nil if dir.report?
        for file in dir.files_to_remove
          file.delete if file.exist?
        end
      end
      def notify_user(dir)
        if dir.files_to_remove
          puts "Dir: #{dir.directory}. Files are maked for remove and " + (dir.report? ? "not removed (report):" : "removed:")
          for file in dir.files_to_remove
            puts "\t#{file}"
          end
          puts " "
        end
      end
      def run_notify_command(dir)
        return nil if dir.notify.empty?
        return nil if dir.report?
        return nil if dir.files_to_remove.empty?
        for command in dir.notify
          puts "Running notify command #{command} for #{dir.directory}"
          eval(command)
          puts "Done\n \n"
        end
      end


    end
  end
end