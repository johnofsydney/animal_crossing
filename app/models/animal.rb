class Animal < ApplicationRecord
  AGE_GROUPS = {
    puppy: 180,
    adolescent: 780,
    adult: 3650,
    old: 7800
  }.freeze

  enum size: { small: 'small', medium: 'medium', large: 'large' }
  enum sex: { male: 'male', female: 'female' }

  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :breeds # rubocop:disable Rails/HasAndBelongsToMany

  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :breeds

  # TODO: use scopes for age groups. mabybe

  def age
    return "#{days_old / 7} weeks" if days_old < 180
    return "#{days_old / 30} months" if days_old < 780

    "#{days_old / 365} years"
  end

  def age_group
    return 'puppy' if days_old < AGE_GROUPS[:puppy]
    return 'adolescent' if days_old < AGE_GROUPS[:adolescent]
    return 'adult' if days_old < AGE_GROUPS[:adult]

    'old'
  end

  private

  def days_old
    @days_old ||= (Time.zone.today - self.dob).to_i
  end
end
