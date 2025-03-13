# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amsq520.4gl
# Descriptions...: MPS 版本查詢
# Date & Author..: 96/05/15  By  Roger
# Modify.........: No.FUN-4B0014 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.FUN-560254 05/06/29 By Carol run shell 產生的問題 
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6C0158 06/12/26 By day 單身匯出excel多一空白行
# Modify.........: No.TQC-6C0192 06/12/27 By day  查詢時要開放其他欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_mpr           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mpr_v       LIKE mpr_file.mpr_v,   
        mpr01       LIKE mpr_file.mpr01,   
        mpr02       LIKE mpr_file.mpr02,  
        mpr03       LIKE mpr_file.mpr03,  
        mpr04       LIKE mpr_file.mpr04,  
        mpr05       LIKE mpr_file.mpr05
                    END RECORD,
     g_wc2           string,  #No.FUN-580092 HCN
     g_sql           string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #NO.FUN-680101 SMALLINT   #單身筆數
    l_ac            LIKE type_file.num5,     #NO.FUN-680101 SMALLINT   #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5      #NO.FUN-680101 SMALLINT   #目前處理的SCREEN LINE
 
DEFINE   g_cnt      LIKE type_file.num10     #NO.FUN-680101 INTEGER
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0081
DEFINE p_row,p_col  LIKE type_file.num5      #NO.FUN-680101 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 4 LET p_col = 8 
    OPEN WINDOW q520_w AT p_row,p_col WITH FORM "ams/42f/amsq520"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
 
 
    LET g_wc2 = '1=1' CALL q520_b_fill(g_wc2)
    CALL q520_menu()
    CLOSE WINDOW q520_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
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
#FUN-4B0014
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mpr),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q520_q()
   CALL q520_b_askkey()
END FUNCTION
 
FUNCTION q520_b_askkey()
    CLEAR FORM
   CALL g_mpr.clear()
    #No.TQC-6C0192--begin
#   CONSTRUCT g_wc2 ON mpr01,mpr02,mpr03
#           FROM s_mpr[1].mpr01,s_mpr[1].mpr02,s_mpr[1].mpr03 
    CONSTRUCT g_wc2 ON mpr_v,mpr01,mpr02,mpr03,mpr04,mpr05
            FROM s_mpr[1].mpr_v,s_mpr[1].mpr01,s_mpr[1].mpr02,s_mpr[1].mpr03,
                 s_mpr[1].mpr04,s_mpr[1].mpr05 
    #No.TQC-6C0192--end  
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
    p_wc2           LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(200)
 
    LET g_sql =
        "SELECT mpr_v,mpr01,mpr02,mpr03,mpr04,mpr05",
        " FROM mpr_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE q520_pb FROM g_sql
    DECLARE mpr_curs CURSOR FOR q520_pb
 
    FOR g_cnt = 1 TO g_mpr.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_mpr[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH mpr_curs INTO g_mpr[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_mpr.deleteElement(g_cnt)  #No.TQC-6C0158
    MESSAGE ""
    LET g_rec_b = g_cnt-1
END FUNCTION
 
FUNCTION q520_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
#FUN-560254-modify
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mpr TO s_mpr.* ATTRIBUTE(COUNT= g_rec_b, UNBUFFERED)
 
      BEFORE ROW
        LET l_ac = ARR_CURR()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#FUN-560254-end
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
 
 
#FUN-4B0014
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
  
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
