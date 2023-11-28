import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="multi-select"
export default class extends Controller {
  static targets = ['submit', 'checkbox']

  connect() {
  }

  toggle() {
    const selection = this.checkboxTargets.filter((element) => element.checked === true)
    selection.length > 0 ? this.submitTarget.disabled = false : this.submitTarget.disabled = true
  }
}
