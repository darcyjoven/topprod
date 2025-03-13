# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicq021.4gl
# Descriptions...: ICD收貨單刻號查詢作業
# Date & Author..: FUN-7B0077 08/03/04 By mike
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B30169 11/03/23 By zhangll 單身至少應顯示一個欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_wc STRING,
    g_idg01     LIKE idg_file.idg01,
    g_idg02     LIKE idg_file.idg02,
    g_idg03     LIKE idg_file.idg03,
    g_idg RECORD LIKE idg_file.*,
    g_bin DYNAMIC ARRAY OF RECORD
            idg20 LIKE idg_file.idg20,
            BIN01 LIKE idg_file.idg24,
            BIN02 LIKE idg_file.idg24,
            BIN03 LIKE idg_file.idg24,
            BIN04 LIKE idg_file.idg24,
            BIN05 LIKE idg_file.idg24,
            BIN06 LIKE idg_file.idg24,
            BIN07 LIKE idg_file.idg24,
            BIN08 LIKE idg_file.idg24,
            BIN09 LIKE idg_file.idg24,
            BIN10 LIKE idg_file.idg24,
            BIN11 LIKE idg_file.idg24,
            BIN12 LIKE idg_file.idg24,
            BIN13 LIKE idg_file.idg24,
            BIN14 LIKE idg_file.idg24,
            BIN15 LIKE idg_file.idg24,
            BIN16 LIKE idg_file.idg24,
            BIN17 LIKE idg_file.idg24,
            BIN18 LIKE idg_file.idg24,
            BIN19 LIKE idg_file.idg24,
            BIN20 LIKE idg_file.idg24,
            BIN21 LIKE idg_file.idg24,
            BIN22 LIKE idg_file.idg24,
            BIN23 LIKE idg_file.idg24,
            BIN24 LIKE idg_file.idg24,
            BIN25 LIKE idg_file.idg24,
            BIN26 LIKE idg_file.idg24,
            BIN27 LIKE idg_file.idg24,
            BIN28 LIKE idg_file.idg24,
            BIN29 LIKE idg_file.idg24,
            BIN30 LIKE idg_file.idg24,
            BIN31 LIKE idg_file.idg24,
            BIN32 LIKE idg_file.idg24,
            BIN33 LIKE idg_file.idg24,
            BIN34 LIKE idg_file.idg24,
            BIN35 LIKE idg_file.idg24,
            BIN36 LIKE idg_file.idg24,
            BIN37 LIKE idg_file.idg24,
            BIN38 LIKE idg_file.idg24,
            BIN39 LIKE idg_file.idg24,
            BIN40 LIKE idg_file.idg24,
            BIN41 LIKE idg_file.idg24,
            BIN42 LIKE idg_file.idg24,
            BIN43 LIKE idg_file.idg24,
            BIN44 LIKE idg_file.idg24,
            BIN45 LIKE idg_file.idg24,
            BIN46 LIKE idg_file.idg24,
            BIN47 LIKE idg_file.idg24,
            BIN48 LIKE idg_file.idg24,
            BIN49 LIKE idg_file.idg24,
            BIN50 LIKE idg_file.idg24,
            BIN51 LIKE idg_file.idg24,
            BIN52 LIKE idg_file.idg24,
            BIN53 LIKE idg_file.idg24,
            BIN54 LIKE idg_file.idg24,
            BIN55 LIKE idg_file.idg24,
            BIN56 LIKE idg_file.idg24,
            BIN57 LIKE idg_file.idg24,
            BIN58 LIKE idg_file.idg24,
            BIN59 LIKE idg_file.idg24,
            BIN99 LIKE idg_file.idg24
    END RECORD,
    g_rec_b  LIKE type_file.num5,    #單身筆數 
    l_ac     LIKE type_file.num5     #目前處理的ARRAY CNT
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_msg          LIKE ze_file.ze03
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10   
DEFINE g_no_ask      LIKE type_file.chr1 
DEFINE g_field_str    STRING
DEFINE g_sql          STRING
DEFINE g_argv1        LIKE idg_file.idg01   #收貨單號
DEFINE g_argv2        LIKE idg_file.idg02   #收貨項次
 
