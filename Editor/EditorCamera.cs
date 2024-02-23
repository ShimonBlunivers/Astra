using Godot;
using System;
using System.Drawing;

public partial class EditorCamera : Camera2D
{

	public const float Speed = 400.0f;
	public const float RunSpeedModifier = 800.0f;

	public const float ZoomSpeed = 0.1f;
	public const float MaxZoom = 10.0f;
	public const float MinZoom = 0.2f;

	public bool locked = false;
	public override void _PhysicsProcess(double delta)
	{
		if (locked) return;
		Vector2 velocity;
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		float running = Input.GetActionStrength("game_run");

		if (direction != Vector2.Zero)
		{
			velocity.X = direction.X * (Speed + RunSpeedModifier * running);
			velocity.Y = direction.Y * (Speed + RunSpeedModifier * running);
			Position += new Vector2((float)(velocity.X * delta), (float)(velocity.Y * delta));
		}
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (locked) return;
		if (@event is InputEventMouseButton)
		{
			InputEventMouseButton emb = (InputEventMouseButton)@event;
			if (emb.IsPressed())
			{
				float zoomModifier = 0;

				if (emb.ButtonIndex == MouseButton.WheelDown)
				{
					if (Zoom.X > 1) zoomModifier = -1;
					else zoomModifier = -0.25f;
				}
				if (emb.ButtonIndex == MouseButton.WheelUp)
				{
					zoomModifier = 1;
				}
				float difference = zoomModifier * ZoomSpeed;
				float newValue = Mathf.Clamp(difference + Zoom.X, MinZoom, MaxZoom);
				Zoom = new Vector2(newValue, newValue);
			}
		}
	}
}
