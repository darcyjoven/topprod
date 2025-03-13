# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axci060.4gl 
# Descriptions...: 產品別成本項目設定作業 
# Date & Author..: 01/11/20 BY DS/P
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0099 05/01/28 By kim 報表轉XML功能
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660160 06/06/23 By Sarah 根據參數(ccz06)決定cak02開窗為'部門代號'或'作業編號'或'工作中心'
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740120 07/04/17 By Sarah PROMPT訊息沒照規範寫,增加p_ze訊息axc-051
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780017 07/07/25 By dxfwo CR報表的制作
# Modify.........: No.TQC-970160 09/07/20 By destiny 1.把成本中心的檢查改在after field后面                                          
#                                                    2.去掉不用的cn3                                                                
#                                                    3.增加第一筆和最后一筆按鈕 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_cak01         LIKE cak_file.cak01,
    g_cak01_t       LIKE cak_file.cak01,
    g_cak           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cak02       LIKE cak_file.cak02,   #成本中心
        cak03       LIKE cak_file.cak03,   #成本項目
        cab02       LIKE cab_file.cab02    #成本項目說明
                    END RECORD,
    g_cak_t         RECORD                 #程式變數 (舊值)
        cak02       LIKE cak_file.cak02,   #成本中心
        cak03       LIKE cak_file.cak03,   #成本項目
        cab02       LIKE cab_file.cab02    #成本項目說明
                    END RECORD,
     g_wc2,g_wc,g_sql    string,  #No.FUN-580092 HCN
    g_cmd          LIKE type_file.chr1000,                                   #No.FUN-680122 VARCHAR(80),
    g_rec_b         LIKE type_file.num5,                #單身筆數            #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT  #No.FUN-680122 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1                                   #No.FUN-680122 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10                                  #No.FUN-680122 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000                                #No.FUN-680122CHAR(72)  
 
