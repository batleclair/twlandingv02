import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ['submitbtn', 'filters', 'btn', 'counter', 'form', 'select', 'indication']
  connect() {
  }

  result() {
    this.submitbtnTarget.click()
    let counter = 0
    const form = new FormData(this.formTarget)
    form.get('function') ? counter = 0 : counter = -1
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

  toggle() {
    this.filtersTarget.classList.toggle('filters-expand')
    this.btnTarget.classList.toggle('filter-icon-active')
    this.indicationTargets.forEach(indication => {
      indication.classList.toggle('d-none')
    });
  }
}
