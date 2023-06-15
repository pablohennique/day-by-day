import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-entries"
export default class extends Controller {
  static targets = ['list', 'carousel', 'calendar','inputField']

  connect() {

  }

  showResult(event) {
    event.preventDefault();

    this.carouselTarget.classList.add("hidden");
    this.listTarget.classList.remove("hidden");

    fetch(`${this.calendarTarget.action}?To=${this.inputFieldTarget.value}`, {
      headers: { "Accept": "application/json"}
    })
    .then(response => response.json())
    .then( (data) => {
      console.log(this.listTarget)
      this.listTarget.innerHTML = data.form
    })
  }
}
