import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="contact"
export default class extends Controller {
  static targets = ["window"]

  connect() {
  }

  popup(event) {
    event.preventDefault()
    this.windowTarget.style.display = "block"
  }

}
