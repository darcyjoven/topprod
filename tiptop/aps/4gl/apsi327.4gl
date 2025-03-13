# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi327.4gl
# Descriptions...: 平行加工維護作業
# Input parameter:
# Date & Author..: #FUN-870092 2008/08/13/ By Mandy 
# Modify.........: No.TQC-890064 2008/09/30 By Mandy 連結鎖定使用設備(apsi315)時,只會連結到第一筆
# Modify.........: No.TQC-8A0013 2008/10/07 By Mandy 當有做平行加工時,鎖定使用設備的資料需自動產生(未完成量以總量平均分配,尾數放於最後一項,要符合總數)
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_sfb           RECORD LIKE sfb_file.*,   #FUN-870092
    g_vlj_a         RECORD LIKE vlj_file.*,   #頭
    g_vlj_a_t       RECORD LIKE vlj_file.*,
    g_vlj01_t       LIKE vlj_file.vlj01,
    g_vlj02_t       LIKE vlj_file.vlj02,
    g_vlj03_t       LIKE vlj_file.vlj03,
    g_vlj_b         DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        vlj05         LIKE vlj_file.vlj05,   
        vlj06         LIKE vlj_file.vlj06,   
        vlj13         LIKE vlj_file.vlj13,   
        vlj14         LIKE vlj_file.vlj14,   
        vlj15         LIKE vlj_file.vlj15,   
        vlj16         LIKE vlj_file.vlj16,   
        vlj49         LIKE vlj_file.vlj49,   
        vlj50         LIKE vlj_file.vlj50,   
        vlj51         LIKE vlj_file.vlj51,
        vlj311        LIKE vlj_file.vlj311,
        vlj312        LIKE vlj_file.vlj312,
        vlj313        LIKE vlj_file.vlj313,
        vlj314        LIKE vlj_file.vlj314,
        vlj315        LIKE vlj_file.vlj315,
        vlj316        LIKE vlj_file.vlj316,
        desc          LIKE eca_file.eca02
                    END RECORD,
    g_vlj_b_t       RECORD                 #程式變數 (舊值)
        vlj05         LIKE vlj_file.vlj05,   
        vlj06         LIKE vlj_file.vlj06,   
        vlj13         LIKE vlj_file.vlj13,   
        vlj14         LIKE vlj_file.vlj14,   
        vlj15         LIKE vlj_file.vlj15,   
        vlj16         LIKE vlj_file.vlj16,   
        vlj49         LIKE vlj_file.vlj49,   
        vlj50         LIKE vlj_file.vlj50,   
        vlj51         LIKE vlj_file.vlj51,   
        vlj311        LIKE vlj_file.vlj311,
        vlj312        LIKE vlj_file.vlj312,
        vlj313        LIKE vlj_file.vlj313,
        vlj314        LIKE vlj_file.vlj314,
        vlj315        LIKE vlj_file.vlj315,
        vlj316        LIKE vlj_file.vlj316,
        desc          LIKE eca_file.eca02
                    END RECORD,
     g_wc,g_sql          STRING,
     g_wc2               STRING,
    g_argv1         LIKE vlj_file.vlj01,   #工單編號
    g_argv2         LIKE vlj_file.vlj02,   #資源型態
    g_argv3         LIKE vlj_file.vlj03,   #製程序號
    g_rec_b         LIKE type_file.num5,   #單身筆數        
    p_row,p_col     LIKE type_file.num5,   
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  
    g_cmd           LIKE type_file.chr1000,
    g_ecm04         LIKE ecm_file.ecm04,
    g_ecm45         LIKE ecm_file.ecm45
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done  LIKE type_file.num5          
 
DEFINE   g_cnt          LIKE type_file.num10        
DEFINE   g_i            LIKE type_file.num5         
DEFINE   g_msg          LIKE type_file.chr1000      
DEFINE   g_row_count    LIKE type_file.num10        
DEFINE   g_curs_index   LIKE type_file.num10        
DEFINE   g_jump         LIKE type_file.num10        
DEFINE   mi_no_ask      LIKE type_file.num5         
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    
 
   LET g_argv1 =ARG_VAL(1)              #工單編號
   LET g_argv2 =ARG_VAL(2)              #資源型態
   LET g_argv3 =ARG_VAL(3)              #製程序號
   LET g_vlj01_t = NULL
   LET g_vlj_a.vlj01 =g_argv1              #工單編號
   LET g_vlj_a.vlj02 =g_argv2              #資源型態
   LET g_vlj_a.vlj03 =g_argv3              #製程序號
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW i327_w AT p_row,p_col
        WITH FORM "aps/42f/apsi327"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("vlj13,vlj14,vlj15,vlj16,vlj49",FALSE)
 
   IF NOT cl_null(g_argv1) AND
      NOT cl_null(g_argv2) AND
      NOT cl_null(g_argv3) THEN
        SELECT * INTO g_sfb.*
          FROM sfb_file
         WHERE sfb01 = g_argv1
        CALL i327_q()
        CALL i327_menu()
    ELSE
        CALL i327_menu()
    END IF
 
    CLOSE WINDOW i327_w                 #結束畫面
 
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
          RETURNING g_time  
 
