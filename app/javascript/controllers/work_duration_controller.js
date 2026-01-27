import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "display"]

  connect() {
    this.updateDisplay()
  }

  updateDisplay() {
    const minutes = parseInt(this.inputTarget.value) || 0

    if (minutes <= 0) {
      this.displayTarget.textContent = ""
      return
    }

    const hours = Math.floor(minutes / 60)
    const remainingMinutes = minutes % 60

    let formatted = ""
    if (hours > 0 && remainingMinutes > 0) {
      formatted = `${hours}時間${remainingMinutes}分`
    } else if (hours > 0) {
      formatted = `${hours}時間`
    } else {
      formatted = `${remainingMinutes}分`
    }

    this.displayTarget.textContent = formatted
  }
}
