import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ['submitbtn', 'filters', 'btn', 'counter', 'form', 'select', 'indication', 'card', 'preview', 'id', 'loader']

  connect() {
    addEventListener('popstate', (event) => { });
    onpopstate = (event) => {location.reload()};
    let counter = -1
    const form = new FormData(this.formTarget)
    form.get('function') ? counter += 0 : counter += -1
    for (var key of form.keys()) {counter += 1}
    this.counterTarget.innerHTML = counter
    this.counterTarget.classList.remove('d-none')
    if (counter === 0) {
      this.counterTarget.classList.add('d-none')
    }
    counter === 0 ? this.counterTarget.innerHTML = '' : this.counterTarget.innerHTML = counter
    this.selectTarget.classList.remove('pill-dropdown-selected')
    if (form.get('function')) {this.selectTarget.classList.add('pill-dropdown-selected')}
  }

  result() {
    this.submitbtnTarget.click()
  }

  toggle() {
    this.filtersTarget.classList.toggle('filters-expand')
    this.btnTarget.classList.toggle('filter-icon-active')
    this.indicationTargets.forEach(indication => {
      indication.classList.toggle('d-none')
    });
  }

  preview() {
    event.preventDefault()
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

  close() {
    event.preventDefault()
    this.previewTarget.dataset.active = "false"
  }
}
