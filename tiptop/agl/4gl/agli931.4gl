# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli931.4gl
# Descriptions...: 現金流量表活動科目設定 
# Date & Author..: 01/02/01  Wiky  
# Modify.........: 01/02/13  Mandy
# Modify.........: 01/02/13  Mandy
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-510007 05/02/15 By Nicola 報表架構修改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By bnlent   會計科目加帳套BUG修改，解決q_aag開窗無資料
# Modify.........: No.MOD-740269 07/04/24 By johnray 帳套修改,修正單身錄入問題
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830113 08/03/26 By Sunyanchun  老報表該CR
# Modify.........: No.MOD-840537 08/04/23 By Smapmin 增加帳別與群組代號合理性檢查
# Modify.........: No.FUN-920176 09/05/08 BY ve007 依據FUN-920122更改報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-950051 09/10/30 By yiting 由于agli002單頭增加"獨立會科合并"欄位,對檢查會科方式修改
#                                                  2.單身科目gis02開窗，以單頭營運中心DB+帳別gis00開窗資料，AFTER FIELD檢查時亦同  
#                                                  3.aag02要跨db抓取顯示                                                                                 
# Modify.........: No:FUN-920121 09/11/02 by yiting 1.單頭欄位異動 
#                                                  2.單身科目gis02開窗，以單頭營運中心DB+帳別gis00開窗資料，AFTER FIELD檢查時亦同  
#                                                  3.aag02要跨db抓取顯示                                                                                 
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:CHI-A60013 10/07/27 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 合并帐别/合并资料库的抓法改为CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No.TQC-AB0040 10/11/12 By yinhy 增加"更改"功能，恢復"刪除"功能
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數檔改為aaw_file
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60230 11/06/14 By yinhy 修改群組編號gis01開窗
# Modify.........: No.MOD-B60185 11/06/22 By Polly 修正「查詢」科目編號開窗後，按確認或放棄，程式會被關掉
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_gis00         LIKE gis_file.gis00,   #No.FUN-740020
    g_gis01         LIKE gis_file.gis01,   #活動類別(假單頭)
    g_gis00_t       LIKE gis_file.gis00,   #活動類別(舊值)  #No.FUN-740020
    g_gis01_t       LIKE gis_file.gis01,   #活動類別(舊值)
    g_gis05        LIKE gis_file.gis05,       #FUN-920121 add
    g_gis05_t      LIKE gis_file.gis05,       #FUN-920121 add
    g_gis06        LIKE gis_file.gis06,       #FUN-920121 add
    g_gis06_t      LIKE gis_file.gis06,       #FUN-920121 add
    g_axz05        LIKE axz_file.axz05,       #FUN-920121 add
    g_gis_lock      RECORD LIKE gis_file.*,   #TQC-AB0040 add
    g_gis           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gis02       LIKE gis_file.gis02,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        gis03       LIKE gis_file.gis03,   #加減項
        gis04       LIKE gis_file.gis04    #異動別
                    END RECORD,
    g_gis_t         RECORD                 #程式變數 (舊值)
        gis02       LIKE gis_file.gis02,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        gis03       LIKE gis_file.gis03,   #加減項
        gis04       LIKE gis_file.gis04    #異動別
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166     
    g_sql_tmp           STRING,        #No.FUN-740020
    g_rec_b         LIKE type_file.num5,    #單身筆數               #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT    #No.FUN-680098 SMALLINT
DEFINE g_str        STRING     #No.FUN-830113 
DEFINE g_dbs_axz03         LIKE type_file.chr21      #FUN-920121 add
DEFINE g_plant_axz03       LIKE type_file.chr21      #FUN-A30122 add
DEFINE   l_sql                 STRING                                                 
DEFINE   l_table               STRING     

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680098 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098   INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098   SMALLINT
 
