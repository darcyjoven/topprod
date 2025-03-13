# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axci310.4gl
# Descriptions...: 料件分類毛利費用率維護
# Date & Author..: 00/03/16 By Flora
# Modify.........: No:8442 03/10/09 Melody Line 437本table key 值有三個
#                                          用一個取會錯誤，導致後會在輸入檢查時
#                                          沒有該資料，卻會顯示-239資料重複
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0099 05/01/07 By kim 報表轉XML功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780017 07/07/26 By dxfwo CR報表的制作
# Modify.........: No.FUN-7B0116 08/04/08 By Sarah 單頭增加cme06"料件分類來源"(1.成本分群 2.產品分類),單身增加cme031"產品分類",
#                                                  當cme06選1時,單身輸入cme03,cme031隱藏,當cme06選2時,單身輸入cme031,cme03隱藏
# Modify.........: NO.FUN-890029 08/09/08 By sherry
#                  1.增加cme06分類類別
#                  2.增加複製功能
#                  3.cme03欄位定義修改為「分類碼」
# Modify.........: NO.FUN-930100 09/03/25 By jan 修改程序BUG
#
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_cme_o         RECORD LIKE cme_file.*,       #細部品名碼 (舊值)
       g_cmea          RECORD LIKE cme_file.*,       #細部品名碼 (舊值)
       g_cmea_t        RECORD LIKE cme_file.*,       #細部品名碼 (舊值)
       g_cme01         LIKE cme_file.cme01,
       g_cme01_t       LIKE cme_file.cme01,   #細部品名碼 (舊值)
       g_cme02         LIKE cme_file.cme02,
       g_cme02_t       LIKE cme_file.cme02,   #細部品名碼 (舊值)
       g_cme06         LIKE cme_file.cme06,   #料件分類來源         #FUN-7B0116 add
       g_cme06_t       LIKE cme_file.cme06,   #料件分類來源(舊值)   #FUN-7B0116 add
       g_cme           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           cme03       LIKE cme_file.cme03,   #分群一
           cme031      LIKE cme_file.cme031,  #產品分類             #FUN-7B0116 add
           cme04       LIKE cme_file.cme04,   #費用率
           cme05       LIKE cme_file.cme05    #毛利率
                       END RECORD,
       g_cme_t         RECORD                 #程式變數 (舊值)
           cme03       LIKE cme_file.cme03,   #分群一
           cme031      LIKE cme_file.cme031,  #產品分類             #FUN-7B0116 add
           cme04       LIKE cme_file.cme04,   #費用率
           cme05       LIKE cme_file.cme05    #毛利率
                       END RECORD,
       g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
       g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
       l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
       l_sl            LIKE type_file.num5,           #No.FUN-680122 SMALLINT            #目前處理的SCREEN LINE
       g_y             LIKE type_file.num5,           #No.FUN-680122 SMALLINT
       g_m             LIKE type_file.num5,           #No.FUN-680122 SMALLINT
       g_argv1         LIKE cme_file.cme01            #No.FUN-680122 VARCHAR(10)  
 
#主程式開始
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp      STRING   #No.TQC-720019
DEFINE l_sql          STRING   #No.FUN-780017
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_cnt          LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_no_ask       LIKE type_file.num5         #No.FUN-680122 SMALLINT
DEFINE g_str          STRING                           #No.FUN-780017 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
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
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
    LET g_argv1 = ARG_VAL(1)
    LET g_cme01= NULL
    LET g_cme01_t= NULL
    LET p_row = 3 LET p_col = 30
    OPEN WINDOW i310_w AT p_row,p_col
        WITH FORM "axc/42f/axci310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN CALL i310_q() END IF
    CALL i310_menu()
    CLOSE WINDOW i310_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION i310_cs()
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             #清除畫面
      CALL g_cme.clear()
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
      INITIALIZE g_cme01 TO NULL    #No.FUN-750051
      INITIALIZE g_cme02 TO NULL    #No.FUN-750051
      INITIALIZE g_cme06 TO NULL    #FUN-7B0116 add
 
      #螢幕上取條件
      CONSTRUCT g_wc ON cme01,cme02,cme06,cme03,cme031,cme04,cme05   #FUN-7B0116 add cme06,cme031
           FROM cme01,cme02,cme06,s_cme[1].cme03,s_cme[1].cme031,    #FUN-7B0116 add cme06,s_cme[1].cme031
                s_cme[1].cme04,s_cme[1].cme05
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
       
         ON ACTION controlp
            CASE 
               WHEN INFIELD(cme03) #其他分群碼一
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_azf"
                    LET g_qryparam.arg1     = "G"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cme03
                    NEXT FIELD cme03
              #str FUN-7B0116 add
               WHEN INFIELD(cme031)   #產品分類
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_oba"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cme031
                    NEXT FIELD cme031
              #end FUN-7B0116 add
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc=" cme01='",g_argv1,"'"
   END IF
   LET g_sql= "SELECT UNIQUE cme01,cme02,cme06 FROM cme_file",   #FUN-7B0116 add cme06
              " WHERE ", g_wc CLIPPED,
              " ORDER BY cme01"
   PREPARE i310_prepare FROM g_sql      #預備一下
   DECLARE i310_b_cs SCROLL CURSOR WITH HOLD FOR i310_prepare   #宣告成可捲動的
 
