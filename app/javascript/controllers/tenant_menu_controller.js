import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tenant-menu"
export default class extends Controller {
  static targets = ['submenu', 'menu']

  connect() {
  }

  expand() {
    this.submenuTargets.forEach(submenu => {
      if (submenu == event.target) {
        submenu.toggleAttribute("expanded")
      } else {
        submenu.removeAttribute("expanded")
      }
    });
  }

  mobile(){
    this.menuTarget.toggleAttribute("expanded")
  }

  keep(event) {
    event.stopImmediatePropagation()
  }

}
