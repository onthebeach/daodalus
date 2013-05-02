Given(/^there are cats called Jessica and Trevor$/) do
  @jessica = Cat.new("Jessica", 3, :tabby)
  @trevor = Cat.new("Trevor", 4, :persian)
  Cat.insert(@jessica.data)
  Cat.insert(@trevor.data)
end

When(/^I query for cats where name equals Jessica$/) do
  @results = Cat.where(:name).eq("Jessica").find
end

Then(/^only cats with a name of Jessica are returned$/) do
  @results.all? { |c| c.fetch('name') == 'Jessica' }
end
