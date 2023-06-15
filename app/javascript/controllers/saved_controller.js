import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="saved"
export default class extends Controller {
  static targets = ['valid']

  connect() {
  }

  checked(event) {
    event.preventDefault()
    console.log(this.validTarget);
    this.validTarget.classList.remove("hidden");
    this.validTarget.classList.add("hidden");
  }
}
