import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["generating"]
  static values = {
    userId: Number,
    obstacleStatus: String
  }

  connect() {
    const currentStatus = this.obstacleStatusValue

    if (currentStatus === "started") {
      const interval = setInterval(() => {

        fetch("/get_obstacle_status", {
          headers: { "Accept": "text/plain"}
        })
          .then(response => response.text())
          .then((data) => {
            // console.log(data);
            const status = data.toString().trim()
            if (status === 'completed') {
              this.change_card_on_view()
              clearInterval(interval)
            }
          })
      }, 1000)
    }
  }

  change_card_on_view() {
    fetch('/render_completed_obstacle_card', {
      headers: { "Accept": "text/plain"}
    })
      .then(response => response.text())
      .then((data) => {
        this.generatingTarget.outerHTML = data
      })
  }
}
