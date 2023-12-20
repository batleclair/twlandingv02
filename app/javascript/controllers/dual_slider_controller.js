import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dual-slider"

function toTime(num) {
  const ceil = Math.ceil(num)
  const floor = Math.floor(num)
  const prefix = num < 10 ? '0' : ''
  if (ceil === floor) {
    return prefix + num + ':00:00'
  } else {
    return prefix + floor + ':' + Math.round((num-floor)/(ceil-floor) * 60) + ':00'
  }
}

export default class extends Controller {
  static targets = ['start', 'end', 'startinput', 'endinput', 'startoutput', 'endoutput']
  static values = {
    date: String,
  }

  connect() {
    this.update()
    console.log(this.startoutputTarget)
  }

  update() {
    const min = parseInt(this.startTarget.min)
    const max = parseInt(this.startTarget.max)

    let startInput = parseFloat(this.startTarget.value)
    let endInput = parseFloat(this.endTarget.value)

    const low = startInput >= endInput ? endInput : startInput
    const high = startInput < endInput ? endInput : startInput

    const start = (low-min)/(max-min)*100
    const end = (high-min)/(max-min)*100

    this.endTarget.style.background = `linear-gradient(to right, #d4d1d9 0%, #d4d1d9 ${start}%, #531cb3 ${start}%, #531cb3 ${end}%, #d4d1d9 ${end}%, #d4d1d9 100%)`

    // const startTime = new Date(`${this.dateValue}T${toTime(low)}`)
    // const endTime = new Date(`${this.dateValue}T${toTime(high)}`)

    const startTime = `${this.dateValue}T${toTime(low)}`
    const endTime = `${this.dateValue}T${toTime(high)}`

    this.startinputTarget.value = startTime
    this.endinputTarget.value = endTime
    this.startoutputTarget.innerText = toTime(low).slice(0,5)
    this.endoutputTarget.innerText = toTime(high).slice(0,5)
  }

}
