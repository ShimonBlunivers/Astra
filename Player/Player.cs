using Godot;
using System;
public partial class Player : CharacterBody2D
{
	public const float Speed = 400.0f;
	public const float RunSpeedModifier = 100.0f;
	public const float JumpVelocity = -400.0f;

	private AnimatedSprite2D _animatedSprite;

	public override void _Ready()
	{
		_animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		_animatedSprite.Play("Idle");
	}
	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		float running = Input.GetActionStrength("ui_run");

		if (direction != Vector2.Zero)
		{
			velocity.X = direction.X * (Speed + RunSpeedModifier * running);
			velocity.Y = direction.Y * (Speed + RunSpeedModifier * running);

			if (velocity.X < 0)
			{
				_animatedSprite.FlipH = true;
				_animatedSprite.Play("WalkToSide");
			}
			else if (velocity.X > 0)
			{
				_animatedSprite.FlipH = false;
				_animatedSprite.Play("WalkToSide");
			}
			else if (velocity.Y < 0) _animatedSprite.Play("WalkUp");
			else if (velocity.Y > 0) _animatedSprite.Play("WalkDown");
		}
		else
		{
			if (velocity != Vector2.Zero) { _animatedSprite.Play("Idle");}
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Y = Mathf.MoveToward(Velocity.Y, 0, Speed);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}
