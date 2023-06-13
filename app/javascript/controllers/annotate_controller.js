import { Controller } from "@hotwired/stimulus"
import { annotate } from 'rough-notation'

// Connects to data-controller="annotate"
export default class extends Controller {
  static targets = ['banner', 'cta', 'underline', 'circle']

  connect() {
    // console.log(this.element);
    if (this.hasBannerTarget) {
      annotate(this.bannerTarget, { type: 'highlight', color: '#FEC700' }).show();
    } else if (this.hasCtaTarget) {
      annotate(this.ctaTarget, { type: 'underline', color: '#FEC700' }).show();
    } else if (this.hasUnderlineTarget) {
      annotate(this.underlineTarget, { type: 'underline', color: '#FEC700' }).show();
    } else if (this.hasCircleTarget) {
      annotate(this.circleTarget, { type: 'circle', color: '#FEC700' }).show();
    }
  }
}
