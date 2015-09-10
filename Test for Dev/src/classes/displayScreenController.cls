Public with sharing class displayScreenController {
    Public String strings { get; set; }
    Public String[] getStatus() {
        return new String[]{'Open','Closed','Incomplete'};
    }
}