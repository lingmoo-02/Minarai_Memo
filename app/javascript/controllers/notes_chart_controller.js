import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

// Connects to data-controller="notes-chart"
export default class extends Controller {
  connect() {
    const ctx = this.element.getContext("2d")

    const labels = JSON.parse(this.element.dataset.labels)
    const data = JSON.parse(this.element.dataset.data)

    new Chart(ctx, {
      type: "line",
      data: {
        labels: labels,
        datasets: [{
          label: "ノート作成数",
          data: data,
          borderColor: "rgba(59, 130, 246, 1)",   // Tailwindのblue-500
          backgroundColor: "rgba(59, 130, 246, 0.2)",
          tension: 0.3,
          fill: true,
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true, ticks: { stepSize: 1 } }
        }
      }
    })
  }
}
