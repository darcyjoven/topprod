# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: axci311.4gl
# Descriptions...: 料件分類毛利費用率維護
# Date & Author..: 09/03/24 By jan
# Modify.........: No.FUN-930100 09/04/10 by jan
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/25 By lutingting GP5.2 axc模组table类型重新设置
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管  
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_cmf_o         RECORD LIKE cmf_file.*,       #細部品名碼 (舊值)
       g_cmfa          RECORD LIKE cmf_file.*,       #細部品名碼 (舊值)
       g_cmfa_t        RECORD LIKE cmf_file.*,       #細部品名碼 (舊值)
       g_cmf01         LIKE cmf_file.cmf01,
       g_cmf01_t       LIKE cmf_file.cmf01,   #細部品名碼 (舊值)
       g_cmf02         LIKE cmf_file.cmf02,
       g_cmf02_t       LIKE cmf_file.cmf02,   #細部品名碼 (舊值)
       g_cmf06         LIKE cmf_file.cmf06,   #料件分類來源 
       g_cmf06_t       LIKE cmf_file.cmf06,   #料件分類來源(舊值) 
       g_cmf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           cmf03       LIKE cmf_file.cmf03,   #分群一
           cmf031      LIKE cmf_file.cmf031,  #產品分類 
           cmf04       LIKE cmf_file.cmf04,   
           cmf05       LIKE cmf_file.cmf05    
                       END RECORD,
       g_cmf_t         RECORD                 #程式變數 (舊值)
           cmf03       LIKE cmf_file.cmf03,   #分群一
           cmf031      LIKE cmf_file.cmf031,  #產品分類 
           cmf04       LIKE cmf_file.cmf04,   
           cmf05       LIKE cmf_file.cmf05    
                       END RECORD,
       g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
       g_rec_b         LIKE type_file.num5,                #單身筆數
       l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT    
       l_sl            LIKE type_file.num5,                #目前處理的SCREEN LINE
       g_y             LIKE type_file.num5,           
       g_m             LIKE type_file.num5,           
       g_argv1         LIKE cmf_file.cmf01            
 
#主程式開始
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp      STRING   #No.TQC-720019
DEFINE l_sql          STRING   #No.FUN-780017
DEFINE g_before_input_done LIKE type_file.num5  
DEFINE g_cnt          LIKE type_file.num10 
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose 
DEFINE g_msg          LIKE type_file.chr1000 
DEFINE g_row_count    LIKE type_file.num10 
DEFINE g_curs_index   LIKE type_file.num10 
DEFINE g_jump         LIKE type_file.num10 
DEFINE g_no_ask       LIKE type_file.num5  
DEFINE g_str          STRING    
MAIN
DEFINE p_row,p_col   LIKE type_file.num5          
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time  
    LET g_argv1 = ARG_VAL(1)
    LET g_cmf01= NULL
    LET g_cmf01_t= NULL
    LET p_row = 3 LET p_col = 30
    OPEN WINDOW i311_w AT p_row,p_col
        WITH FORM "axc/42f/axci311"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN CALL i311_q() END IF
    CALL i311_menu()
    CLOSE WINDOW i311_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time    
END MAIN
 
FUNCTION i311_cs()
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             #清除畫面
      CALL g_cmf.clear()
      CALL cl_set_head_visible("","YES") 
 
      INITIALIZE g_cmf01 TO NULL
      INITIALIZE g_cmf02 TO NULL  
      INITIALIZE g_cmf06 TO NULL   
 
      #螢幕上取條件
      CONSTRUCT g_wc ON cmf01,cmf02,cmf06,cmf03,cmf031,cmf04,cmf05  
           FROM cmf01,cmf02,cmf06,s_cmf[1].cmf03,s_cmf[1].cmf031,   
                s_cmf[1].cmf04,s_cmf[1].cmf05
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
       
         ON ACTION controlp
            CASE 
               WHEN INFIELD(cmf03) #其他分群碼一
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_azf"
                    LET g_qryparam.arg1     = "G"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cmf03
                    NEXT FIELD cmf03
               WHEN INFIELD(cmf031)   #產品分類
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_oba"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cmf031
                    NEXT FIELD cmf031
               WHEN INFIELD(cmf04)  
