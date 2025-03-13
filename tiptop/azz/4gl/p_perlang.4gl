# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_perlang.4gl
# Descriptions...: 畫面元件顯示多語言設定作業
# Date & Author..: 03/12/04 saki  
# Modify.........: 04/03/06 拆 gae_file 成為 gae + gav
# Modify.........: 04/08/11 增加gae11
# Modify.........: 04/08/11 saki 增加gav08 客製欄位
# Modify.........: No.MOD-490456 04/09/29 修正 count 數量
# Modify.........: No.MOD-4A0311 04/10/25 By Carol 複製時按放棄時無法結束離開複製的功能,回到主功能表
# Modify.........: No.FUN-4A0088 04/11/04 By Smapmin 單頭加秀程式說明
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0020 04/12/08 By Smapmin 允許原先不存在的值被複製
# Modify.........: No.FUN-4C0107 05/01/03 By alex 增加修改 wintitle 功能
# Modify.........: No.MOD-440464 05/02/14 By saki 增加log功能
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.FUN-710055 07/01/23 By saki 自定義欄位設定功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.FUN-760049 07/06/20 By saki 行業別代碼更動
# Modify.........: No.FUN-750068 07/07/06 By saki 行業別選項改由lib製作
# Modify.........: No.FUN-7B0081 07/11/14 By alex gae05搬至gbs_file
# Modify.........: No.MOD-810259 08/01/14 By alex 行業別選項串接參數增加
# Modify.........: No.TQC-880038 08/08/22 By clover p_cron 新增欄位對照
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90139 11/09/29 By tsai_yen 檢查簡繁字串
# Modify.........: No:FUN-BA0011 11/10/05 By jrg542 當資料進行調整時，也視為重要資料異動，個別均須留下紀錄於系統層級 LOG
# Modify.........: No:FUN-BA0116 11/10/31 By joyce 新增繁簡體資料轉換action
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gae01          LIKE gae_file.gae01,   # 類別代號 (假單頭)
         g_gae01_t        LIKE gae_file.gae01,   # 類別代號 (假單頭)
         g_gaz03          LIKE gaz_file.gaz03,   # 程式說明 (假單頭)  #FUN-4A0088
         g_gae11          LIKE gae_file.gae11,   # 類別代號 (假單頭)
         g_gae11_t        LIKE gae_file.gae11,   # 類別代號 (假單頭)
         g_gae12          LIKE gae_file.gae12,   # No.FUN-710055
         g_gae12_t        LIKE gae_file.gae12,   # No.FUN-710055
         g_gae_lock RECORD LIKE gae_file.*,      # FOR LOCK CURSOR TOUCH
         g_gae    DYNAMIC ARRAY of RECORD        # 程式變數
            gae02          LIKE gae_file.gae02,
            gae03          LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gae10          LIKE gae_file.gae10,
#           gae05          LIKE gae_file.gae05   #FUN-7B0081
            gbs06          LIKE gbs_file.gbs06
                      END RECORD,
         g_gae_t           RECORD                 # 變數舊值
            gae02          LIKE gae_file.gae02,
            gae03          LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gae10          LIKE gae_file.gae10,
#           gae05          LIKE gae_file.gae05    #FUN-7B0081
            gbs06          LIKE gbs_file.gbs06
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  STRING,  #No.FUN-580092 HCN
         g_sql                 STRING,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
         g_rec_b               LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE gae_file.gae01
DEFINE   g_argv2               LIKE gae_file.gae11     #MOD-810259
DEFINE   g_argv3               LIKE gae_file.gae12     #MOD-810259
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_no_ask              LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_std_id              LIKE smb_file.smb01     #No.FUN-710055
DEFINE   g_db_type             LIKE type_file.chr3     #No.FUN-760049
 
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = UPSHIFT(ARG_VAL(2))    #MOD-810259
   LET g_argv3 = DOWNSHIFT(ARG_VAL(3))  #MOD-810259
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
   LET g_gae01_t = NULL
   LET g_gae11_t = NULL
   LET g_gae12_t = NULL      #No.FUN-710055
 
   #一般行業別代碼
#  SELECT smb01 INTO g_std_id FROM smb_file WHERE smb02="0" AND smb05="Y"  #No.FUN-760049 mark
   LET g_std_id = "std"            #No.FUN-760049
 
   OPEN WINDOW p_perlang_w WITH FORM "azz/42f/p_perlang"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gae03")
 
   # No.FUN-760049 行業別選項