#  LET g_sql= "SELECT UNIQUE cme01,cme02 FROM cme_file",      #No.TQC-720019
   LET g_sql_tmp= "SELECT UNIQUE cme01,cme02,cme06 FROM cme_file",  #No.TQC-720019   #FUN-7B0116 add cme06
                  " WHERE ", g_wc CLIPPED,
                  " INTO TEMP x "
   DROP TABLE x
#  PREPARE i310_precount_x FROM g_sql      #No.TQC-720019
   PREPARE i310_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i310_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i310_precount FROM g_sql
   DECLARE i310_count CURSOR FOR i310_precount
END FUNCTION
 
FUNCTION i310_menu()
 
   WHILE TRUE
      LET g_argv1 = ARG_VAL(1)
      CALL i310_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i310_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i310_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i310_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i310_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i310_out()
            END IF
         #No.FUN-890029---Begin
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i310_copy()
            END IF
         #No.FUN-890029---End
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #FUN-4B0015
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_cme),'','')
            END IF
         #--
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_cme01 IS NOT NULL THEN
                  LET g_doc.column1 = "cme01"
                  LET g_doc.column2 = "cme02"
                  LET g_doc.column3 = "cme06"   #FUN-7B0116 add
                  LET g_doc.value1 = g_cme01
                  LET g_doc.value2 = g_cme02
                  LET g_doc.value3 = g_cme06    #FUN-7B0116 add
                  CALL cl_doc()
               END IF 
            END IF
         #No.FUN-6A0019-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i310_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_cme.clear()
   INITIALIZE g_cme01 LIKE cme_file.cme01
   INITIALIZE g_cme02 LIKE cme_file.cme02
   INITIALIZE g_cme06 LIKE cme_file.cme06   #FUN-7B0116 add
   INITIALIZE g_cmea.* LIKE cme_file.*      #DEFAULT 設定
   LET g_cme01_t = NULL
   LET g_cme02_t = NULL
   LET g_cme06_t = NULL                     #FUN-7B0116 add
   #預設值及將數值類變數清成零
   LET g_cme_o.* = g_cmea.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_cmea.cme06 = '1'        #No.FUN-890029
      CALL i310_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_cmea.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_cmea.cme01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      LET g_rec_b=0
      CALL i310_b()                   #輸入單身
      LET g_cme01_t=g_cme01
      LET g_cme02_t=g_cme02
      LET g_cme06_t=g_cme06           #FUN-7B0116 add
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i310_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680122 VARCHAR(1)
       p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680122 VARCHAR(1)
 
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT BY NAME g_cmea.cme01,g_cmea.cme02,g_cmea.cme06 WITHOUT DEFAULTS   #FUN-7B0116 add cme06
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i310_set_entry(p_cmd)
         CALL i310_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
       
     #BEFORE FIELD cme01                 #年份
     #   IF p_cmd = 'u' AND g_chkey = 'N' THEN NEXT FIELD cme02 END IF
      
      AFTER FIELD cme01                  #年度
         IF NOT cl_null(g_cmea.cme01)  THEN
            LET g_cme01=g_cmea.cme01
         END IF
 
      AFTER FIELD cme02                  #月份
         IF NOT cl_null(g_cmea.cme02) THEN 
            #No.FUN-890029---Begin 
            #IF g_cmea.cme02 <0 OR g_cmea.cme02 > 12 THEN
            #   CALL cl_err(g_cmea.cme02,'mfg6032',0)
            IF g_cmea.cme02 <= 0 OR g_cmea.cme02 > 12 THEN
               CALL cl_err(g_cmea.cme02,'aom-580',0)
            #No.FUN-890029---End
               LET g_cmea.cme02=g_cme_o.cme02
               DISPLAY BY NAME g_cmea.cme02 
               NEXT FIELD cme02
            END IF
            LET g_cme_o.cme02=g_cmea.cme02
            LET g_cme02=g_cmea.cme02
            #No.FUN-890029---Begin  
            #IF g_cmea.cme02 != g_cme02_t OR g_cme02_t IS NULL THEN
            #   SELECT count(*) INTO g_cnt FROM cme_file
            #    WHERE cme01 = g_cmea.cme01
            #      AND cme02 = g_cmea.cme02
            #      AND cme06 = g_cmea.cme06   #FUN-7B0116 add
            #   IF g_cnt > 0 THEN   #資料重複
            #       CALL cl_err(g_cmea.cme02,-239,0)
            #       LET g_cmea.cme02 = g_cme02_t
            #       DISPLAY BY NAME g_cmea.cme02 
            #       NEXT FIELD cme02
            #   END IF
            #END IF
            #No.FUN-890029---End
         END IF
            
     #str FUN-7B0116 add
      AFTER FIELD cme06      #料件分類來源(1.成本分群 2.產品分類)
         IF NOT cl_null(g_cmea.cme06)  THEN
            LET g_cme_o.cme06=g_cmea.cme06
            LET g_cme06=g_cmea.cme06
            IF g_cmea.cme06 != g_cme06_t OR g_cme06_t IS NULL THEN
               SELECT count(*) INTO g_cnt FROM cme_file
                WHERE cme01 = g_cmea.cme01
                  AND cme02 = g_cmea.cme02
                  AND cme06 = g_cmea.cme06   #FUN-7B0116 add
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_cmea.cme06,-239,0)
                  LET g_cmea.cme06 = g_cme06_t
                  DISPLAY BY NAME g_cmea.cme06 
                  NEXT FIELD cme06
               END IF
            END IF
         END IF
     #end FUN-7B0116 add
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
         IF g_cmea.cme02 IS NULL OR g_cmea.cme02 <=0 OR g_cmea.cme02 > 12 THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_cmea.cme02 
         END IF    
        #str FUN-7B0116 add
         #IF g_cmea.cme06 IS NULL OR g_cmea.cme06 NOT MATCHES '[12]' THEN   #No.FUN-890029
         IF g_cmea.cme06 IS NULL OR g_cmea.cme06 NOT MATCHES '[123456]' THEN    #No.FUN-890029
            LET l_flag='Y'
            DISPLAY BY NAME g_cmea.cme06
         END IF
        #end FUN-7B0116 add
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD cme01
         END IF
         LET g_cme06=g_cmea.cme06  #FUN-930100  
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
    #MOD-650015 --start
    # ON ACTION CONTROLO                        # 沿用所有欄位
    #     IF INFIELD(cme01) THEN
    #         LET g_cmea.* = g_cmea_t.*
    #         DISPLAY BY NAME g_cmea.* 
    #         NEXT FIELD cme01
    #     END IF
    #MOD-650015 --end
 
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
 
