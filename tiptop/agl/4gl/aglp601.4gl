# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aglp601.4gl
# Descriptions...: 固定預算彙總作業
# Return code....: 
# Date & Author..: 92/08/12 By Nora
# Modify ........: 95/09/25 By Danny (Debug)
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-710023 07/01/22 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-740065 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.FUN-8A0086 08/10/17 By zhaijie添加錯誤匯總函數s_showmsg()
# Modify.........: No.MOD-960120 09/06/09 By Sarah 先刪除新年度+預算編號資料,再抓原始年度+預算編號彙總後產生新的年度+預算編號資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD                
               bookno     LIKE afa_file.afa00,    #No.FUN-740065
               yy_o       LIKE afb_file.afb03,    #會計年度
               yy_s       LIKE afb_file.afb03,    #原始會計年度
               afb01_o    LIKE afb_file.afb01     #預算編號
              END RECORD 
DEFINE g_afb  DYNAMIC ARRAY OF RECORD
	       afb01_s    LIKE afb_file.afb01,    #原始預算編號
	       afa02_s    LIKE afa_file.afa02,    #預算名稱
	       per        LIKE type_file.num5     #調整比率 #No.FUN-680098 SMALLINT
              END RECORD 
DEFINE l_ac               LIKE type_file.num5     #CURRENT ARRAY LINE        #No.FUN-680098SMALLINT
DEFINE l_time             LIKE type_file.num5     #No.FUN-680098 SMALLINT
DEFINE p_row,p_col        LIKE type_file.num5     #No.FUN-680098 SMALLINT
DEFINE g_bookno           LIKE afb_file.afb00
DEFINE g_cnt              LIKE type_file.num10    #No.FUN-680098 INTEGER
DEFINE g_i                LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE g_msg              LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(72)
DEFINE l_flag             LIKE type_file.chr1     #No.FUN-680098 VARCHAR(1) 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW p601_w AT p_row,p_col WITH FORM "agl/42f/aglp601" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_getmsg('agl-050',g_lang) RETURNING g_msg
 
   #No.FUN-740065  --Begin
   LET tm.bookno = ARG_VAL(1)
#  IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF
   #No.FUN-740065  --End  
 
   WHILE TRUE
      INITIALIZE tm.* TO NULL            # Default condition
      CLEAR FORM           #MOD-960120 add
      CALL g_afb.clear()   #MOD-960120 add
      IF s_aglshut(0) THEN EXIT WHILE END IF
      CALL p601_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF cl_sure(16,21) THEN
         LET g_success = 'Y' #No.MOD-470586
         BEGIN WORK
         CALL p601()
         CALL s_showmsg()     #FUN-8A0086 
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
      CLEAR FORM
      CALL g_afb.clear()
   END WHILE        
   CLOSE WINDOW p601_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION p601_i()
   DEFINE p_row,p_col     LIKE type_file.num5,          #No.FUN-680098 smallint
          l_sw            LIKE type_file.chr1,          #重要欄位是否空白  #No.FUN-680098   VARCHAR(1)    
          l_cmd           LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
 
   LET tm.bookno = g_aza.aza81  #No.FUN-740065
   DISPLAY ' ' TO afa02_o   #MOD-960120 add
   INPUT BY NAME tm.bookno,tm.yy_o,tm.afb01_o,tm.yy_s WITHOUT DEFAULTS   #No.FUN-740065
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      #No.FUN-740065  --Begin
      AFTER FIELD bookno
         IF NOT cl_null(tm.bookno) THEN
            CALL p601_bookno(tm.bookno)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.bookno,g_errno,0)
               LET tm.bookno = g_aza.aza81
               DISPLAY BY NAME tm.bookno
               NEXT FIELD bookno
            END IF
         END IF
      #No.FUN-740065  --End  
 
      AFTER FIELD yy_o
         IF tm.yy_o IS NULL THEN NEXT FIELD yy_o END IF
         LET tm.yy_s = tm.yy_o
         DISPLAY BY NAME tm.yy_s
 
      AFTER FIELD afb01_o
         IF tm.afb01_o IS NULL THEN NEXT FIELD afb01_o END IF
         CALL p601_afb01_o()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(tm.afb01_o,g_errno,0)
            NEXT FIELD afb01_o
         END IF
 
      AFTER FIELD yy_s
         IF tm.yy_s IS NULL THEN NEXT FIELD yy_s END IF
         CALL p601_i1()
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         #No.FUN-740065  --Begin
         IF INFIELD(bookno) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_aaa"
            LET g_qryparam.default1 = tm.bookno
            CALL cl_create_qry() RETURNING tm.bookno
            DISPLAY BY NAME tm.bookno
            NEXT FIELD bookno
         END IF  
         #No.FUN-740065  --End  
         IF INFIELD(afb01_o) THEN
#           CALL q_afa(10,30,tm.afb01_o,g_bookno) RETURNING tm.afb01_o
#           CALL FGL_DIALOG_SETBUFFER( tm.afb01_o )
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf01a"   #MOD-960120 mod q_afa->q_azf01a
            LET g_qryparam.default1 = tm.afb01_o
           #LET g_qryparam.arg1 = tm.bookno  #No.FUN-740065  #MOD-960120 mark
            LET g_qryparam.arg1 = '7'                        #MOD-960120
            CALL cl_create_qry() RETURNING tm.afb01_o       
#           CALL FGL_DIALOG_SETBUFFER( tm.afb01_o )         
            DISPLAY BY NAME tm.afb01_o                      
            NEXT FIELD afb01_o                              
         END IF                                             
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
END FUNCTION
 
