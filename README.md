# chef_cleaner 

Simple chef handler to remove files who was not updated by chef in the specific directory. 

## Supported Platforms

Tested on Ubuntu 12.04, but may work on almost all linux platforms.
*WARNING* - now it works only with patched chef_handler cookbook. I create pull request to opscode chef_handler and you can check his status: https://github.com/opscode-cookbooks/chef_handler/pull/15

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

### make_clean resource

For starting cleaning in directory use make_clean resource:

```ruby
make_clean "/tmp/1"
```

There is additional attributes:
 * exclude - Array of exclude files in dir
 * report_only - for testing, if you not sure what you want to clean 
 * notify - run some command if cleaner remove some files

```ruby
make_clean "/etc/sensu/conf.d/checks" do
  exclude ["my_new_check.json"]
  notify `service sensu-client restart`
end
```
## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Grammarly, Inc. (<ctrlok@gmail.com>)
