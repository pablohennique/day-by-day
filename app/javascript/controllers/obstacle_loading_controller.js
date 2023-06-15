import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["generating", "list"]
  static values = {
    userId: Number,
    obstacleStatus: String
  }

  connect() {
    // console.log(`connected`)
    // console.log(this.generatingTarget);
    // console.log(this.listTarget);
    // this.#targetObstacleCard()
    // console.log(this.userIdValue);
    // console.log(this.obstacleStatusValue);


    // Watch for changes in the key's value
    const currentStatus = this.obstacleStatusValue

    if (currentStatus === "started") {
      setInterval(() => {

        fetch("/get_obstacle_status", {
          headers: { "Accept": "text/plain"}
        })
          .then(response => response.text())
          .then((data) => {
            if (data === "completed") {
              change_card_on_view()
            }
            // console.log("data: ", data )
          })

        // const currentValue = this.obstacleStatusValue

        // console.log(currentValue);

        // if (currentValue === "completed") {
        //   this.#valueUpdated(currentValue)
        //   return;
        // }
      }, 1000)
    }

  }

  change_card_on_view() {

  }
}
