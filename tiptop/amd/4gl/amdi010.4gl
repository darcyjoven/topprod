# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern namb...: amdi010.4gl
# Descriptions...: 發票字軌維護程式
# Date & Author..: 96/10/11 BY Joanne Chen 
# Modify.........: No.FUN-4B0007 04/11/01 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-510019 05/01/11 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-550095 05/05/13 By Smapmin 單身新增CONTROLO功能
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制      
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-680074 06/08/23 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710009 07/01/04 By Rayven 報表接下頁，結束格式調整
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-730021 07/03/05 By Smapmin 刪除後筆數有誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7c0043 07/12/26 By Cockroach 報表改為p_query實現
# Modify.........: No.MOD-830015 08/03/04 By Smapmin 如果畫面上的欄位皆為no entry,則無法執行到before input段,故於input 前再一次呼叫entry/noentry的控管
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-950026 09/05/05 By Sarah DISPLAY BY NAME g_amb07應改成DISPLAY g_amb07 TO amb07
# Modify.........: No.MOD-960056 09/06/04 By Sarah DISPLAY l_ac TO FORMONLY.cn3這行mark
# Modify.........: No.TQC-980273 09/08/27 By lilingyu "起始號碼 結束號碼"沒有相關數據邏輯控管
# Modify.........: No.TQC-980267 09/08/27 By lilingyu 年度月份欄位應該不可以輸入"-5,-6"類似這樣的無效值的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_amb01         LIKE amb_file.amb01,   # 發票年 (假單頭)
    g_amb02         LIKE amb_file.amb02,   # 發票月(假單頭)
    g_amb07         LIKE amb_file.amb07,   # 發票月(假單頭)
    g_amb01_t       LIKE amb_file.amb01,   # 發票年(舊值)
    g_amb02_t       LIKE amb_file.amb02,   # 發票年(舊值)
    g_amb07_t       LIKE amb_file.amb07,   # 發票年(舊值)
    g_amball        RECORD
       amb01        LIKE amb_file.amb01,   # 發票年 (假單頭)
       amb02        LIKE amb_file.amb02,   # 發票月(假單頭)
       amb07        LIKE amb_file.amb07    # 發票月(假單頭)
                    END RECORD,
    g_amb           DYNAMIC ARRAY OF RECORD# 程式變數(Program Variables)
        amb03       LIKE amb_file.amb03,   # 字軌
        amb04       LIKE amb_file.amb04,   # 格式
        amb05       LIKE amb_file.amb05,   # 起始號碼
        amb06       LIKE amb_file.amb06    # 結束號碼
                    END RECORD,
    g_amb_t         RECORD                 # 程式變數 (舊值)
        amb03       LIKE amb_file.amb03,   # 字軌
        amb04       LIKE amb_file.amb04,   # 格式
        amb05       LIKE amb_file.amb05,   # 起始號碼
        amb06       LIKE amb_file.amb06    # 結束號碼
                    END RECORD,
     g_wc,g_sql     STRING, #No.FUN-580092 HCN         #No.FUN-680074
    g_ss            LIKE type_file.chr1,               #No.FUN-680074 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,               # 單身筆數    #No.FUN-680074 SMALLINT
    l_ac            LIKE type_file.num5                # 目前處理的ARRAY CNT        #No.FUN-680074 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680074
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_jump          LIKE type_file.num10,        #No.FUN-680074 INTEGER
         g_no_ask       LIKE type_file.num5          #No.FUN-680074 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680074 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680074 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680074 INTEGER
DEFINE   g_before_input_done LIKE type_file.num5      #FUN-570108          #No.FUN-680074 SMALLINT

