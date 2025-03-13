# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: atmi500.4gl
# Descriptions...: 預測影響因素設定維護作業
# Date & Author..: 07/04/02 By kim (FUN-730069)
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-780002 07/08/01 By kim 修改數項規格的問題
# Modify.........: No.TQC-790077 07/09/12 By Carrier ofd05/ofd06/ofd07 非負控管
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C30190 12/03/28 By xumeimei 原報表轉CR報表
# Modify.........: No.TQC-C50038 12/05/07 By fanbj 選擇一筆資料刪除，資料被刪除了，但是畫面沒有清空
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables) #FUN-730069
DEFINE
    g_odf01           LIKE odf_file.odf01,
    g_odf01_t         LIKE odf_file.odf01,
    g_odf02           LIKE odf_file.odf02,
    g_odf02_t         LIKE odf_file.odf02,   
    g_odf03           LIKE odf_file.odf03,
    g_odf03_t         LIKE odf_file.odf03,   
    g_odf             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        odf04         LIKE odf_file.odf04,
        odf05         LIKE odf_file.odf05,
        odf06         LIKE odf_file.odf06,
        odf07         LIKE odf_file.odf07
                      END RECORD,
    g_odf_t           RECORD                 #程式變數 (舊值)
        odf04         LIKE odf_file.odf04,
        odf05         LIKE odf_file.odf05,
        odf06         LIKE odf_file.odf06,
        odf07         LIKE odf_file.odf07
                      END RECORD,
    g_wc,g_sql,g_wc2  STRING,
    g_rec_b           LIKE type_file.num5,   #No.FUN-680098 SMALLINT  #單身筆數
    g_ss              LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
    l_ac              LIKE type_file.num5,   #No.FUN-680098 SMALLINT   #目前處理的ARRAY CNT
    g_argv1           LIKE odf_file.odf01,
    g_argv2           LIKE odf_file.odf02,
    g_argv3           LIKE odf_file.odf03
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680098 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680098 INTEGER
DEFINE   g_msg         LIKE ze_file.ze03  #No.FUN-680098    VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   l_table       STRING                  #No.FUN-C30190 
 
MAIN
#       l_time   LIKE type_file.chr8          #No.FUN-6A0073
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098  SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #FUN-C30190---add---Begin
   LET g_sql = "odf01.odf_file.odf01,",
               "odf02.odf_file.odf02,",
               "odf03.odf_file.odf03,",
               "odf04.odf_file.odf04,",
               "odf05.odf_file.odf05,",
               "odf06.odf_file.odf06,",
               "odf07.odf_file.odf07,",
               "odfacti.odf_file.odfacti,",
               "odfdate.odf_file.odfdate,",
               "odfegrup.odf_file.odfegrup,",
               "odfmodu.odf_file.odfmodu,",
               "odfuser.odf_file.odfuser,",
               "odforig.odf_file.odforig,",
               "odforiu.odf_file.odforiu"

   LET l_table = cl_prt_temptable('atmi500',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   #FUN-C30190---add---End 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   LET g_argv3 =ARG_VAL(3)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i500_w AT p_row,p_col
     WITH FORM "atm/42f/atmi500"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND cl_null(g_argv3)) THEN
      CALL i500_q()
   END IF   
   CALL i500_menu()
 
   CLOSE WINDOW i500_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i500_cs()
