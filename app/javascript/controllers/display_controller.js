import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="display"
export default class extends Controller {
  static targets = ["output"]

  connect() {
    console.log('helooooo')
  }

  update() {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    fetch(`${event.target.href}.json`, {
      method: "GET",
      headers: {"X-CSRF-Token": token },
      contentType: "json"
    })
      .then(response => response.json())
      .then((data) => {
        this.outputTarget.innerHTML = data["content"]
      })
  }
}
