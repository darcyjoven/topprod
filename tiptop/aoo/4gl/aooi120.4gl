# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi120.4gl
# Descriptions...: 新舊會計科目對應關系維護作業
# Date & Author..: No.FUN-730048 07/03/23 By johnray
# Modify.........: No.FUN-750055 07/05/15 BY cheunl  更新基本檔會計科目
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-810058 08/01/18 By lumxa  apz52 faa20 occ03 occ04在UPDATE時候 apz52 faa20無需更新，occ03 occ04應該是ooc03和ooc04
# Modify.........: No.FUN-810045 08/03/03 By rainy 專案管理相關修改.dbo.pjg_file已取消
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.TQC-980246 09/09/01 By liuxqa 資料全部查出，刪除一筆資料，不會顯示下一筆。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0372 10/12/02 By chenying 年度欄位輸入負數沒有管控
#                                                     運行成功后彈出對話框“執行成功，是否繼續作業”選擇“是”程序沒有任何反應；選擇“否”退出
#                                                     新舊帳套的更替和新舊科目的轉換對應（一對一，不能多對一或一對多）
# Modify.........: No.FUN-B10052 11/01/24 By lilingyu 科目查詢自動過濾
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數檔改為aaw_file 
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B90189 11/09/26 By johung 修正單身查詢條件未傳入g_wc
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:MOD-BC0110 12/01/09 By Lori 會計科目需排除統制科目
# Modify.........: No:FUN-BB0015 12/01/09 By Lori 新增[整批產生]功能
# Modify.........: No:FUN-BC0068 12/01/09 By Lori 新增[整批刪除]功能
# Modify.........: No:FUN-BB0017 12/01/09 By Lori 增加資料有效否
# Modify.........: No:TQC-C10031 12/01/13 By Lori 修改整批產生中的開窗選項
# Modify.........: No:CHI-C20023 12/03/09 By Lori 增加[使用時點]欄位

# Modify.........: No:CHI-C80044 12/07/10 By Belle  控卡科目不可一對多
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   g_tag01        LIKE tag_file.tag01,       #目錄代號 (假單頭)
   g_tag01_t      LIKE tag_file.tag01,       #目錄代號 (舊值)
   g_tag06        LIKE tag_file.tag06,       #CHI-C20023
   g_tag06_t      LIKE tag_file.tag06,       #CHI-C20023
   g_tag          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
      tag04          LIKE tag_file.tag04,
      tag05          LIKE tag_file.tag05,
      aag022         LIKE aag_file.aag02,
      tag02          LIKE tag_file.tag02,
      tag03          LIKE tag_file.tag03,
      aag021         LIKE aag_file.aag02,
      tagacti        LIKE tag_file.tagacti   #FUN-BB0017
                  END RECORD,
   g_tag_t        RECORD                     #程式變數 (舊值)
      tag04          LIKE tag_file.tag04,
      tag05          LIKE tag_file.tag05,
      aag022         LIKE aag_file.aag02,
      tag02          LIKE tag_file.tag02,
      tag03          LIKE tag_file.tag03,
      aag021         LIKE aag_file.aag02,
      tagacti        LIKE tag_file.tagacti   #FUN-BB0017
                  END RECORD,
   g_name         LIKE type_file.chr20,
   g_wc,g_sql     STRING,
   g_ss           LIKE type_file.chr1,       #決定後續步驟
   l_ac           LIKE type_file.num5,       #目前處理的ARRAY CNT
   g_argv1        LIKE tag_file.tag01,
   g_rec_b        LIKE type_file.num5,       #單身筆數
   g_cn2          LIKE type_file.num5
DEFINE g_forupd_sql        STRING            #SELECT ... FOR UPDATE SQL
DEFINE g_chr               LIKE tag_file.tag01
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10   #No.TQC-980246 add
DEFINE mi_no_ask           LIKE type_file.num5    #No.TQC-980246 add
 
MAIN
   DEFINE p_row,p_col      LIKE type_file.num5
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)            #計算使用時間 (進入時間)
      RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_tag01 = NULL                        #清除鍵值
   LET g_tag01_t = NULL
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW i120_w AT p_row,p_col WITH FORM "aoo/42f/aooi120"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

  #CHI-C20023--Begin--
   IF g_aza.aza26 = '2' THEN
      CALL cl_set_comp_visible("tag06",TRUE)
   ELSE
      CALL cl_set_comp_visible("tag06",FALSE)
   END IF
  #CHI-C20023---End---
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL i120_q() END IF
 
   CALL i120_menu()
 
   CLOSE WINDOW i120_w                       #結束畫面
   CALL cl_used(g_prog,g_time,2)             #計算使用時間 (退出時間)
      RETURNING g_time
 
END MAIN
 
FUNCTION i120_curs()                         # QBE 查詢資料
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             # 清除畫面
      CALL g_tag.clear()
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_tag01 TO NULL    #No.FUN-750051
      INITIALIZE g_tag06 TO NULL    #No.CHI-C20023
      CONSTRUCT g_wc ON tag01,tag04,tag05,tag02,tag03,tag06  #CHI-C20023 add tag06    # 螢幕上取條件
         FROM tag01,s_tag[1].tag04,s_tag[1].tag05,s_tag[1].tag02,s_tag[1].tag03,tag06  #CHI-C20023 add tag06
 
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

        #MOD-BC0110--Begin--
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tag02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aaa"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tag02
                  NEXT FIELD tag02

               WHEN INFIELD(tag03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_aag06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tag03
                  NEXT FIELD tag03

               WHEN INFIELD(tag04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aaa"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tag04
                  NEXT FIELD tag04

               WHEN INFIELD(tag05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_aag06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tag05
                  NEXT FIELD tag05

            END CASE
        #MOD-BC0110--End--
 
      END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)  #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc=" tag01='",g_argv1,"'"
   END IF

   LET g_sql= "SELECT UNIQUE tag01,tag06 FROM tag_file ",     #CHI-C20023 add tag06 
              " WHERE ", g_wc CLIPPED
   
   PREPARE i120_prepare FROM g_sql      #預備一下
   DECLARE i120_b_curs                  #宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR i120_prepare
 
  #LET g_sql = "SELECT COUNT(DISTINCT tag01) FROM tag_file ",  #CHI-C20023
  #            " WHERE ",g_wc CLIPPED                          #CHI-C20023
   LET g_sql = "SELECT COUNT(*) FROM (",                       #CHI-C20023
               "   SELECT DISTINCT tag01,tag06 FROM tag_file ",#CHI-C20023
               "   WHERE ",g_wc CLIPPED                        #CHI-C20023
 #CHI-C20023--Begin--
  IF g_aza.aza26 <> '2' THEN
     LET g_sql = g_sql," AND tag06 = '1'"
  END IF
  LET g_sql = g_sql,")"
 #CHI-C20023---End---

   PREPARE i120_precount FROM g_sql
   DECLARE i120_count CURSOR FOR i120_precount
 
END FUNCTION
 
FUNCTION i120_menu()
   DEFINE l_cmd   LIKE type_file.chr1000
   DEFINE l_flag  LIKE type_file.chr1   #TQC-AB0372
     
   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i120_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i120_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i120_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i120_copy()
            END IF
        #MOD-BC0110--Begin Mark--
        #WHEN "change"
        #   IF cl_chk_act_auth() THEN
        #      LET g_success = 'Y'      #TQC-AB0372
        #      BEGIN WORK               #TQC-AB0372
        #      CALL i120_change()
        #      #TQC-AB0372-----------add-----------str-------------
        #      IF g_success = 'Y' THEN
        #         COMMIT WORK
        #         CALL cl_end2(1) RETURNING l_flag
        #      ELSE
        #         ROLLBACK WORK
        #         CALL cl_end2(2) RETURNING l_flag
        #      END IF
        #      IF l_flag THEN
        #         CONTINUE WHILE
        #      ELSE
        #         EXIT WHILE
        #      END IF
        #      #TQC-AB0372---------add--------------end------------
        #   END IF
        #MOD-BC0110---End Mark---

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_tag01 IS NOT NULL THEN
                  LET g_doc.column1 = "tag01"
                  LET g_doc.value1 = g_tag01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tag),'','')
            END IF
        #FUN-BB0015--Begin--
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL i120_g()
            END IF
        #FUN-BB0015---End---
        #FUN-BC0068--Begin--
         WHEN "delete_select"
            IF cl_chk_act_auth() THEN
               CALL i120_r1()
            END IF
        #FUN-BC0068---End--- 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i120_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_tag.clear()
   INITIALIZE g_tag01 LIKE tag_file.tag01
   LET g_tag01_t = NULL
   INITIALIZE g_tag06 LIKE tag_file.tag06  #CHI-C20023
   LET g_tag06_t = NULL                    #CHI-C20023
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i120_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b=0
      CALL g_tag.clear()
      IF g_ss='Y' THEN
         CALL i120_b_fill()             #單身
         DISPLAY ARRAY g_tag TO s_tag.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      END IF
 
      CALL i120_b()                      #輸入單身
      LET g_tag01_t = g_tag01            #保留舊值
      LET g_tag06_t = g_tag06            #CHI-C20023   #保留舊值
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i120_u()
   IF g_tag01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tag01_t = g_tag01
   LET g_tag06_t = g_tag06              #CHI-C20023
   WHILE TRUE
      CALL i120_i("u")                  #欄位更改
      IF INT_FLAG THEN
         LET g_tag01=g_tag01_t
         DISPLAY g_tag01 TO tag01       #單頭
         LET g_tag06=g_tag06_t          #CHI-C20023
         DISPLAY g_tag06 TO tag06       #CHI-C20023 #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_tag01 != g_tag01_t THEN      #更改單頭值
        #CHI-C20023--Begin--
         IF cl_null(g_tag06) THEN
            LET g_tag06 = '1'
         END IF
        #CHI-C20023---End---
        #UPDATE tag_file SET tag01 = g_tag01                    #CHI-C20023
        #   WHERE tag01 = g_tag01_t                             #CHI-C20023
         UPDATE tag_file SET tag01 = g_tag01,tag06 = g_tag06    #CHI-C20023
            WHERE tag01 = g_tag01_t AND tag06 = g_tag06_t       #CHI-C20023
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tag_file",g_tag01_t,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i120_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1       #a:輸入 u:更改
 
   LET g_ss='Y'
   CALL cl_set_head_visible("","YES")
 
   INPUT g_tag01,g_tag06        #CHI-C20023 add g_tag06
      WITHOUT DEFAULTS
      FROM tag01,tag06          #CHI-C20023 add tag06
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
#         CALL i120_set_entry(p_cmd)
#         CALL i120_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
        #CHI-C20023--Begin--
         IF cl_null(g_tag06) THEN
            LET g_tag06 = '1'
         END IF
        #CHI-C20023---End---
          NEXT FIELD tag01

      AFTER FIELD tag01                          #目錄代號
        #IF NOT cl_null(g_tag01) THEN                       #TQC-AB0372 mark
         IF NOT cl_null(g_tag01) AND g_tag01 >= 0  THEN     #TQC-AB0372 add
           #CHI-C20023--Begin Mark--
           #IF g_tag01 != g_tag01_t OR g_tag01_t IS NULL THEN    #輸入後更改不同時值
           #   SELECT UNIQUE tag01 INTO g_chr
           #      FROM tag_file
           #      WHERE tag01=g_tag01
           #   IF SQLCA.sqlcode THEN             #不存在, 新來的
           #      IF p_cmd='a' THEN
           #         LET g_ss='N'
           #      END IF
           #   ELSE
           #      IF p_cmd='u' THEN
           #         CALL cl_err(g_tag01,-239,0)
           #         LET g_tag01=g_tag01_t
           #         NEXT FIELD tag01
           #      END IF
           #   END IF
           #END IF
           #CHI-C20023---End Mark---
         ELSE                      #TQC-AB0372 add
            NEXT FIELD tag01       #TQC-AB0372 add
         END IF
     
     #CHI-C20023--Begin--
      AFTER FIELD tag06                          #目錄代號
         IF NOT cl_null(g_tag01) AND NOT cl_null(g_tag06) THEN
            IF (g_tag01 != g_tag01_t OR g_tag01_t IS NULL) AND
               (g_tag06 != g_tag06_t OR g_tag06_t IS NULL) THEN
               SELECT UNIQUE tag01 INTO g_chr
                  FROM tag_file
                  WHERE tag01=g_tag01 AND tag06 = g_tag06
               IF SQLCA.sqlcode THEN             #不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_tag01,-239,0)
                     LET g_tag01=g_tag01_t
                     NEXT FIELD tag01
                  END IF
               END IF
            END IF
         END IF
     #CHI-C20023---End---

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                         #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
     #TQC-860019-add
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     #TQC-860019-add
 
   END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i120_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_tag01 TO NULL
   INITIALIZE g_tag06 TO NULL             #CHI-C20023
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY ' ' TO FORMONLY.cnt
   CALL i120_curs()                       #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i120_b_curs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tag01 TO NULL
      INITIALIZE g_tag06 TO NULL             #CHI-C20023
   ELSE
      CALL i120_fetch('F')                #讀出TEMP第一筆並顯示
      OPEN i120_count
      FETCH i120_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i120_fetch(p_flag)
   DEFINE
      p_flag          LIKE type_file.chr1,   #處理方式
      l_abso          LIKE type_file.num10   #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i120_b_curs INTO g_tag01,g_tag06           #CHI-C20023 add g_tag06
      WHEN 'P' FETCH PREVIOUS i120_b_curs INTO g_tag01,g_tag06           #CHI-C20023 add g_tag06
      WHEN 'F' FETCH FIRST    i120_b_curs INTO g_tag01,g_tag06           #CHI-C20023 add g_tag06
      WHEN 'L' FETCH LAST     i120_b_curs INTO g_tag01,g_tag06           #CHI-C20023 add g_tag06
      WHEN '/'
        IF (NOT mi_no_ask) THEN                 #No.TQC-980246 add
         CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
         LET INT_FLAG = 0                #add for prompt bug
         #PROMPT g_msg CLIPPED,': ' FOR l_abso       #No.TQC-980246 mark
         PROMPT g_msg CLIPPED,': ' FOR g_jump        #No.TQC-980246 mod 
            ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
            ON ACTION about
               CALL cl_about()
 
            ON ACTION help
               CALL cl_show_help()
 
            ON ACTION controlg
               CALL cl_cmdask()
 
         END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
        END IF                                      #No.TQC-980246 add
            #FETCH ABSOLUTE l_abso i120_b_curs INTO g_tag01  #No.TQC-980246 mark
            FETCH ABSOLUTE g_jump i120_b_curs INTO g_tag01   #No.TQC-980246 mod
            LET mi_no_ask = FALSE                            #No.TQC-980246 add
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_tag01,SQLCA.sqlcode,0)
   ELSE
      CALL i120_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         #WHEN '/' LET g_curs_index = l_abso     #No.TQC-980246 mark
         WHEN '/' LET g_curs_index = g_jump      #No.TQC-980246 mod
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i120_show()
   DISPLAY g_tag01,g_tag06 TO tag01,tag06        #CHI-C20023 add tag06               #單頭
   CALL i120_b_fill()                    #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i120_r()
   IF g_tag01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tag01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tag01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM tag_file WHERE tag01 = g_tag01 AND tag06 = g_tag06     #CHI-C20023 add ta06
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","tag_file",g_tag01,"",SQLCA.sqlcode,"","BODY DELETE:",1)
      ELSE
         CLEAR FORM
         CALL g_tag.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
