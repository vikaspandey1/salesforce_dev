Public with sharing class ShowOppBoardController {
 Public List<Opportunity> oppList{get;set;}
 Public List<String> fieldList{get;set;} 
 Public ShowOppBoardController(){
     oppList = New List<Opportunity>();
     fieldList = New List<String>{'name','stagename','expectedrevenue','type'};
     oppList = [select name,stagename,expectedrevenue,type from opportunity limit 10];
  }
}