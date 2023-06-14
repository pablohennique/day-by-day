import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["generating"]

  connect() {
    console.log(`connected`)
    console.log(this.generatingTarget);
  }
}
