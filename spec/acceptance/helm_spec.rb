require 'spec_helper_acceptance'

describe 'the helm module' do

  describe 'kubernetes class' do
    context 'it should install the module and run' do

      pp = <<-MANIFEST
      if $::osfamily == 'RedHat'{
        class {'kubernetes':
                container_runtime => 'docker',
                manage_docker => false,
                controller => true,
                schedule_on_controller => true,
                environment  => ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
                ignore_preflight_errors => ['NumCPU'],
                cgroup_driver => 'cgroupfs'
              }
        }
      if $::osfamily == 'Debian'{
        class {'kubernetes':
                controller => true,
                schedule_on_controller => true,
                environment  => ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf'],
                ignore_preflight_errors => ['NumCPU'],
              }
        }
  MANIFEST
      it 'should run' do
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should install kubectl' do
        shell('kubectl', :acceptable_exit_codes => [0])
      end
      it 'should install kube-dns' do
        shell('KUBECONFIG=/etc/kubernetes/admin.conf kubectl get deploy --namespace kube-system coredns', :acceptable_exit_codes => [0])
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
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should install helm' do
        shell('helm', :acceptable_exit_codes => [0])
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
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should create chart' do
        shell('ls /tmp/myapptest', :acceptable_exit_codes => [0])
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
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should package chart' do
        shell('ls /root/.helm/repository/local/myapptest-0.1.0.tgz', :acceptable_exit_codes => [0])
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
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should deploy a package' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;helm ls | grep myapprelease', :acceptable_exit_codes => [0])
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
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should remove a deployment' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;helm ls | grep myapprelease', :acceptable_exit_codes => [1])
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
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should add helm repo' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;helm repo list | grep git', :acceptable_exit_codes => [0])
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
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should remove helm repo' do
        shell('export KUBECONFIG=/etc/kubernetes/admin.conf;helm repo list | grep git', :acceptable_exit_codes => [1])
      end
    end
  end
end
