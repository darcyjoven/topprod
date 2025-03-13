# Prog. Version..: '5.30.07-13.05.16(00006)'     #
#
# Library name...: cl_repcon
# Descriptions...: 詢問特殊列印條件
#                      (1) 製表日期
#                      (2) 報表收受單位或人員
#                      (3) 選擇語言別
#                      (4) 是否後庭執行本作業 及 執行時間
#                      (5) 選擇列印方式
#                      (6) 列印份數
# Input Parameter: p_pdate
#                  p_towhom
#                  p_lang
#                  p_bgjob
#                  p_time
#                  p_prtway
#                  p_copies
# Return Code....: p_pdate
#                  p_towhom
#                  p_lang
#                  p_bgjob
#                  p_time
#                  p_prtway
#                  p_copies
# Usage..........: call cl_repcon(p_row,p_col,p_pdate,p_towhom,p_lang,
#                                 p_bgjob,p_time,p_prtway,p_copies)
#                       returning p_row,p_col,p_pdate,p_towhom,p_lang,
#                                 p_bgjob,p_time,p_prtway,p_copies
# Date & Author..: 91/05/28 By LYS
# Revise record..:
# Modify.........: 04/10/26 by Brendan - Processs model changed
# Modify.........: No.FUN-570264 05/07/28 By saki 背景作業選擇樣板
# Modify.........: No.TQC-5A0059 06/01/09 By coco 其他特殊列印條件中的列印方式跟列印份數拿掉
# Modify.........: No.FUN-630099 06/03/31 By Echo zy06 VARCHAR(10)放大為char(20)
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-690103 06/10/18 By saki 變更p_time長度
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-7C0058 07/12/19 By jacklai 補充lib的說明資料
# Modify.........: No.FUN-7C0078 07/12/25 By jacklai 增加CrystalReports背景作業功能
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.FUN-A80044 10/08/06 By Hiko 宣告變數不參考zld_file
# Modify.........: No.FUN-B80097 11/08/30 By jacklai 增加GR背景作業功能
# Modify.........: No.FUN-D20057 13/02/21 By odyliao 增加XtraGrid背景作業功能

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE m_lang  LIKE type_file.chr1  #No.FUN-7C0078