#FUN-AA0059---------mod------------str-----------------                
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form  = "q_ima"
#                    LET g_qryparam.state = "c"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO cmf04
                    NEXT FIELD cmf04
               OTHERWISE EXIT CASE
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cmfuser', 'cmfgrup') #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc=" cmf01='",g_argv1,"'"
   END IF
   LET g_sql= "SELECT UNIQUE cmf01,cmf02,cmf06 FROM cmf_file",   
              " WHERE ", g_wc CLIPPED,
              " ORDER BY cmf01"
   PREPARE i311_prepare FROM g_sql      #預備一下
   DECLARE i311_b_cs SCROLL CURSOR WITH HOLD FOR i311_prepare   #宣告成可捲動的
 
   LET g_sql_tmp= "SELECT UNIQUE cmf01,cmf02,cmf06 FROM cmf_file",  
                  " WHERE ", g_wc CLIPPED,
                  " INTO TEMP x "
   DROP TABLE x
   PREPARE i311_precount_x FROM g_sql_tmp  
   EXECUTE i311_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i311_precount FROM g_sql
   DECLARE i311_count CURSOR FOR i311_precount
END FUNCTION
 
FUNCTION i311_menu()
 
   WHILE TRUE
      LET g_argv1 = ARG_VAL(1)
      CALL i311_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i311_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i311_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i311_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i311_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i311_out()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i311_copy()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_cmf),'','')
            END IF
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_cmf01 IS NOT NULL THEN
                  LET g_doc.column1 = "cmf01"
                  LET g_doc.column2 = "cmf02"
                  LET g_doc.column3 = "cmf06"  
                  LET g_doc.value1 = g_cmf01
                  LET g_doc.value2 = g_cmf02
                  LET g_doc.value3 = g_cmf06   
                  CALL cl_doc()
               END IF 
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i311_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_cmf.clear()
   INITIALIZE g_cmf01 LIKE cmf_file.cmf01
   INITIALIZE g_cmf02 LIKE cmf_file.cmf02
   INITIALIZE g_cmf06 LIKE cmf_file.cmf06 
   INITIALIZE g_cmfa.* LIKE cmf_file.*      #DEFAULT 設定
   LET g_cmf01_t = NULL
   LET g_cmf02_t = NULL
   LET g_cmf06_t = NULL                     #FUN-7B0116 add
   #預設值及將數值類變數清成零
   LET g_cmf_o.* = g_cmfa.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_cmfa.cmf06 = '1'  
      CALL i311_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_cmfa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_cmfa.cmf01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      LET g_rec_b=0
      CALL i311_b()                   #輸入單身
      LET g_cmf01_t=g_cmf01
      LET g_cmf02_t=g_cmf02
      LET g_cmf06_t=g_cmf06  
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i311_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入      
       p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       
 
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT BY NAME g_cmfa.cmf01,g_cmfa.cmf02,g_cmfa.cmf06 WITHOUT DEFAULTS  
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i311_set_entry(p_cmd)
         CALL i311_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
       
      AFTER FIELD cmf01                  #年度
         IF NOT cl_null(g_cmfa.cmf01)  THEN
            LET g_cmf01=g_cmfa.cmf01
         END IF
 
      AFTER FIELD cmf02                  #月份
         IF NOT cl_null(g_cmfa.cmf02) THEN 
            IF g_cmfa.cmf02 <= 0 OR g_cmfa.cmf02 > 12 THEN
               CALL cl_err(g_cmfa.cmf02,'aom-580',0)
               LET g_cmfa.cmf02=g_cmf_o.cmf02
               DISPLAY BY NAME g_cmfa.cmf02 
               NEXT FIELD cmf02
            END IF
            LET g_cmf_o.cmf02=g_cmfa.cmf02
            LET g_cmf02=g_cmfa.cmf02
         END IF
            
      AFTER FIELD cmf06      #料件分類來源(1.成本分群 2.產品分類)
         IF NOT cl_null(g_cmfa.cmf06)  THEN
            LET g_cmf_o.cmf06=g_cmfa.cmf06
            LET g_cmf06=g_cmfa.cmf06
            IF g_cmfa.cmf06 != g_cmf06_t OR g_cmf06_t IS NULL THEN
               SELECT count(*) INTO g_cnt FROM cmf_file
                WHERE cmf01 = g_cmfa.cmf01
                  AND cmf02 = g_cmfa.cmf02
                  AND cmf06 = g_cmfa.cmf06 
               IF g_cnt > 0 THEN  
                  CALL cl_err(g_cmfa.cmf06,-239,0)
                  LET g_cmfa.cmf06 = g_cmf06_t
                  DISPLAY BY NAME g_cmfa.cmf06 
                  NEXT FIELD cmf06
               END IF
            END IF
         END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
         IF g_cmfa.cmf02 IS NULL OR g_cmfa.cmf02 <=0 OR g_cmfa.cmf02 > 12 THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_cmfa.cmf02 
         END IF    
         IF g_cmfa.cmf06 IS NULL OR g_cmfa.cmf06 NOT MATCHES '[1234567]' THEN    
            LET l_flag='Y'
            DISPLAY BY NAME g_cmfa.cmf06
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD cmf01
         END IF
         LET g_cmf06=g_cmfa.cmf06 
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
   END INPUT
