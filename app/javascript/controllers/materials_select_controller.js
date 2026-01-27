import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customInput", "materialId", "materialLabel", "materialMenu"]
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

      this.renderMaterialOptions(materials)
    } catch (error) {
      console.error('Failed to load materials:', error)
    }
  }

  renderMaterialOptions(materials) {
    const menu = this.materialMenuTarget
    menu.innerHTML = ''

    // --新規入力-- オプション
    const newMaterialOption = document.createElement("li")
    const newMaterialLink = document.createElement("a")
    newMaterialLink.href = "#"
    newMaterialLink.dataset.value = ""
    newMaterialLink.textContent = "--新規入力--"
    newMaterialLink.addEventListener("click", (e) => this.selectMaterial(e))
    newMaterialOption.appendChild(newMaterialLink)
    menu.appendChild(newMaterialOption)

    // 既存資材を表示
    materials.forEach(material => {
      const li = document.createElement("li")
      const a = document.createElement("a")
      a.href = "#"
      a.dataset.value = material.id
      a.textContent = material.name
      a.addEventListener("click", (e) => this.selectMaterial(e))
      li.appendChild(a)
      menu.appendChild(li)
    })
  }

  selectMaterial(event) {
    event.preventDefault()
    const selectedValue = event.currentTarget.dataset.value
    const selectedName = event.currentTarget.textContent.trim()

    // details を閉じる
    const details = event.currentTarget.closest("details")
    if (details) {
      details.open = false
    }

    if (selectedValue === "") {
      // 新規入力モード
      this.materialLabelTarget.textContent = selectedName
      this.customInputTarget.classList.remove("hidden")
      this.customInputTarget.focus()
      this.customInputTarget.value = ""
      this.materialIdTarget.value = ""
    } else {
      // 既存資材選択モード
      this.materialLabelTarget.textContent = selectedName
      this.customInputTarget.classList.add("hidden")
      this.materialIdTarget.value = selectedValue
      this.customInputTarget.value = ""
    }
  }
}
