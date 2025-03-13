# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: p_qryauth.4gl
# Descriptions...: 查詢使用者本身可執行特定程式的權限
# Date & Author..: 07/08/25 alex #FUN-780078
# Memo...........: 限定只有tiptop可查其他user，而非tiptop只能查自己的權限
# Modify.........: No.FUN-840217 08/04/29 By alex 修正tiptop登入show -201
# Modify.........: No.FUN-850036 08/05/09 By alex 開窗修改為INPUT Mode,原設計本就不支援多查
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0080 09/12/11 By Dido 為定義 g_row_count 
 
DATABASE ds
 
GLOBALS "../../config/top.global"     #FUN-780078
 
DEFINE   g_zx01           LIKE zx_file.zx01,   
         g_zx04           LIKE zx_file.zx04,
         g_zz01           LIKE zz_file.zz01
DEFINE   g_zx             RECORD
           zx02           LIKE zx_file.zx02,
           zw02           LIKE zw_file.zw02,
           zxwtxt         STRING,
           zx03           LIKE zx_file.zx03,
           gem03          LIKE gem_file.gem03,
           zywtxt         STRING,
           zxytxt         STRING,
           gaz03          LIKE gaz_file.gaz03,
           zy03           LIKE zy_file.zy03,
           zy04           LIKE zy_file.zy04,
           zy05           LIKE zy_file.zy05,
           zy07           LIKE zy_file.zy07,
           zy06           LIKE zy_file.zy06,
           zz011          LIKE zz_file.zz011,
           cust           LIKE type_file.chr1
                      END RECORD
DEFINE   g_qryauth    DYNAMIC ARRAY of RECORD    # 程式變數
           gbd01          LIKE gbd_file.gbd01,
           gbd04          LIKE gbd_file.gbd04,
           zxw04          LIKE zxw_file.zxw04,
           gbl03          LIKE gbl_file.gbl03
                      END RECORD
DEFINE   g_zxw        DYNAMIC ARRAY OF RECORD
           zxw03          LIKE zxw_file.zxw03,
           zxw04          LIKE zxw_file.zxw04,
           zxw05          LIKE zxw_file.zxw05
                  END RECORD
DEFINE   g_cnt2                LIKE type_file.num5,  
         g_wc                  STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,   # 單身筆數   
         l_ac                  LIKE type_file.num5    # 目前處理的ARRAY CNT 
DEFINE   g_chr                 LIKE type_file.chr1   
DEFINE   g_cnt                 LIKE type_file.num10  
DEFINE   g_msg                 LIKE type_file.chr1000 
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5   
DEFINE   g_argv1               LIKE zz_file.zz01
DEFINE   g_argv2               LIKE zx_file.zx01
DEFINE   g_row_count           LIKE type_file.num10
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_jump                LIKE type_file.num10   
DEFINE   g_no_ask              LIKE type_file.num5    
 
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW p_qryauth_w WITH FORM "azz/42f/p_qryauth"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   IF g_user <> 'tiptop' THEN
      LET g_zx01 = g_user CLIPPED
      CALL p_qryauth_usershow()
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_qryauth_q('0')
   END IF
 
   CALL p_qryauth_menu() 
 
   CLOSE WINDOW p_qryauth_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
 
