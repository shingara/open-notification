require 'restclient'

RestClient.post 'http://localhost:3000/messages', :api_key => '4b1c3741ac2a922601000001',
  :subject => 'Trop fort',
  :body => "c'est de la grosse bombe",
  :message_kinds => {0 => {:channel => 'jabber', :to => 'cyril.mougel@gmail.com'},
    1 =>
    {:channel => 'mail', :to => 'cyril.mougel@gmail.com'}
}
