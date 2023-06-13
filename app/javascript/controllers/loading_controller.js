import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core";

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["loadingCard", "recoCards"];
  static values = {
    id: String
  }
  connect() {
    // console.log(this.idValue);
    // console.log(localStorage.getItem("hasCodeRunBefore"));
    // console.log(localStorage.getItem("hasCodeRunBefore") === this.idValue);
    // console.log(localStorage.getItem("hasCodeRunBefore") !== this.idValue);

  const hasCodeRunBefore = localStorage.getItem("hasCodeRunBefore")
      if (hasCodeRunBefore !== this.idValue) {
        setTimeout(() => {
          this.loadingCardTarget.remove();
          this.recoCardsTarget.classList.remove("hidden");
            }, 4000);
        localStorage.setItem("hasCodeRunBefore", this.idValue);

        console.log("IF activated")

      } else {
        this.loadingCardTarget.remove();
        this.recoCardsTarget.classList.remove("hidden")

        console.log("IF skipped")

      }
  };
}
