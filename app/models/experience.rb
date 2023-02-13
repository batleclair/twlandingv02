class Experience < ApplicationRecord
  belongs_to :candidate
  validates :employer, presence: { message: 'Renseigne le nom de ton employeur, client ou projet' }
  validates :title, presence: { message: 'Précise un intitulé de poste ou de mission' }
  validates :start_date, presence: { message: "Veuillez indiquer une date de début" }
  validates :start_date, format: {with: /\A[1-2](0|9)\d{2}[\/]((0[1-9])|(1[0-2]))\z/, message: "Format mm/aaaa" }

  def duration
    s = DateTime.new(start_date[0..3].to_i, start_date[5..].to_i)
    e = end_date.present? ? Date.new(end_date[0..3].to_i, end_date[5..].to_i) : DateTime.now()
    d = e - s
    years = d.fdiv(365).floor
    months = d.fdiv(30).ceil - (d.fdiv(365).floor * 12)
    if months == 13
      years += 1
      months = 0
    end
    return {
      years: years,
      months: months
    }
  end

  def end_date_output
    "#{end_date[5..]}/#{end_date[0..3]}"
  end

  def start_date_output
    "#{start_date[5..]}/#{start_date[0..3]}"
  end
end
