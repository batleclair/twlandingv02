import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ['icon', 'tab1', 'tab2', 'tab3']

  connect() {

  }

  toggle(event) {
    this.element.classList.toggle("menu-expand");
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
