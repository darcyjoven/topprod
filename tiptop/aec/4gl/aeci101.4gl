# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci101.4gl
# Descriptions...: 產品製程重要說明維護作業
# Input parameter:
# Date & Author..: 99/05/11/ By Iceman FOR TIPTOP 4.00
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-580014 05/08/16 By jackie 轉XML
# Modify.........: No.MOD-580067 05/08/31 By kim 取工作站說明的方式有誤
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-640194 06/04/09 By Sarah 增加qbe新功能時,程式放置位置錯誤,導致一直出現ON IDLE訊息
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740341 07/04/28 By johnray 被其他程序調用時，打開"維護說明資料"，點"查詢"報錯（-1349 字元轉換至數值失敗）
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760047 07/06/06 By xufeng  行序為負數無控管
# Modify.........: No.FUN-760085 07/07/11 By sherry  報表改由Crystal Report輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60013 10/06/03 By lilingyu 平行工藝
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.MOD-C90071 12/09/20 By Elise 進入menu前會判斷是否走平行製程
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效不可進單身
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ecb           RECORD LIKE ecb_file.*,   #製程資料
    g_ecb_t         RECORD LIKE ecb_file.*,
    g_ecb01_t       LIKE ecb_file.ecb01,
    g_type          LIKE type_file.chr1,     #No.FUN-680073  VARCHAR(1),    #資料性質
    g_ecbb          DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        ecbb09      LIKE ecbb_file.ecbb09,   #行序
        ecbb10      LIKE ecbb_file.ecbb10    #說明
                    END RECORD,
    g_ecbb_t         RECORD                 #程式變數 (舊值)
        ecbb09       LIKE ecbb_file.ecbb09,   #行序
        ecbb10       LIKE ecbb_file.ecbb10    #說明
                    END RECORD,
     g_wc,g_sql          STRING,  #No.FUN-580092 HCN    
     g_wc2               STRING,  #No.FUN-580092 HCN   
    g_argv1         LIKE ecb_file.ecb01,   #產品編號
    g_argv2         LIKE ecb_file.ecb02,   #製程序號
    g_argv3         LIKE ecb_file.ecb03,   #製程序
    g_argv4         LIKE ecb_file.ecb012,       #FUN-A60013
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680073 SMALLINT
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680073 SMALLINT SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680073
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680073
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680073 SMALLINT
#No.FUN-760085---Begin                                                          
DEFINE l_table        STRING,                                                   
       g_str          STRING,                                                   
       l_sql          STRING                                                    
#No.FUN-760085---End           
 
MAIN
# DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0100
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
#No.FUN-760085---Begin
   LET g_sql = "ecbb01.ecbb_file.ecbb01,",
               "ecbb02.ecbb_file.ecbb02,",
               "ecbb03.ecbb_file.ecbb03,",
               "ecbb09.ecbb_file.ecbb09,",     
               "ecbb10.ecbb_file.ecbb10,"
 
   LET l_table = cl_prt_temptable('aeci101',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?, ?, ?, ?, ?) "                                     
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
 #No.FUN-760085--END       
 
 
   LET g_argv1 =ARG_VAL(1)              #產品編號
   LET g_argv2 =ARG_VAL(2)              #製程編號
   LET g_argv3 =ARG_VAL(3)              #製程序
   LET g_argv4 =ARG_VAL(4)              #FUN-A60013
   LET g_ecb01_t = NULL
   LET g_ecb.ecb01 =g_argv1              #產品編號
   LET g_ecb.ecb02 =g_argv2              #製程編號
   LET g_ecb.ecb03 =g_argv3              #製程序
   LET g_ecb.ecb012=g_argv4              #FUN-A60013
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW i101_w AT p_row,p_col
        WITH FORM "aec/42f/aeci101"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#FUN-A60013 --begin--
   IF g_sma.sma541 = 'Y' THEN 
      CALL cl_set_comp_visible("ecb012,ecu014",TRUE) 
   ELSE
      CALL cl_set_comp_visible("ecb012,ecu014",FALSE)
   END IF 	   
