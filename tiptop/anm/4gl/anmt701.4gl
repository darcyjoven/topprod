# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: anmt701.4gl
# Descriptions...: 應收帳款融資貸款維護作業
# Date & Author..: 00/07/26 By Mandy
# Modify.........: No.9011 04/01/02 By Kitty 增加判斷oma_file的確認碼及作廢碼
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/02/01 By pengu 報表轉XML
# Modify.........: No.FUN-4C0098 05/02/02 By pengu 報表轉XML
# Modify.........: No.FUN-550037 05/05/13 By saki  欄位comment顯示
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.MOD-560166 05/07/14 By Nicola 修改q_oma的參數
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760115 07/06/25 By Smapmin 帳款編號查詢時要可以複選
#                                                    相關單號顯示有錯
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/07/07 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
#   g_argv1         VARCHAR(10),                 #相關單號
    g_argv1         LIKE nnr_file.nnr01,      #No.FUN-680107 VARCHAR(16)             #No.FUN-550057
    g_nnr01         LIKE nnr_file.nnr01,      #假單頭
    g_nnr01_t       LIKE nnr_file.nnr01,      #假單頭
    g_nnr           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                        nnr02   LIKE nnr_file.nnr02,
                        nnr03   LIKE nnr_file.nnr03,
                        nnr04   LIKE nnr_file.nnr04,
                        nnr041  LIKE nnr_file.nnr041,
                        nnr05   LIKE nnr_file.nnr05,
                        nnr06   LIKE nnr_file.nnr06,
                        nnr07   LIKE nnr_file.nnr07,
                        nnr08   LIKE nnr_file.nnr08,
                        nnr09   LIKE nnr_file.nnr09,
                        nnr10   LIKE nnr_file.nnr10,
                        nnr11   LIKE nnr_file.nnr11,
                        nnr12   LIKE nnr_file.nnr12,
                        nnr13   LIKE nnr_file.nnr13
                    END RECORD,
    g_nnr_t         RECORD                 #程式變數 (舊值)
                        nnr02   LIKE nnr_file.nnr02,
                        nnr03   LIKE nnr_file.nnr03,
                        nnr04   LIKE nnr_file.nnr04,
                        nnr041  LIKE nnr_file.nnr041,
                        nnr05   LIKE nnr_file.nnr05,
                        nnr06   LIKE nnr_file.nnr06,
                        nnr07   LIKE nnr_file.nnr07,
                        nnr08   LIKE nnr_file.nnr08,
                        nnr09   LIKE nnr_file.nnr09,
                        nnr10   LIKE nnr_file.nnr10,
                        nnr11   LIKE nnr_file.nnr11,
                        nnr12   LIKE nnr_file.nnr12,
                        nnr13   LIKE nnr_file.nnr13
                    END RECORD,
    g_wc2,g_sql     STRING,                 #No.FUN-580092 HCN      
    g_wc            STRING,                 #No.FUN-580092 HCN       
    g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
    g_ss            LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
    l_flag          LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL       
DEFINE   g_cnt      LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg      LIKE ze_file.ze03       #No.FUN-680107 VARCHAR(72)
DEFINE   g_head1    STRING
 
 
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680107 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   OPTIONS
      PROMPT  LINE  LAST,
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   LET g_argv1 = ARG_VAL(1)               #傳遞的參數:相關單號
   LET g_nnr01 = g_argv1
 
   INITIALIZE g_nnr_t.* TO NULL
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW t701_w AT p_row,p_col
       WITH FORM "anm/42f/anmt701"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#   CALL t701_q()
IF NOT cl_null(g_argv1) THEN CALL t701_q() END IF
   CALL t701_menu()
   CLOSE WINDOW t701_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
