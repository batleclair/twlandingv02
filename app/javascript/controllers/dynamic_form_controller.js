import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dynamic-form"
export default class extends Controller {
  static targets = ['output', 'input', 'trigger', 'customOutput', 'customTrigger']

  connect() {
    this.toggle()
    this.customToggle()
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

  customToggle() {
    if (this.hasCustomTriggerTarget) {
      if (this.customTriggerTarget.value === "Autre (préciser)") {
        this.customOutputTarget.classList.remove("d-none")
      } else {
        this.customOutputTarget.classList.add("d-none")
      }
    }
  }

  toggle() {
    if (this.hasTriggerTarget) {
      this.inputTargets.forEach(t => {
        this.triggerTarget.checked ? t.classList.add("d-none") : t.classList.remove("d-none")
      });
      this.outputTargets.forEach(t => {
        this.triggerTarget.checked ? t.classList.remove("d-none") : t.classList.add("d-none")
      });
    }
  }

  enable(){
    if (this.triggerTarget.checked) {
      this.inputTarget.classList.remove("disabled")
    } else {
      this.inputTarget.classList.add("disabled")
    }
  }
}
