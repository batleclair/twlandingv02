import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  static targets = ['message', 'ctn', 'label']

  connect() {
    console.log(this.element.offsetHeight)
    console.log(this.messageTargets[0].offsetHeight)
    console.log(this.messageTargets.pop().offsetHeight)
    this.element.style.height = `${this.messageTargets[0].offsetHeight + 30}px`;
  }

  toggle() {
    this.element.toggleAttribute("expanded");
    if (this.element.hasAttribute("expanded")) {
      this.element.style.height = `${this.ctnTarget.offsetHeight + 30}px`;
      this.labelTarget.innerText = "masquer les anciens messages"
    } else {
      this.element.style.height = `${this.messageTargets[0].offsetHeight + 30}px`;
      this.labelTarget.innerText = "voir tous les messages"
    }
  }
}
