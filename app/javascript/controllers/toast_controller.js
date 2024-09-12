import { Controller } from "@hotwired/stimulus"
import toastr from "toastr"

export default class extends Controller {
  connect() {
    toastr.options = {
      "closeButton": true,
      "progressBar": true,
      "positionClass": "toast-top-right",
      "timeOut": 5000
    }
  }

  show({ detail: { content } }) {
    const toastText = `${content} was copied!`
    toastr.success(toastText)
  }
}
