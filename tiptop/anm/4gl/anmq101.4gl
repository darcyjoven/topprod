# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmq101.4gl
# Descriptions...: 應付票據查詢作業
# Date & Author..: 92/06/09 By Yen
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/11 By pengu 報表轉XML
#
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-740058 07/04/13 By Judy 匯出EXCEL多一行空白列
# Modify.........: No.TQC-770063 07/07/11 By wujie  打印條件有問題
# Modify.........: No.FUN-7B0097 07/11/19 By Dido 報表格式修改為crystal reports
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
            wc      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(600) #Head Where condition
        END RECORD,
    g_nmd DYNAMIC ARRAY OF RECORD
            nmd03   LIKE nmd_file.nmd03,
            nmd02   LIKE nmd_file.nmd02,
            nmd07   LIKE nmd_file.nmd07,
            nmd05   LIKE nmd_file.nmd05,
            nmd04   LIKE nmd_file.nmd04,
            nmd08   LIKE nmd_file.nmd08,
            nmd24   LIKE nmd_file.nmd24,
            nmd12   LIKE nmd_file.nmd12
        END RECORD,
    g_wc,g_sql      STRING,                #TQC-630166        
    g_rec_b         LIKE type_file.num5    #單身筆數 #No.FUN-680107 SMALLINT
 
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE g_str        STRING   #FUN-7B0097
 
MAIN
#     DEFINEl_time LIKE type_file.chr8	        #No.FUN-6A0082
DEFINE   l_sl	    LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
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
 
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q101_w AT p_row,p_col WITH FORM 'anm/42f/anmq101'
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    DISPLAY FORM q101_srn
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q101_q()
#    END IF
    CALL q101_menu()
    CLOSE WINDOW q101_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION q101_cs()
   CLEAR FORM #清除畫面
   CALL g_nmd.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CONSTRUCT tm.wc ON nmd03,nmd02,nmd07,nmd05,nmd04,nmd08,nmd12
       FROM s_nmd[1].nmd03,s_nmd[1].nmd02,s_nmd[1].nmd07,s_nmd[1].nmd05,
            s_nmd[1].nmd04,s_nmd[1].nmd08,s_nmd[1].nmd12
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
   IF INT_FLAG THEN RETURN END IF
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND nmdgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
   #End:FUN-980030
 
   LET g_sql = "SELECT nmd03,nmd02,nmd07,nmd05,nmd04,nmd08,nmd24,nmd12",
               " FROM nmd_file WHERE nmd30 <> 'X' AND ",tm.wc CLIPPED,
               " ORDER BY nmd03,nmd02"
   PREPARE q101_p FROM g_sql
   IF SQLCA.sqlcode
   THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
   DECLARE q101_cs CURSOR FOR q101_p
 
   # 取合乎條件筆數
   LET g_sql=" SELECT COUNT(*) FROM nmd_file",
	     " WHERE nmd30 <> 'X' AND ",tm.wc CLIPPED
   PREPARE q101_pp  FROM g_sql
   DECLARE q101_cnt   CURSOR FOR q101_pp
END FUNCTION
 
#中文的MENU
 
FUNCTION q101_menu()
 
   WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q101_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q101_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q101_q()
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q101_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q101_cnt
    FETCH q101_cnt INTO g_cnt
    DISPLAY g_cnt TO cnt
    CALL cl_getmsg('anm-059',g_lang) RETURNING g_msg
    MESSAGE g_msg
    CALL q101_b_fill() #單身
END FUNCTION
 
