# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimt500.4gl
# Descriptions...: 庫存明細等級維護作業
# Date & Author..: 92/09/01 By Keith
# Modify.........: 92/09/23 By Keith   # 多加 img36
# Modify.........: No.MOD-4A0248 04/10/27 By Yuna QBE開窗開不出來
# Modify.........: NO.MOD-420449 05/07/11 By Yiting key值可更改
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-680006 06/08/07 By Pengu mark FUNCTION t500_hu()
# Modify.........: No.FUN-690026 06/09/19 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-880128 08/10/06 By jan 只可修改 外觀，等級 其他不可修改！
# Modify.........: No.MOD-8A0167 08/10/17 By claire 修改功能應受權限控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima() 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
       g_img         RECORD LIKE img_file.*,
       g_img_t       RECORD LIKE img_file.*,
       g_img_o       RECORD LIKE img_file.*,
       g_img01_t     LIKE img_file.img01,
       g_img02_t     LIKE img_file.img02,
       g_img19_t     LIKE img_file.img19,
       g_img36_t     LIKE img_file.img36,
       g_wc,g_sql    STRING                  #TQC-630166
 
DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5    #NO.MOD-420449  #No.FUN-690026 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    INITIALIZE g_img.* TO NULL
    INITIALIZE g_img_t.* TO NULL
    INITIALIZE g_img_o.* TO NULL
    LET g_forupd_sql = "SELECT * FROM img_file WHERE img01 = ? AND img02 = ? AND img03 = ? AND img04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 21
 
   OPEN WINDOW t500_w AT p_row,p_col
        WITH FORM "aim/42f/aimt500"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
 
    WHILE TRUE
      LET g_action_choice=""
    CALL t500_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t500_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION t500_cs()
    CLEAR FORM
    INITIALIZE g_img.* TO NULL   #FUN-640213 add 
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                 img01,img02,img03,img04,img09,img10,img19,img36
        #--No.MOD-4A0248--------
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
         CASE WHEN INFIELD(img01)      #料件編號
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.state= "c"
                #   LET g_qryparam.form = "q_ima"
                #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AAOO59 --End--
                   DISPLAY g_qryparam.multiret TO img01
                   NEXT FIELD img01
              WHEN INFIELD(img02)      #倉庫
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_imd"
                   LET g_qryparam.arg1 = 'SW'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO img02
                   NEXT FIELD img02
              WHEN INFIELD(img03)      #儲位
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_ime"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO img03
                   NEXT FIELD img03
              WHEN INFIELD(img04)      #批號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_img"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO img04
                   NEXT FIELD img04
         OTHERWISE EXIT CASE
         END CASE
       #--END---------------
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
 
    #資料權限的檢查
    LET g_sql="SELECT img01,img02,img03,img04,img09,img10,img19,img36",
              " FROM img_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY img01"
    PREPARE t500_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t500_cs                           # SCROLL CURSOR
     SCROLL CURSOR WITH HOLD FOR t500_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM img_file WHERE ",g_wc CLIPPED # 捉出符合QBE條件的
    PREPARE t500_precount FROM g_sql
    DECLARE t500_count CURSOR FOR t500_precount
END FUNCTION
 
FUNCTION t500_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t500_q()
            END IF
        ON ACTION next
            CALL t500_fetch('N')
        ON ACTION previous
            CALL t500_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"  #MOD-8A0167 
            IF cl_chk_act_auth() THEN     #MOD-8A0167 cancel mark
                 CALL t500_u()
            END IF                        #MOD-8A0167 cancel mark 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t500_fetch('/')
        ON ACTION first
            CALL t500_fetch('F')
        ON ACTION last
            CALL t500_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
  
      #No.FUN-680046-------add--------str----
      ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_img.img01 IS NOT NULL THEN
                 LET g_doc.column1 = "img01"
                 LET g_doc.column2 = "img02"
                 LET g_doc.column3 = "img03"
                 LET g_doc.column4 = "img04"
                 LET g_doc.value1 = g_img.img01
                 LET g_doc.value2 = g_img.img02
                 LET g_doc.value3 = g_img.img03
                 LET g_doc.value4 = g_img.img04
                 CALL cl_doc()
              END IF
          END IF
      #No.FUN-680046-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t500_cs
END FUNCTION
 
 
#------------No.TQC-680006 mark
#FUNCTION t500_hu(u_sw,r_sw)
#  DEFINE u_sw,r_sw LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
#  CALL t500_hu_nma(u_sw,r_sw)    #If you had to update another table,
#  IF g_success = 'N' THEN RETURN END IF
#
#END FUNCTION
 
#FUNCTION t500_hu_nma(u_sw,r_sw)
#  DEFINE u_sw,r_sw,u_sign  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       	  l_nmc03   LIKE nmc_file.nmc03
 
#  IF u_sw = 1 THEN   #(在update 或insert 時將資料更新至資料庫)
#     SELECT nmc03 INTO l_nmc03 FROM nmc_file WHERE nmc01 = g_img.img03
#     IF l_nmc03 = '1' THEN LET u_sign = 1 ELSE LET u_sign = -1 END IF
#     UPDATE nma_file SET nma23 = nma23 + g_img.img04 * u_sign
#     WHERE nma01 = g_img.img01
#     IF SQLCA.sqlcode THEN
#        LET g_success = 'N'
#        CALL cl_err('(t500_hu_nma:ckp#1)',SQLCA.sqlcode,1) #No.FUN-660156
#        CALL cl_err3("upd","nma_file",g_img.img01,"",SQLCA.sqlcode,"",
#                     "(t500_hu_nma:ckp#1)",1)  #No.FUN-660156
#        RETURN
#     END IF
#  END IF
#  IF r_sw = 1 THEN   #(在update 或remove 時將舊資料還原)
#     SELECT nmc03 INTO l_nmc03 FROM nmc_file WHERE nmc01 = g_img_o.img03
#     IF l_nmc03 = '1' THEN LET u_sign = 1 ELSE LET u_sign = -1 END IF
#     UPDATE nma_file SET nma23 = nma23 - g_img_o.img04 * u_sign #將舊存款還原
#      WHERE nma01 = g_img_o.img01
#     IF SQLCA.sqlcode THEN
#        LET g_success = 'N'
#        RETURN
#     END IF
#  END IF
#END FUNCTION
#------------No.TQC-680006 end
 
