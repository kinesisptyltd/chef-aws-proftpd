#
# Cookbook Name:: aws-proftpd
# Recipe:: logging
#
# Author:: Christopher Chow (<chris@chowie.net>)
#
# Copyright 2014, Christopher Chow
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

logrotate_app "proftpd-modules" do
  cookbook "logrotate"
  path [
    node["proftpd"]["system_log"],
    node["proftpd"]["transfer_log"],
    node["proftpd"]["sql"]["log"],
    node["proftpd"]["sftp"]["log"],
    node["proftpd"]["ban"]["log"]
  ]
  options   ["missingok", "compress", "delaycompress", "notifempty"]
  frequency "weekly"
  rotate    7
  create    "640 adm"
  postrotate <<-EOF
   restart rsyslog >/dev/null 2>&1 || true
   invoke-rc.d proftpd restart 2>/dev/null >/dev/null || true
  EOF
end

directory "/var/log/proftpd" do
  recursive true
  owner "root"
  group "adm"
  action :create
end

[
  node["proftpd"]["system_log"],
  node["proftpd"]["transfer_log"],
  node["proftpd"]["sql"]["log"],
  node["proftpd"]["sftp"]["log"],
  node["proftpd"]["ban"]["log"]
].each do |log|
  file(log) do
    mode "0640"
    owner "root"
    group "adm"
    action :create
  end
end

["main", "xfer", "ban", "sftp"].each do |log|
  rsyslog_papertrail_log_file "proftpd-#{log}" do
    file "/var/log/proftpd/#{log}.log"
    host node["base"]["logging"]["papertrail"]["operations"]["host"]
    port node["base"]["logging"]["papertrail"]["operations"]["port"]
    notifies :restart, "service[rsyslog]", :delayed
  end

  rsyslog_papertrail_log_program "proftpd-#{log}" do
    program "proftpd-#{log}"
    host node["base"]["logging"]["papertrail"]["operations"]["host"]
    port node["base"]["logging"]["papertrail"]["operations"]["port"]
    notifies :restart, "service[rsyslog]", :delayed
  end
end
