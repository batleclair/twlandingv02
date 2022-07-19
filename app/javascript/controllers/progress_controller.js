import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress"
export default class extends Controller {
  static targets = ['bar1', 'bar2', 'bar3', 'step1', 'step2', 'step3', 'next', 'form1', 'form2', 'header', 'num', 'confirmation']

  connect() {
    console.log(this.step1Target)
  }

  step2(event) {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const candidateId = this.nextTarget.dataset.candidate
    if (candidateId === 'nil') {
      const url = `/candidates`
      fetch(url, {
        method: "POST",
        headers: {"Content-Type": "application/json", "X-CSRF-Token": token },
        body: ''
      })
        .then(response => response.json())
        .then((data) => {
          this.nextTarget.setAttribute("data-candidate", data["id"])
        })
    }
    this.step1Target.classList.add("d-none")
    this.step2Target.classList.remove("d-none")
    this.bar2Target.classList.add("sb-active")
    this.numTarget.innerHTML = '2'
  }

  step3(event) {
    event.preventDefault()
    this.step2Target.classList.add("d-none")
    this.step3Target.classList.remove("d-none")
    this.bar3Target.classList.add("sb-active")
    this.numTarget.innerHTML = '3'
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

  submit(event) {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content

    const candidateId = this.nextTarget.dataset.candidate
    const form = new FormData(this.form2Target)
    const urlCandidate = `/candidates/${candidateId}`
      fetch(urlCandidate, {
        method: "PATCH",
        headers: {"X-CSRF-Token": token },
        body: form
      })
        .then(response => response.json())
        .then((data) => {
          console.log(data)
        })

    const body = JSON.stringify({
      employer_name: document.getElementById('candidacy_employer_name').value,
      employer_aware: document.getElementById('candidacy_employer_aware').checked,
      employer_ok_chance: document.getElementById('candidacy_employer_ok_chance').value,
      half_days_wish: document.getElementById('candidacy_half_days_wish').value,
      // start_date_wish: document.getElementById('candidacy_start_date_wish').value,
      motivation_msg: document.getElementById('candidacy_motivation_msg').value,
      consent: document.getElementById('candidacy_consent').checked,
    })

    const urlCandidacy = this.form1Target.action
    fetch(urlCandidacy, {
      method: "POST",
      headers: {"Content-Type": "application/json", "X-CSRF-Token": token },
      body: body
    })
      .then(response => response.json())
      .then((data) => {
        console.log(data)
      })

    this.step3Target.classList.add("d-none")
    this.headerTarget.classList.add("d-none")
    this.confirmationTarget.classList.remove("d-none")
  }
}