END FUNCTION
 
FUNCTION i311_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cmf01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i311_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1  
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cmf01",FALSE)
   END IF
END FUNCTION
 
FUNCTION i311_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_cmf01 TO NULL 
   INITIALIZE g_cmf02 TO NULL 
   INITIALIZE g_cmf06 TO NULL 
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i311_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i311_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cmf01 TO NULL
      INITIALIZE g_cmf02 TO NULL  
      INITIALIZE g_cmf06 TO NULL  
   ELSE
      OPEN i311_count
      FETCH i311_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i311_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i311_fetch(p_flag)
DEFINE p_flag       LIKE type_file.chr1      #處理方式   #No.FUN-680122 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i311_b_cs INTO g_cmf01,g_cmf02,g_cmf06 
      WHEN 'P' FETCH PREVIOUS i311_b_cs INTO g_cmf01,g_cmf02,g_cmf06 
      WHEN 'F' FETCH FIRST    i311_b_cs INTO g_cmf01,g_cmf02,g_cmf06 
      WHEN 'L' FETCH LAST     i311_b_cs INTO g_cmf01,g_cmf02,g_cmf06  
      WHEN '/'
           IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
                   #CONTINUE PROMPT
 
                 ON ACTION about         #MOD-4C0121
                    CALL cl_about()      #MOD-4C0121
            
                 ON ACTION help          #MOD-4C0121
                    CALL cl_show_help()  #MOD-4C0121
            
                 ON ACTION controlg      #MOD-4C0121
                    CALL cl_cmdask()     #MOD-4C0121
              END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump i311_b_cs INTO g_cmf01,g_cmf02,g_cmf06 
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cmf01,SQLCA.sqlcode,0)
      INITIALIZE g_cmf01 TO NULL 
      INITIALIZE g_cmf02 TO NULL 
      INITIALIZE g_cmf06 TO NULL 
   ELSE
      CALL i311_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i311_show()
   DISPLAY g_cmf01,g_cmf02,g_cmf06 TO cmf01,cmf02,cmf06  
        
   CALL i311_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()               
END FUNCTION
 
