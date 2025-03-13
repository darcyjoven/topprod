# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmt310.4gl
# Descriptions...: 銀行預計存提資料維護作業
# Date & Author..: 92/05/22 By Yen
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/12 By pengu 報表轉XML
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0030 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740058 07/04/12 By Judy  預設上筆資料確定后資料未保存 
# Modify.........: No.TQC-750047 07/05/11 By Smapmin 修改錯字
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.FUN-830149 08/03/31 By zhaijie 報表輸出改為CR
# Modify.........: No.FUN-850038 08/05/12 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/21 By xumm 修改FUN-D30032遗留问题

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1   LIKE nma_file.nma01,
    g_nma     RECORD    nma01   LIKE nma_file.nma01,
                        nma02   LIKE nma_file.nma02,
                        nma04   LIKE nma_file.nma04
                        #No.FUN-850038 --start--
                        ,nmaud01 LIKE nma_file.nmaud01,
                        nmaud02 LIKE nma_file.nmaud02, 
                        nmaud03 LIKE nma_file.nmaud03, 
                        nmaud04 LIKE nma_file.nmaud04, 
                        nmaud05 LIKE nma_file.nmaud05, 
                        nmaud06 LIKE nma_file.nmaud06, 
                        nmaud07 LIKE nma_file.nmaud07, 
                        nmaud08 LIKE nma_file.nmaud08, 
                        nmaud09 LIKE nma_file.nmaud09, 
                        nmaud10 LIKE nma_file.nmaud10, 
                        nmaud11 LIKE nma_file.nmaud11, 
                        nmaud12 LIKE nma_file.nmaud12, 
                        nmaud13 LIKE nma_file.nmaud13, 
                        nmaud14 LIKE nma_file.nmaud14, 
                        nmaud15 LIKE nma_file.nmaud15
                        #FUN-850038 --end--
                         
              END RECORD,
    g_nma_t   RECORD    nma01   LIKE nma_file.nma01,
                        nma02   LIKE nma_file.nma02,
                        nma04   LIKE nma_file.nma04
                        #No.FUN-850038 --start--
                        ,nmaud01 LIKE nma_file.nmaud01,
                        nmaud02 LIKE nma_file.nmaud02, 
                        nmaud03 LIKE nma_file.nmaud03, 
                        nmaud04 LIKE nma_file.nmaud04, 
                        nmaud05 LIKE nma_file.nmaud05, 
                        nmaud06 LIKE nma_file.nmaud06, 
                        nmaud07 LIKE nma_file.nmaud07, 
                        nmaud08 LIKE nma_file.nmaud08, 
                        nmaud09 LIKE nma_file.nmaud09, 
                        nmaud10 LIKE nma_file.nmaud10, 
                        nmaud11 LIKE nma_file.nmaud11, 
                        nmaud12 LIKE nma_file.nmaud12, 
                        nmaud13 LIKE nma_file.nmaud13, 
                        nmaud14 LIKE nma_file.nmaud14, 
                        nmaud15 LIKE nma_file.nmaud15
                        #FUN-850038 --end--
              END RECORD,
    g_nma01_t       LIKE nma_file.nma01,
    g_nmj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nmj011      LIKE nmj_file.nmj011,      #項次
        nmj02       LIKE nmj_file.nmj02,       #日期
        nmj03       LIKE nmj_file.nmj03,       #異動碼
        nmj04       LIKE nmj_file.nmj04,       #金額
        nmj05       LIKE nmj_file.nmj05,       #摘要
        nmj06       LIKE nmj_file.nmj06        #實現否
        #FUN-850038 --start---
        ,nmjud01 LIKE nmj_file.nmjud01,
        nmjud02 LIKE nmj_file.nmjud02,
        nmjud03 LIKE nmj_file.nmjud03,
        nmjud04 LIKE nmj_file.nmjud04,
        nmjud05 LIKE nmj_file.nmjud05,
        nmjud06 LIKE nmj_file.nmjud06,
        nmjud07 LIKE nmj_file.nmjud07,
        nmjud08 LIKE nmj_file.nmjud08,
        nmjud09 LIKE nmj_file.nmjud09,
        nmjud10 LIKE nmj_file.nmjud10,
        nmjud11 LIKE nmj_file.nmjud11,
        nmjud12 LIKE nmj_file.nmjud12,
        nmjud13 LIKE nmj_file.nmjud13,
        nmjud14 LIKE nmj_file.nmjud14,
        nmjud15 LIKE nmj_file.nmjud15
        #FUN-850038 --end--
                    END RECORD,
    g_nmj_t         RECORD                     #程式變數 (舊值)
        nmj011      LIKE nmj_file.nmj011,      #項次
        nmj02       LIKE nmj_file.nmj02,       #日期
        nmj03       LIKE nmj_file.nmj03,       #異動碼
        nmj04       LIKE nmj_file.nmj04,       #金額
        nmj05       LIKE nmj_file.nmj05,       #摘要
        nmj06       LIKE nmj_file.nmj06        #實現否
        #FUN-850038 --start---
        ,nmjud01 LIKE nmj_file.nmjud01,
        nmjud02 LIKE nmj_file.nmjud02,
        nmjud03 LIKE nmj_file.nmjud03,
        nmjud04 LIKE nmj_file.nmjud04,
        nmjud05 LIKE nmj_file.nmjud05,
        nmjud06 LIKE nmj_file.nmjud06,
        nmjud07 LIKE nmj_file.nmjud07,
        nmjud08 LIKE nmj_file.nmjud08,
        nmjud09 LIKE nmj_file.nmjud09,
        nmjud10 LIKE nmj_file.nmjud10,
        nmjud11 LIKE nmj_file.nmjud11,
        nmjud12 LIKE nmj_file.nmjud12,
        nmjud13 LIKE nmj_file.nmjud13,
        nmjud14 LIKE nmj_file.nmjud14,
        nmjud15 LIKE nmj_file.nmjud15
        #FUN-850038 --end--
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166        
    g_rec_b             LIKE type_file.num5,          #目前單身筆數      #No.FUN-680107 SMALLINT
    l_ac                LIKE type_file.num5,          #目前處理 ARRAY COUNT        #No.FUN-680107 SMALLINT
    p_row,p_col         LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql STRING             #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680107
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_str           STRING                       #NO.FUN-830149
DEFINE   l_table         STRING                       #NO.FUN-830149    
DEFINE   g_x9            STRING                       #NO.FUN-830149    
DEFINE   g_x10           STRING                       #NO.FUN-830149    
DEFINE   g_x11           STRING                       #NO.FUN-830149    
DEFINE   g_x12           STRING                       #NO.FUN-830149    
DEFINE   g_x13           STRING                       #NO.FUN-830149 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8             #No.FUN-6A0082
 
   OPTIONS
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
   INITIALIZE g_nma.* TO NULL
   INITIALIZE g_nma_t.* TO NULL
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW t310_w AT p_row,p_col
     WITH FORM "anm/42f/anmt310"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#NO.FUN-830149----START-----
   LET g_sql = "nma01.nma_file.nma01,",
               "nma02.nma_file.nma02,",
               "nma04.nma_file.nma04,",
               "nmj02.nmj_file.nmj02,",
               "nmj03.nmj_file.nmj03,",
               "nmj04.nmj_file.nmj04,",
               "nmj05.nmj_file.nmj05,",
               "nmj06.nmj_file.nmj06"   
   LET l_table = cl_prt_temptable('anmt310',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF         
#NO.FUN-830149----END----- 
    CALL cl_ui_init()
 
 
 
   LET g_argv1 = ARG_VAL(1)
   IF NOT cl_null(g_argv1) THEN
      CALL t310_q()
   END IF
   CALL t310_menu()
   CLOSE WINDOW t310_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t310_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   IF cl_null(g_argv1) THEN
      CLEAR FORM
      CALL g_nmj.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nma.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON nma01,nma02,nma04
                                #FUN-850038   ---start---
                                ,nmaud01,nmaud02,nmaud03,nmaud04,nmaud05,
                                nmaud06,nmaud07,nmaud08,nmaud09,nmaud10,
                                nmaud11,nmaud12,nmaud13,nmaud14,nmaud15
                                #FUN-850038    ----end----
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
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON nmj011,nmj02,nmj03,nmj04,nmj05,nmj06 # 螢幕上取單身條件
                         #No.FUN-850038 --start--
                         ,nmjud01,nmjud02,nmjud03,nmjud04,nmjud05,
                         nmjud06,nmjud07,nmjud08,nmjud09,nmjud10,
                         nmjud11,nmjud12,nmjud13,nmjud14,nmjud15
                         #No.FUN-850038 ---end---
           FROM s_nmj[1].nmj011,s_nmj[1].nmj02,s_nmj[1].nmj03,
                s_nmj[1].nmj04,s_nmj[1].nmj05,s_nmj[1].nmj06
                #No.FUN-850038 --start--
                ,s_nmj[1].nmjud01,s_nmj[1].nmjud02,s_nmj[1].nmjud03,s_nmj[1].nmjud04,s_nmj[1].nmjud05,
                s_nmj[1].nmjud06,s_nmj[1].nmjud07,s_nmj[1].nmjud08,s_nmj[1].nmjud09,s_nmj[1].nmjud10,
                s_nmj[1].nmjud11,s_nmj[1].nmjud12,s_nmj[1].nmjud13,s_nmj[1].nmjud14,s_nmj[1].nmjud15
                #No.FUN-850038 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(nmj03) #銀行代號
#                 CALL q_nmc(11,34,l_nmj03) RETURNING l_nmj03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmc"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nmj03
                  NEXT FIELD nmj03
               OTHERWISE EXIT CASE
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
      IF INT_FLAG THEN
         LET INT_FLAG=0
         RETURN
      END IF
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET g_wc = g_wc clipped," AND nmauser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET g_wc = g_wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #         LET g_wc = g_wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
      #End:FUN-980030
 
      IF g_wc2 = " 1=1" THEN               # 若單身未輸入條件
         LET g_sql = "SELECT nma01 FROM nma_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY nma01"
      ELSE                         # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE nma01 ",
                     "  FROM nma_file, nmj_file ",
                     " WHERE nma01 = nmj_file.nmj01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY nma01"
      END IF
   ELSE
      LET g_wc  = " nma01 = '",g_argv1,"'"
      LET g_wc2 = " nmj01 = '",g_argv1,"'"
      LET g_sql = "SELECT UNIQUE nma01 ",
" FROM nma_file LEFT JOIN nmj_file ON nma01 = nmj_file.nmj01 ",
" WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " ORDER BY nma01"
   END IF
   PREPARE t310_prepare FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE t310_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t310_prepare
   IF g_wc2 = " 1=1" THEN               # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM nma_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(distinct nma01)",
                " FROM nma_file,nmj_file WHERE ",
                " nma01=nmj01 AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
   END IF
   PREPARE t310_recount FROM g_sql
   DECLARE t310_count CURSOR FOR t310_recount
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION t310_menu()
 
   WHILE TRUE
      CALL t310_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t310_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth()
               THEN CALL t310_b()
            ELSE                        #TQC-D40025 Add
               LET g_action_choice = "" #TQC-D40025 Add
            END IF
           #LET g_action_choice = ""    #TQC-D40025 Mark
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL t310_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmj),'','')
            END IF
         #No.FUN-6A0011---------add---------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nma.nma01 IS NOT NULL THEN
                 LET g_doc.column1 = "nma01"
                 LET g_doc.value1 = g_nma.nma01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0011---------add---------end----
      END CASE
   END WHILE
   CLOSE t310_cs
