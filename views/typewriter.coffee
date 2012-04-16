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
      console.log($(window), window, @$)
      @$(window).resize () ->
        Typewriter.resize2

      setInterval (=>
        @updateRemote(@textVal())
      ), 1000

      1
    render: () ->
      2

    textVal: () ->
      @$text.val()

    resize: () ->
      lines = @textVal.split("\n").length
      lineHeight = 30
      additional = 100

      minimumHeight = $(window).height() - (@$text.position().top * 2);
      height = Math.max(lines * lineHeight + additional, minimumHeight)
     

      $text.css("height", height);

    toggleContextBar: () ->
      @$el.toggleClass("menu");

    handleText: (e) ->
      title = @textVal().split("\n")[0]
      @updateTitle title

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


    updateTitle: (docTitle) ->
      title = _([docTitle, "TypeWriter.tw"]).compact().join(" - ")
      window.document.title = title

  Typewriter = new TypewriterView()