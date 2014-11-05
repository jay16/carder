$(document).ready ->
  randomNumber = (min, max) ->
    Math.floor Math.random() * (max - min + 1) + min
  $("#captchaOperation").html [
    randomNumber(1, 100)
    "+"
    randomNumber(1, 200)
    "="
  ].join(" ")
  $("#ppcForm").bootstrapValidator
    message: "填写项不符全要求."
    feedbackIcons:
      valid: "glyphicon glyphicon-ok"
      invalid: "glyphicon glyphicon-remove"
      validating: "glyphicon glyphicon-refresh"

    fields:
      ppc:
        validators:
          notEmpty:
            message: "请填写PrePaidCode."
          stringLength:
            min: 10
            message: "PrePaidCode长度至少10位."
          regexp:
            regexp: /^ppc\d+u\d+o(\d+i)?[a-zA-Z]{3}$/
            message: "PrePaidCode无效."
      captcha:
        validators:
          callback:
            message: "计算错误."
            callback: (value, validator) ->
              items = $("#captchaOperation").html().split(" ")
              sum   = parseInt(items[0]) + parseInt(items[2])
              value = parseInt(value)
              value is sum