#QBE 查詢資料
FUNCTION t701_cs()
 
    IF NOT cl_null(g_argv1) THEN
       DISPLAY g_argv1 TO nnr01
       LET g_wc =" nnr01= '",g_argv1,"' "
       LET g_sql=" SELECT nnr01",
                 " FROM nnr_file ",
                 " WHERE ",g_wc CLIPPED
    ELSE
       CLEAR FORM                             #清除畫面
       CALL g_nnr.clear()
       CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   #INITIALIZE g_nnr01 TO NULL    #No.FUN-750051   #MOD-760115
       CONSTRUCT g_wc ON nnr01,nnr02,nnr03,nnr04,nnr041,nnr05,nnr06,nnr07,
                         nnr08,nnr09,nnr10,nnr11,nnr12 ,nnr13
            FROM nnr01,s_nnr[1].nnr02,s_nnr[1].nnr03,s_nnr[1].nnr04,
                 s_nnr[1].nnr041,s_nnr[1].nnr05,s_nnr[1].nnr06,s_nnr[1].nnr07,
                 s_nnr[1].nnr08,s_nnr[1].nnr09,s_nnr[1].nnr10,s_nnr[1].nnr11,
                 s_nnr[1].nnr12,s_nnr[1].nnr13
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON ACTION controlp
             CASE
                WHEN INFIELD (nnr03)
                   #CALL q_oma(TRUE,FALSE,g_nnr[1].nnr03,' ',' ')   #MOD-760115
                   CALL q_oma(TRUE,TRUE,g_nnr[1].nnr03,' ',' ')   #MOD-760115
                   RETURNING g_nnr[1].nnr03
#                  SELECT oma03,oma032,oma02,oma23,oma24,oma54t,oma56t,oma16
#                      INTO g_nnr[1].nnr04,g_nnr[1].nnr041,g_nnr[1].nnr05,
#                           g_nnr[1].nnr10,g_nnr[1].nnr11 ,g_nnr[1].nnr12,
#                           g_nnr[1].nnr13,l_oma16 FROM oma_file
#                      WHERE oma01 = g_nnr[1].nnr03
#                  SELECT oga908,oga27,oga011
#                      INTO g_nnr[1].nnr09,g_nnr[1].nnr07,l_oga011 FROM oga_file
#                      WHERE oga01 = l_oma16
#                  SELECT ofa50 INTO g_nnr[1].nnr08 FROM ofa_file
#                      WHERE ofa011 = l_oga011
                   DISPLAY g_nnr[1].nnr03 TO nnr03
                   NEXT FIELD nnr03
               WHEN INFIELD (nnr04)
#                    CALL q_occ(06,11,g_nnr[1].nnr04) RETURNING g_nnr[1].nnr04
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_occ"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnr04
                     NEXT FIELD nnr04
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       LET g_sql= "SELECT  UNIQUE nnr01 FROM nnr_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
    END IF
    PREPARE t701_prepare FROM g_sql      #預備一下
    DECLARE t701_b_cs
        SCROLL CURSOR WITH HOLD FOR t701_prepare
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
 
    LET g_sql="SELECT DISTINCT nnr01",
              " FROM nnr_file WHERE ", g_wc CLIPPED," INTO TEMP x"
    PREPARE t701_precount_x  FROM g_sql
    EXECUTE t701_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE t701_precount FROM g_sql
    DECLARE t701_count CURSOR FOR  t701_precount
END FUNCTION
 
FUNCTION t701_menu()
 
   WHILE TRUE
      CALL t701_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t701_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t701_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL t701_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnr),'','')
            END IF
         #No.FUN-6A0011-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nnr01 IS NOT NULL THEN
                 LET g_doc.column1 = "nnr01"
                 LET g_doc.value1 = g_nnr01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0011-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t701_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680107 VARCHAR(1)
   l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
   l_str           LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(40)
 
   LET g_ss='Y'
   DISPLAY  g_nnr01 TO nnr01
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_nnr01 WITHOUT DEFAULTS
 
      AFTER FIELD nnr01
         IF NOT cl_null(g_nnr01) THEN
            IF g_nnr01 != g_nnr01_t OR      #輸入後更改不同時值
               g_nnr01_t IS NULL THEN
               SELECT UNIQUE nnr01 FROM nnr_file
                WHERE nnr01 =g_nnr01
               IF SQLCA.sqlcode THEN             #不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_nnr01,-239,0)
                     LET g_nnr01=g_nnr01_t
                     NEXT FIELD nnr01
                  END IF
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION t701_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CLEAR FORM
   CALL g_nnr.clear()
   CALL t701_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_nnr01 TO NULL
      CALL g_nnr.clear()
      RETURN
   END IF
   OPEN t701_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_nnr01 TO NULL
   ELSE
      CALL t701_fetch('F')                  #讀出TEMP第一筆並顯示
      OPEN t701_count
      FETCH t701_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t701_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680107 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數     #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t701_b_cs INTO g_nnr01
      WHEN 'P' FETCH PREVIOUS t701_b_cs INTO g_nnr01
      WHEN 'F' FETCH FIRST    t701_b_cs INTO g_nnr01
      WHEN 'L' FETCH LAST     t701_b_cs INTO g_nnr01
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
            FETCH ABSOLUTE g_jump t701_b_cs INTO g_nnr01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_nnr01,SQLCA.sqlcode,0)
      #INITIALIZE g_nnr01 TO NULL               #No.FUN-6A0011   #MOD-760115
      RETURN
   ELSE
      OPEN t701_count
      FETCH t701_count INTO g_row_count
      CALL t701_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t701_show()
   #DISPLAY g_row_count TO nnr01               #單頭   #MOD-760115
   DISPLAY g_nnr01 TO nnr01               #單頭   #MOD-760115
   CALL t701_b_fill(' 1=1')                        #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t701_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態                 #No.FUN-680107 VARCHAR(1)
   l_oma16         LIKE oma_file.oma16,                #出貨單號oga01
   l_oga011        LIKE oga_file.oga011,               #出貨通知單號
   l_allow_insert  LIKE type_file.num5,                #可新增否                 #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否                 #No.FUN-680107 SMALLINT
