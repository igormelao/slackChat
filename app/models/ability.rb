class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :read, Team do |t|
        t.user_id == user.id || t.users.where(id: user.id).present?
      end
      can :destroy, Team, user_id: user.id

      can [:create, :destroy], TeamUser do |t|
        t.team.user_id == user.id
      end

      can [:create], Channel do |c|
        c.team.user_id == user.id || c.team.users.where(id: user.id).present?
      end

    end
  end
end
