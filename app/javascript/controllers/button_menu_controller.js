import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button-menu"
export default class extends Controller {
  static targets = ['button', 'content']

  connect() {
    let active = null

    function isActive(btn) {
      if (btn.dataset.status === "active") return true
    }

    this.element.addEventListener('touchend', e => {
      active = this.buttonTargets.findIndex(isActive)
      this.contentTargets.forEach(content => {
        content.dataset.status = ""
      });
      this.contentTargets[active].dataset.status = "active"
    })
  }

  update() {
    let active = null

    function isActive(btn) {
      if (btn.dataset.status === "active") return true
    }

    this.buttonTargets.forEach(btn => {
      btn.dataset.status = ""
    });
    event.target.dataset.status = "active"
    active = this.buttonTargets.findIndex(isActive)
    console.log(active)
    this.contentTargets.forEach(content => {
      content.dataset.status = ""
    });
    this.contentTargets[active].dataset.status = "active"
  }
}
