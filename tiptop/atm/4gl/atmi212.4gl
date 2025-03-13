# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi212.4gl
# Descriptions...: 廣告合同資料維護作業
# Date & Author..: 05/10/19 By jackie
# Modify.........: No.TQC-630069 06/03/07 By Smapmin 流程訊息通知功能
# Modify.........: No.TQC-640096 06/04/08 By jackie 代理商欄位控制修改
# Modify.........: No.TQC-660071 06/06/14 By Smapmin 補充TQC-630069
# Modify.........: No.FUN-660104 06/06/19 By cl   Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/24 By mike報表格式修改為crystal reports
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/18 By TSD.Wind 自定欄位功能修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AC0041 10/12/20 By baogc 修改狀態頁簽屬性
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BC0122 11/12/21 By suncx 合約類型欄位管控BUG修正
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tol           RECORD LIKE tol_file.*,       #單頭
    g_tol_t         RECORD LIKE tol_file.*,       #單頭(舊值)
    g_tol_o         RECORD LIKE tol_file.*,       #單頭(舊值)
    g_tol01         LIKE tol_file.tol01,          #單頭KEY
    g_tol01_t       LIKE tol_file.tol01,          #單頭KEY (舊值)
    g_t1            LIKE oay_file.oayslip,                      #No.FUN-680120 VARCHAR(05)
    g_tom           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        tom02       LIKE tom_file.tom02,   #項次
        tom03       LIKE tom_file.tom03,   #媒體編號
        tof02       LIKE tof_file.tof02,   #媒體名稱
        gea02       LIKE gea_file.gea02,   #廣告區域
        too02       LIKE too_file.too02,   #廣告省別
        tom04       LIKE tom_file.tom04,   #媒體明細
        tog03       LIKE tog_file.tog03,   #起始時段
        tog04       LIKE tog_file.tog04,   #截止時段
        toa02       LIKE toa_file.toa02,   #單位
        tom05       LIKE tom_file.tom05,   #刊列價
        tom06       LIKE tom_file.tom06,   #折扣
        tom07       LIKE tom_file.tom07,   #凈價
        tom08       LIKE tom_file.tom08,   #次數小計
        tom09       LIKE tom_file.tom09,   #金額小計
        tom10       LIKE tom_file.tom10,    #備注
        #FUN-840068 --start---
        tomud01     LIKE tom_file.tomud01,
        tomud02     LIKE tom_file.tomud02,
        tomud03     LIKE tom_file.tomud03,
        tomud04     LIKE tom_file.tomud04,
        tomud05     LIKE tom_file.tomud05,
        tomud06     LIKE tom_file.tomud06,
        tomud07     LIKE tom_file.tomud07,
        tomud08     LIKE tom_file.tomud08,
        tomud09     LIKE tom_file.tomud09,
        tomud10     LIKE tom_file.tomud10,
        tomud11     LIKE tom_file.tomud11,
        tomud12     LIKE tom_file.tomud12,
        tomud13     LIKE tom_file.tomud13,
        tomud14     LIKE tom_file.tomud14,
        tomud15     LIKE tom_file.tomud15
        #FUN-840068 --end--
                    END RECORD,
    g_tom_t         RECORD                 #程式變數 (舊值)
        tom02       LIKE tom_file.tom02,   #項次
        tom03       LIKE tom_file.tom03,   #媒體編號
        tof02       LIKE tof_file.tof02,   #媒體名稱
        gea02       LIKE gea_file.gea02,   #廣告區域
        too02       LIKE too_file.too02,   #廣告省別
        tom04       LIKE tom_file.tom04,   #媒體明細
        tog03       LIKE tog_file.tog03,   #起始時段
        tog04       LIKE tog_file.tog04,   #截止時段
        toa02       LIKE toa_file.toa02,   #單位
        tom05       LIKE tom_file.tom05,   #刊列價
        tom06       LIKE tom_file.tom06,   #折扣
        tom07       LIKE tom_file.tom07,   #凈價
        tom08       LIKE tom_file.tom08,   #次數小計
        tom09       LIKE tom_file.tom09,   #金額小計
        tom10       LIKE tom_file.tom10,   #備注
        #FUN-840068 --start---
        tomud01     LIKE tom_file.tomud01,
        tomud02     LIKE tom_file.tomud02,
        tomud03     LIKE tom_file.tomud03,
        tomud04     LIKE tom_file.tomud04,
        tomud05     LIKE tom_file.tomud05,
        tomud06     LIKE tom_file.tomud06,
        tomud07     LIKE tom_file.tomud07,
        tomud08     LIKE tom_file.tomud08,
        tomud09     LIKE tom_file.tomud09,
        tomud10     LIKE tom_file.tomud10,
        tomud11     LIKE tom_file.tomud11,
        tomud12     LIKE tom_file.tomud12,
        tomud13     LIKE tom_file.tomud13,
        tomud14     LIKE tom_file.tomud14,
        tomud15     LIKE tom_file.tomud15
        #FUN-840068 --end--
                    END RECORD,
    g_tom_o         RECORD                 #程式變數 (舊值)
        tom02       LIKE tom_file.tom02,   #項次
        tom03       LIKE tom_file.tom03,   #媒體編號
        tof02       LIKE tof_file.tof02,   #媒體名稱
        gea02       LIKE gea_file.gea02,   #廣告區域
        too02       LIKE too_file.too02,   #廣告省別
        tom04       LIKE tom_file.tom04,   #媒體明細
        tog03       LIKE tog_file.tog03,   #起始時段
        tog04       LIKE tog_file.tog04,   #截止時段
        toa02       LIKE toa_file.toa02,   #單位
        tom05       LIKE tom_file.tom05,   #刊列價
        tom06       LIKE tom_file.tom06,   #折扣
        tom07       LIKE tom_file.tom07,   #凈價
        tom08       LIKE tom_file.tom08,   #次數小計
        tom09       LIKE tom_file.tom09,   #金額小計
        tom10       LIKE tom_file.tom10,   #備注
        #FUN-840068 --start---
        tomud01     LIKE tom_file.tomud01,
        tomud02     LIKE tom_file.tomud02,
        tomud03     LIKE tom_file.tomud03,
        tomud04     LIKE tom_file.tomud04,
        tomud05     LIKE tom_file.tomud05,
        tomud06     LIKE tom_file.tomud06,
        tomud07     LIKE tom_file.tomud07,
        tomud08     LIKE tom_file.tomud08,
        tomud09     LIKE tom_file.tomud09,
        tomud10     LIKE tom_file.tomud10,
        tomud11     LIKE tom_file.tomud11,
        tomud12     LIKE tom_file.tomud12,
        tomud13     LIKE tom_file.tomud13,
        tomud14     LIKE tom_file.tomud14,
        tomud15     LIKE tom_file.tomud15
        #FUN-840068 --end--
                    END RECORD,
    g_argv1         LIKE tom_file.tom01,        # 詢價單號
    g_argv2         STRING,    #TQC-630069
    g_wc,g_wc2,g_sql,g_cmd    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數             #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680120 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5        #No.FUN-680120 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_chr2          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_chr3          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680120 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_str           STRING                       #No.FUN-760083
DEFINE   l_table         STRING                       #No.FUN-760083
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5              #No.FUN-680120 SMALLINT
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
 
  LET g_argv1 = ARG_VAL(1)   #TQC-630069
  LET g_argv2 = ARG_VAL(2)   #TQC-630069
 
