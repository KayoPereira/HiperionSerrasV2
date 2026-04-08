import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  connect() {
    this._handleOutsideClick = this._close.bind(this)
    this._buildUI()
  }

  disconnect() {
    document.removeEventListener("click", this._handleOutsideClick)
  }

  _buildUI() {
    const select = this.selectTarget
    select.style.display = "none"

    this._trigger = document.createElement("button")
    this._trigger.type = "button"
    this._trigger.className = "custom-select__trigger"
    this._trigger.setAttribute("aria-haspopup", "listbox")
    this._trigger.setAttribute("aria-expanded", "false")
    this._trigger.addEventListener("click", (e) => {
      e.stopPropagation()
      this._toggle()
    })

    this._labelEl = document.createElement("span")
    this._labelEl.className = "custom-select__label"

    const arrow = document.createElement("span")
    arrow.className = "custom-select__arrow"
    arrow.setAttribute("aria-hidden", "true")

    this._trigger.appendChild(this._labelEl)
    this._trigger.appendChild(arrow)

    this._dropdown = document.createElement("ul")
    this._dropdown.className = "custom-select__dropdown"
    this._dropdown.setAttribute("role", "listbox")

    Array.from(select.options).forEach((option) => {
      const li = document.createElement("li")
      li.className = "custom-select__option"
      li.setAttribute("role", "option")
      li.setAttribute("aria-selected", "false")
      li.dataset.value = option.value
      li.textContent = option.text
      li.addEventListener("click", () => this._choose(option.value))
      this._dropdown.appendChild(li)
    })

    this.element.appendChild(this._trigger)
    this.element.appendChild(this._dropdown)

    this._refresh()
  }

  _toggle() {
    this.element.classList.contains("custom-select--open") ? this._close() : this._open()
  }

  _open() {
    this.element.classList.add("custom-select--open")
    this._trigger.setAttribute("aria-expanded", "true")
    this._syncActiveOption()
    document.addEventListener("click", this._handleOutsideClick)
  }

  _close() {
    this.element.classList.remove("custom-select--open")
    this._trigger.setAttribute("aria-expanded", "false")
    document.removeEventListener("click", this._handleOutsideClick)
  }

  _choose(value) {
    this.selectTarget.value = value
    this.selectTarget.dispatchEvent(new Event("change", { bubbles: true }))
    this._refresh()
    this._close()
  }

  _refresh() {
    const select = this.selectTarget
    const selected = select.options[select.selectedIndex]
    const hasValue = !!select.value

    this._labelEl.textContent = selected ? selected.text : ""
    this._labelEl.classList.toggle("custom-select__label--filled", hasValue)
    this.element.classList.toggle("custom-select--filled", hasValue)
  }

  _syncActiveOption() {
    const current = this.selectTarget.value
    this._dropdown.querySelectorAll(".custom-select__option").forEach((li) => {
      const active = li.dataset.value === current
      li.classList.toggle("custom-select__option--active", active)
      li.setAttribute("aria-selected", active ? "true" : "false")
    })
  }
}
