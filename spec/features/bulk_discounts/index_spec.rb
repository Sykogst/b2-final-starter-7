require "rails_helper"

describe "bulk discounts index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_5.id, quantity: 1, unit_price: 1, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
    @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)

    @discount_1 = BulkDiscount.create!(percentage: 10, quantity_threshold: 5, merchant_id: @merchant1.id)
    @discount_2 = BulkDiscount.create!(percentage: 20, quantity_threshold: 10, merchant_id: @merchant1.id)
    @discount_3 = BulkDiscount.create!(percentage: 10, quantity_threshold: 5, merchant_id: @merchant2.id)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  # 1: Merchant Bulk Discounts Index, part 2
  # As a merchant
  # Then I am taken to my bulk discounts index page
  # Where I see all of my bulk discounts including their
  # percentage discount and quantity thresholds
  # And each bulk discount listed includes a link to its show page
  it 'They see all bulk discounts including percentage, quantity thresholds, no discounts from other merchants' do
    within "#discount-#{@discount_1.id}" do
      expect(page).to have_content('10% off 5 items')
    end

    within "#discount-#{@discount_2.id}" do
      expect(page).to have_content('20% off 10 items')
    end

    expect(page).to_not have_css("#discount-#{@discount_3.id}")
  end

  it 'Each discount is a link to its show page, when clicked directs to proper show page' do
    within "#discount-#{@discount_1.id}" do
      expect(page).to have_link('10% off 5 items')
    end

    within "#discount-#{@discount_2.id}" do
      expect(page).to have_link('20% off 10 items')
      click_link('20% off 10 items')
    end

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@discount_2.id}")
  end

  # 2: Merchant Bulk Discount Create
  # As a merchant
  # When I visit my bulk discounts index
  # Then I see a link to create a new discount
  # When I click this link
  # Then I am taken to a new page where I see a form to add a new bulk discount
  # When I fill in the form with valid data
  # Then I am redirected back to the bulk discount index
  # And I see my new bulk discount listed
  it 'There is a link to create a new discount, when clicked, directs to form page, fill in with good information and submit' do
    expect(page).to have_link('Create New Discount')

    click_link('Create New Discount')

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
    
    fill_in 'Percentage', with: 30
    fill_in 'Quantity threshold', with: 20
    click_button 'Submit'
    
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_content('30% off 20 items')
    expect(page).to have_content('Succesfully Added Discount!')
  end

  it 'Create new discount, sad path: missing information' do
    click_link('Create New Discount')    
    fill_in 'Percentage', with: 30
    click_button 'Submit'
    
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to have_content("Quantity threshold can't be blank, Quantity threshold is not a number")
  end

  it 'Create new discount, sad path: non-numerical values' do
    click_link('Create New Discount')    
    fill_in 'Percentage', with: "30%"
    fill_in 'Quantity threshold', with: "20a"

    click_button 'Submit'

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to have_content('Percentage is not a number, Quantity threshold is not a number')
  end

  it 'Create new discount, sad path: negative numbers' do
    click_link('Create New Discount')    
    fill_in 'Percentage', with: -30
    fill_in 'Quantity threshold', with: -20

    click_button 'Submit'

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to have_content('Percentage must be greater than or equal to 0, Quantity threshold must be greater than or equal to 0')
  end

  # Percentage does not actually HAVE to be, just decided to make it a requirement for simplicity
  it 'Create new discount, sad path: integers only' do
    click_link('Create New Discount')    
    fill_in 'Percentage', with: 30.5
    fill_in 'Quantity threshold', with: 20.5

    click_button 'Submit'

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to have_content('Percentage must be an integer, Quantity threshold must be an integer')
  end

  # 3: Merchant Bulk Discount Delete
  # As a merchant
  # When I visit my bulk discounts index
  # Then next to each bulk discount I see a button to delete it
  # When I click this button
  # Then I am redirected back to the bulk discounts index page
  # And I no longer see the discount listed
  it 'There is delete button next to each discount, click, redirects back, discount is gone' do
    within "#discount-#{@discount_1.id}" do
      expect(page).to have_button('Delete')
    end

    within "#discount-#{@discount_2.id}" do
      expect(page).to have_button('Delete')
      click_button('Delete')
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_content('Successfully deleted discount')
    expect(page).to_not have_css("#discount-#{@discount_2.id}")
    expect(page).to_not have_content("20% off 10 items")
  end

  it 'Has a flash message for unsuccessful delete of something' do
    allow(BulkDiscount).to receive(:find).with(@discount_2.id.to_s).and_return(@discount_2)
    allow(@discount_2).to receive(:destroy).and_return(false)
    within "#discount-#{@discount_2.id}" do
      click_button('Delete')
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_content('Failed to delete discount')
    expect(page).to have_content('10% off 5 items')
    expect(page).to have_content('20% off 10 items')
  end

end