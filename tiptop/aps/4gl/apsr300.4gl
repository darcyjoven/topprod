# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: apsr300.4gl
# Descriptions...: 料件採購明細查詢
# Input parameter:
# Date & Author..: No.FUN-960167 09/07/14 By Duke
# Modify.........: NO:FUN-A30102 10/03/29 By Lilan 檢核項目內的check,default "Y"
# Modify.........: NO:FUN-A40018 10/04/07 By Mandy 若料件的來源碼為「D:特性料件」時(ima08='D'),則補貨策略碼(ima37)不能設定為"2:MRP",要視為異常
# Modify.........: NO:FUN-B50022 11/05/30 By Mandy APS GP5.25 追版------

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS
END GLOBALS

   DEFINE tm  RECORD			        # Print condition RECORD
          recent_date       DATE,    
          ch01           VARCHAR(1),
          ch02           VARCHAR(1),
          ch03           VARCHAR(1),
          ch04           VARCHAR(1), 
   	      more	         VARCHAR(1)
              END RECORD

DEFINE   g_i             LIKE type_file.num5    
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   l_table         STRING                 
DEFINE   g_sql           STRING                 
DEFINE   g_str           STRING                 
DEFINE   l_sql         LIKE type_file.chr1000    # RDSQL STATEMENT

