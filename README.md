[![Build Status](https://travis-ci.org/puppetlabs/puppetlabs-helm.svg?branch=main)](https://travis-ci.org/puppetlabs/puppetlabs-helm)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppetlabs/helm.svg)](https://forge.puppetlabs.com/puppetlabs/helm)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/puppetlabs/helm.svg)](https://forge.puppetlabs.com/puppetlabs/helm)

# Helm

#### Table of Contents

- [Helm](#Helm)
      - [Table of Contents](#Table-of-Contents)
  - [Description](#Description)
  - [Setup](#Setup)
  - [Usage](#Usage)
  - [Reference](#Reference)
  - [Limitations](#Limitations)
  - [Development](#Development)
    - [Contributing](#Contributing)


## Description

This module installs the the Helm package manager, which consists of the Helm client (Helm) and the Helm server (Tiller), and it also manages the Helm deployments. The Helm package manager installs and manages Kubernetes applications.

## Setup

Before installing the helm module, create a Kubernetes service account and install a Kubernetes cluster, including kubectl. For more information about Kubernetes and kubectl, see the [Kubernetes docs](https://github.com/kubernetes/helm/issues/2224).

To install the helm module, include the `helm` class:

```puppet
include 'helm'
```

## Usage

To customise options, such as the version, the service account, or the Tiller namespace, add the following code to the manifest file:

```puppet
class { 'helm':
  version           => '2.6.0',
  service_account   => 'my_account',
  tiller_namespaces => ['my_namespace'],
}
```

A Helm chart is a collection of files that describe a related set of Kubernetes resources. To create a Helm chart, add the following code to the manifest file:

```puppet
helm::create { 'myapp':
  env        => $env,
  chart_path => '/tmp',
  chart_name => 'myapp',
  path       => $path,
}
```

To package a Helm chart, add the following code to the manifest file:

```puppet
helm::package { 'myapp':
  chart_path  => '/tmp',
  chart_name  => 'myapp',
  destination => '/root',
  env         => $env,
  path        => $path,
  version     => '0.1.0',
}
```

To deploy a Helm chart, add the following code to the manifest file:

```puppet
helm::chart { 'mysql':
  ensure       => present,
  chart        => 'stable/mysql',
  env          => $env,
  path         => $path,
  release_name => 'mysql',
}
```

To add a Helm chart repository, add the following code to the manifest file:

```puppet
helm::repo { 'myrepo':
  ensure    => present,
  env       => $env,
  path      => $path,
  username  => 'username',
  password  => 'password',
  repo_name => 'myrepo',
  url       => 'http://myserver/charts'
}
```

To update a Helm chart repository, add the following code to the manifest file:

```puppet
helm::repo_update { 'update':
  env    => $env,
  path   => $path,
  update => true
}
```

## Reference

[REFERENCE.md](https://github.com/puppetlabs/puppetlabs-helm/blob/main/REFERENCE.md).

## Limitations

This module is compatible only with the `Linux` kernel.

## Development

### Contributing

If you would like to contribute to this module please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-helm/blob/main/CONTRIBUTING.md).

To run the acceptance tests you can use Puppet Litmus with the Vagrant provider by using the following commands:

    bundle exec rake 'litmus:provision_list[all_supported]'
    bundle exec rake 'litmus:install_agent[puppet5]'
    bundle exec rake 'litmus:install_module'
    bundle exec rake 'litmus:acceptance:parallel'

As currently Litmus does not allow memory size and cpu size parameters for the Vagrant provisioner task we recommend to manually update the Vagrantfile used by the provisioner and add at least the following specifications for the puppetlabs-kubernetes module acceptance tests:

**Update Vagrantfile in the file: spec/fixtures/modules/provision/tasks/vagrant.rb**
    vf = <<-VF 
    Vagrant.configure(\"2\") do |config|
    config.vm.box = '#{platform}'
    config.vm.boot_timeout = 600
    config.ssh.insert_key = false
    config.vm.hostname = "testkube"
    config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "2"
    end
    #{network}
    #{synced_folder}
    end
    VF
