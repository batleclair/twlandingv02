import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ['icon', 'nav']

  connect() {

  }

  toggle(event) {
    this.navTarget.classList.toggle("menu-expand");
    this.iconTarget.classList.toggle("main-color");
  }

  // scroll(event) {
  //   console.log(event.currentTarget.dataset.name)
  //   const target = document.querySelector(`.${event.currentTarget.dataset.name}`)
  //   const position = target.getBoundingClientRect()
  //   console.log(position)
  //   window.scrollTo({
  //     top: position.y + position.height,
  //     behavior: 'smooth'
  //   });
  // }
}
