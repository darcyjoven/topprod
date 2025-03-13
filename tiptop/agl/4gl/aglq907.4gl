# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglq907.4gl
# Descriptions...: 分錄底稿查詢作業
# Date & Author..: No.FUN-8A0083 08/10/22 By jan 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:MOD-B30120 11/03/11 By Sarah 將mfg6150檢查段mark掉
# Modify.........: No.FUN-B50051 11/05/12 By xjll 增加科目编号查询功能 
# Modify.........: Mo.MOD-B70157 11/01/17 By Polly 增加「帳別」選項，以讓USER可查詢不同「帳別」的資料
# Modify.........: No.FUN-C10024 12/05/2333 By minpp 帳套取歷年主會計帳別檔tna_file

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
#           wc1  LIKE type_file.chr1000,
           wc1  STRING,                  #NO.FUN-910082
#           wc  	LIKE type_file.chr1000
           wc   STRING                   #NO.FUN-910082	 
        END RECORD,
    bdate,edate  LIKE type_file.dat,  
    g_npptype    LIKE npp_file.npptype,  #No.MOD-B70157 add
    g_ae  RECORD
           aea00    LIKE aea_file.aea00,   
           aea05		LIKE aea_file.aea05,
           aea02		LIKE aea_file.aea02
       END RECORD,
    g_npp DYNAMIC ARRAY OF RECORD
            npp03    LIKE npp_file.npp03,
            npp02    LIKE npp_file.npp02,
            nppglno  LIKE npp_file.nppglno,
            npq04    LIKE npq_file.npq04,
            npq07_1  LIKE npq_file.npq07,
            npq07_2  LIKE npq_file.npq07,
            b        LIKE aah_file.aah04, 
            npq24    LIKE npq_file.npq24, 
            npq07f_1 LIKE npq_file.npq07, 
            npq07f_2 LIKE npq_file.npq07            
        END RECORD,
    g_bookno     LIKE aea_file.aea00,       
    l_ac    LIKE type_file.num5, #CHI-710005 
    g_wc,g_sql STRING,     #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num5   	      #單身筆數     #No.FUN-680098 smallint
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098 smallint

MAIN
   DEFINE l_sl	        LIKE type_file.num5           
   DEFINE p_row,p_col   	LIKE type_file.num5          
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AGL")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
    LET g_bookno = ARG_VAL(1)         #參數值(1) Part#
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW aglq907_w AT p_row,p_col WITH FORM "agl/42f/aglq907"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    SELECT aaz64 INTO g_aaz.aaz64 FROM aaz_file
    SELECT aza81,aza82 INTO g_aza.aza81,g_aza.aza82 FROM aza_file     #NO.MOD-B70157 add 
    LET g_npptype='0'                #NO.MOD-B70157 add
    LET bdate=g_today 
    LET edate=g_today 
 
 
    CALL s_shwact(0,0,g_bookno)   #No:8597
    IF NOT cl_null(g_bookno) THEN CALL q907_q() END IF
    IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    CALL s_dsmark(g_bookno)                #No:8597
 
    CALL q907_menu()
    CLOSE WINDOW aglq907_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION q907_cs()
   DEFINE   l_cnt            LIKE type_file.num5          #No.FUN-680098  smallint
 
   CLEAR FORM #清除畫面
   CALL g_npp.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES") 
 
   INITIALIZE g_ae.* TO NULL 
   CONSTRUCT BY NAME tm.wc1 ON aag01            
    #No.FUN-B50051--str--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aag01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aag01
                   NEXT FIELD aag01
          OTHERWISE
             EXIT CASE
         END CASE
     #No.FUN-B50051--end-- 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
   END CONSTRUCT
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
#---------------------------------NO.MOD-B70157-----------------------start 
  #INPUT BY NAME bdate,edate WITHOUT DEFAULTS               
   INPUT BY NAME g_npptype,bdate,edate WITHOUT DEFAULTS      
  
      AFTER FIELD g_npptype
        IF g_npptype NOT MATCHES "[01]" THEN
           NEXT FIELD g_npptype 
        ELSE
           DISPLAY BY NAME g_npptype
        END IF
#---------------------------------NO.MOD-B70157 add-------------------end
      AFTER FIELD bdate
         IF cl_null(bdate) THEN
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(edate) THEN
            LET edate =g_lastdat
         ELSE
           #str MOD-B30120 mark
           #IF YEAR(bdate) <> YEAR(edate) THEN
           #   CALL cl_err('','mfg6150',0)
           #   NEXT FIELD edate
           #END IF
           #end MOD-B30120 mark
         END IF
         IF edate < bdate THEN
            CALL cl_err(' ','agl-031',0)
            NEXT FIELD edate
         END IF
 
   END INPUT
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT BY NAME tm.wc ON npp03
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
  #LET g_sql=" SELECT aag01 FROM aag_file ",    #FUN-C10024  mark
   LET g_sql=" SELECT aag00,aag01 FROM aag_file ", #FUN-C10024 add
             " WHERE ",tm.wc1 CLIPPED,
             "   AND aag03 = '2' ",
             "   AND (aag07 = '2' OR aag07 = '3') "
   PREPARE q907_prepare FROM g_sql
   DECLARE q907_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q907_prepare
 
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             " WHERE ",tm.wc1 CLIPPED,
             "   AND aag03 = '2' ",
             "   AND (aag07 = '2' OR aag07 = '3') " 
   PREPARE q907_precount FROM g_sql
   DECLARE q907_count CURSOR FOR q907_precount
