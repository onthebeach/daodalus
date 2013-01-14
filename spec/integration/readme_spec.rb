require 'spec_helper'

class ReadmeDAO
  extend Daodalus::DAO
  target :animals, :cats # or overide `connection` to supply your own

  def self.example_find
    select(:name).where(:paws).less_than(4).find
  end

  def self.example_find_one
    where(:collar_id).eq("aochc986").find_one
  end

  def self.example_update
    set(:stray, true).where(:address).does_not_exist.update
  end

  def self.example_find_and_modify
    dec(:lives).
      push(:names, "Kitty").
      where(:stray).eq(true).
      and(:cuteness).gt(8).
      find_and_modify(new: true)
  end

  def self.example_remove
    where(:lives).eq(0).remove
  end

  def self.example_aggregation
    match(:lives).gt(3).
      and(:address).exists.
      unwind(:favourite_foods).
      group(:favourite_foods).min(min_paws: 'paws').
      sort(:_id).
      limit(10).
      project(:_id).as(:food).and(:min_paws).
      aggregate
  end

end

describe "README examples" do

  it "can run finds" do
    ReadmeDAO.should_receive(:find).with(
      {"paws"=>{"$lt"=>4}},
      {:fields=>{"_id"=>0, "name"=>1}}
    )
    ReadmeDAO.example_find
  end

  it "can run find_ones" do
    ReadmeDAO.should_receive(:find_one).with(
      {"collar_id"=>"aochc986"}, {}
    )
    ReadmeDAO.example_find_one
  end

  it "can run updates" do
    ReadmeDAO.should_receive(:update).with(
      {"address"=>{"$exists"=>false}},
      {"$set"=>{"stray"=>true}},
      {}
    )
    ReadmeDAO.example_update
  end

  it "can run find_and_modify" do
    ReadmeDAO.should_receive(:find_and_modify).with(
      {:new=>true,
        :query=>{"stray"=>true, "cuteness"=>{"$gt"=>8}},
        :update=>{"$inc"=>{"lives"=>-1}, "$push"=>{"names"=>"Kitty"}}}
    )
    ReadmeDAO.example_find_and_modify
  end

  it "can run aggregation framework queries" do
    ReadmeDAO.should_receive(:aggregate).with(
    [{"$match"=>{"lives"=>{"$gt"=>3}, "address"=>{"$exists"=>true}}},
      {"$unwind"=>"$favourite_foods"},
      {"$group"=>{"_id"=>"$favourite_foods", "min_paws"=>{"$min"=>"$paws"}}},
      {"$sort"=>{"_id"=>1}},
      {"$limit"=>10},
      {"$project"=>{"_id"=>0, "food"=>"$_id", "min_paws"=>"$min_paws"}}
    ])
    ReadmeDAO.example_aggregation
  end

end
