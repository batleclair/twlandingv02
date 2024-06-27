import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gtm"
export default class extends Controller {
  connect() {
    // this.pageView()
  }

  formSend() {
    dataLayer.push({
      event: 'formSend',
      page: {
        url: window.location.href,
        title: document.title
      }
    });
  }

  pageView(){
    document.addEventListener("turbo:load", () => {
      dataLayer.push({
        event: 'pageView',
        page: {
          url: window.location.href,
          title: document.title
        }
      });
    });
  }
}