DEFINE l_oma66     LIKE oma_file.oma66                 #FUN-A60056 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_nnr01 IS NULL THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nnr02,nnr03,nnr04,nnr041,nnr05,nnr06,nnr07,",
                      "       nnr08,nnr09,nnr10,nnr11,nnr12,nnr13 FROM nnr_file",
                      " WHERE nnr02 = ? AND nnr01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t701_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nnr WITHOUT DEFAULTS FROM s_nnr.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
       IF g_rec_b!=0 THEN
         CALL fgl_set_arr_curr(l_ac)
       END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
        #LET g_nnr_t.* = g_nnr[l_ac].*  #BACKUP
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
        #IF g_nnr[l_ac].nnr02 IS NOT NULL THEN
            LET p_cmd='u'
            LET g_nnr_t.* = g_nnr[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN t701_bcl USING g_nnr_t.nnr02,g_nnr01
            IF STATUS THEN
               CALL cl_err("OPEN t701_bcl:", STATUS, 1)
               LET l_lock_sw='Y'
            END IF
            FETCH t701_bcl INTO g_nnr[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_nnr_t.nnr02,SQLCA.sqlcode,1)
               LET l_lock_sw='Y'
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
        #NEXT FIELD nnr02
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nnr[l_ac].* TO NULL      #900423
         LET g_nnr_t.* = g_nnr[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD nnr02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
           #CALL g_nnr.deleteElement(l_ac)   #取消 Array Element
           #IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
           #   LET g_action_choice = "detail"
           #   LET l_ac = l_ac_t
           #END IF
           #EXIT INPUT
         END IF
         INSERT INTO nnr_file(nnr01,nnr02,nnr03,nnr04,nnr041,nnr05,nnr06,
                              nnr07,nnr08,nnr09,nnr10,nnr11,nnr12,nnr13,
                              nnrlegal)   #FUN-980005 
         VALUES(g_nnr01,g_nnr[l_ac].nnr02,g_nnr[l_ac].nnr03,
                g_nnr[l_ac].nnr04,g_nnr[l_ac].nnr041,g_nnr[l_ac].nnr05,
                g_nnr[l_ac].nnr06,g_nnr[l_ac].nnr07,g_nnr[l_ac].nnr08,
                g_nnr[l_ac].nnr09,g_nnr[l_ac].nnr10,g_nnr[l_ac].nnr11,
                g_nnr[l_ac].nnr12,g_nnr[l_ac].nnr13,g_legal)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nnr[l_ac].nnr02,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nnr_file",g_nnr01,g_nnr[l_ac].nnr02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
           #LET g_nnr[l_ac].* = g_nnr_t.*
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD nnr02                         #check 編號是否重複
         IF g_nnr[l_ac].nnr02 IS NULL OR g_nnr[l_ac].nnr02 = 0 THEN
            SELECT max(nnr02)+1 INTO g_nnr[l_ac].nnr02 FROM nnr_file
             WHERE nnr01 = g_nnr01
            IF g_nnr[l_ac].nnr02 IS NULL THEN
               LET g_nnr[l_ac].nnr02 = 1
            END IF
         END IF
 
      AFTER FIELD nnr02               #check 編號是否重複
         IF NOT cl_null(g_nnr[l_ac].nnr02) THEN
            IF g_nnr[l_ac].nnr02 != g_nnr_t.nnr02 OR g_nnr_t.nnr02 IS NULL THEN
               SELECT count(*) INTO l_n FROM nnr_file
                WHERE nnr02 = g_nnr[l_ac].nnr02
                  AND nnr01 = g_nnr01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_nnr[l_ac].nnr02 = g_nnr_t.nnr02
                  NEXT FIELD nnr02
               END IF
            END IF
         END IF
 
      AFTER FIELD nnr03
         IF NOT cl_null(g_nnr[l_ac].nnr03) THEN
            SELECT oma01 FROM oma_file
             WHERE oma01 = g_nnr[l_ac].nnr03 AND omaconf='Y' AND omavoid='N'    #No:9011
            IF STATUS THEN
#              CALL cl_err('select oma',STATUS,1)   #No.FUN-660148
               CALL cl_err3("sel","oma_file",g_nnr[l_ac].nnr03,"",STATUS,"","select oma",1)  #No.FUN-660148
               NEXT FIELD nnr03
            END IF
            SELECT oma03,oma032,oma02,oma23,oma24,oma54t,oma56t,oma16,oma66    #FUN-A60056 add oma66
              INTO g_nnr[l_ac].nnr04,g_nnr[l_ac].nnr041,g_nnr[l_ac].nnr05,
                   g_nnr[l_ac].nnr10,g_nnr[l_ac].nnr11 ,g_nnr[l_ac].nnr12,
                   g_nnr[l_ac].nnr13,l_oma16,l_oma66 FROM oma_file    #FUN-A60056 add oma66
             WHERE oma01 = g_nnr[l_ac].nnr03 AND omaconf='Y' AND omavoid='N'    #No:9011
           #FUN-A60056--mod--str--
           #SELECT oga908,oga27,oga011
           #  INTO g_nnr[l_ac].nnr09,g_nnr[l_ac].nnr07,l_oga011 FROM oga_file
           # WHERE oga01 = l_oma16
           #SELECT ofa50 INTO g_nnr[l_ac].nnr08 FROM ofa_file
           # WHERE ofa011 = l_oga011
            LET g_sql = "SELECT oga908,oga27,oga011",
                        "  FROM ",cl_get_target_table(l_oma66,'oga_file'),
                        " WHERE oga01 = '",l_oma16,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_oma66) RETURNING g_sql
            PREPARE sel_oga908 FROM g_sql
            EXECUTE sel_oga908 INTO g_nnr[l_ac].nnr09,g_nnr[l_ac].nnr07,l_oga011

            LET g_sql = "SELECT ofa50 FROM ",cl_get_target_table(l_oma66,'ofa_file'),
                        " WHERE ofa011 = '",l_oga011,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_oma66) RETURNING g_sql 
            PREPARE sel_ofa50 FROM g_sql
            EXECUTE sel_ofa50 INTO g_nnr[l_ac].nnr08
           #FUN-A60056--mod--end
         END IF
 
      AFTER FIELD nnr04
         IF NOT cl_null(g_nnr[l_ac].nnr04) THEN
            SELECT occ02 INTO g_nnr[l_ac].nnr041 FROM occ_file
             WHERE occ01 = g_nnr[l_ac].nnr04
            IF STATUS THEN