#單身
FUNCTION i311_b()
DEFINE l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  
       l_n             LIKE type_file.num5,    #檢查重複用 
       l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
       p_cmd           LIKE type_file.chr1,    #處理狀態 
       l_length        LIKE type_file.num5,    #長度
       l_allow_insert  LIKE type_file.num5,    #可新增否 
       l_allow_delete  LIKE type_file.num5     #可刪除否
 
   LET g_action_choice = ""
   LET g_cmfa.cmf01=g_cmf01
   LET g_cmfa.cmf02=g_cmf02
   LET g_cmfa.cmf06=g_cmf06   #FUN-7B0116 add
   IF g_cmfa.cmf01 IS NULL OR g_cmfa.cmf01 = 0 THEN RETURN END IF
   IF g_cmfa.cmf06 IS NULL THEN RETURN END IF 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cmf03,cmf031,cmf04,cmf05 ",  
                      "  FROM cmf_file ", 
                      " WHERE cmf01 =? ",
                      "   AND cmf02 =? ",
                      "   AND cmf06 =? ", 
                      "   AND cmf03 =? ",
                      "   AND cmf031=? ", 
                      "   AND cmf04=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i311_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
                  
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_cmf WITHOUT DEFAULTS FROM s_cmf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL i311_set_visible_b()
         CALL i311_set_entry_b()
         CALL i311_set_no_entry_b()
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b>=l_ac THEN
            LET g_cmf_t.* = g_cmf[l_ac].*  #BACKUP
            LET p_cmd='u'
 
            OPEN i311_bcl USING g_cmfa.cmf01,g_cmfa.cmf02,g_cmfa.cmf06, 
                                g_cmf_t.cmf03,g_cmf_t.cmf031,g_cmf_t.cmf04
            IF STATUS THEN
               CALL cl_err("OPEN i311_bcl:", STATUS, 1)
               CLOSE i311_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i311_bcl INTO g_cmf[l_ac].* 
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_cmf_t.cmf03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_cmf[l_ac].cmf031) THEN LET g_cmf[l_ac].cmf031 = ' ' END IF
         IF cl_null(g_cmf[l_ac].cmf03) THEN LET g_cmf[l_ac].cmf03 = ' ' END IF
         IF cl_null(g_cmf[l_ac].cmf04) THEN LET g_cmf[l_ac].cmf04 = ' ' END IF
         INSERT INTO cmf_file(cmf01,cmf02,cmf06,cmf03,cmf031,cmf04,cmf05,cmforiu,cmforig,cmflegal)   #FUN-A50075 add legal
         VALUES(g_cmfa.cmf01,g_cmfa.cmf02,g_cmfa.cmf06,g_cmf[l_ac].cmf03,
                g_cmf[l_ac].cmf031,g_cmf[l_ac].cmf04,g_cmf[l_ac].cmf05, g_user, g_grup,g_legal)      #No.FUN-980030 10/01/04  insert columns oriu, orig   #FUN-A50075 add legal
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","cmf_file",g_cmfa.cmf01,g_cmfa.cmf02,SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_cmf[l_ac].* TO NULL      #900423
         IF g_cmf06='6' THEN
            LET g_cmf[l_ac].cmf03=' '
         ELSE
            LET g_cmf[l_ac].cmf031 =' '
         END IF
         LET g_cmf[l_ac].cmf05 = 0
         LET g_cmf_t.* = g_cmf[l_ac].*             #新輸入資料
         CALL cl_show_fld_cont()     
 
      AFTER FIELD cmf03     
         IF g_cmf06 != '6' THEN  
            IF g_cmf[l_ac].cmf03 IS NOT NULL THEN
               CALL i311_chk_cmf03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_cmf[l_ac].cmf03 = g_cmf_t.cmf03
                  NEXT FIELD cmf03
               END IF
            END IF
            IF g_cmf[l_ac].cmf03 IS NOT NULL AND 
              (g_cmf[l_ac].cmf03 != g_cmf_t.cmf03 OR g_cmf_t.cmf03 IS NULL) THEN
               SELECT count(*) INTO g_cnt
                 FROM cmf_file
                WHERE cmf01 = g_cmfa.cmf01
                  AND cmf02 = g_cmfa.cmf02
                  AND cmf06 = g_cmfa.cmf06  
                  AND cmf03 = g_cmf[l_ac].cmf03
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_cmf[l_ac].cmf03 = g_cmf_t.cmf03
                  NEXT FIELD cmf03
               END IF
            END IF
         END IF 
      
      AFTER FIELD cmf031 
         IF g_cmf06='6' THEN    #料件來源分類=6.產品分類 
            IF g_cmf[l_ac].cmf031 IS NOT NULL THEN
               SELECT oba01 FROM oba_file 
                WHERE oba01=g_cmf[l_ac].cmf031
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","oba_file",g_cmf[l_ac].cmf031,"","aim-142","","",1)
                  LET g_cmf[l_ac].cmf031 = g_cmf_t.cmf031
                  NEXT FIELD cmf031
               END IF
            END IF
            IF g_cmf[l_ac].cmf031 IS NOT NULL AND 
              (g_cmf[l_ac].cmf031 != g_cmf_t.cmf031 OR g_cmf_t.cmf031 IS NULL) THEN
                SELECT count(*) INTO g_cnt
                  FROM cmf_file
                 WHERE cmf01 = g_cmfa.cmf01
                   AND cmf02 = g_cmfa.cmf02
                   AND cmf06 = g_cmfa.cmf06
                   AND cmf031= g_cmf[l_ac].cmf031
                IF g_cnt > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_cmf[l_ac].cmf031 = g_cmf_t.cmf031
                   NEXT FIELD cmf031
                END IF
            END IF
         END IF
 
      AFTER FIELD cmf04
         IF NOT cl_null(g_cmf[l_ac].cmf04) THEN
           #FUN-AA0059 --------------------------add start------------------
            IF NOT s_chk_item_no(g_cmf[l_ac].cmf04,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD cmf04
            END IF 
           #FUN-AA0059 -------------------------add end--------------------
            SELECT count(*) INTO l_n FROM ima_file
             WHERE ima01 = g_cmf[l_ac].cmf04
               AND imaacti = 'Y'
            IF l_n = 0 THEN
               CALL cl_err('','ams-003',0)
               NEXT FIELD cmf04
            END IF
         ELSE
            NEXT FIELD cmf04
         END IF
 
      AFTER FIELD cmf05
         IF NOT cl_null(g_cmf[l_ac].cmf05) THEN
            IF g_cmf[l_ac].cmf05<0 THEN 
               NEXT FIELD cmf05
             END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_cmfa_t.cmf02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
               DELETE FROM cmf_file WHERE cmf01 = g_cmfa.cmf01
                                      AND cmf02 = g_cmfa.cmf02
                                      AND cmf06 = g_cmfa.cmf06
                                      AND cmf03 = g_cmf_t.cmf03
                                      AND cmf04 = g_cmf_t.cmf04
                                      AND cmf031 = g_cmf_t.cmf031
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","cmf_file",g_cmfa.cmf01,g_cmfa.cmf02,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cmf[l_ac].* = g_cmf_t.*
            CLOSE i311_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cmf[l_ac].cmf03,-263,1)
            LET g_cmf[l_ac].* = g_cmf_t.*
         ELSE
            IF cl_null(g_cmf[l_ac].cmf031) THEN LET g_cmf[l_ac].cmf031 = ' ' END IF
            IF cl_null(g_cmf[l_ac].cmf03) THEN LET g_cmf[l_ac].cmf03 = ' ' END IF
            IF cl_null(g_cmf[l_ac].cmf04) THEN LET g_cmf[l_ac].cmf04 = ' ' END IF
            UPDATE cmf_file SET cmf03=g_cmf[l_ac].cmf03,
                                cmf031=g_cmf[l_ac].cmf031,
                                cmf04=g_cmf[l_ac].cmf04,
                                cmf05=g_cmf[l_ac].cmf05
                          WHERE cmf01 = g_cmfa.cmf01 
                            AND cmf02 = g_cmfa.cmf02
                            AND cmf06 = g_cmfa.cmf06 
                            AND cmf03 = g_cmf_t.cmf03
                            AND cmf031= g_cmf_t.cmf031      
                            AND cmf04 =g_cmf_t.cmf04
            IF SQLCA.sqlcode THEN #No.FUN-660127
               LET g_cmf[l_ac].* = g_cmf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac            #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_cmf[l_ac].* = g_cmf_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_cmf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE i311_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac #FUN-D40030 add
         CLOSE i311_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF g_cmf06='6' THEN   
            IF INFIELD(cmf031) AND l_ac > 1 THEN
               LET g_cmf[l_ac].* = g_cmf[l_ac-1].*
               NEXT FIELD cmf031
            END IF
         ELSE
            IF INFIELD(cmf03) AND l_ac > 1 THEN
               LET g_cmf[l_ac].* = g_cmf[l_ac-1].*
               NEXT FIELD cmf03
            END IF
         END IF
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")         #No.FUN-6A0092
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
      ON ACTION controlp
         CASE 
            WHEN INFIELD(cmf03) #其他分群碼一
                 CALL cl_init_qry_var()
                 CASE g_cmfa.cmf06
                      WHEN '1'
                           LET g_qryparam.form     = "q_imz"
                      WHEN '2'
                           LET g_qryparam.form     = "q_azf"
                           LET g_qryparam.arg1     = "D"
                      WHEN '3'
                           LET g_qryparam.form     = "q_azf"
                           LET g_qryparam.arg1     = "E"
                      WHEN '4'
                           LET g_qryparam.form     = "q_azf"
                           LET g_qryparam.arg1     = "F"
                      WHEN '5'
                           LET g_qryparam.form     = "q_azf"
                           LET g_qryparam.arg1     = "G"
                      WHEN '6'
                           LET g_qryparam.form     = "q_oba"
                 END CASE
                 LET g_qryparam.default1 = g_cmf[l_ac].cmf03
                 CALL cl_create_qry() RETURNING g_cmf[l_ac].cmf03
                 DISPLAY BY NAME g_cmf[l_ac].cmf03
                 NEXT FIELD cmf03
            WHEN INFIELD(cmf031)   #產品分類
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_oba"
                 LET g_qryparam.default1 = g_cmf[l_ac].cmf031
                 CALL cl_create_qry() RETURNING g_cmf[l_ac].cmf031
                 DISPLAY BY NAME g_cmf[l_ac].cmf031
                 NEXT FIELD cmf031
            WHEN INFIELD(cmf04)  
