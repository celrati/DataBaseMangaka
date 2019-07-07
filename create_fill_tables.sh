


# dropping the database if it exists #
psql -c '\x' -c 'drop database if exists mangaka_data';
# create a  new database MANGAKA_DATA #
psql -c '\x' -c 'create database mangaka_data';

# create all the tables #
psql -c '\x' --dbname=mangaka_data -c '\i create_All.sql';

#store all the functions_trigers #
psql -c '\x' --dbname=mangaka_data -c '\i create_Trigger.sql';

# insert all the data #
psql -c '\x' --dbname=mangaka_data -c '\i insert_Data.sql';

# we have to connect to psql #
psql
# after you have to do \c mangaka_data to chose this database #
