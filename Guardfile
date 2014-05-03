guard 'nanoc' do
  watch 'nanoc.yaml'
  watch 'Rules'
  watch %r{\A(content|layouts|lib|static)/.*\z}
  ignore %r{(?:4913)$}
  notification :off
end
