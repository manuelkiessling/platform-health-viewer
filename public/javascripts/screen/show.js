$(".frame").draggable({ opacity: 0.5, grid: [10, 10], snap: true });

$(".frame").draggable({
  stop: function(event, ui) {
    jQuery.post( 'update_frame', { frame: {
                                   id: ui.helper.attr('id').substring(6),
                                   top: ui.position.top,
                                   left: ui.position.left
                                 }
                               },
      function(data, textStatus, XMLHttpRequest) {}
    );
  }
});


$(".frame").resizable({ grid: [10, 10] });

$(".frame").resizable({
  stop: function(event, ui) {
    jQuery.post( 'update_frame', { frame: {
                                   id: ui.helper.attr('id').substring(6),
                                   width: ui.helper.width(),
                                   height: ui.helper.height()
                                 }
                               },
      function(data, textStatus, XMLHttpRequest) {}
    );
    window.location.reload();
  }
});
