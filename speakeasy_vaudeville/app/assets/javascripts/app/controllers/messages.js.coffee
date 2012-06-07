$ = jQuery.sub()
# Message = App.Message
# window.MessagesItem = App.MessagesItem

# $.fn.item = ->
#   elementID   = $(@).data('id')
#   elementID or= $(@).parents('[data-id]').data('id')
#   Message.find(elementID)

class MessagesItem extends Spine.Controller
  proxied: [ "render", "remove" ]

  template: (message) ->
    @view('messages/message')(message: message)

  constructor: (@item) ->
    @item.bind "update", @render
    @item.bind "destroy", @remove

  render: =>
    @template(@item)

  remove: ->
    @el.remove()

class Messages extends Spine.Controller

  elements:
    ".items": "items"
    ".new textarea": "input"

  events:
    "click .new input#scroll": "createMessage"

  constructor: ->
    super
    Room.bind 'refresh', @loadMessages
    Message.bind 'create', @addNew
    Message.bind 'refresh change', @render
    Sidebar.bind 'changeRoom', @changeRoom
    
  render: =>
    Message.all()
    @items.empty()
    Message.each(@addOne)
    @scroll()

  loadMessages: =>
    Message.fetch_all()

  scroll: =>
    objDiv = $("#stuff")[0]
    objDiv.scrollTop = objDiv.scrollHeight

  addOne: (item) =>
    return unless item.forRoom(Sidebar.room())
    msgItem = new MessagesItem(item)
    @items.append msgItem.render()
    @scroll()

  addNew: (item) =>
    @addOne(item)

  changeRoom: (room) =>
    @room = room
    @render()

  createMessage: ->
    alert "Room required"  unless Sidebar.room()
    value = @input.val()
    return false unless value 
    # Message.unbind 'refresh change', @render
    Message.create
      room_id: Sidebar.room().id
      body: value

    @input.val ""
    @input.focus()
    #Message.fetch()
    false

  username: =>
    $("meta[name=current-user-name]").attr("content")

  email: => 
    $("meta[name=current-user-email]").attr("content")

window.Messages = Messages