#FUN-A60013 --end--
 
   IF cl_null(g_argv4) THEN LET g_argv4 = ' ' END IF   #MOD-C90071 add

   IF g_argv1 IS NOT NULL AND g_argv1 != ' '
      AND g_argv2 IS NOT NULL AND g_argv2 != ' '
      AND g_argv3 IS NOT NULL AND g_argv3 != ' ' 
      AND g_argv4 IS NOT NULL                       #FUN-A60013
      THEN
      CALL i101_q()
    # CALL i101_b()
      CALL i101_menu()
    ELSE
      LET g_type = '1'
      CALL i101_menu()
    END IF
 
    CLOSE WINDOW i101_w                 #結束畫面
 
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
 
END MAIN
 
#QBE 查詢資料
FUNCTION i101_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_ecu014        LIKE    ecu_file.ecu014   #FUN-A60013 


    CLEAR FORM                             #清除畫面
   CALL g_ecbb.clear()
 
 IF g_argv1 IS NULL OR g_argv1 = ' '  OR
    g_argv2 IS NULL OR g_argv2 = ' '
 THEN
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INITIALIZE g_ecb.ecb01 TO NULL        #No.TQC-740341
   INITIALIZE g_ecb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          ecb01,ecb02,ecb03,ecb012,ecu014,ecb06,ecb17,ecb08       #FUN-A60013 add ecb012,ecu014
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(ecb01)
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()
                 #  LET g_qryparam.state    = "c"
                 #  LET g_qryparam.form = "q_ima"
                 #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO ecb01
                   NEXT FIELD ecb01
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 ELSE 
 	  DISPLAY BY NAME g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb012,g_ecb.ecb03,g_ecb.ecb06,    #FUN-A60013 add g_ecb.ecb012
                    g_ecb.ecb17,g_ecb.ecb08     
#FUN-A60013 --begin--
   LET l_ecu014 = NULL
   SELECT ecu014 INTO l_ecu014 FROM ecu_file
    WHERE ecu01  = g_ecb.ecb01
      AND ecu02  = g_ecb.ecb02
      AND ecu012 = g_ecb.ecb012
   DISPLAY l_ecu014 TO ecu014    
#FUN-A60013 --end--                    
                      
      LET g_wc = " ecb01 ='",g_ecb.ecb01,"' AND ecb02 = '",g_ecb.ecb02,"' AND ",
                 " ecb03 ='",g_ecb.ecb03,"' AND ecb012 = '",g_ecb.ecb012,"'"      #FUN-A60013 add ecb012
 END IF
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ecbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ecbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecbuser', 'ecbgrup')
    #End:FUN-980030
 
 IF g_argv1 IS NULL OR g_argv1 = ' '  OR
    g_argv2 IS NULL OR g_argv2 = ' '  OR
    g_argv3 IS NULL OR g_argv3 = ' '
 THEN
   CONSTRUCT g_wc2 ON ecbb09,ecbb10                 # 螢幕上取單身條件
            FROM s_ecbb[1].ecbb09,s_ecbb[1].ecbb10
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 ELSE LET g_wc2 = " 1=1"
 END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ecb01,ecb02,ecb03,ecb012 FROM ecb_file ",  #FUN-A60013 add ecb012
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1,2,3,4"                               #FUN-A60013 add 4
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT ecb01,ecb02,ecb03,ecb012 FROM ecb_file ",    #FUN-A60013 add ecb012
                   "  FROM ecb_file, ecbb_file ",
                   " WHERE ecb01 = ecbb01 ",
                   "   AND ecb02 = ecbb02 ",
                   "   AND ecb03 = ecbb03 ",
                   "   AND ecb012 = ecbb012",                #FUN-A60013 add
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1,2,3,4"                         #FUN-A60013 add 4
    END IF
 
    PREPARE i101_prepare FROM g_sql
    DECLARE i101_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i101_prepare
 
    LET g_forupd_sql = "SELECT * FROM ecb_file ",
                       "WHERE ecb01 = ? AND ecb02 = ? AND ecb03 = ? AND ecb012 = ? FOR UPDATE"  #FUN-A60013 add ecb012
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_cl CURSOR FROM g_forupd_sql
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ecb_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM ecb_file,ecbb_file WHERE ",
                  "ecb01=ecbb01 AND ecb02 = ecbb02 AND ecb03 = ecbb03 ",
                  "AND ecb012 = ecbb012 ",            #FUN-A60013 add
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
 
