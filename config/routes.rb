Rails.application.routes.draw do
  mount DceLti::Engine => "/lti"
end
