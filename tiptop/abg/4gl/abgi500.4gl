# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi500.4gl
# Descriptions...: 預算編制基礎說明維護作業
# Date & Author..: Julius 02/10/11
# Modify.........: No:8836 03/12/05 ching 顯示 bgw11(科目)
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0067 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-570108 05/07/13 By Trisy key值可更改
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
#Modify..........: NO.MOD-590329 05/10/03 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.TQC-5C0037 05/12/07 By kevin 欄位沒對齊
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/19 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740029 07/04/10 By johnray 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/17 By lala   報表轉為使用p_query
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-970271 09/07/27 By Carrier 金額非負處理 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-B40004 11/04/06 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bgw_hd        RECORD 		 #單頭變數
	bgw01	    LIKE bgw_file.bgw01,
	bgw02	    LIKE bgw_file.bgw02,
	bgw03	    LIKE bgw_file.bgw03,
	bgw04	    LIKE bgw_file.bgw04,
	bgw05	    LIKE bgw_file.bgw05,
	bgw07	    LIKE bgw_file.bgw07,
	bgw11	    LIKE bgw_file.bgw11,
	bgw08	    LIKE bgw_file.bgw08,
	bgw12	    LIKE bgw_file.bgw12,
        bgwuser     LIKE bgw_file.bgwuser,
        bgwgrup     LIKE bgw_file.bgwgrup,
        bgwmodu     LIKE bgw_file.bgwmodu,
        bgwdate     LIKE bgw_file.bgwdate
                    END RECORD,
    g_bgw_hd_t      RECORD			 #備用單頭變數
	bgw01	    LIKE bgw_file.bgw01,
	bgw02	    LIKE bgw_file.bgw02,
	bgw03	    LIKE bgw_file.bgw03,
	bgw04	    LIKE bgw_file.bgw04,
	bgw05	    LIKE bgw_file.bgw05,
	bgw07	    LIKE bgw_file.bgw07,
	bgw11	    LIKE bgw_file.bgw11,
	bgw08	    LIKE bgw_file.bgw08,
	bgw12	    LIKE bgw_file.bgw12,
        bgwuser     LIKE bgw_file.bgwuser,
        bgwgrup     LIKE bgw_file.bgwgrup,
        bgwmodu     LIKE bgw_file.bgwmodu,
        bgwdate     LIKE bgw_file.bgwdate
	END RECORD,
    g_bgw           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        bgw06       LIKE bgw_file.bgw06,         #行序
        bgw09       LIKE bgw_file.bgw09,
        bgw10       LIKE bgw_file.bgw10
                    END RECORD,
    g_bgw_t         RECORD                       #程式變數 (舊值)
        bgw06       LIKE bgw_file.bgw06,         #行序
        bgw09       LIKE bgw_file.bgw09,
        bgw10       LIKE bgw_file.bgw10
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,         #單身筆數 #No.FUN-680061 SMALLINT
    g_argv1         LIKE bgw_file.bgw01,
    g_ss            LIKE type_file.chr1,         #No.FUN-680061 VARCHAR(01)
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5       #No.FUN-680061 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5   #No.FUN-680061 SMALLINT
DEFINE g_bookno1    LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2    LIKE aza_file.aza82   #No.FUN-730033
DEFINE g_flag       LIKE type_file.chr1   #No.FUN-730033
 
DEFINE   g_cnt          LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE   g_i            LIKE type_file.num5       #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03         #No.FUN-680061 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10      #查詢指定的筆數     #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5       #是否開啟指定筆視窗 #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
#主程式開始
 
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0056
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time                            #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
    INITIALIZE g_bgw_hd.* TO NULL                #清除鍵值
    INITIALIZE g_bgw_hd_t.* TO NULL
 
 
    LET p_row = 2 LET p_col = 12
 
    OPEN WINDOW i500_w AT p_row,p_col
         WITH FORM "abg/42f/abgi500"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                         #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    CALL i500_menu()
 
    CLOSE WINDOW i500_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)              #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
 
END MAIN
 
 
 
#QBE 查詢資料
FUNCTION i500_cs()
 
    CLEAR FORM                                   #清除畫面
    CALL g_bgw.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bgw_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc                               #螢幕上取條件
           ON bgw01, bgw04, bgw08,bgw02, bgw03, bgw07, bgw05,bgw12,bgw11,  #No.FUN-730033
     	      bgw06, bgw09, bgw10
         FROM bgw01, bgw04, bgw08,bgw02, bgw03, bgw07, bgw05,bgw12,bgw11,  #No.FUN-730033
     	      s_bgw[1].bgw06,s_bgw[1].bgw09 ,s_bgw[1].bgw10
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(bgw07) #產品名稱
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bgw07
                       NEXT FIELD bgw07
                  WHEN INFIELD(bgw11) #產品名稱
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_aag"
                       LET g_qryparam.where = " aag07 IN ('2','3') ",
                                              " AND aag03 IN ('2')"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bgw11
                       NEXT FIELD bgw11
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
 
 
             IF INT_FLAG THEN RETURN END IF
 
                                                 #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                          #只能使用自己的資料
    #        LET g_wc = g_wc CLIPPED," AND bgwuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                          #只能使用相同群的資料
    #        LET g_wc = g_wc CLIPPED," AND bgwgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc CLIPPED," AND bgwgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bgwuser', 'bgwgrup')
    #End:FUN-980030
 
						 #組SQL 條件
    LET g_sql= "SELECT UNIQUE bgw01, bgw02, bgw03, bgw04,",
	       "              bgw07, bgw11, bgw08, bgw05,bgw12 ",
	       "  FROM bgw_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bgw01,bgw05,bgw04,bgw08,bgw02,bgw03,bgw07,bgw12 "
    PREPARE i500_prepare FROM g_sql      #預備一下
    DECLARE i500_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i500_prepare
 
