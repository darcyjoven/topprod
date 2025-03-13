# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli016.4gl (copy from agli140)
# Descriptions...: 股東權益傳票明細群組歸屬作業
# Date & Author..: 07/08/08 By kim (FUN-780013)
# Modify.........: No.FUN-7A0035 07/10/17 By Nicola 新增"傳票明細產生"功能
# Modify.........: No.FUN-770069 07/10/29 By Sarah i016_gen(),UPDATE的WHERE條件句傳錯值
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-920209 09/03/17 By ve007 update ayc_file時的BUG
# Modify.........: No.TQC-960327 09/06/24 By destiny 打印時會把不同月份的資料印在一起 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/05/19 By hongmei由11區追單, "傳票明細產生"畫面的族群編號增加開窗功能,串axe_file時增加axe13=tm.a
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-920123 10/08/16 By vealxu 將使用axzacti的地方mark
# Modify.........: NO.TQC-AC0315 11/01/06 BY yiting axy_file mark
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ayc01           LIKE ayc_file.ayc01,
    g_ayc01_t         LIKE ayc_file.ayc01,
    g_ayc02           LIKE ayc_file.ayc02,
    g_ayc02_t         LIKE ayc_file.ayc02,   
    g_ayc03           LIKE ayc_file.ayc03,
    g_ayc03_t         LIKE ayc_file.ayc03,   
    g_ayc04           LIKE ayc_file.ayc04,
    g_ayc04_t         LIKE ayc_file.ayc04,
    g_ayc05           LIKE ayc_file.ayc05,
    g_ayc05_t         LIKE ayc_file.ayc05,
    g_ayc             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ayc06         LIKE ayc_file.ayc06,
        ayc07         LIKE ayc_file.ayc07,
        ayc08         LIKE ayc_file.ayc08,
        ayc09         LIKE ayc_file.ayc09,
        ayc10         LIKE ayc_file.ayc10,
        aag02         LIKE aag_file.aag02,
        ayc11         LIKE ayc_file.ayc11,
        ayc12         LIKE ayc_file.ayc12,
        ayc13         LIKE ayc_file.ayc13,
        axl02         LIKE axl_file.axl02
                      END RECORD,
    g_ayc_t           RECORD                 #程式變數 (舊值)
        ayc06         LIKE ayc_file.ayc06,
        ayc07         LIKE ayc_file.ayc07,
        ayc08         LIKE ayc_file.ayc08,
        ayc09         LIKE ayc_file.ayc09,
        ayc10         LIKE ayc_file.ayc10,
        aag02         LIKE aag_file.aag02,
        ayc11         LIKE ayc_file.ayc11,
        ayc12         LIKE ayc_file.ayc12,
        ayc13         LIKE ayc_file.ayc13,
        axl02         LIKE axl_file.axl02
                      END RECORD,
    a                 LIKE type_file.chr1,
    g_wc,g_sql        STRING,
    g_show            LIKE type_file.chr1,   
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,   
    g_ss              LIKE type_file.chr1,   
    l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT
    g_argv1           LIKE ayc_file.ayc01,
    g_argv2           LIKE ayc_file.ayc02,
    g_argv3           LIKE ayc_file.ayc03,
    g_argv4           LIKE ayc_file.ayc04,
    g_argv5           LIKE ayc_file.ayc05 
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098  SMALLINT
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03  #No.FUN-680098    VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   l_cmd         LIKE type_file.chr1000  #No.FUN-760085 
MAIN
#       l_time   LIKE type_file.chr8          #No.FUN-6A0073
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   LET g_argv3 =ARG_VAL(3)
   LET g_argv4 =ARG_VAL(4)
   LET g_argv5 =ARG_VAL(5)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i016_w AT p_row,p_col
     WITH FORM "agl/42f/agli016"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
      (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
      (NOT cl_null(g_argv5)) THEN
      CALL i016_q()
   END IF   
   CALL i016_menu()
 
   CLOSE WINDOW i016_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i016_cs()
DEFINE l_sql STRING
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
      (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
      (NOT cl_null(g_argv5)) THEN
       LET g_wc = "     ayc01 = '",g_argv1,"'",
                  " AND ayc02 = '",g_argv2,"'",
                  " AND ayc03 = '",g_argv3,"'",
                  " AND ayc04 = '",g_argv4,"'",
                  " AND ayc05 = '",g_argv5,"'"
    ELSE
       CLEAR FORM                            #清除畫面
       CALL g_ayc.clear()
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
       INITIALIZE g_ayc01 TO NULL
       INITIALIZE g_ayc02 TO NULL
       INITIALIZE g_ayc03 TO NULL
       INITIALIZE g_ayc04 TO NULL
       INITIALIZE g_ayc05 TO NULL
       CONSTRUCT g_wc ON ayc01,ayc02,ayc03,ayc04,ayc05,ayc06,ayc07,ayc08,
                         ayc09,ayc10,ayc11,ayc12,ayc13
          FROM ayc01,ayc02,ayc03,ayc04,ayc05,
               s_ayc[1].ayc06,s_ayc[1].ayc07,s_ayc[1].ayc08,s_ayc[1].ayc09,
               s_ayc[1].ayc10,s_ayc[1].ayc11,s_ayc[1].ayc12,s_ayc[1].ayc13
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ayc01)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_axz"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ayc01
                NEXT FIELD ayc01
             WHEN INFIELD(ayc10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.state ="c"
               LET g_qryparam.arg1 = g_aaz.aaz64
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_ayc[1].ayc13
               NEXT FIELD ayc10
             WHEN INFIELD(ayc13)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form  = "q_axl"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_ayc[1].ayc13
                NEXT FIELD ayc13
          END CASE
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
       
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
       
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
       
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE ayc01,ayc02,ayc03,ayc04,ayc05 FROM ayc_file ",
               " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY ayc01,ayc02,ayc03,ayc04,ayc05"
    PREPARE i016_prepare FROM g_sql      #預備一下
    DECLARE i016_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i016_prepare
 
    DROP TABLE i016_cnttmp
#   LET l_sql=l_sql," INTO TEMP i016_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=l_sql," INTO TEMP i016_cnttmp"  #No.TQC-720019
    
#   PREPARE i016_cnttmp_pre FROM l_sql       #No.TQC-720019
    PREPARE i016_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
    EXECUTE i016_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i016_cnttmp"
 
    PREPARE i016_precount FROM g_sql
    DECLARE i016_count CURSOR FOR i016_precount
 
    IF NOT cl_null(g_argv1) THEN
       LET g_ayc01=g_argv1
    END IF
 
    IF NOT cl_null(g_argv2) THEN
       LET g_ayc02=g_argv2
    END IF
 
    IF NOT cl_null(g_argv3) THEN
       LET g_ayc02=g_argv3
    END IF
 
    IF NOT cl_null(g_argv4) THEN
       LET g_ayc02=g_argv4
    END IF
 
    IF NOT cl_null(g_argv5) THEN
       LET g_ayc02=g_argv5
    END IF
    CALL i016_show()
END FUNCTION
 
FUNCTION i016_menu()
 
   WHILE TRUE
      CALL i016_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i016_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i016_q()
            END IF
           WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL i016_r()
              END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i016_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i016_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i016_out()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),
                base.TypeInfo.create(g_ayc),'','')
            END IF
         WHEN "genvoucher" #傳票明細產生
            IF cl_chk_act_auth() THEN
               CALL i016_gen()     #No.FUN-7A0035 
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ayc01 IS NOT NULL THEN
                LET g_doc.column1 = "ayc01"
                LET g_doc.column2 = "ayc02"
                LET g_doc.column3 = "ayc03"
                LET g_doc.value1 = g_ayc01
                LET g_doc.value2 = g_ayc02
                LET g_doc.value3 = g_ayc03
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i016_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_ayc.clear()
   LET g_ayc01_t  = NULL
   LET g_ayc02_t  = NULL
   LET g_ayc03_t  = NULL
   LET g_ayc04_t  = NULL
   LET g_ayc05_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i016_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_ayc01=NULL
         LET g_ayc02=NULL
         LET g_ayc03=NULL
         LET g_ayc04=NULL
         LET g_ayc05=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_ayc.clear()
      ELSE
         CALL i016_b_fill('1=1')            #單身
      END IF
 
      CALL i016_b()                      #輸入單身
 
      LET g_ayc01_t = g_ayc01
      LET g_ayc02_t = g_ayc02
      LET g_ayc03_t = g_ayc03
      LET g_ayc04_t = g_ayc04
      LET g_ayc05_t = g_ayc05
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i016_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
    l_cnt           LIKE type_file.num10,
    li_result       LIKE type_file.num5
 
    LET g_ss='Y'
 
    CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
 
    INPUT g_ayc01,g_ayc02,g_ayc03,g_ayc04,g_ayc05 WITHOUT DEFAULTS
        FROM ayc01,ayc02,ayc03,ayc04,ayc05
 
       AFTER FIELD ayc01
          CALL i016_chk_ayc01(g_ayc01) 
               RETURNING li_result,g_ayc02,g_ayc03
          DISPLAY i016_set_axz02(g_ayc01) TO FORMONLY.axz02
          DISPLAY g_ayc02 TO ayc02
          DISPLAY g_ayc03 TO ayc03
          IF NOT li_result THEN
             NEXT FIELD CURRENT
          END IF
       
       AFTER FIELD ayc05
          IF (NOT cl_null(g_ayc01)) OR (NOT cl_null(g_ayc02)) OR
             (NOT cl_null(g_ayc03)) OR (NOT cl_null(g_ayc04)) OR
             (NOT cl_null(g_ayc05)) THEN
             LET l_cnt=0             
             SELECT COUNT(*) INTO l_cnt FROM ayc_file
                                       WHERE ayc01=g_ayc01
                                         AND ayc02=g_ayc02
                                         AND ayc03=g_ayc03
                                         AND ayc04=g_ayc04
                                         AND ayc05=g_ayc05
            IF l_cnt>0 THEN
               CALL cl_err('','-239',1)
               NEXT FIELD ayc01
            END IF
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ayc01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                CALL cl_create_qry() RETURNING g_ayc01
                DISPLAY g_ayc01 TO ayc01
                NEXT FIELD ayc01
          END CASE
       ON ACTION CONTROLG
         CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
    END INPUT
 
