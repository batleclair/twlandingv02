import { Controller } from "@hotwired/stimulus"

function randomInteger(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function spread(bubbles) {
  bubbles.forEach(bubble => {
    const rand_size = Math.random() * 5
    const rand_opacity = Math.random() * 0.3
    const rand_left = Math.round(Math.random() * 100)
    const rand_bottom = Math.round(Math.random() * 100)
    bubble.style = `transform: scale(${rand_size}); left: ${rand_left}%; bottom: ${rand_bottom}%; opacity: ${rand_opacity};`
  });
}

function move(bubbles) {
  bubbles.forEach(bubble => {
    const rand_size = Math.random() * 5
    const rand_opacity = Math.random() * 0.3
    const rand_x = randomInteger(-200, 200)
    const rand_y = randomInteger(-200, 200)
    console.log(rand_x)
    bubble.style = `left: ${bubble.style.left}; bottom: ${bubble.style.bottom}; transform: translate(${rand_x}%, ${rand_y}%) scale(${rand_size}); opacity: ${rand_opacity};`
  });
}

// Connects to data-controller="bubbles"

export default class extends Controller {
  static targets = ['bubble']

  connect() {
    spread(this.bubbleTargets)
    document.addEventListener('scroll', (event) => {});
    onscroll = (event) => {move(this.bubbleTargets)};
  }
}