MAIN
    OPTIONS                                # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_amb01 = NULL                     # 清除鍵值
    LET g_amb02 = NULL                     # 清除鍵值
    LET g_amb01_t = NULL
 
    LET g_forupd_sql = " SELECT amb01,amb02,amb07 FROM amb_file  ",
                        " WHERE amb01 = ? AND amb02 = ? AND amb07 = ? ",
                          " FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i010_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i010_w WITH FORM "amd/42f/amdi010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()

    CALL i010_menu()
    CLOSE WINDOW i010_w                    # 結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i010_curs()
    CALL g_amb.clear()
    CLEAR FORM                             # 清除畫面
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_amb01 TO NULL    #No.FUN-750051
   INITIALIZE g_amb02 TO NULL    #No.FUN-750051
   INITIALIZE g_amb07 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON amb01,amb02,amb03,amb04,amb05,amb06    # 螢幕上取條件
       FROM amb01,amb02,s_amb[1].amb03,s_amb[1].amb04,s_amb[1].amb05,
	    s_amb[1].amb06
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    LET g_sql= "SELECT UNIQUE amb01,amb02,amb07 FROM amb_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i010_prepare FROM g_sql      # 預備一下
    DECLARE i010_b_curs                  # 宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i010_prepare
 #MOD-550095
    DROP TABLE x
#    LET g_sql="SELECT COUNT(*) FROM amb_file WHERE ",
#               g_wc CLIPPED
#   LET g_sql= "SELECT UNIQUE amb01,amb02,amb07 FROM amb_file ",      #No.TQC-720019
    LET g_sql_tmp= "SELECT UNIQUE amb01,amb02,amb07 FROM amb_file ",  #No.TQC-720019
               " WHERE ", g_wc CLIPPED,
               " INTO TEMP x "
 
#   PREPARE i010_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i010_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i010_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x"
 #END MOD-550095
    PREPARE i010_pre_count FROM g_sql
    DECLARE i010_count CURSOR FOR i010_pre_count
END FUNCTION
 
