# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_per.4gl
# Descriptions...: 畫面設定維護作業
# Date & Author..: 03/12/04 alex
# Modify.........: 04/04/12 saki 刪掉原幣金額格式設定
# Modify.........: 04/08/11 saki 增加gav08 客製欄位
# Modify.........: 04/10/07 alex gav08 移至單頭
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0020 04/12/03 By Smapmin 允許原先不存在的值被複製
# Modify.........: No.MOD-4C0124 04/12/21 By saki 記錄是否為必要欄位, 在r.gf的時候更新此資訊
# Modify.........: No.MOD-440464 05/02/14 By saki 增加log功能
# Modify.........: No.FUN-550037 05/05/12 By saki 增加自由格式設定訊息顯示
# Modify.........: No.FUN-550118 05/05/27 By alex 調整可視否選擇功能  p_per_free
# Modify.........: No.MOD-580056 05/08/04 By yiting key可更改
# Modify.........: No.MOD-590329 05/10/04 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.MOD-560058 05/10/07 By alex 調整是否可輸入之互相勾稽功能
# Modify.........: No.FUN-560038 05/10/07 By alex 新增畫面名稱說明
# Modify.........: No.FUN-590001 05/10/17 By alex 修改抓取 p_gae_item 功能
# Modify.........: No.MOD-5B0152 05/11/14 By alex 修改規則與 p_perright 一致
# Modify.........: No.FUN-610065 06/01/13 By saki 新增自訂欄位檢查設定,及畫面為空時按action會當掉的bug,順便加QBE條件紀錄
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.TQC-6A0010 06/10/12 By Smapmin 程式代號無法開窗
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.FUN-710055 07/01/23 By saki 自定義欄位設定功能
# Modify.........: No.FUN-720042 07/03/05 By saki 因應4fd使用, findNode搜尋修改
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-6B0081 07/04/09 By pengu 隱藏"更改"action按鈕
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.FUN-760049 07/06/20 By saki 行業別代碼更動
# Modify.........: No.FUN-760072 07/06/26 By saki 串查功能只for內部
# Modify.........: No.FUN-750068 07/07/06 By saki 行業別欄位combobox改為函式製作
# Modify.........: No.FUN-7B0080 07/11/14 By saki 行業別/自定義欄位架構調整
# Modify.........: No.MOD-810259 08/01/14 By alex 行業別選項串接參數增加
# Modify.........: No.FUN-820044 08/03/10 By alex 移除不符MSV規格函式
# Modify.........: No.FUN-840011 08/04/03 By saki 修改自定義欄位程式設定
# Modify.........: No.FUN-840150 08/04/21 By saki 開放串查功能設定
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-950073 09/05/21 By saki 增加設定所有自定義欄位可視或不可視功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70082 10/07/15 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷
# Modify.........: No.EXT-B60126 11/10/28 By saki 修正無法將自定義欄位換位置到多Grid的Page中
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gav01          LIKE gav_file.gav01,   # 類別代號 (假單頭)
         g_gav01_t        LIKE gav_file.gav01,
         g_gaz03          LIKE gaz_file.gaz03,   #FUN-560038
         g_gav08          LIKE gav_file.gav08,
         g_gav08_t        LIKE gav_file.gav08,
         g_gav11          LIKE gav_file.gav11,   #No.FUN-710055
         g_gav11_t        LIKE gav_file.gav11,   #No.FUN-710055
         g_gav_lock RECORD LIKE gav_file.*,      # FOR LOCK CURSOR TOUCH
         g_gav    DYNAMIC ARRAY of RECORD        # 程式變數
            gav02          LIKE gav_file.gav02,
            gae04          LIKE gae_file.gae04,
            gav07          LIKE gav_file.gav07,
            gav03          LIKE gav_file.gav03,
            gav04          LIKE gav_file.gav04,
#No.FUN-710055 --start--
            gav16          LIKE gav_file.gav16,
            gav12          LIKE gav_file.gav12,
            gav13          LIKE gav_file.gav13,
            gav14          LIKE gav_file.gav14,
            gav15          LIKE gav_file.gav15,
            gav34          LIKE gav_file.gav34,
            gav32          LIKE gav_file.gav32,
#No.FUN-710055 ---end---
            gav06          LIKE gav_file.gav06,
#No.FUN-710055 --start--
            gav19          LIKE gav_file.gav19,
            function       LIKE type_file.chr1,
#No.FUN-710055 ---end---
            gav10          LIKE gav_file.gav10,
            gav09          LIKE gav_file.gav09
                      END RECORD,
         g_gav_t           RECORD                 # 變數舊值
            gav02          LIKE gav_file.gav02,
            gae04          LIKE gae_file.gae04,
            gav07          LIKE gav_file.gav07,
            gav03          LIKE gav_file.gav03,
            gav04          LIKE gav_file.gav04,
#No.FUN-710055 --start--
            gav16          LIKE gav_file.gav16,
            gav12          LIKE gav_file.gav12,
            gav13          LIKE gav_file.gav13,
            gav14          LIKE gav_file.gav14,
            gav15          LIKE gav_file.gav15,
            gav34          LIKE gav_file.gav34,
            gav32          LIKE gav_file.gav32,
#No.FUN-710055 ---end---
            gav06          LIKE gav_file.gav06,
#No.FUN-710055 --start--
            gav19          LIKE gav_file.gav19,
            function       LIKE type_file.chr1,
#No.FUN-710055 ---end---
            gav10          LIKE gav_file.gav10,
            gav09          LIKE gav_file.gav09
                      END RECORD,
#No.FUN-710055 --start--
         g_gav_o  DYNAMIC ARRAY of RECORD        # 程式變數
            gav02          LIKE gav_file.gav02,
            gae04          LIKE gae_file.gae04,
            gav07          LIKE gav_file.gav07,
            gav03          LIKE gav_file.gav03,
            gav04          LIKE gav_file.gav04,
            gav16          LIKE gav_file.gav16,
            gav12          LIKE gav_file.gav12,
            gav13          LIKE gav_file.gav13,
            gav14          LIKE gav_file.gav14,
            gav15          LIKE gav_file.gav15,
            gav34          LIKE gav_file.gav34,
            gav32          LIKE gav_file.gav32,
            gav06          LIKE gav_file.gav06,
            gav19          LIKE gav_file.gav19,
            function       LIKE type_file.chr1,
            gav10          LIKE gav_file.gav10,
            gav09          LIKE gav_file.gav09
                      END RECORD,
#No.FUN-710055 ---end---
#No.FUN-610065 --start--
         g_gbr             RECORD LIKE gbr_file.*,
         g_gbr_t           RECORD LIKE gbr_file.*,
#No.FUN-610065 ---end---
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,
         g_ss                  LIKE type_file.chr1,    #FUN-680135  VARCHAR(1) # 決定後續步驟
         g_rec_b               LIKE type_file.num5,    # 單身筆數   #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5,    # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
         l_ac_o                LIKE type_file.num5     #No.FUN-710055 備份目前處理筆數
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE gav_file.gav01
DEFINE   g_argv2               LIKE gav_file.gav08     #MOD-810259
DEFINE   g_argv3               LIKE gav_file.gav11     #MOD-810259
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_no_ask              LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   att             DYNAMIC ARRAY OF RECORD
            gav02        STRING,
            gae04        STRING,
            gav07        STRING,
            gav03        STRING,
            gav04        STRING,
            gav16        STRING,
            gav12        STRING,
            gav13        STRING,
            gav14        STRING,
            gav15        STRING,
            gav34        STRING,
            gav32        STRING,
            gav06        STRING,
            gav19        STRING,
            function     STRING,
            gav10        STRING,
            gav09        STRING
                         END RECORD
DEFINE   g_gav_prog      RECORD
           gav10         LIKE gav_file.gav10,
           gav09         LIKE gav_file.gav09,
           gav17         LIKE gav_file.gav17,
           gav18         LIKE gav_file.gav18,
           gav19         LIKE gav_file.gav19,
           gav20         LIKE gav_file.gav20,
           gav21         LIKE gav_file.gav21,
           gav22         LIKE gav_file.gav22,
           gav23         LIKE gav_file.gav23,
           gav24         LIKE gav_file.gav24,
           gav25         LIKE gav_file.gav25,
           gav26         LIKE gav_file.gav26,
           gav27         LIKE gav_file.gav27,
           gav28         LIKE gav_file.gav28,
           gav29         LIKE gav_file.gav29,
           gav30         LIKE gav_file.gav30,
           gav31         LIKE gav_file.gav31,
           gav33         LIKE gav_file.gav33,
           gav36         LIKE gav_file.gav36,
           gav37         LIKE gav_file.gav37,
           gav39         LIKE gav_file.gav39
                         END RECORD
DEFINE   g_gav20_table   STRING
DEFINE   g_gav20_field   STRING
DEFINE   g_gav21_table   STRING
DEFINE   g_gav21_where   STRING
DEFINE   g_gav22_table   STRING
DEFINE   g_gav22_field   STRING
DEFINE   g_gav23_field   STRING
DEFINE   g_gav23_table   STRING
DEFINE   g_gav23_where   STRING
DEFINE   g_gav26_table   STRING
DEFINE   g_gav26_field   STRING
DEFINE   g_gav27_table   STRING
DEFINE   g_gav27_where   STRING
DEFINE   g_gav21_funname STRING
DEFINE   g_gav23_funname STRING
DEFINE   g_gav27_funname STRING
DEFINE   g_std_id        LIKE smb_file.smb01
DEFINE   g_chg_flag      LIKE type_file.num5
DEFINE   g_tabindex      DYNAMIC ARRAY OF RECORD
            sel          LIKE type_file.chr1,
            gav02        LIKE gav_file.gav02,
            gae04        LIKE gae_file.gae04,
            gav16        LIKE gav_file.gav16,
            chg_flag     LIKE type_file.num5
                         END RECORD
#No.FUN-710055 ---end---
DEFINE   g_db_type       LIKE type_file.chr3      #No.FUN-760049
DEFINE   g_open_define   LIKE type_file.num5      #No.FUN-7B0080
DEFINE   g_smb01         DYNAMIC ARRAY OF LIKE smb_file.smb01   #No.FUN-950073
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      FIELD ORDER FORM,                           #依照tabIndex順序輸入
      INPUT NO WRAP                               # 輸入的方式: 不打轉
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
 
   LET g_gav01_t = NULL
   LET g_gav08_t = NULL
 
   OPEN WINDOW p_per_w WITH FORM "azz/42f/p_per"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from gav_file  WHERE gav01 = ? AND gav08=? AND gav11=? ",  #No.FUN-710055
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_per_lock_u CURSOR FROM g_forupd_sql
 
   #No.FUN-710055 --start--
   #一般行業別代碼
#  SELECT smb01 INTO g_std_id FROM smb_file WHERE smb02="0" AND smb05="Y"   #No.FUN-760049 mark
   LET g_std_id = "std"            #No.FUN-760049
   #No.FUN-710055 ---end---
 
#  CALL p_per_set_combobox()              #No.FUN-760049 行業別選項
   CALL cl_set_combo_industry("gav11")    #No.FUN-750068
   LET g_db_type=cl_db_get_database_type()   #No.FUN-760049
 
   #No.FUN-760072 --start--   #No.FUN-840150 --mark start--
#  SELECT COUNT(*) INTO g_cnt FROM zlw_file
#  IF SQLCA.sqlcode OR g_cnt < 3 THEN
#     CALL cl_set_comp_entry("gav32",FALSE)
#  END IF
   #No.FUN-760072 ---end---   #No.FUN-840150 ---mark end---
 
   #No.FUN-7B0080 --start-- 隱藏自定義欄位設定, 若查詢出來有自定義欄位再開放(action同)
   CALL cl_set_comp_visible("gav12,gav13,gav14,gav15,gav16,gav17,gav18,gav19,gav20,gav21,gav22,gav23,gav24,gav25,gav26,gav27,gav28,gav29,gav30,gav31,gav33,gav34,gav36,gav37,gav39,function",FALSE)
   CALL cl_set_act_visible("program_check,clear_ui_setting,chg_udfield_visible",FALSE)   #No.FUN-950073
   #No.FUN-7B0080 ---end---
 
   #No.FUN-950073 --start--
   DECLARE smb01_curs CURSOR FOR
      SELECT UNIQUE smb01 FROM smb_file
   LET g_cnt = 1
   FOREACH smb01_curs INTO g_smb01[g_cnt]
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_smb01.deleteElement(g_cnt)
   #No.FUN-950073 ---end---
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_per_q()
   END IF
 
   CALL p_per_menu() 
 
   CLOSE WINDOW p_per_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_per_curs()                        # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_gav.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "gav01 = '",g_argv1 CLIPPED,"' "
      IF NOT cl_null(g_argv2) THEN             #MOD-810259
         LET g_wc = g_wc," AND gav08 = '",g_argv2 CLIPPED,"' "
         IF NOT cl_null(g_argv3) THEN
            LET g_wc = g_wc," AND gav11 = '",g_argv3 CLIPPED,"' "
         END IF
      END IF
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON gav01,gav08,gav11,gav02,gav07,gav03,gav04,
                        gav16,gav12,gav13,gav14,gav15,gav34,gav32,gav19,     #No.FUN-710055
                        gav06,gav10,gav09
                   FROM gav01,gav08,gav11,                  #No.FUN-710055
                        s_gav[1].gav02,s_gav[1].gav07,s_gav[1].gav03,
                        s_gav[1].gav04,
                        s_gav[1].gav16,s_gav[1].gav12,s_gav[1].gav13,  #No.FUN-710055
                        s_gav[1].gav14,s_gav[1].gav15,s_gav[1].gav34,  #No.FUN-710055
                        s_gav[1].gav32,s_gav[1].gav19,                 #No.FUN-710055
                        s_gav[1].gav06,s_gav[1].gav10,s_gav[1].gav09   # MOD-4C0124
 
         #No.FUN-610065 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-610065 ---end---
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gav01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zz"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang CLIPPED   #TQC-6A0010
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gav01
                  NEXT FIELD gav01
 
               #No.FUN-710055 --start--
               WHEN INFIELD(gav18)
                  CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gav18
                  NEXT FIELD gav18
               #No.FUN-710055 ---end---
 
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
 
          #No.FUN-610065 --start--
          ON ACTION qbe_select
             CALL cl_qbe_select()
          ON ACTION qbe_save
             CALL cl_qbe_save()
          #No.FUN-610065 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   #No.FUN-760049 --start--
#  LET g_sql= "SELECT UNIQUE gav01,gav08,gav11 FROM gav_file ",  #No.FUN-710055
#             " WHERE ", g_wc CLIPPED,#" AND gav35 = 'default'", #No.FUN-710055
#             " ORDER BY gav01"
   IF g_db_type = "ORA" THEN
      LET g_sql= "SELECT UNIQUE gav01,gav08,gav11 FROM gav_file ",
                 " WHERE ",g_wc CLIPPED," ORDER BY gav01,DECODE(gav11,'std','1',gav11)"
   ELSE
      LET g_sql= "SELECT UNIQUE gav01,gav08,gav11 FROM gav_file ",  #No.FUN-710055
                 " WHERE ", g_wc CLIPPED,#" AND gav35 = 'default'", #No.FUN-710055
                 " ORDER BY gav01"
   END IF
   #No.FUN-760049 ---end---
   PREPARE p_per_prepare FROM g_sql          # 預備一下
   DECLARE p_per_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_per_prepare
 
END FUNCTION
 
 # 2004/09/29 MOD-490456 選出筆數直接寫入 g_row_count
FUNCTION p_per_count()
 
   DEFINE la_gav   DYNAMIC ARRAY of RECORD        # 程式變數
            gav01          LIKE gav_file.gav01,
            gav08          LIKE gav_file.gav08,
            gav11          LIKE gav_file.gav11    #No.FUN-710055
#           gav35          LIKE gav_file.gav35    #No.FUN-710055
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b LIKE type_file.num10   #FUN-680135 INTEGER
 
   LET g_sql= "SELECT UNIQUE gav01,gav08,gav11 FROM gav_file ",  #No.FUN-710055
#  LET g_sql= "SELECT UNIQUE gav01,gav08,gav11,gav35 FROM gav_file ",  #No.FUN-710055
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gav01"
 
   PREPARE p_per_precount FROM g_sql
   DECLARE p_per_count CURSOR FOR p_per_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH p_per_count INTO la_gav[li_cnt].*
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
 
 
FUNCTION p_per_menu()
   DEFINE   ls_cmd   STRING                     #No.FUN-710055
 
   WHILE TRUE
      CALL p_per_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_per_a()
            END IF
 
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_per_u()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_per_copy()
            END IF
 
#        WHEN "delete"                          # R.取消
#           IF cl_chk_act_auth() THEN
#              CALL p_per_r()
#           END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_per_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_per_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "modify_desc" 
            IF l_ac > 0 THEN                    #No.FUN-610065
               IF NOT cl_null(g_gav01) AND g_gav[l_ac].gav02 != 'wintitle' THEN
                  CALL p_gae_item(g_gav01,g_gav[l_ac].gav02,g_gav08,g_gav11)   #FUN-590001  #No.FUN-710055
                  SELECT gae04 INTO g_gav[l_ac].gae04 FROM gae_file
                   WHERE gae01=g_gav01 AND gae02=g_gav[l_ac].gav02
                     AND gae03=g_lang  AND gae11=g_gav08 AND gae12=g_gav11
               END IF
            END IF                              #No.FUN-610065
 
         WHEN "special_set"
            IF l_ac > 0 THEN                    #No.FUN-610065
               IF NOT cl_null(g_gav01) AND g_gav[l_ac].gav02 != 'wintitle' THEN
               #   IF g_gav[l_ac].gav03 = "N" OR    #MOD-5B0152
                #     ((g_gav[l_ac].gav09 = "N" OR g_gav[l_ac].gav09 IS NULL) AND g_gav[l_ac].gav10 = "Y" ) THEN
                  #   CALL cl_err(g_gav[l_ac].gav02,"azz-118",1)
               #   ELSE
                     CALL p_per_gaj_d(g_gav01,g_gav[l_ac].gav02)
               #   END IF
               END IF
            END IF                              #No.FUN-610065
 
         #No.FUN-610065 --start--  No.FUN-7B0080 --mark--
#        WHEN "userdefined_field_set"
#           IF l_ac > 0 THEN
#              IF NOT cl_null(g_gav01) AND g_gav[l_ac].gav02 != 'wintitle' THEN
#                 IF g_gav[l_ac].gav03 = "N" OR
#                    ((g_gav[l_ac].gav09 = "N" OR g_gav[l_ac].gav09 IS NULL) AND g_gav[l_ac].gav10 = "Y") THEN
#                    CALL cl_err(g_gav[l_ac].gav02,"azz-118",1)
#                 ELSE
#                    CALL p_per_userdefined_field(g_gav01,g_gav[l_ac].gav02,g_gav08)
#                 END IF
#              END IF
#           END IF
         #No.FUN-610065 ---end---
 
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gav),'','')
            END IF
 
          WHEN "showlog"           #MOD-440464
            IF cl_chk_act_auth() THEN
               CALL cl_show_log("p_per")
            END IF
 
         #No.FUN-710055 --start--
         WHEN "preview"
            IF cl_chk_act_auth() THEN
               LET g_chg_flag = FALSE
               CALL p_per_view()
               FOR g_cnt = 1 TO g_gav.getLength()
                   LET g_gav_o[g_cnt].* = g_gav[g_cnt].*
               END FOR
            END IF
 
         WHEN "program_check"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  CALL p_per_field_prog_check()
               END IF
            END IF
 
         WHEN "clear_ui_setting"
            IF cl_chk_act_auth() THEN
               CALL p_per_clear_ui_setting()
            END IF
         #No.FUN-710055 ---end---
 
         #No.FUN-950073 --start--
         WHEN "chg_udfield_visible"
            IF cl_chk_act_auth() THEN
               CALL p_per_chg_udfield_visible()
            END IF
 
         WHEN "chg_industry_visible"
            IF cl_chk_act_auth() THEN
               CALL p_per_chg_industry_visible()
            END IF
         #No.FUN-950073 ---end---
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_per_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gav.clear()
 
   INITIALIZE g_gav01 LIKE gav_file.gav01         # 預設值及將數值類變數清成零
   INITIALIZE g_gaz03 LIKE gaz_file.gaz03         #FUN-560038
   INITIALIZE g_gav08 LIKE gav_file.gav08
   INITIALIZE g_gav11 LIKE gav_file.gav11         #No.FUN-710055
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_per_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_gav01=NULL
         LET g_gaz03=NULL                         #FUN-560038
         LET g_gav08=NULL
         LET g_gav11=NULL                         #No.FUN-710055
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_gav.clear()
      ELSE
         CALL p_per_b_fill('1=1')             # 單身
      END IF
 
      CALL p_per_b()                          # 輸入單身
      LET g_gav01_t=g_gav01
      LET g_gav08_t=g_gav08
      LET g_gav11_t=g_gav11                   #No.FUN-710055
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_per_i(p_cmd)                        # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1   # a:輸入 u:更改        #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'Y'
   DISPLAY g_gav01,g_gaz03,g_gav08,g_gav11 TO gav01,gaz03,gav08,gav11  #FUN-560038  #No.FUN-710055
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_gav01,g_gav08,g_gav11 WITHOUT DEFAULTS FROM gav01,gav08,gav11  #No.FUN-710055
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_per_set_entry(p_cmd)
         CALL p_per_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
      #No.FUN-710055 --start--
      AFTER FIELD gav01
         IF NOT cl_null(g_gav01) AND NOT cl_null(g_gav08) AND
            NOT cl_null(g_gav11) THEN
            IF g_gav01 != g_gav01_t OR cl_null(g_gav01_t) THEN
               SELECT COUNT(UNIQUE gav01) INTO g_cnt FROM gav_file
                WHERE gav01=g_gav01 AND gav08=g_gav08 AND gav11=g_gav11
               IF g_cnt > 0 THEN
                  LET g_ss = 'Y'
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gav01,-239,0)
                     LET g_gav01 = g_gav01_t
                     NEXT FIELD gav01
                  END IF
               END IF
               CALL p_per_gaz03()
               DISPLAY g_gaz03 TO gaz03
            END IF
         END IF
 
      AFTER FIELD gav08
         IF NOT cl_null(g_gav01) AND NOT cl_null(g_gav08) AND
            NOT cl_null(g_gav11) THEN
            IF g_gav08 != g_gav08_t OR cl_null(g_gav08_t) THEN
               SELECT COUNT(UNIQUE gav08) INTO g_cnt FROM gav_file
                WHERE gav01=g_gav01 AND gav08=g_gav08 AND gav11=g_gav11
               IF g_cnt > 0 THEN
                  LET g_ss = 'Y'
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gav08,-239,0)
                     LET g_gav08 = g_gav08_t
                     NEXT FIELD gav08
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD gav11
         IF NOT cl_null(g_gav01) AND NOT cl_null(g_gav08) AND
            NOT cl_null(g_gav11) THEN
            IF g_gav11 != g_gav11_t OR cl_null(g_gav11_t) THEN
               SELECT COUNT(UNIQUE gav11) INTO g_cnt FROM gav_file
                WHERE gav01=g_gav01 AND gav08=g_gav08 AND gav11=g_gav11
               IF g_cnt > 0 THEN
                  LET g_ss = 'Y'
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gav11,-239,0)
                     LET g_gav11 = g_gav11_t
                     NEXT FIELD gav11
                  END IF
               END IF
            END IF
         END IF
      #No.FUN-710055 ---end---
 
      AFTER INPUT
         #No.FUN-710055 --start--
         IF NOT cl_null(g_gav01) AND NOT cl_null(g_gav08) AND
            NOT cl_null(g_gav11) THEN
            IF g_gav01 != g_gav01_t OR cl_null(g_gav01_t) OR
               g_gav08 != g_gav08_t OR cl_null(g_gav08_t) OR
               g_gav11 != g_gav11_t OR cl_null(g_gav11_t) THEN
               SELECT COUNT(UNIQUE gav01) INTO g_cnt FROM gav_file
                WHERE gav01=g_gav01 AND gav08=g_gav08 AND gav11=g_gav11
               IF g_cnt > 0 THEN
                  LET g_ss = 'Y'
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gav11,-239,0)
                     LET g_gav11 = g_gav11_t
                     NEXT FIELD gav11
                  END IF
               END IF
            END IF
         END IF
