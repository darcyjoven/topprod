# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: asfq400.4gl
# Descriptions...: 料件備料查詢
# Date & Author..: 93/03/16 BY Keith
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530217 05/03/23 By kim X鈕沒作用
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60027 10/06/08 By vealxu 製造功能優化-平行制程（批量修改） 
# Modify.........: No.MOD-AC0336 10/12/28 By jan 修正sql
# Modify.........: No.FUN-B10056 11/02/16 By vealxu 修改制程段號的管控
# Modify.........: No:TQC-D70081 13/07/23 By qirl 單頭來源碼欄位增加開窗 沒有取到值 當前版本欄位值取的錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Head Where condition
        	wc2  	LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(600)# Body Where condition
        END RECORD,
    g_ima  RECORD
            ima01		LIKE ima_file.ima01,
            ima02		LIKE ima_file.ima02,
            ima05		LIKE ima_file.ima05,
            ima08		LIKE ima_file.ima08,
            ima021	        LIKE ima_file.ima021,
#           ima262       LIKE ima_file.ima262
            avl_stk LIKE type_file.num15_3     
        END RECORD,
    g_sfb DYNAMIC ARRAY OF RECORD
            sfb13     LIKE sfb_file.sfb13,
            sfb01     LIKE sfb_file.sfb01,
            sfb02     LIKE sfb_file.sfb02,
            sfb04     LIKE sfb_file.sfb04,
            sfb05     LIKE sfb_file.sfb05,
            ima02_b   LIKE ima_file.ima02,
            ima021_b  LIKE ima_file.ima021,
            sfa05     LIKE sfa_file.sfa05,
            sfa06     LIKE sfa_file.sfa06,
            sfa25     LIKE sfa_file.sfa25,
#           qtyct     LIKE ima_file.ima26         #No.FUN-680121 DECIMAL(11,3)
            qtyct     LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
            sfa012    LIKE sfa_file.sfa012,       #No.FUN-A60027
            ecu014    LIKE ecu_file.ecu014,       #No.FUN-A60027
            sfa013    LIKE sfa_file.sfa013,       #No.FUN-A60027
            sfa08     LIKE sfa_file.sfa08         #No.FUN-A60027
        END RECORD,
#   g_argv1     LIKE ima_file.ima01,              # INPUT ARGUMENT - 1
     g_wc,g_wc2      string, #WHERE CONDITION  #No.FUN-580092 HCN
     g_sql           string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num5   	       #單身筆數        #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	     #No.FUN-6A0090
      DEFINE   l_sl,p_row,p_col LIKE type_file.num5  #No.FUN-680121 SMALLINT #No.FUN-6A0090
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 2
   END IF
    OPEN WINDOW asfq400_w AT p_row,p_col
        WITH FORM "asf/42f/asfq400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("sfa012,ecu014,sfa013,sfa08",g_sma.sma541 = 'Y')     #No.FUN-A60027  
## Mark By Raymon
#   IF cl_chk_act_auth() THEN
#      CALL q400_q()
#   END IF
    CALL q400_menu()
    CLOSE WINDOW q400_srn               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
#QBE 查詢資料
FUNCTION q400_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
      CLEAR FORM #清除畫面
   CALL g_sfb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			        # Default condition
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON ima01,ima02,ima021,    #螢幕上取單頭條件
#                                ima08,ima05,ima262
                                 ima08,ima05            #NO.FUN-A20044
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ima01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_ima.ima01
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
    #--TQC-D70081--add---star---
          WHEN INFIELD(ima08)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima7"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_ima.ima08
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima08
            NEXT FIELD ima08
    #--TQC-D70081--add---end---
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
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL q400_b_askkey()
      IF INT_FLAG THEN
         RETURN
      END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    #End:FUN-980030
 
 
IF g_wc2 = " 1=1" THEN            # 若單身未輸入條件
   LET g_sql=" SELECT ima01 FROM ima_file ",
             " WHERE ",tm.wc CLIPPED,
			 " AND (imaacti ='Y' OR imaacti = 'y') ",
             " ORDER BY ima01"
ELSE
   LET g_sql=" SELECT UNIQUE ima01,sfa03 FROM sfa_file,sfb_file,",
             " ima_file ",
             " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
             " AND (imaacti ='Y' OR imaacti = 'y') AND sfb87!='X' ",
             " AND sfb01 = sfa01 AND sfa03 = ima01 AND sfa05 > sfa06 ",
             " ORDER BY sfa03"
END IF
   PREPARE q400_prepare FROM g_sql
   DECLARE q400_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q400_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
      LET g_sql=" SELECT COUNT(*) FROM ima_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND (imaacti ='Y' OR imaacti = 'y') "
  PREPARE q400_precount FROM g_sql
  DECLARE q400_count CURSOR FOR q400_precount
 
END FUNCTION
 
FUNCTION q400_b_askkey()
 
      CONSTRUCT  tm.wc2 ON  # 螢幕上取單身條件
      sfb13,sfb01,sfa05,sfa06,sfa25,sfa012,sfa013,sfa08         #FUN-A60027 add sfa012,sfa013,sfa08
      FROM s_sfb[1].sfb13,s_sfb[1].sfb01,
           s_sfb[1].sfa05,s_sfb[1].sfa06,s_sfb[1].sfa25,s_sfb[1].sfa012,s_sfb[1].sfa013,s_sfb[1].sfa08   #FUN-A60027 modify 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