#No.TQC-980246 add --begin
         OPEN i120_count
         #FUN-B50065-add-start--
         IF STATUS THEN
            CLOSE i120_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50065-add-end-- 
         FETCH i120_count INTO g_row_count
         #FUN-B50065-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i120_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50065-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i120_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i120_fetch('L')
         ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i120_fetch('/')
         END IF
#No.TQC-980246 add --end
      END IF
   END IF
END FUNCTION
 
#單身
FUNCTION i120_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT
      l_n             LIKE type_file.num5,        #檢查重複用
      l_lock_sw       LIKE type_file.chr1,        #單身鎖住否
      p_cmd           LIKE type_file.chr1,        #處理狀態
      l_tot           LIKE type_file.num5,
      l_allow_insert  LIKE type_file.num5,        #可新增否
      l_allow_delete  LIKE type_file.num5,        #可刪除否
      l_cnt           LIKE type_file.num5,        #判斷FIELD欄位值是否有效
      l_aag07         LIKE aag_file.aag07,        #MOD-BC0110 add
      l_aagacti       LIKE aag_file.aagacti       #MOD-BC0110 add
 
   LET g_action_choice = ""
   IF g_tag01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
  #LET g_forupd_sql = "SELECT tag04,tag05,tag02,tag03,tagacti FROM tag_file WHERE tag01=? FOR UPDATE"  #CHI-C20023 mark #FUN-BB0017 addtagacti
   LET g_forupd_sql = "SELECT tag04,tag05,tag02,tag03,tagacti FROM tag_file WHERE tag01=? AND tag06 = ? FOR UPDATE"      #CHI-C20023
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_cnt = 0
 
   INPUT ARRAY g_tag WITHOUT DEFAULTS FROM s_tag.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         DISPLAY l_ac  TO FORMONLY.cn2
         LET l_lock_sw = 'N'               #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_tag_t.* = g_tag[l_ac].*  #BACKUP
 
            BEGIN WORK
            OPEN i120_b_curl USING g_tag01,g_tag06         #CHI-C20023 add g_tag06
            IF STATUS THEN
               CALL cl_err("OPEN i120_b_curl:", STATUS, 1)
               LET l_lock_sw = "Y"
#            ELSE
#               FETCH i120_b_curl INTO g_tag[l_ac].*
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_tag_t.tag03,SQLCA.sqlcode,1)
#                   LET l_lock_sw = "Y"
#               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tag[l_ac].* TO NULL
         LET g_tag_t.* = g_tag[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         LET g_tag[l_ac].tagacti = 'Y'         #FUN-BB0017 tagacti預設值給Y
         NEXT FIELD tag04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
        #CHI-C80044--begin--
         LET g_errno = ' '
         IF NOT cl_null(g_tag[l_ac].tag03) AND NOT cl_null(g_tag[l_ac].tag02) AND p_cmd = 'a' THEN
            CALL i120_chk_acctcnt(g_tag01,g_tag[l_ac].tag02,g_tag[l_ac].tag03) RETURNING g_errno
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tag[l_ac].tag03,g_errno,0)
               NEXT FIELD tag03
            END IF
         END IF
         IF cl_null(g_errno) THEN
        #CHI-C80044--end--
            INSERT INTO tag_file(tag01,tag02,tag03,tag04,tag05,tagacti   #FUN-BB0017 add tagacti
                                 ,tag06)                                        #CHI-C20023
               VALUES(g_tag01,g_tag[l_ac].tag02,g_tag[l_ac].tag03,
                      g_tag[l_ac].tag04,g_tag[l_ac].tag05,g_tag[l_ac].tagacti   #FUN-BB0017 add tagacti
                     ,g_tag06)         #CHI-C20023
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tag_file",g_tag[l_ac].tag02,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
         END IF        #CHI-C80044
 
      AFTER FIELD tag04
         IF NOT cl_null(g_tag[l_ac].tag04) THEN                   
            SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01 = g_tag[l_ac].tag04
            IF l_cnt <> 1 THEN
               CALL cl_err("","anm-009",1)
               NEXT FIELD tag04
            END IF
         END IF
 
      BEFORE FIELD tag05
         IF cl_null(g_tag[l_ac].tag04) THEN
            CALL cl_err("","anm-009",0)    #FUN-B10052  "1"->"0"
            NEXT FIELD tag04
         END IF
 
      AFTER FIELD tag05
         IF NOT cl_null(g_tag[l_ac].tag05) THEN
           #MOD-BC0110--Begin--
            LET g_sql = " SELECT aag07,aagacti FROM aag_file",
                        "  WHERE aag01 = '",g_tag[l_ac].tag05,"'",
                        "    AND aag00 = '",g_tag[l_ac].tag04,"'"
            PREPARE i120_pre_01 FROM g_sql
            DECLARE i120_cur_01 CURSOR FOR i120_pre_01
            OPEN i120_cur_01
            FETCH i120_cur_01 INTO l_aag07,l_aagacti

            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'afa-025'
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tag[l_ac].tag05,g_errno,0)
               NEXT FIELD tag05
            END IF
           #MOD-BC0110---End---
            SELECT aag02 INTO g_tag[l_ac].aag022 FROM aag_file                                                                      
             WHERE aag00 = g_tag[l_ac].tag04 AND aag01 = g_tag[l_ac].tag05
            IF SQLCA.sqlcode THEN            
               CALL cl_err("","aap-021",0)     #FUN-B10052  "1"->"0"
#FUN-B10052 --begin--
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_aag09"              #MOD-BC0110
               LET g_qryparam.form = "q_aag02"              #MOD-BC0110
               LET g_qryparam.default1 = g_tag[l_ac].tag05
               LET g_qryparam.construct = 'N'
               LET g_qryparam.arg1 = g_tag[l_ac].tag04          
               LET g_qryparam.where = " aag01 LIKE '",g_tag[l_ac].tag05 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_tag[l_ac].tag05,g_tag[l_ac].aag022
               DISPLAY g_tag[l_ac].tag05 TO tag05
               DISPLAY g_tag[l_ac].aag022 TO aag022             
