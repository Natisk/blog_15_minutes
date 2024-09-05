import { Controller } from "@hotwired/stimulus"
import { debounce } from "../utils/debounce";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["title", "body"];

  connect() {
    this.posts = debounce(this.posts.bind(this), 500);
  }

  posts(event) {
    const searchTerm = event.target.value.trim().toLowerCase();

    this.titleTargets.forEach((title, index) => {
      const postTitle = title.textContent.toLowerCase();
      const parentDiv = title.closest(".post_wrapper");
      const postBody = this.bodyTargets[index].textContent.toLowerCase();

      if (this.includesSearchTerm(postTitle, postBody, searchTerm)) {
        this.showElement(parentDiv);
      } else {
        this.hideElement(parentDiv);
      }
    });
  }

  includesSearchTerm(title, body, searchTerm) {
    return title.includes(searchTerm) || body.includes(searchTerm);
  }

  showElement(element) {
    element.classList.remove("hidden")
  }

  hideElement(element) {
    element.classList.add("hidden")
  }
}
