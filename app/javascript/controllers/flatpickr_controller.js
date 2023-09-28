import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
import { French } from "flatpickr/dist/l10n/fr.js"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = [ "date" ]

  connect() {
    this.dateTargets.forEach(date => {
      flatpickr(date, {
        mindate: "today",
        dateFormat: "d/m/Y",
        "disable": [
          function(date) {
            return (date.getDay() === 0 || date.getDay() === 6);
          }
        ],
        "locale": French
      })
    });
  }
}
