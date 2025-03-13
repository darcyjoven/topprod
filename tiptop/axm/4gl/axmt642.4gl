# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmt642
# Descriptions...: 佣金維護作業
# Date & Author..: 06/04/04 By Sarah
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.TQC-690034 06/09/19 By Sarah 1.代理商/代送商查詢開窗會跳出錯誤訊息
#                                                  2.筆數計算錯誤
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie FUNCTION _q() 一開始應清空key值`
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BB0030 11/11/09 By destiny  新增查询开窗
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_oft17          LIKE oft_file.oft17,   #佣金對象   (假單頭)
    g_oft03          LIKE oft_file.oft03,   #對象編號   (假單頭)
    g_oft_desc       LIKE pmc_file.pmc03,   #對象簡稱   (假單頭)
    g_oft18          LIKE oft_file.oft18,   #佣金年度   (假單頭)
    g_oft19          LIKE oft_file.oft19,   #佣金月份   (假單頭)
    g_oft04          LIKE oft_file.oft04,   #業務員     (假單頭)
    g_gen02          LIKE gen_file.gen02,   #業務員姓名 (假單頭)
    g_oft21          LIKE oft_file.oft21,   #應付單號   (假單頭)
    g_oft            DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oft05        LIKE oft_file.oft05,   #客戶編號
        occ02        LIKE occ_file.occ02,   #客戶簡稱
        oft02        LIKE oft_file.oft02,   #出貨日期
        oft01        LIKE oft_file.oft01,   #出貨單號
        oft06        LIKE oft_file.oft06,   #項次
        oft07        LIKE oft_file.oft07,   #料號
        oft08        LIKE oft_file.oft08,   #出貨數量
        oft09        LIKE oft_file.oft09,   #出貨金額
        oft10        LIKE oft_file.oft10,   #標準售價
        oft11        LIKE oft_file.oft11,   #成本
        oft12        LIKE oft_file.oft12,   #利潤
        oft13        LIKE oft_file.oft13,   #佣金編號
        oft14        LIKE oft_file.oft14,   #幣別
        oft15        LIKE oft_file.oft15,   #匯率
        oft16        LIKE oft_file.oft16    #應付佣金
                     END RECORD,
    g_oft_t          RECORD                 #程式變數 (舊值)
        oft05        LIKE oft_file.oft05,   #客戶編號
        occ02        LIKE occ_file.occ02,   #客戶簡稱
        oft02        LIKE oft_file.oft02,   #出貨日期
        oft01        LIKE oft_file.oft01,   #出貨單號
        oft06        LIKE oft_file.oft06,   #項次
        oft07        LIKE oft_file.oft07,   #料號
        oft08        LIKE oft_file.oft08,   #出貨數量
        oft09        LIKE oft_file.oft09,   #出貨金額
        oft10        LIKE oft_file.oft10,   #標準售價
        oft11        LIKE oft_file.oft11,   #成本
        oft12        LIKE oft_file.oft12,   #利潤
        oft13        LIKE oft_file.oft13,   #佣金編號
        oft14        LIKE oft_file.oft14,   #幣別
        oft15        LIKE oft_file.oft15,   #匯率
        oft16        LIKE oft_file.oft16    #應付佣金
                     END RECORD,
    g_wc,g_sql       STRING,
    g_delete         LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)    #若刪除資料,則要重新顯示筆數
    g_rec_b          LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    g_ss             LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
    g_succ           LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
    g_comp           LIKE oft_file.oft01,
    g_item           LIKE oft_file.oft02,
    l_ac             LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n              LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql  STRING  #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp     STRING  #No.TQC-720019
DEFINE g_before_input_done   LIKE type_file.num5    #NO.MOD-580056        #No.FUN-680137 SMALLINT
DEFINE g_cnt         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_msg         LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE g_curs_index  LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_row_count   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_jump        LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#主程式開始
MAIN
#     DEFINE   l_time LIKE type_file.chr8          #No.FUN-6A0094
   DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
   LET g_oft17 = NULL                     #清除鍵值
   LET g_oft03 = NULL                     #清除鍵值
   LET g_oft18 = NULL                     #清除鍵值
   LET g_oft19 = NULL                     #清除鍵值
   LET g_oft04 = NULL                     #清除鍵值
   LET g_oft21 = NULL                     #清除鍵值
 
   LET p_row = 5 LET p_col = 15
   OPEN WINDOW t642_w AT p_row,p_col WITH FORM "axm/42f/axmt642"    #顯示畫面
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_delete='N'
 
   CALL t642_menu()
 
   CLOSE WINDOW t642_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION t642_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_oft.clear()
 
   IF INT_FLAG THEN RETURN END IF
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_oft17 TO NULL    #No.FUN-750051
   INITIALIZE g_oft03 TO NULL    #No.FUN-750051
   INITIALIZE g_oft18 TO NULL    #No.FUN-750051
   INITIALIZE g_oft19 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON oft17,oft03,oft18,oft19,oft04,oft21,
                     oft05,oft02,oft01,oft06,oft07,oft08,oft09,
                     oft10,oft11,oft12,oft13,oft14,oft15,oft16
                FROM oft17,oft03,oft18,oft19,oft04,oft21,
                     s_oft[1].oft05,s_oft[1].oft02,s_oft[1].oft01,s_oft[1].oft06,
                     s_oft[1].oft07,s_oft[1].oft08,s_oft[1].oft09,s_oft[1].oft10,
                     s_oft[1].oft11,s_oft[1].oft12,s_oft[1].oft13,s_oft[1].oft14,
                     s_oft[1].oft15,s_oft[1].oft16
                     
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oft03)   #對象編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
              #start TQC-690034 modify
              #IF g_oft17 = "1" THEN   #代理商
              #   LET g_qryparam.form = "q_pmc4"
              #   LET g_qryparam.arg1 = '4'
              #ELSE 
              #   IF g_oft17 = "2" THEN   #代送商
              #      LET g_qryparam.form = "q_pmc8"
              #   END IF
              #END IF
               CALL GET_FLDBUF(oft17) RETURNING g_oft17
               CASE WHEN g_oft17 = '1'   #代理商
                         LET g_qryparam.form = 'q_pmc4'
                         LET g_qryparam.arg1 = '4'
                    WHEN g_oft17 = '2'   #代送商
                         LET g_qryparam.form = 'q_pmc8'
                    OTHERWISE
                         LET g_qryparam.form = 'q_pmc4'
                         LET g_qryparam.arg1 = '4'
               END CASE
              #end TQC-690034 modify
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oft03
               NEXT FIELD oft03
            WHEN INFIELD(oft04)   #業務員
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oft04
               NEXT FIELD oft04 
            #TQC-BB0030--begin
            WHEN INFIELD(oft05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oft05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oft05
               NEXT FIELD oft05
            WHEN INFIELD(oft01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oft01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oft01
               NEXT FIELD oft01
            WHEN INFIELD(oft07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oft07"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oft07
               NEXT FIELD oft07
            WHEN INFIELD(oft14)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oft14"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oft14
               NEXT FIELD oft14
            #TQC-BB0030--end
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
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql="SELECT UNIQUE oft17,oft03,oft18,oft19,oft04,oft21 ",
             "  FROM oft_file ",
             " WHERE ", g_wc CLIPPED,
             " ORDER BY oft17,oft03,oft18,oft19,oft04"
   PREPARE t642_prepare FROM g_sql   #預備一下
   DECLARE t642_cs                   #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t642_prepare
 
  #start TQC-690034 modify
#  LET g_sql="SELECT UNIQUE oft17,oft03,oft18,oft19,oft04,oft21 ",      #No.TQC-720019
   LET g_sql_tmp="SELECT UNIQUE oft17,oft03,oft18,oft19,oft04,oft21 ",  #No.TQC-720019
             "  FROM oft_file ",
             " WHERE ", g_wc CLIPPED,
             "  INTO TEMP x "
   DROP TABLE x
#  PREPARE t642_precount_x FROM g_sql      #No.TQC-720019
   PREPARE t642_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE t642_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
  #LET g_sql="SELECT COUNT(DISTINCT oft03) FROM oft_file ",
  #          " WHERE ", g_wc CLIPPED
  #end TQC-690034 modify
   PREPARE t642_precount FROM g_sql
   DECLARE t642_count CURSOR FOR t642_precount
 
END FUNCTION
 
FUNCTION t642_menu()
 
   WHILE TRUE
      CALL t642_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t642_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t642_r()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t642_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oft),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t642_q()
   DEFINE l_oft01  LIKE oft_file.oft01,
          l_oft02  LIKE oft_file.oft02,
          l_cnt    LIKE type_file.num10       # No.FUN-680137 INTEGER
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   #No.FUN-6A0020------add------
   INITIALIZE g_oft17 TO NULL             
   INITIALIZE g_oft03 TO NULL
   INITIALIZE g_oft18 TO NULL
   INITIALIZE g_oft19 TO NULL
   INITIALIZE g_oft04 TO NULL
   INITIALIZE g_oft21 TO NULL
   #No.FUN-6A0020-------add-----
   CALL cl_opmsg('q')
   CALL t642_cs()                         #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_oft17 TO NULL
      INITIALIZE g_oft03 TO NULL
      INITIALIZE g_oft18 TO NULL
      INITIALIZE g_oft19 TO NULL
      INITIALIZE g_oft04 TO NULL
      INITIALIZE g_oft21 TO NULL
      RETURN
   END IF
 
   OPEN t642_count
   FETCH t642_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN t642_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_oft17 TO NULL
      INITIALIZE g_oft03 TO NULL
      INITIALIZE g_oft18 TO NULL
      INITIALIZE g_oft19 TO NULL
      INITIALIZE g_oft04 TO NULL
      INITIALIZE g_oft21 TO NULL
   ELSE
      CALL t642_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t642_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680137 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t642_cs INTO g_oft17,g_oft03,g_oft18,g_oft19,
                                           g_oft04,g_oft21
      WHEN 'P' FETCH PREVIOUS t642_cs INTO g_oft17,g_oft03,g_oft18,g_oft19,
                                           g_oft04,g_oft21
      WHEN 'F' FETCH FIRST    t642_cs INTO g_oft17,g_oft03,g_oft18,g_oft19,
                                           g_oft04,g_oft21
      WHEN 'L' FETCH LAST     t642_cs INTO g_oft17,g_oft03,g_oft18,g_oft19,
                                           g_oft04,g_oft21
      WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0      ######add for prompt bug
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
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t642_cs INTO g_oft17,g_oft03,g_oft18,g_oft19,
                                               g_oft04,g_oft21
            LET mi_no_ask = FALSE
   END CASE
 
   LET g_succ='Y'
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_oft03,SQLCA.sqlcode,0)
      INITIALIZE g_oft03 TO NULL  #TQC-6B0105
      INITIALIZE g_oft04 TO NULL  #TQC-6B0105
      INITIALIZE g_oft17 TO NULL  #TQC-6B0105
      INITIALIZE g_oft18 TO NULL  #TQC-6B0105
      INITIALIZE g_oft19 TO NULL  #TQC-6B0105
      INITIALIZE g_oft21 TO NULL  #TQC-6B0105
      LET g_succ='N'
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL t642_show()
   END IF
 
END FUNCTION
 
FUNCTION t642_show()
 
   #對象簡稱
   SELECT pmc03 INTO g_oft_desc FROM pmc_file 
    WHERE pmc01=g_oft03 AND pmc14 = '4'
   #業務員姓名
   SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_oft04
 
   DISPLAY g_oft17,g_oft03,g_oft_desc,g_oft18,g_oft19,g_oft04,g_gen02,g_oft21
        TO oft17,oft03,FORMONLY.oft_desc,oft18,oft19,oft04,FORMONLY.gen02,oft21
 
   CALL t642_b_fill()                     #單身
   CALL cl_show_fld_cont()                #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t642_r()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
  #NO.FUN-6A0020-------str------
  #IF g_oft17 IS NULL AND g_oft03 IS NULL AND g_oft18 IS NULL AND 
  #   g_oft19 IS NULL AND g_oft04 IS NULL THEN 
   IF g_oft17 IS NULL OR  g_oft03 IS NULL OR  g_oft18 IS NULL OR 
      g_oft19 IS NULL OR  g_oft04 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0020 
  #No.FUN-6A0020-------end-------
      RETURN
   END IF
   IF NOT cl_null(g_oft21) THEN 
      CALL cl_err('','anm-651',1) RETURN
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
      LET g_sql = " DELETE FROM oft_file WHERE 1=1"
      IF NOT cl_null(g_oft17) THEN LET g_sql = g_sql," AND oft17='",g_oft17,"'" END IF
      IF NOT cl_null(g_oft03) THEN LET g_sql = g_sql," AND oft03='",g_oft03,"'" END IF
      IF NOT cl_null(g_oft18) THEN LET g_sql = g_sql," AND oft18='",g_oft18,"'" END IF
      IF NOT cl_null(g_oft19) THEN LET g_sql = g_sql," AND oft19='",g_oft19,"'" END IF
      IF NOT cl_null(g_oft04) THEN LET g_sql = g_sql," AND oft04='",g_oft04,"'" END IF
      PREPARE t640_p1 FROM g_sql
      EXECUTE t640_p1
      IF SQLCA.sqlcode THEN
         CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
      ELSE
         CLEAR FORM
         CALL g_oft.clear()
         LET g_delete='Y'
         LET g_oft17 = NULL
         LET g_oft03 = NULL
         LET g_oft18 = NULL
         LET g_oft19 = NULL
         LET g_oft04 = NULL
         LET g_oft21 = NULL
         DROP TABLE x                     #No.TQC-720019
         PREPARE t640_p12 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE t640_p12                 #No.TQC-720019
         OPEN t642_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t642_cs
            CLOSE t642_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH t642_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t642_cs
            CLOSE t642_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t642_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t642_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t642_fetch('/')
         END IF
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t642_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680137 SMALLINT
          l_cnt           LIKE type_file.num10       # No.FUN-680137 INTEGER
 
   LET g_action_choice =" "
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = 
       "SELECT oft05,'',oft02,oft01,oft06,oft07,oft08,oft09,",
       "       oft10,oft11,oft12,oft13,oft14,oft15,oft16 ",
       "  FROM oft_file ",
       "   WHERE oft01= ?  AND oft02= ? AND oft03 = ? AND oft04 = ? ",
       "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t642_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_oft WITHOUT DEFAULTS FROM s_oft.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF

       #FUN-D30034-------add-----str
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_oft[l_ac].* TO NULL
          LET g_before_input_done = TRUE
          CALL cl_show_fld_cont()    
       #FUN-D30034-------add-----end
 
       BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          IF g_rec_b >= l_ac THEN
             BEGIN WORK
             LET g_oft_t.* = g_oft[l_ac].*      #BACKUP
             LET p_cmd='u'
             OPEN t642_bcl USING g_oft_t.oft01,g_oft_t.oft02,g_oft03,g_oft04
             IF STATUS THEN
                CALL cl_err("OPEN t642_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t642_bcl INTO g_oft[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_oft_t.oft01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                SELECT occ02 INTO g_oft[l_ac].occ02 FROM occ_file
                 WHERE occ01 = g_oft[l_ac].oft05
                IF STATUS THEN LET g_oft[l_ac].occ02 = "" END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
       BEFORE DELETE
          IF NOT cl_null(g_oft_t.oft01) AND NOT cl_null(g_oft_t.oft02) AND 
             NOT cl_null(g_oft03) AND NOT cl_null(g_oft04) THEN
             IF NOT cl_null(g_oft21) THEN 
                CALL cl_err('','anm-651',1)
                CANCEL DELETE
             END IF
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM oft_file WHERE oft01 = g_oft_t.oft01
                                    AND oft02 = g_oft_t.oft02
                                    AND oft03 = g_oft03
                                    AND oft04 = g_oft04
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_oft_t.oft01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("del","oft_file",g_oft_t.oft01,g_oft_t.oft02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             COMMIT WORK
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac     #FUN-D30034 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_oft[l_ac].* = g_oft_t.*
             #FUN-D30034--add--str--
             ELSE
                CALL g_oft.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end--
             END IF
             CLOSE t642_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D30034 Add
          CLOSE t642_bcl
          COMMIT WORK
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE t642_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t642_b_fill()
 
   LET g_sql = "SELECT oft05,occ02,oft02,oft01,oft06,oft07,oft08,oft09,",
               "       oft10,oft11,oft12,oft13,oft14,oft15,oft16 ",
               "  FROM oft_file,occ_file ",
               " WHERE oft05 = occ01 ",
               "   AND ",g_wc CLIPPED
   IF NOT cl_null(g_oft17) THEN LET g_sql = g_sql," AND oft17 = '",g_oft17,"' " END IF
   IF NOT cl_null(g_oft03) THEN LET g_sql = g_sql," AND oft03 = '",g_oft03,"' " END IF
   IF NOT cl_null(g_oft18) THEN LET g_sql = g_sql," AND oft18 = '",g_oft18,"' " END IF
   IF NOT cl_null(g_oft19) THEN LET g_sql = g_sql," AND oft19 = '",g_oft19,"' " END IF
   IF NOT cl_null(g_oft04) THEN LET g_sql = g_sql," AND oft04 = '",g_oft04,"' " END IF
   IF NOT cl_null(g_oft21) THEN LET g_sql = g_sql," AND oft21 = '",g_oft21,"' " END IF
   LET g_sql = g_sql," ORDER BY oft05,oft02,oft01"
   PREPARE t642_prepare2 FROM g_sql      #預備一下
   DECLARE t642_bcs CURSOR FOR t642_prepare2
 
   CALL g_oft.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH t642_bcs INTO g_oft[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_oft.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t642_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_oft TO s_oft.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION query
           LET g_action_choice="query"
           EXIT DISPLAY
 
        ON ACTION delete
           LET g_action_choice="delete"
           EXIT DISPLAY
 
        ON ACTION detail
           LET g_action_choice="detail"
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
 
        ON ACTION first
           CALL t642_fetch('F')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
        ON ACTION previous
           CALL t642_fetch('P')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
        ON ACTION jump
           CALL t642_fetch('/')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
        ON ACTION next
           CALL t642_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
        ON ACTION last
           CALL t642_fetch('L')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
 
        ON ACTION cancel
           LET g_action_choice="exit"
           LET INT_FLAG=FALSE 		#MOD-570244	mars
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
 
        ON ACTION exporttoexcel       #FUN-4B0049
           LET g_action_choice = 'exporttoexcel'
           EXIT DISPLAY
 
        # No.FUN-530067 --start--
        AFTER DISPLAY
           CONTINUE DISPLAY
        # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
