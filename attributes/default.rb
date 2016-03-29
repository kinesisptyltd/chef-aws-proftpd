#
# Cookbook Name:: aws-proftpd
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

# Server
default[:proftpd][:server_name] = "Debian"
default[:proftpd][:server_type] = "standalone"
default[:proftpd][:server_admin] = "admin@example.com"
default[:proftpd][:server_ident] = "off"
default[:proftpd][:user] = "proftpd"
default[:proftpd][:group] = "nogroup"
default[:proftpd][:umask] = "022 022"
default[:proftpd][:data_directory] = "/data"

default[:proftpd][:system_log] = "/var/log/proftpd/main.log"
default[:proftpd][:transfer_log] = "/var/log/proftpd/xfer.log"

# Networking
default[:proftpd][:port] = 21
default[:proftpd][:pasv_min_port] = 1024
default[:proftpd][:pasv_max_port] = 1048

# Tuning
default[:proftpd][:max_instances] = 30
default[:proftpd][:timeout_no_transfer] = 600
default[:proftpd][:timeout_stalled] = 600
default[:proftpd][:timeout_idle] = 1200

# SQL
default[:proftpd][:sql][:backend] = "postgres"
default[:proftpd][:sql][:authenticate] = "users"
default[:proftpd][:sql][:log] = "/var/log/proftpd/sql.log"
default[:proftpd][:sql][:user_info] = "ftp_users username password uid gid home_dir \"NULL\""
default[:proftpd][:sql][:connect_info] = "user@server user password"
default[:proftpd][:sql][:auth_types] = "OpenSSL Crypt"

# SFTP
default[:proftpd][:sftp][:port] = 22
default[:proftpd][:sftp][:log] = "/var/log/proftpd/sftp.log"
default[:proftpd][:sftp][:auth_methods] = "password"
default[:proftpd][:sftp][:host_rsa_key] = "/etc/ssh/ssh_host_rsa_key"
default[:proftpd][:sftp][:host_dsa_key] = "/etc/ssh/ssh_host_dsa_key"

# Ban
default[:proftpd][:ban][:log] = "/var/log/proftpd/ban.log"

default[:openssh][:server][:port] = 2222

# Backup cron job
default[:proftpd][:backup][:bucket] = nil
