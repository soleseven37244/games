package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class ActorEvents_1 extends ActorScript
{
	public var _FacingRight:Bool;
	public var _touchfloor:Bool;
	public var _Move:Float;
	public var _Jump:Bool;
	public var _UseControls:Bool;
	public var _RunningForce:Float;
	public var _MaximumRunningSpeed:Float;
	public var _Jumping:Bool;
	public var _JumpHigher:Bool;
	public var _VariableJumpDuration:Float;
	public var _VariableJump:Bool;
	public var _JumpingForce:Float;
	public var _OnGround:Bool;
	public var _FacingLeft:Bool;
	public var _JumpLeftAnimation:String;
	public var _JumpRightAnimation:String;
	public var _JumpAnimationWhenFalling:Bool;
	public var _RunLeftAnimation:String;
	public var _RunRightAnimation:String;
	public var _IdleLeftAnimation:String;
	public var _IdleRightAnimation:String;
	public var _WasJump:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Facing Right", "_FacingRight");
		_FacingRight = true;
		nameMap.set("touchfloor", "_touchfloor");
		_touchfloor = false;
		nameMap.set("Move", "_Move");
		_Move = 0.0;
		nameMap.set("Jump", "_Jump");
		_Jump = false;
		nameMap.set("Use Controls", "_UseControls");
		_UseControls = true;
		nameMap.set("Running Force", "_RunningForce");
		_RunningForce = 50.0;
		nameMap.set("Maximum Running Speed", "_MaximumRunningSpeed");
		_MaximumRunningSpeed = 15.0;
		nameMap.set("Jumping", "_Jumping");
		_Jumping = false;
		nameMap.set("Jump Higher", "_JumpHigher");
		_JumpHigher = false;
		nameMap.set("Variable Jump Duration", "_VariableJumpDuration");
		_VariableJumpDuration = 0.2;
		nameMap.set("Variable Jump", "_VariableJump");
		_VariableJump = false;
		nameMap.set("Jumping Force", "_JumpingForce");
		_JumpingForce = 25.0;
		nameMap.set("On Ground", "_OnGround");
		_OnGround = false;
		nameMap.set("Facing Left", "_FacingLeft");
		_FacingLeft = false;
		nameMap.set("Jump Left Animation", "_JumpLeftAnimation");
		nameMap.set("Jump Right Animation", "_JumpRightAnimation");
		nameMap.set("Jump Animation When Falling", "_JumpAnimationWhenFalling");
		_JumpAnimationWhenFalling = false;
		nameMap.set("Run Left Animation", "_RunLeftAnimation");
		nameMap.set("Run Right Animation", "_RunRightAnimation");
		nameMap.set("Idle Left Animation", "_IdleLeftAnimation");
		nameMap.set("Idle Right Animation", "_IdleRightAnimation");
		nameMap.set("Was Jump", "_WasJump");
		_WasJump = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(isKeyDown("Player 2 Left"))
				{
					actor.setXVelocity(-10);
					actor.setAnimation("" + "Walking Left");
					_FacingRight = false;
					propertyChanged("_FacingRight", _FacingRight);
				}
				else if(isKeyDown("Player 2 right"))
				{
					actor.setXVelocity(10);
					actor.setAnimation("" + "Walking Right");
					_FacingRight = true;
					propertyChanged("_FacingRight", _FacingRight);
				}
				else
				{
					actor.setXVelocity(0);
					if(_FacingRight)
					{
						actor.setAnimation("" + "Idle Right");
					}
					else if((_FacingRight == false))
					{
						actor.setAnimation("" + "Idle Left");
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}