#  CALL p_perlang_set_combobox()
   CALL cl_set_combo_industry("gae12")    #No.FUN-750068
   LET g_db_type=cl_db_get_database_type()   #No.FUN-760049
 
   LET g_forupd_sql =" SELECT * FROM gae_file ",  
                      "  WHERE gae01 = ? AND gae11 = ? AND gae12 = ? ",  #No.FUN-710055
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_perlang_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_perlang_q()
   END IF
 
   CALL p_perlang_menu() 
 
   CLOSE WINDOW p_perlang_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_perlang_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_gae.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "gae01 = '",g_argv1 CLIPPED,"' "
      IF NOT cl_null(g_argv2) THEN             #MOD-810259
         LET g_wc = g_wc," AND gae11 = '",g_argv2 CLIPPED,"' "
         IF NOT cl_null(g_argv3) THEN
            LET g_wc = g_wc," AND gae12 = '",g_argv3 CLIPPED,"' "
         END IF
      END IF
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
 
      CONSTRUCT g_wc ON gae01,gae11,gae12,gae02,gae03,gae04,gae10,gbs06  #No.FUN-710055
                   FROM gae01,gae11,gae12,s_gae[1].gae02, s_gae[1].gae03,#No.FUN-710055
                        s_gae[1].gae04, s_gae[1].gae10,s_gae[1].gbs06
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(gae01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gae01
                  NEXT FIELD gae01
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   #No.FUN-760049 --start--
#  LET g_sql= "SELECT UNIQUE gae01,gae11,gae12 FROM gae_file ",   #No.FUN-710055
#             " WHERE ", g_wc CLIPPED,
#             " GROUP BY gae01,gae11,gae12 ORDER BY gae01"        #No.FUN-710055
 
   IF g_wc.getIndexOf("gbs06",1) THEN   #FUN-7B0081
      IF g_db_type = "ORA" THEN
         LET g_sql=" SELECT UNIQUE gae01,gae11,gae12 FROM gae_file,OUTER gbs_file ",
                    " WHERE ",g_wc CLIPPED,
                      " AND gae01 = gbs01 ",
                      " AND gae02 = gbs02 ",
                      " AND gae03 = gbs03 ",
                      " AND gae11 = gbs04 ",
                      " AND gae12 = gbs05 ",
                    " GROUP BY gae01,gae11,gae12",
                    " ORDER BY gae01,gae11,DECODE(gae12,'std','1',gae12)"
      ELSE
         LET g_sql=" SELECT UNIQUE gae01,gae11,gae12 FROM gae_file,OUTER gbs_file ",   #No.FUN-710055
                    " WHERE ", g_wc CLIPPED,
                      " AND gae01 = gbs01 ",
                      " AND gae02 = gbs02 ",
                      " AND gae03 = gbs03 ",
                      " AND gae11 = gbs04 ",
                      " AND gae12 = gbs05 ",
                    " GROUP BY gae01,gae11,gae12 ORDER BY gae01"        #No.FUN-710055
      END IF
   ELSE
      IF g_db_type = "ORA" THEN
         LET g_sql=" SELECT UNIQUE gae01,gae11,gae12 FROM gae_file ",
                    " WHERE ",g_wc CLIPPED," GROUP BY gae01,gae11,gae12",
                    " ORDER BY gae01,gae11,DECODE(gae12,'std','1',gae12)"
      ELSE
         LET g_sql=" SELECT UNIQUE gae01,gae11,gae12 FROM gae_file ",   #No.FUN-710055
                    " WHERE ", g_wc CLIPPED,
                    " GROUP BY gae01,gae11,gae12 ORDER BY gae01"        #No.FUN-710055
      END IF
   END IF
   PREPARE p_perlang_prepare FROM g_sql          # 預備一下
   DECLARE p_perlang_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_perlang_prepare
 
END FUNCTION
 
 # 2004/09/29 MOD-490456 選出筆數直接寫入 g_row_count
FUNCTION p_perlang_count()
 
   DEFINE la_gae   DYNAMIC ARRAY of RECORD        # 程式變數
            gae01          LIKE gae_file.gae01,
            gae11          LIKE gae_file.gae11,
            gae12          LIKE gae_file.gae12    #No.FUN-710055
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b LIKE type_file.num10   #FUN-680135 INTEGER
 
   IF g_wc.getIndexOf("gbs06",1) THEN   #FUN-7B0081
   LET g_sql= "SELECT UNIQUE gae01,gae11,gae12 FROM gae_file,OUTER gbs_file ",  #No.FUN-710055
              " WHERE ", g_wc CLIPPED,
                " AND gae01 = gbs01 ",
                " AND gae02 = gbs02 ",
                " AND gae03 = gbs03 ",
                " AND gae11 = gbs04 ",
                " AND gae12 = gbs05 ",
              " GROUP BY gae01,gae11,gae12 ORDER BY gae01"       #No.FUN-710055
   ELSE
   LET g_sql= "SELECT UNIQUE gae01,gae11,gae12 FROM gae_file ",  #No.FUN-710055
              " WHERE ", g_wc CLIPPED,
              " GROUP BY gae01,gae11,gae12 ORDER BY gae01"       #No.FUN-710055
   END IF
 
   PREPARE p_perlang_precount FROM g_sql
   DECLARE p_perlang_count CURSOR FOR p_perlang_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH p_perlang_count INTO g_gae[li_cnt].*  
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b
 
END FUNCTION
 
FUNCTION p_perlang_menu()
 
   WHILE TRUE
      CALL p_perlang_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_perlang_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_perlang_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_perlang_copy()
            END IF
#        WHEN "delete"                          # R.取消
#           IF cl_chk_act_auth() THEN
#              CALL p_perlang_r()
#           END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_perlang_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_perlang_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gae),'','')
            END IF
 
          WHEN "showlog"           #MOD-440464
            IF cl_chk_act_auth() THEN
               CALL cl_show_log("p_perlang")
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_perlang_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gae.clear()
 
   INITIALIZE g_gae01 LIKE gae_file.gae01         # 預設值及將數值類變數清成零
   INITIALIZE g_gaz03 LIKE gaz_file.gaz03         # 預設值及將數值類變數清成零
   INITIALIZE g_gae11 LIKE gae_file.gae11
   INITIALIZE g_gae12 LIKE gae_file.gae12         #No.FUN-710055
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_gae11 = "N"
      LET g_gae12 = g_std_id                      #No.FUN-710055
      CALL p_perlang_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_gae01=NULL
         LET g_gaz03=NULL
         LET g_gae11=NULL
         LET g_gae12=NULL                         #No.FUN-710055
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_gae.clear()
      ELSE
         CALL p_perlang_b_fill('1=1')             # 單身
      END IF
 
      CALL p_perlang_b()                          # 輸入單身
      LET g_gae01_t=g_gae01
      LET g_gae11_t=g_gae11
      LET g_gae12_t=g_gae12                       #No.FUN-710055
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_perlang_i(p_cmd)                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5    #FUN-680135 SMALLINT
 
   LET g_ss = 'Y'
 
   DISPLAY g_gae01,g_gae11,g_gaz03,g_gae12 TO gae01,gae11,gaz03,gae12    #No.FUN-710055
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_gae01,g_gae11,g_gae12 WITHOUT DEFAULTS FROM gae01,gae11,gae12 #No.FUN-710055
 
      AFTER INPUT
         IF NOT cl_null(g_gae01) THEN
            IF g_gae01 != g_gae01_t OR cl_null(g_gae01_t) THEN
               SELECT COUNT(UNIQUE gae01) INTO g_cnt FROM gae_file
                WHERE gae01 = g_gae01 AND gae11 = g_gae11 AND gae12 = g_gae12   #No.FUN-710055
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gae01,-239,0)
                     LET g_gae01 = g_gae01_t
                     NEXT FIELD gae01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gae01,g_errno,0)
                  NEXT FIELD gae01
               END IF
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gae01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1= g_gae01
               CALL cl_create_qry() RETURNING g_gae01
               NEXT FIELD gae01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION modify_program_name
         # 2005/01/04 主程式及特殊需要而定義的元件資料不可設定 wintitle
         LET l_count = 0
         SELECT count(*) INTO l_count FROM zz_file WHERE zz01=g_gae01
         IF l_count > 0 OR g_gae01='TopMenuGroup' OR g_gae01='TopProgGroup' THEN
            CALL cl_err(g_gae01,"azz-079",1) 
         ELSE
            CALL p_gae_wintitle(g_gae01,g_gae12)
         END IF
 
   END INPUT
