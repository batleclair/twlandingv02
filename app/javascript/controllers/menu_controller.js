import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ['icon', 'nav', 'window', 'close', 'form']

  connect() {
  }

  toggle(event) {
    this.navTarget.classList.toggle("menu-expand");
    this.iconTarget.classList.toggle("text-main");
    this.iconTarget.classList.toggle("bg-white");
  }

  popup(event) {
    event.preventDefault()
    this.windowTarget.style.display = "block"
  }

  save() {
    event.preventDefault()
    const token = document.querySelector("[name='csrf-token']").content
    const form = new FormData(this.formTarget)
    this.formTarget.querySelectorAll(".sm-red-msg").forEach((p) => { p.outerHTML = ''; });
    this.formTarget.querySelectorAll(".notice").forEach((p) => { p.outerHTML = ''; });

    fetch(`${this.formTarget.action}/synch_min`, {
      method: this.formTarget.method,
      headers: {"X-CSRF-Token": token },
      body: form
    })
      .then(response => response.json())
      .then((data) => {
        console.log(data)
        if (data.valid) {
          document.querySelector('body').insertAdjacentHTML('beforeend', '<p class="notice">👍 tes changements ont été enregistrés !</p>')
          window.location.href = this.formTarget.action
        } else {
          Object.entries(data['errors']).forEach(pair => {
            this.formTarget.querySelector(`.candidate_${pair[0]}`).insertAdjacentHTML('beforeend', `<p class="sm-red-msg">${pair[1]}</p>`)
          });
        }
      })
  }

  // scroll(event) {
  //   console.log(event.currentTarget.dataset.name)
  //   const target = document.querySelector(`.${event.currentTarget.dataset.name}`)
  //   const position = target.getBoundingClientRect()
  //   console.log(position)
  //   window.scrollTo({
  //     top: position.y + position.height,
  //     behavior: 'smooth'
  //   });
  // }
}
