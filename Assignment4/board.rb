require 'sinatra'
require 'data_mapper'
require 'json'

DataMapper::setup(:default,"sqlite3://#{Dir.pwd}/board.db")

class Notice
  include DataMapper::Resource
  property :id,         Serial
  property :nick,       String, :required => true
  property :content,    Text, :required => true, :length => 140
  property :created_at, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do
  @notices=Notice.all(:order=>:created_at.desc)
  @title='All Notices'
  erb :home
end

post '/' do
  notice=Notice.new
  notice.nick = params[:nick]
  notice.content=params[:content]
  notice.created_at=Time.now.strftime("%a %b %d %Y %H:%M:%S %z %Y")
  notice.save
  redirect '/'
end

get '/notices' do
  content_type :json
  @notice=Notice.all(:order=> :created_at.desc)
  @notice.to_json
end

get '/users.:format' do
  content_type params[:format]
  @user=Notice.all
  if params[:format]=="json"
    @user.to_json(:only=>[:nick])
  else
    @user.to_xml(:only=>[:nick])
  end
end

get '/notices.:format' do
  content_type params[:format]
  @notice=Notice.all
  if params[:format]=="json"
    @notice.to_json
  else
    @notice.to_xml
  end
end

get '/:id' do
  @notice=Notice.get params[:id]
  @title="Edit notice ##{params[:id]}"
  erb :edit
end

put '/:id' do
  notice=Notice.get params[:id]
  notice.nick=params[:nick]
  notice.content=params[:content]
  notice.save
  redirect '/'
end

get '/:id/delete' do 
  @notice=Notice.get params[:id]
  @title="Confirmation of deletion of notice ##{params[:id]}"
  erb :delete
end

delete '/:id' do
  notice=Notice.get params[:id]
  notice.destroy
  redirect '/'
end

