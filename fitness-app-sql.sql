-- Show total minutes of work outs for users who have worked out with the app in order of first name
CREATE PROCEDURE totalMinutes()
SELECT UserProfile.firstName, UserProfile.Lastname, sum(Workouts.durationMins) AS "Total
Workout Minutes"
FROM UserProfile
JOIN UserState ON UserProfile.userID = UserState.userID
JOIN Workouts ON Workouts.idUserState = UserState.idUserState
GROUP BY UserProfile.userID
ORDER BY UserProfile.firstName;


-- Show dates where users got less sleep than average user sleep
CREATE PROCEDURE sleeplessNights()
SELECT UserProfile.firstName, UserProfile.lastName, Sleep.dateMon AS "Month",
Sleep.dateDay AS "Day", Sleep.dateYear AS "YEAR", Sleep.hoursSlept AS "Hours Slept"
FROM Sleep
JOIN UserState ON UserState.idUserState = Sleep.idUserState
JOIN UserProfile ON UserProfile.userID = UserState.userID
WHERE Sleep.hoursSlept < (
SELECT AVG(Sleep.hoursSlept)
FROM Sleep);


-- Selects list of people who have a subscription
CREATE PROCEDURE hasSubscriptions()
SELECT Outter.firstName, Outter.lastName
FROM UserProfile AS Outter
WHERE EXISTS (
SELECT Subscription.subID
FROM Subscription
WHERE Subscription.subID = Outter.userID);


-- Shows count of all Free or Bronze subscriptions
CREATE PROCEDURE cheapSubscriptions()
SELECT SubPlan.subName, count(Subscription.subID)
FROM SubPlan
JOIN Subscription ON Subscription.subType = SubPlan.subType
GROUP BY SubPlan.subName HAVING SubPlan.subName = "Free" OR SubPlan.subName =
"Bronze";


-- Selects first and last names of profiles using a gmail account for their email (used to add in sign-in with google feature)
CREATE PROCEDURE gmailUsers()
SELECT UserProfile.firstName,UserProfile.lastName
FROM UserProfile
WHERE UserProfile.email RegExp 'gmail.com$';


-- Returns the count of subscriptions created since 2015: useful for viewing growth statistics.
CREATE PROCEDURE recentSubscriptions()
SELECT count(Subscription.subID) AS "New Subscriptions"
FROM Subscription
WHERE Subscription.startYear NOT IN (2012,2013,2014);


-- Displays first and last name and contact info for all users.
CREATE PROCEDURE contactInfo()
SELECT firstName, lastName, email, phone
FROM UserProfile;


-- Displays first and last names and average daily grams consumed of carbs, protein, and fat
CREATE PROCEDURE averageConsumption()
SELECT UserProfile.firstName, UserProfile.lastName, AVG(Nutrition.fatGrams) AS "Fat",
AVG(Nutrition. proteinGrams) AS "Protein", AVG(Nutrition.carbGrams) AS "Carbs"
FROM Nutrition
JOIN UserState ON Nutrition.idUserState = UserState.idUserState
JOIN UserProfile ON UserProfile.userID = UserState.userID
GROUP BY UserProfile.userID;


-- Selects firstname, lastname, of users with their goal calories to burn by the end of the listed goal month/goal year
CREATE PROCEDURE goalTimelines()
SELECT UserProfile.firstName, UserProfile.lastName, WorkoutPlan.goalCaloriesBurned,
WorkoutPlan.goalMonth, WorkoutPlan.goalYear
FROM UserProfile
JOIN UserState ON UserState.userID = UserProfile.userID
JOIN WorkoutPlan ON WorkoutPlan.idUserState = UserState.idUserState;


/* Selects first and last names of all users with the card types stored for their payment
info: If you change your card processing provider to one who doesn’t support some card types,
you can quickly notify users affected by the transition. */
CREATE PROCEDURE userCardTypes()
SELECT UserProfile.firstName, UserProfile.Lastname, PaymentInfo.cardType
FROM UserProfile
JOIN PaymentInfo ON PaymentInfo.paymentID = UserProfile.paymentID;
































