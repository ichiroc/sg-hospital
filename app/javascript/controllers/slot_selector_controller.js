import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slot"]

  select(event) {
    this.slotTargets.forEach(slot => {
      slot.classList.remove("ring-2", "ring-blue-500")
    })
    event.currentTarget.classList.add("ring-2", "ring-blue-500")
  }
}
