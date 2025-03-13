# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# Pattern name...: agli101.4gl
# Descriptions...: 帳別
# Date & Author..: 92/04/06 BY MAY
# Modify         : 95/10/03 BY Lynn   Add ^P 幣別(aaa03)
# Modify         : 97/04/16 By Melody aaa07 改為關帳日期
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: NO.FUN-570097 05/08/25 By ice  增加aaa09/aaa10  結帳方式 1.表結 2.帳結
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640154 06/05/22 By Sarah 增加Action"使用者設限"
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0083 06/11/08 By xumin 報表寬度調整及增加月結方式表結方式
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/07/27 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.FUN-750022 07/08/10 By xufeng  新增依部門設定權限
# Modify.........: No.MOD-7C0122 07/12/18 By Smapmin 修改狀態不需再給預設值.
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-950045 09/05/08 By xiaofeizhu 當資料有效碼(aaaacti)='N'時，不可刪除該筆資料
# Modify.........: No.TQC-960435 09/06/30 By xiaofeizhu 現行年度不可錄入負值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30112 10/08/06 By chenmoyan add aaa11匯兌損失科目/aaa12 匯兌收益科目
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60377 11/06/30 By yinhy 更改錯誤碼'agl-943'為'agl-994'
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: NO.FUN-BC0027 11/12/08 By lilingyu 增加三個科目維護(aaa14 aaa15 aaa16)
# Modify.........: NO.FUN-BB0123 11/12/26 by Lori add aaa13是否拋轉立沖帳明細
# Modify.........: NO.TQC-BC0016 12/01/17 By Lori 預設aaa13為N,增加aaa13的QBE查詢
# Modify.........: NO.TQC-C20096 11/12/09 By Carrier construct aaaoriu,aaaorig
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C80124 12/08/22 By lujh 新增帳套資料aaa13欄位默認值有誤，應是Y/N的一種，目前默認值是‘’
# Modify.........: No.FUN-D20046 13/03/21 By Lori 新增ACTION「編制合併報表營運中心」，定義哪一個營運中心為編制合併報表的營運中心(by帳別)
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40119 13/05/20 By zhangweib aaa14,aaa15,選擇表結法(aaa09 or aaa10='1')時,此字段為必填欄
#                                                      aaa16,選擇帳結法(aaa09 or aaa10='2')時,此字段為必填欄
# Modify.........: No:MOD-D80032 13/08/06 By fengmy mark FUN-D40119
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_aaa           RECORD LIKE aaa_file.*,       #帳別 (假單頭)
    g_aaa_t         RECORD LIKE aaa_file.*,       #帳別 (舊值)
    g_aaa_o         RECORD LIKE aaa_file.*,       #帳別 (舊值)
    g_aaa01_t       LIKE aaa_file.aaa01,          #帳別 (舊值)
    g_aaf           DYNAMIC ARRAY OF RECORD           #程式變數(Program Variables)
        aaf02       LIKE aaf_file.aaf02,          #語言別
        aaf03       LIKE aaf_file.aaf03           #名稱
                    END RECORD,
    g_aaf_t         RECORD                        #程式變數 (舊值)
        aaf02       LIKE aaf_file.aaf02,          #語言別
        aaf03       LIKE aaf_file.aaf03           #名稱
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,#TQC-630166
    g_rec_b         LIKE type_file.num5,          #單身筆數 #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680098 smallint
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680098 SMALLINT
DEFINE g_aag02_1            LIKE aag_file.aag02     #FUN-A30112
DEFINE g_aag02_2            LIKE aag_file.aag02     #FUN-A30112
 
#主程式開始
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680098 VARCHAR(1)  
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose #No.FUN-680098 smallint
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680098 VARCHAR(100)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-680098 INTEGER    
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680098 SMALLINT
#No.FUN-760085---Begin
DEFINE   g_str           STRING                 
DEFINE   l_sql           STRING                 
DEFINE   l_table         STRING                 
#No.FUN-760085---End
DEFINE g_argv1     LIKE aaa_file.aaa01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
#FUN-BC0027 --begin--
DEFINE g_aaa14_1            LIKE aaa_file.aaa02
DEFINE g_aaa15_1            LIKE aaa_file.aaa02
DEFINE g_aaa16_1            LIKE aaa_file.aaa02
#FUN-BC0027 --end--

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680098 smallint
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
   #No.FUN-760085---Begin
   LET g_sql = "aaa01.aaa_file.aaa01,",
               "aaa02.aaa_file.aaa02,", 
               "aaa03.aaa_file.aaa03,",
               "aaa04.aaa_file.aaa04,",
               "aaa05.aaa_file.aaa05,",
               "aaa06.aaa_file.aaa06,",
               "aaa07.aaa_file.aaa07,",
               "aaa09.aaa_file.aaa09,",
               "aaa10.aaa_file.aaa10,",
               "aaf02.aaf_file.aaf02,",
               "aaf03.aaf_file.aaf03,", 
               "l_desc1.ze_file.ze03,",
               "l_desc2.ze_file.ze03 "
      
   LET l_table = cl_prt_temptable('agli101',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "                            
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #NO.FUN-760085---End         
 
    LET g_forupd_sql="SELECT * FROM aaa_file WHERE aaa01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 26
 
    OPEN WINDOW i101_w AT p_row,p_col WITH FORM "agl/42f/agli101"
        ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
#No.MOD-D80032 ---mark--- Start 
   #No.FUN-D40119 ---Add--- Start
#    IF g_aza.aza26 = '2' THEN
#       CALL cl_set_comp_att_text("aaa14",cl_getmsg("agl-366",g_lang))
#       CALL cl_set_comp_att_text("aaa15",cl_getmsg("agl-367",g_lang))
#       CALL cl_set_comp_att_text("aaa16",cl_getmsg("agl-368",g_lang))
#    END IF
   #No.FUN-D40119 ---Add--- End
#No.MOD-D80032 ---mark--- End
 
    # 2004/03/24 新增語言別選項
    CALL cl_set_combo_lang("aaf02")
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i101_a()
            END IF
         OTHERWISE        
            CALL i101_q() 
      END CASE
   END IF
   #--
 
    CALL i101_menu()
    CLOSE WINDOW i101_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i101_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_aaf.clear()
 
    INITIALIZE g_aaa.* TO NULL
    CALL g_aaf.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_aaa.* TO NULL    #No.FUN-750051
 
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" aaa01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        aaa01,aaa02,aaa04,aaa05,aaa03,aaa06,aaa07,aaa11,aaa12,aaa14,aaa15,aaa16,aaa09,aaa10,  #No.FUN-570097 #FUN-A30112 add aaa11,aaa12
                                              #FUN-BC0027 add aaa14,aaa15,aaa16
        aaauser,aaagrup,aaaoriu,aaaorig,aaamodu,aaadate,aaaacti,aaa13                       #TQC-BC0016 add aaa13  #No.TQC-C20096
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
    ON ACTION controlp
       CASE
          WHEN INFIELD(aaa03)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azi"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aaa03
             NEXT FIELD aaa03
#FUN-BC0027 --begin--
          WHEN INFIELD(aaa14)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aaa14"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aaa14
             NEXT FIELD aaa14
          WHEN INFIELD(aaa15)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aaa15"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aaa15
             NEXT FIELD aaa15
          WHEN INFIELD(aaa16)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aaa16"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aaa16
             NEXT FIELD aaa16
#FUN-BC0027 --end--
          OTHERWISE EXIT CASE
       END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CONSTRUCT g_wc2 ON aaf02,aaf03                # 螢幕上取單身條件
            FROM s_aaf[1].aaf02,s_aaf[1].aaf03
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF  #FUN-7C0050
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND aaauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND aaagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND aaagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaauser', 'aaagrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  aaa01 FROM aaa_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY aaa01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT  aaa01 ",
                   "  FROM aaa_file, aaf_file ",
                   " WHERE aaa01 = aaf01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY aaa01"
    END IF
 
    PREPARE i101_prepare FROM g_sql
    DECLARE i101_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i101_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM aaa_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT aaa01) FROM aaa_file,aaf_file WHERE ",
                  "aaf01=aaa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