#FUN-B10052 --end--               
               NEXT FIELD tag05
            END IF
        END IF
 
      AFTER FIELD tag02
         IF NOT cl_null(g_tag[l_ac].tag02) THEN              
            SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01 = g_tag[l_ac].tag02
            IF l_cnt <> 1 THEN
               CALL cl_err("","anm-009",1)
               NEXT FIELD tag02
            END IF
         END IF
        #CHI-C80044--begin--
         LET g_errno = ' '
         IF NOT cl_null(g_tag[l_ac].tag03) AND NOT cl_null(g_tag[l_ac].tag02) AND p_cmd = 'a' THEN
            CALL i120_chk_acctcnt(g_tag01,g_tag[l_ac].tag02,g_tag[l_ac].tag03) RETURNING g_errno
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tag[l_ac].tag03,g_errno,0)
               NEXT FIELD tag03
            END IF
         END IF
        #CHI-C80044--end--
 
      AFTER FIELD tag03
         IF NOT cl_null(g_tag[l_ac].tag03) THEN
           #MOD-BC0110--Begin--
            LET g_sql = " SELECT aag07,aagacti FROM aag_file",
                        "  WHERE aag01 = '",g_tag[l_ac].tag03,"'",
                        "    AND aag00 = '",g_tag[l_ac].tag02,"'"
            PREPARE i120_pre_02 FROM g_sql
            DECLARE i120_cur_02 CURSOR FOR i120_pre_02
            OPEN i120_cur_02
            FETCH i120_cur_02 INTO l_aag07,l_aagacti

            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'afa-025'
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tag[l_ac].tag03,g_errno,0)
               NEXT FIELD tag03
            END IF
           #MOD-BC0110---End---
            SELECT aag02 INTO g_tag[l_ac].aag021 FROM aag_file
               WHERE aag01 = g_tag[l_ac].tag03 AND aag00 = g_tag[l_ac].tag02
            IF SQLCA.sqlcode THEN
               CALL cl_err("","aap-021",0)   #FUN-B10052 "1"->"0"
#FUN-B10052 --begin--
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_aag09"               #MOD-BC0110
               LET g_qryparam.form = "q_aag02"               #MOD-BC0110
               LET g_qryparam.default1 = g_tag[l_ac].tag03
               LET g_qryparam.construct = 'N'
               LET g_qryparam.arg1 = g_tag[l_ac].tag02                  
               LET g_qryparam.where = " aag01 LIKE '",g_tag[l_ac].tag03 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_tag[l_ac].tag03,g_tag[l_ac].aag021
               DISPLAY g_tag[l_ac].tag03 TO tag03
               DISPLAY g_tag[l_ac].aag021 TO aag021
#FUN-B10052 --end--               
               NEXT FIELD tag03
            END IF
#TQC-AB0372-------add--------str---------------------
            IF NOT cl_null(g_tag[l_ac].tag04) AND NOT cl_null(g_tag[l_ac].tag05) THEN
               IF g_tag[l_ac].tag02 = g_tag[l_ac].tag04 AND g_tag[l_ac].tag03 = g_tag[l_ac].tag05 THEN 
                  NEXT FIELD tag03
               END IF
            END IF  
#TQC-AB0372---------add--------------end------------
         END IF
        #CHI-C80044--begin--
         LET g_errno = ' '
         IF NOT cl_null(g_tag[l_ac].tag03) AND NOT cl_null(g_tag[l_ac].tag05) AND p_cmd = 'a' THEN
            CALL i120_chk_acctcnt(g_tag01,g_tag[l_ac].tag02,g_tag[l_ac].tag03) RETURNING g_errno
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tag[l_ac].tag03,g_errno,0)
               NEXT FIELD tag03
            END IF
         END IF
        #CHI-C80044--end--
 
      BEFORE DELETE                            #是否取消單身
         IF g_tag_t.tag02 IS NOT NULL AND g_tag_t.tag03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM tag_file
               WHERE tag01 = g_tag01 AND
                     tag02 = g_tag_t.tag02 AND
                     tag03 = g_tag_t.tag03
                 AND tag04 = g_tag_t.tag04          #CHI-C20023
                 AND tag05 = g_tag_t.tag05          #CHI-C20023
                 AND tag06 = g_tag06                #CHI-C20023
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tag_file",g_tag_t.tag02,g_tag_t.tag03,SQLCA.sqlcode,"","",1)
               LET l_ac_t = l_ac
               EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete OK"
               CLOSE i120_b_curl
               COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tag[l_ac].* = g_tag_t.*
            CLOSE i120_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
        #CHI-C80044--begin--
         LET g_errno = ' '
         IF NOT cl_null(g_tag[l_ac].tag03) AND NOT cl_null(g_tag[l_ac].tag02) THEN
            IF NOT((g_tag_t.tag03 = g_tag[l_ac].tag03) AND (g_tag_t.tag02 = g_tag[l_ac].tag02)) THEN
               CALL i120_chk_acctcnt(g_tag01,g_tag[l_ac].tag02,g_tag[l_ac].tag03) RETURNING g_errno
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tag[l_ac].tag03,g_errno,0)
                  NEXT FIELD tag03
               END IF
            END IF
         END IF
        #CHI-C80044--end--
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tag[l_ac].tag02,-263,1)
            LET g_tag[l_ac].* = g_tag_t.*
         ELSE
            UPDATE tag_file SET tag02 = g_tag[l_ac].tag02,
                                tag03 = g_tag[l_ac].tag03,
                                tag04 = g_tag[l_ac].tag04,
                                tag05 = g_tag[l_ac].tag05,
                                tagacti = g_tag[l_ac].tagacti        #FUN-BB0017 add tagacti
               WHERE tag01=g_tag01
                 AND tag02=g_tag_t.tag02
                 AND tag03=g_tag_t.tag03
                 AND tag04=g_tag_t.tag04   #FUN-BB0017
                 AND tag05=g_tag_t.tag05   #FUN-BB0017
                 AND tag06=g_tag06         #CHI-C20023
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tag_file",g_tag01,g_tag_t.tag02,SQLCA.sqlcode,"","",1)
               LET g_tag[l_ac].* = g_tag_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_tag[l_ac].* = g_tag_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_tag.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i120_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D40030 Add
         CLOSE i120_b_curl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tag04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_tag[l_ac].tag04
               CALL cl_create_qry() RETURNING g_tag[l_ac].tag04
               DISPLAY g_tag[l_ac].tag04 TO tag04
               NEXT FIELD tag04
            WHEN INFIELD(tag02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_tag[l_ac].tag02
               CALL cl_create_qry() RETURNING g_tag[l_ac].tag02
               DISPLAY g_tag[l_ac].tag02 TO tag02
               NEXT FIELD tag02
            WHEN INFIELD(tag05)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_aag09"               #MOD-BC0110
               LET g_qryparam.form = "q_aag15"               #MOD-BC0110
               LET g_qryparam.default1 = g_tag[l_ac].tag05
               LET g_qryparam.arg1 = g_tag[l_ac].tag04          
               CALL cl_create_qry() RETURNING g_tag[l_ac].tag05,g_tag[l_ac].aag022
               DISPLAY g_tag[l_ac].tag05 TO tag05
               DISPLAY g_tag[l_ac].aag022 TO aag022
               NEXT FIELD tag05
            WHEN INFIELD(tag03)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_aag09"               #MOD-BC0110
               LET g_qryparam.form = "q_aag15"               #MOD-BC0110
               LET g_qryparam.default1 = g_tag[l_ac].tag03
               LET g_qryparam.arg1 = g_tag[l_ac].tag02                  
               CALL cl_create_qry() RETURNING g_tag[l_ac].tag03,g_tag[l_ac].aag021
               DISPLAY g_tag[l_ac].tag03 TO tag03
               DISPLAY g_tag[l_ac].aag021 TO aag021
               NEXT FIELD tag03
 
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tag03) AND l_ac > 1 THEN
            LET g_tag[l_ac].* = g_tag[l_ac-1].*
            DISPLAY g_tag[l_ac].* TO s_tag[l_ac].*
            NEXT FIELD tag05
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END INPUT
 
   CLOSE i120_b_curl
 
END FUNCTION
 
FUNCTION i120_b_fill()              #BODY FILL UP
   DEFINE l_sql STRING   #MOD-B90189 add
#MOD-B90189 -- mark begin --
  #DECLARE tag_curs CURSOR FOR
  #   SELECT tag04,tag05,'',tag02,tag03,''
  #   FROM tag_file WHERE tag01=g_tag01
#MOD-B90189 -- mark end --
#MOD-B90189 -- begin --
   IF cl_null(g_wc) THEN LET g_wc = '1=1' END IF
   LET l_sql = "SELECT tag04,tag05,'',tag02,tag03,'',tagacti",   #FUN-BB0017 add tagacti
               "      ,tag06",                                   #CHI-C20023
               "  FROM tag_file",
               " WHERE tag01 = '",g_tag01,"'",
               "   AND tag06 = '",g_tag06,"'",                   #CHI-C20023
               "   AND ",g_wc CLIPPED
   DECLARE tag_curs CURSOR FROM l_sql
