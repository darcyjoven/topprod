# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi225.4gl
# Descriptions...: 供應廠商聯絡資料
# Date & Author..: 01/09/10 By Mandy
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/20 BY chenl   網絡銀行功能，此程序新增ocj04,ocj05兩個字段。
# Modify.........: No.TQC-740073 07/04/13 By Xufeng  用于鎖住單身的sql語句有問題，當"帳號名稱"或"是否主要帳號"值為NULL時查不出資料,并且這兩個字段不是關鍵字，不需要
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-870067 08/07/18 By douzh   使用匯豐銀行時新增Email錄入
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-C40270 12/04/28 By yuhuabao 新版大陸網銀無需用到aza74/aza78兩欄位,故mark掉aza78判断栏位隐藏的代码
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_occ     RECORD    occ01    LIKE occ_file.occ01,
                        occ02    LIKE occ_file.occ02,
                        occ05    LIKE occ_file.occ05,
                        occacti  LIKE occ_file.occacti
              END RECORD,
    g_occ_t   RECORD    occ01    LIKE occ_file.occ01,
                        occ02    LIKE occ_file.occ02,
                        occ05    LIKE occ_file.occ05,
                        occacti  LIKE occ_file.occacti
              END RECORD,
    g_occ01_t       LIKE occ_file.occ01,
    g_argv1         LIKE occ_file.occ01,
    g_ocj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ocj02       LIKE ocj_file.ocj02,       #銀行代號
        nmt02       LIKE nmt_file.nmt02,       #銀行名稱
        ocj03       LIKE ocj_file.ocj03,       #銀行帳號
        ocj04       LIKE ocj_file.ocj04,       #帳戶名稱      #No.FUN-730032 
        ocj05       LIKE ocj_file.ocj05,       #主要銀行帳號  #No.FUN-730032
        ocj06       LIKE ocj_file.ocj06,       #帳戶Email     #No.FUN-870067
        ocj07       LIKE ocj_file.ocj07,       #附加Email     #No.FUN-870067
        ocjacti     LIKE ocj_file.ocjacti      #資料有效碼
                    END RECORD,
    g_ocj_t         RECORD                 #程式變數 (舊值)
        ocj02       LIKE ocj_file.ocj02,   #銀行代號
        nmt02       LIKE nmt_file.nmt02,   #銀行名稱
        ocj03       LIKE ocj_file.ocj03,   #銀行帳號
        ocj04       LIKE ocj_file.ocj04,   #帳戶名稱      #No.FUN-730032 
        ocj05       LIKE ocj_file.ocj05,   #主要銀行帳號  #No.FUN-730032
        ocj06       LIKE ocj_file.ocj06,   #帳戶Email     #No.FUN-870067
        ocj07       LIKE ocj_file.ocj07,   #附加Email     #No.FUN-870067
        ocjacti     LIKE ocj_file.ocjacti  #資料有效碼
                    END RECORD,
    #g_wc,g_wc2,g_sql   LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(300)
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166       
    g_rec_b             LIKE type_file.num5,          #目前單身筆數          #No.FUN-680137 SMALLINT
    l_ac                LIKE type_file.num5           #目前處理 ARRAY COUNT  #No.FUN-680137 SMALLINT
 
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql    STRING  #SELECT ... FOR UPDATE SQL  
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
 
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_success      LIKE type_file.chr1          #No.FUN-730032 
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0094
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    INITIALIZE g_occ.* TO NULL
    INITIALIZE g_occ_t.* TO NULL
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW i225_w AT p_row,p_col
         WITH FORM "axm/42f/axmi225"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    
   #No.FUN-730032--begin--
    IF g_aza.aza73 = 'N' THEN
#      CALL cl_set_comp_visible("ocj04,ocj05",FALSE)
       CALL cl_set_comp_visible("ocj04,ocj05,ocj06,ocj07",FALSE)
    ELSE