END FUNCTION
 
FUNCTION i016_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ayc01,g_ayc02,g_ayc03,g_ayc04,g_ayc05 TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ayc.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i016_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_ayc01,g_ayc02,g_ayc03,g_ayc04,g_ayc05 TO NULL
      RETURN
   END IF
 
   OPEN i016_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ayc01,g_ayc02,g_ayc03,g_ayc04,g_ayc05 TO NULL
   ELSE
      OPEN i016_count
      FETCH i016_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i016_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i016_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式
   l_abso          LIKE type_file.num10   #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i016_bcs INTO g_ayc01,g_ayc02,
                                             g_ayc03,g_ayc04,g_ayc05
       WHEN 'P' FETCH PREVIOUS i016_bcs INTO g_ayc01,g_ayc02,
                                             g_ayc03,g_ayc04,g_ayc05
       WHEN 'F' FETCH FIRST    i016_bcs INTO g_ayc01,g_ayc02,
                                             g_ayc03,g_ayc04,g_ayc05
       WHEN 'L' FETCH LAST     i016_bcs INTO g_ayc01,g_ayc02,
                                             g_ayc03,g_ayc04,g_ayc05
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso i016_bcs INTO g_ayc01,g_ayc02,
                                                g_ayc03,g_ayc04,g_ayc05
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_ayc01,SQLCA.sqlcode,0)
      INITIALIZE g_ayc01 TO NULL
      INITIALIZE g_ayc02 TO NULL
      INITIALIZE g_ayc03 TO NULL
      INITIALIZE g_ayc04 TO NULL
      INITIALIZE g_ayc05 TO NULL
   ELSE
      CALL i016_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i016_show()
 
   DISPLAY g_ayc01 TO ayc01
   DISPLAY g_ayc02 TO ayc02
   DISPLAY g_ayc03 TO ayc03
   DISPLAY g_ayc04 TO ayc04
   DISPLAY g_ayc05 TO ayc05
   DISPLAY i016_set_axz02(g_ayc01) TO FORMONLY.axz02
 
   CALL i016_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i016_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,          #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否       
   p_cmd           LIKE type_file.chr1,          #處理狀態         
   l_allow_insert  LIKE type_file.num5,          #可新增否         
   l_allow_delete  LIKE type_file.num5,          #可刪除否         
   l_cnt           LIKE type_file.num10          #No.FUN-680098
 
   LET g_action_choice = ""
 
   IF cl_null(g_ayc01) OR cl_null(g_ayc02) OR
      cl_null(g_ayc03) OR cl_null(g_ayc04) OR
      cl_null(g_ayc05) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ayc06,ayc07,ayc08,ayc09,ayc10,",
                      "       '',ayc11,ayc12,ayc13,'' FROM ayc_file",
                      "  WHERE ayc01 = ? AND ayc02= ? AND ayc03= ? ",
                      "AND ayc04= ? AND ayc05= ? AND ayc06=? ",
                      "AND ayc07=? AND ayc08=? FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i016_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_ayc.clear() END IF
 
   INPUT ARRAY g_ayc WITHOUT DEFAULTS FROM s_ayc.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ayc_t.* = g_ayc[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i016_bcl USING g_ayc01,g_ayc02,g_ayc03,g_ayc04,g_ayc05,
                                g_ayc[l_ac].ayc06,g_ayc[l_ac].ayc07,
                                g_ayc[l_ac].ayc08
            IF STATUS THEN
               CALL cl_err("OPEN i016_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i016_bcl INTO g_ayc[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i016_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_ayc[l_ac].aag02=i016_set_aag02(g_ayc[l_ac].ayc10)
                  LET g_ayc[l_ac].axl02=i016_set_axl02(g_ayc[l_ac].ayc13)
                  LET g_ayc_t.*=g_ayc[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ayc[l_ac].* TO NULL            #900423
         LET g_ayc_t.* = g_ayc[l_ac].*               #新輸入資料
         LET g_ayc[l_ac].ayc12=0
         CALL cl_show_fld_cont()
         NEXT FIELD ayc06
 
      AFTER FIELD ayc06                         # check data 是否重複
         IF NOT cl_null(g_ayc[l_ac].ayc06) THEN
            IF g_ayc[l_ac].ayc06 != g_ayc_t.ayc06 OR g_ayc_t.ayc06 IS NULL THEN
               IF NOT i016_chk_dudata() THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
 
      AFTER FIELD ayc07                         # check data 是否重複
         IF NOT cl_null(g_ayc[l_ac].ayc07) THEN
            IF g_ayc[l_ac].ayc07 != g_ayc_t.ayc07 OR g_ayc_t.ayc07 IS NULL THEN
               IF NOT i016_chk_dudata() THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
 
      AFTER FIELD ayc08                         # check data 是否重複
         IF NOT cl_null(g_ayc[l_ac].ayc08) THEN
            IF g_ayc[l_ac].ayc08 != g_ayc_t.ayc08 OR g_ayc_t.ayc08 IS NULL THEN
               IF NOT i016_chk_dudata() THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
 
      AFTER FIELD ayc10
         IF NOT i016_chk_ayc10() THEN
            LET g_ayc[l_ac].aag02=NULL
            DISPLAY BY NAME g_ayc[l_ac].aag02
            #Add No.FUN-B10048
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aag"
            LET g_qryparam.construct = 'N'
            LET g_qryparam.default1 = g_ayc[l_ac].ayc10
            LET g_qryparam.arg1 = g_aaz.aaz64
            LET g_qryparam.where = " aag01 LIKE '",g_ayc[l_ac].ayc10 CLIPPED,"%'"
            CALL cl_create_qry() RETURNING g_ayc[l_ac].ayc10
            DISPLAY BY NAME g_ayc[l_ac].ayc10
            #End Add No.FUN-B10048
            NEXT FIELD CURRENT
         END IF
         LET g_ayc[l_ac].aag02=i016_set_aag02(g_ayc[l_ac].ayc10)
 
      AFTER FIELD ayc12
         CALL i006_set_ayc12()
         
      AFTER FIELD ayc13
         IF NOT i016_chk_ayc13() THEN
            LET g_ayc[l_ac].axl02=NULL
            DISPLAY BY NAME g_ayc[l_ac].axl02
            NEXT FIELD CURRENT
         END IF
         LET g_ayc[l_ac].axl02=i016_set_axl02(g_ayc[l_ac].ayc13)
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_ayc[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_ayc[l_ac].* TO s_ayc.*
            CALL g_ayc.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO ayc_file(ayc01,ayc02,ayc03,ayc04,ayc05,
                              ayc06,ayc07,ayc08,ayc09,ayc10,
                              ayc11,ayc12,ayc13)
              VALUES(g_ayc01,g_ayc02,g_ayc03,g_ayc04,g_ayc05,
                     g_ayc[l_ac].ayc06,g_ayc[l_ac].ayc07,g_ayc[l_ac].ayc08,
                     g_ayc[l_ac].ayc09,g_ayc[l_ac].ayc10,g_ayc[l_ac].ayc11,
                     g_ayc[l_ac].ayc12,g_ayc[l_ac].ayc13)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ayc_file",g_ayc[l_ac].ayc06,
                         g_ayc[l_ac].ayc07,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF l_ac>0 THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM ayc_file WHERE ayc01 = g_ayc01
                                   AND ayc02 = g_ayc02
                                   AND ayc03 = g_ayc03
                                   AND ayc04 = g_ayc04
                                   AND ayc05 = g_ayc05
                                   AND ayc06 = g_ayc_t.ayc06
                                   AND ayc07 = g_ayc_t.ayc07
                                   AND ayc08 = g_ayc_t.ayc08
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ayc_file",g_ayc[l_ac].ayc06,
                            g_ayc[l_ac].ayc07,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ayc[l_ac].* = g_ayc_t.*
            CLOSE i016_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ayc[l_ac].ayc06,-263,1)
            LET g_ayc[l_ac].* = g_ayc_t.*
         ELSE
            UPDATE ayc_file SET ayc06 = g_ayc[l_ac].ayc06,
                                ayc07 = g_ayc[l_ac].ayc07,
                                ayc08 = g_ayc[l_ac].ayc08,
                                ayc09 = g_ayc[l_ac].ayc09,
                                ayc10 = g_ayc[l_ac].ayc10,
                                ayc11 = g_ayc[l_ac].ayc11,
                                ayc12 = g_ayc[l_ac].ayc12,
                                ayc13 = g_ayc[l_ac].ayc13
                                 WHERE ayc01 = g_ayc01
                                   AND ayc02 = g_ayc02
                                   AND ayc03 = g_ayc03
                                   AND ayc04 = g_ayc04
                                   AND ayc05 = g_ayc05
                                   AND ayc06 = g_ayc_t.ayc06
                                   AND ayc07 = g_ayc_t.ayc07
                                   AND ayc08 = g_ayc_t.ayc08
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ayc_file",g_ayc[l_ac].ayc06,
                            g_ayc[l_ac].ayc07,SQLCA.sqlcode,"","",1)
               LET g_ayc[l_ac].* = g_ayc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ayc[l_ac].* = g_ayc_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_ayc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i016_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30032 add
         CLOSE i016_bcl
         COMMIT WORK
         #CKP2
          CALL g_ayc.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ayc10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.default1 = g_ayc[l_ac].ayc10
              LET g_qryparam.arg1 = g_aaz.aaz64
              CALL cl_create_qry() RETURNING g_ayc[l_ac].ayc10
              DISPLAY BY NAME g_ayc[l_ac].ayc10
              NEXT FIELD ayc10
           WHEN INFIELD(ayc13)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_axl"
              LET g_qryparam.default1 = g_ayc[l_ac].ayc13
              LET g_qryparam.default2 = g_ayc[l_ac].axl02
              CALL cl_create_qry() RETURNING g_ayc[l_ac].ayc13,
                                             g_ayc[l_ac].axl02
              DISPLAY BY NAME g_ayc[l_ac].ayc13
              DISPLAY BY NAME g_ayc[l_ac].axl02
              NEXT FIELD ayc13
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
             RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END INPUT
 
   CLOSE i016_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i016_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT ayc06,ayc07,ayc08,ayc09,ayc10,'',",
               "       ayc11,ayc12,ayc13,''",
               " FROM ayc_file ",
               " WHERE ayc01 = '",g_ayc01,"'",
               "   AND ayc02 = '",g_ayc02,"'",
               "   AND ayc03 = '",g_ayc03,"'",
               "   AND ayc04 = '",g_ayc04,"'",
               "   AND ayc05 = '",g_ayc05,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY ayc01,ayc02,ayc03,ayc04,ayc05"
   PREPARE i016_prepare2 FROM g_sql       #預備一下
   DECLARE ayc_cs CURSOR FOR i016_prepare2
 
   CALL g_ayc.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH ayc_cs INTO g_ayc[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_ayc[g_cnt].aag02=i016_set_aag02(g_ayc[g_cnt].ayc10)
      LET g_ayc[g_cnt].axl02=i016_set_axl02(g_ayc[g_cnt].ayc13)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_ayc.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i016_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ayc TO s_ayc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i016_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i016_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i016_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i016_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i016_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION genvoucher #傳票明細產生
         LET g_action_choice = 'genvoucher'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i016_copy()
DEFINE
   l_n             LIKE type_file.num5,   #No.FUN-680098   smallint
   l_cnt           LIKE type_file.num10,  #No.FUN-680098   INTEGER
   l_newno1,l_oldno1  LIKE ayc_file.ayc01,
   l_newno2,l_oldno2  LIKE ayc_file.ayc02,
   l_newno3,l_oldno3  LIKE ayc_file.ayc03,
   l_newno4,l_oldno4  LIKE ayc_file.ayc04,
   l_newno5,l_oldno5  LIKE ayc_file.ayc05,
   li_result       LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_ayc01) OR cl_null(g_ayc02) OR
      cl_null(g_ayc03) OR cl_null(g_ayc04) OR
      cl_null(g_ayc05) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   DISPLAY NULL TO ayc01
   DISPLAY NULL TO ayc02
   DISPLAY NULL TO ayc03
   DISPLAY NULL TO ayc04
   DISPLAY NULL TO ayc05
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno5 
    FROM ayc01,ayc02,ayc03,ayc04,ayc05
 
       AFTER FIELD ayc01
          CALL i016_chk_ayc01(l_newno1) 
              RETURNING li_result,l_newno2,l_newno3
          DISPLAY i016_set_axz02(l_newno1) TO FORMONLY.axz02
          DISPLAY l_newno2 TO ayc02
          DISPLAY l_newno3 TO ayc03
          IF NOT li_result THEN
             NEXT FIELD CURRENT
          END IF
 
       AFTER FIELD ayc05
          IF (NOT cl_null(l_newno1)) OR (NOT cl_null(l_newno2)) OR
             (NOT cl_null(l_newno3)) OR (NOT cl_null(l_newno4)) OR
             (NOT cl_null(l_newno5)) THEN
             LET l_cnt=0             
             SELECT COUNT(*) INTO l_cnt FROM ayc_file
                                       WHERE ayc01=l_newno1
                                         AND ayc02=l_newno2
                                         AND ayc03=l_newno3
                                         AND ayc04=l_newno4
                                         AND ayc05=l_newno5
            IF l_cnt>0 THEN
               CALL cl_err('','-239',1)
               NEXT FIELD ayc01
            END IF
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ayc01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                CALL cl_create_qry() RETURNING l_newno1
                DISPLAY l_newno1 TO ayc01
                NEXT FIELD ayc01
          END CASE
 
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_ayc01 TO ayc01
      DISPLAY g_ayc02 TO ayc02
      DISPLAY g_ayc03 TO ayc03
      DISPLAY g_ayc04 TO ayc04
      DISPLAY g_ayc05 TO ayc05
      RETURN
   END IF
 
   DROP TABLE i016_x
 
   SELECT * FROM ayc_file             #單身複製
    WHERE ayc01 = g_ayc01
      AND ayc02 = g_ayc02
      AND ayc03 = g_ayc03
      AND ayc04 = g_ayc04
      AND ayc05 = g_ayc05
     INTO TEMP i016_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","i016_x",g_ayc01,g_ayc02,SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE i016_x SET ayc01=l_newno1,
                     ayc02=l_newno2,
                     ayc03=l_newno3,
                     ayc04=l_newno4,
                     ayc05=l_newno5
 
   INSERT INTO ayc_file SELECT * FROM i016_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","ayc_file",l_newno1,l_newno2,
                    SQLCA.sqlcode,"",g_msg,1)
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_ayc01=l_newno1
      LET g_ayc02=l_newno2
      LET g_ayc03=l_newno3
      LET g_ayc04=l_newno4
      LET g_ayc05=l_newno5
      CALL i016_show()
   END IF
 
END FUNCTION
 
FUNCTION i016_r()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_ayc01) OR cl_null(g_ayc02) OR
      cl_null(g_ayc03) OR cl_null(g_ayc04) OR
      cl_null(g_ayc05) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "ayc01"      #No.FUN-9B0098 10/02/24
   LET g_doc.column2 = "ayc02"      #No.FUN-9B0098 10/02/24
   LET g_doc.column3 = "ayc03"      #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_ayc01       #No.FUN-9B0098 10/02/24
   LET g_doc.value2 = g_ayc02       #No.FUN-9B0098 10/02/24
   LET g_doc.value3 = g_ayc03       #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM ayc_file WHERE ayc01=g_ayc01
                          AND ayc02=g_ayc02
                          AND ayc03=g_ayc03
                          AND ayc04=g_ayc04
                          AND ayc05=g_ayc05
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","ayc_file",g_ayc01,g_ayc02,
                   SQLCA.sqlcode,"","del ayc",1)
      RETURN      
   END IF   
 
   INITIALIZE g_ayc01,g_ayc02,g_ayc03,g_ayc04,g_ayc05 TO NULL
   MESSAGE ""
   DROP TABLE i016_cnttmp                   #No.TQC-720019
   PREPARE i016_precount_x2 FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i016_precount_x2                 #No.TQC-720019
   OPEN i016_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i016_bcs
      CLOSE i016_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   FETCH i016_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i016_bcs
      CLOSE i016_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i016_bcs
      CALL i016_fetch('F') 
   ELSE
      DISPLAY g_ayc01 TO ayc01
      DISPLAY g_ayc02 TO ayc02
      DISPLAY g_ayc03 TO ayc03
      DISPLAY g_ayc04 TO ayc04
      DISPLAY g_ayc05 TO ayc05
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_ayc.clear()
      CALL i016_menu()
   END IF                      
