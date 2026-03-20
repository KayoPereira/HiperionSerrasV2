import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "button", "content"]

  connect() {
    this.contentTargets.forEach((content) => {
      content.style.height = "0px"
      content.hidden = true
    })
  }

  toggle(event) {
    const index = Number(event.params.index)
    if (Number.isNaN(index)) return

    this.itemTargets.forEach((item, i) => {
      if (i === index) {
        this.toggleItem(i)
      } else {
        this.closeItem(i)
      }
    })
  }

  toggleItem(index) {
    const button = this.buttonTargets[index]
    const expanded = button.getAttribute("aria-expanded") === "true"

    if (expanded) {
      this.closeItem(index)
    } else {
      this.openItem(index)
    }
  }

  openItem(index) {
    const item = this.itemTargets[index]
    const button = this.buttonTargets[index]
    const content = this.contentTargets[index]

    content.hidden = false
    content.style.height = "0px"

    requestAnimationFrame(() => {
      content.style.height = `${content.scrollHeight}px`
    })

    item.classList.add("is-open")
    button.setAttribute("aria-expanded", "true")
  }

  closeItem(index) {
    const item = this.itemTargets[index]
    const button = this.buttonTargets[index]
    const content = this.contentTargets[index]

    if (button.getAttribute("aria-expanded") !== "true") return

    content.style.height = `${content.scrollHeight}px`
    requestAnimationFrame(() => {
      content.style.height = "0px"
    })

    content.addEventListener("transitionend", () => {
      if (button.getAttribute("aria-expanded") === "false") {
        content.hidden = true
      }
    }, { once: true })

    item.classList.remove("is-open")
    button.setAttribute("aria-expanded", "false")
  }
}
