require 'spec_helper'

module Daodalus
  describe Pool do

    let (:pool) { Pool.instance }

    describe "#connection" do

      context "when given a valid connection name" do
        it "returns the specified connection" do
          pool['conn1'].should be_a Connection
        end
      end

      context "when given an invalid connection name" do
        it "raises an error" do
          expect { pool['not_exist'] }.to raise_error InvalidConnectionError
        end
      end

    end
  end
end

