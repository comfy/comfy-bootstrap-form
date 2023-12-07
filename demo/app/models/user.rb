class User < ActiveRecord::Base
  has_rich_text :rich_content
end
