# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli121.4gl
# Descriptions...: 分錄底稿摘要彈性設定維護作業agli121
# Date & Author..: NO.FUN-5C0015 BY GILL
# Modify.........: No.FUN-640256 05/04/25 By Claire 加入"查詢欄位代號"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0061 23/10/16 By xumin g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740064 07/04/18 By arman  會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760105 07/06/13 By hongmei 帳套顯示異常
# Modify.........: No.FUN-760085 07/08/03 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-960085 09/07/30 By hongmei select ahh_file 時加入ahh00
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980149 09/09/03 By sabrina i121_b_fill()段、i121_b()不需抓ahh00，故把ahh00拿掉 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_ahh01           LIKE ahh_file.ahh01,   # 科目代號 (假單頭)
         g_ahh00           LIKE ahh_file.ahh00,   # NO.FUN-740064   
         g_ahh00_t         LIKE ahh_file.ahh00,   #帳別 #No.TQC-760105         
         g_ahh01_t         LIKE ahh_file.ahh01,   # 科目代號 (假單頭)
         g_aag02           LIKE aag_file.aag02,   # 科目名稱
         g_ahh    DYNAMIC ARRAY  OF RECORD        # 程式變數
            ahh02          LIKE ahh_file.ahh02,   #科目代號
            gaz03          LIKE gaz_file.gaz03,   #交易作業代號
            ahh03          LIKE ahh_file.ahh03    #摘要設定值
                      END RECORD,
         g_ahh_t           RECORD                 # 變數舊值
            ahh02          LIKE ahh_file.ahh02,   #科目代號
            gaz03          LIKE gaz_file.gaz03,   #交易作業代號
            ahh03          LIKE ahh_file.ahh03    #摘要設定值
                      END RECORD,
         g_ahh_o           RECORD                 # 變數舊值
            ahh02          LIKE ahh_file.ahh02,   #科目代號
            gaz03          LIKE gaz_file.gaz03,   #交易作業代號
            ahh03          LIKE ahh_file.ahh03    #摘要設定值
                      END RECORD,
#        g_wc                  VARCHAR(1000),
         g_wc                  STRING,          #TQC-630166          
         g_sql                 STRING,          
         g_rec_b               LIKE type_file.num5,     # 單身筆數             #No.FUN-680098 SMALLINT
         l_ac                  LIKE type_file.num5,     # 目前處理的ARRAY CNT  #No.FUN-680098 SMALLINT
         g_xxx                 LIKE oay_file.oayslip    #FUN-620023            #No.FUN-680098   VARCHAR(5)       
DEFINE   g_cnt                 LIKE type_file.num10     #No.FUN-680098 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(72)
DEFINE   g_forupd_sql          STRING        
DEFINE   g_curs_index          LIKE type_file.num10         #No.FUN-680098 INTEGER   
DEFINE   g_row_count           LIKE type_file.num10         #No.FUN-680098 INTEGER    
DEFINE   g_jump                LIKE type_file.num10         #No.FUN-680098 INTEGER   
DEFINE   mi_no_ask             LIKE type_file.num5          #No.FUN-680098 INTEGER   #No.FUN-6A0061
#No.FUN-760085---Begin                                                          
DEFINE   g_str                 STRING                                                 
DEFINE   l_sql                 STRING                                                 
DEFINE   l_table               STRING                                                 
#No.FUN-760085---End 
 
MAIN
   DEFINE   p_row,p_col    LIKE type_file.num5          #No.FUN-680098  SMALLINT
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   END IF
   #No.FUN-760085---Begin
   LET g_sql = "ahh00.ahh_file.ahh00,",
               "ahh01.ahh_file.ahh01,",
               "aag02.aag_file.aag02,",
               "ahh02.ahh_file.ahh02,",
               "gaz03.gaz_file.gaz03,",
               "ahh03.ahh_file.ahh03,"      
 
   LET l_table = cl_prt_temptable('agli121',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?) "                                    
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #NO.FUN-760085---End
 
   LET g_ahh01_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW i121_w AT p_row,p_col WITH FORM "agl/42f/agli121"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from ahh_file ",
 
                "  WHERE ahh01 = ? ",
                      "   AND ahh00 = ? ",       #No.TQC-760105
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i121_lock_u CURSOR FROM g_forupd_sql
 
   CALL i121_menu() 
 
   CLOSE WINDOW i121_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i121_curs()                         # QBE 查詢資料
   CLEAR FORM                                # 清除畫面
   CALL g_ahh.clear()
   CALL cl_set_head_visible("","YES")        #No.FUN-6B0029 
 
   INITIALIZE g_ahh01 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON ahh00,ahh01,ahh02,ahh03      #NO.FUN-740064
                FROM ahh00,ahh01,s_ahh[1].ahh02,s_ahh[1].ahh03   #NO.FUN-740064
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
            WHEN INFIELD(ahh01)        #科目代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahh01
               NEXT FIELD ahh01
