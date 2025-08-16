import flixel.FlxG;
import flixel.FlxSprite;

class UnlockState extends MusicBeatState
{
	public var unlocked:FlxSprite;

	public override function create()
	{
		unlocked = new FlxSprite(0, 0).loadGraphic(Paths.image('unlockBG', "hex"));
        unlocked.setGraphicSize(Std.int(unlocked.width * 1.2));
        unlocked.setGraphicSize(Std.int(unlocked.height * 1.2));
        unlocked.updateHitbox();
		unlocked.scrollFactor.set();
		add(unlocked);
		super.create();
	}

	public override function update(elapsed)
	{
		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.playMusic(Paths.music("freakyMenu"));
			FlxG.switchState(new StoryMenuState());
		}
		super.update(elapsed);
	}
}