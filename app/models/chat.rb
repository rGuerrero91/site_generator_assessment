class Chat < ApplicationRecord
  serialize :follow_up_messages, coder: JSON

  def self.latest_html
    order(created_at: :desc).first&.html_response
  end

  def self.latest
    order(created_at: :desc).first
  end
end