#NO.FUN-740064  --Begin
            WHEN INFIELD(ahh00)        #科目代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahh00
               NEXT FIELD ahh00
#NO.FUN-740064    ----End
            WHEN INFIELD(ahh02)        #交易作業(程式代號)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahh02
               NEXT FIELD ahh02
            OTHERWISE
               EXIT CASE
         END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION about
          CALL cl_about()
 
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
 
   LET g_sql= "SELECT UNIQUE ahh00,ahh01 FROM ahh_file ",     #No.TQC-760105
              " WHERE ", g_wc CLIPPED,
              " GROUP BY ahh00,ahh01 ORDER BY ahh00,ahh01"    #No.TQC-760105
 
   PREPARE i121_prepare FROM g_sql          # 預備一下
   DECLARE i121_b_curs                      # 宣告成可捲動的
   SCROLL CURSOR WITH HOLD FOR i121_prepare
 
END FUNCTION
 
#選出筆數直接寫入 g_row_count
FUNCTION i121_count()
   DEFINE la_ahh     DYNAMIC ARRAY of RECORD        # 程式變數
           ahh00     LIKE ahh_file.ahh00,        #No.TQC-760105     
           ahh01     LIKE ahh_file.ahh01
                     END RECORD,
          li_cnt     LIKE type_file.num10,       #No.FUN-680098  INTEGER   
          li_rec_b   LIKE type_file.num10        #No.FUN-680098  INTEGER   
 
   LET g_sql= "SELECT UNIQUE ahh00,ahh01 FROM ahh_file ",      #No.TQC-760105
              " WHERE ", g_wc CLIPPED,
              " GROUP BY ahh00,ahh01 ORDER BY ahh00,ahh01"     #No.TQC-760105  
 
   PREPARE i121_precount FROM g_sql
   DECLARE i121_count CURSOR FOR i121_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i121_count INTO g_ahh[li_cnt].*  
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b
 
END FUNCTION
 
