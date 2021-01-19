# frozen_string_literal: true

require 'shellwords'
#
# helm_repo_add_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of helm repo add flags
  newfunction(:helm_repo_add_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << 'add' if opts['ensure'].to_s == 'present'
    flags << "--ca-file '#{opts['ca_file']}'" if opts['ca_file'] && opts['ca_file'].to_s != 'undef'
    flags << "--cert-file '#{opts['cert_file']}'" if opts['cert_file'] && opts['cert_file'].to_s != 'undef'
    flags << '--debug' if opts['debug']
    flags << "--repo-name '#{opts['key_file']}'" if opts['key_file'] && opts['key_file'].to_s != 'undef'
    flags << '--no-update' if opts['no_update']
    flags << "--home '#{opts['home']}'" if opts['home'] && opts['home'].to_s != 'undef'
    flags << "--host '#{opts['host']}'" if opts['host'] && opts['host'].to_s != 'undef'
    flags << "--kube-context '#{opts['kube_context']}'" if opts['kube_context'] && opts['kube_context'].to_s != 'undef'
    flags << "--tiller-namespace '#{opts['tiller_namespace']}'" if opts['tiller_namespace'] && opts['tiller_namespace'].to_s != 'undef'
    flags << "--username '#{opts['username']}'" if opts['username'] && opts['username'].to_s != 'undef'
    flags << "--password '#{opts['password']}'" if opts['password'] && opts['password'].to_s != 'undef'
    flags << "'#{opts['repo_name']}'" if opts['repo_name'] && opts['repo_name'].to_s != 'undef'
    flags << "'#{opts['url']}'" if opts['url'] && opts['url'].to_s != 'undef'
    flags.flatten.join(' ')
  end
end
