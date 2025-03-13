# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: anmq201.4gl
# Descriptions...: 應收票據查詢作業
# Date & Author..: 92/06/09 By Yen
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/11 By pengu 報表轉XML
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-770013 07/07/02 By Judy 匯出EXCEL的值多一空白行
# Modify.........: No.FUN-830119 08/03/24 By lala 制作CR
# Modify.........: No.MOD-880195 08/08/26 By Sarah 無託收銀行不可顯示銀行簡稱
# Modify.........: No.MOD-8A0072 08/10/08 By clover 單身欄位增加確認碼nmh38
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE l_table STRING
DEFINE g_str   STRING
DEFINE
     tm  RECORD
       	wc  LIKE type_file.chr1000               #No.FUN-680107 VARCHAR(600) # Head Where condition
        END RECORD,
    g_nmh DYNAMIC ARRAY OF RECORD
            nmh24   LIKE nmh_file.nmh24,
            nmh38   LIKE nmh_file.nmh38,    #MOD-8A0072
            nmh04   LIKE nmh_file.nmh04,
            nmh05   LIKE nmh_file.nmh05,
            nmh02   LIKE nmh_file.nmh02,
            nmh31   LIKE nmh_file.nmh31,
            nmh30   LIKE nmh_file.nmh30,
            nmh21   LIKE nmh_file.nmh21,
            nmh01   LIKE nmh_file.nmh01
        END RECORD,
    g_rec_b         LIKE type_file.num5,  	 #單身筆數 #No.FUN-680107 SMALLINT
    g_wc,g_sql      STRING                       #TQC-630166
 
