$(document).ready(function() {

  $("#menuitem_screen").addClass("active");

  $("#formarea").hide();
  $("#addbutton").click(function() {
    $("#formarea").fadeIn();
  });

  $(".frame").draggable({ opacity: 0.5, grid: [10, 10], snap: true });
  $(".frame").draggable({
    stop: function(event, ui) {
      jQuery.post( 'frames/' + ui.helper.attr('id').substring(6) + '.js',
                   { _method: 'PUT',
                     frame: {
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
      jQuery.post( 'frames/' + ui.helper.attr('id').substring(6) + '.js',
                   { _method: 'PUT',
                     frame: {
                      width: ui.helper.width(),
                      height: ui.helper.height()
                     }
                   },
                   function(data, textStatus, XMLHttpRequest) {}
      );
      window.location.reload();
    }
  });


  $(".frame-delete").click(function() {
    jQuery.post( 'frames/' + $(this).attr('id').substring(12) + '.js',
                   { _method: 'DELETE' },
                   function(data, textStatus, XMLHttpRequest) {}
    );
  });

});
