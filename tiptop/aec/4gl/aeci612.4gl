# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci612.4gl
# Descriptions...: 製程資料作業說明維護作業(aeci612)
# Date & Author..: 91/12/13 By MAY
# SORUCE         : aeci625.4gl
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510032 05/02/21 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5B0111 05/11/12 By Carol 報表的料號/品名/規各對齊
#                                                  沒有單身資料時,INSERT資料會變為UPDATE而資料沒法INSERT成功
# Modify.........: No.TQC-5B0158 05/12/07 By Pengu 單身刪除後,再按單身維護一筆資不會真的新增至資料庫
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730091 07/04/02 By joyce 單身下查詢條件時，會出現"語法錯誤"的錯誤訊息
# Modify.........: No.TQC-740341 07/04/28 By johnray 被其他程序調用時，打開"維護說明資料"，點"查詢"報錯（-1349 字元轉換至數值失敗）
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790160 07/09/28 By Pengu 修改SQL語法
# Modify.........: No.FUN-7B0100 07/11/19 By Carol 報表修改為CR用法
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-930162 09/05/06 By destiny sql語句少一變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60028 10/06/07 By lilingyu 平行工藝
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ecb           RECORD
                    ecb01  LIKE ecb_file.ecb01, #作業編號
                    ecb02  LIKE ecb_file.ecb02, #製程編號
                    ecb03  LIKE ecb_file.ecb03, #製程序號
                    ecb06  LIKE ecb_file.ecb06, #作業編號
                    ecb17  LIKE ecb_file.ecb17  #作業編號
                   ,ecb012 LIKE ecb_file.ecb012              #FUN-A60028                    
                    END RECORD,
    g_ecw           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecw05       LIKE ecw_file.ecw05,   #行序
        ecw06       LIKE ecw_file.ecw06    #說明
                    END RECORD,
    g_ecw_t         RECORD                 #程式變數 (舊值)
        ecw05       LIKE ecw_file.ecw05,   #行序
        ecw06       LIKE ecw_file.ecw06    #說明
                    END RECORD,
   #g_wc,g_wc2,g_sql    VARCHAR(300),                #TQC-630166       
    g_wc,g_wc2,g_sql    STRING,                   #TQC-630166     
    g_flag          LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680073 SMALLINT
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT #No.FUN-680073 SMALLINT
    ecb01_t     LIKE ecb_file.ecb01,   #作業編號
    ecb012_t    LIKE ecb_file.ecb012,                 #FUN-A60028
    ecb02_t     LIKE ecb_file.ecb02,   #製程編號
    ecb03_t     LIKE ecb_file.ecb03    #製程序號
 
#主程式開始
DEFINE g_forupd_sql         STRING                       #SELECT ... FOR UPDATE SQL        
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
#FUN-7B0100-add
DEFINE g_str          STRING,                                                   
       l_sql          STRING                                                    
#FUN-7B0100-end
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0100
    p_row,p_col   LIKE type_file.num5                 #No.FUN-680073 SMALLINT
 
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
 
    LET g_ecb.ecb01  = ARG_VAL(1)           #作業編號
    LET g_ecb.ecb02  = ARG_VAL(2)           #作業編號
    LET g_ecb.ecb03  = ARG_VAL(3)           #作業編號
    LET g_ecb.ecb012 = ARG_VAL(4)           #FUN-A60028 
 
    LET p_row = 4 LET p_col = 25
 
    OPEN WINDOW i612_w AT p_row,p_col   #顯示畫面
         WITH FORM "aec/42f/aeci612"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#FUN-A60028 --begin--
    IF g_sma.sma541 = 'Y' THEN 
       CALL cl_set_comp_visible("ecb012,ecu014",TRUE)
    ELSE
       CALL cl_set_comp_visible("ecb012,ecu014",FALSE)
    END IF 	       
#FUN-A60028 --end-- 
 
    IF g_ecb.ecb02 IS NOT NULL AND g_ecb.ecb02 != ' ' AND
       g_ecb.ecb03 IS NOT NULL AND g_ecb.ecb03 != ' ' AND 
       g_ecb.ecb012 IS NOT NULL  #FUN-A60028
       THEN
       LET g_flag = 'Y'
       CALL i612_q()
    ELSE
       LET g_flag = 'N'
    END IF
 
    CALL i612_menu()
 
    CLOSE WINDOW i612_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
 
END MAIN
 