DEFINE g_cnt            LIKE type_file.num10     #No.FUN-680107 INTEGER
DEFINE g_i              LIKE type_file.num5      #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(72)
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0082
DEFINE         l_sl	LIKE type_file.num5      #No.FUN-680107
   DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680107 SMALLINT
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
#No.FUN-830119---start---
   LET g_sql="sta.ze_file.ze03,",
             "nmh04.nmh_file.nmh04,",
             "nmh05.nmh_file.nmh05,",
             "nmh02.nmh_file.nmh02,",
             "nmh31.nmh_file.nmh31,",
             "nmh11.nmh_file.nmh11,",
             "nmh30.nmh_file.nmh30,",
             "nmh21.nmh_file.nmh21,",
             "nma02.nma_file.nma02,",
             "nmh01.nmh_file.nmh01,",
             "nmh24.nmh_file.nmh24,",   
             "nmh38.nmh_file.nmh38"   #MOD-8A0072
   LET l_table = cl_prt_temptable('anmq201',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"   #MOD-8A0072
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-830119---end-`---
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q201_w AT p_row,p_col WITH FORM 'anm/42f/anmq201'
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#   CALL cl_ui_locale("anmq201'")
    CALL cl_ui_init()
 
#    DISPLAY FORM q201_srn
 
#    IF cl_chk_act_auth() THEN
#       CALL q201_q()
#    END IF
    CALL q201_menu()
    CLOSE WINDOW q201_w               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION q201_cs()
   CLEAR FORM #清除畫面
   CALL g_nmh.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   # 螢幕上取單頭條件
   CONSTRUCT tm.wc ON nmh24,nmh38,nmh04,nmh05,nmh02,nmh31,nmh21,nmh01    #MOD-8A0072
       FROM s_nmh[1].nmh24,s_nmh[1].nmh38,s_nmh[1].nmh04,s_nmh[1].nmh05,s_nmh[1].nmh02,  #MOD-8A0072
            s_nmh[1].nmh31,s_nmh[1].nmh21,s_nmh[1].nmh01
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
   display 'tm.wc=',tm.wc
      IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
    #End:FUN-980030
 
   LET g_sql = "SELECT nmh24,nmh38,nmh04,nmh05,nmh02,nmh31,nmh30,nmh21,nmh01",  #MOD-8A0072
               " FROM nmh_file WHERE ",tm.wc CLIPPED,
               " ORDER BY 1,3,4 "
   PREPARE q201_p FROM g_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM END IF
   DECLARE q201_cs CURSOR FOR q201_p
 
   # 取合乎條件筆數
   LET g_sql=" SELECT COUNT(*) FROM nmh_file",
	     " WHERE ",tm.wc CLIPPED
   PREPARE q201_pp  FROM g_sql
   DECLARE q201_cnt   CURSOR FOR q201_pp
END FUNCTION
 
#中文的MENU
 
FUNCTION q201_menu()
 
   WHILE TRUE
      CALL q201_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q201_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q201_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmh),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q201_q()
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q201_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q201_cnt
    FETCH q201_cnt INTO g_cnt
    DISPLAY g_cnt TO cnt
    CALL cl_getmsg('anm-060',g_lang) RETURNING g_msg
    MESSAGE g_msg
    CALL q201_b_fill() #單身
END FUNCTION
 
FUNCTION q201_b_fill()              #BODY FILL UP
 DEFINE l_amt    LIKE nmh_file.nmh02
 
    CALL g_nmh.clear()              #單身 ARRAY 乾洗
    LET g_cnt = 1
    LET l_amt = 0
    FOREACH q201_cs INTO g_nmh[g_cnt].*
      IF SQLCA.sqlcode
      THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
      END IF
      LET l_amt = l_amt + g_nmh[g_cnt].nmh02
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_nmh.deleteElement(g_cnt)  #TQC-770013
 
    LET g_rec_b = g_cnt -1
    IF g_cnt > 1 THEN
       LET g_cnt = g_cnt -1
       DISPLAY g_cnt TO FORMONLY.cnt2
       DISPLAY l_amt TO FORMONLY.cnt3
    END IF
END FUNCTION
 
FUNCTION q201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmh TO s_nmh.*
 
      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-830119---start---
FUNCTION q201_out()
DEFINE l_i             LIKE type_file.num5,      #No.FUN-680107 SMALLINT
       l_name          LIKE type_file.chr20,     # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#      l_nmh  RECORD
#                sta     LIKE ze_file.ze03,        #No.FUN-680107 VARCHAR(6)
#                nmh24   LIKE nmh_file.nmh24,
#                nmh04   LIKE nmh_file.nmh04,
#                nmh05   LIKE nmh_file.nmh05,
#                nmh02   LIKE nmh_file.nmh02,
#                nmh31   LIKE nmh_file.nmh31,
#                nmh30   LIKE nmh_file.nmh30,
#                nmh21   LIKE nmh_file.nmh21,
#                nmh01   LIKE nmh_file.nmh01
#        END RECORD,
#No.FUN-830119---end---
       sr   RECORD
                sta     LIKE ze_file.ze03,
                nmh24   LIKE nmh_file.nmh24,
                nmh38   LIKE nmh_file.nmh38,   #MOD-8A0072
                nmh04	LIKE nmh_file.nmh04,
                nmh05	LIKE nmh_file.nmh05,
                nmh02   LIKE nmh_file.nmh02,
                nmh31   LIKE nmh_file.nmh31,
                nmh11   LIKE nmh_file.nmh11,
                nmh30   LIKE nmh_file.nmh30,
                nmh21   LIKE nmh_file.nmh21,
                nmh01   LIKE nmh_file.nmh01
       END RECORD,
       l_za05           LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(40)
       l_chr            LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
       l_nma02          LIKE nma_file.nma02        #No.FUN-830119
 
    IF tm.wc IS NULL THEN
#      CALL cl_err('',-400,0)
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)    #MOD-8A0072
    #LET l_name = 'anmq201.out'                                                 #No.FUN-830119
    #CALL cl_outnam('anmq201') RETURNING l_name                                 #No.FUN-830119
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    #LET g_sql="SELECT ' ',nmh24,nmh04,nmh05,nmh02,nmh31,nmh11,nmh30,nmh21,",
     LET g_sql="SELECT ' ',nmh24,nmh38,nmh04,nmh05,nmh02,nmh31,nmh11,nmh30,nmh21,",  #MOD-8A0072
              " nmh01 FROM nmh_file",
    #          " WHERE nmh38 <> 'X' AND ",tm.wc CLIPPED  #MOD-8A0072
              " WHERE ", tm.wc CLIPPED                   #MOD-8A0072
 
    PREPARE q201_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE q201_co CURSOR FOR q201_p1
 
    #START REPORT q201_rep TO l_name
#No.FUN-830119---start---
    FOREACH q201_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #SELECT nmh24,COUNT(*),sum(nmh02) FROM nmh_file where nmh24=sr.nmh24
        #GROUP BY nmh24
        #CALL s_nmhsta(l_nmh.nmh24) RETURNING l_nmh.sta
        CALL s_nmhsta(sr.nmh24) RETURNING sr.sta
        LET l_nma02 = ''   #MOD-880195 add
        SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nmh21
 
        EXECUTE insert_prep USING
           sr.sta,sr.nmh04,sr.nmh05,sr.nmh02,sr.nmh31,sr.nmh11,
           sr.nmh30,sr.nmh21,l_nma02,sr.nmh01,sr.nmh24,sr.nmh38   #MOD-8A0072
        #OUTPUT TO REPORT q201_rep(l_nmh.*)
    END FOREACH
    #CALL cl_wcchp(tm.wc,'nmh24,nmh04,nmh05,nmh02,nmh31,nmh21,nmh01')  #MOD-8A0072
    CALL cl_wcchp(tm.wc,'nmh24,nmh38,nmh04,nmh05,nmh02,nmh31,nmh21,nmh01')   #MOD-8A0072
             RETURNING tm.wc
    LET g_str=tm.wc
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('anmq201','anmq201',g_sql,g_str)
    #FINISH REPORT q201_rep
 
    #CLOSE q201_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
#REPORT q201_rep(sr)
#    DEFINE
#        l_trailer_sw  LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
#        l_nma02       LIKE nma_file.nma02,       #銀行簡稱
#        sr     RECORD
#                sta     LIKE ze_file.ze03,       #No.FUN-680107 VARCHAR(06)
#                nmh24	LIKE nmh_file.nmh24,
#                nmh04	LIKE nmh_file.nmh04,
#                nmh05	LIKE nmh_file.nmh05,
#                nmh02   LIKE nmh_file.nmh02,
#                nmh31   LIKE nmh_file.nmh31,
#                nmh30   LIKE nmh_file.nmh30,
#                nmh21   LIKE nmh_file.nmh21,
#                nmh01   LIKE nmh_file.nmh01
#        END RECORD,
#        l_amt           LIKE nmh_file.nmh02,
#        l_no            LIKE type_file.num5,     #No.FUN-680107 SMALLINT
#        l_chr           LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.nmh24,sr.nmh04,sr.nmh05
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#                  g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#                  g_x[39] clipped,g_x[40] clipped
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
 
#        ON EVERY ROW
#            SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nmh21
#            PRINT COLUMN g_c[31],sr.sta,
#                  COLUMN g_c[32],sr.nmh04,
#                  COLUMN g_c[33],sr.nmh05,
#                  COLUMN g_c[34],cl_numfor(sr.nmh02,34,g_azi04) clipped,
#                  COLUMN g_c[35],sr.nmh31,
#                  COLUMN g_c[36],sr.nmh11,
#                  COLUMN g_c[37],sr.nmh30,
#                  COLUMN g_c[38],sr.nmh21 CLIPPED,
#                  COLUMN g_c[39],l_nma02,
#                  COLUMN g_c[40],sr.nmh01 CLIPPED
 
#        AFTER GROUP OF sr.nmh24
#            LET l_no  = GROUP COUNT(*)
#            LET l_amt = GROUP SUM(sr.nmh02)
#            PRINT  g_dash2[1,g_len]
#            PRINT  COLUMN g_c[31],g_x[9] clipped,COLUMN g_c[32],l_no,
#                   column g_c[33],g_x[10] clipped,COLUMN g_c[34],cl_numfor(l_amt,34,g_azi04) CLIPPED
#            PRINT  g_dash2[1,g_len]
 
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash[1,g_len]
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-830119---end---
