class Appointment < ApplicationRecord
  # 診療目的の定数定義
  CONSULTATION_PURPOSES = [
    ["風邪・発熱", "cold_fever"],
    ["健康診断", "health_checkup"],
    ["予防接種", "vaccination"],
    ["その他", "other"]
  ].freeze

  # 時間枠のenum定義
  enum :appointed_slot, {
    slot_0900: "9:00",
    slot_0915: "9:15",
    slot_0930: "9:30",
    slot_0945: "9:45",
    slot_1000: "10:00",
    slot_1015: "10:15",
    slot_1030: "10:30",
    slot_1045: "10:45",
    slot_1100: "11:00",
    slot_1115: "11:15",
    slot_1130: "11:30",
    slot_1145: "11:45",
    slot_1200: "12:00",
    slot_1500: "15:00",
    slot_1515: "15:15",
    slot_1530: "15:30",
    slot_1545: "15:45",
    slot_1600: "16:00",
    slot_1615: "16:15",
    slot_1630: "16:30",
    slot_1645: "16:45",
    slot_1700: "17:00"
  }, prefix: true

  # バリデーション
  validates :appointed_on, presence: true
  validates :appointed_slot, presence: true
  validates :name, presence: true
  validates :name_kana, presence: true, format: {
    with: /\A[ぁ-んー\s]+\z/,
    message: "はひらがなで入力してください"
  }
  validates :birth_date, presence: true
  validates :phone_number, presence: true, format: {
    with: /\A\d{2,4}-?\d{2,4}-?\d{4}\z/,
    message: "は正しい形式で入力してください（例: 090-1234-5678）"
  }
  validates :consultation_purpose, presence: true, inclusion: {
    in: CONSULTATION_PURPOSES.map(&:last),
    message: "を選択してください"
  }

  validate :appointed_on_cannot_be_in_the_past
  validate :birth_date_cannot_be_in_the_future
  validate :appointment_slot_must_be_available

  # 指定日の利用可能な時間枠を取得
  def self.available_slots_for(date)
    booked_slots = where(appointed_on: date).pluck(:appointed_slot)
    appointed_slots.reject { |_key, value| booked_slots.include?(value) }
  end

  private

  def appointed_on_cannot_be_in_the_past
    if appointed_on.present? && appointed_on < Date.today
      errors.add(:appointed_on, "は今日以降の日付を選択してください")
    end
  end

  def birth_date_cannot_be_in_the_future
    if birth_date.present? && birth_date > Date.today
      errors.add(:birth_date, "は過去の日付を入力してください")
    end
  end

  def appointment_slot_must_be_available
    return unless appointed_on.present? && appointed_slot.present?

    existing = Appointment.where(
      appointed_on: appointed_on,
      appointed_slot: appointed_slot
    )
    existing = existing.where.not(id: id) if persisted?

    if existing.exists?
      errors.add(:base, "選択された日時は既に予約されています")
    end
  end
end
