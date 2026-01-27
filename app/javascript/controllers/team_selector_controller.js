import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["teamInput", "teamLabel", "tagInput", "tagLabel", "tagMenu"]

  connect() {
    this.updateTags(this.teamInputTarget.value)
  }

  selectTeam(event) {
    event.preventDefault()
    const teamId = event.target.dataset.value
    const teamName = event.target.textContent.trim()

    this.teamInputTarget.value = teamId
    this.teamLabelTarget.textContent = teamName

    // detailsを閉じるため、親のdetails要素を取得して閉じる
    const details = event.target.closest("details")
    if (details) {
      details.open = false
    }

    // カスタムイベント発火（materials-selectコントローラーに通知）
    document.dispatchEvent(new CustomEvent('team-changed', {
      detail: { teamId: teamId }
    }))

    this.updateTags(teamId)
  }

  selectTag(event) {
    event.preventDefault()
    const tagId = event.target.dataset.value
    const tagName = event.target.textContent.trim()

    this.tagInputTarget.value = tagId
    this.tagLabelTarget.textContent = tagName

    // detailsを閉じるため、親のdetails要素を取得して閉じる
    const details = event.target.closest("details")
    if (details) {
      details.open = false
    }
  }

  updateTags(teamId) {
    const url = teamId && teamId !== ""
      ? `/teams/${teamId}/tags.json`
      : `/tags.json`

    fetch(url)
      .then(response => response.json())
      .then(tags => this.renderTagOptions(tags))
      .catch(error => console.error("Error loading tags:", error))
  }

  renderTagOptions(tags) {
    const menu = this.tagMenuTarget
    menu.innerHTML = ''

    const defaultOption = document.createElement("li")
    const defaultLink = document.createElement("a")
    defaultLink.href = "#"
    defaultLink.dataset.value = ""
    defaultLink.textContent = "タグを選択（任意）"
    defaultLink.addEventListener("click", (e) => this.selectTag(e))
    defaultOption.appendChild(defaultLink)
    menu.appendChild(defaultOption)

    tags.forEach(tag => {
      const li = document.createElement("li")
      const a = document.createElement("a")
      a.href = "#"
      a.dataset.value = tag.id
      a.textContent = tag.name
      a.addEventListener("click", (e) => this.selectTag(e))
      li.appendChild(a)
      menu.appendChild(li)
    })
  }
}
