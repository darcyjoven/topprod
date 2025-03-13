# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgi600.4gl
# Descriptions...: 請採購預算資料追加記錄
# Date & Author..: 02/10/02 By Julius
# Modify.........: No.FUN-4C0007 04/12/01 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0067 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530244 05/03/24 By Smapmin "確認"會出現英文.
#                                                     確認後應該有圖示畫面上.
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/18 By jamie 1.FUNCTION i600()_q 一開始應清空g_bgu.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 g_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/19 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740029 07/04/11 By johnray 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7A0109 07/10/30 By lumxa _u()舊值備份時缺少bgu03這個字段
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-9B0010 09/11/02 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-B40004 11/04/14 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bgu	RECORD	LIKE bgu_file.*,
    g_bgu_t	RECORD	LIKE bgu_file.*,
    g_bgu_o	RECORD	LIKE bgu_file.*,
    g_bgu01_t		LIKE bgu_file.bgu01,
    g_bgu02_t		LIKE bgu_file.bgu02,
    g_bgu03_t		LIKE bgu_file.bgu03,    #TQC-7A0109
    g_wc,g_sql  string,  #No.FUN-580092 HCN
    used_amt    LIKE type_file.num20_6,      #NO.FUN-680061 DEC(20,6)
    g_bgq07     LIKE bgq_file.bgq07,         #NO.FUN-680061 DEC(20,6) 
    g_bgq08     LIKE bgq_file.bgq08,         #NO.FUN-680061 DEC(20,6)
    g_tot       LIKE type_file.num20_6       #NO.FUN-680061 DEC(20,6)
DEFINE g_cmd        LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(100)
DEFINE g_buf        LIKE type_file.chr50     #No.FUN-680061 VARCHAR(40)
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done   STRING
DEFINE   g_bookno1    LIKE aza_file.aza81   #No.FUN-730033
DEFINE   g_bookno2    LIKE aza_file.aza82   #No.FUN-730033
DEFINE   g_flag       LIKE type_file.chr1   #No.FUN-730033
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680061 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680061 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680061 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE   g_jump         LIKE type_file.num10    #查詢指定的筆數      #No.FUN-680061 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5     #是否開啟指定筆視窗  #No.FUN-680061 SMALLINT #No.FUN-6A0057 g_no_ask 
DEFINE   l_sql          STRING                  #No.FUN-770033
DEFINE   l_table        STRING                  #No.FUN-770033
DEFINE   g_str          STRING                  #No.FUN-770033
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-770033--start--
   LET g_sql= "bgu01.bgu_file.bgu01,",
              "bgu02.bgu_file.bgu02,",
              "bgu03.bgu_file.bgu03,",
              "bgu032.bgu_file.bgu032,",
              "l_aag02.aag_file.aag02,",
              "bgu033.bgu_file.bgu033,",
              "l_gem02.gem_file.gem02,",
              "bgu034.bgu_file.bgu034,",
              "bgu035.bgu_file.bgu035,",
              "bgu04.bgu_file.bgu04,",
              "l_bgq07.bgq_file.bgq07,",
              "l_bgq08.bgq_file.bgq08,",
              "l_tot.bgq_file.bgq07,",
              "bguconf.bgu_file.bguconf"
   LET l_table= cl_prt_temptable('abgi600',g_sql) CLIPPED
   IF l_table= -1 THEN EXIT PROGRAM  END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep',status,-1) EXIT PROGRAM
   END IF  
#No.FUN-770033--end--
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
    INITIALIZE g_bgu.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bgu_file WHERE bgu01 = ? AND bgu02 = ? AND bgu03 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
 
    OPEN WINDOW i600_w WITH FORM "abg/42f/abgi600"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL i600_menu()
 
    CLOSE WINDOW i600_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
END MAIN
 
FUNCTION i600_curs()
    LET g_wc = ""
    CLEAR FORM
    INITIALIZE g_bgu.* TO NULL     #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        bgu01, bgu03, bgu033, bgu034, bgu035, bgu032, bgu04,  #No.FUN-730033
        bguuser, bgugrup, bgumodu, bgudate, bguconf, bguacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
           IF INFIELD(bgu032) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_bgu.bgu032
              LET g_qryparam.where = " aag03 IN ('2','4')"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bgu032
              NEXT FIELD bgu032
           END IF
           IF INFIELD(bgu033) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_gem"
              LET g_qryparam.default1 = g_bgu.bgu033
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bgu033
              NEXT FIELD bgu033
           END IF
 
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
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc CLIPPED," AND bguuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc CLIPPED," AND bgugrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc CLIPPED," AND bgugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bguuser', 'bgugrup')
    #End:FUN-980030
 
    LET g_sql=" SELECT bgu01,bgu02,bgu03 FROM bgu_file ", # 組合出 SQL 指令  #No.TQC-9B0010
        " WHERE ",g_wc CLIPPED, " ORDER BY bgu01,bgu02,bgu03 "               #No.TQC-9B0010
    PREPARE i600_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i600_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i600_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM bgu_file WHERE ",g_wc CLIPPED
    PREPARE i600_precount FROM g_sql
    DECLARE i600_count CURSOR FOR i600_precount
