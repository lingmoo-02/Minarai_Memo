import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "customInput", "materialId"]
  static values = { materialsUrl: String }

  connect() {
    this.materialsUrlValue = "/materials"
    this.loadMaterials()

    // チーム選択が変更されたときに資材一覧を再読み込み
    document.addEventListener('team-changed', (e) => {
      this.loadMaterials(e.detail.teamId)
    })
  }

  async loadMaterials(teamId = null) {
    const url = teamId
      ? `${this.materialsUrlValue}?team_id=${teamId}`
      : this.materialsUrlValue

    try {
      const response = await fetch(url)
      const materials = await response.json()

      // selectの選択肢を更新（最初の2つのoptionは維持）
      const defaultOptions = Array.from(this.selectTarget.options).slice(0, 2)
      this.selectTarget.innerHTML = ''
      defaultOptions.forEach(opt => this.selectTarget.add(opt))

      materials.forEach(material => {
        const option = new Option(material.name, material.id)
        this.selectTarget.add(option)
      })
    } catch (error) {
      console.error('Failed to load materials:', error)
    }
  }

  selectMaterial(event) {
    const selectedValue = event.target.value

    if (selectedValue === "") {
      // 新規入力モード
      this.customInputTarget.classList.remove("hidden")
      this.customInputTarget.focus()
      this.customInputTarget.value = ""
      this.materialIdTarget.value = ""
    } else {
      // 既存資材選択モード
      this.customInputTarget.classList.add("hidden")
      this.materialIdTarget.value = selectedValue
      this.customInputTarget.value = ""
    }
  }
}
