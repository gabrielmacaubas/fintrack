import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("Search controller connected!")
  }

  perform() {
    const query = this.inputTarget.value
    console.log("Searching for:", query)
    // Aqui você faria a requisição assíncrona para o backend
    // Ex: fetch(`/incomes?query=${query}`).then(response => response.text()).then(html => {
    //   this.resultsTarget.innerHTML = html
    // })
  }
}
