# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapi702.4gl
# Descriptions...: 應付帳款系統-部門預設科目維護作業(L/C類)
# Date & Author..: 92/12/22 By Yen
# Modify.........: 04/07/30 BY Wiky MOD-470597 修改u會hold住
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-580028 05/08/22 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680029 06/08/21 By Xufeng 兩帳套修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0016 06/11/11 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/03/28 By mike 會計科目加帳套
# Modify.........: No.TQC-740144 07/04/24 By dxfwo 修改aaps100中參數“依部門區分缺省會計科目”若未勾選，點錄入時報錯信息有誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770012 07/08/02 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.TQC-790097 07/09/14 By lumxa 報表FROM:xxx，頁次格式有誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-B20059 11/02/24 By wujie  科目自动开窗hard code修改
# Modify.........: No:FUN-B30211 11/03/30 By yangtingitng 未加離開前的 cl_used(2)
# Modify.........: No:FUN-B40004 11/04/06 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0047 11/12/31 By fengrui 調整時間函數問題
# Modify.........: No.TQC-BB0139 11/11/16 By yinhy 查詢時，資料建立者，資料建立部門無法下查詢條件
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30486 12/03/12 by lujh aps231/aps236 移至aapi702中.增加顯示科目名稱
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_aps   RECORD LIKE aps_file.*,
    g_aps_t RECORD LIKE aps_file.*,
    g_aps_o RECORD LIKE aps_file.*,
    g_aps01_t LIKE aps_file.aps01,
    g_before_input_done LIKE type_file.num5,    #No.FUN-690028 SMALLINT
   #g_wc,g_sql          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(300)
    g_wc,g_sql          STRING         #TQC-630166
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
#No.FUN-770012 -- begin --
DEFINE g_sql1     STRING
DEFINE l_table    STRING   #MOD-9A0192 mod chr20->STRING
DEFINE g_str      STRING
#No.FUN-770012 -- end --
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0055
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
     # CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055#FUN-BB0047  mark
    INITIALIZE g_aps.* TO NULL
    INITIALIZE g_aps_t.* TO NULL
    INITIALIZE g_aps_o.* TO NULL
    LET g_sql1 = "aps01.aps_file.aps01,apsacti.aps_file.apsacti,",
                 "gem02.gem_file.gem02,",
                 "aps14.aps_file.aps14,aps22.aps_file.aps22,",
                 "aps233.aps_file.aps233,aps234.aps_file.aps234,",
                 "aps25.aps_file.aps25,aps42.aps_file.aps42,",
                 "aps43.aps_file.aps43,aps45.aps_file.aps45,",
                 "aps51.aps_file.aps51,aps52.aps_file.aps52,",
                 "aps53.aps_file.aps53,aps54.aps_file.aps54,",
                 "aps55.aps_file.aps55,aps231.aps_file.aps231,",      #MOD-C30486  add aps231.aps_file.aps231,
                 "aps141.aps_file.aps141,aps221.aps_file.aps221,",
                 "aps238.aps_file.aps238,aps239.aps_file.aps239,",
                 "aps251.aps_file.aps251,aps421.aps_file.aps421,",
                 "aps431.aps_file.aps431,aps451.aps_file.aps451,",
                 "aps511.aps_file.aps511,aps521.aps_file.aps521,",
                 "aps531.aps_file.aps531,aps541.aps_file.aps541,",
                 "aps551.aps_file.aps551,aps236.aps_file.aps236,",    #MOD-C30486  aps236.aps_file.aps236,
                 "aag02_14.aag_file.aag02,aag02_22.aag_file.aag02,",
                 "aag02_233.aag_file.aag02,aag02_234.aag_file.aag02,",
                 "aag02_25.aag_file.aag02,aag02_42.aag_file.aag02,",
                 "aag02_43.aag_file.aag02,aag02_45.aag_file.aag02,",
                 "aag02_51.aag_file.aag02,aag02_52.aag_file.aag02,",
                 "aag02_53.aag_file.aag02,aag02_54.aag_file.aag02,",
                 "aag02_55.aag_file.aag02,",
                 "aag02_141.aag_file.aag02,aag02_221.aag_file.aag02,",                                                                
                 "aag02_238.aag_file.aag02,aag02_239.aag_file.aag02,",                                                              
                 "aag02_251.aag_file.aag02,aag02_421.aag_file.aag02,",                                                                
                 "aag02_431.aag_file.aag02,aag02_451.aag_file.aag02,",                                                                
                 "aag02_511.aag_file.aag02,aag02_521.aag_file.aag02,",                                                                
                 "aag02_531.aag_file.aag02,aag02_541.aag_file.aag02,",                                                                
                 "aag02_551.aag_file.aag02"
    LET l_table = cl_prt_temptable('aapi702',g_sql1) CLIPPED
    IF l_table = -1 THEN 
       EXIT PROGRAM 
   END IF
#No.FUN-770012 -- end --
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 ADD  
    LET g_forupd_sql = " SELECT * FROM aps_file WHERE aps01 = ?  FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i702_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 20
    OPEN WINDOW i702_w AT p_row,p_col WITH FORM "aap/42f/aapi702"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #FUN-680029  --Begin--
    IF g_aza.aza63= 'N' THEN
       CALL cl_set_comp_visible("page02",FALSE)
    END IF
    #FUN-680029  --End--
 
    IF g_apz.apz13 = 'N' THEN
       CALL cl_err('','aap-135',0)
    END IF
 
#   WHILE TRUE
      LET g_action_choice=""
      CALL i702_menu()
#     IF g_action_choice="exit" THEN EXIT WHILE END IF
#   END WHILE
 
    CLOSE WINDOW i702_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION i702_cs()
    CLEAR FORM
   INITIALIZE g_aps.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        aps01,
        aps14, aps22, aps233, aps234, aps25,
        aps42, aps43, aps45, aps51,
        aps52, aps53, aps54, aps55,aps231,    #MOD-C30486 add aps231,
 
        #FUN-680029   --Begin--
        aps141,aps221,aps238,aps239,aps251,
        aps421,aps431,aps451,aps511,aps521,aps531,aps541,aps551,aps236,   #MOD-C30486 add #MOD-C30486 add aps231,
        #FUN-680029   --End--
 
        apsuser,apsgrup,apsmodu,apsdate,apsacti,
        apsoriu,apsorig                                  #TQC-BB0139
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
 
    ON ACTION controlp
       CASE
          WHEN INFIELD(aps01) #部門編號
