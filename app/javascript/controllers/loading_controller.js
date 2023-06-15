import { Controller } from "@hotwired/stimulus"
// import { end } from "@popperjs/core";

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["loadingCard", "recoCards"];
  static values = {
    id: String
  }
  connect() {
    let visitedPages = (JSON.parse(localStorage.getItem("visitedPages")));

    if (visitedPages === null) {
      visitedPages = []
    }

    if (visitedPages.includes(this.idValue)) {
      this.loadingCardTarget.remove();
      this.recoCardsTarget.classList.remove("hidden")
    } else {
      setTimeout(() => {
        this.loadingCardTarget.remove();
        this.recoCardsTarget.classList.remove("hidden");
      }, 4000);
      visitedPages.push(this.idValue)
      localStorage.setItem("visitedPages", JSON.stringify(visitedPages));
    }
  };
}
