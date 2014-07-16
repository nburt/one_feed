describe("PostValidator", function () {

  afterEach(function () {
    $('#jasmine_content').empty();
  });

  describe("validators for creating a post", function () {

    it("returns false if the text field is empty", function () {
      expect(PostValidator.validatePostTextarea("")).toEqual(false);
    });

    it("returns true if the text field is filled", function () {
      expect(PostValidator.validatePostTextarea("foo")).toEqual(true);
    });

    it("returns false if you haven't checked a provider", function () {
      var fixture = '<form><input id="provider_twitter" name="provider[twitter]" type="checkbox" value="0"/><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></form>';
      $('#jasmine_content').append(fixture);
      expect(PostValidator.validatePostCheckboxes($('#jasmine_content').find('input[type=checkbox]'))).toEqual(false)
    });

    it("returns true if you have checked a provider", function () {
      var fixture = '<form><input id="provider_twitter" name="provider[twitter]" checked="checked" type="checkbox" value="0"/><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></form>';
      $('#jasmine_content').append(fixture);
      expect(PostValidator.validatePostCheckboxes($('#jasmine_content').find('input[type=checkbox]'))).toEqual(true)
    });

    it("returns false if a tweet is longer than 140 characters", function () {
      expect(PostValidator.validateTweetLength("hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello wor")).toEqual(false);
    });

    it("returns true if a tweet is less than 140 characters", function () {
      expect(PostValidator.validateTweetLength("hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello w")).toEqual(true);
    });

  });
});