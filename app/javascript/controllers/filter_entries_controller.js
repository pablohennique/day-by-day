import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-entries"
export default class extends Controller {
  connect() {
    console.log("hello from filter controller");
  }
}