END FUNCTION
 
FUNCTION q907_menu()
DEFINE   p_vchno LIKE aea_file.aea03  #CHI-710005
DEFINE   g_cmd   LIKE type_file.chr1000 #CHI-710005
 
   WHILE TRUE
      CALL q907_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q907_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_npp),'','')                                 
            END IF  
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q907_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q907_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q907_count
    FETCH q907_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q907_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q907_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q907_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式 
    l_abso          LIKE type_file.num10   #絕對的筆數 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q907_cs INTO g_ae.aea00,g_ae.aea05    #FUN-C10024 add--g_ae.aea00
        WHEN 'P' FETCH PREVIOUS q907_cs INTO g_ae.aea00,g_ae.aea05    #FUN-C10024 add--g_ae.aea00
        WHEN 'F' FETCH FIRST    q907_cs INTO g_ae.aea00,g_ae.aea05    #FUN-C10024 add--g_ae.aea00
        WHEN 'L' FETCH LAST     q907_cs INTO g_ae.aea00,g_ae.aea05    #FUN-C10024 add--g_ae.aea00
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
            FETCH ABSOLUTE g_jump q907_cs INTO g_ae.aea00,g_ae.aea05    #FUN-C10024 add--g_ae.aea00
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ae.aea05,SQLCA.sqlcode,0)
        INITIALIZE g_ae.* TO NULL
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
 
    CALL q907_show()
END FUNCTION
 
