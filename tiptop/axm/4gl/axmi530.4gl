# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Patter/ name...: axmi530.4gl
# Descriptions...: 產品數量價格折扣維護作業
# Date & Author..: 02/08/05 By windy
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: NO.MOD-530336 05/03/30 By Mandy 功能鍵:[以下修正和此筆相同數量]/[以下修正和此筆相同折扣]無作用.
# Modify.........: No.FUN-560193 05/06/28 By kim 單身 '單位' 改名為 '銷售單位', 並於其右邊增秀 '計價單位'
# Modify.........: NO.TQC-5B0029 05/11/07 By Nicola 列印位置調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740137 07/04/22 By Carrier 價格條件加開窗
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
# Modfiy.........: No.TQC-960124 09/06/11 By Carrier 最低數量若為0,則折扣一定為100%
# Modify.........: No.FUN-870100 09/08/07 By Cockroach axmi530單頭原與axmi530單頭共用同一table，axmi530單頭引用axmi530資料無法維護;
#                                                      現axmi530不再使用，因此修改axmi530單頭可開放維護。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0034 09/11/09 By Carrier 新增后,单身资料没有show出来
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-9C0163 09/12/28 By Cockroach 增加xme00字段區分axmi520/530單頭
# Modify.........: No.TQC-A10092 10/01/08 By lilingyu 單身輸入料號后,沒有自動帶出銷售單位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu 全系統增加料件管控
# Modify.........: No.TQC-AC0058 10/12/08 By houlia 調整修改u（）的顯示
# Modify.........: No.MOD-B30407 11/03/17 By suncx 修正生效日期更改后未UPDATE的BUG
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80199 11/08/26 By lixia 查詢欄位
# Modify.........: No:FUN-BB0086 11/11/18 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-BC0060 11/12/09 By SunLM 增加<>0的情況
# Modify.........: No:FUN-C20068 12/02/14 By fengrui 數量欄位小數取位處理
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_xme           RECORD LIKE xme_file.*,
    g_xme_t         RECORD LIKE xme_file.*,
    g_xme_o         RECORD LIKE xme_file.*,
    g_xme01_t       LIKE xme_file.xme01,       #FUN-870100 ADD
    g_xme02_t       LIKE xme_file.xme02,       #FUN-870100 ADD
    g_xmg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        xmg03       LIKE xmg_file.xmg03,
        ima02	    LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        xmg04       LIKE xmg_file.xmg04,
        ima908      LIKE ima_file.ima908, #FUN-560193
        xmg05       LIKE xmg_file.xmg05,
        xmg06       LIKE xmg_file.xmg06,
        xmg07       LIKE xmg_file.xmg07
                    END RECORD,
    g_xmg_t         RECORD    #程式變數(Program Variables)
        xmg03       LIKE xmg_file.xmg03,
	ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        xmg04       LIKE xmg_file.xmg04,
        ima908      LIKE ima_file.ima908, #FUN-560193
        xmg05       LIKE xmg_file.xmg05,
        xmg06       LIKE xmg_file.xmg06,
        xmg07       LIKE xmg_file.xmg07
                    END RECORD,
    g_xmg_o         RECORD    #程式變數(Program Variables)
        xmg03       LIKE xmg_file.xmg03,
	ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        xmg04       LIKE xmg_file.xmg04,
        ima908      LIKE ima_file.ima908, #FUN-560193
        xmg05       LIKE xmg_file.xmg05,
        xmg06       LIKE xmg_file.xmg06,
        xmg07       LIKE xmg_file.xmg07
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,   #TQC-630166 
    g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,         #目前處理的ARRAY CNT  #No.FUN-680137 SMALLINT
    l_cmd           LIKE type_file.chr1000,      #No.FUN-680137 VARCHAR(200)
    g_buf           LIKE ima_file.ima01,         #No.FUN-680137 VARCHAR(40)
    g_buf1          LIKE ima_file.ima01          #No.FUN-680137 VARCHAR(40)
DEFINE p_row,p_col     LIKE type_file.num5       #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql      STRING       #SELECT ... FOR UPDATE SQL 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680137
DEFINE   g_before_input_done LIKE type_file.num5   #No.FUN-680137 SMALLINT
DEFINE g_sql_tmp         STRING                   #FUN-870100 ADD
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_xmg04_t      LIKE xmg_file.xmg04         #No:FUN-BB0086  add 
MAIN
DEFINE   p_row,p_col     LIKE type_file.num5     #FUN-9C0163 ADD 

   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                        #拮取中斷鍵，由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0094
 
    LET g_forupd_sql =
       #"SELECT * FROM xme_file WHERE xme01 = ? AND xme02 = ? FOR UPDATE" #g_xme_rowid   #FUN-9C0163 MARK
        "SELECT * FROM xme_file WHERE xme00 ='2' AND xme01 = ? AND xme02 = ? FOR UPDATE" #FUN-9C0163 ADD
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i530_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i530_w WITH FORM "axm/42f/axmi530"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF (g_sma.sma116 MATCHES '[01]') THEN    #No.FUN-610076
       CALL cl_set_comp_visible("ima908",FALSE)
    END IF
 
    CALL i530_menu()
 
    CLOSE WINDOW i530_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
 
