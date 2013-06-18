require 'spec_helper'

describe "a pathetic attempt to get the hits/line up to 10x per line" do
  it 'is pathetic' do
    142.times do
      Daodalus::DAO.new(:animalhouse, :cats)
    end
  end
end