END FUNCTION
 
FUNCTION q400_menu()
 
   WHILE TRUE
      CALL q400_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q400_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q400_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
  # DISPLAY '   ' TO FORMONLY.cnt
    CALL q400_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN q400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q400_count
        FETCH q400_count INTO g_row_count
       CALL q400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q400_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10,                #絕對的筆數      #No.FUN-680121 INTEGER
    l_n1            LIKE type_file.num15_3,              ###GP5.2  #NO.FUN-A20044
    l_n2            LIKE type_file.num15_3,              ###GP5.2  #NO.FUN-A20044
    l_n3            LIKE type_file.num15_3               ###GP5.2  #NO.FUN-A20044 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q400_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q400_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q400_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q400_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q400_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
#	SELECT ima01,ima02,ima08,ima05,ima021,ima262   #NO.FUN-A20044
# SELECT ima01,ima02,ima08,ima05,ima021,0        #NO.FUN-A20044  #TQC-D70081-mark
        SELECT ima01,ima02,ima05,ima08,ima021,0    #TQC-D70081--add--
	  INTO g_ima.*
	  FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
   #    CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)  #No.FUN-660128
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)          #No.FUN-660128
        RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
    LET g_ima.avl_stk = l_n3 
    CALL q400_show()
END FUNCTION
 
FUNCTION q400_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL q400_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q400_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
#         l_qty     LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)
#         l_tt      LIKE ima_file.ima26           #No.FUN-680121 DECIMAL(12,3)
          l_qty     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_tt      LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
   DEFINE l_ecu014  LIKE ecu_file.ecu014          #No.FUN-A60027 
   DEFINE l_flag    LIKE type_file.num5           #MOD-AC0336
   DEFINE l_sfb05   LIKE sfb_file.sfb05           #MOD-AC0336
   DEFINE l_sfb06   LIKE sfb_file.sfb06           #MOD-AC0336

 
   LET l_sql =
        "SELECT sfb13,sfb01,sfb02,sfb04,sfb05,ima02,ima021,sfa05,sfa06,sfa25,'',sfa012,'',sfa013,sfa08",         #FUN-A60027 add sfa012,sfa013,sfa08,''
        " FROM  sfb_file,sfa_file,OUTER ima_file ",
        " WHERE sfa_file.sfa03 = '",g_ima.ima01,"' AND sfa01 = sfb01 AND ima_file.ima01=sfb_file.sfb05 AND",
        " sfb04 != '8' AND sfb87!='X' AND ",
          tm.wc2 CLIPPED,
		" AND sfa05 - sfa06 > 0 ",
        " ORDER BY sfb13 "
    PREPARE q400_pb FROM l_sql
    DECLARE q400_bcs                       #BODY CURSOR
        CURSOR FOR q400_pb
 
    FOR g_cnt = 1 TO g_sfb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sfb[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1

    LET l_qty = g_ima.avl_stk   
#   LET l_qty = g_ima.ima262
    FOREACH q400_bcs INTO g_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #No.FUN-A60027 --------------------------start------------------
        CALL s_schdat_sel_ima571(g_sfb[g_cnt].sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336
        SELECT sfb06 INTO l_sfb06 FROM sfb_file WHERE sfb01=g_sfb[g_cnt].sfb01 #MOD-AC0336
        LET l_ecu014 = NULL 
       #FUN-B10056 -------------mod start----------
       #SELECT ecu014 INTO l_ecu014
       #  FROM ecu_file 
       # WHERE ecu012 = g_sfb[g_cnt].sfa012
       #   AND ecu01=l_sfb05 AND ecu02=l_sfb06  #MOD-AC0336
        CALL s_schdat_ecm014(g_sfb[g_cnt].sfb01,g_sfb[g_cnt].sfa012) RETURNING l_ecu014 
       #FUN-B10056 ------------mod end------------ 
        LET g_sfb[g_cnt].ecu014 = l_ecu014
        #No.FUN-A60027 -----------------------------end--------------------- 
        IF g_sfb[g_cnt].sfa05 IS NULL THEN
  	       LET g_sfb[g_cnt].sfa05 = 0
        END IF
        IF g_sfb[g_cnt].sfa06 IS NULL THEN
  	       LET g_sfb[g_cnt].sfa06 = 0
        END IF
        IF g_sfb[g_cnt].sfa25 IS NULL THEN
  	       LET g_sfb[g_cnt].sfa25 = 0
        END IF
#       LET l_tt = g_sfb[g_cnt].sfa05-g_sfb[g_cnt].sfa06-g_sfb[g_cnt].sfa25
        LET l_tt = g_sfb[g_cnt].sfa25
        IF l_tt < 0 THEN
           LET l_tt = 0
        END IF
        LET g_sfb[g_cnt].qtyct = l_qty - l_tt
        LET l_qty = l_qty - l_tt
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt=0
END FUNCTION
 
FUNCTION q400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q400_fetch('L')
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
 
 #MOD-530217........................begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 #MOD-530217........................end
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
