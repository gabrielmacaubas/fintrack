class Income < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :description, presence: true

  scope :recent, -> { order(date: :desc) }

  # Active Storage attachment for receipt
  has_one_attached :receipt

  # Validação customizada para o comprovante
  validate :receipt_validation, if: :receipt_attached?

  def has_receipt?
    receipt.attached?
  end

  def receipt_url
    receipt.attached? ? Rails.application.routes.url_helpers.rails_blob_path(receipt, only_path: true) : nil
  end

  private

  def receipt_attached?
    receipt.attached?
  end

  def receipt_validation
    return unless receipt.attached?

    # Validar tipo de arquivo
    allowed_types = %w[image/jpeg image/jpg image/png application/pdf]
    unless allowed_types.include?(receipt.content_type)
      errors.add(:receipt, 'deve ser uma imagem ou PDF')
    end

    # Validar tamanho (5MB = 5 * 1024 * 1024 bytes)
    if receipt.byte_size > 5.megabytes
      errors.add(:receipt, 'deve ter menos de 5MB')
    end
  end
end