#        IF NOT cl_null(g_gav01) THEN
#           IF g_gav01 != g_gav01_t OR cl_null(g_gav01_t) THEN
#              SELECT COUNT(UNIQUE gav01) INTO g_cnt FROM gav_file
#               WHERE gav01=g_gav01 AND gav08=g_gav08
#              IF g_cnt > 0 THEN
#                 IF p_cmd = 'a' THEN
#                    LET g_ss = 'Y'
#                 END IF
#              ELSE
#                 IF p_cmd = 'u' THEN
#                    CALL cl_err(g_gav01,-239,0)
#                    LET g_gav01 = g_gav01_t
#                    NEXT FIELD gav01
#                 END IF
#              END IF
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_gav01,g_errno,0)
#                 NEXT FIELD gav01
#              ELSE #FUN-560038
#                 CALL p_per_gaz03()
#                 DISPLAY g_gaz03 TO gaz03
#              END IF
#           END IF
#        END IF
         #No.FUN-710055 ---end---
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gav01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.default1= g_gav01
               LET g_qryparam.arg1 = g_lang CLIPPED   #TQC-6A0010
               CALL cl_create_qry() RETURNING g_gav01
               NEXT FIELD gav01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
END FUNCTION
 
 
FUNCTION p_per_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gav01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gav01_t = g_gav01
   LET g_gav08_t = g_gav08
   LET g_gav11_t = g_gav11    #No.FUN-710055
 
   BEGIN WORK
   OPEN p_per_lock_u USING g_gav01,g_gav08,g_gav11  #No.FUN-710055
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_per_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_per_lock_u INTO g_gav_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gav01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_per_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_per_i("u")
      IF INT_FLAG THEN
         LET g_gav01 = g_gav01_t
         DISPLAY g_gav01 TO gav01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gav_file SET gav01 = g_gav01, gav08 = g_gav08, gav11 = g_gav11  #No.FUN-710055
       WHERE gav01 = g_gav01_t
         AND gav08 = g_gav08_t
         AND gav11 = g_gav11_t    #No.FUN-710055
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_gav01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","gav_file",g_gav01_t,g_gav08_t,SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_per_q()                            #Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   #No.FUN-7B0080 --start-- 隱藏自定義欄位設定, 若查詢出來有自定義欄位再開放(action同)
   CALL cl_set_comp_visible("gav12,gav13,gav14,gav15,gav16,gav17,gav18,gav19,gav20,gav21,gav22,gav23,gav24,gav25,gav26,gav27,gav28,gav29,gav30,gav31,gav33,gav34,gav36,gav37,gav39,function",FALSE)
   CALL cl_set_act_visible("preview,program_check,clear_ui_setting,chg_udfield_visible",FALSE)   #No.FUN-950073
   #No.FUN-7B0080 ---end---
 
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_gav.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_per_curs()                         #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_per_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                     #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gav01 TO NULL
      INITIALIZE g_gaz03 TO NULL             #FUN-560038
      LET g_gav08 = "N"
   ELSE
      CALL p_per_fetch('F')                  #讀出TEMP第一筆並顯示
#     OPEN p_per_count
#     FETCH p_per_count INTO g_row_count
      CALL p_per_count()
      DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
FUNCTION p_per_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式   #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10     #絕對的筆數 #No.FUN-680135 INTEGER
 
   LET g_open_define = FALSE        #No.FUN-7B0080 判斷是否要開啟自定義設定欄位
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_per_b_curs INTO g_gav01,g_gav08,g_gav11 #No.FUN-710055
      WHEN 'P' FETCH PREVIOUS p_per_b_curs INTO g_gav01,g_gav08,g_gav11 #No.FUN-710055
      WHEN 'F' FETCH FIRST    p_per_b_curs INTO g_gav01,g_gav08,g_gav11 #No.FUN-710055
      WHEN 'L' FETCH LAST     p_per_b_curs INTO g_gav01,g_gav08,g_gav11 #No.FUN-710055
      WHEN '/' 
         IF (NOT g_no_ask) THEN        #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION help
                   CALL cl_show_help()
                ON ACTION controlg
                   CALL cl_cmdask()
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
              EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_per_b_curs INTO g_gav01,g_gav08,g_gav11 #No.FUN-710055
         LET g_no_ask = FALSE         #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gav01,SQLCA.sqlcode,0)
      INITIALIZE g_gav01 TO NULL  #TQC-6B0105
      INITIALIZE g_gav08 TO NULL  #TQC-6B0105
      INITIALIZE g_gav11 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL p_per_show()
   END IF
END FUNCTION
 
FUNCTION p_per_show()                         # 將資料顯示在畫面上
   CALL p_per_gaz03()
   DISPLAY g_gav01,g_gaz03,g_gav08,g_gav11 TO gav01,gaz03,gav08,gav11 #FUN-560038  #No.FUN-710055
   CALL p_per_b_fill(g_wc)                    # 單身
   FOR g_cnt = 1 TO g_gav.getLength()
       LET g_gav_o[g_cnt].* = g_gav[g_cnt].*
   END FOR
   CALL p_per_b_chg_bgcolor()                 #No.FUN-710055 顯示欄位資料是屬於單頭或單身
 
   CALL cl_show_fld_cont()                    #No.FUN-550037 hmf
END FUNCTION
 
#FUN-560038 (start)
FUNCTION p_per_gaz03()
 
   DEFINE l_count  LIKE type_file.num5    #FUN-680135 SMALLINT
 
   LET g_gaz03 = ""
   LET l_count = 0
 
   SELECT count(*) INTO l_count FROM gaz_file WHERE gaz01=g_gav01
 
   IF l_count > 0 THEN
      SELECT gaz03 INTO g_gaz03 FROM gaz_file
       WHERE gaz01=g_gav01 AND gaz02=g_lang AND gaz05="Y"
      IF cl_null(g_gaz03) THEN
        SELECT gaz03 INTO g_gaz03 FROM gaz_file
         WHERE gaz01=g_gav01 AND gaz02=g_lang AND gaz05="N"
      END IF
   ELSE
      SELECT gae04 INTO g_gaz03 FROM gae_file
       WHERE gae01=g_gav01 AND gae02='wintitle' AND gae03=g_lang AND gae11="Y" AND gae12=g_gav11  #No.FUN-710055
      IF cl_null(g_gaz03) THEN
        SELECT gae04 INTO g_gaz03 FROM gae_file
         WHERE gae01=g_gav01 AND gae02='wintitle' AND gae03=g_lang AND gae11="N" AND gae12=g_gav11  #No.FUN-710055
      END IF
   END IF
 
   IF g_gav01='TopMenuGroup' THEN
      LET g_gaz03='Common Items For TOP Menu'
   END IF
 
   IF g_gav01='TopProgGroup' THEN
      LET g_gaz03='Program Items For TOP Menu'
   END IF
 
END FUNCTION
#FUN-560038(end)
 
 
FUNCTION p_per_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gav   RECORD LIKE gav_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gav01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gav_file WHERE gav01 = g_gav01 AND gav08 = g_gav08 AND gav11 = g_gav11   #No.FUN-710055
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","gav_file",g_gav01,g_gav08,SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_gav.clear()
#        OPEN p_per_count
#        FETCH p_per_count INTO g_row_count
         CALL p_per_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_per_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_per_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE         #No.FUN-6A0080
            CALL p_per_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_per_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,     # 檢查重複用      #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,     # 檢查重複用      #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否      #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     # 處理狀態        #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,     #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5      #No.FUN-680135 SMALLINT
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   li_result       LIKE type_file.num5      #No.FUN-710055
   DEFINE   li_i            LIKE type_file.num5      #No.FUN-760049
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gav01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gav02,' ',gav07,gav03,gav04,gav16,gav12,gav13,", #No.FUN-710055
                     "       gav14,gav15,gav34,gav32,gav06,gav19,' ',gav10,gav09 ", #No.FUN-710055
                      " FROM gav_file ",
                     "  WHERE gav01 = ? AND gav08=? AND gav11=? AND gav02=? ", #No.FUN-710055
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_per_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_ac_t = 0
 
   INPUT ARRAY g_gav WITHOUT DEFAULTS FROM s_gav.*
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
            LET g_gav_t.* = g_gav[l_ac].*    #BACKUP
