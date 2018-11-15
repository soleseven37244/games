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



class ActorEvents_3 extends ActorScript
{
	public var _FacingRight:Bool;
	public var _touchfloor:Bool;
	public var _OnGround:Bool;
	public var _HP1:Float;
	public var _HP:Float;
	public var _crouchright:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Facing Right", "_FacingRight");
		_FacingRight = true;
		nameMap.set("touchfloor", "_touchfloor");
		_touchfloor = false;
		nameMap.set("On Ground", "_OnGround");
		_OnGround = false;
		nameMap.set("HP1", "_HP1");
		_HP1 = 0.0;
		nameMap.set("HP", "_HP");
		_HP = 0.0;
		nameMap.set("crouch right", "_crouchright");
		_crouchright = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.setAnimation("" + "Idle right");
		Engine.engine.setGameAttribute("power1", 0);
		_HP1 = asNumber(600);
		propertyChanged("_HP1", _HP1);
		if((getCurrentSceneName() == "arena 4"))
		{
			_HP = asNumber(10000);
			propertyChanged("_HP", _HP);
		}
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(isKeyDown("left"))
				{
					actor.setXVelocity(-10);
					actor.setAnimation("" + "Walking Left");
					_FacingRight = false;
					propertyChanged("_FacingRight", _FacingRight);
				}
				else if(isKeyDown("right"))
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
						actor.setAnimation("" + "Idle right");
					}
					else if((_FacingRight == false))
					{
						actor.setAnimation("" + "Idle left");
					}
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("p2shoot", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				createRecycledActor(getActorType(7), actor.getX(), actor.getY(), Script.MIDDLE);
				if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
				{
					getLastCreatedActor().setXVelocity(-80);
				}
				else
				{
					getLastCreatedActor().setXVelocity(80);
				}
				if((Engine.engine.getGameAttribute("power1") == 1))
				{
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 16), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(7), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 8), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
				}
				if((Engine.engine.getGameAttribute("power1") == 2))
				{
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(7), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-70);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-60);
					}
					else
					{
						getLastCreatedActor().setXVelocity(60);
					}
				}
				if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
				{
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					getLastCreatedActor().setXVelocity(-50);
				}
				else
				{
					getLastCreatedActor().setXVelocity(60);
				}
				if((Engine.engine.getGameAttribute("power1") == 3))
				{
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(7), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-70);
					}
					else
					{
						getLastCreatedActor().setXVelocity(70);
					}
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-60);
					}
					else
					{
						getLastCreatedActor().setXVelocity(60);
					}
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-50);
					}
					else
					{
						getLastCreatedActor().setXVelocity(50);
					}
					createRecycledActor(getActorType(7), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-40);
					}
					else
					{
						getLastCreatedActor().setXVelocity(40);
					}
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-30);
					}
					else
					{
						getLastCreatedActor().setXVelocity(30);
					}
					createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-28);
					}
					else
					{
						getLastCreatedActor().setXVelocity(28);
					}
					createRecycledActor(getActorType(7), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle left") || (actor.getAnimation() == "Walking Left")))
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
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(10), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_HP1 -= 2;
				propertyChanged("_HP1", _HP1);
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
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(22), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_HP1 -= 2;
				propertyChanged("_HP1", _HP1);
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
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.drawString("" + _HP1, 15, 15);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((_HP1 <= 0))
				{
					Engine.engine.setGameAttribute("death 2", 1);
					actor.setAnimation("" + "Animation 6");
				}
				if((_HP1 <= 0))
				{
					Engine.engine.setGameAttribute("death 2", 1);
				}
				if(((getCurrentSceneName() == "arena 2") && (_HP1 <= 0)))
				{
					Engine.engine.setGameAttribute("death 2", 2);
				}
				if((Engine.engine.getGameAttribute("death 2") == 2))
				{
					actor.setAnimation("" + "Animation 6");
				}
				if(((getCurrentSceneName() == "arena 3") && (_HP1 <= 0)))
				{
					Engine.engine.setGameAttribute("death 2", 3);
					actor.setAnimation("" + "Animation 6");
				}
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
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
				if((getCurrentSceneName() == "arena 4"))
				{
					actor.enableRotation();
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}