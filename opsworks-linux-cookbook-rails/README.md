# opsworks-linux-cookbook-rails Cookbook

## Requirements

* Signed up for an AWS account
* IAM User credentials
* Service Access Permissions enabled on your IAM user
* [AWS Command Line Tool (AWS CLI)](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed on your workstation.
* `bash` or equivalent shell

### Platforms

* Tested and verified on Amazon Linux 2015.09
* Tested and verified on Ubuntu 14.04

### Chef
- Chef 12+


### Cookbooks
- application_ruby
- build-essential
- poise-ruby


## Usage

* run `berks package`
* upload `cookbooks-*.tar.gz` to the appropriate artifactory repository.
* create stack using custom chef cookbooks
* create custom layer
* add `opsworks-linux-cookbook-rails` as recipe in `setup`
* start instance
* goto http://public IP of your instance/
