import { Controller } from "@hotwired/stimulus"
import { annotate } from 'rough-notation'

// Connects to data-controller="annotate"
export default class extends Controller {
  static targets = ['banner', 'cta']

  connect() {
    // console.log(this.bannerTarget);
    annotate(this.bannerTarget, { type: 'highlight', color: '#FEC700' }).show();
    annotate(this.ctaTarget, { type: 'highlight', color: '#FEC700' }).show();
  }
}


// export default class extends Controller {
//   connect() {
//     const annotation = annotate(this.element, { type: 'highlight', color: '#FEC700' });
//     annotation.show();
//   }
// }
