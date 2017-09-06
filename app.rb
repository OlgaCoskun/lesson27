#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

#делаем функцию для добавления парикмахера, но только один раз без повторений
def is_barber_exists? db, name
  db.execute('select * from barbers where name=?', [name]).length > 0
end

#наполнение базы данных
def seed_db db, barbers
  barbers.each do |barber|
    if !is_barber_exists? db, barber
      db.execute 'insert into barbers (name) values (?)', [barber]
  end

end
end

def get_db
  db = SQLite3::Database.new 'barber.db'
  db.results_as_hash = true
  return db
end


before do
  db = get_db
  #db = SQLite3::Database.new 'barber.db'
  @barbers = db.execute 'select * from barbers'
end



configure do
  #db = get_db
  db = SQLite3::Database.new 'barber.db'
  db.execute 'CREATE TABLE IF NOT EXISTS `users` (
  `ID`  INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
  `Name`  TEXT,
  `Phone` TEXT,
  `DataStamp` TEXT,
  `Barber`  INTEGER
  )'
  db.execute 'CREATE TABLE IF NOT EXISTS `barbers` (
    `id`  INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    `name`  TEXT
  )'

  seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehr']

end


get '/' do
  erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end


get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  erb :contacts
end

post '/visit' do
  @name = params[:name]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]

  hh = {:name => 'Введите имя',
      :phone => 'Введите телефон',
      :datetime => 'Введите дату и время'}

  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

    if @error != ''
      return erb :visit
    end

    db = get_db
    db = SQLite3::Database.new 'barber.db'
    db.execute 'insert into users (
      name,
      phone,
      datastamp,
      barber
      )
    values ( ?, ?, ?, ?)', [@name, @phone, @datetime, @barber]
    erb "OK, name is #{@name}, #{@phone}, #{@datetime}, #{@barber}"

  end


get '/showusers' do
  #db = get_db
  db = SQLite3::Database.new 'barber.db'
  db.results_as_hash = true
  @results = db.execute 'select * from users order by ID desc'
  erb :showusers
end
