require 'shellwords'
#
# helm_create_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of helm create flags
  newfunction(:helm_create_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << '--debug' if opts['debug']
    flags << "--home '#{opts['home']}'" if opts['home'].to_s != 'undef'
    flags << "--host '#{opts['host']}'" if opts['host'].to_s != 'undef'
    flags << "--kube-context '#{opts['kube_context']}'" if opts['kube_context'].to_s != 'undef'
    flags << "--starter '#{opts['starter']}" if opts['starter'].to_s != 'undef'
    flags << "--tiller-namespace '#{opts['tiller_namespace']}'" if opts['tiller_namespace'].to_s != 'undef'
    flags << "'#{opts['chart_path']}/#{opts['chart_name']}'" if opts['chart_path'].to_s != 'undef' && opts['chart_name'].to_s != 'undef'
    flags.flatten.join(' ')
  end
end