FUNCTION i310_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cme01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i310_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cme01",FALSE)
   END IF
END FUNCTION
 
FUNCTION i310_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_cme01 TO NULL        #No.FUN-6A0019
   INITIALIZE g_cme02 TO NULL        #FUN-7B0116 add
   INITIALIZE g_cme06 TO NULL        #FUN-7B0116 add
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i310_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i310_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cme01 TO NULL
      INITIALIZE g_cme02 TO NULL        #FUN-7B0116 add
      INITIALIZE g_cme06 TO NULL        #FUN-7B0116 add
   ELSE
      OPEN i310_count
      FETCH i310_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i310_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i310_fetch(p_flag)
DEFINE p_flag       LIKE type_file.chr1      #處理方式   #No.FUN-680122 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i310_b_cs INTO g_cme01,g_cme02,g_cme06   #FUN-7B0116 add g_cme06
      WHEN 'P' FETCH PREVIOUS i310_b_cs INTO g_cme01,g_cme02,g_cme06   #FUN-7B0116 add g_cme06
      WHEN 'F' FETCH FIRST    i310_b_cs INTO g_cme01,g_cme02,g_cme06   #FUN-7B0116 add g_cme06
      WHEN 'L' FETCH LAST     i310_b_cs INTO g_cme01,g_cme02,g_cme06   #FUN-7B0116 add g_cme06
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
           FETCH ABSOLUTE g_jump i310_b_cs INTO g_cme01,g_cme02,g_cme06  #No.TQC-720019   #FUN-7B0116 add g_cme06
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cme01,SQLCA.sqlcode,0)
      INITIALIZE g_cme01 TO NULL  #TQC-6B0105
      INITIALIZE g_cme02 TO NULL  #TQC-6B0105
      INITIALIZE g_cme06 TO NULL  #FUN-7B0116 add
   ELSE
      CALL i310_show()
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
FUNCTION i310_show()
 # LET g_cmea_t.* = g_cmea.*                #保存單頭舊值
   DISPLAY g_cme01,g_cme02,g_cme06 TO cme01,cme02,cme06   #FUN-7B0116 add cme06
        
   CALL i310_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i310_b()
DEFINE l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680122 SMALLINT
       l_n             LIKE type_file.num5,    #檢查重複用         #No.FUN-680122 SMALLINT
       l_lock_sw       LIKE type_file.chr1,    #單身鎖住否         #No.FUN-680122 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,    #處理狀態           #No.FUN-680122 VARCHAR(1)
       l_length        LIKE type_file.num5,                        #No.FUN-680122 SMALLINT             #長度
       l_allow_insert  LIKE type_file.num5,    #可新增否           #No.FUN-680122 SMALLINT
       l_allow_delete  LIKE type_file.num5     #可刪除否           #No.FUN-680122 SMALLINT
 
   LET g_action_choice = ""
   LET g_cmea.cme01=g_cme01
   LET g_cmea.cme02=g_cme02
   LET g_cmea.cme06=g_cme06   #FUN-7B0116 add
   IF g_cmea.cme01 IS NULL OR g_cmea.cme01 = 0 THEN RETURN END IF
   IF g_cmea.cme06 IS NULL THEN RETURN END IF    #No.FUN-890029