#            CALL q_gem(10,3,g_aps.aps01) RETURNING g_aps.aps01
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gem"
             LET g_qryparam.default1 = g_aps.aps01
             #CALL cl_create_qry() RETURNING g_aps.aps01
             #DISPLAY BY NAME g_aps.aps01
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps01
             NEXT FIELD aps01
          WHEN INFIELD(aps14)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps14,g_aza.aza81)   #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps14
          WHEN INFIELD(aps22)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps22,g_aza.aza81)   #No:8727  #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps22
          WHEN INFIELD(aps233)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps233,g_aza.aza81)   #No:8727  #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps233
          WHEN INFIELD(aps234)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps234,g_aza.aza81)  #No:8727  #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps234
          WHEN INFIELD(aps25)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps25,g_aza.aza81)  #No:8727  #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps25
          WHEN INFIELD(aps42)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps42,g_aza.aza81)  #No:8727  #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps42
          WHEN INFIELD(aps43)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps43,g_aza.aza81)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps43
          WHEN INFIELD(aps45)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps45,g_aza.aza81)  #No:8727  #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps45
          WHEN INFIELD(aps51)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps51,g_aza.aza81)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps51
          WHEN INFIELD(aps52)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps52,g_aza.aza81)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps52
          WHEN INFIELD(aps53)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps53,g_aza.aza81)  #No:8727  #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps53
          WHEN INFIELD(aps54)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps54,g_aza.aza81)  #No:8727  #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps54
          WHEN INFIELD(aps55)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps55,g_aza.aza81)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps55
             
          #--MOD-C30486--add--str--
          WHEN INFIELD(aps231) #應付保險費
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps231,g_aza.aza81)   
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps231
             NEXT FIELD aps231
          #--MOD-C30486--add--end--
          
          #FUN-680029  --Begin--
          WHEN INFIELD(aps141)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps141,g_aza.aza82)   #No:8727        #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps141
          WHEN INFIELD(aps221)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps221,g_aza.aza82)   #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps221
          WHEN INFIELD(aps238)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps238,g_aza.aza82)   #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps238
          WHEN INFIELD(aps239)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps239,g_aza.aza82)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps239
          WHEN INFIELD(aps251)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps251,g_aza.aza82)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps251
          WHEN INFIELD(aps421)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps421,g_aza.aza82)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps421
          WHEN INFIELD(aps431)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps431,g_aza.aza82)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps431
          WHEN INFIELD(aps451)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps451,g_aza.aza82)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps451
          WHEN INFIELD(aps511)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps511,g_aza.aza82)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps511
          WHEN INFIELD(aps521)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps521,g_aza.aza82)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps521
          WHEN INFIELD(aps531)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps531,g_aza.aza82)  #No:8727    #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps531
          WHEN INFIELD(aps541)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps541,g_aza.aza82)  #No:8727   #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps541
          WHEN INFIELD(aps551)
                   CALL q_aapact(TRUE,TRUE,'2',g_aps.aps55,g_aza.aza82)  #No:8727    #No.FUN-730064
                        RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps551
          #--MOD-C30486--add--str--
          WHEN INFIELD(aps236) #應付保險費二
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps236,g_aza.aza82)    
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps236
             NEXT FIELD aps236
          #--MOD-C30486--add--str--
          #FUN-680029  --Begin--
 
          OTHERWISE EXIT CASE
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND apsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND apsgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND apsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apsuser', 'apsgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT aps01 FROM aps_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED
         IF g_apz.apz13 = 'N'
            THEN LET g_sql= g_sql CLIPPED," AND aps01 = ' '"
            ELSE LET g_sql= g_sql CLIPPED," AND aps01 != ' '"
         END IF
        LET g_sql= g_sql CLIPPED," ORDER BY aps01"
    PREPARE i702_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i702_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i702_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM aps_file WHERE ",g_wc CLIPPED
         IF g_apz.apz13 = 'N'
            THEN LET g_sql= g_sql CLIPPED," AND aps01 = ' '"
            ELSE LET g_sql= g_sql CLIPPED," AND aps01 != ' '"
         END IF
    PREPARE i702_precount FROM g_sql
    DECLARE i702_count CURSOR FOR i702_precount
END FUNCTION
 
FUNCTION i702_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i702_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i702_q()
            END IF
        ON ACTION next
            CALL i702_fetch('N')
        ON ACTION previous
            CALL i702_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i702_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i702_x()
               CALL cl_set_field_pic("","","","","",g_aps.apsacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i702_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i702_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i702_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_aps.apsacti)
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i702_fetch('/')
        ON ACTION first
            CALL i702_fetch('F')
        ON ACTION last
            CALL i702_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0016--------add----------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_aps.aps01 IS NOT NULL THEN
                  LET g_doc.column1 = "aps01"
                  LET g_doc.value1 = g_aps.aps01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0016--------add----------end----
 
            LET g_action_choice = "exit"
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i702_cs
END FUNCTION
 
 
FUNCTION i702_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    # 是否依部門區分預設會計科目" 設為 'N'
    IF g_apz.apz13 = 'N' THEN
         SELECT count(*) INTO g_cnt FROM aps_file
             WHERE (aps01 = ' ' OR aps01 IS NULL)
         IF g_cnt > 0 THEN                  # Duplicated
          #  CALL cl_err(g_aps.aps01,-239,0)
             CALL cl_err(g_aps.aps01,'aap-248',1)   #No.TQC-740144
             LET g_aps.aps01 = g_aps01_t
             DISPLAY BY NAME g_aps.aps01
             RETURN
         END IF
    END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_aps.* LIKE aps_file.*
    LET g_aps_t.* = g_aps.*
    LET g_aps01_t = NULL
#%  LET g_aps.xxxx = 0				# DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_aps.apsacti ='Y'                   #有效的資料
        LET g_aps.apsuser = g_user
        LET g_aps.apsoriu = g_user #FUN-980030
        LET g_aps.apsorig = g_grup #FUN-980030
        LET g_aps.apsgrup = g_grup               #使用者所屬群
        LET g_aps.apsdate = g_today
        CALL i702_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_aps.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_apz.apz13 = 'N' THEN
           LET g_aps.aps01 = ' '
        ELSE
           IF cl_null(g_aps.aps01) THEN             # KEY 不可空白
               CONTINUE WHILE
           END IF
        END IF
        INSERT INTO aps_file VALUES(g_aps.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("ins","aps_file",g_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        ELSE
            LET g_aps_t.* = g_aps.*                # 保存上筆資料
            SELECT aps01 INTO g_aps.aps01 FROM aps_file
                WHERE aps01 = g_aps.aps01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i702_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
        l_dir           LIKE type_file.chr1,    # No.FUN-690028 VARCHAR(1),               #判斷是否
        l_aag02         LIKE aag_file.aag02,
        l_n             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_aag05         LIKE aag_file.aag05     #No.FUN-B40004 
    INPUT BY NAME g_aps.apsoriu,g_aps.apsorig,
        g_aps.aps01,
        g_aps.aps14, g_aps.aps22, g_aps.aps233, g_aps.aps234,g_aps.aps25,
        g_aps.aps42, g_aps.aps43, g_aps.aps45, g_aps.aps51,
        g_aps.aps52, g_aps.aps53, g_aps.aps54, g_aps.aps55,g_aps.aps231,      #MOD-C30486  add g_aps.aps231,
 
        #FUN-680029  --Begin--
        g_aps.aps141, g_aps.aps221, g_aps.aps238, g_aps.aps239,g_aps.aps251,
        g_aps.aps421, g_aps.aps431, g_aps.aps451, g_aps.aps511,
        g_aps.aps521, g_aps.aps531, g_aps.aps541, g_aps.aps551,g_aps.aps236,   #MOD-C30486  add g_aps.aps236,
        #FUN-680029  --End--
 
        g_aps.apsuser,g_aps.apsgrup,g_aps.apsmodu,g_aps.apsdate,g_aps.apsacti
        WITHOUT DEFAULTS
 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
{
        BEFORE FIELD aps01
            IF p_cmd='u' AND g_chkey = 'N' THEN NEXT FIELD aps14 END IF
            IF g_apz.apz13 = 'N' THEN
                    LET g_aps.aps01 = ' '
                    NEXT FIELD aps14
            END IF
}
 
        AFTER FIELD aps01            #部門編號
             IF NOT cl_null(g_aps.aps01) THEN        #No.MOD-470597
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_aps.aps01 != g_aps01_t) THEN
                   SELECT count(*) INTO l_n FROM aps_file
                       WHERE aps01 = g_aps.aps01
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_aps.aps01,-239,0)
                       LET g_aps.aps01 = g_aps01_t
                       DISPLAY BY NAME g_aps.aps01
                       NEXT FIELD aps01
                   END IF
               END IF
               CALL i702_aps01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps01,g_errno,0)
                  LET g_aps.aps01 = g_aps_o.aps01
                  DISPLAY BY NAME g_aps.aps01
                  NEXT FIELD aps01
               END IF
               LET g_aps_o.aps01 = g_aps.aps01
            END IF
 
        AFTER FIELD aps14
            IF NOT cl_null(g_aps.aps14) THEN
              # SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps14 #No.FUN-B40004
               SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file             #No.FUN-B40004
                                                     WHERE aag01  =g_aps.aps14
                                                       AND aag00  =g_aza.aza81     #No.FUN-730064
                                                       AND aag03  ='2'
                                                       AND aagacti='Y'
                                                       AND aag07 !='1'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('sel aag',STATUS,1)    #No.FUN-660122
#No.FUN-B20059 --begin
                  CALL cl_err3("sel","aag_file",g_aps.aps14,"",STATUS,"","sel aag",0)  #No.FUN-660122
                  CALL q_aapact(FALSE,FALSE,'2',g_aps.aps14,g_aza.aza81)  #No:8727 #No.FUN-730064
                       RETURNING g_aps.aps14
