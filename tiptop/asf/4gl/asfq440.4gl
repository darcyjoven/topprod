# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: asfq440.4gl
# Descriptions...: 料件未發料查詢
# Date & Author..: 93/05/29 BY Keith
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-940008 09/05/09 By hongmei 發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60027 10/06/08 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-B10056 11/02/16 By vealxu 修改制程段號的管控
# Modify.........: No.MOD-BC0247 11/12/23 By ck2yua 將g_sfa08/g_sfa03/g_sfa12/g_sfa27改為動態 避免不夠資料數超出範圍
# Modify.........: No.MOD-C80227 12/09/20 By Elise sfa08後還有其他欄位，但未加上逗號
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Head Where condition
        	wc2  	     LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(600)# Body Where condition
        END RECORD,
    g_ima RECORD
            ima01		LIKE ima_file.ima01,
            ima02		LIKE ima_file.ima02,
            ima08		LIKE ima_file.ima08,
            ima05		LIKE ima_file.ima05,
            ima021      	LIKE ima_file.ima021,
#           ima262      	LIKE ima_file.ima262,
#           qty                 LIKE ima_file.ima26        #No.FUN-680121 DECIMAL(13,3)
            avl_stk LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
            qty     LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044 
          END RECORD,
    g_sfa DYNAMIC ARRAY OF RECORD
            sfa01		LIKE sfa_file.sfa01,
            sfa05		LIKE sfa_file.sfa05,
            sfa06 	     LIKE sfa_file.sfa06,
            sfa062	     LIKE sfa_file.sfa062,
            sfa25		LIKE sfa_file.sfa25,
            sfa07		LIKE sfa_file.sfa07,
#           unqty               LIKE ima_file.ima26        #No.FUN-680121 DECIMAL(13,3)
            unqty   LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
            sfa012  LIKE sfa_file.sfa012,     #FUN-A60027
            ecu014  LIKE ecu_file.ecu014,     #FUN-A60027
            sfa013  LIKE sfa_file.sfa013,     #FUN-A60027
            sfa08   LIKE sfa_file.sfa08       #FUN-A60027    
        END RECORD,
     g_sql           string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num5                #單身筆數        #No.FUN-680121 SMALLINT
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_short_qty     LIKE sfa_file.sfa07          #No.FUN-940008 add
#DEFINE   g_sfa08         ARRAY[200] OF LIKE sfa_file.sfa08    #No.FUN-940008 add   #MOD-BC0247 mark
#DEFINE   g_sfa03         ARRAY[200] OF LIKE sfa_file.sfa03    #No.FUN-940008 add   #MOD-BC0247 mark
#DEFINE   g_sfa12         ARRAY[200] OF LIKE sfa_file.sfa12    #No.FUN-940008 add   #MOD-BC0247 mark
#DEFINE   g_sfa27         ARRAY[200] OF LIKE sfa_file.sfa27    #No.FUN-940008 add   #MOD-BC0247 mark
DEFINE g_sfa08 DYNAMIC ARRAY OF LIKE sfa_file.sfa08 #MOD-BC0247 add
DEFINE g_sfa03 DYNAMIC ARRAY OF LIKE sfa_file.sfa03 #MOD-BC0247 add
DEFINE g_sfa12 DYNAMIC ARRAY OF LIKE sfa_file.sfa12 #MOD-BC0247 add
DEFINE g_sfa27 DYNAMIC ARRAY OF LIKE sfa_file.sfa27 #MOD-BC0247 add 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	     #No.FUN-6A0090
      DEFINE   l_sl,p_row,p_col LIKE type_file.num5  #No.FUN-680121 SMALLINT #No.FUN-6A0090
 
   OPTIONS                                 #改變一些系統預設值
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
    LET p_row = 3 LET p_col = 20
    OPEN WINDOW asfq440_w AT p_row,p_col
        WITH FORM "asf/42f/asfq440"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    #IF cl_chk_act_auth() THEN
    #   CALL q440_q()
    #END IF
    CALL cl_set_comp_visible("sfa012,ecu014,sfa013,sfa08",g_sma.sma541 = 'Y')   #FUN-A60027 
    CALL q440_menu()
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
#QBE 查詢資料
FUNCTION q440_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_sfa.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			   # Default condition
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON ima01
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
   CALL q440_b_askkey()
   IF INT_FLAG THEN
      RETURN
   END IF
   LET g_sql=" SELECT UNIQUE ima01 FROM ima_file,sfa_file",
             " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
			 " AND (sfaacti ='Y' OR sfaacti = 'y') ",
    #           " AND sfb04 MATCHES'[34567]' ",
                " AND ima01 = sfa03 AND sfa05 > sfa06 ",
             " ORDER BY ima01"
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_sql= g_sql clipped," AND imauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_sql= g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_sql= g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    #End:FUN-980030
 
 
   PREPARE q440_prepare FROM g_sql
   DECLARE q440_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q440_prepare
 
   LET g_sql=" SELECT COUNT(UNIQUE ima01) FROM ima_file,sfa_file",
             " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
       	     " AND (sfaacti ='Y' OR sfaacti = 'y') ",
             " AND ima01 = sfa03 AND sfa05 > sfa06 "
   PREPARE q440_prepare1 FROM g_sql
   DECLARE q440_count                         #SCROLL CURSOR
           SCROLL CURSOR FOR q440_prepare1
END FUNCTION
 
FUNCTION q440_b_askkey()
      CONSTRUCT  tm.wc2 ON  # 螢幕上取單身條件
               sfa01 FROM s_sfa[1].sfa01
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
 