FUNCTION i010_menu()
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i010_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i010_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i010_u()
            END IF
 #MOD-550095
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i010_copy()
            END IF
 #END MOD-550095
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i010_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0007
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_amb),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_amb01 IS NOT NULL THEN
                LET g_doc.column1 = "amb01"
                LET g_doc.column2 = "amb02"
                LET g_doc.column3 = "amb07"
                LET g_doc.value1 = g_amb01
                LET g_doc.value2 = g_amb02
                LET g_doc.value3 = g_amb07
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i010_a()
    WHILE TRUE
        MESSAGE ""
        CLEAR FORM
        CALL g_amb.clear()
        INITIALIZE g_amb01,g_amb02,g_amb07 TO NULL
        LET g_amb01_t = NULL
        LET g_amb02_t = NULL
        LET g_amb07_t = NULL
        #預設值及將數值類變數清成零
        CALL cl_opmsg('a')
        CALL i010_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_amb.clear()
        ELSE
            CALL i010_b_fill('1=1')         #單身
        END IF
        LET g_rec_b=0 
        CALL i010_b()                      #輸入單身
        LET g_amb01_t = g_amb01            #保留舊值
        LET g_amb02_t = g_amb02            #保留舊值
        LET g_amb07_t = g_amb07            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i010_u()
    IF g_amb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_amb01_t = g_amb01
    LET g_amb02_t = g_amb02
    LET g_amb07_t = g_amb07
    BEGIN WORK
 
    OPEN i010_cl USING g_amb01_t,g_amb02_t,g_amb07_t
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_amball.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    WHILE TRUE
        CALL i010_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_amb01=g_amb01_t
            LET g_amb02=g_amb02_t
            LET g_amb07=g_amb02_t
            DISPLAY g_amb01 TO amb01  #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_amb01 != g_amb01_t OR  g_amb02!=g_amb02_t THEN      #更改單頭值
            UPDATE amb_file SET amb01 = g_amb01, #更新DB
                                amb02 = g_amb02,
                                amb07 = g_amb07
             WHERE amb01 = g_amb01_t AND amb02=g_amb02_t AND amb07=g_amb07_t
            IF STATUS THEN
             #  CALL cl_err(g_amb01,STATUS,0) #No.FUN-660093
                CALL cl_err3("upd","amb_file",g_amb01_t,g_amb02_t,STATUS,"","",1)   #No.FUN-660093
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i010_i(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680074 VARCHAR(1)
 
   LET g_ss='Y'
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   #-----MOD-830015---------
   LET g_before_input_done = FALSE                                         
   CALL i010_set_entry(p_cmd)                                              
   CALL i010_set_no_entry(p_cmd)                                           
   LET g_before_input_done = TRUE                                          
   #-----END MOD-830015----- 
   INPUT g_amb01,g_amb02,g_amb07 WITHOUT DEFAULTS
    FROM amb01,amb02,amb07
 
#No.FUN-570108 --start                                                          
      BEFORE INPUT                                                               
         LET g_before_input_done = FALSE                                         
         CALL i010_set_entry(p_cmd)                                              
         CALL i010_set_no_entry(p_cmd)                                           
         LET g_before_input_done = TRUE                                          
#No.FUN-570108 --end     
 
#TQC-980267 --begin--
      AFTER FIELD amb01
        IF NOT cl_null(g_amb01) THEN 
           IF g_amb01 <= 0 THEN 
              CALL cl_err('','amd-003',0)
              NEXT FIELD amb01
           END IF    
        END IF 
#TQC-980267 --end--
 
      AFTER FIELD amb02     
         IF NOT cl_null(g_amb02) IS NULL THEN
#TQC-980267 --begin--
           IF g_amb02 <= 0 THEN 
              CALL cl_err('','amd-003',0)
              NEXT FIELD amb02
           END IF    
#TQC-980267 --end--           
            LET g_amb07 = g_amb02 + 1
            DISPLAY g_amb07 TO amb07
	    #輸入後更改不同時值
            IF g_amb01 != g_amb01_t OR cl_null(g_amb01_t) OR
	       g_amb02!=g_amb02_t OR cl_null(g_amb02_t) OR
	       g_amb07!=g_amb07_t OR cl_null(g_amb07_t) THEN
               SELECT UNIQUE amb01,amb02,amb07
                 FROM amb_file
                WHERE amb01 = g_amb01
                  AND amb02 = g_amb02
                  AND amb07 = g_amb07
               IF STATUS =100 THEN             #不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_amb01,-239,0)
                     LET g_amb01=g_amb01_t
                     LET g_amb02=g_amb02_t
                     LET g_amb07=g_amb07_t
                     NEXT FIELD amb01
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD amb07
         IF NOT cl_null(g_amb07) THEN
#TQC-980267 --begin--
           IF g_amb07 <= 0 THEN 
              CALL cl_err('','amd-003',0)
              NEXT FIELD amb07
           END IF    
#TQC-980267 --end--           
            IF g_amb01 != g_amb01_t OR
               g_amb01_t IS NULL THEN
               SELECT COUNT(*) INTO g_cnt FROM amb_file
                WHERE amb01 = g_amb01
                  AND amb02 = g_amb02
                  AND amb07 = g_amb07
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)           #資料重複
                  LET g_amb07 = g_amb07_t
                 #DISPLAY BY NAME g_amb07    #MOD-950026 mark
                  DISPLAY g_amb07 TO amb07   #MOD-950026
                  NEXT FIELD amb07
               END IF
            END IF
         END IF
         LET g_amb07_t = g_amb07
 