#   LET g_sql= "SELECT UNIQUE bgw01, bgw02, bgw03, bgw04, ",      #No.TQC-720019
    LET g_sql_tmp= "SELECT UNIQUE bgw01, bgw02, bgw03, bgw04, ",  #No.TQC-720019
	       "	      bgw05, bgw07, bgw11, bgw08,bgw12 ",
               "  FROM bgw_file ",
	       " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i500_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i500_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i500_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i500_precount FROM g_sql
    DECLARE i500_count CURSOR FOR i500_precount
END FUNCTION
 
FUNCTION i500_menu()
DEFINE l_cmd  LIKE type_file.chr1000            #No.FUN-820002 
   WHILE TRUE
      CALL i500_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i500_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i500_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i500_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i500_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i500_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
         IF cl_chk_act_auth()                                                   
               THEN CALL i500_out()                                            
         END IF                                                                 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i500_a()
    IF s_shut(0) THEN                            #檢查權限
	RETURN
    END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_bgw.clear()
    INITIALIZE g_bgw_hd.* TO NULL
    INITIALIZE g_bgw_hd_t.* TO NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bgw_hd.bgwuser = g_user
        LET g_bgw_hd.bgwgrup = g_grup
        LET g_bgw_hd.bgwdate = g_today
        CALL i500_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #使用者不玩了
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
     IF cl_null(g_bgw_hd.bgw02)  OR
        cl_null(g_bgw_hd.bgw03)  OR
        cl_null(g_bgw_hd.bgw04)  OR
        cl_null(g_bgw_hd.bgw07)  OR
        cl_null(g_bgw_hd.bgw11)  OR
        cl_null(g_bgw_hd.bgw08)  OR
        cl_null(g_bgw_hd.bgw05)  OR
        cl_null(g_bgw_hd.bgw12) THEN
        CONTINUE WHILE
     END IF
 
     LET g_rec_b = 0
     CALL g_bgw.clear()
        CALL i500_b()                            #輸入單身
        LET g_bgw_hd_t.* = g_bgw_hd.*            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i500_u()
 
    IF s_shut(0) THEN
	RETURN
    END IF
    IF g_bgw_hd.bgw01 IS NULL THEN
	CALL cl_err('',-400,0)
	RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bgw_hd_t.bgw01 = g_bgw_hd.bgw01
    LET g_bgw_hd_t.bgw02 = g_bgw_hd.bgw02
    LET g_bgw_hd_t.bgw03 = g_bgw_hd.bgw03
    LET g_bgw_hd_t.bgw04 = g_bgw_hd.bgw04
    LET g_bgw_hd_t.bgw07 = g_bgw_hd.bgw07
    LET g_bgw_hd_t.bgw11 = g_bgw_hd.bgw11
    LET g_bgw_hd_t.bgw08 = g_bgw_hd.bgw08
    LET g_bgw_hd_t.bgw05 = g_bgw_hd.bgw05
    LET g_bgw_hd_t.bgw12 = g_bgw_hd.bgw12
    BEGIN WORK
    WHILE TRUE
        CALL i500_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET g_bgw_hd.bgw01 = g_bgw_hd_t.bgw01
            LET g_bgw_hd.bgw02 = g_bgw_hd_t.bgw02
            LET g_bgw_hd.bgw03 = g_bgw_hd_t.bgw03
            LET g_bgw_hd.bgw04 = g_bgw_hd_t.bgw04
            LET g_bgw_hd.bgw07 = g_bgw_hd_t.bgw07
            LET g_bgw_hd.bgw11 = g_bgw_hd_t.bgw11
            LET g_bgw_hd.bgw08 = g_bgw_hd_t.bgw08
            LET g_bgw_hd.bgw05 = g_bgw_hd_t.bgw05
            LET g_bgw_hd.bgw12 = g_bgw_hd_t.bgw12
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bgw_file
	   SET bgw01 = g_bgw_hd.bgw01,
               bgw02 = g_bgw_hd.bgw02,
               bgw03 = g_bgw_hd.bgw03,
               bgw04 = g_bgw_hd.bgw04,
               bgw07 = g_bgw_hd.bgw07,
               bgw11 = g_bgw_hd.bgw11,
               bgw08 = g_bgw_hd.bgw08,
               bgw05 = g_bgw_hd.bgw05,
               bgw12 = g_bgw_hd.bgw12
         WHERE bgw01 = g_bgw_hd_t.bgw01
           AND bgw02 = g_bgw_hd_t.bgw02
           AND bgw03 = g_bgw_hd_t.bgw03
           AND bgw04 = g_bgw_hd_t.bgw04
           AND bgw07 = g_bgw_hd_t.bgw07
           AND bgw08 = g_bgw_hd_t.bgw08
           AND bgw05 = g_bgw_hd_t.bgw05
           AND bgw12 = g_bgw_hd_t.bgw12
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("upd","bgw_file",g_bgw_hd_t.bgw01,g_bgw_hd_t.bgw02,SQLCA.sqlcode,"","",1) #FUN-660105
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i500_i(p_cmd)
DEFINE
    p_cmd LIKE type_file.chr1,        #No.FUN-680061 VARCHAR(01)
    l_n   LIKE type_file.num5         #No.FUN-680061 SMALLINT
