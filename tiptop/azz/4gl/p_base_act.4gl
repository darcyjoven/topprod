# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_base_act.4gl
# Descriptions...: 程式基礎執行權限定義暨4ad 4tm產生作業
# Date & Author..: 04/04/06 alex
# Sample.........: r.r2 p_base_act comm_prog come_from target_prog
#                       comm_prog   共用程式  gap資料來源
#                       come_from   由哪支作業串來的  一般都是 p_zz or empty
#                       target_prog 目標程式  產生的4ad,4tm使用此名
# Memo...........: Warning:comm_prog and target_prog should be same module!
# Modify.........:               04/08/23 By alex 將 p_get_act 調為 unset LANG
# Modify.........: No.MOD-490479 04/09/30 By alex 設定不抓取權限指標 gap06 
#                                zz_file要顯示全部Action,但於p_zy,p_zxw
#                                不可抓不可設的
# Modify.........: No.MOD-4A0180 04/10/12 By alex 設定 argv1=transname and argv3=zz01
# Modify.........: No.FUN-4B0049 04/11/18 By Yuna 加轉 excel 檔功能
# Modify.........: No.FUN-4C0104 05/01/05 By alex 修改 4js bug 定義超長
# Modify.........: No.MOD-510103 05/01/14 By alex 將部份功能移到 p_mis 獨立一支
# Modify.........: No.MOD-4A0221 05/02/17 By alex 在產生 4ad 4tm 前判斷應生到哪去
# Modify.........: No.FUN-530022 05/03/17 By alex 修正 gbd07 控制錯誤
# Modify.........: No.MOD-540163 05/04/29 By alex 修正 order by 錯誤
# Modify.........: No.MOD-540108 05/05/02 By alex 修正 zz04 更新時點
# Modify.........: No.TQC-5A0117 05/11/05 By alex 增加離開作業檢查權限功能
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.MOD-610005 06/01/04 By alex 增加應先輸入共用名稱的控管
# Modify.........: No.TQC-610018 06/01/05 By alex 刪除直接執行即離開時跑出的錯誤訊息
# Modify.........: No.TQC-620047 06/02/15 By alex 自動產生所有應修之4ad,4tm
# Modify.........: No.TQC-630185 06/03/30 By Echo 將echo '' 改為 echo -n ''
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-660195 06/07/11 By saki 新增自訂快速鍵功能
# Modify.........: No.FUN-680135 06/09/18 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time改為g_time
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.MOD-8B0083 08/11/07 By Smapmin 4tm的檔案組成有誤
# Modify.........: No.FUN-8C0133 08/12/27 By alex 新增MSV程式段,調整抓gbd方法
# Modify.........: No.MOD-930079 09/03/06 By Dido 若僅購買中文版時,不可預設值為英文
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0113 09/11/19 By alex 調為使用cl_null_empty_to_file()
# Modify.........: No.FUN-A60023 10/07/01 By Kevin 檢查XML 保留字
# Modify.........: No.FUN-AB0041 10/11/10 By Kevin 新增ASE程式段,調整抓gbd方法
# Modify.........: No.MOD-AC0282 10/12/23 By lilingyu 程序有新增action時,在維護action代碼時,進入此程式的單身,欄位gbd06"是否tiptop標準action"有可能為空,導致畫面當出
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gap01          LIKE gap_file.gap01,   # 類別代號 (假單頭)
         g_gap01_t        LIKE gap_file.gap01,   # 類別代號 (假單頭)
         g_gaz03          LIKE gaz_file.gaz03,
         g_gap_lock RECORD LIKE gap_file.*,      # FOR LOCK CURSOR TOUCH
         g_gap    DYNAMIC ARRAY of RECORD        # 程式變數
            gap03          LIKE gap_file.gap03,
            gbd06          LIKE gbd_file.gbd06,
            gap02          LIKE gap_file.gap02,
            gbd04          LIKE gbd_file.gbd04,
            gbd05          LIKE gbd_file.gbd05,
            gap04          LIKE gap_file.gap04,
            gap05          LIKE gap_file.gap05,
            gbd04_s        LIKE gbd_file.gbd04,
            gbd05_s        LIKE gbd_file.gbd05,
            gap08          LIKE gap_file.gap08   #No.FUN-660195
                      END RECORD,
         g_gap_t           RECORD                # 變數舊值
            gap03          LIKE gap_file.gap03,
            gbd06          LIKE gbd_file.gbd06,
            gap02          LIKE gap_file.gap02,
            gbd04          LIKE gbd_file.gbd04,
            gbd05          LIKE gbd_file.gbd05,
            gap04          LIKE gap_file.gap04,
            gap05          LIKE gap_file.gap05,
            gbd04_s        LIKE gbd_file.gbd04,
            gbd05_s        LIKE gbd_file.gbd05,
            gap08          LIKE gap_file.gap08   #No.FUN-660195
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #No.FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,
         g_ss                  LIKE type_file.chr1,    #No.FUN-680135 決定後續步驟
         g_rec_b               LIKE type_file.num5,    #No.FUN-680135 單身筆數
         l_ac                  LIKE type_file.num5     #No.FUN-680135 目前處理的ARRAY CNT
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135  
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 
DEFINE   g_argv1               LIKE gap_file.gap01
DEFINE   g_argv2               LIKE gap_file.gap01
DEFINE   g_argv3               STRING
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_no_ask             LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1) # 要換的程式 id  # 4A0221 gap 來源
   LET g_argv2 = ARG_VAL(2) # 從哪來的
   LET g_argv3 = ARG_VAL(3) # 原來程式 id    # 4A0221 4ad 名稱
 
   # 如果是共用程式, 則 g_argv1 <> g_argv3 如果不是則 g_argv1 = g_argv3
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   # MOD-4A0221 檢查, 若沒輸就算了, 若有輸入則確認是否存在 zz08 
   IF NOT cl_null(g_argv1) THEN
      CALL p_base_act_chkargv1()
   END IF
 
   IF cl_null(g_argv2) OR g_argv2 <> "p_zz" THEN
      LET g_argv2="empty"
   END IF
 
   IF cl_null(g_argv3) THEN
      LET g_argv3="empty"
   END IF
 
   LET g_gap01_t = NULL
 
   OPEN WINDOW p_base_act_w WITH FORM "azz/42f/p_base_act"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from gap_file  WHERE gap01 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_base_act_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
 
      # 2004/04/16 重新抓取資料,串 p_get_act
      IF g_argv2="p_zz" THEN
         CALL p_base_act_re_scan()
      END IF
      CALL p_base_act_q()
   END IF
 
   CALL p_base_act_menu() 
 
   CLOSE WINDOW p_base_act_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
# MOD-4A0221 檢查, 若沒輸就算了, 若有輸入則確認是否存在 zz08 
FUNCTION p_base_act_chkargv1() 
 
   DEFINE li_i1    LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE li_i2    LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE lc_zz08  LIKE zz_file.zz08
   DEFINE lc_db    LIKE type_file.chr3    #No.FUN-680135 
   DEFINE ls_str   STRING
   DEFINE lc_argv1 LIKE gap_file.gap01
   DEFINE li_shift LIKE type_file.num5
 
   LET lc_db=cl_db_get_database_type()
   CASE lc_db
      WHEN "ORA"
         LET lc_zz08="%",g_argv1 CLIPPED,"%"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 LIKE lc_zz08
      WHEN "IFX"
         LET lc_zz08="*",g_argv1 CLIPPED,"*"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 MATCHES lc_zz08
      WHEN "MSV"  #FUN-8C0133
         LET lc_zz08="%",g_argv1 CLIPPED,"%"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 LIKE lc_zz08
      WHEN "ASE"  #FUN-AB0041
         LET lc_zz08="%",g_argv1 CLIPPED,"%"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 LIKE lc_zz08
   END CASE
   IF li_i1 > 0 THEN
      RETURN
   ELSE
      SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01=g_argv1
      LET ls_str = DOWNSHIFT(lc_zz08) CLIPPED
      IF os.Path.separator()="/" THEN
         LET li_i1 = ls_str.getIndexOf("i/",1)    #For UNIX Base
         LET li_shift = 2                         #環境變數位移
      ELSE
         LET li_i1 = ls_str.getIndexOf("i%\/",1)  #For Windows Base
         LET li_shift = 3
      END IF
      LET li_i2 = ls_str.getIndexOf(" ",li_i1)
      IF li_i2 <= li_i1 THEN LET li_i2=ls_str.getLength() END IF
      LET lc_argv1 = ls_str.subString(li_i1+li_shift,li_i2)
      CALL cl_err_msg(NULL,"azz-060",g_argv1 CLIPPED|| "|" || lc_argv1 CLIPPED,10)
      LET g_argv1=lc_argv1 CLIPPED
   END IF
 
END FUNCTION
 
FUNCTION p_base_act_curs()                       # QBE 查詢資料
 
   DEFINE ls_gap01    STRING
 
   CLEAR FORM                                    # 清除畫面
   CALL g_gap.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "gap01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
      CONSTRUCT g_wc ON gap01,gap03,gap02,gap04,gap05,gap08
                   FROM gap01,
                        s_gap[1].gap03,s_gap[1].gap02,s_gap[1].gap04,
                        s_gap[1].gap05,s_gap[1].gap08
 
         AFTER FIELD gap01
            CALL FGL_DIALOG_GETBUFFER() RETURNING ls_gap01
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gap01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zz"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gap01
                  NEXT FIELD gap01
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
          ON ACTION about
             CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE gap01 FROM gap_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gap01 "
   PREPARE p_base_act_prepare FROM g_sql          # 預備一下
   DECLARE p_base_act_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_base_act_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT gap01) FROM gap_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE p_base_act_precount FROM g_sql
   DECLARE p_base_act_count CURSOR FOR p_base_act_precount
END FUNCTION
 
