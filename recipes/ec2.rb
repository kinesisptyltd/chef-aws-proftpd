#
# Cookbook Name:: aws-proftpd
# Recipe:: ec2
#
# Author:: Kinesis Pty Ltd (<devs@kinesis.org>)
#
# Copyright (C) 2014, Kinesis Pty Ltd
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

Chef::Recipe.send(:include, Kinesis::Aws)

ec2 = aws_client("EC2", node["ec2"]["placement_availability_zone"].chop)

ec2.associate_address(
  instance_id: node["ec2"]["instance_id"],
  allocation_id: node["proftpd"]["eip_id"],
  allow_reassociation: true
)