END FUNCTION
 
FUNCTION i600_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i600_a()
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i600_r()
            END IF
        ON ACTION output
            LET g_action_choice="output"
             IF cl_chk_act_auth()
                THEN CALL i600_out()
             END IF
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i600_y()
                CALL cl_set_field_pic(g_bgu.bguconf,"","","","",g_bgu.bguacti) #MOD-530244
            END IF
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i600_z()
                CALL cl_set_field_pic(g_bgu.bguconf,"","","","",g_bgu.bguacti) #MOD-530244
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i600_q()
            END IF
        ON ACTION next
           CALL i600_fetch('N')
        ON ACTION previous
            CALL i600_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i600_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i600_x()
            END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
           CALL i600_fetch('/')
        ON ACTION first
           CALL i600_fetch('F')
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0003-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_bgu.bgu01 IS NOT NULL THEN            
                  LET g_doc.column1 = "bgu01"               
                  LET g_doc.column2 = "bgu02"               
                  LET g_doc.value1 = g_bgu.bgu01            
                  LET g_doc.value2 = g_bgu.bgu02           
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0003-------add--------end----
 
            LET g_action_choice = "exit"
          CONTINUE MENU
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i600_cs
END FUNCTION
 
 
FUNCTION i600_a()
    MESSAGE ""
    IF s_shut(0) THEN
	RETURN
    END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bgu.* LIKE bgu_file.*
    LET g_bgu01_t = NULL
    LET g_bgu02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
	LET g_bgu.bgu01   = g_today
	LET g_bgu.bgu04   = 0
	LET g_bgu.bgu034  = YEAR(g_today)
	LET g_bgu.bgu035  = MONTH(g_today)
	LET g_bgu.bguconf = 'N'
        LET g_bgu.bguuser = g_user
        LET g_bgu.bguoriu = g_user #FUN-980030
        LET g_bgu.bguorig = g_grup #FUN-980030
        LET g_bgu.bgugrup = g_grup               #使用者所屬群
        LET g_bgu.bgudate = g_today
        LET g_bgu.bguacti = 'Y'
        CALL i600_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_bgu.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_bgu.bgu01) THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO bgu_file VALUES(g_bgu.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("ins","bgu_file",g_bgu.bgu01,g_bgu.bgu02,SQLCA.sqlcode,"","",1) #FUN-660105
            CONTINUE WHILE
        ELSE
            LET g_bgu_t.* = g_bgu.*                # 保存上筆資料
            SELECT bgu01,bgu02,bgu03 INTO g_bgu.bgu01,g_bgu.bgu02,g_bgu.bgu03 FROM bgu_file
                WHERE bgu01 = g_bgu.bgu01
                  AND bgu02 = g_bgu.bgu02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i600_i(p_cmd)
    DEFINE
        p_cmd       LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
        l_n         LIKE type_file.num5,    #No.FUN-680061 SMALLINT 
        l_bud       LIKE type_file.num5,    #NO.FUN-680061 SMALLINT
        over_amt    LIKE type_file.num20_6, #NO.FUN-680061 DEC(20,6) 
        bdate,edate LIKE type_file.dat      #NO.FUN-680061 DATE
    DEFINE  l_aag05     LIKE aag_file.aag05                  #No.FUN-B40004
 
    INPUT BY NAME g_bgu.bguoriu,g_bgu.bguorig,
            g_bgu.bgu01, g_bgu.bgu03,
	    g_bgu.bgu033, g_bgu.bgu034, g_bgu.bgu035,g_bgu.bgu032,   #No.FUN-730033
	    g_bgu.bgu04,
            g_bgu.bguuser, g_bgu.bgugrup, g_bgu.bgumodu,
            g_bgu.bgudate, g_bgu.bguconf,g_bgu.bguacti
            WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i600_set_entry(p_cmd)
           CALL i600_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD bgu01
            IF NOT cl_null(g_bgu.bgu01) THEN
               IF cl_null(g_bgu.bgu02)
                  OR g_bgu.bgu02 = 0 THEN
                  SELECT max(bgu02)+1
	            INTO g_bgu.bgu02
                    FROM bgu_file
       	           WHERE bgu01 = g_bgu.bgu01
                   IF cl_null(g_bgu.bgu02)
                      OR g_bgu.bgu02 = 0 THEN
                      LET g_bgu.bgu02 = 1
                   END IF
                   DISPLAY BY NAME g_bgu.bgu02 #ATTRIBUTE(YELLOW)
                END IF
                CALL i600_set_no_entry(p_cmd)
            END IF
 
        AFTER FIELD bgu03
            IF cl_null(g_bgu.bgu03) THEN
               LET g_bgu.bgu03 = ' '
            END IF
            CALL i600_set_no_entry(p_cmd)
 
        AFTER FIELD bgu032
            IF NOT cl_null(g_bgu.bgu032) THEN
#               CALL i600_aag02('a',g_bgu.bgu032,g_bookno1)  #No.FUN-730033
               CALL i600_aag02('a',g_bgu.bgu032,g_aza.aza81) #No.FUN-740029
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bgu.bgu032,g_errno,0)
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_bgu.bgu032  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2','4') AND aagacti='Y' AND aag01 LIKE '",g_bgu.bgu032 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_bgu.bgu032 
                  DISPLAY BY NAME g_bgu.bgu032 
                  #FUN-B10049--end                        
                  NEXT FIELD bgu032
               END IF
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_bgu.bgu032
                  AND aag00 = g_aza.aza81
               IF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_bgu.bgu032,g_bgu.bgu033,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bgu.bgu032,g_errno,0)
                  DISPLAY BY NAME g_bgu.bgu032
                  NEXT FIELD bgu032
               END IF
               #No.FUN-B40004  --End
            END IF
 
	AFTER FIELD bgu033
           IF NOT cl_null(g_bgu.bgu033) THEN
              CALL i600_gem02('a',g_bgu.bgu033)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_bgu.bgu033,g_errno,0)              
                 NEXT FIELD bgu033
              END IF
           END IF
 
	AFTER FIELD bgu034
           IF NOT cl_null(g_bgu.bgu034) THEN
	      IF g_bgu.bgu034 < 1 THEN
	         NEXT FIELD bgu034
	      END IF
              #No.FUN-730033  --Begin
              CALL s_get_bookno(g_bgu.bgu034) RETURNING g_flag,g_bookno1,g_bookno2
              IF g_flag =  '1' THEN  #抓不到帳別
                 CALL cl_err(g_bgu.bgu034,'aoo-081',1)
                 NEXT FIELD bgu034
              END IF
              #No.FUN-730033  --End  
           END IF
 
	AFTER FIELD bgu035
	    IF NOT cl_null(g_bgu.bgu035) THEN
	       IF g_bgu.bgu035 > 12
	          OR g_bgu.bgu035 < 1 THEN
	  	  NEXT FIELD bgu035
	       END IF
               CALL i600_amt()
            END IF
 
	AFTER FIELD bgu04
           IF NOT cl_null(g_bgu.bgu04) THEN
              IF g_bgu.bgu04 < 1 THEN
		 NEXT FIELD bgu04
	      END IF
           END IF
 
        AFTER INPUT
           LET g_bgu.bguuser = s_get_data_owner("bgu_file") #FUN-C10039
           LET g_bgu.bgugrup = s_get_data_group("bgu_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLP
           IF INFIELD(bgu032) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.default1 = g_bgu.bgu032
              LET g_qryparam.where = " aag03 IN ('2','4')"
#              LET g_qryparam.arg1 = g_bookno1  #No.FUN-730033
              LET g_qryparam.arg1 = g_aza.aza81 #No.FUN-740029
              CALL cl_create_qry() RETURNING g_bgu.bgu032
#              CALL FGL_DIALOG_SETBUFFER( g_bgu.bgu032 )
              DISPLAY BY NAME g_bgu.bgu032
#   	            CALL i600_aag02('d',g_bgu.bgu032,g_bookno1)  #No.FUN-730033
                   CALL i600_aag02('d',g_bgu.bgu032,g_aza.aza81) #No.FUN-740029
              NEXT FIELD bgu032
           END IF
           IF INFIELD(bgu033) THEN
 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.default1 = g_bgu.bgu033
 
              CALL cl_create_qry() RETURNING g_bgu.bgu033
 
#              CALL FGL_DIALOG_SETBUFFER( g_bgu.bgu033 )
 
              DISPLAY BY NAME g_bgu.bgu033
                    CALL i600_gem02('d',g_bgu.bgu033)
              NEXT FIELD bgu033
 
           END IF
 
        #MOD-650015 --star
        #ON ACTION CONTROLO
        #    IF INFIELD(bgu01) THEN
        #        LET g_bgu.* = g_bgu_t.*
        #        CALL i600_show()
        #        NEXT FIELD bgu01
        #    END IF
        #MOD-650015 --end
 
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
 
 
    END INPUT
END FUNCTION
 
FUNCTION i600_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bgu.* TO NULL                #No.FUN-6A0003
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i600_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i600_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0)
        INITIALIZE g_bgu.* TO NULL
    ELSE
        OPEN i600_count
        FETCH i600_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i600_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
 
