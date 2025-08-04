package play.components;

import backend.util.PathUtil;
import ui.UIClickableSprite;

class AntJournal extends UIClickableSprite
{
    public function new ()
    {
        super();
		loadGraphic(PathUtil.ofSharedImage("journal"));
    }
}