import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-entries"
export default class extends Controller {
  static targets = ['list', 'carousel']

  connect() {
    console.log("hello from filter controller");
  }

  showResult(event) {
    event.preventDefault();
    this.listTarget.classList.remove("hidden");
    this.carouselTarget.classList.add("hidden");
  }
}