END FUNCTION
 
FUNCTION i600_fetch(p_flbgu)
    DEFINE
        p_flbgu          LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
    CASE p_flbgu
        WHEN 'N' FETCH NEXT     i600_cs INTO	
						g_bgu.bgu01,
						g_bgu.bgu02,  #No.TQC-9B0010
						g_bgu.bgu03   #No.TQC-9B0010
        WHEN 'P' FETCH PREVIOUS i600_cs INTO	
						g_bgu.bgu01,
						g_bgu.bgu02,  #No.TQC-9B0010
						g_bgu.bgu03   #No.TQC-9B0010
        WHEN 'F' FETCH FIRST    i600_cs INTO	
						g_bgu.bgu01,
						g_bgu.bgu02,  #No.TQC-9B0010
						g_bgu.bgu03   #No.TQC-9B0010
        WHEN 'L' FETCH LAST     i600_cs INTO	
						g_bgu.bgu01,
						g_bgu.bgu02,  #No.TQC-9B0010
						g_bgu.bgu03   #No.TQC-9B0010
        WHEN '/'
            IF (NOT g_no_ask) THEN            #No.FUN-6A0057 g_no_ask 
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG=0
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
 
            FETCH ABSOLUTE g_jump i600_cs INTO	
						g_bgu.bgu01,
						g_bgu.bgu02,  #No.TQC-9B0010
						g_bgu.bgu03   #No.TQC-9B0010
            LET g_no_ask = FALSE             #No.FUN-6A0057 g_no_ask 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0)
        INITIALIZE g_bgu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbgu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bgu.* FROM bgu_file            # 重讀DB,因TEMP有不被更新特性
       WHERE bgu01 = g_bgu.bgu01 AND bgu02 = g_bgu.bgu02 AND bgu03 = g_bgu.bgu03
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0) #FUN-660105
        CALL cl_err3("sel","bgu_file",g_bgu.bgu01,g_bgu.bgu02,SQLCA.sqlcode,"","",1) #FUN-660105
    ELSE
        #No.FUN-730033  --Begin
        CALL s_get_bookno(g_bgu.bgu034) RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag =  '1' THEN  #抓不到帳別
           CALL cl_err(g_bgu.bgu034,'aoo-081',1)
        END IF
        #No.FUN-730033  --End  
        LET g_data_owner = g_bgu.bguuser   #FUN-4C0067
        LET g_data_group = g_bgu.bgugrup   #FUN-4C0067
        CALL i600_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i600_show()
    LET g_bgu_t.* = g_bgu.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_bgu.*
    DISPLAY BY NAME g_bgu.bgu01,g_bgu.bgu02,g_bgu.bgu03,g_bgu.bgu033,g_bgu.bgu034,
                    g_bgu.bgu035,g_bgu.bgu032,g_bgu.bgu04,g_bgu.bguuser,g_bgu.bgugrup,
                    g_bgu.bguconf,g_bgu.bguoriu,g_bgu.bguorig,g_bgu.bgumodu,g_bgu.bgudate,
                    g_bgu.bguacti 
    #No.FUN-9A0024--end
     CALL cl_set_field_pic(g_bgu.bguconf,"","","","",g_bgu.bguacti) #MOD-530244
