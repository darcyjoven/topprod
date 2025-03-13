# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq501.4gl
# Descriptions...: 部門科目餘額查詢
# Date & Author..: 92/04/01 By DAVID WANG
#                  By Melody    單身新增'00'期別後display有誤
# Modify.........: No:9515 04/05/03 By Mandy (1)查詢出來的借方異動額,貸方異動額,累計餘額有誤
#                                            (2)_b_fill()中l_tot define的不夠大
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-590124 05/10/27 By Dido 字元轉換有誤
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680025 06/08/24 By douzh voucher型報表轉template1
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By mike    會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-830144 08/04/07 By lilingyu 改CR報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50051 11/05/12 By xjll  增加科目编号查询开窗功能  

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       	wc  	STRING         #TQC-630166 		# Head Where condition
        END RECORD,
    g_ao  RECORD
            aao01		LIKE aao_file.aao01,
            aao02		LIKE aao_file.aao02,
            aao03		LIKE aao_file.aao03,
            aao00		LIKE aao_file.aao00
        END RECORD,
    g_aao DYNAMIC ARRAY OF RECORD
            seq     LIKE ze_file.ze03,    #No.FUN-680098  VARCHAR(04)
            aao05   LIKE aao_file.aao05,
            aao06   LIKE aao_file.aao06,
            l_tot   LIKE aao_file.aao05
        END RECORD,
    g_argv1     LIKE aao_file.aao00,      # INPUT ARGUMENT - 1
    g_bookno    LIKE aaa_file.aaa01, #帳別  #No.FUN-670039
    g_wc,g_sql STRING,        #TQC-630166    #WHERE CONDITION
    g_rec_b  LIKE type_file.num5,  	  #單身筆數 #No.FUN-680098  SMALLINT
    g_aag02 LIKE aag_file.aag02,
    g_aag06 LIKE aag_file.aag06
DEFINE   g_cnt          LIKE type_file.num10     #No.FUN-680098  integer
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose   #No.FUN-680098  smallint
DEFINE   g_msg          LIKE ze_file.ze03        #No.FUN-680098  VARCHAR(72) 
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680098  integer
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680098  integer 
DEFINE   g_jump         LIKE type_file.num10     #No.FUN-680098  integer 
DEFINE   g_no_ask      LIKE type_file.num5      #No.FUN-680098  smallint      
DEFINE   l_table        STRING                   #NO.FUN-830144                                                             
DEFINE   g_str          STRING                   #NO.FUN-830144                                                             
DEFINE   gg_sql         STRING                   #NO.FUN-830144 
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_bookno     = ARG_VAL(1)

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   #NO.FUN-830144  --Begin--                                                                                                
   LET gg_sql = "aao02.aao_file.aao02,",                                                                                    
                "gem02.gem_file.gem02,",                                                                                    
                "aao01.aao_file.aao01,",                                                                                    
                "aag02.aag_file.aag02,",                                                                                    
                "aao03.aao_file.aao03,",                                                                                    
                "aao04.aao_file.aao04,",                                                                                    
                "aao05.aao_file.aao05,",                                                                                    
                "aao06.aao_file.aao06,",                                                                                    
                "aag06.aag_file.aag06,",                                                                                    
                "l_azi05.azi_file.azi05"                                                                                    
   LET l_table = cl_prt_temptable('aglq501',gg_sql) CLIPPED                                                                 
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                
   LET gg_sql = "INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,                                                        
                " VALUES(?,?,?,?,?,?,?,?,?,?)"                                                                              
   PREPARE insert_prep FROM gg_sql                                                                                          
   IF STATUS THEN                                                                                                           
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM                                                                     
   END IF                                                                                                                   
 
    OPEN WINDOW q501_w WITH FORM "agl/42f/aglq501"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    CALL s_shwact(0,0,g_bookno)

    IF NOT cl_null(g_bookno) THEN CALL q501_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
 
    CALL q501_menu()
    CLOSE WINDOW q501_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q501_cs()
   DEFINE   l_cnt LIKE type_file.num5      #No.FUN-680098  smallint
 
   CLEAR FORM #清除畫面
   CALL g_aao.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		 # Default condition
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_ao.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
             aao01,aao02,aao03,aao00
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN

   #No.FUN-B50051--str--
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aao01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aao01
                   NEXT FIELD aao01
          OTHERWISE
             EXIT CASE
         END CASE
   #No.FUN-B50051--end--       

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
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   LET g_sql=" SELECT UNIQUE aao01,aao02,aao03,aao00 FROM aao_file,aag_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND aag01 = aao01 AND aag00=aao00 ",     #No.FUN-740020 
             " ORDER BY aao01,aao02,aao03 "
   PREPARE q501_prepare FROM g_sql
   DECLARE q501_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q501_prepare
   # 取合乎條件筆數
   DROP TABLE x
   LET g_sql=" SELECT UNIQUE aao01,aao02,aao03,aao00 FROM aao_file,aag_file ",
             "  WHERE ",tm.wc CLIPPED,
             "    AND aag01 = aao01 AND aag00=aao00",    #No.FUN-740020 
             "   INTO TEMP x"
   PREPARE q501_prepare_x FROM g_sql
   EXECUTE q501_prepare_x
 
       LET g_sql = "SELECT COUNT(*) FROM x "
 
   PREPARE q501_prepare_cnt FROM g_sql
   DECLARE q501_count CURSOR FOR q501_prepare_cnt
 
