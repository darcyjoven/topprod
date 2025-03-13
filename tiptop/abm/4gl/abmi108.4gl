# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: abmi108.4gl
# Descriptions...: 工程BOM-聯產品維護作業
# Date & Author..: 03/04/21 By Mandy
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510033 05/01/19 By Mandy 報表轉XML
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-8C0219 08/12/22 By claire 調整語法,否則單頭輸入後,進單身前程式會莫名的當出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/05 By vealxu 拿掉FUN-AA0059 料號管控，測試料件無需判斷
# Modify.........: No.FUN-AB0025 10/11/05 By lixh1  拿掉FUN-AA0059系統料號的開窗控管
# Modify.........: No.FUN-ABOO25 10/11/11 By lixh1 还原FUN-AA0059 系統開窗管控
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmo           RECORD
                       bmo01  LIKE bmo_file.bmo01,
                       bmo011 LIKE bmo_file.bmo011,
                       bmo05  LIKE bmo_file.bmo05, bmo06  LIKE bmo_file.bmo06
                    END RECORD,
    g_bmo_t         RECORD
                       bmo01  LIKE bmo_file.bmo01,
                       bmo011 LIKE bmo_file.bmo011,
                       bmo05  LIKE bmo_file.bmo05, bmo06  LIKE bmo_file.bmo06
                    END RECORD,
    g_bmo01_t       LIKE bmo_file.bmo01,   
    g_bmo011_t      LIKE bmo_file.bmo011,   
    g_bmn           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        bmn02       LIKE bmn_file.bmn02,     #項次
        bmn03       LIKE bmn_file.bmn03,     #聯產品料件號編號
        ima02s      LIKE ima_file.ima02,
        ima021s     LIKE ima_file.ima021,
        bmn04       LIKE bmn_file.bmn04,     #聯產品單位
        bmn05       LIKE bmn_file.bmn05      #生效否
                    END RECORD,
    g_bmn_t         RECORD                   #程式變數 (舊值)
        bmn02       LIKE bmn_file.bmn02,     #項次
        bmn03       LIKE bmn_file.bmn03,     #聯產品料件號編號
        ima02s      LIKE ima_file.ima02,
        ima021s     LIKE ima_file.ima021,
        bmn04       LIKE bmn_file.bmn04,     #聯產品單位
        bmn05       LIKE bmn_file.bmn05      #生效否
                    END RECORD,
   #g_wc,g_wc2,g_sql    STRING, #TQC-630166  
    g_wc,g_wc2,g_sql    STRING,              #TQC-630166
    g_flag          LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,     #單身筆數      #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,     #目前處理的ARRAY CNT     #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5      #目前處理的SCREEN LINE   #No.FUN-680096 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680096 SMALLINT
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose  #No.FUN-680096 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03        #No.FUN-680096 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
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
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
 
    LET g_bmo.bmo01  = ARG_VAL(1)          #主件編號
    LET g_bmo.bmo011 = ARG_VAL(2)          #版本
 
    LET g_forupd_sql =
        "SELECT * FROM bmo_file WHERE bmo01=g_bmo.bmo01 AND bmo011=g_bmo.bmo011 AND bmo06=g_bmo.bmo06 FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i108_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 4
 
    OPEN WINDOW i108_w AT  p_row,p_col         #顯示畫面
         WITH FORM "abm/42f/abmi108"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    IF g_bmo.bmo01 IS NOT NULL AND  g_bmo.bmo01 != ' ' THEN
        LET g_flag = 'Y'
        LET g_rec_b = 0
        CALL i108_q()
        CALL i108_b()
    ELSE
        LET g_flag = 'N'
    END IF
    CALL i108_menu()
    CLOSE WINDOW i108_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i108_cs()
