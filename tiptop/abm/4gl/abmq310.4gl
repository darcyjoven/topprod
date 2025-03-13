# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Pattern name...: abmq310.4gl
# Descriptions...: 料件承認修改記錄查詢
# Date & Author..: 2003/03/10 By Hjwang (Ref aooq030.4gl)
# bugno..........: #6845
# Modify.........: No.FUN-4B0001 04/11/03 By Smapmin 料件編號開窗
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
 # Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
 
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
     DEFINE g_azv DYNAMIC ARRAY OF RECORD
           azv01         LIKE azv_file.azv01,
           azv10         LIKE azv_file.azv10,
           azv02         LIKE azv_file.azv02,
           mse02         LIKE mse_file.mse02,
           azv03         LIKE azv_file.azv03,
           pmc03         LIKE pmc_file.pmc03,
           azv07         LIKE azv_file.azv07,
           azv04         LIKE azv_file.azv04,
           azv08         LIKE azv_file.azv08,
           azv05         LIKE azv_file.azv05,
           azv09         LIKE azv_file.azv09,
           azv06         LIKE azv_file.azv06
                     END RECORD
    DEFINE g_argv1       LIKE rva_file.rva01    # INPUT ARGUMENT - 1
    DEFINE g_wc,g_sql 	 string                 #WHERE CONDITION  #No.FUN-580092 HCN
    DEFINE l_ac          LIKE type_file.num5    #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    DEFINE l_sl          LIKE type_file.num5    #目前處理的SCREEN LINE  #No.FUN-680096 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10,  #No.FUN-680096 INTEGER
         g_rec_b         LIKE type_file.num5    #單身筆數    #No.FUN-680096 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8	     #No.FUN-6A0060
    DEFINE l_sl		 LIKE type_file.num5    #No.FUN-680096 SMALLINT
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵，由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
 
 
    #計算使用時間 (進入時間)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
 
    LET p_row = 4 LET p_col = 4
        
    OPEN WINDOW q310_w AT p_row,p_col WITH FORM "abm/42f/abmq310" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
         
 
 
 
    #處理功能選擇
    CALL q310_menu()
 
    CLOSE WINDOW q310_w
 
    #計算使用時間 (退出使間)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
 
END MAIN
 
# Describe: QBE 查詢資料
 
FUNCTION q310_cs()
 
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680096 SMALLINT
 
   #清除畫面
   CLEAR FORM
   CALL g_azv.clear()
   CALL cl_opmsg('q')
 
   CONSTRUCT g_wc ON azv01,azv10,azv02,azv03,azv07,azv04,azv08,azv05,azv09,
                     azv06
       FROM  s_azv[1].azv01,s_azv[1].azv10,s_azv[1].azv02,s_azv[1].azv03,
             s_azv[1].azv07,s_azv[1].azv04,s_azv[1].azv08,s_azv[1].azv05,
             s_azv[1].azv09,s_azv[1].azv06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON ACTION CONTROLP #FUN-4B0001 
            IF INFIELD(azv01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azv"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azv01
               NEXT FIELD azv01
            END IF
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT azv01,azv10,azv02,'',azv03,'',azv07,azv04,azv08,azv05,",
                     "azv09,azv06 FROM azv_file ",
             " WHERE ",g_wc CLIPPED 
 
   PREPARE q310_prepare FROM g_sql
   DECLARE q310_cs CURSOR FOR q310_prepare
 
END FUNCTION
 
FUNCTION q310_menu()
   DEFINE   l_cmd    LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(80)
 
 
 
   WHILE TRUE
      CALL q310_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q310_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azv),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q310_q()
 
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cn2
 
    CALL q310_cs()
 
    IF INT_FLAG THEN 
        LET INT_FLAG = 0
        RETURN 
    END IF
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    END IF
 
    MESSAGE ''
    CALL q310_b_fill()
 
END FUNCTION
 
# Describe: BODY FILL UP
 
FUNCTION q310_b_fill()
 
    DEFINE l_sql     LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(1000)
    DEFINE l_za02    LIKE type_file.num5       #暫存指標 #No.FUN-680096 SMALLINT
 
    CALL g_azv.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH q310_cs INTO g_azv[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT mse02 INTO g_azv[g_cnt].mse02  FROM mse_file
                 WHERE mse01 = g_azv[g_cnt].azv02
        IF SQLCA.sqlcode THEN LET g_azv[g_cnt].mse02 = ' ' END IF
        SELECT pmc03 INTO g_azv[g_cnt].pmc03   FROM pmc_file
                 WHERE pmc01 = g_azv[g_cnt].azv03
        IF SQLCA.sqlcode THEN LET g_azv[g_cnt].pmc03 = ' ' END IF
 
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_cnt = g_cnt - 1
    CALL SET_COUNT(g_cnt)                    #告訴I.單身筆數
    LET g_rec_b=g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2 
 
END FUNCTION
 
FUNCTION q310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azv TO s_azv.*
 
      BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       #No.MOD-530688  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530688  --end   
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
