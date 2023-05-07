import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core";



// Connects to data-controller="slider"
export default class extends Controller {
  static targets = ['input', 'custom', 'output']

  connect() {
    // this.inputTargets.forEach(slider => {
    //   set(slider)
    // });
    const value = this.inputTarget.value;
    this.inputTarget.setAttribute("value", value)
    const min = this.inputTarget.min;
    const max = this.inputTarget.max;
    const progress = (value-min)/(max-min)*100
    this.inputTarget.style.background = `linear-gradient(to right, #531cb3 0%, #531cb3 ${progress}%, #FFFBFE ${progress}%, #FFFBFE 100%)`

    const custom = ['impossible ! 😩', 'pas sûr... 😟', 'je ne sais pas 😗', 'possible 🙂', "c'est sûr ! 🤩"]
    const duration = ['entre 1 et 2 mois', 'entre 3 et 6 mois', "+ de 6 mois"]
    const frequency = ['1 à 2 jours par mois', '1 jour par semaine', "+ d'1 jour par sem."]

    if (value === "0") {
      this.outputTarget.innerHTML = 'sélectionner'
    } else if (this.element.dataset.sliderType === 'standard') {
      this.outputTarget.innerHTML = value
      } else {
        this.outputTarget.innerHTML = eval(this.element.dataset.sliderType)[value - 1]
      }
  }

  update(event) {
    const value = this.inputTarget.value;
    this.inputTarget.setAttribute("value", value)
    const min = this.inputTarget.min;
    const max = this.inputTarget.max;
    const progress = (value-min)/(max-min)*100
    this.inputTarget.style.background = `linear-gradient(to right, #531cb3 0%, #531cb3 ${progress}%, #FFFBFE ${progress}%, #FFFBFE 100%)`

    const custom = ['impossible ! 😩', 'pas sûr... 😟', 'je ne sais pas 😗', 'possible 🙂', "c'est sûr ! 🤩"]
    const duration = ['entre 1 et 2 mois', 'entre 3 et 6 mois', "+ de 6 mois"]
    const frequency = ['1 à 2 jours par mois', '1 jour par semaine', "+ d'1 jour par sem."]

    if (value === "0") {
      this.outputTarget.innerHTML = 'sélectionner'
    } else if (this.element.dataset.sliderType === 'standard') {
      this.outputTarget.innerHTML = value
      } else {
        this.outputTarget.innerHTML = eval(this.element.dataset.sliderType)[value - 1]
      }
  }

}
