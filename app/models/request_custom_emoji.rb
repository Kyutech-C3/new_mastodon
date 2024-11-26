# frozen_string_literal: true
# == Schema Information
#
# Table name: request_custom_emojis
#
#  id                           :bigint(8)        not null, primary key
#  state                        :integer          default(0)
#  shortcode                    :string           default(""), not null
#  image_file_name              :string
#  image_content_type           :string
#  image_file_size              :integer
#  image_updated_at             :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  image_storage_schema_version :integer
#  account_id                   :bigint(8)        not null
#

# app/models/custom_emoji.rb を参考に作成

class RequestCustomEmoji < ApplicationRecord
  include Attachmentable

  belongs_to :account

  has_attached_file :image, styles: { static: { format: 'png', convert_options: '-coalesce +profile "!icc,*" +set date:modify +set date:create +set date:timestamp', file_geometry_parser: FastGeometryParser } }, validate_media_type: false, processors: [:lazy_thumbnail]

  validates_attachment :image, content_type: { content_type: CustomEmoji::IMAGE_MIME_TYPES }, presence: true, size: { less_than: CustomEmoji::LIMIT }
  validates :shortcode, uniqueness: true, format: { with: CustomEmoji::SHORTCODE_ONLY_RE }, length: { minimum: CustomEmoji::MINIMUM_SHORTCODE_SIZE }

  scope :alphabetic, -> { order(shortcode: :asc) }

  remotable_attachment :image, CustomEmoji::LIMIT

  after_commit :remove_entity_cache

  def object_type
    :emoji
  end

  class << self
    def from_text(text, domain = nil)
      return [] if text.blank?

      shortcodes = text.scan(CustomEmoji::SCAN_RE).map(&:first).uniq

      return [] if shortcodes.empty?

      EntityCache.instance.emoji(shortcodes, domain)
    end

    def search(shortcode)
      where(arel_table[:shortcode].matches("%#{sanitize_sql_like(shortcode)}%"))
    end
  end

  private

  def remove_entity_cache
    Rails.cache.delete(EntityCache.instance.to_key(:emoji, shortcode))
  end
end