DEFINE    l_aag05  LIKE aag_file.aag05  #No.FUN-B40004 add
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_bgw_hd.bgw01, g_bgw_hd.bgw04, g_bgw_hd.bgw08,g_bgw_hd.bgw02,
          g_bgw_hd.bgw03, g_bgw_hd.bgw07, 
          g_bgw_hd.bgw05, g_bgw_hd.bgw12, g_bgw_hd.bgw11  #No.FUN-730033
    WITHOUT DEFAULTS
     FROM bgw01, bgw04, bgw08,bgw02, bgw03, bgw07,
          bgw05, bgw12, bgw11  #No.FUN-730033
 
#No.FUN-570108 --start--
BEFORE INPUT
        LET  g_before_input_done = FALSE
        CALL i500_set_entry(p_cmd)
        CALL i500_set_no_entry(p_cmd)
        LET  g_before_input_done = TRUE
#No.FUN-570108 --end--
        AFTER FIELD bgw01
	    IF g_bgw_hd.bgw01 IS NULL THEN
               LET g_bgw_hd.bgw01 = ' '
            END IF
 
	AFTER FIELD bgw04
	    IF NOT cl_null(g_bgw_hd.bgw04) THEN
	       IF g_bgw_hd.bgw04 NOT MATCHES '[12]' THEN
  		  NEXT FIELD bgw04
	       END IF
            END IF
 
	AFTER FIELD bgw02
	    IF NOT cl_null(g_bgw_hd.bgw02) THEN
                CASE g_bgw_hd.bgw04
                  WHEN 1 SELECT count(fab01) INTO g_cnt
			   FROM fab_file
			  WHERE fab01 = g_bgw_hd.bgw02
                         IF g_cnt < 1 THEN
                            CALL cl_err('','aoo-109',0)
                            NEXT FIELD bgw02
                         END IF
                   WHEN 2 SELECT count(faj02) INTO g_cnt
			    FROM faj_file
			   WHERE faj02 = g_bgw_hd.bgw02
                          IF g_cnt < 1 THEN
                             CALL cl_err('','afa-911',0)
                             NEXT FIELD bgw02
                          END IF
		END CASE
	    END IF
 
	AFTER FIELD bgw03
            IF g_bgw_hd.bgw03 IS NULL THEN
               LET g_bgw_hd.bgw03=' '
            END IF
	    CASE g_bgw_hd.bgw04
              WHEN 1 SELECT COUNT(*) INTO g_cnt
		       FROM bgo_file
		      WHERE bgo01 = g_bgw_hd.bgw01
		        AND bgo02 = g_bgw_hd.bgw03
		     IF g_cnt < 1 THEN
                        CALL cl_err('','aoo-109',0)
                        NEXT FIELD bgw03
                     END IF
              WHEN 2 IF NOT cl_null(g_bgw_hd.bgw03) THEN
			SELECT COUNT(*) INTO g_cnt
			  FROM faj_file
			 WHERE faj02 = g_bgw_hd.bgw02
			   AND faj022= g_bgw_hd.bgw03
			IF l_n < g_cnt THEN
                           CALL cl_err('','afa-911',0)
                           NEXT FIELD bgw03
                        END IF
		     END IF
	    END CASE
 
	AFTER FIELD bgw08
	    IF NOT cl_null(g_bgw_hd.bgw08) THEN
	       IF g_bgw_hd.bgw08 NOT MATCHES '[123]' THEN
	  	  NEXT FIELD bgw08
	       END IF
            END IF
 
	AFTER FIELD bgw07
	    IF NOT cl_null(g_bgw_hd.bgw07) THEN
		CALL i500_bgw07('a',g_bgw_hd.bgw07)
		IF NOT cl_null(g_errno) THEN
		    CALL cl_err(g_bgw_hd.bgw07,g_errno,0)
		    NEXT FIELD bgw07
		END IF
	    END IF
            CALL i500_bgw07('d', g_bgw_hd.bgw07)
 
       AFTER FIELD bgw11 #No.8836
         IF NOT cl_null(g_bgw_hd.bgw11) THEN