DEFINE  lc_qbe_sn    LIKE gbm_file.gbm01       #No.FUN-580031  HCN
DEFINE  l_i,l_j      LIKE type_file.num5,      #No.FUN-680096 SMALLINT
        l_buf        LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(500)       
    CLEAR FORM                                 #清除畫面
    CALL g_bmn.clear()
 
 IF g_flag = 'N'
 THEN
    CALL cl_set_head_visible("","YES")         #No.FUN-6B0033
   INITIALIZE g_bmo.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                  # 螢幕上取單頭條件
          bmn01
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bmn01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmq"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmn01
                  NEXT FIELD bmn01
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
 ELSE LET g_wc = "     bmo01  ='",g_bmo.bmo01 ,"'",
                 " AND bmo011 ='",g_bmo.bmo011,"'"
      LET g_wc2= "     bmn01  ='",g_bmo.bmo01 ,"'",
                 " AND bmn011 ='",g_bmo.bmo011,"'"
 END IF
    IF INT_FLAG THEN  RETURN END IF
    IF g_flag = 'N' THEN
                 ## 將bmn 轉換為bmo
                     LET l_buf=g_wc
                     LET l_j=length(l_buf)
                    #FOR l_i=1 TO l_j       #MOD-8C0219 mark
                     FOR l_i=1 TO (l_j-4)   #MOD-8C0219
                        IF l_buf[l_i,l_i+4]='bmn01' THEN
                              LET l_buf[l_i,l_i+4]='bmo01'
                        END IF
                     END FOR
                     LET g_wc  = l_buf
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bmouser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bmogrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bmogrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmouser', 'bmogrup')
    #End:FUN-980030
 
 
IF g_flag = 'N'
THEN
   CONSTRUCT g_wc2 ON bmn02,bmn03,bmn04,bmn05               # 螢幕上取單身條件
            FROM s_bmn[1].bmn02,s_bmn[1].bmn03,
                 s_bmn[1].bmn04,s_bmn[1].bmn05
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmn03)
#                    CALL q_ima1(3,10,'MT',g_bmn[1].bmn03) RETURNING g_bmn[1].bmn03
#FUN-AB0025 --Begin--  remark
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima1"
                   #  LET g_qryparam.state = 'c'
                   #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima1","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
#FUN-AB0025 --End--  remark
                     DISPLAY g_qryparam.multiret TO bmn03
                     NEXT FIELD bmn03
                WHEN INFIELD(bmn04)
#                    CALL q_gfe(3,10,g_bmn[1].bmn04) RETURNING g_bmn[1].bmn04
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmn04
                     NEXT FIELD bmn04
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
 
 
		#No.FUN-580031 --start--     HCN
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN  RETURN END IF
ELSE LET g_wc2 = " 1=1"
END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT bmo06, bmo01,bmo011 FROM bmo_file,bmq_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND bmq01  = bmo01 ",
                   "   AND bmq903 = 'Y' ",
                   " ORDER BY bmo01,bmo011"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT bmo06, bmo01,bmo011 ",
                   "  FROM bmo_file, bmn_file,bmq_file ",
                   " WHERE bmo01 = bmn01 ",
                   "   AND bmq01 = bmo01 ",
                   "   AND bmq903 = 'Y' ",
                   "   AND ", g_wc  CLIPPED,
                    "  AND ", g_wc2 CLIPPED,
                   " ORDER BY bmo01,bmo011"
    END IF
 
    PREPARE i108_prepare FROM g_sql
    DECLARE i108_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i108_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bmo_file,bmq_file WHERE ",g_wc CLIPPED,
                   "  AND bmq01 = bmo01 ",
                   "  AND bmq903 = 'Y' "
    ELSE
        LET g_sql="SELECT COUNT(distinct bmo01) FROM bmo_file,bmn_file,bmq_file",
                  " WHERE bmo01=bmn01 ",
                  "   AND bmq01 = bmo01 ",
                  "   AND bmq903 = 'Y' ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE i108_precount FROM g_sql
    DECLARE i108_count CURSOR FOR i108_precount
END FUNCTION
 
