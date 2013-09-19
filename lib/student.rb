class Student
  SCHEME = {
    :datetime_send             => 0,
    :name                      => 1,
    :period                    => 2,
    :rg                        => 3,
    :cpf                       => 4,
    :born_date                 => 5,
    :civil_state               => 6,
    :children                  => 7,
    :children_number           => 8,
    :address                   => 9,
    :cep                       => 10,
    :phone                     => 11,
    :cell_phone                => 12,
    :contact_phone             => 13,
    :mail                      => 14,
    :transport                 => 15,
    :address_situation         => 16,
    :aged_address              => 17,
    :living                    => 18,
    :family_composition_number => 19,
    :family_worker_number      => 20,
    :family_rent               => 21,
    :work                      => 22,
    :work_period               => 23,
    :school_life               => 24,
    :know_languages            => 25,
    :languages                 => 26,
    :already_study_here        => 27,
    :past_study_course         => 28,
    :why_stud                  => 29
  }

  attr_accessor :row, :klass

  def initialize(row)
    @row = row
  end

  def method_missing(method, *args)
    if Student::SCHEME.include?(method)
      row[Student::SCHEME[method]]
    else
      super(method, *args)
    end
  end
end

class Klass
  attr_accessor :students, :xls, :path

  GRAPHS = {
    :age_group    => "Faixa Etária",
    :civil_state  => "Estado civil",
    :suns         => "Filhos",
    :my_address   => "Residência Própria",
    :locomotion   => "Locomoção"
  }

  #GRAPHS = {
    #:age_group    => "Faixa Etária",
    #:civil_state  => "Estado civil",
    #:suns         => "Filhos",
    #:address      => "Residencia em Franca",
    #:locomotion   => "Locomoção",
    #:live_with    => "Com quem mora",
    #:family       => "Composição familiar",
    #:activity     => "Atividade Remunerada Familiar",
    #:rent         => "Renda Familiar",
    #:working_area => "Area de trabalho",
    #:school_life  => "Vida escolar",
    #:knowledge    => "Tem Conhecimento de Informática",
    #:languages    => "Idiomas",
    #:deficiency   => "Deficiência"
  #}



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
end
