Rails.application.routes.draw do
  get 'petpage', to: 'chessboards#petpage'
  get '*path', to: 'chessboards#svg', format: :svg
end