FUNCTION t500_i(p_cmd)
    DEFINE
        p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n      LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
     #MOD-420449
    #INPUT BY NAME g_img.img19,g_img.img36 WITHOUT DEFAULTS
    INPUT BY NAME g_img.img01,g_img.img02,
                  g_img.img03,g_img.img04,
                  g_img.img19,g_img.img36 WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t500_set_entry(p_cmd)
        CALL t500_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
    #-END
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    INITIALIZE g_img.* TO NULL
    CALL t500_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN t500_count
    FETCH t500_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        INITIALIZE g_img.* TO NULL
    ELSE
        CALL t500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t500_fetch(p_flimg)
    DEFINE
        p_flimg          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimg
        WHEN 'N' FETCH NEXT     t500_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04,g_img.img09,
              g_img.img10,g_img.img19,g_img.img36
        WHEN 'P' FETCH PREVIOUS t500_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04,g_img.img09,
              g_img.img10,g_img.img19,g_img.img36
        WHEN 'F' FETCH FIRST    t500_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04,g_img.img09,
              g_img.img10,g_img.img19,g_img.img36
        WHEN 'L' FETCH LAST     t500_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04,g_img.img09,
              g_img.img10,g_img.img19,g_img.img36
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t500_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04,g_img.img09,
              g_img.img10,g_img.img19,g_img.img36
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        INITIALIZE g_img.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flimg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_img.* FROM img_file            # 重讀DB,因TEMP有不被更新特性
       WHERE img01 = g_img.img01 AND img02 = g_img.img02 AND img03 = g_img.img03 AND img04 = g_img.img04
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_img.img01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","img_file",g_img.img01,"",SQLCA.sqlcode,"",
                    "",1)  #No.FUN-660156
    ELSE
        CALL t500_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t500_show()
    DEFINE
      d_ima02   LIKE ima_file.ima02,
      d_ima05   LIKE ima_file.ima05,
      d_ima08   LIKE ima_file.ima08
    LET g_img_t.* = g_img.*
    DISPLAY BY NAME g_img.img01,g_img.img02,g_img.img03,
                    g_img.img04,g_img.img09,g_img.img10,
                    g_img.img19,g_img.img36
    SELECT ima02,ima05,ima08 INTO d_ima02,d_ima05,d_ima08 FROM ima_file
     WHERE g_img.img01 = ima01
    DISPLAY d_ima02,d_ima05,d_ima08 TO ima02,ima05,ima08
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t500_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_img.img01)  THEN     #未先查詢即選UPDATE
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_img19_t = g_img.img19
    LET g_img36_t = g_img.img36
    LET g_img_o.*=g_img.*  #保留舊值
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t500_cl USING  g_img.img01,g_img.img02,g_img.img03,g_img.img04
    FETCH t500_cl INTO g_img.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t500_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t500_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_img.*=g_img_t.*
            CALL t500_show()
            CALL cl_err('',9001,0)
            RETURN
        END IF
        UPDATE img_file SET img_file.* = g_img.*    # 更新DB
            WHERE img01 = g_img_o.img01 AND img02 = g_img_o.img02 AND img03 = g_img_o.img03 AND img04 = g_img_o.img04             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
#           CALL cl_err(g_img.img01,SQLCA.sqlcode,0) #No.FUN-660156
            CALL cl_err3("upd","img_file",g_img_t.img01,"",SQLCA.sqlcode,"",
                         "",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t500_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t500_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_img           RECORD LIKE img_file.*,
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('aimt500') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimt500'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM img_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE t500_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t500_co                         # CURSOR
        CURSOR FOR t500_p1
 
    START REPORT t500_rep TO l_name
 
    FOREACH t500_co INTO l_img.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t500_rep(l_img.*)
    END FOREACH
 
    FINISH REPORT t500_rep
 
    CLOSE t500_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t500_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        sr              RECORD LIKE img_file.*,
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.img01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT g_x[11] CLIPPED,COLUMN 58,g_x[12] CLIPPED
			PRINT COLUMN 2,g_x[13] CLIPPED,'  ',g_x[14] CLIPPED
            LET l_trailer_sw = 'y'
        ON EVERY ROW
 #          IF sr.imgacti = 'N' THEN PRINT '*'; END IF
            PRINT COLUMN 2,sr.img01,COLUMN 10,sr.img02,COLUMN 21,sr.img03,
				  COLUMN 25,sr.img04,COLUMN 42,sr.img05 CLIPPED
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
 #MOD-420449
FUNCTION t500_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("img01,img02,img03,img04",TRUE)
   END IF
END FUNCTION
 
FUNCTION t500_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
#No.FUN-880128--BEGIN--modify---
#  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#    CALL cl_set_comp_entry("img01,img02,img03,img04",FALSE)
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("img01,img02,img03,img04,img09,img10",FALSE)
#No.FUN-880128--END--modify---
   END IF
END FUNCTION
#--END
 
#Patch....NO.TQC-610036 <001> #
