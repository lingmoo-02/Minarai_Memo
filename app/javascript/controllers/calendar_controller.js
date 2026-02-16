import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["calendar", "monthYear"]
  static values = {
    noteDates: Array,
    currentYear: Number,
    currentMonth: Number
  }

  connect() {
    const now = new Date()
    this.currentYearValue = now.getFullYear()
    this.currentMonthValue = now.getMonth()
    this.renderCalendar()
  }

  previousMonth() {
    if (this.currentMonthValue === 0) {
      this.currentMonthValue = 11
      this.currentYearValue--
    } else {
      this.currentMonthValue--
    }
    this.renderCalendar()
  }

  nextMonth() {
    if (this.currentMonthValue === 11) {
      this.currentMonthValue = 0
      this.currentYearValue++
    } else {
      this.currentMonthValue++
    }
    this.renderCalendar()
  }

  renderCalendar() {
    // 月年表示を更新
    this.updateMonthYear()

    // カレンダーグリッドをクリア
    const calendarElement = this.calendarTarget
    calendarElement.innerHTML = ""

    // カレンダーグリッドを生成
    const firstDay = new Date(this.currentYearValue, this.currentMonthValue, 1)
    const lastDay = new Date(this.currentYearValue, this.currentMonthValue + 1, 0)
    const daysInMonth = lastDay.getDate()
    const startingDayOfWeek = firstDay.getDay()

    // 前月の余った日数を追加
    for (let i = 0; i < startingDayOfWeek; i++) {
      const emptyCell = document.createElement("div")
      emptyCell.className = "aspect-square flex items-center justify-center p-2 rounded text-gray-400"
      calendarElement.appendChild(emptyCell)
    }

    // 当月の日数を追加
    const today = new Date()
    for (let day = 1; day <= daysInMonth; day++) {
      const cell = this.createDayCell(day, today)
      calendarElement.appendChild(cell)
    }
  }

  createDayCell(day, today) {
    const cell = document.createElement("div")
    cell.className = "aspect-square flex flex-col items-center justify-center p-2 rounded text-sm relative cursor-pointer transition"

    // 日付文字列を作成
    const dateStr = `${this.currentYearValue}-${String(this.currentMonthValue + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`

    // data-date 属性を追加
    cell.dataset.date = dateStr

    // クリックイベントを追加
    cell.addEventListener('click', () => this.selectDate(dateStr))

    // ノートがある日付かチェック
    const hasNote = this.noteDatesValue.includes(dateStr)

    // 今日の日付かチェック
    const isToday = today.getFullYear() === this.currentYearValue &&
                    today.getMonth() === this.currentMonthValue &&
                    today.getDate() === day

    // スタイルを設定
    if (isToday) {
      cell.className += " bg-green-100 border-2 border-green-500"
      const span = document.createElement("span")
      span.className = "font-bold text-green-700"
      span.textContent = day
      cell.appendChild(span)
    } else if (hasNote) {
      cell.className += " hover:bg-gray-100"
      const span = document.createElement("span")
      span.className = "font-semibold text-green-700"
      span.textContent = day
      cell.appendChild(span)

      const dot = document.createElement("div")
      dot.className = "w-1.5 h-1.5 bg-green-500 rounded-full mt-1"
      cell.appendChild(dot)
    } else {
      cell.className += " text-gray-700 hover:bg-gray-100"
      const span = document.createElement("span")
      span.className = "text-sm"
      span.textContent = day
      cell.appendChild(span)
    }

    return cell
  }

  updateMonthYear() {
    const monthNames = [
      "1月", "2月", "3月", "4月", "5月", "6月",
      "7月", "8月", "9月", "10月", "11月", "12月"
    ]
    const monthYearStr = `${this.currentYearValue}年 ${monthNames[this.currentMonthValue]}`
    this.monthYearTarget.textContent = monthYearStr
  }

  selectDate(dateStr) {
    // 選択状態のスタイルを更新
    this.updateSelectedDate(dateStr)

    // サーバーからノートを取得
    const url = `/notes/by_date?date=${dateStr}`

    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
    .then(response => {
      if (response.ok) {
        return response.text()
      }
      throw new Error('Network response was not ok')
    })
    .then(html => {
      // Turbo Stream を適用
      Turbo.renderStreamMessage(html)
    })
    .catch(error => {
      console.error('Error fetching notes:', error)
    })
  }

  updateSelectedDate(dateStr) {
    // 既存の選択状態をクリア
    const prevSelected = this.calendarTarget.querySelector('[data-selected="true"]')
    if (prevSelected) {
      prevSelected.removeAttribute('data-selected')
      prevSelected.classList.remove('ring-2', 'ring-blue-500')
    }

    // 新しい選択状態を追加
    const selected = this.calendarTarget.querySelector(`[data-date="${dateStr}"]`)
    if (selected) {
      selected.dataset.selected = 'true'
      selected.classList.add('ring-2', 'ring-blue-500')
    }
  }
}
