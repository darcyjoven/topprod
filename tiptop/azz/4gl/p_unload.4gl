# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: p_unload.4gl
# Descriptions...: p_unload DB to txt 
# Date & Author..: 11/12/05 By jrg542
# Modify.........: No.FUN-BB0068 11/12/05 By jrg542 整併unload unloadx 工具程式
# Modify.........: No:FUN-CA0016 12/12/28 By joyce 1.新增若有勾選使用unload指令需寄發e-mail通知系統管理員
#                                                  2.調整程式可比照之前unloadx的用法，可承接使用者輸入的sql語法

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS
   DEFINE l_db       LIKE type_file.chr50
   DEFINE l_file     STRING
   DEFINE l_table    STRING   # No:FUN-CA0016
   DEFINE l_sql      STRING   # No:FUN-CA0016
   DEFINE l_sql_1    STRING   # No:FUN-CA0016
   DEFINE l_args     LIKE type_file.num5
   DEFINE g_msg      LIKE type_file.chr1000
   DEFINE l_result   LIKE type_file.num5
END GLOBALS


MAIN
   
    LET g_bgjob = 'Y'

    LET l_db    = ARG_VAL(1)  #db name
    LET l_table = ARG_VAL(2)  #table name
    LET l_file  = ARG_VAL(3)  #file name
    LET l_sql   = ARG_VAL(4)  #sql statement    # No:FUN-CA0016
    LET l_args  = NUM_ARGS()  #外部參數個數

    # No:FUN-CA0016 ---modify start---
    DISPLAY "l_db:",l_db
    DISPLAY "l_table:",l_table
    DISPLAY "l_file:",l_file
    DISPLAY "l_sql:",l_sql

    #未輸入參數時中止作業
    IF cl_null(l_db) OR cl_null(l_file) THEN
       CALL p_unload_error()
    END IF
    # No:FUN-CA0016 --- modify end ---
    
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time    
    CALL cl_getmsg('azz1186',g_lang) RETURNING g_msg  #資料是重要機密，注意你是否擁有此權限
    DISPLAY g_msg

    CALL p_unload_action()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN


FUNCTION p_unload_action()
    DEFINE l_str    STRING 
    DEFINE l_tmp    STRING
    DEFINE l_azz12  LIKE azz_file.azz12    # No:FUN-CA0016
    DEFINE l_azz13  LIKE azz_file.azz13    # No:FUN-CA0016


    CLOSE DATABASE
    DATABASE l_db

    # No:FUN-CA0016 --- modify start---
 #  IF l_args < 3 THEN #外部參數個數 #順序:ds table_name       #No.FUN-BB0068
 #     IF l_args = 2 THEN #AND l_file IS NULL THEN #ds table_name
 #        LET l_sql = "SELECT * FROM ",l_table CLIPPED   
 #     END IF        
 #  ELSE               #順序: ds (table_name or sqlstatement) *.txt
 #     LET l_str = DOWNSHIFT(l_sql)
 #     IF NOT l_str.getIndexOf("select ",1) THEN # 判斷是否含有 select 敘述
 #        LET l_sql = "SELECT * FROM ",l_table CLIPPED
 #     END IF 
 #  END IF 

    # 之前unload 的用法： unload  ds ima_file [ima_file.txt]
    #     unloadx的用法： unloadx ds ima_file.txt "select * from ima_file"
    # 現在p_unload.4gl要同時能夠適用於unload及unloadx的用法，
    # 再依照unload或是unloadx傳入不同的參數去取得資料
    # 傳入的參數應為             p_unload  db_name table_name file_name     sql_statement
    # 例如：unload  -->  應傳入  p_unload  ds      ima_file   ima_file.txt  ""
    #       unloadx -->  應傳入  p_unload  ds      ""         ima_file.txt  "select * from ima_file"

    IF cl_null(l_sql) THEN
       LET l_sql_1 = "SELECT * FROM ",l_table CLIPPED
    ELSE
       LET l_sql_1 = l_sql
    END IF

    IF cl_null(l_file) THEN
       LET l_file = l_table CLIPPED,".txt"
    END IF

    #CALL p_db_psw_check("system", tmpsw.ed4_4 CLIPPED) 先暫時不作判斷，目前在shell 判斷

    LET l_result = TRUE

    DISPLAY "UNLOAD TO ",l_file," ",l_sql_1

    UNLOAD TO l_file l_sql_1
    #0 = OK, 100 = not row found, <0 = error 
    IF SQLCA.sqlcode  < 0  OR SQLCA.sqlcode  = 100 THEN 
       DISPLAY "Export Table : ",l_file ," Fail......"
       CALL cl_used(g_prog,g_time,2) RETURNING g_time

       LET l_result = FALSE   # No:FUN-CA0016
    END IF

    # 新增若有勾選使用unload指令需寄發e-mail通知系統管理員
    SELECT azz12,azz13 INTO l_azz12,l_azz13 FROM azz_file
    IF l_azz12 = "Y" THEN
       CALL p_unload_sendmail(l_azz13)
    END IF

    IF l_result THEN
       LET l_tmp = "DATABASE : ",l_db CLIPPED,"  UNLOAD TO ",l_file," ",l_sql,"   result : Success.........."
    ELSE
       LET l_tmp = "DATABASE : ",l_db CLIPPED,"  UNLOAD TO ",l_file," ",l_sql,"   result : False............"
    #  EXIT PROGRAM 
    END IF
    DISPLAY l_tmp
    # No:FUN-CA0016 --- modify end ---

    #留下系統紀錄
    IF cl_syslog("S","A",l_tmp) THEN END IF

