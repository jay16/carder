require "./config/boot.rb"

# public
map("/")                { run HomeController }
map("/weixin")          { run WeixinController }
map("/user")            { run UserController }