END FUNCTION
 
FUNCTION q501_menu()
 
   WHILE TRUE
      CALL q501_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q501_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q501_out()
               CURRENT WINDOW IS q501_w
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aao),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q501_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q501_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q501_count
       FETCH q501_count INTO g_cnt
       DISPLAY g_cnt TO FORMONLY.cnt
       LET g_row_count = g_cnt
       CALL q501_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q501_fetch(p_flag)
DEFINE
    p_flag           LIKE type_file.chr1,     #處理方式     #No.FUN-680098  VARCHAR(1) 
    l_abso           LIKE type_file.num10    #絕對的筆數    #No.FUN-680098  integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q501_cs INTO g_ao.aao01,
                                             g_ao.aao02,g_ao.aao03,g_ao.aao00
        WHEN 'P' FETCH PREVIOUS q501_cs INTO g_ao.aao01,
                                             g_ao.aao02,g_ao.aao03,g_ao.aao00
        WHEN 'F' FETCH FIRST    q501_cs INTO g_ao.aao01,
                                             g_ao.aao02,g_ao.aao03,g_ao.aao00
        WHEN 'L' FETCH LAST     q501_cs INTO g_ao.aao01,
			                     g_ao.aao02,g_ao.aao03,g_ao.aao00
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q501_cs INTO g_ao.aao01,g_ao.aao02,g_ao.aao03,g_ao.aao00
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ao.aao02,SQLCA.sqlcode,0)
        INITIALIZE g_ao.* TO NULL  #TQC-6B0105
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
 
    CALL q501_show()
END FUNCTION
 
