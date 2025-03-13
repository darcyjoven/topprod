# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmi940.4gl
# Descriptions...: 追索天數維護作業
# Date & Author..: 06/06/12 BY yiting 
# Modify.........: No.FUN-660148 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-960138 09/06/12 By sabrina  DISPLAY BY NAME g_ngh.* 有欄位跟變數對不上的錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_ngh           RECORD LIKE ngh_file.*,       
       g_ngh_t         RECORD LIKE ngh_file.*,      
       g_ngi01         DYNAMIC ARRAY OF RECORD
                          ngi02_01   LIKE ngi_file.ngi02,
                          ngi03_01   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi01_t       RECORD
                          ngi02_01   LIKE ngi_file.ngi02,
                          ngi03_01   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi02         DYNAMIC ARRAY OF RECORD
                          ngi02_02   LIKE ngi_file.ngi02,
                          ngi03_02   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi02_t       RECORD
                          ngi02_02   LIKE ngi_file.ngi02,
                          ngi03_02   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi03         DYNAMIC ARRAY OF RECORD
                          ngi02_03   LIKE ngi_file.ngi02,
                          ngi03_03   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi03_t       RECORD
                          ngi02_03   LIKE ngi_file.ngi02,
                          ngi03_03   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi04         DYNAMIC ARRAY OF RECORD
                          ngi02_04   LIKE ngi_file.ngi02,
                          ngi03_04   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi04_t       RECORD
                          ngi02_04   LIKE ngi_file.ngi02,
                          ngi03_04   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi05         DYNAMIC ARRAY OF RECORD
                          ngi02_05   LIKE ngi_file.ngi02,
                          ngi03_05   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi05_t       RECORD
                          ngi02_05   LIKE ngi_file.ngi02,
                          ngi03_05   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi06         DYNAMIC ARRAY OF RECORD
                          ngi02_06   LIKE ngi_file.ngi02,
                          ngi03_06   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi06_t       RECORD
                          ngi02_06   LIKE ngi_file.ngi02,
                          ngi03_06   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi07         DYNAMIC ARRAY OF RECORD
                          ngi02_07   LIKE ngi_file.ngi02,
                          ngi03_07   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi07_t       RECORD
                          ngi02_07   LIKE ngi_file.ngi02,
                          ngi03_07   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi08         DYNAMIC ARRAY OF RECORD
                          ngi02_08   LIKE ngi_file.ngi02,
                          ngi03_08   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi08_t       RECORD
                          ngi02_08   LIKE ngi_file.ngi02,
                          ngi03_08   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi09         DYNAMIC ARRAY OF RECORD
                          ngi02_09   LIKE ngi_file.ngi02,
                          ngi03_09   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi09_t       RECORD
                          ngi02_09   LIKE ngi_file.ngi02,
                          ngi03_09   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi10         DYNAMIC ARRAY OF RECORD
                          ngi02_10   LIKE ngi_file.ngi02,
                          ngi03_10   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi10_t       RECORD
                          ngi02_10   LIKE ngi_file.ngi02,
                          ngi03_10   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi11         DYNAMIC ARRAY OF RECORD
                          ngi02_11   LIKE ngi_file.ngi02,
                          ngi03_11   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi11_t       RECORD
                          ngi02_11   LIKE ngi_file.ngi02,
                          ngi03_11   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi12         DYNAMIC ARRAY OF RECORD
                          ngi02_12   LIKE ngi_file.ngi02,
                          ngi03_12   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi12_t       RECORD
                          ngi02_12   LIKE ngi_file.ngi02,
                          ngi03_12   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi13         DYNAMIC ARRAY OF RECORD
                          ngi02_13   LIKE ngi_file.ngi02,
                          ngi03_13   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi13_t       RECORD
                          ngi02_13   LIKE ngi_file.ngi02,
                          ngi03_13   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi14         DYNAMIC ARRAY OF RECORD
                          ngi02_14   LIKE ngi_file.ngi02,
                          ngi03_14   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi14_t       RECORD
                          ngi02_14   LIKE ngi_file.ngi02,
                          ngi03_14   LIKE ngi_file.ngi03
                       END RECORD,
       g_ngi           DYNAMIC ARRAY OF RECORD
                          ngi02_01   LIKE ngi_file.ngi02,
                          ngi02_02   LIKE ngi_file.ngi02,
                          ngi02_03   LIKE ngi_file.ngi02,
                          ngi02_04   LIKE ngi_file.ngi02,
                          ngi02_05   LIKE ngi_file.ngi02,
                          ngi02_06   LIKE ngi_file.ngi02,
                          ngi02_07   LIKE ngi_file.ngi02,
                          ngi02_08   LIKE ngi_file.ngi02,
                          ngi02_09   LIKE ngi_file.ngi02,
                          ngi02_10   LIKE ngi_file.ngi02,
                          ngi02_11   LIKE ngi_file.ngi02,
                          ngi02_12   LIKE ngi_file.ngi02,
                          ngi02_13   LIKE ngi_file.ngi02,
                          ngi02_14   LIKE ngi_file.ngi02,
                          ngi03_01   LIKE ngi_file.ngi03,
                          ngi03_02   LIKE ngi_file.ngi03,
                          ngi03_03   LIKE ngi_file.ngi03,
                          ngi03_04   LIKE ngi_file.ngi03,
                          ngi03_05   LIKE ngi_file.ngi03,
                          ngi03_06   LIKE ngi_file.ngi03,
                          ngi03_07   LIKE ngi_file.ngi03,
                          ngi03_08   LIKE ngi_file.ngi03,
                          ngi03_09   LIKE ngi_file.ngi03,
                          ngi03_10   LIKE ngi_file.ngi03,
                          ngi03_11   LIKE ngi_file.ngi03,
                          ngi03_12   LIKE ngi_file.ngi03,
                          ngi03_13   LIKE ngi_file.ngi03,
                          ngi03_14   LIKE ngi_file.ngi03
                       END RECORD,
     g_wc,g_wc2,g_sql  STRING,      
       g_rec_b         LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b01       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b02       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b03       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b04       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b05       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b06       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b07       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b08       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b09       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b10       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b11       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b12       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b13       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       g_rec_b14       LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_ac            LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_cmd           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
DEFINE g_forupd_sql    STRING        
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_i             LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0082
 
   OPTIONS                                          #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                  #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0082
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW i940_w AT p_row,p_col
     WITH FORM "anm/42f/anmi940"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   CALL i940_show()
   CALL i940_menu()
 
   CLOSE WINDOW i940_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0082
 
END MAIN
 
