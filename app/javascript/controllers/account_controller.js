import { Controller } from "@hotwired/stimulus"

function switchTab(targets, n) {
  targets.forEach(btn => {
    btn.removeAttribute('data-active')
  });
  targets[n].setAttribute('data-active', 'savebtn')
}

// Connects to data-controller="account"
export default class extends Controller {
  static targets = ['button', 'creds', 'extras', 'form']

  connect() {
  }

  step1() {
    this.credsTarget.setAttribute('data-position', 'active')
    this.extrasTarget.setAttribute('data-position', 'right')
    switchTab(this.buttonTargets, 0)
  }

  step2() {
    if ((event.type === 'keydown' && event.key === 'Tab') || event.type === 'click') {
      event.preventDefault()
      this.credsTarget.setAttribute('data-position', 'left')
      this.extrasTarget.setAttribute('data-position', 'active')
      switchTab(this.buttonTargets, 1)
    }
  }

  save() {
    event.preventDefault()
    this.formTarget.submit()
  }
}
