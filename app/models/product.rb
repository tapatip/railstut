class Product < ActiveRecord::Base
  has_many :line_items
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true, length: {minimum: 10, too_short: "title must be at least than 10 symbols"}
  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|png|jpg)\Z}i,
      message: 'URL должен указывать на изображение формата GIF, PNG или JPG'
  }
  before_destroy :ensure_not_referenced_by_any_line_item

  def self.latest
    Product.order(:updated_at).last
  end

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'line item are exist')
      return false
    end
  end
end
