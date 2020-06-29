pageextension 50600 "IDYK Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter("No.")
        {
            field("IDYK Chamber of Commerce No."; "IDYK Chamber of Commerce No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Chamber of Commerce No.';
            }
        }
    }
}