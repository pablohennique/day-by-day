import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"


export default class extends Controller {
  static targets = ["generating", "list"]
  static values = {
    userId: Number
  }

  connect() {
    // console.log(`connected`)
    // console.log(this.generatingTarget);
    // console.log(this.listTarget);
    // this.#targetObstacleCard()
    // console.log(this.userIdValue);

    this.channel = createConsumer().subscriptions.create(
      { channel: "SideqikChannel", id: this.userIdValue },
      { received: data => console.log(data) }
    )
  }

  #targetObstacleCard() {
    const card = this.generatingTargets.find(card => card.dataset.obstacleId === '25')
    console.log(card);
  }
}