#QBE 查詢資料
FUNCTION i612_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                                     #清除畫面
   CALL g_ecw.clear()
 
 IF g_flag = 'N'  THEN  #參數是否有值
    CALL cl_set_head_visible("","YES")            #No.FUN-6B0029
    INITIALIZE g_ecb.* TO NULL                    #No.TQC-740341
   INITIALIZE g_ecb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
          ecb01,ecb02,ecb012,ecu014,ecb03,ecb06,ecb17             #FUN-A60028 add ecb012,ecu014
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 ELSE
    LET g_wc = " ecb01 ='",g_ecb.ecb01,"'",
               " AND ecb02 ='",g_ecb.ecb02,"'",
               " AND ecb03 ='",g_ecb.ecb03,"'",
               " AND ecb012='",g_ecb.ecb012,"'"   #FUN-A60028 add
 END IF
 IF INT_FLAG THEN RETURN END IF
 #資料權限的檢查
 #Begin:FUN-980030
 # IF g_priv2='4' THEN                           #只能使用自己的資料
 #     LET g_wc = g_wc clipped," AND ecbuser = '",g_user,"'"
 # END IF
 # IF g_priv3='4' THEN                           #只能使用相同群的資料
 #     LET g_wc = g_wc clipped," AND ecbgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
 # END IF
 
 # IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
 #     LET g_wc = g_wc clipped," AND ecbgrup IN ",cl_chk_tgrup_list()
 # END IF
 LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecbuser', 'ecbgrup')
 #End:FUN-980030
 
 IF g_flag = 'N'  THEN  #參數是否有值
    CONSTRUCT g_wc2 ON ecw05,ecw06                # 螢幕上取單身條件
          FROM s_ecw[1].ecw05,s_ecw[1].ecw06
 
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
 ELSE
    LET g_wc2=" 1=1"
 END IF
 IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
  # LET g_sql = "SELECT ecb01,ecb02,ecb03,ecb06,rowid FROM ecb_file ",               #No.TQC-930162
    LET g_sql = "SELECT ecb01,ecb02,ecb03,ecb06,ecb17,ecb012 FROM ecb_file ",         #No.TQC-930162   #FUN-A60028 add ecb012
                " WHERE ", g_wc CLIPPED,
                " ORDER BY ecb01,ecb02,ecb03,ecb06,ecb012"   #FUN-A60028 add ecb012
 ELSE					# 若單身有輸入條件
  # modify by No.TQC-730091
  #  LET g_sql = "SELECT ecb01,ecb02,ecb03,ecb06, UNIQUE ecb_file.rowid ",
  #  LET g_sql = "SELECT UNIQUE ecb01,ecb02,ecb03,ecb06,ecb_file.rowid ",            #No.TQC-930162     
     LET g_sql = "SELECT UNIQUE ecb01,ecb02,ecb03,ecb06,ecb17,ecb012 ",       #No.TQC-930162   #FUN-A60028 add ecb012
                " FROM  ecb_file, ecw_file ",
                " WHERE ecb01 = ecw01",
                " AND ecb02 = ecw02",
                " AND ecb03 = ecw03",
                " AND ecb012= ecw012",   #FUN-A60028 
                " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                " ORDER BY ecb01,ecb02,ecb03,ecb06,ecb012"        #FUN-A60028 add ecb012
 END IF
 
 PREPARE i612_prepare FROM g_sql
 DECLARE i612_cs                         #SCROLL CURSOR
    SCROLL CURSOR WITH HOLD FOR i612_prepare
 
 IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
     LET g_sql="SELECT COUNT(*) FROM ecb_file ",
               " WHERE ", g_wc CLIPPED
 ELSE
     LET g_sql=
   # modify by No.TQC-730091
   #            " SELECT UNIQUE COUNT(*) " ,
               " SELECT COUNT(UNIQUE(ecb01,ecb02,ecb03,ecb012)) " ,   #FUN-A60028 add ecb012
               " FROM ecb_file,ecw_file WHERE ",
               " ecb01=ecw01 AND ecb02=ecw02 AND ",
               " ecb03=ecw03 ",
               " AND ecb012= ecw012",                   #FUN-A60028 add
               " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
 END IF
    PREPARE i612_precount FROM g_sql
    DECLARE i612_count CURSOR FOR i612_precount
END FUNCTION
 
