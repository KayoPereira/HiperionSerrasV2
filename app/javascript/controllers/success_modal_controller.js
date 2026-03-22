import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.previousOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"
  }

  disconnect() {
    document.body.style.overflow = this.previousOverflow
  }

  overlayClick(event) {
    if (event.target === this.element) this.close()
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  close() {
    this.element.remove()
  }
}