FUNCTION i121_menu()
 
   WHILE TRUE
      CALL i121_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
           IF cl_chk_act_auth() THEN
              CALL i121_a()
           END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i121_copy()
            END IF
         WHEN "delete"                          # R.刪除
            IF cl_chk_act_auth() THEN
               CALL i121_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i121_q()
            END IF
         WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i121_out()
           END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i121_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_ahh),'','')
            END IF
         #No.FUN-6B0040-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ahh01 IS NOT NULL THEN
                 #No.TQC-760105-----Begin
                 LET g_doc.column1 = "ahh00"                                                                                        
                 LET g_doc.value1 = g_ahh00 
                 LET g_doc.column2 = "ahh01"
                 LET g_doc.value2 = g_ahh01
                 #No.TQC-760105-----End
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0040-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i121_a()
   
   MESSAGE ""
   CLEAR FORM
   CALL g_ahh.clear()
  
   INITIALIZE g_ahh01 LIKE gae_file.gae01    # 預設值及將數值類變數清成零
   INITIALIZE g_aag02 LIKE aag_file.aag02    # 預設值及將數值類變數清成零
   LET g_ahh00 = NULL #No.TQC-760105
   CALL cl_opmsg('a')
  
   WHILE TRUE
     CALL i121_i("a")# 輸入單頭
    
     IF INT_FLAG THEN# 使用者不玩了
        LET g_ahh00=NULL   #NO.FUN-740064
        LET g_ahh01=NULL
        LET g_aag02=NULL
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
     
     LET g_rec_b = 0
     
     CALL g_ahh.clear()
     CALL i121_b_fill('1=1')             # 單身
     
     CALL i121_b()                       # 輸入單身
     LET g_ahh01_t=g_ahh01
     LET g_ahh00_t=g_ahh00    #No.TQC-760105
     EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION i121_i(p_cmd)                          # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #No.FUN-680098 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5    #No.FUN-680098   SMALLLINT
   DEFINE   l_aaaacti    LIKE aaa_file.aaaacti  #No.TQC-760105 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
   INPUT g_ahh00,g_ahh01 WITHOUT DEFAULTS FROM ahh00,ahh01    #NO.FUN-740064
      
      #No.TQC-760105------Begin
      AFTER FIELD ahh00                                                                                                             
         IF NOT cl_null(g_ahh00) THEN                                                                                               
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                                                                             
             WHERE aaa01=g_ahh00                                                                                                    
            IF SQLCA.SQLCODE=100 THEN                                                                                               
               CALL cl_err3("sel","aaa_file",g_ahh00,"",100,"","",1)                                                                
               NEXT FIELD ahh00                                                                                                     
            END IF                                                                                                                  
            IF l_aaaacti='N' THEN                                                                                                   
               CALL cl_err(g_ahh00,"9028",1)                                                                                        
               NEXT FIELD ahh00                                                                                                     
            END IF                                                                                                                  
         END IF
      #No.TQC-760105------End
 
      AFTER FIELD ahh01
         IF cl_null(g_ahh00) THEN NEXT FIELD ahh00 END IF    #No.TQC-760105
         IF NOT cl_null(g_ahh01) THEN
            IF p_cmd = 'a' OR (p_cmd ='u' AND g_ahh01 != g_ahh01_t) THEN
              #Mod No.FUN-B10048
              #LET l_count = 0 
              #SELECT COUNT(*) INTO l_count FROM aag_file
              # WHERE aag01 = g_ahh01
              #   AND aag00 = g_ahh00      #NO.FUN-740064
              #   AND aagacti='Y'
              #IF l_count = 0 THEN
              #   CALL cl_err('','agl-916',1)
              #   NEXT FIELD ahh01
              #END IF
              #LET l_count = 0
              #SELECT COUNT(*) INTO l_count FROM aag_file
              # WHERE aag01 = g_ahh01
              #   AND aag00 = g_ahh00              #NO.FUN-740064
              #   AND aagacti='Y'
              #   AND aag07 ='1'
              #IF l_count > 0 THEN
              #   CALL cl_err('','agl-015',1)
              #   NEXT FIELD ahh01
              #END IF
 
              #LET g_aag02 = NULL
              #SELECT aag02 INTO g_aag02 FROM aag_file
              # WHERE aag01 = g_ahh01
              #   AND aag00 = g_ahh00      #NO.FUN-740064
              #   AND aagacti ='Y'
              #DISPLAY g_aag02 TO aag02
               CALL i121_ahh01(g_ahh01,g_ahh00)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ahh01,g_errno,0)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag02"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_ahh00 
                  LET g_qryparam.default1= g_ahh01
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_ahh01 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_ahh01
                  NEXT FIELD ahh01
               ELSE
                  DISPLAY g_aag02 TO aag02
               END IF
              #End Mod No.FUN-B10048
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ahh01)  #科目
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag02"
#               LET g_qryparam.arg1 = g_lang    #NO.FUN-740064
               LET g_qryparam.arg1 = g_ahh00    #NO.FUN-740064
               LET g_qryparam.default1= g_ahh01
               CALL cl_create_qry() RETURNING g_ahh01
               NEXT FIELD ahh01
#NO.FUN-740064    ----Begin
            WHEN INFIELD(ahh00)  #科目
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
#               LET g_qryparam.arg1 = g_lang    #NO.FUN-740064
               LET g_qryparam.arg1 = g_ahh00    #NO.FUN-740064
               LET g_qryparam.default1= g_ahh00
               CALL cl_create_qry() RETURNING g_ahh00
               NEXT FIELD ahh00
#NO.FUN-740064      ----End
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
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
END FUNCTION
 
FUNCTION i121_r()
 
  IF s_shut(0) THEN
     RETURN
  END IF
 
  IF cl_null(g_ahh01) OR cl_null(g_ahh00) THEN     #No.TQC-760105
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  BEGIN WORK
 
  IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "ahh00"      #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_ahh00       #No.FUN-9B0098 10/02/24
      LET g_doc.column2 = "ahh01"      #No.FUN-9B0098 10/02/24
      LET g_doc.value2 = g_ahh01       #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
     DELETE FROM ahh_file WHERE ahh01 = g_ahh01
                            AND ahh00 = g_ahh00      #No.TQC-760105
     IF SQLCA.sqlcode THEN
