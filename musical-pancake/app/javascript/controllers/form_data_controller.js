import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-data"
export default class extends Controller {
  static targets = ["streetSelector"]

  setStreetData(e) {
    let newOpts = e.map(
      (e) => {
        let el = document.createElement('option')
        el['value'] = e.street
        el.text     = e.street
        console.log(e)
        //`<option value="${e.postal_code}">${e.street}</option>`
        return el
      }
    )
    let streetSel = document.getElementById('street-selector');
    streetSel.replaceChildren(...newOpts)
    //this.citySelectTarget.append(newOpts)
  }

  setCityData(e) {
    let newOpts = e.map(
      (e) => {
        let el = document.createElement('option')
        el['value'] = e.city
        el.text = `${e.city.slice(0, 1)}${e.city.toLowerCase().slice(1)}`
        return el
      }
    )
    console.log(newOpts)
    document.getElementById('city-select').replaceChildren(...newOpts)
  }

  setNumbersData(e) {
    let newOpts = e.map(
      (e) => {
        let el = document.createElement('option')
        el['value'] = e.number
        el.text = e.number
        return el
      }
    )
    //console.log('setNumbersData',e)
    //console.log(newOpts)
    document.getElementById('number-selector').replaceChildren(...newOpts)
  }

  citySelectHandler(e) {
    let cityNameUpperCase = e.target.value
    console.log(`citySelectHandler, ${cityNameUpperCase}!`)

    // Lookup Streets associated with the City selected and
    // set them to the Streets selector
    fetch(`/cities/${cityNameUpperCase}/streets/`)
      .then((response) => response.json())
      .then((data) => this.setStreetData(data));
  }

  streetSelectHandler(e) {
    let streetNameUpperCase = e.target.value
    console.log(`streetSelectHandler, ${streetNameUpperCase}!`)

    // Lookup Numbers associated with the Street selected and
    // set them to the Numbers selector
    /// streets/ALE%20WEE/numbers/
    fetch(`/streets/${encodeURIComponent(streetNameUpperCase)}/numbers/`)
      .then((response) => response.json())
      .then((data) => this.setNumbersData(data));
  }

  postalCodeHandler(e) {
    let postalCode = e.target.value
    if(postalCode.length >= 3) {
      console.log(`postalCodeHandler, ${postalCode}!`)

    // Lookup Cities associated with the Postal Code entered (min 3 length)
    // set them to the City selector
      fetch(`/postal-codes/${postalCode}/cities/`)
        .then((response) => response.json())
        .then((data) => this.setCityData(data));
        //.then((response) => console.log(response.body))

    }
  }
}
