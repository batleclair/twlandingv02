import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
let counter = 0

export default class extends Controller {
  static targets = ['card', 'prev', 'next', 'container']

  connect() {
  }

  right() {
    const cards = this.cardTargets.length
    const box = this.containerTarget.offsetWidth
    const maxclicks = cards - Math.floor(box / 300)
    const stub = maxclicks * 300 - box % 300 - 20
    if (counter < maxclicks - 1) {
      this.cardTargets.forEach(card => {
        card.style.transform = `translateX(${-300 * (counter + 1)}px)`;
      });
      counter += 1
    } else if (counter === maxclicks - 1) {
      this.cardTargets.forEach(card => {
        card.style.transform = `translateX(${ - stub }px)`;
      });
      counter += 1
    }
  }

  left() {
    const cards = this.cardTargets.length
    const maxclicks = cards - Math.floor(this.containerTarget.offsetWidth / 300)
    if (counter > 1) {
      this.cardTargets.forEach(card => {
        card.style.transform = `translateX(${-300 * (counter -1)}px)`;
      });
      counter -= 1
    } else if (counter === 1) {
      this.cardTargets.forEach(card => {
        card.style.transform = '';
      });
      counter -= 1
    }

  }
}