FUNCTION i940_menu()
 
   WHILE TRUE
      CALL i940_bp("G")
      CASE g_action_choice
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i940_u()
            END IF
         WHEN "modify01" 
            IF cl_chk_act_auth() THEN
               CALL i940_b01()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify02" 
            IF cl_chk_act_auth() THEN
               CALL i940_b02()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify03" 
            IF cl_chk_act_auth() THEN
               CALL i940_b03()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify04" 
            IF cl_chk_act_auth() THEN
               CALL i940_b04()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify05" 
            IF cl_chk_act_auth() THEN
               CALL i940_b05()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify06" 
            IF cl_chk_act_auth() THEN
               CALL i940_b06()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify07" 
            IF cl_chk_act_auth() THEN
               CALL i940_b07()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify08" 
            IF cl_chk_act_auth() THEN
               CALL i940_b08()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify09" 
            IF cl_chk_act_auth() THEN
               CALL i940_b09()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify10" 
            IF cl_chk_act_auth() THEN
               CALL i940_b10()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify11" 
            IF cl_chk_act_auth() THEN
               CALL i940_b11()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify12" 
            IF cl_chk_act_auth() THEN
               CALL i940_b12()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify13" 
            IF cl_chk_act_auth() THEN
               CALL i940_b13()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify14" 
            IF cl_chk_act_auth() THEN
               CALL i940_b14()
               CALL i940_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       # WHEN "exporttoexcel"   #No.MOD-640284 Mark
       #    IF cl_chk_act_auth() THEN
       #      CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ngi),'','')
       #    END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i940_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
   LET g_forupd_sql = "SELECT * FROM ngh_file WHERE ngh00 = '0' FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ngh_cl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN ngh_cl
   IF STATUS  THEN CALL cl_err('OPEN ngh_curl',STATUS,1) RETURN END IF
   FETCH ngh_cl INTO g_ngh.*
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
   END IF
   LET g_ngh_t.* = g_ngh.*
   WHILE TRUE
       CALL i940_i()
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
       UPDATE ngh_file
          SET ngh_file.*=g_ngh.*
        WHERE ngh00 = '0'
       IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660148
           CALL cl_err3("upd","ngh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660148
           CONTINUE WHILE
       END IF
       EXIT WHILE
   END WHILE
   CLOSE ngh_cl
   COMMIT WORK
   CALL i940_show()
END FUNCTION
 
FUNCTION i940_i()
   DEFINE l_flag   LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_n1     LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          p_cmd    LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
  #TQC-960138---modify    
   DISPLAY BY NAME g_ngh.*    #並沒有全部的欄位都有顯示在畫面上，故不可用此寫法  
   DISPLAY BY NAME g_ngh.ngh01,g_ngh.ngh02,g_ngh.ngh03,g_ngh.ngh04,
                   g_ngh.ngh05,g_ngh.ngh06,g_ngh.ngh07,g_ngh.ngh08,
                   g_ngh.ngh09,g_ngh.ngh10,g_ngh.ngh11,g_ngh.ngh12,
                   g_ngh.ngh13,g_ngh.ngh14
  #TQC-960138---modify
 
   INPUT BY NAME g_ngh.ngh01,g_ngh.ngh02,g_ngh.ngh03,g_ngh.ngh04,
                 g_ngh.ngh05,g_ngh.ngh06,g_ngh.ngh07,g_ngh.ngh08,
                 g_ngh.ngh09,g_ngh.ngh10,g_ngh.ngh11,g_ngh.ngh12,
                 g_ngh.ngh13,g_ngh.ngh14
          WITHOUT DEFAULTS 
 
      AFTER FIELD ngh01
         IF g_ngh.ngh02 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh02
         END IF
 
      AFTER FIELD ngh02
         IF g_ngh.ngh02 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh02
         END IF
 
      AFTER FIELD ngh03
         IF g_ngh.ngh03 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh03
         END IF
 
      AFTER FIELD ngh04
         IF g_ngh.ngh04 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh04
         END IF
 
      AFTER FIELD ngh05
         IF g_ngh.ngh05 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh05
         END IF
 
      AFTER FIELD ngh06
         IF g_ngh.ngh06 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh06
         END IF
 
      AFTER FIELD ngh07
         IF g_ngh.ngh07 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh07
         END IF
 
      AFTER FIELD ngh08
         IF g_ngh.ngh08 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh08
         END IF
 
      AFTER FIELD ngh09
         IF g_ngh.ngh09 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh09
         END IF
 
      AFTER FIELD ngh10
         IF g_ngh.ngh10 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh10
         END IF
 
      AFTER FIELD ngh11
         IF g_ngh.ngh10 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh11
         END IF
      AFTER FIELD ngh12
         IF g_ngh.ngh10 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh12
         END IF
 
      AFTER FIELD ngh13
         IF g_ngh.ngh10 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh13
         END IF
 
      AFTER FIELD ngh14
         IF g_ngh.ngh10 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD ngh14
         END IF
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
    
END FUNCTION
 
FUNCTION i940_show()
 
   SELECT * INTO g_ngh.* FROM ngh_file WHERE ngh00 = '0'
   IF SQLCA.sqlcode OR g_ngh.ngh01 IS NULL THEN
       LET g_ngh.ngh00 = '0'
       LET g_ngh.ngh01 = '0'
       LET g_ngh.ngh02 = '0'
       LET g_ngh.ngh03 = '0'
       LET g_ngh.ngh04 = '0'
       LET g_ngh.ngh05 = '0'
       LET g_ngh.ngh06 = '0'
       LET g_ngh.ngh07 = '0'
       LET g_ngh.ngh08 = '0'
       LET g_ngh.ngh09 = '0'
       LET g_ngh.ngh10 = '0'
       LET g_ngh.ngh11 = '0'
       LET g_ngh.ngh12 = '0'
       LET g_ngh.ngh13 = '0'
       LET g_ngh.ngh14 = '0'
       IF SQLCA.sqlcode THEN
          INSERT INTO ngh_file VALUES (g_ngh.*)
       ELSE
          UPDATE ngh_file SET * = g_ngh.*
           WHERE ngh00 = '0'
       END IF
       IF SQLCA.sqlcode THEN
#         CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660148
          CALL cl_err3("upd","ngh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660148
          RETURN
       END IF
   END IF
   LET g_ngh_t.* = g_ngh.*
   DISPLAY BY NAME g_ngh.ngh01,g_ngh.ngh02,g_ngh.ngh03,g_ngh.ngh04,
                   g_ngh.ngh05,g_ngh.ngh06,g_ngh.ngh07,g_ngh.ngh08,
                   g_ngh.ngh09,g_ngh.ngh10,g_ngh.ngh11,g_ngh.ngh12,
                   g_ngh.ngh13,g_ngh.ngh14
   CALL i940_b_fill()
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION i940_b01()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      "  WHERE ngi01 = '1'", 
                      "   AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl01 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi01 WITHOUT DEFAULTS FROM s_ngi01.* 
         ATTRIBUTE(COUNT=g_rec_b01,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b01 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b01 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi01_t.* = g_ngi01[l_ac].*
            OPEN i940_bcl01 USING g_ngi01_t.ngi02_01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi01_t.ngi02_01,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl01 INTO g_ngi01[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi01_t.ngi02_01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi01[l_ac].* TO NULL
         LET g_ngi01[l_ac].ngi03_01 = 0
         LET g_ngi01_t.* = g_ngi01[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi01[l_ac].ngi02_01) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(1,g_ngi01[l_ac].ngi02_01,g_ngi01[l_ac].ngi03_01)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi01[l_ac].ngi02_01,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi01[l_ac].ngi02_01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b01 = g_rec_b01 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_01
         IF NOT cl_null(g_ngi01[l_ac].ngi02_01) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi01[l_ac].ngi02_01
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi01[l_ac].ngi02_01,"axm-274",0)
                NEXT FIELD ngi02_01
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi01_t.ngi02_01 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '1'
               AND ngi02 = g_ngi01_t.ngi02_01
               AND ngi03 = g_ngi01_t.ngi03_01
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi01_t.ngi02_01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi01_t.ngi02_01,g_ngi01_t.ngi03_01,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi01[l_ac].* = g_ngi01_t.*
            CLOSE i940_bcl01
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi01[l_ac].ngi02_01,-263,1)
            LET g_ngi01[l_ac].* = g_ngi01_t.*
         ELSE
            IF cl_null(g_ngi01[l_ac].ngi02_01) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi01[l_ac].* = g_ngi01_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi01[l_ac].ngi02_01, 
                                   ngi03 = g_ngi01[l_ac].ngi03_01
                WHERE ngi01 = '1'
                  AND ngi02 = g_ngi01_t.ngi02_01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi01[l_ac].ngi02_01,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi01_t.ngi02_01,g_ngi01_t.ngi03_01,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi01[l_ac].* = g_ngi01_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi01[l_ac].* = g_ngi01_t.*
            END IF
            CLOSE i940_bcl01
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl01
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi01[l_ac].ngi02_01
               CALL cl_create_qry() RETURNING g_ngi01[l_ac].ngi02_01 
               DISPLAY BY NAME g_ngi01[l_ac].ngi02_01 
               NEXT FIELD ngi02_01
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl01
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i940_b02()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '2' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl02 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi02 WITHOUT DEFAULTS FROM s_ngi02.* 
         ATTRIBUTE(COUNT=g_rec_b02,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b02 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b02 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi02_t.* = g_ngi02[l_ac].*
            OPEN i940_bcl02 USING g_ngi02_t.ngi02_02
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi02_t.ngi02_02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl02 INTO g_ngi02[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi02_t.ngi02_02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi02[l_ac].* TO NULL
         LET g_ngi02[l_ac].ngi03_02 = 0
         LET g_ngi02_t.* = g_ngi02[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi02[l_ac].ngi02_02) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(2,g_ngi02[l_ac].ngi02_02,g_ngi02[l_ac].ngi03_02)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi02[l_ac].ngi02_02,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi02[l_ac].ngi02_02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b02 = g_rec_b02 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_02
         IF NOT cl_null(g_ngi02[l_ac].ngi02_02) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi02[l_ac].ngi02_02
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi02[l_ac].ngi02_02,"axm-274",0)
                NEXT FIELD ngi02_02
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi02_t.ngi02_02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '2'
               AND ngi02 = g_ngi02_t.ngi02_02
               AND ngi03 = g_ngi02_t.ngi03_02
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi02_t.ngi02_02,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi02_t.ngi02_02,g_ngi02_t.ngi03_02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi02[l_ac].* = g_ngi02_t.*
            CLOSE i940_bcl02
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi02[l_ac].ngi02_02,-263,1)
            LET g_ngi02[l_ac].* = g_ngi02_t.*
         ELSE
            IF cl_null(g_ngi02[l_ac].ngi02_02) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi02[l_ac].* = g_ngi02_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi02[l_ac].ngi02_02, 
                                   ngi03 = g_ngi02[l_ac].ngi03_02
                WHERE ngi01 = '2'
                  AND ngi02 = g_ngi02_t.ngi02_02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi02[l_ac].ngi02_02,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi02_t.ngi02_02,g_ngi02_t.ngi03_02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi02[l_ac].* = g_ngi02_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi02[l_ac].* = g_ngi02_t.*
            END IF
            CLOSE i940_bcl02
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl02
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi02[l_ac].ngi02_02
               CALL cl_create_qry() RETURNING g_ngi02[l_ac].ngi02_02 
               DISPLAY BY NAME g_ngi02[l_ac].ngi02_02 
               NEXT FIELD ngi02_02
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl02
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b03()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '3' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl03 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi03 WITHOUT DEFAULTS FROM s_ngi03.* 
         ATTRIBUTE(COUNT=g_rec_b03,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b03 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b03 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi03_t.* = g_ngi03[l_ac].*
            OPEN i940_bcl03 USING g_ngi03_t.ngi02_03
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi03_t.ngi02_03,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl03 INTO g_ngi03[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi03_t.ngi02_03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi03[l_ac].* TO NULL
         LET g_ngi03[l_ac].ngi03_03 = 0
         LET g_ngi03_t.* = g_ngi03[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi03[l_ac].ngi02_03) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(3,g_ngi03[l_ac].ngi02_03,g_ngi03[l_ac].ngi03_03)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi03[l_ac].ngi02_03,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi03[l_ac].ngi02_03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b03 = g_rec_b03 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_03
         IF NOT cl_null(g_ngi03[l_ac].ngi02_03) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi03[l_ac].ngi02_03
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi03[l_ac].ngi02_03,"axm-274",0)
                NEXT FIELD ngi02_03
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi03_t.ngi02_03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 ='3' 
               AND ngi02 = g_ngi03_t.ngi02_03
               AND ngi03 = g_ngi03_t.ngi03_03
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi03_t.ngi02_03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi03_t.ngi02_03,g_ngi03_t.ngi03_03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi03[l_ac].* = g_ngi03_t.*
            CLOSE i940_bcl03
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi03[l_ac].ngi02_03,-263,1)
            LET g_ngi03[l_ac].* = g_ngi03_t.*
         ELSE
            IF cl_null(g_ngi03[l_ac].ngi02_03) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi03[l_ac].* = g_ngi03_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi03[l_ac].ngi02_03, 
                                   ngi03 = g_ngi03[l_ac].ngi03_03
                WHERE ngi01 = '3'
                  AND ngi02 = g_ngi03_t.ngi02_03
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi03[l_ac].ngi02_03,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi03_t.ngi02_03,g_ngi03_t.ngi03_03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi03[l_ac].* = g_ngi03_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi03[l_ac].* = g_ngi03_t.*
            END IF
            CLOSE i940_bcl03
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl03
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi03[l_ac].ngi02_03
               CALL cl_create_qry() RETURNING g_ngi03[l_ac].ngi02_03 
               DISPLAY BY NAME g_ngi03[l_ac].ngi02_03 
               NEXT FIELD ngi02_03
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl03
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b04()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '4' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl04 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi04 WITHOUT DEFAULTS FROM s_ngi04.* 
         ATTRIBUTE(COUNT=g_rec_b04,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b04 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b04 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi04_t.* = g_ngi04[l_ac].*
            OPEN i940_bcl04 USING g_ngi04_t.ngi02_04
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi04_t.ngi02_04,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl04 INTO g_ngi04[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi04_t.ngi02_04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi04[l_ac].* TO NULL
         LET g_ngi04[l_ac].ngi03_04 = 0
         LET g_ngi04_t.* = g_ngi04[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi04[l_ac].ngi02_04) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(4,g_ngi04[l_ac].ngi02_04,g_ngi04[l_ac].ngi03_04)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi04[l_ac].ngi02_04,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi04[l_ac].ngi02_04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b04 = g_rec_b04 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_04
         IF NOT cl_null(g_ngi04[l_ac].ngi02_04) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi04[l_ac].ngi02_04
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi04[l_ac].ngi02_04,"axm-274",0)
                NEXT FIELD ngi02_04
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi04_t.ngi02_04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '4'
               AND ngi02 = g_ngi04_t.ngi02_04
               AND ngi03 = g_ngi04_t.ngi03_04
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi04_t.ngi02_04,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi04_t.ngi02_04,g_ngi04_t.ngi03_04,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi04[l_ac].* = g_ngi04_t.*
            CLOSE i940_bcl04
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi04[l_ac].ngi02_04,-263,1)
            LET g_ngi04[l_ac].* = g_ngi04_t.*
         ELSE
            IF cl_null(g_ngi04[l_ac].ngi02_04) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi04[l_ac].* = g_ngi04_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi04[l_ac].ngi02_04, 
                                   ngi03 = g_ngi04[l_ac].ngi03_04
                WHERE ngi01 = '4'
                  AND ngi02 = g_ngi04_t.ngi02_04
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi04[l_ac].ngi02_04,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi04_t.ngi02_04,g_ngi04_t.ngi03_04,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi04[l_ac].* = g_ngi04_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi04[l_ac].* = g_ngi04_t.*
            END IF
            CLOSE i940_bcl04
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl04
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi04[l_ac].ngi02_04
               CALL cl_create_qry() RETURNING g_ngi04[l_ac].ngi02_04 
               DISPLAY BY NAME g_ngi04[l_ac].ngi02_04 
               NEXT FIELD ngi02_04
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl04
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b05()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '5' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl05 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi05 WITHOUT DEFAULTS FROM s_ngi05.* 
         ATTRIBUTE(COUNT=g_rec_b05,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b05 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b05 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi05_t.* = g_ngi05[l_ac].*
            OPEN i940_bcl05 USING g_ngi05_t.ngi02_05
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi05_t.ngi02_05,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl05 INTO g_ngi05[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi05_t.ngi02_05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi05[l_ac].* TO NULL
         LET g_ngi05[l_ac].ngi03_05 = 0
         LET g_ngi05_t.* = g_ngi05[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_05
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi05[l_ac].ngi02_05) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(5,g_ngi05[l_ac].ngi02_05,g_ngi05[l_ac].ngi03_05)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi05[l_ac].ngi02_05,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi05[l_ac].ngi02_05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b05 = g_rec_b05 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_05
         IF NOT cl_null(g_ngi05[l_ac].ngi02_05) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi05[l_ac].ngi02_05
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi05[l_ac].ngi02_05,"axm-274",0)
                NEXT FIELD ngi02_05
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi05_t.ngi02_05 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '5'
               AND ngi02 = g_ngi05_t.ngi02_05
               AND ngi03 = g_ngi05_t.ngi03_05
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi05_t.ngi02_05,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi05_t.ngi02_05,g_ngi05_t.ngi03_05,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi05[l_ac].* = g_ngi05_t.*
            CLOSE i940_bcl05
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi05[l_ac].ngi02_05,-263,1)
            LET g_ngi05[l_ac].* = g_ngi05_t.*
         ELSE
            IF cl_null(g_ngi05[l_ac].ngi02_05) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi05[l_ac].* = g_ngi05_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi05[l_ac].ngi02_05, 
                                   ngi03 = g_ngi05[l_ac].ngi03_05
                WHERE ngi01 = '5'
                  AND ngi02 = g_ngi05_t.ngi02_05
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi05[l_ac].ngi02_05,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi05_t.ngi02_05,g_ngi05_t.ngi03_05,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi05[l_ac].* = g_ngi05_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi05[l_ac].* = g_ngi05_t.*
            END IF
            CLOSE i940_bcl05
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl05
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi05[l_ac].ngi02_05
               CALL cl_create_qry() RETURNING g_ngi05[l_ac].ngi02_05 
               DISPLAY BY NAME g_ngi05[l_ac].ngi02_05 
               NEXT FIELD ngi02_05
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl05
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b06()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '6' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl06 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi06 WITHOUT DEFAULTS FROM s_ngi06.* 
         ATTRIBUTE(COUNT=g_rec_b06,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b06 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b06 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi06_t.* = g_ngi06[l_ac].*
            OPEN i940_bcl06 USING g_ngi06_t.ngi02_06
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi06_t.ngi02_06,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl06 INTO g_ngi01[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi06_t.ngi02_06,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi06[l_ac].* TO NULL
         LET g_ngi06[l_ac].ngi03_06 = 0
         LET g_ngi06_t.* = g_ngi06[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_06
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi06[l_ac].ngi02_06) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(6,g_ngi06[l_ac].ngi02_06,g_ngi06[l_ac].ngi03_06)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi06[l_ac].ngi02_06,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi06[l_ac].ngi02_06,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b06 = g_rec_b06 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_06
         IF NOT cl_null(g_ngi06[l_ac].ngi02_06) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi06[l_ac].ngi02_06
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi06[l_ac].ngi02_06,"axm-274",0)
                NEXT FIELD ngi02_06
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi06_t.ngi02_06 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '6'
               AND ngi02 = g_ngi06_t.ngi02_06
               AND ngi03 = g_ngi06_t.ngi03_06
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi06_t.ngi02_06,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi06_t.ngi02_06,g_ngi06_t.ngi03_06,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi06[l_ac].* = g_ngi06_t.*
            CLOSE i940_bcl06
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi06[l_ac].ngi02_06,-263,1)
            LET g_ngi06[l_ac].* = g_ngi06_t.*
         ELSE
            IF cl_null(g_ngi06[l_ac].ngi02_06) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi06[l_ac].* = g_ngi06_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi06[l_ac].ngi02_06, 
                                   ngi03 = g_ngi06[l_ac].ngi03_06
                WHERE ngi01 = '6'
                  AND ngi02 = g_ngi06_t.ngi02_06
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi06[l_ac].ngi02_06,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi06_t.ngi02_06,g_ngi06_t.ngi03_06,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi06[l_ac].* = g_ngi06_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi06[l_ac].* = g_ngi06_t.*
            END IF
            CLOSE i940_bcl06
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl06
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi06[l_ac].ngi02_06
               CALL cl_create_qry() RETURNING g_ngi06[l_ac].ngi02_06 
               DISPLAY BY NAME g_ngi06[l_ac].ngi02_06 
               NEXT FIELD ngi02_06
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl06
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b07()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '7' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl07 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi07 WITHOUT DEFAULTS FROM s_ngi07.* 
         ATTRIBUTE(COUNT=g_rec_b07,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b07 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b07 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi07_t.* = g_ngi07[l_ac].*
            OPEN i940_bcl07 USING g_ngi07_t.ngi02_07
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi07_t.ngi02_07,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl07 INTO g_ngi07[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi07_t.ngi02_07,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi07[l_ac].* TO NULL
         LET g_ngi07[l_ac].ngi03_07 = 0
         LET g_ngi07_t.* = g_ngi07[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_07
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi07[l_ac].ngi02_07) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(7,g_ngi07[l_ac].ngi02_07,g_ngi07[l_ac].ngi03_07)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi07[l_ac].ngi02_07,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi07[l_ac].ngi02_07,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b07 = g_rec_b07 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_07
         IF NOT cl_null(g_ngi07[l_ac].ngi02_07) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi07[l_ac].ngi02_07
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi07[l_ac].ngi02_07,"axm-274",0)
                NEXT FIELD ngi02_07
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi07_t.ngi02_07 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '7'
               AND ngi02 = g_ngi07_t.ngi02_07
               AND ngi03 = g_ngi07_t.ngi03_07
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi07_t.ngi02_07,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi07_t.ngi02_07,g_ngi07_t.ngi03_07,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi07[l_ac].* = g_ngi07_t.*
            CLOSE i940_bcl07
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi07[l_ac].ngi02_07,-263,1)
            LET g_ngi07[l_ac].* = g_ngi07_t.*
         ELSE
            IF cl_null(g_ngi07[l_ac].ngi02_07) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi07[l_ac].* = g_ngi07_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi07[l_ac].ngi02_07, 
                                   ngi03 = g_ngi07[l_ac].ngi03_07
                WHERE ngi01 = '7'
                  AND ngi02 = g_ngi07_t.ngi02_07
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi07[l_ac].ngi02_07,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi07_t.ngi02_07,g_ngi07_t.ngi03_07,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi07[l_ac].* = g_ngi07_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi07[l_ac].* = g_ngi07_t.*
            END IF
            CLOSE i940_bcl07
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl07
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi07[l_ac].ngi02_07
               CALL cl_create_qry() RETURNING g_ngi07[l_ac].ngi02_07 
               DISPLAY BY NAME g_ngi07[l_ac].ngi02_07 
               NEXT FIELD ngi02_07
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl07
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b08()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '8' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl08 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi08 WITHOUT DEFAULTS FROM s_ngi08.* 
         ATTRIBUTE(COUNT=g_rec_b08,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b08 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b08 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi08_t.* = g_ngi08[l_ac].*
            OPEN i940_bcl08 USING g_ngi08_t.ngi02_08
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi08_t.ngi02_08,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl08 INTO g_ngi08[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi08_t.ngi02_08,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi08[l_ac].* TO NULL
         LET g_ngi08[l_ac].ngi03_08 = 0
         LET g_ngi08_t.* = g_ngi08[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_08
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi08[l_ac].ngi02_08) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(8,g_ngi08[l_ac].ngi02_08,g_ngi08[l_ac].ngi03_08)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi08[l_ac].ngi02_08,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi08[l_ac].ngi02_08,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b08 = g_rec_b08 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_08
         IF NOT cl_null(g_ngi08[l_ac].ngi02_08) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi08[l_ac].ngi02_08
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi08[l_ac].ngi02_08,"axm-274",0)
                NEXT FIELD ngi02_08
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi08_t.ngi02_08 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '8'
               AND ngi02 = g_ngi08_t.ngi02_08
               AND ngi03 = g_ngi08_t.ngi03_08
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi08_t.ngi02_08,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi08_t.ngi02_08, g_ngi08_t.ngi03_08,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi08[l_ac].* = g_ngi08_t.*
            CLOSE i940_bcl08
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi08[l_ac].ngi02_08,-263,1)
            LET g_ngi08[l_ac].* = g_ngi08_t.*
         ELSE
            IF cl_null(g_ngi08[l_ac].ngi02_08) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi08[l_ac].* = g_ngi08_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi08[l_ac].ngi02_08, 
                                   ngi03 = g_ngi08[l_ac].ngi03_08
                WHERE ngi01 = '8'
                  AND ngi02 = g_ngi08_t.ngi02_08
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi08[l_ac].ngi02_08,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi08_t.ngi02_08, g_ngi08_t.ngi03_08,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi08[l_ac].* = g_ngi08_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi08[l_ac].* = g_ngi08_t.*
            END IF
            CLOSE i940_bcl08
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl08
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi08[l_ac].ngi02_08
               CALL cl_create_qry() RETURNING g_ngi08[l_ac].ngi02_08 
               DISPLAY BY NAME g_ngi08[l_ac].ngi02_08 
               NEXT FIELD ngi02_08
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl08
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i940_b09()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '9' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl09 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi09 WITHOUT DEFAULTS FROM s_ngi09.* 
         ATTRIBUTE(COUNT=g_rec_b09,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b09 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b09 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi09_t.* = g_ngi09[l_ac].*
            OPEN i940_bcl09 USING g_ngi09_t.ngi02_09
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi09_t.ngi02_09,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl09 INTO g_ngi02[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi09_t.ngi02_09,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi09[l_ac].* TO NULL
         LET g_ngi09[l_ac].ngi03_09 = 0
         LET g_ngi09_t.* = g_ngi09[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_09
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi09[l_ac].ngi02_09) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(9,g_ngi09[l_ac].ngi02_09,g_ngi09[l_ac].ngi03_09)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi09[l_ac].ngi02_09,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi09[l_ac].ngi02_09,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b09 = g_rec_b09 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_09
         IF NOT cl_null(g_ngi09[l_ac].ngi02_09) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi09[l_ac].ngi02_09
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi09[l_ac].ngi02_09,"axm-274",0)
                NEXT FIELD ngi02_09
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi09_t.ngi02_09 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '9'
               AND ngi02 = g_ngi09_t.ngi02_09
               AND ngi03 = g_ngi09_t.ngi03_09
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi09_t.ngi02_09,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi09_t.ngi02_09,g_ngi09_t.ngi03_09,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi09[l_ac].* = g_ngi09_t.*
            CLOSE i940_bcl09
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi09[l_ac].ngi02_09,-263,1)
            LET g_ngi09[l_ac].* = g_ngi09_t.*
         ELSE
            IF cl_null(g_ngi09[l_ac].ngi02_09) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi09[l_ac].* = g_ngi09_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi09[l_ac].ngi02_09, 
                                   ngi03 = g_ngi09[l_ac].ngi03_09
                WHERE ngi01 = '9'
                  AND ngi02 = g_ngi09_t.ngi02_09
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi09[l_ac].ngi02_09,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi09_t.ngi02_09,g_ngi09_t.ngi03_09,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi09[l_ac].* = g_ngi09_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi09[l_ac].* = g_ngi09_t.*
            END IF
            CLOSE i940_bcl09
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl09
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi09[l_ac].ngi02_09
               CALL cl_create_qry() RETURNING g_ngi09[l_ac].ngi02_09 
               DISPLAY BY NAME g_ngi09[l_ac].ngi02_09 
               NEXT FIELD ngi02_09
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl09
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b10()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '10' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl10 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi10 WITHOUT DEFAULTS FROM s_ngi10.* 
         ATTRIBUTE(COUNT=g_rec_b10,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b10 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b10 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi10_t.* = g_ngi10[l_ac].*
            OPEN i940_bcl10 USING g_ngi10_t.ngi02_10
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi10_t.ngi02_10,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl10 INTO g_ngi10[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi10_t.ngi02_10,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi10[l_ac].* TO NULL
         LET g_ngi10[l_ac].ngi03_10 = 0
         LET g_ngi10_t.* = g_ngi10[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_10
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi10[l_ac].ngi02_10) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(10,g_ngi10[l_ac].ngi02_10,g_ngi10[l_ac].ngi03_10)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi10[l_ac].ngi02_10,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi10[l_ac].ngi02_10,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b10 = g_rec_b10 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_10
         IF NOT cl_null(g_ngi10[l_ac].ngi02_10) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi10[l_ac].ngi02_10
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi10[l_ac].ngi02_10,"axm-274",0)
                NEXT FIELD ngi02_10
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi10_t.ngi02_10 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '10'
               AND ngi02 = g_ngi10_t.ngi02_10
               AND ngi03 = g_ngi10_t.ngi03_10
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi10_t.ngi02_10,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi10_t.ngi02_10,g_ngi10_t.ngi03_10,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi10[l_ac].* = g_ngi10_t.*
            CLOSE i940_bcl10
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi10[l_ac].ngi02_10,-263,1)
            LET g_ngi10[l_ac].* = g_ngi10_t.*
         ELSE
            IF cl_null(g_ngi10[l_ac].ngi02_10) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi10[l_ac].* = g_ngi10_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi10[l_ac].ngi02_10, 
                                   ngi03 = g_ngi10[l_ac].ngi03_10
                WHERE ngi01 = '10'
                  AND ngi02 = g_ngi10_t.ngi02_10
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi10[l_ac].ngi02_10,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi10_t.ngi02_10,g_ngi10_t.ngi03_10,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi10[l_ac].* = g_ngi10_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi10[l_ac].* = g_ngi10_t.*
            END IF
            CLOSE i940_bcl10
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl10
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi10[l_ac].ngi02_10
               CALL cl_create_qry() RETURNING g_ngi10[l_ac].ngi02_10 
               DISPLAY BY NAME g_ngi10[l_ac].ngi02_10 
               NEXT FIELD ngi02_10
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl10
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b11()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '11' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl11 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi11 WITHOUT DEFAULTS FROM s_ngi11.* 
         ATTRIBUTE(COUNT=g_rec_b11,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b11 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b11 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi11_t.* = g_ngi11[l_ac].*
            OPEN i940_bcl11 USING g_ngi11_t.ngi02_11
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi11_t.ngi02_11,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl11 INTO g_ngi11[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi11_t.ngi02_11,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi11[l_ac].* TO NULL
         LET g_ngi11[l_ac].ngi03_11 = 0
         LET g_ngi11_t.* = g_ngi11[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_11
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi11[l_ac].ngi02_11) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(11,g_ngi11[l_ac].ngi02_11,g_ngi11[l_ac].ngi03_11)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi11[l_ac].ngi02_11,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi11[l_ac].ngi02_11,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b11 = g_rec_b11 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_11
         IF NOT cl_null(g_ngi11[l_ac].ngi02_11) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi11[l_ac].ngi02_11
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi11[l_ac].ngi02_11,"axm-274",0)
                NEXT FIELD ngi02_11
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi11_t.ngi02_11 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '11'
               AND ngi02 = g_ngi11_t.ngi02_11
               AND ngi03 = g_ngi11_t.ngi03_11
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi11_t.ngi02_11,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi11_t.ngi02_11,g_ngi11_t.ngi03_11,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi11[l_ac].* = g_ngi11_t.*
            CLOSE i940_bcl11
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi11[l_ac].ngi02_11,-263,1)
            LET g_ngi11[l_ac].* = g_ngi11_t.*
         ELSE
            IF cl_null(g_ngi11[l_ac].ngi02_11) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi11[l_ac].* = g_ngi11_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi11[l_ac].ngi02_11, 
                                   ngi03 = g_ngi11[l_ac].ngi03_11
                WHERE ngi01 = '11'
                  AND ngi02 = g_ngi11_t.ngi02_11
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi11[l_ac].ngi02_11,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi11_t.ngi02_11,g_ngi11_t.ngi03_11,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi11[l_ac].* = g_ngi11_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi11[l_ac].* = g_ngi11_t.*
            END IF
            CLOSE i940_bcl11
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl11
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi11[l_ac].ngi02_11
               CALL cl_create_qry() RETURNING g_ngi11[l_ac].ngi02_11 
               DISPLAY BY NAME g_ngi11[l_ac].ngi02_11 
               NEXT FIELD ngi02_11
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl11
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b12()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '12' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl12 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi12 WITHOUT DEFAULTS FROM s_ngi12.* 
         ATTRIBUTE(COUNT=g_rec_b12,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b12 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b12 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi12_t.* = g_ngi12[l_ac].*
            OPEN i940_bcl12 USING g_ngi12_t.ngi02_12
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi12_t.ngi02_12,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl12 INTO g_ngi12[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi12_t.ngi02_12,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi12[l_ac].* TO NULL
         LET g_ngi12[l_ac].ngi03_12 = 0
         LET g_ngi12_t.* = g_ngi12[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_12
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi12[l_ac].ngi02_12) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(12,g_ngi12[l_ac].ngi02_12,g_ngi12[l_ac].ngi03_12)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi12[l_ac].ngi02_12,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi12[l_ac].ngi02_12,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b12 = g_rec_b12 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_12
         IF NOT cl_null(g_ngi12[l_ac].ngi02_12) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi12[l_ac].ngi02_12
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi12[l_ac].ngi02_12,"axm-274",0)
                NEXT FIELD ngi02_12
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi12_t.ngi02_12 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '12'
               AND ngi02 = g_ngi12_t.ngi02_12
               AND ngi03 = g_ngi12_t.ngi03_12
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi12_t.ngi02_12,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi12_t.ngi02_12,g_ngi12_t.ngi03_12,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi12[l_ac].* = g_ngi12_t.*
            CLOSE i940_bcl12
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi12[l_ac].ngi02_12,-263,1)
            LET g_ngi12[l_ac].* = g_ngi12_t.*
         ELSE
            IF cl_null(g_ngi12[l_ac].ngi02_12) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi12[l_ac].* = g_ngi12_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi12[l_ac].ngi02_12, 
                                   ngi03 = g_ngi12[l_ac].ngi03_12
                WHERE ngi01 = '12'
                  AND ngi02 = g_ngi12_t.ngi02_12
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi12[l_ac].ngi02_12,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi12_t.ngi02_12,g_ngi12_t.ngi03_12,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi12[l_ac].* = g_ngi12_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi12[l_ac].* = g_ngi12_t.*
            END IF
            CLOSE i940_bcl12
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl12
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi12[l_ac].ngi02_12
               CALL cl_create_qry() RETURNING g_ngi12[l_ac].ngi02_12 
               DISPLAY BY NAME g_ngi12[l_ac].ngi02_12 
               NEXT FIELD ngi02_12
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl12
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b13()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '13' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl13 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi13 WITHOUT DEFAULTS FROM s_ngi13.* 
         ATTRIBUTE(COUNT=g_rec_b13,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b13 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b13 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi13_t.* = g_ngi13[l_ac].*
            OPEN i940_bcl13 USING g_ngi13_t.ngi02_13
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi13_t.ngi02_13,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl13 INTO g_ngi13[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi13_t.ngi02_13,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi13[l_ac].* TO NULL
         LET g_ngi13[l_ac].ngi03_13 = 0
         LET g_ngi13_t.* = g_ngi13[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_13
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi13[l_ac].ngi02_13) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(13,g_ngi13[l_ac].ngi02_13,g_ngi13[l_ac].ngi03_13)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi13[l_ac].ngi02_13,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi13[l_ac].ngi02_13,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b13 = g_rec_b13 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_13
         IF NOT cl_null(g_ngi13[l_ac].ngi02_13) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi13[l_ac].ngi02_13
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi13[l_ac].ngi02_13,"axm-274",0)
                NEXT FIELD ngi02_13
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi13_t.ngi02_13 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '13'
               AND ngi02 = g_ngi13_t.ngi02_13
               AND ngi03 = g_ngi13_t.ngi03_13
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi13_t.ngi02_13,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi13_t.ngi02_13,g_ngi13_t.ngi03_13,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi13[l_ac].* = g_ngi13_t.*
            CLOSE i940_bcl13
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi13[l_ac].ngi02_13,-263,1)
            LET g_ngi13[l_ac].* = g_ngi13_t.*
         ELSE
            IF cl_null(g_ngi13[l_ac].ngi02_13) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi13[l_ac].* = g_ngi13_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi13[l_ac].ngi02_13, 
                                   ngi03 = g_ngi13[l_ac].ngi03_13
                WHERE ngi01 = '13'
                  AND ngi02 = g_ngi13_t.ngi02_13
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi13[l_ac].ngi02_13,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi13_t.ngi02_13,g_ngi13_t.ngi03_13,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi13[l_ac].* = g_ngi13_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi13[l_ac].* = g_ngi13_t.*
            END IF
            CLOSE i940_bcl13
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl13
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi13[l_ac].ngi02_13
               CALL cl_create_qry() RETURNING g_ngi13[l_ac].ngi02_13 
               DISPLAY BY NAME g_ngi13[l_ac].ngi02_13 
               NEXT FIELD ngi02_13
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl13
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i940_b14()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ngi02,ngi03 FROM ngi_file ",
                      " WHERE ngi01 = '14' AND ngi02 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i940_bcl14 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ngi14 WITHOUT DEFAULTS FROM s_ngi14.* 
         ATTRIBUTE(COUNT=g_rec_b14,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b14 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b14 >= l_ac THEN
            LET p_cmd='u'
            LET g_ngi14_t.* = g_ngi14[l_ac].*
            OPEN i940_bcl14 USING g_ngi14_t.ngi02_14
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ngi14_t.ngi02_14,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl14 INTO g_ngi14[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ngi14_t.ngi02_14,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ngi14[l_ac].* TO NULL
         LET g_ngi14[l_ac].ngi03_14 = 0
         LET g_ngi14_t.* = g_ngi14[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ngi02_14
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ngi14[l_ac].ngi02_14) THEN
            CANCEL INSERT
         END IF
         INSERT INTO ngi_file(ngi01,ngi02,ngi03)
                       VALUES(14,g_ngi14[l_ac].ngi02_14,g_ngi14[l_ac].ngi03_14)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ngi14[l_ac].ngi02_14,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","ngi_file",g_ngi14[l_ac].ngi02_14,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b14 = g_rec_b14 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD ngi02_14
         IF NOT cl_null(g_ngi14[l_ac].ngi02_14) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_ngi14[l_ac].ngi02_14
             IF g_cnt = 0 THEN
                CALL cl_err(g_ngi14[l_ac].ngi02_14,"axm-274",0)
                NEXT FIELD ngi02_14
             END IF
         END IF
 
      BEFORE DELETE
         IF g_ngi14_t.ngi02_14 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ngi_file 
             WHERE ngi01 = '14'
               AND ngi02 = g_ngi14_t.ngi02_14
               AND ngi03 = g_ngi14_t.ngi03_14
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_ngi14_t.ngi02_14,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","ngi_file",g_ngi14_t.ngi02_14,g_ngi14_t.ngi03_14,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ngi14[l_ac].* = g_ngi14_t.*
            CLOSE i940_bcl14
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ngi14[l_ac].ngi02_14,-263,1)
            LET g_ngi14[l_ac].* = g_ngi14_t.*
         ELSE
            IF cl_null(g_ngi14[l_ac].ngi02_14) THEN
               CALL cl_err("","axm-039",1)
               LET g_ngi14[l_ac].* = g_ngi14_t.*
            ELSE
               UPDATE ngi_file SET ngi02 = g_ngi14[l_ac].ngi02_14, 
                                   ngi03 = g_ngi14[l_ac].ngi03_14
                WHERE ngi01 = '14'
                  AND ngi02 = g_ngi14_t.ngi02_14
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ngi14[l_ac].ngi02_14,SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","ngi_file",g_ngi14_t.ngi02_14,g_ngi14_t.ngi03_14,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                  LET g_ngi14[l_ac].* = g_ngi14_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ngi14[l_ac].* = g_ngi14_t.*
            END IF
            CLOSE i940_bcl14
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i940_bcl14
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ngi02_14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_ngi14[l_ac].ngi02_14
               CALL cl_create_qry() RETURNING g_ngi14[l_ac].ngi02_14 
               DISPLAY BY NAME g_ngi14[l_ac].ngi02_14 
               NEXT FIELD ngi02_14
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i940_bcl14
   COMMIT WORK
 
END FUNCTION
 
 
 
FUNCTION i940_b_fill()
   CALL g_ngi.clear()
   CALL g_ngi01.clear()
   CALL g_ngi02.clear()
   CALL g_ngi03.clear()
   CALL g_ngi04.clear()
   CALL g_ngi05.clear()
   CALL g_ngi06.clear()
   CALL g_ngi07.clear()
   CALL g_ngi08.clear()
   CALL g_ngi09.clear()
   CALL g_ngi10.clear()
   CALL g_ngi11.clear()
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 = '1'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb01 FROM g_sql
   DECLARE ngi_curs01 CURSOR FOR i940_pb01
 
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH ngi_curs01 INTO g_ngi[g_cnt].ngi02_01,g_ngi[g_cnt].ngi03_01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi02:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_ngi01[g_cnt].ngi02_01 = g_ngi[g_cnt].ngi02_01
      LET g_ngi01[g_cnt].ngi03_01 = g_ngi[g_cnt].ngi03_01
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b01 = g_cnt -1
 
   IF g_rec_b01 < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 = '2'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb02 FROM g_sql
   DECLARE ngi_curs02 CURSOR FOR i940_pb02
   LET g_cnt = 1
 
   FOREACH ngi_curs02 INTO g_ngi[g_cnt].ngi02_02,g_ngi[g_cnt].ngi03_02
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi02:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi02[g_cnt].ngi02_02 = g_ngi[g_cnt].ngi02_02
      LET g_ngi02[g_cnt].ngi03_02 = g_ngi[g_cnt].ngi03_02
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi02.deleteElement(g_cnt)
   LET g_rec_b02 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='3'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb03 FROM g_sql
   DECLARE ngi_curs03 CURSOR FOR i940_pb03
 
   LET g_cnt = 1
 
   FOREACH ngi_curs03 INTO g_ngi[g_cnt].ngi02_03,g_ngi[g_cnt].ngi03_03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi03:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi03[g_cnt].ngi02_03 = g_ngi[g_cnt].ngi02_03
      LET g_ngi03[g_cnt].ngi03_03 = g_ngi[g_cnt].ngi03_03
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi03.deleteElement(g_cnt)
 
   LET g_rec_b03 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='4'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb04 FROM g_sql
   DECLARE ngi_curs04 CURSOR FOR i940_pb04
 
   LET g_cnt = 1
 
   FOREACH ngi_curs04 INTO g_ngi[g_cnt].ngi02_04,g_ngi[g_cnt].ngi03_04
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi04:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi04[g_cnt].ngi02_04 = g_ngi[g_cnt].ngi02_04
      LET g_ngi04[g_cnt].ngi03_04 = g_ngi[g_cnt].ngi03_04
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi04.deleteElement(g_cnt)
 
   LET g_rec_b04 = g_cnt -1
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='5'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb05 FROM g_sql
   DECLARE ngi_curs05 CURSOR FOR i940_pb05
 
   LET g_cnt = 1
 
   FOREACH ngi_curs05 INTO g_ngi[g_cnt].ngi02_05,g_ngi[g_cnt].ngi03_05
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi05:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi05[g_cnt].ngi02_05 = g_ngi[g_cnt].ngi02_05
      LET g_ngi05[g_cnt].ngi03_05 = g_ngi[g_cnt].ngi03_05
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi05.deleteElement(g_cnt)
 
   LET g_rec_b05 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='6'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb06 FROM g_sql
   DECLARE ngi_curs06 CURSOR FOR i940_pb06
 
   LET g_cnt = 1
 
   FOREACH ngi_curs06 INTO g_ngi[g_cnt].ngi02_06,g_ngi[g_cnt].ngi03_06
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi06:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi06[g_cnt].ngi02_06 = g_ngi[g_cnt].ngi02_06
      LET g_ngi06[g_cnt].ngi03_06 = g_ngi[g_cnt].ngi03_06
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi06.deleteElement(g_cnt)
 
   LET g_rec_b06 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='7'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb07 FROM g_sql
   DECLARE ngi_curs07 CURSOR FOR i940_pb07
 
   LET g_cnt = 1
 
   FOREACH ngi_curs07 INTO g_ngi[g_cnt].ngi02_07,g_ngi[g_cnt].ngi03_07
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi07:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi07[g_cnt].ngi02_07 = g_ngi[g_cnt].ngi02_07
      LET g_ngi07[g_cnt].ngi03_07 = g_ngi[g_cnt].ngi03_07
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi07.deleteElement(g_cnt)
 
   LET g_rec_b07 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='8'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb08 FROM g_sql
   DECLARE ngi_curs08 CURSOR FOR i940_pb08
 
   LET g_cnt = 1
 
   FOREACH ngi_curs08 INTO g_ngi[g_cnt].ngi02_08,g_ngi[g_cnt].ngi03_08
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi08:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi08[g_cnt].ngi02_08 = g_ngi[g_cnt].ngi02_08
      LET g_ngi08[g_cnt].ngi03_08 = g_ngi[g_cnt].ngi03_08
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi08.deleteElement(g_cnt)
 
   LET g_rec_b08 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='9'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb09 FROM g_sql
   DECLARE ngi_curs09 CURSOR FOR i940_pb09
 
   LET g_cnt = 1
 
   FOREACH ngi_curs09 INTO g_ngi[g_cnt].ngi02_09,g_ngi[g_cnt].ngi03_09
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi09:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi09[g_cnt].ngi02_09 = g_ngi[g_cnt].ngi02_09
      LET g_ngi09[g_cnt].ngi03_09 = g_ngi[g_cnt].ngi03_09
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi09.deleteElement(g_cnt)
 
   LET g_rec_b09 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='10'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb10 FROM g_sql
   DECLARE ngi_curs10 CURSOR FOR i940_pb10
 
   LET g_cnt = 1
 
   FOREACH ngi_curs10 INTO g_ngi[g_cnt].ngi02_10,g_ngi[g_cnt].ngi03_10
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi10:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi10[g_cnt].ngi02_10 = g_ngi[g_cnt].ngi02_10
      LET g_ngi10[g_cnt].ngi03_10 = g_ngi[g_cnt].ngi03_10
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi10.deleteElement(g_cnt)
 
   LET g_rec_b10 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='11'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb11 FROM g_sql
   DECLARE ngi_curs11 CURSOR FOR i940_pb11
 
   LET g_cnt = 1
 
   FOREACH ngi_curs11 INTO g_ngi[g_cnt].ngi02_11,g_ngi[g_cnt].ngi03_11
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi11:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi11[g_cnt].ngi02_11 = g_ngi[g_cnt].ngi02_11
      LET g_ngi11[g_cnt].ngi03_11 = g_ngi[g_cnt].ngi03_11
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi11.deleteElement(g_cnt)
 
   LET g_rec_b11 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='12'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb12 FROM g_sql
   DECLARE ngi_curs12 CURSOR FOR i940_pb12
 
   LET g_cnt = 1
 
   FOREACH ngi_curs12 INTO g_ngi[g_cnt].ngi02_12,g_ngi[g_cnt].ngi03_12
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi12:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi12[g_cnt].ngi02_12 = g_ngi[g_cnt].ngi02_12
      LET g_ngi12[g_cnt].ngi03_12 = g_ngi[g_cnt].ngi03_12
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi12.deleteElement(g_cnt)
 
   LET g_rec_b12 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='13'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb13 FROM g_sql
   DECLARE ngi_curs13 CURSOR FOR i940_pb13
 
   LET g_cnt = 1
 
   FOREACH ngi_curs13 INTO g_ngi[g_cnt].ngi02_13,g_ngi[g_cnt].ngi03_13
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi13:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi13[g_cnt].ngi02_13 = g_ngi[g_cnt].ngi02_13
      LET g_ngi13[g_cnt].ngi03_13 = g_ngi[g_cnt].ngi03_13
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi13.deleteElement(g_cnt)
 
   LET g_rec_b13 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
   LET g_sql = "SELECT ngi02,ngi03 FROM ngi_file",
               " WHERE ngi01 ='14'",
               " ORDER BY ngi02"
 
   PREPARE i940_pb14 FROM g_sql
   DECLARE ngi_curs14 CURSOR FOR i940_pb14
 
   LET g_cnt = 1
 
   FOREACH ngi_curs14 INTO g_ngi[g_cnt].ngi02_14,g_ngi[g_cnt].ngi03_14
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ngi14:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_ngi14[g_cnt].ngi02_14 = g_ngi[g_cnt].ngi02_14
      LET g_ngi14[g_cnt].ngi03_14 = g_ngi[g_cnt].ngi03_14
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   CALL g_ngi14.deleteElement(g_cnt)
   LET g_rec_b14 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
   LET g_rec_b = g_rec_b - 1
 
END FUNCTION
 
FUNCTION i940_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "modify01" 
      OR g_action_choice = "modify02" OR g_action_choice = "modify03"
      OR g_action_choice = "modify04" OR g_action_choice = "modify05"
      OR g_action_choice = "modify06" OR g_action_choice = "modify07"
      OR g_action_choice = "modify08" OR g_action_choice = "modify09"
      OR g_action_choice = "modify10" OR g_action_choice = "modify11" 
      OR g_action_choice = "modify12" OR g_action_choice = "modify13" 
      OR g_action_choice = "modify14" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ngi TO s_ngi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION modify01
         LET g_action_choice="modify01"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify02
         LET g_action_choice="modify02"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify03
         LET g_action_choice="modify03"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify04
         LET g_action_choice="modify04"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify05
         LET g_action_choice="modify05"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify06
         LET g_action_choice="modify06"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify07
         LET g_action_choice="modify07"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify08
         LET g_action_choice="modify08"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify09
         LET g_action_choice="modify09"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify10
         LET g_action_choice="modify10"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify11
         LET g_action_choice="modify11"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify12
         LET g_action_choice="modify12"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify13
         LET g_action_choice="modify13"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify14
         LET g_action_choice="modify14"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION
 
