# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axrq020.4gl
# Descriptions...: 發票簿使用查詢
# Date & Author..: 95/02/08 By Danny
# Modify.........: No.MOD-4A0104 04/10/07 ching 筆數錯誤修改
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-560198 05/06/22 By ice 發票欄位加大后截位修改 
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.MOD-670066 06/07/14 By Nicola cnt1改為decimal(10,0)
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A40066 10/04/13 By xiaofeizhu oom04¦b¤£¦P·|­p¥\¯à®Éã¤£¦Pªº­È
# Modify.........: No.FUN-B90130 11/10/31 By wujie 大陆版时显示oom15 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     tm  RECORD
        	 wc     LIKE type_file.chr1000, #No.FUN-680123 VARCHAR(1000) # Head Where condition
                 wc2    LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(1000) # Body Where condition
        END RECORD,
     g_oom   RECORD LIKE oom_file.*,
    #g_cnt1  DECIMAL(10,0),                     #No.MOD-670066
     g_cnt1  LIKE oom_file.oom08,               #No.FUN-680123 DECIMAL(10,0)
     g_ome DYNAMIC ARRAY OF RECORD
            ome01   LIKE ome_file.ome01,
            ome02   LIKE ome_file.ome02,
            omevoid LIKE ome_file.omevoid,
            ome043  LIKE ome_file.ome043,
            ome59   LIKE ome_file.ome59,
            ome59x  LIKE ome_file.ome59x,
            ome59t  LIKE ome_file.ome59t
        END RECORD,
    g_tot1,g_tot2,g_tot3  LIKE ome_file.ome59,
    g_query_flag          LIKE type_file.num5,         #No.FUN-680123 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_wc,g_wc2,g_sql      string,                      #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b               LIKE type_file.num10         #No.FUN-680123 INTEGER  #單身筆數
 
DEFINE   g_cnt            LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE   g_msg            LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(72)
DEFINE   g_row_count      LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE   g_curs_index     LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE   g_jump           LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE   mi_no_ask        LIKE type_file.num5          #No.FUN-680123 SMALLINT
 
MAIN
#   DEFINE l_time	  LIKE type_file.chr8,         #計算被使用時間 #No.FUN-680123 VARCHAR(8)  #No.FUN-6A0095
    DEFINE
          l_sl            LIKE type_file.num5          #No.FUN-680123 SMALLINT 
   DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680123 SMALLINT
   OPTIONS                                             #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                    #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
    LET g_query_flag=1
    LET p_row = 3 LET p_col = 2
   #TQC-A40066--Mark-Begin                                                                                                          
   #OPEN WINDOW q020_w AT p_row,p_col                                                                                               
   #     WITH FORM "axr/42f/axrq020"                                                                                                
   #      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN                                                                
   #TQC-A40066--Mark-End                                                                                                            
#No.FUN-B90130 --begin   
#    IF g_aza.aza26 = '2' THEN                                                                                                       
#    OPEN WINDOW q020_w AT p_row,p_col                                                                                               
#         WITH FORM "gxr/42f/gxrq020"                                                                                                
#          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                   
#    ELSE                                                                                                                            
#    OPEN WINDOW q020_w AT p_row,p_col                                                                                               
#         WITH FORM "axr/42f/axrq020"                                                                                                
#          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                   
#    END IF                                                                                                                          
    #TQC-A40066--Add-End
    OPEN WINDOW q020_w AT p_row,p_col                                                                                         
         WITH FORM "axr/42f/axrq020"                                                                                                
          ATTRIBUTE (STYLE = g_win_style CLIPPED)  
    IF g_aza.aza26 <> '2' THEN CALL cl_set_comp_visible('oom15',FALSE) END IF 
#No.FUN-B90130 --end 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q020_q()
#    END IF
    CALL q020_menu()
    CLOSE WINDOW q020_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
END MAIN
 
#QBE 查詢資料
FUNCTION q020_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680123 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_ome.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_oom.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON oom01,oom02,oom021,oom03,oom04,oom15,oom05,oom06,oom07,   #No.FUN-B90130 add oom15 
                              oom08,oom09,oom10
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oomuser', 'oomgrup') #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
 
    #MOD-4A0104
  #CALL q020_b_askkey()
  #IF INT_FLAG THEN RETURN END IF
 
   MESSAGE ' WAIT ' 
   LET g_sql=" SELECT oom01,oom02,oom021,oom03,oom04,oom05,oom15 FROM oom_file ",  #No.FUN-B90130 add oom15 
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY oom01,oom02,oom021,oom03,oom04,oom05,oom15 "               #No.FUN-B90130 add oom15
   PREPARE q020_prepare FROM g_sql
   DECLARE q020_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q020_prepare
 
#No.FUN-560198 --start--                                                                                                            
#  LET g_sql=" SELECT COUNT (*) FROM " ,                                                                                            
#            " (SELECT oom01,oom02,oom021,oom03,oom04,oom05 FROM oom_file ",                                                        
#            "   WHERE ",tm.wc CLIPPED,                                                                                             
#            "   GROUP BY oom01,oom02,oom021,oom03,oom04,oom05 ) cnt_tmp "                                                          
   LET g_sql=" SELECT COUNT(*) ",                                                                                                   
             "   FROM oom_file ",                                                                                                   
             "   WHERE ",tm.wc CLIPPED                                                                                              
#No.FUN-560198 --end--               
 
   PREPARE q020_precount FROM g_sql
   DECLARE q020_count                         #SCROLL CURSOR
           SCROLL CURSOR FOR q020_precount
   #--
END FUNCTION
 
