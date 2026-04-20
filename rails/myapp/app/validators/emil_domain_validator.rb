class EmailDomainValidator < ActiveModel::Validator
  def validate(record)
    unless record.email&.end_with?("@company.com")
      record.errors.add(:email, "must be a company email")
    end
  end
end