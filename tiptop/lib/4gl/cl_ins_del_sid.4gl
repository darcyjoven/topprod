# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: cl_insert_sid.4gl
# Descriptions...: 將view所需要的資訊新增到sid_file內
# Date & Author..: 2009/07/24 by Hiko
# Usage..........: CALL cl_ins_del_sid(1)
# Modify.........: No.FUN-980030 09/08/10 by Hiko For GP5.2
# Modify.........: No.FUN-AA0017 10/10/13 by Alex 新增TIPTOP對Sybase支持
# Modify.........: No.FUN-AB0060 10/11/15 by Kevin 設置Sybase日期
# Modify.........: No.TQC-D10049 13/01/11 by Kevin 加上 WHENEVER ERROR CONTINUE

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
##################################################
# Descriptions...: 將view所需要的資訊新增到sid_file內
# Date & Author..: 2009/07/24 by Hiko   #FUN-980030
# Input Parameter: p_action 1:新增 2:刪除
#                : p_plant 傳入工廠(跨工廠時,才可抓到正確的資料)
# Return code....: void
##################################################
FUNCTION cl_ins_del_sid(p_action, p_plant)
   DEFINE p_action  SMALLINT,
          p_plant   LIKE azw_file.azw01
   DEFINE l_sid01   LIKE sid_file.sid01
   DEFINE l_pid     LIKE type_file.num10
   DEFINE l_sid_cnt SMALLINT
   DEFINE l_dbs     LIKE azw_file.azw06
 
   WHENEVER ERROR CONTINUE                 #TQC-D10049
 
   #有調整時, 要記得與cl_user,cl_used同步.
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
 
   IF p_action=1 THEN
      CASE cl_db_get_database_type()
         WHEN "ORA"
            SELECT USERENV('SESSIONID') INTO l_sid01 FROM DUAL
         WHEN "MSV"
            PREPARE msv1 FROM "SELECT @@SPID "
            EXECUTE msv1 INTO l_sid01

            PREPARE msv3 FROM "SET DATEFORMAT YMD" #FUN-AB0060
            EXECUTE msv3
 
         WHEN "ASE"                           #FUN-AA0017
            PREPARE ase1 FROM "SELECT @@SPID "
            EXECUTE ase1 INTO l_sid01

            PREPARE ase3 FROM "SET DATEFORMAT YMD" #FUN-AB0060
            EXECUTE ase3 
         WHEN "DB2"
            SELECT application_id INTO l_sid01 FROM sysibm.sysdummy1
         OTHERWISE
            DISPLAY "Error: TIPTOP Still NOT Support ",cl_db_get_database_type()," Database."
            EXIT PROGRAM 
      END CASE

      SELECT count(*) INTO l_sid_cnt FROM sid_file WHERE sid01=l_sid01
      IF SQLCA.SQLCODE THEN
         CALL cl_err('sid_file error:',SQLCA.SQLCODE,1)
         RETURN 
      END IF

      IF l_sid_cnt > 0 THEN
         #刪除原本就存在相同的SESSIONID,這樣可以避免重覆.
         DELETE FROM sid_file WHERE sid01=l_sid01
      END IF
 
      IF p_plant = g_plant THEN
         LET l_dbs = g_dbs
      ELSE
         SELECT azw06 INTO l_dbs FROM azw_file WHERE azw01=p_plant
      END IF
 
      LET l_pid = FGL_GETPID()
      LET g_today = TODAY
      LET g_time = TIME
      DISPLAY ""
      DISPLAY "SESSIONID:",l_sid01,"  PLANT:",p_plant,"  DBNAME:",l_dbs
      INSERT INTO sid_file VALUES(l_sid01,p_plant,l_dbs,g_user,l_pid,g_prog,g_time,g_today)
   ELSE
      #DISPLAY "DELETE SESSIONID..."
      CASE cl_db_get_database_type()
         WHEN "ORA"
            SELECT USERENV('SESSIONID') INTO l_sid01 FROM DUAL
         WHEN "MSV"
            PREPARE msv2 FROM "SELECT @@SPID "
            EXECUTE msv2 INTO l_sid01
         WHEN "ASE"
            PREPARE ase2 FROM "SELECT @@SPID "      #FUN-AA0017
            EXECUTE ase2 INTO l_sid01
         WHEN "DB2"
            SELECT application_id INTO l_sid01 FROM sysibm.sysdummy1
         OTHERWISE
            DISPLAY "Error: TIPTOP Still NOT Support ",cl_db_get_database_type()," Database."
            EXIT PROGRAM 
      END CASE

      SELECT count(*) INTO l_sid_cnt FROM sid_file WHERE sid01=l_sid01
      IF SQLCA.SQLCODE THEN
         CALL cl_err('sid_file error:',SQLCA.SQLCODE,1)
         RETURN 
      END IF
      IF l_sid_cnt > 0 THEN
         #資料存在才刪除.
         DELETE FROM sid_file WHERE sid01=l_sid01
      END IF
   END IF
END FUNCTION
