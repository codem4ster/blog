`import $ from 'jquery';`
`import "./new.scss"`


$('.refresh').click (->
  captcha = $('#captcha')
  parent = captcha.parent()
  captcha.remove()
  num = Math.floor(Math.random() * 1000000);
  $('<img id="captcha" src="/captcha?no-cache=' + num + '">').appendTo parent
)