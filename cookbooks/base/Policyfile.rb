# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'base'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'base::default'

# Specify a custom source for a single cookbook:
cookbook 'base', path: '.'
# cookbook 'mysql', '~> 7.2.0'
cookbook 'mysql', '~> 8.5.1'
cookbook 'yum-mysql-community', '~> 4.0.1'