FUNCTION p_qryauth_curs(li_type)                 # QBE 查詢資料
 
   DEFINE li_type    LIKE type_file.num10
 
   CLEAR FORM                                    # 清除畫面
   CALL g_qryauth.clear()
 
   IF g_user <> "tiptop" THEN
      DISPLAY g_user TO zx01
 
      IF NOT cl_null(g_argv1) THEN
         LET g_wc="zx01 = '",g_user CLIPPED,"' AND zz01='",g_argv1 CLIPPED,"' "
      ELSE
         CONSTRUCT g_wc ON zz01 FROM zz01
            ON ACTION controlp
               CASE
                   WHEN INFIELD(zz01) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaz"
                    #LET g_qryparam.state = "c"  #FUN-850036
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO zz01
                     NEXT FIELD zz01
 
                  OTHERWISE
                     EXIT CASE
               END CASE
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
         
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zzuser', 'zzgrup') #FUN-980030
 
         IF INT_FLAG THEN RETURN END IF
         IF g_wc = " 1=1" THEN                  # 若單身未輸入條件
            CALL cl_err("You Should Input Query Condiction!","!",1)
            LET INT_FLAG = TRUE
            RETURN
         ELSE
            LET g_wc = g_wc.trim()," AND zx01 = '",g_user CLIPPED,"' "
         END IF
      END IF
   ELSE
      IF NOT cl_null(g_argv1) THEN    #FUN-840217
         LET g_wc=" zz01='",g_argv1 CLIPPED,"' "
         IF NOT cl_null(g_argv2) THEN
            LET g_wc="zx01 = '",g_argv2 CLIPPED,"' AND ",g_wc
         END IF
      ELSE
         IF NOT li_type THEN    #li_type=0 選 user+prog
            CONSTRUCT g_wc ON zx_file.zx01,zz_file.zz01 FROM zx01,zz01
 
               ON ACTION controlp
                  CASE
                      WHEN INFIELD(zx01) 
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zx"
                       #LET g_qryparam.state = "c"    #FUN-850036
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO zx01
                        NEXT FIELD zx01
                      WHEN INFIELD(zz01) 
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gaz"
                       #LET g_qryparam.state = "c"    #FUN-850036
                        LET g_qryparam.arg1 = g_lang CLIPPED
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO zz01
                        NEXT FIELD zz01
 
                     OTHERWISE
                        EXIT CASE
                  END CASE
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
 
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
            
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
            END CONSTRUCT
 
            IF INT_FLAG THEN RETURN END IF
            #FUN-840217
            IF NOT g_wc.getIndexOf("zx_file.zx01",1) OR NOT g_wc.getIndexOf("zz_file.zz01",1) THEN
               CALL cl_err("You Should Input Both User and Program Condiction!","!",1)
               LET INT_FLAG = TRUE
               RETURN
            END IF
         ELSE
            CONSTRUCT g_wc ON zx_file.zx04,zz_file.zz01 FROM zx04,zz01
               ON ACTION controlp
                  CASE
                      WHEN INFIELD(zx04) 
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zw"
                       #LET g_qryparam.state = "c"    #FUN-850036
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO zx04
                        NEXT FIELD zx04
                      WHEN INFIELD(zz01) 
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gaz"
                       #LET g_qryparam.state = "c"    #FUN-850036
                        LET g_qryparam.arg1 = g_lang CLIPPED
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO zz01
                        NEXT FIELD zz01
 
                     OTHERWISE
                        EXIT CASE
                  END CASE
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
 
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
            
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
            END CONSTRUCT
 
            IF INT_FLAG THEN RETURN END IF
            IF g_wc.getIndexOf("zx04",1) AND g_wc.getIndexOf("zx01",1) THEN
               CALL cl_err("You Should Input Both Categeory and Program Condiction!","!",1)
               LET INT_FLAG = TRUE
               RETURN
            END IF
         END IF
      END IF
   END IF
 
   #FUN-840217
   IF g_wc.getIndexOf("zx01",1) THEN
      LET g_sql=" SELECT zx_file.zx01,zz_file.zz01,zx_file.zx04 ",
                  " FROM zx_file,zy_file,zz_file ",
                 " WHERE zx_file.zx04 = zy_file.zy01 ",
                   " AND zz_file.zz01 = zy_file.zy02 ",
                   " AND ", g_wc CLIPPED,
                 " ORDER BY zz01"
   ELSE
      LET g_sql=" SELECT '',zz01,zx04 FROM zx_file,zy_file,zz_file ",
                 " WHERE zx04 = zy01 AND zz01 = zy02 ",
                   " AND ", g_wc CLIPPED,
                 " ORDER BY zz01 "
   END IF
   PREPARE p_qryauth_prepare FROM g_sql          # 預備一下
   DECLARE p_qryauth_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_qryauth_prepare
 
  #-TQC-9C0080-add-
   IF g_wc.getIndexOf("zx01",1) THEN
      LET g_sql=" SELECT count(*) ",
                  " FROM zx_file,zy_file,zz_file ",
                 " WHERE zx_file.zx04 = zy_file.zy01 ",
                   " AND zz_file.zz01 = zy_file.zy02 ",
                   " AND ", g_wc CLIPPED
   ELSE
      LET g_sql=" SELECT count(*) ",
                "   FROM zx_file,zy_file,zz_file ",
                "  WHERE zx04 = zy01 AND zz01 = zy02 ",
                   " AND ", g_wc CLIPPED
   END IF
   PREPARE p_qryauth_precount FROM g_sql
   DECLARE p_qryauth_count CURSOR FOR p_qryauth_precount
  #-TQC-9C0080-add-