FUNCTION i612_menu()
 
   WHILE TRUE
      CALL i612_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i612_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i612_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i612_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i612_out()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecw),'','')
            END IF
##
        #No.FUN-6A0039-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ecb.ecb01 IS NOT NULL THEN
                LET g_doc.column1 = "ecb01"
                LET g_doc.column2 = "ecb02"
                LET g_doc.column3 = "ecb03"
                LET g_doc.column4 = "ecb06"
                LET g_doc.column5 = "ecb012"       #FUN-A60028 add
                LET g_doc.value1 = g_ecb.ecb01
                LET g_doc.value2 = g_ecb.ecb02
                LET g_doc.value3 = g_ecb.ecb03
                LET g_doc.value4 = g_ecb.ecb06
                LET g_doc.value5 = g_ecb.ecb012      #FUN-A60028 add
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0039-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i612_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
#    INITIALIZE g_ecb.* TO NULL              #No.FUN-6A0039   #No.TQC-740341
    CLEAR FORM
   CALL g_ecw.clear()
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i612_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i612_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ecb.* TO NULL
    ELSE
       OPEN i612_count
       FETCH i612_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i612_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i612_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式   #No.FUN-680073 VARCHAR(1) 
    l_abso          LIKE type_file.num10,  #絕對的筆數 #No.FUN-680073 INTEGER
    l_ecbuser       LIKE ecb_file.ecbuser, #FUN-4C0034
    l_ecbgrup       LIKE ecb_file.ecbgrup  #FUN-4C0034
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i612_cs INTO g_ecb.ecb01,
                               #g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17                  #No.TQC-930162
                                g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17,g_ecb.ecb012  #No.TQC-930162 #FUN-A60028 add ecb012      
        WHEN 'P' FETCH PREVIOUS i612_cs INTO g_ecb.ecb01,
                               #g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17                  #No.TQC-930162
                                g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17,g_ecb.ecb012 #No.TQC-930162  #FUN-A60028 add ecb012    
        WHEN 'F' FETCH FIRST    i612_cs INTO g_ecb.ecb01,
                               #g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17                  #No.TQC-930162
                                g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17,g_ecb.ecb012  #No.TQC-930162  #FUN-A60028 add ecb012    
        WHEN 'L' FETCH LAST     i612_cs INTO g_ecb.ecb01,
                               #g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17                  #No.TQC-930162
                                g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17,g_ecb.ecb012   #No.TQC-930162  #FUN-A60028 add ecb012     
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
            FETCH ABSOLUTE g_jump i612_cs INTO g_ecb.ecb01,
                                    g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb17,g_ecb.ecb012   #FUN-A60028 add ecb012
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',g_ecb.ecb03 CLIPPED,
                 '+',g_ecb.ecb012 CLIPPED                                             #FUN-A60028 add ecb012
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
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
    SELECT ecb01,ecb02,ecb03,ecb06,ecb17,ecb012,ecbuser,ecbgrup      #FUN-A60028 add ecb012
      INTO g_ecb.*,l_ecbuser,l_ecbgrup  #FUN-4C0034 modify
      FROM ecb_file 
     WHERE ecb01 = g_ecb.ecb01 AND ecb02 = g_ecb.ecb02 AND ecb03 = g_ecb.ecb03 
       AND ecb012= g_ecb.ecb012           #FUN-A60028 add
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED        #FUN-A60028 add ecb012
#      CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("sel","ecb_file",g_msg,"",SQLCA.SQLCODE,"","",1) #FUN-660091
       INITIALIZE g_ecb.* TO NULL
       RETURN
#FUN-4C0034
    ELSE
       LET g_data_owner = l_ecbuser      #FUN-4C0034
       LET g_data_group = l_ecbgrup      #FUN-4C0034
       CALL i612_show()                  # 重新顯示
    END IF
##
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i612_show()
 DEFINE   l_ima02       LIKE ima_file.ima02,
          l_ima021      LIKE ima_file.ima021
 DEFINE   l_ecu014      LIKE ecu_file.ecu014              #FUN-A60028 add
 
    DISPLAY BY NAME g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,
                    g_ecb.ecb06,g_ecb.ecb17,g_ecb.ecb012       #FUN-A60028 add g_ecb.ecb012

#FUN-A60028 --begin--
    LET l_ecu014 = NULL
    SELECT ecu014 INTO l_ecu014 FROM ecu_file
     WHERE ecu01  = g_ecb.ecb01
       AND ecu02  = g_ecb.ecb02
       AND ecu012 = g_ecb.ecb012
    DISPLAY l_ecu014 TO ecu014   
