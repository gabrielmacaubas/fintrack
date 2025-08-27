import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "results", "loading", "clearButton"]
  static values = { 
    url: String,
    debounceDelay: { type: Number, default: 300 },
    minLength: { type: Number, default: 2 }
  }

  connect() {
    console.log("Search controller connected!")
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  // Handle input changes with debounce
  search() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    const query = this.inputTarget.value.trim()
    
    // Clear results if query is too short
    if (query.length < this.minLengthValue) {
      this.clearResults()
      return
    }

    // Show loading state
    this.showLoading()

    // Debounce the search
    this.timeout = setTimeout(() => {
      this.performSearch(query)
    }, this.debounceDelayValue)
  }

  // Clear search input and results
  clear() {
    this.inputTarget.value = ""
    this.clearResults()
    this.inputTarget.focus()
  }

  // Handle form submission
  submit(event) {
    event.preventDefault()
    const query = this.inputTarget.value.trim()
    
    if (query.length >= this.minLengthValue) {
      this.performSearch(query)
    }
  }

  // Private methods
  async performSearch(query) {
    try {
      if (!this.hasUrlValue) {
        console.warn("Search URL not configured")
        return
      }

      const url = new URL(this.urlValue, window.location.origin)
      url.searchParams.set('query', query)

      const response = await fetch(url, {
        headers: {
          'Accept': 'text/html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (response.ok) {
        const html = await response.text()
        this.updateResults(html)
      } else {
        this.showError('Erro na busca. Tente novamente.')
      }
    } catch (error) {
      console.error('Search error:', error)
      this.showError('Erro na busca. Verifique sua conexão.')
    } finally {
      this.hideLoading()
    }
  }

  showLoading() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.style.display = "block"
    }
  }

  hideLoading() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.style.display = "none"
    }
  }

  updateResults(html) {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = html
    }
  }

  clearResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = ""
    }
    this.hideLoading()
  }

  showError(message) {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = `
        <div class="alert alert-danger" role="alert">
          <i class="bi bi-exclamation-triangle me-2"></i>
          ${message}
        </div>
      `
    }
  }
}
