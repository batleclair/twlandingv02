import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password"
export default class extends Controller {
  static targets = ['input']

  connect() {
  }

  toggle(event) {
    event.target.classList.toggle("fa-eye-slash")
    event.target.classList.toggle("fa-eye")
    event.target.classList.toggle("text-main")
    this.inputTarget.type === "password" ? this.inputTarget.type = "input" : this.inputTarget.type = "password"
  }
}