#  SELECT * INTO g_cmea.* FROM cme_file WHERE cme01=g_cmea.cme01  #No:8442
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cme03,cme031,cme04,cme05 ",   #FUN-7B0116 add cme031
                      "  FROM cme_file ", 
                      " WHERE cme01 =? ",
                      "   AND cme02 =? ",
                      "   AND cme06 =? ",   #FUN-7B0116 add
                      "   AND cme03 =? ",
                      "   AND cme031=? ",   #FUN-7B0116 add
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
                  
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_cme WITHOUT DEFAULTS FROM s_cme.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
        #str FUN-7B0116 add
         CALL i310_set_visible_b()
         CALL i310_set_entry_b()
         CALL i310_set_no_entry_b()
        #end FUN-7B0116 add
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b>=l_ac THEN
            LET g_cme_t.* = g_cme[l_ac].*  #BACKUP
            LET p_cmd='u'
 
           #OPEN i310_bcl USING g_cmea.cme01,g_cmea.cme02,g_cme_t.cme03   #FUN-7B0116 mark
            OPEN i310_bcl USING g_cmea.cme01,g_cmea.cme02,g_cmea.cme06,   #FUN-7B0116 add cme06
                                g_cme_t.cme03,g_cme_t.cme031              #FUN-7B0116 add cme031
            IF STATUS THEN
               CALL cl_err("OPEN i310_bcl:", STATUS, 1)
               CLOSE i310_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i310_bcl INTO g_cme[l_ac].* 
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_cme_t.cme03,SQLCA.sqlcode,1)
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
        #IF g_cme[l_ac].cme03 IS NULL THEN  #重要欄位空白,無效   #FUN-7B0116 mark
         IF (g_cme06='1' AND g_cme[l_ac].cme03 IS NULL)  OR      #FUN-7B0116
            (g_cme06='2' AND g_cme[l_ac].cme03 IS NULL)  OR      #No.FUN-890029
            (g_cme06='3' AND g_cme[l_ac].cme03 IS NULL)  OR      #No.FUN-890029
            (g_cme06='4' AND g_cme[l_ac].cme03 IS NULL)  OR      #No.FUN-890029
            (g_cme06='5' AND g_cme[l_ac].cme03 IS NULL)  OR      #No.FUN-890029
            #(g_cme06='2' AND g_cme[l_ac].cme031 IS NULL) THEN   #FUN-7B0116  #No.FUN-890029
            (g_cme06='6' AND g_cme[l_ac].cme031 IS NULL) THEN    #No.FUN-890029
            INITIALIZE g_cme[l_ac].* TO NULL
         END IF
        #str FUN-7B0116 mod
        #INSERT INTO cme_file(cme01,cme02,cme03,cme04,cme05)
        #VALUES(g_cmea.cme01,g_cmea.cme02,g_cme[l_ac].cme03,
        #       g_cme[l_ac].cme04,g_cme[l_ac].cme05)
         INSERT INTO cme_file(cme01,cme02,cme06,cme03,cme031,cme04,cme05,cmelegal)   #FUN-A50075 add legal
         VALUES(g_cmea.cme01,g_cmea.cme02,g_cmea.cme06,g_cme[l_ac].cme03,
                g_cme[l_ac].cme031,g_cme[l_ac].cme04,g_cme[l_ac].cme05,g_legal)   #FUN-A50075 add legal
        #end FUN-7B0116 mod
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cme[l_ac].cme03,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cme_file",g_cmea.cme01,g_cmea.cme02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
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
         INITIALIZE g_cme[l_ac].* TO NULL      #900423
        #str FUN-7B0116 add
         #No.FUN-890029---Begin
         #IF g_cme06='1' THEN
         #   LET g_cme[l_ac].cme031=' '
         #ELSE
         #   LET g_cme[l_ac].cme03 =' '
         #END IF
         IF g_cme06='6' THEN
            LET g_cme[l_ac].cme03=' '
         ELSE
            LET g_cme[l_ac].cme031 =' '
         END IF
         #No.FUN-890029---End
        #end FUN-7B0116 add
         LET g_cme_t.* = g_cme[l_ac].*             #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER FIELD cme03                        #check 序號是否重複
         #IF g_cme06='1' THEN    #料件來源分類=1.成本分群   #FUN-7B0116 add  #No.FUN-890029
         IF g_cme06 != '6' THEN  #No.FUN-890029
            IF g_cme[l_ac].cme03 IS NOT NULL THEN
               #No.FUN-890029---Begin
               #SELECT azf01 FROM azf_file 
               # WHERE azf01=g_cme[l_ac].cme03 AND azf02='G' #6818
               #   AND azfacti='Y'
               #IF SQLCA.sqlcode  THEN
