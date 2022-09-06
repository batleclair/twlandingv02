import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["close", "window"]
  connect() {
  }

  close(event) {
    event.preventDefault()
    if ((event.type === 'keyup' && event.key === 'Escape') || event.type === 'click') {
      this.windowTargets.forEach(target => {
        target.style.display = "none"
      });

    }
  }

  keep(event) {
    event.stopImmediatePropagation()
  }

}