END FUNCTION
 
 
FUNCTION p_qryauth_menu()
 
   WHILE TRUE
      CALL p_qryauth_bp("G")
 
      CASE g_action_choice
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_qryauth_q('0')
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qryauth),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_qryauth_q(li_type)                    #Query 查詢
 
   DEFINE li_type      LIKE type_file.num10
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CLEAR FORM  
   CALL g_qryauth.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_qryauth_curs(li_type)                  #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
  #-TQC-9C0080-add-
   OPEN p_qryauth_count
   FETCH p_qryauth_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
  #-TQC-9C0080-end-
   OPEN p_qryauth_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zx01 TO NULL
      INITIALIZE g_zx04 TO NULL
      INITIALIZE g_zz01 TO NULL
   ELSE
      CALL p_qryauth_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_qryauth_fetch(p_flag)              #處理資料的讀取
 
   DEFINE   p_flag   LIKE type_file.chr1      #處理方式     
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_qryauth_b_curs INTO g_zx01,g_zz01,g_zx04 
      WHEN 'P' FETCH PREVIOUS p_qryauth_b_curs INTO g_zx01,g_zz01,g_zx04
      WHEN 'F' FETCH FIRST    p_qryauth_b_curs INTO g_zx01,g_zz01,g_zx04
      WHEN 'L' FETCH LAST     p_qryauth_b_curs INTO g_zx01,g_zz01,g_zx04  
      WHEN '/' 
         IF (NOT g_no_ask) THEN        #No.FUN-6A0080
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
         FETCH ABSOLUTE g_jump p_qryauth_b_curs INTO g_zx01,g_zz01,g_zx04
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx01,SQLCA.sqlcode,0)
      INITIALIZE g_zx01 TO NULL 
      INITIALIZE g_zx04 TO NULL 
      INITIALIZE g_zz01 TO NULL 
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL p_qryauth_show()
   END IF
END FUNCTION
 
FUNCTION p_qryauth_usershow() 
 
   SELECT zx02,zx03,zx04 INTO g_zx.zx02,g_zx.zx03,g_zx04
     FROM zx_file
    WHERE zx01=g_zx01
 
   SELECT zw02      INTO g_zx.zw02
     FROM zw_file
    WHERE zw01=g_zx04
 
   SELECT gem03     INTO g_zx.gem03
     FROM gem_file
    WHERE gem01=g_zx.zx03
 
   CALL p_qryauth_zxw() RETURNING g_zx.zxwtxt
   CALL p_qryauth_zyw() RETURNING g_zx.zywtxt
   CALL p_qryauth_zxy() RETURNING g_zx.zxytxt
 
   DISPLAY g_zx01,g_zx04,
           g_zx.zx02,  g_zx.zx03,  g_zx.zw02,g_zx.gem03,
           g_zx.zxwtxt,g_zx.zywtxt,g_zx.zxytxt 
        TO zx01,zx04,
           zx02,zx03,zw02,gem03,
           zxwtxt,zywtxt,zxytxt
 
END FUNCTION
 
