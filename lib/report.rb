class Report
  attr_accessor :students, :xls, :path

  GRAPHS = {
    :age_group         => "Faixa Etária",
    :civil_state       => "Estado civil",
    :children          => "Filhos",
    :my_address        => "Reside em Franca",
    :transport         => "Locomoção",
    :address_situation => "Residência Própria",
    :living            => "Com quem mora",
    :family            => "Composição familiar",
    :family_work       => "Atividade Remunerada Familiar",
    :family_rent       => "Renda Familiar",
    :work              => "Area de trabalho",
    :school_life       => "Vida escolar",
    :know_languages    => "Idiomas"
  }

  PROPERTIES = {
    :civil_state       => :string,
    :children          => :string,
    :transport         => :string,
    :address_situation => :string,
    :living            => :string,
    :family            => :integer,
    :family_work       => :integer,
    :family_rent       => :string,
    :work              => :string,
    :school_life       => :string,
    :know_languages    => :string
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


  # TODO: Check invalid address to inform
  def my_address
    ceps = students.collect do |student|
      # Get only numbers
      text = student.cep.to_i.to_s.gsub(/[^\d]/, '')
      if text.size == 8
        # 14 - Initial of Franca CEP
          next("Sim") if student.cep.to_s[0..1] == "14"
      end
      "Não"
    end

    ceps.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end

  def method_missing(method, *args)
    if PROPERTIES.include?(method)
      to_graph_value(method, PROPERTIES[method])
    else
      super(method, *args)
    end
  end

  def to_graph_value(property, type)
    if type == :integer
      collection = students.collect{ |student| student.public_send(property).to_i }
    else
      collection = students.collect{ |student| student.public_send(property).to_s.capitalize }
    end
    collection.group_by {|value| value}.inject({}) {|hash, (key, value)| hash[key] = value.size; hash}
  end
end