END FUNCTION
 
FUNCTION i016_chk_ayc01(p_ayc01)
   DEFINE p_ayc01 LIKE ayc_file.ayc01
   DEFINE l_axzacti  LIKE axz_file.axzacti
   DEFINE l_axz05 LIKE axz_file.axz05
   DEFINE l_axz06 LIKE axz_file.axz06
   
   LET l_axz05=NULL
   LET l_axz06=NULL
   IF NOT cl_null(p_ayc01) THEN
    # SELECT axzacti,axz05,axz06                            #FUN-920123 mark 
    #   INTO l_axzacti,l_axz05,l_axz06 FROM axz_file        #FUN-920123 mark
      SELECT axz05,axz06                                    #FUN-920123
        INTO l_axz05,l_axz06 FROM axz_file                  #FUN-920123  
                                      WHERE axz01=p_ayc01
      CASE
         WHEN SQLCA.sqlcode
            CALL cl_err3("sel","ayc_file",p_ayc01,"",SQLCA.sqlcode,"","",1)
            RETURN FALSE,NULL,NULL
       #FUN-920123 --------------mark start------------------------- 
       # WHEN l_axzacti='N'                      
       #    CALL cl_err3("sel","ayc_file",p_ayc01,"",9028,"","",1)
       #    RETURN FALSE,NULL,NULL
       #FUN-920123 -------------mark end-----------------------------
      END CASE      
   END IF
   RETURN TRUE,l_axz05,l_axz06
