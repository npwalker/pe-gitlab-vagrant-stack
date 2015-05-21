## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  server => "${settings::server}",
  path   => false,
}

notify { "servername is ${settings::server}": }

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node 'gitlab-server' {
 
 #class { 'packagecloud': } 

 #packagecloud::repo { "gitlab/gitlab-ce":
 #  type => 'rpm',  # or "deb" or "gem"
 #  server_address => 'https://packages.gitlab.com',
 #  require => Class['packagecloud'],
 #}   

 exec { '/usr/bin/curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo /bin/bash':
   creates => '/etc/yum.repos.d/gitlab_gitlab-ce.repo',
 }

 package { 'gitlab-ce': 
   ensure => 'installed',
 #  require => Packagecloud::Repo['gitlab/gitlab-ce'],
 }
 
 exec { 'configure and start gitlab':
   command => '/usr/bin/gitlab-ctl reconfigure',
   creates => '/opt/gitlab/embedded/etc/gitconfig',
 }
 
}

node 'puppet-master'{

  class {'r10k::webhook::config':
    use_mcollective => false,
  }

  class {'r10k::webhook':
    user    => 'root',
    group   => '0',
    require => Class['r10k::webhook::config'],
  }
}

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}

