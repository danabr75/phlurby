class User < GeneralObject
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # after_create :assign_default_role

  # def assign_default_role
  #   self.add_role(:newuser) if self.roles.blank?
  # end

  def active_for_authentication?
    #remember to call the super
    #then put our own check to determine "active" state using 
    #our own "is_active" column
    super and !self.disabled
  end

end
