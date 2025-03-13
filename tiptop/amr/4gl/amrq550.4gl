# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: amrq550.4gl
# Descriptions...: MPS工單開立查詢
# Date & Author..: 00/06/07 By Mark
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770031 07/07/05 By chenl   修改b_fill函數。
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.MOD-910083 09/02/02 By Pengu 查詢時無法以單身資料作條件查詢
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C80041 13/02/06 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
        	wc  	LIKE type_file.chr1000,     # Head Where condition    #NO.FUN-680082 VARCHAR(600)
        	wc2  	LIKE type_file.chr1000      # Body Where condition    #NO.FUN-680082 VARCHAR(600)
        END RECORD,
    g_msa   RECORD
            msa01    LIKE msa_file.msa01,  
            msa02    LIKE msa_file.msa02,  
            msa03    LIKE msa_file.msa03,  
            msa04    LIKE msa_file.msa04,  
            msb02    LIKE msb_file.msb02,
            msb03    LIKE msb_file.msb03,
            ima02    LIKE ima_file.ima02,
            ima021   LIKE ima_file.ima021,
            msb04    LIKE msb_file.msb04,
            msb05    LIKE msb_file.msb05,
            msb08    LIKE msb_file.msb08,
            msb06    LIKE msb_file.msb06
        END RECORD,
    g_sfb DYNAMIC ARRAY OF RECORD
            sfb01   LIKE sfb_file.sfb01,
            sfb04_d LIKE sfb_file.sfb04,  #NO.FUN-680082 VARCHAR(08)
            sfb13   LIKE sfb_file.sfb13,
            sfb15   LIKE sfb_file.sfb15,
            sfb08   LIKE sfb_file.sfb08,
            sfb081  LIKE sfb_file.sfb081,
            sfb09   LIKE sfb_file.sfb09,
            sfb82   LIKE sfb_file.sfb82
        END RECORD,
    g_argv1         LIKE msa_file.msa01,
    g_argv2         LIKE msb_file.msb02,
    g_sfb01         LIKE sfb_file.sfb01,
    g_query_flag    LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next   #NO.FUN-680082 SMALLINT
    g_cmd           LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(100) 
    g_sql           STRING,                 #WHERE CONDITION                #No.FUN-580092 HCN           
    g_rec_b         LIKE type_file.num10    #NO.FUN-680082 INTEGER	    #單身筆數
 
 
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680082 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-680082 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680082 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-680082 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #NO.FUN-680082 SMALLINT
 
MAIN
#     DEFINE   l_time    LIKE type_file.chr8     #No.FUN-6A0076
      DEFINE   l_sl      LIKE type_file.num5,  
               p_row     LIKE type_file.num5,  
               p_col     LIKE type_file.num5     #NO.FUN-680082 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_argv2      = ARG_VAL(2)         
    LET g_query_flag=1
    LET p_row = 4 LET p_col = 2 
    OPEN WINDOW q550_w AT p_row,p_col
        WITH FORM "amr/42f/amrq550" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q550_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q550_q() END IF
    CALL q550_menu()
    CLOSE WINDOW q550_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
#QBE 查詢資料
FUNCTION q550_cs()
   DEFINE   l_cnt LIKE type_file.num5       #NO.FUN-680082 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "msa01 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET tm.wc=tm.wc CLIPPED," AND msb02=",g_argv2
      END IF
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
      CALL g_sfb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
 
   INITIALIZE g_msa.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON msa01,msa02,msb02,msb03,
                                      msb04,msb05,msb08, msb06,
                                      msa03,msa04   
 
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
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('msauser', 'msagrup') #FUN-980030
 
           IF INT_FLAG THEN RETURN END IF
           CALL q550_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT ' 
   IF cl_null(tm.wc2) OR tm.wc2=' 1=1' THEN    #No.MOD-910083 modify
      LET g_sql=" SELECT msa01,msb02 FROM msa_file,msb_file ",
                " WHERE msa01=msb01 AND msa03='N' AND ",tm.wc CLIPPED,
                "   AND msa05<>'X'", #CHI-C80041
                " ORDER BY msa01,msb02"
   ELSE
      LET g_sql=" SELECT UNIQUE msa01,msb02 ",
                "   FROM msa_file,msb_file,sfb_file ",       #No.MOD-910083 modify
                " WHERE msa01=msb01 AND msa03='N' AND ",tm.wc CLIPPED,
                "   AND msa05<>'X'", #CHI-C80041
                "   AND sfb22 = msa01 AND sfb221 = msb02 ",  #No.MOD-910083 add
                "   AND ",tm.wc2 CLIPPED,
                " ORDER BY msa01,msb02"
   END IF
   PREPARE q550_prepare FROM g_sql
   DECLARE q550_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q550_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
  #-------------No.MOD-910083 modify
  #    LET g_sql=" SELECT COUNT(*) FROM msa_file,msb_file ",
  #                " WHERE msa01=msb01 AND msa03='N' AND ",tm.wc CLIPPED
  #PREPARE q550_pp  FROM g_sql
  #DECLARE q550_cnt   CURSOR FOR q550_pp
   LET g_row_count = 0
   FOREACH q550_cs INTO g_msa.msa01,g_msa.msb02
      LET g_row_count = g_row_count + 1
   END FOREACH 
  #-------------No.MOD-910083 end
