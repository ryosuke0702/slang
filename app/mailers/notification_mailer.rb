class NotificationMailer < ApplicationMailer
  default from: 'no-replay@gmail.com'

#usersコントローラー
  def complete_mail(user)  #ユーザー登録したときにメール通知
    @user = user
    @url = "https://vietnamslang.herokuapp.com/"
    mail(subject: "COMPLETE join your address" ,to: @user.email)
  end

  def destroy_mail(user)  #アカウント削除時にメールで通知
    @user = user
    mail(subject: "DELETE your account" ,to: @user.email)
  end

#commentコントローラー
  def comment_mail(user, post)  #自分の投稿にコメントがきたときメールで通知
    @name = post.name
    @user = user
    @url = "https://vietnamslang.herokuapp.com/"
    mail(subject: "Be commented on your post" ,to: @user.email)
  end
end
