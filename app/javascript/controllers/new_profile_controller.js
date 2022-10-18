import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-profile"
export default class extends Controller {
  static targets = ['form', 'company']

  connect() {
  }

  save() {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const form = new FormData(this.formTarget)
    this.formTarget.querySelectorAll(".sm-red-msg").forEach((p) => { p.outerHTML = ''; });
    this.formTarget.querySelectorAll(".notice").forEach((p) => { p.outerHTML = ''; });

    fetch(`${this.formTarget.action}/synch`, {
      method: this.formTarget.method,
      headers: {"X-CSRF-Token": token },
      body: form
    })
      .then(response => response.json())
      .then((data) => {
        if (data.valid) {
          window.location.href = '/offers'
          document.querySelector('body').insertAdjacentHTML('beforeend', '<p class="notice">👍 tes changements ont été enregistrés !</p>')
        } else {
          Object.entries(data['errors']).forEach(pair => {
            this.formTarget.querySelector(`.candidate_${pair[0]}`).insertAdjacentHTML('beforeend', `<p class="sm-red-msg">${pair[1]}</p>`)
          });
        }
      })
  }

  hide() {
    this.companyTarget.classList.remove('d-none')
    if (event.currentTarget.value === 'freelance' || event.currentTarget.value === 'inactive') {
      this.companyTarget.classList.add('d-none')
    }
  }
}
