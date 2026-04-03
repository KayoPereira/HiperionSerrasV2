import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mainImage", "thumb", "modal", "modalImage", "modalThumb", "strip"]
  static values = { index: { type: Number, default: 0 } }

  connect() {
    this.closeTimer = null
    this.sync()
  }

  open() {
    if (!this.hasModalTarget) return

    clearTimeout(this.closeTimer)
    this.modalTarget.hidden = false
    this.modalTarget.classList.remove("is-closing")
    requestAnimationFrame(() => {
      this.modalTarget.classList.add("is-open")
    })

    document.body.style.overflow = "hidden"
    this.boundKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundKeydown)
    this.sync()
  }

  close() {
    if (!this.hasModalTarget || this.modalTarget.hidden) return

    this.modalTarget.classList.remove("is-open")
    this.modalTarget.classList.add("is-closing")

    clearTimeout(this.closeTimer)
    this.closeTimer = setTimeout(() => {
      if (this.hasModalTarget) {
        this.modalTarget.hidden = true
        this.modalTarget.classList.remove("is-closing")
      }
    }, 220)

    document.body.style.overflow = ""
    if (this.boundKeydown) {
      document.removeEventListener("keydown", this.boundKeydown)
      this.boundKeydown = null
    }
  }

  closeOutside(event) {
    if (event.target === event.currentTarget) this.close()
  }

  select(event) {
    const index = Number(event.params.index)
    if (Number.isNaN(index)) return

    this.indexValue = index
    this.sync()
  }

  goTo(event) {
    const index = Number(event.params.index)
    if (Number.isNaN(index)) return

    this.indexValue = index
    this.sync()
  }

  next() {
    const total = this.mainImageTargets.length
    if (total < 2) return

    this.indexValue = (this.indexValue + 1) % total
    this.sync()
  }

  prev() {
    const total = this.mainImageTargets.length
    if (total < 2) return

    this.indexValue = (this.indexValue - 1 + total) % total
    this.sync()
  }

  sync() {
    this.mainImageTargets.forEach((image, index) => {
      image.classList.toggle("is-active", index === this.indexValue)
    })

    this.thumbTargets.forEach((thumb, index) => {
      const active = index === this.indexValue
      thumb.classList.toggle("is-active", active)
      thumb.setAttribute("aria-pressed", String(active))
    })

    this.modalImageTargets.forEach((image, index) => {
      image.classList.toggle("is-active", index === this.indexValue)
      image.setAttribute("aria-hidden", String(index !== this.indexValue))
    })

    this.modalThumbTargets.forEach((thumb, index) => {
      const active = index === this.indexValue
      thumb.classList.toggle("is-active", active)
      thumb.setAttribute("aria-pressed", String(active))
    })

    this.scrollActiveThumbIntoView(this.thumbTargets[this.indexValue])
    this.scrollActiveThumbIntoView(this.modalThumbTargets[this.indexValue])
  }

  scrollActiveThumbIntoView(element) {
    if (!element) return

    element.scrollIntoView({ behavior: "smooth", block: "nearest", inline: "center" })
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    } else if (event.key === "ArrowRight") {
      this.next()
    } else if (event.key === "ArrowLeft") {
      this.prev()
    }
  }

  disconnect() {
    clearTimeout(this.closeTimer)
    this.close()
  }
}
