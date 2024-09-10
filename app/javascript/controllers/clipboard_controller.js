import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }
  
  copy(event) {
    const postTitle = event.currentTarget.dataset.postTitle
    this.dispatch("copy", { detail: { content: postTitle } })
    navigator.clipboard.writeText(postTitle)
  }
}
