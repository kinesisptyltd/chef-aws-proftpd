#
# Cookbook Name:: aws-proftpd
# Recipe:: network
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

include_recipe "openssh"
include_recipe "iptables"

package "ipset" do
  action :install
end

cookbook_file "/usr/local/bin/blacklists.sh" do
  source "blacklists.sh"
  owner "root"
  group "root"
  mode "755"
end

cookbook_file "/etc/rsyslog.d/30-blacklist.conf" do
  source "30-blacklist.conf"
  owner "root"
  group "root"
  notifies :restart, "service[rsyslog]"
end

execute "/usr/local/bin/blacklists.sh" do
  user "root"
  not_if { File.exist?("/var/lib/blacklists/blacklists.out") }
end

cron "blacklists-reboot" do
  time :reboot
  user "root"
  command "/usr/local/bin/blacklists.sh"
end

cron "blacklists-daily" do
  time :daily
  user "root"
  command "/usr/local/bin/blacklists.sh"
end

logrotate_app "blacklists" do
  cookbook  "logrotate"
  path      "/var/log/blacklists.log"
  options   ["missingok", "notifempty", "compress", "delaycompress", "sharedscripts"]
  rotate    4
  create    "644 root adm"
  postrotate "reload rsyslog >/dev/null 2>&1 || true"
end

if node[:proftpd][:backup][:bucket]
  cron "backup" do
    minute "5"
    user "root"
    command "/usr/local/bin/aws --region ap-southeast-2 s3 sync #{node[:proftpd][:data_directory]}/proftpd s3://#{node[:proftpd][:backup][:bucket]}"
  end
end
