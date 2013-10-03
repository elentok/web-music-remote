PORT = 8123

http      = require 'http'
socketIo  = require 'socket.io'
extension = null

validCommands = ['play', 'next', 'prev']

handleRequest = (req, res) ->
  command = req.url.replace(/^\//, '')

  if validCommands.indexOf(command) == -1
    res.writeHead(500)
    return res.end("Invalid command '#{command}'")

  res.writeHead(200)
  res.end(command)

  if extension?
    console.log("Emitting '#{command}' to extension")
    extension.emit('music', command)

app = http.createServer(handleRequest)
app.listen(PORT)

io = socketIo.listen(app)
io.sockets.on "connection", (socket) ->
  console.log("Extension connected.")
  extension = socket