END FUNCTION
 
FUNCTION t310_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_nma.* TO NULL              #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t310_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
   CALL g_nmj.clear()
      RETURN
   END IF
   OPEN t310_count
   FETCH t310_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t310_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
      INITIALIZE g_nma.* TO NULL
   ELSE
      CALL t310_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t310_fetch(p_flnmj)
   DEFINE
      p_flnmj         LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
      l_abso          LIKE type_file.num10         #No.FUN-680107 INTEGER
 
   CASE p_flnmj
      WHEN 'N' FETCH NEXT     t310_cs INTO g_nma.nma01
      WHEN 'P' FETCH PREVIOUS t310_cs INTO g_nma.nma01
      WHEN 'F' FETCH FIRST    t310_cs INTO g_nma.nma01
      WHEN 'L' FETCH LAST     t310_cs INTO g_nma.nma01
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
            FETCH ABSOLUTE g_jump t310_cs INTO g_nma.nma01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
      INITIALIZE g_nma.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flnmj
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT nma01,nma02,nma04         # 重讀DB,因TEMP有不被更新特性
          #FUN-850038     ---start---
          ,nmaud01,nmaud02,nmaud03,nmaud04,
          nmaud05,nmaud06,nmaud07,nmaud08,
          nmaud09,nmaud10,nmaud11,nmaud12,
          nmaud13,nmaud14,nmaud15 
          #FUN-850038     ----end----
     INTO g_nma.* FROM nma_file
    WHERE nma_file.nma01 = g_nma.nma01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("sel","nma_file",g_nma.nma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      CALL t310_show()                      # 重新顯示
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t310_show()
   LET g_nma_t.* = g_nma.*                      #保存單頭舊值
   DISPLAY BY NAME g_nma.nma01,g_nma.nma02,g_nma.nma04
           #FUN-850038     ---start---
           ,g_nma.nmaud01,g_nma.nmaud02,g_nma.nmaud03,g_nma.nmaud04,
           g_nma.nmaud05,g_nma.nmaud06,g_nma.nmaud07,g_nma.nmaud08,
           g_nma.nmaud09,g_nma.nmaud10,g_nma.nmaud11,g_nma.nmaud12,
           g_nma.nmaud13,g_nma.nmaud14,g_nma.nmaud15 
           #FUN-850038     ----end----
   CALL t310_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t310_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680107 VARCHAR(1)
   l_nmj03         LIKE nmj_file.nmj03,                #異動碼
   l_flag          LIKE type_file.chr1,                #No.FUN-680107 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
   IF g_nma.nma01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nmj011,nmj02,nmj03,nmj04,nmj05,nmj06",
                      "  FROM nmj_file",
                      " WHERE nmj01 = ? AND nmj011 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
       INPUT ARRAY g_nmj WITHOUT DEFAULTS FROM s_nmj.*
             ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
        IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)
        END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
         #LET g_nmj_t.* = g_nmj[l_ac].*  #BACKUP
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          IF g_rec_b >= l_ac THEN
        # IF g_nmj_t.nmj011 IS NOT NULL THEN
             LET p_cmd='u'
             LET g_nmj_t.* = g_nmj[l_ac].*  #BACKUP
             BEGIN WORK
             OPEN t310_bcl USING g_nma.nma01,g_nmj_t.nmj011
             IF STATUS THEN
                CALL cl_err("OPEN t310_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t310_bcl INTO g_nmj[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_nmj_t.nmj011,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
         #NEXT FIELD nmj011
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_nmj[l_ac].* TO NULL      #900423
          LET g_nmj[l_ac].nmj06 = 'N'       #Default
          LET g_nmj_t.* = g_nmj[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD nmj011
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
            #CALL g_nmj.deleteElement(l_ac)   #取消 Array Element
            #IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
            #   LET g_action_choice = "detail"
            #   LET l_ac = l_ac_t
            #END IF
            #EXIT INPUT
          END IF
          INSERT INTO nmj_file (nmj01,nmj011,nmj02,nmj03,nmj04,nmj05,nmj06
                                #No.FUN-850038 --start--
                                ,nmjud01,nmjud02,nmjud03,nmjud04,nmjud05,
                                nmjud06,nmjud07,nmjud08,nmjud09,nmjud10,
                                nmjud11,nmjud12,nmjud13,nmjud14,nmjud15,
                                #No.FUN-850038 ---end---
                                nmjlegal)  #FUN-980005 add legal 
               VALUES(g_nma.nma01,g_nmj[l_ac].nmj011,g_nmj[l_ac].nmj02,
                      g_nmj[l_ac].nmj03,g_nmj[l_ac].nmj04,
                      g_nmj[l_ac].nmj05,g_nmj[l_ac].nmj06
                      #No.FUN-850038 --start--
                      ,g_nmj[l_ac].nmjud01,g_nmj[l_ac].nmjud02,g_nmj[l_ac].nmjud03,
                      g_nmj[l_ac].nmjud04,g_nmj[l_ac].nmjud05,g_nmj[l_ac].nmjud06,
                      g_nmj[l_ac].nmjud07,g_nmj[l_ac].nmjud08,g_nmj[l_ac].nmjud09,
                      g_nmj[l_ac].nmjud10,g_nmj[l_ac].nmjud11,g_nmj[l_ac].nmjud12,
                      g_nmj[l_ac].nmjud13,g_nmj[l_ac].nmjud14,g_nmj[l_ac].nmjud15,
                      #No.FUN-850038 ---end---
                      g_legal)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_nmj[l_ac].nmj011,SQLCA.sqlcode,0)   #No.FUN-660148
             CALL cl_err3("ins","nmj_file",g_nma.nma01,g_nmj[l_ac].nmj011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            #LET g_nmj[l_ac].* = g_nmj_t.*
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       BEFORE FIELD nmj011                            #default 序號
          IF cl_null(g_nmj[l_ac].nmj011) OR g_nmj[l_ac].nmj011 = 0 THEN
             SELECT max(nmj011)+1 INTO g_nmj[l_ac].nmj011
               FROM nmj_file
              WHERE nmj01 = g_nma.nma01
             IF cl_null(g_nmj[l_ac].nmj011) THEN
                LET g_nmj[l_ac].nmj011 = 1
             END IF
          END IF
 
       BEFORE FIELD nmj04 #票面金額
          IF cl_null(g_nmj[l_ac].nmj04) THEN
             LET g_nmj[l_ac].nmj04 = 0
          END IF
 
       AFTER FIELD nmj011                        #check 項次是否重複
          IF NOT cl_null(g_nmj_t.nmj011) THEN
             IF cl_null(g_nmj[l_ac].nmj011) THEN
                LET g_nmj[l_ac].nmj011 = g_nmj_t.nmj011
                CALL cl_err('','anm-003',0)
                NEXT FIELD nmj011
             END IF
          END IF
          IF (p_cmd = 'a') OR
             (p_cmd = 'u' AND g_nmj_t.nmj011 != g_nmj[l_ac].nmj011) THEN
             SELECT count(*) INTO l_n
               FROM nmj_file
              WHERE nmj01 = g_nma.nma01
                AND nmj011 = g_nmj[l_ac].nmj011
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_nmj[l_ac].nmj011 = g_nmj_t.nmj011
                NEXT FIELD nmj011
             END IF
          END IF
 
       AFTER FIELD nmj03                        #check
          IF NOT cl_null(g_nmj[l_ac].nmj03) THEN
             SELECT count(*) INTO l_n
               FROM nmc_file
              WHERE nmc01 = g_nmj[l_ac].nmj03
             IF l_n <= 0 THEN
                CALL cl_err(g_nmj[l_ac].nmj03,'anm-030',0)
                LET g_nmj[l_ac].nmj03 = g_nmj_t.nmj03
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_nmj[l_ac].nmj03
                #------MOD-5A0095 END------------
                NEXT FIELD nmj03
             END IF
          END IF
 
       AFTER FIELD nmj04 #票面金額
          IF NOT cl_null(g_nmj[l_ac].nmj04) THEN
             IF g_nmj[l_ac].nmj04 <= 0 THEN
               CALL cl_err(g_nmj[l_ac].nmj04,'anm-041',0)
               NEXT FIELD nmj04
             END IF
          END IF
 
       AFTER FIELD nmj06
          IF NOT cl_null(g_nmj[l_ac].nmj06) THEN
             IF g_nmj[l_ac].nmj06 NOT MATCHES "[YN]" THEN
                LET g_nmj[l_ac].nmj06 = g_nmj_t.nmj06
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_nmj[l_ac].nmj06
                #------MOD-5A0095 END------------
                NEXT FIELD nmj06
             END IF
          END IF
 
        #No.FUN-850038 --start--
        AFTER FIELD nmjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       BEFORE DELETE                            #是否取消單身
          IF g_nmj_t.nmj011 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM nmj_file
              WHERE nmj01 = g_nma.nma01
                AND nmj011 = g_nmj[l_ac].nmj011
             LET g_rec_b = g_rec_b -1
             DISPLAY g_rec_b TO FORMONLY.cn2
             IF SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err(g_nmj_t.nmj011,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("del","nmj_file",g_nma.nma01,g_nmj[l_ac].nmj011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_nmj[l_ac].* = g_nmj_t.*
             CLOSE t310_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_nmj[l_ac].nmj011,-263,1)
             LET g_nmj[l_ac].* = g_nmj_t.*
          ELSE
             UPDATE nmj_file SET nmj011= g_nmj[l_ac].nmj011,
                                 nmj02 = g_nmj[l_ac].nmj02,
                                 nmj03 = g_nmj[l_ac].nmj03,
                                 nmj04 = g_nmj[l_ac].nmj04,
                                 nmj05 = g_nmj[l_ac].nmj05,
                                 nmj06 = g_nmj[l_ac].nmj06
                                 #No.FUN-850038 --start--
                                 ,nmjud01 = g_nmj[l_ac].nmjud01,
                                 nmjud02 = g_nmj[l_ac].nmjud02,
                                 nmjud03 = g_nmj[l_ac].nmjud03,
                                 nmjud04 = g_nmj[l_ac].nmjud04,
                                 nmjud05 = g_nmj[l_ac].nmjud05,
                                 nmjud06 = g_nmj[l_ac].nmjud06,
                                 nmjud07 = g_nmj[l_ac].nmjud07,
                                 nmjud08 = g_nmj[l_ac].nmjud08,
                                 nmjud09 = g_nmj[l_ac].nmjud09,
                                 nmjud10 = g_nmj[l_ac].nmjud10,
                                 nmjud11 = g_nmj[l_ac].nmjud11,
                                 nmjud12 = g_nmj[l_ac].nmjud12,
                                 nmjud13 = g_nmj[l_ac].nmjud13,
                                 nmjud14 = g_nmj[l_ac].nmjud14,
                                 nmjud15 = g_nmj[l_ac].nmjud15
                                 #No.FUN-850038 ---end---
              WHERE nmj01=g_nma.nma01 AND nmj011=g_nmj_t.nmj011
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nmj[l_ac].nmj011,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nmj_file",g_nma.nma01,g_nmj_t.nmj011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nmj[l_ac].* = g_nmj_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac      #FUN-D30032 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_nmj[l_ac].* = g_nmj_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_nmj.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end-- 
             END IF
             CLOSE t310_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac      #FUN-D30032 Add
          CLOSE t310_bcl
          COMMIT WORK
 
#      ON ACTION CONTROLN
#         CALL t310_b_askkey()
#         EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(nmj011) AND l_ac > 1 THEN
             LET g_nmj[l_ac].* = g_nmj[l_ac-1].*
#            LET g_nmj[l_ac].nmj011 = NULL   #TQC-620018  #TQC-740058
             LET g_nmj[l_ac].nmj011 = g_rec_b + 1 #TQC-740058                   
             DISPLAY BY NAME g_nmj[l_ac].nmj011   #TQC-740058 
             NEXT FIELD nmj011
          END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(nmj03) #銀行代號
                LET  l_nmj03 = g_nmj[l_ac].nmj03
#               CALL q_nmc(11,34,l_nmj03) RETURNING l_nmj03
#               CALL FGL_DIALOG_SETBUFFER( l_nmj03 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nmc"
                LET g_qryparam.default1 = l_nmj03
                CALL cl_create_qry() RETURNING l_nmj03
#                CALL FGL_DIALOG_SETBUFFER( l_nmj03 )
                LET  g_nmj[l_ac].nmj03 = l_nmj03
                 DISPLAY BY NAME g_nmj[l_ac].nmj03         #No.MOD-490344
                NEXT FIELD nmj03
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION create_bank_withdraw
          CALL cl_cmdrun('anmi032 '  CLIPPED)
 
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
 
   CLOSE t310_bcl
 
END FUNCTION
 
FUNCTION t310_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
  CONSTRUCT l_wc2 ON nmj011,nmj02,nmj03,nmj04,nmj05,nmj06
                FROM s_nmj[1].nmj011,s_nmj[1].nmj02,s_nmj[1].nmj03,
                     s_nmj[1].nmj04,s_nmj[1].nmj05,s_nmj[1].nmj06
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL t310_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t310_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
   LET g_rec_b = 0
   LET g_sql = "SELECT nmj011,nmj02,nmj03,nmj04,nmj05,nmj06",
               #No.FUN-850038 --start--
               "       ,nmjud01,nmjud02,nmjud03,nmjud04,nmjud05,",
               "       nmjud06,nmjud07,nmjud08,nmjud09,nmjud10,",
               "       nmjud11,nmjud12,nmjud13,nmjud14,nmjud15", 
               #No.FUN-850038 ---end---
               " FROM nmj_file",
               " WHERE nmj01 ='",g_nma.nma01,"'",
               " AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE t310_pb FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE nmj_cs                       #SCROLL CURSOR
       CURSOR FOR t310_pb
 
   CALL g_nmj.clear()
   LET g_cnt = 1
   FOREACH nmj_cs INTO g_nmj[g_cnt].*   #單身 ARRAY 填充
      LET g_cnt=g_cnt+1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   CALL g_nmj.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_nmj TO s_nmj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL t310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t310_fetch('L')
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
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION t310_out()
DEFINE
    l_i             LIKE type_file.num5,               #No.FUN-680107 SMALLINT
    sr       RECORD order1 LIKE nmj_file.nmj01,        #No.FUN-680107 VARCHAR(10)
                    order2 LIKE nmj_file.nmj01,        #No.FUN-680107 VARCHAR(10)
        nma01       LIKE nma_file.nma01,   #銀行編號
        nma02       LIKE nma_file.nma03,   #銀行簡稱
        nma04       LIKE nma_file.nma04,   #銀行帳號
        nmj02       LIKE nmj_file.nmj02,   #日期
        nmj03       LIKE nmj_file.nmj03,   #異動碼
        nmj04       LIKE nmj_file.nmj04,   #金額
        nmj05       LIKE nmj_file.nmj05,   #摘要
        nmj06       LIKE nmj_file.nmj06    #實現否
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680107 VARCHAR(20)
    l_za05          LIKE type_file.chr1000,             #        #No.FUN-680107 VARCHAR(40)
    l_chr           LIKE type_file.chr1                 #        #No.FUN-680107 VARCHAR(1)
    CALL cl_del_data(l_table)                           #NO.FUN-830149
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
#    CALL cl_outnam('anmt310') RETURNING l_name          #NO.FUN-830149
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT '','',nma01,nma02,nma04,",
              "nmj02,nmj03,nmj04,nmj05,nmj06",
              " FROM nma_file,nmj_file",
              " WHERE nma01=nmj01 AND ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED
    PREPARE t310_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
    DECLARE t310_co CURSOR FOR t310_p1
    CALL t310_o_srt() RETURNING g_chr,l_chr
    IF l_chr = 'n' THEN RETURN END IF
 
 
#    START REPORT t310_rep TO l_name                     #NO.FUN-830149
 
    FOREACH t310_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#NO.FUN-830149----START---MARK----
#        IF  g_chr = "2"  THEN                 #move sort data
#           LET sr.order1 = sr.nmj02
#           LET sr.order2 = sr.nma01
#        ELSE
#           LET sr.order1 = sr.nma01
#           LET sr.order2 = sr.nmj02
#        END IF
#NO.FUN-830149----end---mark----
#        OUTPUT TO REPORT t310_rep(sr.*)                 #NO.FUN-830149
#NO.FUN-830149----START----
    EXECUTE insert_prep USING 
      sr.nma01,sr.nma02,sr.nma04,sr.nmj02,sr.nmj03,sr.nmj04,sr.nmj05,sr.nmj06
#NO.FUN-830149---END----
    END FOREACH
 
#    FINISH REPORT t310_rep                              #NO.FUN-830149
#NO.FUN-830149----START------
     LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(g_wc,'nmj011,nmj02,nmj03,nmj04,nmj05,nmj06 ')
             RETURNING g_wc
     END IF
     LET g_str = g_wc,";",g_chr,";",g_azi04
     CALL cl_prt_cs3('anmt310','anmt310',g_sql,g_str)
#NO.FUN-830149----END------ 
    CLOSE t310_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)                   #NO.FUN-830149
END FUNCTION
 
FUNCTION t310_o_srt()
DEFINE
    l_chr    LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   LET l_chr = 'y'
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 16 LET p_col = 36
   ELSE LET p_row = 16 LET p_col = 20
   END IF
   OPEN WINDOW cl_sure_w AT p_row,p_col WITH 7 ROWS, 40 COLUMNS
 
#NO.FUN-830149---START----
#      DISPLAY  g_x[9] CLIPPED,g_x[10]  AT 1,1
#      DISPLAY  '       (1)．',g_x[11]  AT 3,1
#      DISPLAY  '       (2)．',g_x[12]  AT 4,1
     CALL cl_getmsg('anmt09',g_lang) RETURNING g_x9
     CALL cl_getmsg('anmt10',g_lang) RETURNING g_x10
     CALL cl_getmsg('anmt11',g_lang) RETURNING g_x11
     CALL cl_getmsg('anmt12',g_lang) RETURNING g_x12
     CALL cl_getmsg('anmt13',g_lang) RETURNING g_x13
      DISPLAY  g_x9 CLIPPED,g_x10  AT 1,1
      DISPLAY  '       (1). ',g_x11  AT 3,1
      DISPLAY  '       (2). ',g_x12  AT 4,1
#NO.FUN-830149---END-----
      LET g_chr = ''
   WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT  g_x[13]  CLIPPED FOR g_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
#            CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END PROMPT
      IF INT_FLAG THEN LET INT_FLAG = 0 LET l_chr = "n" EXIT WHILE END IF
      IF g_chr IS NOT NULL AND g_chr MATCHES "[12]" THEN
         EXIT WHILE
      END IF
   END WHILE
   CLOSE WINDOW cl_sure_w RETURN g_chr,l_chr
END FUNCTION
#NO.FUN-830149----START---MARK---
#REPORT t310_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
#    l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
#    sr       RECORD order1 LIKE nmj_file.nmj01,   #No.FUN-680107 
#                    order2 LIKE nmj_file.nmj01,   #No.FUN-680107
#        nma01       LIKE nma_file.nma01,   #銀行編號
#        nma02       LIKE nma_file.nma02,   #銀行簡稱
#        nma04       LIKE nma_file.nma04,   #銀行帳號
#        nmj02       LIKE nmj_file.nmj02,   #日期
#        nmj03       LIKE nmj_file.nmj03,   #異動碼
#        nmj04       LIKE nmj_file.nmj04,   #金額
#        nmj05       LIKE nmj_file.nmj05,   #摘要
#        nmj06       LIKE nmj_file.nmj06    #實現否
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY  sr.order1,sr.order2
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT '  '   #TQC-740058   #TQC-750047
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
# 
#            IF  g_chr = "2"  THEN                 #move sort data
#                LET g_head1=g_x[10] CLIPPED,' ',g_x[12] CLIPPED
#                PRINT g_head1
#            ELSE
#                LET g_head1=g_x[10] CLIPPED,' ',g_x[11] CLIPPED
#                PRINT g_head1
#            END IF
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.nma01,
#                 COLUMN g_c[32],sr.nma02,
#                 COLUMN g_c[33],sr.nmj02,
#                 COLUMN g_c[34],sr.nmj03,
#                 COLUMN g_c[35],cl_numfor(sr.nmj04,35,g_azi04),
#                 COLUMN g_c[36],sr.nmj05 clipped,
#                 COLUMN g_c[37],sr.nmj06
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,201
#               THEN
#                    PRINT g_dash[1,g_len]
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#            END IF
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-830149----END--MARK--
#Patch....NO.MOD-5A0095 <003,001> #
