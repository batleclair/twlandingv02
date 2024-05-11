import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dot-path"
export default class extends Controller {
  static targets = ['ctn', 'path', 'dot']

  connect() {
    this.draw()
    const elements = this.dotTargets
    elements.push(this.pathTarget)
    this.onVisible(this.pathTarget, this.play, elements)
  }

  draw() {
    const w = this.ctnTarget.offsetWidth
    const r = w/400
    const path = `M 5 26 C ${r*31} 26 ${r*57} 52 ${r*83} 26 C ${r*109} 0 ${r*135} 0 ${r*161} 26 C ${r*187} 52 ${r*213} 52 ${r*239} 26 S ${r*291} 0 ${r*317} 26 S ${r*369} 26 ${r*395} 26`
    this.pathTarget.setAttribute('d', path)
    this.dotTargets.forEach(dot => {
      dot.style.offsetPath = `path('${path}')`
    });
  }

  onVisible(target, action, elements) {
    new IntersectionObserver((entries, observer) => {
        entries.forEach((entry) => {
          if(entry.intersectionRatio > 0) {
            action(elements);
            observer.disconnect();
          };
        })
      }
    ).observe(target)
  }

  play(elements){
    elements.forEach(element => {
      element.style.animationPlayState = "running"
    });
  }
}
