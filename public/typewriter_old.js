$(function(){

  $("body, .settings").live("click", function(e){
    $("body").toggleClass("menu");
    e.stopImmediatePropagation();
    window.scrollTo(0);
  });

  window.save = function(value){
    return 1;
    $.ajax({
      type: "POST",
      data: value
    });
  }
  Typewriter = function(){
    $textarea = $("textarea");

    return {
      resize: function(){
        var lines = $textarea.val().split("\n").length,
            lineHeight = 30,
            additional = 100;

        var minimumHeight = $(window).height() - ($("textarea").position().top * 2);
        var height = Math.max(lines * lineHeight + additional, minimumHeight)// $(document).height())
        console.log(minimumHeight)


        $textarea.css("height", height);
      }
    }
  }


  window.typewriter = new Typewriter();
  $(window).bind("resize", typewriter.resize)

  update = function(){
    $textarea = $("textarea");

    value = $textarea.val();

    if(value === " "){
      value = "&nbsp;";
    }else if(value === "\n"){
      value = "<br/>";
    }
    $(".text").html($(".text").html() + value);
    $textarea.val("");
  }


  $("body.unforgivable").each(function(){
    $("textarea").keydown(update);
    $("textarea").keyup(update);
  });

  $("body.timed").each(function(){
    setInterval(function(){
      $(".text").append("&nbsp;");
    }, 1000);
  });

  $("body.normal").each(function(){
    $("textarea").keydown(function(e){
      $textarea = $(this);
      if(e.keyCode == 9){
        e.preventDefault();
        console.log("preventd")
      }
      typewriter.resize();
    });
    typewriter.resize();
  });


  selectTextArea = function(){
    var $t = $("textarea");
    var t=$t[0],
    len=t.value.length;
    if(t.setSelectionRange){
      t.setSelectionRange(len,len)
    }
    $t.focus();
  }

  $("textarea").click(function(e){
    e.stopImmediatePropagation();
  });

  $("html").click(function(e){
    selectTextArea()
  });

  selectTextArea()


  setInterval(function(){
    if($("body").hasClass("normal")){
      save($(".normal textarea").val());
    }else{
      save($(".unforgivable .text").html());
    }
  }, 4000);
});

