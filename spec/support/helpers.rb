Dir.glob(Rails.root.join('spec/support/helpers/**/*').to_s).each do |r|
  require r
end
