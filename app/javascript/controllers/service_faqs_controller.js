import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template"]
  static values = { nextIndex: Number }

  connect() {
    this.nextIndexValue = this.currentMaxIndex() + 1
  }

  add(event) {
    event.preventDefault()

    const index = this.nextIndexValue
    this.nextIndexValue += 1

    const html = this.templateTarget.innerHTML.replace(/NEW_RECORD|FAQ_INDEX/g, index)
    this.listTarget.insertAdjacentHTML("beforeend", html)
  }

  remove(event) {
    event.preventDefault()

    const item = event.currentTarget.closest(".service-admin-form__faq-card") || event.currentTarget.closest(".product-admin-form__faq-item")
    if (!item) return

    const destroyInput = item.querySelector('input[name*="[_destroy]"]')

    if (destroyInput) {
      destroyInput.value = "1"
      item.hidden = true
    } else {
      item.remove()
    }
  }

  currentMaxIndex() {
    const inputs = this.listTarget.querySelectorAll('textarea[name*="_faqs_attributes]"]')
    let maxIndex = -1

    inputs.forEach((input) => {
      const match = input.name.match(/\[\w+_faqs_attributes\]\[(\d+)\]/)
      if (!match) return

      const index = Number.parseInt(match[1], 10)
      if (Number.isNaN(index)) return

      maxIndex = Math.max(maxIndex, index)
    })

    return maxIndex
  }
}