FUNCTION i530_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_xmg.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_xme.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON xme01,xme02,xme06,xmeuser,xmegrup,xmemodu,xmedate #FUN-870100 ADD xme06
                              ,xmeoriu,xmeorig   #TQC-B80199
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       #No.TQC-740137  --Begin
       ON ACTION controlp
           CASE
             WHEN INFIELD(xme01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_oah'
                LET g_qryparam.state  = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO xme01
                NEXT FIELD xme01
             WHEN INFIELD(xme02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_azi'
                LET g_qryparam.state  = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO xme02
                NEXT FIELD xme02
           END CASE
       #No.TQC-740137  --End  
 
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
 
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON xmg03,xmg04,xmg05,xmg06,xmg07
         FROM s_xmg[1].xmg03,s_xmg[1].xmg04,s_xmg[1].xmg05,
              s_xmg[1].xmg06,s_xmg[1].xmg07
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(xmg03)
#               CALL q_ima(05,11,g_xmg[1].xmg03) RETURNING g_xmg[1].xmg03
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.state = 'c'
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                DISPLAY g_qryparam.multiret TO xmg03
                NEXT FIELD xmg03
              WHEN INFIELD(xmg04)
#               CALL q_gfe(05,11,g_xmg[1].xmg04) RETURNING g_xmg[1].xmg04
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO xmg04
                NEXT FIELD xmg04
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
    IF INT_FLAG THEN RETURN END IF
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
	#	LET g_wc = g_wc CLIPPED,"AND xmeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc CLIPPED,"AND xmegrup MATCHES'",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc CLIPPED,"AND xmegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('xmeuser', 'xmegrup')
    #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT xme01,xme02 FROM xme_file",
                  #" WHERE ", g_wc CLIPPED,      #FUN-9C0163 MARK
                  #" ORDER BY 1,2"               #FUN-9C0163 MARK
                   " WHERE xme00='2' AND ", g_wc CLIPPED,    #FUN-9C0163 ADD
                   " ORDER BY xme01,xme02 "                #FUN-9C0163 ADD
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT xme01,xme02",
                   "  FROM xme_file,xmg_file",
                   " WHERE xme00='2' AND xme01 = xmg01 AND xme02 = xmg02",  #FUN-9C0163 ADD XME00
                   "   AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  #  " ORDER BY 1,2"                #FUN-9C0163 MARK
                   " ORDER BY xme01,xme02"      #FUN-9C0163 ADD
    END IF
    PREPARE i530_prepare FROM g_sql
    DECLARE i530_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i530_prepare
 
    IF g_wc2 = " 1=1" THEN			#取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM xme_file WHERE xme00='2' AND ",g_wc CLIPPED   #FUN-9C0163 ADD XME00
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT xme01||xme02) FROM xme_file,xmg_file WHERE ",
                 "xme00 = '2' AND ",    #FUN-9C0163 ADD  
                 "xme01 = xmg01 AND xme02 = xmg02 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    
    PREPARE i530_precount FROM g_sql
    DECLARE i530_count CURSOR FOR i530_precount
END FUNCTION
 
FUNCTION i530_menu()
   WHILE TRUE
      CALL i530_bp("G")
      CASE g_action_choice
        #FUN-870100 ADD--
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i530_a()
            END IF
        #FUN-870100 END--  
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i530_q()
            END IF
        #FUN-870100 ADD--
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i530_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i530_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i530_copy()
            END IF
        #FUN-870100 END-- 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i530_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i530_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_xmg),'','')
            END IF
         #No.FUN-6A0020-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_xme.xme01 IS NOT NULL THEN
                LET g_doc.column1 = "xme01"
                LET g_doc.column2 = "xme02"
                LET g_doc.value1 = g_xme.xme01
                LET g_doc.value2 = g_xme.xme02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0020-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query
FUNCTION i530_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_xme.* TO NULL              #No.FUN-6A0020
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_xmg.clear()
 
    CALL i530_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_xme.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
 
    OPEN i530_cs                            #從DB產生合乎條件TEMP (0-30鏃)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_xme.* TO NULL
    ELSE
        OPEN i530_count
        FETCH i530_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i530_fetch('F')                  #讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i530_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
      WHEN 'N' FETCH NEXT     i530_cs INTO g_xme.xme01,g_xme.xme02
      WHEN 'P' FETCH PREVIOUS i530_cs INTO g_xme.xme01,g_xme.xme02
      WHEN 'F' FETCH FIRST    i530_cs INTO g_xme.xme01,g_xme.xme02
      WHEN 'L' FETCH LAST     i530_cs INTO g_xme.xme01,g_xme.xme02
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                  LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i530_cs INTO g_xme.xme01,g_xme.xme02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)
        INITIALIZE g_xme.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_xme.* FROM xme_file WHERE xme01 = g_xme.xme01 AND xme02=g_xme.xme02
                                          AND xme00 = '2'           #FUN-9C0163 ADD
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_xme.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_xme.xmeuser      #FUN-4C0057 add
    LET g_data_group = g_xme.xmegrup      #FUN-4C0057 add
    CALL i530_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i530_show()
    LET g_xme_t.* = g_xme.*                #保存單頭舊值
    DISPLAY BY NAME g_xme.xme01,g_xme.xme02,g_xme.xme06, g_xme.xmeoriu,g_xme.xmeorig,
                    g_xme.xmeuser,g_xme.xmegrup,g_xme.xmemodu,g_xme.xmedate       #modified by windy (ten)
    LET g_buf = NULL
    SELECT oah02 INTO g_buf FROM oah_file WHERE oah01=g_xme.xme01
    DISPLAY g_buf TO oah02
    CALL i530_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#FUN-870100 ADD BEGIN--------------------------