FUNCTION p601_afb01_o()
  #DEFINE l_afaacti   LIKE afa_file.afaacti   #MOD-960120 mark 
  #DEFINE l_afa02     LIKE afa_file.afa02     #MOD-960120 mark 
   DEFINE l_azfacti   LIKE azf_file.azfacti   #MOD-960120 add
   DEFINE l_azf03     LIKE azf_file.azf03     #MOD-960120 add
   DEFINE l_azf07     LIKE azf_file.azf07     #MOD-960120 add
 
   LET g_errno = ' '
   LET l_azf03 = ' '     #MOD-960120 add
   LET l_azf07 = ' '     #MOD-960120 add
   LET l_azfacti = ' '   #MOD-960120 add
#str MOD-960120 mod
#  SELECT afa02,afaacti INTO l_afa02,l_afaacti
#    FROM afa_file
#   WHERE afa01 = tm.afb01_o
#     AND afa00 = tm.bookno   #No.FUN-740065
##Modify By Danny 95/09/25(判斷帳別)
### No:2577 modify 1998/10/21 ----------------
##    AND afa00 = g_bookno 
   SELECT azf03,azf07,azfacti INTO l_azf03,l_azf07,l_azfacti
     FROM azf_file
    WHERE azf01 = tm.afb01_o AND azf02 = '2'
#end MOD-960120 mod
 
   CASE 
      WHEN STATUS=100 
         LET g_errno = 'agl-005'
     #WHEN l_afaacti = 'N'  #MOD-960120 mark
      WHEN l_azfacti = 'N'  #MOD-960120 
         LET g_errno = '9027'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
  #IF cl_null(g_errno) THEN DISPLAY l_afa02 TO afa02_o END IF  #MOD-960120 mark
   IF cl_null(g_errno) THEN DISPLAY l_azf03 TO afa02_o END IF  #MOD-960120
 
END FUNCTION
 
#No.FUN-740065  --Begin
FUNCTION p601_bookno(p_bookno)
   DEFINE p_bookno   LIKE aaa_file.aaa01,
          l_aaaacti  LIKE aaa_file.aaaacti
 
   LET g_errno = ' '
   LET l_aaaacti = ' '   #MOD-960120 add
   SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
   CASE
      WHEN l_aaaacti = 'N' LET g_errno = '9028'
      WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
 
END FUNCTION
#No.FUN-740065  --End  
 
FUNCTION p601_i1()
 
   LET g_action_choice = NULL
 # CALL cl_getmsg('agl-017',g_lang) RETURNING g_msg
   INPUT ARRAY g_afb WITHOUT DEFAULTS FROM s_afb.*
       ATTRIBUTE(INSERT ROW=FALSE,DELETE ROW=FALSE,UNBUFFERED)
 
      BEFORE FIELD afb01_s
         LET l_ac = ARR_CURR()
 
      AFTER FIELD afb01_s
         IF g_afb[l_ac].afb01_s IS NOT NULL AND g_afb[l_ac].afb01_s!=' ' THEN
           #str MOD-960120 mod
           #SELECT afa02 INTO g_afb[l_ac].afa02_s FROM afa_file 
           # WHERE afa01 = g_afb[l_ac].afb01_s
           #   AND afa00 = tm.bookno  #No.FUN-740065
            SELECT azf03 INTO g_afb[l_ac].afa02_s FROM azf_file
             WHERE azf01 = g_afb[l_ac].afb01_s AND azf02 = '2'
           #end MOD-960120 mod
            IF STATUS THEN
#              CALL cl_err(g_afb[l_ac].afb01_s,g_errno,0)   #No.FUN-660123
               CALL cl_err3("sel","afa_file",g_afb[l_ac].afb01_s,"",g_errno,"","",0)   #No.FUN-660123
               NEXT FIELD afb01_s
            END IF
         END IF
        #DISPLAY g_afb[l_ac].afa02_s TO afa02_s   #MOD-960120 mark
 
      BEFORE FIELD per
         IF g_afb[l_ac].afb01_s IS NULL THEN NEXT FIELD afb01_s END IF
         CALL p601_afb01_s()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_afb[l_ac].afb01_s,g_errno,0)
            NEXT FIELD afb01_s
         END IF
 
     #str MOD-960120 add
      AFTER FIELD per
         IF cl_null(g_afb[l_ac].per) THEN
            CALL cl_err('','mfg0037',0)
            NEXT FIELD per
         END IF
     #end MOD-960120 add
 
      AFTER DELETE
         LET g_cnt = ARR_COUNT()
         INITIALIZE g_afb[g_cnt+1].* TO NULL
 
      AFTER ROW 
         AFTER INPUT
         LET g_cnt = ARR_COUNT()
 
      ON ACTION CONTROLP
         IF INFIELD(afb01_s) THEN
#           CALL q_afa(10,30,g_afb[l_ac].afb01_s,g_bookno) RETURNING g_afb[l_ac].afb01_s
#           CALL FGL_DIALOG_SETBUFFER( g_afb[l_ac].afb01_s )
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf01a"   #MOD-960120 mod q_afa->q_azf01a
            LET g_qryparam.default1 = g_afb[l_ac].afb01_s
           #LET g_qryparam.arg1 = tm.bookno  #No.FUN-740065  #MOD-960120 mark
            LET g_qryparam.arg1 = '7'                        #MOD-960120
            CALL cl_create_qry() RETURNING g_afb[l_ac].afb01_s
#           CALL FGL_DIALOG_SETBUFFER( g_afb[l_ac].afb01_s )
            DISPLAY g_afb[l_ac].afb01_s TO afb01_s
            NEXT FIELD afb01_s
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT  
 
