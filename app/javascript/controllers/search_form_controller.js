import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ['submitbtn', 'filters', 'btn', 'counter', 'form', 'select', 'list', 'card', 'preview', 'id', 'loader', 'close']

  connect() {
    addEventListener('popstate', (event) => { });
    onpopstate = (event) => {location.reload()};

    const form = new FormData(this.formTarget)
    const urlParams = new URLSearchParams(window.location.search);
    const searchParams = Array.from(urlParams.values())
    let counter = 0

    searchParams.forEach(value => {
      value !== '' ? counter += 1 : counter
    });

    urlParams.get('frequency') === '3' ? counter += -1 : counter
    urlParams.get('duration') === '3' ? counter += -1 : counter
    // urlParams.get('id') ? counter += -1 : this.cardTargets[0].dataset.active = "true"
    urlParams.get('id') ? counter += -1 : counter += 0

    if (urlParams.get('full_remote') === '1') {
      this.selectTargets[1].classList.add('readonly-input')
    }

    if (this.hasCounterTarget) {
      this.counterTarget.innerHTML = counter
      if (counter !== 0) {
        this.counterTarget.classList.remove('invisible')
      }
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
    window.history.pushState('', '', url)
    this.previewTarget.dataset.active = "false"
    this.cardTargets.forEach(card => {
      card.dataset.active = false
    });
    this.idTarget.value = ''
  }

  toggle() {
    this.filtersTarget.toggleAttribute("collapsed");
    this.btnTarget.toggleAttribute("collapsed");
  }

  update(){
    const counter = parseInt(this.listTarget.dataset.counter)
    this.counterTarget.innerHTML = counter
    counter === 0 ? this.counterTarget.classList.add('invisible') : this.counterTarget.classList.remove('invisible')

    const form = new FormData(this.formTarget)
    this.selectTargets.forEach(target => {
      target.classList.remove('pill-dropdown-selected')
      if (form.get(target.id)) {target.classList.add('pill-dropdown-selected')}
    });

    if (form.get('full_remote') === '1') {
      this.selectTargets[1].classList.add('readonly-input')
    } else {
      this.selectTargets[1].classList.remove('readonly-input')
    }

    console.log(this.previewTarget.dataset.id)
    this.setActive()
  }

  setActive(){
    const activeId = this.hasPreviewTarget ? this.previewTarget.dataset.id : null
    this.cardTargets.forEach((card) => {
      card.dataset.activeCard = card.dataset.id === activeId
    });
  }
}
