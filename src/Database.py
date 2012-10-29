#The Database Class
import psycopg2
import psycopg2.extras
import logging

class Database:
    def __init__(self,username,password,database,host):
        self.username = username
        self.password = password
        self.database = database
        self.host = host
        self.logger = logging.getLogger("sql_debug")
        self.logger.propagate = True
        try:
            self.con = psycopg2.connect('dbname=' + database + ' user=' + username + 
                                        ' password=' + password + ' host=' + host) 
        except psycopg2.DatabaseError, e:
            self.logger.error("Cannot connect to the database. Please check the database credentials " +
            "and try again");
            self.logger.debug("We got the following exception: " + e.pgerror)
            exit()

    #insert CVEs into the database
    def insertCve(self, cveId, cveSummary, cvssScore):
        insertCveSql = "insert into cve_list (cve_id, summary, cvss_score) values (%s,%s,%s) returning id";
        insertCveData = (cveId, cveSummary, float(cvssScore),)
        cursor = self.con.cursor()
        try:
            cursor.execute(insertCveSql, insertCveData)
            #no exception 
            self.con.commit()
            id = cursor.fetchone()[0]
            cursor.close()
            return id
        except psycopg2.DatabaseError, e:
            self.logger.error("There was a database error while inserting the CVE value.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
            return -1
        except psycopg2.ProgrammingError, e:
            self.logger.error("There was an error inserting the CVE value.")
            self.logger.debug("We got the following exception: "+ e.pgerror)
            self.con.rollback()
            cursor.close()
            return -1
        except psycopg2.InterfaceError, e:
            self.logger.error("There was an error inserting the CVE value.:")
            self.logger.debug("We got the following exception: "+ e.pgerror)
            self.con.rollback()
            cursor.close()
            return -1
        except psycopg2.IntegrityError, e:
            self.logger.error("There was an integrity error while inserting the CVE value." +
                              "This might be a repeated CVE ID,")
            self.logger.debug("We got the following exception: "+ e.pgerror)
    
    #insert CPEs into the database
    def insertCpe(self, cpeId, cpeName):
        insertCpeSql = "insert into cpe_list (cpe_id, cpe_name) values (%s,%s)"
        insertCpeData(cpeId, cpeName, )
        cursor = self.con.cursor()
        try:
            cursor.execute(insertCpeSql, insertCpeData)
            #no exceptions
            self.con.commit()
            cursor.close()
        except psycopg2.DatabaseError, e:
            self.logger.error("There was a database error while inserting the CPE value.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
        except psycopg2.ProgrammingError, e:
            self.logger.error("There was an error inserting the CPE value,")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
        
    #insert CVE references into the database:
    def insertCveReference(self, cveId, referenceSource, referenceLink):
        insertReferenceSql = ("insert into cve_references (cve_id, reference_source, reference_link" +
                             " values(%s,%s,%s)")
        insertReferenceData = (int(cveId), referenceSource, referenceLink, )
        cursor = self.con.cursor()
        try:
            cursor.execute(insertReferenceSql, insertReferenceData)
            #no exceptions
            self.con.commit()
            cursor.close()
        except psycopg2.DatabaseError, e:
            self.logger.error("There was a database error while inserting the CVE Reference.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
        except psycopg2.IntegrityError, e:
            self.logger.error("There was a foreign key error while inserting the CVE Reference.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
        except psycopg2.ProgrammingError, e:
            self.logger.error("There was an error while inserting the CVE reference.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
            
    #insert affected software into the database
    def insertAffectedSoftware(self, cveId, cpeId):
        insertAffectedSoftwareSql = ("insert into affected_software (cve_id,cpe_id) values"+
                                     "(%s,%s)")
        insertAffectedData = (int(cveId), int(cpeId))
        cursor = self.con.cursor()
        try:
            cursor.execute(insertAffectedSoftware, insertAffectedData)
            #no exceptions
            self.con.commit()
            cursor.close()
        except psycopg2.DatabaseError, e:
            self.logger.error("There was a database error while inserting into affected software.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
        except psycopg2.IntegrityError, e:
            self.logger.error("There was a foreign key error while inserting into affected software.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
        except psycopg2.ProgrammingError, e:
            self.logger.error("There was an error while inserting into affected software.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            self.con.rollback()
            cursor.close()
    
    #return CPE ID
    def returnCpeId(self, cpeValue):
        returnCpeIdSql = "select id from cpe_list where cpe_id=%s"
        returnCpeIdData = (cpeValue, )
        cursor = self.con.cursor()
        try:
            cursor.execute(returnCpeIdSql, returnCpeIdData)
            #no exceptions
            if cursor.rowcount>0:
                cpeId = cursor.fetchone()[0]
                cursor.close()
                return cpeId
            else:
                cursor.close()
                return -1
        except psycopg2.DatabaseError, e:
            self.logger.error("There was a database error while returning CPE ID,")
            self.logger.debug("We got the following exception: " + e.pgerror)
            cursor.close()
        except psycopg2.ProgrammingError, e:
            self.logger.error("There was an error while returning CPE ID.")
            self.logger.debug("We got the following exception: " + e.pgerror)
            cursor.close()
    
    
            
            
        