#   OPTIONS INSERT KEY F1
#BugNo:6691
#   IF NOT (g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6') THEN
#      DISPLAY '                       ' AT 2,1
#   END IF
END FUNCTION
 
FUNCTION p601_afb01_s()
  #DEFINE l_afaacti   LIKE afa_file.afaacti   #MOD-960120 mark 
  #DEFINE l_afa02     LIKE afa_file.afa02     #MOD-960120 mark 
   DEFINE l_azfacti   LIKE azf_file.azfacti   #MOD-960120 add
   DEFINE l_azf03     LIKE azf_file.azf03     #MOD-960120 add
   DEFINE l_azf07     LIKE azf_file.azf07     #MOD-960120 add
 
   LET g_errno = ' '
   LET l_azf03 = ' '     #MOD-960120 add
   LET l_azf07 = ' '     #MOD-960120 add
   LET l_azfacti = ' '   #MOD-960120 add
#str MOD-960120 mod
### No:2577 modify 1998/10/21 ----------------
#  SELECT afa02,afaacti INTO l_afa02,l_afaacti
#    FROM afa_file
#   WHERE afa01 = g_afb[l_ac].afb01_s
##    AND afa00 = g_bookno
#     AND afa00 = tm.bookno  #No.FUN-740065
### -
   SELECT azf03,azf07,azfacti INTO l_azf03,l_azf07,l_azfacti
     FROM azf_file
    WHERE azf01 = g_afb[l_ac].afb01_s AND azf02 = '2'
#end MOD-960120 mod
 
   CASE 
      WHEN STATUS=100 
         LET g_errno = 'agl-005'
     #WHEN l_afaacti = 'N'  #MOD-960120 mark
      WHEN l_azfacti = 'N'  #MOD-960120 
         LET g_errno = '9027'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
  #str MOD-960120 mark
  #IF cl_null(g_errno) THEN
  #   DISPLAY g_afb[l_ac].afa02_s TO afa02_s
  #END IF
  #end MOD-960120 mark
 
END FUNCTION
 
FUNCTION p601()
   DEFINE l_sql      LIKE type_file.chr1000,# RDSQL STATEMENT        #No.FUN-680098  VARCHAR(600) 
          l_afb      RECORD LIKE afb_file.*,
          l_afc      RECORD LIKE afc_file.*,   #MOD-960120 add
          l_afb10    LIKE afb_file.afb10,
          l_afb11    LIKE afb_file.afb11,
          l_afb12    LIKE afb_file.afb12,
          l_afb13    LIKE afb_file.afb13,
          l_afb14    LIKE afb_file.afb14,
          l_afc06    ARRAY[13] OF LIKE afc_file.afc06,
          l_afc06_o  LIKE afc_file.afc06,
          l_afc07    LIKE afc_file.afc07, 
          sr         RECORD LIKE afb_file.*,
          sr1        RECORD LIKE afc_file.*,
          l_new      LIKE type_file.chr1,      #No.FUN-680098 VARCHAR(1)  
          afb_cnt    LIKE type_file.num5,      #No.FUN-680098 smallint 
          l_name     LIKE type_file.chr20,     #No.FUN-680098 VARCHAR(12) 
          l_name2    LIKE type_file.chr20,     #No.FUN-680098 VARCHAR(12) 
          l_cmd      LIKE type_file.chr50,     #No.FUN-680098 VARCHAR(30) 
          l_n,l_i    LIKE type_file.num5,      #No.FUN-680098 smallint
          l_cnt      LIKE type_file.num5,      #MOD-960120 add
          l_msg      STRING,                   #MOD-960120 add
          l_afb02_o  LIKE afb_file.afb02,      #MOD-960120 add
          l_afb04_o  LIKE afb_file.afb04,      #MOD-960120 add
          l_afb041_o LIKE afb_file.afb041,     #MOD-960120 add
          l_afb042_o LIKE afb_file.afb042,     #MOD-960120 add
          l_afc02_o  LIKE afc_file.afc02,      #MOD-960120 add
          l_afc04_o  LIKE afc_file.afc04,      #MOD-960120 add
          l_afc05_o  LIKE afc_file.afc05,      #MOD-960120 add
          l_afc041_o LIKE afc_file.afc041,     #MOD-960120 add
          l_afc042_o LIKE afc_file.afc042,     #MOD-960120 add
          m_afc06    LIKE afc_file.afc06,      #MOD-960120 add
          m_afc07    LIKE afc_file.afc07,      #MOD-960120 add
          m_afc08    LIKE afc_file.afc08,      #MOD-960120 add
          m_afc09    LIKE afc_file.afc09       #MOD-960120 add
 
   IF g_aza.aza02 = '1' THEN LET g_i = 12 ELSE LET g_i = 13 END IF
 
  #str MOD-960120 add
###1.先檢查要重新產生的新年度+預算編號資料是否已有耗用,若有則不允許重新產生
   #當新年度+預算編號=原始年度+預算編號,表示是要做預算調整,
   #                                    不管有沒有耗用預算,這都是允許的!
   #當新年度+預算編號<>原始年度+預算編號,表示是要做預算彙總,
   #                                     若已有耗用預算,不允許重新產生
   IF NOT (tm.yy_o = tm.yy_s AND g_cnt = 1 AND
           tm.afb01_o = g_afb[1].afb01_s) THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM afc_file
       WHERE afc00 = tm.bookno
         AND afc01 = tm.afb01_o
         AND afc03 = tm.yy_o
         AND afc07!= 0   #已耗用預算
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         LET l_msg = tm.bookno,"+",tm.afb01_o,"+",tm.yy_o
         CALL cl_err(l_msg,'agl027',1)  #已有已消耗預算資料,不可重新產生!
         RETURN
      END IF
   END IF
 
