class Dish
  attr_reader :name, :price, :description

  def initialize(name, price, description = nil)
    @name = name
    @price = price
    @description = description
  end
end

class Category
  attr_reader :name, :dishes

  def initialize(name)
    @name = name
    @dishes = []
  end

  def add_dish(dish)
    @dishes << dish
  end
end

class Menu
  attr_reader :categories

  def initialize
    @categories = []
  end

  def add_category(category)
    @categories << category
  end

  def find_dish(dish_name)
    @categories.each do |category|
      category.dishes.each do |dish|
        return dish if dish.name == dish_name
      end
    end
    nil
  end
end

# DSL для опису меню
class MenuBuilder
  def initialize
    @menu = Menu.new
  end

  def category(name, &block)
    category = Category.new(name)
    # Викликаємо блок у контексті MenuBuilder, передаючи категорію
    instance_eval_with_category(category, &block)
    @menu.add_category(category)
  end

  def dish(name, price, description = nil)
    Dish.new(name, price, description)
  end

  def build
    @menu
  end

  private

  # Додаємо метод для виконання блоку в контексті MenuBuilder і Category
  def instance_eval_with_category(category, &block)
    @current_category = category
    instance_eval(&block)
    @current_category = nil
  end

  def add_dish(dish)
    @current_category.add_dish(dish)
  end
end

# Створення меню
builder = MenuBuilder.new

builder.category("Appetizers") do
  add_dish(dish("Spring Rolls", 5.99, "Crispy and delicious"))
  add_dish(dish("Garlic Bread", 3.49))
end

builder.category("Main Courses") do
  add_dish(dish("Spaghetti Bolognese", 12.99))
  add_dish(dish("Grilled Chicken", 15.49, "Juicy grilled chicken with sides"))
end

menu = builder.build

# Показати меню
menu.categories.each do |category|
  puts category.name
  category.dishes.each do |dish|
    puts "  #{dish.name} - $#{dish.price} #{dish.description ? "- #{dish.description}" : ''}"
  end
end