# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: gxcq100
# Descriptions...: 庫存入項資料查詢作業
# Date & Author..: 2004/02/20 By Elva
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770001 07/07/02 By sherry  點擊"幫助"按鈕無效
# Modify.........: No.FUN-7C0101 08/01/10 By douzh   成本改善功能,增加成本計算類別(cxa010),類別編號(cxa011),制費等欄位
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
           tm       RECORD
                    wc          LIKE type_file.chr1000#NO.FUN-680145 VARCHAR(500)  # Head Where condition
                    END RECORD,
           g_cxa01  LIKE cxa_file.cxa01,               # 料件編號
           g_ima02  LIKE ima_file.ima02,               # 品名
           g_ima25  LIKE ima_file.ima25,               # 單位
           g_cxa02  LIKE cxa_file.cxa02,               # 年度
           g_cxa010 LIKE cxa_file.cxa010,              # 成本計算類別        #No.FUN-7C0101
           g_cxa011 LIKE cxa_file.cxa011,              # 類別編號            #No.FUN-7C0101
           g_cxa03  LIKE cxa_file.cxa03,               # 月份
           g_cxa    DYNAMIC ARRAY OF RECORD
             cxa04  LIKE cxa_file.cxa04,               # 異動日期
             cxa05  LIKE cxa_file.cxa05,               # 異動時間
             cxa06  LIKE cxa_file.cxa06,               # 異動單號        
             cxa07  LIKE cxa_file.cxa07,               # 項次             
             cxa08  LIKE cxa_file.cxa08,               # 異動數量       
             cxa09  LIKE cxa_file.cxa09,               # 異動金額            
             cxa091 LIKE cxa_file.cxa091,              # 材料
             cxa092 LIKE cxa_file.cxa092,              # 人工
             cxa093 LIKE cxa_file.cxa093,              # 異動金額-制費一
             cxa094 LIKE cxa_file.cxa094,              # 加工
             cxa095 LIKE cxa_file.cxa095,              # 異動金額-制費二
             cxa096 LIKE cxa_file.cxa096,              # 異動金額-制費三      #No.FUN-7C0101
             cxa097 LIKE cxa_file.cxa096,              # 異動金額-制費四      #No.FUN-7C0101
             cxa098 LIKE cxa_file.cxa096,              # 異動金額-制費五      #No.FUN-7C0101
             cxa10  LIKE cxa_file.cxa10,               # 已耗   
             cxa11  LIKE cxa_file.cxa11,  
             cxa111 LIKE cxa_file.cxa111,
             cxa112 LIKE cxa_file.cxa112,
             cxa113 LIKE cxa_file.cxa113,
             cxa114 LIKE cxa_file.cxa114,  
             cxa115 LIKE cxa_file.cxa115,
             cxa116 LIKE cxa_file.cxa116,                                     #No.FUN-7C0101 
             cxa117 LIKE cxa_file.cxa117,                                     #No.FUN-7C0101  
             cxa118 LIKE cxa_file.cxa118,                                     #No.FUN-7C0101    
             cxa15  LIKE cxa_file.cxa15                # 代買 
             	    END RECORD,
    g_argv1         LIKE cxa_file.cxa01,      # 
    g_query_flag    LIKE type_file.num5,         #NO.FUN-680145 SMALLINT  #第一次進入程式時即進入Query之後進入N.下筆
     g_sql           string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5          #NO.FUN-680145 SMALLINT  #單身筆數
 
DEFINE p_row,p_col       LIKE type_file.num5          #NO.FUN-680145 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #NO.FUN-680145 INTEGER                                                
DEFINE   g_msg           LIKE type_file.chr1000       #NO.FUN-680145 VARCHAR(72)                                             
DEFINE   g_row_count     LIKE type_file.num10         #NO.FUN-680145 INTEGER                                           
DEFINE   g_curs_index    LIKE type_file.num10         #NO.FUN-680145 INTEGER 
 DEFINE   g_jump         LIKE type_file.num10         #NO.FUN-680145 INTEGER 
 DEFINE   mi_no_ask      LIKE type_file.num5          #NO.FUN-680145 SMALLINT
DEFINE   l_ac	 	 LIKE type_file.num5          #NO.FUN-680145 SMALLINT
 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	     #No.FUN-6A0099
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("GXC")) THEN
       EXIT PROGRAM
    END IF
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 3 LET p_col = 15
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   OPEN WINDOW q100_w AT p_row,p_col
       WITH FORM "gxc/42f/gxcq100" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_init()
   CALL q100_menu()
   CLOSE WINDOW q100_w
     CALL  cl_used(g_prog,g_time,2)          #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
         RETURNING g_time    #No.FUN-6A0099
