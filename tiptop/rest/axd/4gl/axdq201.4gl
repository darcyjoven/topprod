# Prog. Version..: '5.10.00-08.01.04(00000)'     #
# Pattern name...: axdq201.4gl
# Descriptions...: 料件集團調撥明細查詢             
# Date & Author..: 04/01/13 By Carrier
 # Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE 
    g_ade03   LIKE ade_file.ade03,
    g_ima02   LIKE ima_file.ima02,
    g_ima021  LIKE ima_file.ima021,
    g_ade     DYNAMIC ARRAY OF RECORD
              r        LIKE type_file.num5,   #No.FUN-680108 SMALLINT
              add01    LIKE add_file.add01,
              ade02    LIKE ade_file.ade02,
              add02    LIKE add_file.add02,
              ade06    LIKE ade_file.ade06,
              ade07    LIKE ade_file.ade07,
              ade04    LIKE ade_file.ade04,
              ade05    LIKE ade_file.ade05,
              ade12    LIKE ade_file.ade12,
              ade15    LIKE ade_file.ade15,
              ade13    LIKE ade_file.ade13,
              ade14    LIKE ade_file.ade14
              END RECORD,
    g_bdate,g_edate  LIKE type_file.dat,    #No.FUN-680108 DATE               
    g_ade_rowid      LIKE type_file.chr18,  #No.FUN-680108 INT
    g_wc,g_wc2,g_sql string,                #WHERE CONDITION  #No:FUN-580092 HCN
    g_argv1          LIKE ade_file.ade03,
    g_rec_b          LIKE type_file.num10,  #單身筆數   #No.FUN-680108 INTEGER
    g_j              LIKE type_file.num5,   #No.FUN-680108 SMALLINT
    g_ade05_t        LIKE ade_file.ade05,
    g_ade12_t        LIKE ade_file.ade12,
    g_ade15_t        LIKE ade_file.ade15
DEFINE   g_cnt       LIKE type_file.num10        #No.FUN-680108 INTEGER
DEFINE   g_msg       LIKE type_file.chr1000,     #No.FUN-680108 VARCHAR(72)
         l_ac        LIKE type_file.num5         #No.FUN-680108 SMALLINT

DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10     #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5      #No.FUN-680108 SMALLINT   #No.FUN-6A0078
                                                                                
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0091
      DEFINE   p_row,p_col   LIKE type_file.num5      #No.FUN-680108 SMALLINT

   OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091

   LET p_row = 3 LET p_col = 4 
   OPEN WINDOW q201_w AT p_row,p_col WITH FORM "axd/42f/axdq201"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()
    LET g_argv1 =  ARG_VAL(1)

#    IF cl_chk_act_auth() THEN
#       CALL q201_q()
#    END IF
    CALL q201_menu()    #中文
    CLOSE WINDOW q201_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION q201_cs()
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No:FUN-580031

   CLEAR FORM #清除畫
   CALL g_ade.clear()
   CALL cl_opmsg('q')
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_ade03 TO NULL    #No.FUN-750051
      CONSTRUCT g_wc ON ade03
                   FROM ade03

      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No:FUN-580031 --end--       HCN

      ON IDLE g_idle_seconds                                            
         CALL cl_on_idle()                                              
         CONTINUE CONSTRUCT                                             

      #No:FUN-580031 --start--       
      ON ACTION qbe_select          
          CALL cl_qbe_list() RETURNING lc_qbe_sn          
          CALL cl_qbe_display_condition(lc_qbe_sn)       
      #No:FUN-580031 ---end--- 

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      END CONSTRUCT 
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = " ade03 = '",g_argv1,"'"
   END IF

   LET g_bdate = g_today
   LET g_edate = g_today

   INPUT g_bdate,g_edate WITHOUT DEFAULTS
         FROM FORMONLY.bdate,FORMONLY.edate

      AFTER FIELD edate
        IF g_edate < g_bdate THEN NEXT FIELD bdate END IF

      ON IDLE g_idle_seconds                                  
        CALL cl_on_idle()                                                       
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
   IF INT_FLAG THEN RETURN END IF
         
   CONSTRUCT g_wc2 ON add01,ade02,add02,ade06,ade07,ade04,ade05,
                     ade12,ade15,ade13,ade14
                FROM s_sr[1].add01,s_sr[1].ade02,s_sr[1].add02,
                     s_sr[1].ade06,s_sr[1].ade07,s_sr[1].ade04,
                     s_sr[1].ade05,s_sr[1].ade12,s_sr[1].ade15,
                     s_sr[1].ade13,s_sr[1].ade14

      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 --end--       HCN

      ON IDLE g_idle_seconds                                            
         CALL cl_on_idle()                                              
         CONTINUE CONSTRUCT                                             

      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
                                                                                
   END CONSTRUCT 
   IF INT_FLAG THEN RETURN END IF

   MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
   LET g_sql="SELECT DISTINCT ade03 ",
             "  FROM ade_file,add_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND add02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
             "   AND add01 = ade01 AND ",g_wc2 CLIPPED,
             "   AND addconf = 'Y' AND addacti = 'Y' ",
             "   AND add06 = '1' ",
             " ORDER BY 1 "
   PREPARE q201_prepare FROM g_sql
   IF STATUS THEN CALL cl_err('q201_pre',STATUS,1) END IF
   DECLARE q201_cs SCROLL CURSOR WITH HOLD FOR q201_prepare

   LET g_sql="SELECT COUNT(distinct ade03)",                               
             "  FROM ade_file,add_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND add02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
             "   AND add01 = ade01 AND ",g_wc2 CLIPPED,
             "   AND addconf = 'Y' AND addacti = 'Y' ",
             "   AND add06 = '1' "
   PREPARE q201_precount FROM g_sql                                            
   DECLARE q201_count CURSOR FOR q201_precount
