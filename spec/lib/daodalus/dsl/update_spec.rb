require 'spec_helper'

module Daodalus
  module DSL
    describe Update do
      let (:dao) { stub }
      let (:update) { Update.new(dao) }

      describe "#set" do
        it 'adds a set command to the update clause' do
          update.set(:cats, 4).update_clause.
            should eq ({'$set' => {'cats' => 4}})
        end
        it 'works with multiple clause' do
          update.set(:cats, 4).set(:dogs, 3).update_clause.
            should eq ({'$set' => {'cats' => 4, 'dogs' => 3}})
        end
      end

      describe "#unset" do
        it 'adds an unset command to the update clause' do
          update.unset(:cats).update_clause.
            should eq ({'$unset' => {'cats' => ''}})
        end
      end

      describe "#inc" do
        it 'adds an inc command to the update clause' do
          update.inc(:cats).update_clause.
            should eq ({'$inc' => {'cats' => 1}})
        end
      end

      describe "#dec" do
        it 'adds an inc command to the update clause with the negated value' do
          update.dec(:cats).update_clause.
            should eq ({'$inc' => {'cats' => -1}})
        end
      end

      describe "#rename" do
        it 'adds a rename command to the update clause' do
          update.rename(:cats, :kittehs).update_clause.
            should eq ({'$rename' => {'cats' => 'kittehs'}})
        end
      end

      describe "#push" do
        it 'adds a push command to the update clause' do
          update.push(:cats, "Binx").update_clause.
            should eq ({'$push' => {'cats' => 'Binx'}})
        end
        it 'also works with multiple values' do
          update.push(:cats, "Binx", "Caramel").update_clause.
            should eq ({'$pushAll' => {'cats' => ['Binx', 'Caramel']}})
        end
      end

      describe "#push_all" do
        it 'adds a pushAll command to the update clause' do
          update.push_all(:cats, ["Binx", "Caramel"]).update_clause.
            should eq ({'$pushAll' => {'cats' => ['Binx', 'Caramel']}})
        end
      end

      describe "#add_to_set" do
        it 'adds a addToSet command to the update clause' do
          update.add_to_set(:cats, "Binx").update_clause.
            should eq ({'$addToSet' => {'cats' => 'Binx'}})
        end
        it 'also works with multiple values' do
          update.add_to_set(:cats, "Binx", "Caramel").update_clause.
            should eq ({'$addToSet' => {'cats' => { '$each' => ['Binx', 'Caramel']}}})
        end
      end

      describe "#add_each_to_set" do
        it 'adds a addToSet command to the update clause' do
          update.add_each_to_set(:cats, ["Binx", "Caramel"]).update_clause.
            should eq ({'$addToSet' => {'cats' => { '$each' => ['Binx', 'Caramel']}}})
        end
      end

      describe "#pop" do
        it 'adds a pop command to the update clause' do
          update.pop(:cats).update_clause.
            should eq ({'$pop' => {'cats' => 1}})
        end
      end

      describe "#pop_first" do
        it 'adds a pop first command to the update clause' do
          update.pop_first(:cats).update_clause.
            should eq ({'$pop' => {'cats' => -1}})
        end
      end

      describe "#pull" do
        it 'adds a pull command to the update clause' do
          update.pull(:cats, 4).update_clause.
            should eq ({'$pull' => {'cats' => 4}})
        end
        it 'also works with multiple values' do
          update.pull(:cats, "Binx", "Caramel").update_clause.
            should eq ({'$pullAll' => {'cats' => ['Binx', 'Caramel']}})
        end
      end

      describe "#pull_all" do
        it 'adds a pullAll command to the update clause' do
          update.pull_all(:cats, ["Binx", "Caramel"]).update_clause.
            should eq ({'$pullAll' => {'cats' => ['Binx', 'Caramel']}})
        end
      end

      describe "#upsert" do
        it "adds the upsert flag to the update clause" do
          dao.should_receive(:update).
            with({}, {}, {:upsert => true})
          update.upsert
        end
      end

    end
  end
end
