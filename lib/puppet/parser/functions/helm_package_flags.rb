require 'shellwords'
#
# helm_package_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of helm package flags
  newfunction(:helm_package_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << '--debug' if opts['debug']
    flags << '--dependency-update' if opts['dependency_update']
    flags << "--destination '#{opts['destination']}'" if opts['destination'].to_s != 'undef'
    flags << "--home '#{opts['home']}'" if opts['home'].to_s != 'undef'
    flags << "--host '#{opts['host']}'" if opts['host'].to_s != 'undef'
    flags << "--key '#{opts['key']}'" if opts['key'].to_s != 'undef'
    flags << "--keystring '#{opts['keystrings']}'" if opts['keystring'].to_s != 'undef'
    flags << "--kube-context '#{opts['kube_context']}'" if opts['kube_context'].to_s != 'undef'
    flags << '--save' if opts['save']
    flags << '--sign' if opts['sign']
    flags << "--tiller-namespace '#{opts['tiller_namespace']}'" if opts['tiller_namespace'].to_s != 'undef'
    flags << "--version '#{opts['version']}'" if opts['version'].to_s != 'undef'
    flags << "'#{opts['chart_path']}/#{opts['chart_name']}'" if opts['chart_path'].to_s != 'undef' && opts['chart_name'].to_s != 'undef'
    flags.flatten.join(' ')
  end
end
