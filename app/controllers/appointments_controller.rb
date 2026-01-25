class AppointmentsController < ApplicationController
  before_action :validate_and_set_appointment, only: [:new]

  # ステップ1: カレンダー表示
  def index
    @min_date = Date.today
    @max_date = Date.today + 3.months
  end

  # ステップ2/3: 時間枠選択・入力フォーム
  def new
    # @appointmentはbefore_actionで設定済み
    # ビューで直接Appointment.available_slots_forを使用
  end

  # 予約作成
  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      redirect_to appointment_path(@appointment), notice: "予約が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 予約完了画面
  def show
    @appointment = Appointment.find(params[:id])
  end

  private

  def validate_and_set_appointment
    # 日付パラメータの必須チェック
    if params[:date].blank?
      redirect_to appointments_path, alert: "日付を選択してください"
      return
    end

    # Appointmentインスタンスを作成してバリデーション
    @appointment = Appointment.new(
      appointed_on: params[:date],
      appointed_slot: params[:slot]
    )

    # バリデーション実行
    @appointment.valid?

    # appointed_onのエラーチェック
    if @appointment.errors[:appointed_on].present?
      redirect_to appointments_path, alert: @appointment.errors[:appointed_on].first
      return
    end

    # appointed_slotのエラーチェック（slotパラメータがある場合のみ）
    if params[:slot].present? && @appointment.errors[:appointed_slot].present?
      redirect_to new_appointment_path(date: params[:date]),
                  alert: @appointment.errors[:appointed_slot].first
      return
    end
    @appointment.errors.clear
  end

  def appointment_params
    params.require(:appointment).permit(
      :appointed_on, :appointed_slot,
      :name, :name_kana, :patient_number,
      :birth_date, :phone_number, :consultation_purpose
    )
  end
end