END FUNCTION
 
FUNCTION i016_set_axz02(p_axz01)
   DEFINE p_axz01 LIKE axz_file.axz01
   DEFINE l_axz02 LIKE axz_file.axz02
   
   IF cl_null(p_axz01) THEN RETURN NULL END IF
   LET l_axz02=''
   SELECT axz02 INTO l_axz02 FROM axz_file
                            WHERE axz01=p_axz01
   RETURN l_axz02
END FUNCTION
 
FUNCTION i016_set_aag02(p_aag01)
   DEFINE p_aag01 LIKE aag_file.aag01
   DEFINE l_aag02 LIKE aag_file.aag02
   
   IF cl_null(p_aag01) THEN RETURN NULL END IF
   LET l_aag02=''
   SELECT aag02 INTO l_aag02 FROM aag_file
                            WHERE aag01=p_aag01
                              AND aag00=g_aaz.aaz64
   RETURN l_aag02
END FUNCTION
 
FUNCTION i016_set_axl02(p_axl01)
   DEFINE p_axl01 LIKE axl_file.axl01
   DEFINE l_axl02 LIKE axl_file.axl02
   
   IF cl_null(p_axl01) THEN RETURN NULL END IF
   LET l_axl02=''
   SELECT axl02 INTO l_axl02 FROM axl_file
                            WHERE axl01=p_axl01
   RETURN l_axl02
