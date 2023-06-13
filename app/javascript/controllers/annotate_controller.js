import { Controller } from "@hotwired/stimulus"
import { annotate } from 'rough-notation'

// Connects to data-controller="annotate"
export default class extends Controller {
  connect() {
    const annotation = annotate(this.element, { type: 'highlight', color: '#FEC700' });
    annotation.show();
  }
}