FUNCTION p_base_act_menu()
 
   DEFINE li_zz04      LIKE type_file.num5    #No.FUN-680135 SMALLINT #TQC-5A0117
   DEFINE li_zy03      LIKE type_file.num5    #No.FUN-680135 SMALLINT #TQC-5A0117
 
   WHILE TRUE
      CALL p_base_act_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_base_act_a()
            END IF
 
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_base_act_u()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_base_act_copy()
            END IF
 
#        WHEN "delete"                          # R.取消
#           IF cl_chk_act_auth() THEN
#              CALL p_base_act_r()
#           END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_base_act_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_base_act_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "modify_common_gbd"               # 修改共用名稱/說明
            IF cl_chk_act_auth() THEN           # 權限
               IF NOT cl_null(g_gap01) THEN
                  IF NOT cl_null(g_gap[l_ac].gap02)         # 有抓到 action
                     AND g_gap[l_ac].gbd06 IS NOT NULL THEN # 也有在 gbd中選到資料
 
                     CALL p_base_act_gbd(g_gap[l_ac].gap02,"standard") # 就可以執行
 
                     SELECT gbd04,gbd05
                       INTO g_gap[l_ac].gbd04,g_gap[l_ac].gbd05
                       FROM gbd_file
                      WHERE gbd01=g_gap[l_ac].gap02 AND gbd02="standard"
                        AND gbd03=g_lang
                        AND gbd07="N"        #FUN-530022
 
                     # 2004/06/25 詢問是否自動產生 4ad
                     IF cl_confirm("azz-051") THEN
                        CALL p_base_act_output_4ad()
                     END IF
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
#         WHEN "mis_func"
#            # 2004/08/17 MIS後門
#            IF cl_chk_act_auth() THEN
#               MENU "" ATTRIBUTE(STYLE="popup")
#                  ON ACTION do_all_mis_htm   # 轉換所有 on-line help
#                     CALL p_base_do_all_mis("p_help_htm")
#                  ON ACTION do_all_mis_act   # 重抓取所有 action-id
#                     CALL p_base_do_all_mis("p_get_act")
#               END MENU
#            END IF
 
        WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gap),'','')
            END IF
      END CASE
   END WHILE
 
   #05/11/04 TQC-5A0117 檢查並詢問是否更新 zz04,zy03
   CALL p_base_act_check_zz04() RETURNING li_zz04,li_zy03
   IF li_zz04 THEN
      IF cl_confirm("azz-054") THEN
         CALL p_base_act_add_zz04(li_zy03)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p_base_act_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gap.clear()
 
   INITIALIZE g_gap01 LIKE gap_file.gap01         # 預設值及將數值類變數清成零
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_base_act_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_gap01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_gap.clear()
      ELSE
         CALL p_base_act_b_fill('1=1')       # 單身
      END IF
 
      CALL p_base_act_b()                    # 輸入單身
      LET g_gap01_t=g_gap01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_base_act_i(p_cmd)                 # 處理INPUT
   DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680135  # a:輸入 u:更改
 
   LET g_ss = 'Y'
   DISPLAY g_gap01 TO gap01
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT g_gap01 WITHOUT DEFAULTS FROM gap01
 
      AFTER FIELD gap01                         # 查詢程式代號
         IF NOT cl_null(g_gap01) THEN
            IF g_gap01 != g_gap01_t OR cl_null(g_gap01_t) THEN
               SELECT COUNT(UNIQUE gap01) INTO g_cnt FROM gap_file
                WHERE gap01 = g_gap01
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gap01,-239,0)
                     LET g_gap01 = g_gap01_t
                     NEXT FIELD gap01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gap01,g_errno,0)
                  NEXT FIELD gap01
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gap01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.default1= g_gap01
               CALL cl_create_qry() RETURNING g_gap01
#               CALL FGL_DIALOG_SETBUFFER( g_gap01 )
               NEXT FIELD gap01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON IDLE g_idle_seconds  #FUN-860033
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
END FUNCTION
 
 
FUNCTION p_base_act_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gap01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gap01_t = g_gap01
 
   BEGIN WORK
   OPEN p_base_act_lock_u USING g_gap01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_base_act_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_base_act_lock_u INTO g_gap_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gap01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_base_act_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_base_act_i("u")
      IF INT_FLAG THEN
         LET g_gap01 = g_gap01_t
         DISPLAY g_gap01 TO gap01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gap_file SET gap01 = g_gap01
       WHERE gap01 = g_gap01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_gap01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","gap_file",g_gap01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_base_act_q()                            #Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_gap.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_base_act_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_base_act_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gap01 TO NULL
   ELSE
      CALL p_base_act_fetch('F')                 #讀出TEMP第一筆並顯示
      OPEN p_base_act_count
      FETCH p_base_act_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
FUNCTION p_base_act_fetch(p_flag)           #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,   #No.FUN-680135 #處理方式
            l_abso   LIKE type_file.num10   #No.FUN-680135 INTEGER #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_base_act_b_curs INTO g_gap01
      WHEN 'P' FETCH PREVIOUS p_base_act_b_curs INTO g_gap01
      WHEN 'F' FETCH FIRST    p_base_act_b_curs INTO g_gap01
      WHEN 'L' FETCH LAST     p_base_act_b_curs INTO g_gap01
      WHEN '/' 
         IF (NOT g_no_ask) THEN           #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
                ON IDLE g_idle_seconds   #FUN-860033
                   CALL cl_on_idle()
 
                ON ACTION about         #FUN-860033
                   CALL cl_about()      #FUN-860033
           
                ON ACTION controlg      #FUN-860033
                   CALL cl_cmdask()     #FUN-860033
           
                ON ACTION help          #FUN-860033
                   CALL cl_show_help()  #FUN-860033
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
              EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_base_act_b_curs INTO g_gap01
         LET g_no_ask = FALSE          #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gap01,SQLCA.sqlcode,0)
      INITIALIZE g_gap01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL p_base_act_show()
   END IF
END FUNCTION
 
FUNCTION p_base_act_show()                         # 將資料顯示在畫面上
 
#  #MOD-540163
   CALL cl_get_progname(g_gap01,g_lang) RETURNING g_gaz03
#  SELECT gaz03 INTO g_gaz03 
#    FROM gaz_file WHERE gaz01=g_gap01 AND gaz02=g_lang order by gaz05
 
   DISPLAY g_gap01,g_gaz03 TO gap01,gaz03
   CALL p_base_act_b_fill(g_wc)             # 單身
   CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_base_act_r()                     # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            l_gap   RECORD LIKE gap_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gap01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gap_file WHERE gap01 = g_gap01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","gap_file",g_gap01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_gap.clear()
         OPEN p_base_act_count
         FETCH p_base_act_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_base_act_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_base_act_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL p_base_act_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_base_act_b()                           # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,    #No.FUN-680135 SMALLINT # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,    #No.FUN-680135 SMALLINT # 檢查重複用
            l_gau01         LIKE type_file.num5,    #No.FUN-680135 SMALLINT # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,    #No.FUN-680135 單身鎖住否
            p_cmd           LIKE type_file.chr1,    #No.FUN-680135 處理狀態
            l_allow_insert  LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE   li_zz04         LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE   li_zy03         LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE   li_cnt          LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-660195
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gap01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gap03,'',gap02,'','',gap04,gap05,'','',gap08 ",  #No.FUN-660195
                      " FROM gap_file ",
                     "  WHERE gap01 = ? AND gap02 = ? ",
                       " FOR UPDATE "
 
   # 2004/08/26 以下這種寫法在 Informix 中不被接受, 因為 Informix 在 FOR UPDATE
   #            中不可有 UNIQUE, DISTINCT, GROUP BY, UNION, OUTER 等複雜的行為
   #            此點與 ORACLE 不同, 解決方法為過了 FETCH 後再重選
 
#  LET g_forupd_sql= "SELECT gap03,gbd06,gap02,gbd04,gbd05,gap04,gap05,'','' ",
#                     " FROM gap_file, OUTER gbd_file ",
#                    "  WHERE gap01 = ? AND gap02 = ? ",
#                      " AND gbd_file.gbd01=gap_file.gap02 ",
#                      " AND gbd_file.gbd03= ? ",
#                      " AND gbd_file.gbd02='standard' ",
#                      " FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_base_act_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_ac_t = 0
 
   INPUT ARRAY g_gap WITHOUT DEFAULTS FROM s_gap.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gap_t.* = g_gap[l_ac].*    #BACKUP
 
            # 2004/08/26 此處因應上方 g_forupd_sql 拿掉一個問號