#            CALL i500_bgw11(g_bgw_hd.bgw11,g_bookno1)  #No.FUN-730033
            CALL i500_bgw11(g_bgw_hd.bgw11,g_aza.aza81) #No.FUN-740029            
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bgw_hd.bgw11  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bgw_hd.bgw11 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_bgw_hd.bgw11
               DISPLAY BY NAME g_bgw_hd.bgw11  
               #FUN-B10049--end                   
               NEXT FIELD bgw11
            END IF
            #No.FUN-B40004  --Begin
            LET l_aag05=''
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01 = g_bgw_hd.bgw11
               AND aag00 = g_aza.aza81
            IF l_aag05 = 'Y' THEN
               #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
               IF g_aaz.aaz90 !='Y' THEN
                  LET g_errno = ' '
                  CALL s_chkdept(g_aaz.aaz72,g_bgw_hd.bgw11,g_bgw_hd.bgw07,g_aza.aza81)
                       RETURNING g_errno
               END IF
            END IF            
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_bgw_hd.bgw11,g_errno,0)
               LET g_errno = ' '
               NEXT FIELD bgw11
            END IF
            #No.FUN-B40004  --End
         END IF
 
	AFTER FIELD bgw05
	    IF NOT cl_null(g_bgw_hd.bgw05) THEN
	       IF g_bgw_hd.bgw05 < 1 THEN
	          NEXT FIELD bgw05
	       END IF
               #No.FUN-730033  --Begin
               CALL s_get_bookno(g_bgw_hd.bgw05) 
                    RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_bgw_hd.bgw05,'aoo-081',1)
                  NEXT FIELD bgw05
               END IF
               #No.FUN-730033  --End  
            END IF
 
	AFTER FIELD bgw12
	    IF NOT cl_null(g_bgw_hd.bgw12) THEN
	       IF g_bgw_hd.bgw12 < 1 THEN
	          NEXT FIELD bgw12
	       END IF
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bgw07) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_bgw_hd.bgw07
                   CALL cl_create_qry() RETURNING g_bgw_hd.bgw07
                   NEXT FIELD bgw07
              WHEN INFIELD(bgw11) #客戶編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_bgw_hd.bgw11
                   LET g_qryparam.where = " aag07 IN ('2','3') ",
                                          " AND aag03 IN ('2')"
#                   LET g_qryparam.arg1  = g_bookno1  #No.FUN-730033
                   LET g_qryparam.arg1  = g_aza.aza81 #No.FUN-740029
                   CALL cl_create_qry() RETURNING g_bgw_hd.bgw11
 
                   NEXT FIELD bgw11
            END CASE
 
        ON ACTION CONTROLF                 #欄位說明
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
 
FUNCTION i500_bgw11(p_code,p_bookno)    #No.FUN-730033
DEFINE p_code     LIKE aag_file.aag01
DEFINE p_bookno   LIKE aag_file.aag00   #No.FUN-730033
DEFINE l_aagacti  LIKE aag_file.aagacti
DEFINE l_aag07    LIKE aag_file.aag07
DEFINE l_aag09    LIKE aag_file.aag09
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag02    LIKE aag_file.aag02
 
 LET l_aag02=''
 LET l_aag03=''
 LET l_aag07=''
 LET l_aag09=''
 LET l_aagacti=''
 LET g_errno=''
 SELECT aag02,aag03,aag07,aag09,aagacti
   INTO l_aag02,l_aag03,l_aag07,l_aag09,l_aagacti
   FROM aag_file
  WHERE aag01=p_code
    AND aag00=p_bookno   #No.FUN-730033
 CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
      WHEN l_aagacti='N'      LET g_errno='9028'
       WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
       WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
       WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
      OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
 END CASE
 DISPLAY l_aag02 TO FORMONLY.aag02
 
