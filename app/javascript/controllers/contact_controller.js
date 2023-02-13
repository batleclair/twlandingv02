import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="contact"
export default class extends Controller {
  static targets = ["window", "org"]

  connect() {
  }

  popup(event) {
    event.preventDefault()
    this.windowTarget.style.display = "block"
  }

  show(event) {
    this.orgTarget.style="display: none;"
    if  (event.target.value === 'Association' || event.target.value === 'Entreprise') {
      this.orgTarget.style=""
    }
  }
}
