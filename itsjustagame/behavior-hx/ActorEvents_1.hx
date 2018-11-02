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
	public var _HP:Float;
	
	
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
		nameMap.set("HP", "_HP");
		_HP = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_HP = asNumber(600);
		propertyChanged("_HP", _HP);
		if((getCurrentSceneName() == "arena 4"))
		{
			_HP = asNumber(100000);
			propertyChanged("_HP", _HP);
		}
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("death", 0);
		Engine.engine.setGameAttribute("power", 0);
		
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
						actor.setAnimation("" + "Animation 5");
					}
					else if((_FacingRight == false))
					{
						actor.setAnimation("" + "Idle Left");
					}
					if((actor.getXVelocity() == 0))
					{
						actor.setAnimation("" + "Idle right");
					}
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((getCurrentSceneName() == "arena 4"))
				{
					actor.enableRotation();
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.drawString("" + _HP, 15, 15);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(22), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_HP -= 2;
				propertyChanged("_HP", _HP);
				if((event.otherFromLeft || event.otherFromRight))
				{
					actor.setFriction(0);
				}
				else
				{
					actor.setFriction(1);
				}
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((Engine.engine.getGameAttribute("death") == 1))
				{
					actor.setAnimation("" + "Animation 6");
				}
				if((_HP <= 0))
				{
					Engine.engine.setGameAttribute("death", 1);
				}
				if((actor.isAlive() == false))
				{
					Engine.engine.setGameAttribute("death", 1);
				}
				if(((getCurrentSceneName() == "arena 2") && (_HP <= 0)))
				{
					Engine.engine.setGameAttribute("death", 2);
				}
				if((Engine.engine.getGameAttribute("death") == 2))
				{
					actor.setAnimation("" + "Animation 6");
				}
				if(((getCurrentSceneName() == "arena 3") && (_HP <= 0)))
				{
					Engine.engine.setGameAttribute("death", 3);
				}
				if((Engine.engine.getGameAttribute("death") == 3))
				{
					actor.setAnimation("" + "Animation 6");
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("p1shoot", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				createRecycledActor(getActorType(10), actor.getX(), actor.getY(), Script.MIDDLE);
				if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
				{
					getLastCreatedActor().setXVelocity(-80);
				}
				else
				{
					getLastCreatedActor().setXVelocity(80);
				}
				if((Engine.engine.getGameAttribute("power") == 1))
				{
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 16), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(10), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 8), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
				}
				if((Engine.engine.getGameAttribute("power") == 2))
				{
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(10), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-70);
					}
					else
					{
						getLastCreatedActor().setXVelocity(70);
					}
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-60);
					}
					else
					{
						getLastCreatedActor().setXVelocity(60);
					}
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-50);
					}
					else
					{
						getLastCreatedActor().setXVelocity(50);
					}
				}
				if((Engine.engine.getGameAttribute("power") == 3))
				{
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(10), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-70);
					}
					else
					{
						getLastCreatedActor().setXVelocity(70);
					}
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-60);
					}
					else
					{
						getLastCreatedActor().setXVelocity(60);
					}
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-50);
					}
					else
					{
						getLastCreatedActor().setXVelocity(50);
					}
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-40);
					}
					else
					{
						getLastCreatedActor().setXVelocity(40);
					}
					createRecycledActor(getActorType(10), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-30);
					}
					else
					{
						getLastCreatedActor().setXVelocity(30);
					}
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-28);
					}
					else
					{
						getLastCreatedActor().setXVelocity(20);
					}
					createRecycledActor(getActorType(10), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-24);
					}
					else
					{
						getLastCreatedActor().setXVelocity(24);
					}
				}
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((event.thisFromLeft || event.thisFromRight))
				{
					actor.setFriction(0);
				}
				else
				{
					actor.setFriction(1);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addActorTypeGroupPositionListener(getActorType(1).ID, function(a:Actor, enteredScreen:Bool, exitedScreen:Bool, enteredScene:Bool, exitedScene:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && exitedScene)
			{
				if((getCurrentSceneName() == "Level 1"))
				{
					Engine.engine.setGameAttribute("death", 1);
				}
				else if((getCurrentSceneName() == "arena 2"))
				{
					Engine.engine.setGameAttribute("death", 1);
				}
				if((getCurrentSceneName() == "arena 3"))
				{
					Engine.engine.setGameAttribute("death", 1);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(7), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((event.thisFromLeft || event.thisFromRight))
				{
					actor.setFriction(0);
				}
				else
				{
					actor.setFriction(1);
				}
				_HP -= 2;
				propertyChanged("_HP", _HP);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}