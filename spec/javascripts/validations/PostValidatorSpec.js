describe("PostValidator", function () {

  afterEach(function () {
    $('#jasmine_content').empty();
  });

  describe("validators for creating a post", function () {

    it("returns false if the text field is empty", function () {
      var fixture = '<p id="textarea_validation_error">Post body cannot be blank.</p><p style="display:block" id="tweet_length_validation_error">Tweet cannot be longer than 140 characters.</p>';
      $('#jasmine_content').append(fixture);
      expect('#tweet_length_validation_error').toBeVisible();
      expect(PostValidator.validatePostTextarea("")).toEqual(false);
      expect('#textarea_validation_error').toBeVisible();
      expect('#tweet_length_validation_error').toBeHidden();
    });

    it("returns true if the text field is filled", function () {
      var fixture = '<p id="textarea_validation_error">Post body cannot be blank.</p>';
      $('#jasmine_content').append(fixture);
      expect(PostValidator.validatePostTextarea("foo")).toEqual(true);
      expect('#textarea_validation_error').toBeHidden();
    });

    it("returns false if you haven't checked a provider", function () {
      var fixture = '<form><p id="checkbox_validation_error">You must check at least one provider.</p><input id="provider_twitter" name="provider[twitter]" type="checkbox" value="0"/><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></form>';
      $('#jasmine_content').append(fixture);
      expect(PostValidator.validatePostCheckboxes($('#jasmine_content').find('input[type=checkbox]'))).toEqual(false);
      expect($('#checkbox_validation_error')).toBeVisible();
    });

    it("returns true if you have checked a provider", function () {
      var fixture = '<form><p id="checkbox_validation_error">You must check at least one provider.</p><input id="provider_twitter" name="provider[twitter]" checked="checked" type="checkbox" value="0"/><input id="provider_facebook" name="provider[facebook]" type="checkbox" value="0"/></form>';
      $('#jasmine_content').append(fixture);
      expect(PostValidator.validatePostCheckboxes($('#jasmine_content').find('input[type=checkbox]'))).toEqual(true);
      expect($('#checkbox_validation_error')).toBeHidden();
    });

    it("returns false if a tweet is longer than 140 characters", function () {
      var fixture = '<p id="tweet_length_validation_error">Tweet cannot be longer than 140 characters.</p>';
      $('#jasmine_content').append(fixture);
      expect(PostValidator.validateTweetLength("hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello wor")).toEqual(false);
      expect($('#tweet_length_validation_error')).toBeVisible();
    });

    it("returns true if a tweet is less than 140 characters", function () {
      var fixture = '<p id="tweet_length_validation_error">Tweet cannot be longer than 140 characters.</p>';
      $('#jasmine_content').append(fixture);
      expect(PostValidator.validateTweetLength("hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello w")).toEqual(true);
      expect($('#tweet_length_validation_error')).toBeHidden();
    });

  });
});