END FUNCTION
 
FUNCTION i101_menu()
 
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i101_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i101_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecbb),'','')
            END IF
##
        #No.FUN-6A0039-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ecb.ecb01 IS NOT NULL THEN
                LET g_doc.column1 = "ecb01"
                LET g_doc.column2 = "ecb02"
                LET g_doc.column3 = "ecb03"
                LET g_doc.column4 = "ecb012"                  #FUN-A60013 add
                LET g_doc.value1 = g_ecb.ecb01
                LET g_doc.value2 = g_ecb.ecb02
                LET g_doc.value3 = g_ecb.ecb03
                LET g_doc.value4 = g_ecb.ecb012              #FUN-A60013 add               
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0039-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
#    INITIALIZE g_ecb.ecb01 TO NULL         #No.FUN-6A0039   #No.TQC-740341
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_ecbb.clear()
    CALL i101_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i101_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ecb.ecb01 TO NULL
    ELSE
        CALL i101_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i101_count
        FETCH i101_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680073 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i101_cs INTO g_ecb.ecb01,
                                             g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012       #FUN-A60013 add ecb012
        WHEN 'P' FETCH PREVIOUS i101_cs INTO g_ecb.ecb01,
                                             g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012       #FUN-A60013 add ecb012
        WHEN 'F' FETCH FIRST    i101_cs INTO g_ecb.ecb01,
                                             g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012       #FUN-A60013 add ecb012
        WHEN 'L' FETCH LAST     i101_cs INTO g_ecb.ecb01,
                                             g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012       #FUN-A60013 add ecb012
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
            FETCH ABSOLUTE g_jump i101_cs INTO g_ecb.ecb01,
                                               g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012       #FUN-A60013 add ecb012
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecb.ecb01,SQLCA.sqlcode,0)
        INITIALIZE g_ecb.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_ecb.* FROM ecb_file 
     WHERE ecb01=g_ecb.ecb01 
       AND ecb02=g_ecb.ecb02 
       AND ecb03=g_ecb.ecb03
       AND ecb012=g_ecb.ecb012       #FUN-A60013 add 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ecb.ecb01,SQLCA.sqlcode,0) #No.FUN-660091
        CALL cl_err3("sel","ecb_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) #FUN-660091
        INITIALIZE g_ecb.* TO NULL
        RETURN
#FUN-4C0034
    ELSE
        LET g_data_owner = g_ecb.ecbuser      #FUN-4C0034
        LET g_data_group = g_ecb.ecbgrup      #FUN-4C0034
        CALL i101_show()
    END IF
##
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i101_show()
DEFINE l_ecu014     LIKE ecu_file.ecu014   #FUN-A60013 

    DEFINE l_ima02  LIKE ima_file.ima02,
           l_ima021 LIKE ima_file.ima021,
           #l_pmc03  LIKE pmc_file.pmc03 #MOD-580067
            l_eca02  LIKE eca_file.eca02 #MOD-580067
 
    LET g_ecb_t.* = g_ecb.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
        g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,
        g_ecb.ecb08,g_ecb.ecb06,g_ecb.ecb17                              
#FUN-A60013 --begin--
       ,g_ecb.ecb012  
       
   LET l_ecu014 = NULL
   SELECT ecu014 INTO l_ecu014 FROM ecu_file
    WHERE ecu01  = g_ecb.ecb01
      AND ecu02  = g_ecb.ecb02
      AND ecu012 = g_ecb.ecb012
   DISPLAY l_ecu014 TO ecu014    
#FUN-A60013 --end-- 
       
    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM  ima_file
     WHERE ima01 = g_ecb.ecb01
    DISPLAY l_ima02,l_ima021 TO FORMONLY.ima02,ima021
 
    #MOD-580067...............begin
   #SELECT pmc03 INTO l_pmc03 FROM pmc_file
   # WHERE pmc01 = g_ecb.ecb08
   #IF SQLCA.SQLCODE = 100 THEN
   #   SELECT eca02 INTO l_pmc03 FROM eca_file
   #    WHERE eca01 = g_ecb.ecb08
   #END IF
   #DISPLAY l_pmc03 TO FORMONLY.desc1
    SELECT eca02 INTO l_eca02 FROM eca_file
       WHERE eca01 = g_ecb.ecb08
    IF SQLCA.sqlcode THEN
       LET l_eca02=NULL
    END IF
    DISPLAY l_eca02 TO FORMONLY.desc1
    #MOD-580067...............end
 
    CALL i101_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
#單身
FUNCTION i101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否        #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否        #No.FUN-680073 SMALLINT
    l_ecuacti       LIKE ecu_file.ecuacti   #CHI-C90006
    
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF

    #CHI-C90006---begin
    LET l_ecuacti = NULL 
    SELECT ecuacti INTO l_ecuacti
      FROM ecu_file
     WHERE ecu01  = g_ecb.ecb01
       AND ecu02  = g_ecb.ecb02
       AND ecu012 = g_ecb.ecb012
    IF l_ecuacti='N' THEN RETURN END IF  
    #CHI-C90006---end
 
    IF cl_null(g_ecb.ecb01) OR cl_null(g_ecb.ecb02)
       OR cl_null(g_ecb.ecb03) OR g_ecb.ecb012 IS NULL THEN   #FUN-A60013 add ecb012
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ecbb09,ecbb10 FROM ecbb_file  ",
                       " WHERE ecbb01= ? AND ecbb02 = ? ",
                       "   AND ecbb03= ? AND ecbb09 = ? AND ecbb012 = ? FOR UPDATE"  #FUN-A60013 add ecbb012
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ecbb WITHOUT DEFAULTS FROM s_ecbb.*
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
 
            OPEN i101_cl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012   #FUN-A60013 add ecb012
            IF STATUS THEN
               CALL cl_err("OPEN i101_cl_b:", STATUS, 1)
               CLOSE i101_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i101_cl INTO g_ecb.*   # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err('Fetch i101_cl_b',SQLCA.sqlcode,1)
               CLOSE i101_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ecbb_t.* = g_ecbb[l_ac].*  #BACKUP
 
               OPEN i101_bcl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,
                                   g_ecbb_t.ecbb09,g_ecb.ecb012             #FUN-A60013 add ecb012
               IF STATUS THEN
                  CALL cl_err("OPEN i101_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i101_bcl INTO g_ecbb[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('Fetch i101_bcl',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_ecbb_t.*=g_ecbb[l_ac].*
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ecbb[l_ac].* TO NULL      #900423
            LET g_ecbb_t.* = g_ecbb[l_ac].*                  #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ecbb09
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ecbb_file(ecbb01,ecbb02,ecbb03,ecbb09,ecbb10,ecbb012)   #FUN-A60013 add ecbb012
                           VALUES(g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,
                                  g_ecbb[l_ac].ecbb09,g_ecbb[l_ac].ecbb10,g_ecb.ecb012)   #FUN-A60013 add g_ecb.ecb012
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ecbb[l_ac].ecbb09,SQLCA.sqlcode,0) #No.FUN-660091
                CALL cl_err3("ins","ecbb_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) #FUN-660091
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD ecbb09                        # dgeeault 序號
            IF g_ecbb[l_ac].ecbb09 IS NULL OR g_ecbb[l_ac].ecbb09 = 0 THEN
               SELECT max(ecbb09)+1 INTO g_ecbb[l_ac].ecbb09 FROM ecbb_file
                WHERE ecbb01 = g_ecb.ecb01
                  AND ecbb02 = g_ecb.ecb02
                  AND ecbb03 = g_ecb.ecb03
                  AND ecbb012= g_ecb.ecb012   #FUN-A60013
               IF g_ecbb[l_ac].ecbb09 IS NULL THEN
                  LET g_ecbb[l_ac].ecbb09 = 1
               END IF
            END IF
 
        AFTER FIELD ecbb09                        #check 序號是否重複
            IF NOT cl_null(g_ecbb[l_ac].ecbb09) THEN
               IF (g_ecbb[l_ac].ecbb09 != g_ecbb_t.ecbb09 OR
                   g_ecbb_t.ecbb09 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM ecbb_file
                    WHERE ecbb01 = g_ecb.ecb01
                      AND ecbb02 = g_ecb.ecb02
                      AND ecbb03 = g_ecb.ecb03
                      AND ecbb09 = g_ecbb[l_ac].ecbb09
                      AND ecbb012= g_ecb.ecb012   #FUN-A60013                      
                   IF l_n > 0 THEN
                      CALL cl_err(g_ecbb[l_ac].ecbb09,-239,0)
                      LET g_ecbb[l_ac].ecbb09 = g_ecbb_t.ecbb09
                      NEXT FIELD ecbb09
                   END IF
               END IF
               #No.TQC-760047      --begin
               IF g_ecbb[l_ac].ecbb09 <=0 THEN
                  CALL cl_err('','aec-994',0)
                  NEXT FIELD ecbb09
               END IF
               #No.TQC-760047      --end   
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ecbb_t.ecbb09 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM ecbb_file
                 WHERE ecbb01 = g_ecb.ecb01 AND ecbb02 = g_ecb.ecb02
                   AND ecbb03 = g_ecb.ecb03 AND ecbb09 = g_ecbb_t.ecbb09
                   AND ecbb012= g_ecb.ecb012                #FUN-A60013                   
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ecbb_t.ecbb09,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("del","ecbb_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) #FUN-660091
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
 
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
             END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ecbb[l_ac].* = g_ecbb_t.*
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ecbb[l_ac].ecbb09,-263,1)
               LET g_ecbb[l_ac].* = g_ecbb_t.*
            ELSE
               UPDATE ecbb_file SET ecbb09=g_ecbb[l_ac].ecbb09,
                                    ecbb10=g_ecbb[l_ac].ecbb10
                WHERE ecbb01=g_ecb.ecb01 AND ecbb02 = g_ecb.ecb02 AND
                      ecbb03=g_ecb.ecb03 AND ecbb09 = g_ecbb_t.ecbb09
                  AND ecbb012= g_ecb.ecb012   #FUN-A60013    
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ecbb[l_ac].ecbb09,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("upd","ecbb_file",g_ecb.ecb01,g_ecbb_t.ecbb09,SQLCA.sqlcode,"","",1) #FUN-660091
                   LET g_ecbb[l_ac].* = g_ecbb_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ecbb[l_ac].* = g_ecbb_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ecbb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i101_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ecbb09) AND l_ac > 1 THEN
                LET g_ecbb[l_ac].* = g_ecbb[l_ac-1].*
                DISPLAY g_ecbb[l_ac].* TO s_ecbb[l_ac].*
                NEXT FIELD ecbb09
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
 
    CLOSE i101_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i101_b_askkey()
DEFINE
    l_wc       LIKE type_file.chr1000           #No.FUN-680073 VARCHAR(200)
 
    CONSTRUCT l_wc ON ecbb09,ecbb10             #螢幕上取條件
       FROM s_ecbb[1].ecbb09,s_ecbb[1].ecbb10
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
    CALL i101_b_fill(l_wc)
END FUNCTION
 
FUNCTION i101_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,  #No.FUN-680073 VARCHAR(300)
    l_flag          LIKE type_file.chr1      #No.FUN-680073 VARCHAR(1)
 
    LET g_sql =
        "SELECT ecbb09,ecbb10 FROM ecbb_file",
        " WHERE ecbb01 = '",g_ecb.ecb01,"'",
        "  AND  ecbb02 = '",g_ecb.ecb02,"'",
        "  AND  ecbb03 = '",g_ecb.ecb03,"'",
        "  AND ecbb012 = '",g_ecb.ecb012,"'",     #FUN-A60013 add
        "  AND ", p_wc2 CLIPPED,            #單身
        "  ORDER BY 1"
    PREPARE i101_pb FROM g_sql
    DECLARE ecbb_cs CURSOR FOR i101_pb            #SCROLL CURSOR
 
    CALL g_ecbb.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH ecbb_cs INTO g_ecbb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_ecbb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecbb TO s_ecbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
           LET g_action_choice="output"
           EXIT DISPLAY
 
      ON ACTION first
         CALL i101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
     ON ACTION related_document                #No.FUN-6A0039  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i101_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
    sr              RECORD
        ecbb01       LIKE ecbb_file.ecbb01,   #料件編號
        ecbb02       LIKE ecbb_file.ecbb02,   #製程編號
        ecbb03       LIKE ecbb_file.ecbb03,   #製程序
        ecbb09       LIKE ecbb_file.ecbb09,   #行序
        ecbb10       LIKE ecbb_file.ecbb10    #說明
                    END RECORD,
    l_name          LIKE type_file.chr20,    # No.FUN-680073 VARCHAR(20), #External(Disk) file name 
    l_za05          LIKE type_file.chr1000   # No.FUN-680073  VARCHAR(40)
 
    MESSAGE " "
    IF g_wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
    #LET l_name = 'aeci101.out'
  # CALL cl_outnam('aeci101') RETURNING l_name     #No.FUN-760085
    CALL cl_del_data(l_table)                      #No.FUN-760085
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085 
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT ecbb01,ecbb02,ecbb03,ecbb09,ecbb10 ",
              " FROM ecb_file,ecbb_file",  # 組合出 SQL 指令
              " WHERE ecb01 = ecbb01 AND ecb02 = ecbb02 AND ecb03 = ecbb03",
              "   AND ecb012 = ecbb012",   #FUN-A60013 
              "  AND ",g_wc CLIPPED,
              "  AND ",g_wc2 CLIPPED
    PREPARE i101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i101_co                         # SCROLL CURSOR
        CURSOR FOR i101_p1
 
#   START REPORT i101_rep TO l_name     #No.FUN-760085
 
    FOREACH i101_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
   #No.FUN-760085---Begin
   #    OUTPUT TO REPORT i101_rep(sr.*)
        EXECUTE insert_prep USING sr.ecbb01,sr.ecbb02,sr.ecbb03,sr.ecbb09,
                                  sr.ecbb10
   #No.FUN-760085---End
    END FOREACH
 
#   FINISH REPORT i101_rep                #No.FUN-760085
 
    CLOSE i101_co
    ERROR ""
#No.FUN-760085---Begin
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'ecb01,ecb02,ecb03,ecb06,ecb17,ecb08')         
            RETURNING g_wc                                                     
       LET g_str = g_wc                                                        
    END IF
    LET g_str = g_wc                                                        
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED  
#   CALL cl_prt(l_name,' ','1',g_len)
    CALL cl_prt_cs3('aeci101','aeci101',l_sql,g_str)
#No.FUN-760085---End
END FUNCTION
 
#No.FUN-760085
{
REPORT i101_rep(sr)
DEFINE
    l_last_sw    LIKE type_file.chr1,     # No.FUN-680073 VARCHAR(1),
    sr              RECORD
        ecbb01       LIKE ecbb_file.ecbb01,   #料件編號
        ecbb02       LIKE ecbb_file.ecbb02,   #製程編號
        ecbb03       LIKE ecbb_file.ecbb03,   #製程序
        ecbb09       LIKE ecbb_file.ecbb09,   #行序
        ecbb10       LIKE ecbb_file.ecbb10    #說明
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ecbb01 ,sr.ecbb02 ,sr.ecbb03, sr.ecbb09
 
    FORMAT
        PAGE HEADER
#No.FUN-580014 --start--
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
            PRINT g_dash1
            LET l_last_sw = 'n'
 
        BEFORE GROUP OF sr.ecbb02  #製程編號
            IF PAGENO > 1 OR LINENO > 8
            THEN SKIP TO TOP OF PAGE
            END IF
            PRINT COLUMN g_c[31],sr.ecbb01 CLIPPED,
                  COLUMN g_c[32],sr.ecbb02 CLIPPED;
 
        BEFORE GROUP OF sr.ecbb03  #製程序
            PRINT COLUMN g_c[33],sr.ecbb03 using '#####&';
 
        ON EVERY ROW
            PRINT COLUMN g_c[34],sr.ecbb09 using '###&', #FUN-590118
                  COLUMN g_c[35],sr.ecbb10 CLIPPED
#No.FUN-580014 --end--
        AFTER GROUP OF sr.ecbb02  #製程編號
 
        ON LAST ROW
            LET l_last_sw = 'y'
 
        PAGE TRAILER
            PRINT g_dash[1,g_len]
            IF l_last_sw = 'y' THEN
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            ELSE
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            END IF
END REPORT}
#No.FUN-760085---End
#Patch....NO.TQC-610035 <> #
