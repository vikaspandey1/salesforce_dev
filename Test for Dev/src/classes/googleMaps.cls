public class googleMaps {

    public String duration {get;set;}
    public Integer travelTime {get;set;}
    public Decimal distance {get;set;}

    public googleMaps(
            String address1,
            String address2) {
                
        String jsonResults = getJsonResults(address1, address2);
        jsonResults = formatJsonResults(jsonResults);
        updateJsonSections(jsonResults);
    }

    public String getJsonResults(
            String address1,
            String address2) {
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setMethod('GET');
        
        String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
            + '?origins=' + address1
            + '&destinations=' + address2
            + '&mode=driving'
            + '&sensor=false'
            + '&language=en'
            + '&units=imperial';
            //+ '&key=AIzaSyCQZq4Wx25BMZZJPLx-8nHDArhkJlbOOVM';
            
        req.setEndPoint(url);

        HTTPResponse resp = http.send(req);
        String jsonResults = resp.getBody().replace('\n', '');
        return jsonResults;
    }
    
    public String formatJsonResults(String jsonResults) {
        jsonResults = jsonResults.replace('{', ', ');
        jsonResults = jsonResults.replace('}', ', ');
        jsonResults = jsonResults.replace('[', ', ');
        jsonResults = jsonResults.replace(']', ', ');
        jsonResults = jsonResults.replace('"', ''); 
        return jsonResults;
    }

    
    public void updateJsonSections(
        String jsonResults) {
        
        List<String> jsonSections = jsonResults.split(', ');
        
        
        for (Integer i = 0; i < jsonSections.size(); i++) {
            jsonSections[i] = jsonSections[i].trim();
            
            if (jsonSections[i].contains('duration :')) {
                duration = parseDuration(jsonSections[i + 1]);
                travelTime = parseTravelTime(duration);
            }
            
            if (jsonSections[i].contains('distance :')) {
                distance = parseDistance(jsonSections[i + 1]);
            }
        }
    }

    public Decimal parseDistance(String value) {

        value = value.replace('text : ', '');
        value = value.replace('value : ', '');
        value = value.replace(' mi', '');
        value = value.replace(' ft', '');
        value = value.replace(',', '');
        value = value.trim();       
        
        return Decimal.valueOf(value);
    }
    
    public String parseDuration(String value) {
        value = value.replace('text : ', '');
        value = value.replace('value : ', '');
        
        return value;
    }
    
    public Integer parseTravelTime(String value) {
    
        Integer tmpMinutes = 0;
    
        List<String> durationNodes = value.split(' ');
        String prevDurationNode = '';
        
        for (String durationNode : durationNodes) {
            if (durationNode == 'day' || durationNode == 'days') {
                tmpMinutes += Integer.valueOf(prevDurationNode) * 1440;
            }
            if (durationNode == 'hour' || durationNode == 'hours') {
                tmpMinutes += Integer.valueOf(prevDurationNode) * 60;
            }
            if (durationNode == 'min' || durationNode == 'mins') {
                tmpMinutes += Integer.valueOf(prevDurationNode);
            }
            
            prevDurationNode = durationNode;
        }
    
        return tmpMinutes;  
    }

}