FUNCTION q020_b_askkey()
   CONSTRUCT tm.wc2 ON ome01,ome02,omevoid,ome043,ome59,ome59x,ome59t
                  FROM s_ome[1].ome01,s_ome[1].ome02,s_ome[1].omevoid,
                       s_ome[1].ome043,s_ome[1].ome59,
                       s_ome[1].ome59x,s_ome[1].ome59t
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
END FUNCTION
 
#中文的MENU
FUNCTION q020_menu()
 
   WHILE TRUE
      CALL q020_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q020_q()
            END IF
#           NEXT OPTION "next"
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ome),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q020_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
   #DISPLAY '   ' TO FORMONLY.cnt  
    CALL q020_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q020_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q020_count
        FETCH q020_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q020_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q020_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式   #No.FUN-680123 VARCHAR(1)
    l_abso          LIKE type_file.num10      #絕對的筆數 #No.FUN-680123 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q020_cs INTO g_oom.oom01,g_oom.oom02,g_oom.oom021,g_oom.oom03,g_oom.oom04,g_oom.oom05,g_oom.oom15    #No.FUN-B90130 add oom15  
        WHEN 'P' FETCH PREVIOUS q020_cs INTO g_oom.oom01,g_oom.oom02,g_oom.oom021,g_oom.oom03,g_oom.oom04,g_oom.oom05,g_oom.oom15    #No.FUN-B90130 add oom15  
        WHEN 'F' FETCH FIRST    q020_cs INTO g_oom.oom01,g_oom.oom02,g_oom.oom021,g_oom.oom03,g_oom.oom04,g_oom.oom05,g_oom.oom15    #No.FUN-B90130 add oom15  
        WHEN 'L' FETCH LAST     q020_cs INTO g_oom.oom01,g_oom.oom02,g_oom.oom021,g_oom.oom03,g_oom.oom04,g_oom.oom05,g_oom.oom15    #No.FUN-B90130 add oom15 
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
            FETCH ABSOLUTE  g_jump q020_cs INTO g_oom.oom01,g_oom.oom02,g_oom.oom021,g_oom.oom03,g_oom.oom04,g_oom.oom05,g_oom.oom15 #No.FUN-B90130 add oom15 
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oom.oom01,SQLCA.sqlcode,0)
        INITIALIZE g_oom.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_oom.* FROM oom_file WHERE oom01 = g_oom.oom01 AND oom02=g_oom.oom02 AND oom021=g_oom.oom021 AND oom03=g_oom.oom03 AND oom04=g_oom.oom04 AND oom05=g_oom.oom05 AND oom15 = g_oom.oom15  #No.FUN-B90130
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_oom.oom01,SQLCA.sqlcode,0)   #No.FUN-660116
        CALL cl_err3("sel","oom_file",g_oom.oom01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
        RETURN
    END IF
 
    CALL q020_show()
END FUNCTION
 
FUNCTION q020_show()
   #No.FUN-560198 --start--                                                                                                         
   IF NOT cl_null(g_oom.oom11) AND NOT cl_null(g_oom.oom12) THEN                                                                    
      LET g_cnt1=g_oom.oom08[g_oom.oom11,g_oom.oom12]                                                                               
                -g_oom.oom07[g_oom.oom11,g_oom.oom12]+1                                                                             
   ELSE                                                                                                                             
      LET g_cnt1=g_oom.oom08[3,10]-g_oom.oom07[3,10]+1                                                                              
   END IF                                                                                                                           
   #No.FUN-560198 --end-- 
         
   DISPLAY g_cnt1 TO cnt1 
   DISPLAY BY NAME g_oom.oom01, g_oom.oom02, g_oom.oom021,g_oom.oom03, 
                   g_oom.oom04,g_oom.oom15,    #No.FUN-B90130 add oom15                  
                   g_oom.oom05, g_oom.oom06, g_oom.oom07, g_oom.oom08,
                   g_oom.oom09, g_oom.oom10
                # 顯示單頭值
   CALL q020_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q020_b_fill()                        #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
             "SELECT ome01,ome02,omevoid,ome043,ome59,ome59x,ome59t ",
             "  FROM ome_file",
             " WHERE ome01 BETWEEN '",g_oom.oom07,"' AND '",g_oom.oom08,"'",
             "   AND ", tm.wc2 CLIPPED,
             " ORDER BY 1"
   PREPARE q020_pb FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('q020_pb',STATUS,0) END IF
   DECLARE q020_bcs                       #BODY CURSOR
       CURSOR WITH HOLD FOR q020_pb
 
   CALL g_ome.clear()
   LET g_cnt = 1
   LET g_tot1=0
   LET g_tot2=0
   LET g_tot3=0
   FOREACH q020_bcs INTO g_ome[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_ome[g_cnt].ome59 IS NULL THEN
	   LET g_ome[g_cnt].ome59 = 0 
        END IF
        IF g_ome[g_cnt].ome59x IS NULL THEN
  	       LET g_ome[g_cnt].ome59x = 0 
        END IF
        IF g_ome[g_cnt].ome59t IS NULL THEN
  	       LET g_ome[g_cnt].ome59t = 0 
        END IF
        IF g_ome[g_cnt].omevoid = 'N' THEN 
            LET g_tot1=g_tot1+g_ome[g_cnt].ome59
            LET g_tot2=g_tot2+g_ome[g_cnt].ome59x
            LET g_tot3=g_tot3+g_ome[g_cnt].ome59t
        END IF       
        IF cl_null(g_tot1) THEN LET g_tot1=0 END IF
        IF cl_null(g_tot2) THEN LET g_tot2=0 END IF
        IF cl_null(g_tot3) THEN LET g_tot3=0 END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
   END FOREACH
   #CKP
   CALL g_ome.deleteElement(g_cnt)
   DISPLAY g_tot1,g_tot2,g_tot3 TO tot1,tot2,tot3
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ome TO s_ome.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q020_fetch('L')
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
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
