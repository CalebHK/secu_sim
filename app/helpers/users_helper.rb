module UsersHelper
  
   # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  def edu_option
    [
      ['---Select your education level---', nil],
      ['Primary School', 'Primary School'],
      ['Secondary School', 'Secondary School'],
      ['Undergraduate', 'Undergraduate'],
      ['Postgraduate', 'Postgraduate']
    ]
  end
  
  def gender_option
    [
      ['---Select your gender---', nil],
      ['Female', 'Female'],
      ['Male', 'Male']
    ]
  end
  
  def marital_option
    [
      ['---Select your marital status---', nil],
      ['Single', 'Single'],
      ['Married', 'Married']
    ]
  end
end