#NO.MOD-590329 MARK-------------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_per_set_entry_b(p_cmd)
#           CALL p_per_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK-------------------
            OPEN p_per_bcl USING g_gav01,g_gav08,g_gav11,g_gav_t.gav02  #No.FUN-710055
            IF SQLCA.sqlcode THEN 
               CALL cl_err("OPEN p_per_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_per_bcl INTO g_gav[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_per_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT gae04 INTO g_gav[l_ac].gae04 FROM gae_file
                   WHERE gae01=g_gav01 AND gae11=g_gav08
                     AND gae02=g_gav[l_ac].gav02 AND gae03=g_lang AND gae12=g_gav11   #No.FUN-710055
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            #No.FUN-710055 --start--
            LET g_before_input_done = FALSE
            CALL p_per_set_entry_b(p_cmd)
            CALL p_per_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            #No.FUN-710055 ---end---
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gav[l_ac].* TO NULL       #900423
         LET g_gav_t.* = g_gav[l_ac].*          #新輸入資料
#NO.MOD-590329 MARK---------------------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_per_set_entry_b(p_cmd)
#           CALL p_per_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK--------------------------
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         #No.FUN-710055 --start--
         LET g_before_input_done = FALSE
         CALL p_per_set_entry_b(p_cmd)
         CALL p_per_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
         #No.FUN-710055 ---end---
         NEXT FIELD gav02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gav_file (gav01,gav02,gav03,gav04,gav06,gav07,gav08,gav10,
                               gav09,gav11,gav12,gav13,gav14,gav15,gav16,gav32,gav34)   #No.FUN-710055
              VALUES (g_gav01,g_gav[l_ac].gav02,g_gav[l_ac].gav03,
                      g_gav[l_ac].gav04,g_gav[l_ac].gav06,g_gav[l_ac].gav07,
                      g_gav08,'N','N',g_gav11,g_gav[l_ac].gav12,            #No.FUN-710055
                      g_gav[l_ac].gav13,g_gav[l_ac].gav14,g_gav[l_ac].gav15,#No.FUN-710055
                      g_gav[l_ac].gav16,g_gav[l_ac].gav32,g_gav[l_ac].gav34)                                    #No.FUN-710055
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gav01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gav_file",g_gav01,g_gav[l_ac].gav02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD gav02
         IF g_gav[l_ac].gav02 != g_gav_t.gav02 OR g_gav_t.gav02 IS NULL THEN
            # 檢視 gav_file 中同一 Program Name (gav01) 下是否有相同的
            # Filed Name (gav02)
            SELECT COUNT(*) INTO l_n FROM gav_file
             WHERE gav01 = g_gav01 AND gav08 = g_gav08 AND gav11 = g_gav11  #No.FUN-710055
               AND gav02 = g_gav[l_ac].gav02
            IF l_n > 0 THEN
               CALL cl_err(g_gav[l_ac].gav02,-239,0)
               LET g_gav[l_ac].gav02 = g_gav_t.gav02
               NEXT FIELD gav02
            END IF
            #No.FUN-710055 --start--
            LET g_before_input_done = FALSE
            CALL p_per_set_entry_b(p_cmd)
            CALL p_per_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            #No.FUN-710055 ---end---
         END IF
 
      AFTER FIELD gav03        #FUN-550118
         IF g_gav[l_ac].gav03 = "N" AND g_gav[l_ac].gav10 = "Y" AND g_gav[l_ac].gav09 = "N" THEN
            CALL cl_msgany(1,1,"lib-237")
            LET g_gav[l_ac].gav03 = "Y"
         END IF
 
      AFTER FIELD gav04        #MOD-560058
        IF g_gav[l_ac].gav04 = "N" AND g_gav[l_ac].gav10 = "Y" THEN
           CALL cl_msgany(1,1,"lib-238")
           LET g_gav[l_ac].gav04 = "Y"
        END IF
 
      #No.FUN-710055 --start--
      AFTER FIELD gav32
         #No.FUN-760049 --start--
         IF NOT cl_null(g_gav[l_ac].gav32) THEN   #No.FUN-760072
            SELECT COUNT(*) INTO l_n FROM gaz_file WHERE gaz01=g_gav[l_ac].gav32
            IF l_n <= 0 THEN
               CALL cl_err(g_gav[l_ac].gav32,'lib-021',0)
               NEXT FIELD gav32
            END IF
            LET l_n = 0
            FOR li_i = 1 TO g_gav.getLength()
                #No.FUN-760072 --start--
                IF att[l_ac].gav02 = "Olive reverse" THEN
                   IF att[li_i].gav02 = "Olive reverse" AND g_gav[li_i].gav32 IS NOT NULL AND
                      g_gav[li_i].gav02 != g_gav[l_ac].gav02 THEN
                      LET l_n = l_n + 1
                   END IF
                ELSE
                   IF att[li_i].gav02 = "lightOlive reverse" AND g_gav[li_i].gav32 IS NOT NULL AND
                      g_gav[li_i].gav02 != g_gav[l_ac].gav02 THEN
                      LET l_n = l_n + 1
                   END IF
                END IF
                #No.FUN-760072 ---end---
            END FOR
            IF l_n >= 20 THEN    #No.FUN-760072
               CALL cl_err("","azz-744",0)
               NEXT FIELD gav32                #No.FUN-760072
            END IF
         END IF                                #No.FUN-760072
         #No.FUN-760049 ---end---
      #No.FUN-710055 ---end---
 
      BEFORE FIELD gav06
         CALL p_per_free(g_gav[l_ac].gav06) RETURNING g_gav[l_ac].gav06
         DISPLAY g_gav[l_ac].gav06 TO gav06
#        NEXT FIELD gav10
         NEXT FIELD NEXT       #No.FUN-710055
 
      #No.FUN-550037 --start--
      ON CHANGE gav06
         IF (g_gav[l_ac].gav06 IS NOT NULL) THEN
            CALL cl_msgany(1,1,"lib-235")
         END IF
      #No.FUN-550037 ---end---
 
      AFTER FIELD gav07        #MOD-560058
        IF g_gav[l_ac].gav04 = "Y" AND g_gav[l_ac].gav10 = "Y" THEN
           CALL cl_msgany(1,1,"lib-239")
           LET g_gav[l_ac].gav04 = "N"
        END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gav_t.gav02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err("Deleting One of Several Primary Keys!","!",1)
            END IF
            DELETE FROM gav_file WHERE gav01 = g_gav01
                                   AND gav08 = g_gav08
                                   AND gav11 = g_gav11          #No.FUN-710055
                                   AND gav02 = g_gav[l_ac].gav02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gav_t.gav02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gav_file",g_gav01,g_gav_t.gav02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
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
            LET g_gav[l_ac].* = g_gav_t.*
            CLOSE p_per_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gav[l_ac].gav02,-263,1)
            LET g_gav[l_ac].* = g_gav_t.*
         ELSE
            UPDATE gav_file
               SET gav02 = g_gav[l_ac].gav02,
                   gav03 = g_gav[l_ac].gav03,
                   gav04 = g_gav[l_ac].gav04,
                   gav06 = g_gav[l_ac].gav06,
                   gav07 = g_gav[l_ac].gav07,
            #No.FUN-710055 --start--
                   gav12 = g_gav[l_ac].gav12,
                   gav13 = g_gav[l_ac].gav13,
                   gav14 = g_gav[l_ac].gav14,
                   gav15 = g_gav[l_ac].gav15,
                   gav16 = g_gav[l_ac].gav16,
                   gav32 = g_gav[l_ac].gav32,
                   gav34 = g_gav[l_ac].gav34
            #No.FUN-710055 ---end---
             WHERE gav01 = g_gav01
               AND gav08 = g_gav08
               AND gav11 = g_gav11          #No.FUN-710055
               AND gav02 = g_gav_t.gav02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gav[l_ac].gav02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gav_file",g_gav01,g_gav_t.gav02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gav[l_ac].* = g_gav_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               LET ls_msg_n = g_gav01 CLIPPED,"",g_gav[l_ac].gav02 CLIPPED,"",
                              g_gav[l_ac].gav03 CLIPPED,"",g_gav[l_ac].gav04 CLIPPED,"",
                              g_gav[l_ac].gav06 CLIPPED,"",g_gav[l_ac].gav07 CLIPPED,"",
                              g_gav08 CLIPPED,"",g_gav[l_ac].gav09 CLIPPED,"",
                              g_gav[l_ac].gav10 CLIPPED
               LET ls_msg_o = g_gav01 CLIPPED,"",g_gav_t.gav02 CLIPPED,"",
                              g_gav_t.gav03 CLIPPED,"",g_gav_t.gav04 CLIPPED,"",
                              g_gav_t.gav06 CLIPPED,"",g_gav_t.gav07 CLIPPED,"",
                              g_gav08 CLIPPED,"",g_gav_t.gav09 CLIPPED,"",
                              g_gav_t.gav10 CLIPPED
                CALL cl_log("p_per","U",ls_msg_n,ls_msg_o)            # MOD-440464
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac              #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gav[l_ac].* = g_gav_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_gav.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_per_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac              #FUN-D30034 add
         CLOSE p_per_bcl
         COMMIT WORK
 
         #No.FUN-710055 --start--
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gav32)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zz"
                  LET g_qryparam.arg1 = g_lang CLIPPED   #TQC-6A0010
                  CALL cl_create_qry() RETURNING g_gav[l_ac].gav32
                  DISPLAY BY NAME g_gav[l_ac].gav32
                  NEXT FIELD gav32
            END CASE
         #No.FUN-710055 ---end---
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gav02) AND l_ac > 1 THEN
            LET g_gav[l_ac].* = g_gav[l_ac-1].*
            NEXT FIELD gav02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
   CLOSE p_per_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_per_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc         STRING
   DEFINE p_ac         LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE li_cnt       LIKE type_file.num5    #No.FUN-710055
   DEFINE lc_gaq06     LIKE gaq_file.gaq06    #No.FUN-7B0080
 
    LET g_sql = " SELECT gav02,'',gav07,gav03,gav04,gav16,gav12,gav13,gav14,",  #No.FUN-710055
                "        gav15,gav34,gav32,gav06,gav19,'',gav10,gav09 ",  #No.FUN-710055
                  " FROM gav_file ",
                 " WHERE gav01= '",g_gav01 CLIPPED,"' ",
                   " AND gav08= '",g_gav08 CLIPPED,"' ",
                   " AND gav11= '",g_gav11 CLIPPED,"' ",   #No.FUN-710055
                   " AND ",p_wc CLIPPED,
                 " ORDER BY gav02"
    PREPARE p_per_prepare2 FROM g_sql           #預備一下
    DECLARE gav_curs CURSOR FOR p_per_prepare2
 
    CALL g_gav.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gav_curs INTO g_gav[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          SELECT gae04 INTO g_gav[g_cnt].gae04 FROM gae_file
           WHERE gae01=g_gav01 AND gae11=g_gav08
             AND gae02=g_gav[g_cnt].gav02 AND gae03=g_lang AND gae12=g_gav11 #No.FUN-710055
          #No.FUN-710055 --start--
          SELECT COUNT(*) INTO li_cnt FROM gav_file
           WHERE gav01=g_gav01 AND gav02=g_gav[g_cnt].gav02
             AND gav08=g_gav08 AND gav11=g_gav11
             AND ((gav28='3' AND gav21 IS NOT NULL)
              OR  (gav29='3' AND gav23 IS NOT NULL)
              OR  (gav30='3' AND gav27 IS NOT NULL))
          IF li_cnt > 0 THEN
             LET g_gav[g_cnt].function = "Y"
          ELSE
             LET g_gav[g_cnt].function = "N"
          END IF
          #No.FUN-710055 ---end---
 
          #No.FUN-7B0080 --start--
          IF NOT g_open_define THEN
             SELECT UNIQUE gaq06 INTO lc_gaq06 FROM gaq_file WHERE gaq01=g_gav[g_cnt].gav02
             IF lc_gaq06 = "3" OR g_gav01 = "p_per_prog_chk" THEN   #No.FUN-840011
                LET g_open_define = TRUE
             END IF
          END IF
          #No.FUN-7B0080 ---end---
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gav.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_per_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   #No.FUN-7B0080 --start--
   IF g_open_define THEN
      CALL cl_set_comp_visible("gav12,gav13,gav14,gav15,gav16,gav17,gav18,gav19,gav20,gav21,gav22,gav23,gav24,gav25,gav26,gav27,gav28,gav29,gav30,gav31,gav33,gav34,gav36,gav37,gav39,function",TRUE)
      CALL cl_set_act_visible("preview,program_check,clear_ui_setting,chg_udfield_visible",TRUE)   #No.FUN-950073
   END IF
   #No.FUN-7B0080 ---end---
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gav TO s_gav.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        CALL DIALOG.setCellAttributes(att)    #No.FUN-710055
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
         #No.FUN-710055 --start--
         IF l_ac_o != l_ac AND l_ac_o != 0 THEN
            CALL fgl_set_arr_curr(l_ac_o)
            LET l_ac_o = 0
         END IF
         #No.FUN-710055 ---end---
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
     #----------No.TQC-6B0081 mark
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
     #----------No.TQC-6B0081 end
 
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
 
      ON ACTION modify_desc
         LET g_action_choice="modify_desc"
         LET l_ac_o = ARR_CURR()           #No.FUN-710055
         EXIT DISPLAY
 
      ON ACTION special_set
         LET g_action_choice="special_set"
         LET l_ac_o = ARR_CURR()           #No.FUN-710055
         EXIT DISPLAY
 
      #No.FUN-610065 --start--   #No.FUN-7B0080 --mark--
#     ON ACTION userdefined_field_set
#        LET g_action_choice="userdefined_field_set"
#        LET l_ac_o = ARR_CURR()           #No.FUN-710055
#        EXIT DISPLAY
      #No.FUN-610065 ---end---
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_per_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_per_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_per_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_per_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_per_fetch('L')
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
#        CALL p_per_set_combobox()                #No.FUN-760049
         CALL cl_set_combo_industry("gav11")      #No.FUN-750068
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       ON ACTION showlog                             # MOD-440464
         LET g_action_choice = "showlog"
         LET l_ac_o = ARR_CURR()           #No.FUN-710055
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------   
 
     #No.FUN-710055 --start--
     ON ACTION preview
        LET g_action_choice = "preview"
        LET l_ac_o = ARR_CURR()
        EXIT DISPLAY
 
     ON ACTION program_check
        LET g_action_choice = "program_check"
        LET l_ac_o = ARR_CURR()
        EXIT DISPLAY
 
     ON ACTION clear_ui_setting
        LET g_action_choice = "clear_ui_setting"
        LET l_ac_o = ARR_CURR()
        EXIT DISPLAY
     #No.FUN-710055 ---end---
 
     #No.FUN-950073 --start--
     ON ACTION chg_udfield_visible
        LET g_action_choice = "chg_udfield_visible"
        EXIT DISPLAY
 
     ON ACTION chg_industry_visible
        LET g_action_choice = "chg_industry_visible"
        EXIT DISPLAY
     #No.FUN-950073 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_per_copy()
   DEFINE   l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_newno   LIKE gav_file.gav01,
            l_oldno   LIKE gav_file.gav01,
            l_new08   LIKE gav_file.gav08,
            l_old08   LIKE gav_file.gav08,
            l_new11   LIKE gav_file.gav11,          #No.FUN-710055
            l_old11   LIKE gav_file.gav11           #No.FUN-710055
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
   IF g_gav01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_newno,l_new08,l_new11 WITHOUT DEFAULTS FROM gav01,gav08,gav11  #No.FUN-710055
#     AFTER INPUT
#        IF cl_null(l_newno) THEN
#           NEXT FIELD gav01
#           LET INT_FLAG = 1
#        END IF
#FUN-4C0020
#         SELECT COUNT(*) INTO g_cnt FROM gav_file
#          WHERE gav01=l_newno AND gav08=l_new08
#         IF g_cnt > 0 THEN
#            CALL cl_err(l_newno,-239,0)
#            NEXT FIELD gav01
#         END IF
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
      DISPLAY g_gav01,g_gaz03,g_gav08,g_gav11 TO gav01,gaz03,gav08,gav11  #FUN-560038  #No.FUN-710055
      RETURN
   END IF
 
   DROP TABLE x
#FUN-4C0020
   SELECT * FROM gav_file
     WHERE gav01=g_gav01 and gav08=g_gav08 and gav11=g_gav11 and gav02 NOT IN  #No.FUN-710055
     (SELECT gav02 FROM gav_file WHERE gav01=l_newno and gav08=l_new08 and gav11=l_new11)  #No.FUN-710055
     INTO TEMP x
{
   SELECT * FROM gav_file WHERE gav01=g_gav01 AND gav08=g_gav08 AND gav11=g_gav11  #No:No.FUN-710055
     INTO TEMP x
}
#FUN-4C0020(END)
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_gav01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_gav01,g_gav08,SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET gav01 = l_newno,                        # 資料鍵值
           gav08 = l_new08,                        # MOD-4C0164
           gav11 = l_new11                         #No.FUN-710055
 
   INSERT INTO gav_file SELECT * FROM x 
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('gav:',SQLCA.SQLCODE,0)  #No.FUN-660081
      CALL cl_err3("ins","gav_file",l_newno,l_new08,SQLCA.sqlcode,"","gav",0)   #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldno = g_gav01
   LET l_old08 = g_gav08
   LET l_old11 = g_gav11  #No.FUN-710055
   LET g_gav01 = l_newno
   LET g_gav08 = l_new08
   LET g_gav11 = l_new11  #No.FUN-710055
 
   CALL p_per_b()
   #FUN-C30027---begin
   #LET g_gav01 = l_oldno
   #LET g_gav08 = l_old08
   #LET g_gav11 = l_old11  #No.FUN-710055
   #CALL p_per_show()
   #FUN-C30027---end
END FUNCTION
 
 #No.MOD-580056 --start
FUNCTION p_per_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gav01,gav08,gav11",TRUE)  #No.FUN-710055
   END IF
 
END FUNCTION
 
FUNCTION p_per_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gav01,gav08,gav11",FALSE)  #No.FUN-710055
   END IF
END FUNCTION
 
#NO.MOD-590329 MARK---------------------------------
#FUNCTION p_per_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gav02",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_per_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gav02",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580056 --end
#NO.MOD-590329 MARK-----------------------------------
 
#No.FUN-610065 --start--
FUNCTION p_per_userdefined_field(pc_gav01,pc_gav02,pc_gav08)
   DEFINE   pc_gav01   LIKE gav_file.gav01
   DEFINE   pc_gav02   LIKE gav_file.gav02
   DEFINE   pc_gav08   LIKE gav_file.gav08
   DEFINE   lc_tabcode LIKE gat_file.gat01
   DEFINE   lc_fldcode LIKE gaq_file.gaq01
   DEFINE   ls_str     STRING
   DEFINE   li_cnt     LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   ls_sql     STRING
   DEFINE   ld_date    LIKE type_file.dat     #FUN-680135 DATE
   DEFINE   lc_gaq06   LIKE gaq_file.gaq06    #No.FUN-710055
 
   #No.FUN-710055 --start--
#  IF (pc_gav02 NOT MATCHES "???ud[01][0-9]") AND (pc_gav02 NOT MATCHES "????ud[01][0-9]") THEN
#     RETURN
#  END IF
   SELECT UNIQUE gaq06 INTO lc_gaq06 FROM gaq_file WHERE gaq01=pc_gav02
   IF lc_gaq06 != "3" OR SQLCA.sqlcode THEN
     # CALL cl_err(pc_gav02,"azz-118",1)
     # RETURN
   END IF
   #No.FUN-710055 ---end---
 
   OPEN WINDOW p_per_userdefined_w WITH FORM "azz/42f/p_per_userdefined"   
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_locale("p_per_userdefined")
 
   LET g_forupd_sql = "SELECT * from gbr_file",
                      " WHERE gbr01=? AND gbr02=? AND gbr03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gbr_lock CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN p_gbr_lock USING pc_gav01,pc_gav02,pc_gav08
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_gbr_lock
      ROLLBACK WORK
      CLOSE WINDOW p_per_userdefined_w
      RETURN
   END IF
   FETCH p_gbr_lock INTO g_gbr.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gbr.gbr01,SQLCA.sqlcode,1)
      CLOSE p_gbr_lock
      ROLLBACK WORK
      CLOSE WINDOW p_per_userdefined_w
      RETURN
   ELSE
      DISPLAY BY NAME g_gbr.gbr01,g_gbr.gbr02,g_gbr.gbr03,g_gbr.gbr04,
                      g_gbr.gbr05,g_gbr.gbr06,g_gbr.gbr07,g_gbr.gbr08
 
      WHILE TRUE 
         INPUT BY NAME g_gbr.gbr04,g_gbr.gbr05,g_gbr.gbr06,g_gbr.gbr07,
                       g_gbr.gbr08 WITHOUT DEFAULTS
            BEFORE INPUT
               LET g_gbr_t.* = g_gbr.*
               IF (g_gbr.gbr02 MATCHES "???ud0[2-6]") OR
                  (g_gbr.gbr02 MATCHES "????ud0[2-6]") THEN
                  LET g_gbr.gbr05 = "N"
                  CALL cl_set_comp_entry("gbr05",FALSE)
               ELSE
                  CALL cl_set_comp_entry("gbr05",TRUE)
               END IF
               IF (g_gbr.gbr02 NOT MATCHES "???ud0[2-6]") AND
                  (g_gbr.gbr02 NOT MATCHES "????ud0[2-6]") THEN
                  LET g_gbr.gbr08 = ""
                  CALL cl_set_comp_entry("gbr08",FALSE)
               ELSE
                  CALL cl_set_comp_entry("gbr08",TRUE)
               END IF
               IF g_gbr.gbr05 = "Y" THEN
                  CALL cl_set_comp_entry("gbr06,gbr07",TRUE)
               ELSE
                  LET g_gbr.gbr06 = NULL
                  LET g_gbr.gbr07 = NULL
                  DISPLAY BY NAME g_gbr.gbr06,g_gbr.gbr07
                  CALL cl_set_comp_entry("gbr06,gbr07",FALSE)
               END IF
 
            AFTER FIELD gbr04
               IF NOT cl_null(g_gbr.gbr04) THEN
                  LET ls_str = g_gbr.gbr04
                  LET lc_tabcode = ls_str.subString(1,ls_str.getIndexOf(".",1) - 1)
                  LET lc_fldcode = ls_str.subString(ls_str.getIndexOf(".",1) + 1,ls_str.getLength())
                  #SELECT COUNT(*) INTO li_cnt FROM gat_file WHERE gat01=lc_tabcode     #No.FUN-A70082 mark
                  SELECT COUNT(*) INTO li_cnt FROM zta_file WHERE zta01 = lc_tabcode AND zta02 = 'ds'   #No.FUN-A70082
                  IF li_cnt <= 0 THEN
                     CALL cl_err(g_gbr.gbr04,"-217",1)
                     NEXT FIELD gbr04
                  ELSE
                     LET ls_str = lc_tabcode
                     LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) - 1)
                     LET ls_sql = "SELECT COUNT(*) FROM gaq_file",
                                  " WHERE gaq01 MATCHES '*",ls_str,"*' AND gaq01='",lc_fldcode CLIPPED,"'"
                     PREPARE gaq_cnt FROM ls_sql
                     EXECUTE gaq_cnt INTO li_cnt
                     IF li_cnt <= 0 THEN
                        CALL cl_err(g_gbr.gbr04,"-217",1)
                        NEXT FIELD gbr04
                     END IF
                  END IF
               END IF
 
            AFTER FIELD gbr08
               IF NOT cl_null(g_gbr.gbr08) THEN
                  SELECT COUNT(*) INTO li_cnt FROM gab_file WHERE gab01=g_gbr.gbr08
                  IF li_cnt <= 0 THEN
                     CALL cl_err(g_gbr.gbr08,"100",0)
                     NEXT FIELD gbr08
                  END IF
               END IF
 
            ON CHANGE gbr05
               IF g_gbr.gbr05 = "Y" THEN
                  CALL cl_set_comp_entry("gbr06,gbr07",TRUE)
               ELSE
                  LET g_gbr.gbr06 = NULL
                  LET g_gbr.gbr07 = NULL
                  DISPLAY BY NAME g_gbr.gbr06,g_gbr.gbr07
                  CALL cl_set_comp_entry("gbr06,gbr07",FALSE)
               END IF
 
            AFTER FIELD gbr06
               IF NOT cl_null(g_gbr.gbr06) THEN
                  IF (g_gbr.gbr02 MATCHES "???ud[0][7-9]") OR
                     (g_gbr.gbr02 MATCHES "????ud[0][7-9]") OR
                     (g_gbr.gbr02 MATCHES "???ud[1][0-2]") OR
                     (g_gbr.gbr02 MATCHES "????ud[1][0-2]") THEN
                     IF NOT cl_numchk(g_gbr.gbr06 CLIPPED,0) THEN
                        NEXT FIELD gbr06
                     END IF
                  END IF
                  IF (g_gbr.gbr02 MATCHES "???ud[1][3-5]") OR
                     (g_gbr.gbr02 MATCHES "????ud[1][3-5]") THEN
                     LET ld_date = g_gbr.gbr06
                     IF cl_null(ld_date) THEN
                        NEXT FIELD gbr06
                     END IF
                     LET g_gbr.gbr06=ld_date
                     DISPLAY BY NAME g_gbr.gbr06
                  END IF
               END IF
 
            AFTER FIELD gbr07
               IF NOT cl_null(g_gbr.gbr07) THEN
                  IF (g_gbr.gbr02 MATCHES "???ud[0][7-9]") OR
                     (g_gbr.gbr02 MATCHES "????ud[0][7-9]") OR
                     (g_gbr.gbr02 MATCHES "???ud[1][0-2]") OR
                     (g_gbr.gbr02 MATCHES "????ud[1][0-2]") THEN
                     IF NOT cl_numchk(g_gbr.gbr07 CLIPPED,0) THEN
                        NEXT FIELD gbr07
                     END IF
                  END IF
                  IF (g_gbr.gbr02 MATCHES "???ud[1][3-5]") OR
                     (g_gbr.gbr02 MATCHES "????ud[1][3-5]") THEN
                     LET ld_date = g_gbr.gbr07
                     IF cl_null(ld_date) THEN
                        NEXT FIELD gbr07
                     END IF
                     LET g_gbr.gbr07=ld_date
                     DISPLAY BY NAME g_gbr.gbr07
                  END IF
               END IF
 
            ON ACTION tab_sel
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING lc_tabcode
               LET g_gbr.gbr04 = lc_tabcode CLIPPED,".",lc_fldcode CLIPPED
               DISPLAY BY NAME g_gbr.gbr04
               NEXT FIELD gbr04
            ON ACTION fld_sel
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaq"
               LET g_qryparam.arg1 = g_lang CLIPPED
               LET ls_str = lc_tabcode
               LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
               LET g_qryparam.arg2 = ls_str
               CALL cl_create_qry() RETURNING lc_fldcode
               LET g_gbr.gbr04 = lc_tabcode CLIPPED,".",lc_fldcode CLIPPED
               DISPLAY BY NAME g_gbr.gbr04
               NEXT FIELD gbr04
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(gbr08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gac"
                     LET g_qryparam.default1 = g_gbr.gbr08
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     CALL cl_create_qry() RETURNING g_gbr.gbr08
                     DISPLAY BY NAME g_gbr.gbr08
                     NEXT FIELD gbr08
               END CASE
 
            ON ACTION about         #FUN-860033
               CALL cl_about()      #FUN-860033
       
            ON ACTION controlg      #FUN-860033
               CALL cl_cmdask()     #FUN-860033
       
            ON ACTION help          #FUN-860033
               CALL cl_show_help()  #FUN-860033
       
            ON IDLE g_idle_seconds  #FUN-860033
                CALL cl_on_idle()
                CONTINUE INPUT
 
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = FALSE
            CLOSE p_gbr_lock
            ROLLBACK WORK
         ELSE
            UPDATE gbr_file SET gbr04=g_gbr.gbr04,gbr05=g_gbr.gbr05,
                                gbr06=g_gbr.gbr06,gbr07=g_gbr.gbr07,
                                gbr08=g_gbr.gbr08
                          WHERE gbr01=g_gbr.gbr01 AND gbr02=g_gbr.gbr02 AND gbr03=g_gbr.gbr03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbr.gbr01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gbr_file",g_gbr.gbr01,g_gbr.gbr02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gbr.* = g_gbr_t.*
               CONTINUE WHILE
            ELSE
               COMMIT WORK
               CLOSE p_gbr_lock
            END IF
         END IF
         EXIT WHILE
      END WHILE
   END IF
   CLOSE WINDOW p_per_userdefined_w
END FUNCTION
#No.FUN-610065 ---end---
 
#No.FUN-710055 --start--
FUNCTION p_per_set_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   CALL cl_set_comp_entry("gav12,gav14,gav15,gav16,gav34",FALSE)
END FUNCTION
 
FUNCTION p_per_set_no_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE ls_module       STRING
   DEFINE ls_frm_path     STRING
   DEFINE lwin_curr ui.Window
   DEFINE lfrm_curr ui.Form
   DEFINE lnode_item om.DomNode
   DEFINE ls_tag_name     STRING
   DEFINE ls_tabname      STRING  #No.FUN-720042
 
   IF cl_null(g_gav01) OR cl_null(g_gav08) OR cl_null(g_gav11) THEN #OR g_gav11 = g_std_id THEN  #No.FUN-7B0080
      RETURN
   END IF
   CALL p_per_get_module(g_gav01 CLIPPED,g_gav08 CLIPPED) RETURNING ls_module,ls_frm_path
   IF cl_null(ls_module) THEN
      RETURN
   END IF
 
   OPEN WINDOW test_w WITH FORM ls_frm_path
   IF g_gav[l_ac].gav02 IS NOT NULL THEN
      LET lwin_curr = ui.Window.getCurrent()
      LET lfrm_curr = lwin_curr.getForm()
      LET ls_tabname = cl_get_table_name(g_gav[l_ac].gav02 CLIPPED)   #No.FUN-720042
      LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||g_gav[l_ac].gav02 CLIPPED)   #No.FUN-720042
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("FormField","formonly."||g_gav[l_ac].gav02 CLIPPED)
         IF lnode_item IS NULL THEN
            LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||g_gav[l_ac].gav02 CLIPPED)   #No.FUN-720042
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("TableColumn","formonly."||g_gav[l_ac].gav02 CLIPPED)
            END IF
         END IF
      END IF
      IF lnode_item IS NULL THEN
         CLOSE WINDOW test_w
         RETURN
      END IF
      LET ls_tag_name = lnode_item.getTagName()
   END IF
   CLOSE WINDOW test_w
   CASE ls_tag_name
      WHEN "FormField"
         CALL cl_set_comp_entry("gav12,gav14,gav15,gav16,gav34",TRUE)
      WHEN "TableColumn"
         CALL cl_set_comp_entry("gav12",TRUE)
   END CASE
END FUNCTION
 
FUNCTION p_per_get_module(ps_frm_name,ps_cust)
   DEFINE   ps_frm_name STRING
   DEFINE   ps_cust     STRING
   DEFINE   li_i        LIKE type_file.num10
   DEFINE   li_error    LIKE type_file.num5
   DEFINE   lc_gao01    LIKE gao_file.gao01
   DEFINE   lc_gax02    LIKE gax_file.gax02
   DEFINE   lc_zz011    LIKE zz_file.zz011
   DEFINE   ls_module   STRING
   DEFINE   ls_frm_path STRING
 
   LET li_error = FALSE
   CASE
      WHEN ps_frm_name.subString(1,1)="a" OR ps_frm_name.subString(1,1)="g"
         FOR li_i=3 TO ps_frm_name.getLength()
             LET ls_module = ps_frm_name.subString(1,li_i)
             LET lc_gao01 = UPSHIFT(ls_module.trim())
             SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
             IF NOT SQLCA.SQLCODE THEN
                LET li_error=FALSE
                EXIT FOR
             ELSE
                LET li_error=TRUE
             END IF
         END FOR
         IF ps_cust = "Y" AND NOT li_error THEN
            IF ps_frm_name.subString(1,1)="a" THEN
               LET ls_module = "c" || ls_module.subString(2,ls_module.getLength())
            ELSE
               LET ls_module = "c" || ls_module.subString(1,ls_module.getLength())
            END IF
         END IF
      WHEN ps_frm_name.subString(1,2)="sa" OR ps_frm_name.subString(1,2)="sg"
         FOR li_i=4 TO ps_frm_name.getLength()
            LET ls_module = ps_frm_name.subString(2,li_i)
            LET lc_gao01 = UPSHIFT(ls_module.trim())
            SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
            IF NOT SQLCA.SQLCODE THEN
               LET li_error=FALSE
               EXIT FOR
            ELSE
               LET li_error=TRUE
            END IF
         END FOR
         IF ps_cust = "Y" AND NOT li_error THEN
            LET ls_module = "c" || ls_module.subString(2,ls_module.getLength())
         END IF
      WHEN ps_frm_name.subString(1,2)="sc" 
         FOR li_i=4 TO ps_frm_name.getLength()
            LET ls_module = ps_frm_name.subString(2,li_i)
            LET lc_gao01 = UPSHIFT(ls_module.trim())
            SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
            IF NOT SQLCA.SQLCODE THEN
               EXIT FOR
            END IF
         END FOR
      WHEN ps_frm_name.subString(1,2)="p_" OR ps_frm_name.trim()="udm_tree" 
         IF ps_cust = "Y" THEN
            LET ls_module = "czz"
         ELSE
            LET lc_gax02 = ps_frm_name.trim()
            SELECT zz011 INTO lc_zz011 FROM zz_file,gax_file
             WHERE gax02 = lc_gax02 AND gax01 = zz01
            IF DOWNSHIFT(lc_zz011) = "ain" THEN
               LET ls_module = "ain"
            ELSE
               LET ls_module = "azz"
            END IF
         END IF
      WHEN ps_frm_name.subString(1,2)="s_" 
         IF ps_cust = "Y" THEN
            LET ls_module = "csub"
         ELSE
            LET ls_module = "sub"
         END IF
      WHEN ps_frm_name.subString(1,2)="q_" 
         IF ps_cust = "Y" THEN
            LET ls_module = "cqry"
         ELSE
            LET ls_module = "qry"
         END IF
      WHEN ps_frm_name.subString(1,1)="c" 
         CASE
            WHEN ps_frm_name.subString(2,3)="l_"
               IF ps_cust = "Y" THEN
                  LET ls_module = "clib"
               ELSE
                  LET ls_module = "lib"
               END IF
            WHEN ps_frm_name.subString(2,4)="cl_"
               LET ls_module = "clib"
            WHEN ps_frm_name.subString(2,3)="p_"
               LET ls_module = "czz"
            WHEN ps_frm_name.subString(2,3)="q_"
               LET ls_module = "cqry"
            WHEN ps_frm_name.subString(2,3)="s_"
               LET ls_module = "csub"
            OTHERWISE
               FOR li_i=3 TO ps_frm_name.getLength()
                  LET ls_module = ps_frm_name.subString(1,li_i)
                  LET lc_gao01 = UPSHIFT(ls_module.trim())
                  SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
                  IF NOT SQLCA.SQLCODE THEN
                     EXIT FOR
                  END IF
               END FOR
         END CASE
      OTHERWISE
         RETURN ls_module,ls_frm_path
   END CASE
 
   IF ps_cust = "Y" THEN
      LET ls_frm_path = FGL_GETENV("CUST") || "/" || DOWNSHIFT(ls_module CLIPPED) || "/42f/" || ps_frm_name CLIPPED
   ELSE
      LET ls_frm_path = FGL_GETENV("TOP")  || "/" || DOWNSHIFT(ls_module CLIPPED) || "/42f/" || ps_frm_name CLIPPED
   END IF
 
   RETURN ls_module,ls_frm_path
END FUNCTION
 
