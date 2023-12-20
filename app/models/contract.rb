class Contract < ApplicationRecord
  belongs_to :contractable, polymorphic: true
  belongs_to :company
  has_one_attached :document

  enum :contract_type, {"convention de mécénat": 1, "avenant au contrat de travail": 2, "autre": 3}
  validates :title, presence: {message: "Titre requis"}
  validate :document_present
  validate :file_type

  def document_present
    errors.add(:document, 'Document requis') unless document.attached?
  end

  def file_type
    if document.attached?
      errors.add(:document, 'formats : PDF ou DOC') unless document.content_type.in?(%w[application/pdf application/msword])
    end
  end
end