#No.TQC-860019-add                                                                                           
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
#No.TQC-860019-end
   END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i010_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i010_curs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i010_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
    IF STATUS THEN                         #有問題
        CALL cl_err('',STATUS,0)
        INITIALIZE g_amb01 TO NULL
    ELSE
        CALL i010_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN i010_count
        FETCH i010_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i010_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680074 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680074 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i010_b_curs INTO g_amb01,g_amb02,g_amb07
        WHEN 'P' FETCH PREVIOUS i010_b_curs INTO g_amb01,g_amb02,g_amb07
        WHEN 'F' FETCH FIRST    i010_b_curs INTO g_amb01,g_amb02,g_amb07
        WHEN 'L' FETCH LAST     i010_b_curs INTO g_amb01,g_amb02,g_amb07
        WHEN '/' 
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF 
            FETCH ABSOLUTE g_jump i010_b_curs INTO g_amb01,g_amb02,g_amb07
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amb01,SQLCA.sqlcode,0)
        INITIALIZE g_amb01 TO NULL    #No.FUN-6B0079  add
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    IF STATUS THEN
        CALL cl_err(g_amb01,STATUS,0)
    ELSE
        CALL i010_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i010_show()
    DISPLAY g_amb01,g_amb02,g_amb07 TO amb01,amb02,amb07       # 單頭
    CALL i010_b_fill(g_wc)                       # 單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i010_r()
    IF g_amb01 IS NULL OR g_amb02 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0079
       RETURN
    END IF
    LET g_amb01_t = g_amb01
    LET g_amb02_t = g_amb02
    LET g_amb07_t = g_amb07
    BEGIN WORK
 
    OPEN i010_cl USING g_amb01_t,g_amb02_t,g_amb07_t
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_amball.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amb01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
    IF cl_delh(0,0) THEN                   # 確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "amb01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "amb02"      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "amb07"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_amb01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_amb02       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_amb07       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM amb_file 
            WHERE amb01 = g_amb01 AND amb02=g_amb02 AND amb07=g_amb07
        IF STATUS THEN
        #   CALL cl_err('BODY DELETE:',STATUS,0) #No.FUN-660093
            CALL cl_err3("del","amb_file",g_amb01,g_amb02,STATUS,"","BODY DELETE:",1)   #No.FUN-660093
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i010_precount_x                  #No.TQC-720019
            PREPARE i010_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i010_precount_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_amb.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i010_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i010_b_curs
               CLOSE i010_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i010_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i010_b_curs
               CLOSE i010_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            #LET g_row_count = g_row_count - 1   #TQC-730021
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i010_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i010_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL i010_fetch('/')
            END IF
 
        END IF
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                # 未取消的ARRAY CNT        #No.FUN-680074 SMALLINT
    l_n             LIKE type_file.num5,                # 檢查重複用      #No.FUN-680074 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                # 單身鎖住否      #No.FUN-680074 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                # 處理狀態        #No.FUN-680074 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否         #No.FUN-680074 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否         #No.FUN-680074 SMALLINT
 
    LET g_action_choice = ""
    IF g_amb01 IS NULL OR g_amb02 IS NULL THEN
        RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT amb03,amb04,amb05,amb06 ",
                       " FROM amb_file ",
                       " WHERE amb01 =? ", 
                       " AND amb02 =? ", 
                       " AND amb07 =? ",
                       " AND amb03 =? ", 
                       " AND amb04 =? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET g_amb01_t = g_amb01
        LET g_amb02_t = g_amb02
         LET g_amb07_t = g_amb07   #MOD-550095
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_amb WITHOUT DEFAULTS FROM s_amb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            BEGIN WORK
            LET l_ac = ARR_CURR()
           #DISPLAY l_ac TO FORMONLY.cn3   #MOD-960056 mark
