#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  require 'xmpp4r/client'
  include Jabber
  
  
  def jabber_notify(user_jid,text)

    jid = JID::new('jabra-bugtracker@jabber.ru')
    password = 'trollenbaka'
    cl = Client::new(jid)
    cl.connect
    cl.auth(password)

    to = user_jid
    subj = "Jabra automatic message"
    m = Message::new(to,text).set_type(:normal).set_id('1').set_subject(subj)
    cl.send m
  end

end