END FUNCTION
 
 
FUNCTION p_perlang_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gae01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gae01_t = g_gae01
   LET g_gae11_t = g_gae11
   LET g_gae12_t = g_gae12    #No.FUN-710055
 
   BEGIN WORK
   OPEN p_perlang_lock_u USING g_gae01,g_gae11,g_gae12   #No.FUN-710055
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_perlang_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_perlang_lock_u INTO g_gae_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gae01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_perlang_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_perlang_i("u")
      IF INT_FLAG THEN
         LET g_gae01 = g_gae01_t
         LET g_gae11 = g_gae11_t
         LET g_gae12 = g_gae12_t       #No.FUN-710055
         DISPLAY g_gae01,g_gae11,g_gae12 TO gae01,gae11,gae12   #No.FUN-710055
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gae_file SET gae01 = g_gae01, gae11 = g_gae11, gae12 = g_gae12   #No.FUN-710055
       WHERE gae01 = g_gae01_t
          AND gae11 = g_gae11_t                #MOD-4A0011
          AND gae12 = g_gae12_t                #No.FUN-710055
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_gae01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","gae_file",g_gae01_t,g_gae11_t,SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      ELSE                         #FUN-7B0081
         UPDATE gbs_file SET gbs01=g_gae01, gbs04=g_gae11, gbs05=g_gae12
          WHERE gbs01 = g_gae01_t
            AND gbs04 = g_gae11_t
            AND gbs05 = g_gae12_t
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_perlang_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   CALL g_gae.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_perlang_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_perlang_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gae01 TO NULL
      INITIALIZE g_gaz03 TO NULL
      INITIALIZE g_gae11 TO NULL
      INITIALIZE g_gae12 TO NULL                 #No.FUN-710055
      LET g_gaz03 = ""
   ELSE