END FUNCTION
 
FUNCTION i016_chk_ayc10()
   DEFINE l_aagacti LIKE aag_file.aagacti
   IF NOT cl_null(g_ayc[l_ac].ayc10) THEN
      SELECT aagacti INTO l_aagacti FROM aag_file 
                                WHERE aag01 = g_ayc[l_ac].ayc10
                                  AND aag00 = g_aaz.aaz64
      CASE
         WHEN SQLCA.SQLCODE
            CALL cl_err3("sel","aag_file",g_ayc[l_ac].ayc10,"",
                         SQLCA.SQLCODE,"","",1)
            RETURN FALSE
         WHEN l_aagacti='N'
            CALL cl_err3("sel","aag_file",g_ayc[l_ac].ayc10,"",9028,"","",1)
            RETURN FALSE         
      END CASE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i016_chk_ayc13()
   IF NOT cl_null(g_ayc[l_ac].ayc13) THEN
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM axl_file 
                                WHERE axl01 = g_ayc[l_ac].ayc13
      IF g_cnt=0 THEN
         CALL cl_err3("sel","axl_file",g_ayc[l_ac].ayc13,"",100,"","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i006_set_ayc12()
   IF NOT cl_null(g_ayc[l_ac].ayc12) THEN
      SELECT azi04 INTO t_azi04 FROM azi_file
                               WHERE azi01=g_ayc03
      LET g_ayc[l_ac].ayc12=cl_digcut(g_ayc[l_ac].ayc12,t_azi04)
      DISPLAY BY NAME g_ayc[l_ac].ayc12
   END IF
END FUNCTION
 
FUNCTION i016_chk_dudata()
   IF (NOT cl_null(g_ayc[l_ac].ayc06)) AND 
      (NOT cl_null(g_ayc[l_ac].ayc07)) AND
      (NOT cl_null(g_ayc[l_ac].ayc08)) THEN
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM ayc_file
                                WHERE ayc01=g_ayc01
                                  AND ayc02=g_ayc02
                                  AND ayc03=g_ayc03
                                  AND ayc04=g_ayc04
                                  AND ayc05=g_ayc05
                                  AND ayc06=g_ayc[l_ac].ayc06
                                  AND ayc07=g_ayc[l_ac].ayc07
                                  AND ayc08=g_ayc[l_ac].ayc08
      IF g_cnt>0 THEN
         CALL cl_err('',-239,1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i016_out()
   DEFINE l_wc STRING
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'agli016'
 
   #組合出 SQL 指令
   LET g_sql="SELECT A.ayc01,B.axz02 ayc01_d,A.ayc02,A.ayc03,",
             "       A.ayc04,A.ayc05,A.ayc06,A.ayc07,A.ayc08,A.ayc09,",
             "       A.ayc10,C.aag02 ayc10_d,A.ayc11,A.ayc12,A.ayc13,",
             "       D.axl02 ayc13_d,E.azi04",
#            " FROM ayc_file A,axz_file B,aag_file C,axl_file D,azi_file E",                        #No.TQC-960327
             #No.TQC-9B0015  --Begin
             " FROM azi_file E,ayc_file A LEFT OUTER JOIN axz_file B ",
             "                            ON  A.ayc01=B.axz01",
             "                            LEFT OUTER JOIN aag_file C ",
             "                            ON  A.ayc10=C.aag01 ",
             "                            AND C.aag00= '",g_aaz.aaz64,"'",
             "                            LEFT OUTER JOIN axl_file D ",      #No.TQC-960327
             "                            ON  A.ayc13=D.axl01",
             "   WHERE A.ayc03=E.azi01",
             "   AND ",g_wc CLIPPED,
             " ORDER BY A.ayc01,A.ayc02,A.ayc03,A.ayc04,A.ayc05,",
             "          A.ayc06,A.ayc07,A.ayc08"
             #No.TQC-9B0015  --End  
   PREPARE i016_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i016_co  CURSOR FOR i016_p1
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'ayc01,ayc02,ayc03,ayc04,ayc05,ayc06,ayc07,ayc08,
                          ayc09,ayc10,ayc11,ayc12,ayc13')
           RETURNING l_wc
   ELSE
      LET l_wc = ' '
   END IF
 
   CALL cl_prt_cs1('agli016','agli016',g_sql,l_wc)
 
END FUNCTION
#FUN-780013
 
#-----No.FUN-7A0035----- 
FUNCTION i016_gen()
   DEFINE tm   RECORD  
                  a   LIKE axi_file.axi05,
                  b   LIKE ayc_file.ayc01,
                  y   LIKE ayc_file.ayc04,
                  m   LIKE ayc_file.ayc05
               END RECORD
   DEFINE l_aba RECORD  
                   aba01   LIKE aba_file.aba01,
                   aba02   LIKE aba_file.aba02,
                   abb02   LIKE abb_file.abb02,
                   abb03   LIKE abb_file.abb03,
                   abb04   LIKE abb_file.abb04,
                   abb06   LIKE abb_file.abb06,
                   abb07   LIKE abb_file.abb07,
                   axe06   LIKE axe_file.axe06
                END RECORD
   DEFINE l_axi RECORD  
                   axi01   LIKE axi_file.axi01,
                   axi02   LIKE axi_file.axi02,
                   axj02   LIKE axj_file.axj02,
                   axj03   LIKE axj_file.axj03,
                   axj04   LIKE axj_file.axj04,
                   axj06   LIKE axj_file.axj06,
                   axj07   LIKE axj_file.axj07,
                   axe06   LIKE axe_file.axe06
                END RECORD
#---TQC-AC0315 MARK--
#   DEFINE l_axy             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
#        axy05         LIKE axy_file.axy05,
#        axy06         LIKE axy_file.axy06,
#        axy07         LIKE axy_file.axy07,
#        axy08         LIKE axy_file.axy08,
#        axy09         LIKE axy_file.axy09,
#        aag02         LIKE aag_file.aag02,
#        axy10         LIKE axy_file.axy10,
#        axy11         LIKE axy_file.axy11,
#        axy12         LIKE axy_file.axy12,
#        axl02         LIKE axl_file.axl02
#                      END RECORD
#---TQC-AC0315 mark---
   DEFINE l_axz03   LIKE axz_file.axz03
   DEFINE l_axz05   LIKE axz_file.axz05
   DEFINE l_axz06   LIKE axz_file.axz06
   DEFINE l_azp03   LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_wc  STRING
   DEFINE l_n   LIKE type_file.num5
 
   OPEN WINDOW i016_gw AT p_row,p_col
     WITH FORM "agl/42f/agli016_g"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   INPUT tm.a,tm.b,tm.y,tm.m WITHOUT DEFAULTS FROM a,b,y,m
 
     #AFTER FIELD a
     #   IF cl_null(tm.a) THEN
     #      NEXT FIELD a
     #   END IF
 
     #AFTER FIELD b
     #   IF cl_null(tm.b) THEN
     #      NEXT FIELD b
     #   END IF
 
     #AFTER FIELD m
     #   IF cl_null(tm.m) THEN
     #      NEXT FIELD m
     #   END IF
 
     #AFTER FIELD y
     #   IF cl_null(tm.y) THEN
     #      NEXT FIELD y
     #   END IF
 
      ON ACTION CONTROLP
         CASE
           #str FUN-910001 add                                                                                                      
            WHEN INFIELD(a)  #族群代號                                                                                              
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_axa1"                                                                                        
               LET g_qryparam.default1 = tm.a                                                                                       
               CALL cl_create_qry() RETURNING tm.a                                                                                  
               DISPLAY BY NAME tm.a                                                                                                 
               NEXT FIELD a                                                                                                         
           #end FUN-910001 add
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b 
         END CASE
         #-----TQC-860018---------
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         #-----END TQC-860018-----
   END INPUT
 
   IF NOT cl_confirm('abx-080') THEN
      LET g_success = 'Y'
      CLOSE WINDOW i016_gw
      RETURN
   END IF
 
   LET l_sql = "SELECT axz03,axz05,axz06 FROM axz_file ",
               " WHERE axz01='",tm.b CLIPPED,"'"
 
   PREPARE i016_gprepare FROM l_sql
   DECLARE i016_gcs CURSOR FOR i016_gprepare
 
   FOREACH i016_gcs INTO l_axz03,l_axz05,l_axz06
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH i016_gcs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT azp03 INTO l_azp03 FROM azp_file
       WHERE azp01=l_axz03
 
      #上層公司資料庫原始的傳票明細
      LET l_sql = "SELECT aba01,aba02,abb02,abb03,abb04,abb06,abb07,''",
                 #FUN-A50102--mod--str--
                 #"  FROM ",s_dbstring(l_azp03 CLIPPED),"aba_file,",s_dbstring(l_azp03 CLIPPED),"abb_file ",
                  "  FROM ",cl_get_target_table(l_axz03,'aba_file'),",",
                  "       ",cl_get_target_table(l_axz03,'abb_file'),
                 #FUN-A50102--mod--end
                  " WHERE aba01=abb01",
                  "   AND aba00='",l_axz05,"'",
                  "   AND aba03=",tm.y,
                  "   AND aba04=",tm.m,
                  "   AND aba19 <> 'X' "  #CHI-C80041
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql  #FUN-A50102 
      PREPARE i016_abaprepare FROM l_sql
      DECLARE i016_aba CURSOR FOR i016_abaprepare
      
      FOREACH i016_aba INTO l_aba.* 
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH i016_gcs:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         SELECT axe06 INTO l_aba.axe06 FROM axe_file
          WHERE axe04 = l_aba.abb03
            AND axe01 = tm.b
            AND axe00 = l_axz05
            AND axe13 = tm.a   #FUN-910001 add  #族群代號
 
         SELECT COUNT(*) INTO l_n FROM ayb_file 
          WHERE ayb02=l_aba.axe06
 
         IF cl_null(l_n) OR l_n=0 THEN
            CONTINUE FOREACH
         END IF
 
         LET l_n = 0
 
         SELECT COUNT(*) INTO l_n FROM ayc_file
          WHERE ayc01 = tm.b 
            AND ayc02 = l_axz05
            AND ayc03 = l_axz06
            AND ayc04 = tm.y 
            AND ayc05 = tm.m 
            AND ayc07 = l_aba.aba01
            AND ayc08 = l_aba.abb02
 
         IF l_n=0 THEN
 
           #INSERT INTO axy_file(axy01,axy02,axy03,axy04,axy05,
           #                     axy06,axy07,axy08,axy09,axy10,
           #                     axy11)
           #     VALUES(tm.b,l_axz05,tm.y,tm.m,l_aba.aba02,l_aba.aba01,
           #            l_aba.abb02,l_aba.abb04,l_aba.axe06,
           #            l_aba.abb06,l_aba.abb07)
            INSERT INTO ayc_file(ayc01,ayc02,ayc03,ayc04,ayc05,
                                 ayc06,ayc07,ayc08,ayc09,ayc10,
                                 ayc11,ayc12)
                 VALUES(tm.b,l_axz05,l_axz06,tm.y,tm.m,l_aba.aba02,l_aba.aba01,
                        l_aba.abb02,l_aba.abb04,l_aba.axe06,
                        l_aba.abb06,l_aba.abb07)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ayc_file",l_aba.aba01,
                            l_aba.aba02,SQLCA.sqlcode,"","",1)
            END IF
         ELSE
          #UPDATE axy_file SET axy05 = l_aba.aba02,
          #                    axy08 = l_aba.axe06,
          #                    axy09 = l_aba.abb04,
          #                    axy10 = l_aba.abb06,
          #                    axy11 = l_aba.abb07
           UPDATE ayc_file SET ayc06 = l_aba.aba02,
#                              ayc09 = l_aba.axe06,
#                              ayc10 = l_aba.abb04,
                               ayc09 = l_aba.abb04,              #NO.FUN-920209
                               ayc10 = l_aba.axe06,              #No.FUN-920209
                               ayc11 = l_aba.abb06,
                               ayc12 = l_aba.abb07
             WHERE ayc01 = tm.b
               AND ayc02 = l_axz05
               AND ayc03 = l_axz06   #FUN-770069 mod 10/29
               AND ayc04 = tm.y
               AND ayc05 = tm.m
               AND ayc07 = l_aba.aba01
               AND ayc08 = l_aba.abb02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ayc_file",l_aba.aba01,
                            l_aba.aba02,SQLCA.sqlcode,"","",1)
            END IF
         END IF
 
      END FOREACH
 
      #調整沖銷分錄底稿
      LET l_sql = "SELECT axi01,axi02,axj02,axj03,axj04,axj06,axj07,''",
                 #FUN-A50102--mod--str--
                 #"  FROM ",s_dbstring(l_azp03 CLIPPED),"axi_file,",s_dbstring(l_azp03 CLIPPED),"axj_file ",
                  "  FROM ",cl_get_target_table(l_axz03,'axi_file'),",",
                  "       ",cl_get_target_table(l_axz03,'axj_file'),
                 #FUN-A50102--mod--end
                  " WHERE axi01=axj01",
                  "   AND axi21='00'",
                  "   AND axi00='",l_axz05,"'",
                  "   AND axi05='",tm.a,"'",
                  "   AND axi03=",tm.y,
                  "   AND axi04=",tm.m,
                  "   AND axiconf <> 'X' "  #CHI-C80041
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql  #FUN-A50102    
      PREPARE i016_axiprepare FROM l_sql
      DECLARE i016_axi CURSOR FOR i016_axiprepare
      
      FOREACH i016_axi INTO l_axi.* 
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH i016_axi:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         SELECT COUNT(*) INTO l_n FROM ayb_file 
          WHERE ayb02=l_axi.axj03
 
         IF cl_null(l_n) OR l_n=0 THEN
            CONTINUE FOREACH
         END IF
 
         LET l_n = 0
 
         SELECT COUNT(*) INTO l_n FROM ayc_file
          WHERE ayc01 = tm.b 
            AND ayc02 = l_axz05
            AND ayc03 = l_axz06
            AND ayc04 = tm.y 
            AND ayc05 = tm.m 
            AND ayc07 = l_axi.axi01
            AND ayc08 = l_axi.axj02
 
         IF l_n=0 THEN
 
           #INSERT INTO axy_file(axy01,axy02,axy03,axy04,axy05,
           #                     axy06,axy07,axy08,axy09,axy10,
           #                     axy11)
           #     VALUES(tm.b,l_axz05,tm.y,tm.m,l_axi.axi02,l_axi.axi01,
           #           #l_axi.axj02,l_axi.axe06,l_axi.axj04,
           #            l_axi.axj02,l_axi.axj04,l_axi.axj03,
           #            l_axi.axj06,l_axi.axj07)
            INSERT INTO ayc_file(ayc01,ayc02,ayc03,ayc04,ayc05,
                                 ayc06,ayc07,ayc08,ayc09,ayc10,
                                 ayc11,ayc12)
                 VALUES(tm.b,l_axz05,l_axz06,tm.y,tm.m,l_axi.axi02,
                        l_axi.axi01,l_axi.axj02,l_axi.axj04,l_axi.axj03,
                        l_axi.axj06,l_axi.axj07)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ayc_file",l_axi.axi01,
                            l_axi.axi02,SQLCA.sqlcode,"","",1)
            END IF
         ELSE
           UPDATE ayc_file SET ayc06 = l_axi.axi02,
                               ayc09 = l_axi.axj04,
                               ayc10 = l_axi.axj03,
                               ayc11 = l_axi.axj06,
                               ayc12 = l_axi.axj07
             WHERE ayc01 = tm.b
               AND ayc02 = l_axz05
               AND ayc03 = l_axz06
               AND ayc04 = tm.y
               AND ayc05 = tm.m
               AND ayc07 = l_axi.axi01
               AND ayc08 = l_axi.axj02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ayc_file",l_axi.axi01,
                            l_axi.axi02,SQLCA.sqlcode,"","",1)
            END IF
         END IF
 
      END FOREACH
   END FOREACH
 
   CLOSE WINDOW i016_gw
 
   LET g_ayc01=tm.b
   LET g_ayc02=l_axz05
   LET g_ayc03=l_axz06
   LET g_ayc04=tm.y
   LET g_ayc05=tm.m
 
   DISPLAY g_ayc01 TO ayc01
   DISPLAY g_ayc02 TO ayc02
   DISPLAY g_ayc03 TO ayc03
   DISPLAY g_ayc04 TO ayc04
   DISPLAY g_ayc05 TO ayc05
 
   DISPLAY i016_set_axz02(g_ayc01) TO FORMONLY.axz02
 
   CALL i016_b_fill(' 1=1')
 
   CALL i016_b() 
 
  #OPEN WINDOW i016_dw AT p_row,p_col
  #  WITH FORM "agl/42f/agli016_d"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
  #CALL cl_ui_init()
 
  #LET g_sql = "SELECT axy05,axy06,axy07,axy08,axy09,'',axy10,axy11,axy12,'' ",
  #            "  FROM axy_file ",
  #            " WHERE axy01='",tm.b,"'", 
  #            "   AND axy02='",l_axz05,"'", 
  #            "   AND axy03=",tm.y, 
  #            "   AND axy04=",tm.m,
  #            " ORDER BY axy05,axy06,axy07"
 
  #PREPARE i016_prepared FROM g_sql
  #DECLARE axy_cs CURSOR FOR i016_prepared
 
  #CALL l_axy.clear()
  #LET g_cnt = 1
 
  #FOREACH axy_cs INTO l_axy[g_cnt].*     #單身 ARRAY 填充
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err('FOREACH axy:',SQLCA.sqlcode,1)
  #      EXIT FOREACH
  #   END IF
 
  #   SELECT aag02 INTO l_axy[g_cnt].aag02
  #     FROM aag_file
  #    WHERE aag01 = l_axy[g_cnt].axy09
 
  #   SELECT axl02 INTO l_axy[g_cnt].axl02
  #     FROM axl_file
  #    WHERE axl01 = l_axy[g_cnt].axy12
 
  #   LET g_cnt = g_cnt + 1
 
  #   IF g_cnt > g_max_rec THEN
  #      CALL cl_err( '', 9035, 0 )
  #      EXIT FOREACH
  #   END IF
  #END FOREACH
 
  #CALL g_ayc.deleteElement(g_cnt)
 
  #DISPLAY ARRAY l_axy TO s_axy.* ATTRIBUTE(COUNT=g_cnt,UNBUFFERED)
 
  #LET g_forupd_sql = "SELECT axy05,axy06,axy07,axy08,axy09,'',axy10,axy11,axy12,'' ",
  #                   "  FROM axy_file ",
  #                   " WHERE axy01='",tm.b,"'", 
  #                   "   AND axy02='",l_axz05,"'", 
  #                   "   AND axy03=",tm.y, 
  #                   "   AND axy04=",tm.m,
  #                   "   AND axy06=?",
  #                   "   AND axy07=?",
  #                   "   FOR UPDATE"
 
  # DECLARE s_axy_bcl CURSOR FROM g_forupd_sql 
 
 
  #INPUT ARRAY l_axy WITHOUT DEFAULTS FROM s_axy.*
  #   ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
  #             INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
  #   BEFORE INPUT
  #      IF g_rec_b != 0 THEN
  #         CALL fgl_set_arr_curr(l_ac)
  #      END IF
 
  #   BEFORE ROW
  #      LET l_ac = ARR_CURR()
  #      LET l_n  = ARR_COUNT()
  #      BEGIN WORK
  #      IF g_rec_b>=l_ac THEN
  #          OPEN s_axy_bcl USING l_axy[l_ac].axy06,l_axy[l_ac].axy07
  #          IF STATUS THEN
  #             CALL cl_err("OPEN s_axy_bcl:", STATUS, 1)
  #             CLOSE s_axy_bcl
  #             RETURN
  #          ELSE
  #             FETCH s_axy_bcl INTO l_axy[l_ac].*
  #             IF SQLCA.sqlcode THEN
  #                CALL cl_err('lock npq',SQLCA.sqlcode,1)
  #             END IF
 
  #             SELECT aag02 INTO l_axy[l_ac].aag02
  #               FROM aag_file
  #              WHERE aag01 = l_axy[l_ac].axy09
  #       
  #             SELECT axl02 INTO l_axy[l_ac].axl02
  #               FROM axl_file
  #              WHERE axl01 = l_axy[l_ac].axy12
  #          END IF
  #       END IF
  #          CALL cl_show_fld_cont()
 
  #      AFTER ROW
  #         IF INT_FLAG THEN
  #            CALL cl_err('',9001,0)
  #            LET INT_FLAG = 0
  #            CLOSE s_axy_bcl
  #            EXIT INPUT
  #         END IF
 
  #        UPDATE axy_file SET axy12 = l_axy[l_ac].axy12
  #          WHERE axy01 = tm.a
  #            AND axy02 = tm.b
  #            AND axy03 = tm.y
  #            AND axy04 = tm.m
  #            AND axy06 = l_axy[l_ac].axy06
  #            AND axy07 = l_axy[l_ac].axy07
  #         IF SQLCA.sqlcode THEN
  #            CALL cl_err3("upd","axy_file",l_axy[l_ac].axy06,
  #                         l_axy[l_ac].axy07,SQLCA.sqlcode,"","",1)
  #         END IF
  #      
  #   END INPUT
 
  #CLOSE WINDOW i016_dw
 
 
 
END FUNCTION
#-----No.FUN-7A0035 END----- 
