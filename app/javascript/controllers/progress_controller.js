import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress"
export default class extends Controller {
  static targets = ['bar1', 'bar2', 'bar3', 'step1', 'step2', 'step3', 'next', 'form1', 'form2', 'header', 'num', 'confirmation', 'foremployees']

  connect() {
  }

  step3(event) {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const form2 = new FormData(this.form2Target)
    const offerId = this.nextTarget.dataset.offer
    const urlCheck = `/offers/${offerId}/check`
    this.form2Target.querySelectorAll(".sm-red-msg").forEach((p) => { p.outerHTML = ''; });
    fetch(urlCheck, {
      method: "POST",
      headers: {"X-CSRF-Token": token },
      body: form2
    })
      .then(response => response.json())
      .then((data) => {
        if (data['valid']) {
          this.step2Target.classList.add("d-none")
          this.step3Target.classList.remove("d-none")
          this.bar3Target.classList.add("sb-active")
          this.numTarget.innerHTML = '3'
        } else {
          Object.keys(data['errors']).forEach(key => {
            Object.values(data['errors'][key]).forEach(value => {
              this.form2Target.querySelector(`.candidacy_${key}`).insertAdjacentHTML('beforeend', `<p class="sm-red-msg">${value}</p>`)
            });
          });

        }
      })
  }

  step2(event) {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const candidateId = this.nextTarget.dataset.candidate
    const form1 = new FormData(this.form1Target)
    const method = candidateId === 'nil' ? "POST" : "PATCH"
    const url = candidateId === 'nil' ? `/candidates/synch` : `/candidates/${candidateId}/synch`
    this.form1Target.querySelectorAll(".sm-red-msg").forEach((p) => { p.outerHTML = ''; });
    fetch(url, {
      method: method,
      headers: {"X-CSRF-Token": token },
      body: form1
    })
      .then(response => response.json())
      .then((data) => {
        if (data['valid']) {
          this.nextTarget.setAttribute("data-candidate", data["id"])
          this.step1Target.classList.add("d-none")
          this.step2Target.classList.remove("d-none")
          this.bar2Target.classList.add("sb-active")
          this.numTarget.innerHTML = '2'
          this.foremployeesTarget.classList.remove("d-none")
          if (form1.getAll("candidate[status]")[1] === 'pt_employee' || form1.getAll("candidate[status]")[1] === 'ft_employee') {
            this.foremployeesTarget.classList.remove("d-none")
          } else {
            this.foremployeesTarget.classList.add("d-none")
          }
        } else {
          Object.keys(data['errors']).forEach(key => {
            Object.values(data['errors'][key]).forEach(value => {
              this.form1Target.querySelector(`.candidate_${key}`).insertAdjacentHTML('beforeend', `<p class="sm-red-msg">${value}</p>`)
            });
          });
        }
      })
  }

  submit(event) {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const form2 = new FormData(this.form2Target)
    form2.append('consent', document.getElementById('candidacy_consent').checked)
    const urlCandidacy = this.form2Target.action
    document.getElementById('consent-error').innerHTML = ''
    fetch(urlCandidacy, {
      method: "POST",
      headers: {"X-CSRF-Token": token },
      body: form2
    })
      .then(response => response.json())
      .then((data) => {
        if (data['valid']) {
          this.step3Target.classList.add("d-none")
          this.headerTarget.classList.add("d-none")
          this.confirmationTarget.classList.remove("d-none")
        } else {
          document.getElementById('consent-error').innerHTML = data['errors']['consent'][0]
        }
      })

  }

  back1(event) {
    event.preventDefault()
    this.step2Target.classList.add("d-none")
    this.step1Target.classList.remove("d-none")
    this.bar2Target.classList.remove("sb-active")
    this.numTarget.innerHTML = '1'
  }

  back2(event) {
    event.preventDefault()
    this.step3Target.classList.add("d-none")
    this.step2Target.classList.remove("d-none")
    this.bar3Target.classList.remove("sb-active")
    this.numTarget.innerHTML = '2'
  }
}
