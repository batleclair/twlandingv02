import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core";

// Connects to data-controller="slider"
export default class extends Controller {
  static targets = ['input', 'custom', 'output']

  connect() {
    console.log(this.customTarget.value)
    console.log(this.element.dataset.sliderType)
  }

  update(event) {
    const value = this.inputTarget.value;
    this.inputTarget.setAttribute("value", value)
    const min = this.inputTarget.min;
    const max = this.inputTarget.max;
    const progress = (value-min)/(max-min)*100
    this.inputTarget.style.background = `linear-gradient(to right, #531cb3 0%, #531cb3 ${progress}%, #FFFBFE ${progress}%, #FFFBFE 100%)`

    if (this.element.dataset.sliderType === 'custom') {
      switch (value) {
        case '1':
          this.outputTarget.innerHTML = 'impossible ! 😩';
          break;
        case '2':
          this.outputTarget.innerHTML = 'difficile 😟';
          break;
        case '3':
          this.outputTarget.innerHTML = 'incertain 😗';
          break;
        case '4':
          this.outputTarget.innerHTML = 'possible 🙂';
          break;
        case '5':
          this.outputTarget.innerHTML = 'facile ! 🤩';
          break;
        default:
          break;
        }
      } else {
        this.outputTarget.innerHTML = value
      }
  }

  // this.customTarget.innerHTML = value

    // switch (value) {
    //   case 1:
    //     this.customTarget.innerHTML = '😩';
    //     break;
    //   case 2:
    //     this.customTarget.innerHTML = '🥺';
    //     break;
    //   case 3:
    //     this.customTarget.innerHTML = '😗';
    //     break;
    //   case 4:
    //     this.customTarget.innerHTML = '🙂';
    //     break;
    //   case 5:
    //     this.customTarget.innerHTML = '🤩';
    //     break;
    //   default:
    //     break;
    // }
}