###2.先將原始年度+預算編號資料寫入TempTable,以便後續計算利用
   DROP TABLE p601_tmp_afb
   DROP TABLE p601_tmp_afc
   SELECT * FROM afb_file WHERE 1!=1 INTO TEMP p601_tmp_afb
   SELECT * FROM afc_file WHERE 1!=1 INTO TEMP p601_tmp_afc
 
   LET l_sql = "SELECT * FROM afb_file",
               " WHERE afb00 = '",tm.bookno,"'",
               "   AND afb01 = ? ",
               "   AND afb03 = ",tm.yy_s,
               "   AND afbacti = 'Y'"
   PREPARE p601_tmp1_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('tmp1_p:',STATUS,1)    
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p601_tmp1_c CURSOR FOR p601_tmp1_p
 
   LET l_sql = "SELECT afc_file.* FROM afc_file,afb_file",
               " WHERE afb00 =afc00 ",
               "   AND afb01 =afc01 ",
               "   AND afb02 =afc02 ",
               "   AND afb03 =afc03 ",
               "   AND afb04 =afc04 ",
               "   AND afb041=afc041 ",
               "   AND afb042=afc042 ",
               "   AND afbacti = 'Y' ",         
               "   AND afc00 = '",tm.bookno,"'",
               "   AND afc01 = ?",
               "   AND afc05 = ?",
               "   AND afc03 = ",tm.yy_s
   PREPARE p601_tmp2_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('tmp2_p:',STATUS,1)    
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p601_tmp2_c CURSOR FOR p601_tmp2_p
 
   FOR l_i = 1 TO g_cnt
      FOREACH p601_tmp1_c USING g_afb[l_i].afb01_s INTO l_afb.*
         IF cl_null(l_afb.afb15) THEN LET l_afb.afb15='1' END IF
         LET l_afb.afb10   = l_afb.afb10*g_afb[l_i].per/100
         LET l_afb.afb11   = l_afb.afb11*g_afb[l_i].per/100
         LET l_afb.afb12   = l_afb.afb12*g_afb[l_i].per/100
         LET l_afb.afb13   = l_afb.afb13*g_afb[l_i].per/100
         LET l_afb.afb14   = l_afb.afb14*g_afb[l_i].per/100
         INSERT INTO p601_tmp_afb VALUES (l_afb.*)
      END FOREACH
 
      FOR l_n = 1 TO g_i
         FOREACH p601_tmp2_c USING g_afb[l_i].afb01_s,l_n INTO l_afc.*
            LET l_afc.afc06 =l_afc.afc06*g_afb[l_i].per/100
            #不同年度+預算編號,需將已消耗預算清為零
            IF tm.yy_o != tm.yy_s OR tm.afb01_o != g_afb[l_i].afb01_s THEN
               LET l_afc.afc07 = 0 
            ELSE 
               LET l_afc.afc07 = l_afc.afc07
            END IF   
            INSERT INTO p601_tmp_afc VALUES (l_afc.*)
         END FOREACH
      END FOR
   END FOR
 
###3.將要產生的新年度+預算編號資料刪除
   DELETE FROM afb_file WHERE afb00 = tm.bookno  #No.FUN-740065
                          AND afb01 = tm.afb01_o
                          AND afb03 = tm.yy_o
   DELETE FROM afc_file WHERE afc00 = tm.bookno  #No.FUN-740065
                          AND afc01 = tm.afb01_o
                          AND afc03 = tm.yy_o
 
