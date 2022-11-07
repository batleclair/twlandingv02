import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
let counter = 0

export default class extends Controller {
  static targets = ['card', 'prev', 'next', 'container']

  connect() {
  }

  slide() {
    const cards = this.cardTargets.length
    const maxclicks = cards - Math.floor(this.containerTarget.offsetWidth / 300)
    if (event.currentTarget === this.nextTarget && counter < maxclicks) {
      this.cardTargets.forEach(card => {
        card.style.transform = `translateX(${-300 * (counter + 1)}px)`;
      });
      counter += 1
    } else if (event.currentTarget === this.prevTarget && counter > 0) {
      this.cardTargets.forEach(card => {
        card.style.transform = `translateX(${-300 * (counter -1)}px)`;
      });
      counter -= 1

    }
  }
}
