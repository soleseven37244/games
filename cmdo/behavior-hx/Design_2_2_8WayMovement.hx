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



class Design_2_2_8WayMovement extends ActorScript
{
	public var _DownControl:String;
	public var _LeftControl:String;
	public var _RightControl:String;
	public var _MoveX:Float;
	public var _MoveY:Float;
	public var _NormalizeDiagonalSpeed:Bool;
	public var _Sqrt2:Float;
	public var _StopTurningWhileMoving:Bool;
	public var _UseControls:Bool;
	public var _Speed:Float;
	public var _UseAnimations:Bool;
	public var _UpAnimationIdle:String;
	public var _UpAnimation:String;
	public var _DownAnimationIdle:String;
	public var _DownAnimation:String;
	public var _LeftAnimationIdle:String;
	public var _LeftAnimation:String;
	public var _RightAnimationIdle:String;
	public var _RightAnimation:String;
	public var _PreferVerticalAnimtations:Bool;
	public var _UpControl:String;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_MoveUp():Void
	{
		_MoveY = asNumber(-1);
		propertyChanged("_MoveY", _MoveY);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_MoveDown():Void
	{
		_MoveY = asNumber(1);
		propertyChanged("_MoveY", _MoveY);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_MoveLeft():Void
	{
		_MoveX = asNumber(-1);
		propertyChanged("_MoveX", _MoveX);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_MoveRight():Void
	{
		_MoveX = asNumber(1);
		propertyChanged("_MoveX", _MoveX);
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Down Control", "_DownControl");
		nameMap.set("Actor", "actor");
		nameMap.set("Left Control", "_LeftControl");
		nameMap.set("Right Control", "_RightControl");
		nameMap.set("Move X", "_MoveX");
		_MoveX = 0.0;
		nameMap.set("Move Y", "_MoveY");
		_MoveY = 0.0;
		nameMap.set("Normalize Diagonal Speed", "_NormalizeDiagonalSpeed");
		_NormalizeDiagonalSpeed = true;
		nameMap.set("Sqrt2", "_Sqrt2");
		_Sqrt2 = 0.0;
		nameMap.set("Stop Turning While Moving", "_StopTurningWhileMoving");
		_StopTurningWhileMoving = true;
		nameMap.set("Use Controls", "_UseControls");
		_UseControls = true;
		nameMap.set("Speed", "_Speed");
		_Speed = 30.0;
		nameMap.set("Use Animations", "_UseAnimations");
		_UseAnimations = true;
		nameMap.set("Up Animation (Idle)", "_UpAnimationIdle");
		nameMap.set("Up Animation", "_UpAnimation");
		nameMap.set("Down Animation (Idle)", "_DownAnimationIdle");
		nameMap.set("Down Animation", "_DownAnimation");
		nameMap.set("Left Animation (Idle)", "_LeftAnimationIdle");
		nameMap.set("Left Animation", "_LeftAnimation");
		nameMap.set("Right Animation (Idle)", "_RightAnimationIdle");
		nameMap.set("Right Animation", "_RightAnimation");
		nameMap.set("Prefer Vertical Animtations", "_PreferVerticalAnimtations");
		_PreferVerticalAnimtations = false;
		nameMap.set("Up Control", "_UpControl");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_Sqrt2 = asNumber(Math.sqrt(2));
		propertyChanged("_Sqrt2", _Sqrt2);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_UseControls)
				{
					_MoveX = asNumber((asNumber(isKeyDown(_RightControl)) - asNumber(isKeyDown(_LeftControl))));
					propertyChanged("_MoveX", _MoveX);
					_MoveY = asNumber((asNumber(isKeyDown(_DownControl)) - asNumber(isKeyDown(_UpControl))));
					propertyChanged("_MoveY", _MoveY);
				}
				if((_NormalizeDiagonalSpeed && (!(_MoveX == 0) && !(_MoveY == 0))))
				{
					actor.setXVelocity(((_MoveX * _Speed) / _Sqrt2));
					actor.setYVelocity(((_MoveY * _Speed) / _Sqrt2));
				}
				else
				{
					actor.setXVelocity((_MoveX * _Speed));
					actor.setYVelocity((_MoveY * _Speed));
				}
				if((_StopTurningWhileMoving && (!(_MoveX == 0) || !(_MoveY == 0))))
				{
					actor.setAngularVelocity(Utils.RAD * (0));
				}
				_MoveX = asNumber(0);
				propertyChanged("_MoveX", _MoveX);
				_MoveY = asNumber(0);
				propertyChanged("_MoveY", _MoveY);
				if(_UseAnimations)
				{
					if(((actor.getXVelocity() == 0) && (actor.getYVelocity() == 0)))
					{
						if((actor.getAnimation() == _UpAnimation))
						{
							actor.setAnimation("" + _UpAnimationIdle);
						}
						else if((actor.getAnimation() == _DownAnimation))
						{
							actor.setAnimation("" + _DownAnimationIdle);
						}
						else if((actor.getAnimation() == _LeftAnimation))
						{
							actor.setAnimation("" + _LeftAnimationIdle);
						}
						else if((actor.getAnimation() == _RightAnimation))
						{
							actor.setAnimation("" + _RightAnimationIdle);
						}
					}
					else if(((actor.getYVelocity() < 0) && ((actor.getXVelocity() == 0) || _PreferVerticalAnimtations)))
					{
						actor.setAnimation("" + _UpAnimation);
					}
					else if(((actor.getYVelocity() > 0) && ((actor.getXVelocity() == 0) || _PreferVerticalAnimtations)))
					{
						actor.setAnimation("" + _DownAnimation);
					}
					else if((actor.getXVelocity() < 0))
					{
						actor.setAnimation("" + _LeftAnimation);
					}
					else if((actor.getXVelocity() > 0))
					{
						actor.setAnimation("" + _RightAnimation);
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}