FUNCTION cl_repcon(p_row,p_col,p_pdate,p_towhom,p_lang,p_bgjob,p_time,p_prtway,p_copies)
   DEFINE p_row        LIKE type_file.num5,          #No.FUN-690005 SMALLINT
          p_col        LIKE type_file.num5,          #No.FUN-690005 SMALLINT
          p_pdate      LIKE type_file.dat,              #No.FUN-690005  DATE
          p_towhom     LIKE type_file.chr50,             #No.FUN-690005  VARCHAR(15) #FUN-A80044:原本為zld_file.zld19:varchar2(60)
          p_lang       LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
          p_bgjob      LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
          p_time       LIKE type_file.chr8,             #No.FUN-690005  VARCHAR(5)  #No.FUN-690103
          p_prtway     LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
          l_time       LIKE type_file.chr5,             #No.FUN-690005  VARCHAR(5)
          p_copies     LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
      #   p_plant      LIKE apm_file.apm08,             #No.FUN-690005  VARCHAR(10)     #No.TQC-6A0079
          ls_msg       LIKE ze_file.ze03                #No.FUN-690005  VARCHAR(100)
   DEFINE ls_sql       STRING,              #No.FUN-570264
          li_cnt       LIKE type_file.num5,             #No.FUN-690005  SMALLINT            #No.FUN-570264
          lc_zaa10     LIKE zaa_file.zaa10  #No.FUN-570264
   #DEFINE li_cnt2      LIKE type_file.num10             #No.FUN-7C0078 #No.FUN-B80097 mark
   #DEFINE lc_call_cr   LIKE type_file.chr1              #No.FUN-7C0078 #No.FUN-B80097 mark
   DEFINE lc_cust      LIKE type_file.chr1              #No.FUN-7C0078
   #DEFINE l_zz02       LIKE zz_file.zz02                #No.FUN-7C0078 #No.FUN-B80097 mark
   DEFINE li_cnt3      LIKE type_file.num10              #No.FUN-7C0078
   DEFINE li_reptype   LIKE type_file.num5              #No.FUN-B80097

   WHENEVER ERROR CALL cl_err_msg_log

   #No.FUN-B80097 --start--
   #判斷優先順序 GR, CR, zaa
   LET li_reptype = cl_prt_reptype(g_prog)
   DISPLAY "li_reptype=",li_reptype
   #No.FUN-7C0078 --start--
   #LET li_cnt2 = 0
   #SELECT COUNT(*) INTO li_cnt2 FROM zaw_file WHERE zaw01=g_prog
   #IF li_cnt2 > 0 THEN
   #   LET lc_call_cr = 'Y'
   #ELSE
   #   LET lc_call_cr = 'N'
   #END IF
   #No.FUN-7C0078 --end--
   #No.FUN-B80097

   IF p_row = 0
      THEN LET p_row = 3 LET p_col = 2
   END IF
   LET p_row = p_row - 1

   OPEN WINDOW cl_repcon_w AT p_row,p_col WITH FORM "lib/42f/cl_repcon"
        ATTRIBUTE (STYLE="lib")

   #No.FUN-7C0078 --start--
   #IF lc_call_cr = 'Y' THEN  #No.FUN-B80097
   #IF li_reptype >= 1 THEN    #No.FUN-B80097
   IF li_reptype MATCHES '[12]' THEN    #FUN-D20057 
      CALL cl_set_comp_visible("g_rpt_name",TRUE)
      CALL cl_set_comp_visible("p_towhom",FALSE)
   ELSE
      CALL cl_set_comp_visible("g_rpt_name",FALSE)
      CALL cl_set_comp_visible("p_towhom",TRUE)
   END IF
   #No.FUN-7C0078 --end--

   CALL cl_ui_locale("cl_repcon")

#   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-027' AND ze02 = g_lang
#   MESSAGE ls_msg CLIPPED

#----------
# Initialize values when enterring extra setting
#----------
   CALL cl_set_combo_lang("p_lang")
   IF cl_null(g_pdate) THEN
      LET g_pdate = g_today
   END IF
   IF cl_null(p_towhom) THEN
      LET p_towhom = g_user CLIPPED
   END IF
   IF cl_null(p_lang) THEN
      LET p_lang = g_lang
   END IF
### Mark by TQC-5A0059 ###
#   IF cl_null(p_prtway) THEN
#      LET p_prtway = '1'
#   END IF
#   IF cl_null(p_copies) THEN
#      LET p_copies = '1'
#   END IF
### Mark by TQC-5A0059 ###
   IF ( cl_null(p_bgjob) ) OR ( p_bgjob NOT MATCHES '[YyNn]' ) THEN
      LET p_bgjob = 'Y'
   END IF

