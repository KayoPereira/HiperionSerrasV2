import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("input", this.mask.bind(this))
    this.element.addEventListener("keydown", this.handleBackspace.bind(this))
  }

  mask(event) {
    let value = event.target.value.replace(/\D/g, "").slice(0, 11)
    event.target.value = this.format(value)
  }

  handleBackspace(event) {
    if (event.key !== "Backspace") return
    const value = this.element.value.replace(/\D/g, "")
    if (value.length <= 1) this.element.value = ""
  }

  format(digits) {
    if (digits.length === 0) return ""
    if (digits.length <= 2) return `(${digits}`
    if (digits.length <= 6) return `(${digits.slice(0, 2)}) ${digits.slice(2)}`
    if (digits.length <= 10) return `(${digits.slice(0, 2)}) ${digits.slice(2, 6)}-${digits.slice(6)}`
    return `(${digits.slice(0, 2)}) ${digits.slice(2, 7)}-${digits.slice(7)}`
  }
}
