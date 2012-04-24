$ () ->
  window.TypewriterView = Backbone.View.extend
    el: $("body")
    $text: $(".text")
    events:
      "click textarea": "textClick"
      "click": "toggleContextBar"
      "keydown": "handleText"
      "keyup": "handleText"

    initialize: () ->
      @$(window).resize () ->
        Typewriter.resize

      pos = @textVal().length
      unless $("body").hasClass("read")
        @$text[0].setSelectionRange(pos, pos)
        @$text.focus()

      $(".read-only").attr("href", @readOnlyLink())

      setInterval (=>
        @updateRemote(@textVal())
      ), 1000

      $(".corner").click =>
        @toggleCorner()

    render: () ->
      2

    textVal: () ->
      @$text.val()

    resize: () ->
      lines = @textVal().split("\n").length
      lineHeight = 30
      additional = 100

      minimumHeight = $(window).height() - (@$text.position().top * 2);
      height = Math.max(lines * lineHeight + additional, minimumHeight)
      #console.log(minimumHeight)
      #@$text.css("height", height);

    toggleContextBar: () ->
      @$el.toggleClass("menu");

    toggleCorner: () ->
      $(".corner").toggleClass("open")

    handleText: (e) ->
      title = @textVal().split("\n")[0]
      @updateTitle title
      @resize()

    textClick: (e) ->
      @$el.removeClass("menu");

      e.stopImmediatePropagation()

    updateRemote: (text) ->
      if @lastValue == undefined
        @lastValue = text
      else if @lastValue != text
        $.ajax
          type: "POST",
          data: text
          success: =>
            @lastValue = text
      else
        # ignore

    setCornerSize: (val) ->
      $(".corner").css
        width: val
        height: val

    readOnlyLink: () ->
      u = window.location.toString().split("/")
      u.pop()
      u.join("/")

    updateTitle: (docTitle) ->
      title = _([docTitle, "TypeWriter.tw"]).compact().join(" - ")
      window.document.title = title

  window.Typewriter = new TypewriterView()