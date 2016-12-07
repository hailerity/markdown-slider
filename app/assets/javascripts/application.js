// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){
    window.getCookie = function(name) {
      match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
      if (match) return match[2];
    }

    $('.carousel').carousel({
      interval: false
    });

    var strIndex = getCookie('last-slide-index');
    if (strIndex) {
      $('.carousel').carousel(parseInt(strIndex));
    }

    $('.carousel').on('slid.bs.carousel', function (e) {
      var index = $(this).find('.active').index();
      document.cookie ="last-slide-index=" + index;
    });

    var wrapperHeight = $('.slide-wrapper').height();
    $('.slide-content').each(function(index, slide){
      if (index == 0) {
        var slideHeight = $(slide).height();
        if (slideHeight < wrapperHeight / 2) {
            $(slide).css('margin-top', (wrapperHeight - slideHeight) / 2 * 2 / 3);
        }
      }
    });

    $(document).keydown(function(e) {
      switch(e.which) {
          case 37: // left
          $('.carousel').carousel('prev')
          break;

          case 38: // up
          break;

          case 39: // right
          $('.carousel').carousel('next')
          break;

          case 40: // down
          break;

          default: return; // exit this handler for other keys
      }
      e.preventDefault(); // prevent the default action (scroll / move caret)
    });

});