#No.FUN-B20059 --end                  
                  NEXT FIELD aps14
                  LET g_msg = ' '
                  DISPLAY g_msg TO aps14_d
               END IF
               #No.TQC-B40001  --Begin
               IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps14,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps14,g_errno,0)
                  DISPLAY BY NAME g_aps.aps14  
                  LET g_errno = ' '
                  NEXT FIELD aps14                   
               END IF
               #No.TQC-B40001  --End
               DISPLAY g_msg TO aps14_d
            END IF
        AFTER FIELD aps22
           IF NOT cl_null(g_aps.aps22) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps22 #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file             #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps22
                                                      AND aag00  =g_aza.aza81       #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,1)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps22,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps22,g_aza.aza81)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps22
#No.FUN-B20059 --end
                 NEXT FIELD aps22
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps22_d
              END IF
              #No.TQC-B40001  --Begin
               IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps22,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps22,g_errno,0)
                  DISPLAY BY NAME g_aps.aps22  
                  LET g_errno = ' '
                  NEXT FIELD aps22                   
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps22_d
           END IF
        AFTER FIELD aps233
           IF NOT cl_null(g_aps.aps233) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps233  #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file               #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps233
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,1)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps233,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps233,g_aza.aza81)  #No:8727  #No.FUN-730064
                      RETURNING g_aps.aps233
#No.FUN-B20059 --end
                 NEXT FIELD aps233
                 LET g_msg = ' '
                 DISPLAY g_msg TO FORMONLY.aps233d
              END IF
              #No.TQC-B40001  --Begin
               IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps233,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps233,g_errno,0)
                  DISPLAY BY NAME g_aps.aps233  
                  LET g_errno = ' '
                  NEXT FIELD aps233                   
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO FORMONLY.aps233d
           END IF
        AFTER FIELD aps234
           IF NOT cl_null(g_aps.aps234) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps234      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps234
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps234,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps234,g_aza.aza81)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps234
#No.FUN-B20059 --end
                 NEXT FIELD aps234
                 LET g_msg = ' '
                 DISPLAY g_msg TO FORMONLY.aps234d
              END IF
              #No.TQC-B40001  --Begin
               IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps234,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps234,g_errno,0)
                  DISPLAY BY NAME g_aps.aps234  
                  LET g_errno = ' '
                  NEXT FIELD aps234                   
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO FORMONLY.aps234d
           END IF
        AFTER FIELD aps25
           IF NOT cl_null(g_aps.aps25) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps25       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps25
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps25,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps25,g_aza.aza81)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps25
#No.FUN-B20059 --end
                 NEXT FIELD aps25
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps25_d
              END IF
              #No.TQC-B40001  --Begin
               IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps25,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps25,g_errno,0)
                  DISPLAY BY NAME g_aps.aps25  
                  LET g_errno = ' '
                  NEXT FIELD aps25                  
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps25_d
           END IF
        AFTER FIELD aps42
           IF NOT cl_null(g_aps.aps42) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps42       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps42
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps42,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps42,g_aza.aza81)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps42
#No.FUN-B20059 --end
                 NEXT FIELD aps42
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps42_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps42,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps42,g_errno,0)
                  DISPLAY BY NAME g_aps.aps42 
                  LET g_errno = ' '
                  NEXT FIELD aps42                 
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps42_d
           END IF
        AFTER FIELD aps43
           IF NOT cl_null(g_aps.aps43) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps43       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps43
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps43,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps43,g_aza.aza81)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps43
#No.FUN-B20059 --end
                 NEXT FIELD aps43
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps43_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps43,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps43,g_errno,0)
                  DISPLAY BY NAME g_aps.aps43
                  LET g_errno = ' '
                  NEXT FIELD aps43                 
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps43_d
           END IF
        AFTER FIELD aps45
           IF NOT cl_null(g_aps.aps45) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps45       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps45
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)   #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps45,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps45,g_aza.aza81)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps45
#No.FUN-B20059 --end
                 NEXT FIELD aps45
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps45_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps45,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps45,g_errno,0)
                  DISPLAY BY NAME g_aps.aps45
                  LET g_errno = ' '
                  NEXT FIELD aps45                 
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps45_d
           END IF
        AFTER FIELD aps51
           IF NOT cl_null(g_aps.aps51) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps51       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps51
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps51,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps51,g_aza.aza81)  #No:8727     #No.FUN-730064
                      RETURNING g_aps.aps51
#No.FUN-B20059 --end
                 NEXT FIELD aps51
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps51_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps51,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps51,g_errno,0)
                  DISPLAY BY NAME g_aps.aps51
                  LET g_errno = ' '
                  NEXT FIELD aps51                 
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps51_d
           END IF
        AFTER FIELD aps52
           IF NOT cl_null(g_aps.aps52) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps52       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps52
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps52,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps52,g_aza.aza81)  #No:8727    #No.FUN-730064
                      RETURNING g_aps.aps52
#No.FUN-B20059 --end
                 NEXT FIELD aps52
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps52_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps52,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps52,g_errno,0)
                  DISPLAY BY NAME g_aps.aps52
                  LET g_errno = ' '
                  NEXT FIELD aps52                 
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps52_d
           END IF
        AFTER FIELD aps53
           IF NOT cl_null(g_aps.aps53) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps53       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps53
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps53,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps53,g_aza.aza81)   #No:8727  #No.FUN-730064
                      RETURNING g_aps.aps53
#No.FUN-B20059 --end
                 NEXT FIELD aps53
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps53_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps53,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps53,g_errno,0)
                  DISPLAY BY NAME g_aps.aps53
                  LET g_errno = ' '
                  NEXT FIELD aps53                 
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps53_d
           END IF
        AFTER FIELD aps54
           IF NOT cl_null(g_aps.aps54) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps54       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps54
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)   #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps54,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps54,g_aza.aza81)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps54
#No.FUN-B20059 --end
                 NEXT FIELD aps54
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps54_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps54,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps54,g_errno,0)
                  DISPLAY BY NAME g_aps.aps54
                  LET g_errno = ' '
                  NEXT FIELD aps54                 
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps54_d
           END IF
        AFTER FIELD aps55
           IF NOT cl_null(g_aps.aps55) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps55       #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps55
                                                      AND aag00  =g_aza.aza81        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps55,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps55,g_aza.aza81)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps55
#No.FUN-B20059 --end
                 NEXT FIELD aps55
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps55_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps55,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps55,g_errno,0)
                  DISPLAY BY NAME g_aps.aps55
                  LET g_errno = ' '
                  NEXT FIELD aps55                 
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps55_d
           END IF

        #--MOD-C30486--add--str--
        AFTER FIELD aps231
           IF NOT cl_null(g_aps.aps231) THEN  
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   
                                                    WHERE aag01  =g_aps.aps231
                                                      AND aag00  =g_aza.aza81        
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aag_file",g_aps.aps231,"",STATUS,"","sel aag",0)   
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps231,g_aza.aza81)  
                      RETURNING g_aps.aps231
                 NEXT FIELD aps231
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps231_d
              END IF
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps231,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps231,g_errno,0)
                  DISPLAY BY NAME g_aps.aps231
                  LET g_errno = ' '
                  NEXT FIELD aps231                 
               END IF
              DISPLAY g_msg TO aps231_d
           END IF

        #--MOD-C30486--add--str--  
 
        #FUN-680029  --Begin--
        AFTER FIELD aps141
            IF NOT cl_null(g_aps.aps141) THEN
               #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps141      #No.FUN-B40004
               SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps141
                                                       AND aag00  =g_aza.aza82        #No.FUN-730064
                                                       AND aag03  ='2'
                                                       AND aagacti='Y'
                                                       AND aag07 !='1'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122

#No.FUN-B20059 --begin
                  CALL cl_err3("sel","aag_file",g_aps.aps141,"",STATUS,"","sel aag",0)  #No.FUN-660122
                  CALL q_aapact(FALSE,FALSE,'2',g_aps.aps141,g_aza.aza82)  #No:8727    #No.FUN-730064
                       RETURNING g_aps.aps141
