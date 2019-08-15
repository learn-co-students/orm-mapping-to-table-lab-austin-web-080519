class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY, 
      name TEXT,
      grade INTEGER
    )  
    SQL

    #alternative way to do this would be ... sql = "CREATE TABLE students( etc....)"
    
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql,self.name, self.grade)
    
   #@id = DB[:conn].execute("SELECT students.id FROM students WHERE students.name = ? AND students.grade = ?", self.name, self.grade).first
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    #new_student = Student.new(attributes.each = self.send{|key, value|("#{key}="), value})
    new_student = Student.new(name, grade)
    new_student.save
    return new_student
  end
end