#   DISPLAY BY NAME p_pdate,p_towhom,p_lang,p_bgjob,p_prtway,p_copies,p_javamail
   #No.FUN-570264 --start--
   LET g_rep_user = NULL
   LET g_rep_clas = NULL
   LET g_template = NULL
   #No.FUN-570264 ---end---
   LET g_rpt_name = NULL   #No.FUN-7C0078

   #INPUT BY NAME p_pdate,p_towhom,p_lang,p_prtway,p_copies,p_bgjob,g_rep_user,g_rep_clas,g_template ### TQC-5A0059 ### #No.FUN-7C0078
   INPUT BY NAME p_pdate,p_towhom,p_lang,p_bgjob,g_rep_user,g_rep_clas,g_template,g_rpt_name ### TQC-5A0059 ###   #No.FUN-7C0078
       WITHOUT DEFAULTS ATTRIBUTES(UNBUFFERED)   #No.FUN-570264

         #No.FUN-570264 --start--
         BEFORE INPUT
            IF p_bgjob = 'Y' THEN
               CALL DIALOG.setFieldActive("g_rep_user",TRUE)
               CALL DIALOG.setFieldActive("g_rep_clas",TRUE)
               CALL DIALOG.setFieldActive("g_template",TRUE)
               CALL cl_set_comp_required("g_template,g_rep_user,g_rep_clas",TRUE)
               #No.FUN-7C0078 --start--
               #IF lc_call_cr = 'Y' THEN #No.FUN-B80097
               #IF li_reptype >= 1 THEN #No.FUN-B80097
               IF li_reptype MATCHES '[12]' THEN #No.FUN-D20057 
                  CALL DIALOG.setFieldActive("g_rpt_name",TRUE)
                  CALL cl_set_comp_required("g_rpt_name",TRUE)
               ELSE
                  CALL DIALOG.setFieldActive("g_rpt_name",FALSE)
                  CALL cl_set_comp_required("g_rpt_name",FALSE)
               END IF
               #No.FUN-7C0078 --end--
            ELSE
               CALL DIALOG.setFieldActive("g_rep_user",FALSE)
               CALL DIALOG.setFieldActive("g_rep_clas",FALSE)
               CALL DIALOG.setFieldActive("g_template",FALSE)
               CALL cl_set_comp_required("g_template,g_rep_user,g_rep_clas",FALSE)
               #No.FUN-7C0078 --start--
               CALL DIALOG.setFieldActive("g_rpt_name",FALSE)
               CALL cl_set_comp_required("g_rpt_name",FALSE)
               #No.FUN-7C0078 --end--
            END IF
            IF cl_null(m_lang) THEN LET m_lang = p_lang END IF #No.FUN-B80097  
        #No.FUN-570264 ---end---

### Mark by TQC-5A0059 ###
#        AFTER FIELD p_prtway
#            IF p_bgjob = "Y" AND (p_prtway IS NULL OR p_prtway = 'Q')
#               THEN NEXT FIELD p_prtway
#            END IF
#            IF p_prtway IS NOT NULL AND NOT p_prtway_chk(p_prtway)
#               AND p_prtway <> ' '   #No.B463 add
#               THEN NEXT FIELD p_prtway
#            END IF
#            #No.B463 add
#            IF p_prtway IS NOT NULL AND p_prtway <> ' ' THEN
#               IF p_prtway NOT MATCHES '[123456789]' THEN
#                  NEXT FIELD p_prtway
#               END IF
#            END IF
### Mark by TQC-5A0059 ###
            #No.B463 end---

#----------
# While BACKGROUND JOB checked, the print way & copies is useless for configuration
#----------
        ON CHANGE p_bgjob
            IF p_bgjob = 'Y' THEN
### Mark by TQC-5A0059 ###
#               CALL DIALOG.setFieldActive("p_prtway", FALSE)
#               CALL DIALOG.setFieldActive("p_copies", FALSE)
### Mark by TQC-5A0059 ###
               #No.FUN-570264 --start--
               CALL DIALOG.setFieldActive("g_rep_user",TRUE)
               CALL DIALOG.setFieldActive("g_rep_clas",TRUE)
               CALL DIALOG.setFieldActive("g_template",TRUE)
               CALL cl_set_comp_required("g_rep_user,g_rep_clas,g_template",TRUE)
               #No.FUN-570264 ---end---
               #No.FUN-7C0078 --start--
               #IF lc_call_cr = 'Y' THEN #No.FUN-B80097
               #IF li_reptype >= 1 THEN #No.FUN-B80097
               IF li_reptype MATCHES '[12]' THEN #No.FUN-D20057
                  CALL DIALOG.setFieldActive("g_rpt_name",TRUE)
                  CALL cl_set_comp_required("g_rpt_name",TRUE)
               ELSE
                  CALL DIALOG.setFieldActive("g_rpt_name",FALSE)
                  CALL cl_set_comp_required("g_rpt_name",FALSE)
               END IF
               #No.FUN-7C0078 --end--
            ELSE