#MOD-B90189 -- end --

   CALL g_tag.clear()
 
   LET g_cnt = 1
   FOREACH tag_curs INTO g_tag[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT aag02 INTO g_tag[g_cnt].aag021 FROM aag_file
         WHERE aag00 = g_tag[g_cnt].tag02
         AND aag01 = g_tag[g_cnt].tag03
      SELECT aag02 INTO g_tag[g_cnt].aag022 FROM aag_file
         WHERE aag00 = g_tag[g_cnt].tag04
         AND aag01 = g_tag[g_cnt].tag05
      LET g_cnt = g_cnt + 1
      #TQC-630106-begin
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630106-end
   END FOREACH
   CALL g_tag.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   LET g_rec_b= g_cnt
 
   DISPLAY g_cnt TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_tag TO s_tag.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
     #MOD-BC0110--Begin Mark--
     #ON ACTION change
     #   LET g_action_choice="change"
     #   EXIT DISPLAY
     #MOD-BC0110---End Mark---
      ON ACTION first
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

     #FUN-BB0015--Begin--
      ON ACTION batch_generate
         LET g_action_choice="batch_generate"
         EXIT DISPLAY
     #FUN-BB0015---End---
     #FUN-BC0068--Begin--
      ON ACTION delete_select
         LET g_action_choice="delete_select"
         EXIT DISPLAY
     #FUN-BC0068---End--- 

      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i120_copy()
DEFINE
   l_newno         LIKE tag_file.tag01,
   l_newtype       LIKE tag_file.tag06        #CHI-C20023
 
   IF g_tag01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   LET INT_FLAG = 0
   CALL cl_set_head_visible("","YES")
 
  #INPUT l_newno FROM tag01                    #CHI-C20023
   INPUT l_newno,l_newtype FROM tag01,tag06    #CHI-C20023
      AFTER FIELD tag01
         IF cl_null(l_newno) THEN
            NEXT FIELD tag01
         ELSE
            DISPLAY l_newno TO tag01
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT
   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      RETURN
   END IF
  #CHI-C20023--Begin--
   IF cl_null(l_newtype) THEN
      LET l_newtype = '1'
   END IF
  #CHI-C20023---End---
   SELECT count(*) INTO g_cnt FROM tag_file WHERE tag01 = l_newno AND tag06 = l_newtype   #CHI-C20023 add tag06
   IF g_cnt > 0 THEN
      CALL cl_err(g_tag01,-239,0)
      RETURN
   END IF
   DROP TABLE x
   SELECT * FROM tag_file WHERE tag01=g_tag01 AND tag06 = g_tag06 INTO TEMP x             #CHI-C20023 add tag06
   UPDATE x SET tag01=l_newno,tag06 = l_newtype                               #資料鍵值   #CHI-C20023 add tag06
   INSERT INTO tag_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tag_file",g_tag01,"",SQLCA.sqlcode,"","",1)
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
   END IF
END FUNCTION
 
FUNCTION i120_check_at(l_buf)  # Check tag04 是否只含有一個 @ 符號
   DEFINE l_i      LIKE type_file.num5,
          l_j      LIKE type_file.num5,
          l_count  LIKE type_file.num5,
          l_buf    LIKE tag_file.tag04
 
   LET l_j = length(l_buf)
   LET g_errno = ""
   LET l_count = 0
 
   FOR l_i=1 TO l_j
      IF l_buf[l_i,l_i]='@' THEN
         LET l_count=l_count + 1
      END IF
   END FOR
 
   IF l_count != 1 THEN
      LET g_errno = "aoo-994"
   END IF
 
END FUNCTION
 
FUNCTION i120_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("tag01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i120_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tag01",FALSE)
   END IF
 
END FUNCTION
 
#No.FUN-750055----------start--------------
FUNCTION i120_change()
DEFINE   l_flag         LIKE type_file.chr1
DEFINE   l_aaa04        LIKE aaa_file.aaa04
 
   IF NOT cl_confirm('aoo-132') THEN RETURN END IF
#TQC-AB0372------mark---------str--------
#  WHILE TRUE            
#    LET g_success = 'Y'
#    BEGIN WORK
#TQC-AB0372------mark---------end--------
     LET g_sql = " SELECT tag04,tag05,'',tag02,tag03,'' ",
                 " FROM tag_file",
                 " WHERE tag01 ='",g_tag01,"' "
     PREPARE i120_pb FROM g_sql                                                                                                       
     DECLARE tag_cs CURSOR FOR i120_pb
     CALL g_tag.clear()
     LET g_cnt = 1
     FOREACH tag_cs INTO g_tag[g_cnt].*
       IF SQLCA.sqlcode THEN  
          CALL cl_err('foreach:',SQLCA.sqlcode,1)  
          EXIT FOREACH  
       END IF
#      SELECT aaa04 INTO l_aaa04 FROM aaa_file WHERE  aaa01 = g_tag[g_cnt].tag02
#       IF g_tag01 <= l_aaa04 THEN 
#          CALL cl_err('','aoo-133',1) 
#          IF NOT cl_confirm('aoo-132') THEN RETURN END IF
#       END IF 
        IF g_tag[g_cnt].tag03 != g_tag[g_cnt].tag05 THEN
           CALL i120_change_field() 
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN  
           CALL cl_err( '', 9035, 0 )   
           EXIT FOREACH 
        END IF 
     END FOREACH
#TQC-AB0372------mark---------str--------------
#    IF g_success = 'Y' THEN                                                                                                 
#       COMMIT WORK                                                                                                          
#       CALL cl_end2(1) RETURNING l_flag                                                                                     
#    ELSE                                                                                                                    
#       ROLLBACK WORK                                                                                                        
#       CALL cl_end2(2) RETURNING l_flag                                                                                     
#    END IF
#    IF l_flag THEN                                                                                                          
#       CONTINUE WHILE                                                                                                       
#    ELSE                                                                                                                    
#       EXIT WHILE                                                                                                           
#    END IF
#  END WHILE
#TQC-AB0372------mark---------end--------------
END FUNCTION
 
FUNCTION i120_change_field() 
 
#  UPDATE aab_file set aab01 = g_tag[g_cnt].tag05,
#                      aab00 = g_tag[g_cnt].tag04
#                WHERE aab01 = g_tag[g_cnt].tag03
#                  AND aab00 = g_tag[g_cnt].tag02
 
   UPDATE aac_file set aac04 = g_tag[g_cnt].tag05 WHERE aac04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aac_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
#  UPDATE aak_file set aak01 = g_tag[g_cnt].tag05,
#                      aak00 = g_tag[g_cnt].tag04
#                WHERE aak01 = g_tag[g_cnt].tag03
#                  AND aak00 = g_tag[g_cnt].tag02
 
#  UPDATE aaz_file set aaz31 = g_tag[g_cnt].tag05 WHERE aaz31 = g_tag[g_cnt].tag03  #FUN-BC0027
   UPDATE aaa_file set aaa14 = g_tag[g_cnt].tag05 WHERE aaa14 = g_tag[g_cnt].tag03  #FUN-BC0027
                                                    AND aaa01 = g_tag[g_cnt].tag02  #FUN-BC0027
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aaa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1) #FUN-BC0027 aak_file->aaa_file
      LET g_success = 'N'
      RETURN
   END IF

#  UPDATE aaz_file set aaz32 = g_tag[g_cnt].tag05 WHERE aaz32 = g_tag[g_cnt].tag03 #FUN-BC0027
   UPDATE aaa_file set aaa15 = g_tag[g_cnt].tag05 WHERE aaa15 = g_tag[g_cnt].tag03 #FUN-BC0027
                                                    AND aaa01 = g_tag[g_cnt].tag02  #FUN-BC0027
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aaa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1) #FUN-BC0027 aaz_file->aaa_file
      LET g_success = 'N'
      RETURN
   END IF   
 
#  UPDATE aaz_file set aaz33 = g_tag[g_cnt].tag05 WHERE aaz33 = g_tag[g_cnt].tag03  #FUN-BC0027
   UPDATE aaa_file set aaa16 = g_tag[g_cnt].tag05 WHERE aaa16 = g_tag[g_cnt].tag03  #FUN-BC0027
                                                    AND aaa01 = g_tag[g_cnt].tag02  #FUN-BC0027
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aaa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1) #FUN-BC0027 aaz_file->aaa_file
      LET g_success = 'N'
      RETURN
   END IF   
 
   #UPDATE aaz_file set aaz86 = g_tag[g_cnt].tag05 WHERE aaz86 = g_tag[g_cnt].tag03  #FUN-B50001
   UPDATE aaw_file set aaw02 = g_tag[g_cnt].tag05 WHERE aaw02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aaz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   #UPDATE aaz_file set aaz87 = g_tag[g_cnt].tag05 WHERE aaz87 = g_tag[g_cnt].tag03   #FUN-B50001
   UPDATE aaw_file set aaw04= g_tag[g_cnt].tag05 WHERE aaw04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aaz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
   
   UPDATE aaz_file set aaz91 = g_tag[g_cnt].tag05 WHERE aaz91 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aaz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aaz_file set aaz92 = g_tag[g_cnt].tag05 WHERE aaz92 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aaz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE abj_file set abj04 = g_tag[g_cnt].tag05 WHERE abj04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","abj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE abj_file set abj06 = g_tag[g_cnt].tag05 WHERE abj06 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","abj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE adv_file set adv13 = g_tag[g_cnt].tag05 WHERE adv13 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","adv_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
#  UPDATE afb_file set afb02 = g_tag[g_cnt].tag05,
#                      afb00 = g_tag[g_cnt].tag04
#                WHERE afb02 = g_tag[g_cnt].tag03
#                  AND afb00 = g_tag[g_cnt].tag02
 
#  UPDATE afc_file set afc02 = g_tag[g_cnt].tag05,
#                      afc00 = g_tag[g_cnt].tag04
#                WHERE afc02 = g_tag[g_cnt].tag03
#                  AND afc00 = g_tag[g_cnt].tag02
 
#  UPDATE ahb_file set ahb03 = g_tag[g_cnt].tag05,
#                      afb00 = g_tag[g_cnt].tag04
#                WHERE ahb03 = g_tag[g_cnt].tag03
#                  AND afb00 = g_tag[g_cnt].tag02
 
#  UPDATE ahb_file set ahb16 = g_tag[g_cnt].tag05,
#                      afb00 = g_tag[g_cnt].tag04
#                WHERE ahb16 = g_tag[g_cnt].tag03
#                  AND afb00 = g_tag[g_cnt].tag02
 
#  UPDATE ahd_file set ahd03 = g_tag[g_cnt].tag05,
#                      ahd00 = g_tag[g_cnt].tag04
#                WHERE ahd03 = g_tag[g_cnt].tag03
#                  AND ahd00 = g_tag[g_cnt].tag02
 
#  UPDATE ahf_file set ahf01 = g_tag[g_cnt].tag05,
#                      ahf00 = g_tag[g_cnt].tag04
#                WHERE ahf01 = g_tag[g_cnt].tag03
#                  AND ahf00 = g_tag[g_cnt].tag02
 
#  UPDATE ahh_file set ahh01 = g_tag[g_cnt].tag05,
#                      ahh00 = g_tag[g_cnt].tag04
#                WHERE ahh01 = g_tag[g_cnt].tag03
#                  AND ahh00 = g_tag[g_cnt].tag02
 
   UPDATE api_file set api04 = g_tag[g_cnt].tag05 WHERE api04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","api_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE api_file set api041= g_tag[g_cnt].tag05 WHERE api041= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","api_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
#  UPDATE aps_file set aps031= g_tag[g_cnt].tag05 WHERE aps031= g_tag[g_cnt].tag03
 
