module ApplicationHelper
  include Pagy::Frontend
    include ActionView::Helpers::NumberHelper


 def status_badge(status)
    colors = {
      "pending" => "warning",
      "confirmed" => "info",
      "processing" => "primary",
      "shipped" => "success",
      "delivered" => "success",
      "cancelled" => "danger"
    }

    icons = {
      "pending" => "clock",
      "confirmed" => "check-circle",
      "processing" => "arrow-repeat",
      "shipped" => "truck",
      "delivered" => "check-all",
      "cancelled" => "x-circle"
    }

    content_tag :span, class: "badge bg-#{colors[status]} fs-6" do
      content_tag(:i, "", class: "bi bi-#{icons[status]} me-1") + status.titleize
    end
  end
end
