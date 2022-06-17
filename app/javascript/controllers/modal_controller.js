import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["close", "window"]
  connect() {
    console.log(this.closeTarget)
    console.log(this.windowTarget)
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
