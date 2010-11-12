$("#form").droppable({
  activeClass: "droppable-state-active",
  hoverClass: "droppable-state-hover",
  drop: function( event, ui ) {
    $(this).addClass( "droppable-state-dropped" );

    if (ui.draggable.hasClass("subtag")) {
      document.getElementById("tag_tags").value = ui.draggable.text() + ", " + document.getElementById("tag_tags").value;
    } else if (ui.draggable.hasClass("source")) {
      document.getElementById("tag_event_sources").value = ui.draggable.text() + ", " + document.getElementById("tag_event_sources").value;
    } else if (ui.draggable.hasClass("name")) {
      document.getElementById("tag_event_names").value = ui.draggable.text() + ", " + document.getElementById("tag_event_names").value;
    }

    ui.helper.hide();

    $("#notice").html(ui.draggable.text());
    $("#notice").fadeIn(400, function() {
      $("#notice").fadeOut(400);
    });
  }
});

$(".element").draggable({ revert: "valid", helper: "clone" });
