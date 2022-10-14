import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

// Connects to data-controller="tom-select"
export default class extends Controller {
  connect() {
    new TomSelect(this.element,{
      persist: false,
      createOnBlur: true,
      create: true,
      render:{
        option_create: function( data, escape ){
          return '<div class="create">Ajouter <strong>' + escape(data.input) + '</strong>&hellip;</div>';
        },
        no_results: function( data, escape ){
          return '<div class="no-results">Aucun résultat trouvé</div>';
        },
      }
    })
  }
}
