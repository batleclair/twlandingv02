import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["close", "window"]
  connect() {
  }

  popup(event) {
    event.preventDefault()
    this.windowTarget.style.display = "block"
  }

  close(event) {
    event.preventDefault()
    this.windowTarget.style.display = "none"
  }
}
