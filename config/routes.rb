Rails.application.routes.draw do
	
	# get 'static_pages/help'
	# get  'static_pages/about'
	root 'static_pages#home'
	get  '/help', to: 'static_pages#help'
	get  '/home', to: 'static_pages#home'
	get  '/about', to: 'static_pages#about'

end