#           LET g_amb_t.* = g_amb[l_ac].* # BACKUP
            LET l_lock_sw = 'N'            # DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_amb_t.amb03 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_amb_t.* = g_amb[l_ac].* # BACKUP
                OPEN i010_cl USING g_amb01_t,g_amb02_t,g_amb07_t
                IF STATUS THEN
                   CALL cl_err("OPEN i010_cl:", STATUS, 1)
                   CLOSE i010_cl
                   ROLLBACK WORK
                   RETURN
                END IF
                FETCH i010_cl INTO g_amball.*              # 對DB鎖定
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_amb01,SQLCA.sqlcode,0)
                    RETURN
                END IF
 
                OPEN i010_bcl USING g_amb01,g_amb02,g_amb07,g_amb_t.amb03,g_amb_t.amb04
                IF STATUS THEN
                   CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                   CLOSE i010_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i010_bcl INTO g_amb[l_ac].* 
                   IF SQLCA.SQLCODE THEN
                       CALL cl_err(g_amb_t.amb03,STATUS,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
#            NEXT FIELD amb03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO amb_file(amb01,amb02,amb03,amb04,amb05,amb06,amb07)
            VALUES(g_amb01,g_amb02,g_amb[l_ac].amb03,
                   g_amb[l_ac].amb04,g_amb[l_ac].amb05,g_amb[l_ac].amb06,g_amb07)
            IF STATUS THEN
         #     CALL cl_err(g_amb[l_ac].amb03,STATUS,0) #No.FUN-660093
               CALL cl_err3("ins","amb_file",g_amb01,g_amb02,STATUS,"","",1)   #No.FUN-660093
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
#TQC-980273 --begin--
        AFTER FIELD amb05
           IF NOT cl_null(g_amb[l_ac].amb05) AND NOT cl_null(g_amb[l_ac].amb06) THEN 
              IF g_amb[l_ac].amb05 > g_amb[l_ac].amb06 THEN 
                 CALL cl_err('','amd-018',0)
                 NEXT FIELD amb05
              END IF 
           END IF 
        
        AFTER FIELD amb06
           IF NOT cl_null(g_amb[l_ac].amb05) AND NOT cl_null(g_amb[l_ac].amb06) THEN 
              IF g_amb[l_ac].amb05 > g_amb[l_ac].amb06 THEN 
                 CALL cl_err('','amd-019',0)
                 NEXT FIELD amb06
              END IF 
           END IF         
#TQC-980273 --end--
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
 #MOD-550095
            #INITIALIZE g_amb[l_ac].* TO NULL
            #LET g_amb[l_ac].amb05 = 0
            #LET g_amb[l_ac].amb06 = 0
            IF l_ac > 1 THEN
               LET g_amb[l_ac].* = g_amb[l_ac-1].*
               LET g_amb_t.* = g_amb[l_ac].*          # 新輸入資料
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 #END MOD-550095
 
        AFTER FIELD amb04                          # check 序號是否重複
            IF g_amb[l_ac].amb04 IS NOT NULL AND
               (g_amb[l_ac].amb04 != g_amb_t.amb04 OR
                g_amb_t.amb04 IS NULL) THEN
                SELECT count(*)
                    INTO l_n
                    FROM amb_file
                    WHERE amb01 = g_amb01 AND amb02=g_amb02 AND amb07=g_amb07 AND
                          amb03 = g_amb[l_ac].amb03 AND
			  amb04 = g_amb[l_ac].amb04
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_amb[l_ac].amb03 = g_amb_t.amb03
                    NEXT FIELD amb03
                END IF
            END IF
 
        BEFORE DELETE                            # 是否取消單身
            IF g_amb_t.amb03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM amb_file
                    WHERE amb01 = g_amb01 AND amb02=g_amb02 AND amb07=g_amb07 AND
                          amb03=g_amb_t.amb03 AND amb04 = g_amb_t.amb04
                IF STATUS THEN
            #       CALL cl_err(g_amb_t.amb03,STATUS,0) #No.FUN-660093
                    CALL cl_err3("del","amb_file",g_amb01,g_amb02,STATUS,"","",1)   #No.FUN-660093
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_amb[l_ac].* = g_amb_t.*
               CLOSE i010_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_amb[l_ac].amb03,-263,1)
               LET g_amb[l_ac].* = g_amb_t.*
            ELSE
                UPDATE amb_file SET
                       amb03=g_amb[l_ac].amb03,amb04=g_amb[l_ac].amb04,
                       amb05=g_amb[l_ac].amb05,amb06=g_amb[l_ac].amb06
                 WHERE amb01=g_amb01 
                   AND amb02=g_amb02 
                   AND amb07=g_amb07 
                   AND amb03=g_amb_t.amb03 
                   AND amb04=g_amb_t.amb04
               IF STATUS THEN
             #     CALL cl_err(g_amb[l_ac].amb03,STATUS,0) #No.FUN-660093
                   CALL cl_err3("upd","amb_file",g_amb01,g_amb02,STATUS,"","",1)        #No.FUN-660093
                   LET g_amb[l_ac].* = g_amb_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac     #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_amb[l_ac].* = g_amb_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_amb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE i010_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30032 add
            CLOSE i010_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 #MOD-550095
        ON ACTION CONTROLO
           IF INFIELD(amb03) THEN
              LET g_amb[l_ac].* = g_amb[l_ac-1].*
              NEXT FIELD amb03
           END IF
 #END MOD-550095
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
        
        END INPUT
 
        COMMIT WORK
        CLOSE i010_bcl
END FUNCTION
 
FUNCTION i010_b_askkey()
DEFINE
    l_wc    LIKE type_file.chr1000           #No.FUN-680074 VARCHAR(200)
 
    CONSTRUCT l_wc ON amb03,amb04,amb05,amb06    # 螢幕上取條件
       FROM s_amb[1].amb03,s_amb[1].amb04,s_amb[1].amb05,s_amb[1].amb06
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
    CALL i010_b_fill(l_wc)
