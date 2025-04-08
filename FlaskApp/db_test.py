"Database Connecton Test"
import mysql.connector

def get_database_connection():
    "Build a database connection"
    conn = mysql.connector.connect(user='root', password='1keytone',host='test-stack-labdbinstance-iwn8wkt1epiz.cvasewix0fhp.us-west-2.rds.amazonaws.com', database='TEST-routes')
    return conn
    
mydb = get_database_connection()

mycursor = mydb.cursor()
mycursor.execute("SELECT User FROM mysql.user;")
myresult = mycursor.fetchall()

print("MySQL Users:")
for user in myresult:
    print(user[0])