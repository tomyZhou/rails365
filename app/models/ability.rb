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
      can :read, Book
      can :read, Movie
      can :like, Movie
      can :read, Playlist
    end
  end

  protected

  def basic_read_only
    can :read, Article
    can :read, Group
    can :read, App
    can :read, Book
    can :read, Movie
    can :read, Playlist
  end
end