END FUNCTION

FUNCTION p_unload_error()

   # No:FUN-CA0016 ---modify start---
   DISPLAY " "
   DISPLAY "Error. Missing Parameters."
   DISPLAY " "
   DISPLAY "Usage: p_unload dbname tablename filename sql_statement"
   DISPLAY "       p_unload dbname[:db-password:system-password] tablename filename [sql_statement]"
   DISPLAY "   OR  p_unload dbname[:db-password:system-password] [tablename] filename sql_statement"
   DISPLAY "Ex1  : p_unload ds1 ima_file ima_file.txt ''"
   DISPLAY "Ex2  : p_unload ds1 '' ima_file.txt 'select * from ima_file'"
   # No:FUN-CA0016 --- modify end ---

   EXIT PROGRAM(1)

END FUNCTION

# No:FUN-CA0016 ---start---
FUNCTION p_unload_sendmail(lc_azz13)
   DEFINE lc_azz13       LIKE azz_file.azz13
   DEFINE lc_sql_1       STRING
   DEFINE l_tempdir      LIKE type_file.chr20
   DEFINE lc_channel     base.Channel
   DEFINE l_str          STRING
   DEFINE l_cmd          STRING
   DEFINE lc_msg_s       STRING
   DEFINE lc_result_dec  LIKE type_file.chr10
   DEFINE lc_zx02        LIKE zx_file.zx02

 
   IF cl_null(lc_azz13) THEN
      RETURN
   END IF

   CALL ui.Interface.refresh()
   INITIALIZE g_xml.* TO NULL
   LET l_tempdir = FGL_GETENV('TEMPDIR')
   LET lc_msg_s = g_prog CLIPPED,'_',g_today CLIPPED,'_',l_table CLIPPED

   #Subject
   LET g_xml.subject = lc_msg_s CLIPPED
 
   #抓相關應通知人員email
   LET g_xml.recipient =  lc_azz13
 
   # 產生文本檔
   LET lc_msg_s = g_prog CLIPPED,'_',l_table CLIPPED,'.htm'    #FUN-9B0113
   LET lc_msg_s = os.Path.join(l_tempdir CLIPPED, lc_msg_s CLIPPED)
 
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(lc_msg_s,"w")
   CALL lc_channel.setDelimiter("")
 
   LET l_str = "<html>"
   CALL lc_channel.write(l_str)
   LET l_str = "<head>"
   CALL lc_channel.write(l_str)
 
   LET l_str = "<title>",g_xml.subject CLIPPED,"</title>"
   CALL lc_channel.write(l_str)
   LET l_str = "</head>"
   CALL lc_channel.write(l_str)
   LET l_str = "<body>"
   CALL lc_channel.write(l_str)
 
   ### 本文 ###
   # 取user名稱
   SELECT zx02 INTO lc_zx02 FROM zx_file
    WHERE zx01 = g_user

   # 組執行條件
   LET lc_sql_1 = "UNLOAD TO ",l_file CLIPPED," ",l_sql CLIPPED

   # 執行結果說明
   IF l_result > 0 THEN    # 表示成功
      LET lc_result_dec = "Success"
   ELSE
      LET lc_result_dec = "False"
   END IF

   LET l_str = cl_getmsg("lib-282",g_lang) CLIPPED,"<br>",
               cl_getmsg("axc-535",g_lang) CLIPPED,l_db CLIPPED,"<br>",
               cl_getmsg("azz-093",g_lang) CLIPPED," : ",cl_get_progname(g_prog,g_lang)," \(",g_prog CLIPPED,"\)<br>" ,
               cl_getmsg("lib-036",g_lang) CLIPPED," : ",lc_zx02 CLIPPED," \(",g_user CLIPPED,"\)<br>",
               cl_getmsg("lib-279",g_lang) CLIPPED," : ",TODAY," ",TIME,"<br>",
               cl_getmsg("lib-280",g_lang) CLIPPED," : ",lc_sql_1,"<br>",
               cl_getmsg("lib-281",g_lang) CLIPPED," : ",lc_result_dec CLIPPED
   CALL lc_channel.write(l_str)
 
   LET l_str = "</body>"
   CALL lc_channel.write(l_str)
   LET l_str = "</html>"
   CALL lc_channel.write(l_str)
   CALL lc_channel.close()
 
   LET g_xml.body = g_prog CLIPPED,'_',l_table CLIPPED,'.htm'   #FUN-9B0113
   LET g_xml.body = os.Path.join(l_tempdir CLIPPED, g_xml.body CLIPPED)
 