END FUNCTION
 
FUNCTION q550_b_askkey()
   CONSTRUCT tm.wc2 ON sfb01,sfb04_d,sfb13,sfb15,sfb08,sfb081,sfb09,sfb82
                  FROM s_sfb[1].sfb01,s_sfb[1].sfb04_d,s_sfb[1].sfb13,
                       s_sfb[1].sfb15,s_sfb[1].sfb08,s_sfb[1].sfb081,
                       s_sfb[1].sfb09,s_sfb[1].sfb82
 
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
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
END FUNCTION
 
#中文的MENU
FUNCTION q550_menu()
 
   WHILE TRUE
      CALL q550_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q550_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0013
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
             END IF
         #--
 
       #@WHEN "製程數量查詢" 
         WHEN "query_routing_quantity" 
            SELECT sfb01 INTO g_sfb01 FROM sfb_file 
            WHERE sfb22 = g_msa.msa01 AND sfb221=g_msa.msb02
            IF SQLCA.sqlcode THEN
               LET g_sfb01 = ' ' 
            END IF 
            LET g_cmd="aecq700 '",g_sfb01,"'"  clipped
            CALL cl_cmdrun(g_cmd)
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q550_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q550_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q550_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
      #OPEN q550_cnt                   #No.MOD-910083 mark
      #FETCH q550_cnt INTO g_row_count #No.MOD-910083 mark
       DISPLAY g_row_count TO cnt  
       CALL q550_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q550_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式   #NO.FUN-680082 VARCHAR(1)
    l_abso          LIKE type_file.num10      #絕對的筆數 #NO.FUN-680082 INTEGER 
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     q550_cs INTO g_msa.msa01,g_msa.msb02
       WHEN 'P' FETCH PREVIOUS q550_cs INTO g_msa.msa01,g_msa.msb02
       WHEN 'F' FETCH FIRST    q550_cs INTO g_msa.msa01,g_msa.msb02
       WHEN 'L' FETCH LAST     q550_cs INTO g_msa.msa01,g_msa.msb02
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
            FETCH ABSOLUTE g_jump q550_cs INTO g_msa.msa01,g_msa.msb02
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)
        INITIALIZE g_msa.* TO NULL  #TQC-6B0105
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
	SELECT msa01,msa02,msa03,msa04,msb02,msb03,'','',msb04,
               msb05,msb08,msb06
	  INTO g_msa.*
	  FROM msa_file,msb_file
         WHERE msa01= g_msa.msa01
           AND msb02= g_msa.msb02
           AND msa01= msb01
           AND msa03='N'
           AND msa05<>'X'  #CHI-C80041
 
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0) #No.FUN-660107
         CALL cl_err3("sel","msa_file,msb_file",g_msa.msa01,g_msa.msb02,SQLCA.SQLCODE,"","",0)        #NO.FUN-660107
        RETURN
    END IF
 
    CALL q550_show()
END FUNCTION
   
FUNCTION q550_show()
   SELECT ima02,ima021 INTO g_msa.ima02,g_msa.ima021 
     FROM ima_file WHERE ima01=g_msa.msb03
   DISPLAY BY NAME g_msa.* 
   CALL q550_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
   
FUNCTION q550_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000        #NO.FUN-680082 VARCHAR(1000) 
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
       #No.TQC-770031--begin--
       #"SELECT sfb01,sfb13,sfb15,sfb08,sfb081,",
       #"       sfb09,sfb82,sfb04 ",
        "SELECT sfb01,sfb04,sfb13,sfb15,sfb08,sfb081,",
        "       sfb09,sfb82 ",
       #No.TQC-770031--end--
        "  FROM sfb_file ",
        " WHERE sfb87!='X' AND sfb22='",g_msa.msa01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND sfb221=",g_msa.msb02,
        " ORDER BY 1"
    PREPARE q550_pb FROM l_sql
    DECLARE q550_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q550_pb
    CALL g_sfb.clear()
    LET g_cnt = 1
    FOREACH q550_bcs INTO g_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL s_wostatu(g_sfb[g_cnt].sfb04_d) RETURNING g_sfb[g_cnt].sfb04_d
        IF SQLCA.SQLCODE THEN LET g_sfb[g_cnt].sfb04_d=' ' END IF
        IF g_sfb[g_cnt].sfb08 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb08 = 0 
        END IF
        IF g_sfb[g_cnt].sfb081 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb081 = 0 
        END IF
        IF g_sfb[g_cnt].sfb09 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb09 = 0 
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
 
FUNCTION q550_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1) 
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q550_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q550_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q550_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q550_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q550_fetch('L')
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
    #@ON ACTION 製程數量查詢
      ON ACTION query_routing_quantity
         LET g_action_choice="query_routing_quantity"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0013
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
       #No.MOD-530852  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530852  --end         
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#TQC-790177
