Layout = function () {

  Layout.prototype.initialize = function () {
    this.windowResizeListener();
    this.menuToggle();
  };

  Layout.prototype.windowResizeListener = function () {
    var menuButtonContainer = $('#menu_button_container li');
    $(window).resize(function () {
      if ($('.mobile_menu').css('border') === '0px none rgb(255, 255, 255)') {
        this.largeScreenMenu(menuButtonContainer);
      }
      else {
        this.mobileMenu(menuButtonContainer);
      }
    }.bind(this));
  };

  Layout.prototype.menuToggle = function () {
    $('#menu_button').click(function () {
      $('.mobile_menu').slideToggle();
    });
  };

  Layout.prototype.largeScreenMenu = function (menuButtonContainer) {
    menuButtonContainer.css('display', 'inline-block');
    $('.mobile_menu').show();
    $('#menu_button').hide();
  };

  Layout.prototype.mobileMenu = function (menuButtonContainer) {
    menuButtonContainer.css('display', 'block');
    $('.mobile_menu').hide();
    $('#menu_button').show();
  };
};
