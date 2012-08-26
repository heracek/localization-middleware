class TestApp < Padrino::Application
  register Padrino::Helpers

  error 404 do
    '404 Error'
  end
end