# chef_cleaner 

Simple chef handler to remove files who was not updated by chef in the specific directory. 

## Supported Platforms

Tested on Ubuntu 12.04, but may work on almost all linux platforms.

## Usage

### For init handler — include chef_cleaner into your run_list

Include `chef_cleaner` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[chef_cleaner::default]"
  ]
}
```

### chef_cleaner resource

For starting cleaning in directory use chef_cleaner resource:

```ruby
chef_cleaner "/tmp/1"
```

There is additional attributes:
 * recursive - For recursive check files in dir. *Default*: false (TrueFalse)
 * exclude - Array of exclude files in dir (May be Regexp or local path or global path) (String or Regexp or Array)
 * report - for testing, if you not sure what you want to clean. *Default*: false (TrueFalse)
 * notify - run some command if cleaner remove some files (String or Array)

 Actions:
 * :make_clean - Default action
 * :report - Make report, not remove files

 Examples:

```ruby
chef_cleaner "/etc/sensu/conf.d/checks" do
  exclude "my_new_check.json"
  notify "\`service sensu-client restart\`"
end
```

```ruby
chef_cleaner "/etc/nginx/site-enables" do
  recursive true
  action :report
end
```

```ruby
chef_cleaner "Custom name" do
  directory "/tmp/test_directory_7"
  recursive true
  exclude [/.*regexp$/, "subdir_created_with_bash/created_with_bash", "/subdir_created_with_chef/created_with_bash", "/tmp/test_directory_7/subdir_created_with_bash/created_with_bash_other"]
end
```

## Testing

1. Modify test.rb recipe
2. Just run `vagrant up`


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Grammarly, Inc. (<ctrlok@gmail.com>)
