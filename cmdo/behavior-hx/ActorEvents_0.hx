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



class ActorEvents_0 extends ActorScript
{
	public var _walkingspeed:Float;
	public var _facingright:Bool;
	public var _facingdown:Bool;
	public var _bulletspeed:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("walking speed", "_walkingspeed");
		_walkingspeed = 22.0;
		nameMap.set("facing right", "_facingright");
		_facingright = false;
		nameMap.set("facing down", "_facingdown");
		_facingdown = false;
		nameMap.set("bullet speed", "_bulletspeed");
		_bulletspeed = 50.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		engine.cameraFollow(actor);
		Engine.engine.setGameAttribute("player y", actor.getY());
		Engine.engine.setGameAttribute("player x", actor.getX());
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				engine.cameraFollow(actor);
				if((isKeyDown("down1") && isKeyDown("right1")))
				{
					actor.setAnimation("" + "Animation 13");
					actor.setXVelocity(_walkingspeed);
					actor.setYVelocity(_walkingspeed);
					_facingdown = true;
					propertyChanged("_facingdown", _facingdown);
					_facingright = true;
					propertyChanged("_facingright", _facingright);
				}
				else if((isKeyDown("down1") && isKeyDown("left1")))
				{
					actor.setXVelocity(-(_walkingspeed));
					actor.setYVelocity(_walkingspeed);
					_facingdown = true;
					propertyChanged("_facingdown", _facingdown);
					_facingright = false;
					propertyChanged("_facingright", _facingright);
					actor.setAnimation("" + "Animation 15");
				}
				else if((isKeyDown("up1") && isKeyDown("right1")))
				{
					actor.setXVelocity(_walkingspeed);
					actor.setYVelocity(-(_walkingspeed));
					_facingdown = false;
					propertyChanged("_facingdown", _facingdown);
					_facingright = true;
					propertyChanged("_facingright", _facingright);
					actor.setAnimation("" + "Animation 17");
				}
				else if((isKeyDown("up1") && isKeyDown("left1")))
				{
					actor.setXVelocity(-(_walkingspeed));
					actor.setYVelocity(-(_walkingspeed));
					_facingdown = false;
					propertyChanged("_facingdown", _facingdown);
					_facingright = false;
					propertyChanged("_facingright", _facingright);
					actor.setAnimation("" + "Animation 19");
				}
				else if(isKeyDown("right1"))
				{
					actor.setAnimation("" + "walk right");
					actor.setYVelocity(0);
					actor.setXVelocity(_walkingspeed);
					_facingright = true;
					propertyChanged("_facingright", _facingright);
				}
				else if(isKeyDown("left1"))
				{
					actor.setAnimation("" + "walk left");
					actor.setYVelocity(0);
					actor.setXVelocity(-(_walkingspeed));
					_facingright = false;
					propertyChanged("_facingright", _facingright);
				}
				else if(isKeyDown("up1"))
				{
					actor.setAnimation("" + "walk up");
					actor.setXVelocity(0);
					actor.setYVelocity(-100);
					_facingdown = false;
					propertyChanged("_facingdown", _facingdown);
				}
				else if(isKeyDown("down1"))
				{
					actor.setAnimation("" + "walk down");
					actor.setXVelocity(0);
					actor.setYVelocity(_walkingspeed);
					_facingdown = true;
					propertyChanged("_facingdown", _facingdown);
				}
				else
				{
					if((actor.getAnimation() == "walk up"))
					{
						actor.setAnimation("" + "idle up");
					}
					if((actor.getAnimation() == "walk right"))
					{
						actor.setAnimation("" + "idle right");
					}
					if((actor.getAnimation() == "walk left"))
					{
						actor.setAnimation("" + "idle left");
					}
					if((actor.getAnimation() == "walk down"))
					{
						actor.setAnimation("" + "idle down");
					}
					if((actor.getAnimation() == "Animation 13"))
					{
						actor.setAnimation("" + "Animation 14");
					}
					if((actor.getAnimation() == "Animation 16"))
					{
						actor.setAnimation("" + "Animation 16");
					}
					if((actor.getAnimation() == "Animation 17"))
					{
						actor.setAnimation("" + "Animation 18");
					}
					if((actor.getAnimation() == "Animation 19"))
					{
						actor.setAnimation("" + "Animation 20");
					}
					actor.setXVelocity(0);
					actor.setYVelocity(0);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(49), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				actor.setAnimation("" + "death");
				runLater(1000 * 0.6, function(timeTask:TimedTask):Void
				{
					recycleActor(actor);
					Engine.engine.setGameAttribute("player death", 1);
				}, actor);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(51), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				actor.setAnimation("" + "death");
				runLater(1000 * 0.6, function(timeTask:TimedTask):Void
				{
					Engine.engine.setGameAttribute("player death", 1);
				}, actor);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(65), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				actor.setAnimation("" + "death");
				runLater(1000 * 0.7, function(timeTask:TimedTask):Void
				{
					Engine.engine.setGameAttribute("player death", 1);
				}, actor);
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("a1", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				if((Engine.engine.getGameAttribute("grenade count") > 0))
				{
					actor.setAnimation("" + "Animation 12");
					runLater(1000 * 0.4, function(timeTask:TimedTask):Void
					{
						createRecycledActor(getActorType(7), actor.getX(), actor.getY(), Script.FRONT);
						getLastCreatedActor().applyImpulseInDirection(270, 30);
					}, actor);
					runLater(1000 * 0.5, function(timeTask:TimedTask):Void
					{
						actor.setAnimation("" + "idle up");
						Engine.engine.setGameAttribute("grenade count", (Engine.engine.getGameAttribute("grenade count") - 1));
					}, actor);
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("b", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				playSoundOnChannel(getSound(67), Std.int(2));
				createRecycledActor(getActorType(5), actor.getX(), actor.getY(), Script.FRONT);
				if(((actor.getAnimation() == "Animation 17") || (actor.getAnimation() == "Animation 18")))
				{
					getLastCreatedActor().setXVelocity(_bulletspeed);
					getLastCreatedActor().setYVelocity(-(_bulletspeed));
				}
				if(((actor.getAnimation() == "Animation 19") || (actor.getAnimation() == "Animation 20")))
				{
					getLastCreatedActor().setXVelocity(-(_bulletspeed));
					getLastCreatedActor().setYVelocity(-(_bulletspeed));
				}
				if(((actor.getAnimation() == "Animation 15") || (actor.getAnimation() == "Animation 16")))
				{
					getLastCreatedActor().setXVelocity(-(_bulletspeed));
					getLastCreatedActor().setYVelocity(_bulletspeed);
				}
				if(((actor.getAnimation() == "Animation 13") || (actor.getAnimation() == "Animation 14")))
				{
					getLastCreatedActor().setXVelocity(_bulletspeed);
					getLastCreatedActor().setYVelocity(_bulletspeed);
				}
				if(((actor.getAnimation() == "idle down") || (actor.getAnimation() == "walk down")))
				{
					getLastCreatedActor().setYVelocity(_bulletspeed);
				}
				if(((actor.getAnimation() == "idle right") || (actor.getAnimation() == "walk right")))
				{
					getLastCreatedActor().setXVelocity(_bulletspeed);
				}
				if(((actor.getAnimation() == "idle left") || (actor.getAnimation() == "walk left")))
				{
					getLastCreatedActor().setXVelocity(-(_bulletspeed));
				}
				if(((actor.getAnimation() == "idle up") || (actor.getAnimation() == "walk up")))
				{
					getLastCreatedActor().setYVelocity(-(_bulletspeed));
				}
				runLater(1000 * 0.2, function(timeTask:TimedTask):Void
				{
					stopSoundOnChannel(Std.int(2));
				}, actor);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}