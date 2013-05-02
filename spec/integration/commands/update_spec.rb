require 'spec_helper'

describe "#update" do

  before :each do
    CatDAO.remove_all
  end

  subject { CatDAO }

  it 'works when the last link in the chain is a where clause' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      inc(:paws).
      where(:name).eq('Felix').
      update

    subject.find_one.fetch('paws').should eq 5
  end

  it 'works when the last link in the chain is an update clause' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      inc(:paws).
      update

    subject.find_one.fetch('paws').should eq 5
  end

end

describe "#upsert" do
  before :each do
    CatDAO.remove_all
  end

  subject { CatDAO }

  it 'updates when the record exists' do
    subject.insert(name: "Kiki", mental: true)

    subject.
      set(:mental, false).
      where(:name).eq("Kiki").
      upsert

    subject.find_one.fetch('mental').should eq false
  end

  it 'creates a new record when absent' do
    subject.
      set(:mental, true).
      where(:name).eq("Kiki").
      upsert

    subject.find_one.fetch('mental').should eq true
  end
end
