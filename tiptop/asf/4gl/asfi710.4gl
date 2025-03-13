# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfi710.4gl
# Descriptions...: Run Card Check in 維護作業
# Date & Author..: 00/04/27 by apple
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-490425 04/10/06 By Smapmin 修正接收傳回值的順序
# Modify.........: No.MOD-4A0252 04/10/26 By Smapmin RUN CARD以及作業編號開窗
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-520050 05/02/14 By ching sha_file.rowid修改
# Modify.........: No.MOD-520075 05/02/17 By ching call q_sgm1修改
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-570246 05/07/27 By Elva  月份改期別處理方式
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0164 06/11/13 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0214 06/12/29 By day check in量輸入負數要報錯
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-790001 07/09/03 By jamie PK問題
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-930024 09/03/11 By jan 再新增時系統并未將 g_sha_t.* 的值清空，以至於新增下筆的時候，舊值保留前一筆的資料
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A50124 10/05/28 By houlia 單身顯示
# Modify.........: No:MOD-A60042 10/06/07 By Sarah 跳過作業編號直接輸入製程序,沒有檢查到asf-719
# Modify.........: No.FUN-A60080 10/07/08 By destiny 增加平行工艺逻辑
 
# Modify.........: No.TQC-AB0342 10/11/29 By vealxu WHEN sma541='N'，ecu014沒有隱藏
# Modify.........: No.TQC-AC0374 10/12/29 By lixh1  從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取
# Modify.........: No.FUN-B10056 11/02/14 By vealxu 修改制程段號的管控
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60123 11/06/16 By xianghui 在沒有經過員工編號欄位時對齊進行控管
# Modify.........: No.FUN-BB0085 11/12/16 By xianghui 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sha   RECORD LIKE sha_file.*,
    g_sha_t RECORD LIKE sha_file.*,
    g_sgm   RECORD LIKE sgm_file.*,
    g_sha08_t LIKE sha_file.sha08,
    g_sha01_t LIKE sha_file.sha01,
    g_sha02_t LIKE sha_file.sha02,
    g_h1,g_m1,g_s1 LIKE type_file.num5,          #No.FUN-680121 SMALLINT
     g_wc,g_sql     string,  #No.FUN-580092 HCN
    g_ecbb         DYNAMIC ARRAY OF RECORD   #程式變數(Prinram Variables)
                   ecbb09     LIKE ecbb_file.ecbb09,
                   ecbb10     LIKE ecbb_file.ecbb10
                   END RECORD,
    g_rec_b        LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac           LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680121 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0090
 
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
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
    INITIALIZE g_sha.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM sha_file WHERE sha01 = ? AND sha02 = ? AND sha04 = ? AND sha041 = ? AND sha08 = ? AND sha012= ? FOR UPDATE"  #NO.FUN-A60080  add sha012
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i710_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW i710_w AT p_row,p_col
         WITH FORM "asf/42f/asfi710"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   #NO.FUN-A60080--begin
   IF g_sma.sma541='N' THEN 
    # CALL cl_set_comp_visible("sha012,euc014",FALSE)       #TQC-AB0342
      CALL cl_set_comp_visible("sha012,ecu014",FALSE)         #TQC-AB0342
   ELSE 
   	  CALL cl_set_comp_entry("sgm04",FALSE)   
   END IF 
   #NO.FUN-A60080--end    
    CALL i710_menu()
    CLOSE WINDOW i710_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION i710_curs()
    DEFINE l_sgm02  LIKE sgm_file.sgm02
 
    CLEAR FORM
    CALL g_ecbb.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sha.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        sha08,sha01,sha012,sha02,sgm04,sha04,sha041,  #NO.FUN-A60080  add sha012
        sha03,sha05,sha06,sha07,shauser,shagrup,shamodu,shadate
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(sha08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_shm"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sha08
                 NEXT FIELD sha08
              WHEN INFIELD(sgm04)
                 CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO FORMONLY.sgm04
                #NEXT FIELD FORMONLY.sgm04
                 NEXT FIELD sgm04
              #NO.FUN-A60080--begin   
              WHEN INFIELD(sha012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
               # LET g_qryparam.form     = "q_sha012"     #FUN-B10056 mark
                 LET g_qryparam.form     = "q_sha012_1"   #FUN-B10056
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sha012
                 NEXT FIELD sha012    
              #NO.FUN-A60080--end   
              WHEN INFIELD(sha06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sha06
                 NEXT FIELD sha06
              WHEN INFIELD(sha03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_ecg"
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
     LET g_sql="SELECT sha08,sha01,sha02,sha04,sha041,sha012", #MOD-520050  #NO.FUN-A60080  add sha012
              "  FROM sha_file",
             #"  FROM sha_file,sgm_file",
              " WHERE sha08 IS NOT NULL AND sha08 != ' ' ",
             #" AND sgm_file.sgm02 = sha_file.sha01 ",
              " AND ",g_wc CLIPPED,
              " ORDER BY sha08,sha01"
    PREPARE i710_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i710_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i710_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM sha_file ",
              " WHERE sha08 IS NOT NULL AND sha08 != ' ' AND ",g_wc CLIPPED
    PREPARE i710_precount FROM g_sql
    DECLARE i710_count CURSOR FOR i710_precount
END FUNCTION
 
FUNCTION i710_menu()
 
   WHILE TRUE
      CALL i710_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i710_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i710_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i710_r()
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
                 IF g_sha.sha08 IS NOT NULL THEN            
                    LET g_doc.column1 = "sha08"               
                    LET g_doc.column2 = "sha01" 
                    LET g_doc.column3 = "sha02"
                    LET g_doc.column4 = "sha04"  
                    LET g_doc.column5 = "sha041"
                    LET g_doc.value1 = g_sha.sha08            
                    LET g_doc.value2 = g_sha.sha01
                    LET g_doc.value3 = g_sha.sha02
                    LET g_doc.value4 = g_sha.sha04
                    LET g_doc.value4 = g_sha.sha041
                    CALL cl_doc() 
             END IF 
          END IF
         #No.FUN-6A0164-------add--------end----
      END CASE
   END WHILE
    CLOSE i710_cs
END FUNCTION
 
FUNCTION i710_a()
  DEFINE l_total,l_qty  LIKE sgm_file.sgm291
  DEFINE l_msg          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(50)
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    CALL g_ecbb.clear()
    INITIALIZE g_sha.* LIKE sha_file.*
    LET g_sha08_t = NULL
    LET g_sha01_t = NULL
    LET g_sha02_t = NULL
    LET g_sha_t.* = g_sha.*   #TQC-930024
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sha.sha04 = g_today
        LET g_sha.sha041 = TIME
        LET g_sha.sha06 = g_user
        LET g_sha.shauser = g_user
        LET g_sha.shaoriu = g_user #FUN-980030
        LET g_sha.shaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_sha.shagrup = g_grup               #使用者所屬群
        LET g_sha.shadate = g_today
        LET g_sha.shaacti = 'Y'
        LET g_sha.shaplant = g_plant #FUN-980008 add
        LET g_sha.shalegal = g_legal #FUN-980008 add
        #NO.FUN-A60080--begin
        IF g_sma.sma541='N' THEN 
           LET g_sha.sha012=' '
        END IF 
        #NO.FUN-A60080--end
        CALL i710_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_sha.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_ecbb.clear()
            EXIT WHILE
        END IF
        IF cl_null(g_sha.sha01) THEN               # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_sha.sha08) THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF

        CALL i710_b_fill()         #TQC-A50124

        #-->再一次檢查防止兩人同時輸入
        #-->本站可check in數量=(總投入量 - 已check in數量(sgm291))
        SELECT (sgm301+sgm302+sgm303+sgm304-sgm291) INTO l_total  FROM sgm_file
         WHERE sgm01 = g_sha.sha08 AND sgm03 = g_sha.sha02
           AND sgm012=g_sha.sha012 #NO.FUN-A60080 
          IF g_sha.sha05 > l_total THEN
             LET l_qty =l_total - g_sha.sha05
             LET l_msg ='QTY:',l_qty
             CALL cl_err(l_msg,'asf-717',0)
             CONTINUE WHILE
          END IF
        IF cl_null(g_sha.sha08) THEN LET g_sha.sha08=' ' END IF  #FUN-790001 add
        INSERT INTO sha_file VALUES(g_sha.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_sha.sha08,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("ins","sha_file",g_sha.sha01,g_sha.sha02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        ELSE
            SELECT sha01 INTO g_sha.sha01 FROM sha_file
                     WHERE sha08 = g_sha.sha08
                       AND sha01 = g_sha.sha01
                       AND sha012 = g_sha.sha012  #NO.FUN-A60080  add sha012
                       AND sha02 = g_sha.sha02
                       AND sha04 = g_sha.sha04
                       AND sha041= g_sha.sha041
            CALL i710_upd_sgm()  #Update check in 量
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i710_i(p_cmd)
    DEFINE l_ima02  LIKE ima_file.ima02,
           l_ima021 LIKE ima_file.ima021,
           l_sgm04  LIKE sgm_file.sgm04,
           l_sgm45  LIKE sgm_file.sgm45,
           l_sgm06  LIKE sgm_file.sgm06,
           l_sgm05  LIKE sgm_file.sgm05,
           l_sgm54  LIKE sgm_file.sgm54,
           l_sgm55  LIKE sgm_file.sgm55,
           l_sha02  LIKE sha_file.sha02,
           total    LIKE sgm_file.sgm291,
           l_year,l_mon  LIKE type_file.num5,            #No.FUN-680121 SMALLINT
           p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_n             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_t      LIKE type_file.num5                  #NO.FUN-A60080 
           
    #No.TQC-6C0214--begin
#   DISPLAY BY NAME g_sha.sha04,g_sha.sha041,g_sha.sha06
    DISPLAY BY NAME g_sha.sha08,g_sha.sha01,g_sgm.sgm04,g_sha.sha02,g_sha.sha04,
        g_sha.sha041,g_sha.sha03,g_sha.sha05,g_sha.sha06,g_sha.sha07,
        g_sha.shauser,g_sha.shagrup,g_sha.shamodu,g_sha.shadate
    #No.TQC-6C0214--end  
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_sha.sha08,g_sha.sha01,g_sgm.sgm04,g_sha.sha012,g_sha.sha02,g_sha.sha04, g_sha.shaoriu,g_sha.shaorig, #NO.FUN-A60080  add sha012
        g_sha.sha041,g_sha.sha03,g_sha.sha05,g_sha.sha06,g_sha.sha07,
        g_sha.shauser,g_sha.shagrup,g_sha.shamodu,g_sha.shadate
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i710_set_entry(p_cmd)
            CALL i710_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550067 --start--
         CALL cl_set_docno_format("sha01")
         #No.FUN-550067 ---end---
 
        AFTER FIELD sha08
            IF NOT cl_null(g_sha.sha08) THEN
                CALL i710_sha08('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_sha.sha08,g_errno,0)
                   LET g_sha.sha08 = g_sha_t.sha08
                   DISPLAY BY NAME g_sha.sha08
                   NEXT FIELD sha08
                END IF
            END IF
 
        AFTER FIELD sha04
            IF NOT cl_null(g_sha.sha04) THEN
            #FUN-570246  --begin
            #LET l_year = YEAR(g_sha.sha04)
            #LET l_mon  =  MONTH(g_sha.sha04)
            CALL s_yp(g_sha.sha04) RETURNING l_year,l_mon
            #FUN-570246  --end
            IF l_year > g_sma.sma51 THEN
               #No.+045 010410 by plum
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
 
        AFTER FIELD sgm04
            IF NOT cl_null(g_sgm.sgm04) THEN
           #str MOD-A60042 mod
           #將下面判斷移到i710_sha02()
           ##-->此判斷要考慮作業編號可能不為uniuqe
           #SELECT COUNT(*) INTO g_cnt FROM sgm_file
           # WHERE sgm01=g_sha.sha08 AND sgm04=g_sgm.sgm04
           #CASE
           #  WHEN g_cnt=0   #作業編號完全不存在
           #       DISPLAY "test"
           #       CALL cl_err(g_sgm.sgm04,100,0)
           #       NEXT FIELD FORMONLY.sgm04
           #  WHEN g_cnt=1   #作業編號存在一筆
           #       SELECT sgm03,sgm05,sgm45,sgm06,sgm54,sgm55
           #         INTO g_sha.sha02,l_sgm05,l_sgm45,l_sgm06,l_sgm54,l_sgm55
           #         FROM sgm_file
           #         WHERE sgm01=g_sha.sha08 AND sgm04=g_sgm.sgm04
           #       IF STATUS THEN  #資料資料不存在
#          #          CALL cl_err(g_sgm.sgm04,STATUS,0)   #No.FUN-660128
           #          CALL cl_err3("sel","sgm_file",g_sha.sha08,"",STATUS,"","",1)  #No.FUN-660128
           #          NEXT FIELD FORMONLY.sgm04
           #       END IF
           #       IF l_sgm54 = 'N' THEN
           #          CALL cl_err(g_sgm.sgm04,'asf-719',1)
           #          NEXT FIELD FORMONLY.sgm04
           #       END IF
           #       #-->Check-in  hold
           #       IF not cl_null(l_sgm55)  THEN
           #          CALL cl_err(g_sgm.sgm04,'asf-726',1)
           #          NEXT FIELD FORMONLY.sgm04
           #       END IF
           #  WHEN g_cnt>1
#          #       CALL q_sgm1(0,0,g_sha.sha08,g_sgm.sgm04)
#          #            RETURNING g_sgm.sgm04,g_sha.sha02
#          #        CALL FGL_DIALOG_SETBUFFER( g_sgm.sgm04 )
#          #        CALL FGL_DIALOG_SETBUFFER( g_sha.sha02 )
           #        CALL q_sgm1(FALSE,FALSE,'','',g_sha.sha08,g_sgm.sgm04)
           #            RETURNING g_sgm.sgm04,g_sha.sha02
#          #        CALL FGL_DIALOG_SETBUFFER( g_sgm.sgm04 )
#          #        CALL FGL_DIALOG_SETBUFFER( g_sha.sha02 )
           #       SELECT sgm03,sgm05,sgm45,sgm06,sgm54,sgm55
           #         INTO g_sha.sha02,l_sgm05,l_sgm45,l_sgm06,l_sgm54,l_sgm55
           #         FROM sgm_file
           #        WHERE sgm01=g_sha.sha08 AND sgm04=g_sgm.sgm04
           #          AND sgm03=g_sha.sha02
           #       IF STATUS THEN  #資料資料不存在
#          #          CALL cl_err(g_sgm.sgm04,STATUS,0)   #No.FUN-660128
           #          CALL cl_err3("sel","sgm_file",g_sha.sha08,g_sha.sha02,STATUS,"","",1)  #No.FUN-660128
           #          NEXT FIELD FORMONLY.sgm04
           #       END IF
           #       IF l_sgm54 = 'N' THEN
           #          CALL cl_err(g_sgm.sgm04,'asf-719',1)
           #          NEXT FIELD FORMONLY.sgm04
           #       END IF
           #       #-->Check-in  hold
           #       IF not cl_null(l_sgm55)  THEN
           #          CALL cl_err(g_sgm.sgm04,'asf-726',1)
           #          NEXT FIELD FORMONLY.sgm04
           #       END IF
           #END CASE
           #DISPLAY BY NAME g_sha.sha02
           #DISPLAY l_sgm45 TO FORMONLY.sgm45
           #DISPLAY l_sgm06 TO FORMONLY.sgm06
           #DISPLAY l_sgm05 TO FORMONLY.sgm05
           ##-->不分批做Check-in
           #IF g_sma.sma897='N' THEN
           #   SELECT count(*) INTO l_n FROM sha_file
           #    WHERE sha08 = g_sha.sha08
           #      AND sha02 = g_sha.sha02
           #   IF l_n > 0 THEN
           #      LET g_msg = g_sha.sha08,'+',g_sha.sha02 CLIPPED
           #      CALL cl_err(g_msg,-239,0)
           #      NEXT FIELD FORMONLY.sgm04
           #   END IF
           #END IF
           #將上面判斷移到i710_sha02()
            LET g_errno = ''
            CALL i710_sha02(g_sgm.sgm04)
            IF NOT cl_null(g_errno) THEN
               NEXT FIELD CURRENT
            END IF
           #end MOD-A60042 mod
            END IF

     #NO.FUN-A60080--begin
      AFTER FIELD sha012
         IF NOT cl_null(g_sha.sha012) THEN
            CALL i710_sgm_chk(g_sha.sha08,g_sha.sha012,g_sha.sha02)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sha.sha012,g_errno,0)
               LET g_sha.sha012 = g_sha_t.sha012
               DISPLAY BY NAME g_sha.sha012
               NEXT FIELD sha012
            END IF          
            CALL i710_sgm_show()
         ELSE 
            LET g_sha.sha012=' '   
         END IF
     #NO.FUN-A60080--end
      
     #str MOD-A60042 add
      AFTER FIELD sha02
         IF NOT cl_null(g_sha.sha02) THEN
            IF g_sma.sma541='N' THEN 
               SELECT sgm04 INTO g_sgm.sgm04 FROM sgm_file
                WHERE sgm01 = g_sha.sha08 AND sgm03 = g_sha.sha02
                  AND sgm012=g_sha.sha012   #NO.FUN-A60080
               IF NOT cl_null(g_sgm.sgm04) THEN
                  DISPLAY BY NAME g_sgm.sgm04
                  LET g_errno = ''
                  CALL i710_sha02(g_sgm.sgm04)
                  IF NOT cl_null(g_errno) THEN
                     NEXT FIELD CURRENT
                  END IF
               END IF
            ELSE 
           	   CALL i710_sgm_chk(g_sha.sha08,g_sha.sha012,g_sha.sha02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sha.sha02,g_errno,0)
                  LET g_sha.sha02 = g_sha_t.sha02
                  DISPLAY BY NAME g_sha.sha02
                  NEXT FIELD sha02
               END IF 
               CALL i710_sgm_show()
            END IF 
         ELSE
            IF NOT cl_null(g_sgm.sgm04) THEN
               LET g_sgm.sgm04=''
               DISPLAY BY NAME g_sgm.sgm04
            END IF
         END IF
     #end MOD-A60042 add

        AFTER FIELD sha03
            IF NOT cl_null(g_sha.sha03) THEN
                CALL i710_sha03('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_sha.sha03,g_errno,0)
                   LET g_sha.sha03 = g_sha_t.sha03
                   DISPLAY BY NAME g_sha.sha03
                   NEXT FIELD sha03
                END IF
            END IF
 
        BEFORE FIELD sha05
          #-->本站可check in數量=(總投入量 - 已check in數量(sgm291))
          SELECT (sgm301+sgm302+sgm303+sgm304-sgm291) INTO total  FROM sgm_file
          WHERE sgm01 = g_sha.sha08 AND sgm03 = g_sha.sha02
          IF cl_null(g_sha.sha05) THEN
             LET g_sha.sha05=total
          END IF
          DISPLAY BY NAME g_sha.sha05
 
        AFTER FIELD sha05
          IF NOT cl_null(g_sha.sha05) THEN
             #No.TQC-6C0214--begin
             IF g_sha.sha05 <= 0 THEN
                CALL cl_err(g_sha.sha05,'afa-037',1)
                NEXT FIELD sha05
             END IF
             #No.TQC-6C0214--end  
          IF g_sha.sha05 > total THEN
            CALL cl_err('','asf-717',1)
            NEXT FIELD sha05
          END IF
          END IF
 
        AFTER FIELD sha06
          IF NOT cl_null(g_sha.sha06) THEN
             CALL i710_sha06('a')
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
            #No.TQC-6C0214--begin
#           IF g_sha.sha05 <=0 THEN NEXT FIELD sha05 END IF
            IF g_sha.sha05 <=0 THEN 
               CALL cl_err(g_sha.sha05,'afa-037',1)
               NEXT FIELD sha05 
            END IF
            #TQC-B60123-add-str--
            IF NOT cl_null(g_sha.sha06) THEN
               CALL i710_sha06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sha.sha06,g_errno,0)
                  LET g_sha.sha06 = g_sha_t.sha06
                  DISPLAY BY NAME g_sha.sha06
                  NEXT FIELD sha06
               END IF
            END IF
            #TQC-B60123-add-end--
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(sha08)
                #CALL q_shm(10,3,g_sha.sha08) RETURNING g_sha.sha08
                #CALL FGL_DIALOG_SETBUFFER( g_sha.sha08 )
                 CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_shm1"  #MOD-4A0252
                 LET g_qryparam.default1 = g_sha.sha08
                 CALL cl_create_qry() RETURNING g_sha.sha08
                 DISPLAY BY NAME g_sha.sha08
              WHEN INFIELD(sgm04)
                #MOD-520075
               CALL q_sgm1( FALSE, FALSE,'','',g_sha.sha08,'')
                RETURNING g_sgm.sgm04,g_sha.sha02 #MOD-490425
               #CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_ecm4"     #MOD-4A0252
               #CALL cl_create_qry()
               #RETURNING g_sgm.sgm04,g_sha.sha02
               #--
 
                SELECT sgm03,sgm05,sgm45,sgm06
                  INTO g_sha.sha02,l_sgm05,l_sgm45,l_sgm06
                  FROM sgm_file
                 WHERE sgm01=g_sha.sha08 AND sgm04=g_sgm.sgm04
                   AND sgm03=g_sha.sha02
                 DISPLAY BY NAME g_sgm.sgm04,g_sha.sha02     #No.MOD-490371
                NEXT FIELD FORMONLY.sgm04
              #NO.FUN-A60080--begin   
              WHEN INFIELD(sha012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form= "q_sgm_2"
                 LET g_qryparam.arg1=g_sha.sha08
                 LET g_qryparam.default1 = g_sha.sha012
                 LET g_qryparam.default2 = g_sha.sha02
                 LET g_qryparam.default3 = g_sgm.sgm04
                 CALL cl_create_qry() RETURNING g_sha.sha012,g_sha.sha02,g_sgm.sgm04
                 DISPLAY g_sha.sha012 TO sha012
                 DISPLAY g_sha.sha02 TO sha02
                 DISPLAY g_sgm.sgm04 TO sgm04
                 NEXT FIELD sha012    
              #NO.FUN-A60080--end                   
              WHEN INFIELD(sha06)
                #CALL q_gen(0,0,g_sha.sha06) RETURNING g_sha.sha06
                #CALL FGL_DIALOG_SETBUFFER( g_sha.sha06 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gen"
                 LET g_qryparam.default1 = g_sha.sha06
                 CALL cl_create_qry() RETURNING g_sha.sha06
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
              OTHERWISE
                 EXIT CASE
            END CASE
 
       #MOD-650015 --start
         #ON ACTION CONTROLO                        # 沿用所有欄位
         #   IF INFIELD(sha01) THEN
         #       LET g_sha.* = g_sha_t.*
         #       CALL i710_show()
         #       NEXT FIELD sha01
         #   END IF
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
END FUNCTION

#No.FUN-A60080  --Begin
FUNCTION i710_sgm_chk(p_sgm01,p_sgm012,p_sgm03)
   DEFINE p_sgm01     LIKE sgm_file.sgm01
   DEFINE p_sgm012    LIKE sgm_file.sgm012
   DEFINE p_sgm03     LIKE sgm_file.sgm03
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_sgm54     LIKE sgm_file.sgm54
   DEFINE l_sgm55     LIKE sgm_file.sgm55

   LET g_errno = ''

   IF cl_null(g_sha.sha08) OR g_sha.sha012 IS NULL THEN RETURN END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM sgm_file
    WHERE sgm01 = g_sha.sha08
      AND sgm012= g_sha.sha012
   #当前工单的工艺追踪档中无此工艺段号信息,请检查!
   IF l_cnt = 0 THEN
      LET g_errno = 'aec-311'
      RETURN
   END IF

   IF cl_null(g_sha.sha02) THEN RETURN END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM sgm_file
    WHERE sgm01 = g_sha.sha08
      AND sgm012= g_sha.sha012
      AND sgm03 = g_sha.sha02
   #无此工艺序号
   IF l_cnt = 0 THEN
      LET g_errno = 'abm-215'
      RETURN
   END IF
   SELECT sgm04,sgm45 INTO g_sgm.sgm04,g_sgm.sgm45 FROM sgm_file 
    WHERE sgm01=g_sha.sha08 AND sgm012= g_sha.sha012
      AND sgm03=g_sha.sha02 
   IF NOT cl_null(g_sgm.sgm04) THEN 
      DISPLAY BY NAME g_sgm.sgm04 
      DISPLAY g_sgm.sgm45 TO FORMONLY.sgm45
   END IF 
END FUNCTION   

FUNCTION i710_sgm_show()
   DEFINE l_sgm04  LIKE sgm_file.sgm04
   DEFINE l_sgm45  LIKE sgm_file.sgm45
   DEFINE l_sgm06  LIKE sgm_file.sgm06
   DEFINE l_sgm05  LIKE sgm_file.sgm05
   DEFINE l_sfb06  LIKE sfb_file.sfb06
   DEFINE l_sfb05  LIKE sfb_file.sfb05
   DEFINE l_ecu014 LIKE ecu_file.ecu014
   DEFINE l_flag   LIKE type_file.num5        #TQC-AC0374

   SELECT sgm04,sgm45
     INTO l_sgm04,l_sgm45
     FROM sgm_file
    WHERE sgm01 = g_sha.sha08
      AND sgm012= g_sha.sha012
      AND sgm03 = g_sha.sha02

   LET g_sgm.sgm04 = l_sgm04

#  SELECT sfb06,sfb05 INTO l_sfb06,l_sfb05 FROM sfb_file       #TQC-AC0374
   SELECT sfb06 INTO l_sfb06 FROM sfb_file                       #TQC-AC0374
    WHERE sfb01 = g_sha.sha01
   CALL s_schdat_sel_ima571(g_sha.sha01) RETURNING l_flag,l_sfb05   #TQC-AC0374

  #FUN-B10056 --------mod start------
  #SELECT ecu014 INTO l_ecu014 
  #  FROM ecu_file
  # WHERE ecu01 = l_sfb05
  #   AND ecu02 = l_sfb06
  #   AND ecu012= g_sha.sha012
   CALL s_runcard_sgm014(g_sha.sha08,g_sha.sha012) RETURNING l_ecu014
  #FUN-B10056 -------mod end------- 

   DISPLAY l_sgm04 TO FORMONLY.sgm04
   DISPLAY l_sgm45 TO FORMONLY.sgm45
   DISPLAY l_ecu014 TO FORMONLY.ecu014

END FUNCTION
#NO.FUN-A60080--end   
 
FUNCTION i710_sha08(p_cmd)
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_shm012    LIKE shm_file.shm012,
         l_shm05     LIKE shm_file.shm05,
         l_shm28     LIKE shm_file.shm28,
         l_sfb04     LIKE sfb_file.sfb04,
         l_sfb05     LIKE sfb_file.sfb05,
         l_sfb28     LIKE sfb_file.sfb28,
         l_ima02     LIKE ima_file.ima02,
         l_ima021    LIKE ima_file.ima021
 
    LET g_errno = ' '
    SELECT shm012,shm05,shm28 INTO g_sha.sha01,l_shm05,l_shm28 FROM shm_file
                 WHERE shm01 = g_sha.sha08
          CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-910'
               WHEN l_shm28  = 'Y'       LET g_errno = 'asf-911'
               OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
   	  END CASE
    IF cl_null(g_errno) THEN
       SELECT sfb04,sfb05,sfb28 INTO l_sfb04,l_sfb05,l_sfb28
         FROM sfb_file
        WHERE sfb01 = g_sha.sha01
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-312'
                          LET l_sfb04 = NULL LET l_sfb05 = NULL
                          LET l_sfb28 = NULL
               WHEN l_sfb04  = '1' OR l_sfb04 = '8'
	                           LET g_errno = 'asf-716'
               WHEN l_sfb28  = '3' LET g_errno = 'asf-803'
               OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
    END IF
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
        WHERE ima01 = l_shm05
       IF SQLCA.sqlcode THEN LET l_ima02 = ' ' LET l_ima021 = ' ' END IF
       DISPLAY l_shm05  TO FORMONLY.sfb05
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY BY NAME g_sha.sha08,g_sha.sha01
    END IF
END FUNCTION
 
#str MOD-A60042 add
FUNCTION i710_sha02(p_sgm04)
  DEFINE p_sgm04  LIKE sgm_file.sgm04,
         l_sgm04  LIKE sgm_file.sgm04,
         l_sgm45  LIKE sgm_file.sgm45,
         l_sgm06  LIKE sgm_file.sgm06,
         l_sgm05  LIKE sgm_file.sgm05,
         l_sgm54  LIKE sgm_file.sgm54,
         l_sgm55  LIKE sgm_file.sgm55,
         l_sha02  LIKE sha_file.sha02,
         l_n      LIKE type_file.num5

   IF NOT cl_null(p_sgm04) THEN
      #-->此判斷要考慮作業編號可能不為uniuqe
      SELECT COUNT(*) INTO g_cnt FROM sgm_file
       WHERE sgm01=g_sha.sha08 AND sgm04=p_sgm04
         AND sgm012=g_sha.sha012  #NO.FUN-A60080
      CASE
         WHEN g_cnt=0   #作業編號完全不存在
              DISPLAY "test"
              CALL cl_err(p_sgm04,100,0)
              LET g_errno=100
              RETURN
         WHEN g_cnt=1   #作業編號存在一筆
              SELECT sgm03,sgm05,sgm45,sgm06,sgm54,sgm55
                INTO g_sha.sha02,l_sgm05,l_sgm45,l_sgm06,l_sgm54,l_sgm55
                FROM sgm_file
                WHERE sgm01=g_sha.sha08 AND sgm04=p_sgm04
                 AND sgm012=g_sha.sha012  #NO.FUN-A60080
              IF STATUS THEN  #資料資料不存在
                 CALL cl_err3("sel","sgm_file",g_sha.sha08,"",STATUS,"","",1)  #No.FUN-660128
                 LET g_errno=STATUS
                 RETURN
              END IF
              IF l_sgm54 = 'N' THEN
                 CALL cl_err(p_sgm04,'asf-719',1)
                 LET g_errno='asf-719'
                 RETURN
              END IF
              #-->Check-in  hold
              IF not cl_null(l_sgm55)  THEN
                 CALL cl_err(p_sgm04,'asf-726',1)
                 LET g_errno='asf-726'
                 RETURN
              END IF
         WHEN g_cnt>1
              ##########
              CALL q_sgm1(FALSE,FALSE,'','',g_sha.sha08,p_sgm04)
                   RETURNING p_sgm04,g_sha.sha02
              SELECT sgm03,sgm05,sgm45,sgm06,sgm54,sgm55
                INTO g_sha.sha02,l_sgm05,l_sgm45,l_sgm06,l_sgm54,l_sgm55
                FROM sgm_file
               WHERE sgm01=g_sha.sha08 AND sgm04=p_sgm04
                 AND sgm03=g_sha.sha02
                 AND sgm012=g_sha.sha012  #NO.FUN-A60080
              IF STATUS THEN  #資料資料不存在
                 CALL cl_err3("sel","sgm_file",g_sha.sha08,g_sha.sha02,STATUS,"","",1)  #No.FUN-660128
                 LET g_errno=STATUS
                 RETURN
              END IF
              IF l_sgm54 = 'N' THEN
                 CALL cl_err(p_sgm04,'asf-719',1)
                 LET g_errno='asf-719'
                 RETURN
              END IF
              #-->Check-in  hold
              IF not cl_null(l_sgm55)  THEN
                 CALL cl_err(p_sgm04,'asf-726',1)
                 LET g_errno='asf-726'
                 RETURN
              END IF
      END CASE
      DISPLAY BY NAME g_sha.sha02
      DISPLAY l_sgm45 TO FORMONLY.sgm45
      DISPLAY l_sgm06 TO FORMONLY.sgm06
      DISPLAY l_sgm05 TO FORMONLY.sgm05
      #-->不分批做Check-in
      IF g_sma.sma897='N' THEN
         SELECT count(*) INTO l_n FROM sha_file
          WHERE sha08 = g_sha.sha08
            AND sha02 = g_sha.sha02
            AND sha012=g_sha.sha012  #NO.FUN-A60080
         IF l_n > 0 THEN
            LET g_msg = g_sha.sha08,'+',g_sha.sha02 CLIPPED
            CALL cl_err(g_msg,-239,0)
            LET g_errno=-239
            RETURN
         END IF
      END IF
   END IF

END FUNCTION
#end MOD-A60042 add

FUNCTION i710_sha03(p_cmd)
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
 
FUNCTION i710_sha06(p_cmd)    #人員
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
 
 
FUNCTION i710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sha.* TO NULL               #No.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i710_curs()                         # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_ecbb.clear()
        RETURN
    END IF
    OPEN i710_count
    FETCH i710_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i710_cs         # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sha.sha01,SQLCA.sqlcode,0)
        INITIALIZE g_sha.* TO NULL
    ELSE
        CALL i710_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i710_fetch(p_flsha)
    DEFINE
        p_flsha         LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flsha
        WHEN 'N' FETCH NEXT     i710_cs INTO g_sha.sha08,
                                             g_sha.sha01,g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041
                                             ,g_sha.sha012              #NO.FUN-A60080
                                             
        WHEN 'P' FETCH PREVIOUS i710_cs INTO g_sha.sha08,
                                             g_sha.sha01, g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041
                                             ,g_sha.sha012              #NO.FUN-A60080
                                
        WHEN 'F' FETCH FIRST    i710_cs INTO g_sha.sha08,
                                             g_sha.sha01, g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041
                                             ,g_sha.sha012              #NO.FUN-A60080
                                
        WHEN 'L' FETCH LAST     i710_cs INTO g_sha.sha08,
                                             g_sha.sha01, g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041
                                             ,g_sha.sha012              #NO.FUN-A60080
                                
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i710_cs INTO g_sha.sha08,
                                             g_sha.sha01,g_sha.sha02,
                                             g_sha.sha04,g_sha.sha041
                                             ,g_sha.sha012              #NO.FUN-A60080
                                
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sha.sha08,SQLCA.sqlcode,0)
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
         AND sha012=g_sha.sha012              #NO.FUN-A60080
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_sha.sha08,SQLCA.sqlcode,1)   #No.FUN-660128
       CALL cl_err3("sel","sha_file",g_sha.sha01,g_sha.sha02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_sha.* TO NULL            #FUN-4C0035
    ELSE
       LET g_data_owner = g_sha.shauser      #FUN-4C0035
       LET g_data_group = g_sha.shagrup      #FUN-4C0035
       LET g_data_plant = g_sha.shaplant #FUN-980030
       CALL i710_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i710_show()
    DEFINE l_sgm04  LIKE sgm_file.sgm04,
           l_sgm45  LIKE sgm_file.sgm45,
           l_sgm06  LIKE sgm_file.sgm06,
           l_sgm05  LIKE sgm_file.sgm05,
           l_ecu014 LIKE ecu_file.ecu014  #NO.FUN-A60080
            
    LET g_sha_t.* = g_sha.*
    DISPLAY BY NAME g_sha.sha08,g_sha.sha01,g_sha.sha012,g_sha.sha02,g_sha.shaoriu,g_sha.shaorig,  #NO.FUN-A60080 add sha012
                    g_sha.sha03,g_sha.sha04,g_sha.sha041,
                    g_sha.sha05,g_sha.sha06,g_sha.sha07,g_sha.sha03,
                    g_sha.shauser,g_sha.shagrup,g_sha.shamodu,
                    g_sha.shadate
    SELECT sgm04,sgm45,sgm06,sgm05 INTO
          l_sgm04,l_sgm45,l_sgm06,l_sgm05
      FROM sgm_file
     WHERE sgm01 = g_sha.sha08 AND sgm03 = g_sha.sha02
    CALL i710_sgm_show()
    DISPLAY l_sgm04 TO FORMONLY.sgm04
    DISPLAY l_sgm45 TO FORMONLY.sgm45
    DISPLAY l_sgm06 TO FORMONLY.sgm06
    DISPLAY l_sgm05 TO FORMONLY.sgm05
    DISPLAY l_ecu014 TO FORMONLY.ecu014  #NO.FUN-A60080
    
display 'old sha01=',g_sha.sha01
    CALL i710_sha08('d')
display 'new sha01=',g_sha.sha01
    CALL i710_sha03('d')
    CALL i710_sha06('d')
    CALL i710_b_fill()
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i710_b_fill()
    DEFINE l_shm05   LIKE shm_file.shm05,
           l_shm06   LIKE shm_file.shm06,
           l_ima571  LIKE ima_file.ima571,
           l_cnt     LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    SELECT shm05,shm06,ima571 INTO l_shm05,l_shm06,l_ima571
       FROM shm_file,ima_file
      WHERE shm01=g_sha.sha08 AND ima01=shm05
    IF STATUS THEN LET l_shm05='' LET l_shm06='' LET l_ima571='' END IF
    
    SELECT COUNT(*) INTO l_cnt FROM ecbb_file
      WHERE ecbb01=l_shm05 AND ecbb02=l_shm06 AND ecbb012=g_sha.sha012
    IF l_cnt=0 THEN
       LET l_shm05=l_ima571
    END IF
 
    LET g_sql = "SELECT ecbb09,ecbb10 ",
                " FROM  ecbb_file",
                " WHERE ecbb01='",l_shm05,"' ",
                "   AND ecbb02='",l_shm06,"' ",
                "   AND ecbb03='",g_sha.sha02,"' ",
                "   AND ecbb012='",g_sha.sha012,"' ",
                " ORDER BY ecbb09"
 
    PREPARE i710_pb FROM g_sql
    DECLARE ecbb_curs CURSOR FOR i710_pb
 
    CALL g_ecbb.clear()
    LET g_cnt = 1
    FOREACH ecbb_curs INTO g_ecbb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    IF STATUS THEN CALL cl_err('fore ecbb:',STATUS,1) END IF
    LET g_rec_b=g_cnt - 1
 
END FUNCTION
 
FUNCTION i710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecbb TO s_ecbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
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
         CALL i710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i710_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
     #ON ACTION accept
     #   LET g_action_choice="detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DISPLAY
 
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
 
 
FUNCTION i710_r()
DEFINE l_sgm291 LIKE sgm_file.sgm291,
       l_qty    LIKE sgm_file.sgm291
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sha.sha01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF cl_null(g_sha.sha08) THEN CALL cl_err('',-400,0) RETURN END IF
    IF cl_null(g_sha.sha02) THEN CALL cl_err('',-400,0) RETURN END IF
 
    SELECT sgm291,(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)*sgm59
      INTO l_sgm291,l_qty
      FROM sgm_file
     WHERE sgm01 = g_sha.sha08 AND sgm03 = g_sha.sha02 
      AND sgm012=g_sha.sha012  #NO.FUN-A60080 
     IF l_sgm291-g_sha.sha05<l_qty
     THEN CALL cl_err(l_qty,'asf-669',0)
          RETURN
     END IF
 
    BEGIN WORK
    OPEN i710_cl USING g_sha.sha01,g_sha.sha02,g_sha.sha04,g_sha.sha041,g_sha.sha08,g_sha.sha012              #NO.FUN-A60080
    IF STATUS THEN
       CALL cl_err("OPEN i710_cl:", STATUS, 1)
       CLOSE i710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i710_cl INTO g_sha.*
    IF SQLCA.sqlcode THEN
       LET g_msg = g_sha.sha08 CLIPPED,'+',g_sha.sha01,'+',g_sha.sha02
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i710_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sha08"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "sha01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "sha02"          #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "sha04"          #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "sha041"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sha.sha08       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_sha.sha01       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_sha.sha02       #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_sha.sha04       #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_sha.sha041      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM sha_file WHERE sha08 = g_sha.sha08
                              AND sha01 = g_sha.sha01
                              AND sha02 = g_sha.sha02
                              AND sha04 = g_sha.sha04
                              AND sha041= g_sha.sha041
                              AND sha012=g_sha.sha012              #NO.FUN-A60080
     IF SQLCA.sqlcode THEN 
   #      CALL cl_err('',STATUS,1)   #No.FUN-660128
         CALL cl_err3("del","sha_file",g_sha.sha01,g_sha.sha02,STATUS,"","",1)  #No.FUN-660128
          RETURN
       ELSE
          CALL i710_upd_sgm()  #Update check in 量
          CLEAR FORM
          CALL g_ecbb.clear()
          OPEN i710_count
          #FUN-B50064-add-start--
          IF STATUS THEN
             CLOSE i710_cs
             CLOSE i710_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          FETCH i710_count INTO g_row_count
          #FUN-B50064-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i710_cs
             CLOSE i710_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i710_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i710_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i710_fetch('/')
          END IF
 
       END IF
    END IF
    CLOSE i710_cl
    COMMIT WORK
END FUNCTION
 
#更新工單製程追蹤檔的check in數量
FUNCTION i710_upd_sgm()
DEFINE l_sum_sha05   LIKE sha_file.sha05
DEFINE l_sgm58       LIKE sgm_file.sgm58   #FUN-BB0085
 
   SELECT SUM(sha05) INTO l_sum_sha05
     FROM sha_file
    WHERE sha08=g_sha.sha08
      AND sha02=g_sha.sha02
      AND sha012=g_sha.sha012              #NO.FUN-A60080
      
   IF cl_null(l_sum_sha05) THEN LET l_sum_sha05=0 END IF
   #FUN-BB0085-add-str--
   SELECT sgm58 INTO l_sgm58 FROM sgm_file
    WHERE sgm01 = g_sha.sha08
      AND sgm03 = g_sha.sha02
      AND sgm012=g_sha.sha012
   LET l_sum_sha05 = s_digqty(l_sum_sha05,l_sgm58) 
   #FUN-BB0085-add-end--
   UPDATE sgm_file SET sgm291 = l_sum_sha05
                  WHERE sgm01 = g_sha.sha08
                    AND sgm03 = g_sha.sha02
                    AND sgm012=g_sha.sha012              #NO.FUN-A60080
   IF SQLCA.sqlcode THEN
#     CALL cl_err('','asf-721',1)   #No.FUN-660128
      CALL cl_err3("upd","sgm_file",g_sha01_t,g_sha02_t,"asf-721","","",1)  #No.FUN-660128
   END IF
END FUNCTION
 
FUNCTION i710_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sha08,sha01,sgm04,sha04,sha041,sha03",TRUE)
      CALL cl_set_comp_entry("sgm04",g_sma.sma541='N')  #NO.FUN-A60080    
   END IF
 
END FUNCTION
 
FUNCTION i710_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sha08,sha01,sgm04,sha04,sha041,sha03",FALSE) 
      CALL cl_set_comp_entry("sgm04",g_sma.sma541='Y')  #NO.FUN-A60080   
   END IF
END FUNCTION

