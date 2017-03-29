class User < ApplicationRecord
  
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
                    
  has_secure_password
  
  @@edu_option = [['---Select your education level---', nil],
                  ['Primary School', 'Primary School'],
                  ['Secondary School', 'Secondary School'],
                  ['Undergraduate', 'Undergraduate'],
                  ['Postgraduate', 'Postgraduate']]
                  
  @@gender_option =  [['---Select your gender---', nil],
                      ['Female', 'Female'],
                      ['Male', 'Male']]
                      
  @@marital_option =  [['---Select your marital status---', nil],
                       ['Single', 'Single'],
                       ['Married', 'Married']]
    
  def self.edu_option
    @@edu_option
  end
  
  def self.gender_option
    @@gender_option
  end
  
  def self.marital_option
    @@marital_option
  end
end