###4.撈出TempTable裡的資料,產生新年度+預算編號資料
   #-----------------------afb_file-----------------------
   LET l_afb02_o = ' '   LET l_afb04_o = ' '
   LET l_afb041_o= ' '   LET l_afb042_o= ' '
   DECLARE p601_afb_c1 CURSOR FOR
      SELECT * FROM p601_tmp_afb ORDER BY afb02,afb04,afb041,afb042
   FOREACH p601_afb_c1 INTO l_afb.*
      IF l_afb.afb02 = l_afb02_o  AND l_afb.afb04 = l_afb04_o  AND
         l_afb.afb041= l_afb041_o AND l_afb.afb042= l_afb042_o THEN
         CONTINUE FOREACH
      ELSE
         SELECT SUM(afb10),SUM(afb11),SUM(afb12),SUM(afb13),SUM(afb14)
           INTO l_afb10,l_afb11,l_afb12,l_afb13,l_afb14
           FROM p601_tmp_afb
          WHERE afb02 =l_afb.afb02   #科目編號
            AND afb04 =l_afb.afb04   #部門/異動碼/專案編號
            AND afb041=l_afb.afb041  #預算部門
            AND afb042=l_afb.afb042  #專案代號
         IF cl_null(l_afb10) THEN LET l_afb10=0 END IF
         IF cl_null(l_afb11) THEN LET l_afb11=0 END IF
         IF cl_null(l_afb12) THEN LET l_afb12=0 END IF
         IF cl_null(l_afb13) THEN LET l_afb13=0 END IF
         IF cl_null(l_afb14) THEN LET l_afb14=0 END IF
         INSERT INTO afb_file (afb00,afb01,afb02,afb03,afb04,afb041,afb042,
                               afb05,afb06,afb07,afb08,afb09,afb10,afb11,
                               afb12,afb13,afb14,afb15,afb18,afb19,
                               afbacti,afbuser,afbgrup,afbmodu,afbdate,afboriu,afborig)   
         VALUES(l_afb.afb00,tm.afb01_o,l_afb.afb02,tm.yy_o,l_afb.afb04,
                l_afb.afb041,l_afb.afb042,l_afb.afb05,l_afb.afb06,
                l_afb.afb07,l_afb.afb08,l_afb.afb09,l_afb10,l_afb11,
                l_afb12,l_afb13,l_afb14,l_afb.afb15,l_afb.afb18,l_afb.afb19,
                'Y',g_user,g_grup,'',g_today, g_user, g_grup)         #No.FUN-980030 10/01/04  insert columns oriu, orig
         LET l_afb02_o = l_afb.afb02
         LET l_afb04_o = l_afb.afb04
         LET l_afb041_o= l_afb.afb041
         LET l_afb042_o= l_afb.afb042
      END IF 
   END FOREACH
 
   #-----------------------afc_file-----------------------
   LET l_afc02_o = ' '   LET l_afc04_o = ' '   LET l_afc05_o = 0
   LET l_afc041_o= ' '   LET l_afc042_o= ' '
   DECLARE p601_afc_c1 CURSOR FOR
      SELECT * FROM p601_tmp_afc ORDER BY afc02,afc04,afc05,afc041,afc042
   FOREACH p601_afc_c1 INTO l_afc.*
      IF l_afc.afc02 = l_afc02_o  AND l_afc.afc04 = l_afc04_o  AND
         l_afc.afc05 = l_afc05_o  AND l_afc.afc041= l_afc041_o AND
         l_afc.afc042= l_afc042_o THEN
         CONTINUE FOREACH
      ELSE
         SELECT SUM(afc06),SUM(afc07),SUM(afc08),SUM(afc09)
           INTO m_afc06,m_afc07,m_afc08,m_afc09
           FROM p601_tmp_afc
          WHERE afc02 =l_afc.afc02   #科目編號
            AND afc04 =l_afc.afc04   #部門/異動碼/專案編號
            AND afc05 =l_afc.afc05   #期別
            AND afc041=l_afc.afc041  #預算部門
            AND afc042=l_afc.afc042  #專案代號
         IF cl_null(m_afc06) THEN LET m_afc06=0 END IF
         IF cl_null(m_afc07) THEN LET m_afc07=0 END IF
         IF cl_null(m_afc08) THEN LET m_afc08=0 END IF
         IF cl_null(m_afc09) THEN LET m_afc09=0 END IF
         INSERT INTO afc_file(afc00,afc01,afc02,afc03,afc04,afc041,afc042,
                              afc05,afc06,afc07,afc08,afc09)
         VALUES(l_afc.afc00,tm.afb01_o,l_afc.afc02,tm.yy_o,l_afc.afc04,
                l_afc.afc041,l_afc.afc042,l_afc.afc05,m_afc06,m_afc07,
                m_afc08,m_afc09)
         LET l_afc02_o = l_afc.afc02
         LET l_afc04_o = l_afc.afc04
         LET l_afc05_o = l_afc.afc05
         LET l_afc041_o= l_afc.afc041
         LET l_afc042_o= l_afc.afc042
      END IF 
   END FOREACH
  #end MOD-960120 add
 
  #str MOD-960120 mark
  #DELETE FROM afb_file WHERE afb00 = tm.bookno  #No.FUN-740065
  #                       AND afb01 = tm.afb01_o
  #                       AND afb03 = tm.yy_o
  #DELETE FROM afc_file WHERE afc00 = tm.bookno  #No.FUN-740065
  #                       AND afc01 = tm.afb01_o
  #                       AND afc03 = tm.yy_o
  #
  #LET l_sql = "SELECT * FROM afb_file",
  #            " WHERE afb00 = '",tm.bookno,"'",   #No.FUN-740065
  #            "   AND afb01 = '",tm.afb01_o,"'",  #預算編號
  #            "   AND afb03 = ",tm.yy_o,
  #            "   AND afbacti = 'Y' "     #TQC-630238
  #PREPARE p601_p1 FROM l_sql
  #IF STATUS THEN 
  #   CALL cl_err('p1:',STATUS,1)    
  #   LET g_success = 'N' #No.MOD-470586
  #   RETURN 
  #END IF
  #DECLARE p601_c1 CURSOR WITH HOLD FOR p601_p1
  #
  ##Modify:99/04/15 ------------------------------------#
  ####依原始預算+調整比率--->年度預算
  #LET l_sql = "SELECT afb10,afb11,afb12,afb13,afb14 FROM afb_file",
  #            " WHERE afb00 = '",tm.bookno,"'",  #No.FUN-740065
  #            "   AND afb01 = ? ",	          #預算編號
  #            "   AND afb02 = ? ",	          #科目編號
  #            "   AND afb15 = '1' ",
  #            "   AND afb03 = ",tm.yy_s,
  #            "   AND afbacti = 'Y'"            #TQC-630238
  #PREPARE p601_p2 FROM l_sql
  #IF STATUS THEN 
  #   CALL cl_err('p2:',STATUS,1) 
  #   LET g_success = 'N' #No.MOD-470586
  #   RETURN 
  #END IF
  #DECLARE p601_c2 CURSOR FOR p601_p2
  #LET l_sql = "SELECT afc06 FROM afc_file,afb_file",
  #            " WHERE afb00=afc00 ",
  #            "   AND afb01=afc01 ",
  #            "   AND afb02=afc02 ",
  #            "   AND afb03=afc03 ",
  #            "   AND afb04=afc04 ",
  #            "   AND afb15='1' ",
  #            "   AND afbacti = 'Y' ",           #TQC-630238
  #            "   AND afc00 = '",tm.bookno,"'",  #No.FUN-740065
  #            "   AND afc01 = ? ",		  #預算編號
  #            "   AND afc02 = ? ",		  #科目編號
  #            "   AND afc05 = ? ",		  #期別
  #            "   AND afc04 = ? ",
  #            "   AND afc03 = ",tm.yy_s
  #PREPARE p601_p3 FROM l_sql
  #IF STATUS THEN 
  #   CALL cl_err('p3:',STATUS,1) 
  #   LET g_success = 'N' #No.MOD-470586
  #   RETURN 
  #END IF
  #DECLARE p601_c3 CURSOR FOR p601_p3
  #
  #LET l_new ='Y'   #default 
  #CALL s_showmsg_init()                  #NO.FUN-710023 
  #FOREACH p601_c1 INTO l_afb.*
  #   LET l_new ='N' 
  #  #LET g_success = 'Y' #No.MOD-470586 mark
  #   #NO.FUN-710023--BEGIN                                                           
  #   IF g_success='N' THEN                                                    
  #      LET g_totsuccess='N'                                                   
  #      LET g_success='Y' 
  #   END IF                                                     
  #   #NO.FUN-710023--END 
  #   FOR l_n = 1 TO g_i LET l_afc06[l_n] = 0 END FOR
  #   FOR l_i = 1 TO g_cnt
  #      OPEN p601_c2 USING g_afb[l_i].afb01_s,l_afb.afb02
  #      FETCH p601_c2 INTO l_afb10,l_afb11,l_afb12,l_afb13,l_afb14
  #      IF STATUS AND STATUS != 100 THEN
