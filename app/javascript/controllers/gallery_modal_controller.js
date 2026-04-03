import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "galleryImage", "galleryDot"]
  static values = { index: Number }

  connect() {
    this.closeTimer = null
  }

  open(event) {
    const clickedIndex = Number(event.params.index) || 0
    this.indexValue = clickedIndex
    this.showGallerySlide()

    clearTimeout(this.closeTimer)
    this.overlayTarget.hidden = false
    this.overlayTarget.classList.remove("is-closing")
    requestAnimationFrame(() => {
      this.overlayTarget.classList.add("is-open")
    })

    document.body.style.overflow = "hidden"
    this.boundKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundKeydown)
  }

  close() {
    if (this.overlayTarget.hidden) return

    this.overlayTarget.classList.remove("is-open")
    this.overlayTarget.classList.add("is-closing")

    clearTimeout(this.closeTimer)
    this.closeTimer = setTimeout(() => {
      this.overlayTarget.hidden = true
      this.overlayTarget.classList.remove("is-closing")
    }, 220)

    document.body.style.overflow = ""
    if (this.boundKeydown) {
      document.removeEventListener("keydown", this.boundKeydown)
      this.boundKeydown = null
    }
  }

  closeOutside(event) {
    if (event.target === event.currentTarget) {
      this.close()
    }
  }

  next() {
    this.indexValue = (this.indexValue + 1) % this.galleryImageTargets.length
    this.showGallerySlide()
  }

  prev() {
    this.indexValue = (this.indexValue - 1 + this.galleryImageTargets.length) % this.galleryImageTargets.length
    this.showGallerySlide()
  }

  goTo(event) {
    this.indexValue = Number(event.params.index)
    this.showGallerySlide()
  }

  showGallerySlide() {
    this.galleryImageTargets.forEach((img, i) => {
      img.classList.toggle("is-active", i === this.indexValue)
    })
    this.galleryDotTargets.forEach((dot, i) => {
      dot.classList.toggle("is-active", i === this.indexValue)
    })
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
    document.body.style.overflow = ""
    if (this.boundKeydown) {
      document.removeEventListener("keydown", this.boundKeydown)
      this.boundKeydown = null
    }
  }
}