FUNCTION i530_a()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_xmg.clear()
   INITIALIZE g_xme.* LIKE xme_file.*   
   LET g_xme01_t = NULL
   LET g_xme02_t = NULL
   LET g_xme_t.* = g_xme.*
   LET g_xme_o.* = g_xme.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_xme.xmeuser=g_user
      LET g_xme.xmeoriu = g_user #FUN-980030
      LET g_xme.xmeorig = g_grup #FUN-980030
      LET g_xme.xmegrup=g_grup
      LET g_xme.xmedate=g_today
      LET g_xme.xme00   = '2'   #FUN-9C0163 ADD
 
      CALL i530_i("a")        
 
     IF INT_FLAG THEN      
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_xme.xme01) OR cl_null(g_xme.xme02) THEN  
         CONTINUE WHILE
      END IF
 
      INSERT INTO xme_file VALUES (g_xme.*)
      IF SQLCA.sqlcode THEN                
         CALL cl_err3("ins","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
 
      LET g_xme_t.* = g_xme.*
      CALL g_xmg.clear()
      LET g_rec_b=0          
      CALL i530_b()     
 
      LET g_xme01_t = g_xme.xme01  
      LET g_xme02_t = g_xme.xme02  
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i530_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,  
          l_oah02         LIKE oah_file.oah02,
          l_n             LIKE type_file.num5        
   CALL cl_set_head_visible("","YES")      
 
   INPUT BY NAME g_xme.xme01,g_xme.xme02,g_xme.xme06, g_xme.xmeoriu,g_xme.xmeorig,
                 g_xme.xmeuser,g_xme.xmegrup,g_xme.xmedate
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i530_set_entry(p_cmd)
         CALL i530_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         LET g_xme.xme00 ='2'   #FUN-9C0163 ADD
   
      AFTER FIELD xme01
         IF NOT cl_null(g_xme.xme01) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_xme.xme01 != g_xme_t.xme01) THEN
               SELECT oah02 INTO l_oah02 FROM oah_file
                WHERE oah01 = g_xme.xme01
               IF STATUS THEN 
                  CALL cl_err3("sel","oah_file",g_xme.xme01,"","mfg4101","","",1)  
                  NEXT FIELD xme01
               END IF
               DISPLAY l_oah02 TO FORMONLY.oah02
            END IF
         END IF
 
      AFTER FIELD xme02
         IF NOT cl_null(g_xme.xme02) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_xme.xme02 != g_xme_t.xme02) THEN
               SELECT azi01 FROM azi_file
                WHERE azi01 = g_xme.xme02
                  AND aziacti = 'Y'
               IF STATUS THEN 
                  CALL cl_err3("sel","azi_file",g_xme.xme02,"","mfg3008","","",1)  
                  NEXT FIELD xme02
               END IF
            END IF
            IF p_cmd = "a" OR (p_cmd = "u" AND
               (g_xme.xme01 != g_xme01_t OR g_xme.xme02 != g_xme02_t)) THEN
               SELECT COUNT(*) INTO l_n FROM xme_file
                WHERE xme01 = g_xme.xme01
                  AND xme02 = g_xme.xme02
                  AND xme00 = g_xme.xme00       #FUN-9C0163 ADD
               IF l_n > 0 THEN           
                  CALL cl_err(g_xme.xme01,-239,0)
                  NEXT FIELD xme02
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(xme01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oah"
               LET g_qryparam.default1 = g_xme.xme01
               CALL cl_create_qry() RETURNING g_xme.xme01 
               DISPLAY BY name g_xme.xme01
               NEXT FIELD xme01
            WHEN INFIELD(xme02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_xme.xme02
               CALL cl_create_qry() RETURNING g_xme.xme02 
               DISPLAY BY name g_xme.xme02
               NEXT FIELD xme02
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()    
 
      ON ACTION help          
         CALL cl_show_help()   
 
   END INPUT
 
END FUNCTION
 
FUNCTION i530_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_xme.xme01 IS NULL OR g_xme.xme02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_xme01_t = g_xme.xme01
   LET g_xme02_t = g_xme.xme02
 
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN i530_cl USING g_xme.xme01,g_xme.xme02     #liuxqa 091021
   IF STATUS THEN
      CALL cl_err("OPEN i530_cl:", STATUS, 1)
      CLOSE i530_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i530_cl INTO g_xme.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)   
      CLOSE i530_cl
      RETURN
   END IF
 
#  CALL i530_show()     #TQC-AC0058   --mark
 
   WHILE TRUE
      LET g_xme01_t = g_xme.xme01
      LET g_xme02_t = g_xme.xme02
      LET g_xme.xmemodu = g_user
      LET g_xme.xmedate = g_today
   CALL i530_show()     #TQC-AC0058   --add
      CALL i530_i("u")        
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_xme.*=g_xme_t.*
         CALL i530_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_xme.xme01 != g_xme01_t OR g_xme.xme02 != g_xme02_t THEN
#        UPDATE xmf_file SET xmf01 = g_xme.xme01,
#                            xmf02 = g_xme.xme02
#         WHERE xmf01 = g_xme01_t
#           AND xmf02 = g_xme02_t
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("upd","xmf_file",g_xme01_t,g_xme02_t,SQLCA.sqlcode,"","upd xmf",1)   
#           ROLLBACK WORK
#           RETURN
#        END IF
 
         UPDATE xmg_file SET xmg01 = g_xme.xme01,
                             xmg02 = g_xme.xme02
          WHERE xmg01 = g_xme01_t
            AND xmg02 = g_xme02_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","xmg_file",g_xme01_t,g_xme02_t,SQLCA.sqlcode,"","upd xmg",1)  
            ROLLBACK WORK
            RETURN
         END IF
      END IF
 
      UPDATE xme_file SET xme_file.* = g_xme.*      
       WHERE xme01 = g_xme.xme01 AND xme02=g_xme.xme02
         AND xme00  = g_xme.xme00                  #FUN-9C0163 ADD
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","xme_file",g_xme01_t,g_xme02_t,SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i530_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF
 
END FUNCTION
 
FUNCTION i530_copy()
DEFINE l_xme01,l_xme01_o  LIKE xme_file.xme01,
       l_xme02,l_xme02_o  LIKE xme_file.xme02,
       l_n                  LIKE type_file.num5,       
       l_oah02              LIKE oah_file.oah02
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_xme.xme01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i530_set_entry('a')
    LET g_before_input_done = TRUE
 
    DISPLAY ' ' TO xme01
    DISPLAY ' ' TO xme02
    CALL cl_set_head_visible("","YES")     
 
    INPUT l_xme01,l_xme02 FROM xme01,xme02 
 
       AFTER FIELD xme01
          IF NOT cl_null(l_xme01) THEN
             SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=l_xme01
                                                   
             IF STATUS THEN
                CALL cl_err3("sel","oah_file",l_xme01,"","mfg4101","","",1)  
                NEXT FIELD xme01
             END IF
             DISPLAY l_oah02 TO FORMONLY.oah02
          END IF
 
       #AFTER FIELD xme02
       #    IF NOT cl_null(l_xme02) THEN
       #       SELECT azi01 FROM azi_file WHERE azi01=l_xme02
       #                                     AND aziacti='Y' 
       #       IF STATUS THEN
       #          CALL cl_err(l_xme02,'mfg3008',0) NEXT FIELD xme02
       #       END IF
       #       SELECT COUNT(*) INTO l_n FROM xme_file
       #        WHERE xme01 = l_xme01 AND xme02 = l_xme02
       #       IF l_n > 0 THEN                 
       #          CALL cl_err(l_xme01,-239,0) NEXT FIELD xme02
       #       END IF
       #    END IF
 
       ON ACTION controlp
          CASE
                WHEN INFIELD(xme01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oah"
                     LET g_qryparam.default1 = l_xme01
                     CALL cl_create_qry() RETURNING l_xme01
                     DISPLAY BY name l_xme01
                     NEXT FIELD xme01
                WHEN INFIELD(xme02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = l_xme02
                     CALL cl_create_qry() RETURNING l_xme02
                     DISPLAY BY name l_xme02
                     NEXT FIELD xme02
             OTHERWISE EXIT CASE
          END CASE
 
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
       LET INT_FLAG = 0
       DISPLAY g_xme.xme01 TO xme01 
       DISPLAY g_xme.xme02 TO xme02 
       RETURN
    END IF
 
    DROP TABLE x
 
    SELECT * FROM xme_file WHERE xme01 = g_xme.xme01
        AND xme02 = g_xme.xme02
        AND xme00 = g_xme.xme00            #FUN-9C0163 ADD
        INTO TEMP x
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
       RETURN
    END IF
 
    UPDATE x SET xme01 = l_xme01,
                 xme02 = l_xme02,
                 xme06 = NULL,
                 xmeuser=g_user,
                 xmemodu=g_user,
                 xmegrup=g_grup,
                 xmedate=g_today 
 
    INSERT INTO xme_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","xme_file",l_xme01,l_xme02,SQLCA.sqlcode,"","",1) 
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_xme01,') O.K'
 
    DROP TABLE y
 
    SELECT * FROM xmg_file 
     WHERE xmg01 = g_xme.xme01
       AND xmg02 = g_xme.xme02
      INTO TEMP y
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)
       RETURN
    END IF
 
    UPDATE y SET xmg01 = l_xme01,
                 xmg02 = l_xme02
    IF cl_null(l_xme01) THEN LET l_xme01=' ' END IF  
    INSERT INTO xmg_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","xmg_file",l_xme01,l_xme02,SQLCA.sqlcode,"","",1) 
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_xme01,') O.K'
 
     LET l_xme01_o= g_xme.xme01
     LET g_xme.xme01=l_xme01
     LET l_xme02_o= g_xme.xme02
     LET g_xme.xme02=l_xme02
 
     SELECT * INTO g_xme.* FROM xme_file WHERE xme01 = g_xme.xme01
                                           AND xme02 = g_xme.xme02
                                           AND xme00 = g_xme.xme00                       #FUN-9C0163 ADD
     IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1) 
        INITIALIZE g_xme.* TO NULL
        RETURN
     END IF
     CALL i530_show()
     CALL i530_b_fill("1=1")
     CALL i530_b()
 
     #FUN-C80046---begin
     #LET g_xme.xme01=l_xme01_o
     #LET g_xme.xme02=l_xme02_o
     #SELECT * INTO g_xme.* FROM xme_file WHERE xme01 = g_xme.xme01
     #                                      AND xme02 = g_xme.xme02
     #                                      AND xme00 = g_xme.xme00                       #FUN-9C0163 ADD
     #IF SQLCA.sqlcode THEN
     #   CALL cl_err3("sel","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  
     #   INITIALIZE g_xme.* TO NULL
     #   RETURN
     #END IF
     #CALL i530_show()
     #FUN-C80046---end
END FUNCTION
 
 
FUNCTION i530_r()
   DEFINE l_chr LIKE type_file.chr1       
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_xme.xme01) OR cl_null(g_xme.xme02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN i530_cl USING g_xme.xme01,g_xme.xme02     #liuxqa 091021
   IF STATUS THEN
      CALL cl_err("OPEN i530_cl:", STATUS, 1)
      CLOSE i530_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i530_cl INTO g_xme.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i530_show()
 
   IF cl_delh(20,16) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "xme01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "xme02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_xme.xme01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_xme.xme02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      MESSAGE "Delete xme,xmg!"
 
      DELETE FROM xme_file
       WHERE xme01 = g_xme.xme01
         AND xme02 = g_xme.xme02
         AND xme00 = g_xme.xme00     #FUN-9C0163 ADD
      IF SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("del","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","No xme deleted",1)  
         ROLLBACK WORK
         RETURN
      END IF
 
#     DELETE FROM xmf_file
#      WHERE xmf01 = g_xme.xme01
#        AND xmf02 = g_xme.xme02
#     IF STATUS THEN 
#        CALL cl_err3("del","xmf_file",g_xme.xme01,g_xme.xme02,STATUS,"","del xmf",1) 
#        ROLLBACK WORK
#        RETURN
#     END IF
 
      DELETE FROM xmg_file
       WHERE xmg01 = g_xme.xme01
         AND xmg02 = g_xme.xme02
      IF STATUS THEN
         CALL cl_err3("del","xmg_file",g_xme.xme01,g_xme.xme02,STATUS,"","del xmg",1)   
         ROLLBACK WORK
         RETURN
      END IF
 
      CLEAR FORM
      CALL g_xmg.clear()
      INITIALIZE g_xme.* TO NULL
            
      OPEN i530_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i530_cs
         CLOSE i530_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i530_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i530_cs
         CLOSE i530_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN i530_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i530_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i530_fetch('/')
      END IF
 
      MESSAGE ""
   END IF
 
   CLOSE i530_cl
   COMMIT WORK
 
END FUNCTION
#FUN-870100 ADD END----------------------------
 
FUNCTION i530_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_i             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    l_s             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    i               LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    l_xmg06         LIKE xmg_file.xmg06,
    l_xmg07         LIKE xmg_file.xmg07,
    l_jump          LIKE type_file.num5,                #No.FUN-680137              #判斷是否跳過AFTER ROW的處理
    l_cnt           LIKE type_file.num5,                #判斷是否跳過AFTER ROW的處理        #No.FUN-680137 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
#FUN-9C0163 ADD START--------------------
DEFINE
    l_ima31         LIKE ima_file.ima31,
    l_flag          LIKE type_file.chr1,
    l_fac           LIKE type_file.num20_6,
    l_msg           LIKE type_file.chr1000
#FUN-9C0163 ADD END-----------------------
 
    LET g_action_choice = ""
    IF g_xme.xme01 IS NULL OR g_xme.xme02 IS NULL THEN RETURN END IF
 
#FUN-870100 ADD------------------------
   SELECT * INTO g_xme.* FROM xme_file
    WHERE xme01 = g_xme.xme01
      AND xme02 = g_xme.xme02
      AND xme00 = g_xme.xme00             #FUN-9C0163   ADD  
#FUN-870100 END------------------------
 
    CALL i530_gen()                    #FUN-9C0163 ADD
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     "SELECT xmg03,'','',xmg04,'',xmg05,xmg06,xmg07 ", #FUN-560193
     "  FROM xmg_file ",
     " WHERE xmg01 = ? ",
     "   AND xmg02 = ? ",
     "   AND xmg03 = ? ",
     "   AND xmg04 = ? ",
     "   AND xmg05 = ? ",
     "   AND xmg06 = ? ",
     "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i530_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_xmg WITHOUT DEFAULTS FROM s_xmg.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success = 'Y'
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_xmg_t.* = g_xmg[l_ac].*  #BACKUP
               LET g_xmg_o.* = g_xmg[l_ac].*  #BACKUP
               LET g_xmg04_t = g_xmg[l_ac].xmg04   #No.FUN-BB0086 add
               BEGIN WORK
 
               OPEN i530_bcl USING g_xme.xme01,g_xme.xme02,g_xmg_t.xmg03,
                                   g_xmg_t.xmg04,g_xmg_t.xmg05,
                                   g_xmg_t.xmg06
               IF STATUS THEN
                   CALL cl_err("OPEN i530_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH i530_bcl INTO g_xmg[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_xmg_t.xmg03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
	           SELECT ima02,ima021,ima908
                     INTO g_xmg[l_ac].ima02,g_xmg[l_ac].ima021,g_xmg[l_ac].ima908 FROM ima_file #FUN-560193
                    WHERE ima01 = g_xmg[l_ac].xmg03
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            LET g_before_input_done = FALSE
            CALL i530_set_entry_b(p_cmd)
            CALL i530_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
         IF cl_null(g_xme.xme01) THEN LET g_xme.xme01=' ' END IF  #FUN-870100 ADD
            INSERT INTO xmg_file(xmg01,xmg02,xmg03,xmg04,xmg05,xmg06,
                                 xmg07)
                          VALUES(g_xme.xme01,g_xme.xme02,
                                 g_xmg[l_ac].xmg03,g_xmg[l_ac].xmg04,
                                 g_xmg[l_ac].xmg05,g_xmg[l_ac].xmg06,
                                 g_xmg[l_ac].xmg07)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_xmg[l_ac].xmg03,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
               LET g_success = 'N'
            ELSE
               MESSAGE 'INSERT O.K'
               IF g_success = 'Y' THEN
                   COMMIT WORK
               END IF
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_xmg[l_ac].* TO NULL
            LET g_xmg_t.* = g_xmg[l_ac].*         #新輸入資料
            LET g_xmg_o.* = g_xmg[l_ac].*         #新輸入資料
            LET g_xmg[l_ac].xmg06 = 0
            LET g_xmg[l_ac].xmg07 = 100
            LET g_xmg04_t = NULL                  #No.FUN-BB0086 add
            LET g_before_input_done = FALSE
            CALL i530_set_entry_b(p_cmd)
            CALL i530_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD xmg03
 
        BEFORE FIELD xmg04
            IF g_xmg[l_ac].xmg03 IS NULL THEN NEXT FIELD xmg03 END IF
            IF g_xmg[l_ac].xmg03 != g_xmg_t.xmg03 OR
               g_xmg_t.xmg03 IS NULL THEN
               SELECT ima02,ima021,ima908,ima31  #FUN-560193  #TQC-A10092 add ima31
                 INTO g_xmg[l_ac].ima02,g_xmg[l_ac].ima021,g_xmg[l_ac].ima908,g_xmg[l_ac].xmg04 FROM ima_file  #FUN-560193
                                                                                     #TQC-A10092 add g_xmg[l_ac].xmg04
                WHERE ima01=g_xmg[l_ac].xmg03
               IF STATUS THEN
#                 CALL cl_err(g_xmg[l_ac].xmg03,'mfg3006',0) NEXT FIELD xmg03   #No.FUN-660167
                  CALL cl_err3("sel","ima_file",g_xmg[l_ac].xmg03,"","mfg3006","","",1) NEXT FIELD xmg03 #No.FUN-660167
               END IF
            END IF
 
        AFTER FIELD xmg04
            IF NOT cl_null(g_xmg[l_ac].xmg04) THEN
               CALL i530_xmg04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_xmg[l_ac].xmg04,g_errno,0)
                  LET g_xmg[l_ac].xmg04 = g_xmg_o.xmg04
                  NEXT FIELD xmg04
               #FUN-9C0163 ADD START---------------------
                ELSE
                   IF NOT cl_null(g_xmg[l_ac].xmg03) THEN
                      SELECT ima31 INTO l_ima31 FROM ima_file
                       WHERE ima01 = g_xmg[l_ac].xmg03
                      CALL s_umfchk(g_xmg[l_ac].xmg03,g_xmg[l_ac].xmg04
                                    ,l_ima31)
                      RETURNING l_flag,l_fac
                      IF l_flag = 1 THEN
                         LET l_msg = l_ima31 CLIPPED,'->',
                                     g_xmg[l_ac].xmg04 CLIPPED
                         CALL cl_err(l_msg CLIPPED,'mfg2719',0)
                         NEXT FIELD xmg04
                      END IF
                   END IF
               #FUN-9C0163 ADD END-------------------------- 
               END IF
               #FUN-BB0086--add--start--
               IF NOT cl_null(g_xmg[l_ac].xmg06) AND g_xmg[l_ac].xmg06<>0 THEN  #FUN-C20068
                  IF NOT i530_xmg06_check(p_cmd)  THEN 
                     LET g_xmg04_t = g_xmg[l_ac].xmg04
                     NEXT FIELD xmg06 
                  END IF  
               END IF                                                           #FUN-C20068
               LET g_xmg04_t = g_xmg[l_ac].xmg04
               #FUN-BB0086--add--end--
            END IF

 
        AFTER FIELD xmg05
           IF NOT cl_null(g_xmg[l_ac].xmg05) THEN
              SELECT * FROM xmf_file
               WHERE xmf01 = g_xme.xme01
                 AND xmf02 = g_xme.xme02
                 AND xmf03 = g_xmg[l_ac].xmg03
                 AND xmf04 = g_xmg[l_ac].xmg04
                 AND xmf05 = g_xmg[l_ac].xmg05
#FUN-870100 MARK BEGIN-----
#             IF STATUS THEN
#                CALL cl_err3("sel","xmf_file",g_xme.xme01,g_xme.xme02,"axm-090","","",1)  #No.FUN-660167
#                NEXT FIELD xmg03   
#             END IF
#FUN-870100 MARK END--------  
           END IF
 
        AFTER FIELD xmg06
           #No.FUN-BB0086---start---add---
           IF NOT i530_xmg06_check(p_cmd)  THEN 
                NEXT FIELD xmg06 
           END IF  
           #No.FUN-BB0086---end---add---

           #No.FUN-BB0086---mark---start---
           #IF NOT cl_null(g_xmg[l_ac].xmg06) THEN
           #    IF g_xmg[l_ac].xmg06 < 0 THEN
           #        CALL cl_err(g_xmg[l_ac].xmg06,'mfg1322',0)
           #        NEXT FIELD xmg06
           #    END IF
           #END IF
           #IF p_cmd = 'a' OR (p_cmd = 'u' AND
           #   (g_xmg[l_ac].xmg03 != g_xmg_t.xmg03 OR
           #    g_xmg[l_ac].xmg04 != g_xmg_t.xmg04 OR
           #    g_xmg[l_ac].xmg05 != g_xmg_t.xmg05 OR
           #    g_xmg[l_ac].xmg06 != g_xmg_t.xmg06)) THEN
           #   SELECT COUNT(*) INTO l_cnt FROM xmg_file
           #    WHERE xmg01 = g_xme.xme01 AND xmg02 = g_xme.xme02
           #      AND xmg03 = g_xmg[l_ac].xmg03 AND xmg04 = g_xmg[l_ac].xmg04
           #      AND xmg05 = g_xmg[l_ac].xmg05 AND xmg06 = g_xmg[l_ac].xmg06
           #   IF l_cnt > 0 THEN
           #      CALL cl_err('',-239,0) NEXT FIELD xmg06
           #   END IF
           #END IF
           #No.TQC-960124  --Begin
           #IF NOT cl_null(g_xmg[l_ac].xmg06) THEN
           #  IF g_xmg[l_ac].xmg06 = 0 THEN
           #     LET g_xmg[l_ac].xmg07 = 100
           #  END IF
           #END IF
           #No.TQC-960124  --End
           #No.FUN-BB0086---mark---end---
           
        AFTER FIELD xmg07
           IF NOT cl_null(g_xmg[l_ac].xmg07) THEN
               IF g_xmg[l_ac].xmg07 < 0 OR g_xmg[l_ac].xmg07 > 100 THEN
                   CALL cl_err(g_xmg[l_ac].xmg07,'mfg1332',0) NEXT FIELD xmg07
               END IF
               #No.TQC-960124  --Begin
               IF NOT cl_null(g_xmg[l_ac].xmg06) AND g_xmg[l_ac].xmg06 = 0 THEN
                 IF g_xmg[l_ac].xmg07 <> 100 THEN
                    CALL cl_err(g_xmg[l_ac].xmg07,'axm-711',0)
                    NEXT FIELD xmg07
                 END IF
               END IF
               #No.TQC-960124  --End
               IF g_xmg[l_ac].xmg06 > 0 AND g_xmg[l_ac].xmg07 <> 100 THEN
                  IF g_xmg[l_ac].xmg07 != g_xmg_t.xmg07 OR
                     g_xmg_t.xmg07 IS NULL THEN
                     SELECT COUNT(*) INTO l_cnt
                       FROM xmg_file
                      WHERE xmg01 = g_xme.xme01 AND xmg02 = g_xme.xme02
                        AND xmg03 = g_xmg[l_ac].xmg03
                        AND xmg04 = g_xmg[l_ac].xmg04
                        AND xmg05 = g_xmg[l_ac].xmg05
                        AND ((xmg06 > g_xmg[l_ac].xmg06
                        AND xmg07 >= g_xmg[l_ac].xmg07)
                         OR (xmg06 < g_xmg[l_ac].xmg06
                        AND xmg07 <= g_xmg[l_ac].xmg07))
                     IF l_cnt >0 THEN
                        CALL cl_err('','axm-521',0) NEXT FIELD xmg07
                     END IF
                  END IF
               END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_xmg_t.xmg03 IS NOT NULL AND
               g_xmg_t.xmg04 IS NOT NULL AND
               g_xmg_t.xmg05 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
                DELETE FROM xmg_file WHERE xmg01 = g_xme.xme01
                                       AND xmg02 = g_xme.xme02
                                       AND xmg03 = g_xmg_t.xmg03
                                       AND xmg04 = g_xmg_t.xmg04
                                       AND xmg05 = g_xmg_t.xmg05
                IF SQLCA.SQLERRD[3] = 0 THEN
#                   CALL cl_err(g_xmg_t.xmg03,SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("del","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                   LET g_rec_b=g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            IF g_success = 'Y' THEN COMMIT WORK END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_xmg[l_ac].* = g_xmg_t.*
               CLOSE i530_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_xmg[l_ac].xmg03,-263,1)
                LET g_xmg[l_ac].* = g_xmg_t.*
            ELSE
                UPDATE xmg_file SET xmg06=g_xmg[l_ac].xmg06,
                                    xmg07=g_xmg[l_ac].xmg07,
                                    xmg05=g_xmg[l_ac].xmg05     #MOD-B30407 add
                 WHERE xmg01 = g_xme.xme01
                   AND xmg02 = g_xme.xme02
                   AND xmg03 = g_xmg_t.xmg03
                   AND xmg04 = g_xmg_t.xmg04
                   AND xmg05 = g_xmg_t.xmg05
                   AND xmg06 = g_xmg_t.xmg06
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                  CALL cl_err(g_xmg[l_ac].xmg03,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_xmg[l_ac].* = g_xmg_t.*
                   LET g_success = 'N'
                ELSE
                   MESSAGE 'UPDATE O.K'
                   IF g_success = 'Y' THEN
                       COMMIT WORK
                   END IF
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_xmg[l_ac].* = g_xmg_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_xmg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i530_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i530_bcl
            COMMIT WORK
 
        #BugNo:6596
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(xmg06) AND l_ac > 1 THEN
                LET g_xmg[l_ac].* = g_xmg[l_ac-1].*
                NEXT FIELD xmg06
            END IF
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # ON ACTION CONTROLN
      #     CALL i530_b_askkey()
      #     EXIT INPUT
 
        ON ACTION set_qty
                  CALL i530_ctry_xmg06()
                       NEXT FIELD xmg06
 
        ON ACTION set_discount
                  CALL i530_ctry_xmg07()
                       NEXT FIELD xmg07
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(xmg03)
#               CALL q_ima(05,11,g_xmg[l_ac].xmg03) RETURNING g_xmg[l_ac].xmg03
#               CALL FGL_DIALOG_SETBUFFER( g_xmg[l_ac].xmg03 )
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.default1 = g_xmg[l_ac].xmg03
#                CALL cl_create_qry() RETURNING g_xmg[l_ac].xmg03
#                CALL FGL_DIALOG_SETBUFFER( g_xmg[l_ac].xmg03 )
               CALL q_sel_ima(FALSE, "q_ima","",g_xmg[l_ac].xmg03,"","","","","",'' ) 
                  RETURNING  g_xmg[l_ac].xmg03

#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_xmg[l_ac].xmg03      #No.MOD-490371
                NEXT FIELD xmg03
              WHEN INFIELD(xmg04)
#               CALL q_gfe(05,11,g_xmg[l_ac].xmg04) RETURNING g_xmg[l_ac].xmg04
#               CALL FGL_DIALOG_SETBUFFER( g_xmg[l_ac].xmg04 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_xmg[l_ac].xmg04
                CALL cl_create_qry() RETURNING g_xmg[l_ac].xmg04
#                CALL FGL_DIALOG_SETBUFFER( g_xmg[l_ac].xmg04 )
                 DISPLAY BY NAME g_xmg[l_ac].xmg04      #No.MOD-490371
                NEXT FIELD xmg04
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
 
 
    CLOSE i530_bcl
    IF g_success = 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF
    CALL i530_show()
    CALL i530_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i530_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  xme_file WHERE xme01 = g_xme_t.xme01
                              AND xme02 = g_xme_t.xme02
                              AND xme00 = '2'  
         INITIALIZE g_xme.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i530_delall()
    SELECT COUNT(*) INTO g_cnt FROM xmg_file
        WHERE xmg01=g_xme_t.xme01
          AND xmg02=g_xme_t.xme02
    IF g_cnt = 0 THEN 		 	       #未輸入單身資料，則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM xme_file WHERE xme01 = g_xme_t.xme01
                              AND xme02 = g_xme_t.xme02
                              AND xme00 = '2'         #FUN-9C0163 ADD        
       IF SQLCA.SQLCODE THEN 
#         CALL cl_err('DEL-xme',SQLCA.SQLCODE,0)  #No.FUN-660167
          CALL cl_err3("del","xme_file",g_xme_t.xme01,g_xme_t.xme02,SQLCA.sqlcode,"","DEL-xme",1)  #No.FUN-660167
       END IF
    END IF
END FUNCTION
 
FUNCTION i530_xmg04()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_xmg[l_ac].xmg04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i530_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON xmg03,xmg04,xmg05,xmg06,xmg07
            FROM s_xmg[1].xmg03,s_xmg[1].xmg04,s_xmg[1].xmg05,
                 s_xmg[1].xmg06,s_xmg[1].xmg07
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
    CALL i530_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i530_b_fill(p_wc2)                  #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    #No.TQC-9B0034  --Begin
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    #No.TQC-9B0034  --End  

    LET g_sql =
        "SELECT xmg03,ima02,ima021,xmg04,ima908,xmg05,xmg06,xmg07", #FUN-560193
        " FROM xmg_file LEFT OUTER JOIN ima_file ON xmg_file.xmg03=ima_file.ima01",
        " WHERE  xmg01 ='",g_xme.xme01,"'",  #單頭
        "   AND xmg02 ='",g_xme.xme02,"'",                    #單頭
        "   AND ",p_wc2 CLIPPED,                              #單身
        " ORDER BY 1,5"
 
    PREPARE i530_pb FROM g_sql
    DECLARE xmg_curs                                         #CURSOR
        CURSOR FOR i530_pb
 
    CALL g_xmg.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH xmg_curs INTO g_xmg[g_cnt].*                     #單身 ARRAY 填充
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
    CALL g_xmg.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i530_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_xmg TO s_xmg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#FUN-870100 ADD-----------------
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
#FUN-870100 END--------------------
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i530_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i530_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i530_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i530_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i530_fetch('L')
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
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-7C0043--start--
FUNCTION i530_out()
 DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    sr              RECORD
        xme01       LIKE xme_file.xme01,
        xme02       LIKE xme_file.xme02,
        xme04       LIKE xme_file.xme04,
        xme05       LIKE xme_file.xme05,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        oah02       LIKE oah_file.oah02,
        xmg03       LIKE xmg_file.xmg03,
        xmg04       LIKE xmg_file.xmg04,
        xmg05       LIKE xmg_file.xmg05,
        xmg06       LIKE xmg_file.xmg06,
        xmg07       LIKE xmg_file.xmg07
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680137 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #        #No.FUN-680137 VARCHAR(40)
 DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                    
    IF cl_null(g_wc) AND NOT cl_null(g_xme.xme01) AND NOT cl_null(g_xme.xme02) THEN                                                 
       LET g_wc=" xme00='2' AND xme01='",g_xme.xme01,"' AND xme02='",g_xme.xme02,"' "                                                             
    END IF                                                                                                                          
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                     
    IF cl_null(g_wc2) THEN                                                                                                          
       LET g_wc2=" 1=1"                                                                                                             
    END IF                                                                                                                          
    LET l_cmd = 'p_query "axmi530" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                          
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN
#   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#   LET g_sql="SELECT xme01,xme02,xme04,xme05,ima02,ima021,oah02,",
#             "       xmg03,xmg04,xmg05,xmg06,xmg07",
#             "  FROM xme_file LEFT OUTER JOIN oah_file ON xme_file.xme01=oah_file.oah01,xmg_file LEFT OUTER JOIN ima_file ON xmg_file.xmb03=ima_file.ima01",
#             " WHERE xme01 = xmg01 ",
#             "   AND xme02 = xmg02 ",
#             "   AND ",g_wc CLIPPED,
#             "   AND ",g_wc2 CLIPPED
#   PREPARE i530_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i530_co                           # CURSOR
#       CURSOR FOR i530_p1
 
#   LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi530') RETURNING l_name
#   START REPORT i530_rep TO l_name
 
#   FOREACH i530_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i530_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i530_rep
 
#   CLOSE i530_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i530_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#   l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#   sr              RECORD
#       xme01       LIKE xme_file.xme01,
#       xme02       LIKE xme_file.xme02,
#       xme04       LIKE xme_file.xme04,
#       xme05       LIKE xme_file.xme05,
#       ima02       LIKE ima_file.ima02,
#       ima021      LIKE ima_file.ima021,
#       oah02       LIKE oah_file.oah02,
#       xmg03       LIKE xmg_file.xmg03,
#       xmg04       LIKE xmg_file.xmg04,
#       xmg05       LIKE xmg_file.xmg05,
#       xmg06       LIKE xmg_file.xmg06,
#       xmg07       LIKE xmg_file.xmg07
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.xme01,sr.xme02,sr.xmg03,sr.xmg05
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           PRINT ''
 
#           PRINT g_dash
#           PRINT g_x[31],
#                 g_x[32],
#                 g_x[33],
#                 g_x[34],
#                 g_x[35],
#                 g_x[36],
#                 g_x[37],
#                 g_x[38],
#                 g_x[39]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#
#       BEFORE GROUP OF sr.xme02
#           PRINT COLUMN g_c[31],sr.xme01 CLIPPED,
#                 COLUMN g_c[32],sr.oah02[1,10],     #No.TQC-6A0091
#                 COLUMN g_c[33],sr.xme02 CLIPPED;
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[34],sr.xmg05 CLIPPED,
#                 COLUMN g_c[35],sr.xmg03[1,30] CLIPPED,   #No.TQC-6A0091
#                 COLUMN g_c[36],sr.ima02[1,30] CLIPPED,   #No.TQC-6A0091
#                 COLUMN g_c[37],sr.ima021[1,30] CLIPPED,  #No.TQC-6A0091
#                 COLUMN g_c[38],sr.xmg06 USING '###,###,###,##&',
#                 COLUMN g_c[39],sr.xmg07 USING '####&'
#
#       AFTER GROUP OF sr.xme02
#           SKIP 1 LINE
#
#       ON LAST ROW
#           PRINT g_dash
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN
#                #TQC-630166 
#                #  IF g_wc[001,080] > ' ' THEN
#                #     PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                #  IF g_wc[071,140] > ' ' THEN
#       	 #     PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                #  IF g_wc[141,210] > ' ' THEN
#       	 #     PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(g_wc)
#                #END TQC-630166
#                   PRINT g_dash
#           END IF
#           PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  #No.TQC-5B0029  #No.TQC-6A0091
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.TQC-5B0029  #No.TQC-6A0091
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end-- 
FUNCTION i530_ctry_xmg06()
 DEFINE l_i LIKE type_file.num10,         #No.FUN-680137  INTEGEER
        l_xmg06 LIKE xmg_file.xmg06
    LET l_i = l_ac
    LET l_xmg06 = g_xmg[l_ac].xmg06
    IF cl_confirm('abx-080') THEN
        UPDATE xmg_file
           SET xmg06 = l_xmg06
         WHERE xmg01 = g_xme.xme01
           AND xmg02 = g_xme.xme02
           AND xmg03 = g_xmg[l_i].xmg03
           AND xmg04 = g_xmg[l_i].xmg04
           AND xmg05 = g_xmg[l_i].xmg05
           AND xmg06 = g_xmg_t.xmg06
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_xmg[l_i].xmg03,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_success='N'
            RETURN
        END IF
        LET g_xmg_o.xmg06 = g_xmg_t.xmg06
        LET g_xmg_t.xmg06 = l_xmg06
        WHILE l_i <= g_rec_b  #自本行至最后一行延用此值
              UPDATE xmg_file
                 SET xmg06 = l_xmg06
               WHERE xmg01 = g_xme.xme01
                 AND xmg02 = g_xme.xme02
                 AND xmg03 = g_xmg[l_i].xmg03
                 AND xmg04 = g_xmg[l_i].xmg04
                 AND xmg05 = g_xmg[l_i].xmg05
                 AND xmg06 = g_xmg[l_i].xmg06
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_xmg[l_i].xmg03,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_success='N'
                  EXIT WHILE
              END IF
              LET l_i = l_i + 1
               IF l_i > g_max_rec THEN #MOD-530336
                  EXIT WHILE
              END IF
        END WHILE
    END IF
    CALL i530_show()
END FUNCTION
FUNCTION i530_ctry_xmg07()
 DEFINE l_i LIKE type_file.num10,         #No.FUN-680137  INTEGER
        l_xmg07 LIKE xmg_file.xmg07
        LET l_i = l_ac
        LET l_xmg07 = g_xmg[l_ac].xmg07
        IF cl_confirm('abx-080') THEN
            WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
                  UPDATE xmg_file
                     SET xmg07 = l_xmg07
                   WHERE xmg01 = g_xme.xme01
                     AND xmg02 = g_xme.xme02
                     AND xmg03 = g_xmg[l_i].xmg03
                     AND xmg04 = g_xmg[l_i].xmg04
                     AND xmg05 = g_xmg[l_i].xmg05
                     AND xmg06 = g_xmg[l_i].xmg06
                     IF SQLCA.sqlcode THEN
#                        CALL cl_err(g_xmg[l_i].xmg07,SQLCA.sqlcode,0)   #No.FUN-660167
                         CALL cl_err3("upd","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                         LET g_success='N'
                         EXIT WHILE
                     END IF
                     LET l_i = l_i + 1
                      IF l_i > g_max_rec THEN #MOD-530336
                         EXIT WHILE
                     END IF
            END WHILE
        END IF
        CALL i530_show()
END FUNCTION
 
#No.FUN-870100 ADD BEGIN---------------------------
FUNCTION i530_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1        
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("xme01,xme02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i530_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1        
 
   IF (NOT g_before_input_done) THEN
      IF p_cmd = 'u' AND g_chkey = 'N' THEN
         CALL cl_set_comp_entry("xme01,xme02",FALSE)
      END IF
   END IF
 
END FUNCTION
#No.FUN-870100 ADD END-------------------------------------
 
FUNCTION i530_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
     # CALL cl_set_comp_entry("xmg03,xmg04,xmg05",TRUE)      #FUN-9C0163 MARK
       CALL cl_set_comp_entry("xmg03",TRUE)                  #FUN-9C0163 ADD
   END IF
 
END FUNCTION
 
FUNCTION i530_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_before_input_done = FALSE THEN
      #CALL cl_set_comp_entry("xmg03,xmg04,xmg05",FALSE) #FUN-9C0163 MARK
       CALL cl_set_comp_entry("xmg03",FALSE)            #FUN-9C0163 ADD
   END IF
 
END FUNCTION
#FUN-960130


#FUN-9C0163 ADD START---------------------------------------------------------------------- 
FUNCTION i530_gen()    
   DEFINE l_wc          LIKE type_file.chr1000     
   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE l_sql         LIKE type_file.chr1000       
   DEFINE l_cnt         LIKE type_file.num5         
 
   SELECT COUNT(*) INTO l_cnt FROM xmg_file
    WHERE xmg01 = g_xme.xme01
      AND xmg02 = g_xme.xme02
   IF l_cnt > 0 THEN RETURN END IF
 
   LET p_row = 8 LET p_col = 18
   OPEN WINDOW i530_w1 AT p_row,p_col        
        WITH FORM "axm/42f/axmi5201"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)  
 
   CALL cl_ui_locale("axmi5201")
 
   CONSTRUCT BY NAME l_wc ON ima06,ima01
  
              BEFORE CONSTRUCT
                 CALL cl_qbe_init() 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help()   
 
      ON ACTION controlg       
         CALL cl_cmdask()     
          
      ON ACTION controlp
         CASE
           WHEN INFIELD(ima01)
#FUN-AA0059---------mod------------str-----------------           
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima02"
#                LET g_qryparam.state = 'c'
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima(TRUE, "q_ima02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO ima01
                NEXT FIELD ima01              
         END CASE   
         
     ON ACTION qbe_select
         	   CALL cl_qbe_select()
     ON ACTION qbe_save
		   CALL cl_qbe_save() 
		   
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i530_w1
      RETURN
   END IF
 
   LET l_cnt=0
   LET l_sql = "SELECT * FROM ima_file WHERE ",l_wc CLIPPED
 
   PREPARE i5301_prepare FROM l_sql
   IF STATUS THEN
      CALL cl_err('pre',STATUS,1)
      CLOSE WINDOW i530_w1
      RETURN
   END IF
 
   DECLARE i5301_cs CURSOR FOR i5301_prepare
 
   FOREACH i5301_cs INTO l_ima.*
      #FUN-AB0025 ----------add start----------
      IF NOT cl_null(l_ima.ima01) THEN
         IF NOT s_chk_item_no(l_ima.ima01,'') THEN
            CONTINUE FOREACH
         END IF
      END IF
      #FUN-AB0025 -----------add end-----------
      IF l_ima.ima33 IS NULL THEN LET l_ima.ima33 = 0   END IF
      IF l_ima.ima31 IS NULL THEN LET l_ima.ima31 = " " END IF
      IF cl_null(g_xme.xme01) THEN LET g_xme.xme01= ' ' END IF  

      INSERT INTO xmg_file(xmg01,xmg02,xmg03,xmg04,xmg05,xmg06,xmg07)
                    VALUES(g_xme.xme01,g_xme.xme02,l_ima.ima01,
                           l_ima.ima31,g_today,0,100)
      IF STATUS THEN  
         CALL cl_err3("ins","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.SQLCODE,"","ins xmg",1)   
         EXIT FOREACH 
      END IF
   END FOREACH
 
   ERROR ""
   CLOSE WINDOW i530_w1
 
   CALL i530_b_fill("1=1")
 
END FUNCTION
#FUN-9C0163 ADD END----------------------------------------------------------------------

#No.FUN-BB0086---start---add---
FUNCTION i530_xmg06_check(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_cnt      LIKE type_file.num5

   IF NOT cl_null(g_xmg[l_ac].xmg06) AND NOT cl_null(g_xmg[l_ac].xmg04) THEN
      IF cl_null(g_xmg_t.xmg06) OR cl_null(g_xmg04_t) OR g_xmg_t.xmg06 != g_xmg[l_ac].xmg06 OR g_xmg04_t != g_xmg[l_ac].xmg04 THEN
         LET g_xmg[l_ac].xmg06=s_digqty(g_xmg[l_ac].xmg06, g_xmg[l_ac].xmg04)
         DISPLAY BY NAME g_xmg[l_ac].xmg06
      END IF
   END IF

   IF NOT cl_null(g_xmg[l_ac].xmg06) THEN
      IF g_xmg[l_ac].xmg06 <= 0 THEN #TQC-BC0060
      CALL cl_err(g_xmg[l_ac].xmg06,'mfg1322',0)
      RETURN FALSE 
      END IF
   END IF
   IF p_cmd = 'a' OR (p_cmd = 'u' AND
      (g_xmg[l_ac].xmg03 != g_xmg_t.xmg03 OR
      g_xmg[l_ac].xmg04 != g_xmg_t.xmg04 OR
      g_xmg[l_ac].xmg05 != g_xmg_t.xmg05 OR
      g_xmg[l_ac].xmg06 != g_xmg_t.xmg06)) THEN
      SELECT COUNT(*) INTO l_cnt FROM xmg_file
       WHERE xmg01 = g_xme.xme01 AND xmg02 = g_xme.xme02
         AND xmg03 = g_xmg[l_ac].xmg03 AND xmg04 = g_xmg[l_ac].xmg04
         AND xmg05 = g_xmg[l_ac].xmg05 AND xmg06 = g_xmg[l_ac].xmg06
      IF l_cnt > 0 THEN
         CALL cl_err('',-239,0) 
         RETURN FALSE 
      END IF
   END IF
   #No.TQC-960124  --Begin
   IF NOT cl_null(g_xmg[l_ac].xmg06) THEN
      IF g_xmg[l_ac].xmg06 = 0 THEN
      LET g_xmg[l_ac].xmg07 = 100
      END IF
   END IF
   #No.TQC-960124  --End
   RETURN TRUE 
END FUNCTION 
#No.FUN-BB0086---end---add---
