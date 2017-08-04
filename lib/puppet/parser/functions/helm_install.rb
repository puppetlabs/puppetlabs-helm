require 'shellwords'

module Puppet::Parser::Functions
  # Transforms a hash into a string of helm install chart flags
  newfunction(:helm_install_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['ca_file'].to_s != 'undef'
      flags << "--ca-file '#{opts['ca_file']}'"
    end

    if opts['cert_file'].to_s != 'undef'
      flags << "--cert-file '#{opts['cert_file']}'"
    end

    if opts['devel'].to_s != 'undef'
      flags << "--devel '#{opts['devel']}'"
    end        

    if opts['dry_run'].to_s != 'undef'
      flags << "--dry_run '#{opts['dry_run']}'"
    end    

    if opts['key_file'].to_s != 'undef'
      flags << "--key-file '#{opts['key_file']}'"
    end

    if opts['key_ring'].to_s != 'undef'
      flags << "--key-ring '#{opts['key_ring']}'"
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

    if opts['name'].to_s != 'undef'
      flags << "--name '#{opts['name']}'"
    end

    if opts['name_template'].to_s != 'undef'
      flags << "--name-template '#{opts['name_template']}'"
    end  

    if opts['namespace'].to_s != 'undef'
      flags << "--namespace '#{opts['namespace']}'"
    end

    if opts['no_hooks'].to_s != 'undef'
      flags << "--no-hooks '#{opts['no_hooks']}'"
    end   

    if opts['replace'].to_s != 'undef'
      flags << "--replace '#{opts['replace']}'"
    end 

    if opts['repo'].to_s != 'undef'
      flags << "--repo '#{opts['repo']}'"
    end

    if opts['set'].to_s != 'undef'
      flags << "--set '#{opts['set']}'"
    end  

    if opts['timeout'].to_s != 'undef'
      flags << "--timeout '#{opts['timeout']}'"
    end 

    if opts['tiller_namespace'].to_s != 'undef'
      flags << "--tiller-namespace '#{opts['tiller_namespace']}'"
    end 

    if opts['tiller_tls'].to_s != 'undef'
      flags << "--tiller-tls '#{opts['tiller_tls']}'"
    end

    if opts['tiller_tls_cert'].to_s != 'undef'
      flags << "--tiller-tls-cert '#{opts['tiller_tls_cert']}'"
    end
  
    if opts['tiller_tls_key'].to_s != 'undef'
      flags << "--tiller-tls-key '#{opts['tiller_tls_key']}'"
    end

    if opts['tls'].to_s != 'undef'
      flags << "--tls '#{opts['tls']}'"
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

    if opts['tls_verify'].to_s != 'undef'
      flags << "--tls-verify '#{opts['tls_verify']}'"
    end

    if opts['values'].to_s != 'undef'
      flags << "--values '#{opts['values']}'"
    end

    if opts['verify'].to_s != 'undef'
      flags << "--verify '#{opts['verify']}'"
    end   

    if opts['version'].to_s != 'undef'
      flags << "--version '#{opts['version']}'"
    end     
      
    if opts['wait'].to_s != 'undef'
      flags << "--wait '#{opts['wait']}'"
    end
   flags.flatten.join(" ")
  end
end