FUNCTION p_qryauth_show()                         # 將資料顯示在畫面上
 
   CALL p_qryauth_usershow() 
 
   SELECT zz011 INTO g_zx.zz011 FROM zz_file WHERE zz01=g_zz01
   IF g_zx.zz011[1,1] = "C" THEN LET g_zx.cust="Y" ELSE LET g_zx.cust="N" END IF
 
   SELECT gaz03     INTO g_zx.gaz03
     FROM gaz_file
    WHERE gaz01=g_zz01 AND gaz02=g_lang AND gaz05=g_zx.cust
 
   SELECT zy03,zy04,zy05,zy06,zy07
     INTO g_zx.zy03,g_zx.zy04,g_zx.zy05,g_zx.zy06,g_zx.zy07 
     FROM zy_file
    WHERE zy01=g_zx04 AND zy02=g_zz01
 
   DISPLAY g_zz01,g_zx.gaz03 TO zz01,gaz03
 
   CALL p_qryauth_b_fill()
 
   DISPLAY g_zx.zy04,g_zx.zy05,g_zx.zy06,g_zx.zy07
        TO zy04,zy05,zy06,zy07
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
 
FUNCTION p_qryauth_zxw()
 
   DEFINE ls_sql      STRING
   DEFINE ls_return   STRING
   DEFINE li_cnt      LIKE type_file.num10
   DEFINE lc_zw02     LIKE zw_file.zw02
   DEFINE lc_gaz03    LIKE gaz_file.gaz03
 
   LET ls_sql = " SELECT zxw03,zxw04,zxw05 FROM zxw_file ",
                 " WHERE zxw01 ='",g_zx01 CLIPPED,"' "
   LET ls_return = ""
 
   PREPARE p_qryauth_zxw_pre FROM ls_sql
   DECLARE p_qryauth_zxw_cs CURSOR FOR p_qryauth_zxw_pre
   LET li_cnt=1
   CALL g_zxw.clear()
   FOREACH p_qryauth_zxw_cs INTO g_zxw[li_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      ELSE
         IF g_zxw[li_cnt].zxw03 = "1" THEN
            SELECT zw02 INTO lc_zw02 FROM zw_file
             WHERE zw01=g_zxw[li_cnt].zxw04
            LET ls_return = ls_return.trim(),"Union Category: ",lc_zw02 CLIPPED,
                            "(",g_zxw[li_cnt].zxw04 CLIPPED,") \n" 
         ELSE
            SELECT gaz03 INTO lc_gaz03 FROM gaz_file
             WHERE gaz01=g_zxw[li_cnt].zxw04 AND gaz02=g_lang
            LET ls_return = ls_return.trim(),"Union Sepcialist Program: ",lc_gaz03 CLIPPED,
                            "(",g_zxw[li_cnt].zxw04 CLIPPED,") \n" 
         END IF
      END IF
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL g_zxw.deleteElement(li_cnt)
 
   RETURN ls_return.trim()
 
END FUNCTION
 
 
FUNCTION p_qryauth_zyw()
 
   DEFINE ls_sql      STRING
   DEFINE ls_return   STRING
   DEFINE lc_zyw01    LIKE zyw_file.zyw01
   DEFINE lc_zyw02    LIKE zyw_file.zyw02
   DEFINE lc_zyw03    LIKE zyw_file.zyw03
   DEFINE lc_zyw04    LIKE zyw_file.zyw04
   DEFINE lc_zyw05    LIKE zyw_file.zyw05
   DEFINE lc_zx02     LIKE zx_file.zx02
   DEFINE lc_gem03    LIKE gem_file.gem03
   DEFINE li_cnt      LIKE type_file.num10
 
   LET lc_zyw01 = ""
   SELECT zyw01,zyw02 INTO lc_zyw01,lc_zyw02 FROM zyw_file
    WHERE zyw03=g_zx.zx03 AND zyw05 = "0"
 
   IF cl_null(lc_zyw01) THEN
      LET ls_return = "Relational Departments Not Exist!"
      RETURN ls_return.trim()
   ELSE
      LET ls_return = "Relational Department Group:",lc_zyw02 CLIPPED," (",
                      lc_zyw01 CLIPPED,") \n"
   END IF 
 
   LET ls_sql = " SELECT zyw03,zyw04,zyw05 FROM zyw_file ",
                 " WHERE zyw01 ='",lc_zyw01 CLIPPED,"' ",
                 " ORDER BY zyw05 DESC "
 
   PREPARE p_qryauth_zyw_pre FROM ls_sql
   DECLARE p_qryauth_zyw_cs CURSOR FOR p_qryauth_zyw_pre
   LET li_cnt=1
   FOREACH p_qryauth_zyw_cs INTO lc_zyw03,lc_zyw04,lc_zyw05
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      ELSE
         IF lc_zyw05 <> "0" THEN
            SELECT zx02 INTO lc_zx02 FROM zx_file WHERE zx01=lc_zyw04
            LET ls_return=ls_return.trim(),"   Managed By:",lc_zx02 CLIPPED," (",
                                            lc_zyw04 CLIPPED,") \n"
         ELSE
            SELECT gem03 INTO lc_gem03 FROM gem_file WHERE gem01=lc_zyw03
            LET ls_return=ls_return.trim(),"   Group Member:",lc_gem03 CLIPPED," (",
                                            lc_zyw03 CLIPPED,") \n"
         END IF
      END IF
   END FOREACH
 
   RETURN ls_return.trim()
END FUNCTION
 
 
FUNCTION p_qryauth_zxy()
 
   DEFINE ls_sql      STRING
   DEFINE ls_return   STRING
   DEFINE lc_zxy03    LIKE zxy_file.zxy03
   DEFINE lc_azp02    LIKE azp_file.azp02
   DEFINE li_cnt      LIKE type_file.num10
 
   LET ls_sql = " SELECT zxy03 FROM zxy_file ",
                 " WHERE zxy01 ='",g_zx01 CLIPPED,"' "
   LET ls_return = ""
 
   PREPARE p_qryauth_zxy_pre FROM ls_sql
   DECLARE p_qryauth_zxy_cs CURSOR FOR p_qryauth_zxy_pre
   LET li_cnt=1
   FOREACH p_qryauth_zxy_cs INTO lc_zxy03
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      ELSE
         SELECT azp02 INTO lc_azp02 FROM azp_file
          WHERE azp01=lc_zxy03
         LET ls_return=ls_return.trim(),"Allowed into:",lc_azp02 CLIPPED," (",
                                         lc_zxy03 CLIPPED,") \n"
      END IF
   END FOREACH
 
   RETURN ls_return.trim()
END FUNCTION
 
 
FUNCTION p_qryauth_b_fill()               #BODY FILL UP
 
    DEFINE lst_token   base.StringTokenizer
    DEFINE ls_token    STRING
 
    CALL g_qryauth.clear()
    LET g_cnt = 1
    LET lst_token = base.StringTokenizer.create(g_zx.zy03,',')
 
    WHILE lst_token.hasMoreTokens()
       LET ls_token = lst_token.nextToken()
       LET g_qryauth[g_qryauth.getLength()+1].gbd01 = ls_token.trim()
       LET g_qryauth[g_qryauth.getLength()].zxw04 = g_zx04 CLIPPED
    END WHILE
 
    CALL p_qryauth_b_fillgbd01()     #補上其他群組 action
    CALL p_qryauth_b_fillgbd04()     #補上名字
    CALL p_qryauth_b_fillgbl03()     #補上比照項目
 
    LET g_rec_b = g_qryauth.getLength()
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_qryauth_b_fillgbd01() 
 
    DEFINE li_cnt    LIKE type_file.num10
    DEFINE lc_zy03   LIKE zy_file.zy03
 
    IF g_zxw.getLength() <=1 THEN RETURN END IF
 
    FOR li_cnt = 1 TO g_zxw.getLength()
       IF g_zxw[li_cnt].zxw03 = "1" THEN
          SELECT zy03 INTO lc_zy03
            FROM zy_file
           WHERE zy01=g_zxw[li_cnt].zxw03 AND zy02=g_zz01
          CALL p_qryauth_b_chkarry(lc_zy03,g_zxw[li_cnt].zxw03)
       ELSE
          IF g_zxw[li_cnt].zxw04 <> g_zz01 THEN
             CONTINUE FOR
          ELSE
             CALL p_qryauth_b_chkarry(g_zxw[li_cnt].zxw05,g_zxw[li_cnt].zxw04)
          END IF
       END IF
    END FOR
 
END FUNCTION
 
 
FUNCTION p_qryauth_b_chkarry(lc_zy03,lc_zy01)
 
    DEFINE lc_zy01     LIKE zy_file.zy01
    DEFINE lc_zy03     LIKE zy_file.zy03
    DEFINE lc_gbd01    LIKE gbd_file.gbd01
    DEFINE lst_token   base.StringTokenizer
    DEFINE ls_token    STRING
    DEFINE li_cnt      LIKE type_file.num10
 
    LET lst_token = base.StringTokenizer.create(lc_zy03,',')
 
    WHILE lst_token.hasMoreTokens()
       LET ls_token = lst_token.nextToken()
       LET lc_gbd01 = ls_token.trim()
 
       FOR li_cnt = 1 TO g_qryauth.getLength()
          IF g_qryauth[li_cnt].gbd01 CLIPPED = lc_gbd01 CLIPPED THEN
             CONTINUE WHILE
          END IF
       END FOR
       LET g_qryauth[g_qryauth.getLength()+1].gbd01 = lc_gbd01 CLIPPED
       LET g_qryauth[g_qryauth.getLength()].zxw04 = lc_zy01 CLIPPED
    END WHILE
 
END FUNCTION
 
FUNCTION p_qryauth_b_fillgbd04()
 
    DEFINE li_cnt      LIKE type_file.num10
    DEFINE lc_gbd04    LIKE gbd_file.gbd04
 
    PREPARE p_fillgbd04 FROM "SELECT gbd04 FROM gbd_file WHERE gbd01=? AND gbd02=? AND gbd03=? AND gbd07=?"
 
    FOR li_cnt = 1 TO g_qryauth.getLength()
 
       LET lc_gbd04 = ""
       EXECUTE p_fillgbd04 USING g_qryauth[li_cnt].gbd01,g_zz01,g_lang,"Y"
          INTO lc_gbd04
       IF NOT cl_null(lc_gbd04) THEN
          LET g_qryauth[li_cnt].gbd04 = lc_gbd04 CLIPPED
          CONTINUE FOR
       END IF
 
       EXECUTE p_fillgbd04 USING g_qryauth[li_cnt].gbd01,g_zz01,g_lang,"N"
          INTO lc_gbd04
       IF NOT cl_null(lc_gbd04) THEN
          LET g_qryauth[li_cnt].gbd04 = lc_gbd04 CLIPPED
          CONTINUE FOR
       END IF
 
       EXECUTE p_fillgbd04 USING g_qryauth[li_cnt].gbd01,"standard",g_lang,"Y"
          INTO lc_gbd04
       IF NOT cl_null(lc_gbd04) THEN
          LET g_qryauth[li_cnt].gbd04 = lc_gbd04 CLIPPED
          CONTINUE FOR
       END IF
 
       EXECUTE p_fillgbd04 USING g_qryauth[li_cnt].gbd01,"standard",g_lang,"N"
          INTO lc_gbd04
       IF NOT cl_null(lc_gbd04) THEN
          LET g_qryauth[li_cnt].gbd04 = lc_gbd04 CLIPPED
       END IF
 
    END FOR
 
    FREE p_fillgbd04 
END FUNCTION
 
 
FUNCTION p_qryauth_b_fillgbl03()
 
    DEFINE li_cnt     LIKE type_file.num10
 
    PREPARE p_fillgbl03 FROM "SELECT gbl03 FROM gbl_file WHERE gbl01=? AND gbl02=?"
 
 
    FOR li_cnt = 1 TO g_qryauth.getLength()
 
       EXECUTE p_fillgbl03 USING g_zz01,g_qryauth[li_cnt].gbd01
          INTO g_qryauth[li_cnt].gbl03
 
    END FOR
    FREE p_fillgbl03 
END FUNCTION
 
 
 
FUNCTION p_qryauth_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qryauth TO s_qryauth.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
         CALL cl_show_fld_cont()
         LET l_ac = ARR_CURR()
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_qryauth_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous                         # P.上筆
         CALL p_qryauth_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump                             # 指定筆
         CALL p_qryauth_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next                             # N.下筆
         CALL p_qryauth_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last                             # 最終筆
         CALL p_qryauth_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
 
