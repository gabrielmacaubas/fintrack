import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["form", "input", "select", "clearButton"]
  static values = { 
    autoSubmit: { type: Boolean, default: true },
    debounceDelay: { type: Number, default: 500 }
  }

  connect() {
    console.log("Filter controller connected!")
    this.timeout = null
    this.updateClearButtonState()
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  // Auto-submit form when input changes (with debounce for text fields)
  inputChanged(event) {
    if (!this.autoSubmitValue) return

    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    // Use debounce for text inputs, immediate for selects/dates
    const delay = event.target.type === "text" ? this.debounceDelayValue : 0
    
    this.timeout = setTimeout(() => {
      this.submitForm()
    }, delay)
  }

  // Immediate submit for select/date changes
  selectChanged() {
    if (this.autoSubmitValue) {
      this.submitForm()
    }
  }

  // Manual submit
  submit(event) {
    event.preventDefault()
    this.submitForm()
  }

  // Clear all filters
  clear(event) {
    event.preventDefault()
    
    // Clear all form inputs
    this.inputTargets.forEach(input => {
      input.value = ""
    })

    this.selectTargets.forEach(select => {
      select.selectedIndex = 0
    })

    // Submit the cleared form
    this.submitForm()
  }

  // Private methods
  submitForm() {
    this.updateClearButtonState()
    this.formTarget.requestSubmit()
  }

  updateClearButtonState() {
    if (!this.hasClearButtonTarget) return

    const hasValues = this.hasFilterValues()
    this.clearButtonTarget.style.display = hasValues ? "inline-block" : "none"
  }

  hasFilterValues() {
    // Check if any input has a value
    const hasInputValue = this.inputTargets.some(input => input.value.trim() !== "")
    
    // Check if any select has a non-default value
    const hasSelectValue = this.selectTargets.some(select => 
      select.selectedIndex > 0 && select.value !== ""
    )

    return hasInputValue || hasSelectValue
  }
}
