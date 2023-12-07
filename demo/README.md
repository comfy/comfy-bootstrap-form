# DEMO APP (Rails 7)

### Usage

- `bundle`
- `cd demo/`
- `./bin/rails db:schema:load`
- `./bin/rails s`
- Navigate to http://localhost:3000
- Start changing stuff in [/demo/app/views/bootstrap/form.html.erb](/demo/app/views/bootstrap/form.html.erb)

### Following files were added or changed:

- db/schema.rb
- config/{routes, boot}.rb
- app/models/user.rb
- app/controllers/bootstrap_controller.rb
- app/views/layouts/application.html.erb
- app/views/bootstrap/form.html.erb
