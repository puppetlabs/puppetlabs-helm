require 'shellwords'
#
# helm_ls_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of helm ls flags
  newfunction(:helm_ls_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << 'ls' if opts['ls']
    flags << "--home '#{opts['home']}'" if opts['home'].to_s != 'undef'
    flags << "--host '#{opts['host']}'" if opts['host'].to_s != 'undef'
    flags << "--kube-context '#{opts['kube_context']}'" if opts['kube_context'].to_s != 'undef'
    flags << "--tiller-namespace '#{opts['tiller_namespace']}'" if opts['tiller_namespace'].to_s != 'undef'
    flags << '--short' if opts['short']
    flags << '--tls' if opts['tls']
    flags << "--tls-ca-cert '#{opts['tls_ca_cert']}'" if opts['tls_ca_cert'].to_s != 'undef'
    flags << "--tls-cert '#{opts['tls_cert']}'" if opts['tls_cert'].to_s != 'undef'
    flags << "--tls-key '#{opts['tls_key']}'" if opts['tls_key'].to_s != 'undef'
    flags << '--tls-verify' if opts['tls_verify']
    flags.flatten.join(' ')
  end
end
