# == Schema Information
#
# Table name: animals
#
#  id                                     :bigint           not null, primary key
#  name                                   :string
#  dob                                    :date
#  description                            :string
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  size                                   :string
#  sex                                    :string
#  good_with_small_children               :boolean
#  good_with_older_children               :boolean
#  good_with_other_dogs                   :boolean
#  good_with_cats                         :boolean
#  can_be_left_alone_during_working_hours :boolean
#  apartment_friendly                     :boolean
#  adopted_by_name                        :string
#  adopted_by_email                       :string
#  adopted_by_phone                       :string
#  adopted_date                           :date
#  species                                :string
#
class Animal < ApplicationRecord
  AGE_GROUPS = {
    puppy: 180,
    adolescent: 780,
    adult: 3650,
    old: 7800
  }.freeze

  enum size: { small: 'small', medium: 'medium', large: 'large' }
  enum sex: { male: 'male', female: 'female' }
  enum species: { dog: 'dog', cat: 'cat', other: 'other' }

  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :breeds # rubocop:disable Rails/HasAndBelongsToMany

  # TODO: nested attributes is hard
  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :breeds

  validates :name, presence: true
  validates :size, presence: true
  validates :sex, presence: true
  validates :species, presence: true

  scope :adopted, -> { where.not(adopted_date: nil) }
  scope :not_adopted, -> { where(adopted_date: nil) }
  # TODO: use scopes for age groups. mabybe

  def age
    return "#{days_old / 7} weeks old" if days_old < 180
    return "#{days_old / 30} months old" if days_old < 780

    "#{days_old / 365} years old"
  end

  def age_group
    return 'puppy' if days_old < AGE_GROUPS[:puppy]
    return 'adolescent' if days_old < AGE_GROUPS[:adolescent]
    return 'adult' if days_old < AGE_GROUPS[:adult]

    'old'
  end

  def summary
    "#{self.size.capitalize} #{self.sex} #{self.breeds.any? ? self.breeds_summary : self.species}, approximately #{self.age}."
  end

  def breeds_summary
    return '' if self.breeds.empty?
    return breeds.first.breed if breeds.count == 1

    self.breeds.map(&:breed).join(' x ')
  end

  def adopted?
    self.adopted_date.present?
  end

  private

  def days_old
    return @days_old = 99999 unless self.dob.present?

    @days_old ||= (Time.zone.today - self.dob).to_i
  end
end