MAIN
   #FUN-B50022---mod---str---
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
   #FUN-B50022---mod---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
                                                                                                            
   LET g_sql = "items.type_file.chr30,",                                                                                             
               "mfile.gaz_file.gaz01,",                                                                                             
               "mfilename.gaz_file.gaz03,",                                                                                             
               "opcode.gaz_file.gaz01,",                                                                                           
               "opname.gaz_file.gaz03,",                                                                                             
               "errmsg.ze_file.ze03,",                                                                                             
               "filekey.type_file.chr100,",                                                                                             
               "errcode.ze_file.ze01"                                                                                             
   LET l_table = cl_prt_temptable("apsr300",g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?) "                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.recent_date = ARG_VAL(7)
   LET tm.ch01  = ARG_VAL(8)
   LET tm.ch02  = ARG_VAL(9)
   LET tm.ch03  = ARG_VAL(10)
   LET tm.ch04  = ARG_VAL(11)   
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r300_tm(0,0)		        # Input print condition
      ELSE CALL r300()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col	LIKE type_file.num5,         
          l_cmd		LIKE type_file.chr1000       

   LET p_row = 4 LET p_col = 16

   OPEN WINDOW r300_w AT p_row,p_col WITH FORM "aps/42f/apsr300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.recent_date = g_today

  #FUN-A30102 mod str -----
  #LET tm.ch01 = 'N'
  #LET tm.ch02 = 'N'
  #LET tm.ch03 = 'N'
  #LET tm.ch04 = 'N'
   LET tm.ch01 = 'Y'
   LET tm.ch02 = 'Y'
   LET tm.ch03 = 'Y'
   LET tm.ch04 = 'Y'
  #FUN-A30102 mod end -----

   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.recent_date 		# Condition
   INPUT BY NAME  tm.recent_date WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD recent_date
         IF cl_null(tm.recent_date) THEN
            NEXT FIELD recent_date
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF

   DISPLAY BY NAME tm.more,tm.ch01,tm.ch02,tm.ch03,tm.ch04 		# Condition
   INPUT BY NAME  tm.ch01,tm.ch02,tm.ch03,tm.ch04,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD ch01
         IF cl_null(tm.ch01) OR tm.ch01 NOT MATCHES '[YN]' THEN
            NEXT FIELD ch01
         END IF
      AFTER FIELD ch02
         IF cl_null(tm.ch02)  OR tm.ch02 NOT MATCHES '[YN]'  THEN
            NEXT FIELD ch02
         END IF
      AFTER FIELD ch03
         IF cl_null(tm.ch03)  OR tm.ch03 NOT MATCHES '[YN]'  THEN
            NEXT FIELD ch03
         END IF
      AFTER FIELD ch04
         IF cl_null(tm.ch04)  OR tm.ch04 NOT MATCHES '[YN]'  THEN
            NEXT FIELD ch04
         END IF
 
      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more  NOT MATCHES '[YN]'  OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='apsr300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apsr300','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,		
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.recent_date CLIPPED,"'",
                         " '",tm.ch01  CLIPPED,"'",
                         " '",tm.ch02  CLIPPED,"'",
                         " '",tm.ch03  CLIPPED,"'",
                         " '",tm.ch04  CLIPPED,"'",                        
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('apsr300',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r300()
   ERROR ""
END WHILE
   CLOSE WINDOW r300_w
END FUNCTION

FUNCTION r300()
   DEFINE l_name	LIKE type_file.chr20, 	   # External(Disk) file name      
          l_time	LIKE type_file.chr8,  	   # Used time for running the job 
          l_za05	LIKE type_file.chr1000,    
          i             LIKE type_file.num5,       
          sr              RECORD
                          items      LIKE type_file.chr30,   #檢核項目
                          mfile      LIKE gaz_file.gaz01,    #作業主檔
                          mfilename  LIKE gaz_file.gaz03,    #主檔名稱
                          opcode     LIKE gaz_file.gaz01,    #作業代號
                          opname     LIKE gaz_file.gaz03,    #作業名稱
                          errmsg     LIKE ze_file.ze03,      #異常訊息
                          filekey    LIKE type_file.chr30,   #檔案Key值
                          errcode    LIKE ze_file.ze01       #訊息碼
                        END RECORD                       

                                                                                                                                   
     CALL cl_del_data(l_table)          
     LET l_name = 'apsr300'
   ##檢核項目1 物料主檔-檢查料件基本資料維護(apsi308)
     IF tm.ch01 = 'Y' THEN
        CALL r300_ch01()
     END IF
   ##檢核項目2 自製料件無定義產品製程(aeci100)
     IF tm.ch02 = 'Y' THEN
        CALL r300_ch02()
     END IF
   ##檢核項目3 產品/替代製程工時檢核(aeci100,apsi326)
     IF tm.ch03 = 'Y' THEN
        CALL r300_ch03()
     END IF
   ##檢核項目4 產品/替代製程設備檢核(aeci100,apsi326)
     IF tm.ch04 = 'Y' THEN
        CALL r300_ch04()
     END IF

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     IF g_zz05 = 'Y' THEN                                                                                                                                                                                                                 
        LET g_str = 'Last Upgrade Date ',tm.recent_date                                                                                                           
     END IF                                                                                                                         
     LET g_str=g_str CLIPPED                                                                                                        
     LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     CALL cl_prt_cs3('apsr300',l_name,g_sql,g_str)                                                                                  

END FUNCTION

##檢核項目1 物料主檔-檢查料件基本資料維護(apsi308)
FUNCTION r300_ch01()
DEFINE   sr              RECORD
                          items      LIKE type_file.chr30,   #檢核項目
                          mfile      LIKE gaz_file.gaz01,    #作業主檔
                          mfilename  LIKE gaz_file.gaz03,    #主檔名稱
                          opcode     LIKE gaz_file.gaz01,    #作業代號
                          opname     LIKE gaz_file.gaz03,    #作業名稱
                          errmsg     LIKE ze_file.ze03,      #異常訊息
                          filekey    LIKE type_file.chr100,   #檔案Key值
                          errcode    LIKE ze_file.ze01       #訊息碼
                        END RECORD                       
     DEFINE l_i,l_cnt          LIKE type_file.num5          
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE g_ima       RECORD LIKE ima_file.*
     DEFINE g_vmi       RECORD LIKE vmi_file.* 

    #LET l_sql = " SELECT * FROM ima_file, vmi_file ",       #FUN-A40018--mark
     LET l_sql = " SELECT * FROM ima_file, OUTER vmi_file ", #FUN-A40018--add
                 "  WHERE ima01 = vmi_file.vmi01 ",
                 "    AND imaacti = 'Y' ",
                 "    AND imadate >= '",tm.recent_date CLIPPED,"'"
     LET l_sql = l_sql CLIPPED, ' ORDER BY vmi01 '
     PREPARE r300_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM          
     END IF
     DECLARE r300_curs  CURSOR FOR r300_prepare
     FOREACH r300_curs INTO g_ima.*,g_vmi.*
       #IF SQLCA.sqlcode != 0 THEN
       #   CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       #END IF
       #FUN-A40018--add---str---
       IF NOT cl_null(g_ima.ima37) AND g_ima.ima37 = '2' THEN
           IF NOT cl_null(g_ima.ima08) AND g_ima.ima08 = 'D' THEN
               CALL cl_getmsg('aps-786',g_lang) RETURNING sr.items
               LET sr.mfile = 'aimi100'
               SELECT gaz03 INTO sr.mfilename
                 FROM gaz_file
                WHERE gaz01 = sr.mfile
                  AND gaz02 = g_lang
               LET sr.opcode = 'aimi100'
               SELECT gaz03 INTO sr.opname
                 FROM gaz_file
                WHERE gaz01 = sr.opcode
                  AND gaz02 = g_lang   
               CALL cl_getmsg('mfg1015',g_lang) RETURNING sr.filekey 
               LET sr.filekey = sr.filekey,':',g_ima.ima01 CLIPPED
               LET sr.errcode = 'aps-101'
               CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
               EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                         sr.errmsg, sr.filekey,sr.errcode
           END IF
       END IF
       #FUN-A40018--add---end---
       IF g_vmi.vmi49=1 OR g_vmi.vmi50 = 1 THEN
          CALL cl_getmsg('aps-786',g_lang) RETURNING sr.items
          LET sr.mfile = 'aimi100'
          SELECT gaz03 INTO sr.mfilename
            FROM gaz_file
           WHERE gaz01 = sr.mfile
             AND gaz02 = g_lang
          LET sr.opcode = 'apsi308'
          SELECT gaz03 INTO sr.opname
            FROM gaz_file
           WHERE gaz01 = sr.opcode
             AND gaz02 = g_lang   
          CALL cl_getmsg('mfg1015',g_lang) RETURNING sr.filekey 
          LET sr.filekey = sr.filekey,':',g_ima.ima01 CLIPPED
          LET sr.errcode = 'aps-796'
          CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
          EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                    sr.errmsg, sr.filekey,sr.errcode
       END IF
       IF (g_ima.ima08 ='M' OR g_ima.ima08 = 'U') AND
          (g_vmi.vmi16 = 0) THEN
          CALL cl_getmsg('aps-786',g_lang) RETURNING sr.items
          LET sr.mfile = 'aimi100'
          SELECT gaz03 INTO sr.mfilename
            FROM gaz_file
           WHERE gaz01 = sr.mfile
             AND gaz02 = g_lang
          LET sr.opcode = 'apsi308'
          SELECT gaz03 INTO sr.opname
            FROM gaz_file
           WHERE gaz01 = sr.opcode
             AND gaz02 = g_lang   
          CALL cl_getmsg('mfg1015',g_lang) RETURNING sr.filekey 
          LET sr.filekey = sr.filekey,':',g_ima.ima01 CLIPPED
          LET sr.errcode = 'aps-780'
          CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
          EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                    sr.errmsg, sr.filekey,sr.errcode
       END IF                             
       IF (g_ima.ima08 ='P' OR g_ima.ima08 = 'V') AND
          (g_vmi.vmi17 = 0) THEN
          CALL cl_getmsg('aps-786',g_lang) RETURNING sr.items
          LET sr.mfile = 'aimi100'
          SELECT gaz03 INTO sr.mfilename
            FROM gaz_file
           WHERE gaz01 = sr.mfile
             AND gaz02 = g_lang
          LET sr.opcode = 'apsi308'
          SELECT gaz03 INTO sr.opname
            FROM gaz_file
           WHERE gaz01 = sr.opcode
             AND gaz02 = g_lang   
          CALL cl_getmsg('mfg1015',g_lang) RETURNING sr.filekey 
          LET sr.filekey = sr.filekey,':',g_ima.ima01 CLIPPED
          LET sr.errcode = 'aps-781'
          CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
          EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                    sr.errmsg, sr.filekey,sr.errcode
       END IF                                                                                                                              
     END FOREACH
END FUNCTION

##檢核項目2 自製料件無定義產品製程(aeci100)
FUNCTION r300_ch02()
DEFINE   sr              RECORD
                          items      LIKE type_file.chr30,   #檢核項目
                          mfile      LIKE gaz_file.gaz01,    #作業主檔
                          mfilename  LIKE gaz_file.gaz03,    #主檔名稱
                          opcode     LIKE gaz_file.gaz01,    #作業代號
                          opname     LIKE gaz_file.gaz03,    #作業名稱
                          errmsg     LIKE ze_file.ze03,      #異常訊息
                          filekey    LIKE type_file.chr100,   #檔案Key值
                          errcode    LIKE ze_file.ze01       #訊息碼
                        END RECORD                       
     DEFINE l_i,l_cnt          LIKE type_file.num5          
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE g_ima       RECORD LIKE ima_file.*
     DEFINE g_ecu       RECORD LIKE ecu_file.* 

     LET l_sql = " SELECT * FROM ima_file ",
                 "  WHERE imaacti = 'Y' ",
                 "    AND ima08 in ('M','U') ",
                 "    AND ima01 NOT IN  ",
                 "        (SELECT DISTINCT ecu01 FROM ecu_file ", 
                 "          WHERE ecuacti = 'Y'                ",
                 "         )                                   ", 
                 "    AND imadate >= '",tm.recent_date CLIPPED,"' "
     LET l_sql = l_sql CLIPPED, ' ORDER BY ima01 '
     PREPARE r302_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM          
     END IF
     DECLARE r302_curs  CURSOR FOR r302_prepare
     FOREACH r302_curs INTO g_ima.*
       #IF SQLCA.sqlcode != 0 THEN
       #   CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       #END IF     
        CALL cl_getmsg('aps-787',g_lang) RETURNING sr.items
        LET sr.mfile = 'aeci100'
        SELECT gaz03 INTO sr.mfilename
          FROM gaz_file
         WHERE gaz01 = sr.mfile
           AND gaz02 = g_lang
        LET sr.opcode = 'aeci100'
        SELECT gaz03 INTO sr.opname
          FROM gaz_file
         WHERE gaz01 = sr.opcode
           AND gaz02 = g_lang   
        CALL cl_getmsg('aps-788',g_lang) RETURNING sr.filekey 
        LET sr.filekey = sr.filekey,':',g_ima.ima01 CLIPPED
        LET sr.errcode = 'aps-782'
        CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
        EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                  sr.errmsg, sr.filekey,sr.errcode
     END FOREACH
END FUNCTION

##檢核項目3 產品/替代製程工時檢核(aeci600,aeci100,apsi326)
FUNCTION r300_ch03()
DEFINE   sr              RECORD
                          items      LIKE type_file.chr30,   #檢核項目
                          mfile      LIKE gaz_file.gaz01,    #作業主檔
                          mfilename  LIKE gaz_file.gaz03,    #主檔名稱
                          opcode     LIKE gaz_file.gaz01,    #作業代號
                          opname     LIKE gaz_file.gaz03,    #作業名稱
                          errmsg     LIKE ze_file.ze03,      #異常訊息
                          filekey    LIKE type_file.chr100,   #檔案Key值
                          errcode    LIKE ze_file.ze01       #訊息碼
                        END RECORD                       
     DEFINE l_i,l_cnt          LIKE type_file.num5          
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE g_eca       RECORD LIKE eca_file.*
     DEFINE g_ecb       RECORD LIKE ecb_file.*
     DEFINE g_vms       RECORD LIKE vms_file.* 
     DEFINE l_str       LIKE   ze_file.ze03

     ##產品製程工時檢核 (aeci100)
     LET l_sql = " SELECT * FROM ecb_file,eca_file ",
                 "  WHERE ecb08 = eca01 ",
                 "    AND ecbacti = 'Y' ",
                 "    AND ecbdate >= '",tm.recent_date CLIPPED,"' "
     LET l_sql = l_sql CLIPPED, ' ORDER BY ecb01,ecb02,ecb03 '
     PREPARE r3031_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM          
     END IF
     DECLARE r3031_curs  CURSOR FOR r3031_prepare
     FOREACH r3031_curs INTO g_ecb.*, g_eca.*
       #IF SQLCA.sqlcode != 0 THEN
       #   CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       #END IF     
        CALL cl_getmsg('aps-789',g_lang) RETURNING sr.items
        LET sr.mfile = 'aeci100'
        SELECT gaz03 INTO sr.mfilename
          FROM gaz_file
         WHERE gaz01 = sr.mfile
           AND gaz02 = g_lang
        LET sr.opcode = 'aeci100'
        SELECT gaz03 INTO sr.opname
          FROM gaz_file
         WHERE gaz01 = sr.opcode
           AND gaz02 = g_lang   
         CALL cl_getmsg('aps-788',g_lang) RETURNING l_str 
         LET sr.filekey = l_str,':',g_ecb.ecb01 CLIPPED
         CALL cl_getmsg('aps-790',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_ecb.ecb02 CLIPPED
         CALL cl_getmsg('aps-791',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_ecb.ecb03 USING '<<<<' 
         CALL cl_getmsg('aps-792',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_ecb.ecb06 CLIPPED            

        ##工作站類型 -- 機器
        IF g_eca.eca06 = '1' AND g_ecb.ecb20 = 0 AND g_ecb.ecb21 = 0 THEN
            LET sr.errcode = 'aps-783'
            CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
            EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                      sr.errmsg, sr.filekey,sr.errcode
        END IF  

        ##工作站類型 -- 工作站
        IF g_eca.eca06 = '2' AND g_ecb.ecb18 = 0 AND g_ecb.ecb19 = 0 THEN
            LET sr.errcode = 'aps-784'
            CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
            EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                      sr.errmsg, sr.filekey,sr.errcode
        END IF                                      
     END FOREACH
     
     ##替代製程工時檢核 (apsi326)
     LET l_sql = " SELECT * FROM vms_file,ecb_file,eca_file ",
                 "  WHERE vms01 = ecb01 ",
                 "    AND vms02 = ecb02 ",
                 "    AND vms03 = ecb03 ",
                 "    AND vms07 = eca01 ", 
                 "    AND ecbacti = 'Y' ",
                 "    AND ecbdate >= '",tm.recent_date CLIPPED,"' "
     LET l_sql = l_sql CLIPPED, ' ORDER BY vms01,vms02,vms03 '
     PREPARE r3032_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM          
     END IF
     DECLARE r3032_curs  CURSOR FOR r3032_prepare
     FOREACH r3032_curs INTO g_vms.*,g_ecb.*, g_eca.*
       #IF SQLCA.sqlcode != 0 THEN
       #   CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       #END IF     
        CALL cl_getmsg('aps-793',g_lang) RETURNING sr.items
        LET sr.mfile = 'aeci100'
        SELECT gaz03 INTO sr.mfilename
          FROM gaz_file
         WHERE gaz01 = sr.mfile
           AND gaz02 = g_lang
        LET sr.opcode = 'apsi326'
        SELECT gaz03 INTO sr.opname
          FROM gaz_file
         WHERE gaz01 = sr.opcode
           AND gaz02 = g_lang   
         CALL cl_getmsg('aps-788',g_lang) RETURNING l_str 
         LET sr.filekey = l_str,':',g_vms.vms01 CLIPPED
         CALL cl_getmsg('aps-790',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_vms.vms02 CLIPPED
         CALL cl_getmsg('aps-791',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_vms.vms03 USING '<<<<'
         CALL cl_getmsg('aps-792',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_vms.vms04 CLIPPED            
         CALL cl_getmsg('aap-417',g_lang) RETURNING l_str
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_vms.vms05 USING '<<<<'


        ##工作站類型 -- 機器
        IF g_eca.eca06 = '1' AND g_vms.vms11 = 0 AND g_vms.vms12 = 0 THEN
            LET sr.errcode = 'aps-783'
            CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
            EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                      sr.errmsg, sr.filekey,sr.errcode
        END IF  

        ##工作站類型 -- 工作站
        IF g_eca.eca06 = '2' AND g_vms.vms09 = 0 AND g_vms.vms10 = 0 THEN
            LET sr.errcode = 'aps-784'
            CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
            EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                      sr.errmsg, sr.filekey,sr.errcode
        END IF                                      
     END FOREACH
     
     
END FUNCTION


##檢核項目4 產品/替代製程設備檢核(aeci100,apsi326)
FUNCTION r300_ch04()
DEFINE   sr              RECORD
                          items      LIKE type_file.chr30,   #檢核項目
                          mfile      LIKE gaz_file.gaz01,    #作業主檔
                          mfilename  LIKE gaz_file.gaz03,    #主檔名稱
                          opcode     LIKE gaz_file.gaz01,    #作業代號
                          opname     LIKE gaz_file.gaz03,    #作業名稱
                          errmsg     LIKE ze_file.ze03,      #異常訊息
                          filekey    LIKE type_file.chr100,   #檔案Key值
                          errcode    LIKE ze_file.ze01       #訊息碼
                        END RECORD                       
     DEFINE l_i,l_cnt          LIKE type_file.num5          
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE g_eca       RECORD LIKE eca_file.*
     DEFINE g_ecb       RECORD LIKE ecb_file.*
     DEFINE g_vms       RECORD LIKE vms_file.* 
     DEFINE l_str       LIKE   ze_file.ze03
     DEFINE l_vmn08     LIKE   vmn_file.vmn08
     DEFINE l_vmn081    LIKE   vmn_file.vmn081

     ##產品製程工時檢核 (aeci100)
     LET l_sql = " SELECT * FROM ecb_file ",
                 "  WHERE ecbacti = 'Y' ",
                 "    AND ecbdate >= '",tm.recent_date CLIPPED,"' "
     LET l_sql = l_sql CLIPPED, ' ORDER BY ecb01,ecb02,ecb03 '
     PREPARE r3041_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM          
     END IF
     DECLARE r3041_curs  CURSOR FOR r3041_prepare
     FOREACH r3041_curs INTO g_ecb.*
       #IF SQLCA.sqlcode != 0 THEN
       #   CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       #END IF     
        CALL cl_getmsg('aps-794',g_lang) RETURNING sr.items
        LET sr.mfile = 'aeci100'
        SELECT gaz03 INTO sr.mfilename
          FROM gaz_file
         WHERE gaz01 = sr.mfile
           AND gaz02 = g_lang
        LET sr.opcode = 'aeci100'
        SELECT gaz03 INTO sr.opname
          FROM gaz_file
         WHERE gaz01 = sr.opcode
           AND gaz02 = g_lang   
         CALL cl_getmsg('aps-788',g_lang) RETURNING l_str 
         LET sr.filekey = l_str,':',g_ecb.ecb01 CLIPPED
         CALL cl_getmsg('aps-790',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_ecb.ecb02 CLIPPED
         CALL cl_getmsg('aps-791',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_ecb.ecb03 USING '<<<<'
         CALL cl_getmsg('aps-792',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_ecb.ecb06 CLIPPED            

        LET l_vmn08 = NULL
        LET l_vmn081 = NULL
        SELECT vmn08,vmn081 INTO l_vmn08,l_vmn081
          FROM vmn_file
         WHERE vmn01 = g_ecb.ecb01
           AND vmn02 = g_ecb.ecb02
           AND vmn03 = g_ecb.ecb03
           AND vmn04 = g_ecb.ecb06
        IF g_sma.sma917 =1 THEN 
            ##整合資源型態 -- 機器
            IF cl_null(l_vmn08) AND cl_null(g_ecb.ecb07) THEN
                LET sr.errcode = 'aps-033'
                CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
                EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                          sr.errmsg, sr.filekey,sr.errcode
            END IF
        ELSE
            ##整合資源型態 -- 工作站
            IF cl_null(l_vmn081) AND cl_null(g_ecb.ecb08)   THEN
                LET sr.errcode = 'aps-785'
                CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
                EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                          sr.errmsg, sr.filekey,sr.errcode
            END IF
        END IF                                      
     END FOREACH
     
     ##替代製程工時檢核 (apsi326)
     LET l_sql = " SELECT * FROM vms_file,ecb_file ",
                 "  WHERE vms01 = ecb01 ",
                 "    AND vms02 = ecb02 ",
                 "    AND vms03 = ecb03 ",
                 "    AND ecbacti = 'Y' ",
                 "    AND ecbdate >= '",tm.recent_date CLIPPED,"' "
     LET l_sql = l_sql CLIPPED, ' ORDER BY vms01,vms02,vms03 '
     PREPARE r3042_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM          
     END IF
     DECLARE r3042_curs  CURSOR FOR r3042_prepare
     FOREACH r3042_curs INTO g_vms.*,g_ecb.*
       #IF SQLCA.sqlcode != 0 THEN
       #   CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       #END IF     
       
        CALL cl_getmsg('aps-795',g_lang) RETURNING sr.items
        LET sr.mfile = 'aeci100'
        SELECT gaz03 INTO sr.mfilename
          FROM gaz_file
         WHERE gaz01 = sr.mfile
           AND gaz02 = g_lang
        LET sr.opcode = 'apsi326'
        SELECT gaz03 INTO sr.opname
          FROM gaz_file
         WHERE gaz01 = sr.opcode
           AND gaz02 = g_lang   
         CALL cl_getmsg('aps-788',g_lang) RETURNING l_str 
         LET sr.filekey = l_str,':',g_vms.vms01 CLIPPED
         CALL cl_getmsg('aps-790',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_vms.vms02 CLIPPED
         CALL cl_getmsg('aps-791',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_vms.vms03 USING '<<<<'
         CALL cl_getmsg('aps-792',g_lang) RETURNING l_str 
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_vms.vms04 CLIPPED            
         CALL cl_getmsg('aap-417',g_lang) RETURNING l_str
         LET sr.filekey = sr.filekey,' + ',l_str,':',g_vms.vms05 USING '<<<<'

        LET l_vmn08  = NULL
        LET l_vmn081 = NULL
        SELECT vmn08,vmn081 INTO l_vmn08,l_vmn081
          FROM vmn_file
         WHERE vmn01 = g_vms.vms01
           AND vmn02 = g_vms.vms02
           AND vmn03 = g_vms.vms03
           AND vmn04 = g_vms.vms04
        IF g_sma.sma917 = 1 THEN 
            ##整合資源型態 -- 機器
            IF cl_null(l_vmn08) AND cl_null(g_vms.vms08) THEN
                LET sr.errcode = 'aps-033'
                CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
                EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                          sr.errmsg, sr.filekey,sr.errcode
            END IF  
        ELSE
            ##整合資源型態 -- 工作站
            IF cl_null(l_vmn081) AND cl_null(g_vms.vms07) THEN
                LET sr.errcode = 'aps-785'
                CALL cl_getmsg(sr.errcode,g_lang) RETURNING sr.errmsg               
                EXECUTE insert_prep USING sr.items, sr.mfile,sr.mfilename,sr.opcode,sr.opname,                                                    
                                          sr.errmsg, sr.filekey,sr.errcode
            END IF  
        END IF                                      
     END FOREACH
     
     
END FUNCTION

#Patch....NO:FUN-960167 <001> #