#  UPDATE aps_file set aps041= g_tag[g_cnt].tag05 WHERE aps041= g_tag[g_cnt].tag03
 
   UPDATE aps_file set aps11 = g_tag[g_cnt].tag05 WHERE aps11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps111= g_tag[g_cnt].tag05 WHERE aps111= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps12 = g_tag[g_cnt].tag05 WHERE aps12 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps121= g_tag[g_cnt].tag05 WHERE aps121= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps13 = g_tag[g_cnt].tag05 WHERE aps13 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps131= g_tag[g_cnt].tag05 WHERE aps131= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps14 = g_tag[g_cnt].tag05 WHERE aps14 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps141= g_tag[g_cnt].tag05 WHERE aps141= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps21 = g_tag[g_cnt].tag05 WHERE aps21 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps211= g_tag[g_cnt].tag05 WHERE aps211= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps22 = g_tag[g_cnt].tag05 WHERE aps22 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps221= g_tag[g_cnt].tag05 WHERE aps221= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps23 = g_tag[g_cnt].tag05 WHERE aps23 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps231= g_tag[g_cnt].tag05 WHERE aps231= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps232= g_tag[g_cnt].tag05 WHERE aps232= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps233= g_tag[g_cnt].tag05 WHERE aps233= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps234= g_tag[g_cnt].tag05 WHERE aps234= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps235= g_tag[g_cnt].tag05 WHERE aps235= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps236= g_tag[g_cnt].tag05 WHERE aps236= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps237= g_tag[g_cnt].tag05 WHERE aps237= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps238= g_tag[g_cnt].tag05 WHERE aps238= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps239= g_tag[g_cnt].tag05 WHERE aps239= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps24 = g_tag[g_cnt].tag05 WHERE aps24 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps241= g_tag[g_cnt].tag05 WHERE aps241= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps25 = g_tag[g_cnt].tag05 WHERE aps25 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps251= g_tag[g_cnt].tag05 WHERE aps251= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps40 = g_tag[g_cnt].tag05 WHERE aps40 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps401= g_tag[g_cnt].tag05 WHERE aps401= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps41 = g_tag[g_cnt].tag05 WHERE aps41 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps411= g_tag[g_cnt].tag05 WHERE aps411= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps42 = g_tag[g_cnt].tag05 WHERE aps42 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps421= g_tag[g_cnt].tag05 WHERE aps421= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps43 = g_tag[g_cnt].tag05 WHERE aps43 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps431= g_tag[g_cnt].tag05 WHERE aps431= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps44 = g_tag[g_cnt].tag05 WHERE aps44 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps441= g_tag[g_cnt].tag05 WHERE aps441= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps45 = g_tag[g_cnt].tag05 WHERE aps45 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps451= g_tag[g_cnt].tag05 WHERE aps451= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps46 = g_tag[g_cnt].tag05 WHERE aps46 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps461= g_tag[g_cnt].tag05 WHERE aps461= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps47 = g_tag[g_cnt].tag05 WHERE aps47 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps471= g_tag[g_cnt].tag05 WHERE aps471= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps51 = g_tag[g_cnt].tag05 WHERE aps51 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps511= g_tag[g_cnt].tag05 WHERE aps511= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps54 = g_tag[g_cnt].tag05 WHERE aps54 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps541= g_tag[g_cnt].tag05 WHERE aps541= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps55 = g_tag[g_cnt].tag05 WHERE aps55 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps551= g_tag[g_cnt].tag05 WHERE aps551= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps56 = g_tag[g_cnt].tag05 WHERE aps56 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps561= g_tag[g_cnt].tag05 WHERE aps561= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps57 = g_tag[g_cnt].tag05 WHERE aps57 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps571= g_tag[g_cnt].tag05 WHERE aps571= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps58 = g_tag[g_cnt].tag05 WHERE aps58 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE aps_file set aps581= g_tag[g_cnt].tag05 WHERE aps581= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","aps_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE apt_file set apt03 = g_tag[g_cnt].tag05 WHERE apt03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","apt_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE apt_file set apt031= g_tag[g_cnt].tag05 WHERE apt031= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","apt_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE apt_file set apt04 = g_tag[g_cnt].tag05 WHERE apt04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","apt_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE apt_file set apt041= g_tag[g_cnt].tag05 WHERE apt041= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","apt_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE apt_file set apt05 = g_tag[g_cnt].tag05 WHERE apt05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","apt_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE apw_file set apw03 = g_tag[g_cnt].tag05 WHERE apw03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","apw_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE apw_file set apw031= g_tag[g_cnt].tag05 WHERE apw031= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","apw_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
#TQC-810058--mark--
#  UPDATE apz_file set apz52 = g_tag[g_cnt].tag05 WHERE apz52 = g_tag[g_cnt].tag03
#  IF SQLCA.sqlcode THEN
#     CALL cl_err3("upd","apz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
#     LET g_success = 'N'
#     RETURN
#  END IF
#TQC-810058--mark--
 
   UPDATE awa_file set awa01 = g_tag[g_cnt].tag05 WHERE awa01 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","awa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE awa_file set awa02 = g_tag[g_cnt].tag05 WHERE awa02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","awa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
#  UPDATE axe_file set axe04 = g_tag[g_cnt].tag05,
#                      axe00 = g_tag[g_cnt].tag04
#                WHERE axe04 = g_tag[g_cnt].tag03
#                  AND axe00 = g_tag[g_cnt].tag02
 
#  UPDATE axe_file set axe06 = g_tag[g_cnt].tag05,
#                      axe00 = g_tag[g_cnt].tag04
#                WHERE axe06 = g_tag[g_cnt].tag03
#                  AND axe00 = g_tag[g_cnt].tag02
 
   UPDATE axf_file set axf01 = g_tag[g_cnt].tag05 WHERE axf01 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","axf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE axf_file set axf02 = g_tag[g_cnt].tag05 WHERE axf02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","axf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE axf_file set axf04 = g_tag[g_cnt].tag05 WHERE axf04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","axf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE axp_file set axp09 = g_tag[g_cnt].tag05 WHERE axp09 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","axp_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE azf_file set azf05 = g_tag[g_cnt].tag05 WHERE azf05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","azf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE azf_file set azf051= g_tag[g_cnt].tag05 WHERE azf051= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","azf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE azf_file set azf07 = g_tag[g_cnt].tag05 WHERE azf07 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","azf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE azf_file set azf14 = g_tag[g_cnt].tag05 WHERE azf14 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","azf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE azi_file set azi08 = g_tag[g_cnt].tag05 WHERE azi08 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","azi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE azi_file set azi09 = g_tag[g_cnt].tag05 WHERE azi09 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","azi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bgq_file set bgq04 = g_tag[g_cnt].tag05 WHERE bgq04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bgq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bgu_file set bgu032= g_tag[g_cnt].tag05 WHERE bgu032= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bgu_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bgw_file set bgw11 = g_tag[g_cnt].tag05 WHERE bgw11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bgw_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bgx_file set bgx04 = g_tag[g_cnt].tag05 WHERE bgx04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bgx_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bgz_file set bgz10 = g_tag[g_cnt].tag05 WHERE bgz10 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bgz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bgz_file set bgz11 = g_tag[g_cnt].tag05 WHERE bgz11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bgz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bgz_file set bgz12 = g_tag[g_cnt].tag05 WHERE bgz12 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bgz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bgz_file set bgz13 = g_tag[g_cnt].tag05 WHERE bgz13 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bgz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bhc_file set bhc04 = g_tag[g_cnt].tag05 WHERE bhc04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bhc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bhe_file set bhe02 = g_tag[g_cnt].tag05 WHERE bhe02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bhe_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bhe_file set bhe03 = g_tag[g_cnt].tag05 WHERE bhe03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bhe_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bhe_file set bhe04 = g_tag[g_cnt].tag05 WHERE bhe04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bhe_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE bhe_file set bhe06 = g_tag[g_cnt].tag05 WHERE bhe06 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","bhe_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE caa_file set caa05 = g_tag[g_cnt].tag05 WHERE caa05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","caa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cad_file set cad06 = g_tag[g_cnt].tag05 WHERE cad06 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cad_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cax_file set cax04 = g_tag[g_cnt].tag05 WHERE cax04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cax_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cay_file set cay06 = g_tag[g_cnt].tag05 WHERE cay06 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cay_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cay_file set cay10 = g_tag[g_cnt].tag05 WHERE cay10 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cay_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE caz_file set caz04 = g_tag[g_cnt].tag05 WHERE caz04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","caz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz14 = g_tag[g_cnt].tag05 WHERE ccz14 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz141= g_tag[g_cnt].tag05 WHERE ccz141= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz15 = g_tag[g_cnt].tag05 WHERE ccz15 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz151= g_tag[g_cnt].tag05 WHERE ccz151= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz16 = g_tag[g_cnt].tag05 WHERE ccz16 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz161= g_tag[g_cnt].tag05 WHERE ccz161= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz17 = g_tag[g_cnt].tag05 WHERE ccz17 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz171= g_tag[g_cnt].tag05 WHERE ccz171= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz18 = g_tag[g_cnt].tag05 WHERE ccz18 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz181= g_tag[g_cnt].tag05 WHERE ccz181= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz19 = g_tag[g_cnt].tag05 WHERE ccz19 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz191= g_tag[g_cnt].tag05 WHERE ccz191= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz20 = g_tag[g_cnt].tag05 WHERE ccz20 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz201= g_tag[g_cnt].tag05 WHERE ccz201= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz21 = g_tag[g_cnt].tag05 WHERE ccz21 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz211= g_tag[g_cnt].tag05 WHERE ccz211= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz22 = g_tag[g_cnt].tag05 WHERE ccz22 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz221= g_tag[g_cnt].tag05 WHERE ccz221= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz24 = g_tag[g_cnt].tag05 WHERE ccz24 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz241= g_tag[g_cnt].tag05 WHERE ccz241= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz25 = g_tag[g_cnt].tag05 WHERE ccz25 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ccz_file set ccz251= g_tag[g_cnt].tag05 WHERE ccz251= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","czz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cmi_file set cmi05 = g_tag[g_cnt].tag05 WHERE cmi05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cmi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cmi_file set cmi051= g_tag[g_cnt].tag05 WHERE cmi051= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cmi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cmi_file set cmi051= g_tag[g_cnt].tag05 WHERE cmi051= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cmi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   #-----TQC-B90211---------
   #UPDATE cpa_file set cpa108= g_tag[g_cnt].tag05 WHERE cpa108= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa109= g_tag[g_cnt].tag05 WHERE cpa109= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa111= g_tag[g_cnt].tag05 WHERE cpa111= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa142= g_tag[g_cnt].tag05 WHERE cpa142= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa143= g_tag[g_cnt].tag05 WHERE cpa143= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa144= g_tag[g_cnt].tag05 WHERE cpa144= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa145= g_tag[g_cnt].tag05 WHERE cpa145= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa153= g_tag[g_cnt].tag05 WHERE cpa153= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa154= g_tag[g_cnt].tag05 WHERE cpa154= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa155= g_tag[g_cnt].tag05 WHERE cpa155= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa156= g_tag[g_cnt].tag05 WHERE cpa156= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa157= g_tag[g_cnt].tag05 WHERE cpa157= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa158= g_tag[g_cnt].tag05 WHERE cpa158= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa159= g_tag[g_cnt].tag05 WHERE cpa159= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa83 = g_tag[g_cnt].tag05 WHERE cpa83 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa831= g_tag[g_cnt].tag05 WHERE cpa831= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa84 = g_tag[g_cnt].tag05 WHERE cpa84 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa841= g_tag[g_cnt].tag05 WHERE cpa841= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa85 = g_tag[g_cnt].tag05 WHERE cpa85 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa851= g_tag[g_cnt].tag05 WHERE cpa851= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa86 = g_tag[g_cnt].tag05 WHERE cpa86 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa861= g_tag[g_cnt].tag05 WHERE cpa861= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa87 = g_tag[g_cnt].tag05 WHERE cpa87 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa871= g_tag[g_cnt].tag05 WHERE cpa871= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa88 = g_tag[g_cnt].tag05 WHERE cpa88 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa881= g_tag[g_cnt].tag05 WHERE cpa881= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa89 = g_tag[g_cnt].tag05 WHERE cpa89 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa891= g_tag[g_cnt].tag05 WHERE cpa891= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa90 = g_tag[g_cnt].tag05 WHERE cpa90 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa901= g_tag[g_cnt].tag05 WHERE cpa901= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa91 = g_tag[g_cnt].tag05 WHERE cpa91 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa911= g_tag[g_cnt].tag05 WHERE cpa911= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa92 = g_tag[g_cnt].tag05 WHERE cpa92 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa921= g_tag[g_cnt].tag05 WHERE cpa921= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa93 = g_tag[g_cnt].tag05 WHERE cpa93 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa931= g_tag[g_cnt].tag05 WHERE cpa931= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa94 = g_tag[g_cnt].tag05 WHERE cpa94 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa941= g_tag[g_cnt].tag05 WHERE cpa941= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa95 = g_tag[g_cnt].tag05 WHERE cpa95 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa951= g_tag[g_cnt].tag05 WHERE cpa951= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa96 = g_tag[g_cnt].tag05 WHERE cpa96 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa961= g_tag[g_cnt].tag05 WHERE cpa961= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa97 = g_tag[g_cnt].tag05 WHERE cpa97 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa971= g_tag[g_cnt].tag05 WHERE cpa971= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa98 = g_tag[g_cnt].tag05 WHERE cpa98 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa981= g_tag[g_cnt].tag05 WHERE cpa981= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa99 = g_tag[g_cnt].tag05 WHERE cpa99 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cpa_file set cpa991= g_tag[g_cnt].tag05 WHERE cpa991= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cpa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cph_file set cph19 = g_tag[g_cnt].tag05 WHERE cph19 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cph_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE cph_file set cph191= g_tag[g_cnt].tag05 WHERE cph191= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","cph_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #-----END TQC-B90211----- 
 
