# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi103.4gl
# Descriptions...: 產品結構元件說明維護作業
# Date & Author..: 91/08/06 By Wu
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4C0062 04/12/09 By Mandy bmpuser,bmpgrup無此欄位,abmi101,abmi103程式有作權限判斷應取消
# Modify.........: No.FUN-510033 05/01/19 By Mandy 報表轉XML
# Modify.........: No.FUN-560027 05/06/13 By Mandy 特性BOM+KEY 值bec06
# Modify.........: No.TQC-610097 06/01/19 By kevin g_bmp_rowid 重覆取出
# Modify.........: No.TQC-660046 06/06/09 By xumin cl_err修改為cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6C0053 06/12/13 By Judy 單身不能修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740211 07/04/26 By kim 按B.單身維護時，出現mfg2761此工程BOM已轉式正式BOM，但實際上尚未轉正式BOM
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770052 07/06/26 By xiaofeizhu 制作水晶報表
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-920025 09/02/11 By chenyu 搜尋單頭key的sql要加上bmp28 = bec06
# Modify.........: No.TQC-920038 09/02/16 By chenyu _copy(中，AFTER FIELD bmp03判斷有問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 BY vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bmp           RECORD LIKE bmp_file.*,
    g_bmp_t         RECORD LIKE bmp_file.*,
    g_bmp01_t       LIKE bmp_file.bmp01,   #主件編號-1 (舊值)
    g_bmp28_t       LIKE bmp_file.bmp28,   #FUN-560027 add
    g_bmp011_t      LIKE bmp_file.bmp011,  #主件版本-11(舊值)
    g_bmp02_t       LIKE bmp_file.bmp02,   #項次-2 (舊值)
    g_bmp03_t       LIKE bmp_file.bmp03,   #元件編號-3 (舊值)
    g_bec           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        bec04       LIKE bec_file.bec04,   #行序
        bec05       LIKE bec_file.bec05    #說明
                    END RECORD,
    g_bec_t         RECORD                 #程式變數 (舊值)
        bec04       LIKE bec_file.bec04,   #行序
        bec05       LIKE bec_file.bec05    #說明
                    END RECORD,
   #g_wc,g_wc2,g_sql    STRING,            #TQC-630166    #No.FUN-680096
    g_wc,g_wc2,g_sql    STRING,            #TQC-630166
    g_bmp01         LIKE bmp_file.bmp01,
    g_bmp28         LIKE bmp_file.bmp28,   #FUN-560027 add
    g_bmp02         LIKE bmp_file.bmp02,
    g_bmp03         LIKE bmp_file.bmp03,
    g_bmp011        LIKE bmp_file.bmp011,
    g_flag,g_flag2  LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數     #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
DEFINE g_forupd_sql     STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-680096 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   l_table        STRING                  ### FUN-770052 ###                                                                    
DEFINE   g_str          STRING                  ### FUN-770052 ###                                                                    
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABM")) THEN
        EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060