FUNCTION i108_menu()
 
   WHILE TRUE
      CALL i108_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i108_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i108_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i108_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmo.bmo01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmn01"
                  LET g_doc.value1  = g_bmo.bmo01
                  LET g_doc.column2 = "bmo011"
                  LET g_doc.value2  = g_bmo.bmo011
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmn),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
#Query 查詢
FUNCTION i108_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bmn.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i108_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_bmo.* TO NULL
        RETURN
    END IF
    OPEN i108_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmo.* TO NULL
    ELSE
        OPEN i108_count
        FETCH i108_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i108_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i108_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式     #No.FUN-680096 VARCHAR(1)
    l_bmouser       LIKE bmo_file.bmouser, #FUN-4C0054
    l_bmogrup       LIKE bmo_file.bmogrup  #FUN-4C0054
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i108_cs INTO g_bmo.bmo06,g_bmo.bmo01,g_bmo.bmo011
        WHEN 'P' FETCH PREVIOUS i108_cs INTO g_bmo.bmo06,g_bmo.bmo01,g_bmo.bmo011
        WHEN 'F' FETCH FIRST    i108_cs INTO g_bmo.bmo06,g_bmo.bmo01,g_bmo.bmo011
        WHEN 'L' FETCH LAST     i108_cs INTO g_bmo.bmo06,g_bmo.bmo01,g_bmo.bmo011
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i108_cs INTO g_bmo.bmo06,g_bmo.bmo01,g_bmo.bmo011
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmo.bmo01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_bmo.* TO NULL  #TQC-6B0105
              #TQC-6B0105
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
    SELECT bmo01,bmo011,bmo05,bmouser,bmogrup #FUN-4C0054
           INTO g_bmo.* ,l_bmouser,l_bmogrup FROM bmo_file WHERE bmo01=g_bmo.bmo01 AND bmo011=g_bmo.bmo011 AND bmo06=g_bmo.bmo06 #FUN-4C0054
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmo.bmo01 CLIPPED
     #  CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bmo_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
        INITIALIZE g_bmo.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = l_bmouser      #FUN-4C0054
        LET g_data_group = l_bmogrup      #FUN-4C0054
    END IF
    CALL i108_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i108_show()
    LET g_bmo_t.* = g_bmo.*                #保存單頭舊值
    DISPLAY g_bmo.bmo01  TO bmn01      # 顯示單頭KEY值
    DISPLAY g_bmo.bmo011 TO bmn011     # 顯示單頭KEY值
    CALL i108_bmn01()
    CALL i108_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i108_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用      #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否      #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態        #No.FUN-680096 VARCHAR(1)
    l_flag          LIKE type_file.chr1,      #判斷必要欄位是否有輸入        #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,      #可新增否        #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否        #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmo.bmo01 IS NULL OR g_bmo.bmo01 = ' '
    THEN CALL cl_err('',-400,0) RETURN
    END IF
    IF NOT cl_null(g_bmo.bmo05) THEN
        CALL cl_err(g_bmo.bmo01,'mfg2761',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT bmn02,bmn03,'','',bmn04,bmn05 ",
       "  FROM bmn_file ",
       "   WHERE bmn01 = ? ",
       "   AND bmn011= ? ",
       "   AND bmn02 = ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i108_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmn
              WITHOUT DEFAULTS
              FROM s_bmn.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bmn_t.* = g_bmn[l_ac].*  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
 
                OPEN i108_bcl USING g_bmo.bmo01,g_bmo.bmo011,g_bmn_t.bmn02
                IF STATUS THEN
                    CALL cl_err("OPEN i108_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i108_bcl INTO g_bmn[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmn_t.bmn02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    SELECT ima02,ima021 INTO g_bmn[l_ac].ima02s,g_bmn[l_ac].ima021s
                      FROM ima_file
                     WHERE ima01 = g_bmn[l_ac].bmn03
                    IF SQLCA.sqlcode = 100 THEN
                        SELECT bmq02,bmq021 INTO g_bmn[l_ac].ima02s,g_bmn[l_ac].ima021s
                          FROM bmq_file
                         WHERE bmq01 = g_bmn[l_ac].bmn03
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bmn02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO bmn_file(bmn01,bmn011,bmn02,bmn03,bmn04,bmn05)
            VALUES(g_bmo.bmo01,g_bmo.bmo011,
                   g_bmn[l_ac].bmn02,g_bmn[l_ac].bmn03,
                   g_bmn[l_ac].bmn04,g_bmn[l_ac].bmn05)
            IF SQLCA.sqlcode THEN
        #      CALL cl_err(g_bmn[l_ac].bmn02,SQLCA.sqlcode,0) #No.TQC-660046
               CALL cl_err3("ins","bmn_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)   #No.TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_bmn[l_ac].* TO NULL      #900423
            LET g_bmn[l_ac].bmn05 = 'Y'
            LET g_bmn_t.* = g_bmn[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmn02
 
        BEFORE FIELD bmn02                        #default 序號
            IF g_bmn[l_ac].bmn02 IS NULL OR
               g_bmn[l_ac].bmn02 = 0 THEN
                SELECT max(bmn02)+1
                   INTO g_bmn[l_ac].bmn02
                   FROM bmn_file
                   WHERE bmn01 = g_bmo.bmo01
                IF g_bmn[l_ac].bmn02 IS NULL THEN
                    LET g_bmn[l_ac].bmn02 = 1
                END IF
            END IF
 
        AFTER FIELD bmn02                        #check 序號是否重複
            IF NOT cl_null(g_bmn[l_ac].bmn02) THEN
                IF g_bmn[l_ac].bmn02 != g_bmn_t.bmn02 OR
                   g_bmn_t.bmn02 IS NULL THEN
                    SELECT count(*)
                        INTO l_n
                        FROM bmn_file
                        WHERE bmn01 = g_bmo.bmo01
                          AND bmn02 = g_bmn[l_ac].bmn02
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_bmn[l_ac].bmn02 = g_bmn_t.bmn02
                        NEXT FIELD bmn02
                    END IF
                END IF
            END IF
        AFTER FIELD bmn03
            IF NOT cl_null(g_bmn[l_ac].bmn03) THEN
#FUN-AB0025 -----------mark start-----------------
#                #FUN-AA0059 ----------------------------add start-------------------------
#               IF NOT s_chk_item_no(g_bmn[l_ac].bmn03,'') THEN
#                  CALL cl_err('',g_errno,1)
#                  LET g_bmn[l_ac].bmn03 = g_bmn_t.bmn03
#                  DISPLAY g_bmn[l_ac].bmn03 TO s_bmn[l_sl].bmn03
#                  NEXT FIELD bmn03
#               END IF 
#               #FUN-AA0059 ---------------------------add end-------------------------     
#FUN-AB0025 ----------mark end-----------------
                CALL i108_bmn03('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_bmn[l_ac].bmn03,g_errno,0) 
                    LET g_bmn[l_ac].bmn03 = g_bmn_t.bmn03
                    DISPLAY g_bmn[l_ac].bmn03 TO s_bmn[l_sl].bmn03
                    NEXT FIELD bmn03
                END IF
                IF g_bmn[l_ac].bmn03 != g_bmn_t.bmn03 OR
                   cl_null(g_bmn_t.bmn03) THEN
                    SELECT COUNT(*) INTO g_cnt
                      FROM bmn_file
                     WHERE bmn01 = g_bmo.bmo01
                       AND bmn03 = g_bmn[l_ac].bmn03
                    IF g_cnt >0 THEN
                        CALL cl_err(g_bmn[l_ac].bmn03,'abm-609',0)
                        #聯產品料件號編號重覆!
                        LET g_bmn[l_ac].bmn03 = g_bmn_t.bmn03
                        DISPLAY g_bmn[l_ac].bmn03 TO s_bmn[l_sl].bmn03
                        NEXT FIELD bmn03
                    END IF
                END IF
                SELECT COUNT(*) INTO g_cnt
                  FROM bma_file
                 WHERE bma01 = g_bmn[l_ac].bmn03
                IF g_cnt >=1 AND g_bmn[l_ac].bmn03 != g_bmo.bmo01 THEN
                    #請重新輸入,因為此料號有建立BOM!
                    CALL cl_err(g_bmn[l_ac].bmn03,'abm-612',0)
                    LET g_bmn[l_ac].bmn03 = g_bmn_t.bmn03
                    DISPLAY g_bmn[l_ac].bmn03 TO s_bmn[l_sl].bmn03
                    NEXT FIELD bmn03
                END IF
                SELECT COUNT(*) INTO g_cnt
                  FROM bmo_file
                 WHERE bmo01 = g_bmn[l_ac].bmn03
                IF g_cnt >=1 AND g_bmn[l_ac].bmn03 != g_bmo.bmo01 THEN
                    #請重新輸入,因為此料號有建立測試BOM!
                    CALL cl_err(g_bmn[l_ac].bmn03,'abm-614',0)
                    LET g_bmn[l_ac].bmn03 = g_bmn_t.bmn03
                    DISPLAY g_bmn[l_ac].bmn03 TO s_bmn[l_sl].bmn03
                    NEXT FIELD bmn03
                END IF
            END IF
        AFTER FIELD bmn04
            IF cl_null(g_bmn[l_ac].bmn04) THEN
                LET g_bmn[l_ac].bmn04 = g_bmn_t.bmn04
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bmn[l_ac].bmn04
                #------MOD-5A0095 END------------
            END IF
        AFTER FIELD bmn05
            IF NOT cl_null(g_bmn[l_ac].bmn05) THEN
               IF g_bmn[l_ac].bmn05 NOT MATCHES "[YN]" THEN
                   LET g_bmn[l_ac].bmn05 = g_bmn_t.bmn05
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_bmn[l_ac].bmn05
                   #------MOD-5A0095 END------------
                   NEXT FIELD bmn05
               END IF
            END IF
        BEFORE DELETE                            #是否取消單身
            IF g_bmn_t.bmn02 > 0 AND
               g_bmn_t.bmn02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bmn_file
                    WHERE bmn01  = g_bmo.bmo01
                      AND bmn011 = g_bmo.bmo011
                      AND bmn02  = g_bmn_t.bmn02
                IF SQLCA.sqlcode THEN
               #    CALL cl_err(g_bmn_t.bmn02,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("del","bmn_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)    #Np:TQC-660046
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
               LET g_bmn[l_ac].* = g_bmn_t.*
               CLOSE i108_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bmn[l_ac].bmn02,-263,1)
               LET g_bmn[l_ac].* = g_bmn_t.*
            ELSE
                UPDATE bmn_file SET
                       bmn02=g_bmn[l_ac].bmn02,
                       bmn03=g_bmn[l_ac].bmn03,
                       bmn04=g_bmn[l_ac].bmn04,
                       bmn05=g_bmn[l_ac].bmn05
                 WHERE bmn01 = g_bmo.bmo01
                   AND bmn011= g_bmo.bmo011
                   AND bmn02 = g_bmn_t.bmn02
                IF SQLCA.sqlcode THEN
             #      CALL cl_err(g_bmn[l_ac].bmn02,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","bmn_file",g_bmo.bmo01,g_bmo.bmo011,SQLCA.sqlcode,"","",1)   #No.TQC-660046
                    LET g_bmn[l_ac].* = g_bmn_t.*
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
                  LET g_bmn[l_ac].* = g_bmn_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i108_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_bmn_t.* = g_bmn[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i108_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmn03)
#                    CALL q_ima1(3,10,'MT',g_bmn[l_ac].bmn03) RETURNING g_bmn[l_ac].bmn03
#                    CALL FGL_DIALOG_SETBUFFER( g_bmn[l_ac].bmn03 )
#FUN-AB0025 --Begin--  remark
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima1"
                  #   LET g_qryparam.default1 = g_bmn[l_ac].bmn03
                  #   LET g_qryparam.where = " ima08 IN ('M','T') "
                  #   CALL cl_create_qry() RETURNING g_bmn[l_ac].bmn03
                     CALL q_sel_ima(FALSE, "q_ima1", " ima08 IN ('M','T') ", g_bmn[l_ac].bmn03, "", "", "", "" ,"",'' ) RETURNING g_bmn[l_ac].bmn03
#FUN-AA0059 --End--
#FUN-AB0025 --End--  remark
#                     CALL FGL_DIALOG_SETBUFFER( g_bmn[l_ac].bmn03 )
                     DISPLAY g_bmn[l_ac].bmn03 TO bmn03
                     NEXT FIELD bmn03
                WHEN INFIELD(bmn04)
#                    CALL q_gfe(3,10,g_bmn[l_ac].bmn04) RETURNING g_bmn[l_ac].bmn04
#                    CALL FGL_DIALOG_SETBUFFER( g_bmn[l_ac].bmn04 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.default1 = g_bmn[l_ac].bmn04
                     CALL cl_create_qry() RETURNING g_bmn[l_ac].bmn04
#                     CALL FGL_DIALOG_SETBUFFER( g_bmn[l_ac].bmn04 )
                     DISPLAY g_bmn[l_ac].bmn04 TO bmn04
                     NEXT FIELD bmn04
               OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION qry_test_item
#                    CALL q_bmq(8,2,g_bmn[l_ac].bmn03) RETURNING g_bmn[l_ac].bmn03
#                    CALL FGL_DIALOG_SETBUFFER( g_bmn[l_ac].bmn03 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmq"
                     LET g_qryparam.default1 = g_bmn[l_ac].bmn03
                     CALL cl_create_qry() RETURNING g_bmn[l_ac].bmn03
#                     CALL FGL_DIALOG_SETBUFFER( g_bmn[l_ac].bmn03 )
                     DISPLAY g_bmn[l_ac].bmn03 TO bmn03
                     NEXT FIELD bmn03
 
      # ON ACTION CONTROLN
      #     CALL i108_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmn02) AND l_ac > 1 THEN
                LET g_bmn[l_ac].* = g_bmn[l_ac-1].*
                DISPLAY g_bmn[l_ac].* TO s_bmn[l_sl].*
                NEXT FIELD bmn02
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
 
    CLOSE i108_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i108_b_askkey()
DEFINE
    l_wc2        LIKE type_file.chr1000       #No.FUN-680096  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON bmn02,bmn03,bmn04,bmn05
            FROM s_bmn[1].bmn02,s_bmn[1].bmn03,
                 s_bmn[1].bmn04,s_bmn[1].bmn05
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
    CALL i108_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i108_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(200)
    l_flag     LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
    LET g_sql =
        "SELECT bmn02,bmn03,'','',bmn04,bmn05 ",
        "  FROM bmn_file ",
        " WHERE bmn01 ='",g_bmo.bmo01,"'", #單頭-1
        "   AND ",p_wc2 CLIPPED,           #單身
        " ORDER BY 1,2,3,4"
    PREPARE i108_pb FROM g_sql
    DECLARE bmn_cs                       #SCROLL CURSOR
        CURSOR FOR i108_pb
 
    CALL g_bmn.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH bmn_cs INTO g_bmn[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021 INTO g_bmn[g_cnt].ima02s,g_bmn[g_cnt].ima021s
          FROM ima_file
         WHERE ima01 = g_bmn[g_cnt].bmn03
        IF SQLCA.sqlcode = 100 THEN
            SELECT bmq02,bmq021 INTO g_bmn[g_cnt].ima02s,g_bmn[g_cnt].ima021s
              FROM bmq_file
             WHERE bmq01 = g_bmn[g_cnt].bmn03
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
    CALL g_bmn.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i108_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmn TO s_bmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i108_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i108_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i108_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i108_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i108_fetch('L')
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
 
 
 
FUNCTION i108_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bmn01       LIKE bmn_file.bmn01,   #
        bmn011      LIKE bmn_file.bmn011,  #
        bmn02       LIKE bmn_file.bmn02,   #
        bmn03       LIKE bmn_file.bmn03,   #
        bmn04       LIKE bmn_file.bmn04,   #
        bmn05       LIKE bmn_file.bmn05,
        bmq02       LIKE ima_file.ima02,   #主件編號的品名
        bmq021      LIKE bmq_file.bmq021,  #主件編號的品名 #FUN-510033
        ima02s      LIKE ima_file.ima02,   #聯產品料號的品名
        ima021s     LIKE ima_file.ima021   #聯產品料號的規格
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('abmi108') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT bmn01,bmn011,bmn02,bmn03,bmn04,bmn05 ",
              "  FROM bmn_file,bmq_file,bmo_file ",
              " WHERE bmn01 = bmo01 ",
              "   AND bmq903 = 'Y' ",
              "   AND bmn01 = bmq01 ",
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,2,3,4,5,6"
    PREPARE i108_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i108_co                         # CURSOR
        CURSOR FOR i108_p1
 
    START REPORT i108_rep TO l_name
 
    FOREACH i108_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT bmq02,bmq021 INTO sr.bmq02,sr.bmq021  FROM bmq_file
         WHERE bmq01 = sr.bmn01
        SELECT ima02,ima021 INTO sr.ima02s ,sr.ima021s FROM ima_file
         WHERE ima01 = sr.bmn03
        IF SQLCA.sqlcode = 100 THEN
            SELECT bmq02,bmq021 INTO sr.ima02s,sr.ima021s FROM bmq_file
             WHERE bmq01 = sr.bmn03
        END IF
        OUTPUT TO REPORT i108_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i108_rep
 
    CLOSE i108_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i108_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,   #NO.FUN-680096 VARCHAR(1)
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bmn01       LIKE bmn_file.bmn01,   #
        bmn011      LIKE bmn_file.bmn011,  #
        bmn02       LIKE bmn_file.bmn02,
        bmn03       LIKE bmn_file.bmn03,   #
        bmn04       LIKE bmn_file.bmn04,   #
        bmn05       LIKE bmn_file.bmn05,
        bmq02       LIKE bmq_file.bmq02,   #主件編號的品名
        bmq021      LIKE bmq_file.bmq021,  #主件編號的品名 #FUN-510033
        ima02s      LIKE ima_file.ima02,   #聯產品料號的品名
        ima021s     LIKE ima_file.ima021   #聯產品料號的規格
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bmn01,sr.bmn011,sr.bmn02,sr.bmn03
 
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
 
        BEFORE GROUP OF sr.bmn01
            PRINT COLUMN g_c[31],sr.bmn01,
                  COLUMN g_c[32],sr.bmq02,
                  COLUMN g_c[33],sr.bmq021,
                  COLUMN g_c[34],sr.bmn011;
            LET l_i = 1
 
 
        ON EVERY ROW
            PRINT COLUMN g_c[35],sr.bmn02 USING '###&',
                  COLUMN g_c[36],sr.bmn03,
                  COLUMN g_c[37],sr.ima02s,
                  COLUMN g_c[38],sr.ima021s,
                  COLUMN g_c[39],sr.bmn04,
                  COLUMN g_c[40],sr.bmn05
           #IF l_i = 1 THEN
           #    PRINT COLUMN  2,sr.bmq02;
           #END IF
           #PRINT COLUMN 33,sr.ima02s
           #PRINT COLUMN 33,sr.ima021s
           #LET l_i = l_i + 1
 
 
 
        AFTER GROUP OF sr.bmn01
              SKIP 1 LINE
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN #IF g_wc[001,080] > ' ' THEN
		    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                    #IF g_wc[071,140] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                    #IF g_wc[141,210] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                     CALL cl_prt_pos_wc(g_wc) #TQC-630166
                     PRINT g_dash[1,g_len]
            END IF
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION i108_bmn03(p_cmd)    #聯產品料件號編號
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
         l_ima02     LIKE ima_file.ima02,
         l_ima08     LIKE ima_file.ima08,    #來源碼
         l_imaacti   LIKE ima_file.imaacti
 
  LET g_errno = ' '
  SELECT              ima02,            ima021 ,            ima55,  imaacti,  ima08
    INTO g_bmn[l_ac].ima02s,g_bmn[l_ac].ima021s,g_bmn[l_ac].bmn04,l_imaacti,l_ima08
    FROM ima_file
   WHERE ima01 = g_bmn[l_ac].bmn03
  IF SQLCA.sqlcode = 100 THEN
      SELECT             bmq02 ,            bmq021 ,            bmq55,  bmqacti,  bmq08
        INTO g_bmn[l_ac].ima02s,g_bmn[l_ac].ima021s,g_bmn[l_ac].bmn04,l_imaacti,l_ima08
        FROM bmq_file
       WHERE bmq01 = g_bmn[l_ac].bmn03
  END IF
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                                 LET l_ima02 = NULL
       WHEN l_ima08 NOT MATCHES "[MT]"
                                 LET g_errno = 'abm-608' #料件的來源碼要為'M'或'T'
       WHEN l_imaacti='N' LET g_errno = '9028'
       
  #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
 
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY g_bmn[l_ac].ima02s  TO s_bmn[l_sl].ima02s
      DISPLAY g_bmn[l_ac].ima021s TO s_bmn[l_sl].ima021s
      DISPLAY g_bmn[l_ac].bmn04   TO s_bmn[l_sl].bmn04
  END IF
END FUNCTION
FUNCTION i108_bmn01()
  DEFINE l_bmq02  LIKE bmq_file.bmq02,
         l_bmq021 LIKE bmq_file.bmq021
     SELECT bmq02,bmq021
       INTO l_bmq02,l_bmq021
       FROM bmq_file
      WHERE bmq01 =g_bmo.bmo01
    DISPLAY l_bmq02  TO FORMONLY.bmq02
    DISPLAY l_bmq021 TO FORMONLY.bmq021
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001,002> #