FUNCTION q440_menu()
   DEFINE   l_sql   LIKE type_file.chr1000       #No.FUN-680121  VARCHAR(100)
 
   WHILE TRUE
      CALL q440_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q440_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "動態數量查詢"
         WHEN "query_dynamic_qty_details"
            LET l_sql = "aimq102 "," '1' ","'",g_ima.ima01,"'"
            CALL cl_cmdrun(l_sql)
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfa),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q440_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL q440_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN q440_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q440_count
        FETCH q440_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q440_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q440_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式          #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10,                #絕對的筆數        #No.FUN-680121 INTEGER
    l_n1            LIKE type_file.num15_3,              ###GP5.2  #NO.FUN-A20044
    l_n2            LIKE type_file.num15_3,              ###GP5.2  #NO.FUN-A20044
    l_n3            LIKE type_file.num15_3               ###GP5.2  #NO.FUN-A20044 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q440_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q440_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q440_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q440_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q440_cs INTO g_ima.ima01
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
# SELECT ima01,ima02,ima08,ima05,ima021,ima262,''
  SELECT ima01,ima02,ima08,ima05,ima021,0,'' 
	  INTO g_ima.*
	  FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
 #      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)  #No.FUN-660128
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660128
        RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
    LET g_ima.avl_stk = l_n3 
    CALL q440_show()
END FUNCTION
 
FUNCTION q440_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL q440_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q440_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
#         l_qty     LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)
#         l_need    LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(13,3)
#         l_tt      LIKE ima_file.ima26           #No.FUN-680121 DECIMAL(12,3)
          l_qty     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_need    LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_tt      LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
   DEFINE l_ecu014  LIKE ecu_file.ecu014          #FUN-A60027
 
   LET l_sql =
        "SELECT sfa01,sfa05,sfa06,sfa062,sfa25,'',sfa05-sfa06,sfa012,'',sfa013,sfa08,", #FUN-940008 sfa07-->''  #FUN-A60027 add afa012,sfa013,sfa08,''  #MOD-C80227 add ,
        "       sfa03,sfa08,sfa12,sfa27",    #FUN-940008 add
        " FROM sfa_file,sfb_file",
        " WHERE sfa03 = '",g_ima.ima01,"' AND ",tm.wc2 CLIPPED,
	" AND sfa05 - sfa06 > 0 AND sfb87!='X' ",
        " AND sfa01 = sfb01 AND sfb04 !='8' ",
        " ORDER BY sfa01 "
    PREPARE q440_pb FROM l_sql
    DECLARE q440_bcs                       #BODY CURSOR
        CURSOR FOR q440_pb
 
    FOR g_cnt = 1 TO g_sfa.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sfa[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    LET l_need = 0
    FOREACH q440_bcs INTO g_sfa[g_cnt].*,
                          g_sfa03[g_cnt],g_sfa08[g_cnt],   #FUN-940008 add
                          g_sfa12[g_cnt],g_sfa27[g_cnt]    #FNN-940008 add
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #FUN-A60027 ---------------start-----------------------
        LET l_ecu014  = NULL 
       #FUN-B10056 --------mod start--------- 
       #SELECT ecu014 INTO l_ecu014 
       #  FROM ecu_file
       # WHERE ecu012 = g_sfa[g_cnt].sfa012
        CALL s_schdat_ecm014(g_sfa[g_cnt].sfa01,g_sfa[g_cnt].sfa012) RETURNING l_ecu014
       #FUN-B10056 -------mod end------------
        LET g_sfa[g_cnt].ecu014 = l_ecu014        
        #FUN-A60027 -------------end-------------------------
        #FUN-940008---Begin add      
        CALL s_shortqty(g_sfa[g_cnt].sfa01,g_sfa03[g_cnt],g_sfa08[g_cnt],
                        g_sfa12[g_cnt],g_sfa27[g_cnt],g_sfa[g_cnt].sfa012,g_sfa[g_cnt].sfa013)      #FUN-A60027 add sfa012,sfa013
              RETURNING g_short_qty
        IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
        LET g_sfa[g_cnt].sfa07 = g_short_qty
        #FUN-940008---End
        IF g_sfa[g_cnt].sfa05 IS NULL THEN
  	       LET g_sfa[g_cnt].sfa05 = 0
        END IF
        IF g_sfa[g_cnt].sfa06 IS NULL THEN
  	       LET g_sfa[g_cnt].sfa06 = 0
        END IF
        IF g_sfa[g_cnt].sfa062 IS NULL THEN
  	       LET g_sfa[g_cnt].sfa062 = 0
        END IF
        IF g_sfa[g_cnt].sfa25 IS NULL THEN
  	       LET g_sfa[g_cnt].sfa25 = 0
        END IF
        IF g_sfa[g_cnt].sfa07 IS NULL THEN
  	       LET g_sfa[g_cnt].sfa07 = 0
        END IF
        IF g_sfa[g_cnt].unqty IS NULL THEN
  	       LET g_sfa[g_cnt].unqty = 0
        END IF
        LET l_need = l_need + g_sfa[g_cnt].unqty
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b = g_cnt - 1
#   LET l_need = l_need - g_ima.ima262  #NO.FUN-A20044
    LET l_need = l_need - g_ima.avl_stk #NO.FUN-A20044
    IF l_need < 0 THEN
       LET g_ima.qty = 0
    ELSE
       LET g_ima.qty = l_need
    END IF
    DISPLAY BY NAME g_ima.qty
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q440_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q440_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q440_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q440_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q440_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q440_fetch('L')
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
 
 #MOD-530170
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@      ON ACTION 動態數量查詢
      ON ACTION query_dynamic_qty_details
         LET g_action_choice="query_dynamic_qty_details"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