#     OPEN p_perlang_count
#     FETCH p_perlang_count INTO g_row_count
      CALL p_perlang_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_perlang_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_perlang_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式     #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10         #絕對的筆數   #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_perlang_b_curs INTO g_gae01,g_gae11,g_gae12   #No.FUN-710055
      WHEN 'P' FETCH PREVIOUS p_perlang_b_curs INTO g_gae01,g_gae11,g_gae12   #No.FUN-710055
      WHEN 'F' FETCH FIRST    p_perlang_b_curs INTO g_gae01,g_gae11,g_gae12   #No.FUN-710055
      WHEN 'L' FETCH LAST     p_perlang_b_curs INTO g_gae01,g_gae11,g_gae12   #No.FUN-710055
      WHEN '/' 
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_perlang_b_curs INTO g_gae01,g_gae11,g_gae12   #No.FUN-710055
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gae01,SQLCA.sqlcode,0)
      INITIALIZE g_gae01 TO NULL  #TQC-6B0105
      INITIALIZE g_gae11 TO NULL  #TQC-6B0105
      INITIALIZE g_gae12 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL p_perlang_show()
   END IF
END FUNCTION
 
#FUN-4A0088
FUNCTION p_perlang_show()                         # 將資料顯示在畫面上
   CALL p_perlang_gaz03()
   DISPLAY g_gae01,g_gae11,g_gaz03,g_gae12 TO gae01,gae11,gaz03,gae12  #No.FUN-710055
   CALL p_perlang_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION p_perlang_gaz03()
 
   DEFINE l_count  LIKE type_file.num5    #FUN-680135 SMALLINT
 
   LET g_gaz03 = ""
   LET l_count = 0
 
   SELECT count(*) INTO l_count FROM zz_file WHERE zz01=g_gae01
 
   IF l_count > 0 THEN
      SELECT gaz03 INTO g_gaz03 FROM gaz_file
       WHERE gaz01=g_gae01 AND gaz02=g_lang AND gaz05="Y"
      IF cl_null(g_gaz03) THEN
        SELECT gaz03 INTO g_gaz03 FROM gaz_file
         WHERE gaz01=g_gae01 AND gaz02=g_lang AND gaz05="N"
      END IF
   ELSE
      SELECT gae04 INTO g_gaz03 FROM gae_file
       WHERE gae01=g_gae01 AND gae02='wintitle' AND gae03=g_lang AND gae11="Y" AND gae12=g_gae12  #No.FUN-710055
      IF cl_null(g_gaz03) THEN
        SELECT gae04 INTO g_gaz03 FROM gae_file
         WHERE gae01=g_gae01 AND gae02='wintitle' AND gae03=g_lang AND gae11="N" AND gae12=g_gae12 #No.FUN-710055
      END IF
   END IF
 
   IF g_gae01='TopMenuGroup' THEN
      LET g_gaz03='Common Items For TOP Menu'
   END IF
 
   IF g_gae01='TopProgGroup' THEN
      LET g_gaz03='Program Items For TOP Menu'
   END IF
 
END FUNCTION
#FUN-4A0088(end)
 
 
FUNCTION p_perlang_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gae   RECORD LIKE gae_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gae01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gae_file
       WHERE gae01 = g_gae01 AND gae11 = g_gae11 AND gae12 = g_gae12  #No.FUN-710055
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","gae_file",g_gae01,g_gae11,SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         DELETE FROM gbs_file   #FUN-7B0081
          WHERE gbs01= g_gae01 AND gbs04= g_gae11 AND gbs05= g_gae12
         CLEAR FORM
         CALL g_gae.clear()
