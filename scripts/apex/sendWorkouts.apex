WorkoutDistributor wd = new WorkoutDistributor();
String crn = '0 0 5 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), crn, wd);