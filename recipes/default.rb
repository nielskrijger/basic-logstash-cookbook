include_recipe "ark"
include_recipe "basic-java"

#
# Create user and group
#

group node['logstash']['group'] do
  system true
  gid node['logstash']['gid']
end

user node['logstash']['user'] do
  group node['logstash']['group']
  home node['logstash']['homedir']
  system true
  action :create
  manage_home true
  uid node['logstash']['uid']
end

#
# Create directories and files
#

directory node['logstash']['install_dir'] do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end

directory node['logstash']['conf_dir'] do
  action :create
  recursive true
  owner node['logstash']['user']
  group node['logstash']['group']
  mode '0755'
end

directory File.dirname(node['logstash']['log_file']) do
  action :create
  recursive true
  owner node['logstash']['user']
  group node['logstash']['group']
  mode '0755'
end

file node['logstash']['log_file'] do
  owner node['logstash']['user']
  group node['logstash']['group']
  mode '0644'
  action :create_if_missing
end

#
# Install logstash
#

ark "logstash" do
  url node['logstash']['url']
  owner node['logstash']['user']
  group node['logstash']['group']
  version node['logstash']['version']
  prefix_root node['logstash']['install_dir']
  prefix_home node['logstash']['install_dir']

  not_if do
    link = "#{node['logstash']['dir']}"
    target = "#{node['logstash']['install_dir']}/logstash-v#{node['logstash']['version']}"
    binary = "#{target}/bin/logstash"

    ::File.directory?(target) && ::File.symlink?(link) && ::File.readlink(link) == target && ::File.exists?(binary)
  end
end

#
# Create Logstash configuration
#

template "/etc/init/logstash.conf" do
  mode '0644'
  source "init.logstash.conf.erb"
end

service "logstash" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end