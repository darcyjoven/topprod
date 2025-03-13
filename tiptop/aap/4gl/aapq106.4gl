# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapq106.4gl
# Descriptions...: 多發票付款查詢
# Date & Author..: 97/01/28 BY Star
# Modify.........: 01/04/19 BY ANN CHEN No.B373
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-540057 05/05/09 By wujie 發票號碼調整
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/24 By douzh l_time轉g_time
# Modify.........: No.FUN-690080 06/10/25 By ice 查詢帳款,增加13,17,25類型的判斷與關聯
# Modify.........: No.TQC-6B0104 06/11/20 By Rayven 查詢時，錄入無效的發票號碼或編號，點"查詢帳款"也能查詢出相應的帳款信息
#                                                   匯出EXCEL匯出的值多出一空白行
# Modify.........: No.FUN-6B0033 06/11/27 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-6C0124 06/12/19 By Smapmin DEFINE payno
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C50153 12/05/17 By xuxz apf41判斷
# Modify.........: No.MOD-D20127 13/02/22 By Polly 帳款編號開窗改用q_apa07
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_apk RECORD LIKE apk_file.*,
       g_nmd DYNAMIC ARRAY OF RECORD
             #payno  LIKE faj_file.faj02,      # No.FUN-690028 VARCHAR(10)   #MOD-6C0124
             payno  LIKE aph_file.aph01,      # No.FUN-690028 VARCHAR(10)   #MOD-6C0124
             seq    LIKE type_file.num5,        # No.FUN-690028 SMALLINT
             aph04  LIKE aph_file.aph04,
             amtf   LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
             amt    LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
             nmd02  LIKE nmd_file.nmd02,
             nmd05  LIKE nmd_file.nmd05,
             nmd04  LIKE nmd_file.nmd04
       END RECORD,
        g_wc        string,  #No.FUN-580092 HCN
        g_wc2       string,  #No.FUN-580092 HCN
        g_sql       string,  #No.FUN-580092 HCN
       l_ac         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
#NO.FUN540057--begin
       g_argv1      LIKE apk_file.apk01,      # No.FUN-690028 VARCHAR(16)
#NO.FUN540057--end
       g_rec_b LIKE type_file.num5  		  #單身筆數  #No.FUN-690028 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0055
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q106_w AT p_row,p_col
         WITH FORM "aap/42f/aapq106"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    LET g_argv1 = ARG_VAL(1)
    IF NOT cl_null(g_argv1)
       THEN CALL q106_q()
    END IF
    CALL q106_menu()
    CLOSE WINDOW q106_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION q106_cs()
    CLEAR FORM
   CALL g_nmd.clear()
 
    IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT apk01,apk02,apk03 FROM apk_file ", # 組合出 SQL 指令
                 " WHERE apk01 ='",g_argv1, "'",
                 " ORDER BY apk01"
    ELSE
       CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INITIALIZE g_apk.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON apk03,apk05,apa06,apa07,apk01,apk08,apk07
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION CONTROLP
             CASE WHEN INFIELD(apa06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pmc1"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apa06
                  WHEN INFIELD(apk01)
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_apa"          #MOD-D20127 mark
                    LET g_qryparam.form ="q_apa07"        #MOD-D20127 add
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apk01
             END CASE
 
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
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND apauser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
       #End:FUN-980030
 
       LET g_sql="SELECT apk01,apk02,apk03 ",     #組合出 SQL 指令
                 " FROM apa_file,apk_file ",
                 " WHERE apa01 = apk01 ",
                 "   AND apa00 matches '1*' ",
                 "   AND ",g_wc CLIPPED, " ORDER BY apk01"
    END IF
 
    PREPARE q106_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q106_cs                         # SCROLL CURSOR
        SCROLL CURSOR FOR q106_prepare
    IF NOT cl_null(g_argv1) THEN
        LET g_sql = "SELECT COUNT(*) FROM apk_file WHERE apk03 ='",g_argv1,"'"
    ELSE
        LET g_sql= "SELECT COUNT(*) FROM apa_file,apk_file",
                   " WHERE apa01 = apk01 ",
                   "   AND apa00 matches '1*' ",
                   "   AND ",g_wc CLIPPED
    END IF
    PREPARE q106_pre_count FROM g_sql
    DECLARE q106_count CURSOR FOR q106_pre_count
 
END FUNCTION
 
FUNCTION q106_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(100)
   DEFINE   l_apa00   LIKE apa_file.apa00
   DEFINE   l_prog    LIKE zz_file.zz01      # No.FUN-690028 VARCHAR(10)
 
   WHILE TRUE
      CALL q106_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q106_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_nmd),'','')
             END IF
         #--
 
         ##No.B373
         WHEN "query_account"
            SELECT apa00 INTO l_apa00 FROM apa_file
            WHERE apa01=g_apk.apk01
            IF STATUS THEN LET l_apa00 = '' END IF
            LET g_msg=g_apk.apk01
            LET l_prog = ''  #No.TQC-6B0104
            CASE l_apa00
              WHEN '11' LET l_prog = 'aapt110'
              WHEN '12' LET l_prog = 'aapt120'
              WHEN '13' LET l_prog = 'aapt121'        #No.FUN-690080
              WHEN '15' LET l_prog = 'aapt150'
              WHEN '17' LET l_prog = 'aapt151'        #No.FUN-690080
              WHEN '21' LET l_prog = 'aapt210'
              WHEN '22' LET l_prog = 'aapt220'
              WHEN '23' LET l_prog = 'aapq230'
              WHEN '24' LET l_prog = 'aapq240'
              WHEN '25' LET l_prog = 'aapq231'        #No.FUN-690080
            END CASE
            LET l_cmd = l_prog," '",g_apk.apk01,"'"
           #--No.FUN-660216-------
            #CALL cl_cmdrun(l_cmd)
            IF l_prog MATCHES "aapt*"  THEN
                CALL cl_cmdrun_wait(l_cmd)
            ELSE
                CALL cl_cmdrun(l_cmd)
            END IF
           #--No.FUN-660216--end--
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q106_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q106_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_nmd.clear()
        RETURN
    END IF
    OPEN q106_count
    FETCH q106_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q106_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apk.apk01,SQLCA.sqlcode,0)
        INITIALIZE g_apk.* TO NULL
    ELSE
        CALL q106_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q106_fetch(p_flapa)
    DEFINE
        p_flapa          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flapa
        WHEN 'N' FETCH NEXT     q106_cs INTO g_apk.apk01,g_apk.apk02,g_apk.apk03
        WHEN 'P' FETCH PREVIOUS q106_cs INTO g_apk.apk01,g_apk.apk02,g_apk.apk03
        WHEN 'F' FETCH FIRST    q106_cs INTO g_apk.apk01,g_apk.apk02,g_apk.apk03
        WHEN 'L' FETCH LAST     q106_cs INTO g_apk.apk01,g_apk.apk02,g_apk.apk03
        WHEN '/'
            IF NOT mi_no_ask THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump q106_cs INTO g_apk.apk01,g_apk.apk02,g_apk.apk03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apk.apk01,SQLCA.sqlcode,0)
        INITIALIZE g_apk.* TO NULL  #TQC-6B0105
        LET g_apk.apk01 = ''        #TQC-6B0104
        RETURN
    ELSE
       CASE p_flapa
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_apk.* FROM apk_file    # 重讀DB,因TEMP有不被更新特性
       WHERE apk01 = g_apk.apk01 AND apk02 = g_apk.apk02 AND apk03 = g_apk.apk03
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_apk.apk01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("sel","apk_file",g_apk.apk01,g_apk.apk02,SQLCA.sqlcode,"","",0) #No.FUN-660122
    ELSE
 
        CALL q106_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q106_show()