END FUNCTION
#Query 查詢
FUNCTION i500_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bgw_hd TO NULL       #No.FUN-6A0003
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bgw.clear()
 
    CALL i500_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i500_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bgw_hd TO NULL
    ELSE
        OPEN i500_count
        FETCH i500_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i500_fetch('F')            #讀出TEMP第一筆並顯示
 
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i500_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680061 VARCHAR(01)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i500_bcs INTO g_bgw_hd.bgw01,g_bgw_hd.bgw02,
                                              g_bgw_hd.bgw03,g_bgw_hd.bgw04,
                                              g_bgw_hd.bgw07,
                                              g_bgw_hd.bgw11,
                                              g_bgw_hd.bgw08,
                                              g_bgw_hd.bgw05,
                                              g_bgw_hd.bgw12
        WHEN 'P' FETCH PREVIOUS i500_bcs INTO g_bgw_hd.bgw01,g_bgw_hd.bgw02,
                                              g_bgw_hd.bgw03,g_bgw_hd.bgw04,
                                              g_bgw_hd.bgw07,
                                              g_bgw_hd.bgw11,
                                              g_bgw_hd.bgw08,
                                              g_bgw_hd.bgw05,
                                              g_bgw_hd.bgw12
        WHEN 'F' FETCH FIRST    i500_bcs INTO g_bgw_hd.bgw01,g_bgw_hd.bgw02,
                                              g_bgw_hd.bgw03,g_bgw_hd.bgw04,
                                              g_bgw_hd.bgw07,
                                              g_bgw_hd.bgw11,
                                              g_bgw_hd.bgw08,
                                              g_bgw_hd.bgw05,
                                              g_bgw_hd.bgw12
        WHEN 'L' FETCH LAST     i500_bcs INTO g_bgw_hd.bgw01,g_bgw_hd.bgw02,
                                              g_bgw_hd.bgw03,g_bgw_hd.bgw04,
                                              g_bgw_hd.bgw07,
                                              g_bgw_hd.bgw11,
                                              g_bgw_hd.bgw08,
                                              g_bgw_hd.bgw05,
                                              g_bgw_hd.bgw12
        WHEN '/'
            IF (NOT mi_no_ask) THEN       #No.FUN-6A0057 g_no_ask 
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i500_bcs INTO g_bgw_hd.bgw01,g_bgw_hd.bgw02,
                                                g_bgw_hd.bgw03,g_bgw_hd.bgw04,
                                                g_bgw_hd.bgw07,
                                                g_bgw_hd.bgw11,
                                                g_bgw_hd.bgw08,
                                                g_bgw_hd.bgw05,
                                                g_bgw_hd.bgw12
            LET mi_no_ask = FALSE     #No.FUN-6A0057 g_no_ask 
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_bgw_hd.bgw01, SQLCA.sqlcode, 0)
        INITIALIZE g_bgw_hd.* TO NULL  #TQC-6B0105
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
    #No.FUN-730033  --Begin
    CALL s_get_bookno(g_bgw_hd.bgw05) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_bgw_hd.bgw05,'aoo-081',1)
    END IF
    #No.FUN-730033  --End  
       LET g_data_owner = g_bgw_hd.bgwuser   #FUN-4C0067
       LET g_data_group = g_bgw_hd.bgwgrup  #FUN-4C0067
       CALL i500_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i500_show()
    DISPLAY g_bgw_hd.bgw01, g_bgw_hd.bgw02, g_bgw_hd.bgw03, g_bgw_hd.bgw04,
	    g_bgw_hd.bgw05, g_bgw_hd.bgw07, g_bgw_hd.bgw11, g_bgw_hd.bgw08,
	    g_bgw_hd.bgw12
	 TO bgw01, bgw02, bgw03, bgw04,
	    bgw05, bgw07, bgw11, bgw08, bgw12
 
    CALL i500_bgw07('d', g_bgw_hd.bgw07)
