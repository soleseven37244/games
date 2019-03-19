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



class ActorEvents_65 extends ActorScript
{
	public var _bosshealth:Float;
	public var _xspeed:Float;
	public var _bosstimer:Float;
	public var _collidinig:Bool;
	public var _isinvincible:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("boss health", "_bosshealth");
		_bosshealth = 0.0;
		nameMap.set("x speed", "_xspeed");
		_xspeed = 40.0;
		nameMap.set("boss timer", "_bosstimer");
		_bosstimer = 0.0;
		nameMap.set("collidinig", "_collidinig");
		_collidinig = false;
		nameMap.set("is invincible", "_isinvincible");
		_isinvincible = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_bosshealth = asNumber(40);
		propertyChanged("_bosshealth", _bosshealth);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				Engine.engine.setGameAttribute("debug", _bosshealth);
				actor.setXVelocity(_xspeed);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((_bosshealth <= 0))
				{
					recycleActor(actor);
				}
			}
		});
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * .1, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				_bosstimer = asNumber((_bosstimer - .1));
				propertyChanged("_bosstimer", _bosstimer);
				if((_bosstimer <= 0))
				{
					_xspeed = asNumber(-(_xspeed));
					propertyChanged("_xspeed", _xspeed);
					_bosstimer = asNumber(3);
					propertyChanged("_bosstimer", _bosstimer);
				}
			}
		}, actor);
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(7),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!(_collidinig))
				{
					_xspeed = asNumber(-(_xspeed));
					propertyChanged("_xspeed", _xspeed);
					_bosstimer = asNumber(3);
					propertyChanged("_bosstimer", _bosstimer);
					_collidinig = true;
					propertyChanged("_collidinig", _collidinig);
					runLater(1000 * .1, function(timeTask:TimedTask):Void
					{
						_collidinig = false;
						propertyChanged("_collidinig", _collidinig);
					}, actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(5), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_bosshealth -= 1;
				propertyChanged("_bosshealth", _bosshealth);
				recycleActor(event.otherActor);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(73), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!(_isinvincible))
				{
					_bosshealth -= 10;
					propertyChanged("_bosshealth", _bosshealth);
					_isinvincible = true;
					propertyChanged("_isinvincible", _isinvincible);
					runLater(1000 * 0.2, function(timeTask:TimedTask):Void
					{
						_isinvincible = false;
						propertyChanged("_isinvincible", _isinvincible);
					}, actor);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}