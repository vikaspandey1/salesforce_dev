public class AddTime
 {
 
 public String calculateTime(String str1, String str2){
        String strTemp = '';
        
        if(str1 != null){
            if (str2 != null){
                String[] tempTime = str1.split(':');
                String[] tempExtensionTime = str2.split(':');
                Integer tmpSecond = 0;
                Integer tmpMinute = 0;
                Integer tmpHour = 0;
                Integer tempFraction = 0;
                
                for(integer i=tempTime.size() -1; i >= 0; i--) {
                    
                    tempFraction = Integer.valueOf(tempTime[i]) + Integer.valueOf(tempExtensionTime[i]);
                    
                    if(i==2){
                        if(tempFraction >= 60){
                            tmpSecond = tempFraction - 60;
                            tmpMinute = 1;
                        } else{
                            tmpSecond = tempFraction;
                        }
                    }
                    if(i==1){
                        if(tempFraction + tmpMinute >= 60){
                            tmpMinute = tempFraction  + tmpMinute - 60;
                            tmpHour = 1;
                        } else{
                            tmpMinute = tempFraction + tmpMinute;
                        }  
                    }
                    if(i==0){
                        if(tempFraction + tmpHour >= 24 && i ==0){
                            tmpHour = tempFraction + tmpHour -24;
                        }else{
                            tmpHour = tempFraction + tmpHour ;
                        }                    
                    }
                }
                //System.debug('tmpHour' + tmpHour + 'tmpMinute' + tmpMinute + 'tmpSecond' + tmpSecond);
                strTemp = String.valueOf(tmpHour);
                if (tmpMinute < 9)  strTemp = strTemp+':'+ '0' + tmpMinute;   else    strTemp = strTemp +':'+ tmpMinute;
                if (tmpSecond < 9)  strTemp = strTemp+':'+ '0' + tmpSecond;   else    strTemp = strTemp +':'+ tmpSecond;
                return strTemp;
            } else{
                return str1;
            }
        }
        system.debug('@@@'+str1);
        return str1;        
    }
    }