# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amrq520.4gl
# Descriptions...: MRP 版本查詢
# Date & Author..: 96/05/15  By  Roger
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: NO.FUN-560254 05/06/29 By Carol run shell 產生的問題 
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: NO.TQC-770017 07/07/09 By wujie 1:匯出excel多一行空白                                                            
#                                                  2:不能以"版本"進行查詢
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_msr           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        msr_v        LIKE msr_file.msr_v,   
        msr01        LIKE msr_file.msr01,   
        msr02        LIKE msr_file.msr02,  
        msr03        LIKE msr_file.msr03,  
        msr04        LIKE msr_file.msr04,  
        msr05        LIKE msr_file.msr05
                    END RECORD,
     g_wc2           STRING,     #No.FUN-580092 HCN       
     g_sql           STRING,     #No.FUN-580092 HCN       
     g_rec_b         LIKE type_file.num5,       #單身筆數                #NO.FUN-680082 SMALLINT
     l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT     #NO.FUN-680082 SMALLINT
     l_sl            LIKE type_file.num5,       #目前處理的SCREEN LINE   #NO.FUN-680082 SMALLINT
     p_row,p_col     LIKE type_file.num5        #目前處理的SCREEN LINE   #NO.FUN-680082 SMALLINT
 
DEFINE   g_cnt       LIKE type_file.num10       #NO.FUN-680082 INTEGER
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0076
 
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
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW q520_w AT p_row,p_col WITH FORM "amr/42f/amrq520"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL q520_b_fill(g_wc2)
    CALL q520_menu()
    CLOSE WINDOW q520_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
FUNCTION q520_menu()
 
   WHILE TRUE
      CALL q520_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q520_q()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_msr),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q520_q()
   CALL q520_b_askkey()
END FUNCTION
 
FUNCTION q520_b_askkey()
    CLEAR FORM
   CALL g_msr.clear()
    CONSTRUCT g_wc2 ON msr_v,msr01,msr02,msr03      #No.TQC-770017
            FROM s_msr[1].msr_v, s_msr[1].msr01,s_msr[1].msr02,s_msr[1].msr03      #No.TQC-770017 
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q520_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q520_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000    #NO.FUN-680082 VARCHAR(600)
 
    LET g_sql =
        "SELECT msr_v,msr01,msr02,msr03,msr04,msr05",
        " FROM msr_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE q520_pb FROM g_sql
    DECLARE msr_curs CURSOR FOR q520_pb
    DISPLAY g_sql
    CALL g_msr.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH msr_curs INTO g_msr[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    MESSAGE ""
#No.TQC-770017--begin                                                                                                               
    CALL g_msr.deleteElement(g_cnt)                                                                                                 
#No.TQC-770017--end 
    LET g_rec_b = g_cnt-1
 
END FUNCTION
 
FUNCTION q520_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_msr TO s_msr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
#FUN-560254
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#FUN-560254-end
 
      ON ACTION query
         LET g_action_choice="query"
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
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
 
 
      #FUN-4B0013
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
