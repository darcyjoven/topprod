# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: gxcq110
# Descriptions...: 成本月結資料查詢作業
# Date & Author..: 2004/02/23 By Elva
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770001 07/07/02 By sherry 點擊"幫助"按鈕無效
# Modify.........: No.FUN-7C0101 08/01/10 By ChenMoyan 新增cxb010,cxb011,cxb096,cxb097,cxb098
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       tm       RECORD
                wc          LIKE type_file.chr1000   #NO.FUN-680145 VARCHAR(500)   # Head Where condition
                END RECORD,
       g_cxb01  LIKE cxb_file.cxb01,               # 料件編號
       g_ima02  LIKE ima_file.ima02,               # 品名
       g_ima25  LIKE ima_file.ima25,               # 單位
       g_cxb02  LIKE cxb_file.cxb02,               # 年度
       g_cxb03  LIKE cxb_file.cxb03,               # 月份
       g_cxb010 LIKE cxb_file.cxb010,              #No.FUN-7C0101 
       g_cxb011 LIKE cxb_file.cxb011,              #No.FUN-7C0101 
       g_argv1  LIKE cxb_file.cxb01,               # 
       g_argv2  LIKE cxb_file.cxb02,               # 
       g_argv3  LIKE cxb_file.cxb03,               # 
       g_argv4  LIKE cxb_file.cxb010,              #No.FUN-7C0101
       g_argv5  LIKE cxb_file.cxb011,              #No.FUN-7C0101
       g_cxb    DYNAMIC ARRAY OF RECORD
                cxb04   LIKE cxb_file.cxb04,       # 異動日期
                cxb05   LIKE cxb_file.cxb05,       # 異動時間
                cxb06   LIKE cxb_file.cxb06,       # 異動單號        
                cxb07   LIKE cxb_file.cxb07,       # 項次             
                cxb08   LIKE cxb_file.cxb08,       # 異動數量       
                cxb09   LIKE cxb_file.cxb09,       # 異動金額            
                cxb091  LIKE cxb_file.cxb091,      # 材料
                cxb092  LIKE cxb_file.cxb092,      # 人工
                cxb093  LIKE cxb_file.cxb093,      # 制費
                cxb094  LIKE cxb_file.cxb094,      # 加工
                cxb095  LIKE cxb_file.cxb095       # 其他
               ,cxb096  LIKE cxb_file.cxb096,      #No.FUN-7C0101
                cxb097  LIKE cxb_file.cxb097,      #No.FUN-7C0101 
                cxb098  LIKE cxb_file.cxb098       #No.FUN-7C0101        
     	        END RECORD,
       g_query_flag    LIKE type_file.num5,        #NO.FUN-680145 SMALLINT   #第一次進入程式時即進入Query之後進入N.下筆
        g_sql          string, #WHERE CONDITION  #No.FUN-580092 HCN
       g_rec_b          LIKE type_file.num5        #NO.FUN-680145 SMALLINT   #單身筆數
 
DEFINE p_row,p_col  LIKE type_file.num5          #NO.FUN-680145 SMALLINT
DEFINE   g_cnt      LIKE type_file.num10         #NO.FUN-680145 INTEGER                                              
DEFINE   g_msg      LIKE type_file.chr1000       #NO.FUN-680145 VARCHAR(72)                                             
DEFINE   g_row_count     LIKE type_file.num10         #NO.FUN-680145 INTEGER                                             
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680145 INTEGER
 DEFINE   g_jump         LIKE type_file.num10    #NO.FUN-680145 INTEGER
 DEFINE   mi_no_ask      LIKE type_file.num5     #NO.FUN-680145 SMALLINT
DEFINE   l_ac	 	 LIKE type_file.num5     #NO.FUN-680145 SMALLINT
 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0099
 
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
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
         RETURNING g_time    #No.FUN-6A0099
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1)
    LET g_argv2      = ARG_VAL(2)          #參數值(2)
    LET g_argv3      = ARG_VAL(3)          #參數值(3)
    LET g_argv4      = ARG_VAL(4)          #No.FUN-7C0101
    LET g_argv5      = ARG_VAL(5)          #No.FUN-7C0101
    LET p_row = 2 LET p_col = 15
 
 OPEN WINDOW q110_w AT p_row,p_col
       WITH FORM "gxc/42f/gxcq110" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL q110_menu()
    CLOSE WINDOW q110_w
      CALL  cl_used(g_prog,g_time,2)          #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
         RETURNING g_time    #No.FUN-6A0099
END MAIN
 
