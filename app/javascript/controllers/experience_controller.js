import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="experience"
export default class extends Controller {
  static targets = ["window", "form", "close", "list", "content"]

  connect() {
  }

  popup(event) {
    event.preventDefault()
    const url = event.currentTarget.href === undefined ? '/experiences/nil/select' : event.currentTarget.href
    fetch(url, {
    })
    .then(response => response.json())
    .then((data) => {
      this.contentTarget.innerHTML = data.content
      this.windowTarget.style.display = "block"
    })
  }

  save() {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const form = new FormData(this.formTarget)

    this.formTarget.querySelectorAll(".sm-red-msg").forEach((p) => { p.outerHTML = ''; });
    this.formTarget.querySelectorAll(".notice").forEach((p) => { p.outerHTML = ''; });

    fetch(this.formTarget.action, {
      method: this.formTarget.method,
      headers: {"X-CSRF-Token": token },
      body: form
    })
      .then(response => response.json())
      .then((data) => {
        if (data.valid) {
          document.querySelector('body').insertAdjacentHTML('beforeend', '<p class="notice">👍 tes changements ont été enregistrés !</p>')
          this.listTarget.outerHTML = data['content']
          this.closeTarget.click()
          this.formTarget.reset()
        } else {
          Object.entries(data['errors']).forEach(pair => {
            this.formTarget.querySelector(`.experience_${pair[0]}`).insertAdjacentHTML('beforeend', `<p class="sm-red-msg">${pair[1]}</p>`)
          });
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
          console.log(data)
          this.listTarget.outerHTML = data['content']
        })
    }
  }
}
