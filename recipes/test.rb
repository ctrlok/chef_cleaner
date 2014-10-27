include_recipe "chef_cleaner"

chef_gem "minitest-chef-handler"

require 'minitest-chef-handler'

#### Step 0, Cleaning
bash "Clean all files!" do
  action :nothing
  code "rm -rf /tmp/test_directory*"
end.action(:run)

#### Step 1 -- Basic step

directory "/tmp/test_directory_1" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_1/created_with_bash"
end.action(:run)

file "/tmp/test_directory_1/created_with_chef" do
  action :create
  owner "root"
  group "root"
  mode "0644"
end

class TestChefCleanerStep1 < MiniTest::Chef::TestCase
  def test_files_exist
    assert Dir.exist?("/tmp/test_directory_1"), "Directory not exist!"
    refute File.exist?("/tmp/test_directory_1/created_with_bash"), "File created with bash exist!"
    assert File.exist?("/tmp/test_directory_1/created_with_chef"), "File created with chef not exist!"
  end
end

chef_cleaner "/tmp/test_directory_1"

# Step 2 -- Runing chef without resucrsive

bash "make test dir" do
  action :nothing
  code "mkdir /tmp/test_directory_2"
end.action(:run)

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_2/created_with_bash"
end.action(:run)

file "/tmp/test_directory_2/created_with_chef" do
  content "Test content"
  action :create
  owner "root"
  group "root"
  mode "0644"
end

bash "make test dir" do
  action :nothing
  code "mkdir /tmp/test_directory_2/dir_not_deleted"
end.action(:run)

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_2/dir_not_deleted/file_not_deleted"
end.action(:run)



class TestChefCleanerStep2 < MiniTest::Chef::TestCase
  def test_files_exist
    assert Dir.exist?("/tmp/test_directory_2"), "Directory not exist!"
    refute File.exist?("/tmp/test_directory_2/created_with_bash"), "File created with bash exist!"
    assert File.exist?("/tmp/test_directory_2/created_with_chef"), "File created with chef not exist!"
    assert Dir.exist?("/tmp/test_directory_2/dir_not_deleted"), "Directory not exist, but created with chef"
    assert File.exist?("/tmp/test_directory_2/dir_not_deleted/file_not_deleted"), "File created without chef and not exit with non recursive clean"
  end
end

chef_cleaner "/tmp/test_directory_2"

# Step 3

bash "make test dir" do
  action :nothing
  code "mkdir /tmp/test_directory_3"
end.action(:run)


bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_3/created_with_bash"
end.action(:run)

file "/tmp/test_directory_3/created_with_chef" do
  content "Test content"
  action :create
  owner "root"
  group "root"
  mode "0644"
end


directory "/tmp/test_directory_3/subdir_created_with_chef" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_3/subdir_created_with_chef/created_with_bash"
end.action(:run)


file "/tmp/test_directory_3/subdir_created_with_chef/created_with_chef" do
  content "Test content"
  action :create
  owner "root"
  group "root"
  mode "0644"
end

bash "make test dir" do
  action :nothing
  code "mkdir /tmp/test_directory_3/subdir_created_with_bash"
end.action(:run)

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_3/subdir_created_with_bash/created_with_bash"
end.action(:run)

file "/tmp/test_directory_3/subdir_created_with_bash/created_with_chef" do
  content "Test content"
  action :create
  owner "root"
  group "root"
  mode "0644"
end


class TestChefCleanerStep3 < MiniTest::Chef::TestCase
  def test_files_exist
    assert Dir.exist?("/tmp/test_directory_3"), "Directory not exist!"
    refute File.exist?("/tmp/test_directory_3/created_with_bash"), "File created with bash exist!"
    assert File.exist?("/tmp/test_directory_3/created_with_chef"), "File created with chef not exist!"
    assert Dir.exist?("/tmp/test_directory_3/subdir_created_with_chef"), "Directory not exist!"
    refute File.exist?("/tmp/test_directory_3/subdir_created_with_chef/created_with_bash"), "File created with bash exist!"
    assert File.exist?("/tmp/test_directory_3/subdir_created_with_chef/created_with_chef"), "File created with chef not exist!"
    assert Dir.exist?("/tmp/test_directory_3/subdir_created_with_bash"), "Directory not exist!"
    refute File.exist?("/tmp/test_directory_3/subdir_created_with_bash/created_with_bash"), "File created with bash exist!"
    assert File.exist?("/tmp/test_directory_3/subdir_created_with_bash/created_with_chef"), "File created with chef not exist!"
  end
end

chef_cleaner "Custom name" do
  directory "/tmp/test_directory_3"
  recursive true