FUNCTION q101_b_fill()              #BODY FILL UP
 DEFINE  l_amt   LIKE nmd_file.nmd04
 
    FOR g_cnt = 1 TO g_nmd.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_nmd[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET l_amt = 0
    FOREACH q101_cs INTO g_nmd[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      IF cl_null(g_nmd[g_cnt].nmd04)
      THEN LET g_nmd[g_cnt].nmd04 = 0
      END IF
      LET l_amt = l_amt + g_nmd[g_cnt].nmd04
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_nmd.deleteElement(g_cnt)   #TQC-740058 
    LET g_rec_b = g_cnt - 1
    IF g_cnt > 1 THEN
        LET g_cnt = g_cnt -1
        DISPLAY g_cnt TO FORMONLY.cnt2
        DISPLAY l_amt TO FORMONLY.cnt3
    END IF
END FUNCTION
 
FUNCTION q101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmd TO s_nmd.*
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
        #No.MOD-530853  --end
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q101_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
        l_nmd  RECORD
                nmd03	LIKE nmd_file.nmd03,
                nmd02	LIKE nmd_file.nmd02,
                nmd07	LIKE nmd_file.nmd07,
                nmd05   LIKE nmd_file.nmd05,
                nmd04   LIKE nmd_file.nmd04,
                nmd08   LIKE nmd_file.nmd08,
                nmd24   LIKE nmd_file.nmd24,
                nmd12   LIKE nmd_file.nmd12,
                sta     LIKE ze_file.ze03            #No.FUN-680107 VARCHAR(4)
        END RECORD,
        l_za05          LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(40)
        l_chr           LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
    IF tm.wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
    #LET l_name = 'anmq101.out'                   #FUN-9B0097 mark
    #CALL cl_outnam('anmq101') RETURNING l_name   #FUN-9B0097 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#NO.CHI-6A0004--BEGIN  
#  SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#               FROM azi_file WHERE azi01 = g_aza.aza17
#      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_aza.aza17,SQLCA.sqlcode,0)   #No.FUN-660148
#         CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
#      END IF
#NO.CHI-6A0004--END
    LET g_sql="SELECT nmd03,nma02,nmd02,nmd07,nmd05,nmd04,nmd08,nmd24,nmd12 ",
              " FROM nmd_file, nma_file ",
              " WHERE nmd30 <> 'X' AND  ",tm.wc CLIPPED,
              " AND nmd03 = nma_file.nma01 "
#-----FUN-7B0097---------
#
#   PREPARE q101_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE q101_co CURSOR FOR q101_p1
#
#   START REPORT q101_rep TO l_name
#
#   FOREACH q101_co INTO l_nmd.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#          CALL s_nmdsta(l_nmd.nmd12) RETURNING l_nmd.sta
#       OUTPUT TO REPORT q101_rep(l_nmd.*)
#   END FOREACH
#
#   FINISH REPORT q101_rep
#
#   CLOSE q101_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'nmd03,nmd02,nmd07,nmd05,nmd04,nmd08,nmd12')
        RETURNING g_wc
    END IF
    LET g_str = g_wc,";",g_azi04,";",g_azi05
    CALL cl_prt_cs1("anmq101","anmq101",g_sql,g_str)
#-----END FUN-7B0097-----
 
 
END FUNCTION
 
REPORT q101_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_nma02         LIKE nma_file.nma02,    #付款銀行簡稱
        sr     RECORD
                nmd03	LIKE nmd_file.nmd03,
                nmd02	LIKE nmd_file.nmd02,
                nmd07	LIKE nmd_file.nmd07,
                nmd05   LIKE nmd_file.nmd05,
                nmd04   LIKE nmd_file.nmd04,
                nmd08   LIKE nmd_file.nmd08,
                nmd24   LIKE nmd_file.nmd24,
                nmd12   LIKE nmd_file.nmd12,
                sta     LIKE ze_file.ze03            #No.FUN-680107 VARCHAR(4)
        END RECORD,
        l_tot           LIKE nmd_file.nmd03,
        l_no            LIKE type_file.num5,         #No.FUN-680107 SMALLINT
        l_amt           LIKE nmd_file.nmd04,
        l_chr           LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.nmd03,sr.nmd02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
                  g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
                  g_x[39] clipped
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nmd03
            PRINT COLUMN g_c[31],sr.nmd03[1,6],
                  COLUMN g_c[32],l_nma02,
                  COLUMN g_c[33],sr.nmd02,
                  COLUMN g_c[34],sr.nmd07,
                  COLUMN g_c[35],sr.nmd05,
                  COLUMN g_c[36],cl_numfor(sr.nmd04,36,g_azi04) CLIPPED,
                  COLUMN g_c[37],sr.nmd08,
                  COLUMN g_c[38],sr.nmd24,
                  COLUMN g_c[39],sr.sta CLIPPED
 
        AFTER GROUP OF sr.nmd03
            LET l_no  = GROUP COUNT(*)
            LET l_amt = GROUP SUM(sr.nmd04)
            PRINT  g_dash2
            PRINT  COLUMN g_c[31],g_x[9] CLIPPED,COLUMN g_c[32],l_no,
                   COLUMN g_c[35],g_x[10] CLIPPED,COLUMN g_c[36],cl_numfor(l_amt,36,g_azi04) CLIPPED
            PRINT  g_dash2
 
        ON LAST ROW
            IF g_zz05 = 'Y'
               THEN 
#No.TQC-770063--begin
               CALL cl_wcchp(tm.wc,'nmd02,nmd07,nmd05')                                                                             
               RETURNING tm.wc                                                                                                      
               PRINT g_dash[1,g_len]                                                                                                
               CALL cl_prt_pos_wc(tm.wc) 
#                   PRINT g_dash[1,g_len]
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#No.TQC-770063--end
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
