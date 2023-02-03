import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="candidacy"
export default class extends Controller {
  static targets =["window", "content"]
  connect() {
  }

  popup2(event) {
    event.preventDefault()
    if (event.target.dataset.id === undefined) {
      this.windowTarget.style.display = "block"
    } else {
      const urlSelect = `../offers/${event.target.dataset.id}/select`
      console.log(urlSelect)
      fetch(urlSelect, {

      })
      .then(response => response.json())
      .then((data) => {
       this.contentTarget.innerHTML = data.content
       this.windowTarget.style.display = "block"
      })
    }
  }

}