END FUNCTION
 
FUNCTION i101_menu()
 
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL i101_a()
              END IF
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL i101_q()
              END IF
           WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL i101_r()
              END IF
           WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL i101_u()
              END IF
           WHEN "invalid"
              IF cl_chk_act_auth() THEN
                 CALL i101_x()
                 CALL cl_set_field_pic("","","","","",g_aaa.aaaacti)
              END IF
           WHEN "reproduce"
              IF cl_chk_act_auth() THEN
                 CALL i101_copy()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL i101_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
           WHEN "output"
              IF cl_chk_act_auth() THEN
                 CALL i101_out()
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
         
           ##FUN-BB0123--Begin--
           WHEN "i101_aaa13"
            IF cl_chk_act_auth() THEN
               CALL i101_aaa13()
            END IF
           ##FUN-BB0123---End---

         #start FUN-640154 add
         #@WHEN "使用者設限"
           WHEN "authorization"
              IF NOT cl_null(g_aaa.aaa01) THEN
                 IF cl_chk_act_auth() THEN
                    CALL s_aay(g_aaa.aaa01)
                 END IF
                 LET g_msg = s_aay_d(g_aaa.aaa01)
                 DISPLAY g_msg TO aay02_desc
              ELSE
                CALL cl_err('','-400',0)
              END IF
         #end FUN-640154 add
         #start FUN-750022 add
         #@WHEN "部門設限"    
           WHEN "dept_authorization"   
              IF NOT cl_null(g_aaa.aaa01) THEN
                 IF cl_chk_act_auth() THEN
                    CALL s_aax(g_aaa.aaa01)
                 END IF
                 LET g_msg = s_aax_d(g_aaa.aaa01)
                 DISPLAY g_msg TO aax02_desc
              ELSE
                 CALL cl_err('','-400',0)
              END IF
         #end FUN-750022 add

           #FUN-D20046 add begin---
           #編制合併報表營運中心
           WHEN "consolidation_plant"
              IF cl_chk_act_auth() THEN
                 CALL i101_cons_plant()
              END IF
           #FUN-D20046 add end-----

           WHEN "related_document"  #No.MOD-470515
              IF cl_chk_act_auth() THEN
                 IF g_aaa.aaa01 IS NOT NULL THEN
                    LET g_doc.column1 = "aaa01"
                    LET g_doc.value1 = g_aaa.aaa01
                    CALL cl_doc()
                 END IF
              END IF
           WHEN "exporttoexcel"   #No.FUN-4B0010
              IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aaf),'','')
              END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i101_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_aaf.clear()
    INITIALIZE g_aaa.* LIKE aaa_file.*             #DEFAULT 設定
    LET g_aaa01_t = NULL
    #預設值及將數值類變數清成零
    LET g_aaa_o.* = g_aaa.*
    CALL cl_opmsg('a')
    WHILE TRUE
        #NO.590002 START----------
        LET g_aaa.aaa09= '1'
        LET g_aaa.aaa10= '1'
        #NO.590002 END------------
        LET g_aaa.aaauser=g_user
        LET g_aaa.aaaoriu = g_user #FUN-980030
        LET g_aaa.aaaorig = g_grup #FUN-980030
        LET g_aaa.aaagrup=g_grup
        LET g_aaa.aaadate=g_today
        LET g_aaa.aaaacti='Y'                      #資料有效
        LET g_aaa.aaa13 = 'N'   #TQC-C80124  add
        #FUN-D20046 add begin---
        IF cl_null(g_aaa.aaa17) THEN
           LET g_aaa.aaa17 = ' '
        END IF
        #FUN-D20046 add end-----
        DISPLAY g_aaa.aaa13 TO aaa13  #TQC-C80124  add
        CALL i101_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            INITIALIZE g_aaa.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_aaa.aaa01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_aaa.aaa13 = 'N'                      #TQC-BC0016
        INSERT INTO aaa_file VALUES (g_aaa.*)
        IF SQLCA.sqlcode THEN   	           # 置入資料庫不成功
