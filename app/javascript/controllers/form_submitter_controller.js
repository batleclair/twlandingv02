import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submitter"
export default class extends Controller {
  static targets = ['form', 'list']

  connect() {
  }

  submit() {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const form = new FormData(this.formTarget)
    this.listTarget.querySelectorAll(".sm-red-msg").forEach((p) => { p.outerHTML = ''; });
    fetch(this.formTarget.action, {
      method: this.formTarget.method,
      headers: {"X-CSRF-Token": token },
      body: form
    })
      .then(response => response.json())
      .then((data) => {
        if (data.valid) {
          this.formTarget.reset()
          this.listTarget.innerHTML = data['content']
        } else {
          this.listTarget.insertAdjacentHTML('beforeend', `<p class="sm-red-msg">${data['errors']['offer_list_id'][0]}</p>`)
        }
      })
  }

  destroy() {
    event.preventDefault()
    if (confirm('😰 attention ! es-tu sûr·e de vouloir supprimer cette ligne ?')) {
      const token = document.querySelector("[name='csrf-token']").content
      fetch(event.currentTarget.href, {
        method: 'DELETE',
        headers: {"X-CSRF-Token": token },
      })
      .then(response => response.json())
        .then((data) => {
          this.listTarget.innerHTML = data['content']
        })
    }
  }

}
