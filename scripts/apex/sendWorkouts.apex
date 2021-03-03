WorkoutDistributor wd = new WorkoutDistributor();
String cron = '20 49 7 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), cron, wd);