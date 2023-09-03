import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

// Connects to data-controller="typed-js"
export default class extends Controller {
  connect() {
    new Typed(this.element, {
      strings: ["Marketing / Com'", "Finance / Gestion", "RH / Juridique", "IT / Web / Data", "Achats / Logistique"],
      typeSpeed: 50,
      loop: true
    })
  }
}