#      CALL cl_set_comp_visible("ocj04,ocj05",TRUE)
       CALL cl_set_comp_visible("ocj04,ocj05,ocj06,ocj07",TRUE)
    END IF 
   #No.FUN-730032--end--
 
    LET g_argv1 = ARG_VAL(1)
    LET g_occ.occ01 = g_argv1
    IF NOT cl_null(g_argv1) THEN
        CALL i225_q()
        CALL i225_b()
    END IF
    CALL i225_menu()
    CLOSE WINDOW i225_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i225_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    IF g_argv1 = " " OR g_argv1 IS NULL THEN
      CLEAR FORM
      CALL g_ocj.clear()
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_occ.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          occ01,occ02,occ05
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
      CONSTRUCT g_wc2 ON ocj02,ocj03,ocj04,ocj05,ocj06,ocj07,ocjacti  # 螢幕上取單身條件      #No.FUN-730032 add ocj04,ocj05  #No.FUN-870067 add ocj06,ocj07
              FROM s_ocj[1].ocj02,s_ocj[1].ocj03,s_ocj[1].ocj04,s_ocj[1].ocj05,   #No.FUN-730032
                   s_ocj[1].ocj06,s_ocj[1].ocj07,                                 #No.FUN-870067
                   s_ocj[1].ocjacti
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(ocj02)
#               CALL q_nmt(0,0,g_ocj[1].ocj02) RETURNING g_ocj[1].ocj02
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nmt"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ocj02
                NEXT FIELD ocj02
 
               OTHERWISE
                    EXIT CASE
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF STATUS THEN CALL cl_err ('',STATUS,1) END IF
      IF INT_FLAG THEN  RETURN END IF
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #          LET g_wc = g_wc clipped," AND occuser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #          LET g_wc = g_wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #          LET g_wc = g_wc clipped," AND occgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
      #End:FUN-980030
 
      IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
         LET g_sql = "SELECT  occ01 FROM occ_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY occ01"
      ELSE					# 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE  occ01 ",
                     "  FROM occ_file LEFT OUTER JOIN ocj_file ON occ_file.occ01=ocj_file.ocj01  ",
                     " WHERE ",
                     g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY occ01"
      END IF
   ELSE
      LET g_wc = " occ01 = '",g_argv1,"'"
 #    LET g_wc2 =" ocj01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
      LET g_sql = "SELECT occ01 FROM occ_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY occ01"
   END IF
   PREPARE i225_prepare FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE i225_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i225_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM occ_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct occ01)",
                  " FROM occ_file,ocj_file WHERE ",
                  " occ01=ocj01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF
    PREPARE i225_precount FROM g_sql
    DECLARE i225_count CURSOR FOR i225_precount
END FUNCTION
 
FUNCTION i225_menu()
 
   WHILE TRUE
      CALL i225_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i225_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i225_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i225_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ocj),'','')
            END IF
         #No.FUN-6A0020-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_occ.occ01 IS NOT NULL THEN
                 LET g_doc.column1 = "occ01"
                 LET g_doc.value1 = g_occ.occ01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0020-------add--------end----
      END CASE
   END WHILE
      CLOSE i225_cs
END FUNCTION
 
