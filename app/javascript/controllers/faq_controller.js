import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="faq"
export default class extends Controller {
  static targets = ['box']

  connect() {
  }

  show() {
    if (event.currentTarget.classList.contains('faq-active')) {
      event.currentTarget.classList.remove('faq-active')
    } else {
      this.boxTargets.forEach(box => {
        box.classList.remove('faq-active')
      });
      event.currentTarget.classList.add('faq-active')
    }
  }
}