#No.FUN-B20059 --end
                  NEXT FIELD aps141
                  LET g_msg = ' '
                  DISPLAY g_msg TO aps141_d
               END IF
               #No.TQC-B40001  --Begin
               IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps141,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps141,g_errno,0)
                  DISPLAY BY NAME g_aps.aps141
                  LET g_errno = ' '
                  NEXT FIELD aps141                
               END IF
               #No.TQC-B40001  --End
               DISPLAY g_msg TO aps141_d
            END IF
        AFTER FIELD aps221
           IF NOT cl_null(g_aps.aps221) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps221      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps221   
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps221,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps221,g_aza.aza82)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps221
#No.FUN-B20059 --end
                 NEXT FIELD aps221
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps221_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps221,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps221,g_errno,0)
                  DISPLAY BY NAME g_aps.aps221
                  LET g_errno = ' '
                  NEXT FIELD aps221                
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps221_d
           END IF
        AFTER FIELD aps238
           IF NOT cl_null(g_aps.aps238) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps238      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps238   
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps238,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps238,g_aza.aza82)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps238
#No.FUN-B20059 --end
                 NEXT FIELD aps238
                 LET g_msg = ' '
                 DISPLAY g_msg TO FORMONLY.aps238d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps238,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps238,g_errno,0)
                  DISPLAY BY NAME g_aps.aps238
                  LET g_errno = ' '
                  NEXT FIELD aps238                
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO FORMONLY.aps238d
           END IF
        AFTER FIELD aps239
           IF NOT cl_null(g_aps.aps239) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps239      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps239   
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps239,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps239,g_aza.aza82)  #No:8727  #No.FUN-730064
                      RETURNING g_aps.aps239
#No.FUN-B20059 --end
                 NEXT FIELD aps239
                 LET g_msg = ' '
                 DISPLAY g_msg TO FORMONLY.aps239d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps239,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps239,g_errno,0)
                  DISPLAY BY NAME g_aps.aps239
                  LET g_errno = ' '
                  NEXT FIELD aps239                
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO FORMONLY.aps239d
           END IF
        AFTER FIELD aps251
           IF NOT cl_null(g_aps.aps251) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps251      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps251
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps251,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps251,g_aza.aza82)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps251
#No.FUN-B20059 --end
                 NEXT FIELD aps251
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps251_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps251,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps251,g_errno,0)
                  DISPLAY BY NAME g_aps.aps251
                  LET g_errno = ' '
                  NEXT FIELD aps251               
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps251_d
           END IF
        AFTER FIELD aps421
           IF NOT cl_null(g_aps.aps421) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps421      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps421
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122

#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps421,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps421,g_aza.aza82)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps421
#No.FUN-B20059 --end
                 NEXT FIELD aps421
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps421_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps421,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps421,g_errno,0)
                  DISPLAY BY NAME g_aps.aps421
                  LET g_errno = ' '
                  NEXT FIELD aps421              
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps421_d
           END IF
        AFTER FIELD aps431
           IF NOT cl_null(g_aps.aps431) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps431      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps431
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps431,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps431,g_aza.aza82)  #No:8727  #No.FUN-730064
                      RETURNING g_aps.aps431
#No.FUN-B20059 --end
                 NEXT FIELD aps431
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps431_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps431,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps431,g_errno,0)
                  DISPLAY BY NAME g_aps.aps431
                  LET g_errno = ' '
                  NEXT FIELD aps431              
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps431_d
           END IF
        AFTER FIELD aps451
           IF NOT cl_null(g_aps.aps451) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps451      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps451
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)   #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps451,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps451,g_aza.aza82)  #No:8727  #No.FUN-730064
                      RETURNING g_aps.aps451
#No.FUN-B20059 --end
                 NEXT FIELD aps451
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps451_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps451,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps451,g_errno,0)
                  DISPLAY BY NAME g_aps.aps451
                  LET g_errno = ' '
                  NEXT FIELD aps451              
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps451_d
           END IF
        AFTER FIELD aps511
           IF NOT cl_null(g_aps.aps511) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps511      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps511
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps511,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps511,g_aza.aza82)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps511
#No.FUN-B20059 --end
                 NEXT FIELD aps511
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps511_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps511,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps511,g_errno,0)
                  DISPLAY BY NAME g_aps.aps511
                  LET g_errno = ' '
                  NEXT FIELD aps511              
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps511_d
           END IF
           
        AFTER FIELD aps521
           IF NOT cl_null(g_aps.aps521) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps521      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps521
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps521,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps521,g_aza.aza82)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps521
#No.FUN-B20059 --end
                 NEXT FIELD aps521
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps521_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps521,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps521,g_errno,0)
                  DISPLAY BY NAME g_aps.aps521
                  LET g_errno = ' '
                  NEXT FIELD aps521              
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps521_d
           END IF
        AFTER FIELD aps531
           IF NOT cl_null(g_aps.aps531) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps531      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps531
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps531,"",STATUS,"","sel aag",0)  #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps531,g_aza.aza82)  #No:8727   #No.FUN-730064
                      RETURNING g_aps.aps531
#No.FUN-B20059 --end
                 NEXT FIELD aps531
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps531_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps531,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps531,g_errno,0)
                  DISPLAY BY NAME g_aps.aps531
                  LET g_errno = ' '
                  NEXT FIELD aps531              
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps531_d
           END IF
        AFTER FIELD aps541
           IF NOT cl_null(g_aps.aps541) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps541      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps541
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)   #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps541,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps541,g_aza.aza82)  #No:8727    #No.FUN-730064
                      RETURNING g_aps.aps541
#No.FUN-B20059 --end
                 NEXT FIELD aps541
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps541_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps541,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps541,g_errno,0)
                  DISPLAY BY NAME g_aps.aps541
                  LET g_errno = ' '
                  NEXT FIELD aps541              
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps541_d
           END IF
        AFTER FIELD aps551
           IF NOT cl_null(g_aps.aps551) THEN
              #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01  =g_aps.aps551      #No.FUN-B40004
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   #No.FUN-B40004
                                                    WHERE aag01  =g_aps.aps551
                                                      AND aag00  =g_aza.aza82        #No.FUN-730064
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
#                CALL cl_err('sel aag',STATUS,0)    #No.FUN-660122
#No.FUN-B20059 --begin
                 CALL cl_err3("sel","aag_file",g_aps.aps551,"",STATUS,"","sel aag",0)   #No.FUN-660122
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps551,g_aza.aza82)  #No:8727     #No.FUN-730064
                      RETURNING g_aps.aps551
