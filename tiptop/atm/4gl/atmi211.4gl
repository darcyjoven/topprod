# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi211.4gl
# Descriptions...: 全國性廣告費分攤比率維護作業
# Date & Author..: 05/10/18 By Tracy
# Modify.........: MOD-640219 06/04/09 By Ray 更改Input時的qry 
# Modify.........: TQC-650031 06/05/11 By Tracy AFTER FIELD toj01 增加控制條件 
# Modify.........: No.FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710043 07/01/11 By Rayven 若選出省別人口數為空則重新選擇或先去atmi208中維護
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/18 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-860012 08/06/04 By lala    CR
# Modify.........: No.FUN-8A0067 09/02/05 By dxfwo CRbug
 
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
#No.FUN-860012---start---
DEFINE tm    RECORD
              wc	STRING,
              wc2       STRING,
              a 	LIKE type_file.chr1,
              b 	LIKE type_file.chr1,
              c	        LIKE type_file.chr1,
              more	LIKE type_file.chr1
 	     END RECORD
#No.FUN-860012---end---
DEFINE
    g_toj           RECORD LIKE toj_file.*,
    g_toj_t         RECORD LIKE toj_file.*,
    g_toj_o         RECORD LIKE toj_file.*,
    g_toj01_t       LIKE toj_file.toj01,
    g_toj02_t       LIKE toj_file.toj02,
    g_tok           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        tok03       LIKE tok_file.tok03,          #項次
        tok04       LIKE tok_file.tok04,          #省別
        too02       LIKE too_file.too02,          #省份名稱
        tok05       LIKE tok_file.tok05,          #人口數
        tok06       LIKE tok_file.tok06,          #收視率
        tok061      LIKE tok_file.tok05,          #收視人口
        tok062      LIKE tok_file.tok06,          #省分攤比率
        tok07       LIKE tok_file.tok07,          #生效日期
        tok08       LIKE tok_file.tok08,          #失效日期
        tok09       LIKE tok_file.tok09,          #備注
        #FUN-840068 --start---
        tokud01     LIKE tok_file.tokud01,
        tokud02     LIKE tok_file.tokud02,
        tokud03     LIKE tok_file.tokud03,
        tokud04     LIKE tok_file.tokud04,
        tokud05     LIKE tok_file.tokud05,
        tokud06     LIKE tok_file.tokud06,
        tokud07     LIKE tok_file.tokud07,
        tokud08     LIKE tok_file.tokud08,
        tokud09     LIKE tok_file.tokud09,
        tokud10     LIKE tok_file.tokud10,
        tokud11     LIKE tok_file.tokud11,
        tokud12     LIKE tok_file.tokud12,
        tokud13     LIKE tok_file.tokud13,
        tokud14     LIKE tok_file.tokud14,
        tokud15     LIKE tok_file.tokud15
        #FUN-840068 --end--
                    END RECORD,
    g_tok_t         RECORD                        #程式變數 (舊值)
        tok03       LIKE tok_file.tok03,          #項次
        tok04       LIKE tok_file.tok04,          #省別
        too02       LIKE too_file.too02,          #省份名稱
        tok05       LIKE tok_file.tok05,          #人口數
        tok06       LIKE tok_file.tok06,          #收視率
        tok061      LIKE tok_file.tok05,          #收視人口
        tok062      LIKE tok_file.tok06,          #省分攤比率
        tok07       LIKE tok_file.tok07,          #生效日期
        tok08       LIKE tok_file.tok08,          #失效日期
        tok09       LIKE tok_file.tok09,          #備注
        #FUN-840068 --start---
        tokud01     LIKE tok_file.tokud01,
        tokud02     LIKE tok_file.tokud02,
        tokud03     LIKE tok_file.tokud03,
        tokud04     LIKE tok_file.tokud04,
        tokud05     LIKE tok_file.tokud05,
        tokud06     LIKE tok_file.tokud06,
        tokud07     LIKE tok_file.tokud07,
        tokud08     LIKE tok_file.tokud08,
        tokud09     LIKE tok_file.tokud09,
        tokud10     LIKE tok_file.tokud10,
        tokud11     LIKE tok_file.tokud11,
        tokud12     LIKE tok_file.tokud12,
        tokud13     LIKE tok_file.tokud13,
        tokud14     LIKE tok_file.tokud14,
        tokud15     LIKE tok_file.tokud15
        #FUN-840068 --end--
                    END RECORD,
    g_tok_o         RECORD                        #程式變數 (舊值)
        tok03       LIKE tok_file.tok03,          #項次
        tok04       LIKE tok_file.tok04,          #省別
        too02       LIKE too_file.too02,          #省份名稱
        tok05       LIKE tok_file.tok05,          #人口數
        tok06       LIKE tok_file.tok06,          #收視率
        tok061      LIKE tok_file.tok05,          #收視人口
        tok062      LIKE tok_file.tok06,          #省分攤比率
        tok07       LIKE tok_file.tok07,          #生效日期
        tok08       LIKE tok_file.tok08,          #失效日期
        tok09       LIKE tok_file.tok09,          #備注
        #FUN-840068 --start---
        tokud01     LIKE tok_file.tokud01,
        tokud02     LIKE tok_file.tokud02,
        tokud03     LIKE tok_file.tokud03,
        tokud04     LIKE tok_file.tokud04,
        tokud05     LIKE tok_file.tokud05,
        tokud06     LIKE tok_file.tokud06,
        tokud07     LIKE tok_file.tokud07,
        tokud08     LIKE tok_file.tokud08,
        tokud09     LIKE tok_file.tokud09,
        tokud10     LIKE tok_file.tokud10,
        tokud11     LIKE tok_file.tokud11,
        tokud12     LIKE tok_file.tokud12,
        tokud13     LIKE tok_file.tokud13,
        tokud14     LIKE tok_file.tokud14,
        tokud15     LIKE tok_file.tokud15
        #FUN-840068 --end--
                    END RECORD,
   g_wc,g_wc2,g_sql STRING,
   g_rec_b          LIKE type_file.num5,                       #單身筆數             #No.FUN-680120 SMALLINT
   l_ac             LIKE type_file.num5                        #目前處理的ARRAY CNT  #No.FUN-680120 SMALLINT
 
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_chr        LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i          LIKE type_file.num5          #count/index for any purpose       #No.FUN-680120 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680120
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_row_count  LIKE type_file.num10                 #總筆數                  #No.FUN-680120 INTEGER
DEFINE g_jump       LIKE type_file.num10                 #查詢指定的筆數          #No.FUN-680120 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5                  #是否開啟指定筆視窗      #No.FUN-680120 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_str      STRING     #No.FUN-860012
DEFINE   l_table    STRING     #No.FUN-860012
#主程式開始
MAIN
#DEFINE                                            #No.FUN-6B0014 
#       l_time    LIKE type_file.chr8              #No.FUN-6B0014
 
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
 