#    CALL i600_aag02('d',g_bgu.bgu032,g_bookno1)  #No.FUN-730033
    CALL i600_aag02('d',g_bgu.bgu032,g_aza.aza81) #No.FUN-740029
    CALL i600_gem02('d',g_bgu.bgu033)
    CALL i600_amt()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i600_aag02(p_cmd,l_aag01,p_bookno)  #No.FUN-730033
    DEFINE p_cmd     LIKE type_file.chr1,      #No.FUN-680061 VARCHAR(01)
           p_bookno  LIKE aag_file.aag00,    #No.FUN-730033
           l_aag01   LIKE aag_file.aag01,
           l_aag02   LIKE aag_file.aag02,
           l_aag07   LIKE aag_file.aag07,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_errno = ' '
    IF l_aag01 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aag07,aagacti
          INTO l_aag02,l_aag07,l_aagacti
          FROM aag_file
	 WHERE aag01 = l_aag01
           AND aag00 = p_bookno  #No.FUN-730033
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_aag02 = NULL
        END IF
        IF l_aag07 = '1' THEN #為統制科目者不可做預算
	    LET g_errno = 'agl-131 '
        END IF
        IF l_aagacti='N' THEN
	    LET g_errno = '9028'
        END IF
    END IF
    IF p_cmd = 'd'
    OR cl_null(g_errno) THEN
        DISPLAY l_aag02 TO FORMONLY.aag02 #ATTRIBUTE(MAGENTA)
    END IF