### Mark by TQC-5A0059 ###
#               CALL DIALOG.setFieldActive("p_prtway", TRUE)
#               CALL DIALOG.setFieldActive("p_copies", TRUE)
### Mark by TQC-5A0059 ###
               #No.FUN-570264 --start--
               CALL DIALOG.setFieldActive("g_rep_user",FALSE)
               CALL DIALOG.setFieldActive("g_rep_clas",FALSE)
               CALL DIALOG.setFieldActive("g_template",FALSE)
               CALL cl_set_comp_required("g_rep_user,g_rep_clas,g_template",FALSE)
               #No.FUN-570264 ---end---
               #No.FUN-7C0078 --start--
               CALL DIALOG.setFieldActive("g_rpt_name",FALSE)
               CALL cl_set_comp_required("g_rpt_name",FALSE)
               #No.FUN-7C0078 --end--
            END IF

       #No.FUN-570264 --start--
       AFTER FIELD g_rep_user
          #No.FUN-B80097 --start
          IF NOT cl_repcon_chkrep(li_reptype) THEN
                      NEXT FIELD g_rep_user
                   END IF
          #No.FUN-B80097 --end--

       AFTER FIELD g_rep_clas
          #No.FUN-B80097 --start
          IF NOT cl_repcon_chkrep(li_reptype) THEN
                      NEXT FIELD g_rep_clas
                   END IF
          #No.FUN-B80097 --end--

       AFTER FIELD g_rpt_name
          #No.FUN-B80097 --start
          IF NOT cl_repcon_chkrep(li_reptype) THEN
                 NEXT FIELD g_rpt_name
             END IF
          #No.FUN-B80097 --end--

       #No.FUN-B80097 --start
       ON CHANGE p_lang
             LET m_lang = p_lang
          
       ON ACTION ACCEPT
          IF NOT cl_repcon_chkrep(li_reptype) THEN
             NEXT FIELD p_lang
          ELSE
             EXIT INPUT
             END IF
       #No.FUN-B80097 --end--

       AFTER FIELD g_template
          #No.FUN-B80097 --start
          IF NOT cl_repcon_chkrep(li_reptype) THEN
                      NEXT FIELD g_template
                   END IF
          #No.FUN-B80097 --end--

       ON ACTION CONTROLP
          #IF lc_call_cr = 'N' THEN  #No.FUN-7C0078   #No.FUN-B80097
          IF li_reptype <= 0 THEN                     #No.FUN-B80097
             IF INFIELD(g_rep_user) OR INFIELD(g_rep_clas) OR INFIELD(g_template) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zaa"
                LET g_qryparam.arg1 = g_prog
                LET g_qryparam.arg2 = p_lang
                IF cl_db_get_database_type() = 'ORA' THEN
                   LET ls_sql = "SELECT count(*) FROM ",
                                "(SELECT unique zaa04,zaa17,zaa11 FROM zaa_file ",
                                "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",p_lang,"' AND zaa10 = 'Y'",
                                "  AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED,
                                "' OR zaa17= '",g_clas CLIPPED,"'))"
                ELSE
                   LET ls_sql = "SELECT count(*) FROM table(multiset",
                                "(SELECT unique zaa04,zaa17,zaa11 FROM zaa_file ",
                                "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",p_lang,"' AND zaa10 = 'Y'",
                                "  AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED,
                                "' OR zaa17= '",g_clas CLIPPED,"')))"
                END IF
                PREPARE zaa_pre1 FROM ls_sql
                IF SQLCA.SQLCODE THEN
                   CALL cl_err("prepare zaa_cur1: ", SQLCA.SQLCODE, 0)
                   RETURN FALSE
                END IF
                EXECUTE zaa_pre1 INTO li_cnt
                IF li_cnt > 0 THEN
                   LET lc_zaa10 = "Y"
                ELSE
                   LET lc_zaa10 = "N"
                END IF
                LET g_qryparam.arg3 = lc_zaa10
                LET g_qryparam.arg4 = g_user
                LET g_qryparam.arg5 = g_clas
                LET g_qryparam.construct = "N"
                LET g_qryparam.default1 = g_rep_user
                LET g_qryparam.default2 = g_rep_clas
                LET g_qryparam.default3 = g_template
                CALL cl_create_qry() RETURNING g_rep_user,g_rep_clas,g_template
                NEXT FIELD g_template
             END IF
          #No.FUN-7C0078 --start--
          ELSE
             IF INFIELD(g_rep_user) OR INFIELD(g_rep_clas) OR
                INFIELD(g_template) OR INFIELD(g_rpt_name)
             THEN
                #No.FUN-B80097 --start--
                CASE li_reptype
                  #FUN-D20057 add-----(s)
                   WHEN 3
                      SELECT COUNT(*) INTO li_cnt FROM gdr_file WHERE gdr01=g_prog AND gdr03 IN ('Y','y')
                      IF li_cnt > 0 THEN
                         LET lc_cust = 'Y'
                      ELSE
                         LET lc_cust = 'N'
                      END IF
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gdr"
                      LET g_qryparam.arg1 = g_prog
                      LET g_qryparam.arg2 = lc_cust  ##客製否
                      LET g_qryparam.arg3 = g_clas
                      LET g_qryparam.arg4 = g_user
                      LET g_qryparam.default1 = g_rep_user
                      LET g_qryparam.default2 = g_rep_clas
                      LET g_qryparam.default3 = g_template
                      LET g_qryparam.construct = "N"
                      CALL cl_create_qry() RETURNING g_rep_clas,g_rep_user,g_template
                      NEXT FIELD CURRENT 
                  #FUN-D20057 add-----(e)
                   WHEN 2
                      SELECT COUNT(*) INTO li_cnt FROM gdw_file WHERE gdw01=g_prog AND gdw03 IN ('Y','y')
                      IF li_cnt > 0 THEN
                         LET lc_cust = 'Y'
                      ELSE
                         LET lc_cust = 'N'
                      END IF
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gdw2"
                      LET g_qryparam.arg1 = g_prog
                      LET g_qryparam.arg2 = lc_cust  ##客製否
                      LET g_qryparam.arg3 = g_clas
                      LET g_qryparam.arg4 = g_user
                      LET g_qryparam.default1 = g_rep_user
                      LET g_qryparam.default2 = g_rep_clas
                      LET g_qryparam.default3 = g_template
                      LET g_qryparam.construct = "N"
                      CALL cl_create_qry() RETURNING g_rep_clas,g_rep_user,g_template,g_rpt_name
                      NEXT FIELD g_rpt_name
                   WHEN 1
                      SELECT COUNT(*) INTO li_cnt FROM zaw_file WHERE zaw01=g_prog AND zaw03 IN ('Y','y')
                      IF li_cnt > 0 THEN
                         LET lc_cust = 'Y'
                      ELSE
                         LET lc_cust = 'N'
                      END IF
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_zaw2"
                      LET g_qryparam.arg1 = g_prog
                      LET g_qryparam.arg2 = lc_cust  ##客製否
                      LET g_qryparam.arg3 = p_lang
                      LET g_qryparam.arg4 = g_clas
                      LET g_qryparam.arg5 = g_user
                      LET g_qryparam.default1 = g_rep_user
                      LET g_qryparam.default2 = g_rep_clas
                      LET g_qryparam.default3 = g_template
                      LET g_qryparam.construct = "N"
                      CALL cl_create_qry() RETURNING g_rep_clas,g_rep_user,g_template,g_rpt_name
                      NEXT FIELD g_rpt_name
                END CASE
                      #No.FUN-B80097 --end--
             END IF
          END IF
          #No.FUN-7C0078 --end--
       #No.FUN-570264 ---end---

       #No.TQC-860016 --start--
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION controlg
          CALL cl_cmdask()

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()
       #No.TQC-860016 ---end---
   END INPUT

   CLOSE WINDOW cl_repcon_w

   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      LET p_pdate = g_today
      LET p_towhom = NULL
      LET p_lang = g_lang
      LET p_bgjob = 'N'
      LET p_time = NULL