#No.FUN-860012---start---
   LET g_sql="toj01.toj_file.toj01,",
             "tof02.tof_file.tof02,",
             "toj02.toj_file.toj02,",
             "tqa02.tqa_file.tqa02,",
             "toj03.toj_file.toj03,",
             "tok03.tok_file.tok03,",
             "tok04.tok_file.tok04,",
             "too02.too_file.too02,",
             "tok05.tok_file.tok05,",
             "tok06.tok_file.tok06,",
             "l_tok061.tok_file.tok05,",
             "l_tok062.tok_file.tok06,",
             "tok07.tok_file.tok07,",
             "tok08.tok_file.tok08,",
             "tok09.tok_file.tok09"
 
   LET l_table = cl_prt_temptable('atmi211',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-860012---end---
 
   LET g_forupd_sql = "SELECT * FROM toj_file WHERE toj01 = ? AND toj02 =?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i211_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
 
   OPEN WINDOW i211_w AT p_row,p_col      #顯示畫面
        WITH FORM "atm/42f/atmi211"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i211_menu()
   CLOSE WINDOW i211_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION i211_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_tok.clear() 
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_toj.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON toj01,toj02,toj03,
                             tojuser,tojgrup,tojmodu,tojdate,tojacti,
                             #FUN-840068   ---start---
                             tojud01,tojud02,tojud03,tojud04,tojud05,
                             tojud06,tojud07,tojud08,tojud09,tojud10,
                             tojud11,tojud12,tojud13,tojud14,tojud15
                             #FUN-840068    ----end----
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(toj01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_tof2"
                 LET g_qryparam.arg1='1'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toj01
                 NEXT FIELD toj01
            WHEN INFIELD(toj02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1='2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toj02
                 NEXT FIELD toj02
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
   #      LET g_wc = g_wc clipped," AND tojuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND tojgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND tojgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tojuser', 'tojgrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON tok03,tok04,tok05,tok06,tok07,tok08,  #螢幕上取單身條件
                      tok09
                      #No.FUN-840068 --start--
                      ,tokud01,tokud02,tokud03,tokud04,tokud05
                      ,tokud06,tokud07,tokud08,tokud09,tokud10
                      ,tokud11,tokud12,tokud13,tokud14,tokud15
                      #No.FUN-840068 ---end---
             FROM s_tok[1].tok03,s_tok[1].tok04,s_tok[1].tok05,
                  s_tok[1].tok06,s_tok[1].tok07,s_tok[1].tok08,
                  s_tok[1].tok09
                  #No.FUN-840068 --start--
                  ,s_tok[1].tokud01,s_tok[1].tokud02,s_tok[1].tokud03
                  ,s_tok[1].tokud04,s_tok[1].tokud05,s_tok[1].tokud06
                  ,s_tok[1].tokud07,s_tok[1].tokud08,s_tok[1].tokud09
                  ,s_tok[1].tokud10,s_tok[1].tokud11,s_tok[1].tokud12
                  ,s_tok[1].tokud13,s_tok[1].tokud14,s_tok[1].tokud15
                  #No.FUN-840068 ---end---
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tok04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_too"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tok04
                 NEXT FIELD tok04
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
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  toj01 ,toj02 FROM toj_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY toj01"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT  toj01,toj02 ",
                  "  FROM toj_file, tok_file ",
                  " WHERE toj01 = tok01",
                  "   AND toj02 = tok02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY toj01"
   END IF
 
   PREPARE i211_prepare FROM g_sql
   DECLARE i211_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i211_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
#     LET g_sql="SELECT toj01,toj02 FROM toj_file WHERE ",g_wc CLIPPED,      #No.TQC-720019
      LET g_sql_tmp="SELECT toj01,toj02 FROM toj_file WHERE ",g_wc CLIPPED,  #No.TQC-720019
                    " GROUP BY toj01,toj02",
                    " INTO TEMP z "
   ELSE
#     LET g_sql="SELECT toj01,toj02 FROM toj_file,tok_file WHERE ",      #No.TQC-720019
      LET g_sql_tmp="SELECT toj01,toj02 FROM toj_file,tok_file WHERE ",  #No.TQC-720019
                    "tok01=toj01 AND tok02=toj02 AND",g_wc CLIPPED,
                    " AND ",g_wc2 CLIPPED,
                    " GROUP BY toj01,toj02",
                    " INTO TEMP z "
   END IF
   DROP TABLE z
#  PREPARE i211_precount_z FROM g_sql      #No.TQC-720019
   PREPARE i211_precount_z FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i211_precount_z
 
   LET g_sql="SELECT COUNT(*) FROM z "
 
   PREPARE i211_precount FROM g_sql
   DECLARE i211_count CURSOR FOR i211_precount
 
END FUNCTION
 
FUNCTION i211_menu()
 
   WHILE TRUE
      CALL i211_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i211_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i211_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i211_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i211_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i211_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i211_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i211_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i211_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tok),'','')
            END IF
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_toj.toj01 IS NOT NULL THEN
                 LET g_doc.column1 = "toj01"
                 LET g_doc.value1 = g_toj.toj01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i211_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_tok.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_toj.* LIKE toj_file.*             #DEFAULT 設定
   LET g_toj01_t = NULL
   LET g_toj02_t = NULL
 
 
   #預設值及將數值類變數清成零
   LET g_toj_t.* = g_toj.*
   LET g_toj_o.* = g_toj.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_toj.tojuser=g_user
      LET g_toj.tojoriu = g_user #FUN-980030
      LET g_toj.tojorig = g_grup #FUN-980030
      LET g_toj.tojgrup=g_grup
      LET g_toj.tojdate=g_today
      LET g_toj.tojacti='Y'              #資料有效
 
      CALL i211_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_toj.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_toj.toj01) OR cl_null(g_toj.toj02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO toj_file VALUES (g_toj.*)
 
      IF SQLCA.sqlcode THEN              #置入資料庫不成功
         CALL cl_err3("ins","toj_file",g_toj.toj01,g_toj.toj02,SQLCA.sqlcode,"","",1)  #No.FUN-660104         #FUN-B80061    ADD
         ROLLBACK WORK
      #  CALL cl_err(g_toj.toj01,SQLCA.sqlcode,1)  #No.FUN-660104
      #   CALL cl_err3("ins","toj_file",g_toj.toj01,g_toj.toj02,SQLCA.sqlcode,"","",1)  #No.FUN-660104        #FUN-B80061    MARK 
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
 
      SELECT toj01,toj02 INTO g_toj.toj01,g_toj.toj02 FROM toj_file
        WHERE toj01 = g_toj.toj01
          AND toj02 = g_toj.toj02
      LET g_toj01_t = g_toj.toj01        #保留舊值
      LET g_toj02_t = g_toj.toj02        #保留舊值
      LET g_toj_t.* = g_toj.*
      LET g_toj_o.* = g_toj.*
      CALL g_tok.clear()
 
      LET g_rec_b = 0
      CALL i211_b()                      #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i211_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_toj.toj01) OR cl_null(g_toj.toj02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_toj.* FROM toj_file
    WHERE toj01=g_toj.toj01
      AND toj02=g_toj.toj02
 
   IF g_toj.tojacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_toj.toj01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_toj01_t = g_toj.toj01
   LET g_toj02_t = g_toj.toj02
   BEGIN WORK
 
   OPEN i211_cl USING g_toj.toj01,g_toj.toj02
   IF STATUS THEN
      CALL cl_err("OPEN i211_cl:", STATUS, 1)
      CLOSE i211_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i211_cl INTO g_toj.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i211_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i211_show()
 
   WHILE TRUE
      LET g_toj01_t = g_toj.toj01
      LET g_toj02_t = g_toj.toj02
      LET g_toj_o.* = g_toj.*
      LET g_toj.tojmodu=g_user
      LET g_toj.tojdate=g_today
 
      CALL i211_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_toj.*=g_toj_t.*
         CALL i211_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_toj.toj01 != g_toj01_t OR g_toj.toj02 != g_toj02_t THEN
         UPDATE tok_file SET tok01 = g_toj.toj01,
                             tok02 = g_toj.toj02
                       WHERE tok01 = g_toj01_t
                         AND tok02 = g_toj02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #  CALL cl_err('tok',SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","tok_file",g_toj01_t,g_toj02_t,SQLCA.sqlcode,"","tok",1)  #No.FUN-660104
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE toj_file SET toj_file.* = g_toj.*
       WHERE toj01 = g_toj01_t AND toj02 = g_toj02_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #  CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","toj_file",g_toj.toj01,g_toj.toj02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i211_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i211_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
   p_cmd     LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_toj.tojuser,g_toj.tojmodu,
       g_toj.tojgrup,g_toj.tojdate,g_toj.tojacti
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME g_toj.toj01,g_toj.toj02,g_toj.toj03, g_toj.tojoriu,g_toj.tojorig,
                 #FUN-840068     ---start---
                 g_toj.tojud01,g_toj.tojud02,g_toj.tojud03,g_toj.tojud04,
                 g_toj.tojud05,g_toj.tojud06,g_toj.tojud07,g_toj.tojud08,
                 g_toj.tojud09,g_toj.tojud10,g_toj.tojud11,g_toj.tojud12,
                 g_toj.tojud13,g_toj.tojud14,g_toj.tojud15 
                 #FUN-840068     ----end----
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i211_set_entry(p_cmd)
         CALL i211_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD toj01
         IF cl_null(g_toj.toj01) THEN
            DISPLAY NULL TO FORMONLY.tof02
         ELSE
            IF cl_null(g_toj_o.toj01) OR
               (g_toj.toj01 != g_toj_o.toj01 ) THEN
               SELECT count(*) INTO l_n FROM tof_file
                WHERE tof01 = g_toj.toj01
                  AND tof21 = '1'                #No.TQC-650031        
               IF l_n = 0 THEN
                  CALL cl_err('',100,0)
                  LET g_toj.toj01 = g_toj01_t
                  DISPLAY BY NAME g_toj.toj01
                  NEXT FIELD toj01
               END IF
               CALL i211_toj01(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_toj.toj01,g_errno,0)
                  LET g_toj.toj01 = g_toj_o.toj01
                  DISPLAY BY NAME g_toj.toj01
                  NEXT FIELD toj01
               END IF
            END IF
         END IF
 
      AFTER FIELD toj02
         IF cl_null(g_toj.toj02) THEN
            DISPLAY NULL TO FORMONLY.tqa02
         ELSE
            IF cl_null(g_toj_o.toj02) OR
               (g_toj_o.toj02 != g_toj.toj02 ) THEN
               SELECT count(*) INTO l_n FROM tqa_file
                WHERE tqa01 = g_toj.toj02 AND tqa03='2'
                   IF l_n = 0 THEN
                     CALL cl_err('',100,0)
                     LET g_toj.toj02 = g_toj02_t
                     DISPLAY BY NAME g_toj.toj02
                     NEXT FIELD toj02
                   END IF
 
               SELECT count(*) INTO l_n FROM toj_file
                WHERE toj01 = g_toj.toj01
                  AND toj02 = g_toj.toj02
                   IF l_n > 0 THEN
                     CALL cl_err(g_toj.toj01,-239,0)
                     NEXT FIELD toj01
                   END IF
 
               CALL i211_toj02(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_toj.toj02,g_errno,0)
                  LET g_toj.toj02 = g_toj_o.toj02
                  DISPLAY BY NAME g_toj.toj02
                  NEXT FIELD toj02
               END IF
            END IF
         END IF
 
      #FUN-840068     ---start---
      AFTER FIELD tojud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tojud15
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
            WHEN INFIELD(toj01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tof2"
                 LET g_qryparam.arg1='1'
                 LET g_qryparam.default1 = g_toj.toj01
                 CALL cl_create_qry() RETURNING g_toj.toj01
                 DISPLAY BY NAME g_toj.toj01
                 NEXT FIELD toj01
            WHEN INFIELD(toj02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1='2'
                 LET g_qryparam.default1 = g_toj.toj02
                 CALL cl_create_qry() RETURNING g_toj.toj02
                 DISPLAY BY NAME g_toj.toj02
                 NEXT FIELD toj02
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
 
FUNCTION i211_toj01(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_tof02   LIKE tof_file.tof02,
          l_tofacti LIKE tof_file.tofacti
 
   LET g_errno = ' '
   SELECT tof02,tofacti
     INTO l_tof02,l_tofacti
     FROM tof_file
    WHERE tof01 = g_toj.toj01
   CASE WHEN SQLCA.SQLCODE = 100
                           LET g_errno = 'mfg9089'
                           LET l_tof02 = NULL
        WHEN l_tofacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_tof02 TO FORMONLY.tof02
   END IF
 
END FUNCTION
 
 
FUNCTION i211_toj02(p_cmd)
   DEFINE l_tqa02   LIKE tqa_file.tqa02,
          l_tqaacti LIKE tqa_file.tqaacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   LET g_errno = ' '
   SELECT tqa02,tqaacti
     INTO l_tqa02,l_tqaacti
     FROM tqa_file WHERE tqa01 = g_toj.toj02 AND tqa03='2'
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9089'
                           LET l_tqa02 = NULL
        WHEN l_tqaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_tqa02 TO FORMONLY.tqa02
   END IF
 
END FUNCTION
 
FUNCTION i211_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_toj.* TO NULL              #NO.FUN-6B0043
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tok.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i211_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_toj.* TO NULL
      RETURN
   END IF
 
   OPEN i211_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_toj.* TO NULL
   ELSE
      OPEN i211_count
      FETCH i211_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i211_fetch('F')                  # 讀出TEMP第一筆并顯示
   END IF
 
END FUNCTION
 
FUNCTION i211_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i211_cs INTO g_toj.toj01,g_toj.toj02
      WHEN 'P' FETCH PREVIOUS i211_cs INTO g_toj.toj01,g_toj.toj02
      WHEN 'F' FETCH FIRST    i211_cs INTO g_toj.toj01,g_toj.toj02
      WHEN 'L' FETCH LAST     i211_cs INTO g_toj.toj01,g_toj.toj02
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
            FETCH ABSOLUTE g_jump i211_cs INTO g_toj.toj01,g_toj.toj02
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)
      INITIALIZE g_toj.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_toj.* FROM toj_file WHERE toj01 = g_toj.toj01 AND toj02 = g_toj.toj02
   IF SQLCA.sqlcode THEN
   #  CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)  #No.FUN-660104
      CALL cl_err3("sel","toj_file",g_toj.toj01,g_toj.toj02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
      INITIALIZE g_toj.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_toj.tojuser
   LET g_data_group = g_toj.tojgrup
 
   CALL i211_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i211_show()
   LET g_toj_t.* = g_toj.*                #保存單頭舊值
   LET g_toj_o.* = g_toj.*                #保存單頭舊值
   DISPLAY BY NAME g_toj.toj01,g_toj.toj02,g_toj.toj03, g_toj.tojoriu,g_toj.tojorig,
                   g_toj.tojuser,g_toj.tojgrup,g_toj.tojmodu,
                   g_toj.tojdate,g_toj.tojacti,
           #FUN-840068     ---start---
           g_toj.tojud01,g_toj.tojud02,g_toj.tojud03,g_toj.tojud04,
           g_toj.tojud05,g_toj.tojud06,g_toj.tojud07,g_toj.tojud08,
           g_toj.tojud09,g_toj.tojud10,g_toj.tojud11,g_toj.tojud12,
           g_toj.tojud13,g_toj.tojud14,g_toj.tojud15 
           #FUN-840068     ----end----
 
   CALL i211_toj01('d')
   CALL i211_toj02('d')
 
   CALL i211_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i211_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_toj.toj01) OR cl_null(g_toj.toj02) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i211_cl USING g_toj.toj01,g_toj.toj02
   IF STATUS THEN
      CALL cl_err("OPEN i211_cl:", STATUS, 1)
      CLOSE i211_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i211_cl INTO g_toj.*                         # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)        #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i211_show()
 
   IF cl_exp(0,0,g_toj.tojacti) THEN                   #確認一下
      LET g_chr=g_toj.tojacti
      IF g_toj.tojacti='Y' THEN
         LET g_toj.tojacti='N'
      ELSE
         LET g_toj.tojacti='Y'
      END IF
 
      UPDATE toj_file SET tojacti=g_toj.tojacti,
                          tojmodu=g_user,
                          tojdate=g_today
      WHERE toj01=g_toj.toj01
        AND toj02=g_toj.toj02
 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","toj_file",g_toj.toj01,g_toj.toj02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
         LET g_toj.tojacti=g_chr
      END IF
   END IF
 
   CLOSE i211_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT tojacti,tojmodu,tojdate
     INTO g_toj.tojacti,g_toj.tojmodu,g_toj.tojdate FROM toj_file
    WHERE toj01=g_toj.toj01
      AND toj02=g_toj.toj02
   DISPLAY BY NAME g_toj.tojacti,g_toj.tojmodu,g_toj.tojdate
 
END FUNCTION
 
FUNCTION i211_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_toj.toj01) OR cl_null(g_toj.toj02) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_toj.* FROM toj_file
    WHERE toj01=g_toj.toj01
      AND toj02=g_toj.toj02
   IF g_toj.tojacti ='N' THEN                #檢查資料是否為無效
      CALL cl_err(g_toj.toj01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i211_cl USING g_toj.toj01,g_toj.toj02
   IF STATUS THEN
      CALL cl_err("OPEN i211_cl:", STATUS, 1)
      CLOSE i211_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i211_cl INTO g_toj.*               #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i211_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "toj01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_toj.toj01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM toj_file WHERE toj01 = g_toj.toj01
                             AND toj02 = g_toj.toj02
      DELETE FROM tok_file WHERE tok01 = g_toj.toj01
                             AND tok02 = g_toj.toj02
      CLEAR FORM
      CALL g_tok.clear()
      DROP TABLE z
#     EXECUTE i211_precount_z                  #No.TQC-720019
      PREPARE i211_precount_z2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i211_precount_z2                 #No.TQC-720019
      OPEN i211_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i211_cs
         CLOSE i211_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i211_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i211_cs
         CLOSE i211_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i211_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i211_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i211_fetch('/')
      END IF
   END IF
 
   CLOSE i211_cl
   COMMIT WORK
   CALL cl_flow_notify(g_toj.toj01,'D')
END FUNCTION
 
#單身
FUNCTION i211_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
    l_tok05         LIKE tok_file.tok05,
    l_tok061        LIKE tok_file.tok05
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF cl_null(g_toj.toj01) OR cl_null(g_toj.toj02) THEN
       RETURN
    END IF
 
    SELECT * INTO g_toj.* FROM toj_file
     WHERE toj01=g_toj.toj01
       AND toj02=g_toj.toj02
 
    IF g_toj.tojacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_toj.toj01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tok03,tok04,'',tok05,tok06,'','',tok07,",
                       "       tok08,tok09,",
                       #No.FUN-840068 --start--
                       "       tokud01,tokud02,tokud03,tokud04,tokud05,",
                       "       tokud06,tokud07,tokud08,tokud09,tokud10,",
                       "       tokud11,tokud12,tokud13,tokud14,tokud15", 
                       #No.FUN-840068 ---end---
                       "  FROM tok_file",
                       " WHERE tok01=? AND tok02=? AND tok03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i211_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tok WITHOUT DEFAULTS FROM s_tok.*
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
 
           OPEN i211_cl USING g_toj.toj01,g_toj.toj02
           IF STATUS THEN
              CALL cl_err("OPEN i211_cl:", STATUS, 1)
              CLOSE i211_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i211_cl INTO g_toj.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i211_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tok_t.* = g_tok[l_ac].*  #BACKUP
              LET g_tok_o.* = g_tok[l_ac].*  #BACKUP
              OPEN i211_bcl USING g_toj.toj01,g_toj.toj02,g_tok_t.tok03
              IF STATUS THEN
                 CALL cl_err("OPEN i211_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i211_bcl INTO g_tok[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tok[l_ac].tok03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE
                    CALL i211_tok04('d')
                    LET g_tok[l_ac].tok061 = g_tok[l_ac].tok05 *
                                             g_tok[l_ac].tok06
                    SELECT SUM(tok05*tok06) INTO l_tok061
                      FROM tok_file
                     WHERE tok02 = g_toj.toj02
                       AND tok05 IS NOT NULL
                       AND tok06 IS NOT NULL
                    IF cl_null(l_tok061) THEN
                       LET l_tok061 = 0
                    END IF
                    LET g_tok[l_ac].tok062 = g_tok[l_ac].tok061/l_tok061
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tok[l_ac].* TO NULL
           LET g_tok_t.* = g_tok[l_ac].*         #新輸入資料
           LET g_tok_o.* = g_tok[l_ac].*         #新輸入資料
           NEXT FIELD tok03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tok_file(tok01,tok02,tok03,tok04,tok05,tok06,
                                tok07,tok08,tok09,
                                #FUN-840068 --start--
                                tokud01,tokud02,tokud03,tokud04,tokud05,tokud06,
                                tokud07,tokud08,tokud09,tokud10,tokud11,tokud12,
                                tokud13,tokud14,tokud15)
                                #FUN-840068 --end--
           VALUES(g_toj.toj01,g_toj.toj02,
                  g_tok[l_ac].tok03,g_tok[l_ac].tok04,
                  g_tok[l_ac].tok05,g_tok[l_ac].tok06,
                  g_tok[l_ac].tok07,g_tok[l_ac].tok08,
                  g_tok[l_ac].tok09,
                  #FUN-840068 --start--
                  g_tok[l_ac].tokud01,g_tok[l_ac].tokud02,
                  g_tok[l_ac].tokud03,g_tok[l_ac].tokud04,
                  g_tok[l_ac].tokud05,g_tok[l_ac].tokud06,
                  g_tok[l_ac].tokud07,g_tok[l_ac].tokud08,
                  g_tok[l_ac].tokud09,g_tok[l_ac].tokud10,
                  g_tok[l_ac].tokud11,g_tok[l_ac].tokud12,
                  g_tok[l_ac].tokud13,g_tok[l_ac].tokud14,
                  g_tok[l_ac].tokud15)
                  #FUN-840068 --end--
 
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_tok[l_ac].tok03,SQLCA.sqlcode,0)  #No.FUN-660104
              CALL cl_err3("ins","tok_file",g_tok[l_ac].tok03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD tok03                        #default 序號
           IF cl_null(g_tok[l_ac].tok03) OR g_tok[l_ac].tok03 = 0 THEN
              SELECT max(tok03)+1
                INTO g_tok[l_ac].tok03
                FROM tok_file
               WHERE tok01 = g_toj.toj01
                 AND tok02 = g_toj.toj02
              IF cl_null(g_tok[l_ac].tok03) THEN
                 LET g_tok[l_ac].tok03 = 1
              END IF
           END IF
 
        AFTER FIELD tok03                        #check 序號是否重復
           IF NOT cl_null(g_tok[l_ac].tok03) THEN
              IF g_tok[l_ac].tok03 != g_tok_t.tok03
                 OR cl_null(g_tok_t.tok03) THEN
                 SELECT count(*)
                   INTO l_n
                   FROM tok_file
                  WHERE tok01 = g_toj.toj01
                    AND tok02 = g_toj.toj02
                    AND tok03 = g_tok[l_ac].tok03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tok[l_ac].tok03 = g_tok_t.tok03
                    NEXT FIELD tok03
                 END IF
              END IF
           END IF
 
        AFTER FIELD tok04
           IF NOT cl_null(g_tok[l_ac].tok04) THEN
              IF g_tok[l_ac].tok04 != g_tok_t.tok04    #check 省別是否重復
                 OR cl_null(g_tok_t.tok04) THEN
                 SELECT count(*)
                   INTO l_n
                   FROM tok_file
                  WHERE tok01 = g_toj.toj01
                    AND tok02 = g_toj.toj02
                    AND tok04 = g_tok[l_ac].tok04
                 IF l_n > 0 THEN
                    CALL cl_err('','atm-310',0)
                    LET g_tok[l_ac].tok04 = g_tok_t.tok04
                    NEXT FIELD tok04
                 END IF
              END IF
              SELECT COUNT(*) INTO l_cnt FROM too_file
                WHERE too01 = g_tok[l_ac].tok04
                IF l_cnt = 0 THEN
                   CALL cl_err('','atm-131',0)
                   LET g_tok[l_ac].tok04= g_tok_t.tok04
                   NEXT FIELD tok04
                END IF
              CALL i211_tok04('d')
           END IF
 
           LET l_tok05 = 0
           SELECT sum(tod08)
             INTO l_tok05
             FROM tod_file
            WHERE tod02=g_tok[l_ac].tok04
           LET g_tok[l_ac].tok05 = l_tok05
           #No.TQC-710043 --start--
           IF cl_null(g_tok[l_ac].tok05) THEN
              CALL cl_err('','atm-563',1)
              NEXT FIELD tok04
           END IF
           #No.TQC-710043 --end--
 
 
        AFTER FIELD tok06
           IF NOT cl_null(g_tok[l_ac].tok06) THEN
              IF g_tok[l_ac].tok06 <0 OR g_tok[l_ac].tok06 >1  THEN
                 CALL cl_err(g_tok[l_ac].tok06,'atm-308',0)
                 LET g_tok[l_ac].tok06 = g_tok_o.tok06
                 NEXT FIELD tok06
              END IF
           END IF
 
           LET g_tok[l_ac].tok061 = g_tok[l_ac].tok05 * g_tok[l_ac].tok06
 
           SELECT SUM(tok05*tok06) INTO l_tok061  #看此品牌的各省總收視人口
             FROM tok_file
            WHERE tok02 = g_toj.toj02
              AND tok05 IS NOT NULL
              AND tok06 IS NOT NULL
           IF cl_null(l_tok061) THEN
              LET l_tok061 = 0
           END IF
           IF NOT cl_null(g_tok[l_ac].tok062) THEN
              LET g_tok[l_ac].tok062 = g_tok[l_ac].tok061/l_tok061
           ELSE
              LET g_tok[l_ac].tok062 = g_tok[l_ac].tok061/
                                      (l_tok061 + g_tok[l_ac].tok061)
           END IF
 
        AFTER FIELD tok07
           IF NOT cl_null(g_tok[l_ac].tok07) THEN
              IF NOT cl_null(g_tok[l_ac].tok08) THEN
                 IF g_tok[l_ac].tok08<g_tok[l_ac].tok07 THEN
                    CALL cl_err(g_tok[l_ac].tok07,'mfg3009',0)
                    NEXT FIELD tok07
                 END IF
              END IF
           END IF
 
        AFTER FIELD tok08
           IF NOT cl_null(g_tok[l_ac].tok08) THEN
              IF NOT cl_null(g_tok[l_ac].tok07) THEN
                 IF g_tok[l_ac].tok08<g_tok[l_ac].tok07 THEN
                    CALL cl_err(g_tok[l_ac].tok07,'mfg3009',0)
                    NEXT FIELD tok08
                 END IF
              END IF
           END IF
 
        #No.FUN-840068 --start--
        AFTER FIELD tokud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tokud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_tok_t.tok03 > 0 AND g_tok_t.tok03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tok_file
               WHERE tok01 = g_toj.toj01
                 AND tok02 = g_toj.toj02
                 AND tok03 = g_tok_t.tok03
              IF SQLCA.sqlcode THEN
              #  CALL cl_err(g_tok_t.tok03,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("del","tok_file",g_tok_t.tok03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
              LET g_tok[l_ac].* = g_tok_t.*
              CLOSE i211_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tok[l_ac].tok03,-263,1)
              LET g_tok[l_ac].* = g_tok_t.*
           ELSE
              UPDATE tok_file SET tok03=g_tok[l_ac].tok03,
                                  tok04=g_tok[l_ac].tok04,
                                  tok05=g_tok[l_ac].tok05,
                                  tok06=g_tok[l_ac].tok06,
                                  tok07=g_tok[l_ac].tok07,
                                  tok08=g_tok[l_ac].tok08,
                                  tok09=g_tok[l_ac].tok09,
                                  #FUN-840068 --start--
                                  tokud01 = g_tok[l_ac].tokud01,
                                  tokud02 = g_tok[l_ac].tokud02,
                                  tokud03 = g_tok[l_ac].tokud03,
                                  tokud04 = g_tok[l_ac].tokud04,
                                  tokud05 = g_tok[l_ac].tokud05,
                                  tokud06 = g_tok[l_ac].tokud06,
                                  tokud07 = g_tok[l_ac].tokud07,
                                  tokud08 = g_tok[l_ac].tokud08,
                                  tokud09 = g_tok[l_ac].tokud09,
                                  tokud10 = g_tok[l_ac].tokud10,
                                  tokud11 = g_tok[l_ac].tokud11,
                                  tokud12 = g_tok[l_ac].tokud12,
                                  tokud13 = g_tok[l_ac].tokud13,
                                  tokud14 = g_tok[l_ac].tokud14,
                                  tokud15 = g_tok[l_ac].tokud15
                                  #FUN-840068 --end-- 
               WHERE tok01=g_toj.toj01
                 AND tok02=g_toj.toj02
                 AND tok03=g_tok_t.tok03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #  CALL cl_err(g_tok[l_ac].tok03,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("upd","tok_file",g_tok[l_ac].tok03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_tok[l_ac].* = g_tok_t.*
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
                 LET g_tok[l_ac].* = g_tok_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tok.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i211_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i211_bcl
           COMMIT WORK
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tok02) AND l_ac > 1 THEN
              LET g_tok[l_ac].* = g_tok[l_ac-1].*
              LET g_tok[l_ac].tok03 = g_rec_b + 1
              NEXT FIELD tok02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tok04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_too2"     #MOD-640219
                 LET g_qryparam.default1 = g_tok[l_ac].tok04
                 CALL cl_create_qry() RETURNING g_tok[l_ac].tok04
                 DISPLAY BY NAME g_tok[l_ac].tok04
                 NEXT FIELD tok04
               OTHERWISE EXIT CASE
            END CASE
 
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
 
    CLOSE i211_bcl
    COMMIT WORK
#   CALL i211_delall() #CHI-C30002 mark
    CALL i211_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i211_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM toj_file WHERE toj01 = g_toj.toj01 AND toj02 = g_toj.toj02
         INITIALIZE g_toj.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i211_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM tok_file
#    WHERE tok01 = g_toj.toj01
#      AND tok02 = g_toj.toj02
#
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM toj_file WHERE toj01 = g_toj.toj01
#                             AND toj02 = g_toj.toj02
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i211_tok04(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
  DEFINE l_tooacti  LIKE too_file.tooacti,
         l_too02    LIKE too_file.too02
  LET g_errno = " "
  SELECT tooacti,too02 INTO l_tooacti,l_too02
    FROM too_file
   WHERE too01 = g_tok[l_ac].tok04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_tooacti = NULL
         WHEN l_tooacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  LET g_tok[l_ac].too02 = l_too02
END FUNCTION
 
FUNCTION i211_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON tok03,tok04,tok05,tok06,
                       tok07,tok08,tok09
                       #No.FUN-840068 --start--
                       ,tokud01,tokud02,tokud03,tokud04,tokud05
                       ,tokud06,tokud07,tokud08,tokud09,tokud10
                       ,tokud11,tokud12,tokud13,tokud14,tokud15
                       #No.FUN-840068 ---end---
            FROM s_tok[1].tok03,s_tok[1].tok04,s_tok[1].tok05,
                 s_tok[1].tok06,s_tok[1].tok07,
                 s_tok[1].tok08,s_tok[1].tok09
                 #No.FUN-840068 --start--
                 ,s_tok[1].tokud01,s_tok[1].tokud02,s_tok[1].tokud03
                 ,s_tok[1].tokud04,s_tok[1].tokud05,s_tok[1].tokud06
                 ,s_tok[1].tokud07,s_tok[1].tokud08,s_tok[1].tokud09
                 ,s_tok[1].tokud10,s_tok[1].tokud11,s_tok[1].tokud12
                 ,s_tok[1].tokud13,s_tok[1].tokud14,s_tok[1].tokud15
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
 
    CALL i211_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i211_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(200)
    l_tok061        LIKE tok_file.tok05
 
    LET g_sql = "SELECT tok03,tok04,too02,tok05,tok06,'','',tok07,tok08,tok09,",
                #No.FUN-840068 --start--
                "       tokud01,tokud02,tokud03,tokud04,tokud05,",
                "       tokud06,tokud07,tokud08,tokud09,tokud10,",
                "       tokud11,tokud12,tokud13,tokud14,tokud15", 
                #No.FUN-840068 ---end---
                "  FROM tok_file,too_file",
                " WHERE tok01 ='",g_toj.toj01,"' ",  #單頭
                "   AND tok02 ='",g_toj.toj02,"' ",
                "   AND tok04 = too01"
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY tok03 "
    DISPLAY g_sql
 
    PREPARE i211_pb FROM g_sql
    DECLARE tok_cs                       #CURSOR
        CURSOR FOR i211_pb
 
    CALL g_tok.clear()
    LET g_cnt = 1
 
    FOREACH tok_cs INTO g_tok[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_tok[g_cnt].tok061 = g_tok[g_cnt].tok05 * g_tok[g_cnt].tok06
      SELECT SUM(tok05*tok06) INTO l_tok061
        FROM tok_file
       WHERE tok02 = g_toj.toj02
         AND tok05 IS NOT NULL
         AND tok06 IS NOT NULL
 
      IF cl_null(l_tok061) THEN
         LET l_tok061 = 0
      END IF
      LET g_tok[g_cnt].tok062 = g_tok[g_cnt].tok061/l_tok061
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_tok.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i211_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tok TO s_tok.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL i211_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i211_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION jump
         CALL i211_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i211_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i211_fetch('L')
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#NO.FUN-6B0031--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i211_copy()
DEFINE
    l_newno         LIKE toj_file.toj01,
    l_newno2        LIKE toj_file.toj02,
    l_oldno         LIKE toj_file.toj01,
    l_oldno2        LIKE toj_file.toj02,
    l_tof02         LIKE tof_file.tof02,
    l_tqa02         LIKE tqa_file.tqa02,
    p_cmd           LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
    l_n             LIKE type_file.num5          #No.FUN-680120 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_toj.toj01) OR cl_null(g_toj.toj02) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i211_set_entry('a')
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
    INPUT l_newno,l_newno2 FROM toj01,toj02
 
        AFTER FIELD toj01
           IF NOT cl_null(l_newno) THEN
              SELECT count(*) INTO l_n FROM tof_file
               WHERE tof01 = l_newno
                 AND tofacti = 'Y'
                  IF l_n = 0 THEN
                     CALL cl_err('',100,0)
                     LET g_toj.toj01 = g_toj01_t
                     DISPLAY BY NAME g_toj.toj01
                     NEXT FIELD toj01
                  END IF
           END IF
           SELECT tof02 INTO l_tof02 FROM tof_file
            WHERE tof01 = l_newno
              AND tofacti='Y'
           DISPLAY l_tof02 TO FORMONLY.tof02
 
        AFTER FIELD toj02
           IF NOT cl_null(l_newno2) THEN
              SELECT count(*) INTO l_n FROM tqa_file
               WHERE tqa01 = l_newno2
                 AND tqa03 = '2'
                 AND tqaacti = 'Y'
                  IF l_n = 0 THEN
                    CALL cl_err('',100,0)
                    LET g_toj.toj02 = g_toj02_t
                    DISPLAY BY NAME g_toj.toj02
                    NEXT FIELD toj02
                  END IF
           END IF
           SELECT tqa02 INTO l_tqa02 FROM tqa_file
            WHERE tqa01 = l_newno2
              AND tqa03 = '2'
              AND tqaacti='Y'
           DISPLAY l_tqa02 TO FORMONLY.tqa02
 
        BEGIN WORK
           SELECT COUNT(*) INTO l_n
             FROM toj_file
            WHERE toj01 = l_newno
              AND toj02 = l_newno2
           IF l_n>0 THEN
              CALL cl_err('',-239,0)
              NEXT FIELD toj01
           END IF
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(toj01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tof2"
                  LET g_qryparam.arg1='1'
                  LET g_qryparam.default1 = l_newno
                  CALL cl_create_qry() RETURNING l_newno
                  DISPLAY l_newno TO toj01
                  NEXT FIELD toj01
             WHEN INFIELD(toj02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1='2'
                  LET g_qryparam.default1 =l_newno2
                  CALL cl_create_qry() RETURNING l_newno2
                  DISPLAY l_newno2 TO toj02
                  NEXT FIELD toj02
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
       DISPLAY BY NAME g_toj.toj01
       DISPLAY BY NAME g_toj.toj02
       ROLLBACK WORK
       RETURN
    END IF
 
    DROP TABLE y
 
    SELECT * FROM toj_file         #單頭復制
        WHERE toj01=g_toj.toj01
          AND toj02=g_toj.toj02
        INTO TEMP y
 
    UPDATE y
        SET toj01=l_newno,    #新的鍵值
            toj02=l_newno2,
            tojuser=g_user,   #資料所有者
            tojgrup=g_grup,   #資料所有者所屬群
            tojmodu=NULL,     #資料修改日期
            tojdate=g_today,  #資料建立日期
            tojacti='Y'       #有效資料
 
    INSERT INTO toj_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
    #   CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("ins","toj_file",l_newno,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660104
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
 
    DROP TABLE x
 
    SELECT * FROM tok_file         #單身復制
        WHERE tok01=g_toj.toj01
          AND tok02=g_toj.toj02
        INTO TEMP x
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("ins","x",g_toj.toj01,g_toj.toj02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
 
    UPDATE x
        SET tok01=l_newno,
            tok02=l_newno2
 
    INSERT INTO tok_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tok_file",l_newno,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660104          #FUN-B80061    ADD
        ROLLBACK WORK #No:7857
    #   CALL cl_err(g_toj.toj01,SQLCA.sqlcode,0)  #No.FUN-660104
    #    CALL cl_err3("ins","tok_file",l_newno,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660104         #FUN-B80061    MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_toj.toj01
    LET l_oldno2= g_toj.toj02
    SELECT toj_file.* INTO g_toj.* FROM toj_file
     WHERE toj01 = l_newno
       AND toj02 = l_newno2
    CALL i211_u()
    CALL i211_b()
    #FUN-C80046---begin
    #SELECT * INTO g_toj.* FROM toj_file
    # WHERE toj01 = l_oldno
    #   AND toj02 = l_oldno2
    #CALL i211_show()
    #FUN-C80046---end
END FUNCTION
 
FUNCTION i211_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_tok06         LIKE tok_file.tok05,          #No.FUN-860012
    l_tok061        LIKE tok_file.tok05,          #No.FUN-860012
    l_tok062        LIKE tok_file.tok06,          #No.FUN-860012
    sr              RECORD
        toj01       LIKE toj_file.toj01,
        tof02       LIKE tof_file.tof02,
        toj02       LIKE toj_file.toj02,
        tqa02       LIKE tqa_file.tqa02,
        toj03       LIKE toj_file.toj03,
        tok03       LIKE tok_file.tok03,          #項次
        tok04       LIKE tok_file.tok04,          #省別
        too02       LIKE too_file.too02,          #省份名稱
        tok05       LIKE tok_file.tok05,          #人口數
        tok06       LIKE tok_file.tok06,          #收視率
        tok07       LIKE tok_file.tok07,          #生效日期
        tok08       LIKE tok_file.tok08,          #失效日期
        tok09       LIKE tok_file.tok09           #備注
       END RECORD,
    l_name          LIKE type_file.chr20         #No.FUN-680120 VARCHAR(20)                   #External(Disk) file name
 
    IF cl_null(g_toj.toj01) OR cl_null(g_toj.toj02) THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    IF cl_null(g_wc) THEN
        LET g_wc ="  toj01='",g_toj.toj01,"'"
    END IF
#No.FUN-860012---start---
#    CALL cl_wait()
#    CALL cl_outnam('atmi211') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT toj01,tof02,toj02,tqa02,toj03,",
          " tok03,tok04,too02,tok05,tok06,tok07,tok08,tok09",
          " FROM toj_file,tok_file,",
          " OUTER tof_file,OUTER tqa_file,OUTER too_file",
          " WHERE tok01=toj01 AND tok02=toj02 AND toj_file.toj01=tof_file.tof01",
          " AND toj_file.toj02=tqa_file.tqa01 AND tqa_file.tqa03='2' AND tof_file.tof21='1'",
          " AND tok_file.tok04=too_file.too01 AND ",g_wc CLIPPED,"AND ",g_wc2 CLIPPED
    PREPARE i211_p1 FROM g_sql              # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('i211_p1',STATUS,0) END IF
 
    DECLARE i211_co                         # CURSOR
        CURSOR FOR i211_p1
 
#    START REPORT i211_rep TO l_name
 
    FOREACH i211_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#        OUTPUT TO REPORT i211_rep(sr.*)
    LET l_tok061 = sr.tok05*sr.tok06
         SELECT SUM(tok05*tok06) INTO l_tok06
           FROM tok_file
          WHERE tok02 = sr.toj02
            AND tok05 IS NOT NULL
            AND tok06 IS NOT NULL
         LET l_tok062 = l_tok061/l_tok06
    EXECUTE insert_prep USING
        sr.toj01,sr.tof02,sr.toj02,sr.tqa02,sr.toj03,sr.tok03,sr.tok04,sr.too02,
        sr.tok05,sr.tok06,l_tok061,l_tok062,sr.tok07,sr.tok08,sr.tok09
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#----FUN-8A0067----#
#    CALL cl_wcchp(tm.wc,'toj01,toj02,toj03,tojuser,tojgrup,tojmodu,tojdate,tojacti')
#            RETURNING tm.wc
 
     CALL cl_wcchp(g_wc,'toj01,toj02,toj03,tojuser,tojgrup,tojmodu,tojdate,tojacti')
             RETURNING g_wc
#    LET g_str=tm.wc
     LET g_str=g_wc
#----FUN-8A0067----# 
     CALL cl_prt_cs3('atmi211','atmi211',g_sql,g_str)
#    FINISH REPORT i211_rep
 
#    CLOSE i211_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i211_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#   l_i             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#   l_tok06         LIKE tok_file.tok05,
#   l_tok061        LIKE tok_file.tok05,
#   l_tok062        LIKE tok_file.tok06,
#   sr              RECORD
#       toj01       LIKE toj_file.toj01,
#       tof02       LIKE tof_file.tof02,
#       toj02       LIKE toj_file.toj02,
#       tqa02       LIKE tqa_file.tqa02,
#       toj03       LIKE toj_file.toj03,
#       tok03       LIKE tok_file.tok03,          #項次
#       tok04       LIKE tok_file.tok04,          #省別
#       too02       LIKE too_file.too02,          #省份名稱
#       tok05       LIKE tok_file.tok05,          #人口數
#       tok06       LIKE tok_file.tok06,          #收視率
#       tok07       LIKE tok_file.tok07,          #生效日期
#       tok08       LIKE tok_file.tok08,          #失效日期
#       tok09       LIKE tok_file.tok09           #備注
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.toj01,sr.toj02,sr.tok03
#   FORMAT
#   PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_dash[1,g_len]
#     LET l_trailer_sw = 'y'
 
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#     PRINT g_dash1
 
#     BEFORE GROUP OF sr.toj01
#     BEFORE GROUP OF sr.toj02
#
#        PRINT COLUMN g_c[31],sr.toj01 CLIPPED,
#              COLUMN g_c[32],sr.tof02 CLIPPED,
#              COLUMN g_c[33],sr.toj02 CLIPPED,
#              COLUMN g_c[34],sr.tqa02 CLIPPED,
#              COLUMN g_c[35],sr.toj03 CLIPPED;
 
#     ON EVERY ROW
#        LET l_tok061 = sr.tok05*sr.tok06
#        SELECT SUM(tok05*tok06) INTO l_tok06
#          FROM tok_file
#         WHERE tok02 = sr.toj02
#           AND tok05 IS NOT NULL
#           AND tok06 IS NOT NULL
#        LET l_tok062 = l_tok061/l_tok06
 
#        PRINT COLUMN g_c[36],sr.tok03 USING '####',
#              COLUMN g_c[37],sr.tok04 CLIPPED,
#              COLUMN g_c[38],sr.too02 CLIPPED,
#              COLUMN g_c[39],sr.tok05 USING '##########',
#              COLUMN g_c[40],sr.tok06 CLIPPED,
#              COLUMN g_c[41],l_tok061 USING '##########',
#              COLUMN g_c[42],l_tok062 CLIPPED,
#              COLUMN g_c[43],sr.tok07 CLIPPED,
#              COLUMN g_c[44],sr.tok08 CLIPPED,
#              COLUMN g_c[45],sr.tok09
 
#     ON LAST ROW
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#     AFTER  GROUP OF sr.toj02
#        PRINT g_dash2[1,g_len]
 
#     PAGE TRAILER
#          IF l_trailer_sw = 'y' THEN
#             PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#          ELSE
#             SKIP 2 LINE
#          END IF
#END REPORT
#No.FUN-860012---end---
 
FUNCTION i211_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("toj01,toj02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i211_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("toj01,toj02",FALSE)
    END IF
 
END FUNCTION
 
