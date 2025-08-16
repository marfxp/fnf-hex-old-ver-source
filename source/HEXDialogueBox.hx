package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

class HEXDialogueBox extends FlxSpriteGroup // yapi old hex diag
{
	var box:FlxSprite;

	private var background:FlxSpriteGroup = new FlxSpriteGroup();
	private var splitBack:String = "";
	private var BGid:Int = -1;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeftHex:FlxSprite;
	var portraitLeftMyst:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitRightGF:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var black:FlxSprite;

	public var sound:FlxSound;
	var snd:FlxSound;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		trace(dialogueList);

	if (PlayState.isStoryMode)
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
		case 'dunk' | 'ram' | 'hello-world' | 'glitcher':
		    sound = new FlxSound().loadEmbedded(Paths.music('givinALittle', 'hex'), true);
		    sound.volume = 0;
		    FlxG.sound.list.add(sound);
		    sound.fadeIn(1, 0, 0.8);
		}
	}

		black = new FlxSprite(-200, -200).makeGraphic(9000, 9000, FlxColor.BLACK);
		add(black);

		box = new FlxSprite(-20, 400).loadGraphic(Paths.image('dialoguebox', 'hex'));

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'dunk' | 'ram' | 'hello-world' | 'glitcher':
			var bgJson:Array<Dynamic> = cast Json.parse(Assets.getText(Paths.json('backgrounds')).trim()).bg;

		    for (ar in bgJson)
		    {
			    var bg:FlxSprite = new FlxSprite();
			    bg = new FlxSprite(ar[1], ar[2]).loadGraphic(Paths.image('cutscenes/' + ar[0]));
			    bg.scrollFactor.set();
			    bg.antialiasing = true;
			    bg.scale.set(ar[3], ar [3]);
			    bg.visible = false;
			    background.add(bg);
		    }
		    add(background);
		}

		this.dialogueList = dialogueList;

		portraitLeftHex = new FlxSprite(130, 300).loadGraphic(Paths.image('hex_nametag', 'hex'));
		portraitLeftHex.updateHitbox();
		portraitLeftHex.scrollFactor.set();
		portraitLeftHex.setGraphicSize(Std.int(portraitLeftHex.width * 0.8));
		add(portraitLeftHex);

		portraitLeftMyst = new FlxSprite(130, 300).loadGraphic(Paths.image('question_nametag', 'hex'));
		portraitLeftMyst.updateHitbox();
		portraitLeftMyst.scrollFactor.set();
		portraitLeftMyst.setGraphicSize(Std.int(portraitLeftMyst.width * 0.8));
		add(portraitLeftMyst);

		portraitRight = new FlxSprite(130, 300).loadGraphic(Paths.image('bf_nametag', 'hex'));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.8));
		add(portraitRight);

		portraitRightGF = new FlxSprite(130, 300).loadGraphic(Paths.image('gf_nametag', 'hex'));
		portraitRightGF.updateHitbox();
		portraitRightGF.scrollFactor.set();
		portraitRightGF.setGraphicSize(Std.int(portraitRightGF.width * 0.8));
		add(portraitRightGF);

		box.updateHitbox();
		box.screenCenter(X);
		add(box);

		swagDialogue = new FlxTypeText(240, box.y + 115, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Gotham Black';
		swagDialogue.color = FlxColor.BLACK;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('hx', 'hex'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);

		portraitLeftHex.visible = false;
		portraitLeftMyst.visible = false;
		portraitRight.visible = false;
		portraitRightGF.visible = false;

		dialogueOpened = true;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					sound.kill();

					remove(black);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						portraitLeftHex.visible = false;
						portraitLeftMyst.visible = false;
						portraitRight.visible = false;
						portraitRightGF.visible = false;
						swagDialogue.alpha -= 1 / 5;
						background.alpha -= 0.2;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
			if(background.members.length > 1 && splitBack.length > 0)
			{
				var id = Std.parseInt(splitBack) -1;
				if(BGid != -1)
				{
					background.members[BGid].visible = false;
				}
				if(id >= 0)
				{
					black.visible = false;
					background.members[id].visible = true;
					BGid = id;
				}
			}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		var cleaned = false;
        var safetyCounter = 0;

        while (!cleaned && safetyCounter < 10)
        {
            if (dialogueList[0].contains(':'))
            cleanDialog();
        else
            cleaned = true;

        safetyCounter++;
        }

        if (!cleaned)
            trace('warn: diag clean loop hit safety limit');

		    swagDialogue.resetText(dialogueList[0]);
		    swagDialogue.start(0.04, true);

		    portraitLeftHex.visible = false;
		    portraitLeftMyst.visible = false;
		    portraitRight.visible = false;
		    portraitRightGF.visible = false;

		switch (curCharacter)
		{
			case 'myst':
				portraitLeftMyst.visible = true;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('hx', 'hex'), 0.6)];
			case 'hex':
				portraitLeftHex.visible = true;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('hx', 'hex'), 0.6)];
			case 'bf':
				portraitRight.visible = true;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bf', 'hex'), 0.6)];
			case 'gf':
				portraitRightGF.visible = true;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gf', 'hex'), 0.6)];
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		
		if (splitName[1] == 'PLAYSOUND')
		{
			trace('SOUND NOW IZZZZZZZZ ' + splitName[2]);
			snd = new FlxSound().loadEmbedded(Paths.sound(splitName[2], 'hex'));
			snd.play();
			dialogueList.remove(dialogueList[0]);
		}
		else if (splitName[1] == 'BGTRACK')
		{
			trace('BG TRACK ' + splitName[2]);
			sound.fadeOut();
			FlxG.sound.list.remove(sound);
			sound = new FlxSound().loadEmbedded(Paths.music(splitName[2], 'hex'));
			sound.volume = 0;
			FlxG.sound.list.add(sound);
			sound.fadeIn(1, 0, 0.8);
			dialogueList.remove(dialogueList[0]);
		}
		else if(splitName[1].split("/").length > 1)
		{
			trace('bg now is ' + splitName[1]);
			splitBack = splitName[1].split("/")[1];
			curCharacter = splitName[1].split("/")[0];
		}
		else
			curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}