#FUN-A60028 --end--
 
    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
     WHERE ima01 = g_ecb.ecb01
    DISPLAY l_ima02  TO ima02
    DISPLAY l_ima021 TO ima021
 
    CALL i612_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i612_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680073 SMALLINT
    l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680073 VARCHAR(1)
    l_ans           LIKE type_file.chr1,          #直接由作業資料描述說明檔輸入 #No.FUN-680073 VARCHAR(01)
    l_buf           LIKE type_file.chr1000,       #直接由作業資料描述說明檔輸入 #No.FUN-680073 VARCHAR(60)
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680073 SMALLINT
 
    LET g_action_choice = ""
    IF g_ecb.ecb01 IS NULL THEN
       RETURN
    END IF

#FUN-A60028 --begin--
   IF g_ecb.ecb012 IS NULL THEN 
      RETURN 
   END IF    
#FUN-A60028 --end--
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
#若無單身資料則由ecz_file中直接抓資料
    IF g_rec_b  = 0  THEN
       LET l_ans = NULL
       CALL cl_getmsg('mfg4077',g_lang) RETURNING l_buf
       CALL cl_prompt(10,3,l_buf) RETURNING l_ans
       IF l_ans THEN
          CALL i612_bf_ecz()
       END IF
    END IF
 
    LET g_forupd_sql = "SELECT ecw05,ecw06 FROM ecw_file ",
                       " WHERE ecw01= ? AND ecw02= ? AND ecw03= ? ",
                       " AND ecw05= ? AND ecw012 = ? FOR UPDATE"         #FUN-A60028 add ecw012
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i612_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ecw WITHOUT DEFAULTS FROM s_ecw.*
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
 
            IF g_rec_b >= l_ac THEN
 
               BEGIN WORK
 
               LET p_cmd='u'
               LET g_ecw_t.* = g_ecw[l_ac].*  #BACKUP
 
               OPEN i612_bcl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,
                                   g_ecw_t.ecw05,g_ecb.ecb012            #FUN-A60028 add g_ecb.ecb012
               IF STATUS THEN
                  CALL cl_err("OPEN i612_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i612_bcl INTO g_ecw[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ecw_t.ecw05,SQLCA.sqlcode,1)
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
            INSERT INTO ecw_file(ecw01,ecw02,ecw03,ecw05,ecw06,ecw012)  #FUN-A60028 add ecw012
                          VALUES(g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,
                                 g_ecw[l_ac].ecw05,g_ecw[l_ac].ecw06,g_ecb.ecb012)   #FUN-A60028 add g_ecb.ecb012
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ecw[l_ac].ecw05,SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("ins","ecw_file",g_ecb.ecb01,g_ecw[l_ac].ecw05,SQLCA.SQLCODE,"","",1) #FUN-660091
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ecw[l_ac].* TO NULL      #900423
            LET g_ecw_t.* = g_ecw[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ecw05
 
        BEFORE FIELD ecw05                        #default 序號
            IF g_ecw[l_ac].ecw05 IS NULL OR
               g_ecw[l_ac].ecw05 = 0 THEN
               SELECT max(ecw05)+1
                  INTO g_ecw[l_ac].ecw05
                  FROM ecw_file
                  WHERE ecw01 = g_ecb.ecb01 AND ecw02 = g_ecb.ecb02
                    AND ecw03 = g_ecb.ecb03
                    AND ecw012= g_ecb.ecb012        #FUN-A60028 add                        
               #若為第一次輸入,則其值為1
               IF g_ecw[l_ac].ecw05 IS NULL THEN
                  LET g_ecw[l_ac].ecw05 = 1
               END IF
            END IF
 
        AFTER FIELD ecw05                        #check 序號是否重複
            IF NOT cl_null(g_ecw[l_ac].ecw05) THEN
               IF g_ecw[l_ac].ecw05 != g_ecw_t.ecw05 OR
                  g_ecw_t.ecw05 IS NULL THEN
                  SELECT count(*) INTO l_n FROM ecw_file
                   WHERE ecw01 = g_ecb.ecb01
                     AND ecw02 = g_ecb.ecb02
                     AND ecw03 = g_ecb.ecb03
                     AND ecw05 = g_ecw[l_ac].ecw05
                     AND ecw012= g_ecb.ecb012          #FUN-A60028 add
                  IF l_n > 0 THEN
                     CALL cl_err(g_ecw[l_ac].ecw05,-239,0)
                     LET g_ecw[l_ac].ecw05 = g_ecw_t.ecw05
                     NEXT FIELD ecw05
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ecw_t.ecw05 > 0 AND
               g_ecw_t.ecw05 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM ecw_file
                WHERE ecw01 = g_ecb.ecb01
                  AND ecw02 = g_ecb.ecb02
                  AND ecw03 = g_ecb.ecb03
                  AND ecw05 = g_ecw_t.ecw05
                  AND ecw012= g_ecb.ecb012       #FUN-A60028 add
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ecw_t.ecw05,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("del","ecw_file",g_ecb.ecb01,g_ecw_t.ecw05,SQLCA.SQLCODE,"","",1) #FUN-660091
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
 
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ecw[l_ac].* = g_ecw_t.*
               CLOSE i612_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ecw[l_ac].ecw05,-263,1)
               LET g_ecw[l_ac].* = g_ecw_t.*
            ELSE
               UPDATE ecw_file SET ecw05=g_ecw[l_ac].ecw05,
                                   ecw06=g_ecw[l_ac].ecw06
                WHERE ecw01=g_ecb.ecb01
                  AND ecw02=g_ecb.ecb02
                  AND ecw03=g_ecb.ecb03
                  AND ecw05=g_ecw_t.ecw05
                  AND ecw012=g_ecb.ecb012        #FUN-A60028 add
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ecw[l_ac].ecw05,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("upd","ecw_file",g_ecb.ecb01,g_ecw_t.ecw05,SQLCA.SQLCODE,"","",1) #FUN-660091
                  LET g_ecw[l_ac].* = g_ecw_t.*
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
                  LET g_ecw[l_ac].* = g_ecw_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ecw.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i612_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
    #mark輸入時才能正常insert資料
    #       LET g_ecw_t.* = g_ecw[l_ac].*     #TQC-5B0111 &051112
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i612_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i612_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ecw05) AND l_ac > 1 THEN
               LET g_ecw[l_ac].* = g_ecw[l_ac-1].*
               DISPLAY g_ecw[l_ac].* TO s_ecw[l_ac].*
               NEXT FIELD ecw05
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
 
    CLOSE i612_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i612_b_askkey()
