# helm

## NOTE

At present this module is requires a working kubernetes cluster, with kubectl installed.
In addition to this it is recommended that a service account be setup in the desired namespace
before installation of helm to use full functionatlity.

See here for more information:

https://github.com/kubernetes/helm/issues/2224



#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with helm](#setup)
    * [What helm affects](#what-helm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with helm](#beginning-with-helm)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The helm module installs, configures and manages the helm package manager.

This module manages both the installation of the helm client and helm server. In addition to this it will manage helm deployments

## Setup

To install with the default options:
`include helm`

## Usage

To customise options, such as the version of helm, or the service account and namespace of the tiller deployment:

```
class { 'helm':
  version => '2.6.0',
  service_account => 'my_account',
  tiller_namespace => 'my_namespace',
}
```

## Reference

### Public classes

#### Class: `helm`

Guides the basic setup and installation of Helm on your system.

When this class is declared with the default options, Puppet:

- Downloads and installs the specified helm version on your system.
- Creates the cluster role and service accounts required to run tiller.
- Deploys the helm server (Tiller) into the `kube-system` namespace.

##### `env`

Sets the environment variables required for helm to connect to the kubernetes cluster

Default: `[ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']`

##### `init`

A flag to initialise the helm install and deploy the Tiller pod to Kubernetes

Values: `'true', 'false'`

Default: `true`

##### `install_path`

Sets the path variable for exec types in the module

Default: `['bin','/usr/bin']`

##### `service_account`

The name of the service account assigned to the `tiller` deployment

Default: `tiller`

##### `tiller_namespace`

The namespace to deploy tiller into

Default: `kube-system`

##### `version`

The version of helm to install

Default: `2.5.1`

### Private classes

#### Class: `helm::binary`

Downloads and extracts the helm binary

#### Class: `helm::account_config`

Configures the service account and cluster role required to deploy helm

#### Class: `helm::config`

Calls the `helm::helm_init` define to deploy tiller to the kubernetes cluster.

### Defines

#### `helm::create`

Creates a new chart by running `helm create`

##### `chart_name`

Default: `undef`

The name of the helm chart

##### `chart_path`

The file system location of the chart.

Note: If directories in the given path do not exist, Helm will attempt to create them as it goes. If the given destination exists and there are files in that directory, conflicting files will be overwritten, but other files will be left alone

Default: `undef`

##### `debug`

Enable verbose output

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of Tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use

Default: `undef`

##### `tiller_namespace`

Namespace of Tiller

Default: `kube-system`


#### `helm::chart`

Manages the deployment of helm charts

##### `ensure`

A flag to determine whether a chart should be deployed

Values: `'present','absent'`

Default: `present`

##### `ca_file`

Verify certificates of HTTPS-enabled servers using this CA bundle

##### `cert_file`

Identify HTTPS client using this SSL certificate file

##### `devel`

Use development versions

##### `dry_run`

Simulate an install or delete of a deployment

##### `key_file`

Identify  HTTPS client using thie SSL key file

##### `keyring`

Location of the public keys used for verification

##### `name`

Release name

Default: `undef`

##### `name_template`

Template used to name the release

##### `no_hooks`

Prevent hooks from running during install

##### `purge`

Remove the release from the store and make its name free for later use

Default: `true`

##### `replace`

Reuse the given name

##### `repo`

Chart reposistory URL for the requested chart

##### `set`

Set array of values for the `helm create` command

Default: `[]`

##### `timeout`

time in seconds to wait for any individual Kubernetes operation

##### `tiller_namespace`

Namespace of Tiller

Default: `kube-system`












## Limitations

This module is only compatible with the `Linux` kernel

## Development

### Contributing

[Puppet][] modules on the [Puppet Forge][] are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve.

We want to make it as easy as possible to contribute changes so our modules work in your environment, but we also need contributors to follow a few guidelines to help us maintain and improve the modules' quality.

For more information, please read the complete [module contribution guide][] and check out [CONTRIBUTING.md][].