DEFINE   g_row_count    LIKE type_file.num10                                 #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10                                 #No.FUN-680122 INTEGER
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5                                     #No.FUN-680122 SMALLINT
 
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
    LET p_row = 4 LET p_col = 26
    OPEN WINDOW i060_w AT p_row,p_col WITH FORM "axc/42f/axci060"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    #No:A088
    CALL i060_menu()
    ##
    CLOSE WINDOW i060_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION i060_menu()
 
   WHILE TRUE
      CALL i060_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i060_a()
            END IF
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i060_q() 
            END IF
         #No.TQC-970160--begin
         WHEN "first" 
            CALL i060_fetch('F')
         WHEN "last" 
            CALL i060_fetch('L')
         WHEN "jump" 
            CALL i060_fetch('/')   
         #No.TQC-970160--end  
         WHEN "previous" 
            CALL i060_fetch('P')
         WHEN "next"  
            CALL i060_fetch('N')
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i060_out() 
            END IF
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cak),'','')
             END IF
         #--
 
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i060_b() 
            ELSE
               LET g_action_choice = NULL 
            END IF
 
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_cak01 IS NOT NULL THEN
                 LET g_doc.column1 = "cak01"
                 LET g_doc.value1 = g_cak01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0019-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i060_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_cak.clear()
    LET g_cak01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cak01 = NULL
        CALL i060_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            RETURN
        END IF
        IF g_cak01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_rec_b = 0 
        CALL i060_b()                   #輸入單身
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            RETURN
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i060_i(p_cmd)
   DEFINE
        p_cmd               LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag              LIKE type_file.chr1,                    #判斷必要欄位是否輸入        #No.FUN-680122 VARCHAR(1)
        l_msg1,l_msg2       LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(70) 
        l_oba02    LIKE oba_file.oba02,
        l_n                 LIKE type_file.num5           #No.FUN-680122 SMALLINT
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT g_cak01 WITHOUT DEFAULTS 
        FROM cak01 
          
        AFTER FIELD cak01 
          IF NOT cl_null(g_cak01) THEN  
             SELECT oba02 INTO l_oba02  FROM oba_file 
              WHERE oba01=g_cak01
             IF cl_null(l_oba02) THEN 
                LET INT_FLAG = 0  ######add for prompt bug
               #str TQC-740120 modify
               #PROMPT "產品分類不存在,請重新輸入!" FOR g_chr 
                CALL cl_getmsg('aom-005',g_lang) RETURNING g_msg
                PROMPT g_msg CLIPPED FOR g_chr
               #end TQC-740120 modify
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT
 
                   ON ACTION about         #MOD-4C0121
                      CALL cl_about()      #MOD-4C0121
 
                   ON ACTION help          #MOD-4C0121
                      CALL cl_show_help()  #MOD-4C0121
 
                   ON ACTION controlg      #MOD-4C0121
                      CALL cl_cmdask()     #MOD-4C0121
                END PROMPT
                NEXT FIELD cak01 
             END IF  
          END IF  
          DISPLAY l_oba02 TO FORMONLY.oba02
 
        AFTER INPUT  
            LET l_flag='N'
            IF INT_FLAG THEN
               CLEAR FORM
               CALL g_cak.clear()
               EXIT INPUT  
            END IF
            IF g_cak01 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_cak01 
            END IF    
 
         ON ACTION controlp
         CASE
            WHEN INFIELD(cak01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_oba"
               LET g_qryparam.default1 = g_cak01
               CALL cl_create_qry() RETURNING g_cak01
               DISPLAY g_cak01 TO cak01
               SELECT oba02 INTO l_oba02 FROM oba_file
                WHERE oba01 = g_cak01
               DISPLAY l_oba02 TO FORMONLY.oba02
               NEXT FIELD cak01
            OTHERWISE EXIT CASE
         END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
    END INPUT
END FUNCTION
 
FUNCTION i060_q()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CLEAR FORM
   CALL g_cak.clear()
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt  
    #CALL i060_cs()
    MESSAGE "Searching !" 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    -------------------------------
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    CONSTRUCT BY NAME g_wc ON cak01 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
         ON ACTION controlp
         CASE
            WHEN INFIELD(cak01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_oba"
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cak01
               NEXT FIELD cak01
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF cl_null(g_wc) THEN LET g_wc=" 1=1 " END IF 
 
    CONSTRUCT g_wc2  ON cak02,cak03
           FROM s_cak[1].cak02,s_cak[1].cak03
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp 
        CASE
              WHEN INFIELD(cak02)
                #start FUN-660160 modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_gem"
                #LET g_qryparam.state = "c" 
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CASE g_ccz.ccz06
                    WHEN '3'
                       CALL q_ecd(TRUE,TRUE,"")
                            RETURNING g_qryparam.multiret
                    WHEN '4'
                       CALL q_eca(TRUE,TRUE,"")
                            RETURNING g_qryparam.multiret
                    OTHERWISE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form     ="q_gem"
                       LET g_qryparam.state = "c" 
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                 END CASE
                #end FUN-660160 modify
                 DISPLAY g_qryparam.multiret TO cak02
                 NEXT FIELD cak02
              WHEN INFIELD(cak03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_cab"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cak03
                 NEXT FIELD cak03
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
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 IS NULL THEN LET g_wc2=' 1=1 ' END IF 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE cak01 FROM cak_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cak01 ",
                   "  FROM cak_file ",
                   "   WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE i060_prepare FROM g_sql
    DECLARE i060_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i060_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(DISTINCT cak01) FROM cak_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT cak01) FROM cak_file WHERE ",
                  g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i060_precount FROM g_sql
    DECLARE i060_count CURSOR FOR i060_precount
  
    OPEN i060_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        LET g_cak01 = NULL
    ELSE
        OPEN i060_count 
        FETCH i060_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt 
        CALL i060_fetch('F')                  # 讀出TEMP第一筆並顯示
        MESSAGE " "
    END IF
END FUNCTION
 
 
FUNCTION i060_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680122 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680122 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i060_cs INTO g_cak01
        WHEN 'P' FETCH PREVIOUS i060_cs INTO g_cak01
        WHEN 'F' FETCH FIRST    i060_cs INTO g_cak01
        WHEN 'L' FETCH LAST     i060_cs INTO g_cak01
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
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
             FETCH ABSOLUTE l_abso i060_cs INTO g_cak01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_cak01 TO NULL  #TQC-6B0105
    ELSE
        CALL i060_show()
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
FUNCTION i060_show()
  DEFINE l_oba02 LIKE oba_file.oba02
 
    LET g_cak01_t = g_cak01
    SELECT oba02 INTO l_oba02 FROM oba_file 
     WHERE oba01=g_cak01 
    DISPLAY g_cak01 TO cak01     # 顯示單頭值
    DISPLAY l_oba02 TO FORMONLY.oba02 
   
    CALL b_fill(g_cak01)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
{ 
FUNCTION i060_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_cak.clear()
   INITIALIZE g_cak01 TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON cak01        # 螢幕上取單頭條件
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
    IF cl_null(g_wc) THEN LET g_wc=" 1=1" END IF 
    IF INT_FLAG THEN RETURN END IF
   
    CONSTRUCT g_wc2 ON cak02,cak03
            FROM s_cak[1].cak02,s_cak[1].cak03
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         ON ACTION controlp   
         CASE
              WHEN INFIELD(cak02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gem"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cak02
                 NEXT FIELD cak02
              WHEN INFIELD(cak03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_cab"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cak03
                 NEXT FIELD cak03
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
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE cak01 FROM cak_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 2"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cak01 ",
                   "  FROM cak_file ",
                   "   WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 2"
    END IF
 
    PREPARE i060_prepare FROM g_sql
    DECLARE i060_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i060_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(DISTINCT cak01) FROM cak_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT cak01) FROM cak_file WHERE ",
                  g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i060_precount FROM g_sql
    DECLARE i060_count CURSOR FOR i060_precount
END FUNCTION
}
 
FUNCTION i060_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680122 VARCHAR(1)
    l_oba02         LIKE oba_file.oba02,
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT cak02,cak03,'' ",
                       " FROM cak_file ",
                       " WHERE cak01=? ",
                       "   AND cak02=? ",
                       "   AND cak03=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i060_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_cak WITHOUT DEFAULTS FROM s_cak.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
#           DISPLAY l_ac TO FORMONLY.cn3            #No.TQC-970160
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_cak_t.* = g_cak[l_ac].*  #BACKUP
 
               OPEN i060_bcl USING g_cak01,g_cak_t.cak02,g_cak_t.cak03
               IF STATUS THEN
                  CALL cl_err("OPEN i060_bcl:", STATUS, 1)
                  CLOSE i060_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH i060_bcl INTO g_cak[l_ac].* 
                  IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cak_t.cak02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
                  CALL i060_cak03(g_cak[l_ac].cak03) RETURNING g_cak[l_ac].cab02 
               END IF
               IF l_ac <= l_n then                   #DISPLAY NEWEST
                 CALL i060_cak03(g_cak[l_ac].cak03) RETURNING g_cak[l_ac].cab02 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_cak[l_ac].cak02 IS NULL OR g_cak[l_ac].cak03 IS NULL THEN
                INITIALIZE g_cak[l_ac].* TO NULL
            END IF
            INSERT INTO cak_file(cak01,cak02,cak03)              
                   VALUES(g_cak01,g_cak[l_ac].cak02,
                   g_cak[l_ac].cak03)                    
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_cak[l_ac].cak02,SQLCA.sqlcode,0)   #No.FUN-660127
                CALL cl_err3("ins","cak_file",g_cak01,g_cak[l_ac].cak02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                CANCEL INSERT 
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2 
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_cak[l_ac].* TO NULL   
            LET g_cak_t.* = g_cak[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cak02
 
#       BEFORE FIELD cak03                                 #No.TQC-970160 
        AFTER FIELD cak02                                  #No.TQC-970160 
            IF NOT cl_null(g_cak[l_ac].cak02) THEN 
              #start FUN-660160 modify
              #SELECT COUNT(*) INTO g_cnt FROM gem_file 
              # WHERE gem01=g_cak[l_ac].cak02 
              #   AND gemacti='Y'   #NO:6950
               CASE g_ccz.ccz06
                  WHEN '3'
                     SELECT COUNT(*) INTO g_cnt
                       FROM ecd_file
                      WHERE ecd01 = g_cak[l_ac].cak02
                        AND ecdacti='Y'
                  WHEN '4'
                     SELECT COUNT(*) INTO g_cnt
                       FROM eca_file
                      WHERE eca01 = g_cak[l_ac].cak02
                        AND ecaacti='Y'
                  OTHERWISE
                     SELECT COUNT(*) INTO g_cnt
                       FROM gem_file
                      WHERE gem01 = g_cak[l_ac].cak02
                        AND gemacti='Y'
               END CASE
              #end FUN-660160 modify
               IF g_cnt=0 THEN 
                 #str TQC-740120 modify
                 #LET INT_FLAG = 0  ######add for prompt bug
                 #PROMPT "Cost Center Is Not Exist" FOR g_chr 
                  CALL cl_err("","mfg1318" , 1) 
                 #end TQC-740120 modify
                  NEXT FIELD cak02 
               END IF 
            END IF 
 
        AFTER FIELD cak03 
            IF NOT cl_null(g_cak[l_ac].cak03) THEN   
               CALL i060_cak03(g_cak[l_ac].cak03) RETURNING g_cak[l_ac].cab02 
               IF cl_null(g_cak[l_ac].cab02)  THEN 
                 #str TQC-740120 modify
                 #LET INT_FLAG = 0  ######add for prompt bug
                 #PROMPT "Cann't find Cost Item! Please Input Again!" FOR g_chr 
                  CALL cl_err("","mfg1313" , 1) 
                 #end TQC-740120 modify
                  NEXT FIELD cak03 
               END IF 
              
               SELECT COUNT(*) INTO g_cnt FROM caa_file 
                WHERE caa01=g_cak[l_ac].cak02 AND caa02=g_cak[l_ac].cak03 
               IF g_cnt=0 THEN 
                 #str TQC-740120 modify
                 #LET g_msg='This Cost Center Not Approve This Item' CLIPPED
                  CALL cl_getmsg('axc-051',g_lang) RETURNING g_msg
                 #end TQC-740120 modify
                  LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg FOR g_chr 
                     ON IDLE g_idle_seconds
                        CALL cl_on_idle()
#                        CONTINUE PROMPT
 
                     ON ACTION about         #MOD-4C0121
                        CALL cl_about()      #MOD-4C0121
                
                     ON ACTION help          #MOD-4C0121
                        CALL cl_show_help()  #MOD-4C0121
                
                     ON ACTION controlg      #MOD-4C0121
                        CALL cl_cmdask()     #MOD-4C0121
                  END PROMPT
                  NEXT FIELD cak03 
               END IF 
              
               IF g_cak[l_ac].cak03 !=g_cak_t.cak03 OR 
                 (g_cak[l_ac].cak03 IS NOT NULL AND g_cak_t.cak03 IS NULL) THEN 
                 SELECT count(*) INTO l_n FROM cak_file
                  WHERE cak01 = g_cak01 
                    AND cak02 = g_cak[l_ac].cak02
                    AND cak03 = g_cak[l_ac].cak03
                 IF l_n > 0 THEN
                   LET g_msg=g_cak01 CLIPPED,'+',g_cak[l_ac].cak02 CLIPPED,'+',
                             g_cak[l_ac].cak03 CLIPPED
                   CALL cl_err(g_msg,-239,1)
                   LET g_cak[l_ac].cak02 = g_cak_t.cak02
                   LET g_cak[l_ac].cak03 = g_cak_t.cak03
                   NEXT FIELD cak03
                 END IF
               END IF 
            END IF 
 
        BEFORE DELETE                            #是否取消單身
            IF g_cak_t.cak02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM cak_file WHERE cak01=g_cak01 
                                 AND cak02 = g_cak_t.cak02
                                 AND cak03 = g_cak_t.cak03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cak_t.cak02,SQLCA.sqlcode,0)     #No.FUN-660127
                    CALL cl_err3("del","cak_file",g_cak01,g_cak_t.cak02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2 
            COMMIT WORK
            END IF

   #FUN-D40030---add---str---
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN    
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_cak[l_ac].* = g_cak_t.*
               ELSE
                  CALL g_cak.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i060_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i060_bcl
            COMMIT WORK
   #FUN-D40030---add---end---

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cak[l_ac].* = g_cak_t.*
               CLOSE i060_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cak[l_ac].cak02,-263,1)
               LET g_cak[l_ac].* = g_cak_t.*
            ELSE
               IF g_cak[l_ac].cak02 IS NULL OR g_cak[l_ac].cak03 IS NULL THEN
                   INITIALIZE g_cak[l_ac].* TO NULL
               END IF
               UPDATE cak_file SET cak02=g_cak[l_ac].cak02,
                                   cak03=g_cak[l_ac].cak03
                WHERE cak01=g_cak01
                  AND cak02= g_cak_t.cak02
                  AND cak03= g_cak_t.cak03
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cak[l_ac].cak02,SQLCA.sqlcode,0)   #No.FUN-660127
                   CALL cl_err3("upd","cak_file",g_cak01,g_cak_t.cak02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                   LET g_cak[l_ac].* = g_cak_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        ON ACTION controlp
            CASE
              WHEN INFIELD(cak02)
                #start FUN-660160 modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_gem"
                #LET g_qryparam.default1 = g_cak[l_ac].cak02
                #CALL cl_create_qry() RETURNING g_cak[l_ac].cak02
                 CASE g_ccz.ccz06
                    WHEN '3'
                       CALL q_ecd(FALSE,TRUE,g_cak[l_ac].cak02)
                            RETURNING g_cak[l_ac].cak02
                    WHEN '4'
                       CALL q_eca(FALSE,TRUE,g_cak[l_ac].cak02)
                            RETURNING g_cak[l_ac].cak02
                    OTHERWISE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form     ="q_gem"
                       LET g_qryparam.default1 = g_cak[l_ac].cak02
                       CALL cl_create_qry() RETURNING g_cak[l_ac].cak02
                 END CASE
                #end FUN-660160 modify
#                 CALL FGL_DIALOG_SETBUFFER( g_cak[l_ac].cak02 )
                 SELECT oba02 INTO l_oba02 FROM oba_file
                  WHERE oba01=g_cak[l_ac].cak02
                 DISPLAY l_oba02 TO FORMONLY.oba02
                 NEXT FIELD cak02
              WHEN INFIELD(cak03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_cab"
                 LET g_qryparam.default1 = g_cak[l_ac].cak03
                 CALL cl_create_qry() RETURNING g_cak[l_ac].cak03
#                 CALL FGL_DIALOG_SETBUFFER( g_cak[l_ac].cak03 )
                 SELECT cab02 INTO g_cak[l_ac].cab02 FROM cab_file
                  WHERE cab01=g_cak[l_ac].cak03
                 NEXT FIELD cak03
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cak02) AND l_ac > 1 THEN
                LET g_cak[l_ac].* = g_cak[l_ac-1].*
                NEXT FIELD cak02
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
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
        
        END INPUT
 
        CLOSE i060_bcl
        COMMIT WORK
END FUNCTION
 
FUNCTION i060_b_askkey()
    CLEAR FORM
    CALL g_cak.clear()
    CONSTRUCT g_wc2 ON cak02,cak03
            FROM s_cak[1].cak02,s_cak[1].cak03
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i060_b_fill(g_wc2)
END FUNCTION
 
FUNCTION b_fill(p_cak01)              #BODY FILL UP
DEFINE p_cak01  LIKE cak_file.cak01 
 
    LET g_sql =
        " SELECT cak02,cak03,cab02 ",
        "  FROM cak_file,cab_file ",
        " WHERE cak03=cab_file.cab01 ",
        "   AND cak01='",p_cak01,"' ",
        "   AND ",g_wc2 CLIPPED,
        "  ORDER BY 1"
    PREPARE i060_pb FROM g_sql
    DECLARE cak_curs CURSOR FOR i060_pb
 
    CALL g_cak.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH cak_curs INTO g_cak[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_cak.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i060_b_fill(p_wc2)              #BODY FILL UP
DEFINE   p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)  
 
    LET g_sql =
        "SELECT cak02,cak03,cab02,'' ",
        "  FROM cak_file,cab_file ",
        " WHERE cak03=cab_file.cab01 ",
        "   AND ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i060_pb2 FROM g_sql
    DECLARE cak_curs2 CURSOR FOR i060_pb2
 
    PREPARE i060_bp FROM g_sql 
 
    
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH cak_curs2 INTO g_cak[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    MESSAGE ""
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2 
        LET g_cnt = 0
END FUNCTION
 
FUNCTION i060_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cak TO s_cak.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION previous
         CALL i060_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#No.TQC-970160--begin
      ON ACTION FIRST
         CALL i060_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
	        
      ON ACTION jump
         CALL i060_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
		
      ON ACTION last
         CALL i060_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#No.TQC-970160--end                                 
 
      ON ACTION next
         CALL i060_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
  
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
 
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
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
   {   #@ON ACTION 更改
      ON ACTION update
         LET g_action_choice="update"
         EXIT DISPLAY
   }
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
{
FUNCTION i060_copy()
    DEFINE l_newno         LIKE cak_file.cak01,
           l_oldno         LIKE cak_file.cak01,
           l_cak       RECORD LIKE cak_file.*,
           l_oba02     LIKE oba_file.oba02,
           l_flag          LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cak01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY "" AT 1,1
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT l_newno FROM cak01
        AFTER FIELD cak01
            IF l_newno IS NULL THEN
                NEXT FIELD cak01
            END IF
            SELECT count(*) INTO g_cnt FROM cak_file
             WHERE cak01 = l_newno 
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD cak01
            END IF
            SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01=l_newno
            IF cl_null(l_oba02) THEN NEXT FIELD cak01 END IF 
            DISPLAY l_oba02 TO FORMONLY.oba02 
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
        DISPLAY BY NAME g_cak01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM cak_file
        WHERE cak01=g_cak01
        INTO TEMP x
    UPDATE x
        SET cak01=l_newno    #資料鍵值
    LET l_flag='Y'
    DECLARE x_cur CURSOR FOR 
       SELECT * FROM x 
    FOREACH x_cur INTO l_cak.* 
       INSERT INTO cak_file VALUES(l_cak.*) 
       IF STATUS THEN LET l_flag='N' EXIT FOREACH END IF 
    END FOREACH 
    IF l_flag='N' THEN 
         CALL cl_err(g_cak01,SQLCA.sqlcode,0) 
    ELSE 
       MESSAGE 'ROW(',l_newno,')O.K' 
       LET l_oldno=g_cak01 
       LET g_cak01=l_newno
    END IF 
    CALL i060_show()
END FUNCTION
}
 
FUNCTION i060_cak03(p_cak03)
  DEFINE p_cak03 LIKE cak_file.cak03 
  DEFINE l_cab02 LIKE cab_file.cab02 
 
  LET l_cab02=''
  SELECT cab02 INTO l_cab02 FROM cab_file 
   WHERE cab01=p_cak03 
  RETURN l_cab02 
END FUNCTION
 
FUNCTION i060_out()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122  VARCHAR(20),      # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680122 VARCHAR(40)
          l_chr     LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          sr        RECORD
                  cak01  LIKE cak_file.cak01, 
                  oba02  LIKE oba_file.oba02,
                  cak02  LIKE cak_file.cak02, 
                  cak03  LIKE cak_file.cak03, 
                  cab02  LIKE cab_file.cab02 
                    END RECORD 
 
       #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0146
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
     LET l_sql = "SELECT cak01,oba02,cak02,cak03,cab02 ",
#               " FROM cak_file LEFT OUTER JOIN cab_file ON cak03=cab01 LEFT OUTER JOIN oba_file on cak01=oba01 ",
                " FROM cak_file,cab_file,oba_file ",
                "  WHERE cak01='",g_cak01,"' " CLIPPED
#No.FUN-780017---Begin 
#    PREPARE axci060_p1 FROM l_sql
#    IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) EXIT PROGRAM END IF
#    DECLARE axci060_c1 CURSOR FOR axci060_p1
 
#    CALL cl_outnam('axci060') RETURNING l_name
#    START REPORT axci060_rep TO l_name
 
#    FOREACH axci060_c1 INTO sr.*
#      IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT PROGRAM END IF
#      OUTPUT TO REPORT axci060_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT axci060_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0146
     IF g_zz05 = 'Y' THEN                                                        
        CALL cl_wcchp(g_wc,'cak01')         
             RETURNING g_wc                                                     
     END IF       
     CALL cl_prt_cs1('axci060','axci060',l_sql,g_wc)
#No.FUN-780017---End  
END FUNCTION
{                       #No.FUN-780017
REPORT axci060_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          l_chr         LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          l_cd          LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          sr        RECORD
                  cak01  LIKE cak_file.cak01, 
                  oba02  LIKE oba_file.oba02,
                  cak02  LIKE cak_file.cak02, 
                  cak03  LIKE cak_file.cak03, 
                  cab02  LIKE cab_file.cab02 
                    END RECORD 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 ORDER BY sr.cak01 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT 
      PRINT g_dash
      PRINT g_x[9] CLIPPED,sr.cak01 
      PRINT g_x[31],g_x[32],g_x[33]
      PRINT g_dash1
      LET l_last_sw = 'n'
  
   BEFORE GROUP OF sr.cak01  
      SKIP TO TOP OF PAGE 
      PRINT g_x[9] CLIPPED,sr.cak01[1,4],' ',sr.oba02 
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.cak02 CLIPPED,
            COLUMN g_c[32],sr.cak03 CLIPPED,
            COLUMN g_c[33],sr.cab02 CLIPPED
 
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT     }         #No.FUN-780017      
 
