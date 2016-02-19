require 'spec_helper'

describe 'bamboo' do
  context 'supported operating systems' do

    context "bamboo::configure class without any parameters" do
      let(:params) {{ }}

      it { is_expected.to contain_file('/usr/local/bamboo/atlassian-bamboo-5.9.7/bin/setenv.sh').with(
          'owner'   => 'bamboo',
          'group'   => 'bamboo',
          'content' => /^BAMBOO_HOME="\/var\/local\/bamboo"$/,
        )
      }

      it { is_expected.to contain_file('/usr/local/bamboo/atlassian-bamboo-5.9.7/bin/setenv.sh').with(
          'content' => /^JVM_SUPPORT_RECOMMENDED_ARGS=""$/
        )
      }

      it { is_expected.to contain_file('/usr/local/bamboo/atlassian-bamboo-5.9.7/bin/setenv.sh').with(
          'content' => /^JVM_MINIMUM_MEMORY="256m"$/
        )
      }

      it { is_expected.to contain_file('/usr/local/bamboo/atlassian-bamboo-5.9.7/bin/setenv.sh').with(
          'content' => /^JVM_MAXIMUM_MEMORY="1024m"$/
        )
      }

      it { is_expected.to contain_file('/usr/local/bamboo/atlassian-bamboo-5.9.7/bin/setenv.sh').with(
          'content' => /^JAVA_OPTS=" -Xms\${JVM_MINIMUM_MEMORY}.*"/
        )
      }

      it { is_expected.to contain_file('/usr/local/bamboo/atlassian-bamboo-5.9.7/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties').with(
          'content' => /^bamboo\.home=\/var\/local\/bamboo$/
        )
      }

      it { is_expected.to contain_augeas('/usr/local/bamboo/atlassian-bamboo-5.9.7/conf/server.xml').with(
          'changes' => [
            "set Server/Service[#attribute/name='Catalina']/Engine/Host/Context/#attribute/path ''",
            "set Server/Service/Connector/#attribute/maxThreads '150'",
            "set Server/Service/Connector/#attribute/minSpareThreads '25'",
            "set Server/Service/Connector/#attribute/connectionTimeout '20000'",
            "set Server/Service/Connector/#attribute/port '8085'",
            "set Server/Service/Connector/#attribute/acceptCount '100'",
          ]
        )
      }

    end
    context "bamboo::configure class with custom java_opts" do
      let(:params) do
        {
          :jvm_opts => '-Foo -Bar',
        }
      end

      it { is_expected.to contain_file('/usr/local/bamboo/atlassian-bamboo-5.9.7/bin/setenv.sh').with(
          'content' => /^JAVA_OPTS="-Foo -Bar -Xms\${JVM_MINIMUM_MEMORY}.*"/
        )
      }
    end
    context "bamboo::configure class with custom tomcat settings" do
      let(:params) do
        {
          :max_threads        => '256',
          :min_spare_threads  => '100',
          :connection_timeout => '30000',
          :tomcat_port        => '9090',
          :accept_count       => '200',
          :proxy              => {
            'scheme'    => 'https',
            'proxyName' => 'bamboo.example.com',
            'proxyPort' => '443',
          },
        }
      end
      it { is_expected.to contain_augeas('/usr/local/bamboo/atlassian-bamboo-5.9.7/conf/server.xml').with(
          'changes' => [
            "set Server/Service[#attribute/name='Catalina']/Engine/Host/Context/#attribute/path ''",
            "set Server/Service/Connector/#attribute/maxThreads '256'",
            "set Server/Service/Connector/#attribute/minSpareThreads '100'",
            "set Server/Service/Connector/#attribute/connectionTimeout '30000'",
            "set Server/Service/Connector/#attribute/port '9090'",
            "set Server/Service/Connector/#attribute/acceptCount '200'",
            "set Server/Service/Connector/#attribute/scheme 'https'",
            "set Server/Service/Connector/#attribute/proxyName 'bamboo.example.com'",
            "set Server/Service/Connector/#attribute/proxyPort '443'",
          ]
        )
      }
    end

  end

end