#       CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("del","ahh_file",g_ahh01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123
     ELSE
        CLEAR FORM
        CALL g_ahh.clear()
        LET g_cnt=SQLCA.SQLERRD[3]
        MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        CALL i121_count()
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i121_b_curs
           CLOSE i121_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i121_b_curs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i121_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE   #No.FUN-6A0061
           CALL i121_fetch('/')
        END IF
     END IF
  END IF
  COMMIT WORK
 
END FUNCTION
 
FUNCTION i121_q()                            #Query 查詢
 
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ahh01 TO NULL               #No.FUN-6B0040
   INITIALIZE g_ahh00 TO NULL               #No.TQC-760105
   CLEAR FROM
   CALL g_ahh.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i121_curs()                         #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i121_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                    #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_ahh01 TO NULL
      INITIALIZE g_ahh00 TO NULL            #No.TQC-760105
   ELSE
#     OPEN i121_count
#     FETCH i121_count INTO g_row_count
      CALL i121_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i121_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i121_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,    #處理方式        #No.FUN-680098 VARCHAR(1)
            l_abso   LIKE type_file.num10    #絕對的筆數      #No.FUN-680098 INTEGER   
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i121_b_curs INTO g_ahh00,g_ahh01  #No.TQC-760105
      WHEN 'P' FETCH PREVIOUS i121_b_curs INTO g_ahh00,g_ahh01  #No.TQC-760105
      WHEN 'F' FETCH FIRST    i121_b_curs INTO g_ahh00,g_ahh01  #No.TQC-760105
      WHEN 'L' FETCH LAST     i121_b_curs INTO g_ahh00,g_ahh01  #No.TQC-760105 
      WHEN '/' 
         IF (NOT mi_no_ask) THEN   #No.FUN-6A0061
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i121_b_curs INTO g_ahh00,g_ahh01    #No.TQC-760105
         LET mi_no_ask = FALSE  #No.FUN-6A0061 
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ahh01,SQLCA.sqlcode,0)
      INITIALIZE g_ahh01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL i121_show()
   END IF
END FUNCTION
 