#        OPEN p_perlang_count
#        FETCH p_perlang_count INTO g_row_count
         CALL p_perlang_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_perlang_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_perlang_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL p_perlang_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_perlang_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_cnt           LIKE type_file.num5,               # FUN-7B0081
            l_gau01         LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
   DEFINE   l_count         LIKE type_file.num5                #FUN-680135    SMALLINT
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   li_i            LIKE type_file.num5                # 暫存用數值   # No:FUN-BA0116
   DEFINE   lc_target       LIKE gay_file.gay01                # No:FUN-BA0116
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gae01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
#  LET g_forupd_sql= "SELECT gae02,gae03,gae04,gae10,gae05 ",    #FUN-7B0081
 
   LET g_forupd_sql= "SELECT gae02,gae03,gae04,gae10,'' ",
                     "  FROM gae_file ",
                     "  WHERE gae01 = ? AND gae02 = ? AND gae03 = ? ",
                       " AND gae11 = ? AND gae12 = ? ",    #No.FUN-710055
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_perlang_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gae WITHOUT DEFAULTS FROM s_gae.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gae_t.* = g_gae[l_ac].*    #BACKUP
            OPEN p_perlang_bcl USING g_gae01,g_gae_t.gae02,g_gae_t.gae03,g_gae11,g_gae12  #No.FUN-710055
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_perlang_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_perlang_bcl INTO g_gae[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_perlang_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE   #FUN-7B0081
                  SELECT gbs06 INTO g_gae[l_ac].gbs06 FROM gbs_file
                   WHERE gbs01 = g_gae01 AND gbs02 = g_gae[l_ac].gae02
                     AND gbs03 = g_gae[l_ac].gae03
                     AND gbs04 = g_gae11 AND gbs05 = g_gae12
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         IF g_gae[l_ac].gae02 = 'wintitle' THEN
            CALL cl_set_comp_entry("gae04",FALSE)
         ELSE
            CALL cl_set_comp_entry("gae04",TRUE)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gae[l_ac].* TO NULL       #900423
         LET g_gae_t.* = g_gae[l_ac].*          #新輸入資料
         LET g_gae[l_ac].gae10 = g_today 
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gae02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
#       #INSERT INTO gae_file(gae01,gae02,gae03,gae04,gae05,gae10,gae11,gae12) #FUN-7B0081
#       #             VALUES (g_gae01,g_gae[l_ac].gae02,g_gae[l_ac].gae03,
#       #                     g_gae[l_ac].gae04,g_gae[l_ac].gae05,
#       #                     g_gae[l_ac].gae10,g_gae11,g_gae12)   #No.FUN-710055
 
         INSERT INTO gae_file(gae01,gae02,gae03,gae04,gae10,gae11,gae12)
                      VALUES (g_gae01,g_gae[l_ac].gae02,g_gae[l_ac].gae03,
                              g_gae[l_ac].gae04,g_gae[l_ac].gae10,g_gae11,g_gae12)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gae01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gae_file",g_gae01,g_gae[l_ac].gae02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            IF NOT cl_null(g_gae[l_ac].gbs06) THEN       #FUN-7B0081
               INSERT INTO gbs_file(gbs01,gbs02,gbs03,gbs04,gbs05,gbs06)
                         VALUES (g_gae01,g_gae[l_ac].gae02,g_gae[l_ac].gae03,
                                 g_gae11,g_gae12,g_gae[l_ac].gbs06)
            END IF
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            #No.FUN-BA0011 ---start
            LET ls_msg_n = g_gae01 CLIPPED,"",g_gae[l_ac].gae02 CLIPPED,"",
                                g_gae[l_ac].gae03 CLIPPED,"",g_gae[l_ac].gae04 CLIPPED,"",
                                g_gae[l_ac].gbs06 CLIPPED,"",g_gae[l_ac].gae10 CLIPPED,"",
                                g_gae11 CLIPPED,"",g_gae12 CLIPPED   
            LET ls_msg_o = ""   
            CALL cl_log("p_perlang","I",ls_msg_n,ls_msg_o) 
            #No.FUN-BA0011 ---end
         END IF
 
      BEFORE FIELD gae02
         CALL cl_set_comp_entry("gae04",TRUE)
 
      AFTER FIELD gae02
         IF g_gae[l_ac].gae02 = 'wintitle' THEN
            LET l_count = 0
            SELECT count(*) INTO l_count FROM zz_file WHERE zz01=g_gae01
            IF l_count > 0 OR g_gae01='TopMenuGroup' OR g_gae01='TopProgGroup' THEN
               CALL cl_err(g_gae[l_ac].gae02,"azz-079",1)
               NEXT FIELD gae02
            END IF
            IF p_cmd <> 'a' THEN   # 新增時, 准, 修改, 不准
               CALL cl_set_comp_entry("gae04",FALSE)
            END IF
         END IF
 
      AFTER FIELD gae03
         IF NOT cl_null(g_gae[l_ac].gae02) AND
            NOT cl_null(g_gae[l_ac].gae03) THEN
            # 檢視目前欲變更的是否為 Key Realtion 中的主鍵值 Primary Key
            # gau01, 若有則出現註記入 l_gau01
            SELECT COUNT(*) INTO l_gau01 FROM gau_file
             WHERE gau01 = g_gae[l_ac].gae02
            IF STATUS THEN
               LET l_gau01 = 0
            END IF
            IF g_gae[l_ac].gae02 != g_gae_t.gae02 OR g_gae_t.gae02 IS NULL THEN
               # 檢視 gae_file 中同一 Program Name (gae01) 下是否有相同的
               # Filed Name (gae02)
               SELECT COUNT(*) INTO l_n FROM gae_file
                WHERE gae01 = g_gae01 AND gae11 = g_gae11 AND gae12 = g_gae12   #No.FUN-710055
                  AND gae02 = g_gae[l_ac].gae02 AND gae03 = g_gae[l_ac].gae03
               IF l_n > 0 THEN
                  CALL cl_err(g_gae[l_ac].gae02,-239,0)
                  LET g_gae[l_ac].gae03 = g_gae_t.gae03
                  NEXT FIELD gae03
               ELSE
                  IF l_gau01 > 0 THEN 
                     IF p_cmd='a' THEN
                        CALL cl_err(g_gae[l_ac].gae03,"azz-080",1)
                     ELSE 
                        CALL cl_err(g_gae[l_ac].gae03,"azz-081",1)
                     END IF
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD gae04
         IF NOT cl_null(g_gae[l_ac].gae04) THEN
            ###FUN-B90139 START ###
            IF NOT cl_unicode_check02(g_gae[l_ac].gae03, g_gae[l_ac].gae04,"1") THEN
               NEXT FIELD gae04
            ELSE
            ###FUN-B90139 END ###
              IF g_gae[l_ac].gae04 != g_gae_t.gae04 AND l_gau01 > 0 THEN
           
                # 2004/03/05 暫時 mark
                #           IF NOT p_perlang_chk_gau("0") THEN
                #              CALL cl_err("gau04 CHANGING,RUN p_keyrelat!","!",1)
                #           END IF
              END IF
            END IF   #FUN-B90139
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gae_t.gae02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err(g_gae[l_ac].gae02,"azz-082",1)
            END IF
            DELETE FROM gae_file WHERE gae01 = g_gae01
                                   AND gae02 = g_gae[l_ac].gae02
                                   AND gae03 = g_gae[l_ac].gae03
                                   AND gae11 = g_gae11
                                   AND gae12 = g_gae12             #No.FUN-710055
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gae_t.gae02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gae_file",g_gae01,g_gae_t.gae02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            ELSE      #FUN-7B0081
               DELETE FROM gbs_file
                WHERE gbs01 = g_gae01            AND gbs02 = g_gae[l_ac].gae02
                  AND gbs03 = g_gae[l_ac].gae03  AND gbs04 = g_gae11
                  AND gbs05 = g_gae12
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
         #No.FUN-BA0011 ---start
         MESSAGE 'DELETE O.K'
         LET ls_msg_n = g_gae01 CLIPPED,"",g_gae[l_ac].gae02 CLIPPED,"",
                              g_gae[l_ac].gae03 CLIPPED,"",g_gae[l_ac].gae04 CLIPPED,"",
                              g_gae[l_ac].gbs06 CLIPPED,"",g_gae[l_ac].gae10 CLIPPED,"",
                              g_gae11 CLIPPED,"",g_gae12 CLIPPED   
         LET ls_msg_o = g_gae01 CLIPPED,"",g_gae_t.gae02 CLIPPED,"",
                              g_gae_t.gae03 CLIPPED,"",g_gae_t.gae04 CLIPPED,"",
                              g_gae_t.gbs06 CLIPPED,"",g_gae_t.gae10 CLIPPED,"",
                              g_gae11 CLIPPED,"",g_gae12 CLIPPED   
         CALL cl_log("p_perlang","D",ls_msg_n,ls_msg_o) 
         #No.FUN-BA0011 ---end
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gae[l_ac].* = g_gae_t.*
            CLOSE p_perlang_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("g_gae[l_ac].gae02","azz-083",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gae[l_ac].gae02,-263,1)
            LET g_gae[l_ac].* = g_gae_t.*
         ELSE
            LET g_gae[l_ac].gae10 = g_today 
            UPDATE gae_file
               SET gae02 = g_gae[l_ac].gae02,
                   gae03 = g_gae[l_ac].gae03,
                   gae04 = g_gae[l_ac].gae04,
                 # gae05 = g_gae[l_ac].gae05,  #FUN-7B0081
                   gae10 = g_gae[l_ac].gae10
             WHERE gae01 = g_gae01
               AND gae02 = g_gae_t.gae02
               AND gae03 = g_gae_t.gae03
               AND gae11 = g_gae11
               AND gae12 = g_gae12             #No.FUN-710055
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gae[l_ac].gae02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gae_file",g_gae01,g_gae_t.gae02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gae[l_ac].* = g_gae_t.*
            ELSE
               IF NOT cl_null(g_gae[l_ac].gbs06) THEN    #FUN-7B0081
                  SELECT COUNT(*) INTO l_cnt FROM gbs_file
                   WHERE gbs01 = g_gae01       AND gbs02 = g_gae_t.gae02
                     AND gbs03 = g_gae_t.gae03 AND gbs04 = g_gae11
                     AND gbs05 = g_gae12
                  IF l_cnt >= 1 THEN
                     UPDATE gbs_file
                        SET gbs02 = g_gae[l_ac].gae02,
                            gbs03 = g_gae[l_ac].gae03,
                            gbs06 = g_gae[l_ac].gbs06
                      WHERE gbs01 = g_gae01       AND gbs02 = g_gae_t.gae02
                        AND gbs03 = g_gae_t.gae03 AND gbs04 = g_gae11
                        AND gbs05 = g_gae12
                  ELSE
                     INSERT INTO gbs_file(gbs01,gbs02,gbs03,gbs04,gbs05,gbs06)
                     VALUES (g_gae01,g_gae[l_ac].gae02,g_gae[l_ac].gae03,
                             g_gae11,g_gae12,g_gae[l_ac].gbs06)
                  END IF
               ELSE
                  DELETE FROM gbs_file
                   WHERE gbs01 = g_gae01       AND gbs02 = g_gae_t.gae02
                     AND gbs03 = g_gae_t.gae03 AND gbs04 = g_gae11
                     AND gbs05 = g_gae12
               END IF
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               LET ls_msg_n = g_gae01 CLIPPED,"",g_gae[l_ac].gae02 CLIPPED,"",
                              g_gae[l_ac].gae03 CLIPPED,"",g_gae[l_ac].gae04 CLIPPED,"",
                              g_gae[l_ac].gbs06 CLIPPED,"",g_gae[l_ac].gae10 CLIPPED,"",
                              g_gae11 CLIPPED,"",g_gae12 CLIPPED   #No.FUN-710055
               LET ls_msg_o = g_gae01 CLIPPED,"",g_gae_t.gae02 CLIPPED,"",
                              g_gae_t.gae03 CLIPPED,"",g_gae_t.gae04 CLIPPED,"",
                              g_gae_t.gbs06 CLIPPED,"",g_gae_t.gae10 CLIPPED,"",
                              g_gae11 CLIPPED,"",g_gae12 CLIPPED   #No.FUN-710055
                CALL cl_log("p_perlang","U",ls_msg_n,ls_msg_o)            # MOD-440464
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac         #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gae[l_ac].* = g_gae_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_gae.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_perlang_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac         #FUN-D30034 add
         CLOSE p_perlang_bcl
         COMMIT WORK
 
      # No:FUN-BA0116 ---start---
      ON ACTION translate_zhtw
         LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE
            WHEN g_gae[l_ac].gae03 = "0" LET lc_target = "2"
            WHEN g_gae[l_ac].gae03 = "2" LET lc_target = "0"
         END CASE

         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO g_gae.getLength()
            IF li_i = l_ac THEN CONTINUE FOR END IF
            # gae01、gae11、gae12欄位屬單頭資料，不列在單身ARRAY中
            IF g_gae[li_i].gae02 = g_gae[l_ac].gae02 AND
               g_gae[li_i].gae03 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(gae04)
                     LET g_gae[l_ac].gae04 = cl_trans_utf8_twzh(g_gae[l_ac].gae03,g_gae[li_i].gae04)
                     DISPLAY g_gae[l_ac].gae04 TO gae04
                     EXIT FOR
               END CASE
            END IF
         END FOR
      # No:FUN-BA0116 --- end ---

      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gae02) AND l_ac > 1 THEN
            LET g_gae[l_ac].* = g_gae[l_ac-1].*
            NEXT FIELD gae02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gae04)
               CALL s_keyrelat(g_gae[l_ac].gae04,g_gae[l_ac].gae03,g_gae[l_ac].gae02)
                    RETURNING g_gae[l_ac].gae04
               DISPLAY g_gae[l_ac].gae04 TO gae04
               NEXT FIELD gae04
 
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------     
 
   END INPUT
 
   CLOSE p_perlang_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_perlang_chk_gau(p_lang)
   DEFINE p_lang LIKE type_file.chr1    #FUN-680135 VARCHAR(1)
   DEFINE p_ac   LIKE type_file.num5    #FUN-680135 SMALLINT
   CASE p_lang
      WHEN "0" SELECT COUNT(*) INTO p_ac FROM gau_file
                WHERE gau01=g_gae[l_ac].gae03
                  AND gau03=g_gae[l_ac].gae04
   END CASE
   IF p_ac > 0 THEN  #有就是一樣
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION
 
