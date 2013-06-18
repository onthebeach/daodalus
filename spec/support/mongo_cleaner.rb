module MongoCleaner
  extend self

  def clean
    dao.remove
  end

  def dao
    @dao ||= Daodalus::DAO.new(:animalhouse, :cats)
  end

end