END MAIN
 
#QBE 查詢資料
FUNCTION i327_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
   CLEAR FORM                             #清除畫面
 
   CALL g_vlj_b.clear()
 
 IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) THEN
     CALL cl_set_head_visible("","YES")    
 
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          vlj01,vlj02,vlj03
 
     BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
     ON ACTION controlp
           CASE
              WHEN INFIELD(vlj01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_sfb"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO vlj01
                   NEXT FIELD vlj01
              OTHERWISE EXIT CASE
           END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION qbe_select
	 CALL cl_qbe_list() RETURNING lc_qbe_sn
	 CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
 ELSE 
     DISPLAY BY NAME g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03
      LET g_wc = "     vlj01 ='",g_vlj_a.vlj01,"'",
                 " AND vlj02 =",g_vlj_a.vlj02,
                 " AND vlj03 ='",g_vlj_a.vlj03,"' "
 END IF
 IF INT_FLAG THEN RETURN END IF
 #資料權限的檢查
 #Begin:FUN-980030
 # IF g_priv2='4' THEN                           #只能使用自己的資料
 #     LET g_wc = g_wc clipped," AND vljuser = '",g_user,"'"
 # END IF
 # IF g_priv3='4' THEN                           #只能使用相同群的資料
 #     LET g_wc = g_wc clipped," AND vljgrup MATCHES '",g_grup CLIPPED,"*'"
 # END IF
 
 # IF g_priv3 MATCHES "[5678]" THEN    #群組權限
 #     LET g_wc = g_wc clipped," AND vljgrup IN ",cl_chk_tgrup_list()
 # END IF
 LET g_wc = g_wc CLIPPED,cl_get_extra_cond('vljuser', 'vljgrup')
 #End:FUN-980030
 
 IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) THEN
     CONSTRUCT g_wc2 ON vlj05 ,vlj06 ,vlj13 ,vlj14 ,vlj15 ,vlj16 ,vlj49,vlj50,vlj51,                 # 螢幕上取單身條件 
                        vlj311,vlj312,vlj313,vlj314,vlj315,vlj316
               FROM s_vlj[1].vlj05 ,s_vlj[1].vlj06 ,s_vlj[1].vlj13 ,s_vlj[1].vlj14,s_vlj[1].vlj15,
                    s_vlj[1].vlj16 ,s_vlj[1].vlj49 ,s_vlj[1].vlj50 ,s_vlj[1].vlj51,
                    s_vlj[1].vlj311,s_vlj[1].vlj312,s_vlj[1].vlj313,s_vlj[1].vlj314,s_vlj[1].vlj315,s_vlj[1].vlj316
     
        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
 
        ON ACTION controlp
         CASE
            WHEN INFIELD(vlj06)                 #生產站別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 IF g_vlj_a.vlj02 = 0 THEN
                     LET g_qryparam.form     = "q_eca1"
                 ELSE
                     LET g_qryparam.form     = "q_eci"
                 END IF
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vlj06
                 NEXT FIELD vlj06
         END CASE
     
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
     
        ON ACTION about         
           CALL cl_about()      
     
        ON ACTION help          
           CALL cl_show_help()  
     
        ON ACTION controlg      
           CALL cl_cmdask()     
     
        ON ACTION qbe_save
           CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
 ELSE 
     LET g_wc2 = " 1=1"
 END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
          LET g_sql = "SELECT UNIQUE vlj01,vlj02,vlj03 FROM vlj_file ",
                      " WHERE ", g_wc CLIPPED,
                      " ORDER BY vlj01,vlj02,vlj03"
    ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE vlj01,vlj02,vlj03 FROM vlj_file ",
                      "  FROM vlj_file ",
                      " WHERE ",g_wc  CLIPPED, 
                      "   AND ",g_wc2 CLIPPED,
                      " ORDER BY vlj01,vlj02,vlj03"
    END IF
 
    PREPARE i327_prepare FROM g_sql
    DECLARE i327_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i327_prepare
 
    LET g_forupd_sql = "SELECT * FROM vlj_file ",
                       "  WHERE vlj01 = ? ",
                       "   AND vlj02 = ? ",
                       "   AND vlj03 = ? ",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i327_cl CURSOR FROM g_forupd_sql
 
   LET g_sql= "SELECT vlj01,vlj02,vlj03 FROM vlj_file ",
              " WHERE ",g_wc  CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " GROUP BY vlj01,vlj02,vlj03 ",
              " INTO TEMP x "
   DROP TABLE x
   PREPARE i327_precount_x FROM g_sql
   EXECUTE i327_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i327_pp FROM g_sql
   DECLARE i327_count CURSOR FOR i327_pp
 
