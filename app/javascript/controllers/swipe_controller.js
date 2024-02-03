import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="swipe"
export default class extends Controller {
  static targets = ['ctn', 'card', 'dot']

  connect() {
    let touchstartX = null
    let touchendX = null
    let active = 1
    const cards = this.cardTargets
    const cardCount = cards.length
    const cardSize = cards[0].offsetWidth
    const ctnSize = this.ctnTarget.offsetWidth
    const firstActiveCard = parseInt(this.ctnTarget.dataset.focus, 10)
    const stub = cardCount * cardSize + cardCount * 10 - ctnSize
    const dots = this.dotTargets

    function adjust(cards, dots) {
      dots.forEach(dot => {
        dot.dataset.active="false"
      });
      cards.forEach(card => {
       for (let i = 0; i < cardCount ; i++) {
        if (active === i) {
          card.style.transform = `translateX(${Math.max(cardSize*firstActiveCard - i*cardSize, 0 - stub)}px)`
          if (dots[i]) {dots[i].dataset.active="true"}
        }
       }
     });
    }

    function reset(cards) {
      cards.forEach(card => {
        card.dataset.status = ""
      });
    }

    this.ctnTarget.addEventListener('touchstart', e => {
      touchstartX = e.changedTouches[0].screenX
    })

    this.ctnTarget.addEventListener('touchend', e => {
      touchendX = e.changedTouches[0].screenX
      if (window.matchMedia("(max-width: 800px)").matches) {
        if (touchendX < touchstartX) {
          reset(cards)
          active = Math.min(active + 1, cardCount - 1)
          this.cardTargets[active].dataset.status = "active"
          adjust(cards, dots)
        }
        if (touchendX > touchstartX) {
          reset(cards)
          active = Math.max(active - 1, 0)
          this.cardTargets[active].dataset.status = "active"
          adjust(cards, dots)
        }
      }
      touchendX = null
      touchendX = null
    })
  }

  refocus(event) {
    if (window.matchMedia("(max-width: 800px)").matches) {
      event.preventDefault()
      let active = null
      const cardCount = this.cardTargets.length
      const cardSize = this.cardTarget.offsetWidth
      const ctnSize = this.ctnTarget.offsetWidth
      const firstActiveCard = parseInt(this.ctnTarget.dataset.focus, 10)
      const stub = cardCount * cardSize + cardCount * 10 - ctnSize

      this.cardTargets.forEach(function callback(card, index) {
        card.dataset.status = ""
        if (event.target === card) {
          card.dataset.status = "active"
          active = index
        }
      });

      this.cardTargets.forEach(card => {
        for (let i = 0; i < cardCount ; i++) {
          if (active === i) card.style.transform = `translateX(${Math.max(cardSize*firstActiveCard - i*cardSize, 0 - stub)}px)`
        }
      });
    }
  }

  keep(event) {
    event.stopImmediatePropagation()
  }
}
