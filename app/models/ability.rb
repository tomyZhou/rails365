class Ability
  include CanCan::Ability

  def initialize(user)

    if user.blank?
      cannot :manage, :all
      basic_read_only

    elsif user.super_admin?
      can :manage, :all

    else
      can [:read, :create], Article
      can [:update, :destroy], Article do |article|
        article.user_id == user.id
      end

      can :read, Group

    end

  end

protected

  def basic_read_only
    can :read, Article
    can :read, Group
  end

end