MAIN
DEFINE
   p_row,p_col     LIKE type_file.num5                 #開窗的位置        #No.FUN-680098 SMALLINT
 
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
  
   LET g_sql = "gis00.gis_file.gis00,",
               "gis01.gis_file.gis01,",
               "gis02.gis_file.gis02,",
               "gis05.gis_file.gis05,",
               "gis06.gis_file.gis06,",
               "axz02.axz_file.axz02,",
               "axz03.axz_file.axz03,",
               "aag02.aag_file.aag02,",
               "gis03.gis_file.gis03,", 
               "gis04.gis_file.gis04,",
               "gir02.gir_file.gir02,"
   LET l_table = cl_prt_temptable('agli931',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?) "                                    
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                 
 
    LET p_row = ARG_VAL(2)     #No.MOD-4C0171                 #取得螢幕位置
    LET p_col = ARG_VAL(3)     #No.MOD-4C0171
   LET g_gis01      = NULL                #清除鍵值
   LET g_gis01_t    = NULL
   LET g_gis00      = NULL                #清除鍵值
   LET g_gis00_t    = NULL
    LET g_gis05   = NULL                      #FUN-920121 add
    LET g_gis05_t = NULL                      #FUN-920121 add
    LET g_gis06   = NULL                      #FUN-920121 add
    LET g_gis06_t = NULL                      #FUN-920121 add
    LET g_gis00   = NULL                      #FUN-920121 add
    LET g_gis00_t = NULL                      #FUN-920121 add

   LET p_row = 3 LET p_col = 14
       
   OPEN WINDOW i931_w AT p_row,p_col      #顯示畫面
     WITH FORM "agl/42f/agli931"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
   #No.TQC-AB0040  --Begin 
   LET g_forupd_sql =" SELECT * FROM gis_file ",
                      " WHERE gis00 = ? AND gis01 = ? AND gis05 = ? AND gis06= ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
   DECLARE i931_cl CURSOR FROM g_forupd_sql
   #No.TQC-AB0040  --End
 
   CALL i931_menu()
   CLOSE WINDOW i931_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i931_cs()
   CLEAR FORM                                   #清除畫面
      CALL g_gis.clear()
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
   INITIALIZE g_gis00 TO NULL    #No.FUN-750051
   INITIALIZE g_gis01 TO NULL    #No.FUN-750051
   INITIALIZE g_gis05 TO NULL    #FUN-920121 add
   INITIALIZE g_gis06 TO NULL    #FUN-920121 add
   INITIALIZE g_gis00 TO NULL    #FUN-920121 add

   CONSTRUCT g_wc ON gis05,gis06,gis00,gis01,gis02,gis03,gis04                    #螢幕上取條件                  
                FROM gis05,gis06,gis00,gis01,s_gis[1].gis02,
                     s_gis[1].gis03,s_gis[1].gis04                 
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION controlp                 # 沿用所有欄位
         CASE
          WHEN INFIELD(gis00)                                                                                                       
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.state = "c"                                                                                             
             LET g_qryparam.form ="q_aaa"                                                                                           
             CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
             DISPLAY g_qryparam.multiret TO gis00                                                                                   
             NEXT FIELD gis00                                                                                                       
            WHEN INFIELD(gis01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               #LET g_qryparam.form ="q_gir" #No.TQC-B60230
               LET g_qryparam.form ="q_gir1" #No.TQC-B60230
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gis01
               NEXT FIELD gis01 
            WHEN INFIELD(gis02)
               CALL q_m_aag2(TRUE,TRUE,g_plant_new,g_gis[1].gis02,'23',g_gis00)    #FUN-920025 mod  #No.MOD-480092  #No.FUN-730070#TQC-9C0099
                   #RETURNING g_gis[1].gis02                                       #MOD-B60185 mark
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gis02
              #CALL i931_gis()                     #MOD-B60185 mark
               NEXT FIELD gis02
              WHEN INFIELD(gis05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gis05
                 NEXT FIELD gis05
              WHEN INFIELD(gis06)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axz"      
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gis06  
                 NEXT FIELD gis06
            OTHERWISE
               EXIT CASE
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
 
   
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
   LET g_sql="SELECT UNIQUE gis00,gis01,gis05,gis06 FROM gis_file ", # 組合出SQL 指令,看gis01有幾種就run幾次 #FUN-920121 mod  #No.FUN-740020
             " WHERE ", g_wc CLIPPED,
             " ORDER BY 1"
   PREPARE i931_prepare FROM g_sql              #預備一下
   DECLARE i931_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i931_prepare
   DROP TABLE x      #No.TQC-AB0040 add                                              #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE gis00,gis01,gis05,gis06 FROM gis_file ", #FUN-920121 mod                                                          
                  " WHERE ",g_wc CLIPPED,                                                                                           
                  "   INTO TEMP x"                                                                                                  
   #DROP TABLE x      #No.TQC-AB0040 mark                                                                                                               
   PREPARE i931_pre_x FROM g_sql_tmp                                                                                   
   EXECUTE i931_pre_x                                                                                                               
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                             
   PREPARE i931_precount FROM g_sql
   DECLARE i931_count CURSOR FOR i931_precount
END FUNCTION
 
FUNCTION i931_menu()
 
   WHILE TRUE
      CALL i931_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i931_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i931_q()
            END IF
#TQC-AB0040  --Begin
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i931_r()
           END IF
        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i931_u()
            END IF
#TQC-AB0040  --End
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i931_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i931_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_gis00 IS NULL OR g_gis01 IS NOT NULL THEN  #No.FUN-740020
                  LET g_doc.column1 = "gis01"
                  LET g_doc.value1 = g_gis01
                  LET g_doc.column2 = "gis05"
                  LET g_doc.value2 = g_gis05
                  LET g_doc.column3 = "gis06"
                  LET g_doc.value3 = g_gis06
                  LET g_doc.column4 = "gis00"
                  LET g_doc.value4 = g_gis00
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gis),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
#No.TQC-AB0040  --Begin
FUNCTION i931_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_gis01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gis00_t = g_gis00
   LET g_gis01_t = g_gis01
   LET g_gis05_t = g_gis05
   LET g_gis06_t = g_gis06
   BEGIN WORK

   OPEN i931_cl USING g_gis00,g_gis01,g_gis05,g_gis06
   IF STATUS THEN
      CALL cl_err("OPEN i931_cl:", STATUS, 1)
      CLOSE i931_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i931_cl INTO g_gis_lock.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_gis01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i931_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL i931_show()
   WHILE TRUE
      LET g_gis00_t = g_gis00
      LET g_gis01_t = g_gis01
      LET g_gis05_t = g_gis05
      LET g_gis06_t = g_gis06
      CALL i931_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gis00 = g_gis00_t
         LET g_gis01 = g_gis01_t
         LET g_gis05 = g_gis05_t
         LET g_gis06 = g_gis06_t
         DISPLAY g_gis00,g_gis01,g_gis05,g_gis06 TO gis00,gis01,gis05,gis06
         LET INT_FLAG = 0
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE gis_file SET gis00 = g_gis00,gis01 = g_gis01,gis05 = g_gis05,gis06 = g_gis06
       WHERE gis00 = g_gis00_t
         AND gis01 = g_gis01_t
         AND gis05 = g_gis05_t
         AND gis06 = g_gis06_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","gis_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE i931_cl
   COMMIT WORK
   CALL i931_show()
   CALL i931_b_fill("1=1")
END FUNCTION
#No.TQC-AB0040  --End 
#Add  輸入
FUNCTION i931_a()
DEFINE   l_n    LIKE type_file.num5          #No.FUN-680098 SMALLINT
   
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
      CALL g_gis.clear()
   INITIALIZE g_gis01 LIKE gis_file.gis01
   LET g_gis01_t = NULL
   INITIALIZE g_gis00 LIKE gis_file.gis00
   LET g_gis00_t = NULL
   INITIALIZE g_gis05 LIKE gis_file.gis05      #DEFAULT 設定  
   INITIALIZE g_gis06 LIKE gis_file.gis06      #DEFAULT 設定  
   LET g_gis05_t = NULL
   LET g_gis06_t = NULL

   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i931_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_gis.clear()
      SELECT COUNT(*) INTO l_n FROM gis_file WHERE gis01=g_gis01
                                               AND gis00=g_gis00 #No.FUN-740020
                                               AND gis05=g_gis05 #FUN-920121 add #No.FUN-740020
                                               AND gis06=g_gis06 #FUN-920121 add #No.FUN-740020
      LET g_rec_b = 0                    #No.FUN-680064
      IF l_n > 0 THEN
         CALL i931_b_fill('1=1')
      END IF
      CALL i931_b()                             #輸入單身
      LET g_gis00_t = g_gis00                   #保留舊值 #No.FUN-740020
      LET g_gis01_t = g_gis01                   #保留舊值
      LET g_gis05_t = g_gis05                   #保留舊值 #FUN-920121 add
      LET g_gis06_t = g_gis06                   #保留舊值 #FUN-920121 add
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i931_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
   l_cnt           LIKE type_file.num5,          #MOD-840537
   l_n1,l_n        LIKE type_file.num5          #FUN-920121 add
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
   INPUT g_gis05,g_gis06,g_gis00,g_gis01 WITHOUT DEFAULTS FROM gis05,gis06,gis00,gis01 #FUN-920121 mod  #No.FUN-740020
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i931_set_entry(p_cmd)
         CALL i931_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD gis00 
         LET l_cnt = 0
         LET g_sql = "SELECT COUNT(*) ",
                    #"  FROM ",g_dbs_axz03,"aaa_file",  #FUN-A50102
                     "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                     " WHERE aaa01 = '",g_gis00,"'",
                     "   AND aaaacti = 'Y' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102 
         PREPARE i931_pre_2 FROM g_sql
         DECLARE i931_cur_2 CURSOR FOR i931_pre_2
         OPEN i931_cur_2
         FETCH i931_cur_2 INTO l_cnt
         IF l_cnt = 0 THEN
            CALL cl_err('','agl-095',0)   
            NEXT FIELD gis00
         END IF
 
      AFTER FIELD gis01                  #設定活動類別
         IF NOT cl_null(g_gis01) THEN
            CALL i931_gis01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)   #MOD-840537
               NEXT FIELD gis01
            END IF
         END IF
 
      AFTER FIELD gis05   #族群代號
         IF cl_null(g_gis05) THEN
            CALL cl_err(g_gis05,'mfg0037',0)
            NEXT FIELD gis05
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_gis05
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_gis05,'agl-223',0)
               NEXT FIELD gis05
            END IF
         END IF

      AFTER FIELD gis06 
         IF NOT cl_null(g_gis06) THEN 
               CALL i931_gis06('a',g_gis06,g_gis05)  #FUN-950051 add gis05
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gis06,g_errno,0)
                  NEXT FIELD gis06
               END IF
            IF g_gis05 IS NOT NULL AND g_gis06 IS NOT NULL AND
               g_gis00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_gis05 AND axa02=g_gis06
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_gis05 AND axb04=g_gis06
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_gis06,'agl-223',0)
                  LET g_gis05 = g_gis05_t
                  LET g_gis06 = g_gis06_t
                  LET g_gis00 = g_gis00_t
                  DISPLAY BY NAME g_gis05,g_gis06,g_gis00
                  NEXT FIELD gis06
               END IF
            END IF
         END IF 
         
     #No.TQC-AB0040  --Begin
     AFTER INPUT
        IF g_gis05 IS NOT NULL AND g_gis06 IS NOT NULL AND
               g_gis00 IS NOT NULL THEN
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_gis05 AND axa02=g_gis06
                  AND axa03=g_axz05
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_gis05 AND axb04=g_gis06
                  AND axb05=g_axz05
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_gis06,'agl-223',0)
                  LET g_gis05 = g_gis05_t
                  LET g_gis06 = g_gis06_t
                  LET g_gis00 = g_gis00_t
                  DISPLAY BY NAME g_gis05,g_gis06,g_gis00
                  NEXT FIELD gis05
               END IF
            END IF
     #No.TQC-AB0040  --End
      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(gis00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_gis00
               CALL cl_create_qry() RETURNING g_gis00
               DISPLAY BY NAME g_gis00
               NEXT FIELD gis00 
            WHEN INFIELD(gis01)
               CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_gir"  #No.TQC-B60230
               LET g_qryparam.form ="q_gir1"  #No.TQC-B60230
               LET g_qryparam.default1 = g_gis01
               CALL cl_create_qry() RETURNING g_gis01
               DISPLAY BY NAME g_gis01
               NEXT FIELD gis01 
            WHEN INFIELD(gis05) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_gis05
               CALL cl_create_qry() RETURNING g_gis05
               DISPLAY g_gis05 TO gis05
               NEXT FIELD gis05
            WHEN INFIELD(gis06)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"    
               LET g_qryparam.default1 = g_gis06
               CALL cl_create_qry() RETURNING g_gis06
               DISPLAY g_gis06 TO gis06 
               NEXT FIELD gis06
            OTHERWISE
               EXIT CASE
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
END FUNCTION
 
FUNCTION i931_gis01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
   l_gir02    LIKE gir_file.gir02,
   l_gir04    LIKE gir_file.gir04           #TQC-B60230
 
   LET g_errno=''
   SELECT gir02,gir04 INTO l_gir02,l_gir04                   #TQC-B60230
     FROM gir_file
     WHERE gir01=g_gis01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917'
                                LET l_gir02=NULL
       WHEN l_gir04='N'         LET g_errno='agl1005'    #TQC-B60230
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
 
     DISPLAY l_gir02 TO FORMONLY.gir02 
   END IF
END FUNCTION
#Query 查詢
FUNCTION i931_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gis00,g_gis01 TO NULL    #No.FUN-6B0040  #No.FUN-740020
    INITIALIZE g_gis05 TO NULL            #FUN-920121 add                      
    INITIALIZE g_gis06 TO NULL            #FUN-920121 add                      
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i931_cs()                         #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i931_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_gis00,g_gis01 TO NULL  #No.FUN-740020
      INITIALIZE g_gis05 TO NULL            #FUN-920121 add                      
      INITIALIZE g_gis06 TO NULL            #FUN-920121 add                      
   ELSE
      CALL i931_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN i931_count
      FETCH i931_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i931_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i931_b_cs INTO g_gis00,g_gis01,g_gis05,g_gis06  #FUN-920121 add g_gis05,g_gis06
       WHEN 'P' FETCH PREVIOUS i931_b_cs INTO g_gis00,g_gis01,g_gis05,g_gis06  #FUN-920121 add g_gis05,g_gis06
       WHEN 'F' FETCH FIRST    i931_b_cs INTO g_gis00,g_gis01,g_gis05,g_gis06  #FUN-920121 add g_gis05,g_gis06
       WHEN 'L' FETCH LAST     i931_b_cs INTO g_gis00,g_gis01,g_gis05,g_gis06  #FUN-920121 add g_gis05,g_gis06
       WHEN '/' 
            IF (NOT mi_no_ask) THEN
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
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i931_b_cs INTO g_gis00,g_gis01,g_gis05,g_gis06  #FUN-920121 mod
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_gis01,SQLCA.sqlcode,0)
      INITIALIZE g_gis01 TO NULL  #TQC-6B0105
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
 
   CALL i931_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i931_show()
   DISPLAY g_gis00 TO gis00               #單頭 #No.FUN-740020
   DISPLAY g_gis01 TO gis01               #單頭
   DISPLAY g_gis05 TO gis05               #FUN-920121 add
   DISPLAY g_gis06 TO gis06               #FUN-920121 add

   CALL i931_gis06('d',g_gis06,g_gis05)           #FUN-920121 add  #FUN-950051 add gis05
   CALL i931_gis01('d')
   CALL i931_b_fill(g_wc)                 #單身

   CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i931_r()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_gis01 IS NULL THEN
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "gis01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_gis01       #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "gis05"      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_gis05       #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "gis06"      #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_gis06       #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "gis00"      #No.FUN-9B0098 10/02/24
       LET g_doc.value4 = g_gis00       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM gis_file WHERE gis00 = g_gis00  #No.FUN-740020
                             AND gis01 = g_gis01
                             AND gis05 = g_gis05  #FUN-920121 add
                             AND gis06 = g_gis06  #FUN-920121 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gis_file",g_gis01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123 #No.FUN-740020
      ELSE
         CLEAR FORM
         CALL g_gis.clear()
         LET g_gis00 = NULL   #No.FUN-740020
         LET g_gis01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i931_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i931_b_cs
            CLOSE i931_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         FETCH i931_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i931_b_cs
            CLOSE i931_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i931_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i931_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i931_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i931_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
   l_n             LIKE type_file.num5,     #檢查重複用       #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否       #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,     #處理狀態         #No.FUN-680098 VARCHAR(1)
   l_gis_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW   #No.FUN-680098  VARCHAR(1)
   l_chr           LIKE type_file.chr1,     #No.FUN-680098    VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,     #可新增否         #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5      #可刪除否         #No.FUN-680098 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF g_gis00 IS NULL OR g_gis01 IS NULL THEN  #No.FUN-740020
       RETURN
   END IF
 
   CALL cl_opmsg('b')                #單身處理的操作提示
 
   LET g_forupd_sql = "SELECT gis02,'',gis03,gis04 FROM gis_file",
                      " WHERE gis00 = ? AND gis01=? AND gis02=? AND gis05=? AND gis06=? FOR UPDATE"  #FUN-920121 mod  #No.FUN-740020
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i931_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_gis WITHOUT DEFAULTS FROM s_gis.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
   
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'                   
            LET g_gis_t.* = g_gis[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i931_bcl USING g_gis00,g_gis01,g_gis_t.gis02,g_gis05,g_gis06     #FUN-920121 mod  #No.MOD-740269
            IF STATUS THEN
               CALL cl_err("OPEN i931_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i931_bcl INTO g_gis_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock gis',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gis[l_ac].* TO NULL         #900423
         INITIALIZE g_gis_t.* TO NULL  
         IF l_ac > 1 THEN
            LET g_gis[l_ac].gis03 = g_gis[l_ac-1].gis03
            LET g_gis[l_ac].gis04 = g_gis[l_ac-1].gis04
         END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gis02
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO gis_file (gis00,gis01,gis02,gis03,gis04,gis05,gis06)  
                         VALUES(g_gis00,g_gis01,g_gis[l_ac].gis02,g_gis[l_ac].gis03,  
                                g_gis[l_ac].gis04,g_gis05,g_gis06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gis_file",g_gis01,g_gis[l_ac].gis02,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #No.FUN-740020
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      AFTER FIELD gis02
         IF NOT cl_null(g_gis[l_ac].gis02) THEN
            CALL i931_gis()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_gis[l_ac].gis02,'23',g_gis00)    
                    RETURNING g_gis[l_ac].gis02
               #FUN-B20004--end               
               NEXT FIELD gis02
            END IF
         END IF
         IF g_gis[l_ac].gis02 != g_gis_t.gis02 OR
            cl_null(g_gis_t.gis02) THEN
            SELECT COUNT(*) INTO l_n FROM gis_file
             WHERE gis02 = g_gis[l_ac].gis02 
            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD gis02
               END IF
            END IF
            SELECT count(*) INTO l_n FROM gis_file 
             WHERE gis01 = g_gis01 AND gis02 = g_gis[l_ac].gis02
               AND gis00 = g_gis00  #No.FUN-740020
            IF l_n <> 0 THEN
               LET g_gis[l_ac].gis02 = g_gis_t.gis02
               CALL cl_err('','-239',0) 
               NEXT FIELD gis02
            END IF
         END IF
   
      AFTER FIELD gis03
         IF NOT cl_null(g_gis[l_ac].gis03) THEN
            IF g_gis[l_ac].gis03 NOT MATCHES '[-+]' THEN 
               NEXT FIELD gis03 
            END IF
         END IF
   
      AFTER FIELD gis04
         IF NOT cl_null(g_gis[l_ac].gis04) THEN
            IF g_gis[l_ac].gis04 NOT MATCHES '[123456]' THEN
               NEXT FIELD gis04
            END IF 
         END IF
   
      BEFORE DELETE                                    #modify:Mandy
         #判斷是否可以刪除此ROW,因為此ROW可能和其它file有key值的關聯性,
         #所以不能隨便亂刪掉
         CALL i931_gis_delyn() RETURNING l_gis_delyn 
         IF g_gis_t.gis02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN   #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_gis_delyn = 'N ' THEN   #為不可刪除此ROW的狀態下
               #人工輸入金額設定作業中此ROW已被使用,不可刪除!!
               CALL cl_err(g_gis_t.gis02,'agl-918',0) 
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gis_file WHERE gis00 = g_gis00  #No.FUN-740020
                                   AND gis01 = g_gis01 AND gis02 = g_gis_t.gis02 
                                   AND gis05 = g_gis05  #FUN-920121 add                           
                                   AND gis06 = g_gis06  #FUN-920121 add                         
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gis_file",g_gis01,g_gis_t.gis02,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #No.FUN-740020
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gis[l_ac].* = g_gis_t.*
            CLOSE i931_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gis[l_ac].gis02,-263,1)
            LET g_gis[l_ac].* = g_gis_t.*
         ELSE
            UPDATE gis_file SET gis02 = g_gis[l_ac].gis02,
                                gis03 = g_gis[l_ac].gis03,
                                gis04 = g_gis[l_ac].gis04 
             WHERE gis00=g_gis00  #No.FUN-740020
               AND gis01=g_gis01 AND gis02=g_gis_t.gis02
               AND gis05=g_gis05   #FUN-920121 add                        
               AND gis06=g_gis06   #FUN-920121 add                     
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gis_file",g_gis01,g_gis_t.gis02,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-740020
               LET g_gis[l_ac].* = g_gis_t.*
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
               LET g_gis[l_ac].* = g_gis_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_gis.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i931_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i931_bcl
         COMMIT WORK
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gis02) AND l_ac > 1 THEN
            LET g_gis[l_ac].* = g_gis[l_ac-1].*
            NEXT FIELD gis02
         END IF
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
   
      ON ACTION CONTROLG
         CALL cl_cmdask()
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(gis02)
               CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_gis[l_ac].gis02,'23',g_gis00)    #FUN-920025 mod  #No.MOD-480092  #No.FUN-730070#TQC-9C0099
                    RETURNING g_gis[l_ac].gis02
               DISPLAY g_qryparam.multiret TO gis02 
               NEXT FIELD gis02
            OTHERWISE
               EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
   END INPUT
 
   CLOSE i931_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i931_gis()
