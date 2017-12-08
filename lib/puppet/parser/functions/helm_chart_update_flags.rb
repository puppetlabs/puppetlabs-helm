require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm install chart flags
  newfunction(:helm_chart_update_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    flags << 'upgrade' if opts['ensure'].to_s == 'present'

    flags << "'#{opts['release_name']}'" if opts['release_name'].to_s != 'undef'

    flags << "'#{opts['chart']}'" if opts['chart'].to_s != 'undef'

    flags << '--install' if opts['install']

    flags << "--ca-file '#{opts['ca_file']}'" if opts['ca_file'].to_s != 'undef'

    if opts['cert_file'].to_s != 'undef'
      flags << "--cert-file '#{opts['cert_file']}'"
    end

    flags << '--debug' if opts['debug']

    flags << '--devel' if opts['devel']

    flags << '--dry_run' if opts['dry_run']

    if opts['key_file'].to_s != 'undef'
      flags << "--key-file '#{opts['key_file']}'"
    end

    flags << "--keyring '#{opts['keyring']}'" if opts['keyring'].to_s != 'undef'

    flags << "--home '#{opts['home']}'" if opts['home'].to_s != 'undef'

    flags << "--host '#{opts['host']}'" if opts['host'].to_s != 'undef'

    if opts['kube_context'].to_s != 'undef'
      flags << "--kube-context '#{opts['kube_context']}'"
    end

    if opts['namespace'].to_s != 'undef'
      flags << "--namespace '#{opts['namespace']}'"
    end

    flags << '--no-hooks' if opts['no_hooks']

    flags << '--recreate-pods' if opts['recreate_pods']

    flags << '--reset-values' if opts['reset_values']

    flags << '--reuse-values' if opts['reuse_values']

    flags << "--repo '#{opts['repo']}'" if opts['repo'].to_s != 'undef'

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

    flags << "--timeout '#{opts['timeout']}'" if opts['timeout'].to_s != 'undef'

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end

    flags << '--tls' if opts['tls']

    if opts['tls_ca_cert'].to_s != 'undef'
      flags << "--tls-ca-cert '#{opts['tls_ca_cert']}'"
    end

    if opts['tls_cert'].to_s != 'undef'
      flags << "--tls-cert '#{opts['tls_cert']}'"
    end

    flags << "--tls-key '#{opts['tls_key']}'" if opts['tls_key'].to_s != 'undef'

    flags << '--tls-verify' if opts['tls_verify']

    flags << '--verify' if opts['verify']

    flags << "--version '#{opts['version']}'" if opts['version'].to_s != 'undef'

    flags << '--wait' if opts['wait']

    flags.flatten.join(' ')
  end
end