#QBE 查詢資料
FUNCTION q110_cs()
   DEFINE   l_cnt    LIKE type_file.num5      #NO.FUN-680145 SMALLINT
   DEFINE   l_cxb010 LIKE cxb_file.cxb010     #No.FUN-7C0101
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "cxb01 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET tm.wc = tm.wc CLIPPED," AND cxb02 = ",g_argv2
      END IF
      IF NOT cl_null(g_argv3) THEN
         LET tm.wc = tm.wc CLIPPED," AND cxb03 = ",g_argv3
      END IF
      #No.FUN-7C0101--Begin
      IF NOT cl_null(g_argv4) THEN                                                                                                  
         LET tm.wc = tm.wc CLIPPED," AND cxb010 = ",g_argv4                                                                          
      END IF
      IF NOT cl_null(g_argv5) THEN                                                                                                  
         LET tm.wc = tm.wc CLIPPED," AND cxb011 = ",g_argv5                                                                          
      END IF
      #No.FUN-7C0101--End
   ELSE CLEAR FORM #清除畫面
        CALL g_cxb.clear() 
      CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL	      # Default condition
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_cxb01 TO NULL    #No.FUN-750051
   INITIALIZE g_cxb02 TO NULL    #No.FUN-750051
   INITIALIZE g_cxb03 TO NULL    #No.FUN-750051
   INITIALIZE g_cxb010 TO NULL   #No.FUN-7C0101
   INITIALIZE g_cxb011 TO NULL   #No.FUN-7C0101 
#     CONSTRUCT tm.wc ON cxb01,cxb02,cxb03,cxb04,cxb05,cxb06,cxb07,
      CONSTRUCT tm.wc ON cxb01,cxb02,cxb03,cxb010,cxb011,cxb04,cxb05,cxb06,cxb07, #No.FUN-7C0101 
                         cxb08,cxb09,cxb091,cxb092,cxb093,cxb094,cxb095
                        ,cxb096,cxb097,cxb098                                 #No.FUN-7C0101 
#                   FROM cxb01,cxb02,cxb03,s_cxb[1].cxb04, s_cxb[1].cxb05,    #No.FUN-7C0101 
                    FROM cxb01,cxb02,cxb03,cxb010,cxb011,s_cxb[1].cxb04, s_cxb[1].cxb05,    #No.FUN-7C0101
                         s_cxb[1].cxb06, s_cxb[1].cxb07, s_cxb[1].cxb08,
                         s_cxb[1].cxb09, s_cxb[1].cxb091,s_cxb[1].cxb092,
                         s_cxb[1].cxb093,s_cxb[1].cxb094,s_cxb[1].cxb095
                        ,s_cxb[1].cxb096,s_cxb[1].cxb097,s_cxb[1].cxb098     #No.FUN-7C0101 
              
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       #No.FUN-7C0101--start--                                                                                                      
       AFTER FIELD cxb010                                                                                                            
              LET l_cxb010 = get_fldbuf(cxb010)                                                                                       
       #No.FUN-7C0101---end--- 
        #MOD-530850                                                                
       ON ACTION CONTROLP                                                         
         CASE                                                                    
          WHEN INFIELD(cxb01)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_ima"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_cxb01                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            DISPLAY g_qryparam.multiret TO cxb01                                
            NEXT FIELD cxb01 
#No.FUN-7C0101 --Begin                   
         WHEN INFIELD(cxb011)
            CALL cl_init_qry_var()
            IF l_cxb010 MATCHES '[45]' THEN
              IF l_cxb010 = '4' THEN
                LET g_qryparam.form = "q_pja"
              END IF
              IF l_cxb010 = '5' THEN
                LET g_qryparam.form = "q_gem4"
              END IF
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_cxb011
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO cxb011
              NEXT FIELD cxb011           
           END IF
#No.FUN-7C0101 --End                     
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
#  LET g_sql="SELECT UNIQUE cxb01,cxb02,cxb03 FROM cxb_file ",                 #No.FUN-7C0101 
   LET g_sql="SELECT UNIQUE cxb01,cxb02,cxb03,cxb010,cxb011 FROM cxb_file ",   #No.FUN-7C0101
             " WHERE ",tm.wc CLIPPED ,
#            " ORDER BY cxb01,cxb02,cxb03 "                                    #No.FUN-7C0101 
            " ORDER BY cxb01,cxb02,cxb03,cxb010,cxb011 "                       #No.FUN-7C0101
   PREPARE q110_prepare FROM g_sql
   DECLARE q110_cs                         #SCROLL CURSOR
    SCROLL CURSOR FOR q110_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
#  LET g_sql=" SELECT UNIQUE cxb01,cxb02,cxb03 FROM cxb_file ",                #No.FUN-7C0101 
   LET g_sql=" SELECT UNIQUE cxb01,cxb02,cxb03,cxb010,cxb011 FROM cxb_file ",  #No.FUN-7C0101
             " WHERE ",tm.wc CLIPPED ,
             " INTO TEMP x "
   DROP TABLE x
   PREPARE q110_precount_x FROM g_sql
   EXECUTE q110_precount_x
 
   LET g_sql=" SELECT COUNT(*) FROM x "
   PREPARE q110_pp FROM g_sql
   DECLARE q110_cnt CURSOR FOR q110_pp