END MAIN
 
#QBE 查詢資料
FUNCTION q100_cs()
   DEFINE   l_cnt   LIKE type_file.num5      #NO.FUN-680145 SMALLINT
 
   IF g_argv1 != ' '
      THEN LET tm.wc = "cxa01 = '",g_argv1,"'"
      ELSE CLEAR FORM #清除畫面
           CALL g_cxa.clear() 
           CALL cl_opmsg('q')
        INITIALIZE tm.* TO NULL	      # Default condition
           CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_cxa01  TO NULL    #No.FUN-750051
   INITIALIZE g_cxa02  TO NULL    #No.FUN-750051
   INITIALIZE g_cxa010 TO NULL    #No.FUN-7C0101
   INITIALIZE g_cxa011 TO NULL    #No.FUN-7C0101
   INITIALIZE g_cxa03  TO NULL    #No.FUN-750051
           CONSTRUCT tm.wc ON cxa01,cxa02,cxa010,cxa011,cxa03,cxa04,cxa05,cxa06,cxa07,cxa08,                  #No.FUN-7C0101
             cxa09,cxa091,cxa092,cxa093,cxa094,cxa095,cxa096,cxa097,cxa098,cxa10,cxa11,cxa111,cxa112,         #No.FUN-7C0101
             cxa113,cxa114,cxa115,cxa116,cxa117,cxa118,cxa15             # 螢幕上取單頭條件                   #No.FUN-7C0101 
               FROM cxa01,cxa02,cxa010,cxa011,cxa03,s_cxa[1].cxa04,s_cxa[1].cxa05,
               s_cxa[1].cxa06,s_cxa[1].cxa07,s_cxa[1].cxa08,
               s_cxa[1].cxa09,s_cxa[1].cxa091,s_cxa[1].cxa092,s_cxa[1].cxa093,
               s_cxa[1].cxa094,s_cxa[1].cxa095,s_cxa[1].cxa096,                                               #No.FUN-7C0101 
               s_cxa[1].cxa097,s_cxa[1].cxa098,s_cxa[1].cxa10,s_cxa[1].cxa11,                                 #No.FUN-7C0101
               s_cxa[1].cxa111,s_cxa[1].cxa112,s_cxa[1].cxa113,s_cxa[1].cxa114,
               s_cxa[1].cxa115,s_cxa[1].cxa116,s_cxa[1].cxa117,                                               #No.FUN-7C0101
               s_cxa[1].cxa118,s_cxa[1].cxa15                                                                 #No.FUN-7C0101
              
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
               #MOD-530850                                                                
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(cxa01)                                                 
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_ima"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_cxa01                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            DISPLAY g_qryparam.multiret TO cxa01                                
            NEXT FIELD cxa01                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
    #--
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
#--NO.MOD-860078 start---
  
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
#--NO.MOD-860078 end------- 
 
   END CONSTRUCT        
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
           IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF
   MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
   LET g_sql=" SELECT UNIQUE cxa01,cxa02,cxa010,cxa011,cxa03 FROM cxa_file ",          #No.FUN-7C0101     
             "  WHERE ",tm.wc CLIPPED ,
             "  ORDER BY cxa01,cxa02,cxa010,cxa011,cxa03 "                             #No.FUN-7C0101
   PREPARE q100_prepare FROM g_sql
   DECLARE q100_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q100_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT UNIQUE cxa01,cxa02,cxa010,cxa011,cxa03 FROM cxa_file ",          #No.FUN-7C0101
             "  WHERE ",tm.wc CLIPPED ,
             "   INTO TEMP x"
   DROP TABLE x
   PREPARE q100_precount_x FROM g_sql
   EXECUTE q100_precount_x
   
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE q100_pp  FROM g_sql
   DECLARE q100_cnt   CURSOR FOR q100_pp
END FUNCTION
 
