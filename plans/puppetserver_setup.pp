plan helm::puppetserver_setup(
  Optional[String] $collection = 'puppet7'
) {
  $puppet_server =  get_targets('*').filter |$n| { $n.vars['role'] == 'controller' }
  $puppet_server_facts = facts($puppet_server[0])
  $platform = $puppet_server_facts['platform']
  # install pe server
  run_task('provision::install_puppetserver', $puppet_server, { 'collection' => $collection, 'platform' => $platform })
}


