# Prog. Version..: '5.30.06-13.03.25(00008)'     #
#
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# Pattern name...: aapq101.4gl
# Descriptions...: 帳款餘額查詢
# Date & Author..: 92/12/23 By Roger
# Modify.........: No.MOD-4A0252 04/10/20 By Smapmin 新增開窗功能
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-570275 05/08/10 By Nicola 金額計算時，借貸方判斷
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0104 06/11/21 By Rayven 匯出EXCEL匯出的值多一空白行,指定筆彈出的對話框不規範
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/03/28 By atsea 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780021 07/08/06 By Smapmin 變數使用錯誤
# Modify.........: No.TQC-860021 08/06/10 By Sarah DISPLAY ARRAY,PROMPT段漏了ON IDLE控制
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/09 By destiny display xxx.*改為display對應欄位
# Modify.........: No.MOD-CA0112 12/10/16 By Polly 調整抓取單身資料條件

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
       	wc  	LIKE type_file.chr1000		# Head Where condition  #No.FUN-690028 VARCHAR(600)
        END RECORD,
    g_head_1  RECORD
            apm08		LIKE apm_file.apm08,
            apm09		LIKE apm_file.apm09,
            apm00		LIKE apm_file.apm00,
            #add 030522 NO.A074
            aag02		LIKE aag_file.aag02,
            apm01		LIKE apm_file.apm01,
            apm02		LIKE apm_file.apm02,
            apm03		LIKE apm_file.apm03,
            #add 030522 NO.A074
            apm11		LIKE apm_file.apm11,
            apm04		LIKE apm_file.apm04
        END RECORD,
    #modify 030522 NO.A074
    g_apm DYNAMIC ARRAY OF RECORD
            apm05   LIKE apm_file.apm05,
            apm06f  LIKE apm_file.apm06f,
            apm07f  LIKE apm_file.apm07f,
            balf    LIKE apm_file.apm07,
            apm06   LIKE apm_file.apm06,
            apm07   LIKE apm_file.apm07,
            bal     LIKE apm_file.apm07
        END RECORD,
     g_wc,g_sql   string,     #WHERE CONDITION  #No.FUN-580092 HCN
    l_ac,l_sl   LIKE type_file.num5,        #No.FUN-690028 SMALLINT
    g_rec_b     LIKE type_file.num5   		  #單身筆數  #No.FUN-690028 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
MAIN
   DEFINE l_time	LIKE type_file.chr8,   		#計算被使用時間  #No.FUN-690028 VARCHAR(8)
          l_sl		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW q111_w AT p_row,p_col
        WITH FORM "aap/42f/aapq101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL q101_menu()
    CLOSE FORM q101_srn               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
END MAIN
 
#QBE 查詢資料
FUNCTION q101_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690028 SMALLINT
   CLEAR FORM #清除畫面
   CALL g_apm.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   #modify 030522 NO.A074
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INITIALIZE g_head_1.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON apm08,apm09,apm00,apm01,apm02,apm03,apm11,apm04
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 #MOD-4A0252新增開窗功能
   ON ACTION CONTROLP
           CASE
              WHEN INFIELD(apm08) #工廠別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azp"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apm08	
                 NEXT FIELD apm08
              WHEN INFIELD(apm00) #科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apm00
                 NEXT FIELD apm00
              WHEN INFIELD(apm01) #付款廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apm01
                 NEXT FIELD apm01
              WHEN INFIELD(apm03) #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apm03
                 NEXT FIELD apm03
              WHEN INFIELD(apm11) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apm11
                 NEXT FIELD apm11
              WHEN INFIELD(apm09) #帳別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aaa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apm09
                 NEXT FIELD apm09
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
   #modify 030522 NO.A074
   LET g_sql="SELECT DISTINCT apm08,apm09,apm00,aag02,apm01,apm02,",
             "       apm03,apm11,apm04",
             "  FROM apm_file LEFT OUTER JOIN aag_file ON aag_file.aag01 = apm_file.apm00 AND aag_file.aag00 = apm_file.apm09 ",  
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY 1,2,3,5,6,7,8,9 "
   PREPARE q101_prepare FROM g_sql
   DECLARE q101_cs SCROLL CURSOR FOR q101_prepare
 
   LET g_sql="SELECT DISTINCT apm08,apm09,apm00,apm01,apm02,apm03,apm11,apm04",
             "  FROM apm_file ",
             " WHERE ",tm.wc CLIPPED,
             "  INTO TEMP x "
   DROP TABLE x
   PREPARE q101_precount_x FROM g_sql
   EXECUTE q101_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE q101_precount FROM g_sql
   DECLARE q101_count CURSOR FOR q101_precount
END FUNCTION
 
#中文的MENU
FUNCTION q101_menu()
 
   WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q101_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_apm),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q101_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q101_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q101_cs                            # 從DB產生合乎條件TEMP(0-30秒)   
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q101_count
        FETCH q101_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q101_cs INTO g_head_1.*
        WHEN 'P' FETCH PREVIOUS q101_cs INTO g_head_1.*
        WHEN 'F' FETCH FIRST    q101_cs INTO g_head_1.*
        WHEN 'L' FETCH LAST     q101_cs INTO g_head_1.*
        WHEN '/'
            IF NOT mi_no_ask THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds  #TQC-860021
                     CALL cl_on_idle()    #TQC-860021
 
                  ON ACTION about         #TQC-860021
                     CALL cl_about()      #TQC-860021
 
                  ON ACTION help          #TQC-860021
                     CALL cl_show_help()  #TQC-860021
 
                  ON ACTION controlg      #TQC-860021
                     CALL cl_cmdask()     #TQC-860021
               END PROMPT                 #TQC-860021
 
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q101_cs INTO g_head_1.*
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head_1.apm01,SQLCA.sqlcode,0)
        INITIALIZE g_head_1.* TO NULL  #TQC-6B0105
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
 
    CALL q101_show()
