import { Controller } from "@hotwired/stimulus"
import toastr from "toastr"

export default class extends Controller {
  static targets = [ "toast" ]

  connect() {
    toastr.options = {
      "closeButton": true,
      "progressBar": true,
      "positioinClass": "toast-top-right",
      "timeout": "5000"
    }
  }

  show({ detail: { content } }) {
    const toastText = `${content} was copied!`
    toastr.success(toastText)
  }
}
