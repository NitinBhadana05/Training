import "@hotwired/turbo-rails"

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("form[data-auto-search]").forEach((form) => {
    const input = form.querySelector("[data-auto-search-input]")
    if (!input || input.dataset.autoSearchReady === "true") return

    input.dataset.autoSearchReady = "true"
    let timer

    input.addEventListener("input", () => {
      clearTimeout(timer)
      timer = setTimeout(() => form.requestSubmit(), 250)
    })
  })
})
