import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["close", "window", "content"]
  connect() {
  }

  popup(event) {
    event.preventDefault()
    this.windowTarget.style.display = "block"
  }

  close(event) {
    event.preventDefault()
    if ((event.type === 'keyup' && event.key === 'Escape') || event.type === 'click') {
      this.windowTarget.style.display = "none"
    }
  }

  keep(event) {
    event.stopImmediatePropagation()
  }

  popup2(event) {
    event.preventDefault()
    const urlSelect = `offers/${event.target.dataset.id}/select`
    fetch(urlSelect, {

    })
    .then(response => response.json())
    .then((data) => {
     this.contentTarget.innerHTML = data.content
     this.windowTarget.style.display = "block"
    })
  }
}
