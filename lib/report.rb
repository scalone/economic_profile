class Report
  attr_accessor :students, :xls, :path

  GRAPHS = {
    :age_group         => "Faixa Etária",
    :civil_state       => "Estado civil",
    :suns              => "Filhos",
    :my_address        => "Reside em Franca",
    :locomotion        => "Locomoção",
    :address_situation => "Residência Própria",
    :live_with         => "Com quem mora",
    :family            => "Composição familiar",
    :activity          => "Atividade Remunerada Familiar",
    :rent              => "Renda Familiar",
    :working_area      => "Area de trabalho",
    :school_life       => "Vida escolar",
    :languages         => "Idiomas"
  }

  def initialize(path)
    @path     = path
    @xls      =  Roo::Excel.new(path)
    create_students
  end

  def create_students
    @students = []
    xls.each_with_index do |row, index|
      next if index == 0
      @students << Student.new(row)
    end 
  end

  def graphs
    GRAPHS.inject([]) do |list, (graph_method, title)|
      list << [title, self.send(graph_method)]
    end
  end

  def age_group
    ages = students.collect do |student|
      ((Time.now - student.born_date.to_time) / 60 / 60 / 24 / 30 / 12).abs.to_i
    end

    result = {"Menor que 20" => 0, "Entre 21 e 30" => 0, "Entre 31 e 40" => 0, "Maior que 40" => 0}

    ages.each do |age|
      if age < 20
        result["Menor que 20"] += 1
      elsif (21..30).include? age
        result["Entre 21 e 30"] += 1
      elsif (31..40).include? age
        result["Entre 31 e 40"] += 1
      elsif age > 40
        result["Maior que 40"] += 1
      end
    end

    result
  end

  def civil_state
    states = students.collect{ |student| student.civil_state.capitalize }
    states.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def suns
    children = students.collect{ |student| student.children.capitalize }
    children.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  # TODO: Check invalid address to inform
  def my_address
    ceps = students.collect do |student|
      # Get only numbers
      text = student.cep.to_i.to_s.gsub(/[^\d]/, '')
      if text.size == 8
        # 14 - Initial of Franca CEP
          next("sim") if student.cep.to_s[0..1] == "14"
      end
      "Não"
    end

    ceps.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def locomotion
    transports = students.collect{ |student| student.transport.capitalize }
    transports.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def address_situation
    situations = students.collect{ |student| student.address_situation.capitalize }
    situations.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def live_with
    collection = students.collect{ |student| student.living.capitalize }
    collection.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def family
    collection = students.collect{ |student| student.family_composition_number.to_i }
    collection.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def activity
    collection = students.collect{ |student| student.family_worker_number.to_i }
    collection.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def rent
    collection = students.collect{ |student| student.family_rent }
    collection.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def working_area
    collection = students.collect{ |student| student.work }
    collection.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def school_life
    collection = students.collect{ |student| student.school_life }
    collection.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def languages
    collection = students.collect{ |student| student.know_languages }
    collection.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end
end