#              CALL cl_err('select occ',STATUS,1)   #No.FUN-660148
               CALL cl_err3("sel","occ_file",g_nnr[l_ac].nnr04,"",STATUS,"","select occ",1)  #No.FUN-660148
               NEXT FIELD nnr04
            END IF
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_nnr[l_ac].nnr041
            #------MOD-5A0095 END------------
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_nnr_t.nnr02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nnr_file
             WHERE nnr02 = g_nnr_t.nnr02 AND nnr01 = g_nnr01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nnr_t.nnr02,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nnr_file",g_nnr_t.nnr02,g_nnr01,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_nnr[l_ac].* = g_nnr_t.*
            CLOSE t701_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nnr[l_ac].nnr02,-263,1)
            LET g_nnr[l_ac].* = g_nnr_t.*
         ELSE
            UPDATE nnr_file SET nnr01  = g_nnr01,
                                nnr02  = g_nnr[l_ac].nnr02,
                                nnr03  = g_nnr[l_ac].nnr03,
                                nnr04  = g_nnr[l_ac].nnr04,
                                nnr041 = g_nnr[l_ac].nnr041,
                                nnr05  = g_nnr[l_ac].nnr05,
                                nnr06  = g_nnr[l_ac].nnr06,
                                nnr07  = g_nnr[l_ac].nnr07,
                                nnr08  = g_nnr[l_ac].nnr08,
                                nnr09  = g_nnr[l_ac].nnr09,
                                nnr10  = g_nnr[l_ac].nnr10,
                                nnr11  = g_nnr[l_ac].nnr11,
                                nnr12  = g_nnr[l_ac].nnr12,
                                nnr13  = g_nnr[l_ac].nnr13
             WHERE nnr02 = g_nnr_t.nnr02
               AND nnr01 = g_nnr01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nnr[l_ac].nnr02,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nnr_file",g_nnr01,g_nnr_t.nnr02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nnr[l_ac].* = g_nnr_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac      #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nnr[l_ac].* = g_nnr_t.*
          #FUN-D30032--add--str--
            ELSE
               CALL g_nnr.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
          #FUN-D30032--add--end--
            END IF
            CLOSE t701_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30032 add
        #LET g_nnr_t.* = g_nnr[l_ac].*
         CLOSE t701_bcl
         COMMIT WORK
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(nnr03)
                 CALL q_oma(FALSE,TRUE,g_nnr[l_ac].nnr03,' ',' ')   #No.MOD-560166
                RETURNING g_nnr[l_ac].nnr03