DEFINE l_sql STRING
 
    IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND cl_null(g_argv3)) THEN
       LET g_wc = " odf01 = '",g_argv1,"'",
                  " AND odf02 = '",g_argv2,"'",
                  " AND odf03 = '",g_argv3,"'"
    ELSE
       CLEAR FORM                            #清除畫面
       CALL g_odf.clear()
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_odf01 TO NULL    #No.FUN-750051
   INITIALIZE g_odf02 TO NULL    #No.FUN-750051
   INITIALIZE g_odf03 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON odf01,odf02,odf03,odf04,odf05,odf06,odf07
          FROM odf01,odf02,odf03,s_odf[1].odf04,
               s_odf[1].odf05,s_odf[1].odf06,s_odf[1].odf07
               
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(odf01)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_odb"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO odf01
                NEXT FIELD odf01
             WHEN INFIELD(odf02)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_tqb"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO odf02
                NEXT FIELD odf02
             WHEN INFIELD(odf03)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_oba"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO odf03
                NEXT FIELD odf03
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('odfuser', 'odfgrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE odf01,odf02,odf03 FROM odf_file ",
               " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY odf01,odf02,odf03"
    PREPARE i500_prepare FROM g_sql      #預備一下
    DECLARE i500_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i500_prepare
 
    DROP TABLE i500_cnttmp
#   LET l_sql=l_sql," INTO TEMP i500_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=l_sql," INTO TEMP i500_cnttmp"  #No.TQC-720019
    
#   PREPARE i500_cnttmp_pre FROM l_sql       #No.TQC-720019
    PREPARE i500_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
    EXECUTE i500_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i500_cnttmp"      
    
    PREPARE i500_precount FROM g_sql    
    DECLARE i500_count CURSOR FOR i500_precount
 
    IF NOT cl_null(g_argv1) THEN
       LET g_odf01=g_argv1
    END IF
 
    IF NOT cl_null(g_argv2) THEN
       LET g_odf02=g_argv2
    END IF
 
    IF NOT cl_null(g_argv3) THEN
       LET g_odf03=g_argv3
    END IF
    CALL i500_show()
END FUNCTION
 
FUNCTION i500_menu()
 
   WHILE TRUE
      CALL i500_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN
                  CALL i500_a()
               END IF
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i500_q()
            END IF
           WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL i500_r()
              END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i500_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i500_b()
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
               CALL i500_out()
            END IF
        #WHEN "exporttoexcel"
        #   IF cl_chk_act_auth() THEN
        #      CALL cl_export_to_excel
        #      (ui.Interface.getRootNode(),base.TypeInfo.create(g_odf),'','')
        #   END IF
         #No.FUN-6B0040-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_odf01 IS NOT NULL THEN
                LET g_doc.column1 = "odf01"
                LET g_doc.column2 = "odf02"
                LET g_doc.column3 = "odf03"
                LET g_doc.value1 = g_odf01
                LET g_doc.value2 = g_odf02
                LET g_doc.value3 = g_odf03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0040-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i500_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_odf.clear()
   LET g_odf01_t  = NULL
   LET g_odf02_t  = NULL
   LET g_odf03_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i500_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_odf01=NULL
         LET g_odf02=NULL
         LET g_odf03=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_odf.clear()
      ELSE
         CALL i500_b_fill('1=1')            #單身
      END IF
      CALL i500_b()                      #輸入單身
 
      LET g_odf01_t = g_odf01
      LET g_odf02_t = g_odf02
      LET g_odf03_t = g_odf03
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i500_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   #No.FUN-680098 VARCHAR(1)
    l_cnt           LIKE type_file.num10       #No.FUN-680098 INTEGER
DEFINE l_odbacti    LIKE odb_file.odbacti
DEFINE l_tqbacti    LIKE tqb_file.tqbacti
 
    LET g_ss='Y'
 
    CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
 
    INPUT g_odf01,g_odf02,g_odf03 WITHOUT DEFAULTS
        FROM odf01,odf02,odf03
 
       AFTER FIELD odf01
          IF NOT cl_null(g_odf01) THEN
             SELECT odbacti INTO l_odbacti FROM odb_file
                           WHERE odb01=g_odf01
             CASE
                WHEN SQLCA.sqlcode
                   CALL cl_err3("sel","odb_file",g_odf01,"",100,"","",1)
                   NEXT FIELD odf01
                WHEN l_odbacti<>'Y'
                   CALL cl_err3("sel","odb_file",g_odf01,"","9028","","",1)
                   NEXT FIELD odf01
             END CASE
             CALL i500_set_odb02()             
          ELSE
             DISPLAY NULL TO FROMONLY.odb02
          END IF
 
       AFTER FIELD odf02
          IF NOT cl_null(g_odf02) THEN
             SELECT tqbacti INTO l_tqbacti FROM tqb_file
                           WHERE tqb01=g_odf02
             CASE
                WHEN SQLCA.sqlcode
                   CALL cl_err3("sel","tqb_file",g_odf02,"",100,"","",1)
                   NEXT FIELD odf02
                WHEN l_tqbacti<>'Y'
                   CALL cl_err3("sel","tqb_file",g_odf02,"","9028","","",1)
                   NEXT FIELD odf02
             END CASE
             CALL i500_set_tqb02()
          ELSE
             DISPLAY NULL TO FROMONLY.tqb02
          END IF
       
       AFTER FIELD odf03
          IF NOT cl_null(g_odf03) THEN
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM oba_file
                            WHERE oba01=g_odf03
             IF l_cnt=0 THEN
                CALL cl_err3("sel","oba_file",g_odf03,"",100,"","",1)
                NEXT FIELD odf03
             END IF
             CALL i500_set_oba02()
          ELSE
             DISPLAY NULL TO FROMONLY.oba02
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(odf01)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_odb"
                CALL cl_create_qry() RETURNING g_odf01
                DISPLAY g_odf01 TO odf01
                NEXT FIELD odf01
             WHEN INFIELD(odf02)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_tqb"
                CALL cl_create_qry() RETURNING g_odf02
                DISPLAY g_odf02 TO odf02
                NEXT FIELD odf02
             WHEN INFIELD(odf03)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_oba"
                CALL cl_create_qry() RETURNING g_odf03
                DISPLAY g_odf03 TO odf03
                NEXT FIELD odf03
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
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
    END INPUT
 
END FUNCTION
 
FUNCTION i500_q()
   LET g_odf01 = ''
   LET g_odf02 = ''
   LET g_odf03 = ''
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_odf01,g_odf02,g_odf03 TO NULL       #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_odf.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i500_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_odf01,g_odf02,g_odf03 TO NULL
      RETURN
   END IF
 
   OPEN i500_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_odf01,g_odf02,g_odf03 TO NULL
   ELSE
      OPEN i500_count
      FETCH i500_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i500_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i500_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10   #絕對的筆數  #No.FUN-680098 integer
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i500_bcs INTO g_odf01,g_odf02,g_odf03
       WHEN 'P' FETCH PREVIOUS i500_bcs INTO g_odf01,g_odf02,g_odf03
       WHEN 'F' FETCH FIRST    i500_bcs INTO g_odf01,g_odf02,g_odf03
       WHEN 'L' FETCH LAST     i500_bcs INTO g_odf01,g_odf02,g_odf03
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
            FETCH ABSOLUTE l_abso i500_bcs INTO g_odf01,g_odf02,g_odf03
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_odf01,SQLCA.sqlcode,0)
      INITIALIZE g_odf01 TO NULL  #TQC-6B0105
      INITIALIZE g_odf02 TO NULL  #TQC-6B0105
      INITIALIZE g_odf03 TO NULL  #TQC-6B0105
   ELSE
      CALL i500_show()
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
FUNCTION i500_show()
 
   DISPLAY g_odf01 TO odf01
   DISPLAY g_odf02 TO odf02
   DISPLAY g_odf03 TO odf03
   CALL i500_set_odb02()
   CALL i500_set_tqb02()
   CALL i500_set_oba02()
   CALL i500_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i500_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680098 smallint
   l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680098   smallint
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680098    VARCHAR(1)
   p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,          #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5,          #可刪除否          #No.FUN-680098 SMALLINT
   l_cnt           LIKE type_file.num10          #No.FUN-680098  INTEGER
 
   LET g_action_choice = ""
 
   IF cl_null(g_odf01) OR cl_null(g_odf02) OR cl_null(g_odf03) THEN
      CALL cl_err('',-400,1)
      RETURN     #No.TQC-680030 add
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT odf04,odf05,odf06,odf07 FROM odf_file",
                      " WHERE odf01 = ? AND odf02= ? AND odf03= ? AND odf04= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN 
      CALL g_odf.clear() 
      CALL i500_g_b()
   END IF
 
  
   INPUT ARRAY g_odf WITHOUT DEFAULTS FROM s_odf.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
            LET g_odf_t.* = g_odf[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i500_bcl USING g_odf01,g_odf02,g_odf03,g_odf[l_ac].odf04
            IF STATUS THEN
               CALL cl_err("OPEN i500_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i500_bcl INTO g_odf[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i500_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_odf_t.*=g_odf[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_odf[l_ac].* TO NULL            #900423
         LET g_odf_t.* = g_odf[l_ac].*               #新輸入資料
         LET g_odf[l_ac].odf04=g_today
         LET g_odf[l_ac].odf05=0
         LET g_odf[l_ac].odf06=0
         LET g_odf[l_ac].odf07=0
         CALL cl_show_fld_cont()
         NEXT FIELD odf04
 
      AFTER FIELD odf04                         # check data 是否重複
         IF NOT cl_null(g_odf[l_ac].odf04) THEN
            IF g_odf[l_ac].odf04 != g_odf_t.odf04 OR g_odf_t.odf04 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM odf_file
                                         WHERE odf01 = g_odf01
                                           AND odf02 = g_odf02
                                           AND odf03 = g_odf03
                                           AND odf04 = g_odf[l_ac].odf04
               IF (l_cnt > 0) OR (SQLCA.sqlcode) THEN
                  CALL cl_err(g_odf[l_ac].odf04,-239,0)
                  LET g_odf[l_ac].odf04 = g_odf_t.odf04
                  DISPLAY BY NAME g_odf[l_ac].odf04
                  NEXT FIELD odf04
               END IF
            END IF
         END IF
 
      #No.TQC-790077  --Begin
      AFTER FIELD odf05
         IF NOT cl_null(g_odf[l_ac].odf05) THEN
            IF g_odf[l_ac].odf05 < 0 THEN
               CALL cl_err(g_odf[l_ac].odf05,'aim-223',0)
               NEXT FIELD odf05
            END IF
         END IF
 
      AFTER FIELD odf06
         IF NOT cl_null(g_odf[l_ac].odf06) THEN
            IF g_odf[l_ac].odf06 < 0 THEN
               CALL cl_err(g_odf[l_ac].odf06,'aim-223',0)
               NEXT FIELD odf06
            END IF
         END IF
 
      AFTER FIELD odf07
         IF NOT cl_null(g_odf[l_ac].odf07) THEN
            IF g_odf[l_ac].odf07 < 0 THEN
               CALL cl_err(g_odf[l_ac].odf07,'aim-223',0)
               NEXT FIELD odf07
            END IF
         END IF
      #No.TQC-790077  --Begin
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP2
            INITIALIZE g_odf[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_odf[l_ac].* TO s_odf.*
            CALL g_odf.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
            #CANCEL INSERT
         END IF
         INSERT INTO odf_file(odf01,odf02,odf03,odf04,odf05,odf06,odf07,odforiu,odforig)
              VALUES(g_odf01,g_odf02,g_odf03,g_odf[l_ac].odf04,g_odf[l_ac].odf05,
                     g_odf[l_ac].odf06,g_odf[l_ac].odf07, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","odf_file",g_odf[l_ac].odf04,'',SQLCA.sqlcode,"","",1)  #No.FUN-660138
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_odf_t.odf04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM odf_file WHERE odf01 = g_odf01
                                   AND odf02 = g_odf02
                                   AND odf03 = g_odf03
                                   AND odf04 = g_odf_t.odf04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","odf_file",g_odf[l_ac].odf04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
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
            LET g_odf[l_ac].* = g_odf_t.*
            CLOSE i500_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_odf[l_ac].odf04,-263,1)
            LET g_odf[l_ac].* = g_odf_t.*
         ELSE
            UPDATE odf_file SET odf04 = g_odf[l_ac].odf04,
                                odf05 = g_odf[l_ac].odf05,
                                odf06 = g_odf[l_ac].odf06,
                                odf07 = g_odf[l_ac].odf07
                                 WHERE odf01 = g_odf01
                                   AND odf02 = g_odf02
                                   AND odf03 = g_odf03
                                   AND odf04 = g_odf_t.odf04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","odf_file",g_odf[l_ac].odf04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
               LET g_odf[l_ac].* = g_odf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_odf[l_ac].* = g_odf_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_odf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE i500_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30033 add
         CLOSE i500_bcl
         COMMIT WORK
         #CKP2
        #CALL g_odf.deleteElement(g_rec_b+1) #FUN-D30033 mark             
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(odf02) AND l_ac > 1 THEN
            LET g_odf[l_ac].* = g_odf[l_ac-1].*
            LET g_odf[l_ac].odf04=null
            NEXT FIELD odf04
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
 
   CLOSE i500_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i500_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT odf04,odf05,odf06,odf07",
               " FROM odf_file ",
               " WHERE odf01 = '",g_odf01,"'",
               "   AND odf02 = '",g_odf02,"'",
               "   AND odf03 = '",g_odf03,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY odf04"
   PREPARE i500_prepare2 FROM g_sql       #預備一下
   DECLARE odf_cs CURSOR FOR i500_prepare2
 
   CALL g_odf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH odf_cs INTO g_odf[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_odf.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_odf TO s_odf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i500_fetch('L')
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
 
      #ON ACTION exporttoexcel
      #   LET g_action_choice = 'exporttoexcel'
      #   EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i500_copy()
DEFINE
   l_n             LIKE type_file.num5,   #No.FUN-680098   smallint
   l_cnt           LIKE type_file.num10,  #No.FUN-680098   INTEGER
   l_newno1,l_oldno1  LIKE odf_file.odf01,
   l_newno2,l_oldno2  LIKE odf_file.odf02,
   l_newno3,l_oldno3  LIKE odf_file.odf03,
   l_odbacti       LIKE odb_file.odbacti,
   l_tqbacti       LIKE tqb_file.tqbacti 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_odf01) OR cl_null(g_odf02) OR cl_null(g_odf03) THEN
      CALL cl_err('',-400,1)
      RETURN     #No.TQC-680030 add
   END IF
 
   DISPLAY " " TO odf01
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INPUT l_newno1,l_newno2,l_newno3 FROM odf01,odf02,odf03
 
      AFTER FIELD odf01
         IF NOT cl_null(l_newno1) THEN
            SELECT odbacti INTO l_odbacti FROM odb_file
                          WHERE odb01=l_newno1
            CASE
               WHEN SQLCA.sqlcode
                  CALL cl_err3("sel","odb_file",l_newno1,"",100,"","",1)
                  NEXT FIELD odf01
               WHEN l_odbacti<>'Y'
                  CALL cl_err3("sel","odb_file",l_newno1,"","9028","","",1)
                  NEXT FIELD odf01
            END CASE
            CALL i500_set_odb02()             
         ELSE
            DISPLAY NULL TO FROMONLY.odb02
         END IF
 
      AFTER FIELD odf02
         IF NOT cl_null(l_newno2) THEN
            SELECT tqbacti INTO l_tqbacti FROM tqb_file
                          WHERE tqb01=l_newno2
            CASE
               WHEN SQLCA.sqlcode
                  CALL cl_err3("sel","tqb_file",l_newno2,"",100,"","",1)
                  NEXT FIELD odf02
               WHEN l_tqbacti<>'Y'
                  CALL cl_err3("sel","tqb_file",l_newno2,"","9028","","",1)
                  NEXT FIELD odf02
            END CASE
            CALL i500_set_tqb02()
         ELSE
            DISPLAY NULL TO FROMONLY.tqb02
         END IF
      
      AFTER FIELD odf03
         IF NOT cl_null(l_newno3) THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM oba_file
                           WHERE oba01=l_newno3
            IF l_cnt=0 THEN
               CALL cl_err3("sel","oba_file",l_newno3,"",100,"","",1)
               NEXT FIELD odf03
            END IF
            CALL i500_set_oba02()
         ELSE
            DISPLAY NULL TO FROMONLY.oba02
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_odf01 TO odf01
      DISPLAY g_odf02 TO odf02
      DISPLAY g_odf03 TO odf03
      RETURN
   END IF
 
   DROP TABLE i500_x
 
   SELECT * FROM odf_file             #單身複製
    WHERE odf01 = g_odf01
      AND odf02 = g_odf02
      AND odf03 = g_odf03
     INTO TEMP i500_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660138
      CALL cl_err3("ins","i500_x",g_odf01,g_odf02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
      RETURN
   END IF
 
   UPDATE i500_x SET odf01=l_newno1,
                     odf02=l_newno2,
                     odf02=l_newno2
 
   INSERT INTO odf_file SELECT * FROM i500_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660138
      CALL cl_err3("ins","odf_file",l_newno1,l_newno2,SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660138
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_odf01=l_newno1
      LET g_odf02=l_newno2
      LET g_odf03=l_newno3
      CALL i500_show()
   END IF
 
END FUNCTION
 
FUNCTION i500_r()
   IF cl_null(g_odf01) OR cl_null(g_odf02) OR cl_null(g_odf03) THEN
      CALL cl_err('',-400,1)
      RETURN     #No.TQC-680030 add
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "odf01"      #No.FUN-9B0098 10/02/24
   LET g_doc.column2 = "odf02"      #No.FUN-9B0098 10/02/24
   LET g_doc.column3 = "odf03"      #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_odf01       #No.FUN-9B0098 10/02/24
   LET g_doc.value2 = g_odf02       #No.FUN-9B0098 10/02/24
   LET g_doc.value3 = g_odf03       #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM odf_file WHERE odf01=g_odf01
                          AND odf02=g_odf02
                          AND odf03=g_odf03
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('del odf',SQLCA.sqlcode,1)   #No.FUN-660138
      CALL cl_err3("del","odf_file",g_odf01,g_odf02,SQLCA.sqlcode,"","del odf",1)  #No.FUN-660138
      RETURN      
   END IF   
 
   INITIALIZE g_odf01,g_odf02,g_odf03 TO NULL
   #TQC-C50038--start add----------
   CLEAR FORM 
   CALL g_odf.clear()
   #TQC-C50038--end add------------
   MESSAGE ""
   DROP TABLE i500_cnttmp                   #No.TQC-720019
   PREPARE i500_precount_x2 FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i500_precount_x2                 #No.TQC-720019
   OPEN i500_count
   #FUN-B50064-add-start--
   IF STATUS THEN
      CLOSE i500_bcs
      CLOSE i500_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50064-add-end--
   FETCH i500_count INTO g_row_count
   #FUN-B50064-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i500_bcs
      CLOSE i500_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50064-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i500_bcs
      CALL i500_fetch('F') 
   ELSE
      DISPLAY g_odf01 TO odf01
      DISPLAY g_odf02 TO odf02
      DISPLAY g_odf03 TO odf03
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_odf.clear()
      CALL i500_menu()
   END IF                      
END FUNCTION
 
FUNCTION i500_out()
    DEFINE
        sr              RECORD LIKE odf_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680098 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680098 VARCHAR(20)
        l_sql           STRING,                 #FUN-C30190 add
        l_za05          LIKE za_file.za05       # #No.FUN-680098 VARCHAR(40)
   
    IF g_wc IS NULL THEN 
       IF (NOT cl_null(g_odf01)) AND 
          (NOT cl_null(g_odf02)) AND 
          (NOT cl_null(g_odf03)) 
       THEN
          LET g_wc=" odf01='",g_odf01,"'",
                   " AND odf02='",g_odf02,"'",
                   " AND odf03=",g_odf03,"'"
       ELSE
          CALL cl_err('',-400,0)
          RETURN 
       END IF
    END IF
    CALL cl_wait()
    #FUN-C30190---add---Str
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    #FUN-C30190---add---End
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM odf_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY odf01,odf02,odf03,odf04"
    PREPARE i500_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i500_co                         # SCROLL CURSOR
         CURSOR FOR i500_p1
 
    #FUN-C30190---mark---Str
    #CALL cl_outnam('atmi500') RETURNING l_name
    #START REPORT i500_rep TO l_name
    #FUN-C30190---mark---End 

    FOREACH i500_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        #OUTPUT TO REPORT i500_rep(sr.*)     #FUN-C30190 mark
        EXECUTE  insert_prep  USING sr.*     #FUN-C30190 add
    END FOREACH
 
    #FINISH REPORT i500_rep                  #FUN-C30190 mark
 
    CLOSE i500_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)        #FUN-C30190 mark
    #FUN-C30190-----add---str----
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY odf01,odf02,odf03,odf04"
    CALL cl_prt_cs3("atmi500","atmi500",l_sql,'')
    #FUN-C30190-----add---end----
END FUNCTION
 
#FUN-C30190-----mark-----str-----
#REPORT i500_rep(sr)
#    DEFINE
#        l_trailer_sw   LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1),
#        sr RECORD LIKE odf_file.*,
#        l_ima02   LIKE ima_file.ima02,
#        l_ima021  LIKE ima_file.ima021,
#        l_ima25   LIKE ima_file.ima25
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.odf01,sr.odf02,sr.odf03,sr.odf04
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                  g_x[36],g_x[37]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
# 
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.odf01 ,
#                  COLUMN g_c[32],sr.odf02 ,
#                  COLUMN g_c[33],sr.odf03 ,
#                  COLUMN g_c[34],sr.odf04 ,
#                  COLUMN g_c[35],cl_numfor(sr.odf05,35,2) ,
#                  COLUMN g_c[36],cl_numfor(sr.odf06,36,2) ,
#                  COLUMN g_c[37],cl_numfor(sr.odf06,37,2) 
# 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
# 
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-C30190-----mark-----end-----
 
FUNCTION i500_set_odb02()
  DEFINE l_odb02 LIKE odb_file.odb02
  IF g_odf01 IS NULL THEN
     DISPLAY NULL TO FORMONLY.odb02
     RETURN
  END IF
  SELECT odb02 INTO l_odb02 FROM odb_file
              WHERE odb01=g_odf01
  DISPLAY l_odb02 TO FORMONLY.odb02
END FUNCTION
 
FUNCTION i500_set_tqb02()
  DEFINE l_tqb02 LIKE tqb_file.tqb02
  IF g_odf02 IS NULL THEN
     DISPLAY NULL TO FORMONLY.tqb02
     RETURN
  END IF
  SELECT tqb02 INTO l_tqb02 FROM tqb_file
              WHERE tqb01=g_odf02
  DISPLAY l_tqb02 TO FORMONLY.tqb02
END FUNCTION
 
FUNCTION i500_set_oba02()
  DEFINE l_oba02 LIKE oba_file.oba02
  IF g_odf03 IS NULL THEN
     DISPLAY NULL TO FORMONLY.oba02
     RETURN
  END IF
  SELECT oba02 INTO l_oba02 FROM oba_file
              WHERE oba01=g_odf03
  DISPLAY l_oba02 TO FORMONLY.oba02
END FUNCTION
 
FUNCTION i500_g_b()
   DEFINE l_odb       RECORD LIKE odb_file.*
   DEFINE l_mm        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #月
          l_dd        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #日
          l_yy        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #年
             i        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
             j        LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
   SELECT * INTO l_odb.* FROM odb_file 
                        WHERE odb01=g_odf01
   IF cl_null(l_odb.odb04) THEN RETURN END IF
   CASE l_odb.odb04   #計算期數
      WHEN '1' #季
         LET j=((YEAR(l_odb.odb06)-YEAR(l_odb.odb05))*12+MONTH(l_odb.odb06)-MONTH(l_odb.odb05)+1)/3
      WHEN '2' #月
         LET j=((YEAR(l_odb.odb06)-YEAR(l_odb.odb05))*12+MONTH(l_odb.odb06)-MONTH(l_odb.odb05)+1)
      WHEN '3' #旬
         LET j=((YEAR(l_odb.odb06)-YEAR(l_odb.odb05))*365+(MONTH(l_odb.odb06)-MONTH(l_odb.odb05)+1)*30)/10
      WHEN '4' #週
         LET j=((YEAR(l_odb.odb06)-YEAR(l_odb.odb05))*365+(MONTH(l_odb.odb06)-MONTH(l_odb.odb05)+1)*30)/7
      WHEN '5' #天
         LET j=l_odb.odb06-l_odb.odb05+1
   END CASE
   FOR i = 1 TO j
      LET l_mm = MONTH(l_odb.odb05)
      LET l_dd = DAY(l_odb.odb05)
      LET l_yy = YEAR(l_odb.odb05)
      CASE l_odb.odb04
        WHEN '1' #季
          IF i = 1 THEN
            #LET g_odf[i].odf04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odf[i].odf04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odf[i].odf04 = g_odf[i-1].odf04 + 3 UNITS MONTH
          END IF      
        WHEN '2' #月
          IF i = 1 THEN
            #LET g_odf[i].odf04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odf[i].odf04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odf[i].odf04 = g_odf[i-1].odf04 + 1 UNITS MONTH
          END IF                  
        WHEN '3' #旬
          IF i = 1 THEN
            #LET g_odf[i].odf04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odf[i].odf04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odf[i].odf04 = g_odf[i-1].odf04 + 10 UNITS DAY
          END IF                  
        WHEN '4' #週
          IF i = 1 THEN
            #LET g_odf[i].odf04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odf[i].odf04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odf[i].odf04 = g_odf[i-1].odf04 + (i-1)*7 UNITS DAY
          END IF                  
        WHEN '5' #天
          IF i = 1 THEN
            #LET g_odf[i].odf04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odf[i].odf04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odf[i].odf04 = g_odf[i-1].odf04 + 1 UNITS DAY
          END IF                  
      END CASE
      LET g_odf[i].odf05=0
      LET g_odf[i].odf06=0
      LET g_odf[i].odf07=0
      INSERT INTO odf_file(odf01,odf02,odf03,odf04,odf05,odf06,odf07,odforiu,odforig)
           VALUES(g_odf01,g_odf02,g_odf03,g_odf[i].odf04,g_odf[i].odf05,
                  g_odf[i].odf06,g_odf[i].odf07, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","odf_file",g_odf[l_ac].odf04,'',SQLCA.sqlcode,"","",1)  #No.FUN-660138
      ELSE
         LET g_rec_b=g_rec_b+1
         DISPLAY g_rec_b TO FORMONLY.cn2
      END IF
   END FOR
 
END FUNCTION
#FUN-B80061
