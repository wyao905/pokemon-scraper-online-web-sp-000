require 'pry'

class Pokemon
  attr_accessor :name, :type, :hp
  attr_reader :id, :db
  
  def initialize(id: nil, name:, type:, db: @db, hp: 60)
    @id = id
    @name = name
    @type = type
    @hp = hp
  end
  
  def alter_hp(new_hp, db)
    self.hp = new_hp
    sql = "UPDATE pokemon SET hp = ? WHERE id = ?;"
    db.execute(sql, self.hp, self.id)
  end
  
  def self.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?)
    SQL
    
    db.execute(sql, name, type)
    
    @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
  end
  
  def self.find(id_num, db)
    sql = <<-SQL
      SELECT * FROM pokemon
      WHERE id = ?
    SQL
    
    found = db.execute(sql, id_num)[0]
    self.new(id: found[0], name: found[1], type: found[2], hp: found[3]) if self.
  end
end