describe("Layout", function () {

  beforeEach(function () {
    jQuery.fx.off = true;
  });

  afterEach(function () {
    $('#jasmine_content').empty();
    jQuery.fx.off = false;
  });

  it("hides and shows the navbar depending on the window size", function () {
    var fixture = '<header><div class="header_content"><nav id="logged_in"><div id="menu_button_container"><ul><li id="menu_button">Menu</li><li class="mobile_menu"><a href="/accounts/16">Account Settings</a></li><li class="mobile_menu"><a href="/destroy">Sign Out</a></li></ul></div></nav></div></header>';
    $('#jasmine_content').append(fixture);
    var layout = new Layout();
    var menuButtonContainer = $('#menu_button_container li');

    layout.mobileMenu(menuButtonContainer);
    expect($('.mobile_menu')).toBeHidden();
    expect($('#menu_button')).toBeVisible();

    layout.largeScreenMenu(menuButtonContainer);
    expect($('#menu_button')).toBeHidden();
    expect($('.mobile_menu')).toBeVisible();
  });

  it("toggles the menu for mobile devices", function () {
    var fixture = '<header><div class="header_content"><nav id="logged_in"><div id="menu_button_container"><ul><li id="menu_button">Menu</li><li class="mobile_menu"><a href="/accounts/16">Account Settings</a></li><li class="mobile_menu"><a href="/destroy">Sign Out</a></li></ul></div></nav></div></header>';
    $('#jasmine_content').append(fixture);
    var layout = new Layout();
    var menuButtonContainer = $('#menu_button_container li');
    layout.mobileMenu(menuButtonContainer);
    expect($('.mobile_menu')).toBeHidden();
    layout.initialize();
    $('#menu_button').click();
    expect($('.mobile_menu')).toBeVisible();
    $('#menu_button').click();
    expect($('.mobile_menu')).toBeHidden();
  });
});

