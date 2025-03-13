# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmq631.4gl
# Descriptions...: 產品序號原物料明細查詢
# Date & Author..: 99/05/27 By Carol :tiptop4.0
# Modify.........: No.FUN-4B0038 04/11/16 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_argv1        LIKE she_file.she02  	# 產品序號
  DEFINE g_sw		LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
  DEFINE g_wc,g_wc2	string 	# WHERE CONDICTION  #No.FUN-580092 HCN
  DEFINE g_sql		string  #No.FUN-580092 HCN
  DEFINE g_sfa 	RECORD
		she02	LIKE she_file.she02,            #產品序號 
		sfa03	LIKE sfa_file.sfa03,            #料號
		sfb01	LIKE sfb_file.sfb01,            #工單編號
		sfb07	LIKE sfb_file.sfb07,            #版本
		sfb06	LIKE sfb_file.sfb06,            #製程編號
  		ima02	LIKE ima_file.ima02,		#品名
  		ima021	LIKE ima_file.ima021		#品名
            	END RECORD
  DEFINE g_sfe DYNAMIC ARRAY OF RECORD
               sfe08    LIKE sfe_file.sfe08, 
               sfe09    LIKE sfe_file.sfe09, 
               sfe10    LIKE sfe_file.sfe10 
               END RECORD
  DEFINE g_rvu DYNAMIC ARRAY OF RECORD
               rvu01    LIKE rvu_file.rvu01,
               rvv02    LIKE rvv_file.rvv02,
               rvu03    LIKE rvu_file.rvu03,
               rvu04    LIKE rvu_file.rvu04,
               pmc03    LIKE pmc_file.pmc03
               END RECORD
  DEFINE g_rvb DYNAMIC ARRAY OF RECORD
               rvb04    LIKE rvb_file.rvb04,
               pmm04    LIKE pmm_file.pmm04,
               gen02    LIKE gen_file.gen02,
               rvu02_q  LIKE rvu_file.rvu02,
               rva06    LIKE rva_file.rva06,
               stat     LIKE aab_file.aab02,      # No.FUN-680137  VARCHAR(6)
               gen02_q  LIKE gen_file.gen02
               END RECORD
  DEFINE g_order        LIKE type_file.num5        # No.FUN-680137   SMALLINT       
  DEFINE g_cnt          LIKE type_file.num10            #No.FUN-680137 INTEGER
  DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(72)
  DEFINE g_rec_b1       LIKE type_file.num10       # No.FUN-680137  INTEGER
  DEFINE g_rec_b2       LIKE type_file.num10       # No.FUN-680137   INTEGER
  DEFINE g_rec_b3       LIKE type_file.num10       # No.FUN-680137  INTEGER
  DEFINE l_ac            LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
  DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
  DEFINE g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
  DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
FUNCTION axmq631(p_argv1)
    DEFINE p_argv1    LIKE  she_file.she02

    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_argv1 = p_argv1
 
    IF NOT cl_null(g_argv1) THEN
       CALL q631_q()
    END IF
 
    CALL q631_menu()
 
END FUNCTION
 
FUNCTION q631_cs()
 DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1) THEN
      DISPLAY g_argv1 TO she02
      LET g_wc = "she02 = '",g_argv1,"' "
   ELSE
      CLEAR FORM              #清除畫面
      CALL g_sfe.clear()
      CALL g_rvu.clear()
      CALL g_rvb.clear()
      CALL cl_opmsg('q')
      CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092
 
   INITIALIZE g_sfa.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON she02,sfa03 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   END IF
   LET g_sql=" SELECT she02,sfa03,sfb01,sfb07,sfb06,'',''", 
             " FROM she_file,sfb_file,sfa_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND sfb01=she01 AND sfa01=sfb01 AND sfb87!='X' ",      
             " ORDER BY she02,sfa03"
   PREPARE q631_prepare FROM g_sql
   DECLARE q631_cs SCROLL CURSOR FOR q631_prepare
 
   LET g_sql=" SELECT COUNT(*) ",
             " FROM she_file,sfb_file,sfa_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND sfb01=she01 AND sfa01=sfb01 ",
             "   AND sfb87!='X' "
   PREPARE q631_pp  FROM g_sql
   DECLARE q631_cnt CURSOR FOR q631_pp
 
END FUNCTION
 
FUNCTION q631_menu()
 
   WHILE TRUE
      CALL q631_bp("G")
      CASE g_action_choice
         WHEN "query" 
            CALL q631_q()
         WHEN "query_material"
            CALL q631_show_material("Q")
         WHEN "query_issue_warehouse"
            CALL q631_show_issue("Q")
         WHEN "query_receipts_po"
            CALL q631_show_receipts("Q")
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q631_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL q631_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "Waiting!" 
    OPEN q631_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('q631_q:',SQLCA.sqlcode,0)
    ELSE
       OPEN q631_cnt
       FETCH q631_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt 
       CALL q631_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q631_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q631_cs INTO g_sfa.*
        WHEN 'P' FETCH PREVIOUS q631_cs INTO g_sfa.*
        WHEN 'F' FETCH FIRST    q631_cs INTO g_sfa.*
        WHEN 'L' FETCH LAST     q631_cs INTO g_sfa.*
        WHEN '/'
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q631_cs INTO g_sfa.*
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('Fetch:',SQLCA.sqlcode,0)
        INITIALIZE g_sfa.* TO NULL  #TQC-6B0105
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
    CALL q631_show()
END FUNCTION
 
