import { Controller } from "@hotwired/stimulus"

function set(inputs, bar) {
  let active = -1
  let x = 0
  inputs.forEach(input => {
    input.classList.remove('lit-radio-btn')
    if (input.checked) {
      const width = Math.round(x / (inputs.length - 1) * 100)
      bar.style = `width: ${width}%;`
      active = x
    }
    x += 1
  });

  if (active > -1) {
    let y = 0;
    do {
      inputs[y].classList.add('lit-radio-btn');
      y += 1;
    } while (y <= active);
  }
}

// Connects to data-controller="radio"

export default class extends Controller {
  static targets = ['bar', 'input', 'label']

  connect() {
    set(this.inputTargets, this.barTarget)
  }

  update(event) {
    set(this.inputTargets, this.barTarget)
  }
}
