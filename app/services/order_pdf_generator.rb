class OrderPdfGenerator
  include ActionView::Helpers::NumberHelper

  def initialize(order)
    @order = order
    @pdf = Prawn::Document.new(page_size: "A4", margin: 40)
  end

  def generate
    add_header
    add_order_info
    add_line_items_table
    add_footer
    @pdf.render
  end

  private

  def add_header
    # Company Logo/Header
    @pdf.font "Helvetica", style: :bold, size: 24
    @pdf.text "Union Swiss", color: "2c3e50"

    @pdf.font "Helvetica", size: 12
    @pdf.text "Bio-Oil Distribution System", color: "7f8c8d"

    @pdf.move_down 10
    @pdf.stroke_horizontal_rule
    @pdf.move_down 20

    # Order Confirmation Title
    @pdf.font "Helvetica", style: :bold, size: 18
    @pdf.text "ORDER CONFIRMATION", align: :center
    @pdf.move_down 30
  end

  def add_order_info
    # Order Details Box
    @pdf.stroke_bounds do
      @pdf.fill_color "f8f9fa"
      @pdf.fill_rectangle [ 0, @pdf.cursor ], @pdf.bounds.width, 100
      @pdf.fill_color "000000"

      @pdf.bounding_box([ 10, @pdf.cursor - 10 ], width: @pdf.bounds.width - 20) do
        @pdf.font "Helvetica", size: 11

        # Left column
        @pdf.bounding_box([ 0, @pdf.cursor ], width: 250) do
          @pdf.font "Helvetica", style: :bold
          @pdf.text "Order Number:", size: 10, color: "7f8c8d"
          @pdf.font "Helvetica", style: :bold, size: 14
          @pdf.text @order.order_number, color: "2c3e50"

          @pdf.move_down 10

          @pdf.font "Helvetica", style: :bold, size: 10
          @pdf.text "Distributor:", color: "7f8c8d"
          @pdf.font "Helvetica", size: 11
          @pdf.text @order.distributor.name

          @pdf.move_down 5

          @pdf.font "Helvetica", style: :bold, size: 10
          @pdf.text "Ordered By:", color: "7f8c8d"
          @pdf.font "Helvetica", size: 11
          @pdf.text @order.user.email
        end

        # Right column
        @pdf.bounding_box([ 300, @pdf.cursor + 80 ], width: 250) do
          @pdf.font "Helvetica", style: :bold, size: 10
          @pdf.text "Order Date:", color: "7f8c8d"
          @pdf.font "Helvetica", size: 11
          @pdf.text @order.created_at.strftime("%B %d, %Y at %I:%M %p")

          @pdf.move_down 10

          @pdf.font "Helvetica", style: :bold, size: 10
          @pdf.text "Required Delivery Date:", color: "7f8c8d"
          @pdf.font "Helvetica", size: 11, style: :bold
          @pdf.text @order.required_delivery_date.strftime("%B %d, %Y"), color: "e74c3c"
        end
      end
    end

    @pdf.move_down 30
  end

  def add_line_items_table
    @pdf.font "Helvetica", style: :bold, size: 14
    @pdf.text "ORDER ITEMS", color: "2c3e50"
    @pdf.move_down 15

    # Prepare table data
    table_data = [
      [
        { content: "Product", font_style: :bold },
        { content: "SKU Code", font_style: :bold },
        { content: "Pallets", font_style: :bold, align: :center },
        { content: "Units", font_style: :bold, align: :center },
        { content: "Unit Price", font_style: :bold, align: :right },
        { content: "Total", font_style: :bold, align: :right }
      ]
    ]

    currency = @order.order_items.first&.sku&.currency || "ZAR"

    @order.order_items.each do |item|
      units = item.quantity * OrderItem::UNITS_PER_PALLET

      table_data << [
        item.sku.product.name,
        item.sku.sku_code,
        { content: item.quantity.to_s, align: :center },
        { content: number_with_delimiter(units), align: :center },
        { content: "#{currency} #{number_with_precision(item.unit_price, precision: 2, delimiter: ',')}", align: :right },
        { content: "#{currency} #{number_with_precision(item.total_price, precision: 2, delimiter: ',')}", align: :right, font_style: :bold }
      ]
    end

    # Create table
    @pdf.table(table_data,
              header: true,
              width: @pdf.bounds.width,
              cell_style: {
                borders: [ :bottom ],
                border_width: 0.5,
                border_color: "dee2e6",
                padding: [ 8, 10 ]
              },
              row_colors: [ "ffffff", "f8f9fa" ]) do
      # Header row styling
      row(0).background_color = "2c3e50"
      row(0).text_color = "ffffff"
      row(0).font_style = :bold
      row(0).borders = []
      row(0).padding = [ 10, 10 ]
    end

    @pdf.move_down 20

    # Grand Total
    @pdf.stroke_bounds do
      @pdf.fill_color "27ae60"
      @pdf.fill_rectangle [ 0, @pdf.cursor ], @pdf.bounds.width, 50
      @pdf.fill_color "000000"

      @pdf.bounding_box([ 10, @pdf.cursor - 15 ], width: @pdf.bounds.width - 20) do
        @pdf.font "Helvetica", style: :bold, size: 16
        @pdf.text "GRAND TOTAL: #{currency} #{number_with_precision(@order.total_amount, precision: 2, delimiter: ',')}",
                  align: :right,
                  color: "ffffff"
      end
    end
  end

  def add_footer
    @pdf.move_down 40

    # Notes section
    @pdf.stroke_bounds do
      @pdf.bounding_box([ 10, @pdf.cursor - 10 ], width: @pdf.bounds.width - 20) do
        @pdf.font "Helvetica", style: :bold, size: 10
        @pdf.text "Important Notes:", color: "2c3e50"
        @pdf.font "Helvetica", size: 9
        @pdf.move_down 5
        @pdf.text "• Each pallet contains 4,800 units"
        @pdf.text "• Please confirm delivery arrangements at least 48 hours in advance"
        @pdf.text "• For any queries, please contact your Union Swiss representative"
      end
    end

    # Footer with page numbers and timestamp
    @pdf.number_pages "Page <page> of <total>",
                      at: [ @pdf.bounds.right - 150, 0 ],
                      width: 150,
                      align: :right,
                      size: 8,
                      color: "7f8c8d"

    @pdf.repeat :all do
      @pdf.draw_text "Generated on #{Time.current.strftime('%B %d, %Y at %I:%M %p')}",
                     at: [ 0, 0 ],
                     size: 8,
                     color: "7f8c8d"
    end
  end
end
