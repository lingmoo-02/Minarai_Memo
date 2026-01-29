import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filterPanel", "toggleButton", "toggleIcon"]

  // 初期化時の処理
  connect() {
    this.updateVisibility()
  }

  // トグル処理 - フィルタパネルの表示/非表示を切り替え
  toggle() {
    this.filterPanelTarget.classList.toggle("hidden")
    this.updateIcon()
    this.updateAriaExpanded()
  }

  // アイコン更新 - chevron-down ⇔ chevron-up
  updateIcon() {
    const isHidden = this.filterPanelTarget.classList.contains("hidden")

    if (isHidden) {
      this.toggleIconTarget.classList.remove("fa-chevron-up")
      this.toggleIconTarget.classList.add("fa-chevron-down")
    } else {
      this.toggleIconTarget.classList.remove("fa-chevron-down")
      this.toggleIconTarget.classList.add("fa-chevron-up")
    }
  }

  // aria-expanded属性を更新（アクセシビリティ対応）
  updateAriaExpanded() {
    const isExpanded = !this.filterPanelTarget.classList.contains("hidden")
    this.toggleButtonTarget.setAttribute("aria-expanded", isExpanded)
  }

  // 初期表示状態の判定
  updateVisibility() {
    const hasFilters = this.hasSearchParams()

    if (hasFilters) {
      // フィルタパラメータがある場合は展開
      this.filterPanelTarget.classList.remove("hidden")
    } else {
      // デフォルトは非表示
      this.filterPanelTarget.classList.add("hidden")
    }

    this.updateIcon()
    this.updateAriaExpanded()
  }

  // 検索パラメータの存在確認
  hasSearchParams() {
    const urlParams = new URLSearchParams(window.location.search)
    return urlParams.has('keyword') ||
           urlParams.has('tag_id') ||
           urlParams.has('date_from') ||
           urlParams.has('date_to')
  }
}
