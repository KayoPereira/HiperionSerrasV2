import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "dot"]
  static values = {
    interval: { type: Number, default: 10000 }
  }

  connect() {
    this.currentIndex = 0
    this.show(this.currentIndex)
    this.startAutoplay()
  }

  disconnect() {
    this.stopAutoplay()
  }

  goTo(event) {
    const index = Number(event.params.index)
    if (Number.isNaN(index)) return

    this.show(index)
    this.restartAutoplay()
  }

  next() {
    if (!this.hasSlideTarget) return

    const nextIndex = (this.currentIndex + 1) % this.slideTargets.length
    this.show(nextIndex)
  }

  show(index) {
    const max = this.slideTargets.length - 1
    if (max < 0) return

    this.currentIndex = Math.min(Math.max(index, 0), max)

    this.slideTargets.forEach((slide, i) => {
      const active = i === this.currentIndex
      slide.classList.toggle("is-active", active)
      slide.setAttribute("aria-hidden", String(!active))
    })

    this.dotTargets.forEach((dot, i) => {
      const active = i === this.currentIndex
      dot.classList.toggle("is-active", active)
      dot.setAttribute("aria-selected", String(active))
    })
  }

  startAutoplay() {
    this.stopAutoplay()
    this.timer = setInterval(() => this.next(), this.intervalValue)
  }

  stopAutoplay() {
    if (!this.timer) return

    clearInterval(this.timer)
    this.timer = null
  }

  restartAutoplay() {
    this.startAutoplay()
  }
}