#No.FUN-B20059 --end
                 NEXT FIELD aps551
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps551_d
              END IF
              #No.TQC-B40001  --Begin
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps551,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps551,g_errno,0)
                  DISPLAY BY NAME g_aps.aps551
                  LET g_errno = ' '
                  NEXT FIELD aps551              
               END IF
               #No.TQC-B40001  --End
              DISPLAY g_msg TO aps551_d
           END IF
        #FUN-680029  --End--
        
        #--MOD-C30486--add--str--
        AFTER FIELD aps236
           IF NOT cl_null(g_aps.aps236) THEN
              SELECT aag02,aag05 INTO g_msg,l_aag05  FROM aag_file                   
                                                    WHERE aag01  =g_aps.aps236
                                                      AND aag00  =g_aza.aza82        
                                                      AND aag03  ='2'
                                                      AND aagacti='Y'
                                                      AND aag07 !='1'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aag_file",g_aps.aps236,"",STATUS,"","sel aag",0) 
                 CALL q_aapact(FALSE,FALSE,'2',g_aps.aps236,g_aza.aza82)  
                      RETURNING g_aps.aps236
                 NEXT FIELD aps236
                 LET g_msg = ' '
                 DISPLAY g_msg TO aps236_d
              END IF
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aps.aps236,g_aps.aps01,g_aza.aza81)
                         RETURNING g_errno
                 END IF
               END IF                  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps236,g_errno,0)
                  DISPLAY BY NAME g_aps.aps236
                  LET g_errno = ' '
                  NEXT FIELD aps236              
               END IF
              DISPLAY g_msg TO aps236_d
           END IF
        #--MOD-C30486--add--str--
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aps.apsuser = s_get_data_owner("aps_file") #FUN-C10039
           LET g_aps.apsgrup = s_get_data_group("aps_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_apz.apz13 = 'Y' THEN
               IF cl_null(g_aps.aps01) THEN
                   LET l_flag='Y'
                   DISPLAY BY NAME g_aps.aps01
               END IF
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD aps01
            END IF
 
        #-----FUN-630081---------
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(aps01) THEN
        #        LET g_aps.* = g_aps_t.*
        #        DISPLAY BY NAME g_aps.*
        #        NEXT FIELD aps01
        #    END IF
        #-----END FUN-630081-----
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aps01) #部門編號
#                CALL q_gem(10,3,g_aps.aps01) RETURNING g_aps.aps01
#                CALL FGL_DIALOG_SETBUFFER( g_aps.aps01 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_aps.aps01
                 CALL cl_create_qry() RETURNING g_aps.aps01
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps01 )
                 DISPLAY BY NAME g_aps.aps01
                 CALL i702_aps01('d')
                 NEXT FIELD aps01
              WHEN INFIELD(aps14)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps14,g_aza.aza81)  #No:8727 #No.FUN-730064
                            RETURNING g_aps.aps14
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps14 )
                 DISPLAY BY NAME g_aps.aps14 NEXT FIELD aps14
              WHEN INFIELD(aps22)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps22,g_aza.aza81)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps22
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps22 )
                 DISPLAY BY NAME g_aps.aps22 NEXT FIELD aps22
              WHEN INFIELD(aps233)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps233,g_aza.aza81)  #No:8727  #No.FUN-730064
                            RETURNING g_aps.aps233
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps233 )
                 DISPLAY BY NAME g_aps.aps233 NEXT FIELD aps233
              WHEN INFIELD(aps234)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps234,g_aza.aza81)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps234
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps234 )
                 DISPLAY BY NAME g_aps.aps234 NEXT FIELD aps234
              WHEN INFIELD(aps25)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps25,g_aza.aza81)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps25
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps25 )
                 DISPLAY BY NAME g_aps.aps25 NEXT FIELD aps25
              WHEN INFIELD(aps42)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps42,g_aza.aza81)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps42
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps42 )
                 DISPLAY BY NAME g_aps.aps42 NEXT FIELD aps42
              WHEN INFIELD(aps43)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps43,g_aza.aza81)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps43
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps43 )
                 DISPLAY BY NAME g_aps.aps43 NEXT FIELD aps43
              WHEN INFIELD(aps45)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps45,g_aza.aza81)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps45
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps45 )
                 DISPLAY BY NAME g_aps.aps45 NEXT FIELD aps45
              WHEN INFIELD(aps51)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps51,g_aza.aza81)  #No:8727     #No.FUN-730064
                            RETURNING g_aps.aps51
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps51 )
                 DISPLAY BY NAME g_aps.aps51 NEXT FIELD aps51
              WHEN INFIELD(aps52)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps52,g_aza.aza81)  #No:8727    #No.FUN-730064
                            RETURNING g_aps.aps52
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps52 )
                 DISPLAY BY NAME g_aps.aps52 NEXT FIELD aps52
              WHEN INFIELD(aps53)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps53,g_aza.aza81)   #No:8727  #No.FUN-730064
                            RETURNING g_aps.aps53
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps53 )
                 DISPLAY BY NAME g_aps.aps53 NEXT FIELD aps53
              WHEN INFIELD(aps54)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps54,g_aza.aza81)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps54
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps54 )
                 DISPLAY BY NAME g_aps.aps54 NEXT FIELD aps54
              WHEN INFIELD(aps55)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps55,g_aza.aza81)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps55
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps55 )
                 DISPLAY BY NAME g_aps.aps55 NEXT FIELD aps55
 
              #--MOD-C30486--add--str--
              WHEN INFIELD(aps231) #應付保險費
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps231,g_aza.aza81)   
                        RETURNING g_aps.aps231
                 DISPLAY BY NAME g_aps.aps231
                 NEXT FIELD aps231
              #--MOD-C30486--add--end--
        
              #FUN-680029   --Begin--
              WHEN INFIELD(aps141)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps141,g_aza.aza82)  #No:8727    #No.FUN-730064
                            RETURNING g_aps.aps141
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps141 )
                 DISPLAY BY NAME g_aps.aps141 NEXT FIELD aps141
              WHEN INFIELD(aps221)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps221,g_aza.aza82)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps221
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps221 )
                 DISPLAY BY NAME g_aps.aps221 NEXT FIELD aps221
              WHEN INFIELD(aps238)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps238,g_aza.aza82)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps238
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps238 )
                 DISPLAY BY NAME g_aps.aps238 NEXT FIELD aps238
              WHEN INFIELD(aps239)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps239,g_aza.aza82)  #No:8727  #No.FUN-730064
                            RETURNING g_aps.aps239
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps239 )
                 DISPLAY BY NAME g_aps.aps239 NEXT FIELD aps239
              WHEN INFIELD(aps251)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps251,g_aza.aza82)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps251
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps251 )
                 DISPLAY BY NAME g_aps.aps251 NEXT FIELD aps251
              WHEN INFIELD(aps421)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps421,g_aza.aza82)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps421
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps421 )
                 DISPLAY BY NAME g_aps.aps421 NEXT FIELD aps421
              WHEN INFIELD(aps431)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps431,g_aza.aza82)  #No:8727  #No.FUN-730064
                            RETURNING g_aps.aps431
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps431 )
                 DISPLAY BY NAME g_aps.aps431 NEXT FIELD aps431
              WHEN INFIELD(aps451)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps451,g_aza.aza82)  #No:8727  #No.FUN-730064
                            RETURNING g_aps.aps451
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps451 )
                 DISPLAY BY NAME g_aps.aps451 NEXT FIELD aps451
              WHEN INFIELD(aps511)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps511,g_aza.aza82)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps511
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps511 )
                 DISPLAY BY NAME g_aps.aps511 NEXT FIELD aps511
              WHEN INFIELD(aps521)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps521,g_aza.aza82)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps521
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps521 )
                 DISPLAY BY NAME g_aps.aps521 NEXT FIELD aps521
              WHEN INFIELD(aps531)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps531,g_aza.aza82)  #No:8727   #No.FUN-730064
                            RETURNING g_aps.aps531
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps531 )
                 DISPLAY BY NAME g_aps.aps531 NEXT FIELD aps531
              WHEN INFIELD(aps541)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps541,g_aza.aza82)  #No:8727    #No.FUN-730064
                            RETURNING g_aps.aps541
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps541 )
                 DISPLAY BY NAME g_aps.aps541 NEXT FIELD aps541
              WHEN INFIELD(aps551)
                       CALL q_aapact(FALSE,TRUE,'2',g_aps.aps551,g_aza.aza82)  #No:8727     #No.FUN-730064
                            RETURNING g_aps.aps551
