import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template"]

  add() {
    const template = this.templateTarget.content.cloneNode(true)
    const parts = template.children[0].id.split("-")
    const newId = parts[0] + "-" +
      parts[1] + "-" +
      (this.listTarget.children.length + 1)
    template.children[0].id = newId
    const button = template.children[0].querySelector("button")
    button.setAttribute("data-bs-target", "#" + newId)
    this.listTarget.appendChild(template)
  }

  remove(event) {
    const target = event.currentTarget.getAttribute("data-bs-target")
    if (!target) return

    const li = this.listTarget.querySelector(target)
    if (!li) return

    const hidden = li.querySelector(".ov-hidden-destroy")
    const idField = li.querySelector('input[name$="[id]"]')

    if (idField?.value) {
      hidden?.removeAttribute("disabled")
    } else {
      li.remove()
    }
  }
}
