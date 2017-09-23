class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :read, Team do |t|
        t.user_id == user.id
      end
      can :destroy, Team, user_id: user.id
    end
  end
end
