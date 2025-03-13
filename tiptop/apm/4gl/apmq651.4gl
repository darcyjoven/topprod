# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmq651.4gl
# Descriptions...: 預算耗用/可用餘額查詢(明細)
# Date & Author..: 08/03/06 By destiny  #No.FUN-810069 因項目預算的表發生重大改變故重寫
# Modify.........: No.FUN-830139 08/04/10 By douzh s_budamt.4gl參數變更
# Modify.........: No.TQC-840049 08/04/20 By destiny 調整QBE順序
# Modify.........: No.MOD-840181 08/04/22 By destiny 調整QBE順序
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B40070 11/04/11 By lilingyu 查詢畫面時,出現-284的錯誤
# Modify.........: No.MOD-B50054 11/05/06 By lilingyu fetch中的sql增加 afb041 afb042
# Modify.........: No.FUN-B50182 11/05/31 By zhangll 增加"本期可用预算",并调整可用余额
# Modify.........: No.FUN-B60055 11/06/09 By zhangll FUN-B50182改善
# Modify.........: No.MOD-C20024 12/02/03 By Vampire 單身"總額可用預算"調整為各期預算(afc06)+挪用金額(afc08)+追加金額(afc09)
 
DATABASE ds

GLOBALS "../../config/top.global"
 
  #No.FUN-830139  --Begin
  DEFINE g_argv1	LIKE afb_file.afb00     # 所要查詢的key
  DEFINE g_argv2	LIKE afb_file.afb01     # 所要查詢的key
  DEFINE g_argv3	LIKE afb_file.afb02     # 所要查詢的key
  DEFINE g_argv4	LIKE afb_file.afb03     # 所要查詢的key
  DEFINE g_argv5	LIKE afb_file.afb04     # 所要查詢的key
  DEFINE g_argv6	LIKE afb_file.afb041    # 所要查詢的key
  DEFINE g_argv7	LIKE afb_file.afb042    # 所要查詢的key
  #No.FUN-830139  --End  
  DEFINE g_wc,g_wc2	string             	# WHERE CONDICTION  
  DEFINE g_sql		string  
  DEFINE g_afb 	RECORD
                afb00   LIKE afb_file.afb00,
                afb01   LIKE afb_file.afb01,
#               afa02   LIKE afa_file.afa02,    #No.FUN-830139
                azf03   LIKE azf_file.azf03,    #No.FUN-830139
                afb041  LIKE afb_file.afb041,
                gem02   LIKE gem_file.gem02,
                afb02   LIKE afb_file.afb02,
                aag02   LIKE aag_file.aag02,
                afb03   LIKE afb_file.afb03,
                afb04   LIKE afb_file.afb04,
                afb042  LIKE afb_file.afb042
                END RECORD
  DEFINE g_sr DYNAMIC ARRAY OF RECORD
                        afc05   LIKE afc_file.afc05,
                        afc06   LIKE afc_file.afc06,
                        all_amt LIKE afc_file.afc06,  #FUN-B50182 add
                        amt1    LIKE afc_file.afc06,     
                        amt2    LIKE afc_file.afc06,     
                        amt3    LIKE afc_file.afc06,     
                        amt4    LIKE afc_file.afc06,      
                        amt5    LIKE afc_file.afc06,      
                        amt6    LIKE afc_file.afc06,     
                        res_amt LIKE afc_file.afc06    
            		END RECORD
DEFINE g_bookno1       LIKE aza_file.aza81          
DEFINE g_bookno2       LIKE aza_file.aza82          
DEFINE g_flag          LIKE type_file.chr1          
DEFINE p_row,p_col     LIKE type_file.num5          
DEFINE g_cnt           LIKE type_file.num10        
DEFINE g_msg           LIKE type_file.chr1000,   
       g_rec_b         LIKE type_file.num5,         
       l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT 
 
DEFINE   g_row_count    LIKE type_file.num10       
DEFINE   g_curs_index   LIKE type_file.num10       


MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)
    LET g_argv5 = ARG_VAL(5)  #No.FUN-830139
    LET g_argv6 = ARG_VAL(6)  #No.FUN-830139
    LET g_argv7 = ARG_VAL(7)  #No.FUN-830139

    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q651_w AT p_row,p_col
        WITH FORM "apm/42f/apmq651"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("all_amt",TRUE)  #FUN-B60055 add
    IF NOT cl_null(g_argv1) THEN CALL q651_q() END IF
    CALL q651_menu()
    CLOSE WINDOW q651_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q651_cs()
   DEFINE   l_cnt LIKE type_file.num5        
 
   IF NOT cl_null(g_argv1)
      #No.FUN-830139  --Begin
      THEN LET g_wc = "afb00 = '",g_argv1,"' AND ",
                      "afb01 = '",g_argv2,"' AND ",
                      "afb02 = '",g_argv3,"' AND ",
                      "afb03 =  ",g_argv4,"  AND ",
                      "afb04 = '",g_argv5,"' AND ",
                      "afb041 = '",g_argv6,"' AND ",
                      "afb042 = '",g_argv7,"' "
      #No.FUN-830139  --End  
	   LET g_wc2=" 1=1 "
   ELSE CLEAR FORM #清除畫面
   CALL g_sr.clear()
       CALL cl_opmsg('q')
       CALL cl_set_head_visible("","YES")           
   INITIALIZE g_afb.* TO NULL    
