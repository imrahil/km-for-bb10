package com.pauluz.bbapps.kontomierz.view.components
{
    import qnx.fuse.ui.listClasses.SectionHeaderRenderer;
    import qnx.fuse.ui.skins.SkinStates;
    import qnx.fuse.ui.text.TextFormat;

    public class CustomSectionHeaderRenderer extends SectionHeaderRenderer
    {
        public function CustomSectionHeaderRenderer()
        {
            super();

            var defaultTF:TextFormat = new TextFormat();
            defaultTF.size = 40;
            defaultTF.color = 0x000000;
            defaultTF.bold = true;

            this.setTextFormatForState(defaultTF, SkinStates.UP);
            this.setTextFormatForState(defaultTF, SkinStates.DOWN);
            this.setTextFormatForState(defaultTF, SkinStates.DOWN_SELECTED);
            this.setTextFormatForState(defaultTF, SkinStates.FOCUS);
            this.setTextFormatForState(defaultTF, SkinStates.UP_ODD);
            this.setTextFormatForState(defaultTF, SkinStates.SELECTED);
        }
    }
}