#              #   CALL cl_err(g_cme[l_ac].cme03,'mfg1306',0)   #No.FUN-660127
               #   CALL cl_err3("sel","azf_file",g_cme[l_ac].cme03,"","mfg1306","","",1)  #No.FUN-660127
               #   LET g_cme[l_ac].cme03 = g_cme_t.cme03
               #   NEXT FIELD cme03
               CALL i310_chk_cme03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_cme[l_ac].cme03 = g_cme_t.cme03
                  NEXT FIELD cme03
               END IF
               #No.FUN-890029---End 
            END IF
            IF g_cme[l_ac].cme03 IS NOT NULL AND 
              (g_cme[l_ac].cme03 != g_cme_t.cme03 OR g_cme_t.cme03 IS NULL) THEN
               SELECT count(*) INTO g_cnt
                 FROM cme_file
                WHERE cme01 = g_cmea.cme01
                  AND cme02 = g_cmea.cme02
                  AND cme06 = g_cmea.cme06   #FUN-7B0116 add
                  AND cme03 = g_cme[l_ac].cme03
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_cme[l_ac].cme03 = g_cme_t.cme03
                  NEXT FIELD cme03
               END IF
            END IF
         END IF   #FUN-7B0116 add
      
     #str FUN-7B0116 add      
      AFTER FIELD cme031                       #check 序號是否重複
         #IF g_cme06='2' THEN    #料件來源分類=2.產品分類 #No.FUN-890029
         IF g_cme06='6' THEN    #料件來源分類=6.產品分類 #No.FUN-890029
            IF g_cme[l_ac].cme031 IS NOT NULL THEN
               SELECT oba01 FROM oba_file 
                WHERE oba01=g_cme[l_ac].cme031
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","oba_file",g_cme[l_ac].cme031,"","aim-142","","",1)
                  LET g_cme[l_ac].cme031 = g_cme_t.cme031
                  NEXT FIELD cme031
               END IF
            END IF
            IF g_cme[l_ac].cme031 IS NOT NULL AND 
              (g_cme[l_ac].cme031 != g_cme_t.cme031 OR g_cme_t.cme031 IS NULL) THEN
                SELECT count(*) INTO g_cnt
                  FROM cme_file
                 WHERE cme01 = g_cmea.cme01
                   AND cme02 = g_cmea.cme02
                   AND cme06 = g_cmea.cme06
                   AND cme031= g_cme[l_ac].cme031
                IF g_cnt > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_cme[l_ac].cme031 = g_cme_t.cme031
                   NEXT FIELD cme031
                END IF
            END IF
         END IF
     #end FUN-7B0116 add
 
      AFTER FIELD cme04
         IF NOT cl_null(g_cme[l_ac].cme04) THEN
            IF g_cme[l_ac].cme04<=0 THEN 
               NEXT FIELD cme04
            END IF
         END IF
 
      AFTER FIELD cme05
         IF NOT cl_null(g_cme[l_ac].cme05) THEN
            IF g_cme[l_ac].cme05<=0 THEN 
               NEXT FIELD cme05
             END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_cmea_t.cme02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
           #str FUN-7B0116 mod
           #DELETE FROM cme_file WHERE cme01 = g_cmea.cme01
           #                       AND cme02 = g_cmea.cme02
           #                       AND cme03 = g_cme_t.cme03
           #No.FUN-890029---Begin
           #IF g_cme06='1' THEN
           #   DELETE FROM cme_file WHERE cme01 = g_cmea.cme01
           #                          AND cme02 = g_cmea.cme02
           #                          AND cme06 = g_cmea.cme06
           #                          AND cme03 = g_cme_t.cme03
           #ELSE
           #   DELETE FROM cme_file WHERE cme01 = g_cmea.cme01
           #                          AND cme02 = g_cmea.cme02
           #                          AND cme06 = g_cmea.cme06
           #                          AND cme031= g_cme_t.cme031
           #END IF
            IF g_cme06='6' THEN
               DELETE FROM cme_file WHERE cme01 = g_cmea.cme01
                                      AND cme02 = g_cmea.cme02
                                      AND cme06 = g_cmea.cme06
                                      AND cme031= g_cme_t.cme031 #FUN-930100
            ELSE
               DELETE FROM cme_file WHERE cme01 = g_cmea.cme01
                                      AND cme02 = g_cmea.cme02
                                      AND cme06 = g_cmea.cme06
                                      AND cme03 = g_cme_t.cme03  #FUN-930100
            END IF
           #No.FUN-890029---End
           #end FUN-7B0116 mod
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cme_t.cme03,SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("del","cme_file",g_cmea.cme01,g_cmea.cme02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
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
            LET g_cme[l_ac].* = g_cme_t.*
            CLOSE i310_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cme[l_ac].cme03,-263,1)
            LET g_cme[l_ac].* = g_cme_t.*
         ELSE
           #IF g_cme[l_ac].cme03 IS NULL THEN  #重要欄位空白,無效   #FUN-7B0116 mark
            IF (g_cme06='1' AND g_cme[l_ac].cme03 IS NULL)  OR      #FUN-7B0116
               #No.FUN-890029---Begin
               (g_cme06='2' AND g_cme[l_ac].cme03 IS NULL)  OR
               (g_cme06='3' AND g_cme[l_ac].cme03 IS NULL)  OR
               (g_cme06='4' AND g_cme[l_ac].cme03 IS NULL)  OR
               (g_cme06='5' AND g_cme[l_ac].cme03 IS NULL)  OR
               #(g_cme06='2' AND g_cme[l_ac].cme031 IS NULL) THEN    #FUN-7B0116
               (g_cme06='6' AND g_cme[l_ac].cme031 IS NULL) THEN
               #No.FUN-890029---End
               INITIALIZE g_cme[l_ac].* TO NULL
            END IF
            UPDATE cme_file SET cme03=g_cme[l_ac].cme03,
                                cme031=g_cme[l_ac].cme031,   #FUN-7B0116 add
                                cme04=g_cme[l_ac].cme04,
                                cme05=g_cme[l_ac].cme05
                          WHERE cme01 = g_cmea.cme01 
                            AND cme02 = g_cmea.cme02
                            AND cme06 = g_cmea.cme06         #FUN-7B0116 add
                            AND cme03 = g_cme_t.cme03
                            AND cme031= g_cme_t.cme031       #FUN-7B0116 add
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cme[l_ac].cme03,SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("upd","cme_file",g_cmea.cme01,g_cme_t.cme03,SQLCA.sqlcode,"","",1)  #No.FUN-660127
               LET g_cme[l_ac].* = g_cme_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac        #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_cme[l_ac].* = g_cme_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_cme.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE i310_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac       #FUN-D40030 add
         CLOSE i310_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         #No.FUN-890029---Begin
         #IF g_cme06='1' THEN   #FUN-7B0116 add
         #   IF INFIELD(cme03) AND l_ac > 1 THEN
         #      LET g_cme[l_ac].* = g_cme[l_ac-1].*
         #      NEXT FIELD cme03
         #   END IF
        ##str FUN-7B0116 add
         #ELSE
         #   IF INFIELD(cme031) AND l_ac > 1 THEN
         #      LET g_cme[l_ac].* = g_cme[l_ac-1].*
         #      NEXT FIELD cme031
         #   END IF
         #END IF
         #end FUN-7B0116 add
         IF g_cme06='6' THEN   
            IF INFIELD(cme031) AND l_ac > 1 THEN
               LET g_cme[l_ac].* = g_cme[l_ac-1].*
               NEXT FIELD cme031
            END IF
         ELSE
            IF INFIELD(cme03) AND l_ac > 1 THEN
               LET g_cme[l_ac].* = g_cme[l_ac-1].*
               NEXT FIELD cme03
            END IF
         END IF
        #No.FUN-890029---End
         
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")         #No.FUN-6A0092
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON ACTION controlp
         CASE 
            WHEN INFIELD(cme03) #其他分群碼一
                 CALL cl_init_qry_var()
                 #No.FUN-890029---Begin
                 #LET g_qryparam.form     = "q_azf"
                 #LET g_qryparam.default1 = g_cme[l_ac].cme03
                 #LET g_qryparam.arg1     = "G"
                 CASE g_cmea.cme06
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
                 LET g_qryparam.default1 = g_cme[l_ac].cme03
                 #No.FUN-890029---End
                 CALL cl_create_qry() RETURNING g_cme[l_ac].cme03
