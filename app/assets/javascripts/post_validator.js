PostValidator = {
  validatePostTextarea: function (textareaValue) {
    if (textareaValue === null || textareaValue === "") {
      alert("Post body cannot be blank.");
      return false;
    } else {
      return true;
    }
  },

  validatePostCheckboxes: function (checkboxes) {
    if (!checkboxes[0].checked && !checkboxes[1].checked) {
      alert("You must check at least one provider.");
      return false;
    } else {
      return true;
    }
  },

  validateTweetLength: function (tweetText) {
    if (tweetText.length > 140) {
      alert("Tweet cannot be longer than 140 characters.");
      return false;
    } else {
      return true;
    }
  }
};