#  #抓附件
#  LET g_xml.attach=''

#  LET l_cmd = g_prog CLIPPED,".txt"
#  LET l_cmd = os.Path.join(l_tempdir CLIPPED, l_cmd CLIPPED)

#  IF os.Path.delete(l_cmd CLIPPED) THEN
#  END IF
#  CALL cl_null_cat_to_file(l_cmd CLIPPED)                  #FUN-9B0113

#  LET l_cmd = "echo 'Logestic\tProgram ID\tCarry Date\t",
#              "Carry Person' >>",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
#  RUN l_cmd
#  FOR l_j = 1 TO g_bmx_1.getlength()
#      IF cl_null(g_bmx_1[l_j].bmx01) THEN
#         CONTINUE FOR
#      END IF
#      IF g_bmx_1[l_j].sel = 'N' THEN
#         CONTINUE FOR
#      END IF
#      LET l_cmd = "echo ",g_azp[l_i].azp01 CLIPPED," \t",
#                  g_today," \t",
#                  g_user," >>",l_tempdir CLIPPED,"/",g_prog CLIPPED,".txt"
#      RUN l_cmd
#  END FOR

#  LET g_xml.attach = g_prog CLIPPED,'.txt'
#  LET g_xml.attach = os.Path.join(l_tempdir CLIPPED,g_xml.attach CLIPPED)
 
   DISPLAY g_xml.subject
   DISPLAY "Mail 收件人清單：" , g_xml.recipient
   CALL cl_jmail()
 
   IF os.Path.delete(g_xml.attach CLIPPED) THEN            #FUN-9B0113
   END IF
END FUNCTION
# No:FUN-CA0016 --- end ---
