$(function(){
  window.save = function(value){
    $.ajax({
      type: "POST",
      data: value
    });
  }


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
      var lines = $textarea.val().split("\n").length;
      $textarea.css("height", lines * 30 + 100);
    });
  });


  $("html").click(function(){
    $("textarea").focus();
  });

  $("textarea").focus();

  setInterval(function(){
    if($("body").hasClass("normal")){
      save($(".normal textarea").val());
    }else{
      save($(".unforgivable .text").html());
    }
  }, 4000);
});

