# frozen_string_literal: true

require 'rspec'
require_relative '../menu'

RSpec.describe MenuBuilder do
  it 'creates a menu with categories and dishes' do
    builder = MenuBuilder.new

    builder.category("Appetizers") do
      add_dish(dish("Spring Rolls", 5.99))
      add_dish(dish("Garlic Bread", 3.49))
    end

    builder.category("Main Courses") do
      add_dish(dish("Spaghetti Bolognese", 12.99))
      add_dish(dish("Grilled Chicken", 15.49, "Grilled with herbs"))
    end

    menu = builder.build

    expect(menu.categories.size).to eq(2)

    appetizers = menu.categories.find { |cat| cat.name == "Appetizers" }
    expect(appetizers.dishes.size).to eq(2)
    expect(appetizers.dishes.first.name).to eq("Spring Rolls")

    main_courses = menu.categories.find { |cat| cat.name == "Main Courses" }
    expect(main_courses.dishes.size).to eq(2)
    expect(main_courses.dishes.last.name).to eq("Grilled Chicken")
  end

  it 'finds a dish by name' do
    builder = MenuBuilder.new

    builder.category("Appetizers") do
      add_dish(dish("Spring Rolls", 5.99))
    end

    builder.category("Main Courses") do
      add_dish(dish("Spaghetti Bolognese", 12.99))
    end

    menu = builder.build

    dish = menu.find_dish("Spring Rolls")
    expect(dish).not_to be_nil
    expect(dish.name).to eq("Spring Rolls")
    expect(dish.price).to eq(5.99)
  end
end
