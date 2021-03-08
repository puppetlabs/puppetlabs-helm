require 'spec_helper_acceptance'

describe 'the helm module', :integration do

  describe 'kubernetes class' do
    context 'it should install the module and run' do

      pp = <<-MANIFEST
      if $::osfamily == 'RedHat'{
        class {'kubernetes':
                kubernetes_version => '1.13.5',
                kubernetes_package_version => '1.13.5',
                container_runtime => 'docker',
                manage_docker => false,
                etcd_hostname => 'localhost.localdomain',
                controller => true,
                schedule_on_controller => true,
                environment  => ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
                ignore_preflight_errors => ['NumCPU'],
                cgroup_driver => 'cgroupfs'
              }
        }
      if $::osfamily == 'Debian'{
        class {'kubernetes':
                kubernetes_version => '1.13.5',
                kubernetes_package_version => '1.13.5-00',
                controller => true,
                schedule_on_controller => true,
                environment  => ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
                ignore_preflight_errors => ['NumCPU'],
              }
        }
  MANIFEST
      it 'should run' do
        apply_manifest(pp)
      end
      it 'should install kubectl' do
        run_shell('kubectl')
      end
      it 'should install kube-dns' do
        run_shell('KUBECONFIG=/etc/kubernetes/admin.conf kubectl get deploy --namespace kube-system coredns')
        sleep(60)
      end
    end
  end

  describe 'helm class' do
    context 'it should install the module' do
      let(:pp) {"
      include helm
      "}
      it 'should run' do
        apply_manifest(pp)
      end
      it 'should install helm' do
        run_shell('helm')
      end
    end
    context 'it should install the module' do
      let(:pp) {"
      helm::create { 'myapptest':
        env        => [ 'HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
        chart_path => '/tmp',
        chart_name => 'myapptest',
        path       =>  ['/bin','/usr/bin'],
      }
      "}
      it 'should run' do
        apply_manifest(pp)
      end
      it 'should create chart' do
        run_shell('ls /tmp/myapptest')
      end
    end

    context 'it should install the module' do
      let(:pp) {"
      helm::package { 'myapptest':
         chart_path  => '/tmp',
         chart_name  => 'myapptest',
         destination => '/root',
         env         => [ 'HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'] ,
         path        => ['/bin','/usr/bin'],
         version     => '0.1.0',
      }
      "}
      it 'should run' do
        apply_manifest(pp,)
      end
      it 'should package chart' do
        run_shell('ls /root/myapptest-0.1.0.tgz')
      end
    end

    context 'it should install the module' do
      let(:pp) {"
      helm::chart { 'myapptest':
          ensure       => present,
          chart        => '/root/myapptest-0.1.0.tgz',
          env          => [ 'HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
          path         => ['/bin','/usr/bin'],
          release_name => 'myapprelease',
      }
      "}
      it 'should run' do
        apply_manifest(pp)
      end
      it 'should deploy a package' do
        run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;helm ls | grep myapprelease')
      end
    end

    context 'it should install the module' do
      let(:pp) {"
      helm::chart { 'myapptest':
          ensure       => absent,
          chart        => 'local/myapptest',
          env          => [ 'HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
          path         => ['/bin','/usr/bin'],
          release_name => 'myapprelease',
      }
      "}
      it 'should run' do
        apply_manifest(pp)
      end
      it 'should remove a deployment' do
        run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;helm ls | grep myapprelease', expect_failures: true)
      end
    end

    context 'it should install the module' do
      let(:pp) {"
      helm::repo { 'myrepo':
          ensure => present,
          env    => [ 'HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
          path   => ['/bin','/usr/bin'],
          repo_name => 'myrepo',
          url       => 'https://raw.githubusercontent.com/sheenaajay/helmchart/master/charts/'
      }
      "}
      it 'should run' do
        apply_manifest(pp)
      end
      it 'should add helm repo' do
        run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;helm repo list | grep git')
      end
    end

    context 'it should remove a helm repo' do
      let(:pp) {"
        helm::repo { 'myrepo':
          ensure => absent,
          env    => [ 'HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
          path   => ['/bin','/usr/bin'],
          repo_name => 'myrepo',
          url       => 'https://raw.githubusercontent.com/sheenaajay/helmchart/master/charts/'
        }
      "}
      it 'should run' do
        apply_manifest(pp)
      end
      it 'should remove helm repo' do
        run_shell('export KUBECONFIG=/etc/kubernetes/admin.conf;helm repo list | grep git', expect_failures: true)
      end
    end
  end
end