#                 CALL FGL_DIALOG_SETBUFFER( g_cme[l_ac].cme03 )
                 DISPLAY BY NAME g_cme[l_ac].cme03
                 NEXT FIELD cme03
           #str FUN-7B0116 add
            WHEN INFIELD(cme031)   #產品分類
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_oba"
                 LET g_qryparam.default1 = g_cme[l_ac].cme031
                 CALL cl_create_qry() RETURNING g_cme[l_ac].cme031
                 DISPLAY BY NAME g_cme[l_ac].cme031
                 NEXT FIELD cme031
           #end FUN-7B0116 add
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
      
   CLOSE i310_bcl
   COMMIT WORK
END FUNCTION
 
#str FUN-7B0116 add
FUNCTION i310_set_entry_b()
   #當單頭的cme06=1.成本分群時,開放輸入cme03,反之則開放cme031
   #No.FUN-890029---Begin
   #當單頭的cme06=1/2/3/4/5,開放輸入cme03,反之則開放cme031
   #IF g_cme06 = '1' THEN 
   #   CALL cl_set_comp_entry("cme03",TRUE)
   #ELSE
   #   CALL cl_set_comp_entry("cme031",TRUE)
   #END IF
   IF g_cme06 = '6' THEN 
      CALL cl_set_comp_entry("cme031",TRUE)
   ELSE
      CALL cl_set_comp_entry("cme03",TRUE)
   END IF
   #No.FUN-890029---End
END FUNCTION
 
FUNCTION i310_set_no_entry_b()
   #No.FUN-890029---Begin
   #當單頭的cme06=1/2/3/4/5,將cme031設成NoEntry,反之則將cme03設成NoEntry
   #IF g_cme06 = '1' THEN 
   #   CALL cl_set_comp_entry("cme031",FALSE)
   #ELSE
   #   CALL cl_set_comp_entry("cme03",FALSE)
   #END IF
   IF g_cme06 = '6' THEN 
      CALL cl_set_comp_entry("cme03",FALSE)
   ELSE
      CALL cl_set_comp_entry("cme031",FALSE)
   END IF
   #No.FUN-890029---End
END FUNCTION
 
FUNCTION i310_set_visible_b()
   #No.FUN-890029---Begin
   #當單頭的cme06=1/2/3/4/5,顯示cme03,隱藏cme031,反之則顯示cme031,隱藏cme03
   #IF g_cme06 = '1' THEN 
   #   CALL cl_set_comp_visible("ome03",TRUE)
   #   CALL cl_set_comp_visible("ome031",FALSE)
   #ELSE
   #   CALL cl_set_comp_visible("ome031",TRUE)
   #   CALL cl_set_comp_visible("ome03",FALSE)
   #END IF
   IF g_cme06 = '6' THEN 
      CALL cl_set_comp_visible("ome031",TRUE)
      CALL cl_set_comp_visible("ome03",FALSE)
   ELSE
      CALL cl_set_comp_visible("ome03",TRUE)
      CALL cl_set_comp_visible("ome031",FALSE)
   END IF
   #No.FUN-890029---End
END FUNCTION
#end FUN-7B0116 add
 
#FUNCTION i310_delall()
#    SELECT COUNT(*) INTO g_cnt FROM cme_file
#        WHERE cme01 = g_cmea.cme01
#          AND cme02 = g_cmea.cme02
#    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#       ERROR g_msg CLIPPED
#       DELETE FROM cme_file WHERE cme01 = g_cmea.cme01
#                              AND cme02 = g_cmea.cme02
#    END IF
#END FUNCTION
   