END FUNCTION
 
FUNCTION i327_menu()
 
   WHILE TRUE
      CALL i327_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i327_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i327_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vlj_b),'','')
            END IF
         #apsi315
         WHEN "aps_lock_used_machine"
            IF cl_chk_act_auth() THEN
                CALL i327_aps_vne()
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_vlj_a.vlj01 IS NOT NULL THEN
                LET g_doc.column1 = "vlj01"
                LET g_doc.column2 = "vlj02"
                LET g_doc.column3 = "vlj03"
                LET g_doc.value1 = g_vlj_a.vlj01
                LET g_doc.value2 = g_vlj_a.vlj02
                LET g_doc.value3 = g_vlj_a.vlj03
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i327_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_vlj_b.clear()
    CALL i327_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i327_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vlj_a.* TO NULL
    ELSE
        CALL i327_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i327_count
        FETCH i327_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i327_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680073 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i327_cs INTO g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03
        WHEN 'P' FETCH PREVIOUS i327_cs INTO g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03
        WHEN 'F' FETCH FIRST    i327_cs INTO g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03
        WHEN 'L' FETCH LAST     i327_cs INTO g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         
                      CALL cl_about()      
 
                   ON ACTION help          
                      CALL cl_show_help()  
 
                   ON ACTION controlg      
                      CALL cl_cmdask()     
 
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i327_cs INTO g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vlj_a.vlj01,SQLCA.sqlcode,0)
        INITIALIZE g_vlj_a.* TO NULL  
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vlj_file",g_vlj_a.vlj01,g_vlj_a.vlj02,SQLCA.sqlcode,"","",1) 
        INITIALIZE g_vlj_a.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_vlj_a.vljuser      
        LET g_data_group = g_vlj_a.vljgrup     
        CALL i327_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i327_show()
 
 
    LET g_vlj_a_t.* = g_vlj_a.*            #保存單頭舊值
    DISPLAY BY NAME                        #顯示單頭值
        g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03
 
    LET g_ecm04 = ''
    LET g_ecm45 = ''
    SELECT ecm04,ecm45 
      INTO g_ecm04,g_ecm45
      FROM ecm_file
     WHERE ecm01 = g_vlj_a.vlj01
       AND ecm03 = g_vlj_a.vlj03
    DISPLAY g_ecm04,g_ecm45 TO ecm04,ecm45
 
    CALL i327_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   