FUNCTION p_per_b_chg_bgcolor()
   DEFINE ls_module       STRING
   DEFINE ls_frm_path     STRING
   DEFINE lwin_curr       ui.Window
   DEFINE lnode_win       om.DomNode
   DEFINE lnode_item      om.DomNode
   DEFINE llst_items      om.NodeList
   DEFINE li_i            LIKE type_file.num10
   DEFINE li_j            LIKE type_file.num10
   DEFINE ls_item_name    STRING
 
   IF cl_null(g_gav01) OR cl_null(g_gav08) OR cl_null(g_gav11) THEN
      RETURN
   END IF
 
   CALL p_per_get_module(g_gav01 CLIPPED,g_gav08 CLIPPED) RETURNING ls_module,ls_frm_path
   IF cl_null(ls_module) THEN
      RETURN
   END IF
 
   OPEN WINDOW test_w WITH FORM ls_frm_path
   LET lwin_curr = ui.Window.getCurrent()
   LET lnode_win = lwin_curr.getNode()
   LET llst_items = lnode_win.selectByTagName("FormField")
   FOR li_i = 1 TO llst_items.getLength()
       LET lnode_item = llst_items.item(li_i)
       LET ls_item_name = lnode_item.getAttribute("colName")
       FOR li_j = 1 TO g_gav.getLength()
           IF ls_item_name.equals(g_gav[li_j].gav02 CLIPPED) THEN
              LET att[li_j].gav02 = "Olive reverse"
              EXIT FOR
           END IF
       END FOR
   END FOR
   LET llst_items = lnode_win.selectByTagName("TableColumn")
   FOR li_i = 1 TO llst_items.getLength()
       LET lnode_item = llst_items.item(li_i)
       LET ls_item_name = lnode_item.getAttribute("colName")
       FOR li_j = 1 TO g_gav.getLength()
           IF ls_item_name.equals(g_gav[li_j].gav02 CLIPPED) THEN
              LET att[li_j].gav02 = "lightOlive reverse"
              EXIT FOR
           END IF
       END FOR
   END FOR
   
   CLOSE WINDOW test_w
END FUNCTION
 
FUNCTION p_per_view()
   DEFINE   ls_module     STRING
   DEFINE   li_i          LIKE type_File.num5
   DEFINE   ls_frm_path   STRING
 
   IF cl_null(g_gav01) OR cl_null(g_gav08) OR cl_null(g_gav11) THEN
      RETURN
   END IF
 
   CALL p_per_get_module(g_gav01 CLIPPED,g_gav08 CLIPPED) RETURNING ls_module,ls_frm_path
   IF cl_null(ls_module) THEN
      RETURN
   END IF
 
   DISPLAY "PREVIEW:",ls_frm_path
 
   WHILE TRUE
      OPEN WINDOW w_curr WITH FORM ls_frm_path
 
      LET g_ui_setting = g_gav11
      LET g_action_choice = "preview"
      CALL cl_set_locale_frm_name(g_gav01 CLIPPED)
      CALL cl_ui_init()
      LET g_ui_setting = ""
      LET g_action_choice = ""
 
      MENU ""
        BEFORE MENU
           #No.FUN-7B0080 --mark start--
#          IF g_gav11 = g_std_id THEN
#             HIDE OPTION "chg_location","chg_tabindex"
#          ELSE
#             SHOW OPTION "chg_location","chg_tabindex"
#          END IF
           #No.FUN-7B0080 ---mark end---
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION chg_location
           CALL p_per_chg_location()
           IF INT_FLAG THEN
              LET INT_FLAG = FALSE
              CONTINUE MENU
           END IF
           CALL p_per_b_fill(g_wc)
           CALL p_per_b_chg_bgcolor()   #No.FUN-7B0080
           EXIT MENU
 
        ON ACTION chg_tabindex
           CALL p_per_chg_tabIndex()
           IF INT_FLAG THEN
              LET INT_FLAG = FALSE
              CONTINUE MENU
           END IF
           CALL p_per_b_fill(g_wc)
           CALL p_per_b_chg_bgcolor()   #No.FUN-7B0080
           EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about         #FUN-860033
           CALL cl_about()      #FUN-860033
   
        ON ACTION controlg      #FUN-860033
           CALL cl_cmdask()     #FUN-860033
   
        ON ACTION help          #FUN-860033
           CALL cl_show_help()  #FUN-860033
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET g_action_choice = "exit"
           LET INT_FLAG=FALSE
           EXIT MENU
      END MENU
 
      CLOSE WINDOW w_curr
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE
   IF g_chg_flag THEN
      IF NOT cl_confirm("azz-736") THEN
         FOR li_i = 1 TO g_gav_o.getLength()
             UPDATE gav_file SET gav13 = g_gav_o[li_i].gav13,gav14 = g_gav_o[li_i].gav14,
                                 gav15 = g_gav_o[li_i].gav15,gav16 = g_gav_o[li_i].gav16,
                                 gav34 = g_gav_o[li_i].gav34
              WHERE gav01=g_gav01 AND gav02=g_gav_o[li_i].gav02 AND gav08=g_gav08 AND gav11=g_gav11
         END FOR
         CALL p_per_b_fill(g_wc)
         CALL p_per_b_chg_bgcolor()   #No.FUN-7B0080
      END IF
   END IF
END FUNCTION
 
FUNCTION p_per_chg_location()
   DEFINE li_i         LIKE type_file.num5
   DEFINE ls_str       STRING
   DEFINE ls_str2      STRING
   DEFINE lc_fld_chg   LIKE gav_file.gav02
   DEFINE lc_fld_page  LIKE gav_file.gav02
   DEFINE lc_fld_h     LIKE gav_file.gav02
   DEFINE lc_fld_v     LIKE gav_file.gav02
   DEFINE lc_fld_bef   LIKE gav_file.gav02
   DEFINE lc_tab_flag  LIKE type_file.chr1
   DEFINE ls_step_flag LIKE type_file.num5
   DEFINE lc_gav02_rel LIKE gav_file.gav02
   DEFINE lc_gav12_h   LIKE gav_file.gav12
   DEFINE lc_gav13     LIKE gav_file.gav13
   DEFINE lc_gav14     LIKE gav_file.gav14
   DEFINE lc_gav14_h   LIKE gav_file.gav14
   DEFINE lc_gav14_chg LIKE gav_file.gav14
   DEFINE lc_gav15     LIKE gav_file.gav15
   DEFINE lc_gav15_rel LIKE gav_file.gav15
   DEFINE lc_gav34     LIKE gav_file.gav34
   DEFINE lc_gav34_chg LIKE gav_file.gav34
   DEFINE lwin_curr    ui.Window                #No.EXT-B60126
   DEFINE lfrm_curr    ui.Form                  #No.EXT-B60126
   DEFINE lnode_item   om.DomNode               #No.EXT-B60126
   DEFINE ls_tabname   STRING                   #No.EXT-B60126
 
   OPEN WINDOW chg_location_w WITH FORM "azz/42f/p_per_chg_location"
      ATTRIBUTE(STYLE="viewer")
   CALL cl_ui_locale("p_per_chg_location")
 
   #No.FUN-7B0080 --start--
   CALL p_per_b_fill('1=1')
   CALL p_per_b_chg_bgcolor()
   #No.FUN-7B0080 ---end---
 
   FOR li_i = 1 TO g_gav.getLength()
       IF att[li_i].gav02 = "Olive reverse" AND NOT cl_null(g_gav[li_i].gav13) AND g_gav[li_i].gav03 = "Y" THEN
          LET ls_str = ls_str,g_gav[li_i].gav02,","
          IF NOT cl_null(g_gav[li_i].gae04) THEN
             LET ls_str2 = ls_str2,g_gav[li_i].gav02,"[",g_gav[li_i].gae04 CLIPPED,"]",","
          ELSE
             LET ls_str2 = ls_str2,g_gav[li_i].gav02,","
          END IF
       END IF
   END FOR
   LET ls_str = ls_str.subString(1,ls_str.getLength()-1)
   LET ls_str2 = ls_str2.subString(1,ls_str2.getLength()-1)
   CALL cl_set_combo_items("chg_field",ls_str,ls_str2)
   CALL cl_set_combo_items("page_field",ls_str,ls_str2)
   CALL cl_set_combo_items("h_field",ls_str,ls_str2)
   CALL cl_set_combo_items("v_field",ls_str,ls_str2)
   CALL cl_set_combo_items("before_field",ls_str,ls_str2)
 
   LET lc_tab_flag = "N"
   DISPLAY lc_tab_flag TO formonly.tabindex_flag
   OPTIONS INPUT WRAP                                  #No.EXT-B60126 4js建議WRAP以避免回到上一步驟會當掉
   INPUT lc_fld_chg,lc_fld_page,lc_fld_h,lc_fld_v,lc_fld_bef,lc_tab_flag WITHOUT DEFAULTS
    FROM formonly.chg_field,formonly.page_field,formonly.h_field,formonly.v_field,formonly.before_field,formonly.tabindex_flag
      BEFORE INPUT
         CALL cl_set_comp_visible("group01,group02,group03,group04,tabindex_flag,prev_step,next_step,loc_finish",TRUE)
         CALL cl_set_comp_visible("group02,group03,group04,tabindex_flag,prev_step,loc_finish",FALSE)
         CALL cl_set_comp_entry("before_field",FALSE)
         LET ls_step_flag = 1
 
      ON CHANGE v_field
         IF cl_null(lc_fld_v) THEN
            CALL cl_set_comp_entry("before_field",FALSE)
         ELSE
            CALL cl_set_comp_entry("before_field",TRUE)
         END IF

      ON ACTION next_step
         #No.EXT-B60126 --start-- 避免回到上一筆，值無法顯示於畫面上
         LET lc_fld_chg = GET_FLDBUF(formonly.chg_field)
         LET lc_fld_page = GET_FLDBUF(formonly.page_field)
         LET lc_fld_h = GET_FLDBUF(formonly.h_field)
         LET lc_fld_v = GET_FLDBUF(formonly.v_field)
         LET lc_fld_bef = GET_FLDBUF(formonly.before_field)
         LET lc_tab_flag = GET_FLDBUF(formonly.tabindex_flag)
         #No.EXT-B60126 ---end---
         LET ls_step_flag = ls_step_flag + 1
         CALL cl_set_comp_visible("group01,group02,group03,group04,tabindex_flag,prev_step,next_step,loc_finish",TRUE)
         CASE ls_step_flag
            WHEN 2
               CALL cl_set_comp_visible("group01,group03,group04,tabindex_flag,loc_finish",FALSE)
            WHEN 3
               CALL cl_set_comp_visible("group01,group02,group04,tabindex_flag,loc_finish",FALSE)
            WHEN 4
               CALL cl_set_comp_visible("group01,group02,group03,tabindex_flag,loc_finish",FALSE)
            WHEN 5
               CALL cl_set_comp_visible("group01,group02,group03,group04,next_step",FALSE)
         END CASE
         CONTINUE INPUT
 
      ON ACTION prev_step
         #No.EXT-B60126 --start-- 避免回到上一筆，值無法顯示於畫面上
         LET lc_fld_chg = GET_FLDBUF(formonly.chg_field)
         LET lc_fld_page = GET_FLDBUF(formonly.page_field)
         LET lc_fld_h = GET_FLDBUF(formonly.h_field)
         LET lc_fld_v = GET_FLDBUF(formonly.v_field)
         LET lc_fld_bef = GET_FLDBUF(formonly.before_field)
         LET lc_tab_flag = GET_FLDBUF(formonly.tabindex_flag)
         #No.EXT-B60126 ---end---
         LET ls_step_flag = ls_step_flag - 1
         CALL cl_set_comp_visible("group01,group02,group03,group04,tabindex_flag,prev_step,next_step,loc_finish",TRUE)
         CASE ls_step_flag
            WHEN 1
               CALL cl_set_comp_visible("group02,group03,group04,tabindex_flag,prev_step,loc_finish",FALSE)
            WHEN 2
               CALL cl_set_comp_visible("group01,group03,group04,tabindex_flag,loc_finish",FALSE)
            WHEN 3
               CALL cl_set_comp_visible("group01,group02,group04,tabindex_flag,loc_finish",FALSE)
            WHEN 4
               CALL cl_set_comp_visible("group01,group02,group03,tabindex_flag,loc_finish",FALSE)
         END CASE
         CONTINUE INPUT
 
      ON ACTION loc_finish
         #No.EXT-B60126 --start--
         LET lc_fld_chg = GET_FLDBUF(formonly.chg_field)
         LET lc_fld_page = GET_FLDBUF(formonly.page_field)
         LET lc_fld_h = GET_FLDBUF(formonly.h_field)
         LET lc_fld_v = GET_FLDBUF(formonly.v_field)
         LET lc_fld_bef = GET_FLDBUF(formonly.before_field)
         #No.EXT-B60126 ---end---
         LET lc_tab_flag = GET_FLDBUF(formonly.tabindex_flag)
         LET ls_step_flag = 6
         EXIT INPUT
 
      AFTER INPUT
         LET lc_tab_flag = GET_FLDBUF(formonly.tabindex_flag)
         IF ls_step_flag = 6 OR INT_FLAG THEN
            EXIT INPUT
         ELSE
            CONTINUE INPUT
         END IF
         
     ON ACTION about         #FUN-860033
        CALL cl_about()      #FUN-860033
 
     ON ACTION controlg      #FUN-860033
        CALL cl_cmdask()     #FUN-860033
 
     ON ACTION help          #FUN-860033
        CALL cl_show_help()  #FUN-860033
 
     ON IDLE g_idle_seconds  #FUN-860033
         CALL cl_on_idle()
         CONTINUE INPUT 
 
   END INPUT
   OPTIONS INPUT NO WRAP                                  #No.EXT-B60126 恢復option設定
   IF INT_FLAG THEN
      CLOSE WINDOW chg_location_w
      RETURN
   END IF
   CLOSE WINDOW chg_location_w
 
   IF NOT cl_null(lc_fld_chg) AND NOT cl_null(lc_fld_page) THEN
      SELECT gav13 INTO lc_gav13 FROM gav_file
       WHERE gav01=g_gav01 AND gav02=lc_fld_page AND gav08=g_gav08 AND gav11=g_gav11
 
      IF cl_null(lc_fld_h) THEN
         SELECT MAX(gav15)+1 INTO lc_gav15 FROM gav_file
          WHERE gav01=g_gav01 AND gav08=g_gav08 AND gav11=g_gav11 AND gav13=lc_gav13
      ELSE
         SELECT gav15 INTO lc_gav15 FROM gav_file
          WHERE gav01=g_gav01 AND gav02=lc_fld_h AND gav08=g_gav08 AND gav11=g_gav11
      END IF
      IF cl_null(lc_fld_v) THEN
         IF cl_null(lc_fld_h) THEN
            SELECT gav14,gav34 INTO lc_gav14,lc_gav34 FROM gav_file
             WHERE gav01=g_gav01 AND gav02=lc_fld_chg AND gav08=g_gav08 AND gav11=g_gav11
            SELECT MAX(gav15)+1 INTO lc_gav15 FROM gav_file
             WHERE gav01=g_gav01 AND gav08=g_gav08 AND gav11=g_gav11 AND gav13=lc_gav13
         ELSE
            SELECT gav12,gav14 INTO lc_gav12_h,lc_gav14_h FROM gav_file
             WHERE gav01=g_gav01 AND gav02=lc_fld_h AND gav08=g_gav08 AND gav11=g_gav11
            SELECT gav14,gav34 INTO lc_gav14_chg,lc_gav34_chg FROM gav_file
             WHERE gav01=g_gav01 AND gav02=lc_fld_chg AND gav08=g_gav08 AND gav11=g_gav11
            LET lc_gav34 = lc_gav12_h+lc_gav14_h+1
            LET lc_gav14 = lc_gav34 + (lc_gav14_chg-lc_gav34_chg) + 1
         END IF
      ELSE
         SELECT gav14,gav34 INTO lc_gav14,lc_gav34 FROM gav_file
          WHERE gav01=g_gav01 AND gav02=lc_fld_v AND gav08=g_gav08 AND gav11=g_gav11
         IF NOT cl_null(lc_fld_bef) THEN
            SELECT gav15 INTO lc_gav15 FROM gav_file
             WHERE gav01=g_gav01 AND gav02=lc_fld_bef AND gav08=g_gav08 AND gav11=g_gav11
            LET g_sql = "SELECT gav02,gav15 FROM gav_file",
                        " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
                        "   AND gav11='",g_gav11 CLIPPED,"' AND gav13='",lc_gav13 CLIPPED,"'",
                        "   AND gav14=",lc_gav14," AND gav15>=",lc_gav15
            PREPARE vertical_pre FROM g_sql
            DECLARE vertical_curs CURSOR FOR vertical_pre
            FOREACH vertical_curs INTO lc_gav02_rel,lc_gav15_rel
               UPDATE gav_file SET gav15=lc_gav15_rel+1
                WHERE gav01=g_gav01 AND gav02=lc_gav02_rel AND gav08=g_gav08 AND gav11=g_gav11
            END FOREACH
         END IF
      END IF
 
      #No.EXT-B60126 --start--
      LET lwin_curr = ui.Window.getCurrent()
      LET lfrm_curr = lwin_curr.getForm()
      LET ls_tabname = cl_get_table_name(lc_fld_page)
      LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||lc_fld_page CLIPPED)
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("FormField","formonly."||lc_fld_page CLIPPED)
      END IF
      IF lnode_item IS NOT NULL THEN
         LET lnode_item = lnode_item.getParent()
         LET lc_gav13 = lnode_item.getAttribute("name")
      END IF
      #No.EXT-B60126 ---end---

      UPDATE gav_file SET gav13 = lc_gav13, gav14 = lc_gav14, gav15 = lc_gav15, gav34 = lc_gav34
       WHERE gav01=g_gav01 AND gav02=lc_fld_chg AND gav08=g_gav08 AND gav11=g_gav11
      LET g_chg_flag = TRUE
   END IF
   IF lc_tab_flag = "Y" THEN
      CALL p_per_chg_tabIndex()
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
      END IF
   END IF
END FUNCTION
 
FUNCTION p_per_chg_tabIndex()
   DEFINE   li_i            LIKE type_file.num5
   DEFINE   li_cnt          LIKE type_file.num5
   DEFINE   li_arr          LIKE type_file.num5
   DEFINE   li_arr_o        LIKE type_file.num5
   DEFINE   li_start_flag   LIKE type_file.num5
   DEFINE   ls_choice       STRING
 
   LET g_sql = "SELECT 'N',gav02,'',gav16,0 FROM gav_file",
               " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
               "   AND gav11='",g_gav11 CLIPPED,"' AND gav16 IS NOT NULL AND gav16 > 0",
               " ORDER BY gav16"
   PREPARE tabindex_pre FROM g_sql
   DECLARE tabindex_curs CURSOR FOR tabindex_pre
   LET li_cnt = 1
   FOREACH tabindex_curs INTO g_tabindex[li_cnt].*
      FOR li_i = 1 TO g_gav.getLength()
          IF g_tabindex[li_cnt].gav02 = g_gav[li_i].gav02 AND 
             att[li_i].gav02 = "Olive reverse" THEN
             LET g_tabindex[li_cnt].gae04 = g_gav[li_i].gae04
             LET li_cnt = li_cnt + 1
             EXIT FOR
          END IF
      END FOR
   END FOREACH
   CALL g_tabindex.deleteElement(li_cnt)
 
   OPEN WINDOW chg_tabindex_w WITH FORM "azz/42f/p_per_chg_tabindex"
      ATTRIBUTE(STYLE="viewer")
   CALL cl_ui_locale("p_per_chg_tabindex")
 
   LET li_start_flag = FALSE
   CALL cl_set_comp_visible("accept",FALSE)
   WHILE TRUE
      DISPLAY ARRAY g_tabindex TO s_tabindex.* ATTRIBUTE(COUNT=g_gav.getLength(),UNBUFFERED)
         BEFORE ROW
            IF li_arr != 0 THEN
               CALL fgl_set_arr_curr(li_arr)
               LET li_arr = 0
            END IF
            LET li_start_flag = TRUE
 
         ON ACTION up
            FOR li_i = 1 TO g_tabindex.getLength()
                IF g_tabindex[li_i].sel = "Y" AND NOT g_tabindex[li_i].chg_flag THEN
                   IF li_i > 1 THEN
                      CALL g_tabindex.insertElement(li_i-1)
                      LET g_tabindex[li_i-1].sel   = g_tabindex[li_i+1].sel
                      LET g_tabindex[li_i-1].gav02 = g_tabindex[li_i+1].gav02
                      LET g_tabindex[li_i-1].gae04 = g_tabindex[li_i+1].gae04
                      LET g_tabindex[li_i-1].gav16 = g_tabindex[li_i+1].gav16
                      LET g_tabindex[li_i-1].chg_flag = TRUE
                      CALL g_tabindex.deleteElement(li_i+1)
                   ELSE
                      EXIT FOR
                   END IF
                END IF
            END FOR
            FOR li_i = 1 TO g_tabindex.getLength()
                LET g_tabindex[li_i].chg_flag = FALSE
            END FOR
            CALL fgl_set_arr_curr(ARR_CURR()-1)
            CONTINUE DISPLAY
 
         ON ACTION down
            FOR li_i = g_tabindex.getLength() TO 1 STEP -1
                IF g_tabindex[li_i].sel = "Y" AND NOT g_tabindex[li_i].chg_flag THEN
                   IF li_i < g_tabindex.getLength() THEN
                      CALL g_tabindex.insertElement(li_i+2)
                      LET g_tabindex[li_i+2].sel   = g_tabindex[li_i].sel
                      LET g_tabindex[li_i+2].gav02 = g_tabindex[li_i].gav02
                      LET g_tabindex[li_i+2].gae04 = g_tabindex[li_i].gae04
                      LET g_tabindex[li_i+2].gav16 = g_tabindex[li_i].gav16
                      LET g_tabindex[li_i+2].chg_flag = TRUE
                      CALL g_tabindex.deleteElement(li_i)
                   ELSE
                      EXIT FOR
                   END IF
                END IF
            END FOR
            FOR li_i = 1 TO g_tabindex.getLength()
                LET g_tabindex[li_i].chg_flag = FALSE
            END FOR
            CALL fgl_set_arr_curr(ARR_CURR()+1)
            CONTINUE DISPLAY
 
         ON ACTION finish
            LET ls_choice = "finish"
            EXIT DISPLAY
 
         ON ACTION accept
            LET li_arr = ARR_CURR()
            IF li_start_flag THEN
               IF g_tabindex[li_arr].sel = "N" THEN
                  LET g_tabindex[li_arr].sel = "Y"
               ELSE
                  LET g_tabindex[li_arr].sel = "N"
               END IF
            END IF
            LET ls_choice = "accept"
            EXIT DISPLAY
 
         ON ACTION cancel
            LET ls_choice = "cancel"
            EXIT DISPLAY
 
         ON ACTION about         #FUN-860033
            CALL cl_about()      #FUN-860033
 
         ON ACTION controlg      #FUN-860033
            CALL cl_cmdask()     #FUN-860033
 
         ON ACTION help          #FUN-860033
            CALL cl_show_help()  #FUN-860033
 
         ON IDLE g_idle_seconds  #FUN-860033
             CALL cl_on_idle()
             CONTINUE DISPLAY 
 
      END DISPLAY
      IF ls_choice = "cancel" OR INT_FLAG THEN
         EXIT WHILE
      END IF
      IF ls_choice = "finish" THEN
         FOR li_i = 1 TO g_tabindex.getLength()
             UPDATE gav_file SET gav16 = li_i
              WHERE gav01=g_gav01 AND gav02=g_tabindex[li_i].gav02
                AND gav08=g_gav08 AND gav11=g_gav11
         END FOR
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_set_comp_visible("accept",TRUE)
   CLOSE WINDOW chg_tabindex_w
