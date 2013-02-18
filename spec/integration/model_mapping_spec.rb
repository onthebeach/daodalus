require 'spec_helper'

class Cat
  include Daodalus::Model

  field :name
  field :legs, type: Integer
end

describe "model_mapping" do
  pending
end
