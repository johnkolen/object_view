class PhoneNumber < ApplicationRecord
  belongs_to :person,
             inverse_of: :phone_numbers

  include ObjectView::MetaAttributes
  include ObjectView::ToParams
  include ObjectView::Dims

  # use same regex for both client- and server-side validation
  # single quotes due to the regex backslashes
  NUMBER_RE_STR = '\([0-9]{3}\)[0-9]{3}-[0-9]{4}'

  validates :number, format: {
              with: /#{NUMBER_RE_STR}/,
              message: "phone numbers must be of the form (123)456-7890"
            }

  def number_pattern
    NUMBER_RE_STR
  end
end