#           CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("ins","aaa_file",g_aaa.aaa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        SELECT aaa01 INTO g_aaa.aaa01 FROM aaa_file
            WHERE aaa01 = g_aaa.aaa01
        LET g_aaa01_t = g_aaa.aaa01        #保留舊值
        LET g_aaa_t.* = g_aaa.*
 
        CALL g_aaf.clear()
        LET g_rec_b = 0
 
        CALL i101_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i101_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_aaa.aaa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_aaa.aaa01
    IF g_aaa.aaaacti ='N' THEN                       #檢查資料是否為無效
       CALL cl_err(g_aaa.aaa01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aaa01_t = g_aaa.aaa01
    LET g_aaa_o.* = g_aaa.*
    BEGIN WORK
    OPEN i101_cl USING g_aaa.aaa01
    IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN i101_cl',SQLCA.sqlcode,0)     #資料被他人LOCK
        CLOSE i101_cl ROLLBACK WORK RETURN
    END IF
    FETCH i101_cl INTO g_aaa.*                       #鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)     #資料被他人LOCK
        CLOSE i101_cl ROLLBACK WORK RETURN
    END IF
    CALL i101_show()
    WHILE TRUE
        #-----MOD-7C0122---------
        ##NO.590002 START----------
        #LET g_aaa.aaa09= '1'
        #LET g_aaa.aaa10= '1'
        ##NO.590002 END------------
        #-----END MOD-7C0122-----
        LET g_aaa01_t = g_aaa.aaa01
        LET g_aaa.aaamodu=g_user
        LET g_aaa.aaadate=g_today
        CALL i101_i("u")                            # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aaa.*=g_aaa_t.*
            CALL i101_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_aaa.aaa01 != g_aaa01_t THEN            # 更改單號
            UPDATE aaf_file SET aaf01 = g_aaa.aaa01
                WHERE aaf01 = g_aaa01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('aaf',SQLCA.sqlcode,0)  #No.FUN-660123
                CALL cl_err3("upd","aaf_file",g_aaa01_t,"",SQLCA.sqlcode,"","aaf",1)  #No.FUN-660123
                 CONTINUE WHILE
            END IF
        END IF
        UPDATE aaa_file SET aaa_file.* = g_aaa.*
            WHERE aaa01 = g_aaa.aaa01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","aaa_file",g_aaa01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i101_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入 #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改          #No.FUN-680098 VARCHAR(1)
    l_n             LIKE type_file.num5,     #No.FUN-680098 smallint
    l_year          LIKE axa_file.axa10,      #FUN-D20046 add
    l_period        LIKE axa_file.axa11       #FUN-D20046 add
 
    DISPLAY BY NAME g_aaa.aaauser,g_aaa.aaagrup,
                    g_aaa.aaadate,g_aaa.aaaacti
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT BY NAME #aaaorig,aaaoriu,       #FUN-9A0036
        g_aaa.aaa01,g_aaa.aaa02,g_aaa.aaa04,g_aaa.aaa05,
	g_aaa.aaa03,g_aaa.aaa06,g_aaa.aaa07,
        g_aaa.aaa11,g_aaa.aaa12,           #FUN-A30112
        g_aaa.aaa14,g_aaa.aaa15,g_aaa.aaa16,           #FUN-BC0027 add 
        g_aaa.aaa09,g_aaa.aaa10 #No.FUN-570097
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i101_set_entry(p_cmd)
            CALL i101_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.MOD-D80032 ---mark--- Start
#No.FUN-D40119 ---Add--- Start
#        AFTER INPUT
#           IF g_aza.aza26 = '2' THEN
#              IF g_aaa.aaa09 = '1' OR g_aaa.aaa10 = '1' THEN
#                 IF cl_null(g_aaa.aaa14) THEN
#                    CALL cl_err(g_aaa.aaa01,'agl-282',0)
#                    NEXT FIELD aaa14
#                 END IF
#                 IF cl_null(g_aaa.aaa15) THEN
#                    CALL cl_err(g_aaa.aaa01,'agl-282',0)
#                    NEXT FIELD aaa15
#                 END IF
#              END IF
#              IF g_aaa.aaa09 = '2' OR g_aaa.aaa10 = '2' THEN
#                 IF cl_null(g_aaa.aaa16) THEN
#                    CALL cl_err(g_aaa.aaa01,'agl-283',0)
#                    NEXT FIELD aaa16
#                 END IF
#              END IF
#           END IF
       #No.FUN-D40119 ---Add--- End
#No.MOD-D80032 ---mark--- End 
        AFTER FIELD aaa01
            IF NOT cl_null(g_aaa.aaa01) THEN
 
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_aaa.aaa01 != g_aaa01_t) THEN
                   SELECT count(*) INTO l_n FROM aaa_file
                    WHERE aaa01 = g_aaa.aaa01
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_aaa.aaa01,-239,0)
                       LET g_aaa.aaa01 = g_aaa01_t
                       DISPLAY BY NAME g_aaa.aaa01
                       NEXT FIELD aaa01
                   END IF
               END IF
            END IF
 
        AFTER FIELD aaa03
            IF NOT cl_null(g_aaa.aaa03) THEN
               SELECT * FROM azi_file
                WHERE azi01 = g_aaa.aaa03   AND aziacti = 'Y'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_aaa.aaa03,'agl-109',0)   #No.FUN-660123
                  CALL cl_err3("sel","azi_file",g_aaa.aaa03,"","agl-109","","",1)  #No.FUN-660123
                  NEXT FIELD aaa03
               END IF
            END IF
 
        #TQC-960435--Begin--#                                                                                                       
        AFTER FIELD aaa04                                                                                                           
            IF NOT cl_null(g_aaa.aaa04) THEN                                                                                        
               IF g_aaa.aaa04 < 0 THEN                                                                                              
                  CALL cl_err('','mfg4012',0)                                                                                       
                  NEXT FIELD aaa04                                                                                                  
               END IF                                                                                                               
            END IF                                                                                                                  
        #TQC-960435--End--#
 
        AFTER FIELD aaa05
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_aaa.aaa05) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_aaa.aaa04
            IF g_azm.azm02 = 1 THEN
               IF g_aaa.aaa05 > 12 OR g_aaa.aaa05 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD aaa05
               END IF
            ELSE
               IF g_aaa.aaa05 > 13 OR g_aaa.aaa05 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD aaa05
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
           IF NOT cl_null(g_aaa.aaa05) THEN
              IF g_aaa.aaa05 > 13 OR g_aaa.aaa05 < 1 THEN
                 NEXT  FIELD aaa05
              END IF
           END IF
 
      #--FUN-A30112 start---
      AFTER FIELD aaa11
         IF NOT cl_null(g_aaa.aaa11) THEN
            CALL i101_aag(g_aaa.aaa11,g_aaa.aaa01) RETURNING g_aag02_1
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #Add No.FUN-B10048
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_aaa.aaa11
               LET g_qryparam.arg1 = g_aaa.aaa01
               LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_aaa.aaa11 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_aaa.aaa11
               DISPLAY BY NAME g_aaa.aaa11
               #End Add No.FUN-B10048
               NEXT FIELD aaa11
            ELSE
               DISPLAY g_aag02_1 TO aag02_1
            END IF
         END IF
      AFTER FIELD aaa12
         IF NOT cl_null(g_aaa.aaa12) THEN
            CALL i101_aag(g_aaa.aaa12,g_aaa.aaa01) RETURNING g_aag02_2
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #Add No.FUN-B10048
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_aaa.aaa12
               LET g_qryparam.arg1 = g_aaa.aaa01
               LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_aaa.aaa12 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_aaa.aaa12
               DISPLAY BY NAME g_aaa.aaa12
               #End Add No.FUN-B10048
               NEXT FIELD aaa12
            ELSE
               DISPLAY g_aag02_2 TO aag02_2
            END IF
         END IF
      #--FUN-A30112 end----
