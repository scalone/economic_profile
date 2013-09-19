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
    :family                    => 19,
    :family_work               => 20,
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

