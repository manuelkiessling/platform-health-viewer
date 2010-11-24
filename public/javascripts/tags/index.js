function bindEventRenderer(tagId) {
  $("#link_events_tagid_" + tagId).bind("ajax:success", function(event, data, status, xhr) {
    $("#events_tagid_" + tagId).hide();
    $("#events_tagid_" + tagId).html('');

    var json = $.parseJSON(xhr.responseText);
    for (key in json) {
      $("#events_tagid_" + tagId).append(json[key].id);
      $("#events_tagid_" + tagId).append("	");
      $("#events_tagid_" + tagId).append(json[key].created_at);
      $("#events_tagid_" + tagId).append("	");
      $("#events_tagid_" + tagId).append(json[key].name);
      $("#events_tagid_" + tagId).append("	");
      $("#events_tagid_" + tagId).append(json[key].source);
      $("#events_tagid_" + tagId).append("	");
      $("#events_tagid_" + tagId).append(json[key].value);
      $("#events_tagid_" + tagId).append("<br />");
    }

    $("#events_tagid_" + tagId).slideDown(400);
  });
}

$(document).ready(function() {

  $("#menuitem_tags").addClass("active");

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

});
