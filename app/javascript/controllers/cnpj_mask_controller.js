import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error", "submit"]

  connect() {
    this.validate(false)
  }

  handleInput(event) {
    let value = event.target.value.replace(/\D/g, "").slice(0, 14)
    event.target.value = this.format(value)
    this.validate(value.length > 0)
  }

  validateField() {
    this.validate(true)
  }

  validate(showMessage) {
    const digits = this.inputTarget.value.replace(/\D/g, "")
    const shouldShowError = digits.length > 0 && !this.isValidCnpj(digits)

    this.inputTarget.setAttribute("aria-invalid", shouldShowError.toString())
    this.inputTarget.classList.toggle("budget-form__input--invalid", shouldShowError)
    this.errorTarget.hidden = !showMessage || !shouldShowError
    this.submitTarget.disabled = shouldShowError
    this.submitTarget.setAttribute("aria-disabled", shouldShowError.toString())
  }

  isValidCnpj(digits) {
    if (digits.length !== 14) return false
    if (/^(\d)\1{13}$/.test(digits)) return false

    const numbers = digits.split("").map(Number)
    const firstDigit = this.checkDigit(numbers.slice(0, 12), [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2])
    const secondDigit = this.checkDigit(numbers.slice(0, 12).concat(firstDigit), [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2])

    return firstDigit === numbers[12] && secondDigit === numbers[13]
  }

  checkDigit(digits, weights) {
    const sum = digits.reduce((total, digit, index) => total + (digit * weights[index]), 0)
    const remainder = sum % 11

    return remainder < 2 ? 0 : 11 - remainder
  }

  format(digits) {
    if (digits.length === 0) return ""
    if (digits.length <= 2) return digits
    if (digits.length <= 5) return `${digits.slice(0, 2)}.${digits.slice(2)}`
    if (digits.length <= 8) return `${digits.slice(0, 2)}.${digits.slice(2, 5)}.${digits.slice(5)}`
    if (digits.length <= 12) return `${digits.slice(0, 2)}.${digits.slice(2, 5)}.${digits.slice(5, 8)}/${digits.slice(8)}`
    return `${digits.slice(0, 2)}.${digits.slice(2, 5)}.${digits.slice(5, 8)}/${digits.slice(8, 12)}-${digits.slice(12)}`
  }
}