FUNCTION i310_b_askkey()
DEFINE l_wc            LIKE type_file.chr1000       #No.FUN-680122CHAR(310) 
 
   CALL cl_opmsg('q')
   CLEAR cme03,cme031,cme04,cme05   #FUN-7B0116 add cme031
   #螢幕上取條件
   CONSTRUCT l_wc ON cme03,cme031,cme04,cme05    #FUN-7B0116 add cme031
        FROM s_cme[1].cme03,s_cme[1].cme031,s_cme[1].cme04,s_cme[1].cme05   #FUN-7B0116 add s_cme[1].cme031
 
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
   CALL i310_b_fill(l_wc)
   CALL cl_opmsg('b')
END FUNCTION
 
FUNCTION i310_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc          LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(310) 
 
   LET g_sql = "SELECT cme03,cme031,cme04,cme05",   #FUN-7B0116 add cme031
               "  FROM cme_file",
               " WHERE cme01 = '",g_cme01,"'",
               "   AND cme02 = '",g_cme02,"'",
               "   AND cme06 = '",g_cme06,"'",   #FUN-7B0116 add
               "   AND ",p_wc CLIPPED ,
               " ORDER BY 1"
   PREPARE i310_prepare2 FROM g_sql      #預備一下
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE i310_curs1 CURSOR FOR i310_prepare2
   CALL g_cme.clear()
   LET g_cnt = 1
   FOREACH i310_curs1 INTO g_cme[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_cme.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cme TO s_cme.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL i310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last 
         CALL i310_fetch('L')
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
         
      #No.FUN-890029---Begin
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #No.FUN-890029---End
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #FUN-4B0015
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i310_r()
   IF g_cme01 IS NULL THEN
      CALL cl_err("",-400,0)              #No.FUN-6A0019
      RETURN 
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "cme01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "cme02"         #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "cme06"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_cme01          #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_cme02          #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_cme06          #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM cme_file
       WHERE cme01=g_cme01 AND cme02=g_cme02 AND cme06=g_cme06   #FUN-7B0116 add cme06
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660127
         CALL cl_err3("del","cme_file",g_cme01,g_cme02,SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660127
      ELSE
         CLEAR FORM
         CALL g_cme.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
#        EXECUTE i310_precount_x                  #No.TQC-720019
         PREPARE i310_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i310_precount_x2                 #No.TQC-720019
         OPEN i310_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i310_b_cs
            CLOSE i310_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i310_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i310_b_cs
            CLOSE i310_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i310_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i310_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i310_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION i310_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
    sr              RECORD
        cme01       LIKE cme_file.cme01,   #年度
        cme02       LIKE cme_file.cme02,   #月份
        cme03       LIKE cme_file.cme03,   #分類碼
        cme04       LIKE cme_file.cme04,   #費用率
        cme05       LIKE cme_file.cme05    #費用率
                    END RECORD,
    l_za05          LIKE za_file.za05,
    l_name          LIKE type_file.chr20          #No.FUN-680122    VARCHAR(20)           #External(Disk) file name
 
    IF g_wc IS NULL THEN 
       IF NOT cl_null(g_cme01) THEN
          LET g_wc=" cme01=",g_cme01," AND cme02= ",g_cme02,
                                     " AND cme06='",g_cme06,"'"   #FUN-7B0116 add
       ELSE
          CALL cl_err('','9057',0) RETURN 
       END IF
    END IF
    CALL cl_wait()
    CALL cl_outnam('axci310') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT cme01,cme02,cme03,cme04,cme05 ",
          " FROM cme_file ",
          " WHERE ",g_wc CLIPPED
#No.FUN-780017---Begin 
#   PREPARE i310_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i310_co CURSOR FOR i310_p1
#   START REPORT i310_rep TO l_name
#   FOREACH i310_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i310_rep(sr.*)
#   END FOREACH
#   FINISH REPORT i310_rep
#   CLOSE i310_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'cme01,cme02,cme06,cme03,cme031,cme04,cme05')   #FUN-7B0116 add
            RETURNING g_str                                                     
    END IF
    LET l_sql = "SELECT cme01,cme02,cme03,cme031,cme04,cme05,cme06 ",  #FUN-7B0116 add cme031,cme06
                "  FROM cme_file ",                                                                                                        
                " WHERE ",g_wc CLIPPED  
    CALL cl_prt_cs1('axci310','axci310',l_sql,g_str)
#No.FUN-780017---End
END FUNCTION
 
#No.FUN-780017 mark
#REPORT i310_rep(sr)
#DEFINE l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
#       l_sw            LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
#       l_i             LIKE type_file.num5,           #No.FUN-680122 SMALLINT
#       sr              RECORD
#           cme01       LIKE cme_file.cme01,   #年度
#           cme02       LIKE cme_file.cme02,   #月份
#           cme03       LIKE cme_file.cme03,   #分類碼
#           cme04       LIKE cme_file.cme04,   #費用率
#           cme05       LIKE cme_file.cme05    #費用率
#                       END RECORD 
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.cme01,sr.cme02,sr.cme03
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT
#            PRINT g_x[9] clipped,sr.cme01 USING "####",
#                  g_x[10] clipped,sr.cme02 USING "&&"
#            PRINT g_dash
#            PRINT g_x[31],g_x[32],g_x[33]
#            PRINT g_dash1
# 
#            LET l_trailer_sw = 'y'
# 
#        BEFORE GROUP OF sr.cme01
#            SKIP TO TOP OF PAGE 
#           #PRINT COLUMN g_c[31],g_x[9] clipped,sr.cme01 USING "####";
#
#       BEFORE GROUP OF sr.cme02
#            SKIP TO TOP OF PAGE 
#           #PRINT COLUMN g_c[32],g_x[10] clipped,sr.cme02 USING "&&"
#           #PRINT COLUMN 25,g_x[13] clipped,
#           #      COLUMN 37,g_x[14] clipped,COLUMN 48,g_x[15] clipped
#           #PRINT COLUMN 25,"------", COLUMN 37,"-------", COLUMN 48,"-------"
#
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.cme03, 
#                 COLUMN g_c[32],sr.cme04 USING "##&.&&",
#                 COLUMN g_c[33],sr.cme05 USING "##&.&&" 
#
#       AFTER GROUP OF sr.cme02
#           PRINT ' '
#
#       ON LAST ROW
#           PRINT g_dash
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-780017 mark
 
#No.FUN-890029---Begin
FUNCTION i310_chk_cme03()
   DEFINE l_chr      LIKE azf_file.azf02,
          l_acti     LIKE imz_file.imzacti
 
   LET g_errno = ''
   IF g_cme[l_ac].cme03 = "ALL" THEN
      RETURN
   END IF
   CASE g_cmea.cme06
        WHEN '2'   LET l_chr = "D"
        WHEN '3'   LET l_chr = "E"
        WHEN '4'   LET l_chr = "F"
        WHEN '5'   LET l_chr = "G"
   END CASE
   CASE
        WHEN g_cmea.cme06 = '1'
           SELECT imzacti INTO l_acti FROM imz_file
            WHERE imz01 = g_cme[l_ac].cme03
        WHEN g_cmea.cme06 MATCHES '[2345]'
           SELECT azfacti INTO l_acti FROM azf_file
            WHERE azf01 = g_cme[l_ac].cme03
              AND azf02 = l_chr
        WHEN g_cmea.cme06 = '6'
           SELECT oba02 FROM oba_file
            WHERE oba01 = g_cme[l_ac].cme03
   END CASE
   CASE
      WHEN SQLCA.SQLCODE = 100
           LET g_errno = SQLCA.SQLCODE
      WHEN g_cmea.cme06 MATCHES '[12345]' AND l_acti <> 'Y'
           LET g_errno = '9028'
      OTHERWISE
           LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE
END FUNCTION
 
#================================
# 複製
#================================
FUNCTION i310_copy()
DEFINE
   l_cme01,l_oldno1    LIKE cme_file.cme01,
   l_cme02,l_oldno2    LIKE cme_file.cme02,
   l_cnt               INTEGER,
   l_buf               VARCHAR(100)
 
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   IF s_shut(0) THEN RETURN END IF
   IF g_cme01 IS NULL OR g_cme02 IS NULL OR cl_null(g_cme06) THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   LET g_before_input_done = FALSE
   CALL i310_set_entry('a')
   LET g_before_input_done = TRUE
 
   INPUT l_cme01,l_cme02 FROM cme01,cme02
      AFTER FIELD cme01
         IF l_cme01 IS NULL THEN
            NEXT FIELD cme01
         END IF
 
      AFTER FIELD cme02
         IF l_cme02 IS NOT NULL THEN
            IF l_cme02 < 1 OR l_cme02 > 12 THEN
               CALL cl_err(l_cme02,'aom-580',0)
               NEXT FIELD cme02
            END IF
            LET l_cnt = 0
            SELECT count(*) INTO l_cnt FROM cme_file
             WHERE cme01 = l_cme01
               AND cme02 = l_cme02
               AND cme06 = g_cme06
            IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
            IF l_cnt > 0 THEN
               CALL cl_err(l_cme01,-239,0)
               NEXT FIELD cme01
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
      DISPLAY g_cme01,g_cme02 TO cme01,cme02
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET l_buf = l_cme01 USING '<<<<', '/', l_cme02 USING '<<'
   BEGIN WORK
   DROP TABLE x
   SELECT * FROM cme_file
    WHERE cme01 = g_cme01
      AND cme02 = g_cme02
      AND cme06 = g_cme06
     INTO TEMP x
   UPDATE x SET cme01    = l_cme01,
                cme02    = l_cme02
   INSERT INTO cme_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","cme_file",l_buf,'',SQLCA.sqlcode,"","cme:",1)
      ROLLBACK WORK
      RETURN
   END IF
   COMMIT WORK
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_buf,') O.K'
 
   LET l_oldno1 = g_cme01
   LET l_oldno2 = g_cme02
   LET g_cme01  = l_cme01
   LET g_cme02  = l_cme02
   CALL i310_b()
   #LET g_cme01  = l_oldno1  #FUN-C80046
   #LET g_cme02  = l_oldno2  #FUN-C80046
   #CALL i310_show()         #FUN-C80046
END FUNCTION
#No.FUN-890029---End
