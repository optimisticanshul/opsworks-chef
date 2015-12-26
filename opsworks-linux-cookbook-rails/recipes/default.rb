include_recipe 'build-essential'

app = search(:aws_opsworks_app).first
Chef::Log.info "Application Details: #{app.inspect}"

app_path = "/srv/#{app['shortname']}"

file "/srv/id_rsa" do
  content "#{app['app_source']['ssh_key']}"
  mode 0600
end

file "/srv/chef_ssh_deploy_wrapper.sh" do
  content  <<-EOF
  #!/bin/sh
  exec ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "/srv/id_rsa" "$@"
  EOF
  mode 0770
end


package node['rails-app']['mysql_package_name']
package value_for_platform_family(debian: 'ruby-dev', rhel: 'ruby-devel')

package 'git' do
  # workaround for:
  # WARNING: The following packages cannot be authenticated!
  # liberror-perl
  # STDERR: E: There are problems and -y was used without --force-yes
  options '--force-yes' if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
end

application app_path do
  git app_path do
    repository app['app_source']['url']
    action :sync
    revision app['app_source']['revision']
    ssh_wrapper "/srv/chef_ssh_deploy_wrapper.sh"
  end

  ruby_runtime '2'
  ruby_gem 'rake'

  bundle_install do
    deployment true
    without %w{development test}
  end

  rails do
    database 'sqlite3:///db.sqlite3'
    migrate app['environment']['RAILS_MIGRATION'] == "true" ? true : false
  end

  unicorn do
    port 8000
  end
end
