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

include_recipe "rsyslog::default"

package "rsyslog-gnutls" do
  action :install
  notifies :restart, resources("service[rsyslog]")
end

# https://bugs.launchpad.net/ubuntu/+source/rsyslog/+bug/940030
logrotate_app "rsyslog" do
  cookbook  "logrotate"
  path      "/var/log/syslog"
  options   ["missingok", "delaycompress", "notifempty"]
  frequency "daily"
  rotate    7
  create    "640 syslog adm"
  postrotate "reload rsyslog >/dev/null 2>&1 || true"
end

logrotate_app "rsyslog-other" do
  cookbook  "logrotate"
  path      [
    "/var/log/mail.info",
    "/var/log/mail.warn",
    "/var/log/mail.err",
    "/var/log/mail.log",
    "/var/log/daemon.log",
    "/var/log/kern.log",
    "/var/log/auth.log",
    "/var/log/user.log",
    "/var/log/lpr.log",
    "/var/log/cron.log",
    "/var/log/debug",
    "/var/log/messages"
  ]
  options   ["missingok", "delaycompress", "notifempty"]
  frequency "weekly"
  rotate    4
  create    "644 syslog adm"
  postrotate "restart rsyslog >/dev/null 2>&1 || true"
end

logrotate_app "proftpd-modules" do
  cookbook  "logrotate"
  path      [
    "/var/log/proftpd/ban.log",
    "/var/log/proftpd/sftp.log",
    "/var/log/proftpd/sql.log"
  ]
  options   ["missingok", "compress", "delaycompress", "notifempty"]
  frequency "weekly"
  rotate    7
  create    "640 root adm"
  postrotate <<-EOF
   restart rsyslog >/dev/null 2>&1 || true
   invoke-rc.d proftpd restart 2>/dev/null >/dev/null || true
  EOF
end

["xfer", "ban", "sftp", "sql"].each do |log|
  base_papertrail "proftpd-#{log}" do
    tag "proftpd-#{log}"
    facility node["proftpd"]["syslog"]["facility"]
    file "/var/log/proftpd/#{log}.log"
    host node["proftpd"]["syslog"]["host"]
    port node["proftpd"]["syslog"]["port"]
  end
end

base_papertrail "proftpd-main" do
  tag "proftpd-main"
  facility node["proftpd"]["syslog"]["facility"]
  file "/var/log/proftpd/proftpd.log"
  host node["proftpd"]["syslog"]["host"]
  port node["proftpd"]["syslog"]["port"]
end
