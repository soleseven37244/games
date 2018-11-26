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



class Design_3_3_HealthManager extends ActorScript
{
	public var _StartingHealth:Float;
	public var _MaximumHealth:Float;
	public var _CurrentHealth:Float;
	public var _HealedMessage:String;
	public var _DamagedMessage:String;
	public var _ZeroHealthAction:String;
	public var _Invincible:Bool;
	public var _DelayBetweenDamage:Float;
	public var _CanBeDamaged:Bool;
	public var _PersistentHealth:Bool;
	public var _HealthGameAttribute:String;
	public var _HealthIdentifier:String;
	public var _DamageSound:Sound;
	public var _DeathSound:Sound;
	public var _HealSound:Sound;
	public var _Spawned:Bool;
	public var xOffset:Float;
	public var yOffset:Float;
	public var _SpawnedActor:Actor;
	public var lifespan:Float;
	public var _SpawnActorOnDeath:Bool;
	public var _ActorTypeToSpawn:ActorType;
	public var _PercentLeft:Float;
	public var _DrawingLocation:String;
	public var _HealthBarXOffset:Float;
	public var _HealthBarOutlineSize:Float;
	public var _HealthBarYOffset:Float;
	public var _HealthBarWidth:Float;
	public var _HealthBarHeight:Float;
	public var _HealthBarOrientation:String;
	public var _HealthBarOutlineColour:Int;
	public var _ColourOver75:Int;
	public var _ColourOver50:Int;
	public var _ColourOver25:Int;
	public var _ColourUnder25:Int;
	public var _HealthBarBackgroundColour:Int;
	public var _DrawHealthBar:Bool;
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_Damage(__Amount:Float):Void
	{
		var __Self:Actor = actor;
		/* Don't take any damage if we're invincible */
		if(((_Invincible || !(_CanBeDamaged)) || (_CurrentHealth <= 0)))
		{
			return;
		}
		/* Make sure health doesn't drop below zero */
		_CurrentHealth = asNumber(Math.max((_CurrentHealth - __Amount), 0));
		propertyChanged("_CurrentHealth", _CurrentHealth);
		_customEvent_UpdateGlobalHealth();
		/* Check if Actor has depleted its health */
		if((_CurrentHealth <= 0))
		{
			if(_SpawnActorOnDeath)
			{
				_customEvent_Death();
			}
			if((hasValue(_DeathSound)))
			{
				playSound(_DeathSound);
			}
			if((_ZeroHealthAction == "Kill"))
			{
				recycleActor(actor);
			}
		}
		else
		{
			if((hasValue(_DamagedMessage)))
			{
				actor.shout("_customEvent_" + _DamagedMessage);
			}
			if((hasValue(_DamageSound)))
			{
				playSound(_DamageSound);
			}
			/* Set up a delay so that the Actor can't be damaged again for this many seconds. */
			if((_DelayBetweenDamage > 0))
			{
				_CanBeDamaged = false;
				propertyChanged("_CanBeDamaged", _CanBeDamaged);
				runLater(1000 * _DelayBetweenDamage, function(timeTask:TimedTask):Void
				{
					if(actor.isAlive())
					{
						_CanBeDamaged = true;
						propertyChanged("_CanBeDamaged", _CanBeDamaged);
					}
				}, actor);
			}
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_Heal(__Amount:Float):Void
	{
		var __Self:Actor = actor;
		/* Make sure health doesn't exceed the maximum amount */
		_CurrentHealth = asNumber(Math.min((_CurrentHealth + __Amount), _MaximumHealth));
		propertyChanged("_CurrentHealth", _CurrentHealth);
		_customEvent_UpdateGlobalHealth();
		if((hasValue(_HealedMessage)))
		{
			actor.shout("_customEvent_" + _HealedMessage);
		}
		if((hasValue(_HealSound)))
		{
			playSound(_HealSound);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_FullRestore():Void
	{
		var __Self:Actor = actor;
		_CurrentHealth = asNumber(_MaximumHealth);
		propertyChanged("_CurrentHealth", _CurrentHealth);
		_customEvent_UpdateGlobalHealth();
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_GetCurrentHealth():Float
	{
		var __Self:Actor = actor;
		return _CurrentHealth;
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_GetMaxHealth():Float
	{
		var __Self:Actor = actor;
		return _MaximumHealth;
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_SetInvincibility(__Status:Bool):Void
	{
		var __Self:Actor = actor;
		_Invincible = __Status;
		propertyChanged("_Invincible", _Invincible);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_SetHealth(__Amount:Float):Void
	{
		var __Self:Actor = actor;
		_CurrentHealth = asNumber(Math.min(__Amount, _MaximumHealth));
		propertyChanged("_CurrentHealth", _CurrentHealth);
		_CurrentHealth = asNumber(Math.max(__Amount, 0));
		propertyChanged("_CurrentHealth", _CurrentHealth);
		_customEvent_UpdateGlobalHealth();
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_GetInvincibility():Bool
	{
		var __Self:Actor = actor;
		return _Invincible;
	}
	public function _customEvent_UpdateGlobalHealth():Void
	{
		if(_PersistentHealth)
		{
			setGameAttribute(_HealthIdentifier, asNumber(_CurrentHealth));
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_Death():Void
	{
		if(_Spawned)
		{
			return;
		}
		_Spawned = true;
		propertyChanged("_Spawned", _Spawned);
		createRecycledActor(_ActorTypeToSpawn, (actor.getX() + xOffset), (actor.getY() + yOffset), Script.FRONT);
		_SpawnedActor = getLastCreatedActor();
		propertyChanged("_SpawnedActor", _SpawnedActor);
		if((lifespan > 0))
		{
			runLater(1000 * lifespan, function(timeTask:TimedTask):Void
			{
				if(((hasValue(_SpawnedActor)) && _SpawnedActor.isAlive()))
				{
					recycleActor(_SpawnedActor);
				}
			}, actor);
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Starting Health", "_StartingHealth");
		_StartingHealth = 3.0;
		nameMap.set("Maximum Health", "_MaximumHealth");
		_MaximumHealth = 3.0;
		nameMap.set("Current Health", "_CurrentHealth");
		_CurrentHealth = 3.0;
		nameMap.set("Healed Message", "_HealedMessage");
		_HealedMessage = "Healed";
		nameMap.set("Damaged Message", "_DamagedMessage");
		_DamagedMessage = "Damaged";
		nameMap.set("Zero Health Action", "_ZeroHealthAction");
		_ZeroHealthAction = "";
		nameMap.set("Invincible?", "_Invincible");
		_Invincible = false;
		nameMap.set("Delay Between Damage", "_DelayBetweenDamage");
		_DelayBetweenDamage = 0.5;
		nameMap.set("Can Be Damaged?", "_CanBeDamaged");
		_CanBeDamaged = true;
		nameMap.set("Persistent Health?", "_PersistentHealth");
		_PersistentHealth = false;
		nameMap.set("Health Game Attribute", "_HealthGameAttribute");
		nameMap.set("Health Identifier", "_HealthIdentifier");
		_HealthIdentifier = "";
		nameMap.set("Damage Sound", "_DamageSound");
		nameMap.set("Death Sound", "_DeathSound");
		nameMap.set("Heal Sound", "_HealSound");
		nameMap.set("Spawned?", "_Spawned");
		_Spawned = false;
		nameMap.set("X Offset", "xOffset");
		xOffset = 0.0;
		nameMap.set("Y Offset", "yOffset");
		yOffset = 0.0;
		nameMap.set("Spawned Actor", "_SpawnedActor");
		nameMap.set("Lifespan", "lifespan");
		lifespan = 0.0;
		nameMap.set("Spawn Actor On Death", "_SpawnActorOnDeath");
		_SpawnActorOnDeath = false;
		nameMap.set("Actor Type To Spawn", "_ActorTypeToSpawn");
		nameMap.set("Percent Left", "_PercentLeft");
		_PercentLeft = 0.0;
		nameMap.set("Drawing Location", "_DrawingLocation");
		_DrawingLocation = "";
		nameMap.set("Health Bar X Offset", "_HealthBarXOffset");
		_HealthBarXOffset = 0.0;
		nameMap.set("Health Bar Outline Size", "_HealthBarOutlineSize");
		_HealthBarOutlineSize = 1.0;
		nameMap.set("Health Bar Y Offset", "_HealthBarYOffset");
		_HealthBarYOffset = 0.0;
		nameMap.set("Health Bar Width", "_HealthBarWidth");
		_HealthBarWidth = 100.0;
		nameMap.set("Health Bar Height", "_HealthBarHeight");
		_HealthBarHeight = 5.0;
		nameMap.set("Health Bar Orientation", "_HealthBarOrientation");
		_HealthBarOrientation = "";
		nameMap.set("Health Bar Outline Colour", "_HealthBarOutlineColour");
		_HealthBarOutlineColour = Utils.getColorRGB(0,0,0);
		nameMap.set("Colour Over 75%", "_ColourOver75");
		_ColourOver75 = Utils.getColorRGB(0,255,0);
		nameMap.set("Colour Over 50%", "_ColourOver50");
		_ColourOver50 = Utils.getColorRGB(255,255,0);
		nameMap.set("Colour Over 25%", "_ColourOver25");
		_ColourOver25 = Utils.getColorRGB(255,153,0);
		nameMap.set("Colour Under 25%", "_ColourUnder25");
		_ColourUnder25 = Utils.getColorRGB(255,0,0);
		nameMap.set("Health Bar Background Colour", "_HealthBarBackgroundColour");
		_HealthBarBackgroundColour = Utils.getColorRGB(0,0,0);
		nameMap.set("Draw Health Bar", "_DrawHealthBar");
		_DrawHealthBar = true;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_CurrentHealth = asNumber(_StartingHealth);
		propertyChanged("_CurrentHealth", _CurrentHealth);
		_HealthIdentifier = "INTERNALGLOBALHEALTH";
		propertyChanged("_HealthIdentifier", _HealthIdentifier);
		if(_PersistentHealth)
		{
			if(!(((asNumber((getGameAttribute(_HealthIdentifier))) <= 0) || (asNumber((getGameAttribute(_HealthIdentifier))) >= 0))))
			{
				setGameAttribute(_HealthIdentifier, asNumber(_CurrentHealth));
			}
			else
			{
				_CurrentHealth = asNumber(asNumber((getGameAttribute(_HealthIdentifier))));
				propertyChanged("_CurrentHealth", _CurrentHealth);
			}
		}
		if((_CurrentHealth <= 0))
		{
			/* Trying to spawn with no health, deal the death blow! */
			if((_ZeroHealthAction == "Kill"))
			{
				recycleActor(actor);
			}
		}
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_PercentLeft = asNumber((_CurrentHealth / _MaximumHealth));
				propertyChanged("_PercentLeft", _PercentLeft);
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_DrawHealthBar)
				{
					if((_DrawingLocation == "Screen"))
					{
						g.translateToScreen();
					}
					/* Draw the health bar background and outline */
					if((_HealthBarOutlineSize > 0))
					{
						g.fillColor = _HealthBarOutlineColour;
						g.fillRect((_HealthBarXOffset - _HealthBarOutlineSize), (_HealthBarYOffset - _HealthBarOutlineSize), (_HealthBarWidth + (_HealthBarOutlineSize * 2)), (_HealthBarHeight + (_HealthBarOutlineSize * 2)));
					}
					g.fillColor = _HealthBarBackgroundColour;
					g.fillRect(_HealthBarXOffset, _HealthBarYOffset, _HealthBarWidth, _HealthBarHeight);
					if((_PercentLeft > 0.75))
					{
						g.fillColor = _ColourOver75;
					}
					else if((_PercentLeft > 0.50))
					{
						g.fillColor = _ColourOver50;
					}
					else if((_PercentLeft > 0.25))
					{
						g.fillColor = _ColourOver25;
					}
					else
					{
						g.fillColor = _ColourUnder25;
					}
					/* Draw the current amount of health */
					if((_HealthBarOrientation == "Horizontal"))
					{
						g.fillRect((_HealthBarXOffset + 1), (_HealthBarYOffset + 1), (Math.round((_HealthBarWidth * _PercentLeft)) - 2), (_HealthBarHeight - 2));
					}
					else
					{
						g.fillRect((_HealthBarXOffset + 1), ((_HealthBarYOffset + Math.round((_HealthBarHeight * (1 - _PercentLeft)))) + 1), (_HealthBarWidth - 2), (Math.round((_HealthBarHeight * _PercentLeft)) - 2));
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}