END FUNCTION
 
FUNCTION i600_gem02(p_cmd,l_gem01)
    DEFINE p_cmd	LIKE type_file.chr1,      #No.FUN-680061 VARCHAR(01)
           l_gem01 LIKE gem_file.gem01,
           l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
      INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = l_gem01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-003'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF l_gem01 = 'ALL' THEN
       LET g_errno = ' ' LET l_gem02 = 'ALL'
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY l_gem02 TO FORMONLY.gem02 #ATTRIBUTE(MAGENTA)
    END IF
END FUNCTION
 
FUNCTION i600_amt()
    DEFINE
	    l_bgq01	LIKE bgq_file.bgq01,
	    l_bgq02     LIKE bgq_file.bgq02,
	    l_bgq03     LIKE bgq_file.bgq03,
	    l_bgq04     LIKE bgq_file.bgq04,
	    l_bgq05     LIKE bgq_file.bgq05,
	    l_bgq07     LIKE bgq_file.bgq07,
	    l_bgq08     LIKE bgq_file.bgq08,
	    l_tot       LIKE bgq_file.bgq07  #NO.FUN-680061 DEC(20,6)
 
     SELECT bgq07,bgq08 INTO l_bgq07,l_bgq08
       FROM bgq_file
      WHERE bgq01 = g_bgu.bgu03
        AND bgq02 = g_bgu.bgu034
        AND bgq03 = g_bgu.bgu035
        AND bgq04 = g_bgu.bgu032
        AND bgq05 = g_bgu.bgu033
 
    LET l_tot = l_bgq07 + l_bgq08
 
    DISPLAY l_tot   TO FORMONLY.tot
    DISPLAY l_bgq07 TO FORMONLY.bgq07 #ATTRIBUTE(MAGENTA)
    DISPLAY l_bgq08 TO FORMONLY.bgq08 #ATTRIBUTE(MAGENTA)
END FUNCTION
 
FUNCTION i600_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bgu.bgu01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT *
      INTO g_bgu.*
      FROM bgu_file
     WHERE bgu01=g_bgu.bgu01
       AND bgu02=g_bgu.bgu02
    IF g_bgu.bguacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_bgu.bguconf = 'Y' THEN
	CALL cl_err('',9023,0)
	RETURN
    END IF
 
   MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bgu01_t = g_bgu.bgu01
    LET g_bgu02_t = g_bgu.bgu02
    LET g_bgu03_t = g_bgu.bgu03      #TQC-7A0109
    BEGIN WORK
    OPEN i600_cl USING g_bgu.bgu01,g_bgu.bgu02,g_bgu.bgu03
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_bgu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0)
        CLOSE i600_cl
        ROLLBACK WORK
        RETURN
    END IF
    LET g_bgu.bgumodu=g_user                     #修改者
    LET g_bgu.bgudate = g_today                  #修改日期
    CALL i600_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_bgu_t.*=g_bgu.*
        CALL i600_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bgu.*=g_bgu_t.*
            CALL i600_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE bgu_file
	   SET bgu_file.* = g_bgu.*    # 更新DB
         WHERE bgu01 = g_bgu01_t AND bgu02 = g_bgu02_t AND bgu03 = g_bgu03_t        # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("upd","bgu_file",g_bgu01_t,g_bgu02_t,SQLCA.sqlcode,"","",1) #FUN-660105
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_bgu.bgu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #--00/05/15 modify
    IF g_bgu.bguconf = 'Y' THEN
	RETURN
    END IF
    BEGIN WORK
    OPEN i600_cl USING g_bgu.bgu01,g_bgu.bgu02,g_bgu.bgu03
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_bgu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF
    CALL i600_show()
    IF cl_exp(0,0,g_bgu.bguacti) THEN
