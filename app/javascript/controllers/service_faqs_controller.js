import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template"]

  add(event) {
    event.preventDefault()

    const uniqueId = `${Date.now()}_${Math.floor(Math.random() * 1000)}`
    const html = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, uniqueId)
    this.listTarget.insertAdjacentHTML("beforeend", html)
  }

  remove(event) {
    event.preventDefault()

    const item = event.currentTarget.closest(".service-admin-form__faq-card")
    if (!item) return

    const destroyInput = item.querySelector('input[name*="[_destroy]"]')

    if (destroyInput) {
      destroyInput.value = "1"
      item.hidden = true
    } else {
      item.remove()
    }
  }
}