END FUNCTION
#單身
FUNCTION i327_b()
DEFINE
    l_cnt           LIKE type_file.num5,          
    l_sum_vlj13     LIKE vlj_file.vlj13,
    l_min_vlj50     LIKE vlj_file.vlj50,    #最小的開工日
    l_max_vlj51     LIKE vlj_file.vlj51,    #最大的完成日
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT       
    l_n             LIKE type_file.num5,    #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否       
    p_cmd           LIKE type_file.chr1,    #處理狀態        
    l_allow_insert  LIKE type_file.num5,    #可新增否       
    l_allow_delete  LIKE type_file.num5     #可刪除否      
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_vlj_a.vlj01) OR cl_null(g_vlj_a.vlj02) OR cl_null(g_vlj_a.vlj03) THEN
        RETURN
    END IF
    SELECT * INTO g_sfb.*
      FROM sfb_file
     WHERE sfb01 = g_vlj_a.vlj01
    IF g_sfb.sfb04 = '8' THEN CALL cl_err('','aap-730',1) RETURN END IF
    IF g_sfb.sfb87 = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF
    IF g_sfb.sfb87 = 'X' THEN CALL cl_err('','9024',1) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT vlj05,vlj06,vlj13,vlj14,vlj15,vlj16,vlj49,vlj50,vlj51 FROM vlj_file ",
                       "  WHERE vlj01 = ? ",
                       "   AND vlj02 = ? ",
                       "   AND vlj03 = ? ",
                       "   AND vlj05 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i327_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_vlj_b WITHOUT DEFAULTS FROM s_vlj.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN i327_cl USING g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03
            IF STATUS THEN
               CALL cl_err("OPEN i327_cl_b1", STATUS, 1)
               CLOSE i327_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i327_cl INTO g_vlj_a.*   # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err('Fetch i327_cl_b2',SQLCA.sqlcode,1)
               CLOSE i327_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_vlj_b_t.* = g_vlj_b[l_ac].*  #BACKUP
 
               OPEN i327_bcl USING g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03,
                                   g_vlj_b_t.vlj05
               IF STATUS THEN
                  CALL cl_err("OPEN i327_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i327_bcl INTO g_vlj_b[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('Fetch i327_bcl',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_vlj_b_t.*=g_vlj_b[l_ac].*
                  END IF
               END IF
               CALL cl_show_fld_cont()     
             END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vlj_b[l_ac].* TO NULL   
            SELECT SUM(vlj13) INTO l_sum_vlj13
              FROM vlj_file
             WHERE vlj01 = g_vlj_a.vlj01
               AND vlj02 = g_vlj_a.vlj02
               AND vlj03 = g_vlj_a.vlj03
            IF cl_null(l_sum_vlj13) THEN 
                LET l_sum_vlj13 = 0 
            END IF
            LET g_vlj_b[l_ac].vlj13 = g_sfb.sfb08 - l_sum_vlj13
            IF g_vlj_b[l_ac].vlj13 < 0 THEN 
                LET g_vlj_b[l_ac].vlj13 = 0  
            END IF
            LET g_vlj_b[l_ac].vlj14 = 0
            LET g_vlj_b[l_ac].vlj15 = 0
            LET g_vlj_b[l_ac].vlj16 = 0
            LET g_vlj_b[l_ac].vlj49 = 0
            LET g_vlj_b[l_ac].vlj50 = g_today
            LET g_vlj_b[l_ac].vlj51 = g_today
            LET g_vlj_b_t.* = g_vlj_b[l_ac].*                  #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD vlj05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO vlj_file(vlj01,vlj02,vlj03,vlj05,vlj06,vlj13,vlj14,vlj15,vlj16,vlj49,vlj50,vlj51,
                                 vlj301,vlj302,vlj303,vlj311,vlj312,vlj313,vlj314,vlj315,vlj316,vljoriu,vljorig)
                           VALUES(g_vlj_a.vlj01,g_vlj_a.vlj02,g_vlj_a.vlj03,
                                  g_vlj_b[l_ac].vlj05,g_vlj_b[l_ac].vlj06,
                                  g_vlj_b[l_ac].vlj13,g_vlj_b[l_ac].vlj14,
                                  g_vlj_b[l_ac].vlj15,g_vlj_b[l_ac].vlj16,
                                  g_vlj_b[l_ac].vlj49,g_vlj_b[l_ac].vlj50,
                                  g_vlj_b[l_ac].vlj51,
                                  0,0,0,0,0,0,0,0,0, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","vlj_file",g_vlj_a.vlj01,g_vlj_a.vlj02,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
            #TQC-8A0013---mod---str---
            CALL i327_aps_vne() 
           #CALL i327_upd_vne06()
            #TQC-8A0013---mod---end---
            
 
        BEFORE FIELD vlj05                        # dgeeault 序號
            IF g_vlj_b[l_ac].vlj05 = 0 THEN
                NEXT FIELD desc
            END IF
            IF cl_null(g_vlj_b[l_ac].vlj05) THEN
               SELECT MAX(vlj05)+1 INTO g_vlj_b[l_ac].vlj05 FROM vlj_file
                WHERE vlj01 = g_vlj_a.vlj01
                  AND vlj02 = g_vlj_a.vlj02
                  AND vlj03 = g_vlj_a.vlj03
               IF cl_null(g_vlj_b[l_ac].vlj05) THEN
                   LET g_vlj_b[l_ac].vlj05 = 1
               END IF
            END IF
 
        AFTER FIELD vlj05                        #check 序號是否重複
            IF NOT cl_null(g_vlj_b[l_ac].vlj05) THEN
               IF g_vlj_b[l_ac].vlj05 != g_vlj_b_t.vlj05 OR cl_null(g_vlj_b_t.vlj05) THEN
                   SELECT count(*) INTO l_n FROM vlj_file
                    WHERE vlj01 = g_vlj_a.vlj01
                      AND vlj02 = g_vlj_a.vlj02
                      AND vlj03 = g_vlj_a.vlj03
                      AND vlj05 = g_vlj_b[l_ac].vlj05
                   IF l_n > 0 THEN
                       CALL cl_err(g_vlj_b[l_ac].vlj05,-239,0)
                       LET g_vlj_b[l_ac].vlj05 = g_vlj_b_t.vlj05
                       NEXT FIELD vlj05
                   END IF
               END IF
            END IF
 
        AFTER FIELD vlj06                  
            IF NOT cl_null(g_vlj_b[l_ac].vlj06) THEN
               IF g_vlj_a.vlj02 = 0 THEN 
                   #工作站
                   CALL i327_vlj06_0(l_ac)
               ELSE
                   #機器編號
                   CALL i327_vlj06_1(l_ac)
               END IF
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('vlj06:',g_errno,1)
                   LET g_vlj_b[l_ac].vlj06 = g_vlj_b_t.vlj06
                   DISPLAY BY NAME g_vlj_b[l_ac].vlj06
                   NEXT FIELD vlj06
               END IF
               IF g_vlj_b[l_ac].vlj06 != g_vlj_b_t.vlj06 OR cl_null(g_vlj_b_t.vlj06) THEN
                   SELECT count(*) INTO l_n FROM vlj_file
                    WHERE vlj01 = g_vlj_a.vlj01
                      AND vlj02 = g_vlj_a.vlj02
                      AND vlj03 = g_vlj_a.vlj03
                      AND vlj06 = g_vlj_b[l_ac].vlj06
                   IF l_n > 0 THEN
                       CALL cl_err(g_vlj_b[l_ac].vlj06,-239,1)
                       LET g_vlj_b[l_ac].vlj06 = g_vlj_b_t.vlj06
                       NEXT FIELD vlj06
                   END IF
                   #==>項次0時,更新ecm05 or ecm06
                   IF g_vlj_b[l_ac].vlj05 = 0 THEN
                       IF g_sma.sma917 = 0 THEN
                           #工作站
                           UPDATE ecm_file
                              SET ecm06 = g_vlj_b[l_ac].vlj06
                            WHERE ecm01 = g_vlj_a.vlj01 
                              AND ecm03 = g_vlj_a.vlj03 
                           IF SQLCA.sqlcode THEN
                               CALL cl_err3("update","ecm_file",g_vlj_a.vlj01,g_vlj_a.vlj03,SQLCA.sqlcode,"","",1)
                           END IF
                       ELSE
                           #機器編號
                           UPDATE ecm_file
                              SET ecm05 = g_vlj_b[l_ac].vlj06
                            WHERE ecm01 = g_vlj_a.vlj01 
                              AND ecm03 = g_vlj_a.vlj03 
                           IF SQLCA.sqlcode THEN
                               CALL cl_err3("update","ecm_file",g_vlj_a.vlj01,g_vlj_a.vlj03,SQLCA.sqlcode,"","",1)
                           END IF
                       END IF
                   END IF
 
                   #==>刪除舊的vne_file資料
                   SELECT count(*) INTO l_n FROM vne_file
                    WHERE vne01 = g_vlj_a.vlj01
                      AND vne02 = g_vlj_a.vlj01
                      AND vne03 = g_vlj_a.vlj03
                      AND vne05 = g_vlj_b_t.vlj06
                   IF l_n > 0 THEN
                       DELETE FROM vne_file
                        WHERE vne01 = g_vlj_a.vlj01
                          AND vne02 = g_vlj_a.vlj01
                          AND vne03 = g_vlj_a.vlj03
                          AND vne05 = g_vlj_b_t.vlj06
                       IF SQLCA.sqlcode THEN
                           CALL cl_err3("delete","vne_file",g_vlj_a.vlj01,g_vlj_a.vlj03,SQLCA.sqlcode,"","",1)
                       END IF
                   END IF
               END IF
            END IF
 
        AFTER FIELD vlj13                                                                                                           
            IF NOT cl_null(g_vlj_b[l_ac].vlj13) THEN
                IF g_vlj_b[l_ac].vlj13<0 THEN                                                                                               
                    CALL cl_err('','aec-992',1) #此欄位不可為負數
                    NEXT FIELD vlj13                                                                                                     
                END IF
            END IF
        AFTER FIELD vlj14
            IF g_vlj_b[l_ac].vlj14<0 THEN                                                                                               
               CALL cl_err('','aec-992',1) #此欄位不可為負數
               NEXT FIELD vlj14                                                                                                    
            END IF
        AFTER FIELD vlj15                                                                                                       
            IF g_vlj_b[l_ac].vlj15<0 THEN                                                                                               
               CALL cl_err('','aec-992',1) #此欄位不可為負數
               NEXT FIELD vlj15                                                                                                     
            END IF
        AFTER FIELD vlj16                                                                                                           
            IF g_vlj_b[l_ac].vlj16<0 THEN                                                                                               
               CALL cl_err('','aec-992',1) #此欄位不可為負數
               NEXT FIELD vlj16                                                                                                     
            END IF
        AFTER FIELD vlj49                                                                                                           
            IF g_vlj_b[l_ac].vlj49<0 THEN                                                                                               
               CALL cl_err('','aec-992',1) #此欄位不可為負數
               NEXT FIELD vlj49                                                                                                     
            END IF
 
        AFTER FIELD vlj51
            IF g_vlj_b[l_ac].vlj51<g_vlj_b[l_ac].vlj50 THEN
                CALL cl_err('','aec-993',1) #完工日期不可小於開工日期
                LET g_vlj_b[l_ac].vlj51 = g_vlj_b_t.vlj51
                DISPLAY BY NAME g_vlj_b[l_ac].vlj51
                NEXT FIELD vlj51
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_vlj_b_t.vlj05) THEN
                #==>不可將項次為0的資料刪除
                IF g_vlj_b[l_ac].vlj05 = 0 THEN
                   CANCEL DELETE
                END IF
 
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM vlj_file
                 WHERE vlj01 = g_vlj_a.vlj01 
                   AND vlj02 = g_vlj_a.vlj02
                   AND vlj03 = g_vlj_a.vlj03 
                   AND vlj05 = g_vlj_b_t.vlj05
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","vlj_file",g_vlj_a.vlj01,g_vlj_a.vlj02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                DELETE FROM vne_file
                  WHERE vne01 = g_vlj_a.vlj01
                    AND vne02 = g_vlj_a.vlj01
                    AND vne03 = g_vlj_a.vlj03
                    AND vne05 = g_vlj_b_t.vlj06
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","vne_file",g_vlj_a.vlj01,g_vlj_b_t.vlj06,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
             END IF
             #TQC-8A0013---mod---str---
            #CALL i327_upd_vne06()
             CALL s_upd_vne06(g_vlj_a.vlj01,g_vlj_a.vlj01,g_vlj_a.vlj03,g_ecm04,g_sfb.sfb08)
             #TQC-8A0013---mod---end---
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vlj_b[l_ac].* = g_vlj_b_t.*
               CLOSE i327_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vlj_b[l_ac].vlj05,-263,1)
               LET g_vlj_b[l_ac].* = g_vlj_b_t.*
            ELSE
               UPDATE vlj_file 
                  SET vlj05=g_vlj_b[l_ac].vlj05,
                      vlj06=g_vlj_b[l_ac].vlj06,
                      vlj13=g_vlj_b[l_ac].vlj13,
                      vlj14=g_vlj_b[l_ac].vlj14,
                      vlj15=g_vlj_b[l_ac].vlj15,
                      vlj16=g_vlj_b[l_ac].vlj16,
                      vlj49=g_vlj_b[l_ac].vlj49,
                      vlj50=g_vlj_b[l_ac].vlj50,
                      vlj51=g_vlj_b[l_ac].vlj51
                WHERE vlj01=g_vlj_a.vlj01 
                  AND vlj02=g_vlj_a.vlj02 
                  AND vlj03=g_vlj_a.vlj03 
                  AND vlj05=g_vlj_b_t.vlj05
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","vlj_file",g_vlj_a.vlj01,g_vlj_b_t.vlj05,SQLCA.sqlcode,"","",1)
                   LET g_vlj_b[l_ac].* = g_vlj_b_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_vlj_b[l_ac].* = g_vlj_b_t.*
               END IF
               CLOSE i327_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i327_bcl
            COMMIT WORK
 
            #==>更新ecm51預計完工日
            SELECT MIN(vlj50),MAX(vlj51) INTO l_min_vlj50,l_max_vlj51
              FROM vlj_file
             WHERE vlj01 = g_vlj_a.vlj01 
               AND vlj02 = g_vlj_a.vlj02
               AND vlj03 = g_vlj_a.vlj03 
            UPDATE ecm_file
               SET ecm50 = l_min_vlj50,
                   ecm51 = l_max_vlj51
             WHERE ecm01 = g_vlj_a.vlj01 
               AND ecm03 = g_vlj_a.vlj03 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("update","ecm_file",g_vlj_a.vlj01,g_vlj_a.vlj03,SQLCA.sqlcode,"","",1)
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(vlj06)
                   IF g_vlj_a.vlj02 = 0 THEN 
                       #工作站
                       CALL q_eca(FALSE,TRUE,g_vlj_b[l_ac].vlj06) RETURNING g_vlj_b[l_ac].vlj06
                       DISPLAY BY NAME g_vlj_b[l_ac].vlj06     
                       NEXT FIELD vlj06
                   ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_eci"
                       LET g_qryparam.default1 = g_vlj_b[l_ac].vlj06
                       CALL cl_create_qry() RETURNING g_vlj_b[l_ac].vlj06
                       DISPLAY BY NAME g_vlj_b[l_ac].vlj06     
                       NEXT FIELD vlj06
                   END IF
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vlj05) AND l_ac > 1 THEN
                LET g_vlj_b[l_ac].* = g_vlj_b[l_ac-1].*
                LET g_vlj_b[l_ac].vlj05 = NULL
                LET g_vlj_b[l_ac].vlj06 = NULL
                DISPLAY g_vlj_b[l_ac].* TO s_vlj[l_ac].*
                NEXT FIELD vlj05
            END IF
 
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      #apsi315
      ON ACTION aps_lock_used_machine
         CALL i327_aps_vne()
 
    END INPUT
 
    CLOSE i327_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i327_b_fill(p_wc2)              #BODY FILL UP
