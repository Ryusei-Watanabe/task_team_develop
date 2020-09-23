class TeamMailer < ApplicationMailer
  default from: 'from@example.com'
  def owner_mail(email, team_name)
    @email = email
    @team_name = team_name
    mail to: email, subject: I18n.t("views.messages.is_invested_team_owner")
  end
end
