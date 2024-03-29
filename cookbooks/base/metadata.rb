name 'base'
maintainer 'The Authors'
maintainer_email 'jeet.dogra@oracle.com'
license 'All Rights Reserved'
description 'Installs/Configures base'
long_description 'Installs/Configures base'
version '0.1.0'
chef_version '>= 14.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/base/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/base'

# depends 'mysql', '~> 7.0'
depends 'mysql', '~> 8.0'
depends 'yum-mysql-community'