end

# Step 4 -- notify
directory "/tmp/test_directory_4" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_4/created_with_bash"
end.action(:run)

fail if File.exist?("/tmp/touchfile")

chef_cleaner "/tmp/test_directory_4" do
  notify "`touch /tmp/touchfile`"
end


class TestChefCleanerStep4 < MiniTest::Chef::TestCase
  def test_notify
    assert File.exist?("/tmp/touchfile"), "File created with notify don't exist"
    assert File.delete("/tmp/touchfile") == 1
  end
end


# Step 5 -- don't run notify if all fine

directory "/tmp/test_directory_5" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

file "/tmp/test_directory_5/chef_file" do
  action :create
  owner "root"
  group "root"
  mode "0644"
end


chef_cleaner "/tmp/test_directory_5" do
  notify "`touch /tmp/touchfile2`"
end


class TestChefCleanerStep5 < MiniTest::Chef::TestCase
  def test_notify
    refute File.exist?("/tmp/touchfile2"), "Notify create file, but won't"
  end
end


# Step 6

directory "/tmp/test_directory_6" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_6/created_with_bash"
end.action(:run)

chef_cleaner "/tmp/test_directory_6" do
  action :report
end


class TestChefCleanerStep6 < MiniTest::Chef::TestCase
  def test_report
    assert File.exist?("/tmp/test_directory_6/created_with_bash"), "File created in report mode don't exist"
  end
end

# Step 7 

bash "make test dir" do
  action :nothing
  code "mkdir /tmp/test_directory_7"
end.action(:run)


bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_7/created_with_bash"
end.action(:run)

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_7/created_with_bash_regexp"
end.action(:run)

file "/tmp/test_directory_7/created_with_chef" do
  content "Test content"
  action :create
  owner "root"
  group "root"
  mode "0644"
end


directory "/tmp/test_directory_7/subdir_created_with_chef" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_7/subdir_created_with_chef/created_with_bash"
end.action(:run)


file "/tmp/test_directory_7/subdir_created_with_chef/created_with_chef" do
  content "Test content"
  action :create
  owner "root"
  group "root"
  mode "0644"
end

bash "make test dir" do
  action :nothing
  code "mkdir /tmp/test_directory_7/subdir_created_with_bash"
end.action(:run)

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_7/subdir_created_with_bash/created_with_bash"
end.action(:run)

bash "Make test file" do
  action :nothing
  code "touch /tmp/test_directory_7/subdir_created_with_bash/created_with_bash_other"
end.action(:run)

file "/tmp/test_directory_7/subdir_created_with_bash/created_with_chef" do
  content "Test content"
  action :create
  owner "root"
  group "root"
  mode "0644"
end


class TestChefCleanerStep7 < MiniTest::Chef::TestCase
  def test_files_exist
    assert Dir.exist?("/tmp/test_directory_7"), "Directory not exist!"
    refute File.exist?("/tmp/test_directory_7/created_with_bash"), "File created with bash exist!"
    assert File.exist?("/tmp/test_directory_7/created_with_bash_regexp"), "File created with bash and exclude by regexp not exist!"
    assert File.exist?("/tmp/test_directory_7/created_with_chef"), "File created with chef not exist!"
    assert Dir.exist?("/tmp/test_directory_7/subdir_created_with_chef"), "Directory not exist!"
    refute File.exist?("/tmp/test_directory_7/subdir_created_with_chef/created_with_bash"), "File created with bash exist!"
    assert File.exist?("/tmp/test_directory_7/subdir_created_with_chef/created_with_chef"), "File created with chef not exist!"
    assert Dir.exist?("/tmp/test_directory_7/subdir_created_with_bash"), "Directory not exist!"
    assert File.exist?("/tmp/test_directory_7/subdir_created_with_bash/created_with_bash"), "File created with bash and excluded by path not exist!"
    assert File.exist?("/tmp/test_directory_7/subdir_created_with_bash/created_with_bash_other"), "File created with bash and excluded by global path not exist!"
    assert File.exist?("/tmp/test_directory_7/subdir_created_with_bash/created_with_chef"), "File created with chef not exist!"
  end
end

chef_cleaner "Custom name" do
  directory "/tmp/test_directory_7"
  recursive true
  exclude [/.*regexp$/, "subdir_created_with_bash/created_with_bash", "/subdir_created_with_chef/created_with_bash", "/tmp/test_directory_7/subdir_created_with_bash/created_with_bash_other"]
end


# Run tests!



Chef::Config.send('report_handlers') << MiniTest::Chef::Handler.new