DEFINE
   #l_wc2           VARCHAR(200) #TQC-630166  
    l_wc2           STRING    #TQC-630166  
 
    CONSTRUCT l_wc2 ON ecw05,ecw06 FROM s_ecw[1].ecw05,s_ecw[1].ecw06
 
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL i612_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i612_bf_ecz()              #BODY FILL UP
DEFINE
        g_sql1     LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(255) 
        g_cnt1     LIKE type_file.num5      # No.FUN-680073 SMALLINT  
 
    LET g_sql1= "SELECT '',ecz05,'' ",
                " FROM ecz_file ",
                " WHERE ecz01 ='",g_ecb.ecb06,"'",  #作業編號
                " ORDER BY 1"
    PREPARE i612_pb1 FROM g_sql1
    DECLARE ecw_cs1                      #SCROLL CURSOR
        CURSOR FOR i612_pb1
 
    CALL g_ecw.clear()
 
    LET g_cnt = 1
    LET g_cnt1= 0
    LET g_rec_b = 0
    FOREACH ecw_cs1 INTO g_ecw[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_ecw[g_cnt].ecw05 = g_cnt
        INSERT INTO ecw_file(ecw01,ecw02,ecw03,ecw05,ecw06,ecw012)  #FUN-A60028 add ecw012
                      VALUES(g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,
                             g_ecw[g_cnt].ecw05,g_ecw[g_cnt].ecw06,g_ecb.ecb012)   #FUN-A60028 add g_ecb.ecb012
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_ecw[g_cnt].ecw05,SQLCA.sqlcode,0) #No.FUN-660091
           CALL cl_err3("ins","ecw_file",g_ecb.ecb01,g_ecw[g_cnt].ecw05,SQLCA.SQLCODE,"","",1) #FUN-660091
           LET g_ecw[g_cnt].* = g_ecw_t.*
        END IF
        LET g_cnt = g_cnt + 1
 
    END FOREACH
    CALL g_ecw.deleteElement(g_cnt)    #No.TQC-5B0158 add
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i612_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           VARCHAR(200) TQC-630166     
    p_wc2           STRING    #TQC-630166    
 
    LET g_sql = "SELECT ecw05,ecw06,'' ",
                " FROM ecw_file",
                " WHERE ecw01 ='",g_ecb.ecb01,"' AND",  #作業編號
                " ecw02 ='",g_ecb.ecb02,"' AND ",
                " ecw03 ='",g_ecb.ecb03,"' AND ",
                " ecw012='",g_ecb.ecb012,"' AND ",  #FUN-A60028 
                 p_wc2 CLIPPED,                     #單身
                " ORDER BY 1"
    PREPARE i612_pb FROM g_sql
    DECLARE ecw_cs                       #SCROLL CURSOR
        CURSOR FOR i612_pb
 
    CALL g_ecw.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH ecw_cs INTO g_ecw[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_ecw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i612_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecw TO s_ecw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL i612_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i612_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i612_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i612_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i612_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
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
 
 
FUNCTION i612_copy()
DEFINE
    l_newno1         LIKE ecb_file.ecb01,
    l_newno2         LIKE ecb_file.ecb02,
    l_newno3         LIKE ecb_file.ecb03,
    l_newno4         LIKE ecb_file.ecb012,      #FUN-A60028 
    l_oldno1         LIKE ecb_file.ecb01,
    l_oldno2         LIKE ecb_file.ecb02,
    l_oldno3         LIKE ecb_file.ecb03,
    l_oldno4         LIKE ecb_file.ecb012,      #FUN-A60028 
    l_ecu014         LIKE ecu_file.ecu014       #FUN-A60028 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecb.ecb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

#FUN-A60028 --begin--
    IF g_ecb.ecb012 IS NULL THEN 
       CALL cl_err('',-400,0)
       RETURN
    END IF    
#FUN-A60028 --end--
    
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT l_newno1,l_newno2,l_newno4,l_newno3 FROM ecb01,ecb02,ecb012,ecb03     #FUN-A60028 add l_newno4,ecb012
    
#FUN-A60028 --begin--
        BEFORE INPUT 
          LET l_newno4 = ' ' 
          DISPLAY l_newno4 TO ecb012                 
#FUN-A60028 --end--
    
        BEFORE FIELD ecb01
	    IF g_sma.sma60 = 'Y' THEN # 若須分段輸入
	       CALL s_inp5(7,20,l_newno1) RETURNING l_newno1
	       DISPLAY l_newno1 TO ecb01
    	    END IF

#FUN-A60028 --begin--
       AFTER FIELD ecb012
         IF l_newno4 IS NULL THEN 
            LET l_newno4 = ' '
         END IF 
#FUN-A60028 --end--
 
        AFTER FIELD ecb03
            IF NOT cl_null(l_newno3) THEN
               #檢查欲複製之單頭資料是否存在
               SELECT ecb01 FROM ecb_file
                WHERE ecb01 = l_newno1
                  AND ecb02 = l_newno2 
                  AND ecb03 = l_newno3
                  AND ecb012= l_newno4    #FUN-A60028 add
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('','aec-014',0) #No.FUN-660091
                  CALL cl_err3("sel","ecb_file",l_newno1,l_newno2,"aec-014","","",1) #FUN-660091
                  NEXT FIELD ecb01
               END IF
               #檢查單身是否己存在
               SELECT count(*) INTO g_cnt FROM ecw_file
                WHERE ecw01 = l_newno1
                  AND ecw02 = l_newno2
                  AND ecw03 = l_newno3
                  AND ecw012= l_newno4         #FUN-A60028 add 
               IF g_cnt > 0 THEN
                  LET g_msg=l_newno1 CLIPPED,'+',l_newno2,'+',l_newno3
                  CALL cl_err(g_msg,'mfg0020',0)
                  LET l_newno1 = NULL LET l_newno2 = NULL
                  LET l_newno3 = NULL 
                  LET l_newno4 = NULL              #FUN-A60028 add
                  DISPLAY l_newno1 TO ecb01
                  DISPLAY l_newno2 TO ecb02
                  DISPLAY l_newno3 TO ecb03
                  DISPLAY l_newno4 TO ecb012       #FUN-A60028 add
                  NEXT FIELD ecb01
               END IF
            END IF
 
 #FUN-A60028 --begin--
       AFTER INPUT 
         IF INT_FLAG THEN 
            EXIT INPUT
         ELSE 
            IF l_newno4 IS NULL THEN LET l_newno4 = ' ' END IF 
            LET l_ecu014 = NULL
            SELECT ecu014 INTO l_ecu014 FROM ecu_file
             WHERE ecu01  = l_newno1
               AND ecu02  = l_newno2
               AND ecu012 = l_newno4
            DISPLAY l_ecu014 TO ecu014   
         END IF  
 #FUN-A60028 --end--
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end  
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_ecb.ecb01
        DISPLAY BY NAME g_ecb.ecb02
        DISPLAY BY NAME g_ecb.ecb03
        DISPLAY BY NAME g_ecb.ecb012   #FUN-A60028 add
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM ecw_file         #單身複製
        WHERE ecw01=g_ecb.ecb01 
          AND ecw02=g_ecb.ecb02
          AND ecw03 = g_ecb.ecb03
          AND ecw012= g_ecb.ecb012     #FUN-A60028 add
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02,'+',g_ecb.ecb03
#      CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("ins","x",g_msg,"",SQLCA.SQLCODE,"","",1) #FUN-660091
       RETURN
    END IF
 
    UPDATE x
        SET ecw01=l_newno1, 
            ecw02=l_newno2,
            ecw03=l_newno3,
            ecw012=l_newno4   #FUN-A60028 add
 
    INSERT INTO ecw_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02,'+',g_ecb.ecb03,
                 '+',g_ecb.ecb012       #FUN-A60028 add ecb012            
#      CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("ins","ecw_file",g_msg,"",SQLCA.SQLCODE,"","",1) #FUN-660091
       RETURN
    END IF
 
    LET g_msg=l_newno1 CLIPPED,'+',l_newno2,'+',l_newno3,'+',l_newno4    #FUN-A60028 add l_newno4
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
    LET l_oldno1 = g_ecb.ecb01
    LET l_oldno2 = g_ecb.ecb02
    LET l_oldno3 = g_ecb.ecb03
    LET l_oldno4 = g_ecb.ecb012    #FUN-A60028 add
    
#   SELECT ecb01,ecb02,ecb03,ecb06,rowid INTO g_ecb.*,g_ecb_rowid FROM ecb_file           #No.TQC-930162
    SELECT ecb01,ecb02,ecb03,ecb06,ecb17,ecb012 INTO g_ecb.* FROM ecb_file  #No.TQC-930162  #FUN-A60028 add ecb012
     WHERE ecb01 =  l_newno1 
       AND ecb02 = l_newno2
       AND ecb03 = l_newno3
       AND ecb012= l_newno4   #FUN-A60028 add
 
    CALL i612_show()
    CALL  i612_b()
#FUN-C30027---begin
#    LET g_ecb.ecb01 = l_oldno1
#    LET g_ecb.ecb02 = l_oldno2
#    LET g_ecb.ecb03 = l_oldno3
#    LET g_ecb.ecb012= l_oldno4     #FUN-A60028 add
#   #-----------No.MOD-790160 modify
#   #SELECT ecb01,ecb02ecb03,ecb06,rowid INTO g_ecb.*,g_ecb_rowid FROM ecb_file
#   #SELECT ecb01,ecb02,ecb03,ecb06,rowid INTO g_ecb.*,g_ecb_rowid FROM ecb_file           #No.TQC-930162 
#    SELECT ecb01,ecb02,ecb03,ecb06,ecb17,ecb012 INTO g_ecb.* FROM ecb_file     #No.TQC-930162 #FUN-A60028 add ecb012
#   #-----------No.MOD-790160 end
#     WHERE ecb01 = g_ecb.ecb01
#       AND ecb02 = g_ecb.ecb02
#       AND ecb03 = g_ecb.ecb03
#       AND ecb012= g_ecb.ecb012    #FUN-A60028 add
# 
#    CALL i612_show()
#FUN-C30027---end
    DISPLAY BY NAME g_ecb.ecb01
    DISPLAY BY NAME g_ecb.ecb02
    DISPLAY BY NAME g_ecb.ecb03
    DISPLAY BY NAME g_ecb.ecb06
    DISPLAY BY NAME g_ecb.ecb012    #FUN-A60028 add
 
END FUNCTION
 
FUNCTION i612_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
    sr              RECORD
        ecb01       LIKE ecb_file.ecb01,   #料號
        ecb02       LIKE ecb_file.ecb02,   #製程編號
        ecb03       LIKE ecb_file.ecb03,   #製程序號
        ecb06       LIKE ecb_file.ecb06,   #作業編號
        ecbacti     LIKE ecb_file.ecbacti,
        ecw05       LIKE ecw_file.ecw05,   #行序
        ecw06       LIKE ecw_file.ecw06    #說明
       ,ecb012      LIKE ecb_file.ecb012        #FUN-A60028 add 
                    END RECORD,
    l_name          LIKE type_file.chr20,    # No.FUN-680073 VARCHAR(20), #External(Disk) file name
    l_za05          LIKE type_file.chr1000   # No.FUN-680073 VARCHAR(40)
DEFINE l_wc         STRING                   #FUN-7B0100-add
 
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc2 = ' 1=1'
    END IF
    CALL cl_wait()
#   CALL cl_outnam('aeci612') RETURNING l_name     #FUN-7B0100-mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ecb01,ecb02,ecb03,ecb06,ecbacti,ecw05,ecw06,ecb012 ",   #FUN-A60028 add ecb012
              " FROM ecb_file,ecw_file ",
              " WHERE ecw01=ecb01 AND ecw02=ecb02 AND ecw03 = ecb03 ",
              "   AND ecw012=ecb012",        #FUN-A60028 add
              " AND ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED
 
#FUN-7B0100-mark
#
#   PREPARE i612_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i612_co CURSOR FOR i612_p1        # SCROLL CURSOR
 
#   START REPORT i612_rep TO l_name 
 
#   FOREACH i612_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i612_rep(sr.*)    
#   END FOREACH
 
#   FINISH REPORT i612_rep                
 
#   CLOSE i612_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#FUN-7B0100-mark-end
#FUN-7B0100-add
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
    IF g_zz05='Y' THEN 
        CALL cl_wcchp(g_wc2,'ecb01,ecb02,ecb03,ecb06,ecbacti,ecw05,ecw06,ecb012')  #FUN-A60028 add ecb012
        RETURNING l_wc
    END IF
    LET g_str=l_wc
    CALL cl_prt_cs1("aeci612","aeci612",g_sql,g_str)
#FUN-7B0100-add-end
 
END FUNCTION
 
#REPORT i612_rep(sr)
#DEFINE
#   #l_trailer_sw    VARCHAR(1),
#    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1) 
#    l_i             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
#    sr              RECORD
#        ecb01       LIKE ecb_file.ecb01,   #料號
#        ecb02       LIKE ecb_file.ecb02,   #製程編號
#        ecb03       LIKE ecb_file.ecb03,   #製程序號
#        ecb06       LIKE ecb_file.ecb06,   #作業編號
#        ecbacti     LIKE ecb_file.ecbacti, #
#        ecw05       LIKE ecw_file.ecw05,   #行序
#        ecw06       LIKE ecw_file.ecw06    #說明
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#    ORDER BY sr.ecb01,sr.ecb02,sr.ecb03,sr.ecw05
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            PRINT g_dash[1,g_len]
#            PRINT g_x[11] CLIPPED,
#                  column 10,sr.ecb01,
#
#          #TQC-5B0111 &051112
#          #       column 31,g_x[12] CLIPPED,
#          #       column 41,sr.ecb02
#                  column 65,g_x[12] CLIPPED, #FUN-590118
#                  column 75,sr.ecb02 #FUN-590118
#          #TQC-5B0111 &051112 -end
#
#            PRINT g_x[13] CLIPPED,
#                  column 10,sr.ecb03,
#          #TQC-5B0111 &051112
#          #       column 31,g_x[14] CLIPPED,
#          #       column 41,sr.ecb06
#                  column 65,g_x[14] CLIPPED, #FUN-590118
#                  column 75,sr.ecb06  #FUN-590118
#          #TQC-5B0111 &051112 -end
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.ecb03
#           SKIP TO TOP OF PAGE
# 
#        ON EVERY ROW
#            PRINT column g_c[31],sr.ecw05 USING '###&', #FUN-590118
#                  COLUMN g_c[32],sr.ecw06
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN#IF g_wc[001,080] > ' ' THEN
#        	   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                   #IF g_wc[071,140] > ' ' THEN
#        	   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                   #IF g_wc[141,210] > ' ' THEN
#        	   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#                    PRINT g_dash[1,g_len]
#            END IF
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
