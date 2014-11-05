(function() {
  $(function() {
    $("#trackForm").bootstrapValidator({
      message: "填写内容不符合要求.",
      feedbackIcons: {
        valid: "glyphicon glyphicon-ok",
        invalid: "glyphicon glyphicon-remove",
        validating: "glyphicon glyphicon-refresh"
      },
      fields: {
        "track[subject]": {
          validators: {
            notEmpty: {
              message: "标题是必填项."
            }
          }
        },
        "track[tos]": {
          validators: {
            notEmpty: {
              message: "收件人是必填项."
            }
          }
        }
      }
    });
    return $("#resetBtn").click(function() {
      return $("#trackForm").data("bootstrapValidator").resetForm(true);
    });
  });

}).call(this);
