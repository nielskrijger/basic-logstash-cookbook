default['logstash']['dir'] = '/opt/logstash'
default['logstash']['user'] = 'logstash'
default['logstash']['uid'] = nil # set to nil to let system pick
default['logstash']['group'] = 'logstash'
default['logstash']['gid'] = nil # set to nil to let system pick
default['logstash']['version'] = '1.4.0'
default['logstash']['url'] = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.zip'
default['logstash']['homedir'] = '/var/lib/logstash'
default['logstash']['pid_dir'] = '/var/run/logstash'
default['logstash']['pid_file'] = '/var/run/logstash'

default['logstash']['indexer']['home'] = "#{node['logstash']['dir']}/indexer"
default['logstash']['indexer']['xms'] = '512m'
default['logstash']['indexer']['xmx'] = '512m'
default['logstash']['indexer']['conf_file'] = '/etc/indexer.conf'
default['logstash']['indexer']['log_file'] = '/var/log/logstash-indexer.out'