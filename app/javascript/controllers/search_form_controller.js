import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ['submitbtn', 'filters', 'btn', 'counter', 'form', 'select', 'indication', 'card', 'preview', 'id', 'loader', 'close', 'slider']

  connect() {
    addEventListener('popstate', (event) => { });
    onpopstate = (event) => {location.reload()};

    const form = new FormData(this.formTarget)
    const urlParams = new URLSearchParams(window.location.search);
    const searchParams = Array.from(urlParams.values())
    let counter = 0
    console.log(searchParams)

    searchParams.forEach(value => {
      value !== '' ? counter += 1 : counter
    });

    urlParams.get('frequency') === '3' ? counter += -1 : counter
    urlParams.get('duration') === '3' ? counter += -1 : counter
    console.log(urlParams.get('id'))
    urlParams.get('id') ? counter += -1 : this.cardTargets[0].dataset.active = "true"

    if (urlParams.get('remote_work') === '1') {
      this.selectTargets[1].classList.add('readonly-input')
    }

    this.counterTarget.innerHTML = counter
    if (counter !== 0) {
      this.counterTarget.classList.remove('invisible')
    }

    this.selectTargets.forEach(target => {
      target.classList.remove('pill-dropdown-selected')
      if (form.get(target.id)) {target.classList.add('pill-dropdown-selected')}
    });
  }

  result() {
    this.submitbtnTarget.click()
  }

  showup() {
    const y = this.element.getBoundingClientRect().top + window.scrollY;
    console.log(y)
    window.scroll({
      top: y - 35,
      behavior: 'smooth'
    });
  }

  preview() {
    event.preventDefault()
    if (event.target.dataset.active === "true") {
      if (event.target.dataset.destination !== '') {
        window.location = event.target.dataset.destination
      }
    } else {
      this.loaderTargets.forEach(loader => {
        loader.style = ""
      })
      this.cardTargets.forEach(card => {
        card.dataset.active = false
      });
      event.target.dataset.active = true
      const url = event.target.href
      window.history.pushState('', '', url)
      this.idTarget.value = event.target.dataset.id
      const urlPreview = `../offers/${event.target.dataset.id}/preview/?search=${window.location.search}`
      console.log(event.target)
      console.log(event.target.dataset.id)
      fetch(urlPreview, {
      })
        .then(response => response.json())
        .then((data) => {
          this.previewTarget.innerHTML = data.content
          this.previewTarget.dataset.active = "true"
          this.loaderTargets.forEach(loader => {
            loader.style = "display: none;"
          })
        })
    }
  }

  close() {
    event.preventDefault()
    const url = this.closeTarget.href
    console.log(url)
    window.history.pushState('', '', url)
    this.previewTarget.dataset.active = "false"
    this.cardTargets.forEach(card => {
      card.dataset.active = false
    });
    this.idTarget.value = ''
  }
}
