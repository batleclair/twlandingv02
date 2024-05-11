import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-carousel"
export default class extends Controller {
  static targets = ['btn', 'slider', 'slide']

  connect() {
  }

  update() {
    this.btnTargets.forEach(btn => {
      btn.removeAttribute("btn-active")
    });
    this.slideTargets.forEach(slide => {
      slide.removeAttribute("card-active")
    });

    const slide = this.slideTargets.find((slide) => slide.dataset.anchor === event.target.dataset.anchor)
    const btn = this.btnTargets.find((btn) => btn.dataset.anchor === event.target.dataset.anchor)

    slide.setAttribute("card-active", "")
    btn.setAttribute("btn-active", "")

    const padding = window.getComputedStyle(this.sliderTarget, null).getPropertyValue('padding-left')
    this.sliderTarget.scroll({left: slide.offsetLeft - parseInt(padding, 10), behaviour: "smooth"})
  }
}