FUNCTION p_perlang_b_fill(p_wc)               #BODY FILL UP
 
   DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(300)
 
#   LET g_sql = "SELECT gae02,gae03,gae04,gae10,gae05 ",   #FUN-7B0081
#                " FROM gae_file ",
#               " WHERE gae01 = '",g_gae01 CLIPPED,"' ",
#                 " AND gae11 = '",g_gae11 CLIPPED,"' ",
#                 " AND gae12 = '",g_gae12 CLIPPED,"' ",   #No.FUN-710055
#                 " AND ",p_wc CLIPPED,
#               " ORDER BY gae02,gae03"
 
    LET g_sql = "SELECT gae02,gae03,gae04,gae10,'' ",
                 " FROM gae_file ",
                " WHERE gae01 = '",g_gae01 CLIPPED,"' ",
                  " AND gae11 = '",g_gae11 CLIPPED,"' ",
                  " AND gae12 = '",g_gae12 CLIPPED,"' ",   #No.FUN-710055
                  " AND ",p_wc CLIPPED,
                " ORDER BY gae02,gae03"
 
    PREPARE p_perlang_prepare2 FROM g_sql           #預備一下
    DECLARE gae_curs CURSOR FOR p_perlang_prepare2
 
    CALL g_gae.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gae_curs INTO g_gae[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          SELECT gbs06 INTO g_gae[g_cnt].gbs06 FROM gbs_file
           WHERE gbs01 = g_gae01 
             AND gbs02 = g_gae[g_cnt].gae02 
             AND gbs03 = g_gae[g_cnt].gae03
             AND gbs04 = g_gae11 
             AND gbs05 = g_gae12
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gae.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_perlang_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gae TO s_gae.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice='reproduce'
         EXIT DISPLAY
 
#     ON ACTION delete                           # R.取消
#        LET g_action_choice='delete'
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_perlang_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_perlang_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_perlang_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_perlang_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_perlang_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
#        CALL p_perlang_set_combobox()              #No.FUN-760049
         CALL cl_set_combo_industry("gae12")        #No.FUN-750068
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("gae03")
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       ON ACTION showlog             #MOD-440464
         LET g_action_choice = "showlog"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_perlang_copy()
   DEFINE   l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_new01   LIKE gae_file.gae01,
            l_new11   LIKE gae_file.gae11,
            l_new12   LIKE gae_file.gae12,          #No.FUN-710055
            l_old01   LIKE gae_file.gae01,
            l_old11   LIKE gae_file.gae11,
            l_old12   LIKE gae_file.gae12           #No.FUN-710055
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_gae01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_new01,l_new11,l_new12 WITHOUT DEFAULTS FROM gae01,gae11,gae12   #No.FUN-710055
 
      AFTER INPUT
 #MOD-4A0311 add
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
##
         IF cl_null(l_new01) THEN
            NEXT FIELD gae01
 #           LET INT_FLAG = 1   #MOD-4A0311  mark
         END IF
#FUN-4C0020
          SELECT COUNT(*) INTO g_cnt FROM gae_file
           WHERE gae01 = l_new01 AND gae11 = l_new11 AND gae12 = l_new12   #No.FUN-710055
          IF g_cnt > 0 THEN
             CALL cl_err_msg(NULL,"azz-110",l_new01||"|"||l_new11,10)
#            CALL cl_err(l_new11,-239,0)
#            NEXT FIELD gae01
          END IF
#FUN-4C0020(END)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_gae01,g_gae11,g_gaz03,g_gae12 TO gae01,gae11,gaz03,gae12   #No.FUN-710055
      RETURN
   END IF
 
   DROP TABLE x
#FUN-4C0020
   SELECT * FROM gae_file 
     WHERE gae01=g_gae01 and gae11=g_gae11 and gae12=g_gae12 and (gae02 NOT IN   #No.FUN-710055
     (SELECT gae02 FROM gae_file WHERE gae01=l_new01 and gae11=l_new11 and gae12=l_new12)   #No.FUN-710055
     or( gae02 IN (SELECT gae02 FROM gae_file WHERE gae01=l_new01 and gae11=l_new11 and gae12=l_new12)  #No.FUN-710055
     and gae03 NOT IN (SELECT gae03 FROM gae_file WHERE gae01=l_new01 and gae11=l_new11 and gae12=l_new12))) #No.FUN-710055
   INTO TEMP x
 
#  SELECT * FROM gae_file WHERE gae01 = g_gae01 AND gae11 = g_gae11
#    INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_gae01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_gae01,g_gae11,SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET gae01 = l_new01,                        # 資料鍵值
          gae11 = l_new11,                        # 資料鍵值
          gae12 = l_new12,                        # No.FUN-710055
          gae10 = TODAY                           # 資料鍵值
 
   INSERT INTO gae_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('gae:',SQLCA.SQLCODE,0)  #No.FUN-660081
      CALL cl_err3("ins","gae_file",l_new01,l_new11,SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   ELSE    #FUN-7B0081
      DROP TABLE x
      SELECT * FROM gbs_file 
       WHERE gbs01=g_gae01 AND gbs04=g_gae11 AND gbs05=g_gae12 
        INTO TEMP x
      UPDATE x
         SET gbs01 = l_new01,
             gbs04 = l_new11,
             gbs05 = l_new12                       
      INSERT INTO gbs_file SELECT * FROM x
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_gae01
   LET l_old11 = g_gae11
   LET l_old12 = g_gae12   #No.FUN-710055
   LET g_gae01 = l_new01
   LET g_gae11 = l_new11
   LET g_gae12 = l_new12   #No.FUN-710055
   CALL p_perlang_b()
   #FUN-C30027---begin
   #LET g_gae01 = l_old01
   #LET g_gae11 = l_old11
   #LET g_gae12 = l_old12   #No.FUN-710055
   #CALL p_perlang_show()
   #FUN-C30027---end
END FUNCTION
 
#No.FUN-760049 --start--
FUNCTION p_perlang_set_combobox()
   DEFINE   lc_smb01    LIKE smb_file.smb01
   DEFINE   lc_smb03    LIKE smb_file.smb03
   DEFINE   ls_value    STRING
   DEFINE   ls_desc     STRING
 
   LET g_sql = "SELECT UNIQUE smb01,smb03 FROM smb_file WHERE smb02='",g_lang CLIPPED,"'"
   PREPARE smb_pre FROM g_sql
   DECLARE smb_curs CURSOR FOR smb_pre
   FOREACH smb_curs INTO lc_smb01,lc_smb03
      IF lc_smb01 = "std" THEN
         LET ls_value = lc_smb01,",",ls_value
         LET ls_desc = lc_smb01,":",lc_smb03,",",ls_desc
      ELSE
         LET ls_value = ls_value,lc_smb01,","
         LET ls_desc = ls_desc,lc_smb01,":",lc_smb03,","
      END IF
   END FOREACH
   CALL cl_set_combo_items("gae12",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
END FUNCTION
#No.FUN-760049 ---end---
#No.TQC-880038 
