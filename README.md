[![Build Status](https://travis-ci.org/puppetlabs/puppetlabs-helm.svg?branch=master)](https://travis-ci.org/puppetlabs/puppetlabs-helm)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppetlabs/helm.svg)](https://forge.puppetlabs.com/puppetlabs/helm)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/puppetlabs/helm.svg)](https://forge.puppetlabs.com/puppetlabs/helm)

# Helm

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with helm](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The Helm package manager installs and manages Kubernetes applications.

## Description

This module installs the the Helm package manager, which consists of the Helm client (Helm) and the Helm server (Tiller), and it also manages the Helm deployments.

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
  version => '2.6.0',
  service_account => 'my_account',
  tiller_namespace => 'my_namespace',
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
  ensure => present,
  env    => $env,
  path   => $path,
  repo_name => 'myrepo',
  url       => 'http://myserver/charts'
}
```

To update a Helm chart repository, add the following code to the manifest file:

```puppet
helm::repo_update { 'update':
  env => $env,
  path => $path,
  update => true
}
```

## Reference

### Classes

#### Public Classes

* [`helm`](#::helm)

#### Private Classes

* `helm::account_config`: Configures the service account and the cluster role that are required to deploy Helm.
* `helm::binary`: Downloads and extracts the Helm binary.
* `helm::config`: Calls the `helm::helm_init` define to deploy Tiller to the Kubernetes cluster.

### Defined Types

* [`helm::create`](#::helm::create): Creates a new Helm chart.
* [`helm::chart`](#::helm::chart): Manages the deployment of the Helm charts.
* [`helm::helm_init`](#::helm::helm_init): Deploys the Tiller pod and initializes the Helm client.
* [`helm::package`](#::helm::package): Packages a chart directory into a chart archive.
* [`helm::repo`](#::helm::repo): Adds a Helm repository.
* [`helm::repo_update`](#::helm::repo_update): Updates all of the Helm repositories.

#### Class: `helm`

Manages the basic Helm installation and setup.

When the `helm` class is declared, Puppet does the following:

* Downloads and installs Helm onto your system.
* Creates the cluster role and service accounts required to run tiller.
* Deploys Tiller in the `kube-system` namespace.

##### Parameters

* `env`: Sets the environment variables for Helm to connect to the Kubernetes cluster. Default: `[ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']`
* `init`: Specifies whether to initialize the Helm installation and deploy the Tiller pod to Kubernetes. Valid options: `true`, `false`. Default: `true`.
* `install_path`: Sets the path variable for the exec types. Default: '/usr/bin'.
* `service_account`: The service account name assigned to the `tiller` deployment. Default: `tiller`.
* `tiller_namespace`: The namespace of where tiller is deployed to. Default: `kube-system`.
* `version`: The version of Helm to install. Default: '2.5.1'.

#### Defined type: `helm::create`

Creates a new Helm chart.

##### `chart_name`

The name of the Helm chart.

Default: `undef`.

##### `chart_path`

The location of the Helm chart.

If the directory in the path does not exist, Helm attempts to create it. If the directory and the files already exist, only the conflicting files are overwritten.

Default: `undef`.

##### `debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Default: `false`.

##### `env`

Sets the environment variables for Helm to connect to the Kubernetes cluster.

Default: `undef`.

##### `home`

The location of your Helm configuration. This value overrides `$HELM_HOME`.

Default: `undef`.

##### `host`

Address of Tiller. This value overrides `$HELM_HOST`.

Default: `undef`.

##### `kube_context`

The name of the kubeconfig context.

Default: `undef`.

##### `path`

The PATH environment variable.

Default: `undef`.

##### `tiller_namespace`

Namespace of Tiller.

Default: 'kube-system'.

##### `starter`

Value for the starter chart.

Default: `undef`.

#### `helm::chart`

Manages the deployment of the Helm charts.

##### `ensure`

Specifies whether a chart is deployed.

Values: 'present', 'absent'.

Default: 'present'.

##### `ca_file`

Verifies the certificates of the HTTPS-enabled servers using the CA bundle.

Default: `undef`.

##### `cert_file`

Identifies the HTTPS client using this SSL certificate file.

Default: `undef`.

##### `debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Default: `false`.

##### `devel`

Specifies whether to use development versions.

Values `true`, `false`.

Default: `false`.

##### `dry_run`

Specifies whether to simulate an installation or delete a deployment.

Values `true`, `false`.

Default: `false`.

##### `env`

Sets the environment variables for Helm to connect to the kubernetes cluster.

Default: `undef`.

##### `key_file`

Identifies the HTTPS client using thie SSL key file.

Default: `undef`.

##### `key_ring`

Location of the public keys that are used for verification.

Default: `undef`.

##### `home`

Location of your Helm config. This value overrides `$HELM_HOME`.

Default: `undef`.

##### `host`

Address of Tiller. This value overrides `$HELM_HOST`.

Default: `undef`.

##### `kube_context`

Name of the kubeconfig context.

Default: `undef`.

##### `name_template`

The template used to name the release.

Default: `undef`.

##### `no_hooks`

Specifies whether to prevent hooks running during the installation.

Values `true`, `false`.

Default: `false`.

##### `path`

Value for the PATH environment variable.

Default: `undef`.

##### `purge`

Specifies whether to remove the release from the store, and make its name available for later use.

Values `true`, `false`.

Default: `true`.

##### `release_name`

**Required.** The release name.

Default: `undef`.

##### `replace`

Reuse the release name.

Default: `false`.

##### `repo`

The repository URL for a requested chart.

Default: `undef`.

##### `set`

The set array of values for the `helm create` command.

Default: '[]'.

##### `timeout`

The timeout in seconds to wait for a Kubernetes operation.

Default: `undef`.

##### `tiller_namespace`

The Tiller namespace.

Default: 'kube-system'.

##### `tls`

Specifies whether to enable TLS.

Values `true`, `false`.

Default: `false`.

##### `tls_ca_cert`

The path to TLS CA certificate file.

Default: `undef`.

##### `tls_cert`

The path to TLS certificate file.

Default: `undef`.

##### `tls_key`

The path to TLS key file.

Default: `undef`.

##### `tls_verify`

Enable TLS for request and verify remote.

Default: `undef`.

##### `values`

Specify values from a YAML file. Multiple values in an array are accepted.

Default: '[]'.

##### `verify`

Specifies whether to verify the package before installing it.

Values `true`, `false`.

Default: `false`.

##### `version`

Specify the version of the chart to install. `undef` installs the latest version.

Default: `undef`.

##### `wait`

Before marking the release as successful, specify whether to wait until all the pods, PVCs, services, and the minimum number of deployment pods are in a ready state. The `timeout` value determines the duration. 

Values `true`, `false`.

Default: `false`.

##### `chart`

The file system location of the package.

Default: `undef`.

#### Defined type: `helm::helm_init`

Deploys the Tiller pod and initialize the Helm client.

##### `init`

Specifies whether to deploy the tiller pod and initialise the Helm client.

Values: `true`, `false`.

Default: `true`.

##### `canary_image`

Specifies whether to use the canary Tiller image.

Values: `true`, `false`.

Default: `false`.

##### `client_only`

Specifies whether to deploy Tiller.

Values: `true`, `false`.

Default: `false`.

##### `debug`

Specifies whether to enable the verbose output.

Values `true`, `false`.

Default: `false`.

##### `dry_run`

Specifies whether to simulate an installation or delete of a deployment.

Values `true`, `false`.

Default: `false`.

##### `env`

Sets the environment variables required for Helm to connect to the kubernetes cluster.

Default: `undef`.

##### `home`

The location for your Helm configuration. This value overrides `$HELM_HOME`.

Default: `undef`.

##### `host`

The host address for Tiller. Overrides `$HELM_HOST`.

Default: `undef`.

##### `kube_context`

The name for the kubeconfig context to use.

Default: `undef`.

##### `local_repo_url`

The local repository URL.

Default: `undef`.

##### `net_host`

Specifies whether to install Tiller with `net=host`.

Values: `true`, `false`.

Default: `false`.

##### `path`

The value for the PATH environment variable.

Default: `undef`.

##### `service_account`

The name for the service account used for deploying Tiller.

Default: `undef`.

##### `skip_refresh`

Specifies whether to refresh or download the local repository cache.

Values: `true`, `false`.

Default: `false`.

##### `stable_repo_url`

The stable repository URL.

Default: `undef`.

##### `tiller_image`

Override the Tiller image.

Default: `undef`

##### `tiller_namespace`

Namespace for Tiller.

Default: 'kube-system'.

##### `tiller_tls`

Specifies whether to install Tiller with TLS enabled.

Values: `true`, `false`.

Default: `false`.

##### `tiller_tls_cert`

The path to the TLS certificate file that is installed with Tiller.

Default: `undef`.

##### `tiller_tls_key`

The path to the TLS key file that is installed with Tiller.

Default: `undef`.

##### `tiller_tls_verify`

Specifies whether to install Tiller with TLS enabled and to verify remote certificates.

Values: `true`, `false`.

Default: `false`.

##### `tls_ca_cert`

Specifies whether to use the path to the CA root certificate.

Values: `true`, `false`.

Default: `false`.

##### `upgrade`

Specifies whether to upgrade if Tiller is installed.

Values: `true`, `false`.

Default: `false`.

#### Defined type: `helm::package`

Packages a chart directory into a chart archive.

##### `chart_name`

Default: `undef`.

The name of the Helm chart.

##### `chart_path`

The file system location of the chart.

##### `debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Default: `false`.

##### `home`

Location of your Helm config. This value overrides `$HELM_HOME`.

Default: `undef`.

##### `host`

The address for Tiller. This value overrides `$HELM_HOST`.

Default: `undef`.

##### `kube_context`

The name for the kubeconfig context.

Default: `undef`.

##### `save`

Specifies whether to save the packaged chart to the local chart repository.

Values: `true`, `false`.

Default: `true`.

##### `sign`

Specifies whether to use a PGP private key to sign the package.

Values: `true`, `false`.

Default: `false`.

##### `tiller_namespace`

The namespace for Tiller.

Default: `undef`.

##### `version`

The version of the chart.

Default: `undef`.

##### `dependency_update`

Specifies whether to update dependencies.

Values: `true`, `false`.

Default: `false`.

##### `destination`

The destination location to write to.

Default: `undef`.

##### `env`

Sets the environment variables required for Helm to connect to the kubernetes cluster.

Default: `undef`.

##### `key`

Specify the key to use.

Default: `undef`.

##### `keystring`

The location of the public keys that are used for verification.

Default: `undef`.

#### Defined type: `helm::repo`

Adds a Helm repository.

##### `ensure`

Specifies whether a repo is added.

Values: 'present', 'absent'.

Default: 'present'.

##### `ca_file`

Verify the certificates of HTTPS-enabled servers that are using the current CA bundle.

Default: `undef`.

##### `cert_file`

Use the SSL certificate file to identify the HTTPS client.

Default: `undef`.

##### `debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Default: `false`.

##### `env`

Sets the environment variables required for Helm to connect to the kubernetes cluster.

Default: `undef`.

##### `key_file`

Use the SSL key file to identify the HTTPS client.

Default: `undef`.

##### `no_update`

Specifies whether to create an error when the repository is already registered.

Values `true`, `false`.

Default: `false`.

##### `home`

Location of your Helm config. This value overrrides `$HELM_HOME`.

Default: `undef`.

##### `host`

The address for Tiller. This value overrides `$HELM_HOST`.

Default: `undef`.

##### `kube_context`

The name for the kubeconfig context to use.

Default: `undef`.

##### `path`

The values for PATH environment variable.

Default: `undef`.

##### `tiller_namespace`

The namespace for Tiller.

Default: `undef`.

##### `repo_name`

The name for the remote repository.

Default: `undef`.

##### `url`

The URL for the remote repository.

Default: `undef`.

#### Defined type: `helm::repo_update`

Updates all of the Helm repositories.

##### `debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Default: `false`.

##### `env`

Sets the environment variables required for Helm to connect to the Kubernetes cluster.

Default: `undef`.

##### `home`

The location of your Helm config. This value overrides `$HELM_HOME`.

Default: `undef`.

##### `host`

The address for Tiller. This value overrides `$HELM_HOST`.

Default: `undef`.

##### `kube_context`

The name for the kubeconfig context to use.

Default: `undef`.

##### `path`

The value for the PATH environment variable.

Default: `undef`.

##### `tiller_namespace`

The namespace for Tiller.

Default: `undef`.

##### `update`

Specifies whether the repository is updated.

Values `true`, `false`.

Default: `true`.

## Limitations

This module is compatible only with the `Linux` kernel.

## Development

### Contributing

If you would like to contribute to this module please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-helm/blob/master/CONTRIBUTING.md).
