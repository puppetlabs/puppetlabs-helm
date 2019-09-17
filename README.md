[![Build Status](https://travis-ci.org/puppetlabs/puppetlabs-helm.svg?branch=master)](https://travis-ci.org/puppetlabs/puppetlabs-helm)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppetlabs/helm.svg)](https://forge.puppetlabs.com/puppetlabs/helm)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/puppetlabs/helm.svg)](https://forge.puppetlabs.com/puppetlabs/helm)

# Helm

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with helm](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
   * [Public classes](#public-classes)
   * [Private classes](#private-classes)
   * [Defined types](#defined-types)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


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

* [Public classes](#public-classes)
* [Private classes](#private-classes)
* [Defined types](#defined-types)

### Public Classes

`helm`: Manages the basic Helm installation and setup.

When the `helm` class is declared, Puppet does the following:

* Downloads and installs Helm onto your system.
* Creates roles and service accounts required to run Tiller.
* Deploys Tiller in one or more namespaces.

**Parameters**

`canary_image`

Use the helm canary image for the default init of helm.

Defaults to `false`.

`client_only`

Specifies whether helm need to configure helm server or not.

Defaults to `false`.

`debug`

Specifies whether to set output logging to debug for the default init.

Defaults to `false`.

`dry_run`

Sets the default init run to dry-run mode.

Defaults to `false`.

`env`

Sets the environment variables for Helm to connect to the Kubernetes cluster.

Defaults to `[ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']`

`home`

Set the `HELM_HOME` variable for the default init.

Defaults to `undef`.

`host`

Set the `HELM_HOST` variable for the default init.

Defaults to `undef`.

`init`

Specifies whether to initialize the Helm installation and deploy the Tiller pod to Kubernetes.

Valid values are `true`, `false`.

Defaults to `true`.

`install_path`

Sets the path variable for the exec types.

Defaults to '/usr/bin'.

`kube_context`

Specifies the `kube_context` for the default init.

Defaults to `undef`.

`proxy`

Specifies internet proxy if necessary.

Defaults to `undef`.

`local_repo_url`

Specifies the local_repo_url for the default init.

Defaults to `undef`.

`net_host`

Enable net_host mode for the default init.

Defaults to `false`.

`node_selectors`

Specify node selectors for the helm init on the default init.

Defaults to `undef`.

`overrides`

Specify override parameters for the default init.

Defaults to `undef`.

`path`

The PATH variable used for exec types.

Defaults to ['/bin','/usr/bin']

`proxy`

If required, specify an internet proxy.

Defaults to `undef`.

`service_account`

The service account name assigned to the `tiller` deployment.

Defaults to `tiller`.

`skip_refresh`

Enable skip refresh mode for the default init.

Defaults to `false`.

`stable_repo_url

Specify the stable repo url for the default init.

Defaults to `undef`.

`tiller_image`

Specify the image for the tiller install in the default init.

Defaults to `undef`.

`tiller_namespaces`

The namespaces where tiller is deployed into.

Defaults to `['kube-system']`.

`tiller_tls`

Enable TLS for tiller in the default init.

Defaults to `false`.

`tiller_tls_cert`

Specify a TLS cert for tiller in the default init.

Defaults to `undef`.

`tiller_tls_key`

Specify a TLS key for tiller in the default init.

Defaults to `undef`.

`tiller_tls_verify`

Enable TLS verification for tiller in the default init.

Defaults to `undef`.

`tls_ca_cert`

Specify a TLS CA certificate for tiller in the default init.

Defaults to `undef`.

`upgrade`

Whether to upgrade tiller in the default init.

Defaults to `false`.

`version`

The version of Helm to install.

Defaults to '2.5.1'.

`archive_baseurl`

The base URL for downloading the helm archive. It must contain file helm-v${version}-linux-${arch}.tar.gz.

URLs supported by the [archive](https://forge.puppet.com/puppet/archive) module also work.

Defaults to `https://kubernetes-helm.storage.googleapis.com`.

### Private Classes

* `helm::account_config`: Configures the service account and the cluster role that are required to deploy Helm.
* `helm::binary`: Downloads and extracts the Helm binary.
* `helm::config`: Calls the `helm::helm_init` define to deploy Tiller to the Kubernetes cluster.

### Defined Types

#### `helm::create`

Creates a new Helm chart.

**Parameters**

`chart_name`

The name of the Helm chart.

Defaults to `undef`.

`chart_path`

The location of the Helm chart.

If the directory in the path does not exist, Helm attempts to create it. If the directory and the files already exist, only the conflicting files are overwritten.

Defaults to `undef`.

`debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Defaults to `false`.

`env`

Sets the environment variables for Helm to connect to the Kubernetes cluster.

Defaults to `undef`.

`home`

The location of your Helm configuration. This value overrides `$HELM_HOME`.

Defaults to `undef`.

`host`

Address of Tiller. This value overrides `$HELM_HOST`.

Defaults to `undef`.

`kube_context`

The name of the kubeconfig context.

Defaults to `undef`.

`path`

The PATH variable used for exec types.

Defaults to ['/bin','/usr/bin']

`starter`

Value for the starter chart.

Defaults to `undef`.

`tiller_namespace`

Namespace of Tiller.

Defaults to 'kube-system'.

#### `helm::chart`

Manages the deployment of the Helm charts.

**Parameters**

`ensure`

Specifies whether a chart is deployed.

Valid values are 'present', 'absent'.

Defaults to 'present'.

`ca_file`

Verifies the certificates of the HTTPS-enabled servers using the CA bundle.

Defaults to `undef`.

`cert_file`

Identifies the HTTPS client using this SSL certificate file.

Defaults to `undef`.

`debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Defaults to `false`.

`devel`

Specifies whether to use development versions.

Values `true`, `false`.

Defaults to `false`.

`dry_run`

Specifies whether to simulate an installation or delete a deployment.

Values `true`, `false`.

Defaults to `false`.

`env`

Sets the environment variables for Helm to connect to the kubernetes cluster.

Defaults to `undef`.

`key_file`

Identifies the HTTPS client using thie SSL key file.

Defaults to `undef`.

`key_ring`

Location of the public keys that are used for verification.

Defaults to `undef`.

`home`

Location of your Helm config. This value overrides `$HELM_HOME`.

Defaults to `undef`.

`host`

Address of Tiller. This value overrides `$HELM_HOST`.

Defaults to `undef`.

`kube_context`

Name of the kubeconfig context.

Defaults to `undef`.

`name_template`

The template used to name the release.

Defaults to `undef`.

`no_hooks`

Specifies whether to prevent hooks running during the installation.

Values `true`, `false`.

Defaults to `false`.

`path`

The PATH variable used for exec types.

Defaults to ['/bin','/usr/bin']

`purge`

Specifies whether to remove the release from the store, and make its name available for later use.

Values `true`, `false`.

Defaults to `true`.

`release_name`

**Required.** The release name.

Defaults to `undef`.

`replace`

Reuse the release name.

Defaults to `false`.

`repo`

The repository URL for a requested chart.

Defaults to `undef`.

`set`

The set array of values for the `helm create` command.

Defaults to '[]'.

`timeout`

The timeout in seconds to wait for a Kubernetes operation.

Defaults to `undef`.

`tiller_namespace`

The Tiller namespace.

Defaults to 'kube-system'.

`tls`

Specifies whether to enable TLS.

Values `true`, `false`.

Defaults to `false`.

`tls_ca_cert`

The path to TLS CA certificate file.

Defaults to `undef`.

`tls_cert`

The path to TLS certificate file.

Defaults to `undef`.

`tls_key`

The path to TLS key file.

Defaults to `undef`.

`tls_verify`

Enable TLS for request and verify remote.

Defaults to `undef`.

`values`

Specify values from a YAML file. Multiple values in an array are accepted.

Defaults to '[]'.

`verify`

Specifies whether to verify the package before installing it.

Values `true`, `false`.

Defaults to `false`.

`version`

Specify the version of the chart to install. `undef` installs the latest version.

Defaults to `undef`.

`wait`

Before marking the release as successful, specify whether to wait until all the pods, PVCs, services, and the minimum number of deployment pods are in a ready state. The `timeout` value determines the duration.

Values `true`, `false`.

Defaults to `false`.

`chart`

The file system location of the package.

Defaults to `undef`.

#### `helm::chart_update`

Update deployed Helm charts.

**Parameters**

`ensure`

Specifies whether a chart must be updated.

Valid values are 'present', 'absent'.

Defaults to 'present'.

`ca_file`

Verifies the certificates of the HTTPS-enabled servers using the CA bundle.

Defaults to `undef`.

`cert_file`

Identifies the HTTPS client using this SSL certificate file.

Defaults to `undef`.

`debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Defaults to `false`.

`devel`

Specifies whether to use development versions.

Values `true`, `false`.

Defaults to `false`.

`dry_run`

Specifies whether to simulate a chart update.

Values `true`, `false`.

Defaults to `false`.

`env`

Sets the environment variables for Helm to connect to the kubernetes cluster.

Defaults to `undef`.

`install`

If a release by this name doesn't already exist, run an install

Defaults to `true`.

`key_file`

Identifies the HTTPS client using the SSL key file.

Defaults to `undef`.

`keyring`

Location of the public keys that are used for verification.

Defaults to `undef`.

`home`

Location of your Helm config. This value overrides `$HELM_HOME`.

Defaults to `undef`.

`host`

Address of Tiller. This value overrides `$HELM_HOST`.

Defaults to `undef`.

`kube_context`

Name of the kubeconfig context.

Defaults to `undef`.

`recreate_pods`

Performs pods restart for the resource if applicable

Defaults to `undef`.

`reset_values`

When upgrading, reset the values to the ones built into the chart

Defaults to `undef`.

`reuse_values`

when upgrading, reuse the last release's values, and merge in any new values. If '--reset-values' is specified, this is ignored.

Defaults to `undef`.

`no_hooks`

Specifies whether to prevent hooks running during the installation.

Values `true`, `false`.

Defaults to `false`.

`path`

The PATH variable used for exec types.

Defaults to ['/bin','/usr/bin']

`purge`

Specifies whether to remove the release from the store, and make its name available for later use.

Values `true`, `false`.

Defaults to `true`.

`release_name`

**Required.** The release name.

Defaults to `undef`.

`repo`

The repository URL for a requested chart.

Defaults to `undef`.

`set`

The set array of values for the `helm create` command.

Defaults to '[]'.

`timeout`

The timeout in seconds to wait for a Kubernetes operation.

Defaults to `undef`.

`tiller_namespace`

The Tiller namespace.

Defaults to 'kube-system'.

`tls`

Specifies whether to enable TLS.

Values `true`, `false`.

Defaults to `false`.

`tls_ca_cert`

The path to TLS CA certificate file.

Defaults to `undef`.

`tls_cert`

The path to TLS certificate file.

Defaults to `undef`.

`tls_key`

The path to TLS key file.

Defaults to `undef`.

`tls_verify`

Enable TLS for request and verify remote.

Defaults to `undef`.

`values`

Specify values from a YAML file. Multiple values in an array are accepted.

Defaults to '[]'.

`verify`

Specifies whether to verify the package before installing it.

Values `true`, `false`.

Defaults to `false`.

`version`

Specify the version of the chart to install. `undef` installs the latest version.

Defaults to `undef`.

`wait`

Before marking the release as successful, specify whether to wait until all the pods, PVCs, services, and the minimum number of deployment pods are in a ready state. The `timeout` value determines the duration.

Values `true`, `false`.

Defaults to `false`.

`chart`

The file system location of the package.

Defaults to `undef`.

#### `helm::helm_init`

Deploys the Tiller pod and initializes the Helm client.

**Parameters**

`init`

Specifies whether to deploy the tiller pod and initialise the Helm client.

Valid values are `true`, `false`.

Defaults to `true`.

`canary_image`

Specifies whether to use the canary Tiller image.

Valid values are `true`, `false`.

Defaults to `false`.

`client_only`

Specifies whether to deploy Tiller.

Valid values are `true`, `false`.

Defaults to `false`.

`debug`

Specifies whether to enable the verbose output.

Values `true`, `false`.

Defaults to `false`.

`dry_run`

Specifies whether to simulate an installation or delete of a deployment.

Values `true`, `false`.

Defaults to `false`.

`env`

Sets the environment variables required for Helm to connect to the kubernetes cluster.

Defaults to `undef`.

`home`

The location for your Helm configuration. This value overrides `$HELM_HOME`.

Defaults to `undef`.

`host`

The host address for Tiller. Overrides `$HELM_HOST`.

Defaults to `undef`.

`kube_context`

The name for the kubeconfig context to use.

Defaults to `undef`.

`local_repo_url`

The local repository URL.

Defaults to `undef`.

`net_host`

Specifies whether to install Tiller with `net=host`.

Valid values are `true`, `false`.

Defaults to `false`.

`path`

The PATH variable used for exec types.

Defaults to ['/bin','/usr/bin']

`service_account`

The name for the service account used for deploying Tiller.

Defaults to `undef`.

`skip_refresh`

Specifies whether to refresh or download the local repository cache.

Valid values are `true`, `false`.

Defaults to `false`.

`stable_repo_url`

The stable repository URL.

Defaults to `undef`.

`tiller_image`

Override the Tiller image.

Defaults to `undef`

`tiller_namespace`

Namespace for Tiller.

Defaults to 'kube-system'.

`tiller_tls`

Specifies whether to install Tiller with TLS enabled.

Valid values are `true`, `false`.

Defaults to `false`.

`tiller_tls_cert`

The path to the TLS certificate file that is installed with Tiller.

Defaults to `undef`.

`tiller_tls_key`

The path to the TLS key file that is installed with Tiller.

Defaults to `undef`.

`tiller_tls_verify`

Specifies whether to install Tiller with TLS enabled and to verify remote certificates.

Valid values are `true`, `false`.

Defaults to `false`.

`tls_ca_cert`

Specifies whether to use the path to the CA root certificate.

Valid values are `true`, `false`.

Defaults to `false`.

`upgrade`

Specifies whether to upgrade if Tiller is installed.

Valid values are `true`, `false`.

Defaults to `false`.

#### `helm::package`

Packages a chart directory into a chart archive.

**Parameters**

`chart_name`

Defaults to `undef`.

The name of the Helm chart.

`chart_path`

The file system location of the chart.

`debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Defaults to `false`.

`home`

Location of your Helm config. This value overrides `$HELM_HOME`.

Defaults to `undef`.

`host`

The address for Tiller. This value overrides `$HELM_HOST`.

Defaults to `undef`.

`kube_context`

The name for the kubeconfig context.

Defaults to `undef`.

`save`

Specifies whether to save the packaged chart to the local chart repository.

Valid values are `true`, `false`.

Defaults to `true`.

`sign`

Specifies whether to use a PGP private key to sign the package.

Valid values are `true`, `false`.

Defaults to `false`.

`tiller_namespace`

The namespace for Tiller.

Defaults to `undef`.

`version`

The version of the chart.

Defaults to `undef`.

`dependency_update`

Specifies whether to update dependencies.

Valid values are `true`, `false`.

Defaults to `false`.

`destination`

The destination location to write to.

Defaults to `undef`.

`env`

Sets the environment variables required for Helm to connect to the kubernetes cluster.

Defaults to `undef`.

`key`

Specify the key to use.

Defaults to `undef`.

`keystring`

The location of the public keys that are used for verification.

Defaults to `undef`.

#### `helm::repo`

Adds a Helm repository.

**Parameters**

`ensure`

Specifies whether a repo is added.

Valid values are 'present', 'absent'.

Defaults to 'present'.

`ca_file`

Verify the certificates of HTTPS-enabled servers that are using the current CA bundle.

Defaults to `undef`.

`cert_file`

Use the SSL certificate file to identify the HTTPS client.

Defaults to `undef`.

`debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Defaults to `false`.

`env`

Sets the environment variables required for Helm to connect to the kubernetes cluster.

Defaults to `undef`.

`key_file`

Use the SSL key file to identify the HTTPS client.

Defaults to `undef`.

`no_update`

Specifies whether to create an error when the repository is already registered.

Values `true`, `false`.

Defaults to `false`.

`home`

Location of your Helm config. This value overrrides `$HELM_HOME`.

Defaults to `undef`.

`host`

The address for Tiller. This value overrides `$HELM_HOST`.

Defaults to `undef`.

`kube_context`

The name for the kubeconfig context to use.

Defaults to `undef`.

`path`

The PATH variable used for exec types.

Defaults to ['/bin','/usr/bin']

`tiller_namespace`

The namespace for Tiller.

Defaults to `undef`.

`username`

The username for the remote repository

Defaults to `undef`.

`password`

The password for the remote repository.

Defaults to `undef`.

`repo_name`

The name for the remote repository.

Defaults to `undef`.

`url`

The URL for the remote repository.

Defaults to `undef`.

#### `helm::repo_update`

Updates all of the Helm repositories.

**Parameters**

`debug`

Specifies whether to enable verbose output.

Values `true`, `false`.

Defaults to `false`.

`env`

Sets the environment variables required for Helm to connect to the Kubernetes cluster.

Defaults to `undef`.

`home`

The location of your Helm config. This value overrides `$HELM_HOME`.

Defaults to `undef`.

`host`

The address for Tiller. This value overrides `$HELM_HOST`.

Defaults to `undef`.

`kube_context`

The name for the kubeconfig context to use.

Defaults to `undef`.

`path`

The PATH variable used for exec types.

Defaults to ['/bin','/usr/bin']

`tiller_namespace`

The namespace for Tiller.

Defaults to `undef`.

`update`

Specifies whether the repository is updated.

Values `true`, `false`.

Defaults to `true`.

## Limitations

This module is compatible only with the `Linux` kernel.

## Development

### Contributing

If you would like to contribute to this module please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-helm/blob/master/CONTRIBUTING.md).
