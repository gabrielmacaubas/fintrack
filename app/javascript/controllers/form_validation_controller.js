import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-validation"
export default class extends Controller {
  static targets = ["form", "field", "submit"]
  static classes = ["valid", "invalid", "loading"]

  connect() {
    console.log("Form validation controller connected!")
    this.setupValidation()
  }

  setupValidation() {
    if (this.hasFormTarget) {
      // Add Bootstrap validation classes
      this.formTarget.classList.add("needs-validation")
      this.formTarget.setAttribute("novalidate", "")
      
      // Add event listeners for real-time validation
      this.fieldTargets.forEach(field => {
        field.addEventListener("blur", this.validateField.bind(this))
        field.addEventListener("input", this.clearFieldError.bind(this))
      })

      // Handle form submission
      this.formTarget.addEventListener("submit", this.handleSubmit.bind(this))
    }
  }

  validateField(event) {
    const field = event.target
    const isValid = field.checkValidity()
    
    if (isValid) {
      this.markFieldAsValid(field)
    } else {
      this.markFieldAsInvalid(field)
    }
    
    this.updateSubmitButton()
  }

  clearFieldError(event) {
    const field = event.target
    field.classList.remove("is-invalid")
    
    // Clear custom error message if exists
    const errorDiv = field.parentNode.querySelector(".invalid-feedback")
    if (errorDiv && errorDiv.dataset.customError) {
      errorDiv.style.display = "none"
    }
  }

  markFieldAsValid(field) {
    field.classList.remove("is-invalid")
    field.classList.add("is-valid")
  }

  markFieldAsInvalid(field) {
    field.classList.remove("is-valid")
    field.classList.add("is-invalid")
  }

  handleSubmit(event) {
    const form = event.target
    
    if (!form.checkValidity()) {
      event.preventDefault()
      event.stopPropagation()
      this.showValidationErrors()
    } else {
      this.showLoading()
    }
    
    form.classList.add("was-validated")
  }

  showValidationErrors() {
    // Focus on first invalid field
    const firstInvalidField = this.formTarget.querySelector(":invalid")
    if (firstInvalidField) {
      firstInvalidField.focus()
      firstInvalidField.scrollIntoView({ behavior: "smooth", block: "center" })
    }
    
    // Mark all invalid fields
    this.fieldTargets.forEach(field => {
      if (!field.checkValidity()) {
        this.markFieldAsInvalid(field)
      }
    })
  }

  showLoading() {
    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = true
      
      // Add loading text/spinner
      const originalText = this.submitTarget.textContent
      this.submitTarget.dataset.originalText = originalText
      this.submitTarget.innerHTML = `
        <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
        Enviando...
      `
      
      if (this.hasLoadingClass) {
        this.submitTarget.classList.add(this.loadingClass)
      }
    }
  }

  updateSubmitButton() {
    if (!this.hasSubmitTarget) return
    
    const allValid = this.fieldTargets.every(field => field.checkValidity())
    
    if (allValid) {
      this.submitTarget.disabled = false
      if (this.hasValidClass) {
        this.submitTarget.classList.add(this.validClass)
        this.submitTarget.classList.remove(this.invalidClass)
      }
    } else {
      if (this.hasInvalidClass) {
        this.submitTarget.classList.remove(this.validClass)
        this.submitTarget.classList.add(this.invalidClass)
      }
    }
  }

  // Custom validation methods
  validateEmail(event) {
    const field = event.target
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    
    if (field.value && !emailRegex.test(field.value)) {
      this.setCustomError(field, "Por favor, insira um email válido")
    }
  }

  validateCurrency(event) {
    const field = event.target
    const value = parseFloat(field.value)
    
    if (field.value && (isNaN(value) || value <= 0)) {
      this.setCustomError(field, "O valor deve ser maior que zero")
    }
  }

  setCustomError(field, message) {
    field.setCustomValidity(message)
    
    // Create or update custom error message
    let errorDiv = field.parentNode.querySelector(".invalid-feedback")
    if (!errorDiv) {
      errorDiv = document.createElement("div")
      errorDiv.className = "invalid-feedback"
      field.parentNode.appendChild(errorDiv)
    }
    
    errorDiv.textContent = message
    errorDiv.dataset.customError = "true"
    errorDiv.style.display = "block"
    
    this.markFieldAsInvalid(field)
  }

  // Action to reset form
  reset() {
    if (this.hasFormTarget) {
      this.formTarget.reset()
      this.formTarget.classList.remove("was-validated")
      
      // Clear all validation classes
      this.fieldTargets.forEach(field => {
        field.classList.remove("is-valid", "is-invalid")
        field.setCustomValidity("")
      })
      
      // Reset submit button
      if (this.hasSubmitTarget) {
        this.submitTarget.disabled = false
        if (this.submitTarget.dataset.originalText) {
          this.submitTarget.textContent = this.submitTarget.dataset.originalText
        }
        this.submitTarget.classList.remove(this.loadingClass, this.validClass, this.invalidClass)
      }
    }
  }
}