FUNCTION q907_show()
   DISPLAY g_ae.aea05 TO aag01
   CALL q907_aea05('d')
   CALL q907_b_fill() #單身
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION q907_aea05(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,  
           l_aag02 LIKE aag_file.aag02,         
           l_aagacti LIKE aag_file.aagacti   
 
    LET g_errno = ' '
    IF g_ae.aea05 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aagacti
           INTO l_aag02,l_aagacti
           FROM aag_file WHERE aag01 = g_ae.aea05
                           AND aag00 = g_ae.aea00   #FUN-C10024 unmark
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_aag02 = NULL
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_aag02 TO  FORMONLY.aag02
    END IF
END FUNCTION
 
FUNCTION q907_b_fill()              #BODY FILL UP
   DEFINE #l_sql   LIKE type_file.chr1000,
          l_sql      STRING,     #NO.FUN-910082 
          l_aea03 LIKE aea_file.aea03,
          l_npq06 LIKE npq_file.npq06,
          l_npq07 LIKE npq_file.npq07,
          l_bal     LIKE aah_file.aah04,
          l_d       LIKE aah_file.aah04,
          l_c       LIKE aah_file.aah04,
          l_bal1    LIKE aah_file.aah04,
          l_bdate   LIKE type_file.dat,
          l_edate   LIKE type_file.dat
   DEFINE l_npq07f  LIKE npq_file.npq07f    
 
   #期初
   LET l_bal1=0
   LET l_bdate=bdate USING "YYYY-MM-DD"
   CALL q907_qcye(g_ae.aea05) RETURNING l_d,l_c,l_bal
 
   LET l_sql =
        "SELECT npp03,npp02,nppglno,npq04 ,0,0,0,npq24,0,0, npq06,npq07,npq07f ", 
        " FROM  npp_file,npq_file",
        " WHERE ",tm.wc CLIPPED,
        " AND npq03 = '",g_ae.aea05,"'",
        " AND npp01 = npq01 AND npp011 = npq011  AND npp00 = npq00 ",
        " AND nppsys = npqsys AND npptype = npqtype ",
#       " AND npp07 = '",g_ae.aea00,"'",
        " AND npptype = '",g_npptype,"'",               #No.MOD-B70157 add
        " AND npp02 BETWEEN '",bdate,"' AND '",edate,"'", 
        " ORDER BY npp02"  
    PREPARE q907_pb FROM l_sql
    DECLARE q907_bcs                       #BODY CURSOR
        CURSOR FOR q907_pb
 
    FOR g_cnt = 1 TO g_npp.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_npp[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_npp[1].npq07_1=l_c
    LET g_npp[1].npq07_2=-l_d
    LET g_npp[1].b=l_bal
    LET l_bal1=l_bal
    #期初
    CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
    LET g_npp[1].npq04 = g_msg CLIPPED
    LET g_cnt = 2
    #CHI-710005  --end
    FOREACH q907_bcs INTO g_npp[g_cnt].*,l_npq06,l_npq07,l_npq07f 
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt=2 THEN
            LET g_rec_b=SQLCA.SQLERRD[3]
        END IF
        IF l_npq06='1' THEN
           LET g_npp[g_cnt].npq07_1=l_npq07
           LET g_npp[g_cnt].npq07f_1=l_npq07f                                        #FUN-8A0077 Add     
        ELSE
           LET g_npp[g_cnt].npq07_2=-l_npq07 
           LET g_npp[g_cnt].npq07f_2=-l_npq07f                                       #FUN-8A0077 Add
        END IF
        LET l_bal1=l_bal1+g_npp[g_cnt].npq07_1+g_npp[g_cnt].npq07_2 
        LET g_npp[g_cnt].b=l_bal1 #CHI-710005
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #期末
    CALL cl_getmsg('agl-193',g_lang) RETURNING g_msg
    LET g_npp[g_cnt].npq04 = g_msg CLIPPED
#MOD-850012-modify-end
    LET g_npp[g_cnt].b=l_bal1
    #CHI-710005  --end
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q907_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npp TO s_npp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q907_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q907_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q907_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q907_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q907_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   #CHI-710005  --begin
   ON ACTION accept
      LET g_action_choice="drill"
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
 
      #No.FUN-860021-Add-Begin--#
      ON ACTION exporttoexcel                                                                                             
         LET g_action_choice = 'exporttoexcel'                                                                                         
         EXIT DISPLAY 
      #No.FUN-860021-Add-End--#
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
 
FUNCTION q907_qcye(l_aea05)
   DEFINE l_aea05 LIKE aea_file.aea05,
          l_bal,l_bal1,l_d,l_c,l_e,l_f  LIKE aah_file.aah04,
          l_y1    LIKE type_file.num5,            #起始日所在年度
          l_m1    LIKE type_file.num5,            #起始日所在期別
          l_flag  LIKE type_file.chr1,            #
          b_date  LIKE type_file.dat,
          e_date  LIKE type_file.dat             #截至日
 
   SELECT azn02,azn04 INTO l_y1,l_m1
     FROM azn_file
    WHERE azn01 = bdate
   #取得起始日會計期間的起始日和截至日
   #CALL s_azm(l_y1,l_m1) RETURNING l_flag,b_date,e_date #CHI-A70007 mark 
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(l_y1,l_m1,g_plant,g_bookno) RETURNING l_flag,b_date,e_date
   ELSE
      CALL s_azm(l_y1,l_m1) RETURNING l_flag,b_date,e_date 
   END IF
   #CHI-A70007 add --end--
    IF l_m1 = 1 THEN
       LET l_m1 = 12
       LET l_y1 = l_y1 -1
    ELSE
       LET l_m1 = l_m1 - 1
    END IF
 
   LET l_bal = 0
   LET l_c = 0
   LET l_d = 0
   LET l_e = 0
   LET l_f = 0
 
 
   #會計科目余額檔
   IF g_npptype = '0' THEN           #No.MOD-B70157 add
      SELECT aah04,aah05 INTO l_c,l_d FROM aah_file
       WHERE aah01 = l_aea05
         AND aah02 = l_y1
         AND aah03 = l_m1
#------------------------------No.MOD-B70157----------------stsrt
        #AND aah00 = g_aaz.aaz64
         AND aah00 = g_aza.aza81
   ELSE
     IF NOT cl_null(g_aza.aza82) THEN
        SELECT aah04,aah05 INTO l_c,l_d FROM aah_file
         WHERE aah01 = l_aea05
           AND aah02 = l_y1
           AND aah03 = l_m1
           AND aah00 = g_aza.aza82
     ELSE
        LET l_c = 0
        LET l_d = 0
     END IF
   END IF
#------------------------------No.MOD-B70157-------------------end 
  #會計傳票檔
   SELECT SUM(npq07) INTO l_e FROM npp_file,npq_file
    WHERE npq03 = l_aea05 AND npp01 = npq01 AND npq06='1'
      AND npp02 >= b_date
      AND npp02 < bdate
      AND npp00 = npq00
      AND npp011 = npq011
      AND nppsys = npqsys
      AND npptype = npqtype                       
#     AND npp07 = g_ae.aea00 
      AND npptype = g_npptype    #No.MOD-B70157 add
 
   SELECT SUM(npq07) INTO l_f FROM npp_file,npq_file
    WHERE npq03 = l_aea05 AND npp01 = npq01 AND npq06='2'
      AND npp02 >= b_date
      AND npp02 < bdate
      AND npp00 = npq00
      AND npp011 = npq011
      AND nppsys = npqsys
      AND npptype = npqtype              
#     AND npp07 = g_ae.aea00 
      AND npptype = g_npptype    #No.MOD-B70157 add

   IF cl_null(l_d) THEN LET l_d = 0 END IF
   IF cl_null(l_c) THEN LET l_c = 0 END IF
   IF cl_null(l_e) THEN LET l_e = 0 END IF
   IF cl_null(l_f) THEN LET l_f = 0 END IF
   LET l_bal1 = l_c -l_d
   LET l_bal = l_bal1 + l_e - l_f
   LET l_c = l_c + l_e
   LET l_d = l_d + l_f
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
 
   RETURN l_d,l_c,l_bal
END FUNCTION
#No.FUN-8A0083--END--
