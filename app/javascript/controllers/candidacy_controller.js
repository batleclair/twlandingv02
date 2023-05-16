import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="candidacy"
export default class extends Controller {
  static targets =["window", "content", "form", "employer"]

  connect() {
  }

  popup2(event) {
    event.preventDefault()
    if (event.target.dataset.id === undefined) {
      this.windowTarget.style.display = "block"
    } else {
      const urlSelect = `../offers/${event.target.dataset.id}/select`
      fetch(urlSelect, {
      })
      .then(response => response.json())
      .then((data) => {
       this.contentTarget.innerHTML = data.content
       this.windowTarget.style.display = "block"
      })
    }
  }

  toggle(event) {
    const form = new FormData(this.formTarget)
    if (form.get('candidate[status]').startsWith('Salar')) {
      this.employerTarget.classList.remove("readonly-input")
      this.employerTarget.disabled = false
    } else {
      this.employerTarget.classList.add("readonly-input")
      this.employerTarget.disabled = true
    }
  }

  submit(event) {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const candidate = new FormData(this.formTarget)
    const candidacy = new FormData
    candidacy.append("candidacy[motivation_msg]", candidate.get('candidate[candidacy][motivation_msg]'))
    candidate.delete('candidate[candidacy][motivation_msg]')
    const candidateMethod = this.formTarget.id.startsWith("new") ? "POST" : "PATCH"
    const offer = this.formTarget.dataset.offer
    const candidacyUrl = `../missions/${offer}/candidacies`
    console.log(candidacyUrl)
    this.formTarget.querySelectorAll(".invalid-msg").forEach((div) => { div.outerHTML = ''; });
    this.formTarget.querySelectorAll(".invalid-input").forEach((input) => { input.classList.remove("invalid-input"); });

    fetch(this.formTarget.action, {
      method: candidateMethod,
      headers: {"X-CSRF-Token": token },
      body: candidate
    })
      .then(response => response.json())
      .then((data) => {

        if (data['valid']) {
          fetch(candidacyUrl, {
            method: "POST",
            headers: {"X-CSRF-Token": token },
            body: candidacy
          })
            .then(response => response.json())
            .then((data) => {
              console.log(data['id'])
              window.location.replace(`/candidacies/${data['id']}`);
            })
        } else {
          Object.keys(data['errors']).forEach(key => {
            Object.values(data['errors'][key]).forEach(value => {
              this.formTarget.querySelector(`#candidate_${key}_wrapper`).insertAdjacentHTML('beforeend', `<div class="invalid-msg">${value}</p>`)
              this.formTarget.querySelector(`#candidate_${key}`).classList.add("invalid-input")
            });
          });
        }
      })
  }
}
