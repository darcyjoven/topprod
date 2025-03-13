# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: afaq250.4gl
# Descriptions...: 量測儀器校驗記錄查詢
# Date & Author..: 00/03/20 By Iceman
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-530664 05/03/28 By Smapmin 查詢無法輸入單身條件
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以用在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 匯出EXCEL表時，下面多出一行
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740131 07/04/22 By rainy 整合測試
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-AB0316 10/11/30 By suncx1 函數返回值與接收返回值的變量的類型不一致，導致截位現象
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc         LIKE type_file.chr1000		# Head Where condition       #No.FUN-680070 VARCHAR(1000)
        END RECORD,
      g_wc2  string,  #No.FUN-580092 HCN
    g_head_1  RECORD
            fgc01          LIKE fgc_file.fgc01,
            fga02          LIKE fga_file.fga02,
            fga03          LIKE fga_file.fga03,
            fga031         LIKE fga_file.fga031,
            fga04          LIKE fga_file.fga04
        END RECORD,
    g_fgc DYNAMIC ARRAY OF RECORD
            fgc011  LIKE fgc_file.fgc011,
            fgc02   LIKE fgc_file.fgc02,
            fgc03   LIKE fgc_file.fgc03,
            fgc04   LIKE fgc_file.fgc04,
            fgc05   LIKE fgc_file.fgc05,
            fge03   LIKE fge_file.fge03,
            fgc06   LIKE fgc_file.fgc06,
            #desc    LIKE type_file.chr4,          #No.FUN-680070 VARCHAR(4)  #TQC-AB0316 mark
            desc    LIKE ze_file.ze03,             #TQC-AB0316 add
            fgc07   LIKE fgc_file.fgc07
        END RECORD,
    #g_desc      LIKE type_file.chr4,               #No.FUN-680070 VARCHAR(4) #TQC-AB0316 mark
    g_desc      LIKE ze_file.ze03,                 #TQC-AB0316 add
    g_wc,g_sql  STRING,                            #WHERE CONDITION       #No.FUN-580092 HCN
    l_ac,l_sl   LIKE type_file.num5,               #No.FUN-680070 smallint
    g_argv1     LIKE fgc_file.fgc01,               #No.FUN-680070 VARCHAR(15)
#       l_time    LIKE type_file.chr8	    #No.FUN-6A0069
    g_rec_b     LIKE type_file.num5                #單身筆數              #No.FUN-680070 SMALLINT
 
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index    LIKE type_file.num10        #No.FUN-680070 INTEGER
MAIN
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
   LET g_argv1 = ARG_VAL(1)
   CALL afaq250(g_argv1)
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
END MAIN
 
FUNCTION afaq250(p_argv1)
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0069
   DEFINE p_argv1      LIKE fgc_file.fgc01         #No.FUN-680070 VARCHAR(15)
 
       LET g_argv1 =p_argv1    #序號參數
 
    OPEN WINDOW q250_w WITH FORM "afa/42f/afaq250"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
        CALL q250_q()
    END IF
    CALL q250_menu()
    CLOSE WINDOW q250_w
      #CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0069
      #   RETURNING l_time  #MOD-580222 mark
END FUNCTION
 
 
#QBE 查詢資料
FUNCTION q250_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE   l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_fgc.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		    # Default condition
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_head_1.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON fgc01,fga02,fga03,fga031,fga04
 
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
		#No.FUN-580031 --end--       HCN
 
      END CONSTRUCT
   ELSE LET tm.wc ="fgc01='",g_argv1,"'"
   END IF
   IF INT_FLAG THEN RETURN END IF
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND fgauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND fgagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND fgagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fgauser', 'fgagrup')
   #End:FUN-980030
 
 
 #MOD-530664
  IF NOT cl_null(g_argv1) THEN  #MOD-740131
    LET g_wc2 = ' 1=1'          #MOD-740131
  ELSE                          #MOD-740131
   CONSTRUCT g_wc2 ON fgc011,fgc02,fgc03,fgc04,fgc05,fge03,fgc06,desc,fgc07
            FROM s_fgc[1].fgc011,s_fgc[1].fgc02,s_fgc[1].fgc03,s_fgc[1].fgc04,
                 s_fgc[1].fgc05,s_fgc[1].fge03,s_fgc[1].fgc06,s_fgc[1].desc,
                 s_fgc[1].fgc07
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about
               CALL cl_about()
 
            ON ACTION help
               CALL cl_show_help()
 
            ON ACTION controlg
               CALL cl_cmdask()
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
  END IF    #MOD-740131
 
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql=" SELECT UNIQUE fgc01",
                 "  FROM fgc_file,fga_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND fgc01 = fga01 ",
                 " ORDER BY 1 "
     ELSE                                       # 若單身有輸入條件
       LET g_sql=" SELECT UNIQUE fgc01",
                 "  FROM fgc_file,fga_file",
                 " WHERE ",tm.wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 "   AND fgc01 = fga01 ",
                 " ORDER BY 1 "
    END IF
 
 
   PREPARE q250_prepare FROM g_sql
   DECLARE q250_cs SCROLL CURSOR FOR q250_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF g_wc2 = " 1=1" THEN
       LET g_sql=" SELECT COUNT(DISTINCT fga01) FROM fgc_file,fga_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND fgc01 = fga01 "
   ELSE
       LET g_sql=" SELECT COUNT(DISTINCT fga01) FROM fgc_file,fga_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED,
                 "   AND fgc01 = fga01 "
   END IF
 #END MOD-530664
   PREPARE q250_pp  FROM g_sql
   DECLARE q250_count   CURSOR FOR q250_pp