# #         CALL cl_err('fetch:',STATUS,1)                    #NO.FUN-710023
  #         CALL s_errmsg('afc00',tm.bookno,'fetch:',STATUS,1) #NO.FUN-710023  #No.FUN-740065
  #         RETURN 
  #      END IF
  #      IF STATUS = 100 THEN CONTINUE FOR END IF
  #      LET l_afb.afb10 = l_afb10*g_afb[l_i].per/100
  #      LET l_afb.afb11 = l_afb11*g_afb[l_i].per/100
  #      LET l_afb.afb12 = l_afb12*g_afb[l_i].per/100
  #      LET l_afb.afb13 = l_afb13*g_afb[l_i].per/100
  #      LET l_afb.afb14 = l_afb14*g_afb[l_i].per/100
  #
  #      FOR l_n = 1 TO g_i
  #         OPEN p601_c3 USING g_afb[l_i].afb01_s,l_afb.afb02,l_n,l_afb.afb04
  #         FETCH p601_c3 INTO l_afc06_o
  #         IF STATUS AND STATUS != 100 THEN
# #            CALL cl_err('fetch:',STATUS,1)                                        #NO.FUN-710023
  #            LET g_showmsg=g_afb[l_i].afb01_s,"/",l_afb.afb02,"/",l_n,"/",         #NO.FUN-710023  
  #                          l_afb.afb04                                             #NO.FUN-710023     
  #            CALL s_errmsg('afc01,afc02,afc05,afc04',g_showmsg,'fetch:',STATUS,1)  #NO.FUN-710023
# #            RETURN                                                                #NO.FUN-710023
  #            EXIT FOR                                                         #NO.FUN-710023 
  #         END IF
  #         IF STATUS = 100 THEN LET l_afc06_o = 0 END IF
  #         LET l_afc06[l_n]=l_afc06_o*g_afb[l_i].per/100
  #      END FOR
  #   END FOR
  #
  #{ckp#1}	  
  #   #更新彙總至預算資料單頭檔
  #   LET g_i=g_i
  #   UPDATE afb_file SET afb10=l_afb.afb10,afb11=l_afb.afb11,
  #                       afb12=l_afb.afb12,afb13=l_afb.afb13,
  #                       afb14=l_afb.afb14
  #    WHERE afb00 = l_afb.afb00 AND afb01 = l_afb.afb01
  #      AND afb02 = l_afb.afb02 AND afb03 = l_afb.afb03
  #      AND afb04 = l_afb.afb04
  #   IF STATUS THEN 
# #      CALL cl_err('p601_ckp#1:',STATUS,1) # NO.FUN-660123   
# #      CALL cl_err3("upd","afb_file",l_afb.afb00,l_afb.afb01,STATUS,"","p601_ckp#1:",1) # NO.FUN-660123 #NO.FUN-710023
  #      LET g_showmsg=l_afb.afb00,"/",l_afb.afb01,"/",l_afb.afb02,"/",  #NO.FUN-710023
  #                    l_afb.afb03,"/",l_afb.afb04                       #NO.FUN-710023 
  #      CALL s_errmsg('afb00,afb01,afb02,afb03,afb04',g_showmsg,'p601_ckp#1:',STATUS,1)  #NO.FUN-710023
  #      LET g_success = 'N'
  #   END IF
  #
  #{ckp#2}
  #   #更新彙總至預算資料單身檔
  #   FOR l_n = 1 TO g_i
  #      UPDATE afc_file SET afc06=l_afc06[l_n]
  #       WHERE afc00 = l_afb.afb00 AND afc01 = l_afb.afb01
  #         AND afc02 = l_afb.afb02 AND afc03 = l_afb.afb03
  #         AND afc04 = l_afb.afb04 AND afc05 = l_n
  #      IF STATUS THEN 
