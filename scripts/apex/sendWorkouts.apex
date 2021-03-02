WorkoutDistributor wd = new WorkoutDistributor();
String crn = '30 12 10 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), crn, wd);