#                       CALL FGL_DIALOG_SETBUFFER( g_aps.aps551 )
                 DISPLAY BY NAME g_aps.aps551 NEXT FIELD aps551
              #FUN-680029  --End--
              #--MOD-C30486--add--str--
              WHEN INFIELD(aps236) #應付保險費二
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps236,g_aza.aza82)   
                      RETURNING g_aps.aps236
                 DISPLAY BY NAME g_aps.aps236
                 NEXT FIELD aps236
              #--MOD-C30486--add--end--
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("aps01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("aps01",FALSE)
   END IF
 
   IF NOT g_before_input_done THEN
       IF g_apz.apz13 = 'N' THEN
            CALL cl_set_comp_entry("aps01",FALSE)
       END IF
   END IF
 
END FUNCTION
 
 
FUNCTION i702_aps01(p_cmd)  #部門編號
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
           INTO l_gem02,l_gemacti
           FROM gem_file WHERE gem01 = g_aps.aps01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-063'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO gem02
    END IF
END FUNCTION
 
FUNCTION i702_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aps.* TO NULL              #No.FUN-6A0016
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i702_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i702_count
    FETCH i702_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i702_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)
        INITIALIZE g_aps.* TO NULL
    ELSE
        CALL i702_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i702_fetch(p_flaps)
    DEFINE
        p_flaps          LIKE type_file.chr1   # No.FUN-690028 VARCHAR(1)
 
    CASE p_flaps
        WHEN 'N' FETCH NEXT     i702_cs INTO g_aps.aps01
        WHEN 'P' FETCH PREVIOUS i702_cs INTO g_aps.aps01
        WHEN 'F' FETCH FIRST    i702_cs INTO g_aps.aps01
        WHEN 'L' FETCH LAST     i702_cs INTO g_aps.aps01
        WHEN '/'
            IF NOT mi_no_ask THEN
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
            FETCH ABSOLUTE g_jump i702_cs
                  INTO g_aps.aps01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)
        INITIALIZE g_aps.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flaps
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_aps.* FROM aps_file            # 重讀DB,因TEMP有不被更新特性
       WHERE aps01 = g_aps.aps01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
       CALL cl_err3("sel","aps_file",g_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
       LET g_data_owner = g_aps.apsuser     #No.FUN-4C0047
       LET g_data_group = g_aps.apsgrup     #No.FUN-4C0047
       CALL i702_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i702_show()
    LET g_aps_t.* = g_aps.*
    DISPLAY BY NAME g_aps.apsoriu,g_aps.apsorig,
        g_aps.aps01,
        g_aps.aps14, g_aps.aps22, g_aps.aps233, g_aps.aps234, g_aps.aps25,
        g_aps.aps42, g_aps.aps43, g_aps.aps45, g_aps.aps51,
        g_aps.aps52, g_aps.aps53, g_aps.aps54, g_aps.aps55,g_aps.aps231,       #MOD-C30486  add g_aps.aps231,
 
        #FUN-680029  --Begin--
        g_aps.aps141, g_aps.aps221, g_aps.aps238, g_aps.aps239, g_aps.aps251,
        g_aps.aps421, g_aps.aps431, g_aps.aps451, g_aps.aps511,
        g_aps.aps521, g_aps.aps531, g_aps.aps541, g_aps.aps551,g_aps.aps236,   #MOD-C30486  add g_aps.aps236,
        #FUN-680029  --End--
 
        g_aps.apsuser,g_aps.apsgrup,g_aps.apsmodu,g_aps.apsdate,g_aps.apsacti
    CALL i702_aps01('d') LET g_msg=''
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps14
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps14_d LET g_msg=' '
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps22
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps22_d LET g_msg = ' '
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps233
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO FORMONLY.aps233d
    LET g_msg = ' '
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps234
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO FORMONLY.aps234d
    LET g_msg = ' '
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps42
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps42_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps43
                                           AND  aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps43_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps45
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps45_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps51
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps51_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps52
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps52_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps53
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps53_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps54
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps54_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps55
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps55_d LET g_msg=''

    #--MOD-C30486--add--str--
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps231
                                            AND aag00=g_aza.aza81        
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps231_d LET g_msg=''
    #--MOD-C30486--add--end--
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps25
                                            AND aag00=g_aza.aza81        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps25_d LET g_msg=' '
 
    #FUN-680029  --Begin--
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps141
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps141_d LET g_msg=' '
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps221
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps221_d LET g_msg = ' '
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps238
                                            AND aag00=g_aza.aza82        #No.FUN-730064
 
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO FORMONLY.aps238d
    LET g_msg = ' '
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps239
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO FORMONLY.aps239d
    LET g_msg = ' '
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps421
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps421_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps431
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps431_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps451
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps451_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps511
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps511_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps521
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps521_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps531
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps531_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps541
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps541_d LET g_msg=''
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps551
                                            AND aag00=g_aza.aza82        #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps551_d LET g_msg=''

    #--MOD-C30486--add--str--
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps236
                                            AND aag00=g_aza.aza81        
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps236_d LET g_msg=''
    #--MOD-C30486--add--end--
 
    SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_aps.aps251
                                           AND  aag00=g_aza.aza82      #No.FUN-730064
    IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
    DISPLAY g_msg TO aps251_d LET g_msg=' '
    #FUN-680029  --End--
 
    CALL cl_set_field_pic("","","","","",g_aps.apsacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i702_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_aps.aps01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_aps.* FROM aps_file
     WHERE aps01=g_aps.aps01
    IF g_aps.apsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_aps.aps01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i702_cl USING g_aps.aps01
    IF STATUS THEN
       CALL cl_err("OPEN i702_cl:", STATUS, 1)
       CLOSE i702_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i702_cl INTO g_aps.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_aps01_t = g_aps.aps01
    LET g_aps_o.*=g_aps.*
    LET g_aps.apsmodu=g_user                     #修改者
    LET g_aps.apsdate = g_today                  #修改日期
    CALL i702_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i702_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aps.*=g_aps_t.*
            CALL i702_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE aps_file SET aps_file.* = g_aps.*    # 更新DB
            WHERE aps01 = g_aps01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","aps_file",g_aps01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i702_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i702_x()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
	IF g_aps.aps01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
	BEGIN WORK
 
 OPEN i702_cl USING g_aps.aps01
 IF STATUS THEN
    CALL cl_err("OPEN i702_cl:", STATUS, 1)
    CLOSE i702_cl
    ROLLBACK WORK
    RETURN
 END IF
	FETCH i702_cl INTO g_aps.*
	IF SQLCA.sqlcode THEN CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0) RETURN END IF
	CALL i702_show()
	IF cl_exp(15,21,g_aps.apsacti) THEN
        LET g_chr=g_aps.apsacti
        IF g_aps.apsacti='Y'
           THEN LET g_aps.apsacti='N'
           ELSE LET g_aps.apsacti='Y'
        END IF
        UPDATE aps_file
            SET apsacti=g_aps.apsacti,
               apsmodu=g_user, apsdate=g_today
            WHERE aps01 = g_aps.aps01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","aps_file",g_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            LET g_aps.apsacti=g_chr
        END IF
        DISPLAY BY NAME g_aps.apsacti
    END IF
    CLOSE i702_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i702_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aps.aps01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i702_cl USING g_aps.aps01
    IF STATUS THEN
       CALL cl_err("OPEN i702_cl:", STATUS, 1)
       CLOSE i702_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i702_cl INTO g_aps.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0) RETURN END IF
    CALL i702_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "aps01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_aps.aps01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM aps_file WHERE aps01 = g_aps.aps01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("del","aps_file",g_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
        ELSE CLEAR FORM
           INITIALIZE g_aps.* TO NULL
           OPEN i702_count
           #FUN-B50062-add-start--
           IF STATUS THEN
              CLOSE i702_cl
              CLOSE i702_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           FETCH i702_count INTO g_row_count
           #FUN-B50062-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i702_cl
              CLOSE i702_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i702_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i702_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i702_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i702_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i702_copy()
   DEFINE l_aps           RECORD LIKE aps_file.*,
          l_oldno,l_newno LIKE aps_file.aps01,
          l_n             LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_apz.apz13 = 'N' THEN
         CALL cl_err('','aap-088',0)
         RETURN
    END IF
    IF g_aps.aps01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
    LET g_before_input_done = FALSE   #FUN-580028
    CALL i110_set_entry('a')          #FUN-580028
    LET g_before_input_done = TRUE    #FUN-580028
    INPUT l_newno FROM aps01
        AFTER FIELD aps01             #部門編號
            IF cl_null(l_newno) IS NULL THEN
                CALL cl_err('','aap-099',0)
                NEXT FIELD aps01
            END IF
            LET l_n = 0
            SELECT count(*) INTO l_n FROM gem_file
                           WHERE gem01 = l_newno AND gemacti = 'Y'
            IF l_n = 0  THEN
               CALL cl_err(l_newno,'aap-063',0)
               NEXT FIELD aps01
            END IF
 
        AFTER INPUT  #判斷
            IF INT_FLAG THEN EXIT INPUT END IF
            SELECT count(*) INTO l_n FROM aps_file
                WHERE aps01 = l_newno
           IF l_n > 0 THEN                  # Duplicated
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD aps01
           END IF
        ON ACTION controlp
           CASE WHEN INFIELD(aps01) #部門編號
#                CALL q_gem(10,3,l_newno) RETURNING l_newno
#                CALL FGL_DIALOG_SETBUFFER( l_newno )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_aps.aps01
                 CALL cl_create_qry() RETURNING l_newno