#    CALL i500_bgw11(g_bgw_hd.bgw11,g_bookno1)  #No.FUN-730033
    CALL i500_bgw11(g_bgw_hd.bgw11,g_aza.aza81) #No.FUN-740029
    CALL i500_b_fill(g_wc)				 #單身
    CALL i500_bp("D")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i500_r()
    IF s_shut(0) THEN
	RETURN
     END IF
    IF g_bgw_hd.bgw01 IS NULL THEN
        RETURN
    END IF
    IF cl_delh(0,0) THEN			 #確認一下
        DELETE FROM bgw_file
	 WHERE bgw01 = g_bgw_hd.bgw01
	   AND bgw02 = g_bgw_hd.bgw02
	   AND bgw03 = g_bgw_hd.bgw03
	   AND bgw04 = g_bgw_hd.bgw04
	   AND bgw07 = g_bgw_hd.bgw07
	   AND bgw08 = g_bgw_hd.bgw08
	   AND bgw05 = g_bgw_hd.bgw05
	   AND bgw12 = g_bgw_hd.bgw12
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("del","bgw_file",g_bgw_hd.bgw01,g_bgw_hd.bgw02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i500_pre_x                  #No.TQC-720019
            PREPARE i500_pre_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i500_pre_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_bgw.clear()
            OPEN i500_count  
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i500_bcs
               CLOSE i500_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i500_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i500_bcs
               CLOSE i500_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i500_bcs                                    
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count                                                       
               CALL i500_fetch('L')         
            ELSE            
              LET g_jump = g_curs_index                                                       LET mi_no_ask = TRUE     #No.FUN-6A0057 g_no_ask 
               CALL i500_fetch('/')             
                                            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i500_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680061 SMALLINT
 
    LET g_action_choice = ""
 
    IF cl_null(g_bgw_hd.bgw01) THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT bgw06,bgw09,bgw10,'' FROM bgw_file ",
        " WHERE bgw01 = ? AND bgw02 = ? AND bgw03 = ? AND bgw04 = ? ",
        "  AND bgw07 = ? AND bgw08 = ? AND bgw05 = ? AND bgw12 = ? ",
        "  AND bgw06 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bcl CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bgw WITHOUT DEFAULTS FROM s_bgw.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
 
            BEGIN WORK
            LET p_cmd='u'
            LET g_bgw_t.* = g_bgw[l_ac].*      #BACKUP
#NO.MOD-590329 MARK-------------
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i500_set_entry_b(p_cmd)
#            CALL i500_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329 MARK
                OPEN i500_bcl USING g_bgw_hd.bgw01,g_bgw_hd.bgw02,
                                    g_bgw_hd.bgw03,g_bgw_hd.bgw04,
                                    g_bgw_hd.bgw07,g_bgw_hd.bgw08,
                                    g_bgw_hd.bgw05,g_bgw_hd.bgw12,
                                    g_bgw_t.bgw06
                IF STATUS THEN
                   CALL cl_err("OPEN i500_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bgw_t.bgw09,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                     FETCH i500_bcl INTO g_bgw[l_ac].*
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bgw[l_ac].* TO NULL      #900423
                LET g_bgw[l_ac].bgw09=0
                LET g_bgw[l_ac].bgw10=0
            LET g_bgw_t.* = g_bgw[l_ac].*         #新輸入資料
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i500_set_entry_b(p_cmd)
#            CALL i500_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329 MARK
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bgw06
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO bgw_file(bgw01,bgw04,bgw08,bgw02,bgw03,
                                 bgw07,bgw11,bgw05,bgw12,
                                 bgw06,bgw09,bgw10,bgworiu,bgworig)                                                       VALUES(g_bgw_hd.bgw01,g_bgw_hd.bgw04,
                                 g_bgw_hd.bgw08,g_bgw_hd.bgw02,
                                 g_bgw_hd.bgw03,g_bgw_hd.bgw07,
                                 g_bgw_hd.bgw11,g_bgw_hd.bgw05,
                                 g_bgw_hd.bgw12,
                                 g_bgw[l_ac].bgw06,g_bgw[l_ac].bgw09,
                                 g_bgw[l_ac].bgw10, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgw[l_ac].bgw06,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("ins","bgw_file",g_bgw_hd.bgw02,g_bgw_hd.bgw03,SQLCA.sqlcode,"","",1) #FUN-660105
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE FIELD bgw06
            IF p_cmd='a' THEN
                LET g_bgw[l_ac].bgw09 = 0
                LET g_bgw[l_ac].bgw10 = 0
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bgw[l_ac].bgw09
                DISPLAY BY NAME g_bgw[l_ac].bgw10
                #------MOD-5A0095 END------------
            END IF
 
        BEFORE FIELD bgw09
            IF NOT cl_null(g_bgw[l_ac].bgw06) THEN
	       IF g_bgw[l_ac].bgw06 < 1 OR g_bgw[l_ac].bgw06 > 12 THEN
                  NEXT FIELD bgw09
               END IF
               IF cl_null(g_bgw_t.bgw06)
                  OR (g_bgw[l_ac].bgw06 != g_bgw_t.bgw06) THEN
           	  SELECT count(*) INTO l_n FROM bgw_file
	     	   WHERE bgw01 = g_bgw_hd.bgw01
		     AND bgw02 = g_bgw_hd.bgw02
		     AND bgw03 = g_bgw_hd.bgw03
		     AND bgw04 = g_bgw_hd.bgw04
		     AND bgw07 = g_bgw_hd.bgw07
		     AND bgw08 = g_bgw_hd.bgw08
		     AND bgw05 = g_bgw_hd.bgw05
		     AND bgw12 = g_bgw_hd.bgw12
                     AND bgw06 = g_bgw[l_ac].bgw06
		  IF l_n > 0 THEN
                     CALL cl_err(g_bgw[l_ac].bgw06,-239,0)
                     LET g_bgw[l_ac].bgw06 = g_bgw_t.bgw06
                     #------MOD-5A0095 START----------
                     DISPLAY BY NAME g_bgw[l_ac].bgw06
                     #------MOD-5A0095 END------------
		     NEXT FIELD bgw06
		  END IF
               END IF
            END IF
 
        #No.TQC-970271  --Begin
        AFTER FIELD bgw09
            IF NOT cl_null(g_bgw[l_ac].bgw09) THEN
               IF g_bgw[l_ac].bgw09 < 0 THEN
                  CALL cl_err(g_bgw[l_ac].bgw09,'gap-003',0)
                  NEXT FIELD bgw09
               END IF
            END IF
 
        AFTER FIELD bgw10
            IF NOT cl_null(g_bgw[l_ac].bgw10) THEN
               IF g_bgw[l_ac].bgw10 < 0 THEN
                  CALL cl_err(g_bgw[l_ac].bgw10,'gap-003',0)
                  NEXT FIELD bgw10
               END IF
            END IF
        #No.TQC-970271  --End  
 
        BEFORE DELETE                            #是否取消單身
            IF g_bgw_t.bgw06 > 0 AND
               g_bgw_t.bgw06 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bgw_file
                    WHERE bgw01 = g_bgw_hd.bgw01
		      AND bgw02 = g_bgw_hd.bgw02
		      AND bgw03 = g_bgw_hd.bgw03
		      AND bgw04 = g_bgw_hd.bgw04
		      AND bgw07 = g_bgw_hd.bgw07
		      AND bgw08 = g_bgw_hd.bgw08
		      AND bgw05 = g_bgw_hd.bgw05
		      AND bgw12 = g_bgw_hd.bgw12
		      AND bgw06 = g_bgw_t.bgw06
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bgw_t.bgw06,SQLCA.sqlcode,0) #FUN-660105
                   CALL cl_err3("del","bgw_file",g_bgw_hd.bgw01,g_bgw_t.bgw06,SQLCA.sqlcode,"","",1) #FUN-660105
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bgw[l_ac].* = g_bgw_t.*
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgw[l_ac].bgw06,-263,1)
               LET g_bgw[l_ac].* = g_bgw_t.*
            ELSE
               UPDATE bgw_file
                  SET bgw06 = g_bgw[l_ac].bgw06,
                      bgw09 = g_bgw[l_ac].bgw09,
                      bgw10 = g_bgw[l_ac].bgw10
#                WHERE bgw01 = g_bgw_hd.bgw01
#                  AND bgw02 = g_bgw_hd.bgw02
#                  AND bgw03 = g_bgw_hd.bgw03
#                  AND bgw04 = g_bgw_hd.bgw04
#                  AND bgw07 = g_bgw_hd.bgw07
#                  AND bgw08 = g_bgw_hd.bgw08
#                  AND bgw05 = g_bgw_hd.bgw05
#                  AND bgw12 = g_bgw_hd.bgw12
#                  AND bgw06 = g_bgw_t.bgw06
                WHERE CURRENT OF i500_bcl
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_bgw[l_ac].bgw06,SQLCA.sqlcode,0) #FUN-660105
                 CALL cl_err3("upd","bgw_file",g_bgw[l_ac].bgw06,"",SQLCA.sqlcode,"","",1) #FUN-660105
                 LET g_bgw[l_ac].* = g_bgw_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bgw[l_ac].* = g_bgw_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgw.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032 add 
            CLOSE i500_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLN
            CALL i500_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                      #沿用所有欄位
            IF INFIELD(bgw06) AND l_ac > 1 THEN
                LET g_bgw[l_ac].* = g_bgw[l_ac-1].*
                NEXT FIELD bgw06
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
        END INPUT
    CLOSE i500_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i500_b_askkey()
