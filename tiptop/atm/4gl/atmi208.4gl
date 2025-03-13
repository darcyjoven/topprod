# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi208.4gl
# Descriptions...: 廣告地區資料維護作業
# Date & Author..: 05/10/19 By jackie
# Modify.........: No.TQC-650031 06/05/12 By Ravyen 修改有資料情況下打印顯示無資料可打印的情況
# Modify.........: No.FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780056 07/07/23 By mike 報表格式修改為p_query
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/18 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-940020 09/05/07 By mike 無效資料刪除時報的錯不對 
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
    g_tod           RECORD LIKE tod_file.*,
    g_tod_t         RECORD LIKE tod_file.*,
    g_tod_o         RECORD LIKE tod_file.*,
    g_tod01_t       LIKE tod_file.tod01,          #區域
    g_tod02_t       LIKE tod_file.tod02,          #省別
    g_tod03_t       LIKE tod_file.tod03,          #地級市
    g_tod04_t       LIKE tod_file.tod04,          #縣
    g_ydate         LIKE type_file.dat,           #No.FUN-680120 DATE                        #單據日期(沿用)
    g_toe           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        toe05       LIKE toe_file.toe05,          #品牌
        toe06       LIKE toe_file.toe06,          #標准營業額
        toe07       LIKE toe_file.toe07,          #備注
        #FUN-840068 --start---
        toeud01     LIKE toe_file.toeud01,
        toeud02     LIKE toe_file.toeud02,
        toeud03     LIKE toe_file.toeud03,
        toeud04     LIKE toe_file.toeud04,
        toeud05     LIKE toe_file.toeud05,
        toeud06     LIKE toe_file.toeud06,
        toeud07     LIKE toe_file.toeud07,
        toeud08     LIKE toe_file.toeud08,
        toeud09     LIKE toe_file.toeud09,
        toeud10     LIKE toe_file.toeud10,
        toeud11     LIKE toe_file.toeud11,
        toeud12     LIKE toe_file.toeud12,
        toeud13     LIKE toe_file.toeud13,
        toeud14     LIKE toe_file.toeud14,
        toeud15     LIKE toe_file.toeud15
        #FUN-840068 --end--
                    END RECORD,
    g_toe_t         RECORD                        #程式變數 (舊值)
        toe05       LIKE toe_file.toe05,          #品牌
        toe06       LIKE toe_file.toe06,          #標准營業額
        toe07       LIKE toe_file.toe07,          #備注
        #FUN-840068 --start---
        toeud01     LIKE toe_file.toeud01,
        toeud02     LIKE toe_file.toeud02,
        toeud03     LIKE toe_file.toeud03,
        toeud04     LIKE toe_file.toeud04,
        toeud05     LIKE toe_file.toeud05,
        toeud06     LIKE toe_file.toeud06,
        toeud07     LIKE toe_file.toeud07,
        toeud08     LIKE toe_file.toeud08,
        toeud09     LIKE toe_file.toeud09,
        toeud10     LIKE toe_file.toeud10,
        toeud11     LIKE toe_file.toeud11,
        toeud12     LIKE toe_file.toeud12,
        toeud13     LIKE toe_file.toeud13,
        toeud14     LIKE toe_file.toeud14,
        toeud15     LIKE toe_file.toeud15
        #FUN-840068 --end--
                    END RECORD,
    g_toe_o         RECORD                        #程式變數 (舊值)
        toe05       LIKE toe_file.toe05,          #品牌
        toe06       LIKE toe_file.toe06,          #標准營業額
        toe07       LIKE toe_file.toe07,          #備注
        #FUN-840068 --start---
        toeud01     LIKE toe_file.toeud01,
        toeud02     LIKE toe_file.toeud02,
        toeud03     LIKE toe_file.toeud03,
        toeud04     LIKE toe_file.toeud04,
        toeud05     LIKE toe_file.toeud05,
        toeud06     LIKE toe_file.toeud06,
        toeud07     LIKE toe_file.toeud07,
        toeud08     LIKE toe_file.toeud08,
        toeud09     LIKE toe_file.toeud09,
        toeud10     LIKE toe_file.toeud10,
        toeud11     LIKE toe_file.toeud11,
        toeud12     LIKE toe_file.toeud12,
        toeud13     LIKE toe_file.toeud13,
        toeud14     LIKE toe_file.toeud14,
        toeud15     LIKE toe_file.toeud15
        #FUN-840068 --end--
                    END RECORD,
#    g_wc,g_wc2,g_sql    LIKE type_file.chr1000, #NO.TQC-630166 MARK       #No.FUN-680120 VARCHAR(600)
    g_wc,g_wc2,g_sql     STRING,     #NO.TQC-630166 
    g_rec_b         LIKE type_file.num5,                       #單身筆數   #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                        #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5                        #No.FUN-680120 SMALLINT
 
DEFINE   g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_before_input_done  LIKE type_file.num5     #No.FUN-680120 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680120 VARCHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #總筆數          #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #查詢指定的筆數  #No.FUN-680120 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #是否開啟指定筆視窗        #No.FUN-680120 SMALLINT
 
 
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
 
 
 
    LET g_forupd_sql = "SELECT * FROM tod_file WHERE tod01 = ? AND tod02 =? AND tod03 =? AND tod04 =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i208_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 9
 
    OPEN WINDOW i208_w AT p_row,p_col              #顯示畫面
        WITH FORM "atm/42f/atmi208"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
 
    CALL i208_menu()
    CLOSE WINDOW i208_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION i208_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_toe.clear()
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tod.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON tod01,tod02,tod03,tod04,tod05,tod06,tod07,tod08,
                             tod09,tod10,tod11,
                             toduser,todgrup,todmodu,toddate,todacti,
                             #FUN-840068   ---start---
                             todud01,todud02,todud03,todud04,todud05,
                             todud06,todud07,todud08,todud09,todud10,
                             todud11,todud12,todud13,todud14,todud15
                             #FUN-840068    ----end----
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
             WHEN INFIELD(tod01)     #區域
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_geo"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tod01
                 NEXT FIELD tod01
             WHEN INFIELD(tod02)     #省別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1 = g_tod.tod01
                 LET g_qryparam.form ="q_too1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tod02
                 NEXT FIELD tod02
             WHEN INFIELD(tod03)      #地級市
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1 = g_tod.tod02
                 LET g_qryparam.form ="q_top1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tod03
                 NEXT FIELD tod03
             WHEN INFIELD(tod04) #縣
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1 = g_tod.tod03
                 LET g_qryparam.form ="q_toq"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tod04
                 NEXT FIELD tod04
            WHEN INFIELD(tod05)   #城市類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '4'
                 LET g_qryparam.form = "q_toa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tod05
                 NEXT FIELD tod05
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
   #      LET g_wc = g_wc clipped," AND toduser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND todgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND todgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('toduser', 'todgrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON toe05,toe06,toe07              #螢幕上取單身條件
             #No.FUN-840068 --start--
             ,toeud01,toeud02,toeud03,toeud04,toeud05
             ,toeud06,toeud07,toeud08,toeud09,toeud10
             ,toeud11,toeud12,toeud13,toeud14,toeud15
             #No.FUN-840068 ---end---
           FROM s_toe[1].toe05,s_toe[1].toe06,s_toe[1].toe07
                #No.FUN-840068 --start--
                ,s_toe[1].toeud01,s_toe[1].toeud02,s_toe[1].toeud03
                ,s_toe[1].toeud04,s_toe[1].toeud05,s_toe[1].toeud06
                ,s_toe[1].toeud07,s_toe[1].toeud08,s_toe[1].toeud09
                ,s_toe[1].toeud10,s_toe[1].toeud11,s_toe[1].toeud12
                ,s_toe[1].toeud13,s_toe[1].toeud14,s_toe[1].toeud15
                #No.FUN-840068 ---end---
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(toe05) #品牌
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1='2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO toe05
                 NEXT FIELD toe05
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
      LET g_sql = "SELECT  tod01,tod02,tod03,tod04 FROM tod_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tod01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT  tod01,tod02,tod03,tod04 ",
                  "  FROM tod_file, toe_file ",
                  " WHERE tod01 = toe01 AND tod02=toe02 AND tod03=toe03 ",
                  " AND tod04=toe04 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tod01"
   END IF
 
   PREPARE i208_prepare FROM g_sql
   DECLARE i208_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i208_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