FUNCTION q100_menu()
    WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               LET g_msg="gxcr110 '",g_cxa01,"'",g_cxa02,g_cxa03 
               CALL cl_cmdrun(g_msg) 
            END IF
         WHEN "help" 
      #     CALL SHOWHELP(1)            #No.TQC-770001
            CALL cl_show_help()         #No.TQC-770001 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q100_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q100_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q100_cs                              # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q100_cnt
        FETCH q100_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
        CALL q100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #NO.FUN-680145 VARCHAR(1)  #處理方式
    l_abso          LIKE type_file.num5      #NO.FUN-680145 INTEGER  #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q100_cs INTO g_cxa01,g_cxa02,g_cxa010,g_cxa011,g_cxa03         #No.FUN-7C0101
        WHEN 'P' FETCH PREVIOUS q100_cs INTO g_cxa01,g_cxa02,g_cxa010,g_cxa011,g_cxa03         #No.FUN-7C0101   
        WHEN 'F' FETCH FIRST    q100_cs INTO g_cxa01,g_cxa02,g_cxa010,g_cxa011,g_cxa03         #No.FUN-7C0101
        WHEN 'L' FETCH LAST     q100_cs INTO g_cxa01,g_cxa02,g_cxa010,g_cxa011,g_cxa03         #No.FUN-7C0101
        WHEN '/'
           #No.MOD-480163
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
          FETCH ABSOLUTE g_jump q100_cs INTO g_cxa01,g_cxa02,g_cxa010,g_cxa011,g_cxa03           #No.FUN-7C0101
          LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cxa01,SQLCA.sqlcode,0)
        INITIALIZE g_cxa01 TO NULL   #TQC-6B0105
        INITIALIZE g_cxa02 TO NULL   #TQC-6B0105
        INITIALIZE g_cxa010 TO NULL  #No.FUN-7C0101
        INITIALIZE g_cxa011 TO NULL  #No.FUN-7C0101
        INITIALIZE g_cxa03 TO NULL   #TQC-6B0105
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
    CALL q100_show()
END FUNCTION
 
FUNCTION q100_show()
   DISPLAY g_cxa01 TO cxa01   #ATTRIBUTE(YELLOW)  # 顯示單頭值 
   DISPLAY g_cxa02 TO cxa02   #ATTRIBUTE(YELLOW)  # 顯示單頭值
   DISPLAY g_cxa010 TO cxa010 #ATTRIBUTE(YELLOW)  # 顯示單頭值     #No.FUN-7C0101
   DISPLAY g_cxa011 TO cxa011 #ATTRIBUTE(YELLOW)  # 顯示單頭值     #No.FUN-7C0101
   DISPLAY g_cxa03 TO cxa03   #ATTRIBUTE(YELLOW)  # 顯示單頭值
   SELECT ima02,ima25 INTO g_ima02,g_ima25 FROM ima_file WHERE ima01 = g_cxa01 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_cxa02,SQLCA.sqlcode,0)   #No.FUN-660146
      CALL cl_err3("sel","ima_file",g_cxa01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660146
      RETURN
   END IF
   DISPLAY g_ima02,g_ima25 TO ima02,ima25
   CALL q100_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q100_b_fill()                  #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 #NO.FUN-680145 VARCHAR(1000) 
#   DEFINE l_tot     LIKE ima_file.ima26    #NO.FUN-680145 DECIMAL(15,3)#FUN-A20044
   DEFINE l_tot     LIKE type_file.num15_3    #NO.FUN-680145 DECIMAL(15,3)#FUN-A20044
 
   LET l_sql =
        "SELECT cxa04,cxa05,cxa06,cxa07,cxa08,cxa09,cxa091,cxa092,cxa093,",
        "       cxa094,cxa095,cxa096,cxa097,cxa098,cxa10,cxa11,cxa111,cxa112,",          #No.FUN-7C0101
        "       cxa113,cxa114,cxa115,cxa116,cxa117,cxa118,cxa15",                        #No.FUN-7C0101
        "  FROM  cxa_file ",
        " WHERE cxa01 = '",g_cxa01,"'",
        "   AND cxa02 = ",g_cxa02,
        "   AND cxa010 = '",g_cxa010,"'",                                                     #No.FUN-7C0101  #數據由axcp500寫入
        "   AND cxa011 = '",g_cxa011,"'",                                                     #No.FUN-7C0101
        "   AND cxa03 = ",g_cxa03,
        "   AND ", tm.wc CLIPPED,
        " ORDER BY cxa04 "
    PREPARE q100_pb FROM l_sql
    DECLARE q100_bcs                      #BODY CURSOR
        CURSOR FOR q100_pb
 
    CALL g_cxa.clear() 
    LET g_rec_b= 0
    LET g_cnt  = 1
    FOREACH q100_bcs INTO g_cxa[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_cxa.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
END FUNCTION
 
FUNCTION q100_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1    #NO.FUN-680145 VARCHAR(1) 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cxa TO s_cxa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output                                                          
         LET g_action_choice="output"                                           
         EXIT DISPLAY
      ON ACTION first 
         CALL q100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL q100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
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
 
      ON ACTION accept
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