END FUNCTION
 
FUNCTION i010_b_fill(p_wc)                       # BODY FILL UP
DEFINE
    p_wc       LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(200)
 
    LET g_sql = "SELECT amb03,amb04,amb05,amb06",
                " FROM amb_file ",
                " WHERE amb01 = ",g_amb01,
		"   AND amb02 = ",g_amb02, 
		"   AND amb07 = ",g_amb07, 
		"   AND ", p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE i010_prepare2 FROM g_sql  
    DECLARE zy_curs CURSOR FOR i010_prepare2
    CALL g_amb.clear()
    LET g_rec_b = 0  
    LET g_cnt = 1
    FOREACH zy_curs INTO g_amb[g_cnt].*    # 單身 ARRAY 填充
        IF STATUS THEN
            CALL cl_err('FOREACH:',STATUS,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('FOREACH:',STATUS,1) END IF
    CALL g_amb.deleteElement(g_cnt)
    LET g_rec_b= g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_amb TO s_amb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i010_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL i010_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL i010_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i010_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i010_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 #MOD-550095
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 #END MOD-550095
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0007
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
     ON ACTION related_document                #No.FUN-6B0079  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 #MOD-550095
FUNCTION i010_copy()
DEFINE
    l_oldno1,l_newno1   LIKE amb_file.amb01,
    l_oldno2,l_newno2   LIKE amb_file.amb02,
    l_oldno3,l_newno3   LIKE amb_file.amb07
 
    IF g_amb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET l_newno1=g_amb01
    LET l_newno2=g_amb02
    LET l_newno3=g_amb07
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno1,l_newno2,l_newno3 WITHOUT DEFAULTS FROM amb01,amb02,amb07
 
        AFTER FIELD amb01
            IF l_newno1 IS NULL THEN
                NEXT FIELD amb01
            END IF
 
        AFTER FIELD amb02
IF l_newno2 IS NULL THEN
                NEXT FIELD amb02
            END IF
 
        AFTER FIELD amb07
            IF l_newno3 IS NULL THEN
                NEXT FIELD amb07
            END IF
            IF l_newno3 < l_newno2 THEN
                 NEXT FIELD amb07
            END IF
 
            SELECT count(*) INTO g_cnt FROM amb_file
                WHERE amb01 = l_newno1 and (amb02 = l_newno2
                      or amb07 = l_newno3)
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno1,-239,0)
               NEXT FIELD amb01
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
        CALL i010_show()
        RETURN
    END IF
 
    DROP TABLE y
    SELECT * FROM amb_file WHERE amb01=g_amb01 and
                                 amb02=g_amb02 and amb07=g_amb07
           INTO TEMP y
    UPDATE y
SET y.amb01=l_newno1,y.amb02=l_newno2,y.amb07=l_newno3     #資料鍵值
    INSERT INTO amb_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
    #  CALL cl_err(l_newno1,SQLCA.sqlcode,0) #No.FUN-660093
       CALL cl_err3("ins","amb_file",l_newno1,l_newno2,SQLCA.sqlcode,"","",1)   #No.FUN-660093
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE 'COPY(',g_cnt USING '<<<<',') Rows O.K'
 
    LET l_oldno1=g_amb01
    LET l_oldno2=g_amb02
    LET l_oldno3=g_amb07
    LET g_amb01=l_newno1
    LET g_amb02=l_newno2
    LET g_amb07=l_newno3
    CALL i010_b()
    #LET g_amb01=l_oldno1  #FUN-C30027
    #LET g_amb02=l_oldno2  #FUN-C30027
    #LET g_amb07=l_oldno3  #FUN-C30027
    CALL i010_show()
END FUNCTION
 #END MOD-550095
 
