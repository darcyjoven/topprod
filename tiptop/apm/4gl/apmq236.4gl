# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmq236.4gl
# Descriptions...: 已收貨等待入庫查詢   
# Date & Author..: 02/09/27 By nicola 
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
   g_rvb           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
      rva06        LIKE rva_file.rva06,   #收貨日期
      rva01        LIKE rva_file.rva01,   #收貨單號
      rva05        LIKE rva_file.rva05,   #供應商編號
      pmc03        LIKE pmc_file.pmc03,   #供應商名稱
      rvb02        LIKE rvb_file.rvb02,   #收貨單項次
      rvb05        LIKE rvb_file.rvb05,   #料件編號
      rvb39        LIKE rvb_file.rvb39,   #檢驗碼 no.7143
      rvb07        LIKE rvb_file.rvb07,   #實收數量
      rvb33        LIKE rvb_file.rvb33,   #充收數量
      rvb30        LIKE rvb_file.rvb30,   #入庫量
      rvb29        LIKE rvb_file.rvb29    #退貨量
                   END RECORD,
   g_rvb_t         RECORD                 #程式變數(舊值)
      rva06        LIKE rva_file.rva06,   #收貨日期
      rva01        LIKE rva_file.rva01,   #收貨單號
      rva05        LIKE rva_file.rva05,   #供應商編號
      pmc03        LIKE pmc_file.pmc03,   #供應商名稱
      rvb02        LIKE rvb_file.rvb02,   #收貨單項次
      rvb05        LIKE rvb_file.rvb05,   #料件編號
      rvb39        LIKE rvb_file.rvb39,   #檢驗碼 #no.7143
      rvb07        LIKE rvb_file.rvb07,   #實收數量
      rvb33        LIKE rvb_file.rvb33,   #充收數量
      rvb30        LIKE rvb_file.rvb30,   #入庫量
      rvb29        LIKE rvb_file.rvb29    #退貨量
                   END RECORD,
    g_wc,g_sql,g_wc2    string,  #No.FUN-580092 HCN
   g_show          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1) 
   g_rec_b         LIKE type_file.num5,    #單身筆數 #No.FUN-680136 SMALLINT
   g_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   g_ss            LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   g_ver           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
   l_sl            LIKE type_file.num5     #No.FUN-680136 SMALLINT  #目前處理的SCREEN LINE
DEFINE p_row,p_col LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE   g_cnt     LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_msg     LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
 
 
#主程式開始
MAIN
   DEFINE
      l_time       LIKE type_file.chr8     #計算被使用時間        #No.FUN-680136 VARCHAR(8)
  
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL cl_used(g_prog,l_time,1)          #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
      RETURNING l_time 
      LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q236_w AT p_row,p_col
       WITH FORM "apm/42f/apmq236" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
#   IF cl_chk_act_auth() THEN
#      CALL q236_q()
#   END IF
   CALL q236_menu()
 
   CLOSE WINDOW q236_w                      #結束畫面
     CALL cl_used(g_prog,l_time,2)  #No.MOD-580088  HCN 20050818
      RETURNING l_time
END MAIN
 
#QBE 查詢資料
FUNCTION q236_cs()
    CLEAR FORM                               #清除畫面
    CALL g_rvb.clear()
    CONSTRUCT g_wc ON rva06,rva01,rva05,pmc03,rvb02,rvb05,rvb39,rvb07,
                      rvb33,rvb30,rvb29
    FROM s_rvb[1].rva06,s_rvb[1].rva01,s_rvb[1].rva05,
         s_rvb[1].pmc03,s_rvb[1].rvb02,s_rvb[1].rvb05,
         s_rvb[1].rvb39,s_rvb[1].rvb07,s_rvb[1].rvb33,
         s_rvb[1].rvb30,s_rvb[1].rvb29  #no.7143 rva20->rvb39
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
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
LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
 
    LET g_sql = "SELECT rva06,rva01,rva05,pmc03,rvb02,rvb05,rvb39,rvb07,",
                "       rvb33,rvb30,rvb29",
                " FROM rva_file,rvb_file,pmc_file ",
                " WHERE rva01 = rvb01 AND rva05 = pmc01 AND rvaconf = 'Y' ",
                "   AND (rvb07-rvb29-rvb30) > 0 ",
                "   AND ", g_wc CLIPPED,
                " ORDER BY rva06,rva01 "
    PREPARE q236_prepare FROM g_sql
    DECLARE q236_bcs CURSOR FOR q236_prepare
      
    LET g_sql = "SELECT COUNT(*) ",
                " FROM rva_file,rvb_file,pmc_file ",
                " WHERE rva01 = rvb01 AND rva05 = pmc01 AND rvaconf = 'Y' ",
                "   AND (rvb07-rvb29-rvb30) > 0 ",
                "   AND ", g_wc CLIPPED
    PREPARE q236_precount FROM g_sql
    DECLARE q236_count CURSOR FOR q236_precount
  
END FUNCTION
 
FUNCTION q236_menu()
 
   WHILE TRUE
      CALL q236_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q236_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q236_q()
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_rvb.clear()
   CALL q236_cs()                      #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q236_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
         OPEN q236_count
         FETCH q236_count INTO g_cnt
         DISPLAY g_cnt TO FORMONLY.cnt  
      CALL q236_b_fill()
   END IF
END FUNCTION
 
FUNCTION q236_b_fill()                     #BODY FILL UP
 
   FOR g_cnt = 1 TO g_rvb.getLength()           #單身 ARRAY 乾洗
      INITIALIZE g_rvb[g_cnt].* TO NULL
   END FOR
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH q236_bcs INTO g_rvb[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
 
   CALL SET_COUNT(g_cnt-1)                 #告訴I.單身筆數
   LET g_rec_b = g_cnt-1
END FUNCTION
     
FUNCTION q236_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
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
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
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
 
   
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