#DEFINE    p_wc2           LIKE type_file.chr1000, 
 DEFINE    p_wc2          STRING,       #NO.FUN-910082
    l_flag          LIKE type_file.chr1     
 
    LET g_sql =
        "SELECT vlj05 ,vlj06 ,vlj13 ,vlj14 ,vlj15 ,vlj16 ,vlj49,vlj50,vlj51,",
        "       vlj311,vlj312,vlj313,vlj314,vlj315,vlj316 ",
        "  FROM vlj_file",
        " WHERE vlj01 = '",g_vlj_a.vlj01,"'",
        "  AND  vlj02 = '",g_vlj_a.vlj02,"'",
        "  AND  vlj03 = '",g_vlj_a.vlj03,"'",
        "  AND ", p_wc2 CLIPPED,            #單身
        "  ORDER BY vlj05"
    PREPARE i327_pb FROM g_sql
    DECLARE vlj_cs CURSOR FOR i327_pb            #SCROLL CURSOR
 
    CALL g_vlj_b.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH vlj_cs INTO g_vlj_b[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_vlj_a.vlj02 = 0 THEN 
            #工作站
            CALL i327_vlj06_0(g_cnt)
        ELSE
            #機器編號
            CALL i327_vlj06_1(g_cnt)
        END IF
        LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_vlj_b.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i327_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vlj_b TO s_vlj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
     #ON ACTION output
     #     LET g_action_choice="output"
     #     EXIT DISPLAY
 
      ON ACTION first
         CALL i327_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY               
 
 
      ON ACTION previous
         CALL i327_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
 
      ON ACTION jump
         CALL i327_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
      ON ACTION next
         CALL i327_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
 
      ON ACTION last
         CALL i327_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
      ON ACTION detail
         LET g_action_choice="detail"
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
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #apsi315
      ON ACTION aps_lock_used_machine
         LET g_action_choice = "aps_lock_used_machine"
         EXIT DISPLAY
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i327_vlj06_0(l_n) #工作站
DEFINE
    l_n             LIKE type_file.num5,   #目前的ARRAY CNT  
    p_cmd           LIKE type_file.chr1,  
    l_ecaacti       LIKE eca_file.ecaacti
 
    LET g_errno = ' '
    SELECT eca02,ecaacti INTO g_vlj_b[l_n].desc,l_ecaacti FROM eca_file
     WHERE eca01 = g_vlj_b[l_n].vlj06
 
         CASE WHEN SQLCA.SQLCODE = 100  
                   LET g_errno = 'aec-100' #無此工作站
                   LET g_vlj_b[l_n].desc = ' '
                   LET l_ecaacti = ' '
              WHEN l_ecaacti='N' 
                   LET g_errno = '9028'
              OTHERWISE          
                   LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_vlj_b[l_n].desc
 
END FUNCTION
 
FUNCTION i327_vlj06_1(l_n) #機器編號
DEFINE
    l_n             LIKE type_file.num5,   #目前的ARRAY CNT  
    p_cmd           LIKE type_file.chr1,  
    l_eciacti       LIKE eci_file.eciacti
 
    LET g_errno = ' '
    SELECT eci06,eciacti INTO g_vlj_b[l_n].desc,l_eciacti FROM eci_file
     WHERE eci01 = g_vlj_b[l_n].vlj06
 
         CASE WHEN SQLCA.SQLCODE = 100  
                   LET g_errno = 'mfg4010' #無此機器編號,請重新輸入
                   LET g_vlj_b[l_n].desc = ' '
                   LET l_eciacti = ' '
              WHEN l_eciacti='N' 
                   LET g_errno = '9028'
              OTHERWISE          
                   LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_vlj_b[l_n].desc
 
END FUNCTION
 
FUNCTION i327_aps_vne()
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_vne RECORD LIKE vne_file.*
 
  IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
  IF cl_null(g_vlj_a.vlj03) OR
     cl_null(g_vlj_b[l_ac].vlj06) THEN
      CALL cl_err('','-400',1)
      RETURN
  END IF
 
  LET l_vne.vne01 = g_vlj_a.vlj01
  LET l_vne.vne02 = g_vlj_a.vlj01
  LET l_vne.vne03 = g_vlj_a.vlj03
  LET l_vne.vne04 = g_ecm04
  LET l_vne.vne05 = g_vlj_b[l_ac].vlj06
 
 
  SELECT COUNT(*) INTO l_cnt FROM vne_file
   WHERE vne01 = l_vne.vne01
     AND vne02 = l_vne.vne02
     AND vne03 = l_vne.vne03
     AND vne04 = l_vne.vne04
     AND vne05 = l_vne.vne05
   IF l_cnt = 0 THEN
       #TQC-8A0013 mark
       #IF NOT cl_confirm('aps-025') THEN #無鎖定製程設備資料,是否新增?
       #    RETURN
       #ELSE
            LET l_vne.vne06 = 0
            LET l_vne.vne07 = 0
            INSERT INTO vne_file VALUES(l_vne.*)
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("ins","vne_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,"","",1)
            END IF
           #TQC-8A0013---mod---str---
           #CALL i327_upd_vne06()
            CALL s_upd_vne06(g_vlj_a.vlj01,g_vlj_a.vlj01,g_vlj_a.vlj03,g_ecm04,g_sfb.sfb08)
           #TQC-8A0013---mod---end---
       #END IF #TQC-8A0013 mark
    END IF
    LET g_cmd = "apsi315 '",l_vne.vne01,"' '",l_vne.vne02,"' '",l_vne.vne03,"' '",l_vne.vne04,"' '",l_vne.vne05,"'" #TQC-890064
   #LET g_cmd = "apsi315 '",l_vne.vne01,"' '",l_vne.vne02,"' '",l_vne.vne03,"' '",l_vne.vne04,"'"                   #TQC-890064
    CALL cl_cmdrun_wait(g_cmd)
END FUNCTION
 
##TQC-8A0013---mark---str---
#FUNCTION i327_upd_vne06()
#DEFINE l_cnt        LIKE type_file.num5
#DEFINE l_vne06  LIKE vne_file.vne06
#DEFINE l_vne RECORD LIKE vne_file.*
#
#  IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
#  IF cl_null(g_vlj_a.vlj03) OR
#     cl_null(g_vlj_b[l_ac].vlj06) THEN
#      CALL cl_err('','-400',1)
#      RETURN
#  END IF
#
#  LET l_vne.vne01 = g_vlj_a.vlj01
#  LET l_vne.vne02 = g_vlj_a.vlj01
#  LET l_vne.vne03 = g_vlj_a.vlj03
#  LET l_vne.vne04 = g_ecm04
#  LET l_vne.vne05 = g_vlj_b[l_ac].vlj06
#
#
#  DECLARE i327_upd_vne06 CURSOR FOR
#   SELECT *  
#    FROM vne_file
#   WHERE vne01 = l_vne.vne01
#     AND vne02 = l_vne.vne02
#     AND vne03 = l_vne.vne03
#     AND vne04 = l_vne.vne04
#
#  SELECT COUNT(*) INTO l_cnt FROM vne_file
#   WHERE vne01 = l_vne.vne01
#     AND vne02 = l_vne.vne02
#     AND vne03 = l_vne.vne03
#     AND vne04 = l_vne.vne04
#  IF l_cnt > 0 THEN
#      SELECT COUNT(*) INTO l_cnt FROM vlj_file
#       WHERE vlj01 = g_vlj_a.vlj01 
#         AND vlj02 = g_vlj_a.vlj02
#         AND vlj03 = g_vlj_a.vlj03 
#      LET l_vne06 = cl_digcut(g_sfb.sfb08/l_cnt,0)
# 
#      FOREACH i327_upd_vne06 INTO l_vne.*
#          IF SQLCA.sqlcode THEN
#              CALL cl_err('foreach:i327_upd_vne06',SQLCA.sqlcode,1)
#              EXIT FOREACH
#          END IF
#          UPDATE vne_file
#             SET vne06 = l_vne06
#           WHERE vne01 = l_vne.vne01
#             AND vne02 = l_vne.vne02
#             AND vne03 = l_vne.vne03
#             AND vne04 = l_vne.vne04
#             AND vne05 = l_vne.vne05
#      END FOREACH
#  END IF
#END FUNCTION
##TQC-8A0013---mark---end---
