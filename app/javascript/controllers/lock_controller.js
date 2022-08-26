import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lock"
export default class extends Controller {
  static targets = ['login', 'apply']

  connect() {
  }

  unhide(event) {
    this.applyTarget.classList.add('d-none')
    this.loginTarget.classList.remove('d-none')
    this.loginTarget.classList.add('d-flex')
  }
}