#  UPDATE cuo_file set cuo03 = g_tag[g_cnt].tag05 WHERE cuo03 = g_tag[g_cnt].tag03
 
   UPDATE cxg_file set cxg05 = g_tag[g_cnt].tag05 WHERE cxg05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cxg_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cxg_file set cxg051= g_tag[g_cnt].tag05 WHERE cxg051= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cxg_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cxi_file set cxi04 = g_tag[g_cnt].tag05 WHERE cxi04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cxi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE cxi_file set cxi041= g_tag[g_cnt].tag05 WHERE cxi041= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","cxi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   #-----TQC-B90211---------
   #UPDATE czy_file set czy07 = g_tag[g_cnt].tag05 WHERE czy07 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","czy_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #
   #UPDATE czy_file set czy071= g_tag[g_cnt].tag05 WHERE czy071= g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","czy_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #-----END TQC-B90211-----
 
   UPDATE ecc_file set ecc02 = g_tag[g_cnt].tag05 WHERE ecc02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ecc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ecc_file set ecc03 = g_tag[g_cnt].tag05 WHERE ecc03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ecc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ecc_file set ecc04 = g_tag[g_cnt].tag05 WHERE ecc04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ecc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ecc_file set ecc05 = g_tag[g_cnt].tag05 WHERE ecc05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ecc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
#TQC-810058--mark--
#  UPDATE faa_file set faa20 = g_tag[g_cnt].tag05 WHERE faa20 = g_tag[g_cnt].tag03
#  IF SQLCA.sqlcode THEN
#     CALL cl_err3("upd","faa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
#     LET g_success = 'N'
#     RETURN
#  END IF
#TQC-810058--mark--
 
   UPDATE fab_file set fab11 = g_tag[g_cnt].tag05 WHERE fab11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fab_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fab_file set fab111= g_tag[g_cnt].tag05 WHERE fab111= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fab_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fab_file set fab12 = g_tag[g_cnt].tag05 WHERE fab12 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fab_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fab_file set fab121= g_tag[g_cnt].tag05 WHERE fab121= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fab_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fab_file set fab13 = g_tag[g_cnt].tag05 WHERE fab13 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fab_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fab_file set fab131= g_tag[g_cnt].tag05 WHERE fab131= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fab_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fab_file set fab24 = g_tag[g_cnt].tag05 WHERE fab24 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fab_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fab_file set fab241= g_tag[g_cnt].tag05 WHERE fab241= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fab_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fad_file set fad03 = g_tag[g_cnt].tag05 WHERE fad03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fad_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fad_file set fad031= g_tag[g_cnt].tag05 WHERE fad031= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fad_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fae_file set fae03 = g_tag[g_cnt].tag05 WHERE fae03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fae_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fae_file set fae07 = g_tag[g_cnt].tag05 WHERE fae07 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fae_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fae_file set fae071= g_tag[g_cnt].tag05 WHERE fae071= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fae_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fae_file set fae09 = g_tag[g_cnt].tag05 WHERE fae09 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fae_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fah_file set fah11 = g_tag[g_cnt].tag05 WHERE fah11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fah_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE faj_file set faj53 = g_tag[g_cnt].tag05 WHERE faj53 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","faj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE faj_file set faj531= g_tag[g_cnt].tag05 WHERE faj531= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","faj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE faj_file set faj54 = g_tag[g_cnt].tag05 WHERE faj54 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","faj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE faj_file set faj541= g_tag[g_cnt].tag05 WHERE faj541= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","faj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE faj_file set faj55 = g_tag[g_cnt].tag05 WHERE faj55 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","faj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE faj_file set faj551= g_tag[g_cnt].tag05 WHERE faj551= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","faj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fak_file set fak53 = g_tag[g_cnt].tag05 WHERE fak53 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fak_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fak_file set fak531= g_tag[g_cnt].tag05 WHERE fak531= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fak_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fak_file set fak54 = g_tag[g_cnt].tag05 WHERE fak54 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fak_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fak_file set fak541= g_tag[g_cnt].tag05 WHERE fak541= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fak_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fak_file set fak55 = g_tag[g_cnt].tag05 WHERE fak55 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fak_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fak_file set fak551= g_tag[g_cnt].tag05 WHERE fak551= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fak_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fan_file set fan11 = g_tag[g_cnt].tag05 WHERE fan11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fan_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fan_file set fan111= g_tag[g_cnt].tag05 WHERE fan111= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fan_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fan_file set fan12 = g_tag[g_cnt].tag05 WHERE fan12 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fan_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fan_file set fan121= g_tag[g_cnt].tag05 WHERE fan121= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fan_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fao_file set fao11 = g_tag[g_cnt].tag05 WHERE fao11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fao_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fao_file set fao111= g_tag[g_cnt].tag05 WHERE fao111= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fao_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fao_file set fao12 = g_tag[g_cnt].tag05 WHERE fao12 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fao_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fao_file set fao121= g_tag[g_cnt].tag05 WHERE fao121= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fao_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbi_file set fbi02 = g_tag[g_cnt].tag05 WHERE fbi02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbi_file set fbi021= g_tag[g_cnt].tag05 WHERE fbi021= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbi_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz05 = g_tag[g_cnt].tag05 WHERE fbz05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz051= g_tag[g_cnt].tag05 WHERE fbz051= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz06 = g_tag[g_cnt].tag05 WHERE fbz06 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz061= g_tag[g_cnt].tag05 WHERE fbz061= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz07 = g_tag[g_cnt].tag05 WHERE fbz07 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz071= g_tag[g_cnt].tag05 WHERE fbz071= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz08 = g_tag[g_cnt].tag05 WHERE fbz08 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz081= g_tag[g_cnt].tag05 WHERE fbz081= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz09 = g_tag[g_cnt].tag05 WHERE fbz09 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz091= g_tag[g_cnt].tag05 WHERE fbz091= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz10 = g_tag[g_cnt].tag05 WHERE fbz10 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz101= g_tag[g_cnt].tag05 WHERE fbz101= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz11 = g_tag[g_cnt].tag05 WHERE fbz11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz111= g_tag[g_cnt].tag05 WHERE fbz111= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz13 = g_tag[g_cnt].tag05 WHERE fbz13 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz131= g_tag[g_cnt].tag05 WHERE fbz131= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz14 = g_tag[g_cnt].tag05 WHERE fbz14 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz141= g_tag[g_cnt].tag05 WHERE fbz141= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz15 = g_tag[g_cnt].tag05 WHERE fbz15 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz151= g_tag[g_cnt].tag05 WHERE fbz151= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz17 = g_tag[g_cnt].tag05 WHERE fbz17 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz171= g_tag[g_cnt].tag05 WHERE fbz171= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz18 = g_tag[g_cnt].tag05 WHERE fbz18 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fbz_file set fbz181= g_tag[g_cnt].tag05 WHERE fbz181= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fbz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fcx_file set fcx09 = g_tag[g_cnt].tag05 WHERE fcx09 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fcx_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fcx_file set fcx091= g_tag[g_cnt].tag05 WHERE fcx091= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fcx_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fcx_file set fcx10 = g_tag[g_cnt].tag05 WHERE fcx10 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fcx_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fcx_file set fcx101= g_tag[g_cnt].tag05 WHERE fcx101= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fcx_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fdd_file set fdd08 = g_tag[g_cnt].tag05 WHERE fdd09 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fdd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fdd_file set fdd081= g_tag[g_cnt].tag05 WHERE fdd091= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fdd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fdd_file set fdd09 = g_tag[g_cnt].tag05 WHERE fdd09 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fdd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE fdd_file set fdd091= g_tag[g_cnt].tag05 WHERE fdd091= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","fdd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gec_file set gec03 = g_tag[g_cnt].tag05 WHERE gec03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gec_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gec_file set gec031= g_tag[g_cnt].tag05 WHERE gec031= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gec_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
#  UPDATE gil_file set gil02 = g_tag[g_cnt].tag05,
#                      gil00 = g_tag[g_cnt].tag04
#                WHERE gil02 = g_tag[g_cnt].tag03
#                  AND gil00 = g_tag[g_cnt].tag02
 
#  UPDATE gis_file set gis02 = g_tag[g_cnt].tag05,
#                      gis00 = g_tag[g_cnt].tag04
#                WHERE gis02 = g_tag[g_cnt].tag03
#                  AND gis00 = g_tag[g_cnt].tag02
 