END FUNCTION
 
FUNCTION p_per_field_prog_check()
   DEFINE   li_result        LIKE type_file.num5
   DEFINE   ls_msg           STRING
   DEFINE   lc_gav31         LIKE gav_file.gav31
   DEFINE   ls_gav31         STRING
   DEFINE   li_max_gav31     LIKE type_file.num5
   DEFINE   ls_gav21_fun_c   STRING
   DEFINE   ls_gav23_fun_c   STRING
   DEFINE   ls_gav27_fun_c   STRING
   DEFINE   ls_funname1      STRING
   DEFINE   ls_funname2      STRING
   DEFINE   ls_funname3      STRING
   DEFINE   ls_gav21_funsn   LIKE type_file.chr1
   DEFINE   ls_gav23_funsn   LIKE type_file.chr1
   DEFINE   ls_gav27_funsn   LIKE type_file.chr1
   DEFINE   lc_gaq06         LIKE gaq_file.gaq06
   DEFINE   li_cnt           LIKE type_File.num5
   DEFINE   lc_gat03         LIKE gat_file.gat03    #No.FUN-840011
 
   SELECT UNIQUE gaq06 INTO lc_gaq06 FROM gaq_file WHERE gaq01=g_gav[l_ac].gav02
   IF (lc_gaq06 != "3" OR SQLCA.sqlcode ) AND (g_gav01 != "p_demo") AND (g_gav01 != "p_per_prog_chk") THEN  #No.FUN-7B0080 改自定義欄位用  #No.FUN-840011
      CALL cl_err(g_gav[l_ac].gav02,"azz-740",1)
      RETURN
   END IF
 
   #No.FUN-840011 --start--
   LET g_sql = "SELECT gat03 FROM gat_file ",
                " WHERE gat01 = ? AND gat02 = '",g_lang,"'"
   PREPARE pre_gat03 FROM g_sql
   #No.FUN-840011 ---end---
 
   LET li_result = TRUE
   INITIALIZE g_gav_prog.* TO NULL
   INITIALIZE g_gav20_table,g_gav20_field TO NULL
   INITIALIZE g_gav22_table,g_gav22_field TO NULL
   INITIALIZE g_gav26_table,g_gav26_field TO NULL
   INITIALIZE g_gav21_table,g_gav21_where TO NULL
   INITIALIZE g_gav23_field,g_gav23_table,g_gav23_where TO NULL
   INITIALIZE g_gav27_table,g_gav27_where TO NULL
   INITIALIZE g_gav21_funname,g_gav23_funname,g_gav27_funname TO NULL
 
   #找出欄位的程式設定
   LET g_sql = "SELECT gav10,gav09,gav17,gav18,gav19,gav20,gav21,gav22,gav23,",
               "       gav24,gav25,gav26,gav27,gav28,gav29,gav30,gav31,gav33,",
               "       gav36,gav37,gav39",
               "  FROM gav_file",
               " WHERE gav01='",g_gav01 CLIPPED,"' AND gav02='",g_gav[l_ac].gav02 CLIPPED,"'",
               "   AND gav08='",g_gav08 CLIPPED,"' AND gav11='",g_gav11 CLIPPED,"'"
   PREPARE prog_chk_pre FROM g_sql
   EXECUTE prog_chk_pre INTO g_gav_prog.gav10,g_gav_prog.gav09,g_gav_prog.gav17,
                             g_gav_prog.gav18,g_gav_prog.gav19,g_gav_prog.gav20,
                             g_gav_prog.gav21,g_gav_prog.gav22,g_gav_prog.gav23,
                             g_gav_prog.gav24,g_gav_prog.gav25,g_gav_prog.gav26,
                             g_gav_prog.gav27,g_gav_prog.gav28,g_gav_prog.gav29,
                             g_gav_prog.gav30,g_gav_prog.gav31,g_gav_prog.gav33,
                             g_gav_prog.gav36,g_gav_prog.gav37,g_gav_prog.gav39
   CASE
      WHEN g_gav_prog.gav28="1"
         CALL p_per_data_separate(g_gav_prog.gav20 CLIPPED,"d") RETURNING g_gav20_table,g_gav20_field,ls_msg
      WHEN g_gav_prog.gav28="2"
         CALL p_per_data_separate(g_gav_prog.gav21 CLIPPED,"s") RETURNING g_gav21_table,ls_msg,g_gav21_where
      WHEN g_gav_prog.gav28="3" OR g_gav_prog.gav28="4"
         CALL p_per_data_separate(g_gav_prog.gav21 CLIPPED,"f") RETURNING g_gav21_funname,ls_gav21_fun_c,ls_msg
      OTHERWISE
         LET g_gav_prog.gav28 = "1"
   END CASE
   CASE
      WHEN g_gav_prog.gav29="1"
         CALL p_per_data_separate(g_gav_prog.gav22 CLIPPED,"d") RETURNING g_gav22_table,g_gav22_field,ls_msg
      WHEN g_gav_prog.gav29="2"
         CALL p_per_data_separate(g_gav_prog.gav23 CLIPPED,"s") RETURNING g_gav23_table,g_gav23_field,g_gav23_where
      WHEN g_gav_prog.gav29="3" OR g_gav_prog.gav29="4"
         CALL p_per_data_separate(g_gav_prog.gav23 CLIPPED,"f") RETURNING g_gav23_funname,ls_gav23_fun_c,ls_msg
      OTHERWISE
         LET g_gav_prog.gav29 = "1"
   END CASE
   CASE
      WHEN g_gav_prog.gav30="1"
         CALL p_per_data_separate(g_gav_prog.gav26 CLIPPED,"d") RETURNING g_gav26_table,g_gav26_field,ls_msg
      WHEN g_gav_prog.gav30="2"
         CALL p_per_data_separate(g_gav_prog.gav27 CLIPPED,"s") RETURNING g_gav27_table,ls_msg,g_gav27_where
      WHEN g_gav_prog.gav30="3" OR g_gav_prog.gav30="4"
         CALL p_per_data_separate(g_gav_prog.gav27 CLIPPED,"f") RETURNING g_gav27_funname,ls_gav27_fun_c,ls_msg
      OTHERWISE
         LET g_gav_prog.gav30 = "1"
   END CASE
   IF cl_null(g_gav_prog.gav24) THEN
      LET g_gav_prog.gav24 = "N"
   END IF
 
   OPEN WINDOW field_prog_chk_w WITH FORM "azz/42f/p_per_prog_chk"
     ATTRIBUTE (STYLE=g_win_style)
   CALL cl_ui_locale("p_per_prog_chk")
 
   DISPLAY BY NAME g_gav_prog.gav10,g_gav_prog.gav09,g_gav_prog.gav17,
                   g_gav_prog.gav18,g_gav_prog.gav19,g_gav_prog.gav24,
                   g_gav_prog.gav28,g_gav_prog.gav29,g_gav_prog.gav30,
                   g_gav_prog.gav31,g_gav_prog.gav33,g_gav_prog.gav36,
                   g_gav_prog.gav37,g_gav_prog.gav39
   DISPLAY g_gav01,g_gav[l_ac].gav02,g_gav08,g_gav11 TO gav01,gav02,gav08,gav11
   DISPLAY g_gav20_table,g_gav20_field TO gav20_table,gav20_field
   DISPLAY g_gav22_table,g_gav22_field TO gav22_table,gav22_field
   DISPLAY g_gav26_table,g_gav26_field TO gav26_table,gav26_field
   DISPLAY g_gav21_table,g_gav21_where TO gav21_table,gav21_where
   DISPLAY g_gav21_funname,ls_gav21_fun_c TO gav21_fun_s,gav21
   DISPLAY g_gav23_field,g_gav23_table,g_gav23_where TO gav23_field,gav23_table,gav23_where
   DISPLAY g_gav23_funname,ls_gav23_fun_c TO gav23_fun_s,gav23
   DISPLAY g_gav27_table,g_gav27_where TO gav27_table,gav27_where
   DISPLAY g_gav27_funname,ls_gav27_fun_c TO gav27_fun_s,gav27
 
   #No.FUN-840011 --以下修改輸入順序
   INPUT g_gav_prog.gav10,g_gav_prog.gav09,g_gav_prog.gav17,
         g_gav_prog.gav18,g_gav_prog.gav24,g_gav_prog.gav25,g_gav_prog.gav33,
         g_gav_prog.gav19,g_gav_prog.gav39,
         g_gav_prog.gav28,g_gav20_table,g_gav20_field,
         g_gav21_table,g_gav21_where,ls_gav21_fun_c,
         g_gav_prog.gav30,g_gav26_table,g_gav26_field,
         g_gav27_table,g_gav27_where,ls_gav27_fun_c,
         g_gav_prog.gav29,g_gav_prog.gav31,g_gav_prog.gav36,g_gav_prog.gav37,
         g_gav22_table,g_gav22_field,
         g_gav23_field,g_gav23_table,g_gav23_where,ls_gav23_fun_c WITHOUT DEFAULTS
    FROM gav10,gav09,gav17,gav18,gav24,gav25,gav33,gav19,gav39,gav28,gav20_table,
         gav20_field,gav21_table,gav21_where,gav21,gav30,gav26_table,gav26_field,
         gav27_table,gav27_where,gav27,gav29,gav31,gav36,gav37,gav22_table,
         gav22_field,gav23_field,gav23_table,gav23_where,gav23
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_per_progchk_set_entry()
         LET g_before_input_done = TRUE
         CALL p_per_get_funname() RETURNING ls_funname1,ls_funname2,ls_funname3
 
      AFTER FIELD gav19
         IF NOT cl_null(g_gav_prog.gav19) AND
            (g_gav_prog.gav24 = "Y" OR g_gav_prog.gav33 = "Y") THEN
            CALL cl_err("","azz-731",1)
            NEXT FIELD gav19
         END IF
         #No.FUN-840011 --start--
         IF NOT cl_null(g_gav_prog.gav19) THEN
            SELECT COUNT(*) INTO li_cnt FROM gab_file, OUTER gae_file
             WHERE gae_file.gae01 = gab01 AND gae_file.gae02 = "wintitle"
               AND gae_file.gae03 = g_lang AND gab07 = "N" AND gab01 = g_gav_prog.gav19
            IF li_cnt <= 0 THEN
               EXECUTE pre_gat03 INTO lc_gat03 USING "gab_file"
               CALL cl_err_msg("","lib-236",g_gav_prog.gav19 CLIPPED||"|"||lc_gat03 CLIPPED||"|gab_file",1)
               NEXT FIELD gav19
            END IF
            SELECT COUNT(*) INTO li_cnt FROM gac_file
             WHERE gac01=g_gav_prog.gav19 AND gac10 = "Y"
            IF li_cnt > 1 THEN
               CALL cl_err(g_gav_prog.gav19,"azz-739",1)
               NEXT FIELD gav19
            END IF
         END IF
         CALL p_per_query_desc(g_gav_prog.gav19 CLIPPED)
#        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         #No.FUN-840011 ---end---
 
      AFTER FIELD gav39
         IF NOT cl_null(g_gav_prog.gav39) AND
            (g_gav_prog.gav24 = "Y" OR g_gav_prog.gav33 = "Y") THEN
            CALL cl_err("","azz-731",1)
            NEXT FIELD gav39
         END IF
         #No.FUN-840011 --start--
         IF NOT cl_null(g_gav_prog.gav39) THEN
            SELECT COUNT(*) INTO li_cnt FROM gab_file, OUTER gae_file
             WHERE gae_file.gae01 = gab01 AND gae_file.gae02 = "wintitle"
               AND gae_file.gae03 = g_lang AND gab07 = "N" AND gab01 = g_gav_prog.gav39
            IF li_cnt <= 0 THEN
               EXECUTE pre_gat03 INTO lc_gat03 USING "gab_file"
               CALL cl_err_msg("","lib-236",g_gav_prog.gav39 CLIPPED||"|"||lc_gat03 CLIPPED||"|gab_file",1)
               NEXT FIELD gav39
            END IF
            SELECT COUNT(*) INTO li_cnt FROM gac_file
             WHERE gac01=g_gav_prog.gav39 AND gac10 = "Y"
            IF li_cnt > 1 THEN
               CALL cl_err(g_gav_prog.gav39,"azz-739",1)
               NEXT FIELD gav39
            END IF
         END IF
         CALL p_per_query_desc(g_gav_prog.gav39 CLIPPED)
#        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         #No.FUN-840011 ---end---
 
      ON CHANGE gav24
         CALL p_per_progchk_set_entry()
 
      AFTER FIELD gav24
         IF g_gav_prog.gav24 = "Y" AND
            (NOT cl_null(g_gav_prog.gav19) OR g_gav_prog.gav33 = "Y") THEN
            CALL cl_err("","azz-732",1)
            NEXT FIELD gav24
         END IF
 
      AFTER FIELD gav33
         IF g_gav_prog.gav33 = "Y" AND
            (NOT cl_null(g_gav_prog.gav19) OR g_gav_prog.gav24 = "Y") THEN
            CALL cl_err("","azz-737",1)
            NEXT FIELD gav33
         END IF
 
      AFTER FIELD gav31
         IF NOT cl_null(g_gav_prog.gav31) THEN
            #No.FUN-840011 --start--
            SELECT COUNT(*) INTO li_cnt FROM gav_file
             WHERE gav01=g_gav01 AND gav08=g_gav08
               AND gav11=g_gav11 AND gav31=g_gav_prog.gav31
            IF li_cnt > 0 THEN
               CALL cl_err(g_gav_prog.gav31,"azz-738",0)
               NEXT FIELD gav31
            END IF