#FUN-BC0027 --begin--
     AFTER FIELD aaa14
         IF NOT cl_null(g_aaa.aaa14) THEN
            CALL i101_aag(g_aaa.aaa14,g_aaa.aaa01) RETURNING g_aaa14_1
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT
            ELSE
               DISPLAY g_aaa14_1 TO aaa14_1
            END IF
         ELSE
                  DISPLAY '' TO aaa14_1
         END IF

    AFTER FIELD aaa15
         IF NOT cl_null(g_aaa.aaa15) THEN
            CALL i101_aag(g_aaa.aaa15,g_aaa.aaa01) RETURNING g_aaa15_1
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT
            ELSE
               DISPLAY g_aaa15_1 TO aaa15_1
            END IF
         ELSE
                  DISPLAY '' TO aaa15_1
         END IF

     AFTER FIELD aaa16
         IF NOT cl_null(g_aaa.aaa16) THEN
            CALL i101_aag(g_aaa.aaa16,g_aaa.aaa01) RETURNING g_aaa16_1
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT
            ELSE
               DISPLAY g_aaa16_1 TO aaa16_1
            END IF
         ELSE
               DISPLAY '' TO aaa16_1
         END IF
#FUN-BC0027 --end--


#No.FUN-570097 --start--
#     AFTER FIELD aaa09
      ON CHANGE  aaa09
         IF NOT cl_null(g_aaa.aaa09) THEN
            IF g_aaa.aaa09 NOT MATCHES '[12]' THEN
               LET g_aaa.aaa09=g_aaa_o.aaa09
               DISPLAY BY NAME g_aaa.aaa09
               NEXT FIELD aaa09
            END IF
            LET g_aaa_o.aaa09=g_aaa.aaa09
            IF g_aaa.aaa09 = '2' THEN
               LET g_aaa.aaa10 = '2'
            END IF
            DISPLAY BY NAME g_aaa.aaa10
            CALL i101_set_entry(p_cmd)
            CALL i101_set_no_entry(p_cmd)
         END IF
 
      AFTER FIELD aaa10
         IF NOT cl_null(g_aaa.aaa10) THEN
            IF g_aaa.aaa10 NOT MATCHES '[12]' THEN
               LET g_aaa.aaa10=g_aaa_o.aaa10
               DISPLAY BY NAME g_aaa.aaa10
               NEXT FIELD aaa10
            END IF
            LET g_aaa_o.aaa10=g_aaa.aaa10
         END IF
#No.FUN-570097 ---end--
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(aaa01) THEN
       #         LET g_aaa.* = g_aaa_t.*
       #         DISPLAY BY NAME g_aaa.*
       #         NEXT FIELD aaa01
       #     END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(aaa03)
#                CALL q_azi(05,11,g_aaa.aaa03) RETURNING g_aaa.aaa03
#                CALL FGL_DIALOG_SETBUFFER( g_aaa.aaa03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_aaa.aaa03
                 CALL cl_create_qry() RETURNING g_aaa.aaa03
#                 CALL FGL_DIALOG_SETBUFFER( g_aaa.aaa03 )
                 DISPLAY BY NAME g_aaa.aaa03
                 NEXT FIELD aaa03