### Mark by TQC-5A0059 ###
#      LET p_prtway = NULL
#      LET p_copies = '1'
### Mark by TQC-5A0059 ###
   END IF

   #No.FUN-7C0078 --start--
   #如果為GR or CR報表, 則指定 p_prtway = 'A'
   LET li_cnt3 = 0
   SELECT COUNT(*) INTO li_cnt3 FROM gdw_file WHERE gdw01 = g_prog #No.FUN-B80097
   IF li_cnt3 <= 0 THEN #No.FUN-B80097
   SELECT COUNT(*) INTO li_cnt3 FROM zaw_file WHERE zaw01 = g_prog
   END IF #No.FUN-B80097
   IF li_cnt3 > 0 AND p_bgjob = 'Y' THEN
      LET p_prtway = 'A'
   END IF
   #No.FUN-7C0078 --end--

   RETURN p_pdate,p_towhom,p_lang,p_bgjob,p_time,p_prtway,p_copies
END FUNCTION

#No.FUN-7C0058
##################################################
# Private Func...: TRUE
# Descriptions...: p_prtway_chk, no use
# Date & Author..: 07/12/19
# Input parameter: p_priv
# Return code....: INTEGER
# Modify ........: No.FUN-7C0058
##################################################
FUNCTION p_prtway_chk(p_priv)
   DEFINE p_priv   LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
          l_i      LIKE type_file.num5              #No.FUN-690005  SMALLINT


   IF g_user = "informix" THEN RETURN 1 END IF
   IF g_priv4 IS NULL     THEN RETURN 1 END IF

   FOR l_i = 1 TO 10
       IF p_priv = g_priv4[l_i,l_i] AND g_priv4[l_i,l_i] IS NOT NULL
          THEN RETURN 1
       END IF
   END FOR
   CALL cl_err(p_priv,'9040',0)
   RETURN 0
