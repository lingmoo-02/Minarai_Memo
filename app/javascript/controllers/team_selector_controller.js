import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tagSelect"]

  connect() {
    this.updateTags()
  }

  updateTags() {
    const teamId = this.element.value

    if (!teamId || teamId === "") {
      // 個人ノート選択時：team_id = null のタグのみ表示
      this.loadTags(null)
    } else {
      // チーム選択時：そのチームのタグのみ表示
      this.loadTags(teamId)
    }
  }

  loadTags(teamId) {
    const url = teamId
      ? `/teams/${teamId}/tags.json`
      : `/tags.json`

    fetch(url)
      .then(response => response.json())
      .then(tags => this.renderTagOptions(tags))
      .catch(error => console.error("Error loading tags:", error))
  }

  renderTagOptions(tags) {
    const select = this.tagSelectTarget
    select.innerHTML = '<option value="">タグを選択（任意）</option>'

    tags.forEach(tag => {
      const option = document.createElement("option")
      option.value = tag.id
      option.textContent = tag.name
      select.appendChild(option)
    })
  }
}