#           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            #No.FUN-840011 ---end---
         END IF
 
      ON CHANGE gav36
         CALL p_per_progchk_set_entry()
         IF g_gav_prog.gav36 = "Y" THEN
            LET g_sql = "SELECT gav31 FROM gav_file",
                        " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
                        "   AND gav11='",g_gav11 CLIPPED,"' AND gav36='Y'"
            PREPARE gav31_pre FROM g_sql
            DECLARE gav31_curs CURSOR FOR gav31_pre
            LET li_max_gav31 = 0
            FOREACH gav31_curs INTO lc_gav31
               LET ls_gav31 = lc_gav31
               LET ls_gav31 = ls_gav31.subString(ls_gav31.getIndexOf("refer_",1)+6,ls_gav31.getLength())
               IF ls_gav31 > li_max_gav31 THEN
                  LET li_max_gav31 = ls_gav31
               END IF
            END FOREACH
            IF li_max_gav31 = 0 THEN
               LET g_gav_prog.gav31 = "refer_001"
            ELSE
               LET g_gav_prog.gav31 = "refer_",li_max_gav31+1 USING "&&&"
            END IF
            DISPLAY BY NAME g_gav_prog.gav31
         ELSE
            LET g_gav_prog.gav31 = ""
            LET g_gav_prog.gav37 = 0
            DISPLAY BY NAME g_gav_prog.gav31,g_gav_prog.gav37
         END IF
 
      ON CHANGE gav28
         CALL p_per_progchk_set_entry()
         CASE
            WHEN g_gav_prog.gav28 = "2"
               IF NOT cl_null(g_gav_prog.gav21) THEN
                  CALL p_per_data_separate(g_gav_prog.gav21 CLIPPED,"s") RETURNING g_gav21_table,ls_msg,g_gav21_where
                  DISPLAY g_gav21_table,g_gav21_where TO gav21_table,gav21_where
               END IF
            WHEN g_gav_prog.gav28 = "3" OR g_gav_prog.gav28 = "4"
               IF NOT cl_null(g_gav_prog.gav21) THEN
                  CALL p_per_data_separate(g_gav_prog.gav21 CLIPPED,"f") RETURNING g_gav21_funname,ls_gav21_fun_c,ls_msg
                  DISPLAY g_gav21_funname,ls_gav21_fun_c TO gav21_fun_s,gav21
               END IF
               IF cl_null(g_gav21_funname) AND g_gav_prog.gav28 = "3" THEN
                  CASE
                     WHEN NOT cl_null(ls_funname1)
                        LET g_gav21_funname = ls_funname1
                        LET ls_gav21_funsn = "1"
                        LET ls_funname1 = NULL
                     WHEN NOT cl_null(ls_funname2)
                        LET g_gav21_funname = ls_funname2
                        LET ls_gav21_funsn = "2"
                        LET ls_funname2 = NULL
                     WHEN NOT cl_null(ls_funname3)
                        LET g_gav21_funname = ls_funname3
                        LET ls_gav21_funsn = "3"
                        LET ls_funname3 = NULL
                  END CASE
                  DISPLAY g_gav21_funname TO gav21_fun_s
               END IF
               IF g_gav_prog.gav28 = "3" THEN
                  NEXT FIELD gav21
               END IF
         END CASE
 
      ON CHANGE gav29
         CALL p_per_progchk_set_entry()
         CASE
            WHEN g_gav_prog.gav29 = "2"
               IF NOT cl_null(g_gav_prog.gav23) THEN
                  CALL p_per_data_separate(g_gav_prog.gav23 CLIPPED,"s") RETURNING g_gav23_table,g_gav23_field,g_gav23_where
                  DISPLAY g_gav23_field,g_gav23_table,g_gav23_where TO gav23_field,gav23_table,gav23_where
               END IF
            WHEN g_gav_prog.gav29 = "3" OR g_gav_prog.gav29 = "4"
               IF NOT cl_null(g_gav_prog.gav23) THEN
                  CALL p_per_data_separate(g_gav_prog.gav23 CLIPPED,"f") RETURNING g_gav23_funname,ls_gav23_fun_c,ls_msg
                  DISPLAY g_gav23_funname,ls_gav23_fun_c TO gav23_fun_s,gav23
               END IF
               IF cl_null(g_gav23_funname) AND g_gav_prog.gav29 = "3" THEN
                  CASE
                     WHEN NOT cl_null(ls_funname1)
                        LET g_gav23_funname = ls_funname1
                        LET ls_gav23_funsn = "1"
                        LET ls_funname1 = NULL
                     WHEN NOT cl_null(ls_funname2)
                        LET g_gav23_funname = ls_funname2
                        LET ls_gav23_funsn = "2"
                        LET ls_funname2 = NULL
                     WHEN NOT cl_null(ls_funname3)
                        LET g_gav23_funname = ls_funname3
                        LET ls_gav23_funsn = "3"
                        LET ls_funname3 = NULL
                  END CASE
                  DISPLAY g_gav23_funname TO gav23_fun_s
               END IF
               IF g_gav_prog.gav29 = "3" THEN
                  NEXT FIELD gav23
               END IF
         END CASE
 
      ON CHANGE gav30
         CALL p_per_progchk_set_entry()
         CASE
            WHEN g_gav_prog.gav30 = "2"
               IF NOT cl_null(g_gav_prog.gav27) THEN
                  CALL p_per_data_separate(g_gav_prog.gav27 CLIPPED,"s") RETURNING g_gav27_table,ls_msg,g_gav27_where
                  DISPLAY g_gav27_table,g_gav27_where TO gav27_table,gav27_where
               END IF
            WHEN g_gav_prog.gav30 = "3" OR g_gav_prog.gav30 = "4"
               IF NOT cl_null(g_gav_prog.gav27) THEN
                  CALL p_per_data_separate(g_gav_prog.gav27 CLIPPED,"f") RETURNING g_gav27_funname,ls_gav27_fun_c,ls_msg
                  DISPLAY g_gav27_funname,ls_gav27_fun_c TO gav27_fun_s,gav27
               END IF
               IF cl_null(g_gav27_funname) AND g_gav_prog.gav30 = "3" THEN
                  CASE
                     WHEN NOT cl_null(ls_funname1)
                        LET g_gav27_funname = ls_funname1
                        LET ls_gav27_funsn = "1"
                        LET ls_funname1 = NULL
                     WHEN NOT cl_null(ls_funname2)
                        LET g_gav27_funname = ls_funname2
                        LET ls_gav27_funsn = "2"
                        LET ls_funname2 = NULL
                     WHEN NOT cl_null(ls_funname3)
                        LET g_gav27_funname = ls_funname3
                        LET ls_gav27_funsn = "3"
                        LET ls_funname3 = NULL
                  END CASE
                  DISPLAY g_gav27_funname TO gav27_fun_s
               END IF
               IF g_gav_prog.gav30 = "3" THEN
                  NEXT FIELD gav27
               END IF
         END CASE
 
      #No.FUN-840011 --start--
      AFTER FIELD gav20_table
         IF NOT cl_null(g_gav20_table) THEN
            #LET g_sql = "SELECT COUNT(*) FROM gat_file WHERE gat01='",g_gav20_table,"'"     #No.FUN-A70082 mark
            LET g_sql = "SELECT COUNT(*) FROM zta_file WHERE zta01 = '",g_gav20_table,"' AND zta02 = 'ds'"    #No.FUN-A70082 
            PREPARE gav20_table_chk FROM g_sql
            EXECUTE gav20_table_chk INTO li_cnt
            IF li_cnt <= 0 THEN
               CALL cl_err(g_gav20_table,"azz-710",0)
               NEXT FIELD gav20_table
            END IF
         END IF
 
      AFTER FIELD gav20_field
         IF NOT cl_null(g_gav20_field) THEN
            LET g_sql = "SELECT COUNT(*) FROM gaq_file WHERE gaq01='",g_gav20_field,"'"
            PREPARE gav20_field_chk FROM g_sql
            EXECUTE gav20_field_chk INTO li_cnt
            IF li_cnt <= 0 THEN
               CALL cl_err(g_gav20_field,"azz-513",0)
               NEXT FIELD gav20_field
            END IF
         END IF
 
      AFTER FIELD gav22_table
         IF NOT cl_null(g_gav22_table) THEN
            #LET g_sql = "SELECT COUNT(*) FROM gat_file WHERE gat01='",g_gav22_table,"'"     #No.FUN-A70082 mark
            LET g_sql = "SELECT COUNT(*) FROM zta_file WHERE zta01 = '",g_gav22_table,"' AND zta02 = 'ds'"    #No.FUN-A70082
            PREPARE gav22_table_chk FROM g_sql
            EXECUTE gav22_table_chk INTO li_cnt
            IF li_cnt <= 0 THEN
               CALL cl_err(g_gav22_table,"azz-710",0)
               NEXT FIELD gav22_table
            END IF
         END IF
 
      AFTER FIELD gav22_field
         IF NOT cl_null(g_gav22_field) THEN
            LET g_sql = "SELECT COUNT(*) FROM gaq_file WHERE gaq01='",g_gav22_field,"'"
            PREPARE gav22_field_chk FROM g_sql
            EXECUTE gav22_field_chk INTO li_cnt
            IF li_cnt <= 0 THEN
               CALL cl_err(g_gav22_field,"azz-513",0)
               NEXT FIELD gav22_field
            END IF
         END IF
 
      AFTER FIELD gav26_table
         IF NOT cl_null(g_gav26_table) THEN
            #LET g_sql = "SELECT COUNT(*) FROM gat_file WHERE gat01='",g_gav26_table,"'"     #No.FUN-A70082 mark
            LET g_sql = "SELECT COUNT(*) FROM zta_file WHERE zta01 = '",g_gav26_table,"' AND zta02 = 'ds'"    #No.FUN-A70082 
            PREPARE gav26_table_chk FROM g_sql
            EXECUTE gav26_table_chk INTO li_cnt
            IF li_cnt <= 0 THEN
               CALL cl_err(g_gav26_table,"azz-710",0)
               NEXT FIELD gav26_table
            END IF
         END IF
 
      AFTER FIELD gav26_field
         IF NOT cl_null(g_gav26_field) THEN
            LET g_sql = "SELECT COUNT(*) FROM gaq_file WHERE gaq01='",g_gav26_field,"'"
            PREPARE gav26_field_chk FROM g_sql
            EXECUTE gav26_field_chk INTO li_cnt
            IF li_cnt <= 0 THEN
               CALL cl_err(g_gav26_field,"azz-513",0)
               NEXT FIELD gav26_field
            END IF
         END IF
      #No.FUN-840011 ---end---
 
      AFTER FIELD gav21
         IF NOT cl_null(ls_gav21_fun_c) THEN
            IF ls_gav21_fun_c.getLength() > 1850 THEN
               MESSAGE 'There are too many numbers of words'
               NEXT FIELD gav21
            END IF
         ELSE
            CASE ls_gav21_funsn
               WHEN "1"
                  LET ls_funname1 = g_gav21_funname
               WHEN "2"
                  LET ls_funname2 = g_gav21_funname
               WHEN "3"
                  LET ls_funname3 = g_gav21_funname
            END CASE
            LET g_gav_prog.gav28 = "1"
            LET g_gav21_funname = NULL
            DISPLAY g_gav_prog.gav28,g_gav21_funname TO gav28,gav21_fun_s
            CALL p_per_progchk_set_entry()
         END IF
 
      AFTER FIELD gav27
         IF NOT cl_null(ls_gav27_fun_c) THEN
            IF ls_gav27_fun_c.getLength() > 1850 THEN
               MESSAGE 'There are too many numbers of words'
               NEXT FIELD gav27
            END IF
         ELSE
            CASE ls_gav27_funsn
               WHEN "1"
                  LET ls_funname1 = g_gav27_funname
               WHEN "2"
                  LET ls_funname2 = g_gav27_funname
               WHEN "3"
                  LET ls_funname3 = g_gav27_funname
            END CASE
            LET g_gav_prog.gav30 = "1"
            LET g_gav27_funname = NULL
            DISPLAY g_gav_prog.gav30,g_gav27_funname TO gav30,gav27_fun_s
            CALL p_per_progchk_set_entry()
         END IF
 
      AFTER FIELD gav23
         IF NOT cl_null(ls_gav23_fun_c) THEN
            IF ls_gav23_fun_c.getLength() > 1850 THEN
               MESSAGE 'There are too many numbers of words'
               NEXT FIELD gav23
            END IF
         ELSE
            CASE ls_gav23_funsn
               WHEN "1"
                  LET ls_funname1 = g_gav23_funname
               WHEN "2"
                  LET ls_funname2 = g_gav23_funname
               WHEN "3"
                  LET ls_funname3 = g_gav23_funname
            END CASE
            LET g_gav_prog.gav29 = "1"
            LET g_gav23_funname = NULL
            DISPLAY g_gav_prog.gav29,g_gav23_funname TO gav29,gav23_fun_s
            CALL p_per_progchk_set_entry()
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_gav_prog.gav28 MATCHES '[34]' AND 
            (cl_null(g_gav21_funname) OR cl_null(ls_gav21_fun_c)) THEN
            NEXT FIELD gav28
         END IF
         IF g_gav_prog.gav30 MATCHES '[34]' AND 
            (cl_null(g_gav27_funname) OR cl_null(ls_gav27_fun_c)) THEN
            NEXT FIELD gav30
         END IF
         IF g_gav_prog.gav29 MATCHES '[34]' AND 
            (cl_null(g_gav23_funname) OR cl_null(ls_gav23_fun_c)) THEN
            NEXT FIELD gav29
         END IF
         IF g_gav_prog.gav28 = "4" THEN
            IF cl_db_get_database_type() = "ORA" THEN
               LET g_sql = "SELECT COUNT(*) FROM gav_file ",
                           " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
                           "   AND gav11='",g_gav11 CLIPPED,"'",
                           "   AND (gav21 LIKE '",g_gav21_funname,"%' OR gav23 LIKE '",g_gav21_funname,"%' OR gav27 LIKE '",g_gav21_funname,"%')"
            ELSE
               LET g_sql = "SELECT COUNT(*) FROM gav_file ",
                           " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
                           "   AND gav11='",g_gav11 CLIPPED,"'",
                           "   AND (gav21 MATCHES '",g_gav21_funname,"*' OR gav23 MATCHES '",g_gav21_funname,"*' OR gav27 MATCHES '",g_gav21_funname,"*')"
            END IF
            PREPARE gav21_funname_pre FROM g_sql
            EXECUTE gav21_funname_pre INTO li_cnt
            IF li_cnt <=0 THEN
               MESSAGE "Can't find this function"
               NEXT FIELD gav28
            END IF
         END IF
         IF g_gav_prog.gav29 = "4" THEN
            IF cl_db_get_database_type() = "ORA" THEN
               LET g_sql = "SELECT COUNT(*) FROM gav_file ",
                           " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
                           "   AND gav11='",g_gav11 CLIPPED,"'",
                           "   AND (gav21 LIKE '",g_gav23_funname,"%' OR gav23 LIKE '",g_gav23_funname,"%' OR gav27 LIKE '",g_gav23_funname,"%')"
            ELSE
               LET g_sql = "SELECT COUNT(*) FROM gav_file ",
                           " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
                           "   AND gav11='",g_gav11 CLIPPED,"'",
                           "   AND (gav21 MATCHES '",g_gav23_funname,"*' OR gav23 MATCHES '",g_gav23_funname,"*' OR gav27 MATCHES '",g_gav23_funname,"*')"
            END IF
            PREPARE gav23_funname_pre FROM g_sql
            EXECUTE gav23_funname_pre INTO li_cnt
            IF li_cnt <=0 THEN
               MESSAGE "Can't find this function"
               NEXT FIELD gav29
            END IF
         END IF
         IF g_gav_prog.gav30 = "4" THEN
            IF cl_db_get_database_type() = "ORA" THEN
               LET g_sql = "SELECT COUNT(*) FROM gav_file ",
                           " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
                           "   AND gav11='",g_gav11 CLIPPED,"'",
                           "   AND (gav21 LIKE '",g_gav27_funname,"%' OR gav23 LIKE '",g_gav27_funname,"%' OR gav27 LIKE '",g_gav27_funname,"%')"
            ELSE
               LET g_sql = "SELECT COUNT(*) FROM gav_file ",
                           " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08 CLIPPED,"'",
                           "   AND gav11='",g_gav11 CLIPPED,"'",
                           "   AND (gav21 MATCHES '",g_gav27_funname,"*' OR gav23 MATCHES '",g_gav27_funname,"*' OR gav27 MATCHES '",g_gav27_funname,"*')"
            END IF
            PREPARE gav27_funname_pre FROM g_sql
            EXECUTE gav27_funname_pre INTO li_cnt
            IF li_cnt <=0 THEN
               MESSAGE "Can't find this function"
               NEXT FIELD gav30
            END IF
         END IF
 
      ON ACTION gav21_sql_ex
         LET g_gav21_table = "ima_file"
         LET g_gav21_where = "ima01=?"
         DISPLAY g_gav21_table TO formonly.gav21_table
         DISPLAY g_gav21_where  TO formonly.gav21_where
 
      ON ACTION gav23_sql_ex
         LET g_gav23_field = "ima02"
         LET g_gav23_table = "ima_file"
         LET g_gav23_where = "ima01=?"
         DISPLAY g_gav23_field TO formonly.gav23_field
         DISPLAY g_gav23_table TO formonly.gav23_table
         DISPLAY g_gav23_where TO formonly.gav23_where
 
      ON ACTION gav27_sql_ex
         LET g_gav27_table = "ima_file"
         LET g_gav27_where = "ima01=?"
         DISPLAY g_gav27_table TO formonly.gav27_table
         DISPLAY g_gav27_where TO formonly.gav27_where
 
      ON ACTION gav21_fun_ex
         LET ls_gav21_fun_c = "DEFINE   ls_sql   STRING\n",
                              "DEFINE   lc_gat03 LIKE gat_file.gat03\n\n",
                              "LET g_errno = \" \"\n",
                              "SELECT ima02,ima021,imaacti INTO g_ima.ima02,g_ima.ima021,g_ima.imaacti\n",
                              " FROM ima_file WHERE ima01 = g_ima.ima01\n",
                              "CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1201'\n",
                              "     WHEN g_ima.imaacti='N'    LET g_errno = '9028'\n",
                              "     OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'\n",
                              "END CASE\n",
                              "DISPLAY BY NAME g_ima.ima02,g_ima.ima021\n",
                              "IF cl_null(g_errno) THEN\n",
                              "   LET li_result = TRUE\n",
                              "ELSE\n",
                              "   LET ls_sql = \"SELECT gat03 FROM gat_file \",\n",
                              "                \" WHERE gat01 = 'ima_file' AND gat02 = '\",g_lang,\"'\"\n",
                              "   PREPARE pre_gat03 FROM ls_sql\n",
                              "   EXECUTE pre_gat03 INTO lc_gat03\n",
                              "   CALL cl_err_msg(\"\",\"lib-236\",ps_value||\"|\"||lc_gat03 CLIPPED||\"|ima_file\",1)\n",
                              "   LET li_result = FALSE\n",
                              "END IF"
         DISPLAY ls_gav21_fun_c TO gav21
 
      ON ACTION gav23_fun_ex
         LET ls_gav23_fun_c = "SELECT ima02,ima021 INTO g_ima.ima02,g_ima.ima021\n",
                              " FROM ima_file WHERE ima01 = g_ima.ima01\n",
                              "DISPLAY BY NAME g_ima.ima02,g_ima.ima021\n"
         DISPLAY ls_gav23_fun_c TO gav23
 
      ON ACTION gav27_fun_ex
         LET ls_gav27_fun_c = "DEFINE   ls_sql   STRING\n",
                              "DEFINE   lc_gat03 LIKE gat_file.gat03\n\n",
                              "LET g_errno = \" \"\n",
                              "SELECT COUNT(*) INTO li_cnt FROM ima_file\n",
                              " WHERE ima01 = g_ima.ima01\n",
                              "IF li_cnt <= 0 THEN\n",
                              "   LET li_result = TRUE\n",
                              "ELSE\n",
                              "   LET ls_sql = \"SELECT gat03 FROM gat_file \",\n",
                              "                \" WHERE gat01 = 'ima_file' AND gat02 = '\",g_lang,\"'\"\n",
                              "   PREPARE pre_gat03 FROM ls_sql\n",
                              "   EXECUTE pre_gat03 INTO lc_gat03\n",
                              "   CALL cl_err_msg(\"\",\"lib-400\",ps_value||\"|\"||lc_gat03 CLIPPED||\"|ima_file\",1)\n",
                              "   LET li_result = FALSE\n",
                              "END IF"
         DISPLAY ls_gav27_fun_c TO gav27
 
#     ON ACTION gav21_compile
#        CALL GET_FLDBUF(gav21) RETURNING ls_gav21_fun_c
#        IF g_gav_prog.gav28 = "3" AND NOT cl_null(g_gav21_funname) AND
#           NOT cl_null(ls_gav21_fun_c) THEN
#           CALL p_per_data_combine(g_gav21_funname,ls_gav21_fun_c,"gav21","f") RETURNING g_gav_prog.gav21
#           CALL p_per_compile(g_gav_prog.gav21)
#        END IF
 
#     ON ACTION gav23_compile
#        CALL GET_FLDBUF(gav23) RETURNING ls_gav23_fun_c
#        IF g_gav_prog.gav29 = "3" AND NOT cl_null(g_gav23_funname) AND
#           NOT cl_null(ls_gav23_fun_c) THEN
#           CALL p_per_data_combine(g_gav23_funname,ls_gav23_fun_c,"gav23","f") RETURNING g_gav_prog.gav23
#           CALL p_per_compile(g_gav_prog.gav23)
#        END IF
 
#     ON ACTION gav27_compile
#        CALL GET_FLDBUF(gav27) RETURNING ls_gav27_fun_c
#        IF g_gav_prog.gav30 = "3" AND NOT cl_null(g_gav27_funname) AND
#           NOT cl_null(ls_gav27_fun_c) THEN
#           CALL p_per_data_combine(g_gav27_funname,ls_gav27_fun_c,"gav27","f") RETURNING g_gav_prog.gav27
#           CALL p_per_compile(g_gav_prog.gav27)
#        END IF
 
      ON ACTION param_setting_i
         CALL GET_FLDBUF(gav19) RETURNING g_gav_prog.gav19
         IF NOT cl_null(g_gav_prog.gav19) THEN
            CALL cl_set_qryparam("1",g_gav01,g_gav[l_ac].gav02,g_gav08,g_gav11,"i")
         END IF
 
      ON ACTION param_setting_c
         CALL GET_FLDBUF(gav39) RETURNING g_gav_prog.gav39
         IF NOT cl_null(g_gav_prog.gav39) THEN
            CALL cl_set_qryparam("1",g_gav01,g_gav[l_ac].gav02,g_gav08,g_gav11,"c")
         END IF
 
      ON ACTION fun_cite_datacheck
         CALL p_per_sel_function(g_gav_prog.gav28,g_gav21_funname,ls_gav21_fun_c) RETURNING g_gav21_funname,ls_gav21_fun_c
         IF g_gav_prog.gav28 = "3" THEN
            DISPLAY ls_gav21_fun_c TO gav21
         ELSE
            DISPLAY g_gav21_funname,ls_gav21_fun_c TO gav21_fun_s,gav21
         END IF
 
      ON ACTION fun_cite_rptcheck
         CALL p_per_sel_function(g_gav_prog.gav30,g_gav27_funname,ls_gav27_fun_c) RETURNING g_gav27_funname,ls_gav27_fun_c
         IF g_gav_prog.gav30 = "3" THEN
            DISPLAY ls_gav27_fun_c TO gav27
         ELSE
            DISPLAY g_gav27_funname,ls_gav27_fun_c TO gav27_fun_s,gav27
         END IF
 
      ON ACTION fun_cite_reference
         CALL p_per_sel_function(g_gav_prog.gav29,g_gav23_funname,ls_gav23_fun_c) RETURNING g_gav23_funname,ls_gav23_fun_c
         IF g_gav_prog.gav29 = "3" THEN
            DISPLAY ls_gav23_fun_c TO gav23
         ELSE
            DISPLAY g_gav23_funname,ls_gav23_fun_c TO gav23_fun_s,gav23
         END IF
 
      #No.FUN-840011 --start-- 由動態設定改為程式寫法
      ON ACTION controlp
         CASE
            WHEN INFIELD(gav19)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gab1"
               LET g_qryparam.default1 = g_gav_prog.gav19
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.where = "(SELECT COUNT(*) FROM gac_file WHERE gac01=gab01 AND gac10='Y') <= 1"
               CALL cl_create_qry() RETURNING g_gav_prog.gav19
               DISPLAY BY NAME g_gav_prog.gav19
               NEXT FIELD gav19
            WHEN INFIELD(gav39)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gab1"
               LET g_qryparam.default1 = g_gav_prog.gav39
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.where = "(SELECT COUNT(*) FROM gac_file WHERE gac01=gab01 AND gac10='Y') <= 1"
               CALL cl_create_qry() RETURNING g_gav_prog.gav39
               DISPLAY BY NAME g_gav_prog.gav39
               NEXT FIELD gav39
            WHEN INFIELD(gav20_table)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gat"
               LET g_qryparam.default1 = g_gav20_table
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_gav20_table
               DISPLAY g_gav20_table TO gav20_table
               NEXT FIELD gav20_table
            WHEN INFIELD(gav20_field)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gaq"
               LET g_qryparam.default1 = g_gav20_field
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.arg2 = g_gav20_table.subString(1,g_gav20_table.getIndexOf("_file",1)-1)
               CALL cl_create_qry() RETURNING g_gav20_field
               DISPLAY g_gav20_field TO gav20_field
               NEXT FIELD gav20_field
            WHEN INFIELD(gav22_table)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gat"
               LET g_qryparam.default1 = g_gav22_table
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_gav22_table
               DISPLAY g_gav22_table TO gav22_table
               NEXT FIELD gav22_table
            WHEN INFIELD(gav22_field)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gaq"
               LET g_qryparam.default1 = g_gav22_field
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.arg2 = g_gav22_table.subString(1,g_gav22_table.getIndexOf("_file",1)-1)
               CALL cl_create_qry() RETURNING g_gav22_field
               DISPLAY g_gav22_field TO gav22_field
               NEXT FIELD gav22_field
            WHEN INFIELD(gav26_table)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gat"
               LET g_qryparam.default1 = g_gav26_table
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_gav26_table
               DISPLAY g_gav26_table TO gav26_table
               NEXT FIELD gav26_table
            WHEN INFIELD(gav26_field)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gaq"
               LET g_qryparam.default1 = g_gav26_field
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.arg2 = g_gav26_table.subString(1,g_gav26_table.getIndexOf("_file",1)-1)
               CALL cl_create_qry() RETURNING g_gav26_field
               DISPLAY g_gav26_field TO gav26_field
               NEXT FIELD gav26_field
         END CASE
      #No.FUN-840011 ---end---
 
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
 
   IF NOT INT_FLAG THEN
      CALL p_per_data_combine(g_gav20_table,g_gav20_field,"","d") RETURNING g_gav_prog.gav20
      CALL p_per_data_combine(g_gav22_table,g_gav22_field,"","d") RETURNING g_gav_prog.gav22
      CALL p_per_data_combine(g_gav26_table,g_gav26_field,"","d") RETURNING g_gav_prog.gav26
      CASE
         WHEN g_gav_prog.gav28 = "1"
            LET g_gav_prog.gav21 = NULL
         WHEN g_gav_prog.gav28 = "2"
            CALL p_per_data_combine(g_gav21_table,"COUNT(*)",g_gav21_where,"s") RETURNING g_gav_prog.gav21
         WHEN g_gav_prog.gav28 = "3" OR g_gav_prog.gav28 = "4"
            CALL p_per_data_combine(g_gav21_funname,ls_gav21_fun_c,"gav21","f") RETURNING g_gav_prog.gav21
      END CASE
      CASE
         WHEN g_gav_prog.gav29 = "1"
            LET g_gav_prog.gav23 = NULL
         WHEN g_gav_prog.gav29 = "2"
            CALL p_per_data_combine(g_gav23_table,g_gav23_field,g_gav23_where,"s") RETURNING g_gav_prog.gav23
         WHEN g_gav_prog.gav29 = "3" OR g_gav_prog.gav29 = "4"
            CALL p_per_data_combine(g_gav23_funname,ls_gav23_fun_c,"gav23","f") RETURNING g_gav_prog.gav23
      END CASE
      CASE
         WHEN g_gav_prog.gav30 = "1"
            LET g_gav_prog.gav27 = NULL
         WHEN g_gav_prog.gav30 = "2"
            CALL p_per_data_combine(g_gav27_table,"COUNT(*)",g_gav27_where,"s") RETURNING g_gav_prog.gav27
         WHEN g_gav_prog.gav30 = "3" OR g_gav_prog.gav30 = "4"
            CALL p_per_data_combine(g_gav27_funname,ls_gav27_fun_c,"gav27","f") RETURNING g_gav_prog.gav27
      END CASE
      UPDATE gav_file SET gav10 = g_gav_prog.gav10,gav09 = g_gav_prog.gav09,
                          gav17 = g_gav_prog.gav17,gav18 = g_gav_prog.gav18,
                          gav19 = g_gav_prog.gav19,gav20 = g_gav_prog.gav20,
                          gav21 = g_gav_prog.gav21,gav22 = g_gav_prog.gav22,
                          gav23 = g_gav_prog.gav23,gav24 = g_gav_prog.gav24,
                          gav25 = g_gav_prog.gav25,gav26 = g_gav_prog.gav26,
                          gav27 = g_gav_prog.gav27,gav28 = g_gav_prog.gav28,
                          gav29 = g_gav_prog.gav29,gav30 = g_gav_prog.gav30,
                          gav31 = g_gav_prog.gav31,gav33 = g_gav_prog.gav33,
                          gav36 = g_gav_prog.gav36,gav37 = g_gav_prog.gav37,
                          gav39 = g_gav_prog.gav39
                    WHERE gav01 = g_gav01 AND gav02 = g_gav[l_ac].gav02
                      AND gav08 = g_gav08 AND gav11 = g_gav11
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET li_result = FALSE
      END IF
   ELSE
      LET INT_FLAG = FALSE
   END IF
 
   CLOSE WINDOW field_prog_chk_w
   IF NOT li_result THEN
      MESSAGE 'UPDATE Error'
   END IF
END FUNCTION
 
