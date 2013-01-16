require 'spec_helper'

module Daodalus

  describe Connection do

    let(:connection) { Connection.new(config) }

    describe '#config' do
      let(:config) { stub(:config) }
      it 'returns the MongoDB config' do
        connection.config.should eq config
      end
    end

    context "given a single server config" do
      let(:config) {{
        "pool_size"=>10,
        "database"=>"daodalus_test",
        "host"=>"localhost",
        "servers"=>[{"host"=>"localhost", "port"=>27017}],
        "replicate_set_name"=>"daodalus",
        "timeout"=> 5,
        "read"=>"primary",
        "refresh_mode"=>"sync",
        "refresh_interval"=>"60",
        "safe"=>{"w" => 2, "wtimeout" => 200, "j" => true}
      }}

      describe "#database_name" do
        it "returns the 'database' value from the config" do
          connection.database_name.should eq 'daodalus_test'
        end
      end

      describe "#pool_size" do
        it "returns the 'pool_size' value from the config" do
          connection.pool_size.should eq 10
        end
      end

      describe "#timeout" do
        it "returns the 'timeout' value from the config" do
          connection.timeout.should eq 5
        end
      end

      describe "#refresh_mode" do
        it "returns the 'refresh_mode' value from the config" do
          connection.refresh_mode.should eq :sync
        end
      end

      describe "#refresh_interval" do
        it "returns the 'refresh_interval' value from the config" do
          connection.refresh_interval.should eq 60
        end
      end

      describe "#servers" do
        it "returns the 'servers' value from the config" do
          connection.servers.should eq [{"host"=>"localhost", "port"=>27017}]
        end
      end

      describe "#read" do
        it "returns the 'read' value from the config" do
          connection.read.should eq :primary
        end
      end

      describe "#safe" do
        it "returns the 'safe' value from the config" do
          connection.safe.should eq({:w => 2, :wtimeout => 200, :j => true})
        end
      end

      describe '#single_server_options' do
        it "returns an options array with the correct elements" do
          connection.single_server_options.should eq [
            "localhost", 27017,
            { :pool_size => 10, :pool_timeout => 5 }
          ]
        end
      end

      describe '#db' do
        let(:db) { stub }
        let(:pool) { stub(:[] => db) }

        subject { connection.db }

        context 'when there is a successful connection' do

          before do
            Mongo::MongoClient.should_receive(:new).
              once.
              with(*connection.single_server_options).
              and_return(pool)
          end

          it 'creates a new Mongo::Connection' do
            subject
          end

          it 'does not create a new Mongo::Connection on subsequent calls' do
            subject
            subject
          end

        end

        context "when there is a connection failure" do
          before do
            Mongo::MongoClient.should_receive(:new).and_raise(Mongo::ConnectionFailure)
          end

          it 'raises any connection failures' do
            expect { subject }.to raise_error(Mongo::ConnectionFailure)
          end
        end
      end
    end

    context "given a replica set config" do
      let(:config) {{
        "replicate_set_name"=>"daodalus",
        "timeout"=>5,
        "pool_size"=>10,
        "database"=>"daodalus_test",
        "host"=>"localhost",
        "read"=>"primary",
        "servers"=>[
          {"port"=>27017, "host"=>"127.0.0.1"},
          {"port"=>27017, "host"=>"127.0.0.2"},
          {"port"=>27017, "host"=>"127.0.0.3"}
        ],
        "safe"=>{"w" => 2, "wtimeout" => 200, "j" => true}
      }}

      describe '#replica_set_options' do

        it "returns an options array with the correct elements" do
          connection.replica_set_options.should eq [
            ["127.0.0.1:27017",
              "127.0.0.2:27017",
              "127.0.0.3:27017"
          ],
            {
            :pool_size => 10,
            :pool_timeout => 5,
            :refresh_mode => false,
            :refresh_interval => 90,
            :read => :primary,
            :safe=>{:w => 2, :wtimeout => 200, :j => true}
          }
          ]
        end
      end

      describe '#db' do
        let(:db) { stub }
        let(:pool) { stub(:[] => db) }

        subject { connection.db }

        context 'when there is a successful connection' do

          before do
            Mongo::MongoReplicaSetClient.should_receive(:new).
              once.
              with(*connection.replica_set_options).
              and_return(pool)
          end

          it 'creates a new Mongo::MongoClient' do
            subject
          end

          it 'does not create a new Mongo::MongoClient on subsequent calls' do
            subject
            subject
          end

        end

        context "when there is a connection failure" do
          before do
            Mongo::MongoReplicaSetClient.should_receive(:new).and_raise(Mongo::ConnectionFailure)
          end

          it 'raises any connection failures' do
            expect { subject }.to raise_error(Mongo::ConnectionFailure)
          end
        end
      end
    end
  end
end
