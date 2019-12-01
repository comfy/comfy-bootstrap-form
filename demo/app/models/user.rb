class User < ActiveRecord::Base
  if Rails.version >= "6.0"
    has_rich_text :rich_content
  end
end
