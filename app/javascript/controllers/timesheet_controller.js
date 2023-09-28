import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timesheet"
export default class extends Controller {
  static targets = ["slot", "inputmin", "inputmax"]
  static values = {
    date: String,
  }

  connect() {
  }

  set() {
    const drawable = () => this.element.dataset.drawable === "true"
    const updateDrawable = () => {
      this.element.dataset.drawable === "true" ? this.element.dataset.drawable = "false" : this.element.dataset.drawable = "true"
    }
    updateDrawable()
    if (drawable()) {
      this.slotTargets.forEach(slot => {
        slot.dataset.selected = ""
        event.target.dataset.selected = "true"
      });
      this.inputminTarget.value = `${this.dateValue} ${event.target.dataset.time}`
    } else {
      let i = parseInt(event.target.dataset.selectable)
      const endTime = this.slotTargets.find((element) => parseInt(element.dataset.selectable) === i + 1);
      this.inputmaxTarget.value = `${this.dateValue} ${endTime.dataset.time}`
    }
  }


  select() {
    const drawable = () => this.element.dataset.drawable === "true"
    if (drawable()) {
      const last = this.slotTargets.filter((element) => element.dataset.selected === "true").slice(-1)[0]
      let i = parseInt(last.dataset.selectable)
      let n = parseInt(event.target.dataset.selectable)
      if (i + 1 === n ) {
        event.target.dataset.selected = "true"
        i += 1
      }
    }
  }
}