# #         CALL cl_err('p601_ckp#2:',STATUS,1)  # NO.FUN-660123
# #         CALL cl_err3("upd","afb_file",l_afb.afb00,l_afb.afb01,STATUS,"","p601_ckp#1:",1) # NO.FUN-660123 #NO.FUN-710023
  #         LET g_showmsg=l_afb.afb00,"/",l_afb.afb01,"/",l_afb.afb02,"/",  #NO.FUN-710023
  #                       l_afb.afb03,"/",l_afb.afb04,"/",l_n               #NO.FUN-710023  
  #         CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc05',g_showmsg,'p601_ckp#2:',STATUS,1) #NO.FUN-710023
  #         LET g_success = 'N'
  #      END IF
  #   END FOR
  #END FOREACH
  ##NO.FUN-710023--BEGIN                                                           
  #IF g_totsuccess="N" THEN                                                        
  #   LET g_success="N"                                                           
  #END IF                                                                          
  ##NO.FUN-710023--END
  #
  #IF l_new ='Y' THEN 
  #   LET l_sql = "SELECT * FROM afb_file ",
  #               " WHERE afb00='",tm.bookno,"'",         #No.FUN-740065
  #               "   AND afb01 = ? ",                    #預算編號
  #               "   AND afb15 ='1' ",
  #               "   AND afbacti = 'Y' ",                #TQC-630238
  #               "   AND afb03 ='",tm.yy_s,"'" CLIPPED   #原始預算年度
  #   PREPARE afb_ins_pre FROM l_sql 
  #   IF SQLCA.sqlcode THEN 
# #      CALL cl_err('afb_ins_pre',STATUS,1)                                      #NO.FUN-710023    
  #      LET g_showmsg=tm.bookno,"/",'1',"/",tm.yy_s                               #NO.FUN-710023   #No.FUN-740065
  #      CALL s_errmsg('afb00,afb15,afb03',g_showmsg,'afb_ins_pre',STATUS,1)      #NO.FUN-710023
  #      LET g_success = 'N'  #No.MOD-470586
  #   END IF 
  #   DECLARE afb_ins_cur CURSOR FOR afb_ins_pre
  #   IF SQLCA.sqlcode THEN
# #      CALL cl_err('afb_ins_cur',STATUS,1)                                      #NO.FUN-710023
  #      LET g_showmsg=tm.bookno,"/",'1',"/",tm.yy_s                               #NO.FUN-710023   #No.FUN-740065
  #      CALL s_errmsg('afb00,afb15,afb03',g_showmsg,'afb_ins_pre',STATUS,1)      #NO.FUN-710023
  #      LET g_success = 'N'  #No.MOD-470586
  #   END IF 
  #   LET l_sql = " SELECT afc_file.* FROM afc_file,afb_file ",
  #               " WHERE afc00 ='",tm.bookno,"'",   #No.FUN-740065
  #               "   AND afc01 = ? ",     #預算編號 
  #               "   AND afb15 ='1' ",
  #               "   AND afc03 ='",tm.yy_s,"'",
  #               "   AND afc00 = afb00 ",
  #               "   AND afc01 = afb01 ",
  #               "   AND afc02 = afb02 ",
  #               "   AND afc03 = afb03 ",
  #               "   AND afbacti = 'Y' ",   #TQC-630238
  #               "   AND afc04 = afb04 " CLIPPED
  #   PREPARE afc_ins_pre FROM l_sql 
  #  #IF SQLCA.sqlcode THEN CALL cl_err('afc_ins_pre',STATUS,1) END IF  #NO.FUN-710023
  #   #NO.FUN-710023 --BEGIN
  #   IF SQLCA.sqlcode THEN 
  #      LET g_showmsg=tm.bookno,"/",tm.yy_s  #No.FUN-740065
  #      CALL s_errmsg('afc00,afc03',g_showmsg,'afc_ins_pre',STATUS,1)    
  #   END IF
  #   #NO.FUN-710023--END
  #   DECLARE afc_ins_cur CURSOR FOR afc_ins_pre 
  #  #IF SQLCA.sqlcode THEN CALL cl_err('afc_ins_cur',STATUS,1) END IF  #NO.FUN-710023
  #   #NO.FUN-710023 --BEGIN
  #   IF SQLCA.sqlcode THEN 
  #      LET g_showmsg=tm.bookno,"/",tm.yy_s  #No.FUN-740065
  #      CALL s_errmsg('afc00,afc03',g_showmsg,'afc_ins_pre',STATUS,1)    
  #   END IF
  #   #NO.FUN-710023--END
  #   CALL cl_outnam('aglp6011') RETURNING l_name 
  #   START REPORT p601_rep1 TO l_name 
  #  #CALL cl_outnam('aglp6012') RETURNING l_name2 
  #  #START REPORT p601_rep2 TO l_name2 
  #   FOR l_i = 1 TO g_cnt 
  #      #NO.FUN-710023--BEGIN                                                           
  #      IF g_success='N' THEN                                                    
  #         LET g_totsuccess='N'                                                   
  #         LET g_success='Y' 
  #      END IF                                                     
  #      #NO.FUN-710023--END
  #      FOREACH afb_ins_cur USING g_afb[l_i].afb01_s INTO sr.* 
  #        #IF SQLCA.sqlcode THEN CALL cl_err('afb_ins_for',STATUS,1)  #NO.FUN-710023
  #         #NO.FUN-710023--BEGIN 
  #         IF SQLCA.sqlcode THEN  
  #            CALL s_errmsg('afb01',g_afb[l_i].afb01_s,'afb_ins_for',STATUS,1)
  #         #NO.FUN-710023--END                
  #            EXIT FOREACH
  #         END IF 
  #         LET sr.afb10 = sr.afb10 * (g_afb[l_i].per/100) 
  #         LET sr.afb11 = sr.afb11 * (g_afb[l_i].per/100)
  #         LET sr.afb12 = sr.afb12 * (g_afb[l_i].per/100)
  #         LET sr.afb13 = sr.afb13 * (g_afb[l_i].per/100)
  #         LET sr.afb14 = sr.afb14 * (g_afb[l_i].per/100) 
  #         OUTPUT TO REPORT p601_rep1(sr.*) 
  #      END FOREACH 
  #         
  #      #---------------------------------------------
  #      FOREACH afc_ins_cur USING g_afb[l_i].afb01_s INTO sr1.*  
  #        #IF SQLCA.sqlcode THEN CALL cl_err('afc_ins_for',STATUS,1) END IF  #NO.FUN-710023
  #         #NO.FUN-710023--BEGIN 
  #         IF SQLCA.sqlcode THEN  
  #            CALL s_errmsg('afc01',g_afb[l_i].afb01_s,'afc_ins_for',STATUS,1)
  #         END IF  
  #         #NO.FUN-710023--END                
  #         LET sr1.afc06 =  sr1.afc06 * (g_afb[l_i].per/100) 
  #         #不同會計年度.已消耗預算清為零
  #         IF tm.yy_o != tm.yy_s OR tm.afb01_o != sr1.afc01 THEN
  #            LET l_afc07 = 0 
  #         ELSE 
  #            LET l_afc07=sr1.afc07 
  #         END IF   
  #         INSERT INTO afc_file(afc00,afc01,afc02,afc03,afc04,  #No.MOD-470041
  #                              afc05,afc06,afc07)
  #         VALUES(sr1.afc00,tm.afb01_o,sr1.afc02,tm.yy_o,sr1.afc04,
  #                sr1.afc05,sr1.afc06,l_afc07)
  #         IF SQLCA.sqlcode THEN 
  #            UPDATE afc_file SET afc06=afc06+sr1.afc06 
  #             WHERE afc00=sr1.afc00
  #               AND afc01=tm.afb01_o
  #               AND afc02=sr1.afc02  
  #               AND afc03=tm.yy_o     
  #               AND afc04=sr1.afc04  
  #               AND afc05=sr1.afc05  
  #         END IF 
  #      END FOREACH 
  #   END FOR 
  #   #NO.FUN-710023--BEGIN                                                           
  #   IF g_totsuccess="N" THEN                                                        
  #      LET g_success="N"                                                           
  #   END IF                                                                          
  #   #NO.FUN-710023--END
 
  #   FINISH REPORT p601_rep1 
  #   #No.+366 010705 plum
  #   LET l_cmd = "chmod 777 ", l_name
  #   RUN l_cmd
  #   #No.+366..end
  #END IF    
  #end MOD-960120 mark
