# frozen_string_literal: true

require 'shellwords'
#
# helm_install_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of helm install chart flags
  newfunction(:helm_install_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << 'install' if opts['ensure'] && opts['ensure'].to_s == 'present'
    flags << "--ca-file '#{opts['ca_file']}'" if opts['ca_file'] && opts['ca_file'].to_s != 'undef'
    flags << "--cert-file '#{opts['cert_file']}'" if opts['cert_file'] && opts['cert_file'].to_s != 'undef'
    flags << '--debug' if opts['debug']
    flags << '--devel' if opts['devel']
    flags << '--dry_run' if opts['dry_run']
    flags << "--key-file '#{opts['key_file']}'" if opts['key_file'] && opts['key_file'].to_s != 'undef'
    flags << "--key-ring '#{opts['key_ring']}'" if opts['key_ring'] && opts['key_ring'].to_s != 'undef'
    flags << "--home '#{opts['home']}'" if opts['home'] && opts['home'].to_s != 'undef'
    flags << "--host '#{opts['host']}'" if opts['host'] && opts['host'].to_s != 'undef'
    flags << "--kube-context '#{opts['kube_context']}'" if opts['kube_context'] && opts['kube_context'].to_s != 'undef'
    flags << "--kubeconfig '#{opts['kubeconfig']}'" if opts['kubeconfig'] && opts['kubeconfig'].to_s != 'undef'
    flags << "--name '#{opts['release_name']}'" if opts['release_name'] && opts['release_name'].to_s != 'undef'
    flags << "--name-template '#{opts['name_template']}'" if opts['name_template'] && opts['name_template'].to_s != 'undef'
    flags << "--namespace '#{opts['namespace']}'" if opts['namespace'] && opts['namespace'].to_s != 'undef'
    flags << '--no-hooks' if opts['no_hooks']
    flags << '--replace' if opts['replace']

    if opts['repo'] && opts['repo'].to_s != 'undef'
      flags << "--repo '#{opts['repo']}'"
    end

    multi_flags = lambda { |values, format|
      filtered = [values].flatten.compact
      filtered.map { |val| sprintf(format + " \\\n", val) }
    }

    [
      ['--set %s',  'set'],
      [' --values %s', 'values'],
    ].each do |(format, key)|
      values    = opts[key]
      new_flags = multi_flags.call(values, format)
      flags.concat(new_flags)
    end

    flags << "--timeout '#{opts['timeout']}'" if opts['timeout'] && opts['timeout'].to_s != 'undef'
    flags << "--tiller-namespace '#{opts['tiller_namespace']}'" if opts['tiller_namespace'] && opts['tiller_namespace'].to_s != 'undef'
    flags << '--tls' if opts['tls']
    flags << "--tls-ca-cert '#{opts['tls_ca_cert']}'" if opts['tls_ca_cert'] && opts['tls_ca_cert'].to_s != 'undef'
    flags << "--tls-cert '#{opts['tls_cert']}'" if opts['tls_cert'] && opts['tls_cert'].to_s != 'undef'
    flags << "--tls-key '#{opts['tls_key']}'" if opts['tls_key'] && opts['tls_key'].to_s != 'undef'
    flags << '--tls-verify' if opts['tls_verify']
    flags << '--verify' if opts['verify']
    flags << "--version '#{opts['version']}'" if opts['version'] && opts['version'].to_s != 'undef'
    flags << '--wait' if opts['wait']
    flags << "'#{opts['chart']}'" if opts['chart'] && opts['chart'].to_s != 'undef'
    flags.flatten.join(' ')
  end
end