FUNCTION q501_show()
   DISPLAY BY NAME g_ao.aao01,g_ao.aao02,g_ao.aao03,g_ao.aao00
   CALL q501_aao01('d')
   CALL q501_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q501_aao01(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1,        #No.FUN-680098  VARCHAR(1) 
           l_gem02 LIKE gem_file.gem02
 
    LET g_errno = ' '
    IF g_ao.aao02 IS NULL THEN
        LET l_gem02=NULL
    ELSE
        SELECT gem02 INTO l_gem02
           FROM gem_file WHERE gem01 = g_ao.aao02  AND gemacti='Y'
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_gem02 = NULL
        END IF
        SELECT aag02,aag06
           INTO g_aag02,g_aag06
           FROM aag_file WHERE aag01 = g_ao.aao01 AND aagacti = 'Y'  AND aag00=g_ao.aao00  #No.FUN-740020 
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET g_aag02 = NULL
            LET g_aag06 = NULL
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_gem02 TO  gem02
       DISPLAY g_aag02 TO  aag02
    END IF
END FUNCTION
 
FUNCTION q501_b_fill()              #BODY FILL UP
#  DEFINE l_sql     VARCHAR(400),
   DEFINE l_sql     STRING,        #TQC-630166
          l_n      LIKE type_file.num5,        #No.FUN-680098 smallint
          l_tot    LIKE type_file.num20_6      #No:9515   #No.FUN-4C0009     #No.FUN-680098 decimal(20,6)
 
 
   LET l_sql =
        "SELECT '',aao05, aao06,0",
        " FROM  aao_file",
        " WHERE aao00 = '",g_ao.aao00,"'" ,
        " AND aao01 = '",g_ao.aao01,"'" ,
        " AND aao02 = '",g_ao.aao02,"'",
        " AND aao03 = ",g_ao.aao03,"",
        " AND aao04 =?"
    PREPARE q501_pb FROM l_sql
    DECLARE q501_bcs                       #BODY CURSOR
        CURSOR FOR q501_pb
 
    CALL g_aao.clear()
    LET g_rec_b=0
    LET g_cnt = 0
    LET l_tot = 0
    IF g_aag06 = '1' THEN
       LET l_n = 1
    ELSE
       LET l_n = -1
    END IF
 
    FOR g_cnt = 1 TO 14
	LET g_i = g_cnt - 1
	OPEN q501_bcs USING g_i #No:9515
        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
           CALL cl_err('',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
	FETCH q501_bcs INTO g_aao[g_cnt].*  #No:9515
	  IF SQLCA.sqlcode = 100 THEN
	     LET g_aao[g_cnt].aao05 = 0     #No:9515
	     LET g_aao[g_cnt].aao06 = 0     #No:9515
	     LET g_aao[g_cnt].l_tot = 0     #No:9515
	  END IF
          IF g_i = 0 THEN
              CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
              LET g_aao[g_cnt].seq = g_msg clipped
          ELSE
              LET g_aao[g_cnt].seq = g_i
          END IF
          LET g_aao[g_cnt].l_tot = l_tot +                     #No:9515
              (g_aao[g_cnt].aao05 - g_aao[g_cnt].aao06) * l_n  #No:9515
          LET l_tot = g_aao[g_cnt].l_tot                       #No:9515
    END FOR
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680098  VARCHAR(1) 
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aao TO s_aao.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
   ON ACTION accept
     #LET l_ac = ARR_CURR()
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
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
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q501_out()
    DEFINE
        l_i          LIKE type_file.num5,        #No.FUN-680098  SMALLINT
        l_name       LIKE type_file.chr20,       # External(Disk) file name  #No.FUN-680098  VARCHAR(20) 
#FUN-590124
        sr     RECORD
                aao01	LIKE aao_file.aao01,
                aao02	LIKE aao_file.aao02,
                aao03	LIKE aao_file.aao03,
                aao00	LIKE aao_file.aao00,
                aao04   LIKE aao_file.aao04,
                aao05   LIKE aao_file.aao05,
                aao06   LIKE aao_file.aao06,
                azi04   LIKE azi_file.azi04
        END RECORD,
#FUN-590124 End
        l_chr        LIKE type_file.chr1     #No.FUN-680098
 
   DEFINE    l_aag02   LIKE aag_file.aag02     #NO.FUN-830144                                                                 
   DEFINE    l_aag06   LIKE aag_file.aag06     #NO.FUN-830144                                                                 
   DEFINE    l_gem02   LIKE gem_file.gem02     #NO.FUN-830144 
 
   #NO.FUN-830144 --Begin--
    IF tm.wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#    CALL cl_wait()
#    CALL cl_outnam('aglq501') RETURNING l_name
    CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglq501'  
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
			AND aaf02 = g_lang
    #NO.FUN-830144  --End--
#    SELECT azi05 INTO g_azi05 FROM azi_file   #總計之小數位數    #CHI-6A0004
#           WHERE azi01 = g_aza.aza17          #CHI-6A0004
#    IF SQLCA.sqlcode THEN 
#      CALL cl_err('',SQLCA.sqlcode,0)  # NO.FUN-660123 #CHI-6A0004 
#       CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0)    # NO.FUN-660123 #CHI-6A0004 
#    END IF                                    #CHI-6A0004 
#FUN-680025--begin
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglq501'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#FUN-680025-end
    LET g_sql="SELECT aao01,aao02,aao03,aao00,aao04,",
              " aao05,aao06,azi04 ",
              " FROM aao_file ,aaa_file LEFT OUTER JOIN azi_file ON aaa03 = azi_file.azi01",
              " WHERE ",tm.wc CLIPPED,
              " AND aao00 = aaa01  ",
              " ORDER BY aao01,aao02,aao03,aao04 "
    PREPARE q501_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q501_co CURSOR FOR q501_p1
 
    #NO.FUN-830144  -Begin--
#    START REPORT q501_rep TO l_name
    FOREACH q501_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#       OUTPUT TO REPORT q501_rep(sr.*)
        SELECT gem02 INTO l_gem02 FROM gem_file                                                                              
         WHERE gem01 = sr.aao02 AND gemacti='Y'                                                                              
 
        SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file                                                                
         WHERE aag01 = sr.aao01 AND aagacti = 'Y' AND aag00=sr.aao00 
 
        EXECUTE insert_prep USING
                sr.aao02,l_gem02,sr.aao01,l_aag02,sr.aao03,                                                                        
                sr.aao04,sr.aao05,sr.aao06,l_aag06,g_azi05
     END FOREACH
    
     LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                        
 
     IF g_zz05 = 'Y' THEN                                                                                                     
        CALL cl_wcchp(tm.wc,'aao01,aao02,aao03,aao00')                                                                       
              RETURNING tm.wc                                                                                                 
     ELSE                                                                                                                     
       LET tm.wc = ""                                                                                                   
     END IF                                                                                                                   
 
    LET g_str = tm.wc                                                                                                        
 
    CALL cl_prt_cs3('aglq501','aglq501',gg_sql,g_str) 
#    FINISH REPORT q501_rep
 
#    CLOSE q501_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
    #NO.FUN-830144  -End-
END FUNCTION
 
#NO.FUN-830144  --Begin--
#REPORT q501_rep(sr)
#    DEFINE
#        l_trailer_sw   LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1) 
##FUN-590124
#        sr     RECORD
#                aao01	LIKE aao_file.aao01,
#                aao02	LIKE aao_file.aao02,
#                aao03   LIKE aao_file.aao03,
#                aao00	LIKE aao_file.aao00,
#                aao04   LIKE aao_file.aao04,
#                aao05   LIKE aao_file.aao05,
#                aao06   LIKE aao_file.aao06,
#                azi04   LIKE azi_file.azi04
#        END RECORD,
##FUN-590124 End
#        l_tot           LIKE aao_file.aao05,
#        l_aag02         LIKE aag_file.aag02,
#        l_aag06         LIKE aag_file.aag06,
#        l_gem02         LIKE gem_file.gem02,
#        l_aao02         LIKE aao_file.aao02,
#        l_aao06         LIKE aao_file.aao06,
#        l_per,i         LIKE type_file.num5,      #No.FUN-680098 
#        l_chr           LIKE type_file.chr1        #No.FUN-680098 
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.aao01,sr.aao02,sr.aao03,sr.aao04
#
#    FORMAT
#        PAGE HEADER
##FUN-680025--begin
##           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##           PRINT ' '
##           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
##               COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            LET g_pageno = g_pageno + 1 
#            LET pageno_total = PAGENO USING '<<<',"/pageno" 
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]
#            PRINT ''    
##FUN-680025--end
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.aao03
#            IF PAGENO > 1 OR LINENO > 5 THEN
#               SKIP TO TOP OF PAGE
#            END IF
#            PRINT g_x[11] CLIPPED,sr.aao02;
#            SELECT gem02 INTO l_gem02 FROM gem_file
#                   WHERE gem01 = sr.aao02 AND gemacti='Y'
#            IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
#            PRINT COLUMN 16,l_gem02
#            PRINT ' '
#           PRINT g_x[12] CLIPPED,sr.aao01;                           #FUN-680025
#            SELECT aag02,aag06 INTO l_aag02,l_aag06 FROM aag_file
#                   WHERE aag01 = sr.aao01 AND aagacti = 'Y' AND aag00=sr.aao00   #No.FUN-740020 
#            IF SQLCA.sqlcode THEN
#               LET l_aag02 = NULL LET l_aag06 = NULL
#            END IF
##FUN-680025--begin
##           PRINT COLUMN 2,l_aag02,COLUMN 32,g_x[13] CLIPPED,sr.aao03
##           PRINT ''
##           PRINT COLUMN 8,g_x[14] CLIPPED,'          ',g_x[16] CLIPPED
##           PRINT COLUMN 8," ----    ------------------    ------------------ ",
##                 ' ------------------'
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#                  g_x[35],g_x[36],g_x[37] 
#            PRINT g_dash1 
##FUN-680025--end
#            LET l_tot = 0
# 
#        ON EVERY ROW
#          {
#           LET l_per = sr.aao04
#           LET kp[l_per+1].aao04 = sr.aao04
#           LET kp[l_per+1].aao05 = sr.aao05
#           LET kp[l_per+1].aao06 = sr.aao06
#          }
#            IF l_aag06 = '1' THEN
#               LET l_tot = l_tot +(sr.aao05 - sr.aao06)
#            ELSE
#               LET l_tot = l_tot +(sr.aao05 - sr.aao06)
#            END IF
##FUN-680025-begin
##           IF sr.aao04 = 0 THEN
##              PRINT COLUMN 9,g_x[17] CLIPPED;
##           ELSE
##              PRINT COLUMN 9,sr.aao04 USING '####';
##           END IF
##           PRINT COLUMN 16,cl_numfor(sr.aao05,18,g_azi05) CLIPPED,
##                 COLUMN 38,cl_numfor(sr.aao06,18,g_azi05) CLIPPED,
##                 COLUMN 58,cl_numfor(l_tot,18,g_azi05) CLIPPED
 #           IF sr.aao04 = 0 THEN 
 #              PRINT COLUMN g_c[31],sr.aao01,
 #                    COLUMN g_c[32],l_aag02,
 #                    COLUMN g_c[33],sr.aao03 USING '####',
 #                    COLUMN g_c[34],g_x[17] CLIPPED;
 #           ELSE
 #              PRINT COLUMN g_c[31],sr.aao01,
 #                    COLUMN g_c[32],l_aag02,
 #                    COLUMN g_c[33],sr.aao03 USING '####',
 #                    COLUMN g_c[34],sr.aao04 USING '####'; 
#            END IF
#            PRINT COLUMN g_c[35],cl_numfor(sr.aao05,35,g_azi05) CLIPPED,
#                  COLUMN g_c[36],cl_numfor(sr.aao06,36,g_azi05) CLIPPED,
#                  COLUMN g_c[37],cl_numfor(l_tot,37,g_azi05) CLIPPED
##FUN-680025--end
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash[1,g_len]
#                    #TQC-630166
#                    #IF g_wc[001,080] > ' ' THEN
#		    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    #IF g_wc[071,140] > ' ' THEN
#		    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    #IF g_wc[141,210] > ' ' THEN
#		    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                    CALL cl_prt_pos_wc(tm.wc)
#            END IF
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-830144  --End--
#Patch....NO.TQC-610035 <001,002> #
