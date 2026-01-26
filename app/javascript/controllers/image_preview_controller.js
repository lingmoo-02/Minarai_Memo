import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "currentImage", "placeholder"]

  previewImage(event) {
    const file = event.target.files[0]

    if (!file) {
      this.resetPreview()
      return
    }

    // ファイルタイプの検証
    if (!file.type.startsWith('image/')) {
      alert('画像ファイルを選択してください')
      event.target.value = ''
      return
    }

    // ファイルサイズの検証（5MB）
    const maxSize = 5 * 1024 * 1024
    if (file.size > maxSize) {
      alert('ファイルサイズは5MB以下にしてください')
      event.target.value = ''
      return
    }

    // FileReader で画像を読み込み
    const reader = new FileReader()
    reader.onload = (e) => {
      // プレビュー画像を表示
      this.previewTarget.src = e.target.result
      this.previewTarget.classList.remove('hidden')

      // 既存画像とプレースホルダーを非表示
      if (this.hasCurrentImageTarget) {
        this.currentImageTarget.classList.add('hidden')
      }
      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.classList.add('hidden')
      }
    }
    reader.readAsDataURL(file)
  }

  resetPreview() {
    // プレビューを非表示
    if (this.hasPreviewTarget) {
      this.previewTarget.classList.add('hidden')
      this.previewTarget.src = ''
    }

    // 既存画像またはプレースホルダーを表示
    if (this.hasCurrentImageTarget) {
      this.currentImageTarget.classList.remove('hidden')
    } else if (this.hasPlaceholderTarget) {
      this.placeholderTarget.classList.remove('hidden')
    }
  }
}
