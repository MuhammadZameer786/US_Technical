module AuditLogsHelper
  def render_event_badge(event)
    case event
    when "create"
      content_tag :span, class: "badge bg-success" do
        content_tag(:i, "", class: "bi bi-plus-circle me-1") + "Created"
      end
    when "update"
      content_tag :span, class: "badge bg-warning" do
        content_tag(:i, "", class: "bi bi-pencil me-1") + "Updated"
      end
    when "destroy"
      content_tag :span, class: "badge bg-danger" do
        content_tag(:i, "", class: "bi bi-trash me-1") + "Deleted"
      end
    else
      content_tag :span, class: "badge bg-secondary" do
        event.titleize
      end
    end
  end

  def render_record_info(version)
    case version.item_type
    when "Order"
      order = version.item
      content_tag(:div) do
        content_tag(:strong, order.order_number, class: "text-primary d-block") +
        content_tag(:small, "Total: #{number_to_currency(order.total_amount)}", class: "text-muted")
      end if order
    when "Product"
      product = version.item
      content_tag(:div) do
        content_tag(:strong, product.name, class: "d-block") +
        content_tag(:small, truncate(product.description, length: 50), class: "text-muted")
      end if product
    when "Sku"
      sku = version.item
      content_tag(:div) do
        content_tag(:strong, sku.name, class: "d-block") +
        content_tag(:small, "Price: #{sku.currency} #{sku.price}", class: "text-muted")
      end if sku
    when "Distributor"
      distributor = version.item
      content_tag(:div) do
        content_tag(:strong, distributor.name, class: "d-block") +
        content_tag(:small, distributor.contact_email, class: "text-muted")
      end if distributor
    when "User"
      user = version.item
      content_tag(:div) do
        content_tag(:strong, user.email, class: "d-block") +
        content_tag(:small, user.role.titleize, class: "text-muted")
      end if user
    else
      "Record ##{version.item_id}"
    end
  rescue
    content_tag(:span, "Record ##{version.item_id}", class: "text-muted")
  end

  def format_value(value)
    case value
    when nil
      "(empty)"
    when true
      "Yes"
    when false
      "No"
    when Time, DateTime, Date
      value.strftime("%Y-%m-%d %H:%M")
    else
      truncate(value.to_s, length: 50)
    end
  end
end