FUNCTION i121_show()                         # 將資料顯示在畫面上
 
   LET g_aag02 = NULL 
   SELECT aag02 INTO g_aag02 FROM aag_file
    WHERE aag01 = g_ahh01
      AND aag00 = g_ahh00       #NO.FUN-740064
      AND aagacti ='Y'
   DISPLAY g_aag02 TO aag02
   DISPLAY g_ahh01 TO ahh01
   DISPLAY g_ahh00 TO ahh00      #NO.FUN-740064
   CALL i121_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i121_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,          # 未取消的ARRAY CNT #No.FUN-680098 SMALLINT
            l_n             LIKE type_file.num5,          # 檢查重複用        #No.FUN-680098 SMALLINT
            l_lock_sw       LIKE type_file.chr1,          # 單身鎖住否        #No.FUN-680098 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,          # 處理狀態          #No.FUN-680098 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,          #No.FUN-680098  SMALLINT
            l_allow_delete  LIKE type_file.num5           #No.FUN-680098  SMALLINT
   DEFINE   l_count         LIKE type_file.num5           #No.FUN-680098  SMALLINT
   DEFINE   l_gaq01      LIKE gaq_file.gaq01  #FUN-640256 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_ahh01) OR cl_null(g_ahh00) THEN    #No.TQC-760105
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
  #LET g_forupd_sql= "SELECT ahh00,ahh02,'',ahh03 ",  #CHI-960085 add ahh00    #MOD-980149 mark
   LET g_forupd_sql= "SELECT ahh02,'',ahh03 ",  #CHI-960085 add ahh00          #MOD-980149 add
                     "  FROM ahh_file",
                     " WHERE ahh00 = ? AND ahh01 = ? AND ahh02 = ? ",     #No.TQC-760105
                     "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i121_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_ahh WITHOUT DEFAULTS FROM s_ahh.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_ahh_t.* = g_ahh[l_ac].*    #BACKUP
            LET g_ahh_o.* = g_ahh[l_ac].*    #BACKUP
            OPEN i121_bcl USING g_ahh00,g_ahh01,g_ahh_t.ahh02    #No.TQC-760105
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i121_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i121_bcl INTO g_ahh[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i121_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i121_gaz03(g_ahh[l_ac].ahh02) RETURNING g_ahh[l_ac].gaz03
               DISPLAY BY NAME g_ahh[l_ac].gaz03
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ahh[l_ac].* TO NULL       
         LET g_ahh_t.* = g_ahh[l_ac].*          #新輸入資料
         LET g_ahh_o.* = g_ahh[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     
         NEXT FIELD ahh02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO ahh_file(ahh00,ahh01,ahh02,ahh03)     #NO.FUN-740064
                      VALUES (g_ahh00,g_ahh01,g_ahh[l_ac].ahh02,g_ahh[l_ac].ahh03)    #NO.FUN-740064
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ahh01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","ahh_file",g_ahh01,g_ahh[l_ac].ahh02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD ahh02  #交易作業(程式代號)
        IF NOT cl_null(g_ahh[l_ac].ahh02) THEN
           IF p_cmd = 'a' OR (p_cmd='u' AND 
                              g_ahh[l_ac].ahh02!=g_ahh_t.ahh02) THEN
              LET l_n = 0 
              SELECT COUNT(*) INTO l_n FROM ahh_file
               WHERE ahh00 = g_ahh00   #CHI-960085 add 
                 AND ahh01 = g_ahh01
                 AND ahh02 = g_ahh[l_ac].ahh02
              IF l_n > 0 THEN
                 CALL cl_err(g_ahh[l_ac].ahh02,-239,1)
                 LET g_ahh[l_ac].ahh02 = g_ahh_o.ahh02
                 NEXT FIELD ahh02
              END IF
              LET g_ahh_o.ahh02 = g_ahh[l_ac].ahh02
           END IF
           IF p_cmd = 'a' OR (p_cmd='u' AND 
                              g_ahh[l_ac].ahh02!=g_ahh_o.ahh02) THEN
              LET l_n = 0 
              SELECT COUNT(*) INTO l_n FROM gaz_file
               WHERE gaz01 = g_ahh[l_ac].ahh02
                 AND gaz02 = g_lang
              IF l_n = 0 THEN
                 CALL cl_err(g_ahh[l_ac].ahh02,'lib-021',1)
                 LET g_ahh[l_ac].ahh02 = g_ahh_o.ahh02
                 NEXT FIELD ahh02
              END IF
              LET g_ahh_o.ahh02 = g_ahh[l_ac].ahh02
           END IF
        END IF
        CALL i121_gaz03(g_ahh[l_ac].ahh02) RETURNING g_ahh[l_ac].gaz03
        DISPLAY BY NAME g_ahh[l_ac].gaz03
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ahh_t.ahh02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM ahh_file WHERE ahh01 = g_ahh01
                                   AND ahh00 =g_ahh00      #No.TQC-760105
                                   AND ahh02 = g_ahh_t.ahh02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ahh_t.ahh02,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","ahh_file",g_ahh01,g_ahh_t.ahh02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ahh[l_ac].* = g_ahh_t.*
            CLOSE i121_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ahh[l_ac].ahh02,-263,1)
            LET g_ahh[l_ac].* = g_ahh_t.*
         ELSE
 
            UPDATE ahh_file
               SET ahh02 = g_ahh[l_ac].ahh02,
                   ahh03 = g_ahh[l_ac].ahh03
             WHERE ahh01 = g_ahh01
               AND ahh00 = g_ahh00     #No.TQC-760105
               AND ahh02 = g_ahh_t.ahh02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ahh[l_ac].ahh02,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","ahh_file",g_ahh01,g_ahh_t.ahh02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_ahh[l_ac].* = g_ahh_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ahh[l_ac].* = g_ahh_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_ahh.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i121_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i121_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(ahh02) AND l_ac > 1 THEN
            LET g_ahh[l_ac].* = g_ahh[l_ac-1].*
            DISPLAY BY NAME g_ahh[l_ac].*
            NEXT FIELD ahh02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ahh02) #交易作業
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaz"
                 LET g_qryparam.arg1 = g_lang
                 LET g_qryparam.default1 = g_ahh[l_ac].ahh02
                 CALL cl_create_qry() RETURNING g_ahh[l_ac].ahh02
                 DISPLAY BY NAME g_ahh[l_ac].ahh02
                 NEXT FIELD ahh02
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
 
     #FUN-640256-begin
      ON ACTION qry_feld
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_feld"
         LET g_qryparam.arg1 = g_xxx
         LET g_qryparam.arg2 = g_lang
         CALL cl_create_qry() RETURNING l_gaq01
         LET g_ahh[l_ac].ahh03 = g_ahh[l_ac].ahh03 CLIPPED,l_gaq01
         DISPLAY BY NAME g_ahh[l_ac].ahh03
         NEXT FIELD ahh03
     #FUN-640256-end
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END INPUT
 
   CLOSE i121_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i121_b_fill(p_wc)              #BODY FILL UP
