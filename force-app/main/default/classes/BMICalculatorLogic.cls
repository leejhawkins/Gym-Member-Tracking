public inherited sharing class BMICalculatorLogic {
    
     public static Double BMICalculator(Member__c member){
        List<Member__c> weightField = [select Weight__c from Member__c limit 1];
        List<Member__c> feetField = [select Height_Feet__c from Member__c limit 1];
        List<Member__c> inchesField = [select Height_Inches__c from Member__c limit 1];

        Decimal weight = weightField[0].Weight__c;
        Decimal feet = feetField[0].Height_Feet__c;
        Decimal inches = inchesField[0].Height_Inches__c;

        Double weightInKilos = weight * 0.453592;
        Double heightInMeters = (((feet * 12) + inches)* .0254);
        Double bmi = weightInKilos / (heightInMeters * heightInMeters);
        
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



    
}