FUNCTION p_per_data_separate(ps_value,pc_type)
   DEFINE   ps_value   STRING
   DEFINE   pc_type    LIKE type_file.chr1
   DEFINE   ls_table   STRING
   DEFINE   ls_field   STRING
   DEFINE   ls_where   STRING
 
   IF NOT cl_null(ps_value) THEN
      CASE pc_type
         WHEN "d"
            LET ls_table = ps_value.subString(1,ps_value.getIndexOf(".",1)-1)
            LET ls_field = ps_value.subString(ps_value.getIndexOf(".",1)+1,ps_value.getLength())
         WHEN "s"
            IF ps_value.subString(1,7) = "SELECT " THEN
               LET ls_field = ps_value.subString(ps_value.getIndexOf("SELECT ",1)+7,ps_value.getIndexOf(" FROM ",1)-1)
               LET ls_table = ps_value.subString(ps_value.getIndexOf(" FROM ",1)+6,ps_value.getIndexOf(" WHERE ",1)-1)
               LET ls_where = ps_value.subString(ps_value.getIndexOf(" WHERE ",1)+7,ps_value.getLength())
            END IF
         WHEN "f"
            IF ps_value.subString(1,9) = "FUNCTION " THEN
               IF ps_value MATCHES "*\nRETURN TRUE\nEND FUNCTION" THEN
                  LET ls_table = ps_value.subString(1,ps_value.getIndexOf("\n",1)-1)
                  LET ls_field = ps_value.subString(ps_value.getIndexOf("DEFINE   ps_value   STRING\n",1)+27,ps_value.getIndexOf("\nRETURN TRUE\nEND FUNCTION",1)-1)
               END IF
               IF ps_value MATCHES "*\nRETURN li_result\nEND FUNCTION" THEN
                  LET ls_table = ps_value.subString(1,ps_value.getIndexOf("\n",1)-1)
                  LET ls_field = ps_value.subString(ps_value.getIndexOf("DEFINE   li_result   LIKE type_file.num5\n",1)+41,ps_value.getIndexOf("\nRETURN li_result\nEND FUNCTION",1)-1)
               END IF
            END IF
      END CASE
   END IF
   RETURN ls_table,ls_field,ls_where
END FUNCTION
 
FUNCTION p_per_data_combine(ps_table,ps_field,ps_where,pc_type)
   DEFINE   ps_table   STRING
   DEFINE   ps_field   STRING
   DEFINE   ps_where   STRING
   DEFINE   pc_type    LIKE type_file.chr1
   DEFINE   ls_value   STRING
 
   IF NOT cl_null(ps_field) AND NOT cl_null(ps_table) THEN
      CASE pc_type
         WHEN "d"
            LET ls_value = ps_table,".",ps_field
         WHEN "s"
            IF cl_null(ps_where) THEN
               LET ls_value = "SELECT ",ps_field," FROM ",ps_table
            ELSE
               LET ls_value = "SELECT ",ps_field," FROM ",ps_table," WHERE ",ps_where
            END IF
         WHEN "f"
            IF NOT cl_null(ps_table) THEN
               IF ps_where.equals("gav23") THEN
                  LET ls_value = ps_table,"\n",
                                 "DEFINE   ps_value   STRING\n",
                                 ps_field,"\n",
                                 "RETURN TRUE\n",
                                 "END FUNCTION"
               ELSE
                  LET ls_value = ps_table,"\n",
                                 "DEFINE   ps_value   STRING\n",
                                 "DEFINE   li_result   LIKE type_file.num5\n",
                                 ps_field,"\n",
                                 "RETURN li_result\n",
                                 "END FUNCTION"
               END IF
            END IF
      END CASE
   END IF
   RETURN ls_value
END FUNCTION
 
FUNCTION p_per_get_funname()
   DEFINE   lc_gax02    LIKE gax_file.gax02
   DEFINE   lc_gav02    LIKE gav_file.gav02
   DEFINE   lc_gav11    LIKE gav_file.gav11
   DEFINE   lc_gav21    LIKE gav_file.gav21
   DEFINE   lc_gav23    LIKE gav_file.gav23
   DEFINE   lc_gav27    LIKE gav_file.gav27
   DEFINE   lc_gav08    LIKE gav_file.gav08
   DEFINE   ls_fun      STRING
   DEFINE   li_fun_num  LIKE type_file.num5
   DEFINE   ls_fun_num  STRING
   DEFINE   li_max_num  LIKE type_file.num5
   DEFINE   li_cnt      LIKE type_file.num5
   DEFINE   ls_funname1 STRING
   DEFINE   ls_funname2 STRING
   DEFINE   ls_funname3 STRING
   DEFINE   li_fun_cnt  LIKE type_file.num5
 
   #主程式對應的per檔內有用哪些function name
   LET g_sql = "SELECT gav02,gav21,gav23,gav27 FROM gav_file",
               " WHERE gav01='",g_gav01 CLIPPED,"' AND gav08='",g_gav08,"' AND gav11='",g_gav11,"'",
               "   AND ((gav28 = '3' AND gav21 IS NOT NULL) OR ",
               "        (gav29 = '3' AND gav23 IS NOT NULL) OR ",
               "        (gav30 = '3' AND gav27 IS NOT NULL))"
   PREPARE gav_main_pre FROM g_sql
   DECLARE gav_main_curs CURSOR FOR gav_main_pre
   FOREACH gav_main_curs INTO lc_gav02,lc_gav21,lc_gav23,lc_gav27
      IF lc_gav21 IS NOT NULL THEN
         LET ls_fun = lc_gav21 CLIPPED
         LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
         LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
         LET li_fun_num = ls_fun_num
         IF li_fun_num > li_max_num THEN
            LET li_max_num = li_fun_num
         END IF
      END IF
      IF lc_gav23 IS NOT NULL THEN
         LET ls_fun = lc_gav23 CLIPPED
         LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
         LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
         LET li_fun_num = ls_fun_num
         IF li_fun_num > li_max_num THEN
            LET li_max_num = li_fun_num
         END IF
      END IF
      IF lc_gav27 IS NOT NULL THEN
         LET ls_fun = lc_gav27 CLIPPED
         LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
         LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
         LET li_fun_num = ls_fun_num
         IF li_fun_num > li_max_num THEN
            LET li_max_num = li_fun_num
         END IF
      END IF
   END FOREACH
 
   #其餘副畫面,必須在p_base_per建立才有效
   LET g_sql = "SELECT gax02 FROM gax_file",
               " WHERE gax01='",g_gav01 CLIPPED,"' AND gax03='Y'"
   PREPARE gax_pre FROM g_sql
   DECLARE gax_curs CURSOR FOR gax_pre
   FOREACH gax_curs INTO lc_gax02
      IF g_gav01 CLIPPED = lc_gax02 CLIPPED THEN
         CONTINUE FOREACH
      END IF
      SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
       WHERE gav01=lc_gax02 AND gav08='Y'
      IF li_cnt > 0 THEN
         LET lc_gav08 = "Y"
      ELSE
         LET lc_gav08 = "N"
      END IF
      SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
       WHERE gav01=lc_gax02 AND gav08=lc_gav08 AND gav11=g_gav11
      IF li_cnt > 0 THEN
         LET lc_gav11 = g_gav11
      ELSE
         LET lc_gav11 = g_std_id
      END IF
      LET g_sql = "SELECT gav02,gav21,gav23,gav27 FROM gav_file",
                  " WHERE gav01='",lc_gax02 CLIPPED,"' AND gav08='",lc_gav08 CLIPPED,"' AND gav11='",lc_gav11 CLIPPED,"'",
                  "   AND ((gav28 = '3' AND gav21 IS NOT NULL) OR ",
                  "        (gav29 = '3' AND gav23 IS NOT NULL) OR ",
                  "        (gav30 = '3' AND gav27 IS NOT NULL))"
      PREPARE gav_other_pre FROM g_sql
      DECLARE gav_other_curs CURSOR FOR gav_other_pre
      FOREACH gav_other_curs INTO lc_gav02,lc_gav21,lc_gav23,lc_gav27
         IF lc_gav21 IS NOT NULL THEN
            LET ls_fun = lc_gav21 CLIPPED
            LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
            LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
            LET li_fun_num = ls_fun_num
            IF li_fun_num > li_max_num THEN
               LET li_max_num = li_fun_num
            END IF
         END IF
 
         IF lc_gav23 IS NOT NULL THEN
            LET ls_fun = lc_gav23 CLIPPED
            LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
            LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
            LET li_fun_num = ls_fun_num
            IF li_fun_num > li_max_num THEN
               LET li_max_num = li_fun_num
            END IF
         END IF
 
         IF lc_gav27 IS NOT NULL THEN
            LET ls_fun = lc_gav27 CLIPPED
            LET ls_fun = ls_fun.subString(1,ls_fun.getIndexOf("\n",1)-1)
            LET ls_fun_num = ls_fun.subString(ls_fun.getIndexOf("cl_validate_fun",1)+15,ls_fun.getIndexOf("(",1)-1)
            LET li_fun_num = ls_fun_num
            IF li_fun_num > li_max_num THEN
               LET li_max_num = li_fun_num
            END IF
         END IF
      END FOREACH
   END FOREACH
 
   #計算目前頁面上需要幾個新的function name
   LET li_fun_cnt = 3
   IF NOT cl_null(g_gav21_funname) THEN
      LET li_fun_cnt = li_fun_cnt - 1
   END IF
   IF NOT cl_null(g_gav27_funname) THEN
      LET li_fun_cnt = li_fun_cnt - 1
   END IF
   IF NOT cl_null(g_gav23_funname) THEN
      LET li_fun_cnt = li_fun_cnt - 1
   END IF
 
   FOR li_cnt = 1 TO li_fun_cnt
      LET li_max_num = li_max_num + 1
      IF li_max_num <= 20 THEN
         LET ls_fun_num = li_max_num USING '&&'
         CASE li_cnt
            WHEN 1
               LET ls_funname1 = "FUNCTION cl_validate_fun",ls_fun_num,"(ps_value)"
            WHEN 2
               LET ls_funname2 = "FUNCTION cl_validate_fun",ls_fun_num,"(ps_value)"
            WHEN 3
               LET ls_funname3 = "FUNCTION cl_validate_fun",ls_fun_num,"(ps_value)"
         END CASE
      END IF
   END FOR
 
   RETURN ls_funname1,ls_funname2,ls_funname3
END FUNCTION
 
FUNCTION p_per_progchk_set_entry()
   IF NOT g_before_input_done THEN
      IF g_gav[l_ac].gav07 = "Y" THEN
         CALL cl_set_comp_entry("gav10,gav09",FALSE)
      ELSE
         CALL cl_set_comp_entry("gav10,gav09",TRUE)
      END IF
   END IF
 
   IF INFIELD(gav24) OR NOT g_before_input_done THEN
      IF g_gav_prog.gav24 = "N" OR cl_null(g_gav_prog.gav24) THEN
         CALL cl_set_comp_entry("gav25",FALSE)
      ELSE
         CALL cl_set_comp_entry("gav25",TRUE)
      END IF
   END IF
   IF INFIELD(gav28) OR INFIELD(gav21) OR NOT g_before_input_done THEN
      CASE
         WHEN g_gav_prog.gav28 = "1" OR cl_null(g_gav_prog.gav28)
            CALL cl_set_comp_visible("grp_datacheck_dym",TRUE)
            CALL cl_set_comp_visible("grp_datacheck_sql,grp_datacheck_fun,fun_cite_datacheck",FALSE)
         WHEN g_gav_prog.gav28 = "2"
            CALL cl_set_comp_visible("grp_datacheck_sql",TRUE)
            CALL cl_set_comp_visible("grp_datacheck_dym,grp_datacheck_fun,fun_cite_datacheck",FALSE)
         WHEN g_gav_prog.gav28 = "3"
            CALL cl_set_comp_visible("grp_datacheck_fun,fun_cite_datacheck",TRUE)
            CALL cl_set_comp_visible("grp_datacheck_dym,grp_datacheck_sql",FALSE)
            CALL cl_set_comp_entry("gav21",TRUE)
         WHEN g_gav_prog.gav28 = "4"
            CALL cl_set_comp_visible("grp_datacheck_fun,fun_cite_datacheck",TRUE)
            CALL cl_set_comp_visible("grp_datacheck_dym,grp_datacheck_sql",FALSE)
            CALL cl_set_comp_entry("gav21",FALSE)
      END CASE
   END IF
   IF INFIELD(gav29) OR INFIELD(gav23) OR NOT g_before_input_done THEN
      CASE
         WHEN g_gav_prog.gav29 = "1" OR cl_null(g_gav_prog.gav29)
            CALL cl_set_comp_visible("grp_reference_dym",TRUE)
            CALL cl_set_comp_visible("grp_reference_sql,grp_reference_fun,fun_cite_reference",FALSE)
         WHEN g_gav_prog.gav29 = "2"
            CALL cl_set_comp_visible("grp_reference_sql",TRUE)
            CALL cl_set_comp_visible("grp_reference_dym,grp_reference_fun,fun_cite_reference",FALSE)
         WHEN g_gav_prog.gav29 = "3"
            CALL cl_set_comp_visible("grp_reference_fun,fun_cite_reference",TRUE)
            CALL cl_set_comp_visible("grp_reference_dym,grp_reference_sql",FALSE)
            CALL cl_set_comp_entry("gav23",TRUE)
         WHEN g_gav_prog.gav29 = "4"
            CALL cl_set_comp_visible("grp_reference_fun,fun_cite_reference",TRUE)
            CALL cl_set_comp_visible("grp_reference_dym,grp_reference_sql",FALSE)
            CALL cl_set_comp_entry("gav23",FALSE)
      END CASE
   END IF
   IF INFIELD(gav30) OR INFIELD(gav27) OR NOT g_before_input_done THEN
      CASE
         WHEN g_gav_prog.gav30 = "1" OR cl_null(g_gav_prog.gav30)
            CALL cl_set_comp_visible("grp_rptcheck_dym",TRUE)
            CALL cl_set_comp_visible("grp_rptcheck_sql,grp_rptcheck_fun,fun_cite_rptcheck",FALSE)
         WHEN g_gav_prog.gav30 = "2"
            CALL cl_set_comp_visible("grp_rptcheck_sql",TRUE)
            CALL cl_set_comp_visible("grp_rptcheck_dym,grp_rptcheck_fun,fun_cite_rptcheck",FALSE)
         WHEN g_gav_prog.gav30 = "3"
            CALL cl_set_comp_visible("grp_rptcheck_fun,fun_cite_rptcheck",TRUE)
            CALL cl_set_comp_visible("grp_rptcheck_dym,grp_rptcheck_sql",FALSE)
            CALL cl_set_comp_entry("gav27",TRUE)
         WHEN g_gav_prog.gav30 = "4"
            CALL cl_set_comp_visible("grp_rptcheck_fun,fun_cite_rptcheck",TRUE)
            CALL cl_set_comp_visible("grp_rptcheck_dym,grp_rptcheck_sql",FALSE)
            CALL cl_set_comp_entry("gav27",FALSE)
      END CASE
   END IF
 
   IF INFIELD(gav36) OR NOT g_before_input_done THEN
      IF g_gav_prog.gav36 = "Y" THEN
         CALL cl_set_comp_entry("gav31",FALSE)
         CALL cl_set_comp_entry("gav37",TRUE)
      ELSE
         CALL cl_set_comp_entry("gav31",TRUE)
         CALL cl_set_comp_entry("gav37",FALSE)
      END IF
   END IF
END FUNCTION
 
# FUN-820044 此 function 於 ON ACTION gav21_compile,gav23_compile,gav27_compile
#            中均未 / 尚未開放使用, 因此先 mark 掉, 若後續有需要使用, 請將下列
#            test 或 export 語法改由 Genero built-in function (os.Path) 撰寫
 
#FUNCTION p_per_compile(ps_prog)
#   DEFINE   ps_prog      STRING
#   DEFINE   li_cnt       LIKE type_file.num5
#   DEFINE   lc_zz01      LIKE zz_file.zz01
#   DEFINE   lc_zz08      LIKE zz_file.zz08
#   DEFINE   ls_cmd       STRING
#   DEFINE   ls_module    STRING
#   DEFINE   ls_file      STRING
#   DEFINE   ls_path      STRING
#   DEFINE   lc_channel   base.Channel
#   DEFINE   ls_fgldir    STRING
#   DEFINE   ls_str       STRING
#   DEFINE   li_result    LIKE type_file.num5
#
#   MESSAGE ""
#   IF cl_null(ps_prog) OR cl_null(g_gav01) THEN
#      RETURN
#   END IF
#
#   SELECT COUNT(*) INTO li_cnt FROM zz_file WHERE zz01 = g_gav01
#   IF li_cnt <= 0 THEN
#      SELECT COUNT(*) INTO li_cnt FROM gax_file WHERE gax02 = g_gav01
#      IF li_cnt = 1 THEN
#         SELECT gax01,lc_zz08 INTO lc_zz01,lc_zz08 FROM gax_file,zz_file
#          WHERE gax02 = g_gav01 AND gax01 = zz01
#      END IF
#   ELSE
#      SELECT zz01,zz08 INTO lc_zz01,lc_zz08 FROM zz_file
#       WHERE zz01 = g_gav01
#   END IF
#   IF cl_null(lc_zz01) THEN
#      CALL cl_err("","azz-733",0)
#      RETURN
#   END IF
#
#   LET ls_cmd = lc_zz08
#   LET ls_module = ls_cmd.subString(ls_cmd.getIndexOf("$FGLRUN $",1)+9,ls_cmd.getIndexOf("i/",1)-1)
#   LET ls_module = ls_module.toLowerCase()
#   IF ls_cmd.getCharAt(ls_cmd.getIndexOf("$FGLRUN $",1)+9) = "C" THEN
#      LET ls_path = FGL_GETENV("CUST"),"/",ls_module,"/4gl/"
#      LET ls_file = lc_zz01,".4gl"
#   ELSE
#      LET ls_path = FGL_GETENV("TOP"),"/",ls_module,"/4gl/"
#      LET ls_file = lc_zz01,".4gl"
#   END IF
#   LET ls_cmd = "test -e ",ls_path,ls_file
#   RUN ls_cmd RETURNING li_cnt
#   IF li_cnt THEN
#      CALL cl_err_msg("","azz-734",ls_path||"|"||ls_file,1)
#      RETURN
#   END IF
#   LET ls_cmd = "cp ",ls_path,ls_file," ",FGL_GETENV("TEMPDIR"),"/"
#   RUN ls_cmd
#
#   LET ls_path = FGL_GETENV("TEMPDIR"),"/"
#
#   LET lc_channel = base.Channel.create()
#   CALL lc_channel.openFile(ls_path||lc_zz01 CLIPPED||".ora","w")
#   CALL lc_channel.setDelimiter("")
#   LET ls_str = FGL_GETENV("TOP")
#   LET ls_str = cl_replace_str(ls_str,"/","|")
#   LET ls_str = cl_replace_str(ls_str,"|","\\/")
#   LET ls_str = '/GLOBALS "..\\/..\\/config\\/top.global"/s//GLOBALS "',ls_str,'\\/config\\/top.global"/'
#   CALL lc_channel.write(ls_str)
#   CALL lc_channel.write("w")
#   CALL lc_channel.close()
#   LET ls_cmd = "ex ",ls_path,ls_file," < ",ls_path,lc_zz01 CLIPPED,".ora"
#   RUN ls_cmd
#
#   LET lc_channel = base.Channel.create()
#   CALL lc_channel.openFile(ls_path||ls_file,"a")
#   CALL lc_channel.setDelimiter("")
#   CALL lc_channel.write("")
#   CALL lc_channel.write("#以下函式為動態設定於畫面元件設定作業(p_per)內的函式")
#   CALL lc_channel.write(ps_prog)
#   CALL lc_channel.close()
#
#   LET ls_fgldir = FGL_GETENV("FGLDIR")
#   LET ls_str = "FGLDIR=",ls_fgldir.subString(1,ls_fgldir.getIndexOf(".",1)),"dev; export FGLDIR;",
#                "cd ",FGL_GETENV("TEMPDIR"),";fglcomp ",ls_file,";",
#                "FGLDIR=",ls_fgldir.subString(1,ls_fgldir.getIndexOf(".",1)),"run; export FGLDIR"
#   RUN ls_str
#   LET ls_str = "test -s ",lc_zz01 CLIPPED,".err"
#   RUN ls_str RETURNING li_result
#   IF li_result THEN
#      MESSAGE "Compile Successfully"
#   ELSE
#      LET ls_str =FGL_GETENV('FGLRUN')," $TOP/azz/42r/p_view.42r ",ls_path,lc_zz01 CLIPPED,".err"
#      RUN ls_str
#   END IF
#   LET ls_str = "rm ",lc_zz01 CLIPPED,".*"
#   RUN ls_str
#END FUNCTION
 
#FUN-820044 end
 
FUNCTION p_per_clear_ui_setting()
   DEFINE   ls_module     STRING
   DEFINE   ls_frm_path   STRING
   DEFINE   lnode_win     om.DomNode,             #No.FUN-840011 modify
            lwin_curr     ui.Window,              #No.FUN-840011
            llst_items    om.NodeList,
            li_i          LIKE type_file.num5,    #FUN-680135 SMALLINT
            li_j          LIKE type_file.num5,    #FUN-680135 SMALLINT
            lnode_item    om.DomNode,
            ls_item_name  STRING
   DEFINE   ls_tag_name   DYNAMIC ARRAY OF STRING
   DEFINE   lc_gav02      LIKE gav_file.gav02
   DEFINE   lnode_child   om.DomNode
   DEFINE   lnode_parent  om.DomNode
   DEFINE   lnode_pre     om.DomNode
   DEFINE   lc_enable     LIKE gav_file.gav03
   DEFINE   lc_entry      LIKE gav_file.gav04
   DEFINE   li_width      LIKE gav_file.gav12
   DEFINE   lc_pagename   LIKE gav_file.gav13
   DEFINE   li_posX       LIKE gav_file.gav14
   DEFINE   li_posY       LIKE gav_file.gav15
   DEFINE   li_tabIndex   LIKE gav_file.gav16
   DEFINE   lc_default    LIKE gav_file.gav17
   DEFINE   lc_include    LIKE gav_file.gav18
   DEFINE   li_posX_label LIKE gav_file.gav34
 
   IF cl_confirm("azz-741") THEN
      LET ls_tag_name[1] = "FormField"
      LET ls_tag_name[2] = "TableColumn"
      LET ls_tag_name[3] = "Page"
      LET ls_tag_name[4] = "Group"
      LET ls_tag_name[5] = "Matrix"
      LET ls_tag_name[6] = "Label"
      LET ls_tag_name[7] = "Button"
 
      IF cl_null(g_gav01) OR cl_null(g_gav08) OR cl_null(g_gav11) THEN
         RETURN
      END IF
      CALL p_per_get_module(g_gav01 CLIPPED,g_gav08 CLIPPED) RETURNING ls_module,ls_frm_path
      IF cl_null(ls_module) THEN
         RETURN
      END IF
 
      OPEN WINDOW clear_w WITH FORM ls_frm_path
 
      FOR li_j = 1 TO ls_tag_name.getLength()
          #No.FUN-840011 --start--
