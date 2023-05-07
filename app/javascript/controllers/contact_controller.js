import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="contact"
export default class extends Controller {
  static targets = ["window", "org", "form", "org"]

  connect() {
  }

  popup(event) {
    event.preventDefault()
    this.windowTarget.style.display = "block"
  }

  show(event) {
    this.orgTarget.style="display: none;"
    if  (event.target.value === 'Association' || event.target.value === 'Entreprise') {
      this.orgTarget.style=""
    }
  }

  toggle(event) {
    const form = new FormData(this.formTarget)
    if (form.get('contact[contact_type]').startsWith('Candi')) {
      this.orgTarget.classList.add("readonly-input")
      this.orgTarget.classList.disabled = true
    } else {
      this.orgTarget.classList.remove("readonly-input")
      this.orgTarget.classList.disabled = false
    }
  }

  save(event) {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const form = new FormData(this.formTarget)

    this.formTarget.querySelectorAll(".invalid-msg").forEach((p) => { p.outerHTML = ''; });
    this.formTarget.querySelectorAll(".invalid-input").forEach((p) => { p.classList.remove("invalid-input"); });
    this.formTarget.querySelectorAll(".notice").forEach((p) => { p.outerHTML = ''; });

    fetch(this.formTarget.action, {
      method: "POST",
      headers: {"X-CSRF-Token": token },
      body: form
    })
      .then(response => response.json())
      .then((data) => {
        if (data['valid']) {
          document.querySelector('body').insertAdjacentHTML('beforeend', '<p class="notice">Bien reçu ! Nous vous recontacterons rapidement 😀</p>')
          this.formTarget.reset()
          this.windowTarget.style.removeProperty('display')

        } else {
          Object.keys(data['errors']).forEach(key => {
            Object.values(data['errors'][key]).forEach(value => {
              this.formTarget.querySelector(`#contact_${key}_wrapper`).insertAdjacentHTML('beforeend', `<div class="invalid-msg">${value}</p>`)
              this.formTarget.querySelector(`#contact_${key}`).classList.add("invalid-input")
            });
          });
        }
      })
  }
}