END FUNCTION
 
FUNCTION q110_menu()
    WHILE TRUE
      CALL q110_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q110_q()
            END IF
         WHEN "help" 
       #    CALL SHOWHELP(1)    #No.TQC-770001
            CALL cl_show_help() #No.TQC-770001  
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q110_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q110_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q110_cnt
        FETCH q110_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
        CALL q110_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q110_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,         #NO.FUN-680145  VARCHAR(1)   #處理方式
    l_abso          LIKE type_file.num10         #NO.FUN-680145  INTEGER   #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q110_cs INTO g_cxb01,g_cxb02,g_cxb03
                                            ,g_cxb010,g_cxb011               #No.FUN-7C0101
        WHEN 'P' FETCH PREVIOUS q110_cs INTO g_cxb01,g_cxb02,g_cxb03
                                            ,g_cxb010,g_cxb011               #No.FUN-7C0101
        WHEN 'F' FETCH FIRST    q110_cs INTO g_cxb01,g_cxb02,g_cxb03
                                            ,g_cxb010,g_cxb011               #No.FUN-7C0101
        WHEN 'L' FETCH LAST     q110_cs INTO g_cxb01,g_cxb02,g_cxb03
                                            ,g_cxb010,g_cxb011               #No.FUN-7C0101
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
          FETCH ABSOLUTE g_jump q110_cs INTO g_cxb01,g_cxb02,g_cxb03
                                            ,g_cxb010,g_cxb011               #No.FUN-7C0101
          LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cxb01,SQLCA.sqlcode,0)
        INITIALIZE g_cxb01 TO NULL  #TQC-6B0105
        INITIALIZE g_cxb02 TO NULL  #TQC-6B0105
        INITIALIZE g_cxb03 TO NULL  #TQC-6B0105
        INITIALIZE g_cxb010 TO NULL #No.FUN-7C0101
        INITIALIZE g_cxb011 TO NULL #No.FUN-7C0101   
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
    CALL q110_show()
END FUNCTION
 
FUNCTION q110_show()
   DISPLAY g_cxb01 TO cxb01 #ATTRIBUTE(YELLOW)  # 顯示單頭值 
   DISPLAY g_cxb02 TO cxb02 #ATTRIBUTE(YELLOW)  # 顯示單頭值
   DISPLAY g_cxb03 TO cxb03 #ATTRIBUTE(YELLOW)  # 顯示單頭值
   DISPLAY g_cxb010 TO cxb010                   #No.FUN-7C0101   
   DISPLAY g_cxb011 TO cxb011                   #No.FUN-7C0101   
   SELECT ima02,ima25 INTO g_ima02,g_ima25 FROM ima_file WHERE ima01 = g_cxb01 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_cxb02,SQLCA.sqlcode,0)   #No.FUN-660146
      CALL cl_err3("sel","ima_file",g_cxb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660146
      RETURN
   END IF
   DISPLAY g_ima02,g_ima25 TO ima02,ima25
   CALL q110_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q110_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 #NO.FUN-680145 VARCHAR(1000)
#   DEFINE l_tot     LIKE ima_file.ima26    #NO.FUN-680145 DECIMAL(15,3)  #FUN-A20044
   DEFINE l_tot     LIKE type_file.num15_3    #NO.FUN-680145 DECIMAL(15,3)  #FUN-A20044
 
   LET l_sql =
        "SELECT cxb04,cxb05,cxb06,cxb07,cxb08,cxb09,cxb091,",
        "       cxb092,cxb093,cxb094,cxb095 ",
        "      ,cxb096,cxb097,cxb098",     #No.FUN-7C0101 
        "  FROM cxb_file ",
        " WHERE cxb01 = '",g_cxb01,"'",
        "   AND cxb02 =  ",g_cxb02,
        "   AND cxb03 =  ",g_cxb03,
        "   AND cxb010 = '",g_cxb010,"'",       #No.FUN-7C0101
        "   AND cxb011 = '",g_cxb011,"'",       #No.FUN-7C0101
        "   AND ", tm.wc CLIPPED,
        " ORDER BY cxb04"
    PREPARE q110_pb FROM l_sql
    DECLARE q110_bcs                       #BODY CURSOR
     CURSOR FOR q110_pb
 
    CALL g_cxb.clear() 
    LET g_rec_b= 0
    LET g_cnt  = 1
    FOREACH q110_bcs INTO g_cxb[g_cnt].*
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
    CALL g_cxb.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
END FUNCTION
 
FUNCTION q110_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1) 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cxb TO s_cxb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
      ON ACTION first 
         CALL q110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL q110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q110_fetch('L')
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
