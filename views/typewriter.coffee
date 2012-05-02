$ () ->
  window.TypewriterView = Backbone.View.extend
    el: $("body")
    $text: $(".text")
    events:
      "click textarea": "textClick"
      "click": "toggleContextBar"
      "keydown": "handleText"
      "keyup": "handleText"
      "change #history": "loadDoc"

    initialize: () ->
      @$(window).resize () ->
        Typewriter.resize

      pos = @textVal().length
      unless $("body").hasClass("read")
        @$text[0].setSelectionRange(pos, pos)
        @$text.focus()

        @loadHistory()
        @updateHistory
          title: @title()
          link: window.location.toString()
        @saveHistory()

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
      @updateTitle @title()
      @resize()

    title: () ->
      @textVal().split("\n")[0]

    textClick: (e) ->
      @$el.removeClass("menu");

      e.stopImmediatePropagation()

    updateRemote: (text) ->
      if @lastValue == undefined
        @lastValue = text
      else if @lastValue != text
        @saveHistory()
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

    loadHistory: () ->
      if window.JSON? && window.localStorage?
        @history = JSON.parse(localStorage.getItem("history") || "[]")
      else
        @history = []

      for doc in @history
        $("<option/>").text(doc.title).attr("value", doc.link).prependTo("#history")

    updateHistory: (newDoc) ->
      for doc in @history
        if doc.link == newDoc.link
          @history = _.without(@history, doc)
      @history.push(newDoc)

    saveHistory: () ->
      if window.JSON? && window.localStorage?
        localStorage.setItem("history", JSON.stringify(@history))

    updateTitle: (docTitle) ->
      title = _([docTitle, "TypeWriter.tw"]).compact().join(" - ")
      window.document.title = title

    loadDoc: (e) ->
      link = $(e.target).val()
      if link.match /http/
        window.location = link

  window.Typewriter = new TypewriterView()