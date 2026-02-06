module Admin
  class AuditLogsController < ApplicationController
    before_action :require_admin

    def index
      @q = PaperTrail::Version.ransack(params[:q])
      @pagy, @versions = pagy(
        @q.result(distinct: true)
          .order(created_at: :desc),
        items: 20
      )
    end

    def show
      @version = PaperTrail::Version.find(params[:id])
      @item = @version.item_type.constantize.find_by(id: @version.item_id)
    end
  end
end