FUNCTION q631_show()
   SELECT ima02,ima021 INTO g_sfa.ima02,g_sfa.ima021 FROM ima_file
    WHERE ima01=g_sfa.sfa03 
   IF STATUS THEN LET g_sfa.ima02='' LET g_sfa.ima021='' END IF 
   DISPLAY BY NAME g_sfa.*
   MESSAGE ' WAIT ' 
   CALL q631_b_fill() #單身
   CALL q631_show_receipts("D")
   CALL q631_show_issue("D")
   CALL q631_show_material("D")
   MESSAGE ''
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q631_b_fill()              #BODY FILL UP
   DEFINE l_sfb02	LIKE type_file.num5,        # No.FUN-680137 SMALLINT
	  I,J		LIKE type_file.num10,       # No.FUN-680137 INTEGER
          l_pmm12       LIKE pmm_file.pmm12,
          l_rvauser     LIKE rva_file.rvauser
 
#-- 發料資料
    DECLARE q631_bcs1 CURSOR FOR
       SELECT sfe08,sfe09,sfe10 FROM sfe_file 
        WHERE sfe01=g_sfa.sfb01 AND sfe07=g_sfa.sfa03 
#-- 原料入庫    
    DECLARE q631_bcs2 CURSOR FOR
       SELECT rvu01,rvv02,rvu03,rvu04,''
        FROM sfe_file,rvu_file,rvv_file
        WHERE sfe01=g_sfa.sfb01 AND sfe07=g_sfa.sfa03 
          AND rvv31=g_sfa.sfa03 AND rvv32=sfe08 
          AND rvv33=sfe09 AND rvv34=sfe10
          AND rvu01=rvv01 AND rvu00=rvv03 
          AND rvuconf = 'Y' 
#-- 收貨採購
    DECLARE q631_bcs3 CURSOR FOR
       SELECT rvb04,'','',rvu02,rva06,rva22,'',rvauser 
        FROM sfe_file,rvu_file,rvb_file,rva_file,rvv_file
        WHERE sfe01=g_sfa.sfb01 AND sfe07=g_sfa.sfa03 
          AND rvv31=g_sfa.sfa03 AND rvv32=sfe08 
          AND rvv33=sfe09 AND rvv34=sfe10
          AND rvb01=rvv04 AND rvb02=rvv05
          AND rva01=rvb01 
          AND rvu01=rvv01 AND rvu00=rvv03 
          AND rvuconf = 'Y' 
          AND rvaconf <> 'X'
 
    CALL g_sfe.clear()
    CALL g_rvu.clear()
    CALL g_rvb.clear()
#----------------------------------------------------------------------------
    LET g_cnt = 1
    FOREACH q631_bcs1 INTO g_sfe[g_cnt].*
      IF STATUS THEN CALL cl_err('F1:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('F1', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b1 = g_cnt - 1
#----------------------------------------------------------------------------
    LET g_cnt = 1
    FOREACH q631_bcs2 INTO g_rvu[g_cnt].*
         IF STATUS THEN CALL cl_err('F2:',STATUS,1) EXIT FOREACH END IF
         SELECT pmc03 INTO g_rvu[g_cnt].pmc03  FROM pmc_file 
          WHERE pmc01=g_rvu[g_cnt].rvu04  
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('F2', 9035, 0 )
            EXIT FOREACH
         END IF
    END FOREACH
    LET g_rec_b2 = g_cnt - 1
#----------------------------------------------------------------------------
    LET g_cnt = 1
    FOREACH q631_bcs3 INTO g_rvb[g_cnt].*,l_rvauser 
         IF STATUS THEN CALL cl_err('F3:',STATUS,1) EXIT FOREACH END IF
         SELECT pmm04,gen02 INTO g_rvb[g_cnt].pmm04,g_rvb[g_cnt].gen02 
           FROM pmm_file LEFT OUTER JOIN gen_file ON pmm_file.pmm12 = gen_file.gen01     #liuxqa 091021
          WHERE pmm01=g_rvb[g_cnt].rvb04  AND pmm18 !='X'                        #liuxqa 091021
         SELECT gen02 INTO g_rvb[g_cnt].gen02_q FROM gen_file
          WHERE gen01=l_rvauser
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('F3', 9035, 0 )
            EXIT FOREACH
         END IF
    END FOREACH
    LET g_rec_b3 = g_cnt - 1
#----------------------------------------------------------------------------
END FUNCTION
 
FUNCTION q631_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL q631_show_issue(p_ud)
   CALL q631_show_material(p_ud)
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL q631_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL q631_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump 
         CALL q631_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL q631_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last 
         CALL q631_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b3 != 0 THEN
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01","AUTO")           #No.FUN-6A0092
 
     #ON ACTION 查詢發料倉儲
      ON ACTION query_issue_warehouse
         LET g_action_choice="query_issue_warehouse"
         EXIT DISPLAY
     #ON ACTION 查詢原料入庫
      ON ACTION query_material
         LET g_action_choice="query_material"
         EXIT DISPLAY
     #ON ACTION 查詢收貨採購
      ON ACTION query_receipts_po
         LET g_action_choice="query_receipts_po"
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
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q631_show_receipts(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b3)
 
      BEFORE DISPLAY
         IF p_ud != 'Q' THEN EXIT DISPLAY END IF
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END DISPLAY
END FUNCTION
 
FUNCTION q631_show_issue(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   DISPLAY ARRAY g_sfe TO s_sfe.*  ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         IF p_ud != 'Q' THEN EXIT DISPLAY END IF
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END DISPLAY
END FUNCTION
 
FUNCTION q631_show_material(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   DISPLAY ARRAY g_rvu TO s_rvu.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         IF p_ud != 'Q' THEN EXIT DISPLAY END IF
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
   
   END DISPLAY
END FUNCTION
