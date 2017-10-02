# helm

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with helm](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

The Helm package manager installs and manages Kubernetes applications. The helm module installs, configures, and manages the helm package manager.

## Description

This module manages the installation of the Helm client (helm) and the Helm server (tiller). It also manages Helm deployments.

## Setup

Before installing the helm module, create a Kubernetes service account and install a kubernetes cluster including kubectl. 
For more information about Kubernetes and kubectl, see the [Kubernetes docs](https://github.com/kubernetes/helm/issues/2224).

To install the helm module with the default options:
`include helm`

## Usage

To customise options, such as the version, the service account, or the tiller namespace, add the following
code to the manifest file:

```
class { 'helm':
  version => '2.6.0',
  service_account => 'my_account',
  tiller_namespace => 'my_namespace',
}
```

To create a Helm chart, add the following code to the manifest file:

```
helm::create { 'myapp':
  env        => $env,
  chart_path => '/tmp',
  chart_name => 'myapp',
  path       => $path,
}
```

To package a chart, add the following code to the manifest file:

```
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

```
helm::chart { 'mysql':
  ensure       => present,
  chart        => 'stable/mysql',
  env          => $env,
  path         => $path,
  release_name => 'mysql',
}
```

To add a Helm repository, add the following code to the manifest file:

```
helm::repo { 'myrepo':
  ensure => present,
  env    => $env,
  path   => $path,
  repo_name => 'myrepo',
  url       => 'http://myserver/charts'
}
```

To update Helm repositories, add the following code to the manifest file:

```
helm::repo_update { 'update':
  env => $env,
  path => $path,
  update => true
}
```
## Reference

### Public classes

#### Class: `helm`

Manages the basic Helm installation and setup.

When the `helm` class is declared, Puppet does the following:

- Downloads and installs Helm onto your system.
- Creates the cluster role and service accounts required to run tiller.
- Deploys tiller in the `kube-system` namespace.

##### `env`

Sets the required environment variables for Helm to connect to the kubernetes cluster.

Default: `[ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']`

##### `init`

Specifies whether to initialize the Helm installation and deploy the tiller pod to Kubernetes.

Values: `'true', 'false'`

Default: `true`

##### `install_path`

Sets the path variable for exec types in the module.

Default: `['bin','/usr/bin']`

##### `service_account`

The service account name assigned to the `tiller` deployment.

Default: `tiller`

##### `tiller_namespace`

The namespace of where tiller is deployed to. 

Default: `kube-system`

##### `version`

The version of Helm to install.

Default: `2.5.1`

### Private classes

#### Class: `helm::binary`

Downloads and extracts the Helm binary.

#### Class: `helm::account_config`

Configures the service account and cluster role required to deploy Helm.

#### Class: `helm::config`

Calls the `helm::helm_init` define to deploy tiller to the kubernetes cluster.

### Defines

#### `helm::create`

Creates a new chart.

##### `chart_name`

Default: `undef`

The name of the Helm chart.

##### `chart_path`

The file system location of the chart.

If directories in the path do not exist, Helm attempts to create them. If the destination exists 
and the files are in the directory, only the conflicting files are overwritten.

Default: `undef`

##### `debug`

Specifies whether to enable verbose output.

Values `'true','false'`

Default: `false`

##### `env`

Sets the required environment variables for Helm to connect to the Kubernetes cluster.

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

The name of the kubeconfig context.

Default: `undef`

##### `path`

Values for the PATH environment variable.

Default: `undef`

##### `tiller_namespace`

Namespace of tiller.

Default: `kube-system`

#### `helm::chart`

Manages the deployment of the Helm charts.

##### `ensure`

Specifies whether a chart is deployed.

Values: `'present','absent'`

Default: `present`

##### `ca_file`

Verify the certificates of HTTPS-enabled servers using the CA bundle.

Default: `undef`

##### `cert_file`

Identifies the HTTPS client using this SSL certificate file.

Default: `undef`

##### `debug`

Specifies whether to enable verbose output.

Values `'true','false'`

Default: `false`

##### `devel`

Specifies whether to use development versions.

Values `'true','false'`

Default: `false`

##### `dry_run`

Specifies whether to simulate an installation or delete a deployment.

Values `'true','false'`

Default: `false`

##### `env`

Sets the required environment variables for Helm to connect to the kubernetes cluster.

Default: `undef`

##### `key_file`

Identifies the HTTPS client using thie SSL key file.

Default: `undef`

##### `keyring`

Location of the public keys that are used for verification.

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use.

Default: `undef`

##### `name_template`

Template used to name the release.

Default: `undef`

##### `no_hooks`

Specifies whether to prevent hooks running during installation.

Values `'true','false'`

Default: `false`

##### `path`

Value for the PATH environment variable.

Default: `undef`

##### `purge`

Specifies whether to remove the release from the store and make its name free for later use.

Values `'true','false'`

Default: `true`

##### `release_name`

Release name. This value is required.

Default: `undef`

##### `replace`

Reuse the given name.

Default: `false`

##### `repo`

Repository URL for the requested chart.

Default: `undef`

##### `set`

Set array of values for the `helm create` command.

Default: `[]`

##### `timeout`

The time in seconds to wait for any individual Kubernetes operation.

Default: `undef`

##### `tiller_namespace`

Namespace of tiller.

Default: `kube-system`

##### `tls`

Specifies whether to enable TLS.

Values `'true','false'`

Default: `false`

##### `tls_ca_cert`

Path to TLS CA certificate file

Default: `undef`

##### `tls_cert`

Path to TLS certificate file

Default: `undef`

##### `tls_key`

Path to TLS key file

Default: `undef`

##### `tls_verify`

Enable TLS for request and verify remote.

Default: `undef`

##### `values`

Specify values from a YAML file. Multiple values in an array are accepted.

Default: `[]`

##### `verify`

Specifies whether to verify the package before installing it.

Values `'true','false'`

Default: `false`

##### `version`

Specify the exact chart version to install. Specifying `undef` installs the latest version.

Default: `undef`

##### `wait`

Specifies whether to wait until all Pods, PVCs, Services, and the minimum number of pods of a deployment are in a ready state before marking the release as successful. The duration is for as long as `timeout` value. 

Values `'true','false'`

Default: `false`

#### `helm::helm_init`

Deploys the tiller pod and initialises the Helm client.

##### `init`

Specifies whether to deploy the tiller pod and initialise the Helm client.

Values: `'true','false'`

Default: `true`

##### `canary_image`

Specifies whether to use the canary tiller image.

Values: `'true','false'`

Default: `false`

##### `client_only`

Specifies whether to deploy tiller.

Values: `'true','false'`

Default: `false`

##### `debug`

Specifies whether to enable verbose output.

Values `'true','false'`

Default: `false`

##### `dry_run`

Specifies whether to simulate an installation or delete of a deployment.

Values `'true','false'`

Default: `false`

##### `env`

Sets the environment variables required for Helm to connect to the kubernetes cluster.

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use.

Default: `undef`

##### `local_repo_url`

The local repository URL.

Default: `undef`

##### `net_host`

Specifies whether to install tiller with net=host.

Values: `'true','false'`

Default: `false`

##### `path`

Value the for PATH environment variable.

Default: `undef`

##### `service_account`

Name of the service account for the tiller deployment.

Default: `false`

##### `skip_refresh`

Specifies whether to refresh (download) the local repository cache.

Values: `'true','false'`

Default: `false`

##### `stable_repo_url`

Stable repository URL.

Default: `undef`

##### `tiller_image`

Override tiller image.

Default: `undef`

##### `tiller_namespace`

Namespace of tiller.

Default: `kube-system`

##### `tiller_tls`

Specifies whether to install tiller with TLS enabled.

Values: `'true','false'`

Default: `false`

##### `tiller_tls_cert`

Path to the TLS certificate file to install with tiller.

Default: `undef`

##### `tiller_tls_key`

Path to the TLS key file to install with tiller.

Default: `undef`

##### `tiller_tls_verify`

Specifies whether to install tiller with TLS enabled and to verify remote certificates.

Values: `'true','false'`

Default: `false`

##### `tls_ca_cert`

Path to the CA root certificate.

Default: `false`

##### `upgrade`

Specifies whether to upgrade if Tiller is installed.

Values: `'true','false'`

Default: `false`

#### `helm::package`

##### `chart_name`

Default: `undef`

The name of the Helm chart.

##### `chart_path`

The file system location of the chart.

##### `debug`

Specifies whether to enable verbose output.

Values `'true','false'`

Default: `false`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use.

Default: `undef`

##### `save`

Specifies whether to save the packaged chart to the local chart repository.

Values: `'true','false'`

Default: `true`

##### `sign`

Specifies whether to use a PGP private key to sign the package.

Values: `'true','false'`

Default: `false`

##### `tiller_namespace`

Namespace of tiller.

Default: `kube-system`

##### `version`

The version of the chart.

Default: `undef`

#### `helm::repo`

##### `ca_file`

Verify certificates of HTTPS-enabled servers using this CA bundle.

Default: `undef`

##### `cert_file`

Identify the HTTPS client using this SSL certificate file.

Default: `undef`

##### `debug`

Specifies whether to enable verbose output.

Values `'true','false'`

Default: `false`

##### `env`

Sets the environment variables required for Helm to connect to the kubernetes cluster

Default: `undef`

##### `key_file`

Identify  HTTPS client using thie SSL key file

Default: `undef`

##### `no_update`

Specifies whether to create an error if the repository is already registered.

Values `'true','false'`

Default: `false`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

Name of the kubeconfig context to use.

Default: `undef`

##### `path`

Values for PATH environment variable

Default: `undef`

##### `tiller_namespace`

Namespace of tiller.

Default: `kube-system`

##### `repo_name`

Name of the remote repository.

Default: `undef`

##### `url`

The URL for the remote repository.

Default: `undef`

#### `helm::repo_update`

A define to update all the Helm repositories.

##### `debug`

Specifies whether to enable verbose output.

Values `'true','false'`

Default: `false`

##### `env`

Sets the environment variables required for Helm to connect to the kubernetes cluster.

Default: `undef`

##### `home`

Location of your Helm config. Overrrides $HELM_HOME

Default: `undef`

##### `host`

Address of tiller. Overrides $HELM_HOST

Default: `undef`

##### `kube_context`

The name of the kubeconfig context to use.

Default: `undef`

##### `path`

The value for PATH environment variable.

Default: `undef`

##### `tiller_namespace`

Namespace of tiller.

Default: `kube-system`

##### `update`

Specifies whether the repo is updated.

Values `'true','false'`

Default: `true`

## Limitations

This module is compatible only with the `Linux` kernel.

## Development

### Contributing

If you would like to contribute to this module please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-helm/blob/master/CONTRIBUTING.md).
