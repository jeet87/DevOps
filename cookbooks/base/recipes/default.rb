#
# Cookbook:: base
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
include_recipe 'yum-mysql-community::mysql55'

mysql_service 'foo' do
  port '3306'
  version '5.5'
  initial_root_password 'pass'
  action [:create, :start]
end

# User creation example: https://docs.chef.io/resource_user.html
user 'create_a_user' do
  username 'jdogra'
  password '$1$575TQ2zt$FcLJfDZPHMBbZZIkQGzWa0'
  home '/home/jdogra'
end

# Single command execution example: https://docs.chef.io/resource_execute.html
execute 'create_temp_dir' do
  command 'mkdir /home/vagrant/deleteMeAfterUse'
  creates '/home/vagrant/deleteMeAfterUse'
end

allMysqlUsers = search(:mysqlUsers, "*:*")

allMysqlUsers.each do |mysqlUser|
  username = mysqlUser["id"]
  password = mysqlUser["password"]
  permissions = mysqlUser["mysqlPermissions"]
  deleteFlag = mysqlUser["delete"]
  userExists = false

  # ruby_block 'check_if_user_exists' do
  #   block do
  #     command = "mysql -S /var/run/mysql-foo/mysqld.sock -u root -p'pass' -e \"SELECT COUNT(*) FROM mysql.user WHERE User='#{username}' AND Host='localhost'\""
  #     commandOut = shell_out(command)
  #     userExistsCount = commandOut.stdout.split("\n")[1].to_i
  #     # puts userExistsCount
  #     if userExistsCount != 0
  #       userExists = true
  #     end
  #   end
  #   action :run
  # end

  execute 'create_mysql_user' do
    command "mysql -S /var/run/mysql-foo/mysqld.sock -u root -p'pass' -e \"CREATE USER '#{username}'@'localhost' IDENTIFIED BY '#{password}'\""
    only_if {shell_out("mysql -S /var/run/mysql-foo/mysqld.sock -u root -p'pass' -e \"SELECT COUNT(*) FROM mysql.user WHERE User='#{username}' AND Host='localhost'\"").stdout.split("\n")[1].to_i == 0 && !deleteFlag}
  end

  execute 'alter_mysql_user_perm' do
    command "mysql -S /var/run/mysql-foo/mysqld.sock -u root -p'pass' -e \"GRANT #{permissions.join(',')} ON *.* TO '#{username}'@'localhost'\""
    only_if {shell_out("mysql -S /var/run/mysql-foo/mysqld.sock -u root -p'pass' -e \"SELECT COUNT(*) FROM mysql.user WHERE User='#{username}' AND Host='localhost'\"").stdout.split("\n")[1].to_i != 0}
  end

  execute 'delete_mysql_user' do
    command "mysql -S /var/run/mysql-foo/mysqld.sock -u root -p'pass' -e \"DROP USER '#{username}'@'localhost'\""
    only_if {shell_out("mysql -S /var/run/mysql-foo/mysqld.sock -u root -p'pass' -e \"SELECT COUNT(*) FROM mysql.user WHERE User='#{username}' AND Host='localhost'\"").stdout.split("\n")[1].to_i != 0 && deleteFlag}
  end
end
