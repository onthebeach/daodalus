Cat = Struct.new(:name, :legs, :type) do
  extend Daodalus::DAO

  target :cathouse, :cats

  def data
    {
      name: name,
      legs: legs,
      type: type
    }
  end
end
