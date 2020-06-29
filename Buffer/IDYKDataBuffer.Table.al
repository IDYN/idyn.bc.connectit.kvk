table 50600 "IDYK Data Buffer"
{
    Caption = 'Data Buffer';

    fields
    {
        field(1; "Chamber of Commerce No."; Text[12])
        {
            Caption = 'Chamber of Commerce No.';
            DataClassification = CustomerContent;
        }
        field(2; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(3; "Street Name"; Text[100])
        {
            Caption = 'Street Name';
            DataClassification = CustomerContent;
        }
        field(4; "House Number"; Text[100])
        {
            Caption = 'House Number';
            DataClassification = CustomerContent;
        }
        field(5; "Post Code"; Text[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(6; "City"; Text[100])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(7; "Website"; Text[100])
        {
            Caption = 'Website';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Chamber of Commerce No.")
        {
            Clustered = true;
        }
    }
}