#           OPEN p_base_act_bcl USING g_gap01,g_gap_t.gap02,g_lang
            OPEN p_base_act_bcl USING g_gap01,g_gap_t.gap02
            IF SQLCA.sqlcode THEN 
               CALL cl_err("OPEN p_base_act_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_base_act_bcl INTO g_gap[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_base_act_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  #FUN-8C0133
                  CALL p_base_act_gbd040506(g_gap[l_ac].gap02,g_gap01)
                     RETURNING g_gap[l_ac].gbd06,
                               g_gap[l_ac].gbd04,  g_gap[l_ac].gbd05,
                               g_gap[l_ac].gbd04_s,g_gap[l_ac].gbd05_s
               END IF
            END IF
            LET g_before_input_done = FALSE
            CALL p_base_act_set_entry(p_cmd)
            CALL p_base_act_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            #No.FUN-660195 --start--
            IF g_gap[l_ac].gbd06 = "Y" THEN
               CALL cl_set_act_visible("act_hot_key",FALSE)
            ELSE
               CALL cl_set_act_visible("act_hot_key",TRUE)
            END IF
            #No.FUN-660195 ---end---
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gap[l_ac].* TO NULL       #900423
         LET g_gap_t.* = g_gap[l_ac].*          #新輸入資料
         LET g_gap[l_ac].gap03="Y"              #必屬 user define
         LET g_gap[l_ac].gap04="N"              #多不為 detail屬性
         LET g_gap[l_ac].gap05="N"              #多不放在 topmenu
         LET g_before_input_done = FALSE
         CALL p_base_act_set_entry(p_cmd)
         CALL p_base_act_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gap02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gap_file (gap01,gap02,gap03,gap04,gap05,gap06,gap08)
              VALUES (g_gap01,g_gap[l_ac].gap02,g_gap[l_ac].gap03,
                              g_gap[l_ac].gap04,g_gap[l_ac].gap05,"Y",g_gap[l_ac].gap08)     #No.FUN-660195
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gap01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gap_file",g_gap01,g_gap[l_ac].gap02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD gap02
         IF g_gap[l_ac].gap02 != g_gap_t.gap02 OR g_gap_t.gap02 IS NULL THEN
            # 檢視 gap_file 中同一 Program Name (gap01) 下是否有相同的
            # Filed Name (gap02)
            SELECT COUNT(*) INTO l_n FROM gap_file
             WHERE gap01 = g_gap01 AND gap02 = g_gap[l_ac].gap02
            IF l_n > 0 THEN
               CALL cl_err(g_gap[l_ac].gap02,-239,0)
               LET g_gap[l_ac].gap02 = g_gap_t.gap02
               NEXT FIELD gap02
            END IF
         END IF
         SELECT gbd04,gbd05,gbd06
           INTO g_gap[l_ac].gbd04,g_gap[l_ac].gbd05,g_gap[l_ac].gbd06
           FROM gbd_file 
          WHERE gbd01=g_gap[l_ac].gap02 AND gbd02="standard"
            AND gbd03=g_lang
            AND gbd07='N'       #FUN-530022
         SELECT gbd04,gbd05 INTO g_gap[l_ac].gbd04_s,g_gap[l_ac].gbd05_s
           FROM gbd_file 
          WHERE gbd01=g_gap[l_ac].gap02 AND gbd02=g_gap01
            AND gbd03=g_lang
            AND gbd07='N'       #FUN-530022
 
      AFTER FIELD gap05
         IF g_gap[l_ac].gbd06 = "Y" AND g_gap[l_ac].gap05 = "Y" THEN
            CALL cl_err("","azz-045",1)
            LET g_gap[l_ac].gap05 = "N"
         END IF
 
      BEFORE FIELD gbd04_s
         IF cl_null(g_gap[l_ac].gbd04) THEN    #MOD-610005
            CALL cl_chk_act_auth_nomsg()
            LET g_action_choice="modify_common_gbd"
            IF cl_chk_act_auth() THEN
               CALL cl_err_msg(NULL,"azz-236",g_gap[l_ac].gap02,10)
               CALL p_base_act_gbd(g_gap[l_ac].gap02,"standard")
               LET g_gap[l_ac].gbd04 = ""
               LET g_gap[l_ac].gbd05 = ""
               SELECT gbd04,gbd05 INTO g_gap[l_ac].gbd04,g_gap[l_ac].gbd05
                 FROM gbd_file
                WHERE gbd01=g_gap[l_ac].gap02 AND gbd02='standard'
                  AND gbd03=g_lang
                  AND gbd07='N'       #FUN-530022
               DISPLAY g_gap[l_ac].gbd04,g_gap[l_ac].gbd05 TO gbd04,gbd05
            ELSE
               CALL cl_err_msg(NULL,"azz-237",g_gap[l_ac].gap02,10)
            END IF
            NEXT FIELD gap04        #No.FUN-660195
         ELSE
            CALL p_base_act_gbd(g_gap[l_ac].gap02,g_gap01)
            LET g_gap[l_ac].gbd04_s = ""
            LET g_gap[l_ac].gbd05_s = ""
            SELECT gbd04,gbd05 INTO g_gap[l_ac].gbd04_s,g_gap[l_ac].gbd05_s
              FROM gbd_file 
             WHERE gbd01=g_gap[l_ac].gap02 AND gbd02=g_gap01
               AND gbd03=g_lang
               AND gbd07='N'       #FUN-530022
            DISPLAY g_gap[l_ac].gbd04_s,g_gap[l_ac].gbd05_s TO gbd04_s,gbd05_s
            NEXT FIELD gap04        #No.FUN-660195
         END IF
 
      BEFORE FIELD gbd05_s
         IF cl_null(g_gap[l_ac].gbd04) THEN    #MOD-610005
            CALL cl_chk_act_auth_nomsg()
            LET g_action_choice="modify_common_gbd"
            IF cl_chk_act_auth() THEN
               CALL cl_err_msg(NULL,"azz-236",g_gap[l_ac].gap02,10)
               CALL p_base_act_gbd(g_gap[l_ac].gap02,"standard")
               LET g_gap[l_ac].gbd04 = ""
               LET g_gap[l_ac].gbd05 = ""
               SELECT gbd04,gbd05 INTO g_gap[l_ac].gbd04,g_gap[l_ac].gbd05
                 FROM gbd_file
                WHERE gbd01=g_gap[l_ac].gap02 AND gbd02='standard'
                  AND gbd03=g_lang
                  AND gbd07='N'       #FUN-530022
               DISPLAY g_gap[l_ac].gbd04,g_gap[l_ac].gbd05 TO gbd04,gbd05
            ELSE
               CALL cl_err_msg(NULL,"azz-237",g_gap[l_ac].gap02,10)
            END IF
            NEXT FIELD gap04        #No.FUN-660195
         ELSE
            CALL p_base_act_gbd(g_gap[l_ac].gap02,g_gap01)
            LET g_gap[l_ac].gbd04_s = ""
            LET g_gap[l_ac].gbd05_s = ""
            SELECT gbd04,gbd05 INTO g_gap[l_ac].gbd04_s,g_gap[l_ac].gbd05_s
              FROM gbd_file 
             WHERE gbd01=g_gap[l_ac].gap02 AND gbd02=g_gap01
               AND gbd03=g_lang
               AND gbd07='N'       #FUN-530022
            DISPLAY g_gap[l_ac].gbd04_s,g_gap[l_ac].gbd05_s TO gbd04_s,gbd05_s
            NEXT FIELD gap04        #No.FUN-660195
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gap_t.gap02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF NOT g_gap[l_ac].gap03="Y" THEN #如果不是 Y (user-define)就不可刪
               CALL cl_err("","azz-044", 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err("Deleting One of Several Primary Keys!","!",1)
            END IF
            DELETE FROM gap_file WHERE gap01 = g_gap01
                                   AND gap02 = g_gap[l_ac].gap02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gap_t.gap02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gap_file",g_gap01,g_gap_t.gap02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gap[l_ac].* = g_gap_t.*
            CLOSE p_base_act_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gap[l_ac].gap02,-263,1)
            LET g_gap[l_ac].* = g_gap_t.*
         ELSE
            UPDATE gap_file
               SET gap02 = g_gap[l_ac].gap02,
                   gap03 = g_gap[l_ac].gap03,
                   gap04 = g_gap[l_ac].gap04,
                   gap05 = g_gap[l_ac].gap05,
                   gap08 = g_gap[l_ac].gap08
             WHERE gap01 = g_gap01
               AND gap02 = g_gap_t.gap02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gap[l_ac].gap02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gap_file",g_gap01,g_gap_t.gap02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gap[l_ac].* = g_gap_t.*
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
            IF p_cmd='u' THEN
               LET g_gap[l_ac].* = g_gap_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gap.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_base_act_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE p_base_act_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gap02) AND l_ac > 1 THEN
            LET g_gap[l_ac].* = g_gap[l_ac-1].*
            NEXT FIELD gap02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON ACTION modify_common_gbd               # 修改共用名稱/說明
          LET g_action_choice="modify_common_gbd"
          IF cl_chk_act_auth() THEN           # 權限
             IF NOT cl_null(g_gap01) THEN
                IF NOT cl_null(g_gap[l_ac].gap02)         # 有抓到 action
                   AND g_gap[l_ac].gbd06 IS NOT NULL THEN # 也有在 gbd中選到資料
 
                   CALL p_base_act_gbd(g_gap[l_ac].gap02,"standard") # 就可以執行
 
                   SELECT gbd04,gbd05
                     INTO g_gap[l_ac].gbd04,g_gap[l_ac].gbd05
                     FROM gbd_file
                    WHERE gbd01=g_gap[l_ac].gap02 AND gbd02="standard"
                      AND gbd03=g_lang
                      AND gbd07='N'       #FUN-530022
                   DISPLAY g_gap[l_ac].gbd04,g_gap[l_ac].gbd05 TO gbd04,gbd05
                END IF
             ELSE
                CALL cl_err('',-400,0)
             END IF
          END IF
          LET g_action_choice=""
 
      #No.FUN-660195 --start--
      ON ACTION act_hot_key
         LET g_action_choice="act_hot_key"
         IF cl_chk_act_auth() THEN           # 權限
            IF g_gap[l_ac].gbd06 = "N" THEN
               CALL p_base_act_set_hotkey(g_gap[l_ac].gap08) RETURNING g_gap[l_ac].gap08
               DISPLAY BY NAME g_gap[l_ac].gap08
            END IF
         END IF
      #No.FUN-660195 ---end---
 
      ON IDLE g_idle_seconds    #FUN-860033
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
      
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
   END INPUT
   CLOSE p_base_act_bcl
   COMMIT WORK
 
   IF g_action_choice = "detail" THEN   #FUN-D30034 add
   ELSE
      # 2004/06/10 詢問是否自動產生 4ad/4tm
      IF cl_confirm("azz-042") THEN
         CALL p_base_act_output_4ad()
         CALL p_base_act_output_4tm()
      END IF
 
      # 2004/08/20 檢查並詢問是否更新 zz04,zy03
      CALL p_base_act_check_zz04() RETURNING li_zz04,li_zy03
      IF li_zz04 THEN
         IF cl_confirm("azz-054") THEN
            CALL p_base_act_add_zz04(li_zy03)
         END IF
      END IF
   END IF    #FUN-D30034 add 
