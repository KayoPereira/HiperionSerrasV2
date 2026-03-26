import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  open() {
    this.overlayTarget.hidden = false
    document.body.style.overflow = "hidden"
    this.boundKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundKeydown)
  }

  close() {
    this.overlayTarget.hidden = true
    document.body.style.overflow = ""
    if (this.boundKeydown) {
      document.removeEventListener("keydown", this.boundKeydown)
    }
  }

  closeOutside(event) {
    if (event.target === event.currentTarget) {
      this.close()
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  disconnect() {
    document.body.style.overflow = ""
    if (this.boundKeydown) {
      document.removeEventListener("keydown", this.boundKeydown)
    }
  }
}
