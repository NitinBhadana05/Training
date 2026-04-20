class AgeValidator < ActiveModel::Validator
  def validate(record)
    if record.age.nil? || record.age < 18
      record.errors.add(:age, "must be at least 18")
    end
  end
end