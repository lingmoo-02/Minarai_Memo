import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customInput"]

  selectMaterial(event) {
    const selectedValue = event.target.value

    // カスタム入力オプションが選択された場合
    if (selectedValue === "") {
      this.customInputTarget.classList.remove("hidden")
      this.customInputTarget.focus()
      this.customInputTarget.value = ""
    } else {
      this.customInputTarget.classList.add("hidden")
      this.customInputTarget.value = selectedValue
    }
  }
}