DEFINE 
   l_gisacti    LIKE aag_file.aagacti    #No.FUN-680098 VARCHAR(1)
 
   LET g_errno = ' '

   LET g_sql = "SELECT aag02,aagacti  ",
              #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'), #FUN-A50102
               " WHERE aag01 = '",g_gis[l_ac].gis02,"'",
               "   AND aag00 = '",g_gis00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE i931_pre FROM g_sql
   DECLARE i931_cur CURSOR FOR i931_pre
   OPEN i931_cur
   FETCH i931_cur INTO g_gis[l_ac].aag02,l_gisacti

   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
        WHEN l_gisacti = 'N'     LEt g_errno = '9028'
        OTHERWISE
   END CASE
END FUNCTION
 
FUNCTION i931_gis_delyn()
DEFINE 
   l_delyn       LIKE type_file.chr1,      #存放可否刪除的變數  #No.FUN-680098   VARCHAR(1)   
   l_n           LIKE type_file.num5          #No.FUN-680098 SMALLINT
   
   LET l_delyn = 'Y'
 
   SELECT COUNT(*)  INTO l_n FROM git_file 
    WHERE git01 = g_gis01
      AND git02 = g_gis[l_ac].gis02 
      AND gis00 = g_gis00  #No.FUN-740020
   IF l_n > 0 THEN 
      LET l_delyn = 'N'
   END IF
   RETURN l_delyn