#                CALL FGL_DIALOG_SETBUFFER( g_nnr[l_ac].nnr03 )
                SELECT oma03,oma032,oma02,oma23,oma24,oma54t,oma56t,oma16,oma66   #FUN-A60056 add oma66
                  INTO g_nnr[l_ac].nnr04,g_nnr[l_ac].nnr041,g_nnr[l_ac].nnr05,
                       g_nnr[l_ac].nnr10,g_nnr[l_ac].nnr11 ,g_nnr[l_ac].nnr12,
                       g_nnr[l_ac].nnr13,l_oma16,l_oma66 FROM oma_file            #FUN-A60056 add oma66
                 WHERE oma01 = g_nnr[l_ac].nnr03 AND omaconf='Y' AND omavoid='N'    #No:9011
               #FUN-A60056--mod--str--
               #SELECT oga908,oga27,oga011
               #  INTO g_nnr[l_ac].nnr09,g_nnr[l_ac].nnr07,l_oga011 FROM oga_file
               # WHERE oga01 = l_oma16
               #SELECT ofa50 INTO g_nnr[l_ac].nnr08 FROM ofa_file
               # WHERE ofa011 = l_oga011
                LET g_sql = "SELECT oga908,oga27,oga011",
                            "  FROM ",cl_get_target_table(l_oma66,'oga_file'),
                            " WHERE oga01 = '",l_oma16,"'"
                CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                CALL cl_parse_qry_sql(g_sql,l_oma66) RETURNING g_sql
                PREPARE sel_oga908_pre1 FROM g_sql
                EXECUTE sel_oga908_pre1 INTO g_nnr[l_ac].nnr09,g_nnr[l_ac].nnr07,l_oga011

                LET g_sql = "SELECT ofa50 FROM ",cl_get_target_table(l_oma66,'ofa_file'),
                            " WHERE ofa011 = '",l_oga011,"'" 
                CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                CALL cl_parse_qry_sql(g_sql,l_oma66) RETURNING g_sql
                PREPARE sel_ofa50_pre1 FROM g_sql
                EXECUTE sel_ofa50_pre1 INTO g_nnr[l_ac].nnr08
               #FUN-A60056--mod--end
                 DISPLAY BY NAME g_nnr[l_ac].nnr03         #No.MOD-490344
                NEXT FIELD nnr03
             WHEN INFIELD (nnr04)
#               CALL q_occ(06,11,g_nnr[l_ac].nnr04) RETURNING g_nnr[l_ac].nnr04
#               CALL FGL_DIALOG_SETBUFFER( g_nnr[l_ac].nnr04 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.default1 = g_nnr[l_ac].nnr04
                CALL cl_create_qry() RETURNING g_nnr[l_ac].nnr04
#                CALL FGL_DIALOG_SETBUFFER( g_nnr[l_ac].nnr04 )
                SELECT occ02 INTO g_nnr[l_ac].nnr041 FROM occ_file
                 WHERE occ01 = g_nnr[l_ac].nnr04
                 DISPLAY BY NAME g_nnr[l_ac].nnr04         #No.MOD-490344
                NEXT FIELD nnr04
          END CASE
 
