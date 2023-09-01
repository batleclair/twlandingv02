import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dynamic-form"
export default class extends Controller {
  static targets = ['output', 'customctn']
  connect() {
  }

  display() {
    const id = event.target.dataset.id
    console.log(id)
    this.outputTargets.forEach(t => {

      console.log(t.dataset.id)
      if (t.dataset.id === id) {
        t.classList.toggle("d-none")
      }
    });
  }

  custom() {
    if (event.target.value === "Autre (préciser)") {
      // event.target.disabled = true
      // this.customfieldTarget.disabled = false
      this.customctnTarget.classList.remove("d-none")
    } else {
      // event.target.disabled = false
      // this.customfieldTarget.disabled = true
      this.customctnTarget.classList.add("d-none")
    }
  }
}