END FUNCTION

#No.FUN-B80097 --start--
#FUN-B80097 mark start
##No.FUN-7C0078 --start--
###################################################
## Private Func...: TRUE
## Descriptions...: cl_repcon_chkcr
## Date & Author..: 08/03/10
## Input parameter: p_lang 語言別
## Return code....: INTEGER
###################################################
#FUNCTION cl_repcon_chkcr()
#   DEFINE li_cnt  LIKE type_file.num10
#
#   IF (NOT cl_null(g_template)) AND (NOT cl_null(g_rep_user)) AND
#      (NOT cl_null(g_rep_clas)) AND (NOT cl_null(g_rpt_name)) THEN#
#
#      LET li_cnt = 0
#      SELECT COUNT(UNIQUE zaw02) INTO li_cnt FROM zaw_file
#      WHERE zaw01 = g_prog AND zaw05 = g_rep_user
#      AND zaw03 = "Y" AND zaw02 = g_template
#      AND zaw04 = g_rep_clas AND (zaw10 = g_sma.sma124 OR zaw10 = 'std')
#      AND zaw06 = m_lang AND zaw08 = g_rpt_name
#
#      IF li_cnt <= 0 THEN
#         SELECT COUNT(UNIQUE zaw02) INTO li_cnt FROM zaw_file
#         WHERE zaw01 = g_prog AND zaw05 = g_rep_user
#         AND zaw03 = "N" AND zaw02 = g_template
#         AND zaw04 = g_rep_clas  AND (zaw10 = g_sma.sma124 OR zaw10 = 'std')
#         AND zaw06 = m_lang AND zaw08 = g_rpt_name
#
#         IF li_cnt <= 0 THEN
#            CALL cl_err(g_rpt_name CLIPPED || "," || g_template CLIPPED || "," || g_rep_user CLIPPED || "," || g_rep_clas CLIPPED,"lib-261",0)
#            RETURN FALSE
#         END IF
#      END IF
#   END IF
#   RETURN TRUE
#END FUNCTION
##No.FUN-7C0078 --end--
#FUN-B80097 mark end

