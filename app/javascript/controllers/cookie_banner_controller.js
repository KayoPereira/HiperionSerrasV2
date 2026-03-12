import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    key: { type: String, default: "cookies_accepted" }
  }

  connect() {
    if (this.accepted()) {
      this.hide()
      return
    }

    document.body.classList.add("cookie-banner-visible")
  }

  accept() {
    localStorage.setItem(this.keyValue, "true")
    this.hide()
  }

  accepted() {
    return localStorage.getItem(this.keyValue) === "true"
  }

  hide() {
    this.element.remove()
    document.body.classList.remove("cookie-banner-visible")
  }
}