#     LET g_sql="SELECT tod01,tod02,tod03,tod04 FROM tod_file ",      #No.TQC-720019
      LET g_sql_tmp="SELECT tod01,tod02,tod03,tod04 FROM tod_file ",  #No.TQC-720019
                    " WHERE ",g_wc CLIPPED,
                    " GROUP BY tod01,tod02,tod03,tod04",
                    " INTO TEMP z "
   ELSE
#     LET g_sql="SELECT tod01,tod02,tod03,tod04 ",      #No.TQC-720019
      LET g_sql_tmp="SELECT tod01,tod02,tod03,tod04 ",  #No.TQC-720019
                    " FROM tod_file,toe_file WHERE ",
                    " toe01=tod01 AND toe02=tod02 AND toe03=tod03 ",
                    " AND toe04=tod04 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " GROUP BY tod01,tod02,tod03,tod04 ",
                    " INTO TEMP z "
   END IF
   DROP TABLE z
#  PREPARE i208_precount_z FROM g_sql      #No.TQC-720019
   PREPARE i208_precount_z FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i208_precount_z
 
   LET g_sql="SELECT COUNT(*) FROM z "
 
   PREPARE i208_precount FROM g_sql
   DECLARE i208_count CURSOR FOR i208_precount
 
END FUNCTION
 
