USE world;

DROP Table if exists DeletedCity;
 
CREATE TABLE DeletedCity
    (ID INT UNSIGNED, Name VARCHAR(50), DeleteDate TIMESTAMP);

DROP TRIGGER IF EXISTS City_After_Delete ;

DELIMITER $$
CREATE TRIGGER City_After_Delete AFTER DELETE ON City
  FOR EACH ROW 
     INSERT INTO DeletedCity (ID, Name) 
         VALUES (OLD.ID, OLD.Name);
   $$
  DELIMITER ;
  
show triggers;
 
Select * from city; 
SELECT * FROM city where name = 'Chicago';
Select * from deletedCity; 

 
/* Class work: Create a trigger that audits all operations
       on the city table */
 
 
 /* Example of a transaction rollback
	even results from triggers are rolled back
 */
  START TRANSACTION;
  SELECT * FROM DeletedCity;
  SELECT * FROM city where name = 'Chicago';
  DELETE FROM city where name = 'Chicago';
  SELECT * FROM DeletedCity;
  ROLLBACK;
  SELECT * FROM DeletedCity;
