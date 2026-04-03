import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error"]

  validate() {
    const value = this.inputTarget.value.trim()
    const isInvalid = value.length > 0 && !this.isValidEmail(value)

    this.inputTarget.setAttribute("aria-invalid", isInvalid.toString())
    this.inputTarget.classList.toggle("budget-form__input--invalid", isInvalid)
    this.errorTarget.hidden = !isInvalid
  }

  isValidEmail(value) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)
  }
}
