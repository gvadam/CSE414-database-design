# CSE 414 Homework 4: Database Design

**Objectives:**
To translate from entity relationship diagrams to a relational database, and to understand functional dependencies and normal forms.


## Assignment Details

### Part 1: Flight Booking Service E/R Design (20 points)

Congratulations, you are opening your own flight booking service! 
In this hw, you will create an Entity-Relationship (E/R) diagram for a database to support your booking service.
In the next hw, you will implement your booking service as a Java program.
Think hard on this problem, as it will inform the design you implement in the next hw.

The following is a description of the domain and tasks your flight booking service needs to support.
Read this description, then decide on entities and relationships for a database to support your service.

This service is based on the tables Flights, Carriers, Months, and Weekdays used in hw2 and hw3. 
**Your flight booking service may not modify the contents of Flights, Carriers, Months, or Weekdays**,
because updates to these tables (such as scheduling new flights) occur outside of your application.

Your service follows a [client-server model](https://en.wikipedia.org/wiki/Client%E2%80%93server_model).
Users interact with your service by running your client application.
Savvy, frequent-flyer users may run several instances of your client application at once!
The client application can either 

1. store information locally (just inside the client program) and transiently (not saved after the program closes), 
in which case this information does not need to be stored in a server database.
2. store information globally (accessible to all client programs) and persistently (saved after the program closes),
in which case this information needs to be stored in a server database.

Remember that only data that falls under category #2 need be stored in your database and modeled in your entity-relationship diagram.


#### Service Requirements

Users *create an account* in your service by specifying their *username* (case insensitive), a *password* (case sensitive), and an *initial balance*. 
Balances are given in dollars, and are used to pay for booking flights.

After creating an account, a user may *login to their account* by specifying their *username* and *password*.

A user may make a *deposit to their account* by specifying *how much money* they wish to add to their balance.

Anyone (even users that have not logged in) may *search for flight itineraries*.
In this context, a flight itinerary is either a *direct flight itinerary*, in which case it consists of a single flight, 
or a *one-stop flight itinerary*, in which case it consists of two flights 
(which must both occur on the same day, and where the destination of the first flight matches the origin of the second flight).

To search for a flight itinerary, one specifies an *origin city*, a *destination city*, a *flight date*, a *maximum number of itineraries to display*,
and *whether they only wish to search for direct flights* or whether they are open to one-stop flights.
The flight itineraries that match the search commands are returned, in order of shortest to longest total itinerary flight time.

A logged-in user may try to *book a flight itinerary that they searched for*.
To do so, the user specifies an *itinerary from their most recent search*.
They may book the itinerary as long as there remains capacity on all flights contained in the itinerary.
That is, if one of the flights a user wishes to book has no capacity remaining (because other users already made reservations for that flight), then the booking is not allowed.
If the reservation is successful, it is recorded in the database with the user that booked it.

A user may later *pay for their reservation*. In order to pay, the user must have enough balance in their account to afford the flight's price.

Alternatively, users may *cancel reservations* (either paid or unpaid). A canceled reservation is deleted, as if it never occurred, 
and any money paid is refunded to the user's balance.


#### E/R Diagram
From the above description, determine entities, relationships, and attributes you need to consider in order to support your service's operations.
Write these in an E/R diagram. Include primary keys on all entities. Include constraints on relationship connectors where appropriate.

*You are not required to list the attributes of Flights, Carriers, Months, or Weekdays, since these are given in hw2.*
All other entities must have attributes and primary keys listed.

You may draw your E/R diagram on paper and scan it, take *quality* pictures of your drawn diagram, 
or use your favorite drawing tool such as Powerpoint, Keynote, or [draw.io](https://www.draw.io/). 
(FYI: Google Slides lacks a few shapes that you might need such as rounded arrows... you can use a crescent and a line).

Name your file `hw4-flightapp.pdf`. If you choose to take a picture, please use the tool <https://imagetopdf.com> to convert your image to a pdf.



### Part 2: From E/R to Cardinality Estimates

*License plate* can have letters and numbers; *driverID* and *Social Security* contain only numbers; 
*maxLiability* is a real number; *year*, *phone*, *capacity* are integers; everything else are strings.


#### Part 2a: Creating Tables from an E/R Diagram (20 points)

1. (10 points) Translate the diagram above by writing the SQL `CREATE TABLE` statements to represent this E/R diagram. 
Include all key constraints; you should specify both primary and foreign keys. 
Make sure that your statements are syntactically correct (you might want to check them using SQLite, Azure SQL Server, or another relational database).
2. (5 points) Which relation in your relational schema represents the relationship "insures" in the E/R diagram? Why is that your representation?
3. (5 points) Compare the representation of the relationships "drives" and "operates" in your schema, and explain why they are different.

Write your answers in a SQL file named `hw4-driving.sql`.
Write your answers to questions 2 and 3 as *SQL comments* in the same file.


#### Part 2b: Planning a query and estimating cardinality (15 points)

The insurance companies are concerned about low-probability disasters! They have hired you as consultants.
Unfortunately, they are not willing to share their data with you since it contains protected information.

Suppose every vehicle insured by an insurance company is [totaled](https://www.insurance.com/auto-insurance/claims/understanding-your-options-for-a-totaled-car.aspx)
so that the insurance companies must pay out all of their policies' maxLiabilities.
*How much will the insurance companies have to pay out to each person they insure?*
This is a serious matter, so the insurance companies would like you to draw an RA Plan to answer this question and estimate the cardinality of the output of each RA operator, in order to estimate how expensive it is to answer this grave question.

Specifically, the insurance company expects an answer in the following format:

```
insuranceCo  personName  payout
-----------  ----------  ------
Company A    Sasha       3000
...          ...         ...

```

The total payout for each insurance company to each person is the sum of maxLiabilities of all vehicles that person owns that is insured by that company.

The insurance companies disclose the following statistics:

* There are 20 insurance companies.
* Each insurance company has a different phone number.
* There are 1000 people.
* There are 960 distinct names among the 1000 people.
* There are 400 vehicles.
* There are 30 distinct vehicle years.
* There are 250 distinct maxLiabilities.
* MaxLiabilities range between 0 and $50,000.

Draw an RA Plan to answer the question above, using the schema you designed for the E/R diagram.
Annotate each RA operator with a cardinality estimate. Include the calculation you used to compute your estimate.

You may draw your E/R diagram on paper and scan it, take *quality* pictures of your drawn diagram, 
or use your favorite drawing tool such as Powerpoint, Keynote, or [draw.io](https://www.draw.io/). 

Name your file `hw4-ra-card.pdf`. If you choose to take a picture, please use the tool <https://imagetopdf.com> to convert your image to a pdf.

Can you draw an RA Plan that has lower cardinalities of RA operators? 
This is the work that database optimizers perform.
Extra credit may be awarded for more optimal RA Plans (that is, those plans that have a lower maximum cardinality estimate among all their operators).

Tip: avoid large Cartesian products. Push down selection and aggregation operators as much as possible.



### Part 3: Functional Dependency Theory (15 points)

A set of attributes X is called closed (with respect to a given set of functional dependencies) if X⁺ = X. 
Consider a relation with schema R(A,B,C,D) and an unknown set of functional dependencies. 
For each closed attribute set below, give a *set of functional dependencies* that is consistent with it.

1. All subsets of {A,B,C,D} are closed.
2. The only closed subsets of {A,B,C,D} are {} and {A,B,C,D}.
3. The only closed subsets of {A,B,C,D} are {}, {B,C}, and {A,B,C,D}.

Write your answers in a text file named `hw4-theory.txt`.



### Part 4: Mr. Frumble Relationship Discovery & Normalization (30 points)

[Mr. Frumble](http://everythingbusytown.wikia.com/wiki/Mr._Frumble) (a great character for small kids who always gets into trouble) designed a simple database to record projected monthly sales in his small store. He never took a database class, so he came up with the following schema:

``Sales(name, discount, month, price)``

He inserted his data into a database, then realized that there was something wrong with it: it was difficult to update. 
He hires you as a consultant to fix his data management problems. 
He gives you this file [mrFrumbleData.txt](https://courses.cs.washington.edu/courses/cse344/mrFrumbleData.txt) and says: "Fix it for me!". 
Help him by normalizing his database. 
Unfortunately you cannot sit down and talk to Mr. Frumble to find out what functional dependencies make sense in his business. 
Instead, you will reverse engineer the functional dependencies from his data instance. 

1. Create a table in the database and load the data from the provided file into that table; use SQLite or any other relational DBMS if your choosing. 

    Turn in your create table statement. The data import statements are optional (you don't need to include these).

2. Find all nontrivial functional dependencies in the database.
This is a reverse engineering task, so expect to proceed in a trial and error fashion. Search first for the simple dependencies, say name → discount then try the more complex ones, like name, discount → month, as needed. To check each functional dependency you have to write a SQL query. 

    Your challenge is to write this SQL query for every candidate functional dependency that you check, such that:
    
     a. the query's answer is always short (say: no more than ten lines - remember that 0 results can be instructive as well)
     
     b. you can determine whether the FD holds or not by looking at the query's answer. 
     Try to be clever in order not to check too many dependencies, but don't miss potential relevant dependencies. 
     For example, if you have A → B and C → D, you do not need to derive AC → BD as well.

    Please write a SQL query for each functional dependency you find.
    Please also include a SQL query for at least one functional dependency that does not exist in the dataset.
    Remember, short queries are preferred.

    Don't forget to write the functional dependencies you find (and don't find!) in SQL comments.

3. Decompose the table into Boyce-Codd Normal Form (BCNF), and create SQL tables for the decomposed schema. Create keys and foreign keys where appropriate.
    
    For this question turn in the SQL commands for creating the tables.

4. Populate your BCNF tables from Mr. Frumble's data. 
For this you need to write SQL queries that load the tables you created in question 3 from the table you created in question 1.

    Here, turn in the SQL queries that load the tables, and count the size of the tables after loading them (obtained by running ``SELECT COUNT(*) FROM Table``).

Write your answers in a SQL file named `hw4-frumble.sql`.
Don't forget to use SQL comments for all non-SQL-code answers.

