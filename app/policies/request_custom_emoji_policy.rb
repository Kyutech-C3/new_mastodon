# frozen_string_literal: true

# app/policies/custom_emoji_policy.rb を参考に作成

class RequestCustomEmojiPolicy < ApplicationPolicy
  def update?
    role.can?(:manage_custom_emojis)
  end

  def destroy?
    role.can?(:manage_custom_emojis) || (record.account_id == current_account&.id)
  end
end
