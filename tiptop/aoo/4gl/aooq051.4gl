# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aooq051.4gl
# Descriptions...: 歷史報表列印
# Argument.......:
# Returning......:
# Date & Author..: 2008/03/17 By Jack Lai
# Modify.........: No.FUN-830111 08/03/25 By kevin 呼叫IE開啟rptlist.aspx
# Modify.........: No.FUN-860087 08/06/23 By jacklai 增加CR中介程式對Informix Unicode版的支持
# Modify.........: No.FUN-930166 09/03/30 By kevin 呼叫CR安全機制
# Modify.........: No.TQC-940059 09/04/24 By tsai_yen 透過背景作業呼叫報表程式,無資料會開空報表，例如axct100用背景呼叫axcr010
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C10115 12/01/31 31區rebuild的結果錯誤排除,cl_get_cr_url()少一參數
# Modify.........: No.FUN-C40012 12/04/03 By tsai_yen GP5.3 CR歷史報表aooq051因zax_file增加欄位zax41而修改
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-860087 --start--
GLOBALS
   DEFINE ms_codeset STRING
   DEFINE g_rptlist  LIKE type_file.chr1 #FUN-930166
   DEFINE gs_hostname   STRING    #AP SERVER Host Name   #FUN-C40012
   DEFINE g_asp_param   RECORD    #ASP.NET 參數           #FUN-C40012
           certid       STRING,
           a            STRING,
           t            STRING,
           t1           STRING,
           t2           STRING,
           t3           STRING,
           t4           STRING,
           t5           STRING,
           t6           STRING,
           t7           STRING,
           t8           STRING,
           limit        STRING
           END RECORD
END GLOBALS
#FUN-860087 --end--	
 
MAIN
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   CALL q051()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time         
END MAIN
 
FUNCTION q051()
   DEFINE l_certid      LIKE zax_file.zax01   
   DEFINE l_user        LIKE zax_file.zax02
   DEFINE l_rpt_path    LIKE zax_file.zax03
   DEFINE l_tsql        LIKE zax_file.zax04
   DEFINE l_param1      LIKE zax_file.zax05
   DEFINE l_trans_lang  LIKE zax_file.zax08
   DEFINE l_logo        LIKE zax_file.zax09
   DEFINE l_zax41       LIKE zax_file.zax41  #AP SERVER Host Name #FUN-C40012
   DEFINE l_zax42       LIKE zax_file.zax42  #ASP.NET的網址參數     #FUN-C40012
   DEFINE l_db_user     STRING
   DEFINE l_db_passwd   STRING
   DEFINE l_instance    STRING
   DEFINE l_url         STRING   
   DEFINE l_tmpstr      STRING
   DEFINE l_db_type     STRING
   DEFINE res           LIKE type_file.num10
   DEFINE i             LIKE type_file.num10
   DEFINE l_rep_db_pw,
          l_str,
          l_rep_db      STRING
   DEFINE l_str_ord,
          l_server,
          l_cli_ie_path,
          crip          STRING
          
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   
   LET l_certid = FGL_GETPID()
   LET l_user = g_user
   LET l_rpt_path = g_prog
   LET l_tsql = g_prog
   LET l_param1 = g_prog
   LET l_trans_lang = g_rlang
   LET l_logo = g_prog
   LET res = ""
   LET g_asp_param.certid  = NULL    #FUN-C40012
   LET g_asp_param.a  = gs_hostname  #FUN-C40012
   LET g_asp_param.t  = NULL         #FUN-C40012
   LET g_asp_param.t1 = NULL         #FUN-C40012
   LET g_asp_param.t2 = NULL         #FUN-C40012
   LET g_asp_param.t3 = NULL         #FUN-C40012
   LET g_asp_param.t4 = NULL         #FUN-C40012
   LET g_asp_param.t5 = NULL         #FUN-C40012
   LET g_asp_param.t6 = NULL         #FUN-C40012
   LET g_asp_param.t7 = NULL         #FUN-C40012
   LET g_asp_param.t8 = NULL         #FUN-C40012
   LET g_asp_param.limit = NULL      #FUN-C40012

   LET g_rptlist = "Y"                            #FUN-C40012
   CALL cl_set_cr_url() RETURNING l_url,l_zax42   #FUN-C40012
   LET l_zax41 = g_asp_param.a                    #FUN-C40012
   
   DISPLAY "l_certid:",l_certid
   DISPLAY "l_zax41:",l_zax41             #FUN-C40012
   DISPLAY "l_zax42:",l_zax42             #FUN-C40012
   DISPLAY "l_user:",l_user
   DISPLAY "l_rpt_path:",l_rpt_path
   DISPLAY "l_tsql:",l_tsql
   DISPLAY "l_param1:",l_param1
   DISPLAY "l_trans_lang:",l_trans_lang
   DISPLAY "l_logo:",l_logo
   
   INSERT INTO zax_file (zax01,zax02,zax03,zax04,zax05,zax08,zax09,
                        zax41, zax42)   #FUN-C40012
   VALUES (l_certid,l_user,l_rpt_path,l_tsql,l_param1,l_trans_lang,l_logo,
           l_zax41, l_zax42)   #FUN-C10034
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","zax_file",l_certid,"",SQLCA.SQLCODE,"","",0)
      RETURN
   END IF
   
   #FUN-930166 --start
   #LET g_rptlist = "Y"   #FUN-C40012 mark
   CALL cl_get_cr_url(l_url,"Y")   #TQC-940059 傳參數p_havedata="Y" #TQC-C10115
   #FUN-930166 --end
 
END FUNCTION
 
