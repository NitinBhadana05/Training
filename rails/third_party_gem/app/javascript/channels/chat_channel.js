import consumer from "channels/consumer"

consumer.subscriptions.create("ChatChannel", {

  connected() {
    console.log("Connected to ChatChannel")
  },

  

  received(data) {
    const messages = document.getElementById("messages")

    if (messages) {
      messages.insertAdjacentHTML("beforeend", `<p>${data.message}</p>`)
    }
  }

});