#         LET lnode_root = ui.Interface.getRootNode()
#         LET llst_items = lnode_root.selectByTagName(ls_tag_name[li_j])
          LET lwin_curr = ui.Window.getCurrent()
          LET lnode_win = lwin_curr.getNode()
          LET llst_items = lnode_win.selectByTagName(ls_tag_name[li_j])
          #No.FUN-840011 ---end---
 
          FOR li_i = 1 to llst_items.getLength()
              LET lnode_item = llst_items.item(li_i)
              LET ls_item_name = lnode_item.getAttribute("colName")
          
              IF (ls_item_name IS NULL) THEN
                 LET ls_item_name = lnode_item.getAttribute("name")
          
                 IF (ls_item_name IS NULL) THEN
                    CONTINUE FOR
                 END IF
              END IF
              LET lc_gav02 = ls_item_name
 
#             LET lc_enable     = NULL   #No.FUN-840011 mark
#             LET lc_entry      = NULL   #No.FUN-840011 mark
              LET li_width      = NULL
              LET lc_pagename   = NULL
              LET li_posX       = NULL
              LET li_posY       = NULL
              LET li_tabIndex   = NULL
              LET lc_default    = NULL
              LET lc_include    = NULL
              LET li_posX_label = NULL
 
              CASE
                 WHEN li_j = 1 OR li_j = 2
                    LET li_tabIndex = lnode_item.getAttribute("tabIndex")
                    LET lc_default  = lnode_item.getAttribute("defaultValue")
                    LET lc_include  = lnode_item.getAttribute("include")
#                   LET lc_enable   = lnode_item.getAttribute("hidden")     #No.FUN-840011 mark
#                   LET lc_entry    = lnode_item.getAttribute("noEntry")    #No.FUN-840011 mark
                    LET lnode_pre = lnode_item.getPrevious()
                    IF lnode_pre IS NOT NULL THEN
                       IF lnode_pre.getTagName() = "Label" THEN
                          LET li_posX_label = lnode_pre.getAttribute("posX")
                       END IF
                    END IF
                    LET lnode_child = lnode_item.getFirstChild()
                    IF lnode_child IS NOT NULL THEN
                       LET li_width = lnode_child.getAttribute("width")
                       LET li_posX  = lnode_child.getAttribute("posX")
                       LET li_posY  = lnode_child.getAttribute("posY")
                    END IF
                 WHEN li_j = 6
                    LET ls_item_name = lnode_item.getAttribute("name")
                    IF (ls_item_name IS NOT NULL AND
                        ls_item_name.subString(1, 5) = "dummy") THEN
                       LET li_width = lnode_item.getAttribute("width")
                       LET li_posX  = lnode_item.getAttribute("posX")
                       LET li_posY  = lnode_item.getAttribute("posY")
                    END IF
                 WHEN li_j = 7
                    LET li_width = lnode_item.getAttribute("width")
                    LET li_posX  = lnode_item.getAttribute("posX")
                    LET li_posY  = lnode_item.getAttribute("posY")
              END CASE
              IF li_j = 1 OR li_j = 2 OR li_j = 6 OR li_j = 7 THEN
                 LET lc_pagename = NULL
                 LET lnode_parent = lnode_item.getParent()
                 WHILE lnode_parent IS NOT NULL
                    IF lnode_parent.getTagName() = "Page" OR lnode_parent.getTagName() = "Group" THEN
                       LET lc_pagename = lnode_parent.getAttribute("name")
                       EXIT WHILE
                    ELSE
                       LET lnode_parent = lnode_parent.getParent()
                    END IF
                 END WHILE
 
#No.FUN-840011 --mark--
#                IF cl_null(lc_enable) OR lc_enable != "1" THEN
#                   LET lc_enable = "Y"
#                ELSE
#                   LET lc_enable = "N"
#                END IF
#                IF cl_null(lc_entry) OR lc_entry != "1" THEN
#                   LET lc_entry = "Y"
#                ELSE
#                   LET lc_entry = "N"
#                END IF
#No.FUN-840011 --mark--
 
                 UPDATE gav_file SET #gav03 = lc_enable,   gav04 = lc_entry,  #No.FUN-840011 mark
                                     gav12 = li_width,    gav13 = lc_pagename,
                                     gav14 = li_posX,     gav15 = li_posY+1 ,
                                     gav16 = li_tabIndex, gav17 = lc_default,
                                     gav18 = lc_include,  gav34 = li_posX_label
                  WHERE gav01 = g_gav01 AND gav02 = lc_gav02 AND gav08 = g_gav08 AND gav11 = g_gav11
              END IF
              #No.FUN-710055 ---end---
          END FOR
      END FOR
      CLOSE WINDOW clear_w
 
      CALL p_per_b_fill(g_wc)                    # 單身
      DISPLAY ARRAY g_gav TO s_gav.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
   END IF
END FUNCTION
 
FUNCTION p_per_sel_function(pc_checkmtd,ps_funname,ps_content)
   DEFINE   pc_checkmtd   LIKE type_file.chr1
   DEFINE   ps_funname    STRING
   DEFINE   ps_content    STRING
   DEFINE   ls_funname    STRING
   DEFINE   ls_content    STRING
   DEFINE   lc_smb01      LIKE smb_file.smb01
   DEFINE   lc_smb03      LIKE smb_file.smb03
   DEFINE   ls_ind_val    STRING
   DEFINE   ls_ind_des    STRING
   DEFINE   lc_gav01      LIKE gav_file.gav01
   DEFINE   ls_gav02      STRING
   DEFINE   ls_gav08      STRING
   DEFINE   ls_gav11      STRING
   DEFINE   lc_gaz03      LIKE gaz_file.gaz03
   DEFINE   lr_fun        DYNAMIC ARRAY OF RECORD
               gav01_2    LIKE gav_file.gav01,
               gav08_2    LIKE gav_file.gav08,
               gav11_2    LIKE gav_file.gav11,
               gav02_2    LIKE gav_file.gav02,
               checktype  LIKE type_file.chr1,
               fun_cont   LIKE gav_file.gav21
                          END RECORD
   DEFINE   lr_fun_t      RECORD
               gav01_2    LIKE gav_file.gav01,
               gav08_2    LIKE gav_file.gav08,
               gav11_2    LIKE gav_file.gav11,
               gav02_2    LIKE gav_file.gav02,
               checktype  LIKE type_file.chr1,
               fun_cont   LIKE gav_file.gav21
                          END RECORD
   DEFINE   lc_gav21      LIKE gav_file.gav21
   DEFINE   lc_gav23      LIKE gav_file.gav23
   DEFINE   lc_gav27      LIKE gav_file.gav27
   DEFINE   ls_action     STRING
   DEFINE   li_cnt        LIKE type_file.num5
   DEFINE   li_cnt2       LIKE type_file.num5
   DEFINE   ls_gav01_val  STRING
   DEFINE   ls_gav01_des  STRING
   DEFINE   ls_msg        STRING
 
   OPEN WINDOW p_per_sel_function_w WITH FORM "azz/42f/p_per_sel_function"
      ATTRIBUTE(STYLE="viewer")
   CALL cl_ui_locale("p_per_sel_function")
 
   DECLARE industry_curs CURSOR FOR SELECT smb01,smb03 FROM smb_file
   FOREACH industry_curs INTO lc_smb01,lc_smb03
      LET ls_ind_val = ls_ind_val,lc_smb01 CLIPPED,","
      LET ls_ind_des = ls_ind_des,lc_smb01 CLIPPED," [",lc_smb03 CLIPPED,"],"
   END FOREACH
   LET ls_ind_val = ls_ind_val.subString(1,ls_ind_val.getLength()-1)
   LET ls_ind_des = ls_ind_des.subString(1,ls_ind_des.getLength()-1)
   CALL cl_set_combo_items("gav11_2",ls_ind_val,ls_ind_des)
 
   CASE
      WHEN pc_checkmtd = "3"
         CALL cl_set_comp_entry("gav01",TRUE)
         LET g_sql = "SELECT UNIQUE gav01 FROM gav_file ",
                     " WHERE ((gav28='3' AND gav21 IS NOT NULL) OR ",
                     "        (gav29='3' AND gav23 IS NOT NULL) OR ",
                     "        (gav30='3' AND gav27 IS NOT NULL)) "
         PREPARE mtd_3_pre FROM g_sql
         DECLARE mtd_3_curs CURSOR FOR mtd_3_pre
         FOREACH mtd_3_curs INTO lc_gav01
            SELECT count(*) INTO li_cnt FROM gaz_file WHERE gaz01=lc_gav01
            IF li_cnt > 0 THEN
               SELECT gaz03 INTO lc_gaz03 FROM gaz_file
                WHERE gaz01=lc_gav01 AND gaz02=g_lang AND gaz05="Y"
               IF cl_null(lc_gaz03) THEN
                 SELECT gaz03 INTO lc_gaz03 FROM gaz_file
                  WHERE gaz01=lc_gav01 AND gaz02=g_lang AND gaz05="N"
               END IF
            ELSE
               SELECT gae04 INTO lc_gaz03 FROM gae_file
                WHERE gae01=lc_gav01 AND gae02='wintitle' AND gae03=g_lang AND gae11="Y" AND gae12=g_gav11
               IF cl_null(lc_gaz03) THEN
                 SELECT gae04 INTO lc_gaz03 FROM gae_file
                  WHERE gae01=lc_gav01 AND gae02='wintitle' AND gae03=g_lang AND gae11="N" AND gae12=g_gav11
               END IF
            END IF
            LET ls_gav01_val = ls_gav01_val,lc_gav01 CLIPPED,","
            LET ls_gav01_des = ls_gav01_des,lc_gav01 CLIPPED," [",lc_gaz03 CLIPPED,"],"
         END FOREACH
         LET ls_gav01_val = ls_gav01_val.subString(1,ls_gav01_val.getLength()-1)
         LET ls_gav01_des = ls_gav01_des.subString(1,ls_gav01_des.getLength()-1)
         CALL cl_set_combo_items("gav01",ls_gav01_val,ls_gav01_des)
      WHEN pc_checkmtd = "4"
         CALL cl_set_comp_entry("gav01",FALSE)
         CALL p_per_sel_function_combobox(g_gav01)
   END CASE
 
   #DIALOG
   WHILE TRUE
      LET ls_action = NULL
      INPUT lc_gav01,ls_gav02 FROM gav01,gav02
         ON CHANGE gav01
            LET lc_gav01 = GET_FLDBUF(gav01)
            CALL p_per_sel_function_combobox(lc_gav01)
         ON ACTION search
            LET lc_gav01 = GET_FLDBUF(gav01)
            LET ls_gav02 = GET_FLDBUF(gav02)
            EXIT INPUT
         ON ACTION quit
            LET ls_action = "quit"
            EXIT INPUT
 
         ON ACTION about         #FUN-860033
            CALL cl_about()      #FUN-860033
 
         ON ACTION controlg      #FUN-860033
            CALL cl_cmdask()     #FUN-860033
 
         ON ACTION help          #FUN-860033
            CALL cl_show_help()  #FUN-860033
 
         ON IDLE g_idle_seconds  #FUN-860033
             CALL cl_on_idle()
             CONTINUE INPUT
      END INPUT
      IF ls_action = "quit" THEN
         LET ls_funname = ps_funname
         LET ls_content = ps_content
         EXIT WHILE
      END IF
 
      LET g_sql = "SELECT gav01,gav08,gav11,gav02,'','' FROM gav_file",
                  " WHERE ((gav28='3' AND gav21 IS NOT NULL) OR ",
                  "        (gav29='3' AND gav23 IS NOT NULL) OR ",
                  "        (gav30='3' AND gav27 IS NOT NULL))"
      IF NOT cl_null(lc_gav01) THEN
         LET g_sql = g_sql," AND gav01='",lc_gav01 CLIPPED,"'"
      END IF
      IF NOT cl_null(ls_gav02) THEN
         LET ls_gav11 = ls_gav02.subString(ls_gav02.getIndexOf("][",1)+2,ls_gav02.getLength()-1)
         LET ls_gav08 = ls_gav02.subString(ls_gav02.getIndexOf("[",1)+1,ls_gav02.getIndexOf("][",1)-1)
         LET ls_gav02 = ls_gav02.subString(1,ls_gav02.getIndexOf("[",1)-1)
         LET g_sql = g_sql," AND gav02='",ls_gav02,"' AND gav08='",ls_gav08,"'",
                           " AND gav11='",ls_gav11,"'"
      END IF
      IF pc_checkmtd = "4" THEN
         LET g_sql = g_sql," AND gav01='",g_gav01 CLIPPED,"'"
      END IF
      PREPARE fun_pre FROM g_sql
      DECLARE fun_curs CURSOR FOR fun_pre
      LET li_cnt = 1
      FOREACH fun_curs INTO lr_fun_t.*
         SELECT gav21,gav23,gav27 INTO lc_gav21,lc_gav23,lc_gav27 FROM gav_file
          WHERE gav01=lr_fun_t.gav01_2 AND gav02=lr_fun_t.gav02_2
            AND gav08=lr_fun_t.gav08_2 AND gav11=lr_fun_t.gav11_2
         IF NOT cl_null(lc_gav21) THEN
            LET lr_fun[li_cnt].* = lr_fun_t.*
            LET lr_fun[li_cnt].checktype = "1"
            LET lr_fun[li_cnt].fun_cont  = lc_gav21
            LET li_cnt = li_cnt + 1
         END IF
         IF NOT cl_null(lc_gav27) THEN
            LET lr_fun[li_cnt].* = lr_fun_t.*
            LET lr_fun[li_cnt].checktype = "2"
            LET lr_fun[li_cnt].fun_cont  = lc_gav27
            LET li_cnt = li_cnt + 1
         END IF
         IF NOT cl_null(lc_gav23) THEN
            LET lr_fun[li_cnt].* = lr_fun_t.*
            LET lr_fun[li_cnt].checktype = "3"
            LET lr_fun[li_cnt].fun_cont  = lc_gav23
            LET li_cnt = li_cnt + 1
         END IF
      END FOREACH
 
      DISPLAY ARRAY lr_fun TO s_fun.* ATTRIBUTE(COUNT=lr_fun.getLength())
         BEFORE ROW
            LET li_cnt = ARR_CURR()
            IF li_cnt > 0 THEN
               DISPLAY lr_fun[li_cnt].fun_cont TO formonly.fun_cont_desc
            END IF
         ON ACTION send
            CALL p_per_data_separate(lr_fun[li_cnt].fun_cont,"f") RETURNING ls_funname,ls_content,ls_msg
            LET ls_action = "send"
            EXIT DISPLAY
         ON ACTION accept
            CALL p_per_data_separate(lr_fun[li_cnt].fun_cont,"f") RETURNING ls_funname,ls_content,ls_msg
            LET ls_action = "send"
            EXIT DISPLAY
         ON ACTION search
            EXIT DISPLAY
         ON ACTION quit
            LET ls_action = "quit"
            EXIT DISPLAY
      END DISPLAY
      IF ls_action = "quit" THEN
         LET ls_funname = ps_funname
         LET ls_content = ps_content
         EXIT WHILE
      END IF
      IF ls_action = "send" THEN
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW p_per_sel_function_w
 
   RETURN ls_funname,ls_content
END FUNCTION
 
FUNCTION p_per_sel_function_combobox(pc_gav01)
   DEFINE   pc_gav01      LIKE gav_file.gav01
   DEFINE   lc_gav02      LIKE gav_file.gav02
   DEFINE   lc_gav08      LIKE gav_file.gav08
   DEFINE   lc_gav11      LIKE gav_file.gav11
   DEFINE   lc_gae04      LIKE gae_file.gae04
   DEFINE   lc_smb03      LIKE smb_file.smb03
   DEFINE   ls_gav02_val  STRING
   DEFINE   ls_gav02_des  STRING
 
   LET g_sql = "SELECT gav02,gav08,gav11 FROM gav_file ",
               " WHERE ((gav28='3' AND gav21 IS NOT NULL) OR ",
               "        (gav29='3' AND gav23 IS NOT NULL) OR ",
               "        (gav30='3' AND gav27 IS NOT NULL)) ",
               "   AND gav01='",pc_gav01 CLIPPED,"'"
   PREPARE mtd_fld_pre FROM g_sql
   DECLARE mtd_fld_curs CURSOR FOR mtd_fld_pre
   FOREACH mtd_fld_curs INTO lc_gav02,lc_gav08,lc_gav11
      SELECT gae04 INTO lc_gae04 FROM gae_file
       WHERE gae01=pc_gav01 AND gae11=lc_gac08
         AND gae02=lc_gav02 AND gae03=g_lang AND gae12=lc_gav11
      LET ls_gav02_val = ls_gav02_val,lc_gav02 CLIPPED,"[",lc_gav08 CLIPPED,"][",lc_gav11 CLIPPED,"],"
      IF lc_gav08 = "Y" THEN
         LET ls_gav02_des = ls_gav02_des,lc_gav02 CLIPPED," [C]"
      ELSE
         LET ls_gav02_des = ls_gav02_des,lc_gav02 CLIPPED," [P]"
      END IF
      SELECT smb03 INTO lc_smb03 FROM smb_file
       WHERE smb01=lc_gav11 AND smb02=g_lang
      LET ls_gav02_des = ls_gav02_des," [",lc_smb03 CLIPPED,"],"
   END FOREACH
   LET ls_gav02_val = ls_gav02_val.subString(1,ls_gav02_val.getLength()-1)
   LET ls_gav02_des = ls_gav02_des.subString(1,ls_gav02_des.getLength()-1)
   CALL cl_set_combo_items("gav02",ls_gav02_val,ls_gav02_des)
END FUNCTION
#No.FUN-710055 ---end---
 
#No.FUN-760049 --start--
FUNCTION p_per_set_combobox()
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
   CALL cl_set_combo_items("gav11",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
END FUNCTION
#No.FUN-760049 ---end---
 
#No.FUN-760072 --start--
FUNCTION p_per_query_desc(ps_value)
   DEFINE   ps_value   STRING
   DEFINE   ls_sql     STRING
   DEFINE   lc_gae04   LIKE gae_file.gae04
 
   LET ls_sql = "SELECT gae04 FROM gae_file",
                " WHERE gae01='",ps_value,"' AND gae02='wintitle'",
                "   AND gae03='",g_lang,"' ORDER BY gae11 DESC"
   PREPARE query_gae04_pre FROM ls_sql
   EXECUTE query_gae04_pre INTO lc_gae04
   IF cl_null(lc_gae04) THEN
      LET ls_sql = "SELECT gat03 FROM gat_file,gac_file",
                   " WHERE gac01='",ps_value,"' AND gac10='Y'",
                   "   AND gat01=gac05 AND gat02='",g_lang,"' ORDER BY gac02 ASC"
      PREPARE query_gat03_pre FROM ls_sql
      EXECUTE query_gat03_pre INTO lc_gae04
   END IF
   CASE
      WHEN INFIELD(gav19)
         DISPLAY lc_gae04 TO gae04_1
      WHEN INFIELD(gav39)
         DISPLAY lc_gae04 TO gae04_2
   END CASE
END FUNCTION
#No.FUN-760072 ---end---
 
#No.FUN-950073 --start--
FUNCTION p_per_chg_udfield_visible()
   DEFINE   lc_gav02     LIKE gav_file.gav02
   DEFINE   lc_visible   LIKE type_file.chr1
 
   IF cl_null(g_gav01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   MENU "" ATTRIBUTE(STYLE="popup")
      ON ACTION set_udfield_visible
         LET lc_visible = "Y"
      ON ACTION set_udfield_invisible
         LET lc_visible = "N"
   END MENU
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF
 
   LET g_sql = "UPDATE gav_file SET gav03 = ? ",
               " WHERE gav01 = '",g_gav01 CLIPPED,"' AND gav02 = ?",
               "   AND gav08 = '",g_gav08 CLIPPED,"' AND gav11 = '",g_gav11 CLIPPED,"'"
   PREPARE visible_pre FROM g_sql
 
   LET g_sql = "SELECT gav02 FROM gav_file ",
               " WHERE gav01 = '",g_gav01 CLIPPED,"' AND gav08 = '",g_gav08 CLIPPED,"'",
               "   AND gav11 = '",g_gav11 CLIPPED,"'"
   PREPARE gav02_pre FROM g_sql
   DECLARE gav02_curs CURSOR FOR gav02_pre
 
   FOREACH gav02_curs INTO lc_gav02
      IF (lc_gav02 MATCHES "???ud[01][0-9]") OR (lc_gav02 MATCHES "????ud[01][0-9]") THEN
         EXECUTE visible_pre USING lc_visible,lc_gav02
      END IF
   END FOREACH
 
   CALL p_per_b_fill(g_wc)
END FUNCTION
 
FUNCTION p_per_chg_industry_visible()
   DEFINE   lc_gav02     LIKE gav_file.gav02
   DEFINE   lc_visible   LIKE type_file.chr1
   DEFINE   li_i         LIKE type_file.num5
   DEFINE   ls_match     STRING
   DEFINE   ls_imamatch  STRING
 
   IF cl_null(g_gav01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   LET g_sql = "UPDATE gav_file SET gav03 = ? ",
               " WHERE gav01 = '",g_gav01 CLIPPED,"' AND gav02 = ?",
               "   AND gav08 = '",g_gav08 CLIPPED,"' AND gav11 = '",g_gav11 CLIPPED,"'"
   PREPARE industry_visible_pre FROM g_sql
 
   LET g_sql = "SELECT gav02 FROM gav_file ",
               " WHERE gav01 = '",g_gav01 CLIPPED,"' AND gav08 = '",g_gav08 CLIPPED,"'",
               "   AND gav11 = '",g_gav11 CLIPPED,"'"
   PREPARE ind_gav02_pre FROM g_sql
   DECLARE ind_gav02_curs CURSOR FOR ind_gav02_pre
 
   FOREACH ind_gav02_curs INTO lc_gav02
      IF g_gav11 = g_std_id THEN
         FOR li_i = 1 TO g_smb01.getLength()
             IF g_smb01[li_i] = g_std_id THEN
                CONTINUE FOR
             END IF
             LET ls_match = "*i",g_smb01[li_i] CLIPPED,"*"
             LET ls_imamatch = "ima",g_smb01[li_i] CLIPPED,"*"
             IF lc_gav02 MATCHES ls_match OR lc_gav02 MATCHES ls_imamatch THEN
                EXECUTE industry_visible_pre USING "N",lc_gav02
             END IF
         END FOR
      ELSE
         FOR li_i = 1 TO g_smb01.getLength()
             IF g_smb01[li_i] = g_std_id THEN
                CONTINUE FOR
             END IF
             LET ls_match = "*i",g_smb01[li_i] CLIPPED,"*"
             LET ls_imamatch = "ima",g_smb01[li_i] CLIPPED,"*"
             IF lc_gav02 MATCHES ls_match OR lc_gav02 MATCHES ls_imamatch THEN
                IF g_smb01[li_i] = g_gav11 THEN
                   LET lc_visible = "Y"
                ELSE
                   LET lc_visible = "N"
                END IF
                EXECUTE industry_visible_pre USING lc_visible,lc_gav02
             END IF
         END FOR
      END IF
   END FOREACH
 
   CALL p_per_b_fill(g_wc)
END FUNCTION
#No.FUN-950073 ---end---
