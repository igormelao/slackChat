window.add = (slug, id, type) ->
  additional = if type == "channel" then "#" else ""
  $('.' + type + 's').prepend('<li class="' + type + '_' + id + '">' +
                               ' <div>' +
                                  '<a href="#" class="open_' + type + '">' +
                                    '<span id="' + id + '">' + additional + slug + '</span>' +
                                  '</a>' +
                                  '<a class="right remove' + type + '" href="#" id="' + id + '">' +
                                    '<i class="material-icons" id="' + id + '">settings</i>' +
                                  '</a>' +
                                 '</div>' +
                                '</li>')
