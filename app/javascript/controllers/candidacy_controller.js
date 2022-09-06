import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="candidacy"
export default class extends Controller {
  static targets =["window", "content"]
  connect() {
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
