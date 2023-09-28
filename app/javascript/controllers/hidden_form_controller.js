import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hidden-form"
export default class extends Controller {
  static targets = ["input", "output", "form"]

  connect() {
  }

  edit() {
    event.preventDefault()
    this.inputTargets.forEach(input => {
      input.classList.remove("d-none")
    });
    this.outputTargets.forEach(output => {
      output.classList.add("d-none")
    });
  }

  cancel() {
    event.preventDefault()
    this.inputTargets.forEach(input => {
      input.classList.add("d-none")
    });
    this.outputTargets.forEach(output => {
      output.classList.remove("d-none")
    });
    this.formTarget.reset()
  }

  keep(event) {
    event.stopImmediatePropagation()
  }

  submit() {
    this.formTarget.submit()
  }

}
