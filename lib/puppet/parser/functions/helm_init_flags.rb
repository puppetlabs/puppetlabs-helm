require 'shellwords'
#
# helm_init_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of helm init flags
  newfunction(:helm_init_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << 'init' if opts['init']
    flags << '--canary-image' if opts['canary_image']
    flags << '--client-only' if opts['client_only']
    flags << '--debug' if opts['debug']
    flags << '--dry_run' if opts['dry_run']
    flags << "--home '#{opts['home']}'" if opts['home'].to_s != 'undef'
    flags << "--host '#{opts['host']}'" if opts['host'].to_s != 'undef'
    flags << "--kube-context '#{opts['kube_context']}'" if opts['kube_context'].to_s != 'undef'
    flags << "--local-repo-url '#{opts['local_repo_url']}'" if opts['local_repo_url'].to_s != 'undef'
    flags << '--net-host' if opts['net_host']
    flags << "--service-account '#{opts['service_account']}'" if opts['service_account'].to_s != 'undef'
    flags << '--skip-refresh' if opts['skip_refresh']
    flags << "--stable-repo-url '#{opts['stable_repo_url']}'" if opts['stable_repo_url'].to_s != 'undef'
    flags << "--tiller-image '#{opts['tiller_image']}'" if opts['tiller_image'].to_s != 'undef'
    flags << "--tiller-namespace '#{opts['tiller_namespace']}'" if opts['tiller_namespace'].to_s != 'undef'
    flags << '--tiller-tls' if opts['tiller_tls']
    flags << "--tiller-tls-cert '#{opts['tiller_tls_cert']}'" if opts['tiller_tls_cert'].to_s != 'undef'
    flags << "--tiller-tls-key '#{opts['tiller_tls_key']}'" if opts['tiller_tls_key'].to_s != 'undef'
    flags << '--tiller-tls-verify' if opts['tiller_tls_verify']
    flags << "--tls_ca_cert '#{opts['tls_ca_cert']}'" if opts['tls_ca_cert'].to_s != 'undef'
    flags << '--upgrade' if opts['upgrade']
    flags.flatten.join(' ')
  end
end
