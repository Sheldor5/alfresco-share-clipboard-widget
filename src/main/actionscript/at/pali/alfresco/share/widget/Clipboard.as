package at.pali.alfresco.share.widget
{
    import flash.system.System;
    import flash.display.Sprite;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.display.Bitmap;
    import flash.text.Font;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Timer;
     
    // set properties to use a fixed size of the swf
    [SWF(backgroundColor="#FFFFFF", width="120", height="18")]
    public class Clipboard extends Sprite
    {
        // embed the icon
        [Embed(source = "/img/clipboard-16.png")]
        internal var png:Class;

        // embed the font
        [Embed(source="/font/open-sans-regular.ttf", 
                fontName = "open-sans-regular", 
                mimeType = "application/x-font", 
                fontWeight="normal", 
                fontStyle="normal", 
                advancedAntiAliasing="true", 
                embedAsCFF="false")]
        internal var font:Class;

        protected var icon:Bitmap = new png;
        protected var f:Font = new font;
        protected var FlashVars:Object = root.loaderInfo.parameters;

        private var textField:TextField = new TextField();
        private var movieClip:MovieClip = new MovieClip();

        private var data:String;
        private var label:String;
        private var success:String;
        private var failure:String;

        public function Clipboard()
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
        }

        private function init(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            // assign the embedded font so we can use it
            var textFormat:TextFormat = new TextFormat("open-sans-regular", 12, 0x444444);

            // set up the textField
            textField.embedFonts = true;
            textField.defaultTextFormat = textFormat;
            textField.height = 18;
            textField.width = 100;
            textField.x = 20;
            textField.y = -1;
            
            // prepare the container which holds the icon and the text field
            movieClip.addChild(icon);
            movieClip.addChild(textField);
            movieClip.mouseChildren = false;
            movieClip.buttonMode = true;
            
            // set data values
            try {
                // get the FlashVars
                data = FlashVars.data as String;
                label = FlashVars.label as String;
                success = FlashVars.success as String;
                failure = FlashVars.failure as String;
                
                // set the label
                textField.text = label;
                
                // add the click listener
                stage.addEventListener(MouseEvent.CLICK, copyToClipobard);
            } catch (e:Error) {
                textField.text = "Initialisation failed!";
                textField.textColor = 0xFF0000;
            }
            
            // add the container to the main DisplayObject
            stage.scaleMode = StageScaleMode.EXACT_FIT;
            addChild(movieClip);
        }
        
        private function copyToClipobard(event:Event):void {
            try {
                System.setClipboard(data);
                textField.textColor = 0x515D6B;
                feedback();
            } catch (e:Error) {
                textField.text = failure;
                textField.textColor = 0xFF0000;
            }
        }
        
        private function feedback():void {
            hideLabel();
            delayedFunctionCall(150, function():void {showLabel();});
            delayedFunctionCall(350, function():void {hideLabel();});
            delayedFunctionCall(425, function():void {textField.text = success;});
            delayedFunctionCall(500, function():void {showLabel();});
        }
        
        private function delayedFunctionCall(delay:int, fn:Function):void {
            var timer:Timer = new Timer(delay, 1);
            timer.addEventListener(TimerEvent.TIMER, fn);
            timer.start();
        }
        
        public function hideLabel():void {
            textField.visible = false;
        }
        
        private function showLabel():void {
            textField.visible = true;
        }
        
    }
    
}