FUNCTION i225_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_occ.* TO NULL              #No.FUN-6A0020
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i225_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_ocj.clear()
        INITIALIZE g_occ.* TO NULL
        RETURN
    END IF
    OPEN i225_count
    FETCH i225_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i225_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
        INITIALIZE g_occ.* TO NULL
    ELSE
        CALL i225_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i225_fetch(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
        l_occuser       LIKE occ_file.occuser,  #FUN-4C0057  add
        l_occgrup       LIKE occ_file.occgrup   #FUN-4C0057  add
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i225_cs INTO g_occ.occ01
        WHEN 'P' FETCH PREVIOUS i225_cs INTO g_occ.occ01
        WHEN 'F' FETCH FIRST    i225_cs INTO g_occ.occ01
        WHEN 'L' FETCH LAST     i225_cs INTO g_occ.occ01
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
           FETCH ABSOLUTE g_jump i225_cs INTO g_occ.occ01
           LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
        INITIALIZE g_occ.* TO NULL  #TQC-6B0105
        LET g_occ.occ01 = NULL      #TQC-6B0105
        RETURN
    END IF
 
      CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
 
    SELECT occ01,occ02,occ05,occacti,occuser,occgrup   # 重讀DB,因TEMP有不被更新特性
           INTO g_occ.*,l_occuser,l_occgrup FROM occ_file
       WHERE occ_file.occ01 = g_occ.occ01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","occ_file",g_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_occ.* TO NULL        #FUN-4C0057 add
    ELSE
       LET g_data_owner = l_occuser      #FUN-4C0057 add
       LET g_data_group = l_occgrup      #FUN-4C0057 add
       CALL i225_show()                  # 重新顯示
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i225_show()
    DEFINE   l_msg   LIKE type_file.chr20        #No.FUN-680137  VARCHAR(20) 
    LET g_occ_t.* = g_occ.*                      #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_occ.occ01  ,g_occ.occ02  ,g_occ.occ05
    CALL s_stades(g_occ.occ05) RETURNING l_msg
    DISPLAY l_msg TO FORMONLY.desc
    CALL i225_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i225_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    LET g_success = 'Y'          #No.FUN-730032
    
    IF g_occ.occ01 IS NULL
       THEN RETURN
    END IF
    IF g_occ.occacti = 'N'
    THEN CALL  cl_err('','mfg3283',0)
         RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     "  SELECT ocj02,'',ocj03,ocj04,ocj05,ocj06,ocj07,ocjacti",  #No.FUN-730032  #No.FUN-870067 add ocj06,ocj07
     "  FROM ocj_file",
     "   WHERE ocj01 = ? ",
     "    AND ocj02 = ? ",
     "    AND ocj03 = ? ",
   # "    AND ocj04 = ? ",   #No.FUN-730032 #No.TQC-740073
   # "    AND ocj05 = ? ",   #No.FUN-730032 #No.TQC-740073
     "  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i225_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ocj
              WITHOUT DEFAULTS
              FROM s_ocj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ocj_t.* = g_ocj[l_ac].*  #BACKUP
                BEGIN WORK
 
                OPEN i225_bcl USING g_occ.occ01,g_ocj_t.ocj02,g_ocj_t.ocj03 
                                              # g_ocj_t.ocj04,g_ocj_t.ocj05     #No.FUN-730032  #No.TQC-740073
                IF STATUS THEN
                    CALL cl_err("OPEN i225_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i225_bcl INTO g_ocj[l_ac].*  
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_ocj_t.ocj02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF     
                    SELECT nmt02
                      INTO g_ocj[l_ac].nmt02
                      FROM nmt_file
                     WHERE nmt01=g_ocj[l_ac].ocj02
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #No.FUN-730032--begin-- add
            CALL i225_ocj05_entry()
            CALL i225_ocj05_noentry()
           #No.FUN-730032--end-- add
 
           #No.FUN-870067--begin
           IF NOT cl_null(g_ocj[l_ac].ocj02) THEN
              CALL i225_ocj02('a',l_ac)
              IF NOT cl_null(g_errno) THEN
                  LET g_ocj[l_ac].ocj02 = g_ocj_t.ocj02
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ocj02
              END IF
           END IF
           #No.FUN-870067--end
 
 
        AFTER INSERT
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ocj_file
                  (ocj01,ocj02,ocj03,ocj04,ocj05,ocj06,ocj07,ocjacti)                    #No.FUN-730032
            VALUES(g_occ.occ01,g_ocj[l_ac].ocj02,g_ocj[l_ac].ocj03,
                   g_ocj[l_ac].ocj04,g_ocj[l_ac].ocj05,g_ocj[l_ac].ocj06,                #No.FUN-870067
                   g_ocj[l_ac].ocj07,g_ocj[l_ac].ocjacti)  #No.FUN-730032                #No.FUN-870067
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ocj[l_ac].ocj02,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","ocj_file",g_occ.occ01,g_ocj[l_ac].ocj02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ocj[l_ac].* TO NULL      #900423
            LET g_ocj[l_ac].ocjacti = 'Y'     #Body default
            LET g_ocj[l_ac].ocj05 = 'N'       #No.FUN-730032
            LET g_ocj_t.* = g_ocj[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ocj02
 
        BEFORE FIELD ocj03
            CALL i225_ocj02('a',l_ac)
            IF NOT cl_null(g_errno) THEN
                LET g_ocj[l_ac].ocj02 = g_ocj_t.ocj02
                CALL cl_err('',g_errno,0)
                NEXT FIELD ocj02
            END IF
        AFTER FIELD ocj03
            IF NOT cl_null(g_ocj[l_ac].ocj03) THEN
                IF g_ocj[l_ac].ocj02 != g_ocj_t.ocj02 OR
                   g_ocj[l_ac].ocj03 != g_ocj_t.ocj03 OR
                   (g_ocj[l_ac].ocj02 IS NOT NULL AND
                    g_ocj_t.ocj02 IS NULL) OR
                   (g_ocj[l_ac].ocj03 IS NOT NULL AND
                    g_ocj_t.ocj03 IS NULL) THEN
 
                    SELECT COUNT(*) INTO g_cnt FROM ocj_file
                     WHERE ocj01 = g_occ.occ01
                       AND ocj02 = g_ocj[l_ac].ocj02
                       AND ocj03 = g_ocj[l_ac].ocj03
                    IF g_cnt > 0 THEN
                        #資料重覆，請重新輸入!
                        CALL cl_err('','axm-298',0)
                        NEXT FIELD ocj03
                    END IF
                END IF
            END IF
            
       #No.FUN-730032--begin--
        BEFORE FIELD ocj05
            CALL i225_ocj05_entry()
            CALL i225_ocj05_noentry()
        
        ON CHANGE ocj05
            IF g_aza.aza73 = 'Y' THEN 
               IF g_ocj[l_ac].ocj05='Y' THEN 
                  IF g_ocj[l_ac].ocjacti ='N' THEN
                     CALL cl_err('','apm-061',1) 
                     LET g_ocj[l_ac].ocj05 = g_ocj_t.ocj05
                     NEXT FIELD ocj05
                  END IF  
               END IF 
            END IF 
            CALL i225_ocj05_entry()
            CALL i225_ocj05_noentry()
            
        ON CHANGE ocjacti
            IF g_aza.aza73 = 'Y' THEN
               IF g_ocj[l_ac].ocjacti = 'N' THEN 
                  IF g_ocj[l_ac].ocj05 = 'Y' THEN 
                     CALL cl_err('','apm-061',1)
                     LET g_ocj[l_ac].ocj05 = 'N'
                     NEXT FIELD ocjacti
                  END IF 
               END IF 
            END IF 
       #No.FUN-730032--end--
       
        BEFORE DELETE                            #是否取消單身
            IF g_ocj_t.ocj02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ocj_file
                 WHERE ocj01 = g_occ.occ01
                   AND ocj02 = g_ocj[l_ac].ocj02
                   AND ocj03 = g_ocj[l_ac].ocj03
                IF SQLCA.SQLERRD[3] = 0 THEN
#                   CALL cl_err(g_ocj_t.ocj02,SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("del","ocj_file",g_occ.occ01,g_ocj_t.ocj02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b -1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ocj[l_ac].* = g_ocj_t.*
               CLOSE i225_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_ocj[l_ac].ocj02,-263,1)
                LET g_ocj[l_ac].* = g_ocj_t.*
            ELSE
            #No.FUN-870067--begin
                IF NOT cl_null(g_ocj[l_ac].ocj02) THEN
                   CALL i225_ocj02('a',l_ac)
                   IF NOT cl_null(g_errno) THEN
                       LET g_ocj[l_ac].ocj02 = g_ocj_t.ocj02
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD ocj02
                   END IF
                END IF
            #No.FUN-870067--end
                UPDATE ocj_file SET
                      ocj02 = g_ocj[l_ac].ocj02,
                      ocj03 = g_ocj[l_ac].ocj03,
                      ocj04 = g_ocj[l_ac].ocj04, #No.FUN-730032
                      ocj05 = g_ocj[l_ac].ocj05, #No.FUN-730032
                      ocj06 = g_ocj[l_ac].ocj06, #No.FUN-870067
                      ocj07 = g_ocj[l_ac].ocj07, #No.FUN-870067
                      ocjacti = g_ocj[l_ac].ocjacti
                    WHERE ocj01 = g_occ.occ01
                      AND ocj02 = g_ocj_t.ocj02
                      AND ocj03 = g_ocj_t.ocj03
             #        AND ocj04 = g_ocj_t.ocj04  #No.FUN-730032  #No.TQC-740073
             #        AND ocj05 = g_ocj_t.ocj05  #No.FUN-730032  #No.TQC-740073
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_ocj[l_ac].ocj02,SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("upd","ocj_file",g_occ.occ01,g_ocj_t.ocj02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    LET g_ocj[l_ac].* = g_ocj_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ocj[l_ac].* = g_ocj_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_ocj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i225_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i225_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(ocj02)
#               CALL q_nmt(0,0,g_ocj[l_ac].ocj02) RETURNING g_ocj[l_ac].ocj02
#               CALL FGL_DIALOG_SETBUFFER( g_ocj[l_ac].ocj02 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nmt"
                LET g_qryparam.default1 = g_ocj[l_ac].ocj02
                CALL cl_create_qry() RETURNING g_ocj[l_ac].ocj02
#                CALL FGL_DIALOG_SETBUFFER( g_ocj[l_ac].ocj02 )
                 DISPLAY BY NAME g_ocj[l_ac].ocj02           #No.MOD-490371
                NEXT FIELD ocj02
 
               OTHERWISE
                    EXIT CASE
            END CASE
 
      # ON ACTION CONTROLN
      #     CALL i225_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ocj02) AND l_ac > 1 THEN
                LET g_ocj[l_ac].* = g_ocj[l_ac-1].*
                LET g_ocj[l_ac].ocj05 = 'N'     #No.FUN-730032
                NEXT FIELD ocj02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
 
        END INPUT
 
    CLOSE i225_bcl
    COMMIT WORK
    
   #No.FUN-730032--begin--
    IF g_rec_b <> 0 THEN
       CALL i225_ocj05_chk() RETURNING g_success
       IF g_success = 'N' THEN 
          LET g_success = 'Y' 
          CALL i225_b()
       END IF                   
    END IF 
   # OPTIONS
   #     INSERT KEY F1,
   #     DELETE KEY F2
   #No.FUN-730032--end--
END FUNCTION
 
FUNCTION i225_b_askkey()
DEFINE
 
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON   ocj02,ocj03,ocj04,ocj05,ocjacti  #No.FUN-730032
                    FROM s_ocj[1].ocj02,s_ocj[1].ocj03,
                         s_ocj[1].ocj04,s_ocj[1].ocj05,   #No.FUN-730032
                         s_ocj[1].ocjacti
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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            RETURN
    END IF
    CALL i225_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i225_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_rec_b = 0
    LET g_sql =
        "SELECT ocj02,'',ocj03,ocj04,ocj05,ocj06,ocj07,ocjacti ",    #No.FUN-730032 #No.FUN-870067 add ocj06,ocj07
        " FROM ocj_file",
        " WHERE ocj01 ='",g_occ.occ01,"'",
        " AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1,2"
    PREPARE i225_pb FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    DECLARE ocj_cs                       #CURSOR
        CURSOR FOR i225_pb
 
    CALL g_ocj.clear()
    LET g_cnt = 1
    FOREACH ocj_cs INTO g_ocj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode
           THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
        END IF
        SELECT nmt02
          INTO g_ocj[g_cnt].nmt02
          FROM nmt_file
         WHERE nmt01 = g_ocj[g_cnt].ocj02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ocj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i225_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ocj TO s_ocj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i225_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i225_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i225_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i225_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i225_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
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
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i225_ocj02(p_cmd,p_ac)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
   p_ac       LIKE type_file.num10,         #No.FUN-680137 INTEGER
   l_nmt12    LIKE nmt_file.nmt12,          #No.FUN-870067
   l_nmtacti  LIKE nmt_file.nmtacti
 
   LET g_errno=''
   SELECT nmt02,nmt12,nmtacti                        #No.FUN-870067
     INTO g_ocj[p_ac].nmt02,l_nmt12,l_nmtacti        #No.FUN-870067 
     FROM nmt_file
    WHERE nmt01=g_ocj[p_ac].ocj02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-013' #無此銀行代號, 請重新輸入
                                LET g_ocj[p_ac].nmt02=NULL
                                LET l_nmt12=NULL      #No.FUN-870067
       WHEN l_nmtacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
#No.FUN-870067--begin
#TQC-C40270 ----- mark ----- begin
#  IF NOT cl_null(g_aza.aza78) AND l_nmt12 = g_aza.aza78 THEN
#     CALL cl_set_comp_entry("ocj06,ocj07",TRUE) 
#     CALL cl_set_comp_required("ocj06,ocj07",TRUE)
#  ELSE
#     CALL cl_set_comp_entry("ocj06,ocj07",FALSE) 
#     CALL cl_set_comp_required("ocj06,ocj07",FALSE)
#  END IF
#TQC-C40270 ----- mark ----- end
#No.FUN-870067--end
 
END FUNCTION
 
FUNCTION i225_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680137 SMALLINT
    sr              RECORD
        occ01       LIKE occ_file.occ01,   #廠商編號
        occ02       LIKE occ_file.occ02,   #廠商簡稱
        ocj02       LIKE ocj_file.ocj02,   #銀行代號
        nmt02       LIKE nmt_file.nmt02,   #銀行名稱
        ocj03       LIKE ocj_file.ocj03,   #銀行帳號
        ocj04       LIKE ocj_file.ocj04,                  #No.FUN-730032
        ocj05       LIKE ocj_file.ocj05                   #No.FUN-730032
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name   #No.FUN-680137 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT occ01,occ02,ocj02,'',ocj03,ocj04,ocj05",    #No.FUN-730032 add ocj04,ocj05
              "  FROM occ_file,ocj_file",
              " WHERE occ01=ocj01 ",
              "   AND ocjacti = 'Y' ",
              "   AND ",g_wc CLIPPED
    IF NOT cl_null(g_wc2) THEN
        LET g_sql = g_sql CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE i225_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,0)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
 
    DECLARE i225_co                                   # CURSOR
        CURSOR FOR i225_p1
 
    LET g_rlang = g_lang                              #FUN-4C0096 add
    CALL cl_outnam('axmi225') RETURNING l_name
 
    #No.FUN-730032--begin--
    IF g_aza.aza73='N' THEN 
       LET g_zaa[36].zaa06 = 'Y'
       LET g_zaa[37].zaa06 = 'Y'
    ELSE 
       LET g_zaa[36].zaa06 = 'N'
       LET g_zaa[37].zaa06 = 'N'
    END IF 
    CALL cl_prt_pos_len()
    #No.FUN-730032--end--    
    START REPORT i225_rep TO l_name
 
    FOREACH i225_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT nmt02 INTO sr.nmt02 FROM nmt_file
         WHERE nmt01 = sr.ocj02
        OUTPUT TO REPORT i225_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i225_rep
 
    CLOSE i225_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i225_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    sr              RECORD
        occ01       LIKE occ_file.occ01,   #廠商編號
        occ02       LIKE occ_file.occ02,   #廠商簡稱
        ocj02       LIKE ocj_file.ocj02,   #銀行代號
        nmt02       LIKE nmt_file.nmt02,   #銀行名稱
        ocj03       LIKE ocj_file.ocj03,   #銀行帳號
        ocj04       LIKE ocj_file.ocj04,
        ocj05       LIKE ocj_file.ocj05
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.occ01,sr.ocj02,sr.ocj03
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            #PRINT ''    #No.TQC-6A0091
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37]     #No.FUN-730032
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.occ01
            PRINT COLUMN g_c[31],sr.occ01,
                  COLUMN g_c[32],sr.occ02[1,10];    #No.TQC-6A0091
 
        ON EVERY ROW
           PRINT COLUMN g_c[33],sr.ocj02,
                 COLUMN g_c[34],sr.nmt02[1,26],
                 COLUMN g_c[35],sr.ocj03,
                 COLUMN g_c[36],sr.ocj04,           #No.FUN-730032
                 COLUMN g_c[37],sr.ocj05            #No.FUN-730032
 
        AFTER GROUP OF sr.occ01
           SKIP 1 LINES
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,201
           THEN
               #TQC-630166
               #IF g_wc[001,080] > ' ' THEN
               #       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
               #IF g_wc[071,140] > ' ' THEN
               #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
               #IF g_wc[141,210] > ' ' THEN
               #       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
               #   PRINT g_dash[1,g_len] 
               #  CALL cl_prt_pos(g_wc)    #No.FUN-730032 mark    
                CALL cl_prt_pos_wc(g_wc)   #No.FUN-730032
               #END TQC-630166
            END IF
            LET l_trailer_sw = 'n'
            PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED      #No.TQC-6A0091
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.TQC-6A0091
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
#No.FUN-730032--begin-- 
FUNCTION i225_ocj05_entry()
DEFINE l_cnt     LIKE type_file.num5
 
  IF g_aza.aza73 = 'Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM ocj_file 
      WHERE ocj01= g_occ.occ01 AND ocj05='Y'
     IF l_cnt = 0 OR g_ocj[l_ac].ocj05='Y' THEN 
        CALL cl_set_comp_entry("ocj05",TRUE)
     END IF 
  END IF 
END FUNCTION 
 
FUNCTION i225_ocj05_noentry()
DEFINE l_cnt     LIKE type_file.num5
  
  IF g_aza.aza73 = 'Y' THEN 
     SELECT COUNT(*) INTO l_cnt FROM ocj_file
      WHERE ocj01=g_occ.occ01 AND ocj05='Y'
     IF l_cnt >0 AND g_ocj[l_ac].ocj05<>'Y' THEN 
        CALL cl_set_comp_entry("ocj05",FALSE)
     END IF  
  END IF 
END FUNCTION 
 
FUNCTION i225_ocj05_chk()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_success  LIKE type_file.chr1
 
  LET l_success = 'Y'
  IF g_aza.aza73 = 'Y' THEN 
     SELECT COUNT(*) INTO l_cnt FROM ocj_file
      WHERE ocj01=g_occ.occ01 AND ocj05='Y'
     IF l_cnt = 0 THEN 
        CALL cl_err('','apm-062',1)
        LET l_success = 'N'
     END IF 
  END IF 
  RETURN l_success 
END FUNCTION 
#No.FUN-730032--end--
