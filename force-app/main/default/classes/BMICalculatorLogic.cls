public inherited sharing class BMICalculatorLogic {
    /*
    public static Double BMICalculator(Member__c member){
        Integer weight = [select Weight__c from Member__c limit 1];
        Integer feet = [select feet__c from Member__c limit 1];
        Integer inches = [select inches__c from Member__c limit 1];

        Double weightInKilos = weight * 0.453592;
        Double heightInMeters = (((feet * 12) + inches)* .0254);
        Double hm = math.pow(heightInMeters, 2.0);
        Double bmi = weightInKilos / hm;
        
        return bmi;
    }

    public static void getAllMembers(List<Member__c> members){
        for(Member__c m: members){
            BMICalculator(m);
        }
    }

    public static void interpretBMI(Double bmi){
        if(bmi < 18.5){
            System.debug('Member is underweight');
        }
        if(bmi >= 18.5 && bmi < 25.0){
                System.debug('Member has a normal BMI');
            }
        if(bmi >= 25.0 && bmi < 30.0){
                System.debug('Member is above weight');
            }
        else{
            if(bmi > 30.0){
                System.debug('Member needs to speak with trainer');
            }
        }
    }
    */
}
