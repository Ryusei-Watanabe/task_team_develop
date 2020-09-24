class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end
  def destroy
    # params[:id]はアジェンダのid。@agenda.team_idでチームのidを取得
    # 全員のemailを取得する。@agendaのteam_idを使って、TeamのアソシエーションメソッドmembersでUserのemailを取得する。
    if current_user.id == @agenda.user_id || current_user == @agenda.team.owner
      @agenda.destroy
      team_members_email = @agenda.team.members.pluck(:email)
      team_members_email.each do |email|
        AgendaMailer.delete_mail(email, @agenda).deliver
      end
      redirect_to dashboard_path, notice: I18n.t('views.messages.destroy_agenda')
    else
      redirect_to dashboard_path, notice: I18n.t('views.messages.can_not_destroy_agenda')
    end

  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