END FUNCTION
 
FUNCTION q250_menu()
 
   WHILE TRUE
      CALL q250_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q250_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fgc),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q250_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
    CALL q250_cs()
    OPEN q250_count
    FETCH q250_count INTO g_row_count #CKP
    DISPLAY g_row_count TO FORMONLY.cnt #CKP
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q250_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q250_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q250_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q250_cs INTO g_head_1.*
        WHEN 'P' FETCH PREVIOUS q250_cs INTO g_head_1.*
        WHEN 'F' FETCH FIRST    q250_cs INTO g_head_1.*
        WHEN 'L' FETCH LAST     q250_cs INTO g_head_1.*
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q250_cs INTO g_head_1.*
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head_1.fgc01,SQLCA.sqlcode,0)
        INITIALIZE g_head_1.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL q250_show()
END FUNCTION
 
FUNCTION q250_show()
 
   SELECT fga02,fga03,fga031,fga04
     INTO g_head_1.fga02,g_head_1.fga03,g_head_1.fga031,g_head_1.fga04
     FROM fga_file
    WHERE fga01 = g_head_1.fgc01
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_head_1.*  
   DISPLAY BY NAME g_head_1.fgc01,g_head_1.fga02,g_head_1.fga03,g_head_1.fga031,g_head_1.fga04
   #No.FUN-9A0024--end 
   CALL q250_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q250_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
          l_n       LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   LET l_sql =
        "SELECT fgc011,fgc02,fgc03,fgc04,fgc05,fge03,fgc06,'',fgc07",
        "  FROM fgc_file LEFT OUTER JOIN fge_file ON fgc05 = fge_file.fge01 ",
        " WHERE fgc01 = '",g_head_1.fgc01,"'"
    PREPARE q250_pb FROM l_sql
    DECLARE q250_bcs CURSOR FOR q250_pb
 
    FOR g_cnt = 1 TO g_fgc.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_fgc[g_cnt].* TO NULL
    END FOR
    LET l_ac = 1
	FOREACH q250_bcs INTO g_fgc[l_ac].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('q250(ckp#1):',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        CALL q250_fgc06('d',g_fgc[l_ac].fgc06) RETURNING g_desc
         LET g_fgc[l_ac].desc=g_desc
        LET l_ac =l_ac+1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_fgc.deleteElement(l_ac)  #No.TQC-6C0009
    LET g_rec_b = l_ac - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q250_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fgc TO s_fgc.*
     ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q250_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q250_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q250_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q250_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q250_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530853  --end
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q250_fgc06(p_cmd,l_fgc06)
DEFINE
      p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_fgc06   LIKE fgc_file.fgc06,
      #l_bn      LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)  #TQC-AB0316
      l_bn      LIKE ze_file.ze03            #TQC-AB0316 add
 
#－0:未校 1:正常 2:停用 3.退修 4.報廢
     CASE l_fgc06
         WHEN '0'
            CALL cl_getmsg('afa-404',g_lang) RETURNING l_bn
         WHEN '1'
            CALL cl_getmsg('afa-405',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-406',g_lang) RETURNING l_bn
         WHEN '3'
            CALL cl_getmsg('afa-407',g_lang) RETURNING l_bn
         WHEN '4'
            CALL cl_getmsg('afa-408',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
#Patch....NO.TQC-610035 <001,002,003,004,005,006,007> #
