class Api::V1::SessionsController < ::DeviseTokenAuth::SessionsController
    protect_from_forgery
  
    wrap_parameters format: []
end