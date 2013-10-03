#autocompile
SERVER_PORT = 8123
SERVER_HOST = "127.0.0.1:#{SERVER_PORT}"

socket = null

init = ->
  socket = io.connect(SERVER_HOST)
  socket.emit "extension", null
  socket.on "music", (command) ->
    console.debug "Got command #{command}"
    commands[command]()
  console.debug "Web Music Remote initialized"

runOnGooglePlay = (code) ->
  chrome.tabs.query {title:"*Google Play"}, (tabs) ->
    if tabs && tabs.length > 0
      console.debug "Found #{tabs.length} google play tabs"
      tabId = tabs[0].id
      chrome.tabs.executeScript(tabId, code: code)

clickOnGooglePlayButton = (id) ->
  code = "console.log('clicking on #{id}'); document.querySelector(\"button[data-id='#{id}']\").click()"
  runOnGooglePlay(code)

commands =
  play: ->
    console.debug "Playing"
    clickOnGooglePlayButton('play-pause')

  next: ->
    console.debug "Next"
    clickOnGooglePlayButton('forward')

  prev: ->
    console.debug "Prev"
    clickOnGooglePlayButton('rewind')

console.debug "Web Music Remote loaded"
window.onload = init