#No.FUN-760083  --begin--
    LET g_sql = "tol01.tol_file.tol01,",
                "tol02.tol_file.tol02,",
                "tol03.tol_file.tol03,",
                "toa02.toa_file.toa02,",
                "tol04.tol_file.tol04,",
                "tol05.tol_file.tol05,",
                "pmc03.pmc_file.pmc03,",
                "tol06.tol_file.tol06,",
                "tol07.tol_file.tol07,",
                "tol08.tol_file.tol08,",
                "tol09.tol_file.tol09,",
                "tol10.tol_file.tol10,",
                "tol11.tol_file.tol11,",
                "tol12.tol_file.tol12,",
                "tol13.tol_file.tol13,",
                "tol14.tol_file.tol14,",
                "tom02.tom_file.tom02,",
                "tom03.tom_file.tom03,",                                                      
                "tof02.tof_file.tof02,",
                "gea02.gea_file.gea02,",
                "too02.too_file.too02,",
                "tom04.tom_file.tom04,",
                "tog03.tog_file.tog03,",
                "tog04.tog_file.tog04,",
                "tom05.tom_file.tom05,",
                "tom06.tom_file.tom06,",                                                                           
                "tom07.tom_file.tom07,",
                "tom08.tom_file.tom08,",
                "tom09.tom_file.tom09,",
                "tom10.tom_file.tom10,",
                "tog05.tog_file.tog05,",
                "l_toa02.toa_file.toa02,",
                "l_geo01.geo_file.geo01"
    LET l_table=cl_prt_temptable("atmi212",g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
    CALL cl_err("insert_prep:",status,1)
   END IF
#No.FUN-760083  --END--
 
    LET g_forupd_sql = " SELECT * FROM tol_file WHERE tol01 = ? FOR UPDATE "                                                        
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i212_cl CURSOR FROM g_forupd_sql                         
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW i212_w AT p_row,p_col
        WITH FORM "atm/42f/atmi212"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    #-----TQC-630069---------
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i212_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i212_a()
             END IF
          OTHERWISE   #TQC-660071
             CALL i212_q()   #TQC-660071
       END CASE
    END IF
 
    #IF g_argv1 IS NOT NULL AND g_argv1 != ' '
    #THEN CALL i212_q()
    #END IF
    #-----END TQC-630069-----
 
    CALL i212_menu()
    CLOSE WINDOW i212_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION i212_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_tom.clear()
 
  IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
     LET g_wc = " tol01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE 
     CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tol.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
                       tol01,tol02,tol03,tol04,tol05,tol06,
                       tol07,tol08,tol09,tol10,tol11,tol12,
                       tol13,tol14,
                   #   toluser,tolgrup,tolmodu,toldate,tolacti, #FUN-AC0041 MARK
                       toluser,tolgrup,toloriu,tolorig,         #FUN-AC0041 ADD
                       tolmodu,toldate,tolacti,                 #FUN-AC0041 ADD
                       #FUN-840068   ---start---
                       tolud01,tolud02,tolud03,tolud04,tolud05,
                       tolud06,tolud07,tolud08,tolud09,tolud10,
                       tolud11,tolud12,tolud13,tolud14,tolud15
                       #FUN-840068    ----end----
 
     #No.FUN-580031 --start--     HCN
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
     #No.FUN-580031 --end--       HCN
 
     ON ACTION controlp
           CASE
               WHEN INFIELD(tol03) #合同類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_toa"
                 LET g_qryparam.arg1 ="7"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tol03
                 NEXT FIELD tol03
               WHEN INFIELD(tol05)    #海關代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_pmc7"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tol05
                 NEXT FIELD tol05
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
     IF INT_FLAG THEN RETURN END IF
 
     CONSTRUCT g_wc2 ON tom02,tom03,tom04,tom06,tom08    #螢幕上取單身條件
                        #No.FUN-840068 --start--
                        ,tomud01,tomud02,tomud03,tomud04,tomud05
                        ,tomud06,tomud07,tomud08,tomud09,tomud10
                        ,tomud11,tomud12,tomud13,tomud14,tomud15
                        #No.FUN-840068 ---end---
            FROM s_tom[1].tom02,s_tom[1].tom03,s_tom[1].tom04,
                 s_tom[1].tom06,s_tom[1].tom08
                 #No.FUN-840068 --start--
                 ,s_tom[1].tomud01,s_tom[1].tomud02,s_tom[1].tomud03
                 ,s_tom[1].tomud04,s_tom[1].tomud05,s_tom[1].tomud06
                 ,s_tom[1].tomud07,s_tom[1].tomud08,s_tom[1].tomud09
                 ,s_tom[1].tomud10,s_tom[1].tomud11,s_tom[1].tomud12
                 ,s_tom[1].tomud13,s_tom[1].tomud14,s_tom[1].tomud15
                 #No.FUN-840068 ---end---
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp  #ok
            CASE
               WHEN INFIELD(tom03) #媒體編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tof"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tom03
                 NEXT FIELD tom03
               WHEN INFIELD(tom04) #媒體明細
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tog"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tom04
                 NEXT FIELD tom04
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
     IF INT_FLAG THEN RETURN END IF
  END IF
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND toluser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND tolgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND tolgrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('toluser', 'tolgrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  tol01 FROM tol_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY tol01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT  tol01 ",
                   "  FROM tol_file,tom_file ",
                   " WHERE tol01 = tom01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY tol01"
    END IF
 
    PREPARE i212_prepare FROM g_sql
    DECLARE i212_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i212_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM tol_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT tol01) ",
                  "FROM tol_file,tom_file ",
                  "WHERE tom01=tol01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i212_precount FROM g_sql
    DECLARE i212_count CURSOR FOR i212_precount
END FUNCTION
 
FUNCTION i212_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(100)
 
   WHILE TRUE
      CALL i212_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i212_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i212_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i212_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i212_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i212_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i212_b()
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
            IF cl_chk_act_auth()  THEN
               IF g_tol.tol01 IS NOT NULL THEN
                 LET g_doc.column1 = "tol01"
                 LET g_doc.value1 = g_tol.tol01
                 CALL cl_doc()
               END IF
            END IF
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_tom),'','')
             END IF
 
         WHEN "void"  #作廢
            IF cl_chk_act_auth() THEN
               CALL i212_c(1)
               IF g_tol.tol13='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               IF g_tol.tol14='1'  THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               IF g_tol.tol14='6' THEN
                  LET g_chr3='Y'
               ELSE
                  LET g_chr3='N'
               END IF
               CALL cl_set_field_pic(g_tol.tol13,g_chr2,"",g_chr3,g_chr,g_tol.tolacti)
            END IF
    
         #FUN-D20039 -----------sta
         WHEN "undo_void"  #作廢
            IF cl_chk_act_auth() THEN
               CALL i212_c(2)
               IF g_tol.tol13='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               IF g_tol.tol14='1'  THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               IF g_tol.tol14='6' THEN
                  LET g_chr3='Y'
               ELSE
                  LET g_chr3='N'
               END IF
               CALL cl_set_field_pic(g_tol.tol13,g_chr2,"",g_chr3,g_chr,g_tol.tolacti)
            END IF
         #FUN-D20039 -----------end
 
         WHEN "confirm" #審核
            IF cl_chk_act_auth() THEN
               CALL i212_y()
               IF g_tol.tol13='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               IF g_tol.tol14='1'  THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               IF g_tol.tol14='6' THEN
                  LET g_chr3='Y'
               ELSE
                  LET g_chr3='N'
               END IF
               CALL cl_set_field_pic(g_tol.tol13,g_chr2,"",g_chr3,g_chr,g_tol.tolacti)
            END IF
 
         WHEN "unconfirm" #取消審核
            IF cl_chk_act_auth() THEN
               CALL i212_z()
               IF g_tol.tol13='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               IF g_tol.tol14='1'  THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               IF g_tol.tol14='6' THEN
                  LET g_chr3='Y'
               ELSE
                  LET g_chr3='N'
               END IF
               CALL cl_set_field_pic(g_tol.tol13,g_chr2,"",g_chr3,g_chr,g_tol.tolacti)
            END IF
 
         WHEN "close_the_case" #結案
            IF cl_chk_act_auth() THEN
               CALL i212_1()
               IF g_tol.tol13='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               IF g_tol.tol14='1'  THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               IF g_tol.tol14='6' THEN
                  LET g_chr3='Y'
               ELSE
                  LET g_chr3='N'
               END IF
               CALL cl_set_field_pic(g_tol.tol13,g_chr2,"",g_chr3,g_chr,g_tol.tolacti)
            END IF
 
         WHEN "undo_close" #取消結案
            IF cl_chk_act_auth() THEN
               CALL i212_2()
               IF g_tol.tol13='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               IF g_tol.tol14='1'  THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               IF g_tol.tol14='6' THEN
                  LET g_chr3='Y'
               ELSE
                  LET g_chr3='N'
               END IF
               CALL cl_set_field_pic(g_tol.tol13,g_chr2,"",g_chr3,g_chr,g_tol.tolacti)
            END IF
 
         WHEN "Ad_Material_Maintain"
            CALL cl_set_act_visible("Ad_Material_Maintain", FALSE)
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i212_out()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i212_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_tom.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_tol.* LIKE tol_file.*             #DEFAULT 設置
    LET g_tol01_t = NULL
    LET g_tol_t.* = g_tol.*
    LET g_tol_o.* = g_tol.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tol.tol13='N'                #審核碼
        LET g_tol.tol14='0'                #狀態碼
        LET g_tol.tol02=g_today            #default單據日期
        LET g_tol.tol09=0
        LET g_tol.tol10=0
        LET g_tol.tol11=0
        LET g_tol.toluser=g_user
        LET g_tol.tolgrup=g_grup
        LET g_tol.toldate=g_today
        LET g_tol.tolacti='Y'              #資料有效
        LET g_tol.toloriu = g_user         #FUN-AC0041 ADD
        LET g_tol.tolorig = g_grup         #FUN-AC0041 ADD
 
        BEGIN WORK
        #-----TQC-630069---------
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_tol.tol01 = g_argv1
        END IF
        #-----END TQC-630069-----
        CALL i212_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_tol.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_tol.tol01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK
   #    LET g_tol.toloriu = g_user      #No.FUN-980030 10/01/04 #FUN-AC0041 MARK
   #    LET g_tol.tolorig = g_grup      #No.FUN-980030 10/01/04 #FUN-AC0041 MARK
        INSERT INTO tol_file VALUES (g_tol.*)
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
        #   CALL cl_err(g_tol.tol01,SQLCA.sqlcode,1)   #No.FUN-660104
            CALL cl_err3("ins","tol_file",g_tol.tol01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CONTINUE WHILE
        ELSE
        COMMIT WORK
        CALL cl_flow_notify(g_tol.tol01,'I')
        END IF
        SELECT tol01 INTO g_tol.tol01 FROM tol_file
            WHERE tol01 = g_tol.tol01
        LET g_tol01_t = g_tol.tol01        #保留舊值
        LET g_tol_t.* = g_tol.*
        LET g_tol_o.* = g_tol.*
        LET g_rec_b=0
        CALL i212_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i212_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_tol.tol01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_tol.* FROM tol_file WHERE tol01=g_tol.tol01
    IF g_tol.tol13='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_tol.tol13='X' THEN
       IF g_tol.tolacti='Y' THEN            #若資料還有效
          CALL cl_err(g_tol.tol01,'9024',0)
          RETURN
       ELSE                                 #資料也已無效
          CALL cl_err(g_tol.tol01,'mfg1000',0)
          RETURN
       END IF
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tol01_t = g_tol.tol01
    BEGIN WORK
 
    OPEN i212_cl USING g_tol.tol01
    IF STATUS THEN
       CALL cl_err("OPEN i212_cl:", STATUS, 1)
       CLOSE i212_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i212_cl INTO g_tol.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i212_cl
        RETURN
    END IF
    CALL i212_show()
    WHILE TRUE
        LET g_tol01_t = g_tol.tol01
        LET g_tol_o.* = g_tol.*
        LET g_tol.tolmodu=g_user
        LET g_tol.toldate=g_today
        CALL i212_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tol.*=g_tol_t.*
            CALL i212_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_tol.tol01 != g_tol01_t THEN            # 更改單號
            UPDATE tom_file SET tom01 = g_tol.tol01
                WHERE tom01 = g_tol01_t
            IF SQLCA.sqlcode THEN
            #   CALL cl_err('tom',SQLCA.sqlcode,0)  #No.FUN-660104
                CALL cl_err3("upd","tom_file",g_tol01_t,"",SQLCA.sqlcode,"","tom",1)   #No.FUN-660104
                CONTINUE WHILE #No.FUN-660104
            END IF
        END IF
        UPDATE tol_file SET tol_file.* = g_tol.*
            WHERE tol01 = g_tol01_t
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("upd","tol_file",g_tol.tol01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
    CLOSE i212_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tol.tol01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION i212_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n,l_i   LIKE type_file.num5,         #No.FUN-680120 SMALLINT
    p_cmd           LIKE type_file.chr1    #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
DEFINE g_chr  LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr2 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr3 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
        g_tol.tol01,g_tol.tol02,g_tol.tol03,g_tol.tol04,
        g_tol.tol05,g_tol.tol06,g_tol.tol07,
        g_tol.tol08,g_tol.tol09,g_tol.tol10,g_tol.tol11,
        g_tol.tol12,g_tol.tol13,g_tol.tol14,
   #    g_tol.toluser,g_tol.tolgrup,g_tol.tolmodu,g_tol.toldate,g_tol.tolacti #FUN-AC0041 MARK
        g_tol.toluser,g_tol.tolgrup,g_tol.toloriu,g_tol.tolorig,              #FUN-AC0041 ADD
        g_tol.tolmodu,g_tol.toldate,g_tol.tolacti                             #FUN-AC0041 ADD
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME
        g_tol.tol01,g_tol.tol02,g_tol.tol03,g_tol.tol04,
        g_tol.tol05,g_tol.tol06,g_tol.tol07,
        g_tol.tol08,g_tol.tol09,g_tol.tol10,g_tol.tol11,
        g_tol.tol12,g_tol.tol13,g_tol.tol14,
  #     g_tol.toluser,g_tol.tolgrup,g_tol.tolmodu,g_tol.toldate,g_tol.tolacti,#FUN-AC0041 MARK
        g_tol.toluser,g_tol.tolgrup,g_tol.toloriu,g_tol.tolorig,              #FUN-AC0041 ADD
        g_tol.tolmodu,g_tol.toldate,g_tol.tolacti,                            #FUN-AC0041 ADD
        #FUN-840068     ---start---
        g_tol.tolud01,g_tol.tolud02,g_tol.tolud03,g_tol.tolud04,
        g_tol.tolud05,g_tol.tolud06,g_tol.tolud07,g_tol.tolud08,
        g_tol.tolud09,g_tol.tolud10,g_tol.tolud11,g_tol.tolud12,
        g_tol.tolud13,g_tol.tolud14,g_tol.tolud15 
                      WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i212_set_entry(p_cmd)
            CALL i212_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
 
        AFTER FIELD tol01
            IF g_tol.tol01 != g_tol_t.tol01 OR g_tol_t.tol01 IS NULL THEN
                SELECT count(*) INTO l_n FROM tol_file
                    WHERE tol01 = g_tol.tol01
                IF l_n > 0 THEN   #媒體代碼重複
                    LET g_tol.tol01 = g_tol_t.tol01
                    DISPLAY BY NAME g_tol.tol01
                     CALL cl_err(g_tol.tol01,-239,1)
                    NEXT FIELD tol01
                END IF
            END IF
        AFTER FIELD tol03                  #媒體代碼
            IF NOT cl_null(g_tol.tol03) THEN
                  CALL i212_tol03('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tol.tol03,g_errno,1)
                     LET g_tol.tol03 = g_tol_o.tol03
                     DISPLAY BY NAME g_tol.tol03
                     NEXT FIELD tol03
                  END IF
            END IF
            LET g_tol_o.tol03 = g_tol.tol03
 
       AFTER FIELD tol05
            IF NOT cl_null(g_tol.tol05) THEN
                  CALL i212_tol05('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tol.tol05,g_errno,1)
                     LET g_tol.tol05 = g_tol_o.tol05
                     DISPLAY BY NAME g_tol.tol05
                     NEXT FIELD tol05
                  END IF
            END IF
            LET g_tol_o.tol05 = g_tol.tol05
 
        AFTER FIELD tol06
            IF NOT cl_null(g_tol.tol06) THEN
               IF NOT cl_null(g_tol.tol07) THEN
                  IF NOT (g_tol.tol06 <= g_tol.tol07) THEN
                     CALL cl_err('','atm-109',1)
                     NEXT FIELD tol06
                  END IF
               END IF
               IF NOT cl_null(g_tol.tol08) THEN
                  IF NOT (g_tol.tol08 <= g_tol.tol06) THEN
                     CALL cl_err('','atm-109',1)
                     NEXT FIELD tol06
                  END IF
               END IF
            END IF
 
        AFTER FIELD tol07
            IF NOT cl_null(g_tol.tol07) THEN
               IF NOT cl_null(g_tol.tol06) THEN
                  IF NOT (g_tol.tol06 <= g_tol.tol07) THEN
                     CALL cl_err('','atm-109',1)
                     NEXT FIELD tol07
                  END IF
               END IF
               IF NOT cl_null(g_tol.tol08) THEN
                  IF NOT (g_tol.tol08 <= g_tol.tol07) THEN
                     CALL cl_err('','atm-109',1)
                     NEXT FIELD tol07
                  END IF
               END IF
            END IF
 
        AFTER FIELD tol08
            IF NOT cl_null(g_tol.tol08) THEN
               IF NOT cl_null(g_tol.tol06) THEN
                  IF g_tol.tol08 > g_tol.tol06 THEN
                     CALL cl_err('','atm-109',1)
                     NEXT FIELD tol08
                  END IF
               END IF
               IF NOT cl_null(g_tol.tol07) THEN
                  IF g_tol.tol08 > g_tol.tol07 THEN
                     CALL cl_err('','atm-109',1)
                     NEXT FIELD tol08
                  END IF
               END IF
            END IF
 
        AFTER FIELD tol14
            IF g_tol.tol13='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
            IF g_tol.tol14='1'  THEN
               LET g_chr2='Y' ELSE LET g_chr2='N'
            END IF
            IF g_tol.tol14='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
            CALL cl_set_field_pic(g_tol.tol13,g_chr2,"",g_chr3,g_chr,g_tol.tolacti)
 
        #FUN-840068     ---start---
        AFTER FIELD tolud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tolud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tol03) #媒體代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_toa"
                 LET g_qryparam.default1 = g_tol.tol03
                 LET g_qryparam.arg1 = "7"
                 CALL cl_create_qry() RETURNING g_tol.tol03
                 DISPLAY BY NAME g_tol.tol03
                 CALL i212_tol03('d')
                 NEXT FIELD tol03
 
               WHEN INFIELD(tol05)      #代理商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc7"
                 LET g_qryparam.default1 = g_tol.tol05
                 CALL cl_create_qry() RETURNING g_tol.tol05
                 DISPLAY BY NAME g_tol.tol05
                 CALL i212_tol05('d')
                 NEXT FIELD tol05
              OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i212_tol03(p_cmd)  #
    DEFINE l_toa02   LIKE toa_file.toa02,
           l_toaacti LIKE toa_file.toaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT toa02,toaacti INTO l_toa02,l_toaacti
      FROM toa_file WHERE toa01 = g_tol.tol03
       AND toa03='7'    #TQC-BC0122
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-110'
         WHEN l_toaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_toa02 TO  FORMONLY.toa02a
    END IF
END FUNCTION
 
FUNCTION i212_tol05(p_cmd)  #
    DEFINE l_pmc03   LIKE pmc_file.pmc03,
           l_pmcacti LIKE pmc_file.pmcacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
      FROM pmc_file WHERE pmc01 = g_tol.tol05
                      AND pmc14='5' AND (pmc30='1' OR pmc30='3')   #TQC-640096
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-116'
         WHEN l_pmcacti='N'        LET g_errno = '9028'
    #FUN-690024------mod-------
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690024------mod-------
         
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_pmc03 TO  FORMONLY.pmc03
    END IF
END FUNCTION
 
FUNCTION i212_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("tol01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i212_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tol01",FALSE)
    END IF
END FUNCTION
 
 
#Query 查詢
FUNCTION i212_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tol.* TO NULL              #NO.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tom.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i212_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_tol.* TO NULL
        RETURN
    END IF
    OPEN i212_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tol.* TO NULL
    ELSE
        OPEN i212_count
        FETCH i212_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i212_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i212_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i212_cs INTO g_tol.tol01
        WHEN 'P' FETCH PREVIOUS i212_cs INTO g_tol.tol01
        WHEN 'F' FETCH FIRST    i212_cs INTO g_tol.tol01
        WHEN 'L' FETCH LAST     i212_cs INTO g_tol.tol01
        WHEN '/'
 
      IF (NOT mi_no_ask) THEN
        CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
        LET INT_FLAG = 0  ######tol for prompt bug
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
      FETCH ABSOLUTE g_jump i212_cs INTO g_tol.tol01
      LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)
        INITIALIZE g_tol.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_tol.* FROM tol_file WHERE tol01 = g_tol.tol01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)   #No.FUN-660104
        CALL cl_err3("sel","tol_file",g_tol.tol01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        INITIALIZE g_tol.* TO NULL
        RETURN
    END IF
 
    CALL i212_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i212_show()
DEFINE g_chr  LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr2 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_chr3 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    LET g_tol_t.* = g_tol.*                #保存單頭舊值
    LET g_tol_o.* = g_tol.*                #保存單頭舊值
 
    CALL cl_set_act_visible("Ad_Material_Maintain", FALSE)
 
    DISPLAY BY NAME                              # 顯示單頭值
        g_tol.tol01,g_tol.tol02,g_tol.tol03,g_tol.tol04,g_tol.tol05,
        g_tol.tol06,g_tol.tol07,g_tol.tol08,g_tol.tol09,g_tol.tol10,
        g_tol.tol11,g_tol.tol12,g_tol.tol13,g_tol.tol14,
        g_tol.toluser,
   #    g_tol.tolgrup,g_tol.tolmodu,g_tol.toldate,g_tol.tolacti, #FUN-AC0041 MARK
        g_tol.tolgrup,g_tol.toloriu,g_tol.tolorig,               #FUN-AC0041 ADD
        g_tol.tolmodu,g_tol.toldate,g_tol.tolacti,               #FUN-AC0041 ADD
        #FUN-840068     ---start---
        g_tol.tolud01,g_tol.tolud02,g_tol.tolud03,g_tol.tolud04,
        g_tol.tolud05,g_tol.tolud06,g_tol.tolud07,g_tol.tolud08,
        g_tol.tolud09,g_tol.tolud10,g_tol.tolud11,g_tol.tolud12,
        g_tol.tolud13,g_tol.tolud14,g_tol.tolud15 
        #FUN-840068     ----end----
    CALL i212_tol03('d')
    CALL i212_tol05('d')
    CALL i212_b_fill(g_wc2)                 #單身
    IF g_tol.tol13='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_tol.tol14='1'  THEN
       LET g_chr2='Y' ELSE LET g_chr2='N'
    END IF
    IF g_tol.tol14='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
    CALL cl_set_field_pic(g_tol.tol13,g_chr2,"",g_chr3,g_chr,g_tol.tolacti)
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i212_c(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
  
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_tol.* FROM tol_file WHERE tol01=g_tol.tol01
   IF g_tol.tol01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_tol.tol13='X' THEN RETURN END IF
    ELSE
       IF g_tol.tol13<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_tol.tol13 = 'Y'  THEN CALL cl_err('','axm-101',0) RETURN END IF
   #狀況為開立及取消時才可執行作廢or取消
   IF g_tol.tol14 NOT MATCHES '[09]' THEN RETURN END IF
   #NO:6961 check 若此為委外單且工單已確認.不可取消作廢
#   IF g_tol.tol13 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK
   LET g_success='Y'
 
   OPEN i212_cl USING g_tol.tol01
   IF STATUS THEN
      CALL cl_err("OPEN i212_cl:", STATUS, 1)
      CLOSE i212_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i212_cl INTO g_tol.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_tol.tol13) THEN
        IF g_tol.tol13 ='N' THEN
            LET g_tol.tol13='X'
            LET g_tol.tol14='9'
        ELSE
            LET g_tol.tol13='N'
            LET g_tol.tol14='0'
        END IF
        UPDATE tol_file SET
               tol13= g_tol.tol13,
               tol14= g_tol.tol14,
               tolmodu=g_user,
               toldate=TODAY
         WHERE tol01 = g_tol.tol01
        IF STATUS THEN
        #  CALL cl_err('upd tol13:',STATUS,1) LET g_success='N' END IF   #No.FUN-660104
           CALL cl_err3("upd","tol_file",g_tol.tol01,"",STATUS,"","upd tol13:",1)   #No.FUN-660104
           LET g_success='N' 
        END IF
   END IF
   IF g_success='Y' THEN
       COMMIT WORK
       CALL cl_flow_notify(g_tol.tol01,'V')
   ELSE
       ROLLBACK WORK
   END IF
   SELECT tol13,tol14 INTO g_tol.tol13,g_tol.tol14
     FROM tol_file WHERE tol01 = g_tol.tol01
   DISPLAY BY NAME g_tol.tol13,g_tol.tol14
END FUNCTION
 
FUNCTION i212_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_tol.tol01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i212_cl USING g_tol.tol01
    IF STATUS THEN
       CALL cl_err("OPEN i212_cl:", STATUS, 1)
       CLOSE i212_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i212_cl INTO g_tol.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i212_show()
    IF cl_exp(0,0,g_tol.tolacti) THEN                   #審核一下
        LET g_chr=g_tol.tolacti
        IF g_tol.tolacti='Y' THEN
            LET g_tol.tolacti='N'
            LET g_tol.tol13='X'
            LET g_tol.tol14='9'
        ELSE
            LET g_tol.tolacti='Y'
            LET g_tol.tol13='N'
            LET g_tol.tol14='0'
        END IF
        UPDATE tol_file                    #更改有效碼
            SET tolacti=g_tol.tolacti,
                tol13=g_tol.tol13,
                tol14=g_tol.tol14
            WHERE tol01=g_tol.tol01
        IF SQLCA.SQLERRD[3]=0 THEN
       #    CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("upd","tol_file",g_tol.tol01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            LET g_tol.tolacti=g_chr
        END IF
        DISPLAY g_tol.tolacti TO tolacti
        DISPLAY g_tol.tol13 TO tol13
        DISPLAY g_tol.tol14 TO tol14
    END IF
    CLOSE i212_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tol.tol01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION i212_r()
 DEFINE l_i LIKE type_file.num5          #No.FUN-680120 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    IF g_tol.tol01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_tol.tolacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tol.tol01,'mfg1000',0)
        RETURN
    END IF
    IF g_tol.tol14='1' OR g_tol.tol14='6' OR g_tol.tol14='9' THEN
        CALL cl_err('','atm-305',0)
        RETURN
    END IF
    SELECT * INTO g_tol.* FROM tol_file
     WHERE tol01=g_tol.tol01
    IF g_tol.tol13='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_tol.tol13='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_tol.tol14 matches '[1]' THEN
        CALL cl_err("","mfg3557",0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i212_cl USING g_tol.tol01
    IF STATUS THEN
       CALL cl_err("OPEN i212_cl:", STATUS, 1)
       CLOSE i212_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i212_cl INTO g_tol.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i212_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tol01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tol.tol01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM tol_file WHERE tol01 = g_tol.tol01
            DELETE FROM tom_file WHERE tom01 = g_tol.tol01
 
            CLEAR FORM
            CALL g_tom.clear()
 
         OPEN i212_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i212_cs
            CLOSE i212_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i212_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i212_cs
            CLOSE i212_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i212_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i212_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i212_fetch('/')
         END IF
    END IF
    CLOSE i212_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tol.tol01,'D')
END FUNCTION
 
#單身
FUNCTION i212_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_tol.tol01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tol.* FROM tol_file WHERE tol01=g_tol.tol01
    IF g_tol.tolacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tol.tol01,'mfg1000',0)
        RETURN
    END IF
    IF g_tol.tol13='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_tol.tol13="Y" THEN
       IF g_tol.tol14 = "6" THEN
          CALL cl_err('','amr-100',0)
          RETURN
       ELSE
          CALL cl_err('','mfg3168',0)
          RETURN
       END IF
    END IF
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT tom02,tom03,'','','',tom04,",
                       " '','','',tom05,tom06,tom07,tom08,tom09,tom10, ",
                       #No.FUN-840068 --start--
                       "       tomud01,tomud02,tomud03,tomud04,tomud05,",
                       "       tomud06,tomud07,tomud08,tomud09,tomud10,",
                       "       tomud11,tomud12,tomud13,tomud14,tomud15", 
                       #No.FUN-840068 ---end---
                       "   FROM tom_file ",
                       "   WHERE tom01=? AND tom02=? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i212_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_tom.clear() END IF
 
        INPUT ARRAY g_tom WITHOUT DEFAULTS FROM s_tom.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_act_visible("Ad_Material_Maintain", TRUE)    #0212
 
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i212_cl USING g_tol.tol01
            IF STATUS THEN
               CALL cl_err("OPEN i212_cl:", STATUS, 1)
               CLOSE i212_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i212_cl INTO g_tol.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i212_cl
              RETURN
            END IF
 
            # 修改狀態時才作備份舊值的動作
            IF g_rec_b >= l_ac THEN
                LET p_cmd="u"
                LET g_tom_t.* = g_tom[l_ac].*  #BACKUP
                LET g_tom_o.* = g_tom[l_ac].*  #BACKUP
 
                OPEN i212_bcl USING g_tol.tol01,g_tom_t.tom02
                IF STATUS THEN
                   CALL cl_err("OPEN i212_bcl:", STATUS, 1)
                   CLOSE i212_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i212_bcl INTO g_tom[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_tom_t.tom02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT tof02,geo02,too02
                    INTO g_tom[l_ac].tof02,g_tom[l_ac].gea02,g_tom[l_ac].too02
                    FROM tof_file, OUTER geo_file, OUTER too_file
                    WHERE tof01=g_tom[l_ac].tom03
                      AND geo_file.geo01=tof_file.tof05 AND too_file.too01=tof_file.tof06
                   SELECT tog03,tog04,toa02
                    INTO g_tom[l_ac].tog03,g_tom[l_ac].tog04,g_tom[l_ac].toa02
                    FROM tog_file, OUTER toa_file
                    WHERE tog01=g_tom[l_ac].tom03
                      AND tog02=g_tom[l_ac].tom04
                      AND toa_file.toa01=tog_file.tog05
                   LET g_tom[l_ac].tom07 = g_tom[l_ac].tom05*g_tom[l_ac].tom06
                   LET g_tom[l_ac].tom09 = g_tom[l_ac].tom07*g_tom[l_ac].tom08
                END IF
            END IF
 
        BEFORE INSERT
            LET p_cmd="a"
            LET l_n = ARR_COUNT()
            INITIALIZE g_tom[l_ac].* TO NULL       #900423
            LET g_tom[l_ac].tom05 = 0              #body default
            LET g_tom[l_ac].tom06 = 0              #body default
            LET g_tom[l_ac].tom07 = 0              #body default
            LET g_tom[l_ac].tom09 = 0              #body default
            LET g_tom_t.* = g_tom[l_ac].*          #新輸入資料
            LET g_tom_o.* = g_tom[l_ac].*          #新輸入資料
            NEXT FIELD tom02
 
        BEFORE FIELD tom02                        #default 序號
            IF g_tom[l_ac].tom02 IS NULL OR g_tom[l_ac].tom02 = 0 THEN
                SELECT max(tom02)+1
                   INTO g_tom[l_ac].tom02
                   FROM tom_file
                   WHERE tom01 = g_tol.tol01
                IF g_tom[l_ac].tom02 IS NULL THEN
                    LET g_tom[l_ac].tom02 = 1
                END IF
            END IF
 
        AFTER FIELD tom02                        #check 序號是否重複
            IF NOT g_tom[l_ac].tom02 IS NULL THEN
               IF g_tom[l_ac].tom02 != g_tom_t.tom02 OR
                  g_tom_t.tom02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM tom_file
                       WHERE tom01 = g_tol.tol01 AND
                             tom02 = g_tom[l_ac].tom02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_tom[l_ac].tom02 = g_tom_t.tom02
                       NEXT FIELD tom02
                   END IF
               END IF
            END IF
 
        AFTER FIELD tom03
            IF NOT cl_null(g_tom[l_ac].tom03) THEN
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_tom[l_ac].tom03 != g_tom_o.tom03) THEN
                 SELECT count(*) INTO l_n FROM tof_file
                     WHERE tof01 = g_tom[l_ac].tom03
                       AND tofacti = 'Y'
                 IF l_n = 0 THEN
                     CALL cl_err('','atm-119',0)
                     LET g_tom[l_ac].tom03 = g_tom_t.tom03
                     NEXT FIELD tom03
                 ELSE
                     CALL i212_tom03('d')
                 END IF
              END IF
            END IF
 
 
        AFTER FIELD tom04
            IF NOT cl_null(g_tom[l_ac].tom04) THEN
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_tom[l_ac].tom04 != g_tom_o.tom04) THEN
                 LET l_n = 0
                 SELECT count(*) INTO l_n FROM tog_file, OUTER toa_file
                     WHERE tog02 = g_tom[l_ac].tom04
                       AND tog01 = g_tom[l_ac].tom03
                       AND tog_file.tog05 = toa_file.toa01
                       AND toa_file.toa03 = '6'
                 IF l_n = 0 THEN
                     CALL cl_err('','atm-309',0)
                     LET g_tom[l_ac].tom04 = g_tom_t.tom04
                     NEXT FIELD tom04
                 ELSE
                     CALL i212_tom04('d')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_tom[l_ac].tom04,g_errno,0)
                        LET g_tom[l_ac].tom04 = g_tom_t.tom04
                        DISPLAY g_tom[l_ac].tom04 TO tom04
                        NEXT FIELD tom04
                     END IF
                 END IF
              END IF
            END IF
 
 
        AFTER FIELD tom06
            IF NOT cl_null(g_tom[l_ac].tom06) THEN
               IF g_tom[l_ac].tom06 > 1 OR g_tom[l_ac].tom06<0 THEN
                    LET g_tom[l_ac].tom06 = g_tom_t.tom06
                    DISPLAY g_tom[l_ac].tom06 TO tom06
                    CALL cl_err(g_tom[l_ac].tom06,'atm-307',0)
                    NEXT FIELD tom06
               END IF
            END IF
            IF NOT cl_null(g_tom[l_ac].tom05)
               AND (NOT cl_null(g_tom[l_ac].tom06)) THEN
               LET g_tom[l_ac].tom07 = g_tom[l_ac].tom05*g_tom[l_ac].tom06
            END IF
            DISPLAY g_tom[l_ac].tom07 TO tom07
 
        AFTER FIELD tom08
            IF not cl_null(g_tom[l_ac].tom08) THEN
               IF g_tom[l_ac].tom08 <= 0 THEN
                  CALL cl_err(g_tom[l_ac].tom08,'atm-121',0)
                  NEXT FIELD tom08
               END IF
            END IF
            IF NOT cl_null(g_tom[l_ac].tom07)
               AND (NOT cl_null(g_tom[l_ac].tom08)) THEN
               LET g_tom[l_ac].tom09 = g_tom[l_ac].tom07*g_tom[l_ac].tom08
            END IF
            DISPLAY g_tom[l_ac].tom09 TO tom09
 
        #No.FUN-840068 --start--
        AFTER FIELD tomud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tomud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               INITIALIZE g_tom[l_ac].* TO NULL  #重要欄位空白,無效
               DISPLAY g_tom[l_ac].* TO s_tom.*
               CALL g_tom.deleteElement(g_rec_b+1)
               ROLLBACK WORK
               EXIT INPUT
            END IF
            INSERT INTO tom_file(tom01,tom02,tom03,tom04,
                                 tom05,tom06,tom07,tom08,
                                 tom09,tom10,
                                 #FUN-840068 --start--
                                 tomud01,tomud02,tomud03,
                                 tomud04,tomud05,tomud06,
                                 tomud07,tomud08,tomud09,
                                 tomud10,tomud11,tomud12,
                                 tomud13,tomud14,tomud15)
                                 #FUN-840068 --end--
            VALUES(g_tol.tol01,g_tom[l_ac].tom02,
                    g_tom[l_ac].tom03,g_tom[l_ac].tom04,
                   g_tom[l_ac].tom05,g_tom[l_ac].tom06,
                   g_tom[l_ac].tom07,g_tom[l_ac].tom08,
                   g_tom[l_ac].tom09,
                   g_tom[l_ac].tom10,
                   #FUN-840068 --start--
                   g_tom[l_ac].tomud01,g_tom[l_ac].tomud02,
                   g_tom[l_ac].tomud03,g_tom[l_ac].tomud04,
                   g_tom[l_ac].tomud05,g_tom[l_ac].tomud06,
                   g_tom[l_ac].tomud07,g_tom[l_ac].tomud08,
                   g_tom[l_ac].tomud09,g_tom[l_ac].tomud10,
                   g_tom[l_ac].tomud11,g_tom[l_ac].tomud12,
                   g_tom[l_ac].tomud13,g_tom[l_ac].tomud14,
                   g_tom[l_ac].tomud15)
                   #FUN-840068 --end--
            IF SQLCA.sqlcode THEN
            #   CALL cl_err(g_tom[l_ac].tom02,SQLCA.sqlcode,0)   #No.FUN-660104
                CALL cl_err3("ins","tom_file",g_tom[l_ac].tom02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                # 新增至資料庫發生錯誤時, CANCEL INSERT,
                # 不需要讓舊值回復到原變數
                CANCEL INSERT
            ELSE
                CALL i212_update()
                IF g_success='Y' THEN
                   COMMIT WORK
                   MESSAGE 'INSERT O.K'
                ELSE
                   CALL cl_rbmsg(1)
                   ROLLBACK WORK
                   MESSAGE 'INSERT FAIL'
                END IF
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_tom_t.tom02 > 0 AND
               g_tom_t.tom02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM tom_file
                    WHERE tom01 = g_tol.tol01 AND
                          tom02 = g_tom_t.tom02
                IF SQLCA.sqlcode THEN
                #   CALL cl_err(g_tom_t.tom02,SQLCA.sqlcode,0)   #No.FUN-660104
                    CALL cl_err3("del","tom_file",g_tom_t.tom02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        AFTER DELETE
            CALL i212_update()
            IF g_success='Y' THEN
               COMMIT WORK
            ELSE
               CALL cl_rbmsg(1) ROLLBACK WORK
            END IF
            LET l_n = ARR_COUNT()
            INITIALIZE g_tom[l_n+1].* TO NULL
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tom[l_ac].* = g_tom_t.*
               CLOSE i212_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tom[l_ac].tom02,-263,1)
               LET g_tom[l_ac].* = g_tom_t.*
            ELSE
               UPDATE tom_file SET tom02= g_tom[l_ac].tom02,
                                   tom03= g_tom[l_ac].tom03,
                                   tom04= g_tom[l_ac].tom04,
                                   tom05= g_tom[l_ac].tom05,
                                   tom06= g_tom[l_ac].tom06,
                                   tom07= g_tom[l_ac].tom07,
                                   tom08= g_tom[l_ac].tom08,
                                   tom09= g_tom[l_ac].tom09,
                                   tom10= g_tom[l_ac].tom10,
                                   #FUN-840068 --start--
                                   tomud01 = g_tom[l_ac].tomud01,
                                   tomud02 = g_tom[l_ac].tomud02,
                                   tomud03 = g_tom[l_ac].tomud03,
                                   tomud04 = g_tom[l_ac].tomud04,
                                   tomud05 = g_tom[l_ac].tomud05,
                                   tomud06 = g_tom[l_ac].tomud06,
                                   tomud07 = g_tom[l_ac].tomud07,
                                   tomud08 = g_tom[l_ac].tomud08,
                                   tomud09 = g_tom[l_ac].tomud09,
                                   tomud10 = g_tom[l_ac].tomud10,
                                   tomud11 = g_tom[l_ac].tomud11,
                                   tomud12 = g_tom[l_ac].tomud12,
                                   tomud13 = g_tom[l_ac].tomud13,
                                   tomud14 = g_tom[l_ac].tomud14,
                                   tomud15 = g_tom[l_ac].tomud15
                                   #FUN-840068 --end-- 
               WHERE tom01=g_tol.tol01 AND tom02=g_tom_t.tom02
               IF SQLCA.sqlcode THEN
               #   CALL cl_err(g_tom[l_ac].tom02,SQLCA.sqlcode,0)   #No.FUN-660104
                   CALL cl_err3("upd","tom_file",g_tom_t.tom02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                   LET g_tom[l_ac].* = g_tom_t.*
               ELSE
                   CALL i212_update()
                   IF g_success='Y' THEN
                      COMMIT WORK
                      MESSAGE 'UPDATE O.K'
                   ELSE
                      CALL cl_rbmsg(1)
                      ROLLBACK WORK
                      MESSAGE 'UPDATE FAIL'
                   END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               # 當為修改狀態且取消輸入時, 才作回復舊值的動作
               IF p_cmd = 'u' THEN
                  LET g_tom[l_ac].* = g_tom_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_tom.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
 
               CLOSE i212_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30033 add 
            # 除了修改狀態取消時, 其餘不需要回復舊值或備份舊值
 
            CLOSE i212_bcl
            COMMIT WORK
 
            CALL g_tom.deleteElement(g_rec_b+1)
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tom02) AND l_ac > 1 THEN
                LET g_tom[l_ac].* = g_tom[l_ac-1].*
                NEXT FIELD tom02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
#0212 --start--
        ON ACTION Ad_Material_Maintain
            LET g_cmd = 'atmi213 ',"'",g_tol.tol01 clipped,"'",g_tom[l_ac].tom02 clipped
            CALL cl_cmdrun(g_cmd)
#0212 --end--
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tom03) #媒體編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tof"
                 LET g_qryparam.default1 = g_tom[l_ac].tom03
                 CALL cl_create_qry() RETURNING g_tom[l_ac].tom03
                 DISPLAY BY NAME g_tom[l_ac].tom03
                 NEXT FIELD tom03
               WHEN INFIELD(tom04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tog"
                 LET g_qryparam.arg1 =g_tom[l_ac].tom03
                 LET g_qryparam.default1 = g_tom[l_ac].tom04
                 CALL cl_create_qry() RETURNING g_tom[l_ac].tom04,g_tom[l_ac].tom05
                 DISPLAY g_tom[l_ac].tom04 TO tom04
                 NEXT FIELD tom04
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        END INPUT
 
        CLOSE i212_bcl
        COMMIT WORK
        CALL i212_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i212_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM tol_file WHERE tol01 = g_tol.tol01
         INITIALIZE g_tol.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION i212_tom03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
           l_tof02   LIKE tof_file.tof02,
           l_tofacti LIKE tof_file.tofacti,
           l_geo02   LIKE geo_file.geo02,
           l_geoacti LIKE geo_file.geoacti,
           l_too02   LIKE too_file.too02,
           l_tooacti LIKE too_file.tooacti
 
    LET g_errno = ' '
 
    SELECT tof02,tofacti,geo02,geoacti,too02,tooacti
      INTO l_tof02,l_tofacti,l_geo02,l_geoacti,l_too02,l_tooacti
      FROM tof_file, OUTER geo_file, OUTER too_file
     WHERE tof01 = g_tom[l_ac].tom03
       AND tofacti = 'Y'
       AND tof_file.tof05 = geo_file.geo01
       AND tof_file.tof06 = too_file.too01
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 100
                                  LET l_tofacti = NULL
                                  LET l_tof02   = NULL
                                  LET l_geoacti = NULL
                                  LET l_geo02   = NULL
                                  LET l_tooacti = NULL
                                  LET l_too02   = NULL
         WHEN l_tofacti='N'       LET g_errno = '9028'
         WHEN l_geoacti='N'       LET g_errno = '9028'
         WHEN l_tooacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_tom[l_ac].tof02 = l_tof02
    LET g_tom[l_ac].gea02 = l_geo02
    LET g_tom[l_ac].too02 = l_too02
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_tom[l_ac].tof02 TO tof02
       DISPLAY g_tom[l_ac].gea02 TO gea02
       DISPLAY g_tom[l_ac].too02 TO too02
    END IF
 
END FUNCTION
 
FUNCTION i212_tom04(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
           l_tog03   LIKE tog_file.tog03,
           l_tog04   LIKE tog_file.tog04,
           l_tog06   LIKE tog_file.tog06,
           l_toa02   LIKE toa_file.toa02,
           l_toaacti LIKE toa_file.toaacti
 
    LET g_errno = ''
    SELECT tog03,tog04,tog06,toa02,toaacti
      INTO l_tog03,l_tog04,l_tog06,l_toa02,l_toaacti
      FROM tog_file, OUTER toa_file
     WHERE tog01 = g_tom[l_ac].tom03
       AND tog02 = g_tom[l_ac].tom04
       AND tog_file.tog05 = toa_file.toa01
       AND toa_file.toa03 = '6'
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 100
                                   LET l_tog03   = NULL
                                   LET l_toaacti = NULL
                                   LET l_toa02   = NULL
                                   LET l_tog04   = NULL
         WHEN l_toaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_tom[l_ac].tog03 = l_tog03
    LET g_tom[l_ac].tog04 = l_tog04
    LET g_tom[l_ac].toa02 = l_toa02
    LET g_tom[l_ac].tom05 = l_tog06
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_tom[l_ac].tog03 TO tog03
       DISPLAY g_tom[l_ac].tog04 TO tog04
       DISPLAY g_tom[l_ac].toa02 TO toa02
       DISPLAY g_tom[l_ac].tom05 TO tom05
    END IF
END FUNCTION
 
FUNCTION i212_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
 
    CONSTRUCT l_wc2 ON tom02,tom03,tof02,gea02,too02,   #螢幕上取單身條件
                       tom04,tog03,tog04,toa02,tom05,
                       tom06,tom07,tom08,tom09,tom10
                       #No.FUN-840068 --start--
                       ,tomud01,tomud02,tomud03,tomud04,tomud05
                       ,tomud06,tomud07,tomud08,tomud09,tomud10
                       ,tomud11,tomud12,tomud13,tomud14,tomud15
                       #No.FUN-840068 ---end---
           FROM s_tom[1].tom02,s_tom[1].tom03,s_tom[1].tof02,
                s_tom[1].gea02,s_tom[1].too02,s_tom[1].tom04,
                s_tom[1].tog03,s_tom[1].tog04,s_tom[1].toa02,
                s_tom[1].tom05,s_tom[1].tom06,s_tom[1].tom07,
                s_tom[1].tom07,s_tom[1].tom08,s_tom[1].tom09,s_tom[1].tom10
                #No.FUN-840068 --start--
                ,s_tom[1].tomud01,s_tom[1].tomud02,s_tom[1].tomud03
                ,s_tom[1].tomud04,s_tom[1].tomud05,s_tom[1].tomud06
                ,s_tom[1].tomud07,s_tom[1].tomud08,s_tom[1].tomud09
                ,s_tom[1].tomud10,s_tom[1].tomud11,s_tom[1].tomud12
                ,s_tom[1].tomud13,s_tom[1].tomud14,s_tom[1].tomud15
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i212_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i212_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT tom02,tom03,'','','',tom04,'','','',",
        "       tom05,tom06,tom07,tom08,",
        "       tom09,tom10, ",
        #No.FUN-840068 --start--
        "       tomud01,tomud02,tomud03,tomud04,tomud05,",
        "       tomud06,tomud07,tomud08,tomud09,tomud10,",
        "       tomud11,tomud12,tomud13,tomud14,tomud15", 
        #No.FUN-840068 ---end---
        "  FROM tom_file ",
        " WHERE tom01 ='",g_tol.tol01,"'",  #單頭
         "  AND ", p_wc2 CLIPPED, #單身
        " ORDER BY tom02"
 
    PREPARE i212_pb FROM g_sql
    DECLARE tom_cs                       #SCROLL CURSOR
        CURSOR FOR i212_pb
    CALL g_tom.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH tom_cs INTO g_tom[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_ac = g_cnt
        CALL i212_tom03('d')
        CALL i212_tom04('d')
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tom.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i212_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("Ad_Material_Maintain", FALSE)    #0212
   DISPLAY ARRAY g_tom TO s_tom.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL i212_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tol in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######tol in 040505
           END IF
           ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i212_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tol in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######tol in 040505
           END IF
	ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i212_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION next
         CALL i212_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION last
         CALL i212_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION Ad_Material_Maintain
         LET g_action_choice="Ad_Material_Maintain"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
    
      #FUN-D20039 --------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 --------------end
 
      ON ACTION close_the_case
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
 
      ON ACTION undo_close
         LET g_action_choice="undo_close"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
 
FUNCTION i212_copy()
DEFINE
    l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_newno         LIKE tol_file.tol01,
    l_oldno         LIKE tol_file.tol01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tol.tol01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i212_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno FROM tol01
 
        AFTER FIELD tol01
            IF NOT cl_null(l_newno) THEN
               SELECT COUNT(*) INTO l_n FROM tol_file
                WHERE tol01 = l_newno
               IF l_n >0 THEN
                  CALL cl_err(l_newno,-239,1)
                  LET l_newno = ''
                  NEXT FIELD tol01
               END IF
            END IF
 
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
        DISPLAY BY NAME g_tol.tol01
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM tol_file         #單頭複製
        WHERE tol01=g_tol.tol01
        INTO TEMP y
    UPDATE y
        SET tol01=l_newno,    #新的鍵值
            toluser=g_user,   #資料所有者
            tolgrup=g_grup,   #資料所有者所屬群
            tolmodu=NULL,     #資料更改日期
            toldate=g_today,  #資料建立日期
            tolacti='Y',      #有效資料
            tol13='N',        #審核碼
            tol14='0'         #狀態碼
    INSERT INTO tol_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM tom_file         #單身複製
        WHERE tom01=g_tol.tol01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)   #No.FUN-660104
        CALL cl_err3("ins","x",g_tol.tol01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        RETURN
    END IF
    UPDATE x
        SET tom01=l_newno
    INSERT INTO tom_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)   #No.FUN-660104
        CALL cl_err3("ins","tom_file",g_tol.tol01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_tol.tol01
     SELECT tol_file.* INTO g_tol.* FROM tol_file
      WHERE tol01 = l_newno
     CALL i212_u()
     CALL i212_b()
     #SELECT tol_file.* INTO g_tol.* FROM tol_file  #FUN-C80046
     # WHERE tol01 = l_oldno   #FUN-C80046
     #CALL i212_show()         #FUN-C80046
END FUNCTION
 
FUNCTION i212_update()
 DEFINE l_tol09 LIKE tol_file.tol09
 
   SELECT SUM(tom09) INTO l_tol09 FROM tom_file
    WHERE tom01=g_tol.tol01
   IF cl_null(l_tol09) THEN LET l_tol09 = 0 END IF
   UPDATE tol_file SET tol09=l_tol09
    WHERE tol01=g_tol.tol01
   IF STATUS THEN
   #  CALL cl_err('upd tol09:',STATUS,0)   #No.FUN-660104
      CALL cl_err3("upd","tol_file",g_tol.tol01,"",STATUS,"","upd tol09:",1)   #No.FUN-660104
      LET g_success='N'
   END IF
   DISPLAY l_tol09 TO tol09
END FUNCTION
 
FUNCTION i212_y()
    IF g_tol.tol01 IS NULL THEN RETURN END IF
#CHI-C30107 -------------- add --------------- begin
    IF g_tol.tolacti='N' THEN
       CALL cl_err(g_tol.tol01,'mfg1000',0)
       RETURN
    END IF
    IF g_tol.tol13='Y' THEN RETURN END IF
    IF g_tol.tol13='X' THEN
       CALL cl_err('','axr-103',0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF 
#CHI-C30107 -------------- add --------------- end
    SELECT * INTO g_tol.* FROM tol_file WHERE tol01=g_tol.tol01
    IF g_tol.tolacti='N' THEN
       CALL cl_err(g_tol.tol01,'mfg1000',0)
       RETURN
    END IF
    IF g_tol.tol13='Y' THEN RETURN END IF
    IF g_tol.tol13='X' THEN
       CALL cl_err('','axr-103',0)
       RETURN
    END IF
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN i212_cl USING g_tol.tol01
    IF STATUS THEN
       CALL cl_err("OPEN i212_cl:", STATUS, 1)
       CLOSE i212_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i212_cl INTO g_tol.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)
        CLOSE i212_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE tol_file SET tol13='Y',tol14='1'
     WHERE tol01 = g_tol.tol01
    IF STATUS THEN
    #  CALL cl_err('upd tol13',STATUS,0)  #No.FUN-660104
       CALL cl_err3("upd","tol_file",g_tol.tol01,"",STATUS,"","upd tol13",1)  #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tol13,tol14 INTO g_tol.tol13,g_tol.tol14 FROM tol_file
     WHERE tol01 = g_tol.tol01
    DISPLAY BY NAME g_tol.tol13
    DISPLAY BY NAME g_tol.tol14
END FUNCTION
 
FUNCTION i212_z()
DEFINE l_n LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tol.tol01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tol.* FROM tol_file WHERE tol01=g_tol.tol01
    IF g_tol.tol13='N' THEN RETURN END IF
    IF g_tol.tol13='X' THEN
       CALL cl_err('','axr-103',0)
       RETURN
    END IF
    IF g_tol.tol14 = '6' THEN
       CALL cl_err("","aap-730",0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
        OPEN i212_cl USING g_tol.tol01
        IF STATUS THEN
           CALL cl_err("OPEN i212_cl:", STATUS, 1)
           CLOSE i212_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH i212_cl INTO g_tol.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)
            CLOSE i212_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE tol_file SET tol13='N',tol14='0'
            WHERE tol01 = g_tol.tol01
        IF STATUS THEN
        #   CALL cl_err('upd tol13',STATUS,0)  #No.FUN-660104
            CALL cl_err3("upd","tol_file",g_tol.tol01,"",STATUS,"","upd tol13",1)  #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT tol13,tol14 INTO g_tol.tol13,g_tol.tol14 FROM tol_file
            WHERE tol01 = g_tol.tol01
        DISPLAY BY NAME g_tol.tol13
        DISPLAY BY NAME g_tol.tol14
END FUNCTION
 
FUNCTION i212_1()
    IF g_tol.tol01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tol.* FROM tol_file WHERE tol01=g_tol.tol01
    IF g_tol.tolacti='N' THEN
       CALL cl_err(g_tol.tol01,'mfg1000',0)
       RETURN
    END IF
    IF g_tol.tol13='N' THEN
       CALL cl_err('',9026,0)
       RETURN
    END IF
    IF g_tol.tol13='X' THEN
       CALL cl_err('','axr-103',0)
       RETURN
    END IF
    IF g_tol.tol14='0' THEN
       CALL cl_err('',9026,0)
       RETURN
    END IF
    IF g_tol.tol14='6' THEN
       RETURN
    END IF
    IF g_tol.tol14='9' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
 
    IF NOT cl_confirm('axr-247') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN i212_cl USING g_tol.tol01
    IF STATUS THEN
       CALL cl_err("OPEN i212_cl:", STATUS, 1)
       CLOSE i212_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i212_cl INTO g_tol.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)
        CLOSE i212_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE tol_file SET tol13='Y',tol14='6'
     WHERE tol01 = g_tol.tol01
    IF STATUS THEN
    #  CALL cl_err('upd tol13',STATUS,0)  #No.FUN-660104
       CALL cl_err3("upd","tol_file",g_tol.tol01,"",STATUS,"","upd tol13",1)  #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tol13,tol14 INTO g_tol.tol13,g_tol.tol14 FROM tol_file
     WHERE tol01 = g_tol.tol01
    DISPLAY BY NAME g_tol.tol13
    DISPLAY BY NAME g_tol.tol14
END FUNCTION
 
FUNCTION i212_2()
    IF g_tol.tol01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tol.* FROM tol_file WHERE tol01=g_tol.tol01
    IF g_tol.tolacti='N' THEN
       CALL cl_err(g_tol.tol01,'mfg1000',0)
       RETURN
    END IF
    IF g_tol.tol13='X' THEN
       CALL cl_err('','axr-103',0)
       RETURN
    END IF
    IF g_tol.tol14 NOT MATCHES "[6]" THEN
       CALL cl_err('','atm-300',0)
       RETURN
    END IF
    IF NOT cl_confirm('amm-050') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN i212_cl USING g_tol.tol01
    IF STATUS THEN
       CALL cl_err("OPEN i212_cl:", STATUS, 1)
       CLOSE i212_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i212_cl INTO g_tol.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tol.tol01,SQLCA.sqlcode,0)
        CLOSE i212_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE tol_file SET tol13='Y',tol14='1'
     WHERE tol01 = g_tol.tol01
    IF STATUS THEN
    #  CALL cl_err('upd tol13',STATUS,0)  #No.FUN-660104
       CALL cl_err3("upd","tol_file",g_tol.tol01,"",STATUS,"","upd tol13",1)  #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tol13,tol14 INTO g_tol.tol13,g_tol.tol14 FROM tol_file
     WHERE tol01 = g_tol.tol01
    DISPLAY BY NAME g_tol.tol13
    DISPLAY BY NAME g_tol.tol14
END FUNCTION
 
FUNCTION i212_out()
    DEFINE
        l_tol           RECORD LIKE tol_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
        l_za05          LIKE za_file.za05,
        sr              RECORD
                        tol01       LIKE tol_file.tol01,
                        tol02       LIKE tol_file.tol02,
                        tol03       LIKE tol_file.tol03,
                        toa02       LIKE toa_file.toa02,
                        tol04       LIKE tol_file.tol04,
                        tol05       LIKE tol_file.tol05,
                        pmc03       LIKE pmc_file.pmc03,
                        tol06       LIKE tol_file.tol06,
                        tol07       LIKE tol_file.tol07,
                        tol08       LIKE tol_file.tol08,
                        tol09       LIKE tol_file.tol09,
                        tol10       LIKE tol_file.tol10,
                        tol11       LIKE tol_file.tol11,
                        tol12       LIKE tol_file.tol12,
                        tol13       LIKE tol_file.tol13,
                        tol14       LIKE tol_file.tol14,
                        tom02       LIKE tom_file.tom02,
                        tom03       LIKE tom_file.tom03,
                        tof02       LIKE tof_file.tof02,
                        gea02       LIKE gea_file.gea02,
                        too02       LIKE too_file.too02,
                        tom04       LIKE tom_file.tom04,
                        tog03       LIKE tog_file.tog03,
                        tog04       LIKE tog_file.tog04,
                        tom05       LIKE tom_file.tom05,
                        tom06       LIKE tom_file.tom06,
                        tom07       LIKE tom_file.tom07,
                        tom08       LIKE tom_file.tom08,
                        tom09       LIKE tom_file.tom09,
                        tom10       LIKE tom_file.tom10,
                        tog05       LIKE tog_file.tog05
                        END RECORD
DEFINE l_sql1     LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(500)
DEFINE l_tof05    LIKE tof_file.tof05
DEFINE l_tof06    LIKE tof_file.tof06
DEFINE l_geo01    LIKE geo_file.geo01
DEFINE l_toa02    LIKE toa_file.toa02                 #No.FUN-760083
    IF cl_null(g_wc) THEN
       LET g_wc=" tol01='",g_tol.tol01,"'"
       LET g_wc2=" 1=1 "
    END IF
    #CALL cl_wait()                                         #No.FUN-760083
    #CALL cl_outnam('atmi212') RETURNING l_name             #No.FUN-760083
    LET g_str=''                                            #No.FUN-760083
    CALL cl_del_data(l_table)                               #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog  #No.FUN-760083
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT tol01,tol02,tol03,'',tol04,tol05,'',tol06,tol07,",
              "       tol08,tol09,tol10,tol11,tol12,tol13,tol14,tom02,tom03,",
              "       '','','',tom04,'','',tom05,tom06,",
              "       tom07,tom08,tom09,tom10,'' ",
              "  FROM tol_file,tom_file ",   #,too_file,gea_file, ",
              " WHERE tol01=tom01 ",
              "   AND ",g_wc," AND ",g_wc2 CLIPPED
 
    PREPARE i212_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i212_co                         # CURSOR
        CURSOR FOR i212_p1
 
    #START REPORT i212_rep TO l_name                     #No.FUN-760083
 
      FOREACH i212_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT tof02,geo02,geo01 INTO sr.tof02,sr.gea02,l_geo01
          FROM tof_file,geo_file WHERE tof01=sr.tom03 AND geo01=tof05
        SELECT too02 INTO sr.too02
          FROM too_file,tof_file WHERE too03=l_geo01
                                   AND tof01=sr.tom03
                                   AND too01=tof06
        SELECT tog03,tog04,tog05 INTO sr.tog03,sr.tog04,sr.tog05
          FROM tog_file WHERE tog01=sr.tom03 AND tog02=sr.tom04
        SELECT toa02 INTO sr.toa02 FROM toa_file WHERE toa01=sr.tol03  #No.FUN-760083                                                          
        SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc01=sr.tol05  #No.FUN-760083
        SELECT toa02 INTO l_toa02 FROM toa_file                        #No.FUN-760083                                                         
             WHERE toa01=sr.tog05  #AND toa03='6'                      #No.FUN-760083
        EXECUTE insert_prep USING  sr.tol01,sr.tol02,sr.tol03,sr.toa02,sr.tol04,sr.tol05,  #No.FUN-760083
                                   sr.pmc03,sr.tol06,sr.tol07,sr.tol08,sr.tol09,sr.tol10,  #No.FUN-760083                                                          
                                   sr.tol11,sr.tol12,sr.tol13,sr.tol14,sr.tom02,sr.tom03,  #No.FUN-760083                                                    
                                   sr.tof02,sr.gea02,sr.too02,sr.tom04,sr.tog03,sr.tog04,  #No.FUN-760083
                                   sr.tom05,sr.tom06,sr.tom07,sr.tom08,sr.tom09,sr.tom10,  #No.FUN-760083
                                   sr.tog05,l_toa02,l_geo01                                #No.FUN-760083                                                                         
      #OUTPUT TO REPORT i212_rep(sr.*)                     #No.FUN-760083
      END FOREACH
 
    #FINISH REPORT i212_rep                                #No.FUN-760083
 
    CLOSE i212_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                     #No.FUN-760083
#No.FUN-760083  --begin--
    IF g_zz05='Y' THEN 
      CALL cl_wcchp(g_wc,'tol01,tol02,tol03,tol04,tol05,tol06,                                                                         
                          tol07,tol08,tol09,tol10,tol11,tol12,                                                                         
                          tol13,tol14,                                                                                                 
                          toluser,tolgrup,tolmodu,toldate,tolacti')
      RETURNING  g_wc
    END IF
    LET g_str=g_wc,';',g_azi03,';',g_azi04
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3("atmi212","atmi212",g_sql,g_str)        
#No.FUN-760083 --end--
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT i212_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_toa02         LIKE toa_file.toa02,
        sr              RECORD
                        tol01       LIKE tol_file.tol01,
                        tol02       LIKE tol_file.tol02,
                        tol03       LIKE tol_file.tol03,
                        toa02       LIKE toa_file.toa02,
                        tol04       LIKE tol_file.tol04,
                        tol05       LIKE tol_file.tol05,
                        pmc03       LIKE pmc_file.pmc03,
                        tol06       LIKE tol_file.tol06,
                        tol07       LIKE tol_file.tol07,
                        tol08       LIKE tol_file.tol08,
                        tol09       LIKE tol_file.tol09,
                        tol10       LIKE tol_file.tol10,
                        tol11       LIKE tol_file.tol11,
                        tol12       LIKE tol_file.tol12,
                        tol13       LIKE tol_file.tol13,
                        tol14       LIKE tol_file.tol14,
                        tom02       LIKE tom_file.tom02,
                        tom03       LIKE tom_file.tom03,
                        tof02       LIKE tof_file.tof02,
                        gea02       LIKE gea_file.gea02,
                        too02       LIKE too_file.too02,
                        tom04       LIKE tom_file.tom04,
                        tog03       LIKE tog_file.tog03,
                        tog04       LIKE tog_file.tog04,
                        tom05       LIKE tom_file.tom05,
                        tom06       LIKE tom_file.tom06,
                        tom07       LIKE tom_file.tom07,
                        tom08       LIKE tom_file.tom08,
                        tom09       LIKE tom_file.tom09,
                        tom10       LIKE tom_file.tom10,
                        tog05       LIKE tog_file.tog05
                        END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.tol01,sr.tom02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
 
    BEFORE GROUP OF sr.tol01
            SKIP TO TOP OF PAGE
            SELECT toa02 INTO sr.toa02 FROM toa_file WHERE toa01=sr.tol03
            SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc01=sr.tol05
 
            PRINT COLUMN 1,g_x[11],sr.tol01 CLIPPED, COLUMN 30,g_x[12],sr.tol02,
                  COLUMN 60,g_x[13],sr.tol03 CLIPPED,
                  COLUMN 90,g_x[14],sr.toa02 CLIPPED
            PRINT COLUMN 1,g_x[15],sr.tol04 CLIPPED,
                  COLUMN 60,g_x[16],sr.tol05 CLIPPED,
                  COLUMN 90,g_x[17],sr.pmc03 CLIPPED
            PRINT COLUMN 1,g_x[18],sr.tol06,COLUMN 30,g_x[19],sr.tol07 CLIPPED,
                  COLUMN 60,g_x[20],sr.tol08
            PRINT COLUMN 1,g_x[21],sr.tol09 CLIPPED, COLUMN 60,g_x[22],sr.tol10
            PRINT COLUMN 1,g_x[23],sr.tol11 CLIPPED, COLUMN 60,g_x[24],sr.tol12
            CASE
              WHEN sr.tol13='N'
                PRINT COLUMN 1,g_x[25],g_x[51] CLIPPED;
              WHEN sr.tol13='Y'
                PRINT COLUMN 1,g_x[25],g_x[52] CLIPPED;
              WHEN sr.tol13='X'
                PRINT COLUMN 1,g_x[25],g_x[53] CLIPPED;
            END CASE
            CASE
              WHEN sr.tol14='0'
                PRINT COLUMN 30,g_x[26],g_x[54] CLIPPED
              WHEN sr.tol14='1'
                PRINT COLUMN 30,g_x[26],g_x[55] CLIPPED
              WHEN sr.tol14='6'
                PRINT COLUMN 30,g_x[26],g_x[56] CLIPPED
              WHEN sr.tol14='9'
                PRINT COLUMN 30,g_x[26],g_x[57] CLIPPED
            END CASE
            PRINT g_dash[1,g_len]
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],
                           g_x[35],g_x[36],g_x[37],g_x[38],g_x[45],
                           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
            PRINT g_dash1 	
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            SELECT toa02 INTO l_toa02 FROM toa_file
             WHERE toa01=sr.tog05  #AND toa03='6'
            PRINTX name=D1
                  COLUMN g_c[31],sr.tom02 USING '########',
                  COLUMN g_c[32],sr.tom03 CLIPPED,
                  COLUMN g_c[33],sr.tof02 CLIPPED,
                  COLUMN g_c[34],sr.gea02 CLIPPED,
                  COLUMN g_c[35],sr.too02 CLIPPED,
                  COLUMN g_c[36],sr.tom04 USING '##########',
                  COLUMN g_c[37],sr.tog03 CLIPPED,
                  COLUMN g_c[38],sr.tog04 CLIPPED,
                  COLUMN g_c[45],l_toa02 CLIPPED, #USING '####',
                  COLUMN g_c[39],cl_numfor(sr.tom05,39,g_azi03),
                  COLUMN g_c[40],sr.tom06 USING '&.&&&&',
                  COLUMN g_c[41],cl_numfor(sr.tom07,41,g_azi03),
                  COLUMN g_c[42],sr.tom08 USING '#########',
                  COLUMN g_c[43],cl_numfor(sr.tom09,43,g_azi04),
                  COLUMN g_c[44],sr.tom10 CLIPPED
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760083 --end--
 
