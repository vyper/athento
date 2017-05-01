class Schedule < ApplicationRecord
  belongs_to :listener
  belongs_to :talker, required: false

  validates :listener,     presence: true
  validates :scheduled_to, presence: true
  validates :room_url,     presence: true, format: URI::regexp(%w(http https))

  scope :available,          -> { includes(:listener).where(talker_id: nil) }
  scope :near,               -> { where(arel_table[:scheduled_to].gt(Time.current)) }
  scope :pending_occurrence, -> { where(occurred_at: nil).where(arel_table[:scheduled_to].lt(Time.current)) }

  after_initialize do
    self.room_url = "http://appear.in/coraus-#{Digest::SHA1.hexdigest(Time.current.to_f.to_s)[0..10]}"
  end

  delegate :name, to: :listener

  def occurred?
    occurred_at.present?
  end
end
