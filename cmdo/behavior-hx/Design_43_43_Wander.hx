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



class Design_43_43_Wander extends ActorScript
{
	public var _MinimumMovingTime:Float;
	public var _MaximumMovingTime:Float;
	public var _MinimumWaitingTime:Float;
	public var _MaximumWaitingTime:Float;
	public var _StartwithWaiting:Bool;
	public var _MaximumSpeed:Float;
	public var _Wait:Bool;
	public var _Move:Bool;
	public var _MinimumSpeed:Float;
	public var _ChangeDirectionwhenColliding:Bool;
	public var _SpeedX:Float;
	public var _SpeedY:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Minimum Moving Time", "_MinimumMovingTime");
		_MinimumMovingTime = 1.0;
		nameMap.set("Maximum Moving Time", "_MaximumMovingTime");
		_MaximumMovingTime = 2.0;
		nameMap.set("Minimum Waiting Time", "_MinimumWaitingTime");
		_MinimumWaitingTime = 1.0;
		nameMap.set("Maximum Waiting Time", "_MaximumWaitingTime");
		_MaximumWaitingTime = 2.0;
		nameMap.set("Start with Waiting", "_StartwithWaiting");
		_StartwithWaiting = true;
		nameMap.set("Maximum Speed", "_MaximumSpeed");
		_MaximumSpeed = 10.0;
		nameMap.set("Wait", "_Wait");
		_Wait = false;
		nameMap.set("Move", "_Move");
		_Move = false;
		nameMap.set("Minimum Speed", "_MinimumSpeed");
		_MinimumSpeed = 5.0;
		nameMap.set("Change Direction when Colliding", "_ChangeDirectionwhenColliding");
		_ChangeDirectionwhenColliding = true;
		nameMap.set("Speed X", "_SpeedX");
		_SpeedX = 0.0;
		nameMap.set("Speed Y", "_SpeedY");
		_SpeedY = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_Wait = _StartwithWaiting;
		propertyChanged("_Wait", _Wait);
		_Move = !(_StartwithWaiting);
		propertyChanged("_Move", _Move);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_Wait)
				{
					_Wait = false;
					propertyChanged("_Wait", _Wait);
					runLater(1000 * (_MinimumWaitingTime + (randomFloat() * (_MaximumWaitingTime - _MinimumWaitingTime))), function(timeTask:TimedTask):Void
					{
						_Move = true;
						propertyChanged("_Move", _Move);
					}, actor);
					actor.setVelocity(0, 0);
					_SpeedX = asNumber(0);
					propertyChanged("_SpeedX", _SpeedX);
					_SpeedY = asNumber(0);
					propertyChanged("_SpeedY", _SpeedY);
				}
				if(_Move)
				{
					_Move = false;
					propertyChanged("_Move", _Move);
					runLater(1000 * (_MinimumMovingTime + (randomFloat() * (_MaximumMovingTime - _MinimumMovingTime))), function(timeTask:TimedTask):Void
					{
						_Wait = true;
						propertyChanged("_Wait", _Wait);
					}, actor);
					actor.setVelocity(randomInt(Math.floor(-180), Math.floor(180)), randomInt(Math.floor(_MinimumSpeed), Math.floor(_MaximumSpeed)));
					_SpeedX = asNumber(actor.getXVelocity());
					propertyChanged("_SpeedX", _SpeedX);
					_SpeedY = asNumber(actor.getYVelocity());
					propertyChanged("_SpeedY", _SpeedY);
				}
			}
		});
		
		/* ======================== Something Else ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_ChangeDirectionwhenColliding)
				{
					if((event.thisFromLeft || event.thisFromRight))
					{
						actor.setXVelocity(-(_SpeedX));
					}
					if((event.thisFromTop || event.thisFromBottom))
					{
						actor.setYVelocity(-(_SpeedY));
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}