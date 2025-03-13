# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Pattern name...: axmp410.4gl
# Descriptions...: 訂單結案/還原
# Date & Author..: 95/01/23 By Roger
# Modify.........: No.8305 03/09/22 By APPLE 修改tm.wc3寫法
# Modify.........: No.9788 04/07/22 By Wiky 結案未考慮權限控管
# Modify.........: No.FUN-4A0027 04/10/08 By Carol add訂單單號,帳款客戶開窗
# Modify.........: No.MOD-4A0247 04/10/18 By Mandy 1.控管當沒有單號時,不能做結案及取消結案
# Modify.........: No.MOD-4A0247 04/10/18 By Mandy 2."作業結束,請按任何鍵繼續:" 多show了一次
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530370 05/03/28 By Mandy 結案的欄位在無項次的畫面多出現一個.
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-550166 05/06/17 By kim 結案還原 + 結案 做 transation control
# Modify.........: No.MOD-570253 05/08/08 By Rosayu oeb08=>no use
# Modify.........: NO.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-5B0133 05/12/05 By Nicola 整批結案加入權限控管
# Modify.........: No.MOD-640481 06/04/14 By Claire 結案前確認QBE不可空白
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-710046 07/01/17 By Carrier 錯誤訊息匯整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-750006 07/05/02 By claire 顯示 oeahold的值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.FUN-850052 08/10/13 BY yiting 加入篩選條件「出貨數量>=訂單數量」
# Modify.........: No.CHI-910040 09/01/16 By xiaofeizhu 在取消結案時，如為"借貨訂單(oea00='8')"，已結案量應等於已銷退量
# Modify.........: No.MOD-960238 09/06/19 By Carrier 整批結案更新不成功
# Modify.........: No.MOD-960272 09/06/25 By Dido 排除三角單據
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0062 09/12/07 By sherry 查詢時抓取資料的sql和計算筆數的sql不一致，導致上下筆顯示有問題
# Modify.........: No:MOD-9C0440 09/12/29 By Dido 批次結案應與主畫面條件相同 
# Modify.........: No:CHI-A60025 10/06/30 By Summer 1.訂單確認後才可以做單身結案,單身若全結案就將單頭的狀況碼改為結案.
#                                                   2.取消結案時,若單身有項次是未結案的,就將單頭的狀況碼改為已核准. 
# Modify.........: No:MOD-A80091 10/08/12 By Smapmin 整批結案時,若剛好有結案到畫面的這筆資料,結案否欄位沒有即時顯示
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-AB0260 10/11/30 By Smapmin 修改變數定義型態
# Modify.........: No.FUN-AC0074 11/04/26 BY shenyang 考慮是否有備置未發量，有產生退備單
# Modify.........: No:MOD-B50246 11/06/15 By Summer 還原MOD-960272修改排除多角單據,改為多角未拋轉單據可結案
# Modify.........: No:CHI-B80016 11/08/11 By johung 依s_mpslog判斷是否取消異動
# Modify.........: No:TQC-C20187 12/02/27 By zhangll wc chr1000->string
# Modify.........: No:FUN-C50136 12/07/06 By xujing 訂單結案信用管控
# Modify.........: No:FUN-D30086 13/03/26 By Elise 整批結案的情況，用彙總訊息顯示成功與失敗單據狀況
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD
                #TQC-C20187 mod
                #wc      LIKE type_file.chr1000,   # Head Where condition   #No.FUN-680137 VARCHAR(300)
                #wc2     LIKE type_file.chr1000,   # Body Where condition   #No.FUN-680137 VARCHAR(300)
                #wc3     LIKE type_file.chr1000    # unqty                  #No.FUN-680137 VARCHAR(300)
                 wc    STRING,
                 wc2   STRING,
                 wc3   STRING
                #TQC-C20187 mod--end
              END RECORD,
       g_oea  RECORD
                 oea01   LIKE oea_file.oea01,
                 oea02   LIKE oea_file.oea02,
                 oea03   LIKE oea_file.oea03,
                 oea04   LIKE oea_file.oea04,
                 oea032  LIKE oea_file.oea032,
                 occ02   LIKE occ_file.occ02,
                 oea14   LIKE oea_file.oea14,
                 oea15   LIKE oea_file.oea15,
                 oeahold LIKE oea_file.oeahold,  #MOD-750006 add
                 oeaconf LIKE oea_file.oeaconf
              END RECORD,
       g_oeb  DYNAMIC ARRAY OF RECORD
                 oeb03   LIKE oeb_file.oeb03,
                 oeb04   LIKE oeb_file.oeb04,
                 oeb06   LIKE oeb_file.oeb06,
                 oeb092  LIKE oeb_file.oeb092,
                 oeb05   LIKE oeb_file.oeb05,
                 oeb12   LIKE oeb_file.oeb12,      #No.FUN-680137 INTEGER   #MOD-AB0260
                 oeb24   LIKE oeb_file.oeb24,      #No.FUN-680137 INTEGER   #MOD-AB0260
                 oeb25   LIKE oeb_file.oeb25,      #No.FUN-680137 INTEGER   #MOD-AB0260
                 unqty   LIKE type_file.num10,      #No.FUN-680137 INTEGER
                 oeb15   LIKE oeb_file.oeb15,
                 oeb70   LIKE oeb_file.oeb70,
               # oeb08   LIKE oeb_file.oeb08, #MOD-570253
                 oeb09   LIKE oeb_file.oeb09,
                 oeb091  LIKE oeb_file.oeb091,
                 oeb16   LIKE oeb_file.oeb16
              END RECORD,
       g_argv1          LIKE oea_file.oea01,
       g_query_flag     LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680137
      #g_wc,g_wc2,g_sql LIKE type_file.chr1000,#WHERE CONDITION  #No.FUN-580092 HCN #No.FUN-680137
       g_wc,g_wc2,g_sql STRING,   #TQC-C20187 mod
       g_rec_b          LIKE type_file.num10   #No.FUN-680137 INTEGER          #單身筆數
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE l_ac             LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_no_ask        LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE g_flag           LIKE type_file.chr1    #NO.FUN-850052
DEFINE g_oea00          LIKE oea_file.oea00    #NO.CHI-910040
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
   LET g_argv1 = ARG_VAL(1)          #參數值(1) Part#
   LET g_query_flag = 1
 
   OPEN WINDOW p410_w WITH FORM "axm/42f/axmp410"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
