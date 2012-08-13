/**
 * Rectangle Packer demo
 * Copyright 2012 Ville Koskela. All rights reserved.
 *
 * Blog: http://villekoskela.org
 * Twitter: @villekoskelaorg
 *
 * You may redistribute, use and/or modify this class freely
 * but this copyright statement must not be removed.
 *
 * The package structure must remain unchanged.
 *
 */
package org.villekoskela
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.getTimer;

    import org.villekoskela.tools.ScalingBox;
    import org.villekoskela.utils.RectanglePacker;

    /**
     * Simple demo application for the RectanglePacker class.
     * Should not be used as a reference for anything :)
     */
    [SWF(width="480", height="480", frameRate="60", backgroundColor="#FFFFFF")]
    public class RectanglePackerDemo extends Sprite
    {
        private static const WIDTH:int = 480
        private static const HEIGHT:int = 480;
        private static const Y_MARGIN:int = 40;
        private static const BOX_MARGIN:int = 15;

        private static const RECTANGLE_COUNT:int = 500;

        private var mBitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT, true, 0xFFFFFFFF);
        private var mCopyRight:TextField = new TextField();
        private var mText:TextField = new TextField();

        private var mPacker:RectanglePacker;
        private var mScalingBox:ScalingBox;

        private var mRectangles:Vector.<Rectangle> = new Vector.<Rectangle>();

        public function RectanglePackerDemo()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);

            var bitmap:Bitmap = new Bitmap(mBitmapData);
            addChild(bitmap);
            bitmap.x = BOX_MARGIN;
            bitmap.y = Y_MARGIN;

            mCopyRight.x = BOX_MARGIN;
            mCopyRight.y = BOX_MARGIN / 3;
            mCopyRight.width = 300;
            mCopyRight.text = "Rectangle Packer (c) villekoskela.org"
            addChild(mCopyRight);

            mText.x = WIDTH - 200;
            mText.y = BOX_MARGIN / 3;
            mText.width = 200;
            addChild(mText);

            mScalingBox = new ScalingBox(BOX_MARGIN, Y_MARGIN, WIDTH - (BOX_MARGIN*2), HEIGHT - (Y_MARGIN + (BOX_MARGIN*2)));
            addChild(mScalingBox);

            createRectangles();
        }

        /**
         * Create some random size rectangles to play with
         */
        private function createRectangles():void
        {
            var width:int;
            var height:int;
            for (var i:int = 0; i < 10; i++)
            {
                width = 40 + Math.floor(Math.random() * 8) * 4;
                height = 40 + Math.floor(Math.random() * 8) * 4;
                mRectangles.push(new Rectangle(0, 0, width, height));
            }

            for (var j:int = 10; i < RECTANGLE_COUNT; i++)
            {
                width = 6 + Math.floor(Math.random() * 8) * 2;
                height = 6 + Math.floor(Math.random() * 8) * 2;
                mRectangles.push(new Rectangle(0, 0, width, height));
            }

            mRectangles.sort(sortOnArea);
        }

        private function sortOnArea(a:Rectangle, b:Rectangle):Number
        {
            if (a.width*a.height > b.width*b.height)
            {
                return -1;
            }

            return 1;
        }

        private function onAddedToStage(event:Event):void
        {
            updateRectangles();
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP;
        }

        private function onEnterFrame(event:Event):void
        {
            if (mScalingBox.boxWidth != mScalingBox.newBoxWidth || mScalingBox.boxHeight != mScalingBox.newBoxHeight)
            {
                updateRectangles();
            }
        }

        private function updateRectangles():void
        {
            var start:int = getTimer();
            mPacker = new RectanglePacker(mScalingBox.newBoxWidth, mScalingBox.newBoxHeight);
            for (var i:int = 0; i < RECTANGLE_COUNT; i++)
            {
                mPacker.insertRectangle(mRectangles[i]);
            }
            var end:int = getTimer();

            if (mPacker.rectangleCount > 0)
            {
                mText.text = mPacker.rectangleCount + " rectangles packed in " + (end - start) + "ms";

                mScalingBox.updateBox(mScalingBox.newBoxWidth, mScalingBox.newBoxHeight);
                mBitmapData.fillRect(mBitmapData.rect, 0xFFFFFFFF);
                var rect:Rectangle = new Rectangle();
                for (var j:int = 0; j < mPacker.rectangleCount; j++)
                {
                    rect = mPacker.getRectangle(j, rect);
                    mBitmapData.fillRect(new Rectangle(rect.left, rect.top, rect.width, rect.height), 0xFF000000);
                    mBitmapData.fillRect(new Rectangle(rect.left + 1, rect.top + 1, rect.width - 2, rect.height - 2), 0xFF171703 + (((18 * ((j+4) % 13)) << 16) + ((31 * ((j*3) % 8)) << 8) + 63 * (((j+1)*3) % 5)));
                }
            }
        }
    }
}