#--FUN-A30112 start---
              WHEN INFIELD(aaa11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_aaa.aaa11
                 LET g_qryparam.arg1 = g_aaa.aaa01
                 CALL cl_create_qry() RETURNING g_aaa.aaa11
                 DISPLAY BY NAME g_aaa.aaa11
                 NEXT FIELD aaa11
              WHEN INFIELD(aaa12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_aaa.aaa12
                 LET g_qryparam.arg1 = g_aaa.aaa01
                 CALL cl_create_qry() RETURNING g_aaa.aaa12
                 DISPLAY BY NAME g_aaa.aaa12
                 NEXT FIELD aaa12
#--FUN-A30112 end-----

#FUN-BC0027 --begin--
           WHEN INFIELD(aaa14)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_aaa.aaa14
               LET g_qryparam.arg1 = g_aaa.aaa01
               CALL cl_create_qry() RETURNING g_aaa.aaa14
               DISPLAY BY NAME g_aaa.aaa14
               NEXT FIELD aaa14
           WHEN INFIELD(aaa15)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_aaa.aaa15
               LET g_qryparam.arg1 = g_aaa.aaa01
               CALL cl_create_qry() RETURNING g_aaa.aaa15
               DISPLAY BY NAME g_aaa.aaa15
               NEXT FIELD aaa15
           WHEN INFIELD(aaa16)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_aaa.aaa16
               LET g_qryparam.arg1 = g_aaa.aaa01
               CALL cl_create_qry() RETURNING g_aaa.aaa16
               DISPLAY BY NAME g_aaa.aaa16
               NEXT FIELD aaa16
#FUN-BC0027 --end--

              OTHERWISE EXIT CASE
           END CASE
 
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
 
FUNCTION i101_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680098char(01)  
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aaa01",TRUE)
    END IF
 
    #No.FUN-570097
    #IF INFIELD(aaa09) THEN   #MOD-7C0122
       CALL cl_set_comp_entry("aaa10",TRUE)
    #END IF   #MOD-7C0122
    #end No.FUN-570097
END FUNCTION
 
FUNCTION i101_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aaa01",FALSE)
    END IF
 
    #No.FUN-570097
    #IF INFIELD(aaa09) THEN   #MOD-7C0122
       IF g_aaa.aaa09 = '2' THEN
          CALL cl_set_comp_entry("aaa10",FALSE)
       END IF
    #END IF   #MOD-7C0122
    #end No.FUN-570097
 
END FUNCTION
#Query 查詢
FUNCTION i101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aaa.* TO NULL               #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_aaf.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i101_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i101_cs                             # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aaa.* TO NULL
    ELSE
        OPEN i101_count
        FETCH i101_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i101_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i101_fetch(p_flag)
DEFINE
    p_flag         LIKE type_file.chr1,    #處理方式    #No.FUN-680098 VARCHAR(1)
    l_abso         LIKE type_file.num10    #絕對的筆數  #No.FUN-680098  integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i101_cs INTO g_aaa.aaa01
        WHEN 'P' FETCH PREVIOUS i101_cs INTO g_aaa.aaa01
        WHEN 'F' FETCH FIRST    i101_cs INTO g_aaa.aaa01
        WHEN 'L' FETCH LAST     i101_cs INTO g_aaa.aaa01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i101_cs INTO g_aaa.aaa01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)
        INITIALIZE g_aaa.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_aaa.aaa01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("sel","aaa_file",g_aaa.aaa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_aaa.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_aaa.aaauser     #No.FUN-4C0048
       LET g_data_group = g_aaa.aaagrup     #No.FUN-4C0048
       CALL i101_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i101_show()
    LET g_aaa_t.* = g_aaa.*                #保存單頭舊值
    DISPLAY BY NAME g_aaa.aaa01, g_aaa.aaa02, g_aaa.aaa03, g_aaa.aaa04, g_aaa.aaaoriu,g_aaa.aaaorig,
                    g_aaa.aaa05, g_aaa.aaa06, g_aaa.aaa07,
                    g_aaa.aaa11, g_aaa.aaa12,  #FUN-A30112
                    g_aaa.aaa14,g_aaa.aaa15,g_aaa.aaa16,   #FUN-BC0027
                    g_aaa.aaauser,g_aaa.aaagrup,g_aaa.aaamodu,g_aaa.aaadate,
                    g_aaa.aaaacti,g_aaa.aaa09,g_aaa.aaa10  #FUN-570097
                   ,g_aaa.aaa13                            #TQC-BC0016
   #start FUN-640154 add
    LET g_msg = s_aay_d(g_aaa.aaa01)
    DISPLAY g_msg TO aay02_desc
   #end FUN-640154 add

    CALL i101_aag(g_aaa.aaa11,g_aaa.aaa01) RETURNING g_aag02_1  #FUN-A30112
    CALL i101_aag(g_aaa.aaa12,g_aaa.aaa01) RETURNING g_aag02_2  #FUN-A30112
    DISPLAY g_aag02_1 TO aag02_1                                #FUN-A30112
    DISPLAY g_aag02_2 TO aag02_2                                #FUN-A30112

#FUN-BC0027 --begin--
    CALL i101_aag(g_aaa.aaa14,g_aaa.aaa01) RETURNING g_aaa14_1
    DISPLAY g_aaa14_1 TO aaa14_1
    CALL i101_aag(g_aaa.aaa15,g_aaa.aaa01) RETURNING g_aaa15_1
    DISPLAY g_aaa15_1 TO aaa15_1
    CALL i101_aag(g_aaa.aaa16,g_aaa.aaa01) RETURNING g_aaa16_1
    DISPLAY g_aaa16_1 TO aaa16_1
#FUN-BC0027 --end--

    CALL i101_b_fill(g_wc2)                 #單身
    CALL cl_set_field_pic("","","","","",g_aaa.aaaacti)
END FUNCTION
 
FUNCTION i101_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_aaa.aaa01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i101_cl USING g_aaa.aaa01
    IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN i101_cl',SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i101_cl ROLLBACK WORK RETURN
    END IF
    FETCH i101_cl INTO g_aaa.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i101_cl ROLLBACK WORK RETURN
    END IF
    CALL i101_show()
    IF cl_exp(0,0,g_aaa.aaaacti) THEN                   #確認一下
        LET g_chr=g_aaa.aaaacti
        IF g_aaa.aaaacti='Y' THEN
            LET g_aaa.aaaacti='N'
        ELSE
            LET g_aaa.aaaacti='Y'
        END IF
        UPDATE aaa_file                    #更改有效碼
            SET aaaacti=g_aaa.aaaacti
            WHERE aaa01=g_aaa.aaa01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","aaa_file",g_aaa.aaa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            LET g_aaa.aaaacti=g_chr
        END IF
        DISPLAY BY NAME g_aaa.aaaacti
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i101_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_aaa.aaa01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
 
    IF g_aaa.aaaacti = 'N' THEN CALL cl_err('','abm-950',0) RETURN END IF             #TQC-950045
 
    BEGIN WORK
    OPEN i101_cl USING g_aaa.aaa01
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)    # 資料被他人LOCK
        CLOSE i101_cl ROLLBACK WORK RETURN
    END IF
    FETCH i101_cl INTO g_aaa.*                      # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)    # 資料被他人LOCK
        CLOSE i101_cl ROLLBACK WORK RETURN
    END IF
    CALL i101_show()
    IF cl_delh(0,0) THEN                            # 確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "aaa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_aaa.aaa01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                         #No.FUN-9B0098 10/02/24
            DELETE FROM aaa_file WHERE aaa01 = g_aaa.aaa01
            IF SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","aaa_file",g_aaa.aaa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            ELSE
               CLEAR FORM
               CALL g_aaf.clear()
               OPEN i101_count
               #FUN-B50062-add-start--
               IF STATUS THEN
                  CLOSE i101_cs
                  CLOSE i101_count
                  COMMIT WORK
                  RETURN
               END IF
               #FUN-B50062-add-end--
               FETCH i101_count INTO g_row_count
               #FUN-B50062-add-start--
               IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                  CLOSE i101_cs
                  CLOSE i101_count
                  COMMIT WORK
                  RETURN
               END IF
               #FUN-B50062-add-end--
               DISPLAY g_row_count TO FORMONLY.cnt
            END IF
            DELETE FROM aaf_file WHERE aaf01 = g_aaa.aaa01
            IF SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('aaf01.file',SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","aaf_file",g_aaa.aaa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            ELSE
               CLEAR FORM
               CALL g_aaf.clear()
            END IF
            CLEAR FORM
            CALL g_aaf.clear()
            CALL g_aaf.clear()
            OPEN i101_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i101_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i101_fetch('/')
            END IF
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680098 smallint
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680098 smallint
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680098 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680098 smallint
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680098 smallint
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_aaa.aaa01 IS NULL THEN
       RETURN
    END IF
    IF g_aaa.aaaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_aaa.aaa01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT aaf02,aaf03 FROM aaf_file",
                       " WHERE aaf01= ? AND aaf02= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_aaf WITHOUT DEFAULTS FROM s_aaf.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN i101_cl USING g_aaa.aaa01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)     #資料被他人LOCK
               CLOSE i101_cl
               ROLLBACK WORK
               RETURN
               #No.FUN-B80057--增加空白行---
                
            ELSE
               FETCH i101_cl INTO g_aaa.*     #鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)     #資料被他人LOCK
                  CLOSE i101_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_aaf_t.* = g_aaf[l_ac].*  #BACKUP
                OPEN i101_bcl USING g_aaa.aaa01,g_aaf_t.aaf02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_aaf_t.aaf02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i101_bcl INTO g_aaf[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_aaf_t.aaf02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aaf[l_ac].* TO NULL      #900423
            LET g_aaf_t.* = g_aaf[l_ac].*         #新輸入資料
            NEXT FIELD aaf02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO aaf_file(aaf01,aaf02,aaf03)
                          VALUES(g_aaa.aaa01,g_aaf[l_ac].aaf02,g_aaf[l_ac].aaf03)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_aaf[l_ac].aaf02,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("ins","aaf_file",g_aaa.aaa01,g_aaf[l_ac].aaf02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD aaf02
            IF NOT cl_null(g_aaf[l_ac].aaf02) THEN
               IF g_aaf[l_ac].aaf02 != g_aaf_t.aaf02 OR
                  g_aaf_t.aaf02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM aaf_file
                    WHERE aaf01 = g_aaa.aaa01
                      AND aaf02 = g_aaf[l_ac].aaf02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_aaf[l_ac].aaf02 = g_aaf_t.aaf02
                      NEXT FIELD aaf02
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_aaf_t.aaf02) THEN
               IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM aaf_file
                 WHERE aaf01 = g_aaa.aaa01 AND
                       aaf02 = g_aaf_t.aaf02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_aaf_t.aaf02,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("del","aaf_file",g_aaa.aaa01,g_aaf_t.aaf02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aaf[l_ac].* = g_aaf_t.*
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aaf[l_ac].aaf02,-263,1)
               LET g_aaf[l_ac].* = g_aaf_t.*
            ELSE
               UPDATE aaf_file SET aaf02=g_aaf[l_ac].aaf02,
                                   aaf03=g_aaf[l_ac].aaf03
                WHERE aaf01=g_aaa.aaa01
                  AND aaf02=g_aaf_t.aaf02
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_aaf[l_ac].* = g_aaf_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_aaf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032 add
            CLOSE i101_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i101_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(aaf02) AND l_ac > 1 THEN
                LET g_aaf[l_ac].* = g_aaf[l_ac-1].*
                NEXT FIELD aaf02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
#No.FUN-6B0029--begin                                             
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
 
    UPDATE aaa_file SET aaamodu=g_user,aaadate=g_today
     WHERE aaa01=g_aaa.aaa01
 
    CLOSE i101_bcl
    COMMIT WORK
    CALL i101_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i101_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM aaa_file WHERE aaa01 = g_aaa.aaa01
         INITIALIZE g_aaa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION i101_b_askkey()
DEFINE
    l_wc2       LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(200) 
 
    CONSTRUCT l_wc2 ON aaf02,aaf03
            FROM s_aaf[1].aaf02,s_aaf[1].aaf03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i101_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i101_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2     LIKE type_file.chr1000#No.FUN-680098 VARCHAR(200)
 
    LET g_sql =
        "SELECT aaf02,aaf03 FROM aaf_file",
    #NO.FUN-8B0123---Begin
        " WHERE aaf01 ='",g_aaa.aaa01,"'"  # AND ",  #單頭
    #   p_wc2 CLIPPED,                     #單身
    #   " ORDER BY aaf02"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY aaf02 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
    
    PREPARE i101_pb FROM g_sql
    DECLARE aaf_curs CURSOR FOR i101_pb
 
    CALL g_aaf.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH aaf_curs INTO g_aaf[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_aaf.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680098   VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aaf TO s_aaf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
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
         CALL i101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION previous
         CALL i101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION jump
         CALL i101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION next
         CALL i101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
      ON ACTION last
         CALL i101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 
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
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("aaf02")
         CALL cl_set_field_pic("","","","","",g_aaa.aaaacti)
         EXIT DISPLAY
 
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ##FUN-BB0123--Begin--
      ON ACTION i101_aaa13
        LET g_action_choice="i101_aaa13"
        EXIT DISPLAY
      ##FUN-BB0123---End---
 
    #start FUN-640154 add
    #@ON ACTION 使用者設限
      ON ACTION authorization
         LET g_action_choice="authorization"
         EXIT DISPLAY
    #end FUN-640154 add
    #start FUN-750022 
    #@ON ACTION 部門設限
      ON ACTION dept_authorization
         LET g_action_choice="dept_authorization"
         EXIT DISPLAY
    #end   FUN-750022 
 
      #FUN-D20046 add begin---
      #編制合併報表營運中心
      ON ACTION consolidation_plant
         LET g_action_choice="consolidation_plant"
         EXIT DISPLAY
      #FUN-D20046 add end-----

#@    ON ACTION 相關文件
      ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i101_bp_refresh()
   DISPLAY ARRAY g_aaf TO s_aaf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
END FUNCTION
 
 
FUNCTION i101_copy()
DEFINE
    l_aaa		RECORD LIKE aaa_file.*,
    l_oldno,l_newno	LIKE aaa_file.aaa01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aaa.aaa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
 
    LET g_before_input_done = FALSE
    CALL i101_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT l_newno FROM aaa01
        AFTER FIELD aaa01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM aaa_file
                WHERE aaa01 = l_newno
               IF g_cnt > 0 THEN
                  CALL cl_err(l_newno,-239,0)
                  NEXT FIELD aaa01
               END IF
            END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_aaa.aaa01
        RETURN
    END IF
    LET l_aaa.* = g_aaa.*
    LET l_aaa.aaa01  =l_newno   #新的鍵值
    LET l_aaa.aaauser=g_user    #資料所有者
    LET l_aaa.aaagrup=g_grup    #資料所有者所屬群
    LET l_aaa.aaamodu=NULL      #資料修改日期
    LET l_aaa.aaadate=g_today   #資料建立日期
    LET l_aaa.aaaacti='Y'       #有效資料
    LET l_aaa.aaaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aaa.aaaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aaa_file VALUES (l_aaa.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('aaa:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","aaa_file",l_aaa.aaa01,"",SQLCA.sqlcode,"","aaa:",1)  #No.FUN-660123
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM aaf_file         #單身複製
        WHERE aaf01=g_aaa.aaa01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_aaa.aaa01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","x",g_aaa.aaa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        RETURN
    END IF
    UPDATE x
        SET aaf01=l_newno
    INSERT INTO aaf_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('aaf:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","aaf_file",l_newno,"",SQLCA.sqlcode,"","aaf:",1)  #No.FUN-660123
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_aaa.aaa01
     SELECT aaa_file.* INTO g_aaa.* FROM aaa_file WHERE aaa01 = l_newno
     CALL i101_u()
     CALL i101_b()
     #SELECT aaa_file.* INTO g_aaa.* FROM aaa_file WHERE aaa01 = l_oldno  #FUN-C30027
     #CALL i101_show()  #FUN-C30027
END FUNCTION
 
FUNCTION i101_out()
DEFINE
    l_i             LIKE type_file.num5,     #No.FUN-680098 SMALLINT
    sr              RECORD
        aaa01       LIKE aaa_file.aaa01,   #帳別
        aaa02       LIKE aaa_file.aaa02,   #說明
        aaa03       LIKE aaa_file.aaa03,   #
        aaa04       LIKE aaa_file.aaa04,   #
        aaa05       LIKE aaa_file.aaa05,   #
        aaa06       LIKE aaa_file.aaa06,   #
        aaa07       LIKE aaa_file.aaa07,   #
        aaf02       LIKE aaf_file.aaf02,   #簽核順序
        aaf03       LIKE aaf_file.aaf03,   #人員代號
        aaa09       LIKE aaa_file.aaa09,   #月結  #No.TQC-6A0083                                                                    
        aaa10       LIKE aaa_file.aaa10,   #年結  #No.TQC-6A0083
        aaaacti     LIKE aaa_file.aaaacti
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680098 VARCHAR(20)
    l_za05          LIKE za_file.za05,      #  #No.FUN-680098 VARCHAR(40)
    l_desc1,l_desc2 LIKE ze_file.ze03          #No.FUN-760085 
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('agli101') RETURNING l_name          #No.FUN-760085
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli101'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT aaa01,aaa02,aaa03,aaa04,aaa05,aaa06,aaa07,",
          "aaf02,aaf03,aaa09,aaa10,aaaacti",   #No.TQC-6A0083
          " FROM aaa_file LEFT OUTER JOIN aaf_file ON aaa01 = aaf_file.aaf01",
          " WHERE  ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i101_co CURSOR FOR i101_p1
 
   #START REPORT i101_rep TO l_name           #No.FUN-760085
    CALL cl_del_data(l_table)                 #No.FUN-760085 
 
    FOREACH i101_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #No.FUN-760085---Begin
        #OUTPUT TO REPORT i101_rep(sr.*)
        LET l_desc1=NULL LET l_desc2=NULL                                                                                       
            CASE sr.aaa09                                                                                                           
                 #WHEN '1' CALL cl_getmsg('agl-943',g_lang) RETURNING l_desc1   #No.TQC-B60377                                                     
                 WHEN '1' CALL cl_getmsg('agl-994',g_lang) RETURNING l_desc1    #No.TQC-B60377                                                    
                 WHEN '2' CALL cl_getmsg('agl-944',g_lang) RETURNING l_desc1                                                        
            END CASE                                                                                                                
            CASE sr.aaa10                                                                                                           
                 #WHEN '1' CALL cl_getmsg('agl-943',g_lang) RETURNING l_desc2   #No.TQC-B60377                                                     
                 WHEN '1' CALL cl_getmsg('agl-994',g_lang) RETURNING l_desc2    #No.TQC-B60377                                                    
                 WHEN '2' CALL cl_getmsg('agl-944',g_lang) RETURNING l_desc2                                                        
            END CASE         
        EXECUTE insert_prep USING sr.aaa01,sr.aaa02,sr.aaa03,sr.aaa04,sr.aaa05,
                                  sr.aaa06,sr.aaa07,sr.aaa09,sr.aaa10,sr.aaf02,
                                  sr.aaf03,l_desc1,l_desc2   
        #No.FUN-760085---End 
    END FOREACH
 
   #FINISH REPORT i101_rep                    #No.FUN-760085  
 
    CLOSE i101_co
   #CALL cl_prt(l_name,' ','1',g_len)         #No.FUN-760085    
    MESSAGE ""
    #NO.FUN-750085 ---Begin
    IF g_zz05 = 'Y' THEN                                                         
       CALL cl_wcchp(g_wc,'aaa01,aaa02,aaa03,aaa04,aaa05,aaa06,aaa07')           
            RETURNING g_wc                                                       
       LET g_str = g_wc                                                          
    END IF                                                                       
    LET g_str = g_wc                                          
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                    
    CALL cl_prt_cs3('agli101','agli101',l_sql,g_str)   
   #No.FUN-760085---End
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i101_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680098 VARCHAR(1)
    l_sw            LIKE type_file.chr1,    #No.FUN-680098CHAR(1)
    l_i             LIKE type_file.num5,    #No.FUN-680098 SMALLINT
    l_desc1,l_desc2 LIKE ze_file.ze03,      #No.TQC-6A0083 
    sr              RECORD
        aaa01       LIKE aaa_file.aaa01,   #帳別
        aaa02       LIKE aaa_file.aaa02,   #說明
        aaa03       LIKE aaa_file.aaa03,   #
        aaa04       LIKE aaa_file.aaa04,   #
        aaa05       LIKE aaa_file.aaa05,   #
        aaa06       LIKE aaa_file.aaa06,   #
        aaa07       LIKE aaa_file.aaa07,   #
        aaf02       LIKE aaf_file.aaf02,   #簽核順序
        aaf03       LIKE aaf_file.aaf03,   #人員代號
        aaa09       LIKE aaa_file.aaa09,   #月結  #No.TQC-6A0083                                                                    
        aaa10       LIKE aaa_file.aaa10,   #年結  #No.TQC-6A0083
        aaaacti     LIKE aaa_file.aaaacti
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.aaa01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            #PRINT g_x[2] CLIPPED,g_today USING 'yy/mm/dd',' ',TIME,#FUN-570250 mark
            PRINT g_x[2] CLIPPED,g_today,' ',TIME, #FUN-570250 add
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.aaa01
			NEED 9 LINES
            PRINT g_dash[1,g_len]
            PRINT g_x[11] CLIPPED,sr.aaa01,COLUMN 23,g_x[12] CLIPPED,sr.aaa02 CLIPPED, #TQC-6A0083 
		  COLUMN 62,g_x[13] CLIPPED,sr.aaa03 CLIPPED     #TQC-6A0083
            PRINT g_x[14] CLIPPED,sr.aaa04 USING '###&',
		  COLUMN 23,g_x[15] CLIPPED,sr.aaa05 USING '###&',
		  COLUMN 58,g_x[16] CLIPPED,sr.aaa06 CLIPPED   #TQC-6A0083
            #No.TQC-6A0083 --Begin                                                                                                  
            LET l_desc1=NULL LET l_desc2=NULL                                                                                       
            CASE sr.aaa09                                                                                                           
                 #WHEN '1' CALL cl_getmsg('agl-943',g_lang) RETURNING l_desc1      #No.TQC-B60377                                                  
                 WHEN '1' CALL cl_getmsg('agl-994',g_lang) RETURNING l_desc1       #No.TQC-B60377                                                 
                 WHEN '2' CALL cl_getmsg('agl-944',g_lang) RETURNING l_desc1                                                        
            END CASE                                                                                                                
            CASE sr.aaa10                                                                                                           
                 #WHEN '1' CALL cl_getmsg('agl-943',g_lang) RETURNING l_desc2      #No.TQC-B60377                                                       
                 WHEN '1' CALL cl_getmsg('agl-994',g_lang) RETURNING l_desc2       #No.TQC-B60377                                                 
                 WHEN '2' CALL cl_getmsg('agl-944',g_lang) RETURNING l_desc2                                                        
            END CASE                                                                                                                
            PRINT g_x[17] CLIPPED,sr.aaa07,                                                                                         
                  COLUMN 23,g_x[20] CLIPPED,sr.aaa09 CLIPPED,' ',l_desc1 CLIPPED,                                                    
                  COLUMN 62,g_x[21] CLIPPED,sr.aaa10 CLIPPED,' ',l_desc2 CLIPPED                                                    
            #No.TQC-6A0083 --End 
#	    PRINT g_x[17] CLIPPED,sr.aaa07 CLIPPED   #TQC-6A0083
                  SKIP 1 LINE
                  PRINT g_x[19] CLIPPED
            PRINT '    -----      -----------------------------'
 
        ON EVERY ROW
           PRINT COLUMN 06,sr.aaf02, COLUMN 16,sr.aaf03
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc,'aaa01,aaa02,aaa03,aaa04,aaa05,aaa06,aaa07')
                    RETURNING g_sql
 
            #TQC-630166
            #  IF g_sql[001,080] > ' ' THEN
	    #	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
            #  IF g_sql[071,140] > ' ' THEN
	    #	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
            #  IF g_sql[141,210] > ' ' THEN
            #          PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
               CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166
               PRINT g_dash[1,g_len]
            END IF
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-760085---End
#---FUN-A30112 start--
FUNCTION i101_aag(p_code,p_bookno)                    
   DEFINE p_code     LIKE aag_file.aag01  
   DEFINE p_bookno   LIKE aag_file.aag00                
   DEFINE l_aagacti  LIKE aag_file.aagacti
   DEFINE l_aag07    LIKE aag_file.aag07  
   DEFINE l_aag03    LIKE aag_file.aag03  
   DEFINE l_aag02    LIKE aag_file.aag02

   SELECT aag02,aag03,aag07,aagacti INTO l_aag02,l_aag03,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01=p_code      
      AND aag00=p_bookno  

    CASE WHEN STATUS=100         LET g_errno='agl-001'   
         WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'     LET g_errno = 'agl-015' 
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   RETURN l_aag02
END FUNCTION
#--FUN-A30112 end-----

#FUN-BB0123--Begin--
FUNCTION i101_aaa13()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_aaa.aaa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01=g_aaa.aaa01

   BEGIN WORK
   OPEN i101_cl USING g_aaa.aaa01
   IF STATUS THEN
      CALL cl_err("OPEN i101_cl:", STATUS, 1)
      CLOSE i101_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i101_cl INTO g_aaa.*
   IF STATUS THEN
      CALL cl_err('Lock aaa:',STATUS,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_aaa_t.*=g_aaa.*
   LET g_aaa_o.*=g_aaa.*

   WHILE TRUE
   INPUT BY NAME g_aaa.aaa13
         WITHOUT DEFAULTS

      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aaa.*=g_aaa_t.*
            DISPLAY BY NAME g_aaa.aaa13
            CALL cl_err('',9001,0)
            EXIT WHILE
         END IF
         UPDATE aaa_file SET aaa13=g_aaa.aaa13
          WHERE aaa01=g_aaa.aaa01
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","aaa_file",g_aaa.aaa01,"",STATUS,"","upd aaa01",1)
            LET g_aaa.*=g_aaa_t.*
            DISPLAY BY NAME g_aaa.aaa13
            ROLLBACK WORK
            RETURN
         ELSE
            LET g_aaa_o.*=g_aaa.*
            LET g_aaa_t.*=g_aaa.*
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
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
#FUN-BB0123---End---

#FUN-D20046 add begin---
FUNCTION i101_cons_plant()
   DEFINE p_row,p_col   LIKE type_file.num5
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_aaa17_desc  LIKE azp_file.azp02

   IF g_aaa.aaa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET p_row = 1 LET p_col = 1

   OPEN WINDOW i101_1_w AT p_row,p_col WITH FORM "agl/42f/agli101_1"
    ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_locale("agli101_1")

   IF NOT cl_null(g_aaa.aaa17) THEN
      SELECT azp02 INTO l_aaa17_desc FROM azp_file WHERE azp01 = g_aaa.aaa17
      DISPLAY l_aaa17_desc TO aaa17_desc
   END IF

   BEGIN WORK

   CALL cl_set_comp_required("aaa17",FALSE)

   INPUT BY NAME g_aaa.aaa17
         WITHOUT DEFAULTS
      AFTER FIELD aaa17
         IF NOT cl_null(g_aaa.aaa17) OR g_aaa.aaa17 = ' ' THEN
            SELECT COUNT(*) INTO l_n FROM azp_file
             WHERE azp01 = g_aaa.aaa17
               AND azp053 = 'Y'

            IF l_n = 0 THEN
               CALL cl_err('','axr-421',1)
               NEXT FIELD aaa17
            END IF
         END IF
      AFTER INPUT
         IF INT_FLAG THEN
            LET g_aaa.*=g_aaa_t.*
            DISPLAY BY NAME g_aaa.aaa17
            CALL cl_err('',9001,0)
            EXIT INPUT
         END IF

         IF cl_null(g_aaa.aaa17) THEN
            LET g_aaa.aaa17 = ' '
         END IF

         UPDATE aaa_file SET aaa17=g_aaa.aaa17
          WHERE aaa01=g_aaa.aaa01
         IF STATUS THEN
            CALL cl_err3("upd","aaa_file",g_aaa.aaa01,"",STATUS,"","upd aaa01",1)
            LET g_aaa.*=g_aaa_t.*
            DISPLAY BY NAME g_aaa.aaa17
            ROLLBACK WORK
            RETURN
         ELSE
            LET g_aaa_o.*=g_aaa.*
            LET g_aaa_t.*=g_aaa.*
         END IF

      ON ACTION controlp
        CASE
           WHEN INFIELD(aaa17)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_azp21"
              LET g_qryparam.default1 = g_aaa.aaa17
              CALL cl_create_qry() RETURNING g_aaa.aaa17
              DISPLAY BY NAME g_aaa.aaa17

              SELECT azp02 INTO l_aaa17_desc FROM azp_file WHERE azp01 = g_aaa.aaa17
              DISPLAY l_aaa17_desc TO aaa17_desc
              NEXT FIELD aaa17
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
      LET g_aaa.*=g_aaa_t.*
      DISPLAY BY NAME g_aaa.aaa17
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   CLOSE WINDOW i101_1_w
END FUNCTION

FUNCTION i101_get_period()
   DEFINE l_axa  RECORD
             axa10  LIKE axa_file.axa10,
             axa11  LIKE axa_file.axa11
             END RECORD,
          l_year   LIKE axa_file.axa10,
          l_period LIKE axa_file.axa11,
          l_sql    STRING

   LET l_year   = NULL
   LET l_period = NULL

   IF NOT cl_null(g_aaa.aaa17) THEN
      LET l_sql = " SELECT UNIQUE axa10, axa11",
                  "   FROM axa_file, axz_file",
                  "  WHERE axa02 = axz01",
                  "    AND axz03 = '",g_aaa.aaa17,"' ",
                  "    AND axz05 = '",g_aaa.aaa01,"' ",
                  "    AND axz04 = 'Y'",
                  "  UNION",
                  " SELECT UNIQUE axb14, axb15",
                  "   FROM axb_file, axa_file, axz_file",
                  "  WHERE axb04 = axz01",
                  "    AND axz03 = '",g_aaa.aaa17,"' ",
                  "    AND axz05 = '",g_aaa.aaa01,"' ",
                  "    AND axz04 = 'Y'",
                  "  ORDER BY 1, 2"
      PREPARE i101_axa_p FROM l_sql
      DECLARE i101_axa_c CURSOR FOR i101_axa_p
      OPEN i101_axa_c
      FETCH FIRST i101_axa_c INTO l_axa.*
         LET l_year   = l_axa.axa10
         LET l_period = l_axa.axa11
      CLOSE i101_axa_c
   END IF
   RETURN l_year,l_period
END FUNCTION
#FUN-D20046 add end-----
#Patch....NO:TQC-610035 <001> #
#Patch....NO.TQC-610035 <001> #
