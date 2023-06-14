import Carousel from 'stimulus-carousel'

export default class extends Carousel {
  connect() {
    super.connect()
    console.log('Hello from carousel')
  }
}