#FUN-AA0059---------mod------------str-----------------            
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_ima"
#                 LET g_qryparam.default1 = g_cmf[l_ac].cmf04
#                 CALL cl_create_qry() RETURNING g_cmf[l_ac].cmf04
                 CALL q_sel_ima(FALSE, "q_ima","",g_cmf[l_ac].cmf04,"","","","","",'' ) 
                   RETURNING  g_cmf[l_ac].cmf04

#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_cmf[l_ac].cmf04
                 NEXT FIELD cmf04
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
      
   CLOSE i311_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i311_set_entry_b()
 
      CALL cl_set_comp_entry("cmf031,cmf03,cmf04",TRUE)
 
END FUNCTION
 
FUNCTION i311_set_no_entry_b()
 
   IF g_cmf06 = '6' THEN 
      CALL cl_set_comp_entry("cmf03,cmf04",FALSE)
   END IF
   IF g_cmf06 MATCHES '[12345]' THEN
      CALL cl_set_comp_entry("cmf031,cmf04",FALSE)
   END IF
   IF g_cmf06 = '7' THEN
      CALL cl_set_comp_entry("cmf03,cmf031",FALSE)
   END IF
   
END FUNCTION
 
FUNCTION i311_set_visible_b()
   #No.FUN-890029---Begin
   #當單頭的cmf06=1/2/3/4/5,顯示cmf03,隱藏cmf031,反之則顯示cmf031,隱藏cmf03
   #IF g_cmf06 = '1' THEN 
   #   CALL cl_set_comp_visible("ome03",TRUE)
   #   CALL cl_set_comp_visible("ome031",FALSE)
   #ELSE
   #   CALL cl_set_comp_visible("ome031",TRUE)
   #   CALL cl_set_comp_visible("ome03",FALSE)
   #END IF
   IF g_cmf06 = '6' THEN 
      CALL cl_set_comp_visible("ome031",TRUE)
      CALL cl_set_comp_visible("ome03",FALSE)
   ELSE
      CALL cl_set_comp_visible("ome03",TRUE)
      CALL cl_set_comp_visible("ome031",FALSE)
   END IF
   #No.FUN-890029---End
