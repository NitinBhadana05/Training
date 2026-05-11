import { Server } from "socket.io"

let io: Server

export function initSocket(server: any) {

  io = new Server(server, {
    cors: {
      origin: "*",
    },
  })

  io.on("connection", (socket) => {

    console.log(
      "User connected:",
      socket.id
    )

    socket.on("disconnect", () => {
      console.log(
        "User disconnected:",
        socket.id
      )
    })
  })

  return io
}

export function getIO() {
  return io
}
