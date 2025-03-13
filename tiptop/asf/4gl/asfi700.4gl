# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfi700.4gl
# Descriptions...: 工單Check in 維護作業
# Date & Author..: 99/05/17 by patricia
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-490476 04/10/18 By Smapmin 新增作業編號開窗功能
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530444 05/03/29 By Carol 1.作業編號查詢改用q_ecm5(check工單)
#                                                  2.於工單製程中之作業編號才可以input,add錯誤訊息，不可過。
#                                                  3.輸入時員工編號自行帶出後,員工姓名同步顯示
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-570246 05/07/26 By Elva  月份改期別處理方式
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-660109 06/07/03 By Claire 加入ecm_file
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0164 06/11/13 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760202 07/06/28 By chenl   修正單身bug。
# Modify.........: No.TQC-780056 07/08/17 By Carrier oracle語法轉至ora文檔
# Modify.........: No.FUN-790001 07/09/03 By jamie PK問題
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0059 09/10/13 By liuxqa 非負控管。
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A50123 10/05/26 By houlia 錄入時，顯示單身資料
# Modify.........: No.FUN-A60011 10/06/22 By Carrier 单头加入KEY值工艺段号sha012
# Modify.........: No.TQC-A80023 10/08/11 by destiny 工單編號開窗過濾掉狀態為8的單號 
# Modify.........: No.TQC-AB0279 10/11/29 By jan sha012給預設值
# Modify.........: No.TQC-AC0374 10/12/29 By lixh1   從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取
# Modify.........: No.FUN-B10056 11/02/14 By vealxu 修改制程段號的管控

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sha          RECORD LIKE sha_file.*,
    g_sha_t        RECORD LIKE sha_file.*,
    g_ecm          RECORD LIKE ecm_file.*,
    g_sha01_t      LIKE sha_file.sha01,
    g_sha012_t     LIKE sha_file.sha012,             #No.FUN-A60011
    g_sha02_t      LIKE sha_file.sha02,
    g_h1,g_m1,g_s1 LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_wc,g_sql     string,  #No.FUN-580092 HCN
    g_ecbb         DYNAMIC ARRAY OF RECORD   #程式變數(Prinram Variables)
                   ecbb09     LIKE ecbb_file.ecbb09,
                   ecbb10     LIKE ecbb_file.ecbb10
                   END RECORD,
    g_rec_b        LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac           LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
 
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done STRING
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680121 INTEGER
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680121 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5        #No.FUN-680121 SMALLINT
#       l_time        LIKE type_file.chr8          #No.FUN-6A0090
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
    IF g_sma.sma54 !='Y' THEN
      CALL cl_err('','asf-718',3)
      EXIT PROGRAM
    END IF
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
    INITIALIZE g_sha.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM sha_file WHERE sha01 = ? AND sha012 = ? AND sha02 = ? AND sha04 = ? AND sha041 = ? AND sha08 = ? FOR UPDATE"  #No.FUN-A60011
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i700_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 5
    OPEN WINDOW i700_w AT p_row,p_col
         WITH FORM "asf/42f/asfi700"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #No.FUN-A60011  --Begin
    CALL cl_set_comp_visible("sha012,ecu014",g_sma.sma541='Y')
    #平行工艺时,工艺段号/工艺序开放,若非平行工艺时,作业编号开放
    CALL cl_set_comp_entry("sha012,sha02",g_sma.sma541='Y')
    CALL cl_set_comp_entry("ecm04",g_sma.sma541='N')
    #No.FUN-A60011  --End  
    CALL i700_menu()
 
    CLOSE WINDOW i700_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION i700_curs()
    CLEAR FORM
    CALL g_ecbb.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sha.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        sha01,sha012,sha02,ecm04,sha04,sha041,sha03,  #No.FUN-A60011
        sha05,sha06,sha07,shauser,shagrup,shaoriu,shaorig,shamodu,shadate  #No.FUN-A60011
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(sha01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_sfb01"
                 LET g_qryparam.default1 = g_sha.sha01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sha01
                 NEXT FIELD sha01
             #No.FUN-A60011  --Begin
             WHEN INFIELD(ecm04)
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_ecd2"
                 #LET g_qryparam.state = 'c'
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #DISPLAY g_qryparam.multiret TO ecm04
                 #NEXT FIELD ecm04
                 CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO FORMONLY.ecm04
                 NEXT FIELD ecm04
             WHEN INFIELD(sha02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_ecm3"
                 LET g_qryparam.default1 = g_sha.sha02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sha02
                 NEXT FIELD sha02
             WHEN INFIELD(sha012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
               # LET g_qryparam.form     = "q_ecu012_1"    #FUN-B10056 mark
                 LET g_qryparam.form     = "q_ecb012_1"    #FUN-B10056  
                 LET g_qryparam.default1 = g_sha.sha012
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sha012
                 NEXT FIELD sha012
             #No.FUN-A60011  --End  
 
             WHEN INFIELD(sha06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     ="q_gen"
                 LET g_qryparam.default1 = g_sha.sha06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sha06
                 NEXT FIELD sha06
              WHEN INFIELD(sha03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_ecg"
                 LET g_qryparam.default1 = g_sha.sha03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sha03
                 NEXT FIELD sha03
              OTHERWISE
                 EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND gebuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND gebgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND gebgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gebuser', 'gebgrup')
    #End:FUN-980030
 
    # 組合出 SQL 指令
    #No.FUN-A60011  --Begin
    LET g_sql="SELECT sha01,sha012,sha02,sha04,sha041,sha08 ",
              "  FROM sha_file LEFT OUTER JOIN ecm_file ",                   #TQC-660109  #No.TQC-780056  
              "                     ON  sha_file.sha01 = ecm_file.ecm01 ",
              "                     AND sha_file.sha012= ecm_file.ecm012",
              "                     AND sha_file.sha02 = ecm_file.ecm03 ",   #TQC-660109  #No.TQC-780056
              " WHERE (sha08 IS NULL OR sha08=' ') ",
              "   AND ",g_wc CLIPPED,
              " ORDER BY sha01,sha012,sha02 "              #TQC-660109
    #No.FUN-A60011  --End  
    PREPARE i700_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i700_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i700_prepare
    #No.FUN-A60011  --Begin
    LET g_sql="SELECT COUNT(*) ",
              "  FROM sha_file LEFT OUTER JOIN ecm_file ",                   #TQC-660109  #No.TQC-780056  
              "                     ON  sha_file.sha01 = ecm_file.ecm01 ",
              "                     AND sha_file.sha012= ecm_file.ecm012",
              "                     AND sha_file.sha02 = ecm_file.ecm03 ",   #TQC-660109  #No.TQC-780056
              " WHERE (sha08 IS NULL OR sha08=' ') ",
              "   AND ",g_wc CLIPPED
    #No.FUN-A60011  --End  
    PREPARE i700_precount FROM g_sql
    DECLARE i700_count CURSOR FOR i700_precount
END FUNCTION
 
FUNCTION i700_menu()
 
   WHILE TRUE
      CALL i700_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
                CALL i700_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i700_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i700_r()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecbb),'','')
            END IF
##
         #No.FUN-6A0164-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
                 IF g_sha.sha01 IS NOT NULL THEN            
                    LET g_doc.column1 = "sha01"               
                    LET g_doc.column2 = "sha02" 
                    LET g_doc.column3 = "sha04"
                    LET g_doc.column4 = "sha041"  
                    LET g_doc.value1 = g_sha.sha01            
                    LET g_doc.value2 = g_sha.sha02
                    LET g_doc.value3 = g_sha.sha04
                    LET g_doc.value4 = g_sha.sha041
                    #No.FUN-A60011  --Begin
                    LET g_doc.column5 = "sha012"  
                    LET g_doc.value5 = g_sha.sha012
                    #No.FUN-A60011  --End  
                    CALL cl_doc() 
             END IF 
          END IF
         #No.FUN-6A0164-------add--------end----
      END CASE
   END WHILE
    CLOSE i700_cs
END FUNCTION
 
FUNCTION i700_a()
  DEFINE l_total,l_qty  LIKE ecm_file.ecm291
  DEFINE l_msg          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(50)
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    CALL g_ecbb.clear()
    INITIALIZE g_sha.* LIKE sha_file.*
    LET g_sha01_t = NULL
    LET g_sha02_t = NULL
    LET g_sha012_t= NULL  #No.FUN-A60011
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ecm.ecm04 = ""
        LET g_sha.sha04 = g_today
        LET g_sha.sha041 = TIME
        LET g_sha.sha06 = g_user
         CALL i700_sha06('d')                 #MOD-530444-3
        LET g_sha.shauser = g_user
        LET g_sha.shaoriu = g_user #FUN-980030
        LET g_sha.shaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_sha.shagrup = g_grup           #使用者所屬群
        LET g_sha.shadate = g_today
        LET g_sha.shaacti = 'Y'
        LET g_sha.shaplant = g_plant #FUN-980008 add
        LET g_sha.shalegal = g_legal #FUN-980008 add
        #NO.TQC-AB0279--begin
        IF g_sma.sma541='N' THEN
           LET g_sha.sha012=' '
        END IF
        #NO.TQC-AB0279--end

        CALL i700_i("a")                     # 各欄位輸入
        IF INT_FLAG THEN                     # 若按了DEL鍵
            INITIALIZE g_sha.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_ecbb.clear()
            EXIT WHILE
        END IF
        IF g_sha.sha01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        CALL i700_b_fill()           #TQC-A50123 add
        #-->再一次檢查防止兩人同時輸入
        #-->本站可check in數量=(總投入量 - 已check in數量(ecm291))
        SELECT (ecm301+ecm302+ecm303-ecm291) INTO l_total  FROM ecm_file
         WHERE ecm01 = g_sha.sha01 AND ecm03 = g_sha.sha02
           AND ecm012= g_sha.sha012    #No.FUN-A60011
          IF g_sha.sha05 > l_total THEN
             LET l_qty =l_total - g_sha.sha05
             LET l_msg ='QTY:',l_qty
             CALL cl_err(l_msg,'asf-717',0)
             CONTINUE WHILE
          END IF
        IF cl_null(g_sha.sha08) THEN LET g_sha.sha08=' ' END IF  #FUN-790001 add
        INSERT INTO sha_file VALUES(g_sha.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_sha.sha01,SQLCA.sqlcode,0)   #No.FUN-660128
           CALL cl_err3("ins","sha_file",g_sha.sha01,g_sha.sha02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
           CONTINUE WHILE
        ELSE
            SELECT sha01 INTO g_sha.sha01 FROM sha_file
                     WHERE sha01 = g_sha.sha01
                       AND sha02 = g_sha.sha02
                       AND sha012= g_sha.sha012  #No.FUN-A60011
                       AND sha04 = g_sha.sha04
                       AND sha041= g_sha.sha041 AND sha08= g_sha.sha08
            CALL i700_upd_ecm()  #Update check in 量
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i700_i(p_cmd)
    DEFINE l_ima02  LIKE ima_file.ima02,
           l_ima021 LIKE ima_file.ima021,
           l_ecm04  LIKE ecm_file.ecm04,
           l_ecm45  LIKE ecm_file.ecm45,
           l_ecm06  LIKE ecm_file.ecm06,
           l_ecm05  LIKE ecm_file.ecm05,
           l_ecm54  LIKE ecm_file.ecm54,
           l_ecm55  LIKE ecm_file.ecm55,
           l_sha02  LIKE sha_file.sha02,
           l_sha012 LIKE sha_file.sha012,              #No.FUN-A60011
           total    LIKE ecm_file.ecm291,
           l_year,l_mon  LIKE type_file.num5,          #No.FUN-680121  SMALLINT
           p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_n             LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    DISPLAY BY NAME g_sha.sha04,g_sha.sha041,g_sha.sha06
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
    INPUT BY NAME g_sha.shaoriu,g_sha.shaorig,
        g_sha.sha01,g_sha.sha012,g_sha.sha02,g_ecm.ecm04,g_sha.sha04,  #No.FUN-A60011
        g_sha.sha041,g_sha.sha03,g_sha.sha05,
        g_sha.sha06,g_sha.sha07,
        g_sha.shauser,g_sha.shagrup,g_sha.shamodu,g_sha.shadate
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i700_set_entry(p_cmd)
            CALL i700_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550067 --start--
         CALL cl_set_docno_format("sha01")
         #No.FUN-550067 ---end---
 
        AFTER FIELD sha01
            IF NOT cl_null(g_sha.sha01) THEN
               CALL i700_sha01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sha.sha01,g_errno,0)
                  LET g_sha.sha01 = g_sha_t.sha01
                  DISPLAY BY NAME g_sha.sha01
                  NEXT FIELD sha01
               END IF
               #No.FUN-A60011  --Begin
               CALL i700_ecm_chk(g_sha.sha01,g_sha.sha012,g_sha.sha02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sha.sha01,g_errno,0)
                  LET g_sha.sha01 = g_sha_t.sha01
                  DISPLAY BY NAME g_sha.sha01
                  NEXT FIELD sha01
               ELSE
                  CALL i700_ecm_show()
               END IF
               #No.FUN-A60011  --End  
            END IF
 
        AFTER FIELD sha04
            IF NOT cl_null(g_sha.sha04) THEN
            #FUN-570246  --begin
            #LET l_year = YEAR(g_sha.sha04)
            #LET l_mon  =  MONTH(g_sha.sha04)
            CALL s_yp(g_sha.sha04) RETURNING l_year,l_mon
            #FUN-570246  --end
            IF l_year > g_sma.sma51 THEN
               #No.+045 010409 by plum
               #CALL cl_err('不可大於目前會計年度!!','',1)
               CALL cl_err(g_sma.sma51,'agl-030',1)
               NEXT FIELD sha04
            END IF
            IF (l_year = g_sma.sma52 AND l_mon > g_sma.sma52) THEN
               #CALL cl_err('不可大於目前會計年度及期別!!',STATUS,1)
               CALL cl_err(g_sma.sma52,'agl-030',1)
               NEXT FIELD sha04
            END IF
            IF g_sha.sha04 <= g_sma.sma53 THEN
               #CALL cl_err('check in日期須大於會計日期','',1)
               CALL cl_err(g_sma.sma53,'asf-030',1)
               NEXT FIELD sha04
            END IF
            END IF
 
        AFTER FIELD sha041
            IF NOT cl_null(g_sha.sha041) THEN
               LET g_h1=g_sha.sha041[1,2]
               LET g_m1=g_sha.sha041[4,5]
               LET g_s1=g_sha.sha041[7,8]
               IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>23 OR g_m1>=60
               THEN CALL cl_err(g_sha.sha041,'asf-807',1)
                    NEXT FIELD sha041
               END IF
            END IF

        #No.FUN-A60011  --Begin
        AFTER FIELD sha012
            IF cl_null(g_sha.sha01) THEN NEXT FIELD sha01 END IF
            IF g_sha.sha012 IS NOT NULL THEN
               CALL i700_ecm_chk(g_sha.sha01,g_sha.sha012,g_sha.sha02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sha.sha012,g_errno,0)
                  LET g_sha.sha012 = g_sha_t.sha012
                  DISPLAY BY NAME g_sha.sha012
                  NEXT FIELD sha012
               ELSE
                  CALL i700_ecm_show()
               END IF
            ELSE
               LET g_sha.sha012 = ' '
            END IF

        AFTER FIELD sha02
            IF cl_null(g_sha.sha01) THEN NEXT FIELD sha01 END IF
            IF g_sha.sha012 IS NULL THEN LET g_sha.sha012 = ' ' END IF
            IF NOT cl_null(g_sha.sha02) THEN 
               CALL i700_ecm_chk(g_sha.sha01,g_sha.sha012,g_sha.sha02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sha.sha02,g_errno,0)
                  LET g_sha.sha02 = g_sha_t.sha02
                  DISPLAY BY NAME g_sha.sha02
                  NEXT FIELD sha02
               ELSE
                  CALL i700_ecm_show()
               END IF
            END IF
        #No.FUN-A60011  --End  
 
        AFTER FIELD ecm04
          IF NOT cl_null(g_ecm.ecm04) THEN
            #-->此判斷要考慮作業編號可能不為uniuqe
            IF g_sha.sha012 IS NULL THEN LET g_sha.sha012 = ' ' END IF   #No.FUN-A60011
            SELECT COUNT(*) INTO g_cnt FROM ecm_file
              WHERE ecm01=g_sha.sha01 AND ecm04=g_ecm.ecm04  #MOD-530444-2 add check ecm01 = sha01
                AND ecm012=g_sha.sha012   #No.FUN-A60011
             CASE
              WHEN g_cnt=0   #作業編號完全不存在
                   CALL cl_err(g_ecm.ecm04,100,0)
                   NEXT FIELD ecm04
              WHEN g_cnt=1   #作業編號存在一筆
                   SELECT ecm03,ecm05,ecm45,ecm06,ecm54,ecm55,ecm012                         #No.FUN-A60011
                     INTO g_sha.sha02,l_ecm05,l_ecm45,l_ecm06,l_ecm54,l_ecm55,g_sha.sha012   #No.FUN-A60011
                     FROM ecm_file
                    WHERE ecm01=g_sha.sha01 AND ecm04=g_ecm.ecm04
                   IF STATUS THEN  #資料資料不存在
#                     CALL cl_err(g_ecm.ecm04,STATUS,0)   #No.FUN-660128
                      CALL cl_err3("sel","ecm_file",g_sha.sha01,"",STATUS,"","",1)  #No.FUN-660128
                      NEXT FIELD ecm04
                   END IF
                   IF l_ecm54 = 'N' THEN
                      CALL cl_err(g_ecm.ecm04,'asf-719',1)
                      NEXT FIELD ecm04
                   END IF
                   #-->Check-in  hold
                   IF not cl_null(l_ecm55)  THEN
                      CALL cl_err(g_ecm.ecm04,'asf-726',1)
                      NEXT FIELD ecm04
                   END IF
              WHEN g_cnt>1
{
#                  CALL q_ecm1(0,0,g_sha.sha01,g_ecm.ecm04)
#                       RETURNING g_ecm.ecm04,g_sha.sha02
                   CALL q_ecm1(FALSE,FALSE,g_sha.sha01,g_ecm.ecm04)
                        RETURNING g_ecm.ecm04,g_sha.sha02
#                   CALL FGL_DIALOG_SETBUFFER( g_ecm.ecm04 )
#                   CALL FGL_DIALOG_SETBUFFER( g_sha.sha02 )
}
{
                    CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_ecd1"
                      LET g_qryparam.state = 'i'
                      CALL cl_create_qry() RETURNING g_ecm.ecm04,g_sha.sha02
                   SELECT ecm03,ecm05,ecm45,ecm06,ecm54,ecm55
                     INTO g_sha.sha02,l_ecm05,l_ecm45,l_ecm06,l_ecm54,l_ecm55
                     FROM ecm_file
                     WHERE ecm01=g_sha.sha01 AND ecm04=g_ecm.ecm04
                       AND ecm03=g_sha.sha02
}
                   IF STATUS THEN  #資料資料不存在
                      CALL cl_err(g_ecm.ecm04,STATUS,0)                       
                      NEXT FIELD ecm04
                   END IF
                   IF l_ecm54 = 'N' THEN
                      CALL cl_err(g_ecm.ecm04,'asf-719',1)
                      NEXT FIELD ecm04
                   END IF
                   #-->Check-in  hold
                   IF not cl_null(l_ecm55)  THEN
                      CALL cl_err(g_ecm.ecm04,'asf-726',1)
                      NEXT FIELD ecm04
                   END IF
            END CASE
            DISPLAY BY NAME g_sha.sha02
            DISPLAY BY NAME g_sha.sha012      #No.FUN-A60011
            DISPLAY l_ecm45 TO FORMONLY.ecm45
            DISPLAY l_ecm06 TO FORMONLY.ecm06
            DISPLAY l_ecm05 TO FORMONLY.ecm05
            #-->不分批做Check-in
            IF g_sma.sma897='N' THEN
               SELECT count(*) INTO l_n FROM sha_file
                WHERE sha01 = g_sha.sha01
                  AND sha02 = g_sha.sha02
                  AND sha012= g_sha.sha012   #No.FUN-A60011
               IF l_n > 0 THEN
                  LET g_msg = g_sha.sha01,'+',g_sha.sha012,'+',g_sha.sha02 CLIPPED  #No.FUN-A60011
                  CALL cl_err(g_msg,-239,0)
                  NEXT FIELD ecm04
               END IF
            END IF
          END IF
 
        AFTER FIELD sha03
          IF NOT cl_null(g_sha.sha03) THEN
                CALL i700_sha03('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_sha.sha03,g_errno,0)
                   LET g_sha.sha03 = g_sha_t.sha03
                   DISPLAY BY NAME g_sha.sha03
                   NEXT FIELD sha03
                END IF
            END IF
 
        BEFORE FIELD sha05
          #-->本站可check in數量=(總投入量 - 已check in數量(ecm291))
          SELECT (ecm301+ecm302+ecm303-ecm291) INTO total  FROM ecm_file
          WHERE ecm01 = g_sha.sha01 AND ecm03 = g_sha.sha02
            AND ecm012= g_sha.sha012    #No.FUN-A60011
          IF cl_null(g_sha.sha05) THEN
             LET g_sha.sha05=total
          END IF
          DISPLAY BY NAME g_sha.sha05
 
        AFTER FIELD sha05
          IF NOT cl_null(g_sha.sha05) THEN
#No.TQC-9A0059 add --begin
          IF g_sha.sha05 < 0 THEN
             CALL cl_err('','aec-020',0)
             NEXT FIELD sha05
          END IF
#No.TQC-9A0059 add --end
 
          IF g_sha.sha05 > total THEN
            CALL cl_err(total,'asf-717',1)
            NEXT FIELD sha05
          END IF
          END IF
 
        AFTER FIELD sha06
          IF NOT cl_null(g_sha.sha06) THEN
             CALL i700_sha06('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_sha.sha06,g_errno,0)
                LET g_sha.sha06 = g_sha_t.sha06
                DISPLAY BY NAME g_sha.sha06
                NEXT FIELD sha06
             END IF
          END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_sha.shauser = s_get_data_owner("sha_file") #FUN-C10039
           LET g_sha.shagrup = s_get_data_group("sha_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_sha.sha05 <=0 THEN NEXT FIELD sha05 END IF
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(sha01)
                #CALL q_sfb(10,3,g_sha.sha01,' ') RETURNING g_sha.sha01
                #CALL FGL_DIALOG_SETBUFFER( g_sha.sha01 )
                 CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_sfb01"  #No.FUN-A60011
                #LET g_qryparam.form     = "q_sfb13"  #No.FUN-A60011
                 LET g_qryparam.form     = "q_sfb13a" #No.TQC-A80023
                 LET g_qryparam.default1 = g_sha.sha01
                 CALL cl_create_qry() RETURNING g_sha.sha01
                 DISPLAY BY NAME g_sha.sha01
              WHEN INFIELD(ecm04)
                 CALL cl_init_qry_var()
 #MOD-530444-1
                 LET g_qryparam.form = "q_ecm5"
                 LET g_qryparam.default1 = g_ecm.ecm04
                 LET g_qryparam.arg1 = g_sha.sha01
                 CALL cl_create_qry() RETURNING g_sha.sha02,g_ecm.ecm04
                 LET g_sha.sha012 = ' '         #No.FUN-A60011
                 SELECT ecm03,ecm05,ecm45,ecm06
                   INTO g_sha.sha02,l_ecm05,l_ecm45,l_ecm06
                   FROM ecm_file
                   WHERE ecm01=g_sha.sha01
                   # AND ecm03=g_ecm.ecm03       #No.FUN-A60011
                     AND ecm03=g_sha.sha02       #No.FUN-A60011
                     AND ecm012=g_sha.sha012     #No.FUN-A60011
##
                  DISPLAY BY NAME g_ecm.ecm04,g_sha.sha02  #No.MOD-490371
                  DISPLAY BY NAME g_sha.sha012             #No.FUN-A60011
                 NEXT FIELD ecm04
              WHEN INFIELD(sha06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     ="q_gen"
                 LET g_qryparam.default1 = g_sha.sha06
                 CALL cl_create_qry() RETURNING g_sha.sha06
#                 CALL FGL_DIALOG_SETBUFFER( g_sha.sha06 )
                 DISPLAY BY NAME g_sha.sha06
                 NEXT FIELD sha06
              WHEN INFIELD(sha03)
                #CALL q_ecg(05,10,g_sha.sha03) RETURNING g_sha.sha03
                #CALL FGL_DIALOG_SETBUFFER( g_sha.sha03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_ecg"
                 LET g_qryparam.default1 = g_sha.sha03
                 CALL cl_create_qry() RETURNING g_sha.sha03
#                 CALL FGL_DIALOG_SETBUFFER( g_sha.sha03 )
                 DISPLAY BY NAME g_sha.sha03
                 NEXT FIELD sha03
              #No.FUN-A60011  --Begin
              WHEN INFIELD(sha012)    #工艺段号
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     ="q_ecm51"
                 LET g_qryparam.default1 = g_sha.sha012
                 LET g_qryparam.default2 = g_sha.sha02
                 LET g_qryparam.default3 = g_ecm.ecm04 
                 LET g_qryparam.arg1     = g_sha.sha01
                 CALL cl_create_qry() RETURNING g_sha.sha012,g_sha.sha02,g_ecm.ecm04
                 DISPLAY BY NAME g_sha.sha012
                 DISPLAY BY NAME g_sha.sha02
                 DISPLAY g_ecm.ecm04 TO FORMONLY.ecm04
                 CALL i700_ecm_show()
                 NEXT FIELD sha012
              WHEN INFIELD(sha02)     #工艺序号
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     ="q_ecm51"
                 LET g_qryparam.default1 = g_sha.sha012
                 LET g_qryparam.default2 = g_sha.sha02
                 LET g_qryparam.default3 = g_ecm.ecm04 
                 LET g_qryparam.arg1     = g_sha.sha01
                 CALL cl_create_qry() RETURNING g_sha.sha012,g_sha.sha02,g_ecm.ecm04
                 DISPLAY BY NAME g_sha.sha012
                 DISPLAY BY NAME g_sha.sha02
                 DISPLAY g_ecm.ecm04 TO FORMONLY.ecm04
                 CALL i700_ecm_show()
                 NEXT FIELD sha02
              #No.FUN-A60011  --End  
              OTHERWISE
                 EXIT CASE
            END CASE
 
       #MOD-650015 --start
       #  ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(sha01) THEN
       #         LET g_sha.* = g_sha_t.*
       #         CALL i700_show()
       #         NEXT FIELD sha01
       #     END IF
       #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
    ERROR ''
END FUNCTION
 
FUNCTION i700_sha01(p_cmd)
         DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                l_sfb04     LIKE sfb_file.sfb04,
                l_sfb05     LIKE sfb_file.sfb05,
                l_sfb28     LIKE sfb_file.sfb28,
                l_sfb93     LIKE sfb_file.sfb93,
                l_ima02     LIKE ima_file.ima02,
                l_ima021    LIKE ima_file.ima021
 
    LET g_errno = ' '
    SELECT sfb04,sfb05,sfb28,sfb93 INTO l_sfb04,l_sfb05,l_sfb28,l_sfb93
      FROM sfb_file
     WHERE sfb01 = g_sha.sha01
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-312'
                          LET l_sfb04 = NULL LET l_sfb05 = NULL
                          LET l_sfb28 = NULL
               WHEN l_sfb04  = '1' OR l_sfb04 = '8'
	                           LET g_errno = 'asf-716'
               WHEN l_sfb28  = '3' LET g_errno = 'asf-803'
               WHEN l_sfb93  = 'N' LET g_errno = 'asf-805'
               OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
        WHERE ima01 = l_sfb05
       IF SQLCA.sqlcode THEN LET l_ima02 = ' ' LET l_ima021 = ' ' END IF
       DISPLAY l_sfb05  TO FORMONLY.sfb05
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    END IF
END FUNCTION
 
FUNCTION i700_sha03(p_cmd)
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_ecg02     LIKE ecg_file.ecg02,
         l_ecgacti   LIKE ecg_file.ecgacti
 
    LET g_errno = ' '
    SELECT ecg02,ecgacti INTO l_ecg02,l_ecgacti
            FROM ecg_file WHERE ecg01 = g_sha.sha03
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4028'
                                         LET l_ecg02 = NULL
               WHEN l_ecgacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
    IF p_cmd = 'd' OR cl_null(g_errno)
    THEN DISPLAY l_ecg02 TO FORMONLY.ecg02
    END IF
END FUNCTION
 
FUNCTION i700_sha06(p_cmd)    #人員
         DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                l_gen02     LIKE gen_file.gen02,
                l_gen03     LIKE gen_file.gen03,
                l_genacti   LIKE gen_file.genacti
 
     LET g_errno = ' '
     SELECT gen02,genacti INTO l_gen02,l_genacti
       FROM gen_file WHERE gen01 = g_sha.sha06
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                        LET l_gen02 = NULL
              WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_gen02 TO FORMONLY.gen02
     END IF
END FUNCTION
 
 
FUNCTION i700_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sha.* TO NULL               #No.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i700_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_ecbb.clear()
        RETURN
    END IF
    OPEN i700_count
    FETCH i700_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sha.sha01,SQLCA.sqlcode,0)
        INITIALIZE g_sha.* TO NULL
    ELSE
        CALL i700_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i700_fetch(p_flsha)
    DEFINE
        p_flsha         LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flsha
        WHEN 'N' FETCH NEXT     i700_cs INTO g_sha.sha01,g_sha.sha012,              #No.FUN-A60011
                                             g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041,g_sha.sha08
                                      
        WHEN 'P' FETCH PREVIOUS i700_cs INTO g_sha.sha01,g_sha.sha012,              #No.FUN-A60011
                                             g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041,g_sha.sha08
                                      
        WHEN 'F' FETCH FIRST    i700_cs INTO g_sha.sha01,g_sha.sha012,              #No.FUN-A60011
                                             g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041,g_sha.sha08
                                      
        WHEN 'L' FETCH LAST     i700_cs INTO g_sha.sha01,g_sha.sha012,              #No.FUN-A60011
                                             g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041,g_sha.sha08
                                      
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i700_cs INTO g_sha.sha01,g_sha.sha012,              #No.FUN-A60011
                                             g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041,g_sha.sha08
                                      
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sha.sha01,SQLCA.sqlcode,0)
        INITIALIZE g_sha.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsha
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_sha.* FROM sha_file            # 重讀DB,因TEMP有不被更新特性
     WHERE sha01 = g_sha.sha01 AND sha02 = g_sha.sha02 AND sha04 = g_sha.sha04 AND sha041 = g_sha.sha041 AND sha08 = g_sha.sha08
       AND sha012= g_sha.sha012            #No.FUN-A60011   
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_sha.sha01,SQLCA.sqlcode,1)   #No.FUN-660128
       CALL cl_err3("sel","sha_file",g_sha.sha01,g_sha.sha02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_sha.* TO NULL            #FUN-4C0035
    ELSE
       LET g_data_owner = g_sha.shauser      #FUN-4C0035
       LET g_data_group = g_sha.shagrup      #FUN-4C0035
       LET g_data_plant = g_sha.shaplant #FUN-980030
       CALL i700_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i700_show()
    DEFINE l_ecm04  LIKE ecm_file.ecm04,
           l_ecm45  LIKE ecm_file.ecm45,
           l_ecm06  LIKE ecm_file.ecm06,
           l_ecm05  LIKE ecm_file.ecm05
 
    LET g_sha_t.* = g_sha.*
    DISPLAY BY NAME g_sha.sha01,g_sha.sha02, g_sha.shaoriu,g_sha.shaorig,
                    g_sha.sha03,g_sha.sha04,g_sha.sha041,
                    g_sha.sha05,g_sha.sha06,g_sha.sha07,g_sha.sha03,
                    g_sha.shauser,g_sha.shagrup,g_sha.shamodu,
                    g_sha.shadate,g_sha.sha012                          #No.FUN-A60011
    SELECT ecm04,ecm45,ecm06,ecm05 INTO
          l_ecm04,l_ecm45,l_ecm06,l_ecm05
      FROM ecm_file
     WHERE ecm01 = g_sha.sha01 AND ecm03 = g_sha.sha02
       AND ecm012= g_sha.sha012                                         #No.FUN-A60011
    DISPLAY l_ecm04 TO FORMONLY.ecm04
    DISPLAY l_ecm45 TO FORMONLY.ecm45
    DISPLAY l_ecm06 TO FORMONLY.ecm06
    DISPLAY l_ecm05 TO FORMONLY.ecm05
    CALL i700_ecm_show()                                                #No.FUN-A60011
    CALL i700_sha01('d')
    CALL i700_sha03('d')
    CALL i700_sha06('d')
    CALL i700_b_fill()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i700_b_fill()
    DEFINE l_sfb05   LIKE sfb_file.sfb05,
           l_sfb06   LIKE sfb_file.sfb06,
           l_ima571  LIKE ima_file.ima571,
           l_cnt     LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    SELECT sfb05,sfb06,ima571 INTO l_sfb05,l_sfb06,l_ima571
       FROM sfb_file,ima_file
      WHERE sfb01=g_sha.sha01 AND ima01=sfb05
    IF STATUS THEN LET l_sfb05='' LET l_sfb06='' LET l_ima571='' END IF
 
    SELECT COUNT(*) INTO l_cnt FROM ecbb_file
      WHERE ecbb01=l_sfb05 AND ecbb02=l_sfb06
    IF l_cnt=0 THEN
       LET l_sfb05=l_ima571
    END IF
 
    LET g_sql = "SELECT ecbb09,ecbb10 ",
                " FROM  ecbb_file",
                " WHERE ecbb01='",l_sfb05,"' ",
                "   AND ecbb02='",l_sfb06,"' ",
                "   AND ecbb03='",g_sha.sha02,"' ",
                "   AND ecbb012='",g_sha.sha012,"'",    #NO.FUN-A60011
                " ORDER BY ecbb09"
 
    PREPARE i700_pb FROM g_sql
    DECLARE ecbb_curs CURSOR FOR i700_pb
 
    CALL g_ecbb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH ecbb_curs INTO g_ecbb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
 
    CALL g_ecbb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
#   CALL i700_bp_refresh()          #No.FUN-550067
 
END FUNCTION
 
FUNCTION i700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecbb TO s_ecbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i700_fetch('L')
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
     #No.TQC-760202--begin-- mark
     #ON ACTION accept
     #   LET g_action_choice="detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DISPLAY
     #No.TQC-760202--end-- mark
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i700_r()
DEFINE l_ecm291 LIKE ecm_file.ecm291,
       l_qty    LIKE ecm_file.ecm291
 
    IF s_shut(0) THEN RETURN END IF
    IF g_sha.sha01 IS NULL OR g_sha.sha02 IS NULL OR g_sha.sha012 IS NULL THEN  #No.FUN-A60011
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT ecm291,(ecm311+ecm312+ecm313+ecm314+ecm316)
      INTO l_ecm291,l_qty
      FROM ecm_file
     WHERE ecm01 = g_sha.sha01 AND ecm03 = g_sha.sha02
       AND ecm012= g_sha.sha012    #No.FUN-A60011
     IF l_ecm291-g_sha.sha05<l_qty
     THEN CALL cl_err(l_qty,'asf-669',0)
          RETURN
     END IF
 
    BEGIN WORK
 
    OPEN i700_cl USING g_sha.sha01,g_sha.sha012,g_sha.sha02,g_sha.sha04,g_sha.sha041,g_sha.sha08  #No.FUN-A60011
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i700_cl:", STATUS, 1)
       CLOSE i700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i700_cl INTO g_sha.*
    IF SQLCA.sqlcode THEN
       LET g_msg = g_sha.sha01 CLIPPED,'+',g_sha.sha012,'+',g_sha.sha02  #No.FUN-A60011
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i700_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sha01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "sha02"          #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "sha04"          #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "sha041"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sha.sha01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_sha.sha02       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_sha.sha04       #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_sha.sha041      #No.FUN-9B0098 10/02/24
        #No.FUN-A60011  --Begin
        LET g_doc.column5 = "sha012"   
        LET g_doc.value5 = g_sha.sha012
        #No.FUN-A60011  --End  
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM sha_file WHERE sha01 = g_sha.sha01
                              AND sha02 = g_sha.sha02
                              AND sha012= g_sha.sha012             #No.FUN-A60011
                              AND sha04 = g_sha.sha04
                              AND sha041= g_sha.sha041 AND sha08= g_sha.sha08
        IF SQLCA.sqlcode THEN 
        #   CALL cl_err('',STATUS,1)   #No.FUN-660128
         CALL cl_err3("del","sha_file",g_sha.sha01,g_sha.sha02,STATUS,"","",1)  #No.FUN-660128
          RETURN
       ELSE
          CALL i700_upd_ecm()  #Update check in 量
          CLEAR FORM
          CALL g_ecbb.clear()
          OPEN i700_count
          FETCH i700_count INTO g_row_count
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i700_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i700_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i700_fetch('/')
          END IF
       END IF
    END IF
    CLOSE i700_cl
    COMMIT WORK
END FUNCTION
 
#更新工單製程追蹤檔的check in數量
FUNCTION i700_upd_ecm()
DEFINE l_sum_sha05   LIKE sha_file.sha05
 
  SELECT SUM(sha05) INTO l_sum_sha05
    FROM sha_file
   WHERE sha01=g_sha.sha01
     AND sha02=g_sha.sha02
     AND sha012=g_sha.sha012     #No.FUN-A60011
 
  IF cl_null(l_sum_sha05) THEN LET l_sum_sha05=0 END IF
    UPDATE ecm_file SET ecm291 = l_sum_sha05
                   WHERE ecm01 = g_sha.sha01
                     AND ecm03 = g_sha.sha02
                     AND ecm012= g_sha.sha012     #No.FUN-A60011
    IF SQLCA.sqlcode THEN
#      CALL cl_err('','asf-721',1)   #No.FUN-660128
       CALL cl_err3("upd","ecm_file",g_sha01_t,g_sha02_t,"asf-721","","",1)  #No.FUN-660128
    END IF
END FUNCTION
 
FUNCTION i700_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   #No.FUN-A60011  --Begin
   #平行工艺时,工艺段号/工艺序开放,若非平行工艺时,作业编号开放
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sha01,sha04,sha041,sha03",TRUE)
      IF g_sma.sma541 = 'Y' THEN
         CALL cl_set_comp_entry("sha012,sha02",TRUE)
      ELSE
         CALL cl_set_comp_entry("ecm04",TRUE)
      END IF
   END IF
  #No.FUN-A60011  --End  
END FUNCTION
 
FUNCTION i700_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   #No.FUN-A60011  --Begin
   #平行工艺时,工艺段号/工艺序开放,若非平行工艺时,作业编号开放
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sha01,sha04,sha041,sha03",FALSE)
      IF g_sma.sma541 = 'Y' THEN
         CALL cl_set_comp_entry("sha012,sha02",FALSE)
      ELSE
         CALL cl_set_comp_entry("ecm04",FALSE)
      END IF
   END IF
   #No.FUN-A60011  --End  
END FUNCTION

#No.FUN-A60011  --Begin
FUNCTION i700_ecm_chk(p_ecm01,p_ecm012,p_ecm03)
   DEFINE p_ecm01     LIKE ecm_file.ecm01
   DEFINE p_ecm012    LIKE ecm_file.ecm012
   DEFINE p_ecm03     LIKE ecm_file.ecm03
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_ecm54     LIKE ecm_file.ecm54
   DEFINE l_ecm55     LIKE ecm_file.ecm55

   LET g_errno = ''


   IF cl_null(g_sha.sha01) OR g_sha.sha012 IS NULL THEN RETURN END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM ecm_file
    WHERE ecm01 = g_sha.sha01
      AND ecm012= g_sha.sha012
   #当前工单的工艺追踪档中无此工艺段号信息,请检查!
   IF l_cnt = 0 THEN
      LET g_errno = 'aec-311'
      RETURN
   END IF

   IF cl_null(g_sha.sha02) THEN RETURN END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM ecm_file
    WHERE ecm01 = g_sha.sha01
      AND ecm012= g_sha.sha012
      AND ecm03 = g_sha.sha02
   #无此工艺序号
   IF l_cnt = 0 THEN
      LET g_errno = 'abm-215'
      RETURN
   END IF

   SELECT ecm54,ecm55 INTO l_ecm54,l_ecm55
     FROM ecm_file
    WHERE ecm01 = g_sha.sha01
      AND ecm012= g_sha.sha012
      AND ecm03 = g_sha.sha02
   #该工艺序设置为不使用工单check in.!!
   IF l_ecm54 = 'N' THEN
      LET g_errno = 'asf-719'
      RETURN
   END IF
   #本工艺有留置, 请利用质量异常处理作业取消留置
   IF NOT cl_null(l_ecm55)  THEN
      LET g_errno = 'asf-726'
      RETURN
   END IF

END FUNCTION


FUNCTION i700_ecm_show()
   DEFINE l_ecm04  LIKE ecm_file.ecm04
   DEFINE l_ecm45  LIKE ecm_file.ecm45
   DEFINE l_ecm06  LIKE ecm_file.ecm06
   DEFINE l_ecm05  LIKE ecm_file.ecm05
   DEFINE l_sfb06  LIKE sfb_file.sfb06
   DEFINE l_sfb05  LIKE sfb_file.sfb05
   DEFINE l_ecu014 LIKE ecu_file.ecu014
   DEFINE l_flag   LIKE type_file.num5             #TQC-AC0374

   SELECT ecm04,ecm05,ecm06,ecm45
     INTO l_ecm04,l_ecm05,l_ecm06,l_ecm45
     FROM ecm_file
    WHERE ecm01 = g_sha.sha01
      AND ecm012= g_sha.sha012
      AND ecm03 = g_sha.sha02

   LET g_ecm.ecm04 = l_ecm04

#   SELECT sfb06,sfb05 INTO l_sfb06,l_sfb05 FROM sfb_file      #TQC-AC0374
    SELECT sfb06 INTO l_sfb06 FROM sfb_file                    #TQC-AC0374
     WHERE sfb01 = g_sha.sha01
    CALL s_schdat_sel_ima571(g_sha.sha01) RETURNING l_flag,l_sfb05      #TQC-AC0374
  #FUN-B10056 ---------mod start----------  
  #SELECT ecu014 INTO l_ecu014 
  #  FROM ecu_file
  # WHERE ecu01 = l_sfb05
  #   AND ecu02 = l_sfb06
  #   AND ecu012= g_sha.sha012
   CALL s_schdat_ecm014(g_sha.sha01,g_sha.sha012) RETURNING l_ecu014 
  #FUN-B10056 --------mod end----------
   DISPLAY l_ecm04 TO FORMONLY.ecm04
   DISPLAY l_ecm05 TO FORMONLY.ecm05
   DISPLAY l_ecm06 TO FORMONLY.ecm06
   DISPLAY l_ecm45 TO FORMONLY.ecm45
   DISPLAY l_ecu014 TO FORMONLY.ecu014


END FUNCTION
#No.FUN-A60011  --End  

