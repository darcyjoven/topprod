# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: armq100.4gl
# Descriptions...: 修復狀況查詢
# Date & Author..: 98/02/25 by  plum
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-560255 05/06/28 By Mandy 在已MARK掉的BEFORE ROW段加CALL cl_show_fld_cont()是不對的,所以將CALL cl_show_fld_cont() MARK掉
# Modify.........: No.MOD-640452 06/04/19 By Sarah 增加顯示rmc26,rmc29,rmc30三個欄位
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
 
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_rmc          DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        rmc01       LIKE rmc_file.rmc01,  
        rmc02       LIKE rmc_file.rmc02,  
        rmc04       LIKE rmc_file.rmc04,  
        rmc06       LIKE rmc_file.rmc06,  
        rmc061      LIKE rmc_file.rmc061,  
        rmc05       LIKE rmc_file.rmc05,  
        rmc31       LIKE rmc_file.rmc31,  
        rmc23       LIKE rmc_file.rmc23,  
        rmc07       LIKE rmc_file.rmc07,  
        rmc21       LIKE rmc_file.rmc21, 
        rmc22       LIKE rmc_file.rmc22, 
        rmc14       LIKE rmc_file.rmc14,  
        rmc08       LIKE rmc_file.rmc08,  
        rma03       LIKE rma_file.rma03,  
        rma04       LIKE rma_file.rma04,     
        rmc32       LIKE rmc_file.rmc32,
        rmc26       LIKE rmc_file.rmc26,   #MOD-640452 add
        rmc29       LIKE rmc_file.rmc29,   #MOD-640452 add
        rmc30       LIKE rmc_file.rmc30    #MOD-640452 add
                    END RECORD,
    g_wc2           STRING,  #No.FUN-580092 HCN
    g_sql           STRING,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-690010 SMALLINT               #目前處理的SCREEN LINE
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0085
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET p_row = 4 LET p_col = 2 
    OPEN WINDOW q100_w AT p_row,p_col WITH FORM "arm/42f/armq100"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL q100_q()
    WHILE TRUE
       LET g_action_choice = ''
       CALL q100_menu()
       IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE 
    CLOSE WINDOW q100_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION q100_menu()
 
   WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q100_q() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmc),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q100_q()
   CALL q100_b_askkey()
   IF INT_FLAG THEN LET INT_FLAG=0 CLEAR FORM RETURN END IF
END FUNCTION
 
FUNCTION q100_b_askkey()
    CLEAR FORM
    CALL g_rmc.clear()
    CONSTRUCT g_wc2 ON rmc01,rmc02,rmc04,rmc06,rmc061,rmc05,rmc31,rmc23,
                       rmc07,rmc21,rmc22,rmc14,rmc08,rma03,rma04,rmc32,
                       rmc26,rmc29,rmc30   #MOD-640452 add
       FROM s_rmc[1].rmc01,s_rmc[1].rmc02,s_rmc[1].rmc04,s_rmc[1].rmc06,s_rmc[1].rmc061,
            s_rmc[1].rmc05,s_rmc[1].rmc31,s_rmc[1].rmc23,
            s_rmc[1].rmc07,s_rmc[1].rmc21,s_rmc[1].rmc22,s_rmc[1].rmc14,
            s_rmc[1].rmc08,s_rmc[1].rma03,s_rmc[1].rma04,s_rmc[1].rmc32,
            s_rmc[1].rmc26,s_rmc[1].rmc29,s_rmc[1].rmc30   #MOD-640452 add
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    CALL q100_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q100_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(600)
 
    LET g_sql = "SELECT rmc01,rmc02,rmc04,rmc06,rmc061,rmc05,rmc31,rmc23,",
                "       rmc07,rmc21,rmc22,rmc14,rmc08,rma03,rma04,rmc32, ",
                "       rmc26,rmc29,rmc30 ",   #MOD-640452 add
       		" FROM rmc_file LEFT JOIN rma_file ON rmc01=rma_file.rma01",
       		" WHERE ", p_wc2 CLIPPED,                     #單身
       		" ORDER BY rmc01,rmc02"
    PREPARE q100_pb FROM g_sql
    DECLARE rmc_curs CURSOR FOR q100_pb
 
    CALL g_rmc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rmc_curs INTO g_rmc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
END FUNCTION
 
FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmc TO s_rmc.* ATTRIBUTE(COUNT=g_rec_b)
 
      #BEFORE ROW
         #LET l_ac = ARR_CURR()
         #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf #FUN-560255 MARK
         #LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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
 
 
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