--## 2004/02/06 by Hiko : 為了上下筆資料所做的設定.                             
   OPEN q201_count                                                                
   FETCH q201_count INTO g_row_count                                              
   CLOSE q201_count    
END FUNCTION

FUNCTION q201_menu()
   WHILE TRUE
      CALL q201_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q201_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION q201_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""    
    CALL cl_opmsg('q')
    CALL q201_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "Waiting...." ATTRIBUTE(REVERSE)                                    
        OPEN q201_count                                                         
        FETCH q201_count INTO g_row_count                                            
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)                      
    OPEN q201_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
      ELSE
        CALL q201_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION

FUNCTION q201_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式        #No.FUN-680108 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數      #No.FUN-680108 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     q201_cs INTO g_ade03
        WHEN 'P' FETCH PREVIOUS q201_cs INTO g_ade03
        WHEN 'F' FETCH FIRST    q201_cs INTO g_ade03
        WHEN 'L' FETCH LAST     q201_cs INTO g_ade03
        WHEN '/'
            IF (NOT mi_no_ask) THEN     #No.FUN-6A0078
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
#            PROMPT g_msg CLIPPED,': ' FOR l_abso
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump 
               ON IDLE g_idle_seconds                                           
                  CALL cl_on_idle()                                             
#                  CONTINUE PROMPT                                              
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                                                                                
            END PROMPT     
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump q201_cs INTO g_ade03
            LET mi_no_ask = FALSE    #No.FUN-6A0078
    END CASE
    #No.TQC-6B0105  --Begin
    IF STATUS THEN 
       INITIALIZE g_ade03 TO NULL  #TQC-6B0105
       CALL cl_err(g_ade03,STATUS,0) RETURN 
    END IF
    #No.TQC-6B0105  --End   
       CASE p_flag                                                              
          WHEN 'F' LET g_curs_index = 1                                        
          WHEN 'P' LET g_curs_index = g_curs_index - 1                        
          WHEN 'N' LET g_curs_index = g_curs_index + 1                        
          WHEN 'L' LET g_curs_index = g_row_count                             
          WHEN '/' LET g_curs_index = g_jump                                   
       END CASE                                                                 
       CALL cl_navigator_setting( g_curs_index, g_row_count ) 
    CALL q201_show()
END FUNCTION

FUNCTION q201_show()
   SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file
    WHERE ima01 = g_ade03
   DISPLAY g_ade03  TO ade03 ATTRIBUTE(YELLOW)  # 顯示單頭值
   DISPLAY g_ima02  TO FORMONLY.ima02 ATTRIBUTE(YELLOW)  # 顯示單頭值
   DISPLAY g_ima021 TO FORMONLY.ima021 ATTRIBUTE(YELLOW)  # 顯示單頭值
   CALL q201_b_fill() #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION q201_b_fill()              #BODY FILL UP
    DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

    LET l_sql = "SELECT 0,add01,ade02,add02,ade06,ade07,",
                "       ade04,ade05,ade12,ade15,ade13,ade14",
                "  FROM ade_file,add_file ",
                " WHERE ade03 = '",g_ade03,"'",
                "   AND add01 = ade01 ",  
                "   AND add02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                "   AND addconf = 'Y' AND addacti = 'Y' ",
                "   AND add06 = '1' ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY 1,2 "
    PREPARE q201_pre2 FROM l_sql
    IF STATUS THEN CALL cl_err('q201_pre2',STATUS,1) END IF 
    DECLARE q201_bcs CURSOR FOR q201_pre2

    LET g_cnt = 1
    LET g_ade05_t = 0
    LET g_ade12_t = 0
    LET g_ade15_t = 0
    FOREACH q201_bcs INTO g_ade[g_cnt].*
        IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_ade[g_cnt].r = g_cnt
        LET g_ade05_t = g_ade05_t + g_ade[g_cnt].ade05
        LET g_ade12_t = g_ade12_t + g_ade[g_cnt].ade12
        LET g_ade15_t = g_ade15_t + g_ade[g_cnt].ade15
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ade.deleteElement(g_cnt)  
    DISPLAY g_ade05_t TO FORMONLY.ade05_t
    DISPLAY g_ade12_t TO FORMONLY.ade12_t
    DISPLAY g_ade15_t TO FORMONLY.ade15_t
END FUNCTION

FUNCTION q201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)


   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ade TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q201_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF            
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION previous
         CALL q201_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF            
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION jump 
         CALL q201_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF            
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION next
         CALL q201_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF            
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION last
         CALL q201_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF            
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

   ON ACTION accept
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

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