END FUNCTION
 
   
FUNCTION i311_b_askkey()
DEFINE l_wc            LIKE type_file.chr1000     
 
   CALL cl_opmsg('q')
   CLEAR cmf03,cmf031,cmf04,cmf05  
   #螢幕上取條件
   CONSTRUCT l_wc ON cmf03,cmf031,cmf04,cmf05    
        FROM s_cmf[1].cmf03,s_cmf[1].cmf031,s_cmf[1].cmf04,s_cmf[1].cmf05   
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
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
   IF INT_FLAG THEN RETURN END IF
   CALL i311_b_fill(l_wc)
   CALL cl_opmsg('b')
END FUNCTION
 
FUNCTION i311_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc          LIKE type_file.chr1000        
 
   LET g_sql = "SELECT cmf03,cmf031,cmf04,cmf05",   #FUN-7B0116 add cmf031
               "  FROM cmf_file",
               " WHERE cmf01 = '",g_cmf01,"'",
               "   AND cmf02 = '",g_cmf02,"'",
               "   AND cmf06 = '",g_cmf06,"'",   #FUN-7B0116 add
               "   AND ",p_wc CLIPPED ,
               " ORDER BY 1"
   PREPARE i311_prepare2 FROM g_sql      #預備一下
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE i311_curs1 CURSOR FOR i311_prepare2
   CALL g_cmf.clear()
   LET g_cnt = 1
   FOREACH i311_curs1 INTO g_cmf[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('B_FILL:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_cmf.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i311_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cmf TO s_cmf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i311_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY 
 
      ON ACTION previous
         CALL i311_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY 
 
      ON ACTION jump 
         CALL i311_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i311_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   
 
      ON ACTION last 
         CALL i311_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY 
                              
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
         
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
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
 
      ON ACTION related_document     
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      ON ACTION controls        
         CALL cl_set_head_visible("","AUTO")           
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i311_r()
   IF g_cmf01 IS NULL THEN
      CALL cl_err("",-400,0)   
      RETURN 
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "cmf01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "cmf02"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "cmf06"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_cmf01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_cmf02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_cmf06       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM cmf_file
       WHERE cmf01=g_cmf01 AND cmf02=g_cmf02 AND cmf06=g_cmf06  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","cmf_file",g_cmf01,g_cmf02,SQLCA.sqlcode,"","BODY DELETE",1)  
      ELSE
         CLEAR FORM
         CALL g_cmf.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE i311_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i311_precount_x2                 #No.TQC-720019
         OPEN i311_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i311_b_cs
            CLOSE i311_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH i311_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i311_b_cs
            CLOSE i311_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i311_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i311_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i311_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION i311_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
    sr              RECORD
        cmf01       LIKE cmf_file.cmf01,   #年度
        cmf02       LIKE cmf_file.cmf02,   #月份
        cmf03       LIKE cmf_file.cmf03,   #分類碼
        cmf04       LIKE cmf_file.cmf04,   
        cmf05       LIKE cmf_file.cmf05    
                    END RECORD,
    l_za05          LIKE za_file.za05,
    l_name          LIKE type_file.chr20          #No.FUN-680122    VARCHAR(20)           #External(Disk) file name
 
    IF g_wc IS NULL THEN 
       IF NOT cl_null(g_cmf01) THEN
          LET g_wc=" cmf01=",g_cmf01," AND cmf02= ",g_cmf02,
                                     " AND cmf06='",g_cmf06,"'"   
       ELSE
          CALL cl_err('','9057',0) RETURN 
       END IF
    END IF
    CALL cl_wait()
#    CALL cl_outnam('axci311') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT cmf01,cmf02,cmf03,cmf04,cmf05 ",
          " FROM cmf_file ",
          " WHERE ",g_wc CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'cmf01,cmf02,cmf06,cmf03,cmf031,cmf04,cmf05')   
            RETURNING g_str                                                     
    END IF
    LET l_sql = "SELECT cmf01,cmf02,cmf03,cmf031,cmf04,cmf05,cmf06 ", 
                "  FROM cmf_file ",                                                                                                        
                " WHERE ",g_wc CLIPPED  
    CALL cl_prt_cs1('axci311','axci311',l_sql,g_str)
END FUNCTION
 
FUNCTION i311_chk_cmf03()
   DEFINE l_chr      LIKE azf_file.azf02,
          l_acti     LIKE imz_file.imzacti
 
   LET g_errno = ''
   IF g_cmf[l_ac].cmf03 = "ALL" THEN
      RETURN
   END IF
   CASE g_cmfa.cmf06
        WHEN '2'   LET l_chr = "D"
        WHEN '3'   LET l_chr = "E"
        WHEN '4'   LET l_chr = "F"
        WHEN '5'   LET l_chr = "G"
   END CASE
   CASE
        WHEN g_cmfa.cmf06 = '1'
           SELECT imzacti INTO l_acti FROM imz_file
            WHERE imz01 = g_cmf[l_ac].cmf03
        WHEN g_cmfa.cmf06 MATCHES '[2345]'
           SELECT azfacti INTO l_acti FROM azf_file
            WHERE azf01 = g_cmf[l_ac].cmf03
              AND azf02 = l_chr
        WHEN g_cmfa.cmf06 = '6'
           SELECT oba02 FROM oba_file
            WHERE oba01 = g_cmf[l_ac].cmf03
   END CASE
   CASE
      WHEN SQLCA.SQLCODE = 100
           LET g_errno = SQLCA.SQLCODE
      WHEN g_cmfa.cmf06 MATCHES '[12345]' AND l_acti <> 'Y'
           LET g_errno = '9028'
      OTHERWISE
           LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE
END FUNCTION
 
#================================
# 複製
#================================
FUNCTION i311_copy()
DEFINE
   l_cmf01,l_oldno1    LIKE cmf_file.cmf01,
   l_cmf02,l_oldno2    LIKE cmf_file.cmf02,
   l_cnt               INTEGER,
   l_buf               VARCHAR(100)
 
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   IF s_shut(0) THEN RETURN END IF
   IF g_cmf01 IS NULL OR g_cmf02 IS NULL OR cl_null(g_cmf06) THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   LET g_before_input_done = FALSE
   CALL i311_set_entry('a')
   LET g_before_input_done = TRUE
 
   INPUT l_cmf01,l_cmf02 FROM cmf01,cmf02
      AFTER FIELD cmf01
         IF l_cmf01 IS NULL THEN
            NEXT FIELD cmf01
         END IF
 
      AFTER FIELD cmf02
         IF l_cmf02 IS NOT NULL THEN
            IF l_cmf02 < 1 OR l_cmf02 > 12 THEN
               CALL cl_err(l_cmf02,'aom-580',0)
               NEXT FIELD cmf02
            END IF
            LET l_cnt = 0
            SELECT count(*) INTO l_cnt FROM cmf_file
             WHERE cmf01 = l_cmf01
               AND cmf02 = l_cmf02
               AND cmf06 = g_cmf06
            IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
            IF l_cnt > 0 THEN
               CALL cl_err(l_cmf01,-239,0)
               NEXT FIELD cmf01
            END IF
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
   IF INT_FLAG THEN
      DISPLAY g_cmf01,g_cmf02 TO cmf01,cmf02
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET l_buf = l_cmf01 USING '<<<<', '/', l_cmf02 USING '<<'
   BEGIN WORK
   DROP TABLE x
   SELECT * FROM cmf_file
    WHERE cmf01 = g_cmf01
      AND cmf02 = g_cmf02
      AND cmf06 = g_cmf06
     INTO TEMP x
   UPDATE x SET cmf01    = l_cmf01,
                cmf02    = l_cmf02
   INSERT INTO cmf_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","cmf_file",l_buf,'',SQLCA.sqlcode,"","cmf:",1)
      ROLLBACK WORK
      RETURN
   END IF
   COMMIT WORK
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_buf,') O.K'
 
   LET l_oldno1 = g_cmf01
   LET l_oldno2 = g_cmf02
   LET g_cmf01  = l_cmf01
   LET g_cmf02  = l_cmf02
   CALL i311_b()
   #LET g_cmf01  = l_oldno1 #FUN-C80046
   #LET g_cmf02  = l_oldno2 #FUN-C80046
   #CALL i311_show()        #FUN-C80046
END FUNCTION
#FUN-930100
