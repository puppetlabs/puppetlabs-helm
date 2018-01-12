require 'shellwords'
#
# helm_delete_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of helm delete flags
  newfunction(:helm_delete_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << 'delete' if opts['ensure'].to_s == 'absent'
    flags << '--dry_run' if opts['dry_run']
    flags << "--home '#{opts['home']}'" if opts['home'].to_s != 'undef'
    flags << "--host '#{opts['host']}'" if opts['host'].to_s != 'undef'
    flags << "--kube-context '#{opts['kube_context']}'" if opts['kube_context'].to_s != 'undef'
    flags << '--no-hooks' if opts['no_hooks']
    flags << '--purge' if opts['purge']
    flags << "--timeout '#{opts['timeout']}'" if opts['timeout'].to_s != 'undef'
    flags << "--tiller-namespace '#{opts['tiller_namespace']}'" if opts['tiller_namespace'].to_s != 'undef'
    flags << '--tls' if opts['tls']
    flags << "--tls-ca-cert '#{opts['tls_ca_cert']}'" if opts['tls_ca_cert'].to_s != 'undef'
    flags << "--tls-cert '#{opts['tls_cert']}'" if opts['tls_cert'].to_s != 'undef'
    flags << "--tls-key '#{opts['tls_key']}'" if opts['tls_key'].to_s != 'undef'
    flags << '--tls-verify' if opts['tls_verify']
    flags << "'#{opts['release_name']}'" if opts['release_name'].to_s != 'undef'
    flags.flatten.join(' ')
  end
end
