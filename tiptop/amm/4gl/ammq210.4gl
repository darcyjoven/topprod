# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: ammq210.4gl
# Descriptions...: 加工通知-廠商查詢作業
# Date & Author..: 00/12/30 by plum
# Modify.........: NO.MOD-490044 04/09/02 by Smapmin 調整資料顯示順序
# Modify.........: No.FUN-4B0036 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     g_mme  RECORD
            mme03	LIKE mme_file.mme03, #供應商
           #pmc03       LIKE pmc_file.pmc03  #供應商簡稱 
            pmc03       LIKE gem_file.gem02  #No.FUN-680100 VARCHAR(10)#供應商/部門簡稱 
        END RECORD,
    choice          LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_order         LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    g_mmf DYNAMIC ARRAY OF RECORD
            mme01       LIKE mme_file.mme01,   #加工通知號
            mmf02       LIKE mmf_file.mmf02,   #項次#MOD-490044
            mme02       LIKE mme_file.mme02,   #單據日期
            mme07       LIKE mme_file.mme07,   #需求部門
            mme06       LIKE mme_file.mme06,   #需求人員
            mmf07       LIKE mmf_file.mmf07,   #來源
            mmfacti     LIKE mmf_file.mmfacti, #有效碼
            mmf03       LIKE mmf_file.mmf03,   #需求料號#MOD-490044
            mmf15       LIKE mmf_file.mmf15,   #加工碼
            mmc02       LIKE mmc_file.mmc02,   #加工碼說明
            mmf10       LIKE mmf_file.mmf10,   #數量
            mmf031      LIKE mmf_file.mmf031,  #單位
            mmf06       LIKE mmf_file.mmf06,   #加工說明
            mmb14       LIKE mmb_file.mmb14
        END RECORD,
    g_mmf02 ARRAY[100] OF LIKE type_file.num5,    #No.FUN-680100 SMALLINT#採購單項次
    g_argv1         LIKE mme_file.mme03,     
    g_query_flag    LIKE type_file.num5,          #No.FUN-680100 SMALLINT#第一次進入程式時即進入Query之後進入next
     g_wc,g_wc2,g_sql STRING, #WHERE CONDITION    #No.FUN-580092 HCN        #No.FUN-680100
    g_rec_b LIKE type_file.num5   		  #單身筆數        #No.FUN-680100 SMALLINT
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(72) 
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
MAIN
#     DEFINE   l_time    LIKE type_file.chr8	    #No.FUN-6A0076
      DEFINE   l_sl,p_row,p_col		LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
   OPTIONS                     
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 2 
    OPEN WINDOW q210_w AT p_row,p_col
        WITH FORM "amm/42f/ammq210" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   #IF cl_chk_act_auth() THEN
   #   CALL q210_q() 
   #END IF
    CALL q210_menu()
    CLOSE WINDOW q210_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
#QBE 查詢資料
FUNCTION q210_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680100 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv1)
      THEN LET g_wc = "mme03 = '",g_argv1,"'"
           LET g_wc2=" 1=1"
   ELSE CLEAR FORM #清除畫面
   CALL g_mmf.clear()
        CALL cl_opmsg('q')
        INITIALIZE g_wc,g_wc2  TO NULL			
   INITIALIZE g_mme.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON mme03 
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
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mmeuser', 'mmegrup') #FUN-980030
        IF INT_FLAG THEN RETURN END IF
 
        CONSTRUCT g_wc2 ON mme01,mmf02,mme02,mme07,mme06,mmf07,mmfacti,mmf03,
                            mmf15,mmf10,mmf031,mmf06,mmb14
            FROM s_mmf[1].mme01, s_mmf[1].mmf02, s_mmf[1].mme02, s_mmf[1].mme07,
                 s_mmf[1].mme06, s_mmf[1].mmf07, s_mmf[1].mmfacti,
                 s_mmf[1].mmf03, s_mmf[1].mmf15, s_mmf[1].mmf10,
                 s_mmf[1].mmf031,s_mmf[1].mmf06, s_mmf[1].mmb14
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
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT ' 
   LET g_sql=" SELECT UNIQUE mme03 ",
             " FROM mme_file,mmf_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND ",g_wc2 CLIPPED,
             " AND mme03 != ' ' AND mme03 IS NOT NULL AND mme01=mmf01",
             " ORDER BY mme03"
   PREPARE q210_prepare FROM g_sql
   DECLARE q210_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q210_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(DISTINCT mme03) FROM mme_file,mmf_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND ",g_wc2 CLIPPED,
             " AND mme03 != ' ' AND mme03 IS NOT NULL AND mme01=mmf01 "
   PREPARE q210_pp  FROM g_sql
   DECLARE q210_cnt   CURSOR FOR q210_pp
