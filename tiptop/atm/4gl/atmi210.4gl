# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi210.4gl
# Descriptions...: 省台廣告費用分攤比率維護作業
# Date & Author..: 05/10/18 By yoyo
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: NO.TQC-640095 06/03/08 By yoyo 省別媒體欄位開窗沒資料，但輸入能過
# Modify.........: No.FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6B0043 06/11/24 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/18 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-860061 08/07/30 By lutingting
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_toh           RECORD LIKE toh_file.*,
    g_toh_t         RECORD LIKE toh_file.*,
    g_toh_o         RECORD LIKE toh_file.*,
    g_toh01_t       LIKE toh_file.toh01,
    g_toh02_t       LIKE toh_file.toh02,
    g_t1            LIKE oay_file.oayslip,                   #No.FUN-680120 VARCHAR(05)
    g_toi           DYNAMIC ARRAY OF RECORD
        toi03       LIKE toi_file.toi03,
        toi04       LIKE toi_file.toi04,
        gea02       LIKE top_file.top02,
        toi05       LIKE toi_file.toi05,
        toi06       LIKE toi_file.toi06,
        toi061      LIKE faa_file.faa27,          #No.FUN-680120 DECIMAL(7,4) 
        toi07       LIKE toi_file.toi07,
        toi08       LIKE toi_file.toi08,
        toi09       LIKE toi_file.toi09,
        #FUN-840068 --start---
        toiud01     LIKE toi_file.toiud01,
        toiud02     LIKE toi_file.toiud02,
        toiud03     LIKE toi_file.toiud03,
        toiud04     LIKE toi_file.toiud04,
        toiud05     LIKE toi_file.toiud05,
        toiud06     LIKE toi_file.toiud06,
        toiud07     LIKE toi_file.toiud07,
        toiud08     LIKE toi_file.toiud08,
        toiud09     LIKE toi_file.toiud09,
        toiud10     LIKE toi_file.toiud10,
        toiud11     LIKE toi_file.toiud11,
        toiud12     LIKE toi_file.toiud12,
        toiud13     LIKE toi_file.toiud13,
        toiud14     LIKE toi_file.toiud14,
        toiud15     LIKE toi_file.toiud15
        #FUN-840068 --end--
                    END RECORD,
    g_toi_t         RECORD       #程式變數(Program Variables)
        toi03       LIKE toi_file.toi03,
        toi04       LIKE toi_file.toi04,
        gea02       LIKE top_file.top02,
        toi05       LIKE toi_file.toi05,
        toi06       LIKE toi_file.toi06,
        toi061      LIKE faa_file.faa27,          #No.FUN-680120 DECIMAL(7,4) 
        toi07       LIKE toi_file.toi07,
        toi08       LIKE toi_file.toi08,
        toi09       LIKE toi_file.toi09,
        #FUN-840068 --start---
        toiud01     LIKE toi_file.toiud01,
        toiud02     LIKE toi_file.toiud02,
        toiud03     LIKE toi_file.toiud03,
        toiud04     LIKE toi_file.toiud04,
        toiud05     LIKE toi_file.toiud05,
        toiud06     LIKE toi_file.toiud06,
        toiud07     LIKE toi_file.toiud07,
        toiud08     LIKE toi_file.toiud08,
        toiud09     LIKE toi_file.toiud09,
        toiud10     LIKE toi_file.toiud10,
        toiud11     LIKE toi_file.toiud11,
        toiud12     LIKE toi_file.toiud12,
        toiud13     LIKE toi_file.toiud13,
        toiud14     LIKE toi_file.toiud14,
        toiud15     LIKE toi_file.toiud15
        #FUN-840068 --end--
                    END RECORD,
    g_toi_o         RECORD       #程式變數(Program Variables)
        toi03       LIKE toi_file.toi03,
        toi04       LIKE toi_file.toi04,
        gea02       LIKE top_file.top02,
        toi05       LIKE toi_file.toi05,
        toi06       LIKE toi_file.toi06,
        toi061      LIKE faa_file.faa27,          #No.FUN-680120 DECIMAL(7,4) 
        toi07       LIKE toi_file.toi07,
        toi08       LIKE toi_file.toi08,
        toi09       LIKE toi_file.toi09,
        #FUN-840068 --start---
        toiud01     LIKE toi_file.toiud01,
        toiud02     LIKE toi_file.toiud02,
        toiud03     LIKE toi_file.toiud03,
        toiud04     LIKE toi_file.toiud04,
        toiud05     LIKE toi_file.toiud05,
        toiud06     LIKE toi_file.toiud06,
        toiud07     LIKE toi_file.toiud07,
        toiud08     LIKE toi_file.toiud08,
        toiud09     LIKE toi_file.toiud09,
        toiud10     LIKE toi_file.toiud10,
        toiud11     LIKE toi_file.toiud11,
        toiud12     LIKE toi_file.toiud12,
        toiud13     LIKE toi_file.toiud13,
        toiud14     LIKE toi_file.toiud14,
        toiud15     LIKE toi_file.toiud15
        #FUN-840068 --end--
                    END RECORD,
    g_wc,g_wc2,g_sql  STRING,
    g_rec_b         LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_toi061        LIKE faa_file.faa27,          #No.FUN-680120 DECIMAL(7,4) 
    l_tod08         LIKE tod_file.tod08,
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
 DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
DEFINE   g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done  LIKE type_file.num5    #No.FUN-680120 SMALLINT
DEFINE   g_sql_tmp            STRING   #No.TQC-720019
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose #No.FUN-680120 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_row_count    LIKE type_file.num10               #總筆數                #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10               #查詢指定的筆數        #No.FUN-680120 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5              #是否開啟指定筆視窗     #No.FUN-680120 SMALLINT
DEFINE   l_sql          STRING                        #No.FUN-860061
DEFINE   g_str          STRING                        #No.FUN-860061
DEFINE   l_table        STRING                        #No.FUN-860061
 