#  IF cl_chk_act_auth() THEN
#     CALL p410_q()
#  END IF
 
   IF NOT cl_null(g_argv1) THEN
      CALL p410_q()
   END IF
 
   WHILE TRUE
      LET g_action_choice = ''
      CALL p410_menu()
      IF g_action_choice = 'exit' THEN
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW p410_w
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
 
END MAIN
 
FUNCTION p410_cs()
   DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "oea01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
      CALL g_oeb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL                      # Default condition
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_oea.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,oea14,oea15
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
##FUN-4A0027
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                   #LET g_qryparam.form ="q_oea6"	#MOD-960272 mark
                    LET g_qryparam.form ="q_oea61"	#MOD-960272
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea01
                    NEXT FIELD oea01
               WHEN INFIELD(oea03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea03
                    NEXT FIELD oea03
               WHEN INFIELD(oea04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea04
                    NEXT FIELD oea04
               WHEN INFIELD(oea14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea14
                    NEXT FIELD oea14
               WHEN INFIELD(oea15)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea15
                    NEXT FIELD oea15
             END CASE
##
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CALL p410_b_askkey()
 
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   MESSAGE ' WAIT '
 
   #No.9788
   #資料權限的檢查
   LET g_wc="1=1"
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   #No.9788(end)
 
   LET g_sql="SELECT UNIQUE oea01 FROM oea_file,oeb_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED,
             "   AND oea01 = oeb01",
            #"   AND oea901 = 'N' ",	#MOD-960272 #MOD-B50246 mark
             "   AND oea905 != 'Y' ",	#MOD-B50246 add 
             "   AND oeaconf != 'X' ", #01/08/16 mandy
             "   AND ",g_wc CLIPPED   #No.9788
             #" ORDER BY oea01"        #NO.FUN-850052 mark
   #-----FUN-850052---------
   IF g_flag = 'Y' THEN
      LET g_sql = g_sql CLIPPED," AND oeb24 >= oeb12"
   END IF
   #-----FUN-850052---------
   PREPARE p410_prepare FROM g_sql
   DECLARE p410_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR p410_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql="SELECT COUNT(unique oea01) FROM oea_file,oeb_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND ",tm.wc2 CLIPPED, #BugNo:6126
             "   AND oea01 = oeb01",
            #"   AND oea901 = 'N' ",	#MOD-9C0063 #MOD-B50246 mark
             "   AND oea905 != 'Y' ",	#MOD-B50246 add 
             "   AND oeaconf != 'X' " #01/08/16 mandy
   #-----FUN-850052---------
   IF g_flag = 'Y' THEN
      LET g_sql = g_sql CLIPPED," AND oeb24 >= oeb12"
   END IF
   #-----FUN-850052---------
   PREPARE p410_pp FROM g_sql
   DECLARE p410_cnt CURSOR FOR p410_pp
 
END FUNCTION
 
FUNCTION p410_b_askkey()
   DEFINE l_unqty LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(80)
 
   CONSTRUCT tm.wc2 ON oeb03,oeb04,oeb092,oeb05,oeb12,oeb24,oeb25,unqty,
                      #oeb15,oeb70,oeb06,oeb08,oeb09,oeb091,oeb16 #MOD-570253
                       oeb15,oeb70,oeb06,oeb09,oeb091,oeb16 #MOD-570253
                  FROM s_oeb[1].oeb03,s_oeb[1].oeb04,s_oeb[1].oeb092,
                       s_oeb[1].oeb05,s_oeb[1].oeb12,s_oeb[1].oeb24,
                       s_oeb[1].oeb25,s_oeb[1].unqty,
                       s_oeb[1].oeb15,s_oeb[1].oeb70,
                      #s_oeb[1].oeb06,s_oeb[1].oeb08,s_oeb[1].oeb09, #MOD-570253
                       s_oeb[1].oeb06,s_oeb[1].oeb09, #MOD-570253
                       s_oeb[1].oeb091,s_oeb[1].oeb16
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
 
  #LET tm.wc2 =  cl_substr(tm.wc2,'unqty', '(oeb12-oeb24+oeb25-oeb26)')
   LET tm.wc2 =  cl_replace_str(tm.wc2,'unqty', '(oeb12-oeb24+oeb25-oeb26)') #No:8305
  #DISPLAY "tm.wc2=",tm.wc2       #CHI-A70049 mark
 
END FUNCTION
 
FUNCTION p410_menu()
   WHILE TRUE
      CALL p410_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL p410_q()
            END IF
         WHEN "close_the_case"
            IF cl_chk_act_auth() THEN
                #MOD-550166................begin
               LET g_success='Y'
               BEGIN WORK
                #MOD-550166................end
               CALL p410_y()
                #MOD-550166................begin
               IF g_success='Y' THEN
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
               END IF
                #MOD-550166................end
            END IF
         WHEN "batch_close"
            IF cl_chk_act_auth() THEN
               CALL p456()
               CALL p410_show()   #MOD-A80091
            END IF
         WHEN "undo_close"
            IF cl_chk_act_auth() THEN
                #MOD-550166................begin
               LET g_success='Y'
               BEGIN WORK
                #MOD-550166................end
               CALL p410_z()
                #MOD-550166................begin
               IF g_success='Y' THEN
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
               END IF
                #MOD-550166................end
            END IF
         WHEN "next"
            CALL p410_fetch('N')
         WHEN "previous"
            CALL p410_fetch('P')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "jump"
            CALL p410_fetch('/')
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p410_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   #no.FUN-850052 start---
   OPEN WINDOW p410_cw WITH FORM "axm/42f/axmp410c" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmp410c") 
 
   LET g_flag = 'N'   
   INPUT BY NAME g_flag WITHOUT DEFAULTS 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT    
   
   END INPUT
   #TQC-870038--begin--
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p410_cw
      RETURN
   END IF
   #TQC-870038--end--
   CLOSE WINDOW p410_cw
   #NO.FUN-850052 end-------------
 
   CALL p410_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_oea.* TO NULL         # MOD-640481
      RETURN
   END IF
 
   OPEN p410_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN p410_cnt
      FETCH p410_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p410_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ''
 
END FUNCTION
 
FUNCTION p410_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
       l_oeauser       LIKE oea_file.oeauser, #FUN-4C0057 add
       l_oeagrup       LIKE oea_file.oeagrup  #FUN-4C0057 add
 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     p410_cs INTO g_oea.oea01
      WHEN 'P' FETCH PREVIOUS p410_cs INTO g_oea.oea01
      WHEN 'F' FETCH FIRST    p410_cs INTO g_oea.oea01
      WHEN 'L' FETCH LAST     p410_cs INTO g_oea.oea01
      WHEN '/'
         IF (NOT g_no_ask) THEN
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
         FETCH ABSOLUTE g_jump p410_cs INTO g_oea.oea01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)
      INITIALIZE g_oea.* TO NULL  #TQC-6B0105
      LET g_oea.oea01 = NULL      #TQC-6B0105
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
 
   SELECT oea01,oea02,oea03,oea04,oea032,'',
          oea14,oea15,oeahold,oeaconf,oeauser,oeagrup  #FUN-4C0057  #MOD-750006 modify
     INTO g_oea.*,l_oeauser,l_oeagrup    #FUN-4C0057
     FROM oea_file
    WHERE oea01 = g_oea.oea01
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)   #No.FUN-660167
      CALL cl_err3("sel","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
      INITIALIZE g_oea.* TO NULL         #FUN-4C0057 add
      RETURN
   END IF
 
   LET g_data_owner = l_oeauser      #FUN-4C0057 add
   LET g_data_group = l_oeagrup      #FUN-4C0057 add
   CALL p410_show()
 
END FUNCTION
 
FUNCTION p410_show()
 
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
   IF SQLCA.SQLCODE THEN LET g_oea.occ02=' ' END IF
   DISPLAY BY NAME g_oea.*   # 顯示單頭值
 
   CALL p410_b_fill() #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION p410_b_fill()              #BODY FILL UP
  #DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(400)
   DEFINE l_sql     STRING  #TQC-C20187 mod
 
   IF cl_null(tm.wc2) THEN
      LET tm.wc2=" 1=1"
   END IF
 
   LET l_sql =
        "SELECT oeb03,oeb04,oeb06,oeb092,oeb05,oeb12,oeb24,oeb25,",
        "      (oeb12-oeb24+oeb25-oeb26),oeb15,oeb70,",
       #"       oeb08,oeb09,oeb091,oeb16,' ' ", #MOD-570253
        "             oeb09,oeb091,oeb16,' ' ", #MOD-570253
        "  FROM oeb_file ",
        " WHERE oeb01 = '",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        " ORDER BY 1"
   PREPARE p410_pb FROM l_sql
   DECLARE p410_bcs CURSOR WITH HOLD FOR p410_pb
 
   CALL g_oeb.clear()
 
   LET g_cnt = 1
 
   FOREACH p410_bcs INTO g_oeb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #--NO.FUN-850052 start--
      IF g_flag = 'Y' THEN  
          IF g_oeb[g_cnt].oeb24 < g_oeb[g_cnt].oeb12 THEN
              CONTINUE FOREACH
          END IF
      END IF
      #--NO.FUN-850052 end----
 
      IF g_oeb[g_cnt].oeb12 IS NULL THEN
         LET g_oeb[g_cnt].oeb12 = 0
      END IF
 
      IF g_oeb[g_cnt].oeb24 IS NULL THEN
         LET g_oeb[g_cnt].oeb24 = 0
      END IF
 
      IF g_oeb[g_cnt].oeb25 IS NULL THEN
         LET g_oeb[g_cnt].oeb25 = 0
      END IF
 
      IF g_oeb[g_cnt].unqty IS NULL THEN
         LET g_oeb[g_cnt].unqty = 0
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_oeb.deleteElement(g_cnt) #MOD-530370
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION p410_bp(p_ud)
   DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" THEN RETURN END IF
 
   LET g_action_choice = ""
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION close_the_case
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
 
      ON ACTION undo_close
         LET g_action_choice="undo_close"
         EXIT DISPLAY
 
      ON ACTION batch_close
         LET g_action_choice="batch_close"
         EXIT DISPLAY
 
      ON ACTION next
         CALL p410_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL p410_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION first
         CALL p410_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL p410_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL p410_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      #No.MOD-530688  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE                 #MOD-570244     mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.MOD-530688  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION p410_y()
   DEFINE l_oeb   RECORD LIKE oeb_file.*
   DEFINE l_seq   LIKE type_file.num5          #No.FUN-680137 SMALLINT 
   DEFINE i       LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_cnt   LIKE type_file.num5          #CHI-A60025 add
   DEFINE l_sie11 LIKE sie_file.sie11          #FUN-AC0074
#  DEFINE l_oia07 LIKE oia_file.oia07 #FUN-C50136 
   IF cl_null(g_oea.oea01) THEN
      CALL cl_err('',-400,0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF #MOD-4A0247
 
   #CHI-A60025 add --start--
   IF g_oea.oeaconf<>'Y' THEN
      CALL cl_err('',9026,0)
      LET g_success='N'
      RETURN
   END IF
   #CHI-A60025

   CALL cl_getmsg('axm-200',g_lang) RETURNING g_msg
   LET INT_FLAG = 0  ######add for prompt bug

   PROMPT g_msg CLIPPED FOR l_seq
 
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
      LET INT_FLAG=0
      LET g_success='N' #MOD-550166
      RETURN
   END IF
 
   IF l_seq IS NULL THEN
      LET g_success='N' #MOD-550166
      RETURN
   END IF
   #NO.FUN-850052 start---
   IF g_flag = 'Y' THEN  
       SELECT * INTO l_oeb.* FROM oeb_file
        WHERE oeb01 = g_oea.oea01
          AND oeb03 = l_seq
          AND oeb24 > = oeb12
       IF STATUS THEN
          CALL cl_err("","axm1999",1)
          LET g_success='N' 
          RETURN
       END IF
   ELSE
   #NO.FUN-850052 end----
       SELECT * INTO l_oeb.* FROM oeb_file
        WHERE oeb01 = g_oea.oea01
          AND oeb03 = l_seq
       IF STATUS THEN
#         CALL cl_err('sel oeb:',STATUS,0)   #No.FUN-660167
          CALL cl_err3("sel","oeb_file",g_oea.oea01,l_seq,STATUS,"","sel oeb",0)   #No.FUN-660167
          LET g_success='N' #MOD-550166
          RETURN
       END IF
   END IF                 #NO.FUN-850052
 
   IF l_oeb.oeb70='Y' THEN
      CALL cl_err('sel oeb:','axm-202',0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF
 
   LET l_oeb.oeb70 = 'Y'
   LET l_oeb.oeb70d = g_today
   LET l_oeb.oeb26 = l_oeb.oeb12 - l_oeb.oeb24 + l_oeb.oeb25
   IF l_oeb.oeb19 = 'Y' THEN
      LET l_oeb.oeb905 = 0
   END IF  #no.7182
 
   UPDATE oeb_file SET * = l_oeb.*
    WHERE oeb01 = g_oea.oea01
      AND oeb03 = l_seq
  #No.+042 010330 by plum
  #IF STATUS THEN CALL cl_err('upd oeb70:',STATUS,0) RETURN END IF
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('upd oeb70:',SQLCA.SQLCODE,0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF
  #No.+042 ..end
 
   #-->產生MPS異動log
   IF g_oaz.oaz06 = 'Y' THEN
      CALL s_mpslog('C',l_oeb.oeb04,l_oeb.oeb26,l_oeb.oeb15,
                    '','','',g_oea.oea01,l_seq,l_seq)
      IF g_success = 'N' THEN RETURN END IF   #CHI-B80016 add
   END IF
 
   SELECT SUM(oeb14/oeb12*oeb26) INTO l_oeb.oeb14 FROM oeb_file
    WHERE oeb01=g_oea.oea01
 
   IF cl_null(l_oeb.oeb14) THEN
      LET l_oeb.oeb14 = 0
   END IF
 
   UPDATE oea_file SET oea63 = l_oeb.oeb14
    WHERE oea01=g_oea.oea01
  #No.+042 010330 by plum
  #IF STATUS THEN CALL cl_err('upd oea63:',STATUS,0) RETURN END IF
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('upd oea63:',SQLCA.SQLCODE,0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF
# BugNo.+042 ..end
   #FUN-AC0074--add--begin
   SELECT  SUM(sie11) INTO l_sie11 FROM sie_file
     WHERE sie05=l_oeb.oeb01  AND sie15=l_oeb.oeb03
   IF l_sie11 >0 THEN
      CALL p410_yes(l_oeb.oeb01,l_oeb.oeb03)
   END IF
   #FUN-AC0074--add--end 
   FOR i = 1 TO g_oeb.getLength()
      IF g_oeb[i].oeb03=l_seq THEN
         LET g_oeb[i].oeb70='Y'
      END IF
   END FOR
 
   #CHI-A60025 add --start--
   SELECT COUNT(*) INTO l_cnt FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb70 = 'N'
   IF l_cnt = 0  THEN
      UPDATE oea_file SET oea49 = '2'
       WHERE oea01=g_oea.oea01
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err('upd oea49:',SQLCA.SQLCODE,0)
         LET g_success='N'
         RETURN
      END IF
   END IF
   #CHI-A60025 add --end--
#FUN-C50136-mark--str
#  #FUN-C50136---add---str---
#  IF g_oaz.oaz96 = 'Y' THEN
#     CALL s_ccc_oia07('H',g_oea.oea03) RETURNING l_oia07
#     IF NOT cl_null(l_oia07) AND l_oia07 = '3' THEN
#        CALL s_ccc_oia(g_oea.oea03,'H',g_oea.oea01,l_seq,'')
#     END IF
#  END IF
#  #FUN-C50136---add---end---
#FUN-C50136-mark--end
END FUNCTION

#FUN-AC0074--add--begin
FUNCTION p410_yes(p_oeb01,p_oeb03)
DEFINE  l_sia  RECORD LIKE sia_file.*
DEFINE  p_oeb01 LIKE oeb_file.oeb01
DEFINE  p_oeb03 LIKE oeb_file.oeb03
DEFINE  l_sie   DYNAMIC ARRAY OF RECORD 
                sie01   LIKE sie_file.sie01,
                sie02   LIKE sie_file.sie02,
                sie03   LIKE sie_file.sie03,
                sie04   LIKE sie_file.sie04,
                sie05   LIKE sie_file.sie05,
                sie06   LIKE sie_file.sie06,
                sie07   LIKE sie_file.sie07,
                sie08   LIKE sie_file.sie08,
                sie09   LIKE sie_file.sie09, 
                sie10   LIKE sie_file.sie10,
                sie11   LIKE sie_file.sie11,
                sie12   LIKE sie_file.sie12,
                sie13   LIKE sie_file.sie13,
                sie14   LIKE sie_file.sie14,
                sie15   LIKE sie_file.sie15,
                sie16   LIKE sie_file.sie16,
                sie012  LIKE sie_file.sie012,
                sie013  LIKE sie_file.sie013
                END RECORD   
DEFINE l_ac             LIKE type_file.num5 
DEFINE g_sql            STRING               
DEFINE li_result    LIKE type_file.num5
DEFINE l_err        STRING
DEFINE l_flag      LIKE type_file.chr1 
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE l_fac       LIKE ima_file.ima31_fac
DEFINE l_sic07_fac LIKE sic_file.sic07_fac
DEFINE l_sic02     LIKE sic_file.sic02

      LET l_sia.sia04 ='2'
      LET l_sia.sia05 = '3'
      LET l_sia.sia06 = g_grup
      LET l_sia.sia02 =g_today
      LET l_sia.sia03 =g_today
      LET l_sia.siaacti = 'Y'
      LET l_sia.siaconf = 'N'
      LET l_sia.siauser = g_user
      LET l_sia.siaplant = g_plant
      LET l_sia.siadate = g_today
      LET l_sia.sialegal = g_legal
      LET l_sia.siagrup = g_grup
      LET l_sia.siaoriu = g_user
      LET l_sia.siaorig = g_grup    
         LET g_sql=" SELECT MAX(smyslip) FROM smy_file",
                   "  WHERE smysys = 'asf' AND smykind='5' ",
                   "    AND length(smyslip) = ",g_doc_len
         PREPARE p410_smy FROM g_sql
         EXECUTE p410_smy INTO l_sia.sia01
        CALL s_auto_assign_no("asf",l_sia.sia01,l_sia.sia02,"","sia_file","sia01","","","")
            RETURNING li_result,l_sia.sia01
        IF (NOT li_result) THEN
            LET g_success='N'
            RETURN
        END IF 
      INSERT INTO sia_file(sia01,sia02,sia03,sia04,sia05,sia06,siaacti,
                    siaconf,siauser,siaplant,
                     siadate,sialegal,siagrup,siaoriu,siaorig) 
             VALUES (l_sia.sia01,l_sia.sia02,l_sia.sia03,l_sia.sia04,l_sia.sia05,g_grup,l_sia.siaacti,
                     l_sia.siaconf,l_sia.siauser,l_sia.siaplant,
                     l_sia.siadate,l_sia.sialegal,l_sia.siagrup,l_sia.siaoriu,l_sia.siaorig)
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("ins","sia_file",l_sia.sia01,l_sia.sia02,l_err,"","ins sia:",1) 
         LET g_success='N' 
         RETURN
      END IF 
      LET l_ac =1 
      LET g_sql =
             "SELECT sie01,sie02,sie03,sie04,sie05,sie06,sie07,sie08,sie09,sie10,sie11,sie12,sie13,sie14,sie15,sie16,sie012,sie013",
             " FROM sie_file",
             " WHERE sie11 > 0 AND sie05 = '",p_oeb01,"' AND sie15 = '",p_oeb03,"'"
      PREPARE p400_pb2 FROM g_sql
      DECLARE sie_curs2 CURSOR FOR p400_pb2
      FOREACH sie_curs2  INTO l_sie[l_ac].*
         SELECT ima25 INTO l_ima25 FROM ima_file
           WHERE ima01 = l_sie[l_ac].sie08
         CALL s_umfchk(l_sie[l_ac].sie08,l_sie[l_ac].sie07,l_ima25)
               RETURNING l_flag,l_fac
         IF l_flag THEN
            CALL cl_err('','',0)
            LET g_success = 'N'
            RETURN
         ELSE
           LET l_sic07_fac = l_fac
         END IF
         SELECT max(sic02)+1 INTO l_sic02 FROM sic_file
           WHERE sic01 = l_sia.sia01
         IF cl_NULL(l_sic02) THEN
            LET l_sic02 =1
         END IF
         INSERT INTO sic_file(sic01,sic02,sic03,sic04,sic05,
                    sic06,sic07,sic08,sic09,
                     sic10,sic11,sic012,sic013,sic15,sic12,siclegal,sicplant,sic07_fac) 
             VALUES (l_sia.sia01,l_sic02,l_sie[l_ac].sie05,l_sie[l_ac].sie08,l_sie[l_ac].sie08,
                     l_sie[l_ac].sie11,l_sie[l_ac].sie07,l_sie[l_ac].sie02,l_sie[l_ac].sie03,
                     l_sie[l_ac].sie04,l_sie[l_ac].sie06,l_sie[l_ac].sie012,l_sie[l_ac].sie013,
                     l_sie[l_ac].sie15,'',g_legal,g_plant,l_sic07_fac)  
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("ins","sic_file",l_sia.sia01,l_sie[l_ac].sie15,l_err,"","ins sic:",1)  #No.FUN-660128
         LET g_success='N'
         RETURN
      END IF 
      LET l_ac= l_ac+1
     END  FOREACH 
     CALL i610sub_y_chk(l_sia.sia01)
     IF g_success = "Y" THEN
        CALL i610sub_y_upd(l_sia.sia01,'',TRUE)  RETURNING l_sia.*
     END IF 
END FUNCTION 
#FUN-AC0074 --add--end
 
FUNCTION p410_z()
   DEFINE l_oeb   RECORD LIKE oeb_file.*
   DEFINE l_seq   LIKE type_file.num5          #No.FUN-680137 SMALLINT 
   DEFINE i       LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_cnt   LIKE type_file.num5          #CHI-A60025 add
#  DEFINE l_oia07 LIKE oia_file.oia07          #FUN-C50136
 
   IF cl_null(g_oea.oea01) THEN
      CALL cl_err('',-400,0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF #MOD-4A0247
 
   SELECT oea00 INTO g_oea00 FROM oea_file WHERE oea01 = g_oea.oea01   #CHI-910040
 
   CALL cl_getmsg('axm-201',g_lang) RETURNING g_msg
 # OPEN WINDOW p410_z_w AT 10,20 WITH 1 ROWS, 40 COLUMNS
            LET INT_FLAG = 0  ######add for prompt bug
   PROMPT g_msg CLIPPED FOR l_seq
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
#         CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END PROMPT
  #CLOSE WINDOW p410_z_w
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET g_success='N' #MOD-550166
      RETURN
   END IF
 
   SELECT * INTO l_oeb.* FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb03 = l_seq
   IF STATUS THEN
#     CALL cl_err('sel oeb:',STATUS,0)   #No.FUN-660167
      CALL cl_err3("sel","oeb_file",g_oea.oea01,l_seq,STATUS,"","sel oeb",0)   #No.FUN-660167
      LET g_success='N' #MOD-550166
      RETURN
   END IF
 
   IF l_oeb.oeb70='N' THEN
      CALL cl_err('sel oeb:','axm-203',0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF
 
   LET l_oeb.oeb70 = 'N'
   LET l_oeb.oeb70d = NULL
   LET l_oeb.oeb26 = 0
   IF g_oea00 = '8' THEN                      #CHI-910040    
      LET l_oeb.oeb26 = l_oeb.oeb25           #CHI-910040
   END IF                                     #CHI-910040 
   IF l_oeb.oeb19 = 'Y' THEN
      CALL cl_err('','axm-809',1)
   END IF  #no.7182
 
   UPDATE oeb_file SET * = l_oeb.*
    WHERE oeb01 = g_oea.oea01
      AND oeb03 = l_seq
  #No.+042 010330 by plum
  #IF STATUS THEN CALL cl_err('upd oeb70:',STATUS,0) RETURN END IF
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('upd oeb70:',SQLCA.SQLCODE,0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF
  #No.+042 ..end
 
   #-->產生MPS異動log
   IF g_oaz.oaz06 = 'Y' THEN
      CALL s_mpslog('Z',l_oeb.oeb04,l_oeb.oeb26,l_oeb.oeb15,
                    '','','',g_oea.oea01,l_seq,l_seq)
      IF g_success = 'N' THEN RETURN END IF   #CHI-B80016 add
   END IF
 
   SELECT SUM(oeb14/oeb12*oeb26) INTO l_oeb.oeb14 FROM oeb_file
    WHERE oeb01=g_oea.oea01
 
   IF cl_null(l_oeb.oeb14) THEN
      LET l_oeb.oeb14 = 0
   END IF
 
   UPDATE oea_file SET oea63 = l_oeb.oeb14
    WHERE oea01=g_oea.oea01
  #No.+042 010330 by plum
  #IF STATUS THEN CALL cl_err('upd oea63:',STATUS,0) RETURN END IF
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('upd oea63:',SQLCA.SQLCODE,0)
      LET g_success='N' #MOD-550166
      RETURN
   END IF
  #No.+042 ..end
 
   FOR i = 1 TO g_oeb.getLength()
      IF g_oeb[i].oeb03=l_seq THEN
         LET g_oeb[i].oeb70='N'
      END IF
   END FOR

   #CHI-A60025 add --start--
   SELECT COUNT(*) INTO l_cnt FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb70 = 'N'
   IF l_cnt > 0  THEN
      UPDATE oea_file SET oea49 = '1'
       WHERE oea01=g_oea.oea01
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err('upd oea49:',SQLCA.SQLCODE,0)
         LET g_success='N'
         RETURN
      END IF
   END IF
   #CHI-A60025 add --end--
#FUN-C50136-mark--str
#  #FUN-C50136---add---str---
#  IF g_oaz.oaz96 = 'Y' THEN
#     CALL s_ccc_oia07('H',g_oea.oea03) RETURNING l_oia07
#     IF NOT cl_null(l_oia07) AND l_oia07 = '3' THEN
#        CALL s_ccc_rback(g_oea.oea03,'H',g_oea.oea01,l_seq,'')
#     END IF
#  END IF
#  #FUN-C50136---add---end---
#FUN-C50136-mark--end 
END FUNCTION
 
FUNCTION p456()
DEFINE tm       RECORD        #where condition
                  #wc  LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(300)
                   wc  STRING   #TQC-C20187 mod
                END RECORD
 
   OPEN WINDOW p456_w WITH FORM "axm/42f/axmp456"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmp456")
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0094
 
 
   CALL cl_opmsg('z')
   BEGIN WORK
 
   CALL p456_cs()
 
   #No.FUN-710046  --Begin
   CALL s_showmsg()
   #No.FUN-710046  --End  
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
 
   CALL cl_end(18,20)  # 顯示 "作業結束,請按任何鍵繼續:"
 
   CLOSE WINDOW p456_w
  #CALL  cl_used(g_prog,g_time,2) #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0094
  #   RETURNING l_time #MOD-580222 mark
 
END FUNCTION
 
FUNCTION p456_cs()
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0094
 
   INITIALIZE tm.*  TO NULL
 
   #INITIALIZE g_oea.* TO NULL    #No.FUN-750051   #MOD-A80091
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,oea14,oea15
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END CONSTRUCT
 
   #MOD-4A0247
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   #No.MOD-960238  --Begin
   ##NO.FUN-850052 start------------
   #LET g_flag = 'N'   
   #INPUT BY NAME g_flag WITHOUT DEFAULTS 
 
   #   ON IDLE g_idle_seconds
   #      CALL cl_on_idle()
   #      CONTINUE INPUT
 
   #   ON ACTION exit                            #加離開功能
   #      LET INT_FLAG = 1
   #      EXIT INPUT    
   #
   #END INPUT
   #IF INT_FLAG THEN
   #   LET INT_FLAG = 0
   #   RETURN
   #END IF
   ##NO.FUN-850052 end-------------
   #No.MOD-960238  --End  
  #MOD-640481-begin
   IF tm.wc=' 1=1' THEN
      CALL cl_err('',-400,0)
      LET g_success='N'
      RETURN
   END IF 
  #MOD-640481-end 
 
   #-----No.FUN-5B0133-----
   #資料權限的檢查
   LET g_wc="1=1"
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN     #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN     #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   #-----No.FUN-5B0133 END-----
 
   IF NOT cl_sure(16,18) THEN
      LET g_success = 'N'
      RETURN
   ELSE
      CALL p456_y()
   END IF
   #MOD-4A0247(end)
 
END FUNCTION
 
FUNCTION p456_y()
   DEFINE l_oeb RECORD LIKE oeb_file.*
   DEFINE l_seq LIKE type_file.num5          #No.FUN-680137 SMALLINT
  #DEFINE l_sql LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
   DEFINE l_sql STRING  #TQC-C20187 mod
   DEFINE g_oea01 LIKE oea_file.oea01
   DEFINE g_oea02 LIKE oea_file.oea02
   DEFINE g_oea14 LIKE oea_file.oea14
   DEFINE g_oeb03 LIKE oeb_file.oeb03   #單身項次
   DEFINE g_oeb01 LIKE oeb_file.oeb01
   DEFINE l_cnt   LIKE type_file.num5          #CHI-A60025 add
#  DEFINE l_oia07 LIKE oia_file.oia07     #FUN-C50136
#  DEFINE l_oea03 LIKE oea_file.oea03     #FUN-C50136 
   DEFINE g_oea905 LIKE oea_file.oea905   #FUN-D30086 add
 
  # LET l_sql ="SELECT oea01,oea02,oea14,oeb03,oeb01 " ,
  #            "  FROM oea_file,oeb_file ",
  #            " WHERE oea01=oeb01",
  #            " AND ",tm.wc CLIPPED
  # LET l_sql = l_sql CLIPPED
  # PREPARE p456_p2 FROM l_sql
  # IF SQLCA.SQLCODE THEN
  #    CALL cl_err('prepare p456_p2 error :',SQLCA.SQLCODE,1)
  #  END IF
  # DECLARE p456_c2 CURSOR FOR p456_p2
  # IF SQLCA.SQLCODE THEN
  #    CALL cl_err('declare p456_c1 error :',SQLCA.SQLCODE,1)
  # END IF
 
 # FOREACH p456_c2 INTO g_oea01,g_oea02,g_oea14
 
  #LET l_sql ="SELECT oeb_file.*,oea01  ",         #FUN-D30086 mark
   LET l_sql ="SELECT oeb_file.*,oea01,oea905  ",  #FUN-D30086
              "  FROM oeb_file,oea_file ",
              " WHERE oeb01=oea01 " ,
              "   AND ",tm.wc CLIPPED,
             #"   AND oea901 != 'Y' ",	#MOD-9C0440 #MOD-B50246 mark
             #"   AND oea905 != 'Y' ",	#MOD-B50246 add  #FUN-D30086 mark 
              "   AND oeaconf != 'X' ", #MOD-9C0440
              "   AND ",g_wc CLIPPED    #No.FUN-5B0133
   PREPARE p456_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p456_p1 error :',SQLCA.SQLCODE,1)
   END IF
 
   DECLARE p456_c1 CURSOR FOR p456_p1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('declare p456_c1 error :',SQLCA.SQLCODE,1)
   END IF
 
   LET g_success = 'Y'
 
   CALL s_showmsg_init()   #No.FUN-710046
   FOREACH p456_c1 INTO l_oeb.*,g_oea01,g_oea905  #FUN-D30086 add g_oea905
      #No.FUN-710046  --Begin
      IF g_success = "N" THEN
         LET g_totsuccess = "N"
         LET g_success = "Y"
      END IF
      #No.FUN-710046  --End
      #--NO.FUN-850052 start----
      IF g_flag = 'Y' THEN
          IF l_oeb.oeb24 < l_oeb.oeb12 THEN
              CONTINUE FOREACH
          END IF
      END IF
      #--NO.FUN-850052 end---
      IF l_oeb.oeb70='Y' THEN
         #No.FUN-710046  --Begin
         #CALL cl_err('sel oeb:','axm-202',0)
        #CALL s_errmsg("oeb70","Y","sel oeb:","axm-202",0)  #FUN-D30086 mark
         CALL s_errmsg("oeb70","Y","sel oeb:","axm-202",1)  #FUN-D30086
         #No.FUN-710046  --End   
         CONTINUE FOREACH
      #    EXIT FOREACH
      END IF
 
     #FUN-D30086---add---S
      IF g_oea905 = 'Y' THEN
         CALL s_errmsg("oea01",g_oea01,"",'axm0004',1)
         CONTINUE FOREACH
      END IF
     #FUN-D30086---add---E
 
      LET l_oeb.oeb70='Y'
      LET l_oeb.oeb70d=g_today
      LET l_oeb.oeb26=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25
      IF l_oeb.oeb19 = 'Y' THEN
         LET l_oeb.oeb905 = 0
      END IF  #no.7182
 
      ####### 98-06-03更新訂單單身檔
     #UPDATE oeb_file SET * = l_oeb.* WHERE oeb01=g_oea01 AND oeb03=l_oeb.oeb03   #No.MOD-960238
      UPDATE oeb_file SET * = l_oeb.* WHERE oeb01=l_oeb.oeb01 AND oeb03=l_oeb.oeb03   #No.MOD-960238
     #No.+042 010330 by plum
#      #IF STATUS THEN CALL cl_err('upd oeb70:',STATUS,0) LET g_success = 'N'   #No.FUN-660167
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('upd oeb70:',SQLCA.SQLCODE,0)   #No.FUN-660167
         #No.FUN-710046  --Begin
         #CALL cl_err3("upd","oeb_file",g_oea01,l_oeb.oeb03,SQLCA.SQLCODE,"","upd oeb70",0)   #No.FUN-660167
         LET g_success='N'
         #RETURN
         LET g_showmsg=g_oea01,"/",l_oeb.oeb03
         CALL s_errmsg("oeb01,oeb03",g_showmsg,"upd oeb70:",SQLCA.sqlcode,1)
         CONTINUE FOREACH
         #No.FUN-710046  --End  
      END IF
     #No.+042 ..end
      ####
      #-->產生MPS異動log
      IF g_oaz.oaz06 = 'Y' THEN
         CALL s_mpslog('C',l_oeb.oeb04,l_oeb.oeb26,l_oeb.oeb15,
                       '','','',
                       #g_oea.oea01,l_oeb.oeb03,l_oeb.oeb03)   #MOD-A80091
                       g_oea01,l_oeb.oeb03,l_oeb.oeb03)   #MOD-A80091
         IF g_success = 'N' THEN CONTINUE FOREACH END IF  #CHI-B80016 add
      END IF
 
      #-->重計未稅金額
      SELECT SUM(oeb14/oeb12*oeb26) INTO l_oeb.oeb14 FROM oeb_file
       WHERE oeb01=g_oea01
      IF cl_null(l_oeb.oeb14) THEN LET l_oeb.oeb14=0 END IF
 
      #### 98-06-03更新訂單單頭檔
      UPDATE oea_file SET oea63 = l_oeb.oeb14 WHERE oea01=g_oea01
     #No.+042 010330 by plum
     #IF STATUS THEN CALL cl_err('upd oea63:',STATUS,0) RETURN END IF
      IF STATUS OR SQLCA.SQLCODE THEN
         #No.FUN-710046  --Begin
         #CALL cl_err('upd oea63:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
         #RETURN
         CALL s_errmsg("oea01",g_oea01,"upd oea63",SQLCA.sqlcode,1)
         CONTINUE FOREACH
         #No.FUN-710046  --End   
      END IF
     #No.+042 ..end
 
      #CHI-A60025 add --start--
      SELECT COUNT(*) INTO l_cnt FROM oeb_file
       WHERE oeb01 = g_oea01
         AND oeb70 = 'N'
      IF l_cnt = 0  THEN
         UPDATE oea_file SET oea49 = '2'
          WHERE oea01=g_oea01
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg("oea01",g_oea01,"upd oea49",SQLCA.sqlcode,1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      #CHI-A60025 add --end--
#FUN-C50136-mark--str
#     #FUN-C50136---add---str
#     IF g_oaz.oaz96 = 'Y' THEN
#        SELECT oea03 INTO l_oea03 FROM oea_file WHERE oea01 = g_oea01
#        CALL s_ccc_oia07('H',l_oea03) RETURNING l_oia07
#        IF NOT cl_null(l_oia07) AND l_oia07 = '3' THEN
#           CALL s_ccc_oia(l_oea03,'H',g_oea01,l_oeb.oeb03,'')
#        END IF
#     END IF
#     #FUN-C50136---add---end---
#FUN-C50136-mark--end

      CALL s_errmsg("oea01",g_oea01,"",'lib-022',1)  #FUN-D30086 add

   END FOREACH

  #-MOD-9C0440-add-
   IF cl_null(g_oea01) THEN
      LET g_success = 'N'                                                                                                           
   END IF
  #-MOD-9C0440-end-
   #No.FUN-710046  --Begin
   IF g_totsuccess = 'N' THEN                                                                                                       
      LET g_success = 'N'                                                                                                           
   END IF                                                                                                                           
   #No.FUN-710046  --End                                                                                                            
                                                                                                                                    
END FUNCTION 