#  UPDATE git_file set git02 = g_tag[g_cnt].tag05,
#                      git00 = g_tag[g_cnt].tag04
#                WHERE git02 = g_tag[g_cnt].tag03
#                  AND git00 = g_tag[g_cnt].tag02
 
   UPDATE giu_file set giu01 = g_tag[g_cnt].tag05 WHERE giu01 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","giu_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE giu_file set giu02 = g_tag[g_cnt].tag05 WHERE giu02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","giu_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE giu_file set giu08 = g_tag[g_cnt].tag05 WHERE giu08 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","giu_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gsa_file set gsa04 = g_tag[g_cnt].tag05 WHERE gsa04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gsa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gsa_file set gsa041= g_tag[g_cnt].tag05 WHERE gsa041= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gsa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gsa_file set gsa05 = g_tag[g_cnt].tag05 WHERE gsa05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gsa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gsa_file set gsa051= g_tag[g_cnt].tag05 WHERE gsa051= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gsa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gsa_file set gsa06 = g_tag[g_cnt].tag05 WHERE gsa06 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gsa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gsa_file set gsa061= g_tag[g_cnt].tag05 WHERE gsa061= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gsa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gsf_file set gsf04 = g_tag[g_cnt].tag05 WHERE gsf04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gsf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gsf_file set gsf041= g_tag[g_cnt].tag05 WHERE gsf041= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gsf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gxd_file set gxd01 = g_tag[g_cnt].tag05 WHERE gxd01 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gxd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gxd_file set gxd011= g_tag[g_cnt].tag05 WHERE gxd011= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gxd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gxd_file set gxd02 = g_tag[g_cnt].tag05 WHERE gxd02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gxd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gxd_file set gxd021= g_tag[g_cnt].tag05 WHERE gxd021= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gxd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gxd_file set gxd031= g_tag[g_cnt].tag05 WHERE gxd031= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gxd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gxd_file set gxd041= g_tag[g_cnt].tag05 WHERE gxd041= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gxd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE gxf_file set gxf31 = g_tag[g_cnt].tag05 WHERE gxf31 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","gxf_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
  #UPDATE ima_file set ima132= g_tag[g_cnt].tag05 WHERE ima132= g_tag[g_cnt].tag03                    #FUN-C30315 mark
   UPDATE ima_file set ima132= g_tag[g_cnt].tag05,imadate = g_today WHERE ima132= g_tag[g_cnt].tag03  #FUN-C30315 add
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ima_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
  #UPDATE ima_file set ima1321= g_tag[g_cnt].tag05 WHERE ima1321= g_tag[g_cnt].tag03                   #FUN-C30315 mark
   UPDATE ima_file set ima1321= g_tag[g_cnt].tag05,imadate = g_today WHERE ima1321= g_tag[g_cnt].tag03 #FUN-C30315 add
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ima_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
  #UPDATE ima_file set ima39 = g_tag[g_cnt].tag05 WHERE ima39 = g_tag[g_cnt].tag03                    #FUN-C30315 mark
   UPDATE ima_file set ima39 = g_tag[g_cnt].tag05,imadate = g_today WHERE ima39 = g_tag[g_cnt].tag03  #FUN-C30315 add
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ima_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
  #UPDATE ima_file set ima391= g_tag[g_cnt].tag05 WHERE ima391= g_tag[g_cnt].tag03                     #FUN-C30315 mark
   UPDATE ima_file set ima391= g_tag[g_cnt].tag05,imadate = g_today  WHERE ima391= g_tag[g_cnt].tag03  #FUN-C30315 add
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ima_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE imaa_file set imaa132= g_tag[g_cnt].tag05 WHERE imaa132= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imaa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE imaa_file set imaa1321= g_tag[g_cnt].tag05 WHERE imaa1321= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imaa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE imaa_file set imaa39 = g_tag[g_cnt].tag05 WHERE imaa39 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imaa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE imaa_file set imaa391= g_tag[g_cnt].tag05 WHERE imaa391= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imaa_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE imd_file set imd08 = g_tag[g_cnt].tag05 WHERE imd08 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE imd_file set imd081= g_tag[g_cnt].tag05 WHERE imd081= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ime_file set ime09 = g_tag[g_cnt].tag05 WHERE ime09 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ime_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ime_file set ime091= g_tag[g_cnt].tag05 WHERE ime091= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ime_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE img_file set img26 = g_tag[g_cnt].tag05 WHERE img26 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","img_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE imgg_file set imgg26= g_tag[g_cnt].tag05 WHERE imgg26= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imgg_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE maj_file set maj21 = g_tag[g_cnt].tag05 WHERE maj21 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","maj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE maj_file set maj22 = g_tag[g_cnt].tag05 WHERE maj22 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","maj_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nma_file set nma05 = g_tag[g_cnt].tag05 WHERE nma05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nma_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nma_file set nma051= g_tag[g_cnt].tag05 WHERE nma051= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nma_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nma_file set nma16 = g_tag[g_cnt].tag05 WHERE nma16 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nma_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nma_file set nma17 = g_tag[g_cnt].tag05 WHERE nma17 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nma_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmc_file set nmc04 = g_tag[g_cnt].tag05 WHERE nmc04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmc_file set nmc041= g_tag[g_cnt].tag05 WHERE nmc041= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmd_file set nmd23 = g_tag[g_cnt].tag05 WHERE nmd23 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmd_file set nmd231= g_tag[g_cnt].tag05 WHERE nmd231= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmd_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmh_file set nmh26 = g_tag[g_cnt].tag05 WHERE nmh26 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmh_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmh_file set nmh261= g_tag[g_cnt].tag05 WHERE nmh261= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmh_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmh_file set nmh27 = g_tag[g_cnt].tag05 WHERE nmh27 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmh_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmh_file set nmh271= g_tag[g_cnt].tag05 WHERE nmh271= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmh_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq01 = g_tag[g_cnt].tag05 WHERE nmq01 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq011= g_tag[g_cnt].tag05 WHERE nmq011= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq02 = g_tag[g_cnt].tag05 WHERE nmq02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq021= g_tag[g_cnt].tag05 WHERE nmq021= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq10 = g_tag[g_cnt].tag05 WHERE nmq10 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq101= g_tag[g_cnt].tag05 WHERE nmq101= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq11 = g_tag[g_cnt].tag05 WHERE nmq11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq111= g_tag[g_cnt].tag05 WHERE nmq111= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq21 = g_tag[g_cnt].tag05 WHERE nmq21 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq211= g_tag[g_cnt].tag05 WHERE nmq211= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq22 = g_tag[g_cnt].tag05 WHERE nmq22 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq221= g_tag[g_cnt].tag05 WHERE nmq221= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq23 = g_tag[g_cnt].tag05 WHERE nmq23 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq231= g_tag[g_cnt].tag05 WHERE nmq231= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq24 = g_tag[g_cnt].tag05 WHERE nmq24 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmq_file set nmq241= g_tag[g_cnt].tag05 WHERE nmq241= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmq_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms12 = g_tag[g_cnt].tag05 WHERE nms12 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms121= g_tag[g_cnt].tag05 WHERE nms121= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms13 = g_tag[g_cnt].tag05 WHERE nms13 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms131= g_tag[g_cnt].tag05 WHERE nms131= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms14 = g_tag[g_cnt].tag05 WHERE nms14 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms141= g_tag[g_cnt].tag05 WHERE nms141= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms15 = g_tag[g_cnt].tag05 WHERE nms15 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms151= g_tag[g_cnt].tag05 WHERE nms151= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms16 = g_tag[g_cnt].tag05 WHERE nms16 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms161= g_tag[g_cnt].tag05 WHERE nms161= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms17 = g_tag[g_cnt].tag05 WHERE nms17 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms171= g_tag[g_cnt].tag05 WHERE nms171= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms18 = g_tag[g_cnt].tag05 WHERE nms18 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms181= g_tag[g_cnt].tag05 WHERE nms181= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms21 = g_tag[g_cnt].tag05 WHERE nms21 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms211= g_tag[g_cnt].tag05 WHERE nms211= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms22 = g_tag[g_cnt].tag05 WHERE nms22 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms221= g_tag[g_cnt].tag05 WHERE nms221= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms23 = g_tag[g_cnt].tag05 WHERE nms23 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms231= g_tag[g_cnt].tag05 WHERE nms231= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms24 = g_tag[g_cnt].tag05 WHERE nms24 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms241= g_tag[g_cnt].tag05 WHERE nms241= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms25 = g_tag[g_cnt].tag05 WHERE nms25 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms251= g_tag[g_cnt].tag05 WHERE nms251= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms26 = g_tag[g_cnt].tag05 WHERE nms26 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms261= g_tag[g_cnt].tag05 WHERE nms261= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms27 = g_tag[g_cnt].tag05 WHERE nms27 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms271= g_tag[g_cnt].tag05 WHERE nms271= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms28 = g_tag[g_cnt].tag05 WHERE nms28 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nms_file set nms281= g_tag[g_cnt].tag05 WHERE nms281= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nms_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmz_file set nmz58 = g_tag[g_cnt].tag05 WHERE nmz58 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE nmz_file set nmz581= g_tag[g_cnt].tag05 WHERE nmz581= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmz_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE oba_file set oba11 = g_tag[g_cnt].tag05 WHERE oba11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","oba_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE oca_file set oca03 = g_tag[g_cnt].tag05 WHERE oca03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","oca_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE oca_file set oca04 = g_tag[g_cnt].tag05 WHERE oca04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","oca_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
#  UPDATE occ_file set occ03 = g_tag[g_cnt].tag05 WHERE occ03 = g_tag[g_cnt].tag03 #TQC-810058
   UPDATE ooc_file set ooc03 = g_tag[g_cnt].tag05 WHERE ooc03 = g_tag[g_cnt].tag03 #TQC-810058
   IF SQLCA.sqlcode THEN
