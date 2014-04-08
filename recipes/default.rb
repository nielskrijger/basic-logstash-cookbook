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

directory node['logstash']['dir'] do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end

# To install Logstash, do the following:
# 1. Download logstash from remote location
# 2. Unzip remote file in Chef cache directory
# 3. Move extracted contents to target directory
#
=begin
src_filename = "logstash-v#{node['logstash']['version']}.zip"
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{Chef::Config['file_cache_path']}/logstash-v#{node['logstash']['version']}"

remote_file src_filepath do
  source node['logstash']['url']
  owner 'root'
  group 'root'
  mode '0644'
end

bash 'install_logstash' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    unzip #{src_filename} -d #{extract_path}
    mv #{extract_path}/*/* #{node['logstash']['dir']}/
  EOH
  not_if { ::File.exists?(extract_path) } # Do not run when file has already been extracted
end
=end

ark "logstash" do
  url node['logstash']['url']
  owner node['logstash']['user']
  group node['logstash']['group']
  version node['logstash']['version']
  prefix_root node['logstash']['dir']
  prefix_home node['logstash']['dir']

  notifies :start, 'service[basic-logstash]' unless node.elasticsearch[:skip_start]
  #notifies :restart, 'service[elasticsearch]' unless node.elasticsearch[:skip_restart]

  not_if do
    link = "#{node['logstash']['dir']}/logstash"
    target = "#{node['logstash']['dir']}/logstash-v#{node.elasticsearch[:version]}"
    binary = "#{target}/bin/logstash"

    ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target && ::File.exists?(binary)
  end
end

template "/etc/init/logstash_indexer.conf" do
  mode '0644'
  source "init.logstash_indexer.conf.erb"
end

service "logstash_indexer" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start, :stop]
end