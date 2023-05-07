import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress"
export default class extends Controller {
  static targets = ['cvmsg', 'cv']

  connect() {
  }

  cv() {
    if (this.cvTarget.files && this.cvTarget.files[0]) {
      this.cvmsgTarget.innerHTML = this.cvTarget.value.replace('fakepath', '...')
    }
  }
}
