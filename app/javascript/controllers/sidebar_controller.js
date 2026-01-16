import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay", "toggleButton"]

  toggle() {
    this.sidebarTarget.classList.toggle("-translate-x-full")
    this.overlayTarget.classList.toggle("hidden")
    this.updateButtonIcon()
  }

  close() {
    this.sidebarTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("hidden")
    this.updateButtonIcon()
  }

  updateButtonIcon() {
    const icon = this.toggleButtonTarget.querySelector("i")
    const isClosed = this.sidebarTarget.classList.contains("-translate-x-full")

    if (isClosed) {
      icon.classList.remove("fa-xmark")
      icon.classList.add("fa-bars")
    } else {
      icon.classList.remove("fa-bars")
      icon.classList.add("fa-xmark")
    }
  }
}
