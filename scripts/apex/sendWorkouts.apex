WorkoutDistributor wd = new WorkoutDistributor();
String cron = '0 0 5 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), cron, wd);