END FUNCTION
 
#str MOD-960120 mark
#REPORT p601_rep1(sr)
#   DEFINE sr       RECORD LIKE afb_file.* ,
#          l_afb10  LIKE afb_file.afb10,
#          l_afb11  LIKE afb_file.afb11,
#          l_afb12  LIKE afb_file.afb12,
#          l_afb13  LIKE afb_file.afb13,
#          l_afb14  LIKE afb_file.afb14  
#   
#   OUTPUT 
#      TOP MARGIN g_top_margin
#      LEFT  MARGIN 0 
#      BOTTOM MARGIN g_bottom_margin 
#      PAGE LENGTH g_page_line
#  
#   ORDER BY sr.afb04,sr.afb00,sr.afb01,sr.afb03,sr.afb02  
#  
#   FORMAT   
#     AFTER GROUP OF sr.afb02 
#       LET l_afb10 = GROUP SUM(sr.afb10) 
#       LET l_afb11 = GROUP SUM(sr.afb11)
#       LET l_afb12 = GROUP SUM(sr.afb12) 
#       LET l_afb13 = GROUP SUM(sr.afb13)
#       LET l_afb14 = GROUP SUM(sr.afb14) 
#       INSERT INTO afb_file (afb00,afb01,afb02,afb03,afb04,  #No.MOD-470041
#                             afb05,afb06,afb07,afb08,afb09,
#                             afb10,afb11,afb12,afb13,afb14,afb15,
#                             afbacti,afbuser,afbgrup,afbmodu,afbdate)   
#       VALUES(sr.afb00,tm.afb01_o,sr.afb02,tm.yy_o,sr.afb04,
#              sr.afb05,sr.afb06,sr.afb07,sr.afb08,sr.afb09,
#              l_afb10,l_afb11,l_afb12,l_afb13,l_afb14,'1',
#              'Y',g_user,'',g_user,g_today)   
#       IF SQLCA.sqlcode THEN 
#          UPDATE afb_file SET afb10=afb10+l_afb10,  
#                              afb11=afb11+l_afb11,  
#                              afb12=afb12+l_afb12,  
#                              afb13=afb13+l_afb13,  
#                              afb14=afb14+l_afb14
#                        WHERE afb00=sr.afb00
#                          AND afb01=tm.afb01_o
#                          AND afb02=sr.afb02  
#                          AND afb03=tm.yy_o     
#                          AND afb04=sr.afb04  
#          #No.MOD-470586
#          IF STATUS THEN
#            #CALL cl_err('upd afb:',STATUS,1)   #No.FUN-660123
#            #CALL cl_err3("upd","afb_file",sr.afb00,tm.afb01_o,STATUS,"","upd afb:",1)   #No.FUN-660123 #NO.FUN-710023
#            #NO.FUN-710023--BEGIN
#             LET g_showmsg=sr.afb00,"/",tm.afb01_o,"/",sr.afb02,"/",tm.yy_o,"/",sr.afb04 
#             CALL s_errmsg('afb00,afb01,afb02,afb03,afb04',g_showmsg,'upd afb:',STATUS,1)
#            #NO.FUN-710023--END
#             LET g_success = 'N'
#          END IF
#          #No.MOD-470586 (end)
#       END IF 
#END REPORT
#end MOD-960120 mark