MAIN
   OPTIONS                                #改變一些系統缺省值
        INPUT NO WRAP
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
   
   IF NOT s_industry('icd') THEN                                                                                                    
      CALL cl_err('','aic-999',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
   END IF      
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_argv1 = ARG_VAL(1)   #收貨單號
   LET g_argv2 = ARG_VAL(2)   #收貨項次
 
   OPEN WINDOW q021_w WITH FORM "aic/42f/aicq021"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL q021_b_form('F')
 
   IF NOT cl_null(g_argv1) THEN
      CALL q021_q()
   END IF
 
   CALL q021_menu()
   CLOSE WINDOW q021_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE查詢資料
FUNCTION q021_cs()
   DEFINE   l_cnt LIKE type_file.num5
 
   CLEAR FORM #清除畫面
   CALL g_bin.clear()
   CALL cl_opmsg('q')
   INITIALIZE g_wc TO NULL  # Default condition
 
   IF cl_null(g_argv1) THEN
      CONSTRUCT BY NAME g_wc ON idg01,idg02,pmn04
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(idg01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rva"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO idg01
                     NEXT FIELD idg01
                WHEN INFIELD(pmn04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pmn04
                     NEXT FIELD pmn04
            END CASE
 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   ELSE
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = "idg01 = '",g_argv1,"' AND idg02 = ",g_argv2
      ELSE
         LET g_wc = "idg01 = '",g_argv1,"' "
      END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE idg01,idg02,idg03 ",
             "   FROM idg_file,pmn_file",
             "  WHERE ",g_wc CLIPPED,
             "    AND idg04 = pmn01 AND idg05 = pmn02 ",
             "  ORDER BY idg01,idg02,idg03 "
   PREPARE q021_prepare FROM g_sql
   DECLARE q021_cs SCROLL CURSOR WITH HOLD FOR q021_prepare
END FUNCTION
 
 
FUNCTION q021_count()
 
   DEFINE l_cnt   LIKE type_file.num5,
          l_i     LIKE type_file.num5,
          l_idg01 LIKE idg_file.idg01,
          l_idg02 LIKE idg_file.idg02,
          l_idg03 LIKE idg_file.idg03
 
   LET g_sql=" SELECT UNIQUE idg01,idg02,idg03 ",
             "   FROM idg_file,pmn_file",
             "  WHERE ",g_wc CLIPPED,
             "    AND idg04 = pmn01 AND idg05 = pmn02 ",
             "  ORDER BY idg01,idg02,idg03 "
   PREPARE q021_cnt_pre FROM g_sql
   DECLARE q021_cnt_cs SCROLL CURSOR WITH HOLD FOR q021_cnt_pre
 
   LET l_i = 0
   FOREACH q021_cnt_cs INTO l_idg01,l_idg02,l_idg03
       LET l_i = l_i + 1
   END FOREACH
   LET g_row_count = l_i
   DISPLAY g_row_count TO FORMONLY.cnt
END FUNCTION
 
 
FUNCTION q021_menu()
 
   WHILE TRUE
      CALL q021_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q021_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                       base.TypeInfo.create(g_bin),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q021_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    LET g_idg01 = NULL
    LET g_idg02 = NULL
    LET g_idg03 = NULL
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q021_b_form('F')
 
    CALL q021_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    OPEN q021_cs                 #從DB產生合乎條件TEMP(0-30秒) 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q021_count()
        CALL q021_fetch('F')                #讀出TEMP第一筆并顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q021_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num10   #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q021_cs 
                  INTO g_idg01,g_idg02,g_idg03
        WHEN 'P' FETCH PREVIOUS q021_cs
                  INTO g_idg01,g_idg02,g_idg03
        WHEN 'F' FETCH FIRST    q021_cs
                  INTO g_idg01,g_idg02,g_idg03
        WHEN 'L' FETCH LAST     q021_cs
                  INTO g_idg01,g_idg02,g_idg03
        WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
               PROMPT g_msg CLIPPED,': ' FOR g_jump
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
           END IF
           FETCH ABSOLUTE g_jump q021_cs 
                     INTO g_idg01,g_idg02,g_idg03
           LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_idg01,SQLCA.sqlcode,0)
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
 
    DECLARE idg_cs CURSOR FOR
    SELECT * FROM idg_file
     WHERE idg01 = g_idg01
       AND idg02 = g_idg02
       AND idg03 = g_idg03
 
    OPEN idg_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('open idg_cs',SQLCA.sqlcode,0)
        RETURN
    END IF
    FETCH idg_cs INTO g_idg.*
 
    CALL q021_show()
END FUNCTION
 
FUNCTION q021_show()
   DEFINE l_pmn04 LIKE pmn_file.pmn04,
          l_ima02 LIKE ima_file.ima02,
          l_imaicd04 LIKE imaicd_file.imaicd04
 
   #顯示單頭值
   DISPLAY BY NAME g_idg.idg01,g_idg.idg02
 
   SELECT pmn04,ima02,imaicd04 INTO l_pmn04,l_ima02,l_imaicd04
     FROM pmn_file,OUTER imaicd_file,OUTER ima_file
    WHERE pmn01 = g_idg.idg04
      AND pmn02 = g_idg.idg05
      AND pmn_file.pmn04 = ima_file.ima01
      AND pmn_file.pmn04 = imaicd_file.imaicd00
 
   DISPLAY l_pmn04,l_ima02 TO pmn04,ima02
 
   IF NOT cl_null(l_imaicd04) AND l_imaicd04 = '1' THEN
      CALL cl_set_comp_lab_text('BIN99','BIN00')
   ELSE
      CALL cl_set_comp_lab_text('BIN99','BIN99')
   END IF
 
 
   #顯示單頭回貨資料值
   DISPLAY BY NAME g_idg.idg03,g_idg.idg04,g_idg.idg05,
                   g_idg.idg06,g_idg.idg07,g_idg.idg08,
                   g_idg.idg09,g_idg.idg10,g_idg.idg11,
                   g_idg.idg12,g_idg.idg13,g_idg.idg14,
                   g_idg.idg15,g_idg.idg16,g_idg.idg17
 
 
   #顯示單頭出貨資料值
   DISPLAY BY NAME g_idg.idg36,g_idg.idg37,g_idg.idg38,
                   g_idg.idg39,g_idg.idg40,g_idg.idg41,
                   g_idg.idg42,g_idg.idg43,g_idg.idg44,
                   g_idg.idg45,g_idg.idg46,g_idg.idg47,
                   g_idg.idg48,g_idg.idg49,g_idg.idg50,
                   g_idg.idg51,g_idg.idg52,g_idg.idg53,
                   g_idg.idg54,g_idg.idg55,g_idg.idg56,
                   g_idg.idg57,g_idg.idg58,g_idg.idg59,
                   g_idg.idg60,g_idg.idg61,g_idg.idg62,
                   g_idg.idg63,g_idg.idg64,g_idg.idg65,
                   g_idg.idg66,g_idg.idg67,g_idg.idg68,
                   g_idg.idg69,g_idg.idg70,g_idg.idg71,
                   g_idg.idg72,g_idg.idg73,g_idg.idg74,
                   g_idg.idg75,g_idg.idg76,g_idg.idg77,
                   g_idg.idg78,g_idg.idg79,g_idg.idg80,
                   g_idg.idg81,g_idg.idg82
 
 
   CALL q021_b_fill()  #單身
   CALL cl_show_fld_cont() 
END FUNCTION
 
 
FUNCTION q021_b_fill()              #BODY FILL UP
   DEFINE #l_sql   LIKE type_file.chr1000,
          l_sql      STRING,     #NO.FUN-910082
          l_idg20 LIKE idg_file.idg20
 
   CALL q021_b_form('F')
 
   LET l_sql = " SELECT UNIQUE idg20 ",
               "   FROM idg_file ",
               "  WHERE idg01= '",g_idg.idg01,"'",
               "    AND idg02= '",g_idg.idg02,"'",
               "    AND idg03= '",g_idg.idg03,"'",
               "  ORDER BY idg20 "
    PREPARE q021_pb FROM l_sql
    DECLARE q021_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q021_pb
 
    CALL g_bin.clear()
    LET g_cnt = 1
    FOREACH q021_bcs INTO l_idg20
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL q021_b_fill2(l_idg20)
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bin.deleteElement(g_cnt)
    LET g_rec_b=g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_field_str = g_field_str.append("idg20")
    CALL q021_b_form('T')
END FUNCTION
 
 
#生成單身
FUNCTION q021_b_fill2(p_idg20)
   DEFINE p_idg20 LIKE idg_file.idg20,
          l_idg21 LIKE idg_file.idg21,
          l_idg24 LIKE idg_file.idg24
 
   DECLARE q021_b_fill2_cs CURSOR FOR
    SELECT idg21,idg24 FROM idg_file
     WHERE idg01 = g_idg01
       AND idg02 = g_idg02
       AND idg03 = g_idg03
       AND idg20 = p_idg20
     ORDER BY idg21
 
   FOREACH q021_b_fill2_cs INTO l_idg21,l_idg24
      IF SQLCA.sqlcode THEN
         CALL cl_err('q021_b_fill2_bs',SQLCA.sqlcode,0)
         RETURN
      END IF
      LET g_bin[g_cnt].idg20 = p_idg20
      CASE l_idg21
           WHEN 'BIN01'
                 LET g_bin[g_cnt].BIN01 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN02'
                 LET g_bin[g_cnt].BIN02 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN03'
                 LET g_bin[g_cnt].BIN03 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN04'
                 LET g_bin[g_cnt].BIN04 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN05'
                 LET g_bin[g_cnt].BIN05 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN06'
                 LET g_bin[g_cnt].BIN06 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN07'
                 LET g_bin[g_cnt].BIN07 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN08'
                 LET g_bin[g_cnt].BIN08 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN09'
                 LET g_bin[g_cnt].BIN09 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN10'
                 LET g_bin[g_cnt].BIN10 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN11'
                 LET g_bin[g_cnt].BIN11 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN12'
                 LET g_bin[g_cnt].BIN12 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN13'
                 LET g_bin[g_cnt].BIN13 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN14'
                 LET g_bin[g_cnt].BIN14 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN15'
                 LET g_bin[g_cnt].BIN15 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN16'
                 LET g_bin[g_cnt].BIN16 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN17'
                 LET g_bin[g_cnt].BIN17 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN18'
                 LET g_bin[g_cnt].BIN18 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN19'
                 LET g_bin[g_cnt].BIN19 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN20'
                 LET g_bin[g_cnt].BIN20 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN21'
                 LET g_bin[g_cnt].BIN21 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN22'
                 LET g_bin[g_cnt].BIN22 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN23'
                 LET g_bin[g_cnt].BIN23 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN24'
                 LET g_bin[g_cnt].BIN24 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN25'
                 LET g_bin[g_cnt].BIN25 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN26'
                 LET g_bin[g_cnt].BIN26 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN27'
                 LET g_bin[g_cnt].BIN27 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN28'
                 LET g_bin[g_cnt].BIN28 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN29'
                 LET g_bin[g_cnt].BIN29 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN30'
                 LET g_bin[g_cnt].BIN30 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN31'
                 LET g_bin[g_cnt].BIN31 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN32'
                 LET g_bin[g_cnt].BIN32 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN33'
                 LET g_bin[g_cnt].BIN33 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN34'
                 LET g_bin[g_cnt].BIN34 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN35'
                 LET g_bin[g_cnt].BIN35 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN36'
                 LET g_bin[g_cnt].BIN36 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN37'
                 LET g_bin[g_cnt].BIN37 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN38'
                 LET g_bin[g_cnt].BIN38 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN39'
                 LET g_bin[g_cnt].BIN39 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN40'
                 LET g_bin[g_cnt].BIN40 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN41'
                 LET g_bin[g_cnt].BIN41 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN42'
                 LET g_bin[g_cnt].BIN42 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN43'
                 LET g_bin[g_cnt].BIN43 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN44'
                 LET g_bin[g_cnt].BIN44 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN45'
                 LET g_bin[g_cnt].BIN45 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN46'
                 LET g_bin[g_cnt].BIN46 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN47'
                 LET g_bin[g_cnt].BIN47 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN48'
                 LET g_bin[g_cnt].BIN48 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN49'
                 LET g_bin[g_cnt].BIN49 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN50'
                 LET g_bin[g_cnt].BIN50 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN51'
                 LET g_bin[g_cnt].BIN51 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN52'
                 LET g_bin[g_cnt].BIN52 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN53'
                 LET g_bin[g_cnt].BIN53 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN54'
                 LET g_bin[g_cnt].BIN54 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN55'
                 LET g_bin[g_cnt].BIN55 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN56'
                 LET g_bin[g_cnt].BIN56 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN57'
                 LET g_bin[g_cnt].BIN57 = l_idg24
                 CALL q021_field_str(l_idg21)
           WHEN 'BIN58'
                 LET g_bin[g_cnt].BIN58 = l_idg24
           WHEN 'BIN59'
                 LET g_bin[g_cnt].BIN59 = l_idg24
                 CALL q021_field_str(l_idg21)
           OTHERWISE #非BIN01-BIN59的全到BIN99來吧
                 LET g_bin[g_cnt].BIN99 = l_idg24
                 CALL q021_field_str("BIN99")
      END CASE
      CALL q021_zero()
 
   END FOREACH
END FUNCTION
 
 
#單身的字段動態visible
FUNCTION q021_b_form(p_status)
   DEFINE p_status    LIKE type_file.chr1
 
   CASE
       WHEN p_status = 'F'  #隱藏字段
        #LET g_field_str = "idg20,",
         LET g_field_str = #Mod No.TQC-B30169
               "BIN01,BIN02,BIN03,BIN04,BIN05,BIN06,BIN07,BIN08,BIN09,BIN10,",
               "BIN11,BIN12,BIN13,BIN14,BIN15,BIN16,BIN17,BIN18,BIN19,BIN20,",
               "BIN21,BIN22,BIN23,BIN24,BIN25,BIN26,BIN27,BIN28,BIN29,BIN30,",
               "BIN31,BIN32,BIN33,BIN34,BIN35,BIN36,BIN37,BIN38,BIN39,BIN40,",
               "BIN41,BIN42,BIN43,BIN44,BIN45,BIN46,BIN47,BIN48,BIN49,BIN50,",
               "BIN51,BIN52,BIN53,BIN54,BIN55,BIN56,BIN57,BIN58,BIN59,BIN99"
         CALL cl_set_comp_visible(g_field_str,FALSE)
         LET g_field_str = NULL
       WHEN p_status = 'T'  #顯示字段
         CALL cl_set_comp_visible(g_field_str,TRUE)
   END CASE
 
END FUNCTION
 
FUNCTION q021_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN  
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bin TO s_bin.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()        
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q021_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
 
      ON ACTION previous
         CALL q021_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q021_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
 
      ON ACTION next
         CALL q021_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
 
      ON ACTION last
         CALL q021_fetch('L')
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#串visible字段字串
FUNCTION q021_field_str(p_idg21)
   DEFINE p_idg21 LIKE idg_file.idg21
   IF NOT g_field_str.getIndexOf(p_idg21,1) THEN
      LET g_field_str = g_field_str.append(p_idg21)
      LET g_field_str = g_field_str.append(",")
   END IF
END FUNCTION
 
#將NULL的資料給0
FUNCTION q021_zero()
   IF cl_null(g_bin[g_cnt].BIN01) THEN LET g_bin[g_cnt].BIN01 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN02) THEN LET g_bin[g_cnt].BIN02 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN03) THEN LET g_bin[g_cnt].BIN03 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN04) THEN LET g_bin[g_cnt].BIN04 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN05) THEN LET g_bin[g_cnt].BIN05 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN06) THEN LET g_bin[g_cnt].BIN06 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN07) THEN LET g_bin[g_cnt].BIN07 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN08) THEN LET g_bin[g_cnt].BIN08 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN09) THEN LET g_bin[g_cnt].BIN09 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN10) THEN LET g_bin[g_cnt].BIN10 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN11) THEN LET g_bin[g_cnt].BIN11 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN12) THEN LET g_bin[g_cnt].BIN12 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN13) THEN LET g_bin[g_cnt].BIN13 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN14) THEN LET g_bin[g_cnt].BIN14 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN15) THEN LET g_bin[g_cnt].BIN15 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN16) THEN LET g_bin[g_cnt].BIN16 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN17) THEN LET g_bin[g_cnt].BIN17 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN18) THEN LET g_bin[g_cnt].BIN18 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN19) THEN LET g_bin[g_cnt].BIN19 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN20) THEN LET g_bin[g_cnt].BIN20 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN21) THEN LET g_bin[g_cnt].BIN21 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN22) THEN LET g_bin[g_cnt].BIN22 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN23) THEN LET g_bin[g_cnt].BIN23 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN24) THEN LET g_bin[g_cnt].BIN24 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN25) THEN LET g_bin[g_cnt].BIN25 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN26) THEN LET g_bin[g_cnt].BIN26 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN27) THEN LET g_bin[g_cnt].BIN27 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN28) THEN LET g_bin[g_cnt].BIN28 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN29) THEN LET g_bin[g_cnt].BIN29 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN30) THEN LET g_bin[g_cnt].BIN30 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN31) THEN LET g_bin[g_cnt].BIN31 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN32) THEN LET g_bin[g_cnt].BIN32 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN33) THEN LET g_bin[g_cnt].BIN33 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN34) THEN LET g_bin[g_cnt].BIN34 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN35) THEN LET g_bin[g_cnt].BIN35 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN36) THEN LET g_bin[g_cnt].BIN36 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN37) THEN LET g_bin[g_cnt].BIN37 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN38) THEN LET g_bin[g_cnt].BIN38 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN39) THEN LET g_bin[g_cnt].BIN39 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN30) THEN LET g_bin[g_cnt].BIN30 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN41) THEN LET g_bin[g_cnt].BIN41 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN42) THEN LET g_bin[g_cnt].BIN42 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN43) THEN LET g_bin[g_cnt].BIN43 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN44) THEN LET g_bin[g_cnt].BIN44 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN45) THEN LET g_bin[g_cnt].BIN45 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN46) THEN LET g_bin[g_cnt].BIN46 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN47) THEN LET g_bin[g_cnt].BIN47 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN48) THEN LET g_bin[g_cnt].BIN48 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN49) THEN LET g_bin[g_cnt].BIN49 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN50) THEN LET g_bin[g_cnt].BIN50 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN51) THEN LET g_bin[g_cnt].BIN51 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN52) THEN LET g_bin[g_cnt].BIN52 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN53) THEN LET g_bin[g_cnt].BIN53 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN54) THEN LET g_bin[g_cnt].BIN54 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN55) THEN LET g_bin[g_cnt].BIN55 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN56) THEN LET g_bin[g_cnt].BIN56 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN57) THEN LET g_bin[g_cnt].BIN57 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN58) THEN LET g_bin[g_cnt].BIN58 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN59) THEN LET g_bin[g_cnt].BIN59 = 0 END IF
   IF cl_null(g_bin[g_cnt].BIN99) THEN LET g_bin[g_cnt].BIN99 = 0 END IF
END FUNCTION
 
#No.FUN-7B0077
