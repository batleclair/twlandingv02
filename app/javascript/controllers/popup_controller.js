import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="popup"
export default class extends Controller {
  static targets = ["close", "window"]

  connect() {
  }

  close() {
    event.preventDefault()
    if ((event.type === 'keyup' && event.key === 'Escape') || event.type === 'click') {
      this.windowTargets.forEach(window => {
        window.dataset.active = false
      });

    }
    // if (document.getElementById('navbar')) {
    //   document.getElementById('navbar').classList.remove("z1")
    // }
  }

  keep(event) {
    event.stopImmediatePropagation()
  }

  open() {
    event.preventDefault()
    const id = event.target.dataset.popUpId
    this.windowTargets.forEach(window => {
      window.dataset.active = (window.dataset.popUpId === id)
    });
    // if (document.getElementById('navbar')) {
    //   document.getElementById('navbar').classList.add("z1")
    // }
  }
}
