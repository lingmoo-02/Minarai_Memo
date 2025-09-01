import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  connect() {
    
    this.ctx = this.element.getContext("2d")

    // 初期表示（日単位）
    this.chart = new Chart(this.ctx, {
      type: "line",
      data: {
        labels: JSON.parse(this.element.dataset.dailyLabels),
        datasets: [{
          label: "ノート累計数",
          data: JSON.parse(this.element.dataset.dailyData),
          borderColor: "rgba(59, 130, 246, 1)",
          backgroundColor: "rgba(59, 130, 246, 0.2)",
          tension: 0.3,
          fill: true
        }]
      },
      options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
      }
    })
  }

  switch(event) {
    console.log("Tab clicked:", event.target.dataset.range)
    event.preventDefault()

    const range = event.target.dataset.range
    let labels, data

    if (range === "day") {
      labels = JSON.parse(this.element.dataset.dailyLabels)
      data   = JSON.parse(this.element.dataset.dailyData)
    } else if (range === "week") {
      labels = JSON.parse(this.element.dataset.weeklyLabels)
      data   = JSON.parse(this.element.dataset.weeklyData)
    } else if (range === "month") {
      labels = JSON.parse(this.element.dataset.monthlyLabels)
      data   = JSON.parse(this.element.dataset.monthlyData)
    } else if (range === "year") {
      labels = JSON.parse(this.element.dataset.yearlyLabels)
      data   = JSON.parse(this.element.dataset.yearlyData)
    }

    this.chart.data.labels = labels
    this.chart.data.datasets[0].data = data
    this.chart.update()

    // タブの見た目を切り替える
    document.querySelectorAll(".tab").forEach(tab => tab.classList.remove("tab-active"))
    event.target.classList.add("tab-active")
  }
}