## *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##                                           
    LET g_sql = " bmp01.bmp_file.bmp01,",                                                                                   
                " ima02a.ima_file.ima02,",                                                                                 
                " ima021a.ima_file.ima021,",                                                                                
                " bmp011.bmp_file.bmp011,",                                                                                    
                " bmp02.bmp_file.bmp02,",                                                                                 
                " bmp03.bmp_file.bmp03,",                                                                               
                " bmq02a.bmq_file.bmq02,",                                                                             
                " bmq021a.bmq_file.bmq021,",                                                                    
                " bec04.bec_file.bec04,",
                " bec05.bec_file.bec05"
    LET l_table = cl_prt_temptable('abmi103',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#                                                                               
 
    LET g_bmp01  = ARG_VAL(1)              #主件編號
    LET g_bmp02  = ARG_VAL(2)              #項次
    LET g_bmp03  = ARG_VAL(3)              #元件
    LET g_bmp011 = ARG_VAL(4)              #元件
    LET g_bmp28  = ARG_VAL(5)              #FUN-560027 add
 
    LET g_forupd_sql =
        "SELECT * FROM bmp_file WHERE bmp01=g_bmp.bmp01 AND bmp28 =g_bmp.bmp28 AND bmp011 = g_bmp.bmp011 AND bmp02=g_bmp.bmp02 AND bmp03=g_bmp.bmp03 FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i103_w WITH FORM "abm/42f/abmi103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560027................begin
    CALL cl_set_comp_visible("bmp28",g_sma.sma118='Y')
    #FUN-560027................end
 
    IF NOT cl_null(g_bmp01) THEN
        LET g_flag = 'Y'
        IF cl_null(g_bmp02) THEN
            LET g_flag2='N'
        ELSE
            LET g_flag2='Y'
        END IF
 
        CALL i103_q()
 
        IF g_flag2='Y' THEN
           CALL i103_b()
 #         CALL i103_menu()
        ELSE
            CALL i103_menu()
        END IF
    ELSE
        LET g_flag = 'N'
        CALL i103_menu()
    END IF
 
    CLOSE WINDOW i103_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i103_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_bec.clear()
 IF cl_null(g_bmp01) THEN
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INITIALIZE g_bmp.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON  bmp01,bmp28,bmp011,bmp03,bmp02 #FUN-560027 add
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 ELSE
      LET g_wc = " bmp01 ='",g_bmp01,"'"
      IF NOT cl_null(g_bmp011) THEN
         LET g_wc = g_wc CLIPPED," AND bmp011 ='",g_bmp011,"'"
      END IF
      IF NOT cl_null(g_bmp02) THEN
         LET g_wc = g_wc CLIPPED," AND bmp02 ='",g_bmp02,"'"
      END IF
      IF NOT cl_null(g_bmp03) THEN
         LET g_wc = g_wc CLIPPED," AND bmp03 ='",g_bmp03,"'"
      END IF
      #FUN-560027 add
      LET g_wc = g_wc CLIPPED," AND bmp28 ='",g_bmp28,"'"
      #FUN-560027(end)
 END IF
    IF INT_FLAG THEN RETURN END IF
 #MOD-4C0062 MARK 掉
#   #資料權限的檢查
#   IF g_priv2='4' THEN                           #只能使用自己的資料
#       LET g_wc = g_wc clipped," AND bmpuser = '",g_user,"'"
#   END IF
#   IF g_priv3='4' THEN                           #只能使用相同群的資料
#       LET g_wc = g_wc clipped," AND bmpgrup MATCHES '",g_grup CLIPPED,"*'"
#   END IF
 
#   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#       LET g_wc = g_wc clipped," AND bmpgrup IN ",cl_chk_tgrup_list()
#   END IF
 
    IF g_flag = 'N'
    THEN
       CONSTRUCT g_wc2 ON bec04,bec05                # 螢幕上取單身條件
                FROM s_bec[1].bec04,s_bec[1].bec05
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
       LET g_sql = "SELECT  bmp01,bmp28,bmp011,bmp02,bmp03 FROM bmp_file ", #FUN-560027 add bmp28 #No.TQC-610097
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 2"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE bmp_file. bmp01,bmp28, bmp011,bmp02,bmp03 ", #FUN-560027 add bmp28 #No.TQC-610097
                   "  FROM bmp_file, bec_file ",
                   " WHERE bmp01 = bec01 AND bmp011=bec011 ",
                   "  AND bmp02 = bec02",
                   " AND bmp03 = bec021 ",
                   " AND bmp28=bec06 ", #No.TQC-920025 add
                   " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 2"
    END IF
 
    PREPARE i103_prepare FROM g_sql
    DECLARE i103_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i103_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bmp_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT UNIQUE COUNT(*) ",
                  " FROM bmp_file,bec_file WHERE ",
                  " bmp01=bec01 AND bmp011=bec011",
                  " AND bmp02=bec02",
                  " AND bmp03=bec021 ",
                  " AND bmp28=bec06 ", #FUN-560027 add
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i103_precount FROM g_sql
    DECLARE i103_count CURSOR FOR i103_precount
END FUNCTION
 
FUNCTION i103_menu()
 
   WHILE TRUE
      CALL i103_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i103_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i103_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i103_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i103_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmp.bmp01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmp01"
                  LET g_doc.value1  = g_bmp.bmp01
                  LET g_doc.column2 = "bmp011"
                  LET g_doc.value2  = g_bmp.bmp011
                  LET g_doc.column3 = "bmp02"
                  LET g_doc.value3  = g_bmp.bmp02
                  LET g_doc.column4 = "bmp03"
                  LET g_doc.value4  = g_bmp.bmp03
                  LET g_doc.column5 = "bmp28"      #FUN-560027 add
                  LET g_doc.value5  = g_bmp.bmp28  #FUN-560027 add
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bec),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
#Query 查詢
FUNCTION i103_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_bec.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i103_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_bmp.* TO NULL
        RETURN
    END IF
    OPEN i103_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmp.* TO NULL
    ELSE
        OPEN i103_count
        FETCH i103_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i103_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i103_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i103_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add
                                             g_bmp.bmp011,
                                             g_bmp.bmp02,g_bmp.bmp03              #No.TQC-610097
        WHEN 'P' FETCH PREVIOUS i103_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add
                                             g_bmp.bmp011,
                                             g_bmp.bmp02,g_bmp.bmp03              #No.TQC-610097
        WHEN 'F' FETCH FIRST    i103_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add
                                             g_bmp.bmp011,
                                             g_bmp.bmp02,g_bmp.bmp03              #No.TQC-610097
        WHEN 'L' FETCH LAST     i103_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add
                                             g_bmp.bmp011,
                                             g_bmp.bmp02,g_bmp.bmp03              #No.TQC-610097
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i103_cs INTO g_bmp.bmp01,g_bmp.bmp28, #FUN-560027 add
                                               g_bmp.bmp011,
                                               g_bmp.bmp02,g_bmp.bmp03              #No.TQC-610097
    END CASE
 
    IF SQLCA.sqlcode THEN
       LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp28 CLIPPED,'+',g_bmp.bmp011 CLIPPED,'+',g_bmp.bmp02  #FUN-560027 add bmp28
                 CLIPPED,'+',g_bmp.bmp03 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       INITIALIZE g_bmp.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_bmp.* FROM bmp_file WHERE bmp01=g_bmp.bmp01 AND bmp28 =g_bmp.bmp28 AND bmp011 = g_bmp.bmp011 AND bmp02=g_bmp.bmp02 AND bmp03=g_bmp.bmp03
    IF SQLCA.sqlcode THEN
       LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp28 CLIPPED,'+',g_bmp.bmp011 CLIPPED,'+',g_bmp.bmp02  #FUN-560027 add bmp28
                 CLIPPED,'+',g_bmp.bmp03 CLIPPED
    #  CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
       CALL cl_err3("sel","bmp_file",g_msg,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
       INITIALIZE g_bmp.* TO NULL
       RETURN
    END IF
    CALL i103_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i103_show()
    DEFINE l_ima02   LIKE ima_file.ima02
    DEFINE l_ima021  LIKE ima_file.ima021
 
    LET g_bmp_t.* = g_bmp.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_bmp.bmp01,g_bmp.bmp28,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03 #FUN-560027 add bmp28
    SELECT bmq02,bmq021 INTO l_ima02,l_ima021 FROM bmq_file WHERE bmq01=g_bmp.bmp01
    DISPLAY l_ima02 TO FORMONLY.ima02_1
    DISPLAY l_ima021 TO FORMONLY.ima021_1
    SELECT bmq02,bmq021 INTO l_ima02,l_ima021 FROM bmq_file WHERE bmq01=g_bmp.bmp03
    DISPLAY l_ima02 TO FORMONLY.ima02_2
    DISPLAY l_ima021 TO FORMONLY.ima021_2
    CALL i103_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i103_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用      #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否      #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否        #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0)  THEN RETURN END IF
    IF g_bmp.bmp01 IS NULL THEN
        RETURN
    END IF
    #no.6542
    SELECT * INTO g_bmp.* FROM bmp_file
     WHERE bmp01 = g_bmp.bmp01 AND bmp011 = g_bmp.bmp011
       AND bmp02 = g_bmp.bmp02 AND bmp03  = g_bmp.bmp03
       AND bmp28 = g_bmp.bmp28  #FUN-560027 add bmp28
    IF NOT cl_null(g_bmp.bmp04)
       AND (g_bmp.bmp04>0) THEN  #TQC-740211
       CALL cl_err('','mfg2761',0) RETURN
    END IF
    #no.6542(end)
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql =
     "  SELECT bec04,bec05 ",
     "  FROM bec_file          ",
     "   WHERE bec01  = ? ",
     "    AND bec011 = ? ",
     "    AND bec02  = ? ",
     "    AND bec021 = ? ",
     "    AND bec04  = ? ",
     "    AND bec06  = ? ", #FUN-560027 add
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
        INPUT ARRAY g_bec
              WITHOUT DEFAULTS
              FROM s_bec.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bec_t.* = g_bec[l_ac].*  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
                OPEN i103_bcl USING g_bmp.bmp01,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03,g_bec_t.bec04,g_bmp.bmp28 #FUN-560027 add bmp28
                IF STATUS THEN
                    CALL cl_err("OPEN i103_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i103_bcl INTO g_bec[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bec_t.bec04,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bec04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO bec_file(bec01,bec011,bec02,bec021,
                                 bec03,bec04,bec05,bec06)                #FUN-560027 add bec06
            VALUES(g_bmp.bmp01,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03,
                   NULL,g_bec[l_ac].bec04,g_bec[l_ac].bec05,g_bmp.bmp28) #FUN-560027 add bmp28
            IF SQLCA.sqlcode THEN
          #     CALL cl_err(g_bec[l_ac].bec04,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("ins","bec_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)   #No.TQC-660046
                #CKP
                CANCEL INSERT
            ELSE
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bec[l_ac].* TO NULL      #900423
            LET g_bec_t.* = g_bec[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bec04
 
        BEFORE FIELD bec04                        #default 序號
            IF g_bec[l_ac].bec04 IS NULL OR
               g_bec[l_ac].bec04 = 0 THEN
                SELECT max(bec04)+1
                   INTO g_bec[l_ac].bec04
                   FROM bec_file
                   WHERE bec01 = g_bmp.bmp01
                     AND bec011= g_bmp.bmp011
                     AND bec02 = g_bmp.bmp02
                     AND bec021 = g_bmp.bmp03
                     AND bec06  = g_bmp.bmp28   #FUN-560027 add
                IF g_bec[l_ac].bec04 IS NULL THEN
                    LET g_bec[l_ac].bec04 = 1
                END IF
            END IF
 
        AFTER FIELD bec04                        #check 序號是否重複
            IF NOT cl_null(g_bec[l_ac].bec04) THEN
                IF g_bec[l_ac].bec04 != g_bec_t.bec04 OR
                   g_bec_t.bec04 IS NULL THEN
                    SELECT count(*)
                        INTO l_n
                        FROM bec_file
                        WHERE bec01  = g_bmp.bmp01
                          AND bec011 = g_bmp.bmp011
                          AND bec02  = g_bmp.bmp02
                          AND bec021 = g_bmp.bmp03
                          AND bec04  = g_bec[l_ac].bec04
                          AND bec06  = g_bmp.bmp28   #FUN-560027 add
                    IF l_n > 0 THEN
                        CALL cl_err(g_bec[l_ac].bec04,-239,0)
                        LET g_bec[l_ac].bec04 = g_bec_t.bec04
                        NEXT FIELD bec04
                    END IF
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bec_t.bec04 > 0 AND
               g_bec_t.bec04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bec_file
                    WHERE bec01 = g_bmp.bmp01
                      AND bec011=g_bmp.bmp011
                      AND bec02 = g_bmp.bmp02
                      AND bec021 = g_bmp.bmp03
                      AND bec04 = g_bec_t.bec04
                      AND bec06  = g_bmp.bmp28   #FUN-560027 add
                IF SQLCA.sqlcode THEN
           #        CALL cl_err(g_bec_t.bec04,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("del","bec_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bec[l_ac].* = g_bec_t.*
               DISPLAY BY NAME g_bec[l_ac].*    #TQC-6C0053
               CLOSE i103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bec[l_ac].bec04,-263,1)
                LET g_bec[l_ac].* = g_bec_t.*
            ELSE
                UPDATE bec_file SET
                   bec04 = g_bec[l_ac].bec04,
                   bec05 = g_bec[l_ac].bec05
                 WHERE bec01  =g_bmp.bmp01
                   AND bec011 =g_bmp.bmp011
                   AND bec02  =g_bmp.bmp02
                   AND bec021 =g_bmp.bmp03
                   AND bec04  =g_bec_t.bec04
                   AND bec06  = g_bmp.bmp28   #FUN-560027 add
                IF SQLCA.sqlcode THEN
              #     CALL cl_err(g_bec[l_ac].bec04,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","bec_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    LET g_bec[l_ac].* = g_bec_t.*
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
               #CKP
               IF p_cmd='u' THEN
                  LET g_bec[l_ac].* = g_bec_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bec.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #CKP
           #LET g_bec_t.* = g_bec[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i103_bcl
            COMMIT WORK
 
     #  ON ACTION CONTROLN
     #      CALL i103_b_askkey()
     #      LET l_exit_sw = "n"
     #      EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bec04) AND l_ac > 1 THEN
                LET g_bec[l_ac].* = g_bec[l_ac-1].*
                DISPLAY BY NAME g_bec[l_ac].*      #TQC-6C0053
                NEXT FIELD bec04
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
 
    CLOSE i103_bcl
        COMMIT WORK
END FUNCTION
 
FUNCTION i103_b_askkey()
DEFINE
    l_wc2   LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON bec04,bec05
            FROM s_bec[1].bec04,s_bec[1].bec05
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
    CALL i103_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i103_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(200)
 
    LET g_sql =
        "SELECT bec04,bec05",
        " FROM bec_file",
        " WHERE bec01 ='",g_bmp.bmp01,"' AND",  #單頭-1
        " bec011='",g_bmp.bmp011,"' AND",       #單頭-011
        " bec02 ='",g_bmp.bmp02,"' AND",        #單頭-2
        " bec021='",g_bmp.bmp03,"' AND",        #單頭-3
        " bec06 ='",g_bmp.bmp28,"'",            #FUN-560027 add
        " AND ",p_wc2 CLIPPED,                  #單身
        " ORDER BY 1"
    PREPARE i103_pb FROM g_sql
    DECLARE bec_cs                       #SCROLL CURSOR
        CURSOR FOR i103_pb
 
    CALL g_bec.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bec_cs INTO g_bec[g_cnt].*   #單身 ARRAY 填充
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
    #CKP
    CALL g_bec.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bec TO s_bec.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i103_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i103_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i103_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i103_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i103_fetch('L')
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i103_copy()
DEFINE
    l_oldno1         LIKE bmp_file.bmp01,
    l_oldno2         LIKE bmp_file.bmp02,
    l_oldno3         LIKE bmp_file.bmp03,
    l_oldno11        LIKE bmp_file.bmp011,
    l_oldno28        LIKE bmp_file.bmp28, #FUN-560027 add
    l_newno1         LIKE bmp_file.bmp01,
    l_newno28        LIKE bmp_file.bmp28, #FUN-560027 add
    l_newno11        LIKE bmp_file.bmp011,
    l_newno2         LIKE bmp_file.bmp02,
    l_newno3         LIKE bmp_file.bmp03
    DEFINE l_ima02   LIKE ima_file.ima02
    DEFINE l_ima021  LIKE ima_file.ima021
 
    IF s_shut(0)  THEN RETURN END IF
    IF g_bmp.bmp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY "" TO bmp01
    DISPLAY "" TO bmp28  #FUN-560027 add
    DISPLAY "" TO bmp011
    DISPLAY "" TO bmp02
    DISPLAY "" TO bmp03
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
    INPUT l_newno1,l_newno28,l_newno11,l_newno2,l_newno3 FROM bmp01,bmp28,bmp011,bmp02,bmp03 #FUN-560027 add bmp28
        BEFORE FIELD bmp01
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(6,27,l_newno1) RETURNING l_newno1
	            DISPLAY l_newno1 TO bmp01
	    END IF
 
        AFTER FIELD bmp01
            IF l_newno1 IS NULL THEN
                NEXT FIELD bmp01
            END IF
            #FUN-AA0059 ------------------------add start--------------------------
            IF NOT s_chk_item_no(l_newno1,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bmp01
            END IF 
            #FUN-AA0059 -------------------------add end---------------------------  
	    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = l_newno1
	    IF SQLCA.sqlcode THEN
	        SELECT bmq02,bmq021 INTO l_ima02,l_ima021 FROM bmq_file WHERE bmq01 = l_newno1
	        IF SQLCA.sqlcode THEN
              #    CALL cl_err(l_newno1,'mfg0002',0) #No.TQC-660046
                   CALL cl_err3("sel","bmq_file",l_newno1,"","mfg0002","","",1)   #No.TQC-660046
                   NEXT FIELD bmp01
	        END IF
            ELSE
                DISPLAY l_ima02 TO FORMONLY.ima02_1
                DISPLAY l_ima021 TO FORMONLY.ima021_1
	    END IF
 
        BEFORE FIELD bmp02
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(7,27,l_newno2) RETURNING l_newno2
	               DISPLAY l_newno2 TO bmp02
	       END IF
 
        AFTER FIELD bmp02
            IF l_newno2 IS NULL THEN
                NEXT FIELD bmp02
            END IF
 
        AFTER FIELD bmp03
            IF l_newno3 IS NULL THEN
                NEXT FIELD bmp03
            END IF
            #FUN-AA0059 ------------------------------add start--------------------------
            IF NOT s_chk_item_no(l_newno3,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bmp03
            END IF 
            #FUN-AA0059 -----------------------------add end--------------------------- 
	    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = l_newno3
	    IF SQLCA.sqlcode THEN
	        SELECT bmq02,bmq021 INTO l_ima02,l_ima021 FROM bmq_file WHERE bmq01 = l_newno3
	        IF SQLCA.sqlcode THEN
             #     CALL cl_err(l_newno3,'mfg0002',0) #No.TQC-660046
                   CALL cl_err3("sel","bmq_file",l_newno3,"",'mfg0002',"","",1)  #No.TQC-660046
                   NEXT FIELD bmp03
	        END IF
            ELSE
                DISPLAY l_ima02 TO FORMONLY.ima02_1
                DISPLAY l_ima021 TO FORMONLY.ima021_1
	    END IF
            SELECT count(*) INTO g_cnt FROM bmp_file
                WHERE bmp01 = l_newno1 AND bmp011 = l_newno11
                  AND bmp02 = l_newno2 AND bmp03 = l_newno3
                  AND bmp28 = l_newno28 #FUN-560027 add bmp28
           #IF g_cnt = 0 THEN     #No.TQC-920038 mark
            IF g_cnt > 0 THEN     #No.TQC-920038 add
                LET g_msg=l_newno1 CLIPPED,'+',l_newno28 CLIPPED,'+',l_newno11 CLIPPED,'+', #FUN-560027 add bmp28
                          l_newno2 CLIPPED,'+',l_newno3
                CALL cl_err(g_msg,'abm-007',0)
                NEXT FIELD bmp01
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
        DISPLAY BY NAME g_bmp.bmp01
        DISPLAY BY NAME g_bmp.bmp28  #FUN-560027 add bmp28
        DISPLAY BY NAME g_bmp.bmp011
        DISPLAY BY NAME g_bmp.bmp02
        DISPLAY BY NAME g_bmp.bmp03
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM bmp_file         #單頭複製
        WHERE bmp01=g_bmp.bmp01 AND bmp011=g_bmp.bmp011
          AND bmp02=g_bmp.bmp02 AND bmp03=g_bmp.bmp03
          AND bmp28=g_bmp.bmp28  #FUN-560027 add bmp28
        INTO TEMP y
    UPDATE y
        SET y.bmp01 =l_newno1,   #新的鍵值-1
            y.bmp28 =l_newno28,  #FUN-560027 add
            y.bmp011=l_newno11,  #新的鍵值-011
            y.bmp02 =l_newno2,   #新的鍵值-2
            y.bmp03 =l_newno3    #新的鍵值-3
    INSERT INTO bmp_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM bec_file         #單身複製
        WHERE bec01=g_bmp.bmp01 AND bec011=g_bmp.bmp011
          AND bec02=g_bmp.bmp02 AND bec021=g_bmp.bmp03
          AND bec06=g_bmp.bmp28 #FUN-560027 add
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp28 CLIPPED,'+',g_bmp.bmp011 CLIPPED, #FUN-560027 add bmp28
                  g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03 CLIPPED
       #CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("ins","x",g_msg,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
        RETURN
    END IF
    UPDATE x
        SET bec01=l_newno1,bec06=l_newno28, bec011=l_newno11,bec02=l_newno2,  #FUN-560027 add bmp28
            bec021=l_newno3
    INSERT INTO bec_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmp.bmp01 CLIPPED,'+',g_bmp.bmp28 CLIPPED,'+',g_bmp.bmp011 CLIPPED, #FUN-560027 add bmp28
                  g_bmp.bmp02 CLIPPED,'+',g_bmp.bmp03 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("ins","bec_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
        RETURN
    END IF
    LET g_msg=l_newno1 CLIPPED,'+',l_newno28 CLIPPED,'+',l_newno11 CLIPPED,'+', #FUN-560027 add newno28
              l_newno2 CLIPPED,'+',l_newno3 CLIPPED
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
    DISPLAY BY NAME g_bmp.bmp01
    DISPLAY BY NAME g_bmp.bmp28  #FUN-560027 add
    DISPLAY BY NAME g_bmp.bmp011
    DISPLAY BY NAME g_bmp.bmp02
    DISPLAY BY NAME g_bmp.bmp03
    LET l_oldno1 = g_bmp.bmp01
    LET l_oldno28= g_bmp.bmp28  #FUN-560027 add
    LET l_oldno11= g_bmp.bmp011
    LET l_oldno2 = g_bmp.bmp02
    LET l_oldno3 = g_bmp.bmp03
    LET g_bmp.bmp01 = l_newno1
    LET g_bmp.bmp28 = l_newno28  #FUN-560027 add
    LET g_bmp.bmp011= l_newno11
    LET g_bmp.bmp02 = l_newno2
    LET g_bmp.bmp03 = l_newno3
    SELECT bmd01,bmd02,bmd03
      INTO g_bmp.bmp01,g_bmp.bmp02,g_bmp.bmp03
      FROM bmd_file WHERE bmd01 = l_newno1 AND bmp011=l_newno11
                      AND bmp02 = l_newno2 AND bmp03 = l_newno3
                      AND bmp28 = l_newno28 #FUN-560027 add
                      AND bmdacti = 'Y'                                           #CHI-910021
 
    CALL i103_show()
    CALL i103_b()
    #FUN-C30027---begin
    #LET g_bmp.bmp01 = l_oldno1
    #LET g_bmp.bmp28 = l_oldno28 #FUN-560027 add
    #LET g_bmp.bmp011= l_oldno11
    #LET g_bmp.bmp02 = l_oldno2
    #LET g_bmp.bmp03 = l_oldno3
    #SELECT bmp01,bmp011,bmp02,bmp03,bmp28                                     #FUN-560027 add bmp28
    #  INTO g_bmp.bmp01,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03,g_bmp.bmp28 #FUN-560027 add bmp28
    #  FROM bmp_file WHERE bmp01 = l_oldno1 AND bmp02 = l_oldno2
    #                  AND bmp03 = l_oldno3 AND bmp011= l_oldno11
    #                  AND bmp28 = l_oldno28  #FUN-560027 add bmp28
    #CALL i103_show()
    #FUN-C30027---end
END FUNCTION
 
FUNCTION i103_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680096 SMALLINT
    sr              RECORD
        bmp01       LIKE bmp_file.bmp01,   #主件編號
        bmp011      LIKE bmp_file.bmp011,  #版本
        bmp02       LIKE bmp_file.bmp02,   #項次
        bmp03       LIKE bmp_file.bmp03,   #元件編號
        bec04       LIKE bec_file.bec04,   #行序
        bec05       LIKE bec_file.bec05    #說明
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096  VARCHAR(40)
    DEFINE l_ima02_a    LIKE ima_file.ima02  #FUN-770052                                                                                
    DEFINE l_ima021_a   LIKE ima_file.ima021 #FUN-770052                                                                                
    DEFINE l_ima02_b    LIKE ima_file.ima02  #FUN-770052                                                                                
    DEFINE l_ima021_b   LIKE ima_file.ima021 #FUN-770052 
    DEFINE l_sql        STRING               #FUN-770052    
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abmi103') RETURNING l_name               #FUN-770052
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
    CALL cl_del_data(l_table)                                                                                                      
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
    #------------------------------ CR (2) ------------------------------#
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT bmp01,bmp011,bmp02,bmp03,bec04,bec05 ",
          " FROM bmp_file,bec_file ",
          " WHERE bec01=bmp01 AND bec011 = bmp011 ",
          " AND bec02=bmp02 AND bec021=bmp03 ",
          " AND bec06=bmp28 ", #FUN-560027 add
          " AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    
    PREPARE i103_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i103_co                         # CURSOR
        CURSOR FOR i103_p1
 
#    START REPORT i103_rep TO l_name          #FUN-770052
 
    FOREACH i103_co INTO sr.*
    #--NO.FUN-770052--begin--#
     SELECT ima02,ima021 INTO l_ima02_a,l_ima021_a                                                                           
             FROM ima_file                                                                                                         
             WHERE ima01 = sr.bmp01                                                                                                 
             IF SQLCA.sqlcode THEN                                                                                                   
                SELECT bmq02,bmq021 INTO l_ima02_a,l_ima021_a                                                                       
                FROM bmq_file                                                                                                     
                WHERE bmq01 = sr.bmp01                                                                                             
                IF SQLCA.sqlcode THEN                                                                                               
                    LET l_ima02_a  = NULL                                                                                           
                    LET l_ima021_a = NULL                                                                                           
                END IF                                                                                                              
            END IF                                                                                                                  
            SELECT ima02,ima021 INTO l_ima02_b,l_ima021_b                                                                           
             FROM ima_file                                                                                                         
             WHERE ima01 = sr.bmp03                                                                                                 
            IF SQLCA.sqlcode THEN                                                                                                   
                SELECT bmq02,bmq021 INTO l_ima02_b,l_ima021_b                                                                       
                 FROM bmq_file                                                                                                     
                 WHERE bmq01 = sr.bmp03                                                                                             
                IF SQLCA.sqlcode THEN                                                                                               
                    LET l_ima02_b  = NULL                                                                                           
                    LET l_ima021_b = NULL                                                                                           
                END IF
            END IF 
      #--NO.FUN-770052--end--#
        IF SQLCA.sqlcode THEN                            
           CALL cl_err('foreach:',SQLCA.sqlcode,1)       
           EXIT FOREACH    
        END IF                              
    ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.bmp01,l_ima02_a,l_ima021_a,sr.bmp011,sr.bmp02,                                                                    
                   sr.bmp03,l_ima02_b,l_ima021_b,sr.bec04,sr.bec05                                                                  
        #------------------------------ CR (3) ------------------------------#
#      OUTPUT TO REPORT i103_rep(sr.*)                     # FUN-770052
    END FOREACH
#--No.FUN-770052--str--add--#                                                                                                       
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'bmp01,bmp28,bmp011,bmp03,bmp02')                                                                                                       
            RETURNING g_wc                                                                                                          
    END IF                                                                                                                          
#--No.FUN-770052--end--add--#
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                     
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                             
    LET g_str = ''                                                                                                                  
    LET g_str = g_wc                          
    CALL cl_prt_cs3('abmi103','abmi103',l_sql,g_str)        #FUN-770052                                                     
    #------------------------------ CR (4) ------------------------------# 
 
#   FINISH REPORT i103_rep                                  #FUN-770052
 
#    CLOSE i103_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
{ REPORT i103_rep(sr)                    #FUN-770052
DEFINE l_ima02_a    LIKE ima_file.ima02  #FUN-510033
DEFINE l_ima021_a   LIKE ima_file.ima021 #FUN-510033
DEFINE l_ima02_b    LIKE ima_file.ima02  #FUN-510033
DEFINE l_ima021_b   LIKE ima_file.ima021 #FUN-510033
DEFINE
    l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_i             LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    sr              RECORD
        bmp01       LIKE bmp_file.bmp01,   #主件編號
        bmp011      LIKE bmp_file.bmp011,  #版本
        bmp02       LIKE bmp_file.bmp02,   #項次
        bmp03       LIKE bmp_file.bmp03,   #元件編號
        bec04       LIKE bec_file.bec04,   #行序
        bec05       LIKE bec_file.bec05    #說明
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bmp01,sr.bmp011,sr.bmp02,sr.bmp03,sr.bec04
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.bmp03  #項次
            SELECT ima02,ima021 INTO l_ima02_a,l_ima021_a
              FROM ima_file
             WHERE ima01 = sr.bmp01
            IF SQLCA.sqlcode THEN
	        SELECT bmq02,bmq021 INTO l_ima02_a,l_ima021_a
                  FROM bmq_file
                 WHERE bmq01 = sr.bmp01
                IF SQLCA.sqlcode THEN
                    LET l_ima02_a  = NULL
                    LET l_ima021_a = NULL
                END IF
            END IF
            SELECT ima02,ima021 INTO l_ima02_b,l_ima021_b
              FROM ima_file
             WHERE ima01 = sr.bmp03
            IF SQLCA.sqlcode THEN
	        SELECT bmq02,bmq021 INTO l_ima02_b,l_ima021_b
                  FROM bmq_file
                 WHERE bmq01 = sr.bmp03
                IF SQLCA.sqlcode THEN
                    LET l_ima02_b  = NULL
                    LET l_ima021_b = NULL
                END IF
            END IF
            PRINT COLUMN g_c[31],sr.bmp01,
                  COLUMN g_c[32],l_ima02_a,
                  COLUMN g_c[33],l_ima021_a,
                  COLUMN g_c[34],sr.bmp011,
                  COLUMN g_c[35],sr.bmp02 using '###&',
                  COLUMN g_c[36],sr.bmp03,
                  COLUMN g_c[37],l_ima02_b,
                  COLUMN g_c[38],l_ima021_b;
        ON EVERY ROW
            PRINT COLUMN g_c[39],sr.bec04 using '###&',
                  COLUMN g_c[40],sr.bec05
 
        AFTER  GROUP OF sr.bmp03  #項次
            PRINT ' '
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN#IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    PRINT g_dash
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            LET l_trailer_sw = 'n'
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT }                                               #FUN-770052
