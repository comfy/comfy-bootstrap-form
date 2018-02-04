# ComfyBootstrapForm

**bootstrap_form** is a Rails form builder that makes it super easy to integrate
[Bootstrap 4](https://getbootstrap.com/) forms into your Rails application.

[![Gem Version](https://img.shields.io/gem/v/comfy_bootstrap_form.svg?style=flat)](http://rubygems.org/gems/comfy_bootstrap_form)
[![Gem Downloads](https://img.shields.io/gem/dt/comfy_bootstrap_form.svg?style=flat)](http://rubygems.org/gems/comfy_bootstrap_form)
[![Build Status](https://img.shields.io/travis/comfy/comfy-bootstrap-form.svg?style=flat)](https://travis-ci.org/comfy/comfy-bootstrap-form)
[![Dependency Status](https://img.shields.io/gemnasium/comfy/comfy-bootstrap-form.svg?style=flat)](https://gemnasium.com/comfy/comfy-bootstrap-form)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/comfy/comfy-bootstrap-form.svg?style=flat)](https://codeclimate.com/github/comfy/comfy-bootstrap-form)
[![Coverage Status](https://img.shields.io/coveralls/comfy/comfy-bootstrap-form.svg?style=flat)](https://coveralls.io/r/comfy/comfy-bootstrap-form?branch=master)
[![Gitter](https://badges.gitter.im/comfy/comfortable-mexican-sofa.svg)](https://gitter.im/comfy/comfortable-mexican-sofa)

## Requirements

- Rails 5.2+
- Bootstrap 4.0.0+

## Installation

Add gem to your Gemfile and run `bundle install`

```ruby
gem "comfy_bootstrap_form", "~> 4.0.0"
```

## Usage

Here's a simple example:

```erb
<%= bootstrap_form_with model: @user do |f| %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.check_box :remember_me %>
  <%= f.submit "Log In" %>
<% end %>
```

This will generate HTML similar to this:

```html
<form action="/users" accept-charset="UTF-8" data-remote="true" method="post">
  <input name="utf8" type="hidden" value="&#x2713;" />
  <input type="hidden" name="authenticity_token" value="AUTH_TOKEN" />
  <div class="form-group">
    <label for="user_email">Email</label>
    <input class="form-control" type="email" name="user[email]" id="user_email" />
  </div>
  <div class="form-group">
    <label for="user_password">Password</label>
    <input class="form-control" type="password" name="user[password]" id="user_password" />
  </div>
  <fieldset class="form-group">
    <div class="form-check">
      <input name="user[remember_me]" type="hidden" value="0" />
      <input class="form-check-input" type="checkbox" value="1" name="user[remember_me]" id="user_remember_me" />
      <label class="form-check-label" for="user_remember_me">Remember me</label>
    </div>
  </fieldset>
  <div class="form-group">
    <input type="submit" name="commit" value="Log In" class="btn" data-disable-with="Log In" />
  </div>
</form>
```

## Supported form field helpers

This gem wraps most of the default form field helpers. Here's the current list:

```
color_field     file_field      phone_field   text_field
date_field      month_field     range_field   time_field
datetime_field  number_field    search_field  url_field
email_field     password_field  text_area     week_field
```

Helpers for DateTime selects are not implemented as it's better to choose one of
many Javascript timepickers out there. For example, [Flatpickr](https://github.com/chmln/flatpickr)
is a good one.

Singular `radio_button` is not implemented as it doesn't make sense to wrap one
radio button input in Bootstrap markup.

### Radio Buttons and Checkboxes

To render collection of radio buttons or checkboxes there are two corresponding
helpers:

```erb
<%= form.check_boxes :choices, ["red", "green", "blue"] %>
<%= form.radio_buttons :choices, ["mild", "hot", "lava"] %>
```

You can define custom labels by sending tuples:

```erb
<%= form.check_boxes :choices, [["yes", "Yay"], ["no", "Nay"]] %>
```

You may choose to render inputs inline:

```erb
<%= form.check_boxes :choices, ["red", "green", "blue"], bootstrap: {inline: true} %>
```

### Submit

Submit button is automatically wrapped with Bootstrap markup. Here's how it looks:

```erb
<%= form.submit %>
<%= form.submit "Submit" %>
<%= form.primary %>
```

You can also pass in a block of content that will be appended next to the button:

```erb
<%= form.submit "Save" do %>
  <a href="/" class="btn btn-link">Cancel</a>
<% end %>
```

### Plaintext helper

There's an additional field helper that render read-only plain text values:

```erb
<%= form.plaintext :value %>
```

## Bootstrap options

### Form

By default form is rendered as a stack. Labels are above inputs, and inputs
take up 100% of the width.

### Horizontal Form

You can change form layout to `horizontal` to put labels and corresponding
inputs side by side:

```erb
<%= bootstrap_form_with model: @user, bootstrap: {layout: :horizontal} do |form|
  <%= form.text_field :email %>
<% end %>
```

There are options that control column width and label alignment. Here's how it
would look with all the defaults:

```erb
<%
bootstrap_options = {
  layout:             "horizontal",
  label_col_class:    "col-sm-2",
  control_col_class:  "col-sm-10",
  label_align_class:  "text-sm-right"
}
%>
<%= bootstrap_form_with model: @user, bootstrap: bootstrap_options do |form|
  <%= form.text_field :email %>
<% end %>
```

### Inline Form

You may choose to render form elements in one line. Please note that this layout
won't render all form elements. Things like errors messages won't show up right.

```erb
<%= bootstrap_form_with url: "/search" do |form|
  <%= form.text_field :query %>
  <%= form.submit "Search" %>
<% end %>
```

### Inputs

- label
- help
- prepend/append

#### Gotchas

For inline radio buttons and check boxes you need to add custom css for error
messages show up (see: https://github.com/twbs/bootstrap/issues/25540):

```css
.invalid-feeback {
  display: block
}
```

---

Copyright 2018 Oleg Khabarov, Released under the [MIT License](LICENCE.md)