END FUNCTION
 
#中文的MENU
FUNCTION q210_menu()
 
   WHILE TRUE
      CALL q210_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q210_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0036
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mmf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q210_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q210_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 RETURN 
    END IF
    OPEN q210_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q210_cnt
       FETCH q210_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q210_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q210_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680100 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680100 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q210_cs INTO g_mme.mme03
        WHEN 'P' FETCH PREVIOUS q210_cs INTO g_mme.mme03
        WHEN 'F' FETCH FIRST    q210_cs INTO g_mme.mme03
        WHEN 'L' FETCH LAST     q210_cs INTO g_mme.mme03
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
            FETCH ABSOLUTE g_jump q210_cs INTO g_mme.mme03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('Fetch error !',SQLCA.sqlcode,0)
       INITIALIZE g_mme.* TO NULL  #TQC-6B0105
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
    SELECT UNIQUE mme03 INTO g_mme.mme03 FROM mme_file
     WHERE mme03 = g_mme.mme03 
    IF SQLCA.sqlcode THEN
#       CALL cl_err('Read mme_file error !',SQLCA.sqlcode,0) #No.FUN-660094
        CALL cl_err3("sel","mme_file",g_mme.mme03,"",SQLCA.SQLCODE,"","read mme_file error !",0)        #NO.FUN-660094
       RETURN
    END IF
    SELECT pmc03 INTO g_mme.pmc03 FROM pmc_file 
     WHERE pmc01 = g_mme.mme03
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
       SELECT gem02 INTO g_mme.pmc03 FROM gem_file
        WHERE gem01=g_mme.mme03
    END IF
 
    CALL q210_show()
END FUNCTION
 
FUNCTION q210_show()
   DISPLAY g_mme.mme03, g_mme.pmc03 TO mme03, pmc03  
   CALL q210_b_fill() 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q210_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING         #No.FUN-680100
 
    LET l_sql =
         "SELECT mme01,mmf02,mme02,mme07,mme06,mmf07,mmfacti,",
         "mmf03,mmf15,mmc02,",
         "       mmf10,mmf031,mmf06 ",
### tony add 010509 加結轉否
	 ", mmb14 ",
###
         " FROM  mme_file,mmf_file LEFT OUTER JOIN mmc_file ON mmc_file.mmc01=mmf15,mmb_file ",
#        " FROM  mme_file,mmf_file,OUTER mmc_file ",
         " WHERE mme01 = mmf01  ",
         "   AND mme03 = '",g_mme.mme03,"'",
### tony add 010509 加結轉否
	 " AND mmb131=mme01 AND mmb132=mmf02 ",
###
         "   AND ",g_wc2 CLIPPED,
         " ORDER BY mme01,mmf02 "
    PREPARE q210_pb FROM l_sql
    DECLARE q210_bcs CURSOR FOR q210_pb
 
    CALL g_mmf.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q210_bcs INTO g_mmf[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mmf TO s_mmf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q210_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q210_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL q210_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q210_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q210_fetch('L')
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
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
      ON ACTION exporttoexcel       #FUN-4B0036
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #No.MOD-530688  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.MOD-530688  --end         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