#        LET g_chr=g_bgu.bguacti
        IF g_bgu.bguacti='Y' THEN
            LET g_bgu.bguacti='N'
        ELSE
            LET g_bgu.bguacti='Y'
        END IF
        UPDATE bgu_file
           SET bguacti=g_bgu.bguacti
         WHERE bgu01 = g_bgu.bgu01 AND bgu02 = g_bgu.bgu02 AND bgu03 = g_bgu.bgu03
        IF STATUS=100 THEN
#           CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("upd","bgu_file",g_bgu.bgu01,g_bgu.bgu02,SQLCA.sqlcode,"","",1) #FUN-660105
#           LET g_bgu.bguacti=g_chr
        END IF
        DISPLAY BY NAME g_bgu.bguacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_r()
    IF s_shut(0) THEN
	RETURN
    END IF
    IF cl_null(g_bgu.bgu01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_bgu.* FROM bgu_file
     WHERE bgu01=g_bgu.bgu01
       AND bgu02=g_bgu.bgu02
    IF g_bgu.bguacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_bgu.bguconf = 'Y' THEN
	CALL cl_err('',9023,0)
	RETURN
    END IF
    BEGIN WORK
    OPEN i600_cl USING g_bgu.bgu01,g_bgu.bgu02,g_bgu.bgu03
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_bgu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bgu.bgu01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF
    CALL i600_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bgu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bgu02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bgu.bgu01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bgu.bgu02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bgu_file WHERE bgu01 = g_bgu.bgu01
                              AND bgu02 = g_bgu.bgu02
       CLEAR FORM
       OPEN i600_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i600_cs
          CLOSE i600_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--

       FETCH i600_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i600_cs
          CLOSE i600_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i600_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i600_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE          #No.FUN-6A0057 g_no_ask 
          CALL i600_fetch('/')
       END IF
    END IF
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_y()
    DEFINE
        l_bgq07	  LIKE bgq_file.bgq07,
        l_bgq08   LIKE bgq_file.bgq08,
        bdate	  LIKE type_file.dat,    #NO.FUN-680061 DATE
        edate	  LIKE type_file.dat     #NO.FUN-680061 DATE
 
    IF s_shut(0) THEN
	RETURN
    END IF
    IF cl_null(g_bgu.bgu01) THEN
	CALL cl_err('',-400,0)
	RETURN
    END IF
    IF g_bgu.bguacti = 'N' THEN
	CALL cl_err('',9027,0)
	RETURN
    END IF
    IF g_bgu.bguconf = 'Y' THEN
	CALL cl_err('',9023,0)
	RETURN
    END IF
 #MOD-530244
    IF cl_confirm('axm-108') THEN
       LET g_success='Y'
    ELSE
       LET g_success='N'
    END IF
{
    IF NOT cl_conf(18,10,'axm-108') THEN
	RETURN
    END IF
    BEGIN WORK
    LET g_success = 'Y'
}
 #END MOD-530244
    UPDATE bgq_file
       SET bgq08 = bgq08+g_bgu.bgu04
     WHERE bgq01 = g_bgu.bgu03
       AND bgq02 = g_bgu.bgu034
       AND bgq03 = g_bgu.bgu035
       AND bgq04 = g_bgu.bgu032
       AND bgq05 = g_bgu.bgu033
    IF STATUS=100 THEN
	LET g_success = 'N'
    END IF
 
    UPDATE bgu_file
       SET bguconf='Y'
     WHERE bgu01 = g_bgu.bgu01
       AND bgu02 = g_bgu.bgu02
 
    IF STATUS=100 THEN
	LET g_success='N'
    END IF
 
    IF g_success = 'Y' THEN
	LET g_bgu.bguconf='Y'
	CALL cl_cmmsg(1)
	COMMIT WORK
	DISPLAY BY NAME g_bgu.bguconf
	CALL i600_showconf()
    ELSE
	CALL cl_rbmsg(1)
	ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION i600_z()
    DEFINE
        l_bgq07	    LIKE bgq_file.bgq07,
        l_bgq08     LIKE bgq_file.bgq08,
        over_amt    LIKE type_file.num20_6,#NO.FUN-680061 DEC(20,6)    
        last_amt    LIKE type_file.num20_6,#NO.FUN-680061 DEC(20,6)   
        bdate	    LIKE type_file.dat,    #NO.FUN-680061 DATE
        edate	    LIKE type_file.dat     #NO.FUN-680061 DATE
 
    IF s_shut(0) THEN
	RETURN
    END IF
    IF cl_null(g_bgu.bgu01) THEN
	CALL cl_err('',-400,0)
	RETURN
    END IF
    IF g_bgu.bguacti = 'N' THEN
	CALL cl_err('',9027,0)
	RETURN
    END IF
    IF g_bgu.bguconf = 'N' THEN
	RETURN
    END IF
 #MOD-530244
    IF cl_confirm('axm-109') THEN
       LET g_success='Y'
    ELSE
       LET g_success='N'
    END IF
{
    IF NOT cl_conf(18,10,'axm-109') THEN
	RETURN
    END IF
    BEGIN WORK
    LET g_success = 'Y'
}
 #END MOD-530244
    UPDATE bgq_file
       SET bgq08 = bgq08-g_bgu.bgu04
     WHERE bgq01 = g_bgu.bgu03
       AND bgq02 = g_bgu.bgu034
       AND bgq03 = g_bgu.bgu035
       AND bgq04 = g_bgu.bgu032
       AND bgq05 = g_bgu.bgu033
    IF STATUS=100 THEN
	LET g_success='N'
    END IF
 
    UPDATE bgu_file
       SET bguconf='N'
     WHERE bgu01=g_bgu.bgu01
       AND bgu02=g_bgu.bgu02
    IF STATUS=100 THEN
        LET g_success='N'
    END IF
 
    IF g_success = 'Y' THEN
	LET g_bgu.bguconf='N'
	CALL cl_cmmsg(1)
	COMMIT WORK
	DISPLAY BY NAME g_bgu.bguconf #ATTRIBUTE(YELLOW)  #TQC-8C0076
	CALL i600_showconf()
    ELSE
	CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION i600_showconf()
    DEFINE
	l_bgq07    LIKE bgq_file.bgq07,
        l_bgq08    LIKE bgq_file.bgq08,
	l_tot      LIKE bgq_file.bgq07  #NO.FUN-680061 DEC(20,6) 
 
    SELECT bgq07,bgq08
      INTO l_bgq07,l_bgq08
      FROM bgq_file
     WHERE bgq01 = g_bgu.bgu03
       AND bgq02 = g_bgu.bgu034
       AND bgq03 = g_bgu.bgu035
       AND bgq04 = g_bgu.bgu032
       AND bgq05 = g_bgu.bgu033
 
    LET l_tot = l_bgq07 + l_bgq08
 
    DISPLAY l_bgq07 TO FORMONLY.bgq07 #ATTRIBUTE(MAGENTA)
    DISPLAY l_bgq08 TO FORMONLY.bgq08 #ATTRIBUTE(MAGENTA)
    DISPLAY l_tot TO FORMONLY.tot #ATTRIBUTE(MAGENTA)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION i600_out()
    DEFINE
    sr  RECORD LIKE bgu_file.*,
        l_i    LIKE type_file.num5,     #No.FUN-680061 SMALLINT
        l_name LIKE type_file.chr20,    # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05 LIKE type_file.chr1000   #NO.FUN-680061 VARCHAR(40)  
#No.FUN-770033--start--
    DEFINE 
        l_bgq07       LIKE bgq_file.bgq07,                                                                                        
        l_bgq08       LIKE bgq_file.bgq08,                                                                                         
        l_tot           LIKE bgq_file.bgq07,
        l_aag02         LIKE aag_file.aag02,                                                                                        
        l_gem02         LIKE gem_file.gem02
#No.FUN-770033--end--
    IF cl_null(g_wc) THEN
	CALL cl_err('', 9057, 0)
	RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abgi600') RETURNING l_name         #No.FUN-770033
    CALL cl_del_data(l_table)                          #No.FUN-770033
    SELECT zo02
      INTO g_company
      FROM zo_file
     WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM bgu_file ",         # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i600_p1 FROM g_sql                   # RUNTIME 編譯
    DECLARE i600_co                              # CURSOR
        CURSOR FOR i600_p1
 
#   START REPORT i600_rep TO l_name                     #No.FUN-770033
 
    FOREACH i600_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#No.FUN-770033--start--
        INITIALIZE l_bgq07,l_bgq08 TO NULL                                                                                               
        SELECT bgq07,bgq08                                                                                                      
          INTO l_bgq07,l_bgq08                                                                                          
          FROM bgq_file                                                                                                         
          WHERE bgq01 = sr.bgu03                                                                                                 
           AND bgq02 = sr.bgu034                                                                                                
           AND bgq03 = sr.bgu035                                                                                                
           AND bgq04 = sr.bgu032                                                                                                
           AND bgq05 = sr.bgu033   
        LET l_tot = l_bgq07 + l_bgq08
        CALL s_get_bookno(sr.bgu034) RETURNING g_flag,g_bookno1,g_bookno2
        SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.bgu032
                                                  AND aag00 = g_aza.aza81
        SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.bgu033 
        EXECUTE insert_prep USING            
                sr.bgu01,sr.bgu02,sr.bgu03,sr.bgu032,l_aag02,sr.bgu033,l_gem02,
                sr.bgu034,sr.bgu035,sr.bgu04,l_bgq07,l_bgq08,l_tot,sr.bguconf
#        OUTPUT TO REPORT i600_rep(sr.*)           
    END FOREACH
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                    
     IF g_zz05 = 'Y' THEN  
        CALL cl_wcchp(g_wc,'bgu01, bgu03, bgu033, bgu034, bgu035, bgu032, bgu04, 
                      bguuser, bgugrup, bgumodu, bgudate, bguconf, bguacti')                                                                            
        RETURNING g_wc        
        LET g_str = g_wc   
     END IF 
    LET g_str=g_str,";",g_azi04                                        
 
#    FINISH REPORT i600_rep                            
 
    CLOSE i600_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)                 
    CALL cl_prt_cs3('abgi600','abgi600',l_sql,g_str)    
#No.FUN-770033--end--
END FUNCTION
#No.FUN-770033--start--
{REPORT i600_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
	l_i		LIKE type_file.num5,     #No.FUN-680061 SMALLINT
        l_aag02         LIKE aag_file.aag02,
        l_gem02         LIKE gem_file.gem02,
	sr              RECORD	LIKE bgu_file.*,
	l_bgq		RECORD
	    bgq07	LIKE bgq_file.bgq07,
	    bgq08	LIKE bgq_file.bgq08
	    END RECORD,
	l_tot		LIKE bgq_file.bgq07
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bgu01, sr.bgu02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                  g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
	    INITIALIZE l_bgq TO NULL
            SELECT bgq07,bgq08
	      INTO l_bgq.bgq07,l_bgq.bgq08
              FROM bgq_file
             WHERE bgq01 = sr.bgu03
	       AND bgq02 = sr.bgu034
               AND bgq03 = sr.bgu035
               AND bgq04 = sr.bgu032
               AND bgq05 = sr.bgu033
	    LET l_tot = l_bgq.bgq07 + l_bgq.bgq08
            #No.FUN-730033  --Begin
            CALL s_get_bookno(sr.bgu034) RETURNING g_flag,g_bookno1,g_bookno2
            #No.FUN-730033  --End  
            SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.bgu032
#                                                      AND aag00 = g_bookno1  #No.FUN-730033
                                                      AND aag00 = g_aza.aza81 #No.FUN-740029
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.bgu033
	    PRINT   COLUMN  g_c[31], sr.bgu01 CLIPPED,
		    COLUMN  g_c[32], sr.bgu02 USING '####',
		    COLUMN  g_c[33], sr.bgu03,
		    COLUMN  g_c[34], sr.bgu032[1,11],
                    COLUMN  g_c[35], l_aag02,
		    COLUMN  g_c[36], sr.bgu033,
                    COLUMN  g_c[37], l_gem02,
		    COLUMN  g_c[38], sr.bgu034 USING '####',
		    COLUMN  g_c[39], sr.bgu035 USING '##',
		    COLUMN  g_c[40], cl_numfor(sr.bgu04,40,g_azi04),
		    COLUMN  g_c[41], cl_numfor(l_bgq.bgq07,40,g_azi04),
		    COLUMN  g_c[42], cl_numfor(l_bgq.bgq08,40,g_azi04),
		    COLUMN  g_c[44], sr.bguconf
 
        ON LAST ROW
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
#No.FUN-770033--end--
 
FUNCTION i600_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("bgu01,bgu03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i600_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'u' AND g_chkey MATCHES'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bgu01,bgu03",FALSE)
   END IF
   IF INFIELD(bgu01) THEN
      CALL cl_set_comp_entry("bgu01",FALSE)
   END IF
   IF INFIELD(bgu03) THEN
      CALL cl_set_comp_entry("bgu03",FALSE)
   END IF
 
END FUNCTION