#  DEFINE p_wc         VARCHAR(300)
   DEFINE p_wc         STRING        #TQC-630166   
   DEFINE p_ac         LIKE type_file.num5       #No.FUN-680098   SMALLINT
 
   #LET g_sql = "SELECT ahh00,ahh02,'',ahh03 ",  #CHI-960085 add ahh00     #MOD-980149 mark
    LET g_sql = "SELECT ahh02,'',ahh03 ",  #CHI-960085 add ahh00           #MOD-980149 add
                 " FROM ahh_file ",
                " WHERE ahh01 = '",g_ahh01 CLIPPED,"' ",
                "   AND ahh00 = '",g_ahh00 CLIPPED,"' ",      #No.TQC-760105
                  " AND ",p_wc CLIPPED,
                " ORDER BY ahh02"
 
    PREPARE i121_prepare2 FROM g_sql           #預備一下
    DECLARE ahh_curs CURSOR FOR i121_prepare2
 
    CALL g_ahh.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH ahh_curs INTO g_ahh[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL i121_gaz03(g_ahh[g_cnt].ahh02) RETURNING g_ahh[g_cnt].gaz03
       DISPLAY BY NAME g_ahh[g_cnt].gaz03
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ahh.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i121_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_ahh TO s_ahh.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice='reproduce'
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL i121_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous                         # P.上筆
         CALL i121_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION jump                             # 指定筆
         CALL i121_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY    
 
      ON ACTION next                             # N.下筆
         CALL i121_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY              
 
      ON ACTION last                             # 最終筆
         CALL i121_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY               
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel      
         LET g_action_choice = 'exporttoexcel'
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
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i121_copy()
   DEFINE   l_aaaacti LIKE aaa_file.aaaacti   #No.TQC-760105
   DEFINE   l_n       LIKE type_file.num5,    #No.FUN-680098  SMALLINT
            l_new01   LIKE ahh_file.ahh01,
            l_old01   LIKE ahh_file.ahh01,
            l_new00   LIKE ahh_file.ahh00,     #No.TQC-760105
            l_old00   LIKE ahh_file.ahh00,     #No.TQC-760105
            l_ahh     RECORD LIKE ahh_file.*,
            l_temp    LIKE ahe_file.ahe02,
            l_count   LIKE type_file.num10     #No.FUN-680098    INTEGER   
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF cl_null(g_ahh01) OR cl_null(g_ahh00) THEN    #No.TQC-760105
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")          #No.FUN-6B0029 
 
   INPUT l_new00,l_new01 WITHOUT DEFAULTS FROM ahh00,ahh01     #No.TQC-760105
 
      #No.TQC-760105------Begin
      AFTER FIELD ahh00                                                                                                             
         IF NOT cl_null(l_new00) THEN                                                                                               
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                                                                             
             WHERE aaa01=l_new00                                                                                                    
            IF SQLCA.SQLCODE=100 THEN                                                                                               
               CALL cl_err3("sel","aaa_file",l_new00,"",100,"","",1)                                                                
               NEXT FIELD ahh00                                                                                                     
            END IF                                                                                                                  
            IF l_aaaacti='N' THEN                                                                                                   
               CALL cl_err(l_new00,"9028",1)                                                                                        
               NEXT FIELD ahh00                                                                                                     
            END IF                                                                                                                  
         END IF 
      #No.TQC-760105------End
  
      AFTER FIELD ahh01
       IF cl_null(l_new00) THEN NEXT FIELD ahh00 END IF    #No.TQC-760105
        LET l_count = 0 
        SELECT COUNT(*) INTO l_count FROM aag_file
         WHERE aag01 = l_new01
   #       AND aag00 = g_ahh00     #NO.FUN-740064  #No.TQC-760105
           AND aag00 = l_new00     #No.TQC-760105
           AND aagacti='Y'
        IF l_count = 0 THEN
           CALL cl_err('','agl-916',0)   #Mod No.FUN-B10048 1->0
           #Add No.FUN-B10048
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_aag02"
           LET g_qryparam.construct = 'N'
           LET g_qryparam.arg1 = l_new00
           LET g_qryparam.default1= l_new01
           LET g_qryparam.where = " aag01 LIKE '",l_new01 CLIPPED,"%'"
           CALL cl_create_qry() RETURNING l_new01
           #End Add No.FUN-B10048
           NEXT FIELD ahh01
        END IF
        LET g_aag02 = NULL
        SELECT aag02 INTO g_aag02 FROM aag_file
         WHERE aag01 = l_new01
    #      AND aag00 = g_ahh00     #NO.FUN-740064    #No.TQC-760105
           AND aag00 = l_new00     #No.TQC-760105
           AND aagacti ='Y'
        DISPLAY g_aag02 TO aag02
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         #No.TQC-760105-----Begin
         IF cl_null(l_new00) THEN                                                                                                   
            NEXT FIELD ahh00                                                                                                        
         END IF
         #No.TQC-760105-----End
         IF cl_null(l_new01) THEN
            NEXT FIELD ahh01
         END IF
         SELECT COUNT(*) INTO g_cnt FROM ahh_file
           WHERE ahh01 = l_new01
             AND ahh00 = l_new00    #No.TQC-760105
         IF g_cnt > 0 THEN
            CALL cl_err_msg(NULL,"azz-110",l_new01,10)
         END IF
 
      ON ACTION CONTROLP
        CASE
          #No.TQC-760105----Begin
          WHEN INFIELD(ahh00)  #帳別                                                                                                
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = "q_aaa"                                                                                         
              LET g_qryparam.default1= l_new00                                                                                      
              CALL cl_create_qry() RETURNING l_new00                                                                                
              NEXT FIELD ahh00
          #No.TQC-760105----END
          WHEN INFIELD(ahh01)  #科目
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag02"
#              LET g_qryparam.arg1 = g_lang    #NO.FUN-740064
#             LET g_qryparam.arg1 = g_ahh00    #NO.FUN-740064
              LET g_qryparam.arg1 = l_new00    #No.TQC-760105
              LET g_qryparam.default1= l_new01
              CALL cl_create_qry() RETURNING l_new01
              NEXT FIELD ahh01
        END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_ahh01 TO ahh01
      DISPLAY g_ahh00 TO ahh00    #No.TQC-760105
      RETURN
   END IF
 
   DROP TABLE x
  
   SELECT * FROM ahh_file WHERE ahh01 = g_ahh01 
                            AND ahh00 = g_ahh00    #No.TQC-760105
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_ahh01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("ins","x",g_ahh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      RETURN
   END IF
 
   UPDATE x
      SET ahh01 = l_new01,                       # 資料鍵值
          ahh00 = l_new00     #No.TQC-760105
   INSERT INTO ahh_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
#     CALL cl_err('ahh:',SQLCA.SQLCODE,0)   #No.FUN-660123
      CALL cl_err3("ins","ahh_file",l_new01,"",SQLCA.sqlcode,"","ahh:",1)  #No.FUN-660123
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_ahh01
   LET g_ahh01 = l_new01
   #No.TQC-760105----Begin
   LET l_old00 = g_ahh00
   LET g_ahh00 = l_new00 
   #No.TQC-760105----End
   CALL i121_b()
   #FUN-C30027---begin
   #LET g_ahh01 = l_old01
   #LET g_ahh00 = l_old00    #No.TQC-760105
   #CALL i121_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION i121_gaz03(p_ahh02)
   DEFINE   l_gaz03         LIKE gaz_file.gaz03,
            p_ahh02         LIKE ahh_file.ahh02 
 
   LET l_gaz03 = NULL
   SELECT gaz03 INTO l_gaz03 FROM gaz_file
    WHERE gaz01 = p_ahh02
      AND gaz02 = g_lang
      AND gaz05 = 'Y'
   IF cl_null(l_gaz03) THEN
      SELECT gaz03 INTO l_gaz03 FROM gaz_file
       WHERE gaz01=p_ahh02
         AND gaz02 = g_lang
         AND gaz05='N'
   END IF
   
   RETURN l_gaz03
 
END FUNCTION
 
#Add No.FUN-B10048
FUNCTION i121_ahh01(p_code,p_bookno)
   DEFINE p_code     LIKE aag_file.aag01
   DEFINE p_bookno   LIKE aag_file.aag00
   DEFINE l_aagacti  LIKE aag_file.aagacti
   DEFINE l_aag07    LIKE aag_file.aag07

   LET g_aag02 = NULL
   LET g_errno = NULL
   SELECT aag02,aag07,aagacti INTO g_aag02,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01=p_code
      AND aag00=p_bookno

    CASE WHEN STATUS=100         LET g_errno='agl-001'
         WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'     LET g_errno = 'agl-015'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
END FUNCTION
#End Add No.FUN-B10048

FUNCTION i121_out()
    DEFINE
        l_ahh         RECORD 
            ahh00          LIKE ahh_file.ahh00,    #No.TQC-760105
            ahh01          LIKE ahh_file.ahh01,
            aag02          LIKE aag_file.aag02,
            ahh02          LIKE ahh_file.ahh02,
            gaz03          LIKE gaz_file.gaz03,
            ahh03          LIKE ahh_file.ahh03
                      END RECORD,
        l_i           LIKE type_file.num5,     #No.FUN-680098  SMALLINT
        l_name        LIKE type_file.chr20,    # External(Disk) file name   #No.FUN-680098 VARCHAR(20)
        l_za05        LIKE za_file.za05        #No.FUN-680098 VARCHAR(40)
   
    IF cl_null(g_wc) THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085
    LET g_sql="SELECT ahh00,ahh01,'',ahh02,'',ahh03 ",      #No.TQC-760105
              " FROM ahh_file ",                # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY ahh00,ahh01 "  #No.TQC-760105    
 
    PREPARE i121_p FROM g_sql                   # RUNTIME 編譯
    DECLARE i121_co CURSOR FOR i121_p           # SCROLL CURSOR
 
    #No.FUN-760085---Begin
    #CALL cl_outnam('agli121') RETURNING l_name
    #START REPORT i121_rep TO l_name
    CALL cl_del_data(l_table)                                                   
    #No.FUN-760085---End 
  
    FOREACH i121_co INTO l_ahh.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
        END IF
        SELECT aag02 INTO l_ahh.aag02 FROM aag_file
         WHERE aag01 = l_ahh.ahh01
#          AND aag00 = g_ahh00       #NO.FUN-740064   #No.TQC-760105
           AND aag00 =l_ahh.ahh00    #No.TQC-760105 
           AND aagacti ='Y'
        CALL i121_gaz03(l_ahh.ahh02) RETURNING l_ahh.gaz03
        #No.FUN-760085---Begin
        #OUTPUT TO REPORT i121_rep(l_ahh.*)
        EXECUTE insert_prep USING l_ahh.ahh00,l_ahh.ahh01,l_ahh.aag02,
                                  l_ahh.ahh02,l_ahh.gaz03,l_ahh.ahh03
        #No.FUN-760085---End 
    END FOREACH
 
    #FINISH REPORT i121_rep           #No.FUN-760085
 
    CLOSE i121_co
    ERROR ""
    #No.FUN-760085---Begin 
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'ahh00,ahh01,ahh02,ahh03')                      
            RETURNING g_str                                                      
    END IF                                                                      
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
    CALL cl_prt_cs3('agli121','agli121',l_sql,g_str)                            
                                                                                
#No.FUN-760085---End 
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i121_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
        sr            RECORD 
            ahh00          LIKE ahh_file.ahh00,   #No.TQC-760105
            ahh01          LIKE ahh_file.ahh01,
            aag02          LIKE aag_file.aag02,
            ahh02          LIKE ahh_file.ahh02,
            gaz03          LIKE gaz_file.gaz03,
            ahh03          LIKE ahh_file.ahh03
                      END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ahh00,sr.ahh01,sr.ahh02    #No.TQC-760105 
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[10],sr.ahh00    #No.TQC-760105
            PRINT g_x[11],sr.ahh01
            PRINT g_x[12],sr.aag02
            PRINT ''
            PRINT g_x[31] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.ahh01
             SKIP TO TOP OF PAGE 
 
        ON EVERY ROW
           PRINT  COLUMN g_c[33],sr.ahh02,
                  COLUMN g_c[34],sr.gaz03,
                  COLUMN g_c[35],sr.ahh03
 
        ON LAST ROW
            IF g_zz05 = 'Y'          
               THEN PRINT g_dash[1,g_len]
                    #TQC-630166
                    #IF g_wc[001,080] > ' ' THEN
		    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                    #IF g_wc[071,140] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                    #IF g_wc[141,210] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc)
            END IF
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-760085---End
