class AgendaMailer < ApplicationMailer
  def delete_mail(email, agenda)
    @email = email
    @agenda_title = agenda.title
    mail to: @email, subject: I18n.t('views.messages.complete_delete')
  end
end