#     ON ACTION CONTROLN
#        CALL t701_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(nnr01) AND l_ac > 1 THEN
            LET g_nnr[l_ac].* = g_nnr[l_ac-1].*
            NEXT FIELD nnr01
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END INPUT
   CLOSE t701_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t701_b_askkey()
   CLEAR FORM
   CALL g_nnr.clear()
   CONSTRUCT g_wc2 ON nnr02,nnr03,nnr04,nnr041,nnr05,nnr06,nnr07,
                      nnr08,nnr09,nnr10,nnr11 ,nnr12,nnr13
       FROM s_nnr[1].nnr02,s_nnr[1].nnr03,s_nnr[1].nnr04,s_nnr[1].nnr041,
            s_nnr[1].nnr05,s_nnr[1].nnr06,s_nnr[1].nnr07,s_nnr[1].nnr08,
            s_nnr[1].nnr09,s_nnr[1].nnr10,s_nnr[1].nnr11,s_nnr[1].nnr12,
            s_nnr[1].nnr13
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
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL t701_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t701_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
   LET g_sql ="SELECT nnr02,nnr03,nnr04,nnr041,nnr05,nnr06,nnr07,nnr08,nnr09,nnr10,nnr11,nnr12,nnr13 ",
              " FROM nnr_file",
              " WHERE nnr01='",g_nnr01,"' AND ",
                p_wc2 CLIPPED,
              " ORDER BY 1"
   PREPARE t701_pb FROM g_sql
   DECLARE nnr_curs CURSOR FOR t701_pb
   CALL g_nnr.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
   FOREACH nnr_curs INTO g_nnr[g_cnt].*   #單身 ARRAY 填充
   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   CALL g_nnr.deleteElement(g_cnt)   #取消 Array Element
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t701_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnr TO s_nnr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t701_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t701_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t701_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t701_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t701_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t701_out()
    DEFINE
        l_nnr           RECORD LIKE nnr_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680107 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #        #No.FUN-680107 VARCHAR(40)
 
    IF g_wc  IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    #LET l_name = 'anmt701.out'
    CALL cl_outnam('anmt701') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM nnr_file ",          # 組合出 SQL 指令
              " WHERE nnr01= '",g_nnr01,"' AND ",
                 g_wc CLIPPED
    PREPARE t701_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t701_co CURSOR FOR t701_p1
 
    START REPORT t701_rep TO l_name
 
    FOREACH t701_co INTO l_nnr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t701_rep(l_nnr.*)
    END FOREACH
 
    FINISH REPORT t701_rep
 
    CLOSE t701_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t701_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
        sr              RECORD LIKE nnr_file.*
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.nnr01,sr.nnr02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[15]))/2)+1,g_x[15] CLIPPED,sr.nnr01
            PRINT g_dash2
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
            PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
 #                   行序    帳單編號    帳款日期    INVOICE     幣別    匯率        應收原幣
            PRINT g_dash1
 #                 12345678901234567890123456789012345678901234567890123456789012345678901234567890
 #                          1         2         3         4         5         6         7
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file WHERE azi01=sr.nnr10
            PRINTX name=D1 COLUMN g_c[31],sr.nnr02 USING '####',
                  COLUMN  g_c[32],sr.nnr03,
                  COLUMN  g_c[33],sr.nnr05,
                  COLUMN  g_c[34],sr.nnr07,
                  COLUMN  g_c[35],sr.nnr10,
                  COLUMN  g_c[36],cl_numfor(sr.nnr11,36,t_azi07),
                  COLUMN  g_c[37],cl_numfor(sr.nnr12,37,t_azi04)
            PRINTX name=D2 COLUMN g_c[39] ,sr.nnr04,
                  COLUMN  g_c[40],sr.nnr06,
                  COLUMN  g_c[41],cl_numfor(sr.nnr08,41,t_azi04),
                  COLUMN  g_c[44],cl_numfor(sr.nnr13,44,g_azi04)
            PRINTX name=D2 COLUMN g_c[39],sr.nnr041,
                  COLUMN g_c[40],'LC:',
                  COLUMN g_c[44],sr.nnr09
        ON LAST ROW
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
#Patch....NO.MOD-5A0095 <003> #