#                 CALL FGL_DIALOG_SETBUFFER( l_newno )
                 DISPLAY l_newno TO aps01
                 NEXT FIELD aps01
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_aps.aps01
        RETURN
    END IF
    LET l_aps.* = g_aps.*
    LET l_aps.aps01  =l_newno   #資料鍵值
    LET l_aps.apsuser=g_user    #資料所有者
    LET l_aps.apsgrup=g_grup    #資料所有者所屬群
    LET l_aps.apsmodu=NULL      #資料修改日期
    LET l_aps.apsdate=g_today   #資料建立日期
    LET l_aps.apsacti='Y'       #有效資料
    LET l_aps.apsoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aps.apsorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aps_file VALUES (l_aps.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("ins","aps_file",l_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_aps.aps01
        SELECT aps_file.* INTO g_aps.* FROM aps_file
                       WHERE aps01 = l_newno
        CALL i702_u()
        #SELECT aps_file.* INTO g_aps.* FROM aps_file  #FUN-C30027
        #               WHERE aps01 = l_oldno          #FUN-C30027
    END IF
    CALL i702_show()
END FUNCTION
 
FUNCTION i702_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
        l_aps   RECORD LIKE aps_file.*,
        l_gem02 LIKE gem_file.gem02,
        l_apr02 LIKE apr_file.apr02,
        l_za05          LIKE type_file.chr1000,               #  #No.FUN-690028 VARCHAR(40)
        l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#No.FUN-770012 -- begin --
    DEFINE l_aag02 RECORD
                   aag02_14   LIKE aag_file.aag02,
                   aag02_22   LIKE aag_file.aag02,
                   aag02_233  LIKE aag_file.aag02,
                   aag02_234  LIKE aag_file.aag02,
                   aag02_25   LIKE aag_file.aag02,
                   aag02_42   LIKE aag_file.aag02,
                   aag02_43   LIKE aag_file.aag02,
                   aag02_45   LIKE aag_file.aag02,
                   aag02_51   LIKE aag_file.aag02,
                   aag02_52   LIKE aag_file.aag02,
                   aag02_53   LIKE aag_file.aag02,
                   aag02_54   LIKE aag_file.aag02,
                   aag02_55   LIKE aag_file.aag02,
                   aag02_231  LIKE aag_file.aag02,     #MOD-C30486  add
                   aag02_141  LIKE aag_file.aag02,
                   aag02_221  LIKE aag_file.aag02,
                   aag02_238  LIKE aag_file.aag02,
                   aag02_239  LIKE aag_file.aag02,
                   aag02_251  LIKE aag_file.aag02,
                   aag02_421  LIKE aag_file.aag02,
                   aag02_431  LIKE aag_file.aag02,
                   aag02_451  LIKE aag_file.aag02,
                   aag02_511  LIKE aag_file.aag02,
                   aag02_521  LIKE aag_file.aag02,
                   aag02_531  LIKE aag_file.aag02,
                   aag02_541  LIKE aag_file.aag02,
                   aag02_551  LIKE aag_file.aag02,
                   aag02_236  LIKE aag_file.aag02     #MOD-C30486  add
                   END RECORD
    DEFINE l_str   STRING
#No.FUN-770012 -- end --
 
    IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'aapi702.out'
#No.FUN-770012 -- begin --
#    CALL cl_outnam('aapi702') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapi702'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    CALL cl_del_data(l_table)     #No.FUN-770012
    LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql1
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) 
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #NO:FUN-B30211 
       EXIT PROGRAM
    END IF
#No.FUN-770012 -- end --
    LET g_sql="SELECT aps_file.*,gem02",   # 組合出 SQL 指令
              " FROM aps_file LEFT OUTER JOIN gem_file ON aps_file.aps01 = gem_file.gem01 AND gem_file.gemacti = 'Y'",
              " WHERE ",g_wc CLIPPED
 
    IF g_apz.apz13 = 'N' THEN
       LET g_sql= g_sql CLIPPED," AND aps01 = ' '"
    ELSE
       LET g_sql= g_sql CLIPPED," AND aps01 != ' '"
    END IF
 
    PREPARE i702_p1 FROM g_sql              # RUNTIME 編譯
    DECLARE i702_co CURSOR FOR i702_p1
#    #FUN-680029  --Begin--
#    IF g_aza.aza63= 'Y' THEN
#       LET g_zaa[22].zaa06= "N"
#       LET g_zaa[23].zaa06= "N"
#       LET g_zaa[24].zaa06= "N"
#       LET g_zaa[25].zaa06= "N"
#       LET g_zaa[26].zaa06= "N"
#       LET g_zaa[27].zaa06= "N"
#       LET g_zaa[28].zaa06= "N"
#       LET g_zaa[29].zaa06= "N"
#       LET g_zaa[30].zaa06= "N"
#       LET g_zaa[31].zaa06= "N"
#       LET g_zaa[32].zaa06= "N"
#       LET g_zaa[33].zaa06= "N"
#       LET g_zaa[35].zaa06= "N"
#    ELSE
#       LET g_zaa[22].zaa06= "Y"
#       LET g_zaa[23].zaa06= "Y"
#       LET g_zaa[24].zaa06= "Y"
#       LET g_zaa[25].zaa06= "Y"
#       LET g_zaa[26].zaa06= "Y"
#       LET g_zaa[27].zaa06= "Y"
#       LET g_zaa[28].zaa06= "Y"
#       LET g_zaa[29].zaa06= "Y"
#       LET g_zaa[30].zaa06= "Y"
#       LET g_zaa[31].zaa06= "Y"
#       LET g_zaa[32].zaa06= "Y"
#       LET g_zaa[33].zaa06= "Y"
#       LET g_zaa[35].zaa06= "Y"
#    END IF
#    #FUN-680029  --End--
 
#    START REPORT i702_rep TO l_name     #No.FUN-770012
 
    FOREACH i702_co INTO l_aps.*,l_gem02
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#No.FUN-770012 -- begin --
#        OUTPUT TO REPORT i702_rep(l_aps.*,l_gem02)
        INITIALIZE l_aag02.* TO NULL
        CALL s_aapact('2',g_aza.aza81,l_aps.aps14) RETURNING l_aag02.aag02_14
        CALL s_aapact('2',g_aza.aza81,l_aps.aps22) RETURNING l_aag02.aag02_22
        CALL s_aapact('2',g_aza.aza81,l_aps.aps233) RETURNING l_aag02.aag02_233
        CALL s_aapact('2',g_aza.aza81,l_aps.aps234) RETURNING l_aag02.aag02_234
        CALL s_aapact('2',g_aza.aza81,l_aps.aps25) RETURNING l_aag02.aag02_25
        CALL s_aapact('2',g_aza.aza81,l_aps.aps42) RETURNING l_aag02.aag02_42
        CALL s_aapact('2',g_aza.aza81,l_aps.aps43) RETURNING l_aag02.aag02_43
        CALL s_aapact('2',g_aza.aza81,l_aps.aps45) RETURNING l_aag02.aag02_45
        CALL s_aapact('2',g_aza.aza81,l_aps.aps51) RETURNING l_aag02.aag02_51
        CALL s_aapact('2',g_aza.aza81,l_aps.aps52) RETURNING l_aag02.aag02_52
        CALL s_aapact('2',g_aza.aza81,l_aps.aps53) RETURNING l_aag02.aag02_53
        CALL s_aapact('2',g_aza.aza81,l_aps.aps54) RETURNING l_aag02.aag02_54
        CALL s_aapact('2',g_aza.aza81,l_aps.aps55) RETURNING l_aag02.aag02_55
        CALL s_aapact('2',g_aza.aza81,l_aps.aps231) RETURNING l_aag02.aag02_231      #MOD-C30486  add
        CALL s_aapact('2',g_aza.aza81,l_aps.aps141) RETURNING l_aag02.aag02_141
        CALL s_aapact('2',g_aza.aza81,l_aps.aps221) RETURNING l_aag02.aag02_221
        CALL s_aapact('2',g_aza.aza81,l_aps.aps238) RETURNING l_aag02.aag02_238
        CALL s_aapact('2',g_aza.aza81,l_aps.aps239) RETURNING l_aag02.aag02_239
        CALL s_aapact('2',g_aza.aza81,l_aps.aps251) RETURNING l_aag02.aag02_251
        CALL s_aapact('2',g_aza.aza81,l_aps.aps421) RETURNING l_aag02.aag02_421
        CALL s_aapact('2',g_aza.aza81,l_aps.aps431) RETURNING l_aag02.aag02_431
        CALL s_aapact('2',g_aza.aza81,l_aps.aps451) RETURNING l_aag02.aag02_451
        CALL s_aapact('2',g_aza.aza81,l_aps.aps511) RETURNING l_aag02.aag02_511
        CALL s_aapact('2',g_aza.aza81,l_aps.aps521) RETURNING l_aag02.aag02_521
        CALL s_aapact('2',g_aza.aza81,l_aps.aps531) RETURNING l_aag02.aag02_531
        CALL s_aapact('2',g_aza.aza81,l_aps.aps541) RETURNING l_aag02.aag02_541
        CALL s_aapact('2',g_aza.aza81,l_aps.aps551) RETURNING l_aag02.aag02_551
        CALL s_aapact('2',g_aza.aza81,l_aps.aps236) RETURNING l_aag02.aag02_236     #MOD-C30486  add 
        EXECUTE insert_prep USING l_aps.aps01,l_aps.apsacti,l_gem02,
                                  l_aps.aps14,l_aps.aps22,l_aps.aps233,l_aps.aps234,
                                  l_aps.aps25,l_aps.aps42,l_aps.aps43,l_aps.aps45,
                                  l_aps.aps51,l_aps.aps52,l_aps.aps53,l_aps.aps54,l_aps.aps55,l_aps.aps231,    #MOD-C30486  add  l_aps.aps231,
                                  l_aps.aps141,l_aps.aps221,l_aps.aps238,l_aps.aps239,
                                  l_aps.aps251,l_aps.aps421,l_aps.aps431,l_aps.aps451,
                                  l_aps.aps511,l_aps.aps521,l_aps.aps531,l_aps.aps541,l_aps.aps551,l_aps.aps236,  #MOD-C30486  add  l_aps.aps236,
                                  l_aag02.*
        IF STATUS THEN
           CALL cl_err("execute insert_prep:",STATUS,1)
           EXIT FOREACH
        END IF
#No.FUN-770012 -- end --
    END FOREACH
 
#    FINISH REPORT i702_rep       #No.FUN-770012
 
    CLOSE i702_co
    ERROR ""
#No.FUN-770012 -- begin --
#    CALL cl_prt(l_name,' ','1',g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     LET l_str = "aps01,aps14,aps22,aps233,aps234,aps25,aps42,aps43,aps45,aps51,",
                 "aps52,aps53,aps54,aps55,aps231,aps141,aps221,aps238,aps239,aps251,",     #MOD-C30486  add  aps231,
                 "aps421,aps431,aps451,aps511,aps521,aps531,aps541,aps551"
     CALL cl_wcchp(g_wc,l_str) RETURNING g_wc
     LET g_str = g_wc,";",g_zz05,";",g_azi03,";",g_azi04,";",g_azi05
     LET g_sql1 = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('aapi702','aapi702',g_sql1,g_str)
#No.FUN-770012 -- end --
END FUNCTION
 
REPORT i702_rep(sr,l_gem02)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        sr RECORD LIKE aps_file.*,
        l_gem02 LIKE gem_file.gem02,
        l_aag02 LIKE aag_file.aag02,
        l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.aps01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED  #TQC-790097
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                  COLUMN (g_len-FGL_WIDTH(g_user)-19),'FROM:',g_user CLIPPED,  #TQC-790097
                COLUMN g_len-10, g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.aps01
            IF sr.apsacti = 'N' THEN PRINT '*'; END IF
            PRINT COLUMN 3,g_x[09] CLIPPED,COLUMN 12,sr.aps01,COLUMN 19,l_gem02
 
        ON EVERY ROW
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps14) RETURNING l_aag02    #No.FUN-730064
            PRINT COLUMN 7,g_x[10] CLIPPED,
                  COLUMN 28,sr.aps14 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps22) RETURNING l_aag02      #No.FUN-730064
            PRINT COLUMN 7,g_x[11] CLIPPED,
                  COLUMN 28,sr.aps22 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
 
            #FUN-680029  --Begin--
            CALL s_aapact('2',g_aza.aza81,sr.aps233) RETURNING l_aag02     #No.FUN-730064
            PRINT COLUMN 7,g_x[34] CLIPPED,
                  COLUMN 28,sr.aps233 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            #FUN-680029  --End--
 
            CALL s_aapact('2',g_aza.aza81,sr.aps234) RETURNING l_aag02     #No.FUN-730064
            PRINT COLUMN 7,g_x[12] CLIPPED,
                  COLUMN 28,sr.aps234 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps25) RETURNING l_aag02     #No.FUN-730064
            PRINT COLUMN 7,g_x[13] CLIPPED,
                  COLUMN 28,sr.aps25 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps42) RETURNING l_aag02     #No.FUN-730064
            PRINT COLUMN 7,g_x[14] CLIPPED,
                  COLUMN 28,sr.aps42 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps43) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[15] CLIPPED,
                  COLUMN 28,sr.aps43 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps45) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[16] CLIPPED,
                  COLUMN 28,sr.aps45 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps51) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[17] CLIPPED,
                  COLUMN 28,sr.aps51 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps52) RETURNING l_aag02     #No.FUN-730064
            PRINT COLUMN 7,g_x[18] CLIPPED,
                  COLUMN 28,sr.aps52 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps53) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[19] CLIPPED,
                  COLUMN 28,sr.aps53 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps54) RETURNING l_aag02    #No.FUN-730064
            PRINT COLUMN 7,g_x[20] CLIPPED,
                  COLUMN 28,sr.aps54 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza81,sr.aps55) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[21] CLIPPED,
                  COLUMN 28,sr.aps55 CLIPPED,' ',l_aag02 CLIPPED
            LET l_aag02 = ' '
            #--MOD-C30486--add--str--
  {應付保費}  CALL s_aapact('2',g_aza.aza81,sr.aps231) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[19] CLIPPED,
                  COLUMN 28,sr.aps231 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
            #--MOD-C30486--add--end--
 
        IF g_aza.aza63='Y' THEN
            #FUN-680029  --Begin--
            CALL s_aapact('2',g_aza.aza82,sr.aps141) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[22] CLIPPED,
                  COLUMN 28,sr.aps141 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps221) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[23] CLIPPED,
                  COLUMN 28,sr.aps221 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps238) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[35] CLIPPED,
                  COLUMN 28,sr.aps238 CLIPPED,' ',l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps23) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[24] CLIPPED,
                  COLUMN 28,sr.aps238 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps251) RETURNING l_aag02  #No.FUN-730064
            PRINT COLUMN 7,g_x[25] CLIPPED,
                  COLUMN 28,sr.aps251 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps421) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[26] CLIPPED,
                  COLUMN 28,sr.aps421 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps431) RETURNING l_aag02    #No.FUN-730064
            PRINT COLUMN 7,g_x[27] CLIPPED,
                  COLUMN 28,sr.aps431 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps45) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[28] CLIPPED,
                  COLUMN 28,sr.aps451 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps511) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[29] CLIPPED,
                  COLUMN 28,sr.aps511 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps521) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[30] CLIPPED,
                  COLUMN 28,sr.aps521 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps531) RETURNING l_aag02  #No.FUN-730064
            PRINT COLUMN 7,g_x[31] CLIPPED,
                  COLUMN 28,sr.aps531 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps541) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[32] CLIPPED,
                  COLUMN 28,sr.aps541 CLIPPED,COLUMN 43,l_aag02 CLIPPED
            LET l_aag02 = ' '
            CALL s_aapact('2',g_aza.aza82,sr.aps551) RETURNING l_aag02   #No.FUN-730064
            PRINT COLUMN 7,g_x[33] CLIPPED,
                  COLUMN 28,sr.aps551 CLIPPED,' ',l_aag02 CLIPPED
            LET l_aag02 = ' '
            #FUN-680029  --End--
            #--MOD-C30486--add--str--
  {應付保費}  CALL s_aapact('2',g_aza.aza82,sr.aps236) RETURNING l_aag02          
            PRINT COLUMN 7,g_x[56] CLIPPED,
                  COLUMN 28,sr.aps236 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
            #--MOD-C30486--add--end--
        END IF
 
        AFTER GROUP OF sr.aps01
            SKIP 1 LINE
 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc,'aps01,aps11,aps21,aps41')
                    RETURNING g_sql
               PRINT g_dash[1,g_len]
               #TQC-630166
               #IF g_sql[001,080] > ' ' THEN
               #        PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
               #        PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
               #        PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
                CALL cl_prt_pos_wc(g_sql)
               #TQC-630166
            END IF
            PRINT g_dash[1,g_len]
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
 
 
#Patch....NO.TQC-610035 <001> #