#     CALL cl_err3("upd","occ_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)  #TQC-810058
      CALL cl_err3("upd","ooc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)  #TQC-810058
      LET g_success = 'N'
      RETURN
   END IF
 
#  UPDATE occ_file set occ04 = g_tag[g_cnt].tag05 WHERE occ04 = g_tag[g_cnt].tag03 #TQC-810058
   UPDATE ooc_file set ooc04 = g_tag[g_cnt].tag05 WHERE ooc04 = g_tag[g_cnt].tag03 #TQC-810058
   IF SQLCA.sqlcode THEN
#     CALL cl_err3("upd","occ_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)   #TQC-810058
      CALL cl_err3("upd","ooc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)   #TQC-810058
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool11 = g_tag[g_cnt].tag05 WHERE ool11 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool111= g_tag[g_cnt].tag05 WHERE ool111= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool12 = g_tag[g_cnt].tag05 WHERE ool12 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool121= g_tag[g_cnt].tag05 WHERE ool121= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool13 = g_tag[g_cnt].tag05 WHERE ool13 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool131= g_tag[g_cnt].tag05 WHERE ool131= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool14 = g_tag[g_cnt].tag05 WHERE ool14 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool141= g_tag[g_cnt].tag05 WHERE ool141= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool15 = g_tag[g_cnt].tag05 WHERE ool15 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool151= g_tag[g_cnt].tag05 WHERE ool151= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool21 = g_tag[g_cnt].tag05 WHERE ool21 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool211= g_tag[g_cnt].tag05 WHERE ool211= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool22 = g_tag[g_cnt].tag05 WHERE ool22 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool221= g_tag[g_cnt].tag05 WHERE ool221= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool23 = g_tag[g_cnt].tag05 WHERE ool23 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool231= g_tag[g_cnt].tag05 WHERE ool231= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool24 = g_tag[g_cnt].tag05 WHERE ool24 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool241= g_tag[g_cnt].tag05 WHERE ool241= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool25 = g_tag[g_cnt].tag05 WHERE ool25 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool251= g_tag[g_cnt].tag05 WHERE ool251= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool26 = g_tag[g_cnt].tag05 WHERE ool26 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool261= g_tag[g_cnt].tag05 WHERE ool261= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool27 = g_tag[g_cnt].tag05 WHERE ool27 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool271= g_tag[g_cnt].tag05 WHERE ool271= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool28 = g_tag[g_cnt].tag05 WHERE ool28 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool281= g_tag[g_cnt].tag05 WHERE ool281= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool41 = g_tag[g_cnt].tag05 WHERE ool41 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool411= g_tag[g_cnt].tag05 WHERE ool411= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool42 = g_tag[g_cnt].tag05 WHERE ool42 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool421= g_tag[g_cnt].tag05 WHERE ool421= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool43 = g_tag[g_cnt].tag05 WHERE ool43 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool431= g_tag[g_cnt].tag05 WHERE ool431= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool44 = g_tag[g_cnt].tag05 WHERE ool44 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool441= g_tag[g_cnt].tag05 WHERE ool441= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool45 = g_tag[g_cnt].tag05 WHERE ool45 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool451= g_tag[g_cnt].tag05 WHERE ool451= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool46 = g_tag[g_cnt].tag05 WHERE ool46 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool461= g_tag[g_cnt].tag05 WHERE ool461= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool47 = g_tag[g_cnt].tag05 WHERE ool47 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool471= g_tag[g_cnt].tag05 WHERE ool471= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool51 = g_tag[g_cnt].tag05 WHERE ool51 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool511= g_tag[g_cnt].tag05 WHERE ool511= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool52 = g_tag[g_cnt].tag05 WHERE ool52 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool521= g_tag[g_cnt].tag05 WHERE ool521= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool53 = g_tag[g_cnt].tag05 WHERE ool53 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool531= g_tag[g_cnt].tag05 WHERE ool531= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool54 = g_tag[g_cnt].tag05 WHERE ool54 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE ool_file set ool541= g_tag[g_cnt].tag05 WHERE ool541= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ool_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
  #FUN-810045 remark begin
   #UPDATE pjg_file set pjg03 = g_tag[g_cnt].tag05 WHERE pjg03 = g_tag[g_cnt].tag03
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","pjg_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
  #FUN-810045 end
 
   UPDATE pmc_file set pmc26 = g_tag[g_cnt].tag05 WHERE pmc26 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pmc_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE pmca_file set pmca26= g_tag[g_cnt].tag05 WHERE pmca26= g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pmca_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE pnr_file set pnr02 = g_tag[g_cnt].tag05 WHERE pnr02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pnr_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE pns_file set pns02 = g_tag[g_cnt].tag05 WHERE pns02 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pns_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE sgb_file set sgb06 = g_tag[g_cnt].tag05 WHERE sgb06 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","sgb_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE str_file set str04 = g_tag[g_cnt].tag05 WHERE str04 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","str_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE sts_file set sts01 = g_tag[g_cnt].tag05 WHERE sts01 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","sts_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE sts_file set sts05 = g_tag[g_cnt].tag05 WHERE sts05 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","sts_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE tpg_file set tpg03 = g_tag[g_cnt].tag05 WHERE tpg03 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","tpg_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE tqe_file set tqe06 = g_tag[g_cnt].tag05 WHERE tqe06 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","tqe_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE tqe_file set tqe07 = g_tag[g_cnt].tag05 WHERE tqe07 = g_tag[g_cnt].tag03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","tqe_file",g_tag[g_cnt].tag03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
 
END FUNCTION
#No.FUN-750055----------end--------------
 
#No.FUN-730048

#FUN-BB0015--Begin--
FUNCTION i120_g()
DEFINE l_sql       LIKE type_file.chr1000,
       l_flag      LIKE type_file.chr1,
       l_cnt       LIKE type_file.num5,
       l_tag02     LIKE tag_file.tag02,
       l_tag03     LIKE tag_file.tag03

DEFINE tm          RECORD
          tag02    LIKE tag_file.tag02,
          tag03    LIKE tag_file.tag03,
          tag04    LIKE tag_file.tag04,
          tag05    LIKE tag_file.tag05
      END RECORD

   IF g_tag01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   OPEN WINDOW i120_w1 AT 6,11
     WITH FORM "aoo/42f/aooi120_g"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("aooi120_g")

   CONSTRUCT g_wc ON aag00,aag01 FROM tag02,tag03

      AFTER FIELD tag02
         CALL GET_FLDBUF(tag02) RETURNING tm.tag02
         CALL GET_FLDBUF(tag03) RETURNING tm.tag03
         IF cl_null(tm.tag02) THEN
            CALL cl_err('','9046',0)
            NEXT FIELD tag02
         END IF
         IF NOT cl_null(tm.tag02) AND cl_null(tm.tag03) THEN
            NEXT FIELD tag03
         END IF
      AFTER FIELD tag03
         CALL GET_FLDBUF(tag02) RETURNING tm.tag02
         CALL GET_FLDBUF(tag03) RETURNING tm.tag03
         IF cl_null(tm.tag03) THEN
            CALL cl_err('','9046',0)
            NEXT FIELD tag03
         END IF
         IF cl_null(tm.tag02) AND NOT cl_null(tm.tag03) THEN
            NEXT FIELD tag02
         END IF
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
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tag02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = tm.tag02
               CALL cl_create_qry() RETURNING tm.tag02
               DISPLAY tm.tag02 TO tag02
               NEXT FIELD tag02
            WHEN INFIELD(tag03)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_aag15"  #TQC-C10031 Mark
               LET g_qryparam.form = "q_aag02"  #TQC-C10031
               LET g_qryparam.default1 = tm.tag03
               LET g_qryparam.arg1 = tm.tag02
               CALL cl_create_qry() RETURNING tm.tag03
               DISPLAY tm.tag03 TO tag03
               NEXT FIELD tag03
            OTHERWISE
               EXIT CASE
         END CASE
   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i120_w1
      RETURN
   END IF

   INPUT tm.tag04 WITHOUT DEFAULTS
    FROM tag04

      AFTER FIELD tag04
         IF NOT cl_null(tm.tag04) THEN
            SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01 = tm.tag04
            IF l_cnt <> 1 THEN
               CALL cl_err("","anm-009",1)
               NEXT FIELD tag04
            END IF
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tag04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = tm.tag04
               CALL cl_create_qry() RETURNING tm.tag04
               DISPLAY tm.tag04 TO tag04
               NEXT FIELD tag04
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i120_w1
      RETURN
   END IF
   LET l_sql = " SELECT aag00,aag01 FROM aag_file ",
               " WHERE  aagacti = 'Y' AND (aag07='2' OR aag07='3') AND ",g_wc CLIPPED

   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE i120_g_pre  FROM l_sql
   DECLARE i120_g CURSOR FOR i120_g_pre
   FOREACH i120_g INTO l_tag02,l_tag03
      IF SQLCA.sqlcode THEN
         CALL cl_err('i120_g',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tag_file
       WHERE tag01 = g_tag01 AND tag02 = l_tag02 AND tag03 = l_tag03
         AND tag06 = g_tag06                                                      #CHI-C20023
      IF l_cnt = 0 THEN
         INSERT INTO tag_file (tag01,tag02,tag03,tag04,tag05,tag06)               #CHI-C20023 add tag06
                       VALUES (g_tag01,l_tag02,l_tag03,tm.tag04,l_tag03,g_tag06)  #CHI-C20023 add tag06
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tag_file",tm.tag02,"",SQLCA.sqlcode,"","",1)
         END IF
      END IF
   END FOREACH
   CLOSE WINDOW i120_w1
   LET g_wc = '1=1'
   CALL i120_b_fill()
   DISPLAY ARRAY g_tag TO s_tag.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
      EXIT DISPLAY
   END DISPLAY
END FUNCTION
#FUN-BB0015---End---
#FUN-BC0068--Begin--
FUNCTION i120_r1()
    DEFINE l_wc,l_sql            LIKE type_file.chr1000

   IF g_tag01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   OPEN WINDOW i120_w2 AT 8,20
     WITH FORM "aoo/42f/aooi120_r"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("aooi120_r")

   CONSTRUCT BY NAME l_wc ON tag02,tag03

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tag02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tag02
               NEXT FIELD tag02
            WHEN INFIELD(tag03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_aag06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tag03
               NEXT FIELD tag03
            OTHERWISE
               EXIT CASE
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

   IF INT_FLAG THEN
      CLOSE WINDOW i120_w2
      LET INT_FLAG=0
      RETURN
   END IF

   IF l_wc = ' 1=1' THEN
      CALL cl_err('','9046',1)
      CLOSE WINDOW i120_w2
   ELSE
      IF NOT cl_sure(16,16) THEN
         CLOSE WINDOW i120_w2
         RETURN
      END IF

      LET l_sql="DELETE FROM tag_file ",
                " WHERE tag01 = '",g_tag01 CLIPPED
               ,"'  AND tag06 = '",g_tag06 CLIPPED    #CHI-C20023
               ,"' AND ",l_wc CLIPPED
      PREPARE i120_r_p FROM l_sql
      EXECUTE i120_r_p

      CLOSE WINDOW i120_w2

      CALL i120_b_fill()

      DISPLAY ARRAY g_tag TO s_tag.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
         EXIT DISPLAY
      END DISPLAY
   END IF
END FUNCTION
#FUN-BC0068---End---
#CHI-C80044--Begin--
FUNCTION i120_chk_acctcnt(p_tag01,p_tag02,p_tag03)
DEFINE p_tag01        LIKE tag_file.tag01
DEFINE p_tag02        LIKE tag_file.tag02
DEFINE p_tag03        LIKE tag_file.tag03
DEFINE l_cnt          LIKE type_file.num5

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM tag_file
    WHERE tag01 = p_tag01
      AND tag02 = p_tag02
      AND tag03 = p_tag03
      AND tag06 = '1' AND tagacti = 'Y'
   IF l_cnt > 0 THEN
      LET g_errno = 'agl1033'
   END IF
   RETURN g_errno
END FUNCTION
#CHI-C80044---End---
