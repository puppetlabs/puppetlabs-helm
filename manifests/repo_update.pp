# Defined Type helm::repo_update
#
# @summary
#   Updates all of the Helm repositories.
#
# @param debug
#   Specifies whether to enable verbose output.
#   Values true, false.
#
# @param env
#   Sets the environment variables required for Helm to connect to the Kubernetes cluster.
#
# @param home
#   The location of your Helm config. This value overrides $HELM_HOME.
#
# @param host
#   The address for Tiller. This value overrides $HELM_HOST.
#
# @param kube_context
#   The name for the kubeconfig context to use.
#
# @param path
#   The PATH variable used for exec types.
#
# @param tiller_namespace
#   The namespace for Tiller.
#
# @param update
#   Specifies whether the repository is updated.
#   Values true, false.
# 
define helm::repo_update (
  Boolean $debug                     = false,
  Optional[Array] $env               = undef,
  Optional[String] $home             = undef,
  Optional[String] $host             = undef,
  Optional[String] $kube_context     = undef,
  Optional[Array] $path              = undef,
  Optional[String] $tiller_namespace = undef,
  Boolean $update                    = true,
){

  include ::helm
  include ::helm::params

  if versioncmp($helm::version, '3.0.0') < 0 {
    if $update {
      $helm_repo_update_flags = helm_repo_update_flags({
        debug => $debug,
        home => $home,
        host => $host,
        kube_context => $kube_context,
        tiller_namespace => $tiller_namespace,
        update => $update,
      })
      $exec_update = "helm repo ${helm_repo_update_flags}"
    }
  } else {
    if $update {
      $helm_repo_update_flags = helm_repo_update_flags({
        debug => $debug,
        host => $host,
        kube_context => $kube_context,
        tiller_namespace => $tiller_namespace,
        update => $update,
      })
      $exec_update = "helm repo ${helm_repo_update_flags}"
    }
  }

  exec { 'helm repo update':
    command     => $exec_update,
    environment => $env,
    path        => $path,
    timeout     => 0,
  }
}
