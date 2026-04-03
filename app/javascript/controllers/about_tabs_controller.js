import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.select({ params: { index: 0 } })
  }

  select(event) {
    const index = Number(event.params.index)
    if (Number.isNaN(index)) return

    this.tabTargets.forEach((tab, i) => {
      tab.classList.toggle("is-active", i === index)
      const button = tab.querySelector("button[role='tab']")
      if (button) {
        button.classList.toggle("is-active", i === index)
        button.setAttribute("aria-selected", String(i === index))
      }
    })

    const currentPanel = this.panelTargets.find(p => p.classList.contains("is-active"))
    const nextPanel = this.panelTargets[index]

    if (currentPanel === nextPanel) return

    if (currentPanel) {
      currentPanel.classList.add("is-leaving")
      currentPanel.addEventListener("animationend", () => {
        currentPanel.classList.remove("is-active", "is-leaving")
      }, { once: true })
    }

    if (nextPanel) {
      nextPanel.classList.add("is-active")
    }
  }
}
