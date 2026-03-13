import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["number"]
  static values = {
    duration: { type: Number, default: 1800 }
  }

  connect() {
    this.hasAnimated = false
    this.hasScrolled = false

    this.handleFirstScroll = () => {
      this.hasScrolled = true
      window.removeEventListener("scroll", this.handleFirstScroll)
    }

    window.addEventListener("scroll", this.handleFirstScroll, { passive: true })

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting && this.hasScrolled && !this.hasAnimated) {
            this.hasAnimated = true
            this.animateAll()
            this.observer.disconnect()
          }
        })
      },
      { threshold: 0.35 }
    )

    this.observer.observe(this.element)
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleFirstScroll)

    if (this.observer) {
      this.observer.disconnect()
    }
  }

  animateAll() {
    this.numberTargets.forEach((target) => {
      const to = Number.parseInt(target.dataset.value || "0", 10)
      const prefix = target.dataset.prefix || ""
      this.animateValue(target, 0, to, prefix)
    })
  }

  animateValue(element, from, to, prefix) {
    const start = performance.now()

    const tick = (now) => {
      const elapsed = now - start
      const progress = Math.min(elapsed / this.durationValue, 1)
      const eased = 1 - Math.pow(1 - progress, 3)
      const value = Math.round(from + (to - from) * eased)

      element.textContent = `${prefix}${new Intl.NumberFormat("pt-BR").format(value)}`

      if (progress < 1) {
        requestAnimationFrame(tick)
      }
    }

    requestAnimationFrame(tick)
  }
}