#No.FUN-B80097 --start--
##################################################
# Private Func...: TRUE
# Descriptions...: cl_repcon_chkrep
# Date & Author..: 11/09/01
# Return code....: INTEGER
##################################################
PRIVATE FUNCTION cl_repcon_chkrep(pi_reptype)
   DEFINE pi_reptype LIKE type_file.num5
   DEFINE li_cnt  LIKE type_file.num10
   DEFINE li_flag    LIKE type_file.num5
   DEFINE ls_msg     STRING

   LET li_flag = FALSE
      LET li_cnt = 0

   CASE pi_reptype
      WHEN 1 #CR
         IF NOT cl_null(g_template) AND NOT cl_null(g_rep_user) 
            AND NOT cl_null(g_rep_clas) AND NOT cl_null(g_rpt_name)
         THEN
         SELECT COUNT(UNIQUE zaw02) INTO li_cnt FROM zaw_file
         WHERE zaw01 = g_prog AND zaw05 = g_rep_user
               AND zaw02 = g_template AND zaw04 = g_rep_clas
               AND (zaw10 = g_sma.sma124 OR zaw10 = 'std')
         AND zaw06 = m_lang AND zaw08 = g_rpt_name

            IF li_cnt > 0 THEN
               LET li_flag = TRUE
            ELSE
               LET ls_msg = g_rpt_name CLIPPED,",",g_template CLIPPED,",",
                            g_rep_user CLIPPED,",",g_rep_clas CLIPPED
               CALL cl_err(ls_msg,"lib-261",0)
         END IF
      END IF
      WHEN 2 #GR
         IF NOT cl_null(g_template) AND NOT cl_null(g_rep_user) 
            AND NOT cl_null(g_rep_clas) AND NOT cl_null(g_rpt_name)
         THEN
      SELECT COUNT(UNIQUE gdw02) INTO li_cnt FROM gdw_file
         WHERE gdw01 = g_prog AND gdw05 = g_rep_user
               AND gdw02 = g_template AND gdw04 = g_rep_clas
         AND gdw09 = g_rpt_name
               AND (gdw06 = g_sma.sma124 OR gdw06 = 'std')

            IF li_cnt > 0 THEN
               LET li_flag = TRUE
            ELSE
               LET ls_msg = g_rpt_name CLIPPED,",",g_template CLIPPED,",",
                            g_rep_user CLIPPED,",",g_rep_clas CLIPPED
               CALL cl_err(ls_msg,"lib-261",0)
            END IF
         END IF 
     #FUN-D20057 add----(s)
      WHEN 3 #XtraGrid
         IF NOT cl_null(g_template) AND NOT cl_null(g_rep_user) 
            AND NOT cl_null(g_rep_clas) THEN
            SELECT COUNT(UNIQUE gdr02) INTO li_cnt FROM gdr_file
               WHERE gdr01 = g_prog AND gdr04 = g_rep_user
                 AND gdr02 = g_template AND gdr05 = g_rep_clas
                 AND (gdr09 = g_sma.sma124 OR gdr09 = 'std')
            IF li_cnt > 0 THEN
               LET li_flag = TRUE
            ELSE
               LET ls_msg = g_template CLIPPED,",",g_rep_user CLIPPED,",",g_rep_clas CLIPPED
               CALL cl_err(ls_msg,"lib-261",0)
            END IF
         END IF 
     #FUN-D20057 add----(e)
      WHEN 0 #zaa
         IF NOT cl_null(g_template) AND NOT cl_null(g_rep_user)
            AND NOT cl_null(g_rep_clas)
         THEN
            SELECT COUNT(UNIQUE zaa11) INTO li_cnt FROM zaa_file
             WHERE zaa01 = g_prog AND zaa04 = g_rep_user
               AND zaa11 = g_template AND zaa17 = g_rep_clas

            IF li_cnt > 0 THEN
               LET li_flag = TRUE
            ELSE
               LET ls_msg = g_template CLIPPED,",",g_rep_user CLIPPED,",",
                            g_rep_clas CLIPPED
               CALL cl_err(ls_msg,"lib-261",0)
         END IF
            
      END IF
   END CASE
   DISPLAY "li_flag=",li_flag
   RETURN li_flag
END FUNCTION
#No.FUN-B80097 --end--