DEFINE
    l_wc    LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc			         #螢幕上取條件
	   ON bgw06,bgw09,bgw10
         FROM s_bgw[1].bgw06,s_bgw[1].bgw09,s_bgw[1].bgw10
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
       RETURN
    END IF
    CALL i500_b_fill(l_wc)
END FUNCTION
 
FUNCTION i500_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc       LIKE type_file.chr1000,   #No.FUN-680061 VARCHAR(200)
    l_aa       LIKE fan_file.fan02       #No.FUN-680061 VARCHAR(4)
 
    LET g_sql = "SELECT bgw06, bgw09, bgw10,''",
		"  FROM bgw_file ",
                " WHERE bgw01 = '", g_bgw_hd.bgw01, "' ",
		"   AND bgw02 = '", g_bgw_hd.bgw02, "' ",
		"   AND bgw03 = '", g_bgw_hd.bgw03, "' ",
		"   AND bgw04 = '", g_bgw_hd.bgw04, "' ",
		"   AND bgw05 = '", g_bgw_hd.bgw05, "' ",
		"   AND bgw07 = '", g_bgw_hd.bgw07, "' ",
		"   AND bgw08 = '", g_bgw_hd.bgw08, "' ",
		"   AND bgw12 = '", g_bgw_hd.bgw12, "' ",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY bgw06"
    PREPARE i500_prepare2 FROM g_sql		 #預備一下
    DECLARE bgw_cs CURSOR FOR i500_prepare2
 
    CALL g_bgw.clear()
    LET g_cnt = 1
#    LET g_rec_b=0
 
    FOREACH bgw_cs INTO g_bgw[g_cnt].*		 #單身 ARRAY 填充
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
    CALL g_bgw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
END FUNCTION
 
FUNCTION i500_bp(p_ud)
DEFINE p_ud            LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bgw TO s_bgw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i500_fetch('L')
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
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i500_bgw07(p_cmd,l_gem01)
    DEFINE p_cmd	LIKE type_file.chr1,        #No.FUN-680061 VARCHAR(01)
           l_gem01 LIKE gem_file.gem01,
           l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    IF g_bgw_hd.bgw08 MATCHES '[13]' THEN
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
       IF p_cmd = 'd' OR cl_null(g_errno) THEN
           DISPLAY l_gem02 TO FORMONLY.gem02
       END IF
    END IF
END FUNCTION
 
#No.FUN-820002--start--
#製作簡表
FUNCTION i500_out()
DEFINE l_cmd  LIKE type_file.chr1000 
#DEFINE
#    l_i LIKE type_file.num5,       #No.FUN-680061 SMALLINT
#    sr RECORD
#       bgw01       LIKE bgw_file.bgw01,
#       bgw04       LIKE bgw_file.bgw04,
#       bgw02       LIKE bgw_file.bgw02,
#       bgw03       LIKE bgw_file.bgw03,
#       bgw07       LIKE bgw_file.bgw07,
#       bgw11       LIKE bgw_file.bgw11,
# 	bgw08	    LIKE bgw_file.bgw08,
# 	bgw05	    LIKE bgw_file.bgw05,
#	bgw12	    LIKE bgw_file.bgw12,
#       bgw06       LIKE bgw_file.bgw06,
#	bgw09	    LIKE bgw_file.bgw09,
#	bgw10	    LIKE bgw_file.bgw10
#       END RECORD,
#    l_name LIKE type_file.chr20,    # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
#    l_za05 LIKE type_file.chr1000   #NO.FUN-680061 VARCHAR(40)  
     IF cl_null(g_wc) AND NOT cl_null(g_bgw_hd.bgw01)                                                                                
       AND NOT cl_null(g_bgw_hd.bgw02) AND NOT cl_null(g_bgw_hd.bgw03)                                                              
       AND NOT cl_null(g_bgw_hd.bgw04) AND NOT cl_null(g_bgw_hd.bgw05)                                                              
       AND NOT cl_null(g_bgw_hd.bgw07) AND NOT cl_null(g_bgw_hd.bgw08)                                                              
       AND NOT cl_null(g_bgw_hd.bgw12) THEN                                                                                         
       LET g_wc = " bgw01 = '",g_bgw_hd.bgw01,"' AND bgw02 = '",g_bgw_hd.bgw02,                                                     
                  "' AND bgw03 = '",g_bgw_hd.bgw03,"' AND bgw04 = '",g_bgw_hd.bgw04,                                                
                  "' AND bgw05 = '",g_bgw_hd.bgw05,"' AND bgw07 = '",g_bgw_hd.bgw07,                                                
                  "' AND bgw08 = '",g_bgw_hd.bgw08,"' AND  bgw12= '",g_bgw_hd.bgw12,"'"                                             
     END IF
     IF cl_null(g_wc) THEN
 	CALL cl_err('', 9057, 0)
 	RETURN
     END IF
     LET l_cmd = 'p_query "abgi500" "',g_wc CLIPPED,'"'  
     CALL cl_cmdrun(l_cmd)