END FUNCTION
 
FUNCTION q101_show()
   #No.FUN-9A0024--begin 
#  DISPLAY BY NAME g_head_1.*
   DISPLAY BY NAME g_head_1.apm08,g_head_1.apm09,g_head_1.apm00,g_head_1.aag02,                                                          
                   g_head_1.apm01,g_head_1.apm02,g_head_1.apm03,g_head_1.apm11,                                                     
                   g_head_1.apm04  
   #No.FUN-9A0024--end
   CALL q101_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q101_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(1000)
          l_n       LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_tot     LIKE apm_file.apm06
   #add 030522 NO.A074
   DEFINE l_totf    LIKE apm_file.apm06,
          l_aag06   LIKE aag_file.aag06
    # No: MOD-530384 add
   DEFINE l_tot_o   LIKE apm_file.apm06,
          l_totf_o  LIKE apm_file.apm06
 
   #modify 030522 NO.A074
   LET l_sql =
        "SELECT apm05,apm06f,apm07f,0,apm06,apm07,0,aag06",
        "  FROM apm_file,aag_file",
        " WHERE apm00 = '",g_head_1.apm00,"'",
        "   AND apm01 = '",g_head_1.apm01,"'",
        "   AND apm02 = '",g_head_1.apm02,"'",
        "   AND apm03 = '",g_head_1.apm03,"'",
        "   AND apm04 = ",g_head_1.apm04,
        "   AND apm08 = '",g_head_1.apm08,"'",
        "   AND apm09 = '",g_head_1.apm09,"'",
        "   AND apm11 = '",g_head_1.apm11,"'",
        "   AND apm00 = aag01",                    #MOD-CA0112 add
        "   AND apm09 = aag00",                    #MOD-CA0112 add
        " ORDER BY apm05 "
    PREPARE q101_pb FROM l_sql
    #add 030523 NO.A074
    IF STATUS THEN CALL cl_err('q101_pb',STATUS,1) RETURN END IF
    DECLARE q101_bcs CURSOR FOR q101_pb
 
    FOR g_cnt = 1 TO g_apm.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_apm[g_cnt].* TO NULL
    END FOR
    LET l_tot = 0
    LET l_ac = 1
    #modify 030522 NO.A074
    FOREACH q101_bcs INTO g_apm[l_ac].*,l_aag06
        IF SQLCA.sqlcode THEN
           CALL cl_err('q101(ckp#1):',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
         #-----No.MOD-570275-----
        IF l_aag06 = "1" THEN
           IF g_apm[l_ac].apm05 = 0 THEN
              LET l_tot = g_apm[l_ac].apm06 - g_apm[l_ac].apm07
              LET l_totf= g_apm[l_ac].apm06f- g_apm[l_ac].apm07f
           ELSE
              LET l_tot = l_tot + g_apm[l_ac].apm06 - g_apm[l_ac].apm07
              LET l_totf= l_totf+ g_apm[l_ac].apm06f- g_apm[l_ac].apm07f
           END IF
        ELSE
           IF g_apm[l_ac].apm05 = 0 THEN
              LET l_tot = g_apm[l_ac].apm07 - g_apm[l_ac].apm06
              LET l_totf= g_apm[l_ac].apm07f- g_apm[l_ac].apm06f
           ELSE
              LET l_tot = l_tot + g_apm[l_ac].apm07 - g_apm[l_ac].apm06
              LET l_totf= l_totf+ g_apm[l_ac].apm07f- g_apm[l_ac].apm06f
           END IF
        END IF
         #-----No.MOD-570275 END-----
 
        IF l_ac = 1 THEN
           LET l_totf = 0
           LET l_tot  = 0
        ELSE
            # No: MOD-530384 --start--
#          LET l_totf = g_apm[l_ac-1].balf
#          LET l_tot  = g_apm[l_ac-1].bal
           LET l_totf = l_totf_o
           LET l_tot  = l_tot_o
            # No: MOD-530384 ---end---
        END IF
        LET g_apm[l_ac].balf = l_totf + g_apm[l_ac].apm06f - g_apm[l_ac].apm07f
        LET g_apm[l_ac].bal  = l_tot  + g_apm[l_ac].apm06  - g_apm[l_ac].apm07
         # No: MOD-530384 --start--
        LET l_totf_o = g_apm[l_ac].balf
        LET l_tot_o = g_apm[l_ac].bal
         # No: MOD-530384 ---end---
        IF l_aag06 = '2' AND g_apm[l_ac].balf < 0 THEN  #貸方科目
           LET g_apm[l_ac].balf = g_apm[l_ac].balf * -1
           LET g_apm[l_ac].bal  = g_apm[l_ac].bal  * -1
        END IF
        LET l_ac = l_ac + 1
      # genero shell add g_max_rec check START
      #IF g_cnt > g_max_rec THEN   #MOD-780021
      IF l_ac > g_max_rec THEN   #MOD-780021
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #CALL g_apm.deleteElement(g_cnt)  #No.TQC-6B0104   #MOD-780021
    CALL g_apm.deleteElement(l_ac)  #No.TQC-6B0104   #MOD-780021
    LET g_rec_b = l_ac - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET l_ac = 1
END FUNCTION
 
FUNCTION q101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apm TO s_apm.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()          #No.FUN-560228
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)         #No.TQC-6B0104
         CALL q101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE DISPLAY      #TQC-860021
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
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
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
      #No.MOD-530853  --begin
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610035 <001,002,003,004,005,006,007> #
