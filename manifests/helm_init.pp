class helm::helm_init (


) {

	helm::config { 'kube-controller': 
    init => true,
    service_account => 'tiller',
    tiller_namespace => 'kube-system'
	}
	
}