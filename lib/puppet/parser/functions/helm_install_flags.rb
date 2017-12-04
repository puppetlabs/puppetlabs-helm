require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm install chart flags
  newfunction(:helm_install_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['ensure'].to_s == 'present'
      flags << 'upgrade'
    end

    if opts['release_name'].to_s != 'undef'
      flags << "'#{opts['release_name']}'"
    end

    if opts['chart'].to_s != 'undef'
      flags << "'#{opts['chart']}'"
    end

    if opts['install']
      flags << '--install'
    end

    if opts['ca_file'].to_s != 'undef'
      flags << "--ca-file '#{opts['ca_file']}'"
    end

    if opts['cert_file'].to_s != 'undef'
      flags << "--cert-file '#{opts['cert_file']}'"
    end

    if opts['debug']
      flags << '--debug'
    end

    if opts['devel']
      flags << '--devel'
    end

    if opts['dry_run']
      flags << '--dry_run'
    end

    if opts['key_file'].to_s != 'undef'
      flags << "--key-file '#{opts['key_file']}'"
    end

    if opts['keyring'].to_s != 'undef'
      flags << "--keyring '#{opts['keyring']}'"
    end

    if opts['home'].to_s != 'undef'
      flags << "--home '#{opts['home']}'"
    end

    if opts['host'].to_s != 'undef'
      flags << "--host '#{opts['host']}'"
    end

    if opts['kube_context'].to_s != 'undef'
      flags << "--kube-context '#{opts['kube_context']}'"
    end

    if opts['namespace'].to_s != 'undef'
      flags << "--namespace '#{opts['namespace']}'"
    end

    if opts['no_hooks']
      flags << '--no-hooks'
    end

    if opts['recreate_pods']
      flags << '--recreate-pods'
    end

    if opts['reset_values']
      flags << '--reset-values'
    end

    if opts['reuse_values']
      flags << '--reuse-values'
    end

    if opts['repo'].to_s != 'undef'
      flags << "--repo '#{opts['repo']}'"
    end

    multi_flags = lambda { |values, format|
      filtered = [values].flatten.compact
      filtered.map { |val| sprintf(format + " \\\n", val) }
    }

    [
      ['--set %s',  'set'],
      [' --values %s', 'values']
    ].each do |(format, key)|
      values    = opts[key]
      new_flags = multi_flags.call(values, format)
      flags.concat(new_flags)
    end

    if opts['timeout'].to_s != 'undef'
      flags << "--timeout '#{opts['timeout']}'"
    end

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end

    if opts['tls']
      flags << '--tls'
    end

    if opts['tls_ca_cert'].to_s != 'undef'
      flags << "--tls-ca-cert '#{opts['tls_ca_cert']}'"
    end

    if opts['tls_cert'].to_s != 'undef'
      flags << "--tls-cert '#{opts['tls_cert']}'"
    end

    if opts['tls_key'].to_s != 'undef'
      flags << "--tls-key '#{opts['tls_key']}'"
    end

    if opts['tls_verify']
      flags << '--tls-verify'
    end

    if opts['verify']
      flags << '--verify'
    end

    if opts['version'].to_s != 'undef'
      flags << "--version '#{opts['version']}'"
    end

    if opts['wait']
      flags << '--wait'
    end

    flags.flatten.join(' ')
  end
end
