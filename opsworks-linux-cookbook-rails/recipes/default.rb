include_recipe 'build-essential'

app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}"

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
  end

  ruby_runtime '2.2'
  ruby_gem 'rake'

  bundle_install do
    deployment true
    without %w{development test}
  end

  rails do
    database 'sqlite3:///db.sqlite3'
    migrate true
  end

  unicorn do
    port 8000
  end
end