END FUNCTION
 
 
FUNCTION p_base_act_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc         STRING                 #TQC-5A0117
   DEFINE p_ac         LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE p_flag       LIKE type_file.chr1    #No.FUN-680135 
   DEFINE p_idx        LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
#  #FUN-8C0133
#  LET g_sql = "SELECT gap03,gbd06,gap02,gbd04,gbd05,gap04,gap05,'','',gap08 ",
#               " FROM gap_file, OUTER gbd_file ",
#              " WHERE gap_file.gap01 = '",g_gap01 CLIPPED,"' ",
#                " AND ",p_wc CLIPPED,
#                " AND gbd_file.gbd01 = gap_file.gap02 ",
#                " AND gbd_file.gbd03 = '",g_lang CLIPPED,"' ",
#                " AND gbd_file.gbd02 = 'standard' ",
#                " AND gbd_file.gbd07 = 'N' ",          #FUN-530022
#              " ORDER BY gap03 DESC,gbd_file.gbd06 "
 
    LET g_sql = "SELECT gap03,'',gap02,'','',gap04,gap05,'','',gap08 ",
                 " FROM gap_file ",
                " WHERE gap01 = '",g_gap01 CLIPPED,"' ",
                  " AND ",p_wc CLIPPED,
                " ORDER BY gap03 DESC "
 
    PREPARE p_base_act_prepare2 FROM g_sql           #預備一下
    DECLARE gap_curs CURSOR FOR p_base_act_prepare2
 
    CALL g_gap.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gap_curs INTO g_gap[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       #FUN-8C0133
       CALL p_base_act_gbd040506(g_gap[g_cnt].gap02,g_gap01)
          RETURNING g_gap[g_cnt].gbd06,
                    g_gap[g_cnt].gbd04,  g_gap[g_cnt].gbd05,
                    g_gap[g_cnt].gbd04_s,g_gap[g_cnt].gbd05_s
 
       LET g_cnt = g_cnt + 1
 
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gap.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    # 2004/06/09 判斷有沒有 gbd06 is null 若有則問 !!
    LET p_flag = "N"
    FOR p_idx=1 TO g_rec_b
       IF NOT cl_null(g_gap[p_idx].gap02) AND
          g_gap[p_idx].gbd06 IS NULL AND cl_null(g_gap[p_idx].gbd04) THEN
          LET p_flag="Y"
          EXIT FOR
       END IF
    END FOR
 
    # 2004/06/09 詢問若沒有共用的 gbd_file, 是否要插入!
    IF p_flag = "Y" THEN
       IF cl_confirm("azz-043") THEN
          FOR p_idx=1 TO g_rec_b                      #怎樣的要塞值?
             IF NOT cl_null(g_gap[p_idx].gap02)       #gap02抓到不是空白或null
                AND g_gap[p_idx].gbd06 IS NULL        #也不會找到標準處有值
                AND cl_null(g_gap[p_idx].gbd04) THEN  #action名稱也是空的
 
                IF g_gap[p_idx].gbd06 IS NULL THEN 
                   LET g_gap[p_idx].gbd06="N"
                END IF
 
                # 2004/12/09 FUN-4C0062 改為只新增一筆 Standard 英文
                # 2009/03/06 MOD-930079 改為只新增一筆 Standard 中文,理由為無論購買中文版或中英文版皆有繁體版
                INSERT INTO gbd_file (gbd01,gbd02,gbd03,gbd06,gbd07)
                 VALUES(g_gap[p_idx].gap02,"standard","0",g_gap[p_idx].gbd06,"N") 
#                VALUES(g_gap[p_idx].gap02,"standard","1",g_gap[p_idx].gbd06,"N")
#                VALUES(g_gap[p_idx].gap02,"standard","1","N","N")
 
             END IF
          END FOR
       END IF
    END IF
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
#傳入 gbd01-Action代碼 gbd02-程式代碼 會幫你找出正確的該程式下的act名稱
#考慮客製  FUN-8C0133
 
FUNCTION p_base_act_gbd040506(lc_gbd01,lc_gbd02)
 
   DEFINE lc_gbd01     LIKE gbd_file.gbd01
   DEFINE lc_gbd02     LIKE gbd_file.gbd02
   DEFINE lc_gbd04     LIKE gbd_file.gbd04
   DEFINE lc_gbd05     LIKE gbd_file.gbd05
   DEFINE lc_gbd04_s   LIKE gbd_file.gbd04
   DEFINE lc_gbd05_s   LIKE gbd_file.gbd05
   DEFINE lc_gbd04_t   LIKE gbd_file.gbd04
   DEFINE lc_gbd05_t   LIKE gbd_file.gbd05
   DEFINE lc_gbd06     LIKE gbd_file.gbd06
 
   #gbd06 是否為標準 Action指標都由 standard 的繁體中文選出
   SELECT gbd06 INTO lc_gbd06 FROM gbd_file
    WHERE gbd01=lc_gbd01 AND gbd02="standard" AND gbd03="0" AND gbd07="N"  

#MOD-AC0282 --begin--
   IF cl_null(lc_gbd06) THEN
     LET lc_gbd06 = 'N'
   END IF 
#MOD-AC0282 --end--
 
   #選出 standard
   SELECT gbd04,gbd05 INTO lc_gbd04,lc_gbd05 FROM gbd_file
    WHERE gbd01=lc_gbd01 AND gbd02="standard" AND gbd03=g_lang AND gbd07="N"  
 
   SELECT gbd04,gbd05 INTO lc_gbd04_t,lc_gbd05_t FROM gbd_file
    WHERE gbd01=lc_gbd01 AND gbd02="standard" AND gbd03=g_lang AND gbd07="Y"  
 
   IF NOT SQLCA.SQLCODE AND NOT cl_null(lc_gbd04_t) THEN
      LET lc_gbd04 = lc_gbd04_t CLIPPED
      LET lc_gbd05 = lc_gbd05_t CLIPPED
   END IF
 
   #選出該程式特有
   SELECT gbd04,gbd05 INTO lc_gbd04_s,lc_gbd05_s FROM gbd_file
    WHERE gbd01=lc_gbd01 AND gbd02=lc_gbd02 AND gbd03=g_lang AND gbd07="N"  
 
   SELECT gbd04,gbd05 INTO lc_gbd04_t,lc_gbd05_t FROM gbd_file
    WHERE gbd01=lc_gbd01 AND gbd02=lc_gbd02 AND gbd03=g_lang AND gbd07="Y"  
 
   IF NOT SQLCA.SQLCODE AND NOT cl_null(lc_gbd04_t) THEN
      LET lc_gbd04_s = lc_gbd04_t CLIPPED
      LET lc_gbd05_s = lc_gbd05_t CLIPPED
   END IF
 
   RETURN lc_gbd06,lc_gbd04,lc_gbd05,lc_gbd04_s,lc_gbd05_s
 
END FUNCTION
 
 
 
 
FUNCTION p_base_act_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680135 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gap TO s_gap.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
#     ON ACTION delete                           # R.取消
#        LET g_action_choice="delete"
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE                      #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_base_act_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION previous                         # P.上筆
         CALL p_base_act_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_base_act_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next                             # N.下筆
         CALL p_base_act_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_base_act_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION modify_common_gbd
         LET g_action_choice="modify_common_gbd"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
#      2005/01/14 MOD-510103
#      ON ACTION mis_func
#         LET g_action_choice="mis_func"
#         EXIT DISPLAY
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_base_act_copy()
   DEFINE   l_n       LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            l_newno   LIKE gap_file.gap01,
            l_oldno   LIKE gap_file.gap01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_gap01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT l_newno WITHOUT DEFAULTS FROM gap01
 
      AFTER FIELD gap01
         IF cl_null(l_newno) THEN
            NEXT FIELD gap01
         END IF
         SELECT COUNT(*) INTO g_cnt FROM gap_file
          WHERE gap01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD gap01
         END IF
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_gap01 TO gap01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM gap_file WHERE gap01 = g_gap01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_gap01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_gap01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET gap01 = l_newno                         # 資料鍵值
 
   INSERT INTO gap_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('gap:',SQLCA.SQLCODE,0)  #No.FUN-660081
      CALL cl_err3("ins","gap_file",l_newno,"",SQLCA.sqlcode,"","gap",0)   #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldno = g_gap01
   LET g_gap01 = l_newno
   CALL p_base_act_b()
   #LET g_gap01 = l_oldno  #FUN-C30027
   #CALL p_base_act_show() #FUN-C30027
END FUNCTION
 
FUNCTION p_base_act_re_scan()
 
   DEFINE l_cmd   STRING
 
   # 2004/04/16 重新抓取資料,串 p_get_act
   IF cl_null(g_argv1) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   # 2004/04/16 詢問一下
   IF NOT cl_confirm("azz-040") THEN
      RETURN
   END IF
 
   LET l_cmd = 'p_get_act "' || g_argv1 CLIPPED || '" ' 
 
   IF os.Path.separator()="/" THEN
      CALL cl_cmdrun_unset_lang_wait(l_cmd)
   ELSE
      CALL cl_cmdrun(l_cmd)
   END IF
 
   RETURN
 
END FUNCTION
 
 
 
FUNCTION p_base_act_output_4ad()
 
   DEFINE la_gbd        RECORD
             gbd01         LIKE gbd_file.gbd01,
             gbd04         LIKE gbd_file.gbd04,
             gbd05         LIKE gbd_file.gbd05,
             gap08         LIKE gap_file.gap08     #No.FUN-660195
                        END RECORD
   DEFINE ls_sql        STRING
   DEFINE ls_top        STRING
   DEFINE ls_topcust    STRING
   DEFINE ls_filename   STRING
   DEFINE ls_cpsource   STRING
   DEFINE lc_gbd03      LIKE gbd_file.gbd03  # 語言別
   DEFINE lc_gbd04      LIKE gbd_file.gbd04  # 如果有自己的
   DEFINE lc_gbd05      LIKE gbd_file.gbd05  # 如果有自己的
   DEFINE lc_cmd        STRING
   DEFINE lc_module     STRING
   DEFINE ls_str        STRING
   DEFINE lc_channel    base.Channel
   DEFINE li_openfile   LIKE type_file.num5  # 是否已開啟檔案的指標 #No.FUN-680135
   DEFINE li_openhead   LIKE type_file.num5  # 是否已開啟檔頭的指標 #No.FUN-680135
   DEFINE lc_zz011      LIKE zz_file.zz011
   DEFINE lc_gap01      LIKE gap_file.gap01  # 如果有自己的 MOD-4A0180
   DEFINE lc_gap01_tmp  LIKE gap_file.gap01
   DEFINE lc_zz08       LIKE zz_file.zz08    # MOD-4A0221
   DEFINE li_i1,li_i2   LIKE type_file.num5  #No.FUN-680135 SMALLINT # MOD-4A0221
   DEFINE ls_gap01      STRING
   DEFINE lc_db         LIKE type_file.chr3  #No.FUN-680135 
   DEFINE lst_gap01     base.StringTokenizer
   DEFINE ls_module_t   STRING               # TQC-620047
   DEFINE ls_text        STRING              #FUN-A60023
 
   # 2004/04/16 產生所有語言別下本程式的 4ad 檔
   IF cl_null(g_gap01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   # 2004/04/19 應加上現行有幾個語言別的指示
   DECLARE p_base_act_out_lang CURSOR FOR
      SELECT DISTINCT gay01 FROM gay_file ORDER BY gay01
 
   # 先組出檔案位置
   CALL fgl_getenv("TOPCONFIG") RETURNING ls_top
   IF cl_null(ls_top) THEN 
      CALL fgl_getenv("TOP") RETURNING ls_top
      LET ls_top = ls_top.trim() || "/config"
   END IF
   CALL fgl_getenv("CUSTCONFIG") RETURNING ls_topcust
   IF cl_null(ls_topcust) THEN
      CALL fgl_getenv("CUST") RETURNING ls_topcust
      LET ls_topcust = ls_topcust.trim() || "/config"
   END IF
 
   # 2004/10/12 BUG-4A0180 2005/01/14 MOD-510103
   LET lc_gap01=""
   IF g_argv3 != "empty" THEN   # AND g_argv3 != "MIS!" THEN
      LET lc_gap01 = g_argv3.trim()
#   ELSE
#      # MOD-4A0221 判斷 g_gap01 與 zz08 截出來的程式名稱是否相同, 不同則以
#      #            共用程式方式處理
#      SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01=g_gap01
#      LET ls_str = DOWNSHIFT(lc_zz08) CLIPPED
#      LET li_i1 = ls_str.getIndexOf("i/",1)
#      LET li_i2 = ls_str.getIndexOf(" ",li_i1)
#      IF li_i2 <= li_i1 THEN LET li_i2=ls_str.getLength() END IF
#      LET lc_gap01 = ls_str.subString(li_i1+2,li_i2)
##     LET lc_gap01 = g_gap01 CLIPPED
   END IF
 
   # MOD-4A0221 2005/03/01 以 g_gap01 為標準檢查 lc_gap 的合理性
   #                       若有多組同時成立 (共用程式) 時,先取用第一個其餘存入
   #                       一個暫存字串,待後面以複製法產生
 
   #TQC-620047
#  IF cl_null(lc_gap01) THEN
      LET lc_db=cl_db_get_database_type()
      CASE lc_db
         WHEN "ORA"
            LET lc_zz08="%",g_gap01 CLIPPED,"%"
            SELECT COUNT(*) INTO li_i1 FROM zz_file
             WHERE zz08 LIKE lc_zz08
         WHEN "IFX"
            LET lc_zz08="*",g_gap01 CLIPPED,"*"
            SELECT COUNT(*) INTO li_i1 FROM zz_file
             WHERE zz08 MATCHES lc_zz08
         WHEN "MSV"     #FUN-8C0133
            LET lc_zz08="%",g_gap01 CLIPPED,"%"
            SELECT COUNT(*) INTO li_i1 FROM zz_file
             WHERE zz08 LIKE lc_zz08
         WHEN "ASE"     #FUN-AB0041
            LET lc_zz08="%",g_gap01 CLIPPED,"%"
            SELECT COUNT(*) INTO li_i1 FROM zz_file
             WHERE zz08 LIKE lc_zz08
      END CASE
 
      IF li_i1 > 1 THEN
         IF cl_confirm("azz-238") THEN
            LET lc_gap01=""
         END IF
      END IF
#  #TQC-620047
 
   IF cl_null(lc_gap01) THEN
      IF li_i1 >= 1 THEN
         CASE lc_db
            WHEN "ORA"
               LET lc_zz08="%",g_gap01 CLIPPED,"%"
               LET ls_str="SELECT zz01 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
            WHEN "IFX"
               LET lc_zz08="*",g_gap01 CLIPPED,"*"
               LET ls_str="SELECT zz01 FROM zz_file WHERE zz08 MATCHES '",lc_zz08 CLIPPED,"' "
            WHEN "MSV"     #FUN-8C0133
               LET lc_zz08="%",g_gap01 CLIPPED,"%"
               LET ls_str="SELECT zz01 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
            WHEN "ASE"     #FUN-AB0041
               LET lc_zz08="%",g_gap01 CLIPPED,"%"
               LET ls_str="SELECT zz01 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
         END CASE
         PREPARE p_base_com_4adpre FROM ls_str
         DECLARE p_base_com_4adcus CURSOR FOR p_base_com_4adpre
         LET li_i2=0
         LET ls_gap01=""  LET lc_gap01=""
         FOREACH p_base_com_4adcus INTO lc_gap01_tmp
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH zz01:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET li_i2 = li_i2 + 1
            IF li_i2=1 THEN 
               LET lc_gap01=lc_gap01_tmp
            ELSE
               LET ls_gap01=ls_gap01.trim(),",",lc_gap01_tmp
            END IF
         END FOREACH
         LET ls_gap01=ls_gap01.subString(2,ls_gap01.getLength())
      ELSE
         CALL cl_err_msg(NULL,"azz-061",g_gap01 CLIPPED,10)
         RETURN   #TQC-620047
      END IF
   END IF
 
   # 2004/07/27 by saki
   SELECT zz011 INTO lc_zz011 FROM zz_file
    WHERE zz01 = lc_gap01
 
   IF cl_null(lc_zz011) THEN
      CALL cl_err_msg(NULL,"azz-061",lc_gap01 CLIPPED,10)
      RETURN
   END IF
 
   LET lc_module = lc_zz011
   LET lc_module = lc_module.toLowerCase()
 
   # 2004/04/19 然後就要做 n 次
   FOREACH p_base_act_out_lang INTO lc_gbd03
 
       IF lc_module.subString(1,1) = "c" THEN
          LET ls_filename = ls_topcust.trim() || "/4ad/" || lc_gbd03 || "/" || lc_module CLIPPED || "/" || lc_gap01 CLIPPED || ".4ad"
       ELSE
          LET ls_filename = ls_top.trim() || "/4ad/" || lc_gbd03 || "/" || lc_module CLIPPED || "/" || lc_gap01 CLIPPED || ".4ad"
       END IF
 
       display "Info 4ad name = ",ls_filename
#      LET lc_cmd = "cat /dev/null > ", ls_filename CLIPPED   #TQC-630006 #MOD-650098
#      RUN lc_cmd
       CALL cl_null_cat_to_file(ls_filename CLIPPED)        #FUN-9B0113

       LET li_openhead=FALSE #檔頭未開啟
 
       # 2004/06/08 抓各程式標準的東西重寫一下
       # 2004/04/17 如果抓到的是標準的  那就不要輸出在 4ad 中
       # 2004/06/14 如果gbd02=standard不存在  那就連自有的不給抓
 
       LET ls_sql = " SELECT gap02,gbd04,gbd05,gap08 FROM gap_file, gbd_file ", #No.FUN-660195
                     " WHERE gap_file.gap01='",g_gap01 CLIPPED,"' ",
                       " AND gbd_file.gbd01=gap_file.gap02 ",
                       " AND gbd_file.gbd02='standard' ",
                       " AND gbd_file.gbd03='",lc_gbd03 CLIPPED,"' ",
                       " AND gbd_file.gbd06 != 'Y' ",
                       " AND gbd_file.gbd07='N' "   #FUN-530022
 
       PREPARE p_base_act_4adpre FROM ls_sql           #預備一下
       DECLARE gbd_curs CURSOR FOR p_base_act_4adpre
 
       FOREACH gbd_curs INTO la_gbd.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             CONTINUE FOREACH
          ELSE
             # 2004/06/14 再看一下有沒有自設的, 有的話就倒回去
             LET lc_gbd04 = ""
             LET lc_gbd05 = ""
             SELECT gbd04,gbd05 INTO lc_gbd04,lc_gbd05 FROM gbd_file 
              WHERE gbd_file.gbd01=la_gbd.gbd01
                AND gbd_file.gbd02=g_gap01
                AND gbd_file.gbd03=lc_gbd03 
                AND gbd_file.gbd07='N'
 
             IF NOT cl_null(lc_gbd04) THEN
                LET la_gbd.gbd04=lc_gbd04 CLIPPED
             END IF
             IF NOT cl_null(lc_gbd05) THEN
                LET la_gbd.gbd05=lc_gbd05 CLIPPED
             END IF
  
             #FUN-A60023
             LET ls_text = la_gbd.gbd04      
             LET ls_text = cl_replace_str(ls_text, "<" , "&lt;")
             LET ls_text = cl_replace_str(ls_text, ">" , "&gt;")               
             # 2004/06/14 看有沒有 comments 有就倒
             #No.FUN-660195 --start-- modify
             IF cl_null(la_gbd.gbd05) THEN
                IF cl_null(la_gbd.gap08) THEN
                   LET ls_str = "   <ActionDefault name=\"",la_gbd.gbd01 CLIPPED,"\" text=\"",ls_text CLIPPED,"\" />"
                ELSE
                   LET ls_str = "   <ActionDefault name=\"",la_gbd.gbd01 CLIPPED,"\" text=\"",ls_text CLIPPED,"\" comment=\"[",la_gbd.gap08 CLIPPED,"]",ls_text CLIPPED,"\" acceleratorName=\"",la_gbd.gap08 CLIPPED,"\" />"
                END IF
             ELSE
                IF cl_null(la_gbd.gap08) THEN
                   LET ls_str = "   <ActionDefault name=\"",la_gbd.gbd01 CLIPPED,"\" text=\"",ls_text CLIPPED,"\" comment=\"",la_gbd.gbd05 CLIPPED,"\" />"
                ELSE
                   LET ls_str = "   <ActionDefault name=\"",la_gbd.gbd01 CLIPPED,"\" text=\"",ls_text CLIPPED,"\" comment=\"[",la_gbd.gap08 CLIPPED,"]",la_gbd.gbd05 CLIPPED,"\" acceleratorName=\"",la_gbd.gap08 CLIPPED,"\" />"
                END IF
             END IF
             #No.FUN-660195 ---end---
 
             IF li_openhead = FALSE THEN
                # 2004/04/17 輸出檔頭
                LET lc_channel = base.Channel.create()
                CALL lc_channel.openFile( ls_filename CLIPPED, "a" )
                CALL lc_channel.setDelimiter("")
                CALL lc_channel.write("<?xml version='1.0'?>")
                CALL lc_channel.write("<ActionDefaultList>")
                LET li_openhead = TRUE
             END IF
 
             CALL lc_channel.write(ls_str)
          END IF
       END FOREACH
 
       IF li_openhead = TRUE THEN
          CALL lc_channel.write("</ActionDefaultList>")
          CALL lc_channel.close()
       END IF
 
   END FOREACH
 
   IF NOT cl_null(ls_gap01) THEN
#     #TQC-620047
      LET ls_module_t=" SELECT zz011 FROM zz_file WHERE zz01=? "
      PREPARE p_base_act_4ad_multi FROM ls_module_t
 
      LET lst_gap01 = base.StringTokenizer.create(ls_gap01,",")
      WHILE lst_gap01.hasMoreTokens()
         LET lc_gap01_tmp=lst_gap01.nextToken()
 
         EXECUTE p_base_act_4ad_multi USING lc_gap01_tmp INTO lc_zz011
         LET ls_module_t = lc_zz011 CLIPPED
         LET ls_module_t = ls_module_t.toLowerCase()
 
         FOREACH p_base_act_out_lang INTO lc_gbd03
            IF lc_module.subString(1,1) = "c" THEN
               LET ls_cpsource = ls_topcust.trim() || "/4ad/" || lc_gbd03 || "/" || lc_module CLIPPED || "/" || lc_gap01 CLIPPED || ".4ad"
            ELSE
               LET ls_cpsource = ls_top.trim() || "/4ad/" || lc_gbd03 || "/" || lc_module CLIPPED || "/" || lc_gap01 CLIPPED || ".4ad"
            END IF
 
            IF ls_module_t.subString(1,1) = "c" THEN
               LET ls_filename = ls_topcust.trim() || "/4ad/" || lc_gbd03 || "/" || ls_module_t.trim() || "/" || lc_gap01_tmp CLIPPED || ".4ad"
            ELSE
               LET ls_filename = ls_top.trim() || "/4ad/" || lc_gbd03 || "/" || ls_module_t.trim() || "/" || lc_gap01_tmp CLIPPED || ".4ad"
            END IF
 
            display "Info 4ad name = ",ls_filename
            LET lc_cmd = "cp ",ls_cpsource.trim()," ",ls_filename.trim()
            RUN lc_cmd
         END FOREACH
      END WHILE
   END IF
 
   RETURN
END FUNCTION
 
FUNCTION p_base_act_output_4tm()
 
   DEFINE ls_top        STRING
   DEFINE ls_topcust    STRING
   DEFINE ls_filename   STRING
   DEFINE ls_cpsource   STRING
   DEFINE lc_cmd        STRING
   DEFINE lc_module     STRING
   DEFINE ls_str        STRING
   DEFINE lc_channel    base.Channel
   DEFINE li_openfile   LIKE type_file.num5   #No.FUN-680135 SMALLINT # 是否已開啟檔案的指標
   DEFINE li_i          LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE li_i1,li_i2   LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE li_openhead   LIKE type_file.num5   #No.FUN-680135 SMALLINT # 是否已開啟檔頭的指標
   DEFINE lc_zz011      LIKE zz_file.zz011
   DEFINE lc_zz08       LIKE zz_file.zz08 
   DEFINE lc_gap01      LIKE gap_file.gap01   # 如果有自己的 MOD-4A0180
   DEFINE lc_gap01_tmp  LIKE gap_file.gap01 
   DEFINE ls_gap01      STRING
   DEFINE lc_db         LIKE type_file.chr3   #No.FUN-680135 
   DEFINE lst_gap01     base.StringTokenizer
   DEFINE ls_module_t   STRING                # TQC-620047
 
   # 2004/04/16 產生本程式的 4tm 檔
   IF cl_null(g_gap01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   # 先組出檔案位置
   CALL fgl_getenv("TOPCONFIG") RETURNING ls_top
   IF cl_null(ls_top) THEN 
      CALL fgl_getenv("TOP") RETURNING ls_top
      LET ls_top = ls_top.trim() || "/config"
   END IF
   CALL fgl_getenv("CUSTCONFIG") RETURNING ls_topcust
   IF cl_null(ls_topcust) THEN
      CALL fgl_getenv("CUST") RETURNING ls_topcust
      LET ls_topcust = ls_topcust.trim() || "/config"
   END IF
 
   # 2004/10/12 BUG-4A0180 2005/01/14 MOD-510103
   IF g_argv3 != "empty" THEN   # AND g_argv3 != "MIS!" THEN
      LET lc_gap01 = g_argv3.trim()
#  ELSE
#     LET lc_gap01 = g_gap01 CLIPPED
   END IF
 
#  #TQC-620047
#  IF cl_null(lc_gap01) THEN
      LET lc_db=cl_db_get_database_type()
      CASE lc_db
         WHEN "ORA"
            LET lc_zz08="%",g_gap01 CLIPPED,"%"
            SELECT COUNT(*) INTO li_i1 FROM zz_file
             WHERE zz08 LIKE lc_zz08
         WHEN "IFX"
            LET lc_zz08="*",g_gap01 CLIPPED,"*"
            SELECT COUNT(*) INTO li_i1 FROM zz_file
             WHERE zz08 MATCHES lc_zz08
         WHEN "MSV"     #FUN-8C0133
            LET lc_zz08="%",g_gap01 CLIPPED,"%"
            SELECT COUNT(*) INTO li_i1 FROM zz_file
             WHERE zz08 LIKE lc_zz08
         WHEN "ASE"     #FUN-AB0041
            LET lc_zz08="%",g_gap01 CLIPPED,"%"
            SELECT COUNT(*) INTO li_i1 FROM zz_file
             WHERE zz08 LIKE lc_zz08
      END CASE
 
      IF li_i1 > 1 THEN
         IF cl_confirm("azz-239") THEN
            LET lc_gap01=""
         END IF
      END IF
#  #TQC-620047
 
   IF cl_null(lc_gap01) THEN
      IF li_i1 >= 1 THEN
         CASE lc_db
            WHEN "ORA"
               LET lc_zz08="%",g_gap01 CLIPPED,"%"
               LET ls_str="SELECT zz01 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
            WHEN "IFX"
               LET lc_zz08="*",g_gap01 CLIPPED,"*"
               LET ls_str="SELECT zz01 FROM zz_file WHERE zz08 MATCHES '",lc_zz08 CLIPPED,"' "
            WHEN "MSV"    #FUN-8C0133
               LET lc_zz08="%",g_gap01 CLIPPED,"%"
               LET ls_str="SELECT zz01 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
            WHEN "ASE"    #FUN-AB0041 
               LET lc_zz08="%",g_gap01 CLIPPED,"%"
               LET ls_str="SELECT zz01 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
         END CASE
         PREPARE p_base_com_4tmpre FROM ls_str
         DECLARE p_base_com_4tmcus CURSOR FOR p_base_com_4tmpre
         LET li_i2=0
         LET ls_gap01=""  LET lc_gap01=""
         FOREACH p_base_com_4tmcus INTO lc_gap01_tmp
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH zz01:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET li_i2 = li_i2 + 1
            IF li_i2=1 THEN
               LET lc_gap01=lc_gap01_tmp
            ELSE
               LET ls_gap01=ls_gap01.trim(),",",lc_gap01_tmp
            END IF
         END FOREACH
         LET ls_gap01=ls_gap01.subString(2,ls_gap01.getLength())
      ELSE
         RETURN  #TQC-620047
      END IF
   END IF
 
   # 2004/07/27 by saki
   SELECT zz011 INTO lc_zz011 FROM zz_file
    WHERE zz01 = lc_gap01
 
   LET lc_module = lc_zz011
   LET lc_module = lc_module.toLowerCase()
 
   IF lc_module.subString(1,1) = "c" THEN
      LET ls_filename = ls_topcust.trim() || "/4tm/" || lc_module CLIPPED || "/" || lc_gap01 CLIPPED || ".4tm"
   ELSE
      LET ls_filename = ls_top.trim() || "/4tm/" || lc_module CLIPPED || "/" || lc_gap01 CLIPPED || ".4tm"
   END IF
   display "Info 4tm name = ",ls_filename

#  LET lc_cmd = "cat /dev/null > ", ls_filename CLIPPED    #TQC-630006 #MOD-650098
#  RUN lc_cmd
   CALL cl_null_cat_to_file(ls_filename CLIPPED)           #FUN-9B0113

   LET li_openhead = FALSE
 
   FOR li_i = 1 TO g_gap.getLength()
      IF g_gap[li_i].gap05 = "Y" THEN
         LET ls_str = "    <TopMenuCommand name=\"",g_gap[li_i].gap02 CLIPPED,"\"/>"
 
         IF li_openhead = FALSE THEN
            # 2004/04/17 輸出檔頭
            LET lc_channel = base.Channel.create()
            CALL lc_channel.openFile( ls_filename CLIPPED, "a" )
            CALL lc_channel.setDelimiter("")
 
            CALL lc_channel.write("<TopMenu>")
            CALL lc_channel.write("  <TopMenuGroup text=\"Extra\">")
            LET li_openhead = TRUE
         END IF
 
         CALL lc_channel.write(ls_str)
      ELSE
         CONTINUE FOR
      END IF
   END FOR
 
   #IF li_openfile = TRUE THEN   #MOD-8B0083
   IF li_openhead = TRUE THEN   #MOD-8B0083
      CALL lc_channel.write("  </TopMenuGroup>")
      CALL lc_channel.write("</TopMenu>")
      CALL lc_channel.close()
   END IF
 
   IF NOT cl_null(ls_gap01) THEN
#     #TQC-620047
      LET ls_module_t=" SELECT zz011 FROM zz_file WHERE zz01=? "
      PREPARE p_base_act_4tm_multi FROM ls_module_t
 
      LET lst_gap01 = base.StringTokenizer.create(ls_gap01,",")
      WHILE lst_gap01.hasMoreTokens()
         LET lc_gap01_tmp=lst_gap01.nextToken()
 
         EXECUTE p_base_act_4ad_multi USING lc_gap01_tmp INTO lc_zz011
         LET ls_module_t = lc_zz011 CLIPPED
         LET ls_module_t = ls_module_t.toLowerCase()
 
         IF lc_module.subString(1,1) = "c" THEN
            LET ls_cpsource = ls_topcust.trim() || "/4tm/" || lc_module CLIPPED || "/" || lc_gap01 CLIPPED || ".4tm"
         ELSE
            LET ls_cpsource = ls_top.trim() || "/4tm/" || lc_module CLIPPED || "/" || lc_gap01 CLIPPED || ".4tm"
         END IF
 
         IF ls_module_t.subString(1,1) = "c" THEN
            LET ls_filename = ls_topcust.trim() || "/4tm/" || ls_module_t.trim() || "/" || lc_gap01_tmp CLIPPED || ".4tm"
         ELSE
            LET ls_filename = ls_top.trim() || "/4tm/" || ls_module_t.trim() || "/" || lc_gap01_tmp CLIPPED || ".4tm"
         END IF
 
         display "Info 4tm name = ",ls_filename
         LET lc_cmd = "cp ",ls_cpsource.trim()," ",ls_filename.trim()
         RUN lc_cmd
      END WHILE
   END IF
 
   RETURN
END FUNCTION
 
# 2004/08/19 詢問是否同時更新 zz04及該使用者所屬權限的 zy03
# 2004/11/19 因應 FUN-4B0029 單號,所以全部的ACTION還是要寫入zz04,比對也要
#            比zy03 
# 2005/05/02 MOD-540108 若有變更則直接更新 zz_file 資料 (前一版為新增始更新)
 
FUNCTION p_base_act_check_zz04()
 
   DEFINE lc_gap         DYNAMIC ARRAY OF RECORD
          gap02          LIKE gap_file.gap02,
          zz04_c         LIKE type_file.chr1,    #No.FUN-680135 此處僅勾選 為拆 zz04 來的
          zy03_c         LIKE type_file.chr1     #No.FUN-680135 此處僅勾選 為拆 zy03 來的
                     END RECORD
   DEFINE li_k           LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE lc_zz04        LIKE zz_file.zz04 
   DEFINE lc_zy03        LIKE zy_file.zy03 
   DEFINE lt_tokn        base.StringTokenizer
   DEFINE ls_gap02       STRING
   DEFINE li_zz04        LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE li_zz04_reduce LIKE type_file.num5     #No.FUN-680135 SMALLINT #MOD-540108
   DEFINE li_zy03        LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE lc_gap01       LIKE gap_file.gap01
 
   # 初始化 li_zz04,li_zy03
   LET li_zz04 = FALSE LET li_zz04_reduce = FALSE  #MOD-540108
   LET li_zy03 = FALSE
 
   IF cl_null(g_gap01) THEN
      IF g_action_choice <> "exit" THEN    #TQC-610018
         CALL cl_err('',-400,0)
      END IF
      RETURN li_zz04,li_zy03
   END IF
 
   CALL lc_gap.clear()
 
#  如果g_argv3 <>g_argv1, 則必為共用程式
#  MOD-510103
#  IF g_argv3!="MIS!" AND g_argv3!="empty" AND g_argv3!=g_argv1 THEN
   IF g_argv3!="empty" AND g_argv3!=g_argv1 THEN
      LET lc_gap01=g_argv3.trim()
   ELSE
      LET lc_gap01=g_gap01
   END IF
 
   DECLARE p_base_act_chk_curs CURSOR FOR
    SELECT gap02 FROM gap_file WHERE gap01=g_gap01 
     ORDER BY gap02 
 
   # 填入 gap_file
   LET li_k=1
   FOREACH p_base_act_chk_curs INTO lc_gap[li_k].gap02
      IF SQLCA.SQLCODE THEN
         RETURN li_zz04,li_zy03
      END IF
      LET lc_gap[li_k].zz04_c="N"
      LET lc_gap[li_k].zy03_c="N"
      LET li_k=li_k+1
   END FOREACH
   CALL lc_gap.deleteElement(li_k)
 
   # 選 zz04, 不可以一併選 zy03, 後詳述
   SELECT zz_file.zz04 INTO lc_zz04
     FROM zz_file
    WHERE zz_file.zz01 = lc_gap01   #g_gap01
 
   # 填入 zz_file.zz04
   LET lt_tokn = base.StringTokenizer.create(lc_zz04 CLIPPED, ",")
   WHILE lt_tokn.hasMoreTokens()
      LET ls_gap02 = lt_tokn.nextToken()
      FOR li_k=1 TO lc_gap.getLength()
         IF lc_gap[li_k].gap02 = ls_gap02.trim() THEN
            LET lc_gap[li_k].zz04_c = "Y"
            EXIT FOR
         END IF
#        #MOD-540108
         IF li_k=lc_gap.getLength() THEN
            LET li_zz04_reduce=TRUE
         END IF
      END FOR
   END WHILE
 
   # 選 zy03 不可以併同 zz04, 因為不一定執行這個工作的 user 有執行此功能的
   # 權限, 所以要分開處理, 以免影響 zz04 的選擇
   SELECT zy_file.zy03 INTO lc_zy03
     FROM zy_file
    WHERE zy_file.zy01 = g_clas AND zy_file.zy02 = lc_gap01   #g_gap01
 
   IF NOT SQLCA.SQLCODE THEN
      # 填入 zy_file.zy03
      LET lt_tokn = base.StringTokenizer.create(lc_zy03 CLIPPED, ",")
      WHILE lt_tokn.hasMoreTokens()
         LET ls_gap02 = lt_tokn.nextToken()
         FOR li_k=1 TO lc_gap.getLength()
            IF lc_gap[li_k].gap02 = ls_gap02.trim() THEN
               LET lc_gap[li_k].zy03_c = "Y"
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END IF
 
   # 檢查
   FOR li_k=1 TO lc_gap.getLength()
      IF lc_gap[li_k].zz04_c != "Y" THEN
         LET li_zz04=TRUE
#        display lc_gap[li_k].gap02,' is leaked in zz04!'
         IF lc_gap[li_k].zy03_c != "Y" THEN
            LET li_zy03=TRUE
#           display lc_gap[li_k].gap02,' is leaked in zy03!'
         END IF
      END IF
   END FOR
 
#  #MOD-540108
   IF li_zz04_reduce THEN
      LET li_zz04=TRUE
   END IF
 
   RETURN li_zz04,li_zy03
END FUNCTION
 
# 2004/11/18 MOD-490479 為了要取消 zz04_ds 的 "變更" 功能, 在此 "強制" 更新
#            zz04 資料, 並且取消沒有做 LET g_action_choice 的 Action
# 2005/05/02 MOD-540108 若有變更則直接更新 zz_file 資料 (前一版為新增始更新)
 
FUNCTION p_base_act_add_zz04(li_zy03)
 
   DEFINE lc_gap02  LIKE gap_file.gap02
   DEFINE lc_zz04   LIKE zz_file.zz04
   DEFINE li_k      LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE li_zy03   LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE li_sync   LIKE type_file.num5     #No.FUN-680135 SMALLINT #當是共用程式時,原程式權限是否跟進同步權限資料
   DEFINE lc_gap01  LIKE gap_file.gap01
   DEFINE lc_db     LIKE type_file.chr3     #No.FUN-680135 #MOD-540108
   DEFINE lc_zz08   LIKE zz_File.zz08       #MOD-540108
 
#  如果g_argv3 <>g_argv1, 則必為共用程式
#  2005/01/14 MOD-510103
#  IF g_argv3!="MIS!" AND g_argv3!="empty" AND g_argv3!=g_argv1 THEN
   IF g_argv3!="empty" AND g_argv3!=g_argv1 THEN
      LET lc_gap01=g_argv3.trim()
      IF cl_confirm("azz-073") THEN
         LET li_sync=TRUE
      ELSE
         LET li_sync=FALSE
      END IF
   ELSE
      LET lc_gap01=g_gap01
      LET li_sync=FALSE
   END IF
 
   DECLARE p_base_act_addzz04_curs CURSOR FOR
    SELECT gap02 FROM gap_file WHERE gap01=g_gap01
     ORDER BY gap02 
 
   LET lc_zz04=""
   LET li_k=1
   # 填入 gap_file
   FOREACH p_base_act_addzz04_curs INTO lc_gap02 
      IF li_k = 1 THEN
         LET lc_zz04 = lc_gap02 CLIPPED
      ELSE
         LET lc_zz04 = lc_zz04 CLIPPED,", ",lc_gap02
      END IF
      LET li_k=li_k+1
   END FOREACH
   LET lc_zz04 = lc_zz04 CLIPPED
 
   # Upate zz_file.zz04
   IF li_sync THEN
      UPDATE zz_file SET zz04=lc_zz04 WHERE zz01=lc_gap01 OR zz01=g_gap01 
      LET lc_db=cl_db_get_database_type()   #MOD-540108
      CASE lc_db
         WHEN "ORA"
            LET lc_zz08="%",g_argv1 CLIPPED,"%"
            UPDATE zz_file SET zz04=lc_zz04
             WHERE zz08 LIKE lc_zz08
         WHEN "IFX"
            LET lc_zz08="*",g_argv1 CLIPPED,"*"
            UPDATE zz_file SET zz04=lc_zz04
             WHERE zz08 MATCHES lc_zz08
         WHEN "MSV"    #FUN-8C0133
            LET lc_zz08="%",g_argv1 CLIPPED,"%"
            UPDATE zz_file SET zz04=lc_zz04
             WHERE zz08 LIKE lc_zz08
         WHEN "ASE"    #FUN-AB0041
            LET lc_zz08="%",g_argv1 CLIPPED,"%"
            UPDATE zz_file SET zz04=lc_zz04
             WHERE zz08 LIKE lc_zz08
      END CASE
   ELSE
      UPDATE zz_file SET zz04=lc_zz04 WHERE zz01=lc_gap01
   END IF
 
   # Upate zy_file.zy03 如果 zy_file 中該 user 預設群組下不存在此程式則不更新
   IF li_zy03 THEN
      IF li_sync THEN
         UPDATE zy_file SET zy03=lc_zz04
          WHERE zy01=g_clas AND (zy02=lc_gap01 OR zy02=g_gap01)
      ELSE
         UPDATE zy_file SET zy03=lc_zz04
          WHERE zy01=g_clas AND zy02=lc_gap01
      END IF
   END IF
 
   RETURN
 
END FUNCTION
 
FUNCTION p_base_act_maintain_act()
 
   DEFINE ls_action_id   STRING
   DEFINE ls_sql         STRING
   DEFINE lc_gap02       LIKE gap_file.gap02
 
   LET ls_action_id = ""
 
   # 2004/06/08 存放 prog vs action 位置改變
   LET ls_sql = " SELECT gap02 FROM gap,file ",
                 " WHERE gap01='",g_gap01 CLIPPED,"' "
 
   PREPARE p_base_act_allpre FROM ls_sql           #預備一下
   DECLARE gbd_allcurs CURSOR FOR p_base_act_allpre
 
   FOREACH gbd_allcurs INTO lc_gap02
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      ELSE
         IF NOT cl_null(lc_gap02) THEN
            LET ls_action_id = ls_action_id,", ",lc_gap02 CLIPPED
         END IF
      END IF
   END FOREACH
 
   LET ls_action_id = ls_action_id.trim()
 
   IF cl_null(ls_action_id) THEN
      CALL cl_err('',-400,0)
      RETURN
   ELSE
      LET g_msg='p_all_act "',ls_action_id,'"'
      CALL cl_cmdrun_wait(g_msg)
   END IF
 
END FUNCTION
 
## 2004/08/17 MIS後門
#FUNCTION p_base_do_all_mis(lc_type)
#
#   DEFINE lc_zz01  LIKE zz_file.zz01
#   DEFINE l_cmd    STRING
#   DEFINE lc_type  LIKE zz_file.zz01
#
#   DECLARE p_base_zz01a_curl CURSOR FOR
#      SELECT zz01 FROM zz_file WHERE 1=1 order by zz01
#   FOREACH p_base_zz01a_curl INTO lc_zz01
#
#    IF lc_zz01[1]="a" OR lc_zz01[1]="p" or lc_zz01[1]="g" or lc_zz01[1]="c" THEN
#       CASE lc_type
#          WHEN "p_help_htm"
#             LET l_cmd = "p_help_htm '" || lc_zz01 CLIPPED || "' '2'"
#             DISPLAY l_cmd
#             CALL cl_cmdrun_wait(l_cmd)
#          WHEN "p_get_act"
#             LET l_cmd = "p_get_act '" || lc_zz01 CLIPPED || "' "
#             DISPLAY l_cmd
#             CALL cl_cmdrun_unset_lang_wait(l_cmd)
#          OTHERWISE
#             EXIT FOREACH
#       END CASE
#    END IF
#   END FOREACH
#
#END FUNCTION
 
FUNCTION p_base_act_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 
 
    IF ( NOT g_before_input_done ) OR INFIELD(gap02) THEN
       CALL cl_set_comp_entry("gap02,gap04,gap05,gbd04_s,gbd05_s",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION p_base_act_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 
 
    IF (NOT g_before_input_done) OR INFIELD(gap02) THEN
       IF g_gap[l_ac].gbd06 IS NULL THEN
          CALL cl_set_comp_entry("gap04,gap05,gbd04_s,gbd05_s",FALSE)
       END IF
       IF g_gap[l_ac].gap03 <> "Y" THEN
          CALL cl_set_comp_entry("gap02",FALSE)
       END IF
    END IF
 
END FUNCTION
 
#No.FUN-660195 --start--
FUNCTION p_base_act_set_hotkey(lc_gap08)
   DEFINE   ls_value   STRING
   DEFINE   lc_start   LIKE type_file.chr1,    #No.FUN-680135 
            lc_shift   LIKE type_file.chr1,    #No.FUN-680135 
            lc_alt     LIKE type_file.chr1,    #No.FUN-680135
            lc_key     LIKE type_file.chr1     #No.FUN-680135
   DEFINE   lc_gap08   LIKE gap_file.gap08
   DEFINE   li_cnt     LIKE type_file.num5     #No.FUN-680135 
 
 
   LET lc_start = "N"
   LET lc_shift = "N"
   LET lc_alt = "N"
   LET lc_key = "A"
   IF NOT cl_null(lc_gap08) THEN
      LET lc_start = "Y"
      LET ls_value = lc_gap08
      IF ls_value.getIndexOf("Shift-",1) THEN
         LET lc_shift = "Y"
         LET ls_value = ls_value.subString(7,ls_value.getLength())
      END IF
      IF ls_value.getIndexOf("Alt-",1) THEN
         LET lc_alt = "Y"
         LET ls_value = ls_value.subString(5,ls_value.getLength())
      END IF
      LET lc_key = ls_value.toUpperCase()
   END IF
 
   OPEN WINDOW hotkey_w WITH FORM "azz/42f/p_act_hotkey"
      ATTRIBUTES(STYLE="create_qry")
   CALL cl_ui_locale("p_act_hotkey")
 
   INPUT lc_start,lc_shift,lc_alt,lc_key WITHOUT DEFAULTS 
    FROM FORMONLY.start_v,FORMONLY.shift_v,FORMONLY.alt_v,FORMONLY.key_v
      BEFORE INPUT
         IF lc_start = "Y" THEN
            CALL cl_set_comp_entry("shift_v,alt_v,key_v",TRUE)
         ELSE
            CALL cl_set_comp_entry("shift_v,alt_v,key_v",FALSE)
         END IF
 
      ON CHANGE start_v
         IF lc_start = "Y" THEN
            CALL cl_set_comp_entry("shift_v,alt_v,key_v",TRUE)
         ELSE
            CALL cl_set_comp_entry("shift_v,alt_v,key_v",FALSE)
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET lc_gap08 = g_gap[l_ac].gap08
            EXIT INPUT
         END IF
         IF lc_start = "Y" THEN
            IF lc_shift = "N" AND lc_alt = "N" THEN
               CALL cl_err("","azz-729",0)
               NEXT FIELD shift_v
            END IF
            LET ls_value = ""
            IF lc_shift = "Y" THEN
               LET ls_value = "Shift-"
            END IF
            IF lc_alt = "Y" THEN
               LET ls_value = ls_value,"Alt-"
            END IF
            LET ls_value = ls_value,DOWNSHIFT(lc_key)
            LET lc_gap08 = ls_value
 
            IF NOT cl_null(lc_gap08) THEN
               SELECT COUNT(*) INTO li_cnt FROM gap_file
                WHERE gap01 = g_gap01 AND gap08 = lc_gap08 AND gap02 != g_gap[l_ac].gap02
               IF li_cnt > 0 THEN
                  CALL cl_err(g_gap[l_ac].gap08,"azz-730",0)
                  NEXT FIELD shift_v
               END IF
            END IF
         ELSE
            LET lc_gap08 = ""
         END IF
 
      ON IDLE g_idle_seconds  #FUN-860033
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE WINDOW hotkey_w
 
   RETURN lc_gap08
END FUNCTION
#No.FUN-660195 ---end---
