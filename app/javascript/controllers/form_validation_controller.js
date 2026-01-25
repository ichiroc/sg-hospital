import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nameKana", "phoneNumber", "nameKanaError", "phoneError"]

  validateKana(event) {
    const value = event.target.value
    const isValid = /^[ぁ-んー\s]*$/.test(value)

    if (!isValid && value.length > 0) {
      this.nameKanaErrorTarget.textContent = "ひらがなで入力してください"
      this.nameKanaErrorTarget.classList.remove("hidden")
      this.nameKanaTarget.classList.add("border-red-500")
    } else {
      this.nameKanaErrorTarget.classList.add("hidden")
      this.nameKanaTarget.classList.remove("border-red-500")
    }
  }

  validatePhone(event) {
    const value = event.target.value
    const isValid = /^\d{2,4}-?\d{2,4}-?\d{4}$/.test(value)

    if (!isValid && value.length > 0) {
      this.phoneErrorTarget.textContent = "正しい電話番号を入力してください（例: 090-1234-5678）"
      this.phoneErrorTarget.classList.remove("hidden")
      this.phoneNumberTarget.classList.add("border-red-500")
    } else {
      this.phoneErrorTarget.classList.add("hidden")
      this.phoneNumberTarget.classList.remove("border-red-500")
    }
  }
}