FUNCTION i208_menu()
 DEFINE   l_cmd    STRING     #No.FUN-780056
 
   WHILE TRUE
      CALL i208_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i208_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i208_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i208_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i208_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i208_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i208_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i208_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i208_out()                                    #No.FUN-780056
               IF cl_null(g_wc) THEN LET g_wc='1=1' END IF         #No.FUN-780056
               LET l_cmd = 'p_query "atmi208" "',g_wc CLIPPED,'"'  #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                               #No.FUN-780056
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_toe),'','')
            END IF
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tod.tod01 IS NOT NULL THEN
                 LET g_doc.column1 = "tod01"
                 LET g_doc.value1 = g_tod.tod01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i208_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_toe.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_tod.* LIKE tod_file.*             #DEFAULT 設定
   LET g_tod01_t = NULL
   LET g_tod02_t = NULL
   LET g_tod03_t = NULL
   LET g_tod04_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_tod_t.* = g_tod.*
   LET g_tod_o.* = g_tod.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tod.toduser=g_user
      LET g_tod.todoriu = g_user #FUN-980030
      LET g_tod.todorig = g_grup #FUN-980030
      LET g_tod.todgrup=g_grup
      LET g_tod.toddate=g_today
      LET g_tod.todacti='Y'              #資料有效
 
      CALL i208_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tod.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_tod.tod01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      INSERT INTO tod_file VALUES (g_tod.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        
         CALL cl_err3("ins","tod_file",g_tod.tod01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104      #FUN-B80061   ADD
         ROLLBACK WORK
      #  CALL cl_err('',SQLCA.sqlcode,1)  #No.FUN-660104
      #   CALL cl_err3("ins","tod_file",g_tod.tod01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104     #FUN-B80061   MARK 
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
 
      SELECT tod01,tod02,tod03,tod04 INTO g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04 FROM tod_file
       WHERE tod01 = g_tod.tod01
         AND tod02 = g_tod.tod02
         AND tod03 = g_tod.tod03
         AND tod04 = g_tod.tod04
      LET g_tod01_t = g_tod.tod01        #保留舊值
      LET g_tod02_t = g_tod.tod02        #保留舊值
      LET g_tod03_t = g_tod.tod03        #保留舊值
      LET g_tod04_t = g_tod.tod04        #保留舊值
      LET g_tod_t.* = g_tod.*
      LET g_tod_o.* = g_tod.*
      CALL g_toe.clear()
 
      LET g_rec_b = 0
      CALL i208_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i208_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tod.tod01 IS NULL OR g_tod.tod02 IS NULL
      OR g_tod.tod03 IS NULL OR g_tod.tod04 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_tod.* FROM tod_file
    WHERE tod01 = g_tod.tod01
      AND tod02 = g_tod.tod02
      AND tod03 = g_tod.tod03
      AND tod04 = g_tod.tod04
 
   IF g_tod.todacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err('','mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tod01_t = g_tod.tod01
   LET g_tod02_t = g_tod.tod02
   LET g_tod03_t = g_tod.tod03
   LET g_tod04_t = g_tod.tod04
 
   BEGIN WORK
 
   OPEN i208_cl USING g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04
   IF STATUS THEN
      CALL cl_err("OPEN i208_cl:", STATUS, 1)
      CLOSE i208_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i208_cl INTO g_tod.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i208_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i208_show()
 
   WHILE TRUE
      LET g_tod01_t = g_tod.tod01
      LET g_tod02_t = g_tod.tod02
      LET g_tod03_t = g_tod.tod03
      LET g_tod04_t = g_tod.tod04
      LET g_tod_o.* = g_tod.*
      LET g_tod.todmodu=g_user
      LET g_tod.toddate=g_today
 
      CALL i208_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tod.*=g_tod_t.*
         CALL i208_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_tod.tod01 != g_tod01_t OR g_tod.tod02 != g_tod02_t
         OR g_tod.tod03 != g_tod03_t OR g_tod.tod04 != g_tod04_t THEN
         UPDATE toe_file SET toe01 = g_tod.tod01,
                             toe02 = g_tod.tod02,
                             toe03 = g_tod.tod03,
                             toe04 = g_tod.tod04
                       WHERE toe01 = g_tod01_t AND toe02 = g_tod02_t
                         AND toe03 = g_tod03_t AND toe04 = g_tod04_t
 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #  CALL cl_err('toe',SQLCA.sqlcode,0)  #No.FUN-660104
            CALL cl_err3("upd","toe_file",g_tod01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE tod_file SET tod_file.* = g_tod.*
       WHERE tod01 = g_tod01_t AND tod02 =g_tod02_t AND tod03 =g_tod03_t AND tod04 =g_tod04_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #  CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","tod_file",g_tod.tod01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i208_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i208_i(p_cmd)
DEFINE
   l_n            LIKE type_file.num5,          #No.FUN-680120 SMALLINT
   p_cmd           LIKE type_file.chr1          #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_tod.toduser,g_tod.todmodu,
                   g_tod.todgrup,g_tod.toddate,g_tod.todacti
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04, g_tod.todoriu,g_tod.todorig,
                 g_tod.tod05,g_tod.tod06,g_tod.tod07,g_tod.tod08,
                 g_tod.tod09,g_tod.tod10,g_tod.tod11,
                 #FUN-840068     ---start---
                 g_tod.todud01,g_tod.todud02,g_tod.todud03,g_tod.todud04,
                 g_tod.todud05,g_tod.todud06,g_tod.todud07,g_tod.todud08,
                 g_tod.todud09,g_tod.todud10,g_tod.todud11,g_tod.todud12,
                 g_tod.todud13,g_tod.todud14,g_tod.todud15 
                 #FUN-840068     ----end----
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i208_set_entry(p_cmd)
         CALL i208_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD tod01
         IF NOT cl_null(g_tod.tod01) THEN
            IF cl_null(g_tod_o.tod01) OR
               (g_tod.tod01 != g_tod_o.tod01 ) THEN
               SELECT count(*) INTO l_n FROM geo_file 
                WHERE geo01 = g_tod.tod01
                IF l_n = 0 THEN
                   CALL cl_err('','atm-301',0)
                   LET g_tod.tod01 = g_tod01_t
                   DISPLAY BY NAME g_tod.tod01
                   NEXT FIELD tod01
                END IF
                CALL i208_tod01('d')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_tod.tod01 = g_tod_o.tod01
                   DISPLAY BY NAME g_tod.tod01
                   NEXT FIELD tod01
                END IF
            END IF
         END IF
 
      AFTER FIELD tod02
         IF NOT cl_null(g_tod.tod02) THEN
            IF cl_null(g_tod_o.tod02) OR
               (g_tod.tod02 != g_tod_o.tod02 ) THEN
            SELECT count(*) INTO l_n FROM too_file
                WHERE too01 = g_tod.tod02
                  AND too03 = g_tod.tod01
                  AND tooacti = 'Y'
                IF l_n = 0 THEN
                  CALL cl_err('','atm-111',0)
                  LET g_tod.tod02 = g_tod02_t
                  DISPLAY BY NAME g_tod.tod02
                  NEXT FIELD tod02
                END IF
               CALL i208_tod02('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_tod.tod02 = g_tod_o.tod02
                  DISPLAY BY NAME g_tod.tod02
                  NEXT FIELD tod02
               END IF
            END IF
         END IF
 
      AFTER FIELD tod03
         IF NOT cl_null(g_tod.tod03) THEN
            IF g_tod_o.tod03 IS NULL OR
               (g_tod.tod03 != g_tod_o.tod03 ) THEN
            SELECT count(*) INTO l_n FROM top_file
                WHERE top01 = g_tod.tod03
                  AND top03 = g_tod.tod02
                  AND topacti='Y'
                IF l_n = 0 THEN
                  CALL cl_err('','atm-112',0)
                  LET g_tod.tod03 = g_tod03_t
                  DISPLAY BY NAME g_tod.tod03
                  NEXT FIELD tod03
                END IF
               CALL i208_tod03('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_tod.tod03 = g_tod_o.tod03
                  DISPLAY BY NAME g_tod.tod03
                  NEXT FIELD tod03
               END IF
            END IF
         END IF
 
      AFTER FIELD tod04
         IF NOT cl_null(g_tod.tod04) THEN
            IF g_tod_o.tod04 IS NULL OR
               (g_tod_o.tod04 != g_tod.tod04 ) THEN
            SELECT count(*) INTO l_n FROM toq_file
                WHERE toq01 = g_tod.tod04
                  AND toq03 = g_tod.tod03
                  AND toqacti = 'Y'
                IF l_n = 0 THEN
                  CALL cl_err('','atm-302',0)
                  LET g_tod.tod04 = g_tod04_t
                  DISPLAY BY NAME g_tod.tod04
                  NEXT FIELD tod04
                END IF
            SELECT count(*) INTO l_n FROM tod_file
                WHERE tod01 = g_tod.tod01
                  and tod02 = g_tod.tod02
                  and tod03 = g_tod.tod03
                  and tod04 = g_tod.tod04
                IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD tod01
                END IF
               CALL i208_tod04('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_tod.tod04 = g_tod_o.tod04
                  DISPLAY BY NAME g_tod.tod04
                  NEXT FIELD tod04
               END IF
            END IF
         END IF
 
      AFTER FIELD tod05
         IF cl_null(g_tod.tod05) THEN
            DISPLAY '' TO FORMONLY.toa02
         END IF
         IF NOT cl_null(g_tod.tod05) THEN
            IF g_tod_o.tod05 IS NULL OR
               (g_tod_o.tod05 != g_tod.tod05 ) THEN
            SELECT count(*) INTO l_n FROM toa_file
                WHERE toa01 = g_tod.tod05
                  AND toa03='4'
                  AND toaacti = 'Y'
                IF l_n = 0 THEN
                  CALL cl_err('','atm-304',0)
                  LET g_tod.tod05 = g_tod_t.tod05
                  DISPLAY BY NAME g_tod.tod05
                  NEXT FIELD tod05
                END IF
                CALL i208_tod05('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_tod.tod05 = g_tod_o.tod05
                  DISPLAY BY NAME g_tod.tod05
                  NEXT FIELD tod05
               END IF
            END IF
         END IF
 
      AFTER FIELD tod06
         IF NOT cl_null(g_tod.tod06) THEN
            IF g_tod.tod06<=0 THEN
              CALL cl_err('','atm-114',0)
              NEXT FIELD tod06
            END IF
         END IF
 
      AFTER FIELD tod07
         IF NOT cl_null(g_tod.tod07) THEN
            IF g_tod.tod07<=0 THEN
              CALL cl_err('','atm-114',0)
              NEXT FIELD tod07
            END IF
         END IF
 
      AFTER FIELD tod08
         IF NOT cl_null(g_tod.tod08) THEN
            IF g_tod.tod08<=0 THEN
              CALL cl_err('','atm-114',0)
              NEXT FIELD tod08
            END IF
         END IF
 
      AFTER FIELD tod09
         IF NOT cl_null(g_tod.tod09) THEN
            IF g_tod.tod09<=0 THEN
              CALL cl_err('','atm-114',0)
              NEXT FIELD tod09
            END IF
         END IF
 
      AFTER FIELD tod10
         IF NOT cl_null(g_tod.tod10) THEN
            IF g_tod.tod10<=0 THEN
              CALL cl_err('','atm-114',0)
              NEXT FIELD tod10
            END IF
            IF g_tod.tod10 > g_tod.tod08 THEN
              CALL cl_err('','atm-118',0)
              NEXT FIELD tod10
            END IF
         END IF
 
        #FUN-840068     ---start---
        AFTER FIELD todud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD todud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON ACTION controlp
         CASE
             WHEN INFIELD(tod01)     #區域
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geo"
                 LET g_qryparam.default1 = g_tod.tod01
                 CALL cl_create_qry() RETURNING g_tod.tod01
                 DISPLAY BY NAME g_tod.tod01
                 NEXT FIELD tod01
             WHEN INFIELD(tod02)     #省別
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_tod.tod01
                 LET g_qryparam.form ="q_too1"
                 CALL cl_create_qry() RETURNING g_tod.tod02
                 DISPLAY BY NAME g_tod.tod02
                 NEXT FIELD tod02
             WHEN INFIELD(tod03)      #地級市
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_tod.tod02
                 LET g_qryparam.form ="q_top1"
                 CALL cl_create_qry() RETURNING g_tod.tod03
                 DISPLAY BY NAME g_tod.tod03
                 NEXT FIELD tod03
             WHEN INFIELD(tod04) #縣
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_tod.tod03
                 LET g_qryparam.form ="q_toq"
                 CALL cl_create_qry() RETURNING g_tod.tod04
                 DISPLAY BY NAME g_tod.tod04
                 NEXT FIELD tod04
            WHEN INFIELD(tod05)   #城市類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '4'
                 LET g_qryparam.form = "q_toa"
                 CALL cl_create_qry() RETURNING g_tod.tod05
                 DISPLAY BY NAME g_tod.tod05
                 NEXT FIELD tod05
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
 
FUNCTION i208_tod01(p_cmd)  #區域
   DEFINE l_geo01   LIKE geo_file.geo01,
          l_geo02   LIKE geo_file.geo02,
          l_geoacti LIKE geo_file.geoacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   LET g_errno = ' '
 
   SELECT geo01,geo02,geoacti
     INTO l_geo01,l_geo02,l_geoacti
     FROM geo_file WHERE geo01=g_tod.tod01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 100
                                  LET l_geo01 = NULL
        WHEN l_geoacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_geo02 TO FORMONLY.gea02
   END IF
 
END FUNCTION
 
FUNCTION i208_tod02(p_cmd)  #
   DEFINE l_too01   LIKE too_file.too01,
          l_too02   LIKE too_file.too02,
          l_tooacti LIKE too_file.tooacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   LET g_errno = ' '
 
   SELECT too01,too02,tooacti
     INTO l_too01,l_too02,l_tooacti
     FROM too_file WHERE too01=g_tod.tod02
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 100
                                  LET l_too01 = NULL
        WHEN l_tooacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_too02 TO FORMONLY.too02
   END IF
 
END FUNCTION
 
FUNCTION i208_tod03(p_cmd)  #
   DEFINE l_top01   LIKE top_file.top01,
          l_top02   LIKE top_file.top02,
          l_topacti LIKE top_file.topacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   LET g_errno = ' '
 
   SELECT top01,top02,topacti
     INTO l_top01,l_top02,l_topacti
     FROM top_file WHERE top01=g_tod.tod03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 100
                                  LET l_top01 = NULL
        WHEN l_topacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_top02 TO FORMONLY.top02
   END IF
 
END FUNCTION
 
FUNCTION i208_tod04(p_cmd)  #
   DEFINE l_toq01   LIKE toq_file.toq01,
          l_toq02   LIKE toq_file.toq02,
          l_toqacti LIKE toq_file.toqacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   LET g_errno = ' '
 
   SELECT toq01,toq02,toqacti
     INTO l_toq01,l_toq02,l_toqacti
     FROM toq_file WHERE toq01=g_tod.tod04
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 100
                                  LET l_toq01 = NULL
        WHEN l_toqacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_toq02 TO FORMONLY.toq02
   END IF
 
END FUNCTION
 
FUNCTION i208_tod05(p_cmd)  #
   DEFINE l_toa01   LIKE toa_file.toa01,
          l_toa02   LIKE toa_file.toa02,
          l_toaacti LIKE toa_file.toaacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   LET g_errno = ' '
 
   SELECT toa01,toa02,toaacti
     INTO l_toa01,l_toa02,l_toaacti
     FROM toa_file WHERE toa01=g_tod.tod05
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 100
                                  LET l_toa01 = NULL
        WHEN l_toaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_toa02 TO FORMONLY.toa02
   END IF
 
END FUNCTION
 
FUNCTION i208_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tod.* TO NULL              #No.FUN-6B0043
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_toe.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i208_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tod.* TO NULL
      RETURN
   END IF
 
   OPEN i208_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tod.* TO NULL
   ELSE
      OPEN i208_count
      FETCH i208_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i208_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i208_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i208_cs INTO g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04 
      WHEN 'P' FETCH PREVIOUS i208_cs INTO g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04 
      WHEN 'F' FETCH FIRST    i208_cs INTO g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04 
      WHEN 'L' FETCH LAST     i208_cs INTO g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04 
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
            FETCH ABSOLUTE g_jump i208_cs INTO g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04 
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tod.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_tod.* FROM tod_file WHERE tod01 = g_tod.tod01 AND tod02 =g_tod.tod02 AND tod03 =g_tod.tod03 AND tod04 =g_tod.tod04
   IF SQLCA.sqlcode THEN
   #  CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660104
      CALL cl_err3("sel","tod_file",g_tod.tod01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
      INITIALIZE g_tod.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_tod.toduser
   LET g_data_group = g_tod.todgrup
 
   CALL i208_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i208_show()
   LET g_tod_t.* = g_tod.*                #保存單頭舊值
   LET g_tod_o.* = g_tod.*                #保存單頭舊值
   DISPLAY BY NAME g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04, g_tod.todoriu,g_tod.todorig,
                   g_tod.tod05,g_tod.tod06,g_tod.tod07,g_tod.tod08,
                   g_tod.tod09,g_tod.tod10,g_tod.tod11,
                   g_tod.toduser,g_tod.todgrup,g_tod.todmodu,
                   g_tod.toddate,g_tod.todacti,
                   #FUN-840068     ---start---
                   g_tod.todud01,g_tod.todud02,g_tod.todud03,g_tod.todud04,
                   g_tod.todud05,g_tod.todud06,g_tod.todud07,g_tod.todud08,
                   g_tod.todud09,g_tod.todud10,g_tod.todud11,g_tod.todud12,
                   g_tod.todud13,g_tod.todud14,g_tod.todud15 
                   #FUN-840068     ----end----
 
   CALL i208_tod01('d')
   CALL i208_tod02('d')
   CALL i208_tod03('d')
   CALL i208_tod04('d')
   CALL i208_tod05('d')
 
   CALL i208_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i208_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tod.tod01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i208_cl USING g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04
   IF STATUS THEN
      CALL cl_err("OPEN i208_cl:", STATUS, 1)
      CLOSE i208_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i208_cl INTO g_tod.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i208_show()
 
   IF cl_exp(0,0,g_tod.todacti) THEN                   #確認一下
      LET g_chr=g_tod.todacti
      IF g_tod.todacti='Y' THEN
         LET g_tod.todacti='N'
      ELSE
         LET g_tod.todacti='Y'
      END IF
 
      UPDATE tod_file SET todacti=g_tod.todacti,
                          todmodu=g_user,
                          toddate=g_today
       WHERE tod01=g_tod.tod01
         AND tod02=g_tod.tod02
         AND tod03=g_tod.tod03
         AND tod04=g_tod.tod04
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("upd","tod_file",g_tod.tod01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
         LET g_tod.todacti=g_chr
      END IF
   END IF
 
   CLOSE i208_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT todacti,todmodu,toddate
     INTO g_tod.todacti,g_tod.todmodu,g_tod.toddate FROM tod_file
    WHERE tod01=g_tod.tod01
      AND tod02=g_tod.tod02
      AND tod03=g_tod.tod03
      AND tod04=g_tod.tod04
   DISPLAY BY NAME g_tod.todacti,g_tod.todmodu,g_tod.toddate
 
END FUNCTION
 
FUNCTION i208_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tod.tod01 IS NULL OR g_tod.tod02 IS NULL
     OR g_tod.tod03 IS NULL OR g_tod.tod04 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_tod.* FROM tod_file
    WHERE tod01=g_tod.tod01
      AND tod02=g_tod.tod02
      AND tod03=g_tod.tod03
      AND tod04=g_tod.tod04
   IF g_tod.todacti ='N' THEN    #檢查資料是否為無效
   #  CALL cl_err('','mfg1000',0)  #No.FUN-660104
     #CALL cl_err3("sel","tod_file",g_tod.tod01,"","mfg1000","","",1)  #No.FUN-660104 #TQC-940020                                   
      CALL cl_err('','abm-950',0) #TQC-940020                                                    
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i208_cl USING g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04
   IF STATUS THEN
      CALL cl_err("OPEN i208_cl:", STATUS, 1)
      CLOSE i208_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i208_cl INTO g_tod.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i208_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tod01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tod.tod01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM tod_file WHERE tod01 = g_tod.tod01
                             AND tod02 = g_tod.tod02
                             AND tod03 = g_tod.tod03
                             AND tod04 = g_tod.tod04
 
      DELETE FROM toe_file WHERE toe01 = g_tod.tod01
                             AND toe02 = g_tod.tod02
                             AND toe03 = g_tod.tod03
                             AND toe04 = g_tod.tod04
      DROP TABLE z                             #No.TQC-720019
      PREPARE i208_precount_z2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i208_precount_z2                 #No.TQC-720019
      CLEAR FORM
      CALL g_toe.clear()
      DROP TABLE z
      EXECUTE i208_precount_z
      OPEN i208_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i208_cs
         CLOSE i208_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i208_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i208_cs
         CLOSE i208_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i208_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i208_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i208_fetch('/')
      END IF
   END IF
 
   CLOSE i208_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tod.tod01,'D')
END FUNCTION
 
#單身
FUNCTION i208_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1) #TQC-840066
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否         #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_tod.tod01 IS NULL OR g_tod.tod02 IS NULL
       OR g_tod.tod03 IS NULL OR g_tod.tod04 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_tod.* FROM tod_file
     WHERE tod01=g_tod.tod01
       AND tod02=g_tod.tod02
       AND tod03=g_tod.tod03
       AND tod04=g_tod.tod04
 
    IF g_tod.todacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT toe05,toe06,toe07, ",
                       #No.FUN-840068 --start--
                       "       toeud01,toeud02,toeud03,toeud04,toeud05,",
                       "       toeud06,toeud07,toeud08,toeud09,toeud10,",
                       "       toeud11,toeud12,toeud13,toeud14,toeud15", 
                       #No.FUN-840068 ---end---
                       "  FROM toe_file",
                       "  WHERE toe01=? AND toe02=? AND toe03=? ",
                       " AND toe04=? AND toe05=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i208_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_toe WITHOUT DEFAULTS FROM s_toe.*
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
 
           OPEN i208_cl USING g_tod.tod01,g_tod.tod02,g_tod.tod03,g_tod.tod04
           IF STATUS THEN
              CALL cl_err("OPEN i208_cl:", STATUS, 1)
              CLOSE i208_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i208_cl INTO g_tod.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err('',SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i208_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_toe_t.* = g_toe[l_ac].*  #BACKUP
              LET g_toe_o.* = g_toe[l_ac].*  #BACKUP
              OPEN i208_bcl USING g_tod.tod01,g_tod.tod02,
                                  g_tod.tod03,g_tod.tod04,g_toe_t.toe05
              IF STATUS THEN
                 CALL cl_err("OPEN i208_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i208_bcl INTO g_toe[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_toe_t.toe05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_toe[l_ac].* TO NULL
           LET g_toe[l_ac].toe05 =  ' '            #Body default
           LET g_toe[l_ac].toe06 =  0              #Body default
           LET g_toe[l_ac].toe07 =  ' '            #Body default
           LET g_toe_t.* = g_toe[l_ac].*         #新輸入資料
           LET g_toe_o.* = g_toe[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD toe05
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO toe_file(toe01,toe02,toe03,toe04,toe05,toe06,
                                toe07,
                                #FUN-840068 --start--
                                toeud01,toeud02,toeud03,
                                toeud04,toeud05,toeud06,
                                toeud07,toeud08,toeud09,
                                toeud10,toeud11,toeud12,
                                toeud13,toeud14,toeud15)
                                #FUN-840068 --end--
           VALUES(g_tod.tod01,g_tod.tod02,
                  g_tod.tod03,g_tod.tod04,
                  g_toe[l_ac].toe05,g_toe[l_ac].toe06,
                  g_toe[l_ac].toe07,
                  #FUN-840068 --start--
                  g_toe[l_ac].toeud01,g_toe[l_ac].toeud02,
                  g_toe[l_ac].toeud03,g_toe[l_ac].toeud04,
                  g_toe[l_ac].toeud05,g_toe[l_ac].toeud06,
                  g_toe[l_ac].toeud07,g_toe[l_ac].toeud08,
                  g_toe[l_ac].toeud09,g_toe[l_ac].toeud10,
                  g_toe[l_ac].toeud11,g_toe[l_ac].toeud12,
                  g_toe[l_ac].toeud13,g_toe[l_ac].toeud14,
                  g_toe[l_ac].toeud15)
                  #FUN-840068 --end--
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_toe[l_ac].toe05,SQLCA.sqlcode,0)  #No.FUN-660104
              CALL cl_err3("ins","toe_file",g_toe[l_ac].toe05,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD toe05
        IF NOT cl_null(g_toe[l_ac].toe05) THEN
          IF g_toe[l_ac].toe05 != g_toe_t.toe05
              OR cl_null(g_toe_t.toe05) THEN
            SELECT count(*) INTO l_n FROM toe_file
               WHERE toe01=g_tod.tod01
                 AND toe02=g_tod.tod02
                 AND toe03=g_tod.tod03
                 AND toe04=g_tod.tod04
                 AND toe05=g_toe[l_ac].toe05
               IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_toe[l_ac].toe05 = g_toe_t.toe05
                 DISPLAY BY NAME g_toe[l_ac].toe05
                 NEXT FIELD toe05
               END IF
           END IF
            SELECT count(*) INTO l_n FROM tqa_file
                WHERE tqa01 = g_toe[l_ac].toe05
                   AND tqa03='2' AND tqaacti='Y'
                IF l_n = 0 THEN
                  CALL cl_err('','atm-303',0)
                  LET g_toe[l_ac].toe05 = g_toe_t.toe05
                  DISPLAY BY NAME g_toe[l_ac].toe05
                  NEXT FIELD toe05
                END IF
        END IF
 
        AFTER FIELD toe06
          IF NOT cl_null(g_toe[l_ac].toe06) THEN
            IF g_toe[l_ac].toe06 <= 0 THEN
              CALL cl_err('','atm-114',0)
               NEXT FIELD toe06
            END IF
          END IF
 
        #No.FUN-840068 --start--
        AFTER FIELD toeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD toeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF l_ac > 0 THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM toe_file
               WHERE toe01 = g_tod.tod01 and toe02= g_tod.tod02
                    and toe03= g_tod.tod03 and toe04=g_tod.tod04
                    and toe05= g_toe_t.toe05
              IF SQLCA.sqlcode THEN
              #  CALL cl_err(g_toe_t.toe05,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("del","toe_file",g_toe_t.toe05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
              LET g_toe[l_ac].* = g_toe_t.*
              CLOSE i208_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_toe[l_ac].toe05,-263,1)
              LET g_toe[l_ac].* = g_toe_t.*
           ELSE
              UPDATE toe_file SET toe05=g_toe[l_ac].toe05,
                                  toe06=g_toe[l_ac].toe06,
                                  toe07=g_toe[l_ac].toe07,
                                  #FUN-840068 --start--
                                  toeud01 = g_toe[l_ac].toeud01,
                                  toeud02 = g_toe[l_ac].toeud02,
                                  toeud03 = g_toe[l_ac].toeud03,
                                  toeud04 = g_toe[l_ac].toeud04,
                                  toeud05 = g_toe[l_ac].toeud05,
                                  toeud06 = g_toe[l_ac].toeud06,
                                  toeud07 = g_toe[l_ac].toeud07,
                                  toeud08 = g_toe[l_ac].toeud08,
                                  toeud09 = g_toe[l_ac].toeud09,
                                  toeud10 = g_toe[l_ac].toeud10,
                                  toeud11 = g_toe[l_ac].toeud11,
                                  toeud12 = g_toe[l_ac].toeud12,
                                  toeud13 = g_toe[l_ac].toeud13,
                                  toeud14 = g_toe[l_ac].toeud14,
                                  toeud15 = g_toe[l_ac].toeud15
                                  #FUN-840068 --end--
 
               WHERE toe01 = g_tod.tod01 and toe02= g_tod.tod02
                    and toe03= g_tod.tod03 and toe04=g_tod.tod04
                    and toe05= g_toe_t.toe05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #  CALL cl_err(g_toe[l_ac].toe05,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("upd","toe_file",g_toe[l_ac].toe05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_toe[l_ac].* = g_toe_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_toe[l_ac].* = g_toe_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_toe.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i208_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i208_bcl
           COMMIT WORK
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(toe05) AND l_ac > 1 THEN
              LET g_toe[l_ac].* = g_toe[l_ac-1].*
              NEXT FIELD toe05
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(toe05) #品牌
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqa"
                 LET g_qryparam.arg1='2'
                 LET g_qryparam.default1 = g_toe[l_ac].toe05
                 CALL cl_create_qry() RETURNING g_toe[l_ac].toe05
                 DISPLAY BY NAME g_toe[l_ac].toe05
                 NEXT FIELD toe05
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END        
    END INPUT
 
    CLOSE i208_bcl
    COMMIT WORK
#   CALL i208_delall() #CHI-C30002 mark
    CALL i208_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i208_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM tod_file WHERE tod01 = g_tod.tod01 and tod02=g_tod.tod02
                                and tod03 = g_tod.tod03 and tod04=g_tod.tod04
         INITIALIZE g_tod.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i208_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM toe_file
#    WHERE toe01 = g_tod.tod01 and toe02=g_tod.tod02
#         and toe03=g_tod.tod03 and toe04=g_tod.tod04
#
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM tod_file WHERE tod01 = g_tod.tod01 and tod02=g_tod.tod02
#                  and tod03 = g_tod.tod03 and tod04=g_tod.tod04
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i208_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON toe05,toe06,toe07
                       #No.FUN-840068 --start--
                       ,toeud01,toeud02,toeud03,toeud04,toeud05
                       ,toeud06,toeud07,toeud08,toeud09,toeud10
                       ,toeud11,toeud12,toeud13,toeud14,toeud15
                       #No.FUN-840068 ---end---
            FROM s_toe[1].toe05,s_toe[1].toe06,s_toe[1].toe07
                 #No.FUN-840068 --start--
                 ,s_toe[1].toeud01,s_toe[1].toeud02,s_toe[1].toeud03
                 ,s_toe[1].toeud04,s_toe[1].toeud05,s_toe[1].toeud06
                 ,s_toe[1].toeud07,s_toe[1].toeud08,s_toe[1].toeud09
                 ,s_toe[1].toeud10,s_toe[1].toeud11,s_toe[1].toeud12
                 ,s_toe[1].toeud13,s_toe[1].toeud14,s_toe[1].toeud15
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
 
    CALL i208_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i208_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
 
    LET g_sql = "SELECT toe05,toe06,toe07,",
                #No.FUN-840068 --start--
                "       toeud01,toeud02,toeud03,toeud04,toeud05,",
                "       toeud06,toeud07,toeud08,toeud09,toeud10,",
                "       toeud11,toeud12,toeud13,toeud14,toeud15", 
                #No.FUN-840068 ---end---
                " FROM toe_file",
                " WHERE toe01 ='",g_tod.tod01,"' ",
                "   and toe02 ='",g_tod.tod02,"' ",
                "   and toe03 ='",g_tod.tod03,"' ",
                "   and toe04 ='",g_tod.tod04,"' "
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY toe05 "
    DISPLAY g_sql
 
    PREPARE i208_pb FROM g_sql
    DECLARE toe_cs                       #CURSOR
        CURSOR FOR i208_pb
 
    CALL g_toe.clear()
    LET g_cnt = 1
 
    FOREACH toe_cs INTO g_toe[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_toe.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i208_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_toe TO s_toe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i208_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i208_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION jump
         CALL i208_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i208_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i208_fetch('L')
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
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i208_copy()
DEFINE
    l_newno1        LIKE tod_file.tod01,
    l_newno2        LIKE tod_file.tod02,
    l_newno3        LIKE tod_file.tod03,
    l_newno4        LIKE tod_file.tod04,
    l_oldno1        LIKE tod_file.tod01,
    l_oldno2        LIKE tod_file.tod02,
    l_oldno3        LIKE tod_file.tod03,
    l_oldno4        LIKE tod_file.tod04,
    l_gea02         LIKE gea_file.gea02,
    l_too02         LIKE too_file.too02,
    l_top02         LIKE top_file.top02,
    l_toq02         LIKE toq_file.toq02
 
    DEFINE   l_n         LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tod.tod01 IS NULL OR g_tod.tod02 IS NULL
       OR g_tod.tod03 IS NULL OR g_tod.tod04 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i208_set_entry('a')
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
    INPUT l_newno1,l_newno2,l_newno3,l_newno4 FROM tod01,tod02,tod03,tod04
 
        AFTER FIELD tod01
           IF NOT cl_null(l_newno1) THEN
             SELECT count(*) INTO l_n FROM geo_file 
              WHERE geo01 = l_newno1
                AND geoacti='Y'
               IF l_n = 0 THEN
                 CALL cl_err('','atm-301',0)
                 LET g_tod.tod01 = g_tod01_t
                 DISPLAY BY NAME g_tod.tod01
                 NEXT FIELD tod01
               END IF
           END IF
           SELECT geo02 INTO l_gea02 FROM geo_file
            WHERE geo01 = l_newno1
              AND geoacti='Y'
           DISPLAY l_gea02 TO FORMONLY.gea02
 
        AFTER FIELD tod02
           IF NOT cl_null(l_newno2) THEN
             SELECT count(*) INTO l_n FROM too_file
               WHERE too01 = l_newno2
                 AND too03 = l_newno1
                 AND tooacti = 'Y'
               IF l_n = 0 THEN
                 CALL cl_err('','atm-111',0)
                 LET g_tod.tod02 = g_tod02_t
                 DISPLAY BY NAME g_tod.tod02
                 NEXT FIELD tod02
               END IF
           END IF
           SELECT too02 INTO l_too02 FROM too_file
            WHERE too01 = l_newno2
              AND too03 = l_newno1
              AND tooacti='Y'
           DISPLAY l_too02 TO FORMONLY.too02
 
        AFTER FIELD tod03
           IF NOT cl_null(l_newno3) THEN
             SELECT count(*) INTO l_n FROM top_file
               WHERE top01 = l_newno3
                 AND top03 = l_newno2
                 AND topacti = 'Y'
               IF l_n = 0 THEN
                 CALL cl_err('','atm-112',0)
                 LET g_tod.tod03 = g_tod03_t
                 DISPLAY BY NAME g_tod.tod03
                 NEXT FIELD tod03
               END IF
           END IF
           SELECT top02 INTO l_top02 FROM top_file
            WHERE top01 = l_newno3
              AND top03 = l_newno2
              AND topacti='Y'
           DISPLAY l_top02 TO FORMONLY.top02
 
        AFTER FIELD tod04
           IF NOT cl_null(l_newno4) THEN
             SELECT count(*) INTO l_n FROM toq_file
               WHERE toq01 = l_newno4
                 AND toq03 = l_newno3
                 AND toqacti = 'Y'
               IF l_n = 0 THEN
                 CALL cl_err('','atm-302',0)
                 LET g_tod.tod04 = g_tod04_t
                 DISPLAY BY NAME g_tod.tod04
                 NEXT FIELD tod04
               END IF
           END IF
           SELECT toq02 INTO l_toq02 FROM toq_file
            WHERE toq01 = l_newno4
              AND toq03 = l_newno3
              AND toqacti='Y'
           DISPLAY l_toq02 TO FORMONLY.toq02
 
#        BEGIN WORK
#           SELECT COUNT(*) INTO l_n
#           FROM tod_file
#           WHERE tod01 = l_newno1
#             AND tod02 = l_newno2
#             AND tod03 = l_newno3
#             AND tod04 = l_newno4
#           IF l_n>0 THEN
#              CALL cl_err('',-239,1)
#              NEXT FIELD tod01
#           END IF
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(tod01)     #區域
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geo"
                 LET g_qryparam.default1 = l_newno1
                 CALL cl_create_qry() RETURNING l_newno1
                 DISPLAY l_newno1 TO tod01
                 NEXT FIELD tod01
             WHEN INFIELD(tod02)     #省別
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = l_newno1
                 LET g_qryparam.form ="q_too1"
                 LET g_qryparam.default1 = l_newno2
                 CALL cl_create_qry() RETURNING l_newno2
                 DISPLAY l_newno2 TO tod02
                 NEXT FIELD tod02
             WHEN INFIELD(tod03)      #地級市
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = l_newno2
                 LET g_qryparam.form ="q_top1"
                 LET g_qryparam.default1 = l_newno3
                 CALL cl_create_qry() RETURNING l_newno3
                 DISPLAY l_newno3 TO tod03
                 NEXT FIELD tod03
             WHEN INFIELD(tod04) #縣
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = l_newno3
                 LET g_qryparam.form ="q_toq"
                 LET g_qryparam.default1 = l_newno4
                 CALL cl_create_qry() RETURNING l_newno4
                 DISPLAY l_newno4 TO tod04
                 NEXT FIELD tod04
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
       DISPLAY BY NAME g_tod.tod01
       DISPLAY BY NAME g_tod.tod02
       DISPLAY BY NAME g_tod.tod03
       DISPLAY BY NAME g_tod.tod04
       RETURN
    END IF
 
    DROP TABLE y
 
    SELECT * FROM tod_file         #單頭複製
        WHERE tod01=g_tod.tod01
          AND tod02=g_tod.tod02
          AND tod03=g_tod.tod03
          AND tod04=g_tod.tod04
        INTO TEMP y
 
    UPDATE y
        SET tod01=l_newno1,   #新的鍵值
            tod02=l_newno2,   #新的鍵值
            tod03=l_newno3,   #新的鍵值
            tod04=l_newno4,   #新的鍵值
            toduser=g_user,   #資料所有者
            todgrup=g_grup,   #資料所有者所屬群
            todmodu=NULL,     #資料修改日期
            toddate=g_today,  #資料建立日期
            todacti='Y'       #有效資料
 
    INSERT INTO tod_file
        SELECT * FROM y
 
    DROP TABLE x
 
    SELECT * FROM toe_file         #單身複製
        WHERE toe01=g_tod.tod01
          AND toe02=g_tod.tod02
          AND toe03=g_tod.tod03
          AND toe04=g_tod.tod04
        INTO TEMP x
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tod.tod01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("ins","toe_file",g_tod.tod01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
 
    UPDATE x
        SET toe01=l_newno1,
            toe02=l_newno2,
            toe03=l_newno3,
            toe04=l_newno4
 
    INSERT INTO toe_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tod.tod01,SQLCA.sqlcode,0)  #No.FUN-660104
        CALL cl_err3("sel","toe_file",g_tod.tod01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
     LET l_oldno1 = g_tod.tod01
     LET l_oldno2 = g_tod.tod02
     LET l_oldno3 = g_tod.tod03
     LET l_oldno4 = g_tod.tod04
     SELECT * INTO g_tod.* FROM tod_file
     WHERE tod01 = l_newno1
       AND tod02 = l_newno2
       AND tod03 = l_newno3
       AND tod04 = l_newno4
     CALL i208_u()
     CALL i208_b()
     #FUN-C80046---begin
     #SELECT * INTO g_tod.* FROM tod_file
     #WHERE tod01 = l_oldno1
     #  AND tod02 = l_oldno2
     #  AND tod03 = l_oldno3
     #  AND tod04 = l_oldno4
     #CALL i208_show()
     #FUN-C80046---end
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i208_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    sr              RECORD
        tod01       LIKE tod_file.tod01,   #
        gea02       LIKE gea_file.gea02,
        tod02       LIKE tod_file.tod02,   #
        too02       LIKE too_file.too02,
        tod03       LIKE tod_file.tod03,   #
        top02       LIKE top_file.top02,
        tod04       LIKE tod_file.tod04,   #
        toq02       LIKE toq_file.toq02,
        tod05       LIKE tod_file.tod05,   #
        toa02       LIKE toa_file.toa02,
        tod06       LIKE tod_file.tod06,   #
        tod07       LIKE tod_file.tod07,   #
        tod08       LIKE tod_file.tod08,   #
        tod09       LIKE tod_file.tod09,   #
        tod10       LIKE tod_file.tod10,   #
        tod11       LIKE tod_file.tod11,   #
        toe05       LIKE toe_file.toe05,   #
        toe06       LIKE toe_file.toe06,   #
        toe07       LIKE toe_file.toe07    #
       END RECORD,
    l_name          LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)               #External(Disk) file name
    l_za05          LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(40)  #
 
    IF cl_null(g_wc) THEN
        LET g_wc ="      tod01='",g_tod.tod01,"'",
                  "  AND tod02='",g_tod.tod02,"'",
                  "  AND tod03='",g_tod.tod03,"'",
                  "  AND tod04='",g_tod.tod04,"'"
        LET g_wc2=" 1=1 "
    END IF
    CALL cl_wait()
    CALL cl_outnam('atmi208') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT tod01,gea02,tod02,too02,tod03,top02,tod04,toq02,",
          " tod05,toa02,tod06,  ",
          " tod07,tod08,tod09,tod10,tod11,toe05,toe06,toe07 ",
#         " FROM tod_file,toe_file,gea_file,too_file,top_file,toq_file,", #No.TQC-650031 MARK
          " FROM tod_file,toe_file,OUTER gea_file,OUTER too_file,",  #No.TQC-650031
          " OUTER top_file,OUTER toq_file,",   #No.TQC-650031
          " OUTER toa_file ",
          " WHERE toe01=tod01 AND toe02=tod02 AND toe03=tod03 ",
#         " AND toe04=tod04 AND tod01=gea01 AND tod02=too01 AND tod03=top01 ",     #No.TQC-650031 MARK
#         " AND tod04=toq01 AND tod05=toa_file.toa01 AND toa_file.toa03='4' AND ", #No.TQC-650031 MARK
          " AND toe04=tod04 AND tod_file.tod01=gea_file.gea01 AND tod_file.tod02=too_file.too01 AND tod_file.tod03=top_file.top01 ", #No.TQC-650031
          " AND tod_file.tod04=toq_file.toq01 AND tod_file.tod05=toa_file.toa01 AND toa_file.toa03='4' AND ",  #No.TQC-650031
          g_wc CLIPPED," AND ", g_wc2 CLIPPED
    PREPARE i208_p1 FROM g_sql                # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('i208_p1',STATUS,0) END IF
 
    DECLARE i208_co                         # CURSOR
        CURSOR FOR i208_p1
 
    START REPORT i208_rep TO l_name
 
    FOREACH i208_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i208_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i208_rep
 
    CLOSE i208_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i208_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1) 
    l_i             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    sr              RECORD
        tod01       LIKE tod_file.tod01,   #
        gea02       LIKE gea_file.gea02,
        tod02       LIKE tod_file.tod02,   #
        too02       LIKE too_file.too02,
        tod03       LIKE tod_file.tod03,   #
        top02       LIKE top_file.top02,
        tod04       LIKE tod_file.tod04,   #
        toq02       LIKE toq_file.toq02,
        tod05       LIKE tod_file.tod05,   #
        toa02       LIKE toa_file.toa02,
        tod06       LIKE tod_file.tod06,   #
        tod07       LIKE tod_file.tod07,   #
        tod08       LIKE tod_file.tod08,   #
        tod09       LIKE tod_file.tod09,   #
        tod10       LIKE tod_file.tod10,   #
        tod11       LIKE tod_file.tod11,   #
        toe05       LIKE toe_file.toe05,   #
        toe06       LIKE toe_file.toe06,   #
        toe07       LIKE toe_file.toe07   #
       END RECORD,
    l_name          LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)             #External(Disk) file name
    l_za05          LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(40)                #
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.tod01,sr.tod02,sr.tod03,sr.tod04
 
    FORMAT
      PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[45],g_x[32],g_x[46],g_x[33],g_x[47],g_x[34],g_x[48],
            g_x[35],g_x[49],g_x[36],g_x[37],
            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
      PRINT g_dash1
      LET l_trailer_sw = 'y'
 
      BEFORE GROUP OF sr.tod01
         PRINT COLUMN g_c[31],sr.tod01 CLIPPED,
               COLUMN g_c[45],sr.gea02 CLIPPED;
 
      BEFORE GROUP OF sr.tod02
         PRINT COLUMN g_c[32],sr.tod02 CLIPPED,
               COLUMN g_c[46],sr.too02 CLIPPED;
 
      BEFORE GROUP OF sr.tod03
         PRINT COLUMN g_c[33],sr.tod03 CLIPPED,
               COLUMN g_c[47],sr.top02 CLIPPED;
 
      BEFORE GROUP OF sr.tod04
         PRINT COLUMN g_c[34],sr.tod04 CLIPPED,
               COLUMN g_c[48],sr.toq02 CLIPPED,
               COLUMN g_c[35],sr.tod05 CLIPPED,
               COLUMN g_c[49],sr.toa02 CLIPPED,
               COLUMN g_c[36],sr.tod06 USING '##########&.&&&',
               COLUMN g_c[37],cl_numfor(sr.tod07,37,g_azi04),
               COLUMN g_c[38],sr.tod08 USING '#########&',
               COLUMN g_c[39],sr.tod09 USING '########&',
               COLUMN g_c[40],sr.tod10 USING '#########&',
               COLUMN g_c[41],sr.tod11 CLIPPED;
 
      ON EVERY ROW
         PRINT COLUMN g_c[42],sr.toe05 CLIPPED,
               COLUMN g_c[43],cl_numfor(sr.toe06,43,g_azi04),
               COLUMN g_c[44],sr.toe07 CLIPPED
 
      ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'
               THEN
#NO.TQC-630166 start-- 
#                   IF g_wc[001,080] > ' ' THEN
#                  PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    IF g_wc[071,140] > ' ' THEN
#                   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#                   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc)                    
#NO.TQC-630166 END--
                    PRINT g_dash[1,g_len]
            END IF
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780056 -end
 
FUNCTION i208_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tod01,tod02,tod03,tod04",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i208_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tod01,tod02,tod03,tod04",FALSE)
    END IF
 
END FUNCTION
 