#      CONSTRUCT BY NAME g_wc ON afb00,afb03,afb041,afb01,afb02,afb042,afb04 # 螢幕上取單頭條件   No.TQC-840049
       CONSTRUCT BY NAME g_wc ON afb00,afb03,afb01,afb02,afb041,afb042,afb04 # 螢幕上取單頭條件   No.MOD-840181
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about        
             CALL cl_about()     
 
          ON ACTION help          
             CALL cl_show_help()  
 
          ON ACTION controlg     
             CALL cl_cmdask()     
 
          ON ACTION qbe_select
             CALL cl_qbe_select()
 
          ON ACTION qbe_save
             CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND afbuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND afbgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN              #群組權限
       #          LET g_wc = g_wc clipped," AND afbgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('afbuser', 'afbgrup')
       #End:FUN-980030
 
       LET g_wc2=" 1=1 "
   END IF
   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE afb_file.afb00,afb01,afb041,afc02,afb03,afb04,afb042",
             "  FROM afb_file,afc_file ",
             " WHERE afb01=afc01 AND afb02=afc02 AND afb041=afc041 ",
             "   AND afb03=afc03 AND afb00=afc00 AND afb04=afc04 ",
             "   AND afb042=afc042 AND ",g_wc CLIPPED,
#             " ORDER BY afb00,afb01,afb041,afb02,afb03,afb04,afb042"
             " ORDER BY 1,2,3,4,5,6,7"
   PREPARE q651_prepare FROM g_sql
   DECLARE q651_cs SCROLL CURSOR FOR q651_prepare
   LET g_sql=" SELECT COUNT(*) FROM afb_file ",
             " WHERE ",g_wc CLIPPED
   PREPARE q651_pp  FROM g_sql
   DECLARE q651_cnt CURSOR FOR q651_pp
END FUNCTION
 
FUNCTION q651_menu()
 
   WHILE TRUE
      CALL q651_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q651_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q651_q()
 
    CALL cl_set_comp_visible("all_amt",TRUE)  #FUN-B60055 add
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q651_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q651_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q651_cnt
        FETCH q651_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q651_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q651_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        
    l_abso          LIKE type_file.num10                 #絕對的筆數     
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q651_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb041,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb042
        WHEN 'P' FETCH PREVIOUS q651_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb041,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb042
        WHEN 'F' FETCH FIRST    q651_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb041,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb042
        WHEN 'L' FETCH LAST     q651_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb041,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb042
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      END PROMPT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT CASE
      END IF
            FETCH ABSOLUTE l_abso q651_cs INTO g_afb.afb00,g_afb.afb01,g_afb.afb041,g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb042
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        INITIALIZE g_afb.* TO NULL  
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
	SELECT DISTINCT afb00,afb01,'',afb041,'',afb02,'',afb03,afb04,afb042 INTO g_afb.*    #TQC-B40070 add DISTINCT
          FROM afb_file WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01
                         AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
                         AND afb04 = g_afb.afb04
#                        AND ROWNUM <=1    #TQC-B40070 add        #MOD-B50054 
                         AND afb041 = g_afb.afb041                #MOD-B50054 
                         AND afb042 = g_afb.afb042                #MOD-B50054 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","afb_file",g_afb.afb01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF
 
 
    CALL s_get_bookno(g_afb.afb03) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_afb.afb03,'aoo-081',1)
    END IF
    CALL q651_show()
END FUNCTION
 
FUNCTION q651_show()
#FUN-830139--begin
#  SELECT afa02 INTO g_afb.afa02 FROM afa_file WHERE afa01=g_afb.afb01
#                                               AND afa00=g_aza.aza81                  
   SELECT azf03 INTO g_afb.azf03 FROM azf_file WHERE azf01=g_afb.afb01
                                                 AND azf02= '2'
#FUN-830139--begin
   SELECT aag02 INTO g_afb.aag02 FROM aag_file WHERE aag01=g_afb.afb02
                                                 AND aag00=g_bookno1
   SELECT gem02 INTO g_afb.gem02 FROM gem_file WHERE gem01=g_afb.afb041
   DISPLAY BY NAME g_afb.*
   CALL q651_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q651_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(1000)
   DEFINE l_tot     LIKE type_file.num10      #No.FUN-680136 INTEGER