#主程式開始
MAIN
#DEFINE                                          #No.FUN-6B0014
#       l_time    LIKE type_file.chr8            #No.FUN-6B0014
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   #No.FUN-860061-------start--
   LET l_sql = "toh01.toh_file.toh01,", 
               "too02.too_file.too02,", 
               "toh02.toh_file.toh02,", 
               "tof02.tof_file.tof02,", 
               "toh03.toh_file.toh03,", 
               "toi03.toi_file.toi03,", 
               "toi04.toi_file.toi04,",
               "gea02.top_file.top02,",
               "toi05.toi_file.toi05,", 
               "toi06.toi_file.toi06,", 
               "toi061.faa_file.faa27,",
               "toi07.toi_file.toi07,", 
               "toi08.toi_file.toi08,", 
               "toi09.toi_file.toi09" 
   LET l_table = cl_prt_temptable('atmi210',l_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF
   #No.FUN-860061-------end
   
    LET g_forupd_sql = "SELECT * FROM toh_file WHERE toh01 = ? AND toh02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i210_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 9
 
    OPEN WINDOW i210_w AT p_row,p_col              #顯示畫面
        WITH FORM "atm/42f/atmi210"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    CALL i210_menu()
    CLOSE WINDOW i210_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION i210_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_toi.clear() 
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_toh.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON toh01,toh02,toh03,
                             tohuser,tohgrup,tohmodu,tohdate,tohacti,
                             #FUN-840068   ---start---
                             tohud01,tohud02,tohud03,tohud04,tohud05,
                             tohud06,tohud07,tohud08,tohud09,tohud10,
                             tohud11,tohud12,tohud13,tohud14,tohud15
                             #FUN-840068    ----end----
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(toh01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
#No.TQC-640095--start
#                LET g_qryparam.form ="q_too"
                 LET g_qryparam.form ="q_too2"
#No.TQC-640095--end
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toh01
                 CALL i210_toh01('d')
                 NEXT FIELD toh01
           WHEN INFIELD(toh02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1 = '2'
                 LET g_qryparam.form ="q_tof1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toh02
                 CALL i210_toh02('d')
                 NEXT FIELD toh02
            OTHERWISE EXIT CASE
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
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND tohuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND tohgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND tohgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tohuser', 'tohgrup')
   #End:FUN-980030
 
 
 
   CONSTRUCT g_wc2 ON toi03,toi04,toi05,toi06,toi07,toi08,toi09
                      #No.FUN-840068 --start--
                      ,toiud01,toiud02,toiud03,toiud04,toiud05
                      ,toiud06,toiud07,toiud08,toiud09,toiud10
                      ,toiud11,toiud12,toiud13,toiud14,toiud15
                      #No.FUN-840068 ---end---
           FROM s_toi[1].toi03,s_toi[1].toi04,s_toi[1].toi05,
                s_toi[1].toi06,s_toi[1].toi07,s_toi[1].toi08,
                s_toi[1].toi09
                #No.FUN-840068 --start--
                ,s_toi[1].toiud01,s_toi[1].toiud02,s_toi[1].toiud03
                ,s_toi[1].toiud04,s_toi[1].toiud05,s_toi[1].toiud06
                ,s_toi[1].toiud07,s_toi[1].toiud08,s_toi[1].toiud09
                ,s_toi[1].toiud10,s_toi[1].toiud11,s_toi[1].toiud12
                ,s_toi[1].toiud13,s_toi[1].toiud14,s_toi[1].toiud15
                #No.FUN-840068 ---end---
     #No.FUN-580031 --start--     HCN
     BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
     #No.FUN-580031 --end--       HCN
 
     ON ACTION controlp
         CASE
           WHEN INFIELD(toi04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_top2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toi04
                 NEXT FIELD toi04
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
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  toh01, toh02 FROM toh_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY toh01,toh02"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT  toh01,toh02 ",
                  "  FROM toh_file, toi_file ",
                  " WHERE toh01 = toi01",
                  "   AND toh02 = toi02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY toh01,toh02"
   END IF
 
   PREPARE i210_prepare FROM g_sql
   DECLARE i210_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i210_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
#     LET g_sql="SELECT toh01,toh02 FROM toh_file WHERE ",g_wc CLIPPED,      #No.TQC-720019
      LET g_sql_tmp="SELECT toh01,toh02 FROM toh_file WHERE ",g_wc CLIPPED,  #No.TQC-720019
                    " GROUP BY toh01,toh02",
                    "  INTO TEMP z "
   ELSE
#     LET g_sql="SELECT toh01,toh02 FROM toh_file,toi_file WHERE ",      #No.TQC-720019
      LET g_sql_tmp="SELECT toh01,toh02 FROM toh_file,toi_file WHERE ",  #No.TQC-720019
                    "toh01=toi01 AND toh02=toi02 AND",g_wc CLIPPED,
                    " AND ",g_wc2 CLIPPED,
                    " GROUP BY toh01,toh02",
                    "  INTO TEMP z "
   END IF
   DROP TABLE z
 
#  PREPARE i210_precount_z FROM g_sql      #No.TQC-720019
   PREPARE i210_precount_z FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i210_precount_z
 
   LET g_sql="SELECT COUNT(*) FROM z "
 
   PREPARE i210_precount FROM g_sql
   DECLARE i210_count CURSOR FOR i210_precount
 
 
END FUNCTION
 
FUNCTION i210_menu()
 
   WHILE TRUE
      CALL i210_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i210_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i210_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i210_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i210_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i210_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i210_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i210_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i210_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
           IF cl_chk_act_auth()  THEN
              IF g_toh.toh01 IS NOT NULL THEN
                 LET g_doc.column1 = "toh01"
                 LET g_doc.value1 = g_toh.toh01
                 LET g_doc.column2 = "toh02"
                 LET g_doc.value2 = g_toh.toh02
                 CALL cl_doc()
              END IF
           END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_toi),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i210_a()
   DEFINE   li_result   LIKE type_file.num5         #No.FUN-680120 SMALLINT
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10        #No.FUN-680120 INTEGER
 
   MESSAGE ""
   CLEAR FORM
   CALL g_toi.clear()
    LET g_wc = NULL
    LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_toh.* LIKE toh_file.*             #DEFAULT 設定
   LET g_toh01_t = NULL
   LET g_toh02_t = NULL
 
 
   #預設值及將數值類變數清成零
   LET g_toh_t.* = g_toh.*
   LET g_toh_o.* = g_toh.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_toh.tohuser=g_user
      LET g_toh.tohoriu = g_user #FUN-980030
      LET g_toh.tohorig = g_grup #FUN-980030
      LET g_toh.tohgrup=g_grup
      LET g_toh.tohdate=g_today
      LET g_toh.tohacti='Y'              #資料有效
 
      CALL i210_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_toh.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_toh.toh01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      IF cl_null(g_toh.toh02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
 
      INSERT INTO toh_file VALUES (g_toh.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        
         CALL cl_err3("ins","toh_file",g_toh.toh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104        #FUN-B80061    ADD
         ROLLBACK WORK
      #  CALL cl_err(g_toh.toh01,SQLCA.sqlcode,1)  #No.FUN-660104
      #   CALL cl_err3("ins","toh_file",g_toh.toh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104       #FUN-B80061    MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_toh.toh01,'I')
      END IF
 
      SELECT toh01,toh02 INTO g_toh.toh01,g_toh.toh02 FROM toh_file
       WHERE toh01 = g_toh.toh01
      LET g_toh01_t = g_toh.toh01        #保留舊值
      LET g_toh02_t = g_toh.toh02        #保留舊值
      LET g_toh_t.* = g_toh.*
      LET g_toh_o.* = g_toh.*
      CALL g_toi.clear()
 
      LET g_rec_b = 0
      CALL i210_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i210_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_toh.toh01 IS NULL OR g_toh.toh02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_toh.* FROM toh_file
    WHERE toh01=g_toh.toh01
      AND toh02=g_toh.toh02
 
   IF g_toh.tohacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_toh.toh01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_toh01_t = g_toh.toh01
   LET g_toh02_t = g_toh.toh02
   BEGIN WORK
 
   OPEN i210_cl USING g_toh.toh01,g_toh.toh02
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_toh.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i210_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i210_show()
 
   WHILE TRUE
      LET g_toh01_t = g_toh.toh01
      LET g_toh02_t = g_toh.toh02
      LET g_toh_o.* = g_toh.*
      LET g_toh.tohmodu=g_user
      LET g_toh.tohdate=g_today
 
      CALL i210_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_toh.*=g_toh_t.*
         CALL i210_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_toh.toh01 != g_toh01_t OR g_toh.toh02 != g_toh02_t THEN
         UPDATE toi_file SET toi01 = g_toh.toh01,toi02 = g_toh.toh02
          WHERE toi01 = g_toh01_t AND toi02 = g_toh02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #  CALL cl_err('toi',SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","toi_file",g_toh01_t,g_toh02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660104 
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE toh_file SET toh_file.* = g_toh.*
       WHERE toh01 = g_toh01_t AND toh02 = g_toh02_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #  CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","toh_file",g_toh.toh01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i210_cl
   COMMIT WORK
   CALL cl_flow_notify(g_toh.toh01,'U')
 
END FUNCTION
 
FUNCTION i210_i(p_cmd)
DEFINE
   l_n            LIKE type_file.num5,          #No.FUN-680120 SMALLINT
   p_cmd           LIKE type_file.chr1          #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
   DEFINE   li_result   LIKE type_file.num5     #No.FUN-680120 SMALLINT
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_toh.tohuser,g_toh.tohmodu,
       g_toh.tohgrup,g_toh.tohdate,g_toh.tohacti
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME g_toh.toh01,g_toh.toh02,g_toh.toh03, g_toh.tohoriu,g_toh.tohorig,
                 #FUN-840068     ---start---
                 g_toh.tohud01,g_toh.tohud02,g_toh.tohud03,g_toh.tohud04,
                 g_toh.tohud05,g_toh.tohud06,g_toh.tohud07,g_toh.tohud08,
                 g_toh.tohud09,g_toh.tohud10,g_toh.tohud11,g_toh.tohud12,
                 g_toh.tohud13,g_toh.tohud14,g_toh.tohud15 
                 #FUN-840068     ----end----
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i210_set_entry(p_cmd)
         CALL i210_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD toh01
         IF NOT cl_null(g_toh.toh01)  THEN
            IF g_toh_o.toh01 IS NULL OR
               (g_toh.toh01 != g_toh_o.toh01) THEN
                 SELECT count(*) INTO l_n FROM too_file
                  WHERE too01=g_toh.toh01
                    AND tooacti='Y'
                 IF l_n <= 0 THEN
                    CALL cl_err(g_toh.toh01,'atm-111',0)
                    NEXT FIELD toh01
                 END IF
            END IF
            CALL i210_toh01(p_cmd)
         END IF
 
      AFTER FIELD toh02
         IF NOT cl_null(g_toh.toh02) THEN
            IF g_toh_o.toh02 IS NULL OR
               (g_toh.toh02 != g_toh_o.toh02 ) THEN
                 SELECT count(*) INTO l_n FROM tof_file
                  WHERE tof06=g_toh.toh01
                    AND tof01=g_toh.toh02
                    AND tof21='2'
                    AND tofacti='Y'
                 IF l_n <= 0 THEN
                    CALL cl_err(g_toh.toh02,'atm-110',0)
                    NEXT FIELD toh02
                 END IF
            END IF
            CALL i210_toh02(p_cmd)
            SELECT count(*) INTO l_n FROM toh_file
             WHERE toh01 = g_toh.toh01
               AND toh02 = g_toh.toh02
            IF l_n > 0 THEN   #重復
                CALL cl_err(g_toh.toh01,-239,0)
                LET g_toh.toh01 = g_toh01_t
                DISPLAY BY NAME g_toh.toh01
                NEXT FIELD toh01
                END IF
         END IF
 
        #FUN-840068     ---start---
        AFTER FIELD tohud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tohud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(toh01)
              CALL cl_init_qry_var()
#No.TQC-640095--start
#             LET g_qryparam.form = "q_too"
              LET g_qryparam.form = "q_too2"
#No.TQC-640095--end
              LET g_qryparam.default1 = g_toh.toh01
              CALL cl_create_qry() RETURNING g_toh.toh01
              DISPLAY BY NAME g_toh.toh01
              CALL i210_toh01('d')
              NEXT FIELD toh01
            WHEN INFIELD(toh02)
               CALL cl_init_qry_var()
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.arg2 = g_toh.toh01
               LET g_qryparam.form = "q_tof1"
               LET g_qryparam.default1 = g_toh.toh02
               CALL cl_create_qry() RETURNING g_toh.toh02
               DISPLAY BY NAME g_toh.toh02
               CALL i210_toh02('d')
               NEXT FIELD toh02
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
 
END FUNCTION
 
FUNCTION i210_toh01(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_too02   LIKE too_file.too02,
          l_tof02   LIKE tof_file.tof02
 
   LET g_errno = ' '
   IF g_toh.toh01 IS NULL THEN
      LET g_errno = 'E'
   ELSE
      SELECT too02
        INTO l_too02
        FROM too_file WHERE too01 = g_toh.toh01
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_too02 = NULL
      END IF
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_too02 TO FORMONLY.too02
   END IF
 
END FUNCTION
 
FUNCTION i210_toh02(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_tof02   LIKE tof_file.tof02
 
   LET g_errno = ' '
   IF g_toh.toh02 IS NULL THEN
      LET g_errno = 'E'
   ELSE
      SELECT tof02
        INTO l_tof02
        FROM tof_file WHERE tof01 = g_toh.toh02
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_tof02 = NULL
      END IF
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_tof02 TO FORMONLY.tof02
   END IF
 
END FUNCTION
 
 
FUNCTION i210_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_toh.* TO NULL              #No.FUN-6B0043 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_toi.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i210_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_toh.* TO NULL
      RETURN
   END IF
 
   OPEN i210_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_toh.* TO NULL
   ELSE
      OPEN i210_count
      FETCH i210_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i210_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i210_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i210_cs INTO g_toh.toh01,g_toh.toh02
      WHEN 'P' FETCH PREVIOUS i210_cs INTO g_toh.toh01,g_toh.toh02
      WHEN 'F' FETCH FIRST    i210_cs INTO g_toh.toh01,g_toh.toh02
      WHEN 'L' FETCH LAST     i210_cs INTO g_toh.toh01,g_toh.toh02
      WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i210_cs INTO g_toh.toh01,
                                               g_toh.toh02
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)
      INITIALIZE g_toh.* TO NULL  #TQC-6B0105
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_toh.* FROM toh_file WHERE toh01 = g_toh.toh01 AND toh02 = g_toh.toh02
   IF SQLCA.sqlcode THEN
   #  CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)  #No.FUN-660104
      CALL cl_err3("sel","toh_file",g_toh.toh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
      INITIALIZE g_toh.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_toh.tohuser
   LET g_data_group = g_toh.tohgrup
 
   CALL i210_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i210_show()
   LET g_toh_t.* = g_toh.*                #保存單頭舊值
   LET g_toh_o.* = g_toh.*                #保存單頭舊值
   DISPLAY BY NAME g_toh.toh01,g_toh.toh02,g_toh.toh03, g_toh.tohoriu,g_toh.tohorig,
                   g_toh.tohuser,g_toh.tohgrup,g_toh.tohmodu,
                   g_toh.tohdate,g_toh.tohacti,
                   #FUN-840068     ---start---
                   g_toh.tohud01,g_toh.tohud02,g_toh.tohud03,g_toh.tohud04,
                   g_toh.tohud05,g_toh.tohud06,g_toh.tohud07,g_toh.tohud08,
                   g_toh.tohud09,g_toh.tohud10,g_toh.tohud11,g_toh.tohud12,
                   g_toh.tohud13,g_toh.tohud14,g_toh.tohud15 
                   #FUN-840068     ----end----
 
   CALL i210_toh01('d')
   CALL i210_toh02('d')
 
   CALL i210_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i210_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_toh.toh01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i210_cl USING g_toh.toh01,g_toh.toh02
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_toh.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i210_show()
 
   IF cl_exp(0,0,g_toh.tohacti) THEN                   #確認一下
      LET g_chr=g_toh.tohacti
      IF g_toh.tohacti='Y' THEN
         LET g_toh.tohacti='N'
      ELSE
         LET g_toh.tohacti='Y'
      END IF
 
      UPDATE toh_file SET tohacti=g_toh.tohacti,
                          tohmodu=g_user,
                          tohdate=g_today
       WHERE toh01=g_toh.toh01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","toh_file",g_toh.toh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         LET g_toh.tohacti=g_chr
      END IF
   END IF
 
   CLOSE i210_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_toh.toh01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT tohacti,tohmodu,tohdate
     INTO g_toh.tohacti,g_toh.tohmodu,g_toh.tohdate FROM toh_file
    WHERE toh01=g_toh.toh01
   DISPLAY BY NAME g_toh.tohacti,g_toh.tohmodu,g_toh.tohdate
 
END FUNCTION
 
FUNCTION i210_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_toh.toh01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_toh.* FROM toh_file
    WHERE toh01=g_toh.toh01
      AND toh02=g_toh.toh02
   IF g_toh.tohacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_toh.toh01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i210_cl USING g_toh.toh01,g_toh.toh02
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_toh.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i210_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "toh01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_toh.toh01      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "toh02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_toh.toh02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM toh_file WHERE toh01 = g_toh.toh01 AND toh02 = g_toh.toh02
      DELETE FROM toi_file WHERE toi01 = g_toh.toh01 AND toi02 = g_toh.toh02
      CLEAR FORM
      CALL g_toi.clear()
      DROP TABLE z                             #No.TQC-720019
      PREPARE i210_precount_z2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i210_precount_z2                 #No.TQC-720019
      OPEN i210_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i210_cs
         CLOSE i210_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i210_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i210_cs
         CLOSE i210_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i210_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i210_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i210_fetch('/')
      END IF
   END IF
 
   CLOSE i210_cl
   COMMIT WORK
   CALL cl_flow_notify(g_toh.toh01,'D')
END FUNCTION
 
#單身
FUNCTION i210_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1) #TQC-840066
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_toh.toh01 IS NULL OR g_toh.toh02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_toh.* FROM toh_file
     WHERE toh01=g_toh.toh01
       AND toh02=g_toh.toh02
 
    IF g_toh.tohacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_toh.toh01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT toi03,toi04,'',toi05,toi06,'',toi07,toi08,toi09,",
                       #No.FUN-840068 --start--
                       "       toiud01,toiud02,toiud03,toiud04,toiud05,",
                       "       toiud06,toiud07,toiud08,toiud09,toiud10,",
                       "       toiud11,toiud12,toiud13,toiud14,toiud15", 
                       #No.FUN-840068 ---end---
                       "  FROM toi_file",
                       " WHERE toi01=? AND toi02=? AND toi03=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i210_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_toi WITHOUT DEFAULTS FROM s_toi.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i210_cl USING g_toh.toh01,g_toh.toh02
           IF STATUS THEN
              CALL cl_err("OPEN i210_cl:", STATUS, 1)
              CLOSE i210_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i210_cl INTO g_toh.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i210_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_toi_t.* = g_toi[l_ac].*  #BACKUP
              LET g_toi_o.* = g_toi[l_ac].*  #BACKUP
              OPEN i210_bcl USING g_toh.toh01,g_toh.toh02,g_toi_t.toi03
              IF STATUS THEN
                 CALL cl_err("OPEN i210_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i210_bcl INTO g_toi[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_toi_t.toi03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT top02
                   INTO g_toi[l_ac].gea02
                   FROM top_file WHERE top01 = g_toi[l_ac].toi04
                 SELECT SUM(tod08)
                   INTO l_tod08
                   FROM tod_file WHERE tod03 = g_toi[l_ac].toi04
                 LET g_toi[l_ac].toi061 = g_toi[l_ac].toi06*100/l_tod08
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_toi[l_ac].* TO NULL
           LET g_toi[l_ac].toi03 =  0
           LET g_toi_t.* = g_toi[l_ac].*         #新輸入資料
           LET g_toi_o.* = g_toi[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD toi03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO toi_file(toi01,toi02,toi03,toi04,toi05,toi06,
                                toi07,toi08,toi09,
                                #FUN-840068 --start--
                                toiud01,toiud02,toiud03,toiud04,toiud05,toiud06,
                                toiud07,toiud08,toiud09,toiud10,toiud11,toiud12,
                                toiud13,toiud14,toiud15)
                                #FUN-840068 --end--
           VALUES(g_toh.toh01,g_toh.toh02,
                  g_toi[l_ac].toi03,g_toi[l_ac].toi04,
                  g_toi[l_ac].toi05,g_toi[l_ac].toi06,
                  g_toi[l_ac].toi07,g_toi[l_ac].toi08,
                  g_toi[l_ac].toi09,
                  #FUN-840068 --start--
                  g_toi[l_ac].toiud01,g_toi[l_ac].toiud02,
                  g_toi[l_ac].toiud03,g_toi[l_ac].toiud04,
                  g_toi[l_ac].toiud05,g_toi[l_ac].toiud06,
                  g_toi[l_ac].toiud07,g_toi[l_ac].toiud08,
                  g_toi[l_ac].toiud09,g_toi[l_ac].toiud10,
                  g_toi[l_ac].toiud11,g_toi[l_ac].toiud12,
                  g_toi[l_ac].toiud13,g_toi[l_ac].toiud14,
                  g_toi[l_ac].toiud15)
                  #FUN-840068 --end--
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_toi[l_ac].toi03,SQLCA.sqlcode,0)  #No.FUN-660104
              CALL cl_err3("ins","toi_file",g_toi[l_ac].toi03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD toi03                        #default 序號
           IF g_toi[l_ac].toi03 IS NULL OR g_toi[l_ac].toi03 = 0 THEN
              SELECT max(toi03)+1
                INTO g_toi[l_ac].toi03
                FROM toi_file
               WHERE toi01 = g_toh.toh01
                 AND toi02 = g_toh.toh02
              IF g_toi[l_ac].toi03 IS NULL THEN
                 LET g_toi[l_ac].toi03 = 1
              END IF
           END IF
 
        AFTER FIELD toi03                        #check 序號是否重複
           IF NOT cl_null(g_toi[l_ac].toi03) THEN
              IF g_toi[l_ac].toi03 != g_toi_t.toi03
                 OR g_toi_t.toi03 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM toi_file
                  WHERE toi01 = g_toh.toh01
                    AND toi02 = g_toh.toh02
                    AND toi03 = g_toi[l_ac].toi03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_toi[l_ac].toi03 = g_toi_t.toi03
                    NEXT FIELD toi03
                 END IF
              END IF
           END IF
 
 
        AFTER FIELD toi04
           IF NOT cl_null(g_toi[l_ac].toi04) THEN
              IF g_toi_o.toi04 IS NULL OR
                (g_toi[l_ac].toi04 != g_toi_o.toi04 ) THEN
                    SELECT count(*) INTO l_n FROM top_file
                     WHERE top03 = g_toh.toh01
                       AND top01 = g_toi[l_ac].toi04
                       AND topacti = 'Y'
                    IF l_n <= 0 THEN
                       CALL cl_err(g_toi[l_ac].toi03,'atm-112',0)
                       LET g_toi[l_ac].toi04 = g_toi_o.toi04
                    NEXT FIELD toi04
                    END IF
                 CALL i210_toi04('d')
              END IF
           END IF
 
        AFTER FIELD toi05
           IF NOT cl_null(g_toi[l_ac].toi05) THEN
                 IF g_toi[l_ac].toi05 < 0 OR
                    g_toi[l_ac].toi05 > 10 THEN
                    CALL cl_err(g_toi[l_ac].toi05,'atm-113',0)
                    NEXT FIELD toi05
                 END IF
           END IF
 
        AFTER FIELD toi06
           IF NOT cl_null(g_toi[l_ac].toi06) THEN
              IF (g_toi[l_ac].toi06 < 0) THEN
                 CALL cl_err(g_toi[l_ac].toi06,'atm-114',0)
                 NEXT FIELD toi06
              END IF
              CALL i210_toi06('d')
           END IF
 
        AFTER FIELD toi07
           IF NOT cl_null(g_toi[l_ac].toi07) THEN
              IF g_toi[l_ac].toi07 > g_toi[l_ac].toi08 THEN
                 CALL cl_err(g_toi[l_ac].toi07,'atm-115',0)
                 NEXT FIELD toi07
              END IF
           END IF
 
        AFTER FIELD toi08
           IF NOT cl_null(g_toi[l_ac].toi08) THEN
              IF g_toi[l_ac].toi08 < g_toi[l_ac].toi07 THEN
                 CALL cl_err(g_toi[l_ac].toi08,'atm-115',0)
                 NEXT FIELD toi08
              END IF
           END IF
 
        #No.FUN-840068 --start--
        AFTER FIELD toiud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toiud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_toi_t.toi03 > 0 AND g_toi_t.toi03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM toi_file
               WHERE toi01 = g_toh.toh01
                 AND toi02 = g_toh.toh02
                 AND toi03 = g_toi_t.toi03
              IF SQLCA.sqlcode THEN
              #  CALL cl_err(g_toi_t.toi03,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("del","toi_file",g_toi_t.toi03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_toi[l_ac].* = g_toi_t.*
              CLOSE i210_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_toi[l_ac].toi03,-263,1)
              LET g_toi[l_ac].* = g_toi_t.*
           ELSE
              UPDATE toi_file SET toi03=g_toi[l_ac].toi03,
                                  toi04=g_toi[l_ac].toi04,
                                  toi05=g_toi[l_ac].toi05,
                                  toi06=g_toi[l_ac].toi06,
                                  toi07=g_toi[l_ac].toi07,
                                  toi08=g_toi[l_ac].toi08,
                                  toi09=g_toi[l_ac].toi09,
                                  #FUN-840068 --start--
                                  toiud01 = g_toi[l_ac].toiud01,
                                  toiud02 = g_toi[l_ac].toiud02,
                                  toiud03 = g_toi[l_ac].toiud03,
                                  toiud04 = g_toi[l_ac].toiud04,
                                  toiud05 = g_toi[l_ac].toiud05,
                                  toiud06 = g_toi[l_ac].toiud06,
                                  toiud07 = g_toi[l_ac].toiud07,
                                  toiud08 = g_toi[l_ac].toiud08,
                                  toiud09 = g_toi[l_ac].toiud09,
                                  toiud10 = g_toi[l_ac].toiud10,
                                  toiud11 = g_toi[l_ac].toiud11,
                                  toiud12 = g_toi[l_ac].toiud12,
                                  toiud13 = g_toi[l_ac].toiud13,
                                  toiud14 = g_toi[l_ac].toiud14,
                                  toiud15 = g_toi[l_ac].toiud15
                                  #FUN-840068 --end-- 
               WHERE toi01=g_toh.toh01
                 AND toi02=g_toh.toh02
                 AND toi03=g_toi_t.toi03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #  CALL cl_err(g_toi[l_ac].toi03,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("upd","toi_file",g_toi[l_ac].toi03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_toi[l_ac].* = g_toi_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_toi[l_ac].* = g_toi_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_toi.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i210_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i210_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(toi03) AND l_ac > 1 THEN
              LET g_toi[l_ac].* = g_toi[l_ac-1].*
              LET g_toi[l_ac].toi03 = g_rec_b + 1
              NEXT FIELD toi03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(toi04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_toh.toh01
                 LET g_qryparam.form ="q_top2"
                 LET g_qryparam.default1 = g_toi[l_ac].toi04
                 CALL cl_create_qry() RETURNING g_toi[l_ac].toi04
                 DISPLAY BY NAME g_toi[l_ac].toi04
                 NEXT FIELD toi04
                 CALL i210_toi04('d')
            END CASE
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                                RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
         CALL cl_about()
 
       ON ACTION help
         CALL cl_show_help()
 
 
    END INPUT
 
    CLOSE i210_bcl
    COMMIT WORK
#   CALL i210_delall()
    CALL i210_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i210_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM toh_file WHERE toh01 = g_toh.toh01 AND toh02 = g_toh.toh02
         INITIALIZE g_toh.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i210_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM toi_file
#    WHERE toi01 = g_toh.toh01
#      AND toi02 = g_toh.toh02
#
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM toh_file
#       WHERE toh01 = g_toh.toh01
#         AND toh02 = g_toh.toh02
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i210_toi04(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_top02   LIKE top_file.top02
 
   LET g_errno = ' '
   IF g_toi[l_ac].toi04 IS NULL THEN
      LET g_errno = ' '
   ELSE
      SELECT top02
        INTO l_top02
        FROM top_file WHERE top01 = g_toi[l_ac].toi04
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_top02 = NULL
      END IF
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_toi[l_ac].gea02 = l_top02
   END IF
 
END FUNCTION
 
FUNCTION i210_toi06(p_cmd)
    DEFINE p_cmd      LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT SUM(tod08) INTO l_tod08
      FROM tod_file WHERE tod03 = g_toi[l_ac].toi04
    IF SQLCA.sqlcode THEN
       LET g_errno = ' '
       LET l_tod08 = NULL
    END IF
    IF cl_null(g_errno) OR  p_cmd='d'  THEN
       LET l_toi061 = g_toi[l_ac].toi06*100/l_tod08
       LET g_toi[l_ac].toi061=l_toi061
    END IF
 
END FUNCTION
 
 
FUNCTION i210_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON toi03,toi04,toi05,toi06,
                       toi07,toi08,toi09
                       #No.FUN-840068 --start--
                       ,toiud01,toiud02,toiud03,toiud04,toiud05
                       ,toiud06,toiud07,toiud08,toiud09,toiud10
                       ,toiud11,toiud12,toiud13,toiud14,toiud15
                       #No.FUN-840068 ---end---
            FROM s_toi[1].toi03,s_toi[1].toi04,
                 s_toi[1].toi05,s_toi[1].toi06,
                 s_toi[1].toi07,s_toi[1].toi08,
                 s_toi[1].toi09
                 #No.FUN-840068 --start--
                 ,s_toi[1].toiud01,s_toi[1].toiud02,s_toi[1].toiud03
                 ,s_toi[1].toiud04,s_toi[1].toiud05,s_toi[1].toiud06
                 ,s_toi[1].toiud07,s_toi[1].toiud08,s_toi[1].toiud09
                 ,s_toi[1].toiud10,s_toi[1].toiud11,s_toi[1].toiud12
                 ,s_toi[1].toiud13,s_toi[1].toiud14,s_toi[1].toiud15
                 #No.FUN-840068 ---end---
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
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
 
    CALL i210_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i210_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
 
    LET g_sql = "SELECT toi03,toi04,'',toi05,",
                " toi06,'',toi07,toi08,toi09,",
                #No.FUN-840068 --start--
                "       toiud01,toiud02,toiud03,toiud04,toiud05,",
                "       toiud06,toiud07,toiud08,toiud09,toiud10,",
                "       toiud11,toiud12,toiud13,toiud14,toiud15", 
                #No.FUN-840068 ---end---
                " FROM toi_file",
                " WHERE toi01 ='",g_toh.toh01,"' ",   #單頭
                "   AND toi02 ='",g_toh.toh02,"' "
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY toi03 "
    DISPLAY g_sql
 
    PREPARE i210_pb FROM g_sql
    DECLARE toi_cs
        CURSOR FOR i210_pb
 
    CALL g_toi.clear()
    LET g_cnt = 1
 
    FOREACH toi_cs INTO g_toi[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     SELECT top02
       INTO g_toi[g_cnt].gea02
       FROM top_file WHERE top01 = g_toi[g_cnt].toi04
     SELECT SUM(tod08)
       INTO l_tod08
       FROM tod_file WHERE tod03 = g_toi[g_cnt].toi04
      LET g_toi[g_cnt].toi061 = g_toi[g_cnt].toi06*100/l_tod08
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_toi.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_toi TO s_toi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
 
      ##################################################################
      # Standard 4ad ACTION
      ##################################################################
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
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
      ON ACTION first
         CALL i210_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i210_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION jump
         CALL i210_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i210_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i210_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i210_copy()
DEFINE
    l_newno         LIKE toh_file.toh01,
    l_newno1        LIKE toh_file.toh02,
    l_too02         LIKE too_file.too02,
    l_tof02         LIKE tof_file.tof02,
    l_oldno1        LIKE toh_file.toh02,
    l_oldno         LIKE toh_file.toh01
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_toh.toh01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_toh.toh02 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i210_set_entry('a')
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno,l_newno1 FROM toh01,toh02
 
        AFTER FIELD toh01
            IF cl_null(l_newno) THEN NEXT FIELD toh01 END IF
            SELECT  count(*) INTO g_cnt FROM too_file
             WHERE  too01=l_newno
               AND  tooacti='Y'
            IF g_cnt <= 0 THEN
               CALL cl_err(l_newno,'atm-111',0)
               NEXT FIELD toh01
            END IF
            SELECT  too02 INTO l_too02 FROM too_file
             WHERE  too01=l_newno
               AND  tooacti='Y'
            DISPLAY l_too02 TO FORMONLY.too02
 
        AFTER FIELD toh02
            IF cl_null(l_newno1) THEN NEXT FIELD toh02 END IF
            SELECT  count(*) INTO g_cnt FROM tof_file
             WHERE  tof01=l_newno1
               AND  tof06=l_newno
               AND  tof21='2'
               AND  tofacti='Y'
            IF g_cnt <= 0 THEN
               CALL cl_err(l_newno1,'atm-110',0)
               NEXT FIELD toh02
            END IF
            SELECT  tof02 INTO l_tof02 FROM tof_file
             WHERE  tof01=l_newno1
               AND  tof06=l_newno
               AND  tof21='2'
               AND  tofacti='Y'
            DISPLAY l_tof02 TO FORMONLY.tof02
 
            BEGIN WORK
 
            SELECT count(*) INTO g_cnt FROM toh_file
             WHERE toh01 = l_newno
               AND toh02 = l_newno1
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD toh01
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(toh01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_too"
                 LET g_qryparam.default1=g_toh.toh01
                 CALL cl_create_qry() RETURNING l_newno
                 DISPLAY l_newno TO toh01
                 IF SQLCA.sqlcode THEN
                   DISPLAY BY NAME g_toh.toh01
                   LET l_newno = NULL
                   NEXT FIELD toh01
                 END IF
              WHEN INFIELD(toh02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '2'
                 LET g_qryparam.arg2 = l_newno
                 LET g_qryparam.form="q_tof1"
                 LET g_qryparam.default1=g_toh.toh02
                 CALL cl_create_qry() RETURNING l_newno1
                 DISPLAY l_newno1 TO toh02
                 IF SQLCA.sqlcode THEN
                   DISPLAY BY NAME g_toh.toh02
                   LET l_newno1= NULL
                   NEXT FIELD toh02
                 END IF
               OTHERWISE EXIT CASE
            END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_toh.toh01,g_toh.toh02
       ROLLBACK WORK
       RETURN
    END IF
 
    DROP TABLE y
 
    SELECT * FROM toh_file         #單頭複製
        WHERE toh01=g_toh.toh01
          AND toh02=g_toh.toh02
        INTO TEMP y
 
    UPDATE y
        SET toh01=l_newno,    #新的鍵值
            toh02=l_newno1,
            tohuser=g_user,   #資料所有者
            tohgrup=g_grup,   #資料所有者所屬群
            tohmodu=NULL,     #資料修改日期
            tohdate=g_today,  #資料建立日期
            tohacti='Y'       #有效資料
 
    INSERT INTO toh_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("ins","toh_file",g_toh.toh01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
 
    DROP TABLE x
 
    SELECT * FROM toi_file         #單身複製
        WHERE toi01=g_toh.toh01
          AND toi02=g_toh.toh02
        INTO TEMP x
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("ins","x",g_toh.toh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
 
    UPDATE x
        SET toi01=l_newno,
            toi02=l_newno1
 
    INSERT INTO toi_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","toi_file",g_toh.toh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104           #FUN-B80061    ADD
        ROLLBACK WORK #No:7857
    #   CALL cl_err(g_toh.toh01,SQLCA.sqlcode,0)  #No.FUN-660104
    #    CALL cl_err3("ins","toi_file",g_toh.toh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104          #FUN-B80061    MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_toh.toh01
     LET l_oldno1= g_toh.toh02
     SELECT toh_file.* INTO g_toh.* FROM toh_file
      WHERE toh01 = l_newno
        AND toh02 = l_newno1
     CALL i210_u()
     CALL i210_b()
     #FUN-C80046---begin
     #SELECT * INTO g_toh.* FROM toh_file
     # WHERE toh01 = l_oldno
     #   AND toh02 = l_oldno1
     #CALL i210_show()
     #FUN-C80046---end
END FUNCTION
 
FUNCTION i210_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    sr              RECORD
        toh01       LIKE toh_file.toh01,
        too02       LIKE too_file.too02,
        toh02       LIKE toh_file.toh02,
        tof02       LIKE tof_file.tof02,
        toh03       LIKE toh_file.toh03,
        toi03       LIKE toi_file.toi03,
        toi04       LIKE toi_file.toi04,
        gea02       LIKE top_file.top02,
        toi05       LIKE toi_file.toi05,
        toi06       LIKE toi_file.toi06,
        toi061      LIKE faa_file.faa27,          #No.FUN-680120 DECIMAL(7,4)
        toi07       LIKE toi_file.toi07,
        toi08       LIKE toi_file.toi08,
        toi09       LIKE toi_file.toi09
       END RECORD,
    l_name          LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)             #External(Disk) file name
    l_za05          LIKE ima_file.ima01              #No.FUN-680120 VARCHAR(40)               #
 
    CALL cl_del_data(l_table)     #No.FUN-860061
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'atmi210'    #No.FUN-860061
    IF cl_null(g_wc) THEN
        LET g_wc ="  toh01='",g_toh.toh01,"' AND toh02='",g_toh.toh02,"'"
        LET g_wc2=" 1=1 "
    END IF
    #CALL cl_wait()                            #No.FUN-860061  
    #CALL cl_outnam('atmi210') RETURNING l_name   #No.FUN-860061
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT UNIQUE toh01,'',toh02,'',toh03,toi03,toi04,'',",
              " toi05,toi06,'',toi07,toi08,toi09 ",
              " FROM toh_file,OUTER toi_file",
              " WHERE toh_file.toh01=toi_file.toi01 ",
              "  AND  toh_file.toh02=toi_file.toi02 ",
              "  AND ",g_wc CLIPPED,
              "  AND ",g_wc2 CLIPPED
    PREPARE i210_p1 FROM g_sql
    IF STATUS THEN CALL cl_err('i210_p1',STATUS,0) END IF
 
    DECLARE i210_co
        CURSOR FOR i210_p1
 
    #START REPORT i210_rep TO l_name  #No.FUN-860061
 
    FOREACH i210_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #No.FUN-860061-------start--   
        SELECT too02 INTO sr.too02
          FROM too_file WHERE too01=sr.toh01
        SELECT tof02 INTO sr.tof02
          FROM tof_file WHERE tof01=sr.toh02
 
        SELECT top02 INTO sr.gea02
          FROM top_file WHERE top01=sr.toi04
        SELECT SUM(tod08) INTO l_tod08
          FROM tod_file WHERE tod03 = sr.toi04
        LET sr.toi061 = sr.toi06*100/l_tod08 
        
        EXECUTE insert_prep USING
             sr.toh01,sr.too02,sr.toh02,sr.tof02,sr.toh03,sr.toi03,sr.toi04,
             sr.gea02,sr.toi05,sr.toi06,sr.toi061,sr.toi07,sr.toi08,sr.toi09                 
        #OUTPUT TO REPORT i210_rep(sr.*)
        #No.FUN-860061-------end        
    END FOREACH
 
    #No.FUN-860061------start--
    #FINISH REPORT i210_rep
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'toh01,toh02,toh03,tohuser,tohgrup,tohmodu,
                     tohdate,tohacti,toi03,toi04,toi05,toi06,toi07,
                     toi08,toi09')
       RETURNING g_wc
    END IF
    LET g_str = g_wc
    
    CALL cl_prt_cs3('atmi210','atmi210',l_sql,g_str)
    CLOSE i210_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    #No.FUN-860061------end
END FUNCTION
 
#No.FUN-860061------------start--
#REPORT i210_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#    l_i             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#    l_tod08         LIKE tod_file.tod08,
#    sr              RECORD
#        toh01       LIKE toh_file.toh01,
#        too02       LIKE too_file.too02,
#        toh02       LIKE toh_file.toh02,
#        tof02       LIKE tof_file.tof02,
#        toh03       LIKE toh_file.toh03,
#        toi03       LIKE toi_file.toi03,
#        toi04       LIKE toi_file.toi04,
#        gea02       LIKE top_file.top02,
#        toi05       LIKE toi_file.toi05,
#        toi06       LIKE toi_file.toi06,
#        toi061      LIKE faa_file.faa27,               #No.FUN-680120 DECIMAL(7,4) 
#        toi07       LIKE toi_file.toi07,
#        toi08       LIKE toi_file.toi08,
#        toi09       LIKE toi_file.toi09
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.toh01,sr.toh02,sr.toi03
#    FORMAT
#        PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT g_dash[1,g_len]
#        LET l_trailer_sw = 'y'
#        PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#                       g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
#                       g_x[43],g_x[44]
#        PRINT g_dash1
# 
#        BEFORE GROUP OF sr.toh01
#         IF (PAGENO > 1 OR LINENO > 9)
#            THEN SKIP TO TOP OF PAGE
#         END IF
# 
#        BEFORE GROUP OF sr.toh02
#         SELECT too02 INTO sr.too02
#           FROM too_file WHERE too01=sr.toh01
#         SELECT tof02 INTO sr.tof02
#           FROM tof_file WHERE tof01=sr.toh02
#         PRINTX name=D1
#               COLUMN g_c[31],sr.toh01 CLIPPED,
#               COLUMN g_c[32],sr.too02 CLIPPED,
#               COLUMN g_c[33],sr.toh02 CLIPPED,
#               COLUMN g_c[34],sr.tof02 CLIPPED,
#               COLUMN g_c[35],sr.toh03 CLIPPED;
#
#
#        ON EVERY ROW
#         SELECT top02 INTO sr.gea02
#           FROM top_file WHERE top01=sr.toi04
#         SELECT SUM(tod08) INTO l_tod08
#           FROM tod_file WHERE tod03 = sr.toi04
#         LET sr.toi061 = sr.toi06*100/l_tod08
#         PRINTX name=D1
#               COLUMN g_c[36],sr.toi03 USING '###&', #FUN-590118
#               COLUMN g_c[37],sr.toi04,
#               COLUMN g_c[38],sr.gea02 CLIPPED,
#               COLUMN g_c[39],sr.toi05 USING '####',
#               COLUMN g_c[40],sr.toi06 USING '#########',
#               COLUMN g_c[41],sr.toi061 USING '###&.&&&&',
#               COLUMN g_c[42],sr.toi07,
#               COLUMN g_c[43],sr.toi08,
#               COLUMN g_c[44],sr.toi09
# 
# 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
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
#No.FUN-860061------------end
 
FUNCTION i210_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("toh01,toh02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i210_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("toh01,toh02",FALSE)
    END IF
 
END FUNCTION
 
