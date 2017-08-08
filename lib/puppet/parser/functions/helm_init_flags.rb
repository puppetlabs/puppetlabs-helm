require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm init flags
  newfunction(:helm_init_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['init'].to_s != 'false'
      flags << 'init'
    end

    if opts['canary_image'].to_s == 'true'
      flags << '--canary-image'
    end

    if opts['client_only'].to_s != 'undef'
      flags << "--client-only '#{opts['client_only']}'"
    end

    if opts['debug'].to_s == 'true'
      flags << '--debug'
    end

    if opts['dry_run'].to_s == 'true'
      flags << '--dry_run'
    end

    if opts['local_repo_url'].to_s != 'undef'
      flags << "--local-repo-url '#{opts['local_repo_url']}'"
    end

    if opts['net_host'].to_s == 'true'
      flags << '--net-host'
    end

    if opts['service_account'].to_s != 'undef'
      flags << "--service-account '#{opts['service_account']}'"
    end

    if opts['skip_refresh'].to_s == 'true'
      flags << '--skip-refresh'
    end

    if opts['stable_repo_url'].to_s != 'undef'
      flags << "--stable-repo-url '#{opts['stable_repo_url']}'"
    end

    if opts['tiller_image'].to_s != 'undef'
      flags << "--tiller-image '#{opts['tiller_image']}'"
    end

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end

    if opts['tiller_tls'].to_s == 'true'
      flags << '--tiller-tls'
    end

    if opts['tiller_tls_cert'].to_s != 'undef'
      flags << "--tiller-tls-cert '#{opts['tiller_tls_cert']}'"
    end

    if opts['tiller_tls_key'].to_s != 'undef'
      flags << "--tiller-tls-key '#{opts['tiller_tls_key']}'"
    end

    if opts['tiller_tls_verify'].to_s == 'true'
      flags << '--tiller-tls-verify'
    end

    if opts['tls_ca_cert'].to_s != 'undef'
      flags << "--tls_ca_cert '#{opts['tls_ca_cert']}'"
    end

    if opts['upgrade'].to_s == 'true'
      flags << '--upgrade'
    end

    flags.flatten.join(" ")
  end
end
