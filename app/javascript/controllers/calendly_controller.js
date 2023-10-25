import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendly"

function updateCandidate() {
  const token = document.querySelector("[name='csrf-token']").content
  fetch("/book-call" , {
    method: "PATCH",
    headers: {
      'X-CSRF-Token': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({call_status: 'booked'})
  })
    .then(response => response.json())
    .then((data) => {
      const card = document.querySelector('[data-controller="calendly"]')
      const msg = document.getElementById('on-boarding-complete')
      card.dataset.validated = true
      card.dataset.active = false
      msg.innerHTML = data["content"]
    })
}

export default class extends Controller {
  static values = {
    email: String,
    name: String
  }

  connect() {
    function isCalendlyEvent(e) {
      return e.origin === "https://calendly.com" && e.data.event && e.data.event.indexOf("calendly.") === 0;
    };

    console.log(this.element.dataset.validated)

    window.addEventListener("message", function(e) {
      if(isCalendlyEvent(e) && e.data.event === "calendly.event_scheduled") {
        updateCandidate()
      }
    });
  }

  popup(){
    event.preventDefault()
    Calendly.initPopupWidget({
      url: 'https://calendly.com/demain-baptiste/intro',
      prefill: {
        name: this.nameValue,
        email: this.emailValue,
        }
      });
      return false;
  }

}
