#
# Cookbook Name:: aws-proftpd
# Recipe:: install
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

include_recipe "apt"

package "proftpd-mod-pgsql" do
  action :install
end

service "proftpd" do
  supports :status => true, :restart => true, :reload => true
end

template "/etc/proftpd/modules.conf" do
  source "modules.conf.erb"
  mode 0644
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
  notifies :restart, resources(:service => "proftpd")
end

template "/etc/proftpd/proftpd.conf" do
  source "proftpd.conf.erb"
  mode 0644
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
  notifies :restart, resources(:service => "proftpd")
end

template "/etc/proftpd/conf.d/sql.conf" do
  source "sql.conf.erb"
  mode 0644
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
  notifies :restart, resources(:service => "proftpd")
end

template "/etc/proftpd/conf.d/sftp.conf" do
  source "sftp.conf.erb"
  mode 0644
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
  notifies :restart, resources(:service => "proftpd")
end

template "/etc/init.d/proftpd" do
  source "proftpd"
  mode "0755"
  owner "root"
  group "root"
  notifies :restart, resources(:service => "proftpd")
end

service "proftpd" do
  action [:enable, :start]
end

directory node[:proftpd][:data_directory] do
  action :create
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
end
