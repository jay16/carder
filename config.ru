require "./config/boot.rb"

# public
map("/")               { run HomeController }
map("/weixin")         { run WeixinController }
# authenticate
map("/carder")         { run Carder::HomeController }
map("/carder/user")    { run Carder::UserController }
map("/cpanel")         { run Cpanel::HomeController }
