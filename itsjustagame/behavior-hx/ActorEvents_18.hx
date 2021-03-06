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



class ActorEvents_18 extends ActorScript
{
	public var _FacingRight:Bool;
	public var _HP:Float;
	public var _HP2:Actor;
	public var _HP3:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Facing Right", "_FacingRight");
		_FacingRight = true;
		nameMap.set("HP", "_HP");
		_HP = 0.0;
		nameMap.set("HP2", "_HP2");
		nameMap.set("HP3", "_HP3");
		_HP3 = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("power 3", 0);
		_HP3 = asNumber(600);
		propertyChanged("_HP3", _HP3);
		if((getCurrentSceneName() == "arena 4"))
		{
			_HP3 = asNumber(100000);
			propertyChanged("_HP3", _HP3);
			actor.enableRotation();
		}
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(isKeyDown("p3 left"))
				{
					actor.setXVelocity(-10);
					actor.setAnimation("" + "Walking Left");
					_FacingRight = false;
					propertyChanged("_FacingRight", _FacingRight);
				}
				else if(isKeyDown("p3 right"))
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
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.drawString("" + _HP3, 15, 15);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((Engine.engine.getGameAttribute("death 3") == 1))
				{
					actor.setAnimation("" + "Animation 6");
				}
				if((_HP3 <= 0))
				{
					Engine.engine.setGameAttribute("death 3", 1);
				}
				if((actor.isAlive() == false))
				{
					Engine.engine.setGameAttribute("death 3", 1);
				}
				if(((getCurrentSceneName() == "arena 2") && (_HP <= 0)))
				{
					Engine.engine.setGameAttribute("death 3", 2);
				}
				if((Engine.engine.getGameAttribute("death 3") == 2))
				{
					actor.setAnimation("" + "Animation 6");
				}
				if(((getCurrentSceneName() == "arena 3") && (_HP <= 0)))
				{
					Engine.engine.setGameAttribute("death 3", 3);
				}
				if((Engine.engine.getGameAttribute("death 3") == 3))
				{
					actor.setAnimation("" + "Animation 6");
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("p3 shoot", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				createRecycledActor(getActorType(22), actor.getX(), actor.getY(), Script.MIDDLE);
				if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
				{
					getLastCreatedActor().setXVelocity(-80);
				}
				else
				{
					getLastCreatedActor().setXVelocity(80);
				}
				if((Engine.engine.getGameAttribute("power 3") == 1))
				{
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 16), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(22), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 8), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
				}
				if((Engine.engine.getGameAttribute("power 3") == 2))
				{
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(22), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-70);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-60);
					}
					else
					{
						getLastCreatedActor().setXVelocity(60);
					}
				}
				if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
				{
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					getLastCreatedActor().setXVelocity(-50);
				}
				else
				{
					getLastCreatedActor().setXVelocity(60);
				}
				if((Engine.engine.getGameAttribute("power 3") == 3))
				{
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-80);
					}
					else
					{
						getLastCreatedActor().setXVelocity(80);
					}
					createRecycledActor(getActorType(22), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-70);
					}
					else
					{
						getLastCreatedActor().setXVelocity(70);
					}
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-60);
					}
					else
					{
						getLastCreatedActor().setXVelocity(60);
					}
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-50);
					}
					else
					{
						getLastCreatedActor().setXVelocity(50);
					}
					createRecycledActor(getActorType(22), actor.getX(), actor.getY(), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-40);
					}
					else
					{
						getLastCreatedActor().setXVelocity(40);
					}
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-30);
					}
					else
					{
						getLastCreatedActor().setXVelocity(30);
					}
					createRecycledActor(getActorType(22), actor.getX(), (actor.getY() + 0), Script.MIDDLE);
					if(((actor.getAnimation() == "Idle Left") || (actor.getAnimation() == "Walking Left")))
					{
						getLastCreatedActor().setXVelocity(-28);
					}
					else
					{
						getLastCreatedActor().setXVelocity(28);
					}
					createRecycledActor(getActorType(22), actor.getX(), actor.getY(), Script.MIDDLE);
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
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(4),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_HP3 -= 2;
				propertyChanged("_HP3", _HP3);
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
			if(wrapper.enabled && sameAsAny(getActorType(10), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_HP3 -= 2;
				propertyChanged("_HP3", _HP3);
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
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}