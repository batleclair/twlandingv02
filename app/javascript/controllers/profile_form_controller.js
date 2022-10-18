import { Controller } from "@hotwired/stimulus"

function switchTab(targets, n) {
  targets.forEach(btn => {
    btn.removeAttribute('data-active')
  });
  targets[n].setAttribute('data-active', '')
}

// Connects to data-controller="profile-form"
export default class extends Controller {
  static targets = ['basics', 'skills', 'wishes', 'button', 'form', 'picinput', 'picactual', 'picpreview', 'company', 'loader', 'save', 'cv', 'cvmsg']

  connect() {
  }

  step1() {
    this.basicsTarget.setAttribute('data-position', 'active')
    this.skillsTarget.setAttribute('data-position', 'right')
    this.wishesTarget.setAttribute('data-position', 'right')
    switchTab(this.buttonTargets, 0)
  }

  step2() {
    if ((event.type === 'keydown' && event.key === 'Tab') || event.type === 'click') {
      event.preventDefault()
      if (this.basicsTarget.dataset.position === "active") {
        this.basicsTarget.setAttribute('data-position', 'left')
      } else if (this.wishesTarget.dataset.position === "active") {
        this.wishesTarget.setAttribute('data-position', 'right')
      }
      this.skillsTarget.setAttribute('data-position', 'active')
      switchTab(this.buttonTargets, 1)
    }
  }

  step3() {
    if ((event.type === 'keydown' && event.key === 'Tab') || event.type === 'click') {
      event.preventDefault()
      this.basicsTarget.setAttribute('data-position', 'left')
      this.skillsTarget.setAttribute('data-position', 'left')
      this.wishesTarget.setAttribute('data-position', 'active')
      switchTab(this.buttonTargets, 2)
    }
  }

  save() {
    this.saveTarget.classList.add('d-none')
    this.loaderTarget.classList.remove('d-none')
    const token = document.querySelector("[name='csrf-token']").content
    const form = new FormData(this.formTarget)
    this.formTarget.querySelectorAll(".sm-red-msg").forEach((p) => { p.outerHTML = ''; });
    this.formTarget.querySelectorAll(".notice").forEach((p) => { p.outerHTML = ''; });
    fetch(`${this.formTarget.action}/synch`, {
      method: 'PATCH',
      headers: {"X-CSRF-Token": token },
      body: form
    })
      .then(response => response.json())
      .then((data) => {
        this.saveTarget.classList.remove('d-none')
        this.loaderTarget.classList.add('d-none')
        if (data['valid']) {
          this.formTarget.insertAdjacentHTML('beforeend', '<p class="notice">👍 tes changements ont été enregistrés !</p>')
        } else {
          Object.keys(data['errors']).forEach(key => {
            Object.values(data['errors'][key]).forEach(value => {
              this.formTarget.querySelector(`.candidate_${key}`).insertAdjacentHTML('beforeend', `<p class="sm-red-msg">${value}</p>`)
            });
          });
        }
      })
  }

  // change() {
  //   console.log('changeform')
  //   this.saveTarget.classList.remove("d-none")
  // }

  preview() {
    if (this.picinputTarget.files && this.picinputTarget.files[0]) {
      const reader = new FileReader()
      reader.onload = (event) => {
        this.picpreviewTarget.src = event.currentTarget.result
      }
      reader.readAsDataURL(this.picinputTarget.files[0])
      this.picpreviewTarget.classList.remove('d-none')
      this.picactualTarget.classList.add('d-none')
    }
  }

  cv() {
    if (this.cvTarget.files && this.cvTarget.files[0]) {
      this.cvmsgTarget.innerHTML = this.cvTarget.value.replace('fakepath', '...')
    }
  }

  hide() {
    this.companyTarget.classList.remove('d-none')
    if (event.currentTarget.value === 'freelance' || event.currentTarget.value === 'inactive') {
      this.companyTarget.classList.add('d-none')
    }
  }
}
