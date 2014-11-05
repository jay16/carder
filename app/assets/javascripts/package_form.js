(function() {
  $(function() {
    $("#packageForm").bootstrapValidator({
      message: "填写内容不符合要求.",
      feedbackIcons: {
        valid: "glyphicon glyphicon-ok",
        invalid: "glyphicon glyphicon-remove",
        validating: "glyphicon glyphicon-refresh"
      },
      fields: {
        "package[name]": {
          validators: {
            notEmpty: {
              message: "套餐名称是必填项."
            }
          }
        },
        "package[price]": {
          validators: {
            notEmpty: {
              message: "价格是必填项."
            },
            lessThan: {
              value: 10000,
              inclusive: true,
              message: "价格应该小于等于10,000"
            },
            greaterThan: {
              value: 1,
              inclusive: true,
              message: "价格应该大于等于1.0"
            }
          }
        },
        "package[num]": {
          validators: {
            notEmpty: {
              message: "数量是必填项."
            },
            lessThan: {
              value: 100,
              inclusive: true,
              message: "数量应该小于100[天/月/年]."
            },
            greaterThan: {
              value: 1,
              inclusive: true,
              message: "数量应该大于等于1."
            }
          }
        },
        "package[unit]": {
          validators: {
            notEmpty: {
              message: "单位是必填项."
            },
            regexp: {
              regexp: /天|月|年/,
              message: "单位必须在[天/月/年]范围内."
            }
          }
        }
      }
    });
    return $("#resetBtn").click(function() {
      return $("#packageForm").data("bootstrapValidator").resetForm(true);
    });
  });

}).call(this);