END FUNCTION
 
FUNCTION i931_b_askkey()
   CLEAR FORM
   CALL g_gis.clear()
   CONSTRUCT g_wc2 ON gis05,gis06,gis00,gis01,gis02,gis03,gis04   #螢幕上取條件 
                 FROM gis05,gis06,gis00,gis01,s_gis[1].gis02,s_gis[1].gis03,s_gis[1].gis04 

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL i931_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i931_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,             #TQC-630166   
   l_flag          LIKE type_file.chr1,              #有無單身筆數        #No.FUN-680098 VARCHAR(1)
   l_sql           STRING        #TQC-630166        
 
   LET l_sql = "SELECT gis02,aag02,gis03,gis04 ",
               "  FROM gis_file,OUTER aag_file",   #FUN-920121 mod
               " WHERE gis01 = '",g_gis01,"'",
               "   AND gis00 = '",g_gis00,"'",   #No.FUN-740020
               "   AND gis05 = '",g_gis05,"'",   #No.FUN-920121  add
               "   AND gis06 = '",g_gis06,"'",   #No.FUN-920121  add
               "   AND gis00 = aag00 ",          #No.MOD-740269
               "   AND gis02 = aag01 AND ",p_wc CLIPPED,
               " ORDER BY gis02"
 
   PREPARE gis_pre FROM l_sql
   DECLARE gis_cs CURSOR FOR gis_pre
 
   CALL g_gis.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH gis_cs INTO g_gis[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_gis[g_cnt].aag02=i931_set_gis02(g_gis[g_cnt].gis02) #FUN-920121 add
      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gis.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i931_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gis TO s_gis.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
#No.TQC-AB0040  --Begin
     ON ACTION delete
        LET g_action_choice="delete"
        EXIT DISPLAY
     ON ACTION modify
        LET g_action_choice="modify"
        EXIT DISPLAY
#No.TQC-AB0040  --End
      ON ACTION first 
         CALL i931_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i931_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i931_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i931_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i931_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
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
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i931_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("gis00,gis01",TRUE)  #No.FUN-740020
    END IF 
 
END FUNCTION
 
FUNCTION i931_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("gis00,gis01",FALSE) #No.FUN-740020
    END IF 
    CALL cl_set_comp_entry("gis00",FALSE) #FUN-920121 add
 
END FUNCTION

FUNCTION  i931_gis06(p_cmd,p_gis06,p_gis05)   #FUN-950051 add gis05  
DEFINE p_cmd           LIKE type_file.chr1,         
       p_gis06         LIKE gis_file.gis06,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
       #l_aaz641        LIKE aaz_file.aaz641,   #FUN-B50001 
       l_aaw01         LIKE aaw_file.aaw01,    
       l_axa09         LIKE axa_file.axa09,    #FUN-950051
       p_gis05         LIKE gis_file.gis05     #FUN-950051

    LET g_errno = ' '

   #FUN-A30122 --------------------------------mod start----------------------------
   #SELECT axa09 INTO l_axa09 FROM axa_file
   # WHERE axa01 = p_gis05   #族群
   #   AND axa02 = p_gis06   #公司編號
   #   SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05 
   #     FROM axz_file
   #    WHERE axz01 = p_gis06
   #IF l_axa09 = 'Y' THEN
   #
   #   LET g_plant_new = l_axz03      #營運中心
   #   CALL s_getdbs()
   #   LET g_dbs_axz03 = g_dbs_new    #所屬DB
    SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05
      FROM axz_file  
     WHERE axz01 = p_gis06 
   #  #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file", #FUN-A50102 #FUN-A50102
   #   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102   
   #               " WHERE aaz00 = '0'"
   #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
   #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   #   PREPARE i931_pre_1 FROM g_sql
   #   DECLARE i931_cur_1 CURSOR FOR i931_pre_1
   #   OPEN i931_cur_1
   #   FETCH i931_cur_1 INTO l_aaz641    #合併後帳別
   #   IF cl_null(l_aaz641) THEN
   #       CALL cl_err(l_axz03,'agl-601',1)
   #   END IF
   #ELSE
   #   LET g_plant_new = g_plant   #TQC-9C0099
   #   LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)   
   #   SELECT aaz641 INTO l_aaz641 FROM aaz_file WHERE aaz00 = '0'
   #END IF
   #FUN-A30122 -----------------------mod end-----------------------------------
    CALL s_aaz641_dbs(p_gis05,p_gis06) RETURNING g_plant_axz03       #FUN-A30122  add              
    #CALL s_get_aaz641(g_plant_axz03) RETURNING l_aaz641                #FUN-A30122  add   #FUN-B50001
    CALL s_get_aaz641(g_plant_axz03) RETURNING l_aaw01
    LET g_plant_new = g_plant_axz03                                  #FUN-A30122 add
    SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01 = p_gis06 
    #LET g_gis00 = l_aaz641   #FUN-B50001 
    LET g_gis00 = l_aaw01
    LET g_axz05 = l_axz05

    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'agl-988'          #TQC-970018
          LET l_axz02 = NULL
          LET l_axz03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_axz02 TO FORMONLY.axz02 
       DISPLAY l_axz03 TO FORMONLY.axz03                                          
       DISPLAY g_gis00 TO FORMONLY.gis00 
    END IF

END FUNCTION

FUNCTION i931_set_gis02(p_gis02)
   DEFINE l_aag02 LIKE aag_file.aag02
   DEFINE p_gis02 LIKE gis_file.gis02
   IF cl_null(p_gis02) THEN RETURN NULL END IF
   LET l_aag02=''

   LET g_sql = "SELECT aag02 ",
              #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
               "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
               " WHERE aag01 = '",p_gis02,"'",
               "   AND aag00 = '",g_gis00,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE i931_pre_3 FROM g_sql
   DECLARE i931_cur_3 CURSOR FOR i931_pre_3
   OPEN i931_cur_3
   FETCH i931_cur_3 INTO l_aag02

   RETURN l_aag02
END FUNCTION

FUNCTION i931_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    sr              RECORD
        gis00       LIKE gis_file.gis00,   #No.FUN-740020   
        gis01       LIKE gis_file.gis01,   
        gis02       LIKE gis_file.gis02,   
        aag02       LIKE aag_file.aag02,   
        gis03       LIKE gis_file.gis03,   
        gis04       LIKE gis_file.gis04,   
        gir02       LIKE gir_file.gir02   
                    END RECORD,
    l_name          LIKE type_file.chr20               #External(Disk) file name        #No.FUN-680098  VARCHAR(20)
DEFINE
    l_gis         RECORD
      gis00       LIKE gis_file.gis00,     
      gis01       LIKE gis_file.gis01,   
      gis02       LIKE gis_file.gis02,
      gis05       LIKE gis_file.gis05,
      gis06       LIKE gis_file.gis06,
      axz02       LIKE axz_file.axz02,
      axz03       LIKE axz_file.axz03,   
      aag02       LIKE aag_file.aag02,   
      gis03       LIKE gis_file.gis03,   
      gis04       LIKE gis_file.gis04,   
      gir02       LIKE gir_file.gir02
                  END RECORD,
      l_azp03     LIKE type_file.chr20,
      l_sql       STRING
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog   #NO.FUN-920176
     CALL cl_del_data(l_table)  
 
     LET g_sql = "SELECT gis00,gis01,gis02,gis05,gis06,axz02,axz03,'',gis03,gis04,gir02 ",
                 " FROM gis_file ",
                 " LEFT OUTER JOIN gir_file ON gir01 = gis01 ",
                 " LEFT OUTER JOIN axz_file ON axz01 = gis06 ",
                 " WHERE ",g_wc CLIPPED
     PREPARE i931_p1 FROM g_sql
     DECLARE i931_p2 CURSOR FOR i931_p1
     FOREACH i931_p2 INTO l_gis.*
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_gis.axz03

          #LET l_sql = "SELECT aag02 FROM ",s_dbstring(l_azp03 CLIPPED),"aag_file WHERE aag00 ='",l_gis.gis00,"' AND", #FUN-A50102
          LET l_sql = "SELECT aag02 FROM ",cl_get_target_table(l_gis.axz03,'aag_file'), #FUN-A50102
                      " WHERE aag00 ='",l_gis.gis00,"' AND",   #FUN-A50102
                      " aag01 = '",l_gis.gis02 ,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql #CHI-A60013 add 
          CALL cl_parse_qry_sql(l_sql,l_gis.axz03) RETURNING l_sql   #FUN-A50102 
          PREPARE aag_sel FROM l_sql
          EXECUTE aag_sel INTO l_gis.aag02
          EXECUTE insert_prep USING l_gis.*
     END FOREACH                           
                                                                     
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'gis00,gis01,gis02,gis03,gis04') RETURNING g_wc                                                           
       LET g_str = g_wc                                                                                                             
    END IF                                                                                                                          
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED       #NO.FUN-920176    
    CALL cl_prt_cs3('agli931','agli931',l_sql,g_str)                         #NO.FUN-920176   
   
END FUNCTION
#No.FUN-9C0072 精簡程式碼