#    CALL cl_wait()
#    CALL cl_outnam('abgi500') RETURNING l_name
#    SELECT zo02
#      INTO g_company
#      FROM zo_file
#      WHERE zo01 = g_lang
#    LET g_sql="SELECT bgw01, bgw04, bgw02, bgw03, ",
#              "       bgw07, bgw11, bgw08, bgw05, bgw12, ",
#	      "	      bgw06, bgw09, bgw10 ",
#              "  FROM bgw_file",
#              " WHERE 1=1 AND ", g_wc CLIPPED
#    PREPARE i500_p1 FROM g_sql                   # RUNTIME 編譯
#    DECLARE i500_co CURSOR FOR i500_p1
 
#    START REPORT i500_rep TO l_name
 
#    FOREACH i500_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i500_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT i500_rep
 
#    CLOSE i500_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i500_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
#    l_i             LIKE type_file.num5,    #No.FUN-680061 SMALLINT
#    l_gem02         LIKE gem_file.gem02,
#    sr RECORD
#       bgw01       LIKE bgw_file.bgw01,
#       bgw04       LIKE bgw_file.bgw04,
#       bgw02       LIKE bgw_file.bgw02,
#       bgw03       LIKE bgw_file.bgw03,
#       bgw07       LIKE bgw_file.bgw07,
#       bgw11       LIKE bgw_file.bgw07,
# 	bgw08	    LIKE bgw_file.bgw08,
#       bgw05       LIKE bgw_file.bgw05,
#	bgw12	    LIKE bgw_file.bgw12,
#       bgw06       LIKE bgw_file.bgw06,
#       bgw09	    LIKE bgw_file.bgw09,
#	bgw10	    LIKE bgw_file.bgw10
#       END RECORD
 
#    OUTPUT
#        TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
#    ORDER BY sr.bgw01, sr.bgw04, sr.bgw02, sr.bgw03,
#             sr.bgw05,sr.bgw12,sr.bgw06, sr.bgw08,sr.bgw07
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED, pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                  g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#                  g_x[45]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
 
#        BEFORE GROUP OF sr.bgw12
#            PRINT COLUMN g_c[31], sr.bgw02,
#                  COLUMN g_c[32], sr.bgw03,
#                  COLUMN g_c[33], sr.bgw12,
#                  COLUMN g_c[34], sr.bgw01,
# 		  COLUMN g_c[35], sr.bgw04,
#                  COLUMN g_c[36], sr.bgw02,
#		  COLUMN g_c[37], sr.bgw03[1,23],
#		  COLUMN g_c[38], sr.bgw05 USING '####',
#		  COLUMN g_c[39], sr.bgw12 USING '####';
 
#        ON EVERY ROW
#            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.bgw07
#            PRINT COLUMN g_c[40], sr.bgw07,
#                  COLUMN g_c[41], l_gem02,
#                  COLUMN g_c[42], sr.bgw08,
# 	           COLUMN g_c[43], sr.bgw06 USING '####', #No.TQC-5C0037
# 	           COLUMN g_c[44], cl_numfor(sr.bgw09,44,g_azi04),
#      	           COLUMN g_c[45], cl_numfor(sr.bgw10,45,g_azi04)
 
#        AFTER GROUP OF sr.bgw05
#            PRINT g_dash2
 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-820002--end--
 
#No.FUN-570108 --start--
 
FUNCTION i500_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bgw01,bgw02,bgw03,bgw04,bgw07,bgw08,bgw05,bgw12",TRUE)
   END IF
END FUNCTION
 
 
FUNCTION i500_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("bgw01,bgw02,bgw03,bgw04,bgw07,bgw08,bgw05,bgw12",FALSE)
   END IF
END FUNCTION
 
#No.FUN-570108 --end--
 
#NO.MOD-590329 MARK------------------
#NO.MOD-580078
#FUNCTION i500_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bgw06",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i500_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bgw06",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#NO.MOD-590329 MARK
#Patch....NO.MOD-5A0095 <001,002> #