DEFINE   l_sta     LIKE gsb_file.gsb05      # No.FUN-690028 VARCHAR(04)
DEFINE   l_apa06   LIKE apa_file.apa06
DEFINE   l_apa07   LIKE apa_file.apa07
 
   DISPLAY BY NAME g_apk.apk03,g_apk.apk05,g_apk.apk01,g_apk.apk08,g_apk.apk07
   SELECT apa06,apa07 INTO l_apa06,l_apa07 FROM apa_file
                     WHERE apa01 = g_apk.apk01
   DISPLAY l_apa06 TO FORMONLY.apa06
   DISPLAY l_apa07 TO FORMONLY.apa07
 
   CALL q106_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q106_b_fill()              #BODY FILL UP
  DEFINE  l_azp RECORD LIKE azp_file.*,
          l_apg01      LIKE apg_file.apg01
  DEFINE l_apf41       LIKE apf_file.apf41 #TQC-C50153 add
 
  FOR g_cnt = 1 TO g_nmd.getLength()           #單身 ARRAY 乾洗
      INITIALIZE g_nmd[g_cnt].* TO NULL
  END FOR
  LET g_cnt = 1


 DECLARE q106_b_apg CURSOR FOR
   SELECT UNIQUE apg01 FROM apg_file WHERE apg04 = g_apk.apk01
 FOREACH q106_b_apg INTO l_apg01
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)   
       EXIT FOREACH
    END IF
    #TQC-C50153-add-str
    LET l_apf41 ='N'
    SELECT apf41 INTO l_apf41 FROM apf_file 
     WHERE apf01 = l_apg01
    IF l_apf41 !='Y' THEN 
       CONTINUE FOREACH
    END IF 
   #TQC-C50153-add-end
    LET g_sql =
        "SELECT aph01,aph02,aph03,aph05f,aph05,' ',aph07,' ' ",
        "  FROM aph_file  ",
        " WHERE aph01 = '",l_apg01,"' ",
        " ORDER BY 1,2 "

    PREPARE q106_pb FROM g_sql
    DECLARE aph_curs                      #SCROLL CURSOR
        CURSOR FOR q106_pb
 
    FOREACH aph_curs INTO g_nmd[g_cnt].*           #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT MAX(nmd02),MAX(nmd05),MAX(nmd04)
          INTO g_nmd[g_cnt].nmd02,g_nmd[g_cnt].nmd05,g_nmd[g_cnt].nmd04
          FROM nmd_file WHERE nmd10=l_apg01
                          AND nmd101 =g_nmd[g_cnt].seq
                          AND nmd30 <> 'X'
          CASE g_lang
           WHEN '0'
                CASE g_nmd[g_cnt].aph04
                    WHEN '0' LET g_nmd[g_cnt].aph04 = '應收'
                    WHEN '1' LET g_nmd[g_cnt].aph04 = '支票'
                    WHEN '2' LET g_nmd[g_cnt].aph04 = '轉帳'
                    WHEN '3' LET g_nmd[g_cnt].aph04 = '郵資'
                    WHEN '4' LET g_nmd[g_cnt].aph04 = '匯盈'
                    WHEN '5' LET g_nmd[g_cnt].aph04 = '匯損'
                    WHEN '6' LET g_nmd[g_cnt].aph04 = '折讓沖帳'
                    WHEN '7' LET g_nmd[g_cnt].aph04 = 'D.M.沖帳'
                    WHEN '8' LET g_nmd[g_cnt].aph04 = '預付沖帳'
                    WHEN '9' LET g_nmd[g_cnt].aph04 = '暫付沖帳'
                    OTHERWISE LET g_nmd[g_cnt].aph04 = ' '
                END CASE
           WHEN '2'
                CASE g_nmd[g_cnt].aph04
                    WHEN '0' LET g_nmd[g_cnt].aph04 = '應收'
                    WHEN '1' LET g_nmd[g_cnt].aph04 = '支票'
                    WHEN '2' LET g_nmd[g_cnt].aph04 = '轉帳'
                    WHEN '3' LET g_nmd[g_cnt].aph04 = '郵資'
                    WHEN '4' LET g_nmd[g_cnt].aph04 = '匯盈'
                    WHEN '5' LET g_nmd[g_cnt].aph04 = '匯損'
                    WHEN '6' LET g_nmd[g_cnt].aph04 = '折讓沖帳'
                    WHEN '7' LET g_nmd[g_cnt].aph04 = 'D.M.沖帳'
                    WHEN '8' LET g_nmd[g_cnt].aph04 = '預付沖帳'
                    WHEN '9' LET g_nmd[g_cnt].aph04 = '暫付沖帳'
                    OTHERWISE LET g_nmd[g_cnt].aph04 = ' '
                END CASE
          OTHERWISE
               CASE g_nmd[g_cnt].aph04
                   WHEN '0' LET g_nmd[g_cnt].aph04 = 'A/R '
                   WHEN '1' LET g_nmd[g_cnt].aph04 = 'Chk '
                   WHEN '2' LET g_nmd[g_cnt].aph04 = 'Tran'
                   WHEN '3' LET g_nmd[g_cnt].aph04 = 'Post'
                   WHEN '4' LET g_nmd[g_cnt].aph04 = 'Ex G'
                   WHEN '5' LET g_nmd[g_cnt].aph04 = 'Ex L'
                   WHEN '6' LET g_nmd[g_cnt].aph04 = 'Disco'
                   WHEN '7' LET g_nmd[g_cnt].aph04 = 'DM'
                   WHEN '8' LET g_nmd[g_cnt].aph04 = 'Temp'
                   WHEN '9' LET g_nmd[g_cnt].aph04 = 'Over'
                   OTHERWISE LET g_nmd[g_cnt].aph04 =' '
               END CASE
        END CASE
        LET g_cnt = g_cnt + 1
        #IF g_cnt > g_nmd_arrno THEN
        #   EXIT FOREACH
        #END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #IF g_cnt > g_nmd_arrno THEN EXIT FOREACH END IF
 END FOREACH
    #---->直接沖帳(apv_file)
    LET g_sql =
           "SELECT apv03,' ',' ',apv04f,apv04,' ',' '  ,' ' ",
           "  FROM apv_file  ",
           " WHERE apv01 = '",g_apk.apk01,"' ",
           " ORDER BY 1 "
 
    PREPARE q106_pb1 FROM g_sql
    DECLARE apv_curs                      #SCROLL CURSOR
        CURSOR FOR q106_pb1
 
    FOREACH apv_curs INTO g_nmd[g_cnt].*           #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        #IF g_cnt > g_nmd_arrno THEN
        #   EXIT FOREACH
        #END IF
    #IF g_cnt > g_nmd_arrno THEN EXIT FOREACH END IF
    END FOREACH
    CALL g_nmd.deleteElement(g_cnt)      #No.TQC-6B0104
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    #IF g_cnt > g_nmd_arrno THEN
    #   CALL cl_err('',9036,0)
    #END IF
END FUNCTION
 
FUNCTION q106_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmd TO s_nmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q106_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q106_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q106_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q106_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q106_fetch('L')
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
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION query_account
         LET g_action_choice="query_account"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