#No.FUN-830139  --Begin
DEFINE l_flag          LIKE type_file.chr1
DEFINE l_flag1         LIKE type_file.chr1
DEFINE l_bookno1       LIKE aaa_file.aaa01
DEFINE l_bookno2       LIKE aaa_file.aaa01
#No.FUN-830139  --End  
#FUN-B50182 add
DEFINE l_afb18         LIKE afb_file.afb18  #是否做总额控制
DEFINE l_afb09         LIKE afb_file.afb09  #本预算上期未消耗预算可否递
#FUN-B50182 add--end
DEFINE l_res_amt_t     LIKE afc_file.afc06  #FUN-B60055 add 上期餘額(舊值)
DEFINE l_afc08         LIKE afc_file.afc08  #MOD-C20024 add
DEFINE l_afc09         LIKE afc_file.afc09  #MOD-C20024 add
 
   CALL cl_wait()
   #FUN-B50182 add
   SELECT afb18,afb09 INTO l_afb18,l_afb09
     FROM afb_file
    WHERE afb00 = g_afb.afb00
      AND afb01 = g_afb.afb01
      AND afb02 = g_afb.afb02
      AND afb03 = g_afb.afb03
      AND afb04 = g_afb.afb04
      AND afb041= g_afb.afb041
      AND afb042= g_afb.afb042
   IF cl_null(l_afb18) THEN LET l_afb18 = 'N' END IF  #總額控制
   IF cl_null(l_afb09) THEN LET l_afb09 = 'N' END IF  #遞延
   #FUN-B50182 add--end
   #FUN-B60055 add 
   CALL cl_set_comp_visible("all_amt",TRUE)
   IF l_afb18 = 'N' AND l_afb09 = 'N' THEN
      CALL cl_set_comp_visible("all_amt",FALSE)
   END IF
   #FUN-B60055 add--end
   LET l_sql =
        "SELECT afc05,afc06,0,0,0,0,0,0,0",
        "  FROM afc_file ",
        " WHERE afc00='",g_afb.afb00,"' AND afc01='",g_afb.afb01,"' AND afc02='",g_afb.afb02,"' ",
        "   AND afc04='",g_afb.afb04,"' AND afc03='",g_afb.afb03,"' AND afc041='",g_afb.afb041,"' ",
        "   AND afc042='",g_afb.afb042,"' ",
        " ORDER BY afc05 "
    PREPARE q651_pb FROM l_sql
    DECLARE q651_bcs CURSOR FOR q651_pb
 
    FOR g_cnt = 1 TO g_sr.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sr[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET l_tot = 0
    LET l_res_amt_t = 0  #FUN-B60055 add
    FOREACH q651_bcs INTO g_sr[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #------------------------------------------ 已耗金額
#No.FUN-830139 ...begin
#       CALL s_budamt(g_afb.afb041,g_afb.afb01,g_afb.afb02,
#                     g_afb.afb03,g_sr[g_cnt].afc05)
        CALL s_get_bookno(g_afb.afb03) RETURNING l_flag,l_bookno1,l_bookno2
        IF l_bookno1 = g_afb.afb00 THEN
           LET l_flag1 = '0'
        ELSE
           LET l_flag1 = '1'
        END IF
       #FUN-B60055 mod s_budamt1->q651_getamt 未來可根據需要提取公用
       #CALL s_budamt1(g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,
        CALL q651_getamt(g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04,
       #FUN-B60055 mod--end s_budamt1->q651_getamt 未來可根據需要提取公用
                       g_afb.afb041,g_afb.afb042,g_sr[g_cnt].afc05,l_flag1)
#No.FUN-830139 ...end
             RETURNING g_sr[g_cnt].amt1, g_sr[g_cnt].amt2, g_sr[g_cnt].amt3,
                       g_sr[g_cnt].amt4, g_sr[g_cnt].amt5, g_sr[g_cnt].amt6
       #FUN-B60055 mod
       ##FUN-B50182 add
       #IF l_afb18='Y' THEN
       #   SELECT SUM(afc06) INTO g_sr[g_cnt].all_amt FROM afc_file
       #    WHERE afc00=g_afb.afb00 AND afc01=g_afb.afb01 AND afc02=g_afb.afb02
       #      AND afc04=g_afb.afb04 AND afc03=g_afb.afb03 AND afc041=g_afb.afb041
       #      AND afc042=g_afb.afb042
       #ELSE
       #   IF l_afb09='Y' THEN #递延 则 本期别及以上期别的预算加总
       #      SELECT SUM(afc06) INTO g_sr[g_cnt].all_amt FROM afc_file
       #       WHERE afc00=g_afb.afb00 AND afc01=g_afb.afb01 AND afc02=g_afb.afb02
       #         AND afc04=g_afb.afb04 AND afc03=g_afb.afb03 AND afc041=g_afb.afb041
       #         AND afc042=g_afb.afb042
       #         AND afc05<=g_sr[g_cnt].afc05
       #   ELSE  #不递延且不做总额控制 则 本期别的预算
       #      LET g_sr[g_cnt].all_amt = g_sr[g_cnt].afc06
       #   END IF
       #END IF
       ##FUN-B50182 add--end
        #總額可用預算amt_all 數值來源
        #做总额控制 
        #  首期： 為各期别预算加总
        #  後期：均為上期餘額
        #不做總額控制  分 遞延和非遞延
        #  遞延：為上期餘額+本月預算
        #  非遞延：為各期預算
        IF l_afb18='Y' THEN #總額
           IF g_cnt=1 THEN  #FUN-B60055 add
              #SELECT SUM(afc06) INTO g_sr[g_cnt].all_amt FROM afc_file                        #MOD-C20024 mark
              SELECT (SUM(afc06)+SUM(afc08)+SUM(afc09)) INTO g_sr[g_cnt].all_amt FROM afc_file #MOD-C20024 add
               WHERE afc00=g_afb.afb00 AND afc01=g_afb.afb01 AND afc02=g_afb.afb02
                 AND afc04=g_afb.afb04 AND afc03=g_afb.afb03 AND afc041=g_afb.afb041
                 AND afc042=g_afb.afb042
           ELSE
              LET g_sr[g_cnt].all_amt = l_res_amt_t
           END IF
        ELSE
           #MOD-C20024 ----- modify start -----
           SELECT afc08, afc09 INTO l_afc08,l_afc09 FROM afc_file
            WHERE afc00=g_afb.afb00 AND afc01=g_afb.afb01 AND afc02=g_afb.afb02
              AND afc04=g_afb.afb04 AND afc03=g_afb.afb03 AND afc041=g_afb.afb041
              AND afc042=g_afb.afb042 AND afc05=g_sr[g_cnt].afc05
           IF cl_null(l_afc08) THEN LET l_afc08 = 0 END IF
           IF cl_null(l_afc09) THEN LET l_afc09 = 0 END IF
           #MOD-C20024 ----- modify end -----
           IF l_afb09='Y' THEN #递延
              #LET g_sr[g_cnt].all_amt = g_sr[g_cnt].afc06 + l_res_amt_t                     #MOD-C20024 mark
              LET g_sr[g_cnt].all_amt = g_sr[g_cnt].afc06 + l_afc08 + l_afc09 + l_res_amt_t  #MOD-C20024 add
           ELSE  #不递延
              #LET g_sr[g_cnt].all_amt = g_sr[g_cnt].afc06                                   #MOD-C20024 mark
              LET g_sr[g_cnt].all_amt = g_sr[g_cnt].afc06 + l_afc08 + l_afc09                #MOD-C20024 add
           END IF
        END IF
       #FUN-B60055 mod--end
       #LET g_sr[g_cnt].res_amt=g_sr[g_cnt].afc06- g_sr[g_cnt].amt1-
        LET g_sr[g_cnt].res_amt=g_sr[g_cnt].all_amt - g_sr[g_cnt].amt1-  #FUN-B50182 mod
                                g_sr[g_cnt].amt2 - g_sr[g_cnt].amt3-
                                g_sr[g_cnt].amt4 - g_sr[g_cnt].amt5-
                                g_sr[g_cnt].amt6
        LET l_res_amt_t = g_sr[g_cnt].res_amt  #FUN-B60055 add
        #------------------------------------------
 
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sr.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    ERROR ""
END FUNCTION
 
FUNCTION q651_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()                
 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q651_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY                   
 
 
      ON ACTION previous
         CALL q651_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION jump
         CALL q651_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION next
         CALL q651_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION last
         CALL q651_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
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
             LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
   ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                                 
         CALL cl_set_head_visible("","AUTO")     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
  
##################################################
#FUN-B60055 add  參考原s_budamt1寫法  預算耗用計算
FUNCTION q651_getamt(p_afc00,p_afc01,p_afc02,p_afc03,
                   p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE l_afb       RECORD LIKE afb_file.*
  DEFINE l_afc       RECORD LIKE afc_file.*
  DEFINE l_sql          STRING 
  DEFINE kk          RECORD
                     pmn01 LIKE pmn_file.pmn01,
                     pmn02 LIKE pmn_file.pmn02,
                     xamt  LIKE afc_file.afc06
                     END RECORD
  DEFINE l_apamt     LIKE afc_file.afc06
  DEFINE bamt1       LIKE afc_file.afc06
  DEFINE bamt2       LIKE afc_file.afc06
  DEFINE bamt3       LIKE afc_file.afc06
  DEFINE bamt4       LIKE afc_file.afc06
  DEFINE bamt4_1     LIKE afc_file.afc06
  DEFINE bamt4_2     LIKE afc_file.afc06
  DEFINE bamt4_3     LIKE afc_file.afc06
  DEFINE bamt5       LIKE afc_file.afc06
  DEFINE bamt5_1     LIKE afc_file.afc06
  DEFINE bamt5_2     LIKE afc_file.afc06
  DEFINE bamt6       LIKE afc_file.afc06
  DEFINE bamt6_1     LIKE afc_file.afc06
  DEFINE bamt6_2     LIKE afc_file.afc06
  DEFINE l_pml87     LIKE pml_file.pml87
  DEFINE l_pml21     LIKE pml_file.pml21
  DEFINE l_pml44     LIKE pml_file.pml44
  DEFINE l_pml07     LIKE pml_file.pml07
  DEFINE l_pml86     LIKE pml_file.pml86
  DEFINE l_pml04     LIKE pml_file.pml04
  DEFINE l_i         LIKE type_file.num5
  DEFINE l_fac       LIKE ima_file.ima31_fac
  DEFINE l_exist     LIKE type_file.num5

  WHENEVER ERROR CALL cl_err_msg_log

  IF cl_null(p_afc00)  THEN LET p_afc00  = ' ' END IF
  IF cl_null(p_afc01)  THEN LET p_afc01  = ' ' END IF
  IF cl_null(p_afc02)  THEN LET p_afc02  = ' ' END IF
  IF cl_null(p_afc03)  THEN LET p_afc03  = ' ' END IF
  IF cl_null(p_afc04)  THEN LET p_afc04  = ' ' END IF
  IF cl_null(p_afc041) THEN LET p_afc041 = ' ' END IF
  IF cl_null(p_afc042) THEN LET p_afc042 = ' ' END IF
  IF cl_null(p_afc05)  THEN LET p_afc05  = ' ' END IF

  #aza63 (使用多帳別) & p_flag = '1'
  IF g_aza.aza63 = 'N' THEN
     IF p_flag = '1' THEN
        RETURN 0,0,0,0,0,0
     END IF
  END IF

  CALL q651_bud_exist(p_afc00,p_afc01,p_afc02,p_afc03,
                       p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
       RETURNING l_exist,l_afb.*,l_afc.*
  IF l_exist = FALSE THEN
     RETURN 0,0,0,0,0,0
  ELSE
     LET p_afc00 = l_afb.afb00
  END IF

  IF cl_null(l_afb.afb18) THEN LET l_afb.afb18 = 'N' END IF  #總額控制
  IF cl_null(l_afb.afb10) THEN LET l_afb.afb10 = 0   END IF  #總年度預算
  IF cl_null(l_afc.afc06) THEN LET l_afc.afc06 = 0   END IF
  IF cl_null(l_afc.afc08) THEN LET l_afc.afc08 = 0   END IF
  IF cl_null(l_afc.afc09) THEN LET l_afc.afc09 = 0   END IF

  #計算已消耗的金額
  LET bamt1 = 0
  LET bamt2 = 0
  LET bamt3 = 0
  LET bamt4 = 0
  LET bamt4_1 = 0
  LET bamt4_2 = 0
  LET bamt4_3 = 0
  LET bamt5 = 0
  LET bamt5_1 = 0
  LET bamt5_2 = 0
  LET bamt6 = 0
  LET bamt6_1 = 0
  LET bamt6_2 = 0

  IF cl_null(l_afb.afb09) THEN LET l_afb.afb09 = 'N' END IF

  #---------------------------------------------
  #(1) PR 已確認且未結案且未轉PO之金額
  #---------------------------------------------
  LET l_sql="SELECT pml87,pml21,pml44,pml07,pml86,pml04 FROM pmk_file,pml_file",
            " WHERE pmk01=pml01 AND pmk18='Y' ",
            "   AND (pml16< '6' OR pml16='S' OR pml16='R' OR pml16='W') ",
            "   AND pml90='",p_afc01,"'",
            "   AND YEAR(pml33)=",p_afc03,
            "   AND pml121='",p_afc04 ,"' ",
            "   AND pml67 ='",p_afc041,"' ",
            "   AND pml12 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pml40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pml401='",p_afc02,"'"
  END IF

# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre1 FROM l_sql
  DECLARE cur1 CURSOR FOR pre1

  LET bamt1 = 0

  FOREACH cur1 INTO l_pml87,l_pml21,l_pml44,l_pml07,l_pml86,l_pml04
     CALL s_umfchk(l_pml04,l_pml07,l_pml86) RETURNING l_i,l_fac
     IF l_i = 1 THEN
        LET g_errno = 'abm-731'
        LET l_fac = 1
     END IF
     IF cl_null(l_pml87) THEN LET l_pml87 = 0 END IF
     IF cl_null(l_pml21) THEN LET l_pml21 = 0 END IF
     IF cl_null(l_pml44) THEN LET l_pml44 = 0 END IF
     IF cl_null(l_fac) THEN LET l_fac = 1 END IF
     LET bamt1 = bamt1 + ((l_pml87-(l_pml21*l_fac)) * l_pml44)
  END FOREACH
  IF cl_null(bamt1) THEN LET bamt1 = 0 END IF
  IF bamt1 < 0 THEN LET bamt1 = 0 END IF

  #---------------------------------------------
  #(2) PR 已轉PO但PO未確認且未結案之金額
  #---------------------------------------------
  LET l_sql="SELECT sum(pmn44*pmn87) FROM pmm_file,pmn_file,pmk_file,pml_file",
            " WHERE pmm01=pmn01 AND pmm18='N'",
            "   AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",
            "   AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 ",
            "   AND pmn98='",p_afc01,"'",
            "   AND YEAR(pml33)=",p_afc03,
            "   AND pmn96='",p_afc04 ,"' ",
            "   AND (pmn67='",p_afc041,"' OR pmn67 IS NULL) ", #MOD-A90043
            "   AND pmn122 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pmn40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pmn401='",p_afc02,"'"
  END IF

# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre2 FROM l_sql
  DECLARE cur2 CURSOR FOR pre2
  OPEN cur2
  FETCH cur2 INTO bamt2
  IF bamt2 is NULL THEN LET bamt2 = 0 END IF
  IF bamt2 < 0 THEN LET bamt2 = 0 END IF

  #---------------------------------------------
  #(3) PO 已確認且PO 未結案且未轉應付的金額
  #---------------------------------------------
  LET l_sql="SELECT pmn01,pmn02,pmn87*pmn44 ",
            "  FROM pmm_file,pmn_file,pmk_file,pml_file",
            " WHERE pmm01 = pmn01 AND pmm18 ='Y' ",
            "   AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",
            "   AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 ",
            "   AND pmn98='",p_afc01,"'",
            "   AND YEAR(pml33)=",p_afc03,
            "   AND pmn96='",p_afc04 ,"' ",
            "   AND (pmn67='",p_afc041,"' OR pmn67 IS NULL) ", #MOD-A90043
            "   AND pmn122 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pmn40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pmn401='",p_afc02,"'"
  END IF
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
#       END IF
#    END IF
# END IF

  PREPARE pre31 FROM l_sql
  DECLARE kk_curs CURSOR FOR pre31
  FOREACH kk_curs INTO kk.*
     IF kk.xamt is NULL THEN LET kk.xamt = 0 END IF
     IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
     DECLARE bb_curs31 cursor FOR
        SELECT (apb08*apb09) from apa_file,apb_file
        WHERE apa01=apb01 AND apb06=kk.pmn01 AND apb07=kk.pmn02 AND apa00[1,1]='1'
          AND apa42 = 'N'
     FOREACH bb_curs31 into l_apamt
        IF l_apamt is NULL THEN LET l_apamt = 0 END IF
        LET kk.xamt = kk.xamt - l_apamt
        IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
     END FOREACH
     LET bamt3 = bamt3 + kk.xamt
  END FOREACH
  IF bamt3 is NULL THEN LET bamt3 = 0 END IF

  LET l_sql="SELECT pmn01,pmn02,pmn87*pmn44 FROM pmm_file,pmn_file",
            " WHERE pmm01 = pmn01 AND pmm18 ='Y' ",
            "   AND (pmm25< '6' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",
            "   AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL ",
            "   AND pmn98='",p_afc01,"'",
            "   AND pmm31=", p_afc03,
            "   AND pmn96='",p_afc04 ,"' ",
            "   AND (pmn67='",p_afc041,"' OR pmn67 IS NULL) ", #MOD-A90043
            "   AND pmn122 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND pmn40='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND pmn401='",p_afc02,"'"
  END IF
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND pmm32<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre32 FROM l_sql
  DECLARE kk_curs1 CURSOR FOR pre32
  FOREACH kk_curs1 INTO kk.*

     IF kk.xamt is NULL THEN LET kk.xamt = 0 END IF
     IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
     DECLARE bb_curs32 cursor FOR
        SELECT (apb08*apb09) from apa_file,apb_file
        WHERE apa01=apb01 AND apb06=kk.pmn01 AND apb07=kk.pmn02 AND apa00[1,1]='1'
          AND apa42 = 'N' #modi 010809
     FOREACH bb_curs32 INTO l_apamt
        IF l_apamt is NULL THEN LET l_apamt = 0 END IF
        LET kk.xamt = kk.xamt - l_apamt
        IF kk.xamt < 0 THEN LET kk.xamt = 0 END IF
     END FOREACH
     LET bamt3 = bamt3 + kk.xamt
  END FOREACH
  IF bamt3 is NULL THEN LET bamt3 = 0 END IF
  IF bamt3 < 0 THEN LET bamt3 = 0 END IF

  #----------------------------------------------
  #(4) PO已立帳(立AP) ,但未拋傳票(未到總帳)之金額
  #----------------------------------------------
  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file,pmm_file,pmn_file,pmk_file,pml_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
            "   AND apa00[1,1]='1' ",
            "   AND apa42 = 'N' AND pmm18 <> 'X' ",
            "   AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
            "   AND pmn24=pmk01 AND pmn25=pml02 AND pmk01=pml01 ",
            "   AND apb31='",p_afc01,"'",
            "   AND YEAR(pml33)=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND MONTH(pml33)<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre41 FROM l_sql
  DECLARE cur41 CURSOR FOR pre41
  OPEN cur41
  FETCH cur41 INTO bamt4_1
  IF bamt4_1 is NULL THEN LET bamt4_1 = 0 END IF

  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file,pmm_file,pmn_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') ",
            "   AND apa00[1,1]='1' ",
            "   AND apa42 = 'N' AND pmm18 <> 'X' ",
            "   AND pmm01=pmn01 AND apb06=pmm01 AND apb07=pmn02 ",
            "   AND (pmn24=' ' OR pmn24 IS NULL) AND pmn25 IS NULL ",
            "   AND apb31='",p_afc01,"'",
            "   AND pmm31=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND pmm32=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND pmm32<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre42 FROM l_sql
  DECLARE cur42 CURSOR FOR pre42
  OPEN cur42
  FETCH cur42 INTO bamt4_2
  IF bamt4_2 is NULL THEN LET bamt4_2 = 0 END IF

  LET l_sql="SELECT SUM(apb08*apb09) ",
            "  FROM apa_file,apb_file",
            " WHERE apa01=apb01 AND (apa44 is NULL or apa44=' ') AND apa41='Y'",
            "   AND apa00[1,1]='1' ",
            "   AND (apb06=' ' OR apb06 IS NULL) ",
            "   AND (apb07 IS NULL) ",
            "   AND apb31='",p_afc01,"'",
            "   AND YEAR(apa02)=", p_afc03,
            "   AND apb36='",p_afc04 ,"' ",
            "   AND apb26 ='",p_afc041,"' ",
            "   AND apb35 ='",p_afc042,"' "
  IF p_flag = '0' THEN   #第一科目
     LET l_sql = l_sql CLIPPED,"   AND apb25='",p_afc02,"'"
  ELSE                   #第二科目
     LET l_sql = l_sql CLIPPED,"   AND apb251='",p_afc02,"'"
  END IF
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND MONTH(apa02)=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND MONTH(apa02)<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre43 FROM l_sql
  DECLARE cur43 CURSOR FOR pre43
  OPEN cur43
  FETCH cur43 INTO bamt4_3
  IF bamt4_3 is NULL THEN LET bamt4_3 = 0 END IF

  LET bamt4 = bamt4_1 + bamt4_2 + bamt4_3
  IF bamt4 < 0 THEN LET bamt4 = 0 END IF

  #------------------------------------------
  #(5) AP 已拋傳票(已轉總帳),但未過帳
  #------------------------------------------
  LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file",
            " WHERE aba01=abb01 AND abapost ='N' ",
            "   AND abaacti = 'Y' ",
            "   AND abb06 = '1'",
            "   AND aba00 = abb00 ",
            "   AND abb36 ='",p_afc01 ,"' ",
            "   AND aba03 =", p_afc03 ,
            "   AND abb35 ='",p_afc04 ,"' ",
            "   AND abb05 ='",p_afc041,"' ",
            "   AND abb08 ='",p_afc042,"' ",
            "   AND abb03 ='",p_afc02 ,"' ",
            "   AND aba00 ='",p_afc00 ,"' "
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND aba04<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre51 FROM l_sql
  DECLARE cur51 CURSOR FOR pre51
  OPEN cur51
  FETCH cur51 INTO bamt5_1
  IF bamt5_1 is NULL THEN LET bamt5_1 = 0 END IF

  LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file",
            " WHERE aba01=abb01 AND abapost ='N' ",
            "   AND abaacti = 'Y' ",
            "   AND abb06 = '2'" ,
            "   AND aba00 = abb00 ",
            "   AND abb36 ='",p_afc01 ,"' ",
            "   AND aba03 =", p_afc03 ,
            "   AND abb35 ='",p_afc04 ,"' ",
            "   AND abb05 ='",p_afc041,"' ",
            "   AND abb08 ='",p_afc042,"' ",
            "   AND abb03 ='",p_afc02 ,"' ",
            "   AND aba00 ='",p_afc00 ,"' "
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND aba04<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre52 FROM l_sql
  DECLARE cur52 CURSOR FOR pre52
  OPEN cur52
  FETCH cur52 INTO bamt5_2
  IF bamt5_2 is NULL THEN LET bamt5_2 = 0 END IF

  LET bamt5 = bamt5_1 - bamt5_2
  IF bamt5 < 0 THEN LET bamt5 = 0 END IF

  #---------------------------------------------
  #(6) AP 已拋傳票已過帳
  #---------------------------------------------
  LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file",
            " WHERE aba01=abb01 AND abapost ='Y' ",
            "   AND abaacti = 'Y' ",
            "   AND abb06 = '1'",
            "   AND aba00 = abb00 ",
            "   AND abb36 ='",p_afc01 ,"' ",
            "   AND aba03 =", p_afc03 ,
            "   AND abb35 ='",p_afc04 ,"' ",
            "   AND abb05 ='",p_afc041,"' ",
            "   AND abb08 ='",p_afc042,"' ",
            "   AND abb03 ='",p_afc02 ,"' ",
            "   AND aba00 ='",p_afc00 ,"' "
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND aba04<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre61 FROM l_sql
  DECLARE cur61 CURSOR FOR pre61
  OPEN cur61
  FETCH cur61 INTO bamt6_1
  IF bamt6_1 is NULL THEN LET bamt6_1 = 0 END IF

  LET l_sql="SELECT SUM(abb07) FROM aba_file,abb_file",
            " WHERE aba01=abb01 AND abapost ='Y' ",
            "   AND abaacti = 'Y' ",
            "   AND abb06 = '2'" ,
            "   AND aba00 = abb00 ",
            "   AND abb36 ='",p_afc01 ,"' ",
            "   AND aba03 =", p_afc03 ,
            "   AND abb35 ='",p_afc04 ,"' ",
            "   AND abb05 ='",p_afc041,"' ",
            "   AND abb08 ='",p_afc042,"' ",
            "   AND abb03 ='",p_afc02 ,"' ",
            "   AND aba00 ='",p_afc00 ,"' "
# IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
#    IF l_afb.afb18 = 'N' THEN #非總額
#       IF l_afb.afb09='N' THEN   #不遞延
           LET l_sql = l_sql CLIPPED,"   AND aba04=",p_afc05
#       ELSE
#          LET l_sql = l_sql CLIPPED,"   AND aba04<=",p_afc05
#       END IF
#    END IF
# END IF
  PREPARE pre62 FROM l_sql
  DECLARE cur62 CURSOR FOR pre62
  OPEN cur62
  FETCH cur62 INTO bamt6_2
  IF bamt6_2 is NULL THEN LET bamt6_2 = 0 END IF

  LET bamt6 = bamt6_1 - bamt6_2
  IF bamt6 < 0 THEN LET bamt6 = 0 END IF





  RETURN bamt1,bamt2,bamt3,bamt4,bamt5,bamt6

END FUNCTION

FUNCTION q651_bud_exist(p_afc00,p_afc01,p_afc02,p_afc03,
                     p_afc04,p_afc041,p_afc042,p_afc05,p_flag)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE l_afb       RECORD LIKE afb_file.*
  DEFINE l_afc       RECORD LIKE afc_file.*
  DEFINE l_flag      LIKE type_file.chr1
  DEFINE l_bookno1   LIKE afa_file.afa01  #帳套1
  DEFINE l_bookno2   LIKE afa_file.afa01  #帳套2

  WHENEVER ERROR CALL cl_err_msg_log

  IF cl_null(p_afc00)  THEN LET p_afc00  = ' ' END IF
  IF cl_null(p_afc01)  THEN LET p_afc01  = ' ' END IF
  IF cl_null(p_afc02)  THEN LET p_afc02  = ' ' END IF
  IF cl_null(p_afc03)  THEN LET p_afc03  = ' ' END IF
  IF cl_null(p_afc04)  THEN LET p_afc04  = ' ' END IF
  IF cl_null(p_afc041) THEN LET p_afc041 = ' ' END IF
  IF cl_null(p_afc042) THEN LET p_afc042 = ' ' END IF
  IF cl_null(p_afc05)  THEN LET p_afc05  = ' ' END IF

  INITIALIZE l_afb.* TO NULL
  INITIALIZE l_afc.* TO NULL

  #8個KEY,不能同時為空
  IF p_afc00 IS NULL AND p_afc01 IS NULL AND p_afc02 IS NULL AND
     p_afc03 IS NULL AND p_afc04 IS NULL AND p_afc041 IS NULL AND
     p_afc042 IS NULL AND p_afc05 IS NULL THEN
     LET g_errno = 'agl-230'
     RETURN FALSE,l_afb.*,l_afc.*
  END IF

  #科目標識 0/1
  IF cl_null(p_flag) OR (p_flag NOT MATCHES '[01]') THEN
     RETURN FALSE,l_afb.*,l_afc.*
  END IF

  #若帳套為空,則用年份p_afc03來取帳套
  IF cl_null(p_afc00) THEN
     CALL s_get_bookno(p_afc03) RETURNING l_flag,l_bookno1,l_bookno2
     IF l_flag = '1' THEN  #抓不到帳套
        LET g_errno = 'aoo-081'
        RETURN FALSE,l_afb.*,l_afc.*
     ELSE
        IF p_flag = '0' THEN  #第一科目
           LET p_afc00 = l_bookno1
        ELSE                  #第二科目
           LET p_afc00 = l_bookno2
        END IF
     END IF
  END IF

  #檢查8個key組成預算方式,在afb_file中是否存在
  SELECT * INTO l_afb.* FROM afb_file
   WHERE afb00 = p_afc00
     AND afb01 = p_afc01
     AND afb02 = p_afc02
     AND afb03 = p_afc03
     AND afb04 = p_afc04
     AND afb041= p_afc041
     AND afb042= p_afc042
  IF SQLCA.sqlcode THEN
     LET g_errno = 'agl-231'
     RETURN FALSE,l_afb.*,l_afc.*
  END IF

  IF NOT cl_null(p_afc05) AND p_afc05 <> 0 THEN
     #檢查8個key組成預算方式,在afc_file中是否存在
     SELECT * INTO l_afc.* FROM afc_file
      WHERE afc00 = p_afc00
        AND afc01 = p_afc01
        AND afc02 = p_afc02
        AND afc03 = p_afc03
        AND afc04 = p_afc04
        AND afc041= p_afc041
        AND afc042= p_afc042
        AND afc05 = p_afc05
     IF SQLCA.sqlcode THEN
        LET g_errno = 'agl-231'
        RETURN FALSE,l_afb.*,l_afc.*
     END IF
  END IF

  RETURN TRUE,l_afb.*,l_afc.*
END FUNCTION
#FUN-B60055 add--end
##################################################