#NO.FUN-7C0043 --BEGIN--
FUNCTION i010_out()
#DEFINE
#   l_i             LIKE type_file.num5,          #No.FUN-680074 SMALLINT
#   sr              RECORD
#       amb01       LIKE amb_file.amb01,   #發票年
#       amb02       LIKE amb_file.amb02,   #發票月
#       amb03       LIKE amb_file.amb03,   #字軌
#       amb04       LIKE amb_file.amb04,   #格式
#       amb05       LIKE amb_file.amb05,   #起始號碼
#       amb06       LIKE amb_file.amb06,   #結束號碼
#       amb07       LIKE amb_file.amb07    #結束號碼
#                   END RECORD,
#    l_name         LIKE type_file.chr20   #No.FUN-680074 VARCHAR(20) #External(Disk) file namb
 DEFINE   l_cmd      LIKE type_file.chr1000   #NO.FUN-7C0043                                                                        
   #NO.FUN-7C0043 --BEGIN--                                                                                                         
    IF cl_null(g_wc) AND NOT cl_null(g_amb01) AND NOT cl_null(g_amb02) AND NOT cl_null(g_amb07) THEN                                
       LET g_wc = " amb01='",g_amb01,"'AND amb02='",g_amb02,"'AND amb07='",g_amb07,"'"                                              
    END IF                                                                                                                          
    IF cl_null(g_wc) THEN                                                                                                           
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "amdi010" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN                                                                                                                          
   #NO.FUN-7C0043 --END--                                                                                                           
                                 
#   IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
#   CALL cl_wait()
#   CALL cl_outnam('amdi010') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
##    LET g_sql="SELECT amb01,amb02,amb03,amb04,amb05,amb06",
##Thomas 忘了加amb07所以沒有印出偶數月  Wendy modify----
#   LET g_sql="SELECT amb01,amb02,amb03,amb04,amb05,amb06,amb07",
#             " FROM amb_file ",
#             " WHERE ",g_wc CLIPPED
#   PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i010_curo                         # SCROLL CURSOR
#        CURSOR FOR i010_p1
 
#   START REPORT i010_rep TO l_name
 
#   FOREACH i010_curo INTO sr.*
#       IF STATUS THEN
#           CALL cl_err('foreach:',STATUS,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i010_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i010_rep
 
#   CLOSE i010_curo
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#
#REPORT i010_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680074 VARCHAR(1)
#   str             STRING,                #No.FUN-680074
#   sr              RECORD
#       amb01       LIKE amb_file.amb01,   #發票年
#       amb02       LIKE amb_file.amb02,   #發票月
#       amb03       LIKE amb_file.amb03,   #字軌
#       amb04       LIKE amb_file.amb04,   #格式
#       amb05       LIKE amb_file.amb05,   #起始號碼
#       amb06       LIKE amb_file.amb06,   #結束號碼
#       amb07       LIKE amb_file.amb07    #結束號碼
#   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.amb01,sr.amb02,sr.amb03
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN g_c[31],g_company
#           PRINT COLUMN g_c[33],g_x[1] CLIPPED
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED, pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       BEFORE GROUP OF sr.amb01  
#           PRINT COLUMN g_c[31],sr.amb01 USING '####';
#       BEFORE GROUP OF sr.amb02  
#           LET str = sr.amb02 USING '##','~',sr.amb07 USING '##'
#           PRINT COLUMN g_c[32],str;
#       ON EVERY ROW
#           PRINT COLUMN g_c[33],sr.amb03,
#                 COLUMN g_c[34],sr.amb04,
#                 COLUMN g_c[35],sr.amb05 USING '&&&&&&&&',
#                 COLUMN g_c[36],sr.amb06 USING '&&&&&&&&'
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
##           PRINT COLUMN g_c[31],g_x[4] CLIPPED,COLUMN g_c[35],g_x[7] CLIPPED   #No.TQC-710009 mark
#            PRINT COLUMN g_c[31],g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-710009
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
##               PRINT COLUMN g_c[31],g_x[4] CLIPPED,COLUMN g_c[35],g_x[6] CLIPPED   #No.TQC-710009 mark
#                PRINT COLUMN g_c[31],g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-710009
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-7C0043 --END--
 
#No.FUN-570108 --start                                                          
FUNCTION i010_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680074 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("amb01,amb02,amb07",TRUE)                           
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i010_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680074 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("amb01,amb02,amb07",FALSE)                          
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
#No.FUN-570108 --end               
