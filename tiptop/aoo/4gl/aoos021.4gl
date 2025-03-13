# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aoos021.4gl
# Descriptions...: 帳套會計期間參數設定
# Date & Author..: 06/07/11 By cl
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0138 06/11/30 By cl    管控功能釋放。另待處理。
# Modify.........: No.TQC-6C0229 07/01/04 By chenl 僅需判別日期期間是否存在于其他帳套中，而期間不必與其他帳套一一對應。
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套 -批次產生tna_file資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/13 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-790009 07/09/04 By Carrier 1.去掉"不使用多帳套"時,run aoos020的內容
#                                                    2.若插入的帳套是aza81,則自動將azmm_file內容插入azm_file
#                                                    3.s021_gen()判斷g_wc是否為NULL
# Modify.........: No.TQC-7A0079 07/10/22 By wujie  輸入帳套與當前主帳套不同時不能存入數據庫
# Modify.........: No.TQC-7B0046 07/11/09 By wujie  tna的索引改為(tna00,tna01)，點“生成歷年會計帳套資料”時，應詢問是否刪除主鍵重復資料
#                                                   點“生成歷年會計帳套資料”時，產生的範圍改為當前這筆
#                                                   增加“歷年會計帳套資料查詢”按鈕，串至aooq021
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-A40071 10/04/15 By lilingyu 查詢時,"帳套azmm00"開窗錯誤
# Modify.........: No:MOD-A60102 10/06/15 By Dido 刪除時應同步刪除 azm_file;取消 aoo-229 訊息 
# Modify.........: No:MOD-B10023 11/01/04 By wujie 第二套张的tna00应该是1，不是0
# Modify.........: No:TQC-B20031 11/02/15 By destiny 會計期間設置時應當管控不能輸入管理帳
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-C40050 12/06/15 By Vampire 在刪除azm_file前count azmm_file的筆數>0不可刪除
# Modify.........: No.TQC-C90084 12/09/19 By lujh 增加期別區間的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_azmm      RECORD LIKE azmm_file.*,
    g_azmm_t    RECORD LIKE azmm_file.*,
    g_azmm00    LIKE azmm_file.azmm00,
    g_azmm00_t  LIKE azmm_file.azmm00,
    g_azmm01_t  LIKE azmm_file.azmm01,
    g_azmm013_t LIKE azmm_file.azmm013,
    g_azmm023_t LIKE azmm_file.azmm023,
    g_azmm033_t LIKE azmm_file.azmm033,
    g_azmm043_t LIKE azmm_file.azmm043,
    g_azmm053_t LIKE azmm_file.azmm053,
    g_azmm063_t LIKE azmm_file.azmm063,
    g_azmm073_t LIKE azmm_file.azmm073,
    g_azmm083_t LIKE azmm_file.azmm083,
    g_azmm093_t LIKE azmm_file.azmm093,
    g_azmm103_t LIKE azmm_file.azmm103,
    g_azmm113_t LIKE azmm_file.azmm113,
    g_azmm123_t LIKE azmm_file.azmm123,
    g_azmm133_t LIKE azmm_file.azmm133,
#    g_wc,g_sql          STRING  #NO.TQC-630166  MARK   
    g_wc,g_sql          STRING      #NO.TQC-630166      
DEFINE  g_forupd_sql    STRING    
DEFINE  g_before_input_done    LIKE type_file.num5   #No.FUN-680102 SMALLINT
DEFINE  g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE  g_msg           LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   g_str          STRING                        #No.FUN-760083
MAIN
#     DEFINE    l_time LIKE type_file.chr10              #No.FUN-6A0081
    DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
    DEFINE l_aza63         LIKE aza_file.aza63
    
     
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-790009  --Begin  --mark
   ##No.FUN-670040--begin-- --move here 
   # SELECT aza63 INTO l_aza63 from aza_file
   # IF l_aza63 ='N' THEN
   #    CALL cl_cmdrun('aoos020')
   #    EXIT PROGRAM    
   # END IF
   ##No.FUN-670040--end-- --move here 
   #No.FUN-790009  --End  
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
    INITIALIZE g_azmm.* TO NULL
    INITIALIZE g_azmm_t.* TO NULL
    LET g_forupd_sql = "SELECT * FROM azmm_file WHERE azmm00=? AND azmm01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s021_curl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col =11
    OPEN WINDOW s021_w AT p_row,p_col
        WITH FORM "aoo/42f/aoos021"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    DISPLAY 'idle time=',g_idle_seconds
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL s021_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s021_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION s021_curs()
    CLEAR FORM
   INITIALIZE g_azmm.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        azmm00,
        azmm01, azmm02, azmm011,azmm012,azmm013,azmm021,
        azmm022,azmm023,azmm031,azmm032,azmm033,azmm041,
        azmm042,azmm043,azmm051,azmm052,azmm053,azmm061,
        azmm062,azmm063,azmm071,azmm072,azmm073,azmm081,
        azmm082,azmm083,azmm091,azmm092,azmm093,azmm101,
        azmm102,azmm103,azmm111,azmm112,azmm113,azmm121,
        azmm122,azmm123,azmm131,azmm132,azmm133
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
             
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
      ON ACTION controlp
         CASE
           WHEN INFIELD(azmm00)
             CALL cl_init_qry_var()
          #  LET g_qryparam.form = "q_aaa"      #TQC-A40071 
             LET g_qryparam.form = "q_azmm00"   #TQC-A40071
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO azmm00
           OTHERWISE EXIT CASE
         END CASE
 
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
{   #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND azmmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND azmmgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND azmmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zmmuser', 'zmmgrup')
    #End:FUN-980030
 
}
    LET g_sql="SELECT azmm00,azmm01 FROM azmm_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY azmm00,azmm01"
    PREPARE s021_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE s021_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s021_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM azmm_file WHERE ",g_wc CLIPPED
    PREPARE s021_precount FROM g_sql
    DECLARE s021_count CURSOR FOR s021_precount
END FUNCTION
 
FUNCTION s021_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL s021_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL s021_q()
            END IF
        ON ACTION next
            CALL s021_fetch('N')
        ON ACTION previous
            CALL s021_fetch('P')
        ON ACTION delete
                 CALL s021_r()
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL s021_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL s021_fetch('/')
        ON ACTION first
            CALL s021_fetch('F')
        ON ACTION last
            CALL s021_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          
       ON ACTION create_period
          CALL s021_period()
 
       #No.FUN-730020  --Begin
       ON ACTION gen_annual_gl_bookno
          CALL s021_gen()
       #No.FUN-730020  --End  
 
#No.TQC-7B0046 --begin
       ON ACTION qry_annual_gl_bookno
          CALL cl_cmdrun_wait("aooq021") 
#No.TQC-7B0046 --end
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE s021_curs
END FUNCTION
 
 
FUNCTION s021_a()
  DEFINE ins_sql      LIKE type_file.chr50     #No.FUN-680122 VARCHAR(40)
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_azmm.* LIKE azmm_file.*
    LET g_azmm00_t = NULL
    LET g_azmm01_t = NULL
    LET g_azmm_t.*=g_azmm.*
    LET g_azmm013_t = ''
    LET g_azmm023_t = ''
    LET g_azmm033_t = ''
    LET g_azmm043_t = ''
    LET g_azmm053_t = ''
    LET g_azmm063_t = ''
    LET g_azmm073_t = ''
    LET g_azmm083_t = ''
    LET g_azmm093_t = ''
    LET g_azmm103_t = ''
    LET g_azmm113_t = ''
    LET g_azmm123_t = ''
    LET g_azmm133_t = ''
 
    LET g_azmm.azmm02=g_aza.aza02
    CALL cl_opmsg('a')
 
    WHILE TRUE
        CALL s021_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_azmm.azmm00 IS NULL OR g_azmm.azmm01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        #No.FUN-790009  --Begin
        BEGIN WORK
        LET g_success = 'Y'
        #No.FUN-790009  --End  
        INSERT INTO azmm_file VALUES(g_azmm.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","azmm_file",g_azmm.azmm01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660131
            ROLLBACK WORK   #No.FUN-790009 
            CONTINUE WHILE
        ELSE
            #No.FUN-790009  --Begin
            #插入azmm_file的中主帳套aza81,則要將azmm_file資料insert至azm_file
            IF g_azmm.azmm00 = g_aza.aza81 THEN
               CALL s021_update_azm(g_azmm.azmm00,g_azmm.azmm01)
               IF g_success = 'N' THEN
                  ROLLBACK WORK
                  CONTINUE WHILE
               ELSE
#                 COMMIT WORK     #No.TQC-7A0079
               END IF
            END IF
            #No.FUN-790009  --End  
            COMMIT WORK     #No.TQC-7A0079
            LET g_azmm_t.* = g_azmm.*                # 保存上筆資料
            SELECT azmm00,azmm01 INTO g_azmm.azmm00,g_azmm.azmm01 FROM azmm_file
                WHERE azmm00=g_azmm.azmm00 AND azmm01 = g_azmm.azmm01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION s021_i(p_cmd)
   DEFINE   p_cmd              LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1)
            l_flag             LIKE type_file.chr1,     #判斷必要欄位之值是否有輸入        #No.FUN-680102 VARCHAR(1)
            l_n                LIKE type_file.num5,     #No.FUN-680102 SMALLINT
            l_aaaacti          LIKE aaa_file.aaaacti,   #
            l_success          LIKE type_file.chr1      #No.FUN-680102CHAR(1)
   #TQC-C90084--add--str--
   DEFINE   l_azmm02           LIKE azmm_file.azmm02
   DEFINE   l_azmm122          LIKE azmm_file.azmm122
   DEFINE   l_azmm132          LIKE azmm_file.azmm132           
   DEFINE   l_azmm011          LIKE azmm_file.azmm011   
   #TQC-C90084--add--end--        
 
   #DISPLAY BY NAME g_azmm.azmmuser,g_azmm.azmmgrup,g_azmm.azmmdate, g_azmm.azmmacti
 
   INPUT BY NAME
      g_azmm.azmm00,g_azmm.azmm01, g_azmm.azmm02,
      g_azmm.azmm011,g_azmm.azmm012,g_azmm.azmm013,
      g_azmm.azmm021,g_azmm.azmm022,g_azmm.azmm023,
      g_azmm.azmm031,g_azmm.azmm032,g_azmm.azmm033,
      g_azmm.azmm041,g_azmm.azmm042,g_azmm.azmm043,
      g_azmm.azmm051,g_azmm.azmm052,g_azmm.azmm053,
      g_azmm.azmm061,g_azmm.azmm062,g_azmm.azmm063,
      g_azmm.azmm071,g_azmm.azmm072,g_azmm.azmm073,
      g_azmm.azmm081,g_azmm.azmm082,g_azmm.azmm083,
      g_azmm.azmm091,g_azmm.azmm092,g_azmm.azmm093,
      g_azmm.azmm101,g_azmm.azmm102,g_azmm.azmm103,
      g_azmm.azmm111,g_azmm.azmm112,g_azmm.azmm113,
      g_azmm.azmm121,g_azmm.azmm122,g_azmm.azmm123,
      g_azmm.azmm131,g_azmm.azmm132,g_azmm.azmm133
      WITHOUT DEFAULTS
 
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL s021_set_entry(p_cmd)
            CALL s021_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
      AFTER FIELD azmm00
        IF NOT cl_null(g_azmm.azmm00) THEN
           SELECT aaaacti INTO l_aaaacti FROM aaa_file
            WHERE aaa01=g_azmm.azmm00
           IF SQLCA.SQLCODE=100 THEN
              CALL cl_err3("sel","aaa_file",g_azmm00,"",100,"","",1)
              NEXT FIELD azmm00
           END IF
           IF l_aaaacti='N' THEN
              CALL cl_err(g_azmm00,"9028",1)
              NEXT FIELD azmm00
           END IF
        END IF
      
      AFTER FIELD azmm01
        IF NOT cl_null(g_azmm.azmm01) THEN
           IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_azmm.azmm01 != g_azmm01_t) THEN
              SELECT count(*) INTO l_n FROM azmm_file 
               WHERE azmm00=g_azmm.azmm00 AND azmm01 = g_azmm.azmm01
              IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err(g_azmm.azmm01,-239,0)
                 LET g_azmm.azmm01 = g_azmm01_t
                 DISPLAY BY NAME g_azmm.azmm01
                 NEXT FIELD azmm01
              END IF
           END IF
        END IF
 
      AFTER FIELD azmm011
         IF NOT cl_null(g_azmm.azmm011) THEN
           #No.TQC-6C0229--begin-- add
           #起始日期的年份必須和年度欄位的值相同。
            IF YEAR(g_azmm.azmm011)!=g_azmm.azmm01 THEN
               CALL cl_err('','aoo-020',0)
               NEXT FIELD azmm011
            END IF  
           #TQC-C90084--add--str--
           LET l_n = 0
           SELECT COUNT(*) INTO l_n
             FROM azmm_file
            WHERE azmm00 = g_azmm.azmm00
              AND azmm01 = g_azmm.azmm01 - 1
           IF l_n > 0 THEN
              SELECT azmm02,azmm122,azmm132 INTO l_azmm02,l_azmm122,l_azmm132 
                FROM azmm_file
               WHERE azmm00 = g_azmm.azmm00
                 AND azmm01 = g_azmm.azmm01 - 1
              IF l_azmm02 = '1' THEN    
                 IF g_azmm.azmm011 < l_azmm122 THEN
                    CALL cl_err('','aoo-079',0)
                    NEXT FIELD azmm011
                 END IF
              END IF
              IF l_azmm02 = '2' THEN
                 IF g_azmm.azmm011 < l_azmm132 THEN
                    CALL cl_err('','aoo-079',0)
                    NEXT FIELD azmm011
                 END IF
              END IF
           END IF
           #TQC-C90084--add--end--
           #由于日期區間輸入錯誤，NEXT FIELD后光標定位于日期區間的起始欄位，
           #所以當重新賦值后，必須對該區間值重新判斷。
            IF l_success='N' THEN
               NEXT FIELD azmm012
            END IF 
           #No.TQC-6C0229--end-- add
            IF g_azmm.azmm02 ='1' AND g_azmm.azmm012 IS NULL THEN
               CALL s021_default1()
            END IF
           #start FUN-660217 add
            IF g_azmm.azmm02 ='2' AND g_azmm.azmm012 IS NULL THEN
               CALL s021_default2()
            END IF
           #end FUN-660217 add
         END IF
 
      AFTER FIELD azmm012
         IF NOT cl_null(g_azmm.azmm012) THEN
           #start FUN-660217 mark
           #IF g_azmm.azmm02 ='2' AND g_azmm.azmm021 IS NULL THEN
           #   CALL s021_default2()
           #END IF
           #end FUN-660217 mark
            IF g_azmm.azmm012 < g_azmm.azmm011 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm011
            END IF
           #No.TQC-6B0138--begin-- mark
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm011,g_azmm.azmm012,'01')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm011,g_azmm.azmm012) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm011
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm013
         IF NOT cl_null(g_azmm.azmm013) THEN
            IF g_azmm.azmm013 < 1 OR g_azmm.azmm013 > 4  OR g_azmm.azmm013 IS NULL THEN
               LET g_azmm.azmm013=g_azmm013_t
               DISPLAY BY NAME g_azmm.azmm013
               NEXT FIELD azmm013
            END IF
         END IF
         LET g_azmm013_t=g_azmm.azmm013
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm021
         IF (NOT cl_null(g_azmm.azmm021)) AND l_success='N' THEN
            NEXT FIELD azmm022
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm022
         IF NOT cl_null(g_azmm.azmm022) THEN
            IF g_azmm.azmm022 < g_azmm.azmm021 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm021
            END IF
           #No.TQC-6B0138--begin-- mark 
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm021,g_azmm.azmm022,'02')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm021,g_azmm.azmm022) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm021
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm023
         IF NOT cl_null(g_azmm.azmm023) THEN
            IF g_azmm.azmm023 < 1 OR g_azmm.azmm023 > 4  OR g_azmm.azmm023 IS NULL THEN
               LET g_azmm.azmm023=g_azmm023_t
               DISPLAY BY NAME g_azmm.azmm023
               NEXT FIELD azmm023
            END IF
         END IF
         LET g_azmm023_t=g_azmm.azmm023
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm031
         IF (NOT cl_null(g_azmm.azmm031)) AND l_success='N' THEN
            NEXT FIELD azmm032
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm032
         IF NOT cl_null(g_azmm.azmm032) THEN
            IF g_azmm.azmm032 < g_azmm.azmm031 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm031
            END IF
           #No.TQC-6B0138--begin-- mark 
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm031,g_azmm.azmm032,'03')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm031,g_azmm.azmm032) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm031
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm033
         IF NOT cl_null(g_azmm.azmm033) THEN
            IF g_azmm.azmm033 < 1 OR g_azmm.azmm033 > 4  OR g_azmm.azmm033 IS NULL THEN
               LET g_azmm.azmm033=g_azmm033_t
               DISPLAY BY NAME g_azmm.azmm033
               NEXT FIELD azmm033
            END IF
         END IF
         LET g_azmm033_t=g_azmm.azmm033
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm041
         IF (NOT cl_null(g_azmm.azmm041)) AND l_success='N' THEN
            NEXT FIELD azmm042
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm042
         IF NOT cl_null(g_azmm.azmm042) THEN
            IF g_azmm.azmm042 < g_azmm.azmm041 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm041
            END IF
           #No.TQC-6B0138--begin-- mark
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm041,g_azmm.azmm042,'04')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm041,g_azmm.azmm042) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm041
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm043
         IF NOT cl_null(g_azmm.azmm043) THEN
            IF g_azmm.azmm043 < 1 OR g_azmm.azmm043 > 4  OR g_azmm.azmm043 IS NULL THEN
               LET g_azmm.azmm043=g_azmm043_t
               DISPLAY BY NAME g_azmm.azmm043
               NEXT FIELD azmm043
            END IF
         END IF
         LET g_azmm043_t=g_azmm.azmm043
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm051
         IF (NOT cl_null(g_azmm.azmm051)) AND l_success='N' THEN
            NEXT FIELD azmm052
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm052
         IF NOT cl_null(g_azmm.azmm052) THEN
            IF g_azmm.azmm052 < g_azmm.azmm051 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm051
            END IF
           #No.TQC-6B0138--begin-- mark 
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm051,g_azmm.azmm052,'05')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm051,g_azmm.azmm052) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm051
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm053
         IF NOT cl_null(g_azmm.azmm053) THEN
            IF g_azmm.azmm053 < 1 OR g_azmm.azmm053 > 4  OR g_azmm.azmm053 IS NULL THEN
               LET g_azmm.azmm053=g_azmm053_t
               DISPLAY BY NAME g_azmm.azmm053
               NEXT FIELD azmm053
            END IF
         END IF
         LET g_azmm053_t=g_azmm.azmm053
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm061
         IF (NOT cl_null(g_azmm.azmm061)) AND l_success='N' THEN
            NEXT FIELD azmm062
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm062
         IF NOT cl_null(g_azmm.azmm062) THEN
            IF g_azmm.azmm062 < g_azmm.azmm061 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm061
            END IF
           #No.TQC-6B0138--begin-- mark 
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm061,g_azmm.azmm062,'06')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--begin-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm061,g_azmm.azmm062) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm061
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm063
         IF NOT cl_null(g_azmm.azmm063) THEN
            IF g_azmm.azmm063 < 1 OR g_azmm.azmm063 > 4  OR g_azmm.azmm063 IS NULL THEN
               LET g_azmm.azmm063=g_azmm063_t
               DISPLAY BY NAME g_azmm.azmm063
               NEXT FIELD azmm063
            END IF
         END IF
         LET g_azmm063_t=g_azmm.azmm063
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm071
         IF (NOT cl_null(g_azmm.azmm071)) AND l_success='N' THEN
             NEXT FIELD azmm072
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm072
         IF NOT cl_null(g_azmm.azmm072) THEN
            IF g_azmm.azmm072 < g_azmm.azmm071 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm071
            END IF
           #No.TQC-6B0138--begin-- mark
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm071,g_azmm.azmm072,'07')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138-end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm071,g_azmm.azmm072) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm071
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm073
         IF NOT cl_null(g_azmm.azmm073) THEN
            IF g_azmm.azmm073 < 1 OR g_azmm.azmm073 > 4  OR g_azmm.azmm073 IS NULL THEN
               LET g_azmm.azmm073=g_azmm073_t
               DISPLAY BY NAME g_azmm.azmm073
               NEXT FIELD azmm073
            END IF
         END IF
         LET g_azmm073_t=g_azmm.azmm073
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm081
         IF (NOT cl_null(g_azmm.azmm081)) AND l_success='N' THEN
             NEXT FIELD azmm082
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm082
         IF NOT cl_null(g_azmm.azmm082) THEN
            IF g_azmm.azmm082 < g_azmm.azmm081 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm081
            END IF
           #No.TQC-6B0138--begin-- mark 
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm081,g_azmm.azmm082,'08')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm081,g_azmm.azmm082) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm081
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm083
         IF NOT cl_null(g_azmm.azmm083) THEN
            IF g_azmm.azmm083 < 1 OR g_azmm.azmm083 > 4  THEN
               LET g_azmm.azmm083=g_azmm083_t
               DISPLAY BY NAME g_azmm.azmm083
               NEXT FIELD azmm083
            END IF
         END IF
         LET g_azmm083_t=g_azmm.azmm083
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm091
         IF (NOT cl_null(g_azmm.azmm091)) AND l_success='N' THEN
             NEXT FIELD azmm092
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm092
         IF NOT cl_null(g_azmm.azmm092) THEN
            IF g_azmm.azmm092 < g_azmm.azmm091 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm091
            END IF
           #No.TQC-6B0138--begin-- mark 
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm091,g_azmm.azmm092,'09')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm091,g_azmm.azmm092) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm091
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm093
         IF NOT cl_null(g_azmm.azmm093) THEN
            IF g_azmm.azmm093 < 1 OR g_azmm.azmm093 > 4  THEN
               LET g_azmm.azmm093=g_azmm093_t
               DISPLAY BY NAME g_azmm.azmm093
               NEXT FIELD azmm093
            END IF
         END IF
         LET g_azmm093_t=g_azmm.azmm093
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm101
         IF (NOT cl_null(g_azmm.azmm101)) AND l_success='N' THEN
             NEXT FIELD azmm102
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm102
         IF NOT cl_null(g_azmm.azmm102) THEN
            IF g_azmm.azmm102 < g_azmm.azmm101 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm101
            END IF
           #No.TQC-6B0138--begin-- mark 
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm101,g_azmm.azmm102,'10')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm101,g_azmm.azmm102) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm101
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm103
         IF NOT cl_null(g_azmm.azmm103) THEN
            IF g_azmm.azmm103 < 1 OR g_azmm.azmm103 > 4  THEN
               LET g_azmm.azmm103=g_azmm103_t
               DISPLAY BY NAME g_azmm.azmm103
               NEXT FIELD azmm103
            END IF
         END IF
         LET g_azmm103_t=g_azmm.azmm103
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm111
         IF (NOT cl_null(g_azmm.azmm111)) AND l_success='N' THEN
             NEXT FIELD azmm112
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm112
         IF NOT cl_null(g_azmm.azmm112) THEN
            IF g_azmm.azmm112 < g_azmm.azmm111 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm111
            END IF
           #No.TQC-6B0138--begin-- mark
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm111,g_azmm.azmm112,'11')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm111,g_azmm.azmm112) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm111
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm113
         IF NOT cl_null(g_azmm.azmm113) THEN
            IF g_azmm.azmm113 < 1 OR g_azmm.azmm113 > 4  THEN
               LET g_azmm.azmm113=g_azmm113_t
               DISPLAY BY NAME g_azmm.azmm113
               NEXT FIELD azmm113
            END IF
         END IF
         LET g_azmm113_t=g_azmm.azmm113
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm121
         IF (NOT cl_null(g_azmm.azmm121)) AND l_success='N' THEN
             NEXT FIELD azmm122
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm122
         IF NOT cl_null(g_azmm.azmm122) THEN
            IF g_azmm.azmm122 < g_azmm.azmm121 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm121
            END IF
           #No.TQC-6B0138--begin-- mark
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm121,g_azmm.azmm122,'12')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm121,g_azmm.azmm122) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm121
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm123
         IF NOT cl_null(g_azmm.azmm123) THEN
            IF g_azmm.azmm123 < 1 OR g_azmm.azmm123 > 4  THEN
               LET g_azmm.azmm123=g_azmm123_t
               DISPLAY BY NAME g_azmm.azmm123
               NEXT FIELD azmm123
            END IF
         END IF
         LET g_azmm123_t=g_azmm.azmm123
 
      BEFORE FIELD azmm131
         IF g_azmm.azmm02 = '1' THEN
            CALL cl_err(g_azmm.azmm131,'aoo-058',0)
            EXIT INPUT
         END IF
 
     #No.TQC-6C0229--begin-- add 
      AFTER FIELD azmm131
         IF (NOT cl_null(g_azmm.azmm131)) AND l_success='N' THEN
             NEXT FIELD azmm132
         END IF 
     #No.TQC-6C0229--end-- add
 
      AFTER FIELD azmm132
         IF NOT cl_null(g_azmm.azmm132) THEN
            IF g_azmm.azmm132 < g_azmm.azmm131 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azmm131
            END IF
           #No.TQC-6B0138--begin-- mark
           # CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm131,g_azmm.azmm132,'13')
           #      RETURNING l_success
           # IF l_success='N' THEN
           #    NEXT FIELD azmm011
           # END IF 
           #No.TQC-6B0138--end-- mark
           #No.TQC-6C0229--begin-- add
            CALL s021_check(g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm131,g_azmm.azmm132) 
                 RETURNING l_success
            IF l_success='N' THEN 
               NEXT FIELD azmm131
            END IF 
           #No.TQC-6C0229--end-- add
         END IF
 
      AFTER FIELD azmm133
         IF NOT cl_null(g_azmm.azmm133) THEN
            IF g_azmm.azmm133 < 1 OR g_azmm.azmm133 > 4  THEN
               LET g_azmm.azmm133=g_azmm133_t
               DISPLAY BY NAME g_azmm.azmm133
               NEXT FIELD azmm133
            END IF
         END IF
         LET g_azmm133_t=g_azmm.azmm133
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_azmm.azmm01 IS NULL  OR g_azmm.azmm01=' ' THEN #會計年度
            LET l_flag='Y'
            DISPLAY BY NAME g_azmm.azmm01
         END IF
         IF g_azmm.azmm02 NOT MATCHES "[12]" OR g_azmm.azmm02 IS NULL THEN
            LET l_flag='Y'    #會計期間分類方式
            DISPLAY BY NAME g_azmm.azmm02
         END IF
         IF g_azmm.azmm011 IS NULL THEN  #第一期起始日期
            LET l_flag='Y'
            DISPLAY BY NAME g_azmm.azmm011
         END IF
         IF g_azmm.azmm012 IS NULL THEN  #第一期截止日期
            LET l_flag='Y'
            DISPLAY BY NAME g_azmm.azmm012
         END IF
         IF g_azmm.azmm02 ='2' AND g_azmm.azmm131 IS NULL THEN
            LET l_flag='Y'  #第13期起始日期
            DISPLAY BY NAME g_azmm.azmm131
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD azmm01
         END IF
         #TQC-C90084--add--str--
         LET l_n = 0
         SELECT COUNT(*) INTO l_n
           FROM azmm_file
          WHERE azmm00 = g_azmm.azmm00
            AND azmm01 = g_azmm.azmm01 + 1
         IF l_n > 0 THEN
            SELECT azmm011 INTO l_azmm011
              FROM azmm_file
             WHERE azmm00 = g_azmm.azmm00
               AND azmm01 = g_azmm.azmm01 + 1
            IF g_azmm.azmm02 = '1' THEN
               IF g_azmm.azmm122 > l_azmm011 THEN
                  CALL cl_err('','aoo-079',0)
                  NEXT FIELD azmm011
               END IF
            END IF
            IF g_azmm.azmm02 = '2' THEN
               IF g_azmm.azmm132 > l_azmm011 THEN
                  CALL cl_err('','aoo-079',0)
                  NEXT FIELD azmm011
               END IF
            END IF
         END IF
         #TQC-C90084--add--end-- 

        #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(azmm01) THEN
      #      LET g_azmm.* = g_azmm_t.*
      #      DISPLAY BY NAME g_azmm.*
      #      NEXT FIELD azmm01
      #   END IF
        #MOD-650015 --end 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(azmm00)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_aaa"
             CALL cl_create_qry() RETURNING g_azmm.azmm00
             DISPLAY g_azmm.azmm00 TO azmm00
           OTHERWISE EXIT CASE
         END CASE
 
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
 
FUNCTION s021_set_entry(p_cmd)
    DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("azmm01,azmm02",TRUE)
    END IF
 
END FUNCTION
FUNCTION s021_set_no_entry(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("azmm01,azmm02",FALSE)
    END IF
 
 
END FUNCTION
FUNCTION s021_default1()  #預設會計期間
    DEFINE i  LIKE type_file.num5,          #No.FUN-680102 SMALLINT
           j  LIKE type_file.num5,          #No.FUN-680102 SMALLINT
           b_date  LIKE type_file.chr20,          #No.FUN-680102CHAR(20)
           l_date  ARRAY[12] OF LIKE type_file.dat,            #No.FUN-680102DATE
           l_date2 ARRAY[12] OF LIKE type_file.dat             #No.FUN-680102DATE
 
    #輸入'1' 表示一年分12期, 每期以月為單位.
 #  CALL cl_dtoc(g_azmm.azmm011) RETURNING b_date
    LET b_date=g_azmm.azmm011 USING "yyyymmdd"
    FOR i= 1 TO 12
        LET b_date=b_date[1,4],b_date[5,6]+1 USING '&&',b_date[7,8]
        IF b_date[5,6]='13' THEN
           LET b_date=b_date[1,4]+1 USING '&&&&',b_date[5,6]*0+1
               USING '&&',b_date[7,8]
        END IF
        IF b_date[7,8]<>'01' THEN
           LET b_date=b_date[1,4],b_date[5,6],b_date[7,8]*0+1 USING '&&'
        END IF
#       CALL cl_ctod(b_date) RETURNING l_date[i]
        LET l_date[i]=MDY(b_date[5,6],b_date[7,8],b_date[1,4])
        LET l_date2[i]=l_date[i]-1
    END FOR
    LET g_azmm.azmm012=l_date2[1]
    LET g_azmm.azmm021=l_date[1]
    LET g_azmm.azmm022=l_date2[2]
    LET g_azmm.azmm031=l_date[2]
    LET g_azmm.azmm032=l_date2[3]
    LET g_azmm.azmm041=l_date[3]
    LET g_azmm.azmm042=l_date2[4]
    LET g_azmm.azmm051=l_date[4]
    LET g_azmm.azmm052=l_date2[5]
    LET g_azmm.azmm061=l_date[5]
    LET g_azmm.azmm062=l_date2[6]
    LET g_azmm.azmm071=l_date[6]
    LET g_azmm.azmm072=l_date2[7]
    LET g_azmm.azmm081=l_date[7]
    LET g_azmm.azmm082=l_date2[8]
    LET g_azmm.azmm091=l_date[8]
    LET g_azmm.azmm092=l_date2[9]
    LET g_azmm.azmm101=l_date[9]
    LET g_azmm.azmm102=l_date2[10]
    LET g_azmm.azmm111=l_date[10]
    LET g_azmm.azmm112=l_date2[11]
    LET g_azmm.azmm121=l_date[11]
    LET g_azmm.azmm122=l_date2[12]
  # LET g_azmm.azmm131=l_date[12]
  # LET g_azmm.azmm132=l_date2[13]
    LET g_azmm.azmm013=1
    LET g_azmm.azmm023=1
    LET g_azmm.azmm033=1
    LET g_azmm.azmm043=2
    LET g_azmm.azmm053=2
    LET g_azmm.azmm063=2
    LET g_azmm.azmm073=3
    LET g_azmm.azmm083=3
    LET g_azmm.azmm093=3
    LET g_azmm.azmm103=4
    LET g_azmm.azmm113=4
    LET g_azmm.azmm123=4
  # LET g_azmm.azmm133=4
 
    DISPLAY BY NAME g_azmm.azmm011,g_azmm.azmm012,g_azmm.azmm013,
                    g_azmm.azmm021,g_azmm.azmm022,g_azmm.azmm023,
                    g_azmm.azmm031,g_azmm.azmm032,g_azmm.azmm033,
                    g_azmm.azmm041,g_azmm.azmm042,g_azmm.azmm043,
                    g_azmm.azmm051,g_azmm.azmm052,g_azmm.azmm053,
                    g_azmm.azmm061,g_azmm.azmm062,g_azmm.azmm063,
                    g_azmm.azmm071,g_azmm.azmm072,g_azmm.azmm073,
                    g_azmm.azmm081,g_azmm.azmm082,g_azmm.azmm083,
                    g_azmm.azmm091,g_azmm.azmm092,g_azmm.azmm093,
                    g_azmm.azmm101,g_azmm.azmm102,g_azmm.azmm103,
                    g_azmm.azmm111,g_azmm.azmm112,g_azmm.azmm113,
                    g_azmm.azmm121,g_azmm.azmm122,g_azmm.azmm123,
                    g_azmm.azmm131,g_azmm.azmm132,g_azmm.azmm133
 
END FUNCTION
 
FUNCTION s021_default2()    #預設會計期間
    DEFINE l_date LIKE type_file.chr20,          #No.FUN-680102CHAR(20)
           f_date LIKE type_file.dat             #No.FUN-680102DATE
    #輸入'2' 表示一年分13期, 每期以 4週為單位.
    LET g_azmm.azmm012=g_azmm.azmm011+27   #FUN-660217 add
    LET g_azmm.azmm021=g_azmm.azmm012+1
    LET g_azmm.azmm022=g_azmm.azmm021+27
    LET g_azmm.azmm031=g_azmm.azmm022+1
    LET g_azmm.azmm032=g_azmm.azmm031+27
    LET g_azmm.azmm041=g_azmm.azmm032+1
    LET g_azmm.azmm042=g_azmm.azmm041+27
    LET g_azmm.azmm051=g_azmm.azmm042+1
    LET g_azmm.azmm052=g_azmm.azmm051+27
    LET g_azmm.azmm061=g_azmm.azmm052+1
    LET g_azmm.azmm062=g_azmm.azmm061+27
    LET g_azmm.azmm071=g_azmm.azmm062+1
    LET g_azmm.azmm072=g_azmm.azmm071+27
    LET g_azmm.azmm081=g_azmm.azmm072+1
    LET g_azmm.azmm082=g_azmm.azmm081+27
    LET g_azmm.azmm091=g_azmm.azmm082+1
    LET g_azmm.azmm092=g_azmm.azmm091+27
    LET g_azmm.azmm101=g_azmm.azmm092+1
    LET g_azmm.azmm102=g_azmm.azmm101+27
    LET g_azmm.azmm111=g_azmm.azmm102+1
    LET g_azmm.azmm112=g_azmm.azmm111+27
    LET g_azmm.azmm121=g_azmm.azmm112+1
    LET g_azmm.azmm122=g_azmm.azmm121+27
    LET g_azmm.azmm131=g_azmm.azmm122+1
  # CALL cl_dtoc(g_azmm.azmm011) RETURNING l_date
    LET l_date=g_azmm.azmm011 USING "yyyymmdd"
         LET l_date=l_date[1,4]+1 USING '&&&&',l_date[5,6],l_date[7,8]
    LET f_date=MDY(l_date[5,6],l_date[7,8],l_date[1,4])
    LET g_azmm.azmm132=f_date-1   #最後一期截止日期為第一期起始日期加一年減一天
    LET g_azmm.azmm013=1
    LET g_azmm.azmm023=1
    LET g_azmm.azmm033=1
    LET g_azmm.azmm043=2
    LET g_azmm.azmm053=2
    LET g_azmm.azmm063=2
    LET g_azmm.azmm073=3
    LET g_azmm.azmm083=3
    LET g_azmm.azmm093=3
    LET g_azmm.azmm103=4
    LET g_azmm.azmm113=4
    LET g_azmm.azmm123=4
    LET g_azmm.azmm133=4
 
    DISPLAY BY NAME g_azmm.azmm011,g_azmm.azmm012,g_azmm.azmm013,
                    g_azmm.azmm021,g_azmm.azmm022,g_azmm.azmm023,
                    g_azmm.azmm031,g_azmm.azmm032,g_azmm.azmm033,
                    g_azmm.azmm041,g_azmm.azmm042,g_azmm.azmm043,
                    g_azmm.azmm051,g_azmm.azmm052,g_azmm.azmm053,
                    g_azmm.azmm061,g_azmm.azmm062,g_azmm.azmm063,
                    g_azmm.azmm071,g_azmm.azmm072,g_azmm.azmm073,
                    g_azmm.azmm081,g_azmm.azmm082,g_azmm.azmm083,
                    g_azmm.azmm091,g_azmm.azmm092,g_azmm.azmm093,
                    g_azmm.azmm101,g_azmm.azmm102,g_azmm.azmm103,
                    g_azmm.azmm111,g_azmm.azmm112,g_azmm.azmm113,
                    g_azmm.azmm121,g_azmm.azmm122,g_azmm.azmm123,
                    g_azmm.azmm131,g_azmm.azmm132,g_azmm.azmm133
 
END FUNCTION
 
FUNCTION s021_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s021_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_azmm.* TO NULL
        RETURN
    END IF
    OPEN s021_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azmm.azmm01,SQLCA.sqlcode,0)
        INITIALIZE g_azmm.* TO NULL
    ELSE
       OPEN s021_count
       FETCH s021_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL s021_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION s021_fetch(p_flazmm)
    DEFINE
        p_flazmm        LIKE type_file.chr1,           #No.FUN-680102CHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680102 INTEGER
 
    CASE p_flazmm
        WHEN 'N' FETCH NEXT     s021_curs INTO g_azmm.azmm00,g_azmm.azmm01
        WHEN 'P' FETCH PREVIOUS s021_curs INTO g_azmm.azmm00,g_azmm.azmm01
        WHEN 'F' FETCH FIRST    s021_curs INTO g_azmm.azmm00,g_azmm.azmm01
        WHEN 'L' FETCH LAST     s021_curs INTO g_azmm.azmm00,g_azmm.azmm01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump s021_curs INTO g_azmm.azmm00,g_azmm.azmm01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azmm.azmm01,SQLCA.sqlcode,0)
        INITIALIZE g_azmm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flazmm
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_azmm.* FROM azmm_file            # 重讀DB,因TEMP有不被更新特性
       WHERE azmm00=g_azmm.azmm00 AND azmm01=g_azmm.azmm01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","azmm_file",g_azmm.azmm00,g_azmm.azmm01,SQLCA.sqlcode,"","",0)    #No.FUN-660131
    ELSE
 
        CALL s021_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION s021_show()
 
    LET g_azmm_t.* = g_azmm.*
    #No.FUN-9A0024--begin   
    #DISPLAY BY NAME g_azmm.*  
    DISPLAY BY NAME g_azmm.azmm00,g_azmm.azmm01,g_azmm.azmm02,g_azmm.azmm011,g_azmm.azmm012,g_azmm.azmm013,g_azmm.azmm021,g_azmm.azmm022,g_azmm.azmm023,
                    g_azmm.azmm031,g_azmm.azmm032,g_azmm.azmm033,g_azmm.azmm041,g_azmm.azmm042,g_azmm.azmm043,g_azmm.azmm051,g_azmm.azmm052,g_azmm.azmm053,
                    g_azmm.azmm061,g_azmm.azmm062,g_azmm.azmm063,g_azmm.azmm071,g_azmm.azmm072,g_azmm.azmm073,g_azmm.azmm081,g_azmm.azmm082,g_azmm.azmm083,
                    g_azmm.azmm091,g_azmm.azmm092,g_azmm.azmm093,g_azmm.azmm101,g_azmm.azmm102,g_azmm.azmm103,g_azmm.azmm111,g_azmm.azmm112,g_azmm.azmm113,
                    g_azmm.azmm121,g_azmm.azmm122,g_azmm.azmm123,g_azmm.azmm131,g_azmm.azmm132
    #No.FUN-9A0024--end 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s021_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
    DEFINE l_cnt   LIKE type_file.num5       #MOD-A60102 
      
    IF g_azmm.azmm00 IS NULL AND g_azmm.azmm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_azmm.azmm00 IS NULL OR g_azmm.azmm01 IS NULL THEN
       CALL cl_err('',"-16310",0)
    END IF
    BEGIN WORK
    OPEN s021_curl USING g_azmm.azmm00,g_azmm.azmm01
    IF STATUS  THEN CALL cl_err('OPEN s021_curl',STATUS,1) RETURN END IF
    FETCH s021_curl INTO g_azmm.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azmm.azmm01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL s021_show()
    IF cl_delete() THEN
      #-MOD-A60102-add-
      #MOD-C40050 mark start -----
      #LET l_cnt = 0
      #SELECT COUNT(*) INTO l_cnt 
      #  FROM azm_file
      # WHERE azm01 = g_azmm.azmm01 
      #IF l_cnt > 0 THEN
      #   DELETE FROM azm_file 
      #         WHERE azm01 = g_azmm.azmm01 
      #   IF SQLCA.SQLERRD[3]=0 THEN
      #      CALL cl_err3("del","azm_file","",g_azmm.azmm01,SQLCA.sqlcode,"","",0)   
      #   END IF 
      #END IF 
      #MOD-C40050 mark end   -----
      #-MOD-A60102-end-
        DELETE
            FROM azmm_file
                  WHERE azmm00=g_azmm.azmm00
                  AND azmm01=g_azmm.azmm01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","azmm_file",g_azmm.azmm00,g_azmm.azmm01,SQLCA.sqlcode,"","",0)    #No.FUN-660131
         # LET g_azmm.azmmacti=g_chr
        ELSE
          #MOD-C40050 add start -----
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM azm_file WHERE azm01 = g_azmm.azmm01
          IF l_cnt > 0 THEN
             SELECT COUNT(*) INTO l_cnt FROM azmm_file WHERE azmm01 = g_azmm.azmm01
             IF l_cnt = 0 THEN
                DELETE FROM azm_file WHERE azm01 = g_azmm.azmm01
                IF SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err3("del","azm_file","",g_azmm.azmm01,SQLCA.sqlcode,"","",0)
                END IF
             END IF
          END IF
          #MOD-C40050 add end   -----
           CLEAR FORM
           OPEN s021_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE s021_curs
              CLOSE s021_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH s021_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE s021_curs
              CLOSE s021_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN s021_curs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL s021_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL s021_fetch('/')
           END IF
        END IF
    END IF
    CLOSE s021_curl
    COMMIT WORK
END FUNCTION
 
#檢查起始日期與截止日期是否存在于其他帳套中
#No.TQC-6C0229--begin-- mark
#該段函數做保留，另做日期期間判斷函數于此函數下。
#FUNCTION s021_check(l_no,l_year,l_sdate,l_edate,l_q)
#DEFINE l_sdate     LIKE type_file.dat,             #起始日期        #No.FUN-680102DATE
#       l_edate     LIKE type_file.dat,         #截止日期      #No.FUN-680102DATE
#       l_no        LIKE type_file.chr5,          #No.FUN-680102CHAR(5)
#       l_year      LIKE type_file.num5,           #No.FUN-680102SMALLINT
#       l_q         LIKE type_file.chr2,    #期別 #No.FUN-680102CHAR(2)
#       l_n         LIKE type_file.num5,          #No.FUN-680102 SMALLINT
#       l_azmm      RECORD LIKE azmm_file.*,
#       l_sql       STRING,    
#       l_success   LIKE type_file.chr1            #No.FUN-680102CHAR(1)
#      
#   LET l_n = NULL
#   LET l_success = NULL
#   LET l_sql="SELECT azmm",l_q CLIPPED,"1,azmm",l_q CLIPPED,"2 ",
#             "  FROM azmm_file WHERE azmm00<>'",l_no CLIPPED,"'",
#             "   AND azmm01 =",l_year
#   PREPARE s021_pre1 FROM l_sql
#   DECLARE s021_cs1 CURSOR FOR s021_pre1  
# 
#   CASE 
#     WHEN l_q=01    #第一期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm011,l_azmm.azmm012
#       IF ((l_azmm.azmm011=l_sdate AND l_azmm.azmm012) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm011!=l_sdate OR l_azmm.azmm012!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=02    #第二期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm021,l_azmm.azmm022
#       IF ((l_azmm.azmm021=l_sdate AND l_azmm.azmm022) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm021!=l_sdate OR l_azmm.azmm022!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=03    #第三期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm031,l_azmm.azmm032
#       IF ((l_azmm.azmm031=l_sdate AND l_azmm.azmm032) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm031!=l_sdate OR l_azmm.azmm032!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=04     #第四期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm041,l_azmm.azmm042
#       IF ((l_azmm.azmm041=l_sdate AND l_azmm.azmm042) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm041!=l_sdate OR l_azmm.azmm042!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=05     #第五期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm051,l_azmm.azmm052
#       IF ((l_azmm.azmm051=l_sdate AND l_azmm.azmm052) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm051!=l_sdate OR l_azmm.azmm052!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=06     #第六期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm061,l_azmm.azmm062
#       IF ((l_azmm.azmm061=l_sdate AND l_azmm.azmm062) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm061!=l_sdate OR l_azmm.azmm062!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=07     #第七期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm071,l_azmm.azmm072
#       IF ((l_azmm.azmm071=l_sdate AND l_azmm.azmm072) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm071!=l_sdate OR l_azmm.azmm072!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=08     #第八期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm081,l_azmm.azmm082
#       IF ((l_azmm.azmm081=l_sdate AND l_azmm.azmm082) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm081!=l_sdate OR l_azmm.azmm082!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=09     #第九期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm091,l_azmm.azmm092
#       IF ((l_azmm.azmm091=l_sdate AND l_azmm.azmm092) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm091!=l_sdate OR l_azmm.azmm092!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=10    #第十期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm101,l_azmm.azmm102
#       IF ((l_azmm.azmm101=l_sdate AND l_azmm.azmm102) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm101!=l_sdate OR l_azmm.azmm102!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=11    #第十一期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm111,l_azmm.azmm112
#       IF ((l_azmm.azmm111=l_sdate AND l_azmm.azmm112) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm111!=l_sdate OR l_azmm.azmm112!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=12    #第十二期
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm121,l_azmm.azmm122
#       IF ((l_azmm.azmm121=l_sdate AND l_azmm.azmm122) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm121!=l_sdate OR l_azmm.azmm122!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     WHEN l_q=13
#       OPEN s021_cs1
#       FETCH s021_cs1 INTO l_azmm.azmm131,l_azmm.azmm132
#       IF ((l_azmm.azmm131=l_sdate AND l_azmm.azmm132) OR (SQLCA.sqlcode=100)) THEN
#          LET l_success='Y'
#       END IF
#       IF (SQLCA.sqlcode=0 AND (l_azmm.azmm131!=l_sdate OR l_azmm.azmm132!=l_edate)) THEN
#          CALL cl_err('',"aoo-300",0)
#          LET l_success='N'
#       END IF
#     OTHERWISE EXIT CASE
#   END CASE
#
#RETURN l_success
#CLOSE s021_cs1
#
#END FUNCTION
#No.TQC-6C0229--end-- mark
#判斷日期區間是否存在于其他帳套中，但期間數不必與其他帳套對應。
#No.TQC-6C0229--begin-- add
FUNCTION s021_check(l_no,l_year,l_sdate,l_edate)
DEFINE         l_azmm     RECORD LIKE azmm_file.*
DEFINE         l_no       LIKE type_file.chr5
DEFINE         l_year     LIKE type_file.num5
DEFINE         l_sdate    LIKE type_file.dat
DEFINE         l_edate    LIKE type_file.dat
DEFINE         l_sdate1   LIKE type_file.chr10
DEFINE         l_edate1   LIKE type_file.chr10
DEFINE         l_success  LIKE type_file.chr1
DEFINE         l_sql      STRING 
DEFINE         l_azmm011  LIKE type_file.chr10
DEFINE         l_azmm012  LIKE type_file.chr10
DEFINE         l_azmm021  LIKE type_file.chr10
DEFINE         l_azmm022  LIKE type_file.chr10
DEFINE         l_azmm031  LIKE type_file.chr10
DEFINE         l_azmm032  LIKE type_file.chr10
DEFINE         l_azmm041  LIKE type_file.chr10
DEFINE         l_azmm042  LIKE type_file.chr10
DEFINE         l_azmm051  LIKE type_file.chr10
DEFINE         l_azmm052  LIKE type_file.chr10
DEFINE         l_azmm061  LIKE type_file.chr10
DEFINE         l_azmm062  LIKE type_file.chr10
DEFINE         l_azmm071  LIKE type_file.chr10
DEFINE         l_azmm072  LIKE type_file.chr10
DEFINE         l_azmm081  LIKE type_file.chr10
DEFINE         l_azmm082  LIKE type_file.chr10
DEFINE         l_azmm091  LIKE type_file.chr10
DEFINE         l_azmm092  LIKE type_file.chr10
DEFINE         l_azmm101  LIKE type_file.chr10
DEFINE         l_azmm102  LIKE type_file.chr10
DEFINE         l_azmm111  LIKE type_file.chr10
DEFINE         l_azmm112  LIKE type_file.chr10
DEFINE         l_azmm121  LIKE type_file.chr10
DEFINE         l_azmm122  LIKE type_file.chr10
DEFINE         l_azmm131  LIKE type_file.chr10
DEFINE         l_azmm132  LIKE type_file.chr10
 
    LET l_success = NULL
    IF YEAR(l_sdate)!=l_year AND YEAR(l_sdate)!=l_year+1 THEN  
       CALL cl_err('','aoo-020',0)
       LET l_success='N'
       RETURN l_success
    END IF 
    IF YEAR(l_edate)!=l_year AND YEAR(l_edate)!=l_year+1 THEN
       CALL cl_err('','aoo-020',0)
       LET l_success='N'
       RETURN l_success
    END IF
    LET l_sdate1=l_sdate
    LET l_edate1=l_edate 
    LET l_sql = "SELECT azmm011,azmm012,azmm021,azmm022,azmm031,azmm032,azmm041,",
                "       azmm042,azmm051,azmm052,azmm061,azmm062,azmm071,azmm072,",
                "       azmm081,azmm082,azmm091,azmm092,azmm101,azmm102,azmm111,",
                "       azmm112,azmm121,azmm122,azmm131,azmm132 ",
                "  FROM azmm_file ",
                " WHERE azmm00<>'",l_no CLIPPED,"'",
                "   AND azmm01=",l_year
    PREPARE s021_pre1 FROM l_sql
    DECLARE s021_cs1  CURSOR FOR s021_pre1 
    OPEN s021_cs1
    FETCH s021_cs1 INTO l_azmm.azmm011,l_azmm.azmm012,l_azmm.azmm021,l_azmm.azmm022,
                        l_azmm.azmm031,l_azmm.azmm032,l_azmm.azmm041,l_azmm.azmm042,
                        l_azmm.azmm051,l_azmm.azmm052,l_azmm.azmm061,l_azmm.azmm062,
                        l_azmm.azmm071,l_azmm.azmm072,l_azmm.azmm081,l_azmm.azmm082,
                        l_azmm.azmm091,l_azmm.azmm092,l_azmm.azmm101,l_azmm.azmm102,
                        l_azmm.azmm111,l_azmm.azmm112,l_azmm.azmm121,l_azmm.azmm122,
                        l_azmm.azmm131,l_azmm.azmm132
    LET l_azmm011 = l_azmm.azmm011   LET l_azmm012 = l_azmm.azmm012
    LET l_azmm021 = l_azmm.azmm021   LET l_azmm022 = l_azmm.azmm022
    LET l_azmm031 = l_azmm.azmm031   LET l_azmm032 = l_azmm.azmm032
    LET l_azmm041 = l_azmm.azmm041   LET l_azmm042 = l_azmm.azmm042
    LET l_azmm051 = l_azmm.azmm051   LET l_azmm052 = l_azmm.azmm052
    LET l_azmm061 = l_azmm.azmm061   LET l_azmm062 = l_azmm.azmm062
    LET l_azmm071 = l_azmm.azmm071   LET l_azmm072 = l_azmm.azmm072
    LET l_azmm081 = l_azmm.azmm081   LET l_azmm082 = l_azmm.azmm082
    LET l_azmm091 = l_azmm.azmm091   LET l_azmm092 = l_azmm.azmm092
    LET l_azmm101 = l_azmm.azmm101   LET l_azmm102 = l_azmm.azmm102
    LET l_azmm111 = l_azmm.azmm111   LET l_azmm112 = l_azmm.azmm112
    LET l_azmm121 = l_azmm.azmm121   LET l_azmm122 = l_azmm.azmm122
    LET l_azmm131 = l_azmm.azmm131   LET l_azmm132 = l_azmm.azmm132
    IF (l_sdate1[6,10]=l_azmm011[6,10] AND l_edate1[6,10]=l_azmm012[6,10]) OR 
       (l_sdate1[6,10]=l_azmm021[6,10] AND l_edate1[6,10]=l_azmm022[6,10]) OR 
       (l_sdate1[6,10]=l_azmm031[6,10] AND l_edate1[6,10]=l_azmm032[6,10]) OR 
       (l_sdate1[6,10]=l_azmm041[6,10] AND l_edate1[6,10]=l_azmm042[6,10]) OR 
       (l_sdate1[6,10]=l_azmm051[6,10] AND l_edate1[6,10]=l_azmm052[6,10]) OR 
       (l_sdate1[6,10]=l_azmm061[6,10] AND l_edate1[6,10]=l_azmm062[6,10]) OR 
       (l_sdate1[6,10]=l_azmm071[6,10] AND l_edate1[6,10]=l_azmm072[6,10]) OR 
       (l_sdate1[6,10]=l_azmm081[6,10] AND l_edate1[6,10]=l_azmm082[6,10]) OR 
       (l_sdate1[6,10]=l_azmm091[6,10] AND l_edate1[6,10]=l_azmm092[6,10]) OR 
       (l_sdate1[6,10]=l_azmm101[6,10] AND l_edate1[6,10]=l_azmm102[6,10]) OR 
       (l_sdate1[6,10]=l_azmm111[6,10] AND l_edate1[6,10]=l_azmm112[6,10]) OR 
       (l_sdate1[6,10]=l_azmm121[6,10] AND l_edate1[6,10]=l_azmm122[6,10]) OR 
       (l_sdate1[6,10]=l_azmm131[6,10] AND l_edate1[6,10]=l_azmm132[6,10]) OR 
       (SQLCA.sqlcode=100) THEN 
       LET l_success='Y'
    ELSE 
    	 LET l_success='N'
       CALL cl_err('','aoo-300',0)
    END IF 
 
    RETURN l_success
    CLOSE s021_cs1
    
END FUNCTION
#No.TQC-6C0229--end-- add
 
FUNCTION s021_period()
DEFINE tm          RECORD
           azmm00  LIKE azmm_file.azmm00,   
           azmm01  LIKE azmm_file.azmm01    
                   END RECORD
DEFINE l_azmm      RECORD LIKE azmm_file.*
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE l_n         LIKE type_file.num5,         #No.FUN-680102 SMALLINT
       l_sql       STRING,    
       l_flag      LIKE type_file.chr1,         #No.FUN-680102 VARCHAR(1)
       l_flag1     LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
DEFINE l_aaaacti   LIKE aaa_file.aaaacti        #No.FUN-790009
 
   #No.FUN-790009  --Begin
   #CALL s021_update_azm來更新azm_file
   #No.FUN-790009  --End  
 
   LET p_row = 2 LET p_col = 2 
   OPEN WINDOW s021_1_w AT p_row,p_col WITH FORM "aoo/42f/aoos021_1" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()  
   CALL cl_opmsg('p') 
 
   LET tm.azmm00=NULL
   LET INT_FLAG = 0
 
   WHILE TRUE
      INPUT BY NAME tm.azmm00,tm.azmm01 WITHOUT DEFAULTS
         
          BEFORE INPUT
            IF (NOT cl_null(g_azmm.azmm00)) AND (NOT cl_null(g_azmm.azmm01)) THEN
                LET tm.azmm00=g_azmm.azmm00
                LET tm.azmm01=g_azmm.azmm01
                DISPLAY BY NAME tm.azmm00,tm.azmm01
            END IF 
         
          AFTER FIELD azmm00
            #No.FUN-790009  --Begin
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=tm.azmm00
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",tm.azmm00,"","anm-062","","",1)
               NEXT FIELD azmm00
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(tm.azmm00,"9028",1)
               NEXT FIELD azmm00
            END IF
            #No.FUN-790009  --End  
            #TQC-B20031--begin
            IF NOT cl_null(tm.azmm00) THEN 
               IF tm.azmm00 !=g_aza.aza81 THEN 
                  CALL cl_err('','aoo-312',1)
                  NEXT FIELD azmm00
               END IF 
            END IF  
            #TQC-B20031--end
          ON ACTION CONTROLP
            CASE
              WHEN INFIELD(azmm00)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aaa"
                CALL cl_create_qry() RETURNING tm.azmm00
                DISPLAY tm.azmm00 TO azmm00
              OTHERWISE EXIT CASE
            END CASE             
   
         ON ACTION about    
            CALL cl_about()
                                                                                                                                       
         ON ACTION help   
            CALL cl_show_help()
   
         ON ACTION exit                                                                                                            
            LET INT_FLAG = 1                                                                                                          
            EXIT INPUT     
   
     #TQC-860019-add
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     #TQC-860019-add
 
      END INPUT 
     
      BEGIN WORK 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         ROLLBACK WORK
         CLOSE WINDOW s021_1_w 
         RETURN
      END IF
   
      #No.FUN-790009  --Begin
      IF cl_confirm("abx-080") THEN
         #TQC-B20031--begin
         IF tm.azmm00 !=g_aza.aza81 THEN 
            CALL cl_err('','aoo-312',1)
            CLOSE WINDOW s021_1_w 
            RETURN 
         END IF 
         #TQC-B20031--end
         LET g_success = 'Y'
         CALL s021_update_azm(tm.azmm00,tm.azmm01)
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag 
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE 
            EXIT WHILE
         END IF
      END IF
      #No.FUN-790009  --End
   END WHILE
   CLOSE WINDOW s021_1_w
END FUNCTION
 
FUNCTION s021_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        sr RECORD LIKE azmm_file.*,
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE za_file.za05,        #No.FUN-680102 VARCHAR(40)
        l_chr           LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
       LET g_wc=" azmm01='",g_azmm.azmm01,"'"
    END IF
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 's021.out'
    CALL cl_outnam('aoos021') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM azmm_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
#No.FUN-760083 --begin--
{
    PREPARE s021_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE s021_curo                         # SCROLL CURSOR
         CURSOR FOR s021_p1
 
    START REPORT s021_rep TO l_name
 
    FOREACH s021_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT s021_rep(sr.*)
    END FOREACH
 
    FINISH REPORT s021_rep
 
    CLOSE s021_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
}
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05='Y' THEN 
       CALL cl_wcchp(g_wc,'azmm00,azmm01, azmm02, azmm011,azmm012,azmm013,azmm021,                                                                                                                     
                           azmm022,azmm023,azmm031,azmm032,azmm033,azmm041,                                                                            
                           azmm042,azmm043,azmm051,azmm052,azmm053,azmm061,                                                                            
                           azmm062,azmm063,azmm071,azmm072,azmm073,azmm081,                                                                            
                           azmm082,azmm083,azmm091,azmm092,azmm093,azmm101,                                                                            
                           azmm102,azmm103,azmm111,azmm112,azmm113,azmm121,                                                                            
                           azmm122,azmm123,azmm131,azmm132,azmm133 ')
       RETURNING g_wc
    END IF
    LET g_str=''
    LET g_str=g_wc
    CALL cl_prt_cs1("aoos021","aoos021",g_sql,g_str)
#No.FUN-760083 --END--
END FUNCTION
 
#No.FUN-760083 --BEGIN--
{
REPORT s021_rep(sr)
    DEFINE
        i    LIKE type_file.num5,                   #No.FUN-680102 SMALLINT
        l_trailer_sw    LIKE type_file.chr1,        #No.FUN-680102CHAR(1)
        sr RECORD LIKE azmm_file.*,
        l_chr           LIKE type_file.chr1         #No.FUN-680102 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.azmm01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT g_dash[1,g_len]
            SKIP 2 LINE
            PRINT g_x[13] CLIPPED,sr.azmm00
            PRINT g_x[11] CLIPPED,
                  COLUMN 6,sr.azmm01,
                  COLUMN 15,g_x[12] CLIPPED,
                  COLUMN 48,sr.azmm02
            SKIP 2 LINE
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
            PRINT g_dash1
            SKIP 1 LINE
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.azmm01
           IF (PAGENO>1 OR LINENO>9) THEN
              SKIP TO TOP OF PAGE
           END IF
        ON EVERY ROW
           PRINT COLUMN (g_c[31]+4),' 1',
                 COLUMN g_c[32],sr.azmm011,
                 COLUMN g_c[33],sr.azmm012,
                 COLUMN g_c[34],sr.azmm013
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 2',
                 COLUMN g_c[32],sr.azmm021,
                 COLUMN g_c[33],sr.azmm022,
                 COLUMN g_c[34],sr.azmm023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 3',
                 COLUMN g_c[32],sr.azmm031,
                 COLUMN g_c[33],sr.azmm032,
                 COLUMN g_c[34],sr.azmm033
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 4',
                 COLUMN g_c[32],sr.azmm041,
                 COLUMN g_c[33],sr.azmm042,
                 COLUMN g_c[34],sr.azmm043
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 5',
                 COLUMN g_c[32],sr.azmm051,
                 COLUMN g_c[33],sr.azmm052,
                 COLUMN g_c[34],sr.azmm053
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 6',
                 COLUMN g_c[32],sr.azmm061,
                 COLUMN g_c[33],sr.azmm062,
                 COLUMN g_c[34],sr.azmm063
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 7',
                 COLUMN g_c[32],sr.azmm071,
                 COLUMN g_c[33],sr.azmm072,
                 COLUMN g_c[34],sr.azmm073
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 8',
                 COLUMN g_c[32],sr.azmm081,
                 COLUMN g_c[33],sr.azmm082,
                 COLUMN g_c[34],sr.azmm083
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 9',
                 COLUMN g_c[32],sr.azmm091,
                 COLUMN g_c[33],sr.azmm092,
                 COLUMN g_c[34],sr.azmm093
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),'10',
                 COLUMN g_c[32],sr.azmm101,
                 COLUMN g_c[33],sr.azmm102,
                 COLUMN g_c[34],sr.azmm103
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),'11',
                 COLUMN g_c[32],sr.azmm111,
                 COLUMN g_c[33],sr.azmm112,
                 COLUMN g_c[34],sr.azmm113
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),'12',
                 COLUMN g_c[32],sr.azmm121,
                 COLUMN g_c[33],sr.azmm122,
                 COLUMN g_c[34],sr.azmm123
           SKIP 1 LINE
           IF sr.azmm02='2' THEN
           PRINT COLUMN (g_c[31]+4),'13',
                 COLUMN g_c[32],sr.azmm131,
                 COLUMN g_c[33],sr.azmm132,
                 COLUMN g_c[34],sr.azmm133
           SKIP 1 LINE
           END IF
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
#NO.TQC-630166 start--
#                    IF g_wc[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    IF g_wc[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                     CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end---
            END IF
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
#No.FUN-760083  --END--
 
#No.FUN-730020  --Begin
FUNCTION s021_gen()
#No.FUN-740033  --Begin
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_azmm00  LIKE azmm_file.azmm00
DEFINE l_azmm01  LIKE azmm_file.azmm01
 
  #No.FUN-790009  --Begin
#No.TQC-7B0046 --begin
#  IF cl_null(g_wc) THEN
#     LET g_wc = " 1=1"
#  END IF
#No.TQC-7B0046 --end
  #No.FUN-790009  --End
  LET g_sql = "SELECT UNIQUE azmm00,azmm01 FROM azmm_file",
#             " WHERE ",g_wc CLIPPED
              " WHERE azmm00 ='",g_azmm.azmm00,"' AND azmm01 ='",g_azmm.azmm01,"'"    #No.TQC-7B0046
  PREPARE s021_tna_prepare FROM g_sql
  DECLARE s021_tna_curs CURSOR FOR s021_tna_prepare
  BEGIN WORK
  FOREACH s021_tna_curs INTO l_azmm00,l_azmm01
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach',SQLCA.sqlcode,1)
        ROLLBACK WORK
        RETURN
     END IF
     LET l_cnt=0
     IF l_azmm00 = g_aza.aza81 THEN
        SELECT COUNT(*) INTO l_cnt FROM tna_file
#        WHERE tna00 = '0' AND tna01 = l_azmm01 AND tna02 = l_azmm00
         WHERE tna00 = '0' AND tna01 = l_azmm01     #No.TQC-7B0046   
        IF l_cnt = 0 THEN
           INSERT INTO tna_file(tna00,tna01,tna02) VALUES('0',l_azmm01,l_azmm00)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tna_file",l_azmm01,l_azmm00,SQLCA.sqlcode,"ins tna","",1)
              ROLLBACK WORK
              RETURN
           END IF
#No.TQC-7B0046 --begin
        ELSE
           IF (cl_confirm("aoo-304")) THEN
              DELETE FROM tna_file WHERE tna00 = '0' AND tna01 = l_azmm01
              INSERT INTO tna_file(tna00,tna01,tna02) VALUES('0',l_azmm01,l_azmm00)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","tna_file",l_azmm01,l_azmm00,SQLCA.sqlcode,"ins tna","",1)
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
#No.TQC-7B0046 --end
        END IF
     END IF
     IF l_azmm00 = g_aza.aza82 THEN
        SELECT COUNT(*) INTO l_cnt FROM tna_file
#        WHERE tna00 = '1' AND tna01 = l_azmm01 AND tna02 = l_azmm00
         WHERE tna00 = '1' AND tna01 = l_azmm01     #No.MOD-B10023
        IF l_cnt = 0 THEN
           INSERT INTO tna_file(tna00,tna01,tna02) VALUES('1',l_azmm01,l_azmm00)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tna_file",l_azmm01,l_azmm00,SQLCA.sqlcode,"ins tna","",1)
              ROLLBACK WORK
              RETURN
           END IF
#No.TQC-7B0046 --begin
        ELSE
           IF (cl_confirm("aoo-304")) THEN
              DELETE FROM tna_file WHERE tna00 = '1' AND tna01 = l_azmm01  #No.MOD-B10023
              INSERT INTO tna_file(tna00,tna01,tna02) VALUES('1',l_azmm01,l_azmm00)  #No.MOD-B10023
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","tna_file",l_azmm01,l_azmm00,SQLCA.sqlcode,"ins tna","",1)
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
#No.TQC-7B0046 --end
        END IF
     END IF
  END FOREACH
 
  COMMIT WORK
#No.FUN-740033  --End
 
END FUNCTION
#No.FUN-730020  --End
 
#No.FUN-790009  --Begin
#更新azm_file
FUNCTION s021_update_azm(p_azmm00,p_azmm01)
  DEFINE p_azmm00    LIKE azmm_file.azmm00
  DEFINE p_azmm01    LIKE azmm_file.azmm01
  DEFINE l_azmm      RECORD LIKE azmm_file.*
  DEFINE l_n         LIKE type_file.num5
 
      SELECT * INTO l_azmm.* FROM azmm_file
       WHERE azmm00=p_azmm00 AND azmm01=p_azmm01     
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","azmm_file",p_azmm00,p_azmm01,SQLCA.SQLCODE,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
 
      SELECT COUNT(*) INTO l_n FROM azm_file
       WHERE azm01=l_azmm.azmm01 AND azm02=l_azmm.azmm02
      IF l_n>0 THEN
        #IF cl_confirm("aoo-229") THEN     #MOD-A60102 mark
            LET g_sql="UPDATE azm_file ",
                      " SET azm011=?,azm012=?,azm013=?, ",
                      " azm021=?,azm022=?,azm023=?,azm031=?,azm032=?,azm033=?,",
                      " azm041=?,azm042=?,azm043=?,azm051=?,azm052=?,azm053=?,",
                      " azm061=?,azm062=?,azm063=?,azm071=?,azm072=?,azm073=?,",
                      " azm081=?,azm082=?,azm083=?,azm091=?,azm092=?,azm093=?,",
                      " azm101=?,azm102=?,azm103=?,azm111=?,azm112=?,azm113=?,",
                      " azm121=?,azm122=?,azm123=?,azm131=?,azm132=?,azm133=?",
                      " WHERE azm01=? AND azm02=?"
            PREPARE ins_azm_p FROM g_sql
            EXECUTE ins_azm_p USING
                    l_azmm.azmm011,l_azmm.azmm012,l_azmm.azmm023,
                    l_azmm.azmm021,l_azmm.azmm022,l_azmm.azmm023,
                    l_azmm.azmm031,l_azmm.azmm032,l_azmm.azmm033,
                    l_azmm.azmm041,l_azmm.azmm042,l_azmm.azmm043,
                    l_azmm.azmm051,l_azmm.azmm052,l_azmm.azmm053,
                    l_azmm.azmm061,l_azmm.azmm062,l_azmm.azmm063,
                    l_azmm.azmm071,l_azmm.azmm072,l_azmm.azmm073,
                    l_azmm.azmm081,l_azmm.azmm082,l_azmm.azmm083,
                    l_azmm.azmm091,l_azmm.azmm092,l_azmm.azmm093,
                    l_azmm.azmm101,l_azmm.azmm102,l_azmm.azmm103,
                    l_azmm.azmm111,l_azmm.azmm112,l_azmm.azmm113,
                    l_azmm.azmm121,l_azmm.azmm122,l_azmm.azmm123,
                    l_azmm.azmm131,l_azmm.azmm132,l_azmm.azmm133,
                    l_azmm.azmm01,l_azmm.azmm02
            IF SQLCA.SQLCODE THEN
               CALL cl_err3('upd','azm_file',l_azmm.azmm01,'',SQLCA.sqlcode,'upd azm','',1)
               LET g_success = 'N'
               RETURN
            END IF
        #ELSE          #MOD-A60102 mark
        #   RETURN     #MOD-A60102 mark
        #END IF        #MOD-A60102 mark
      ELSE
         LET g_sql="INSERT INTO azm_file ",
                   "(azm01,azm02,azm011,azm012,azm013, ",
                   " azm021,azm022,azm023,azm031,azm032,azm033,",
                   " azm041,azm042,azm043,azm051,azm052,azm053,",
                   " azm061,azm062,azm063,azm071,azm072,azm073,",
                   " azm081,azm082,azm083,azm091,azm092,azm093,",
                   " azm101,azm102,azm103,azm111,azm112,azm113,",
                   " azm121,azm122,azm123,azm131,azm132,azm133)",
                   " VALUES(?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?,",
                   "        ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?,",
                   "        ?,?,?,?,?,?)"
         PREPARE ins_azm_p1 FROM g_sql
         EXECUTE ins_azm_p1 USING
              l_azmm.azmm01,l_azmm.azmm02,
              l_azmm.azmm011,l_azmm.azmm012,l_azmm.azmm023,
              l_azmm.azmm021,l_azmm.azmm022,l_azmm.azmm023,
              l_azmm.azmm031,l_azmm.azmm032,l_azmm.azmm033,
              l_azmm.azmm041,l_azmm.azmm042,l_azmm.azmm043,
              l_azmm.azmm051,l_azmm.azmm052,l_azmm.azmm053,
              l_azmm.azmm061,l_azmm.azmm062,l_azmm.azmm063,
              l_azmm.azmm071,l_azmm.azmm072,l_azmm.azmm073,
              l_azmm.azmm081,l_azmm.azmm082,l_azmm.azmm083,
              l_azmm.azmm091,l_azmm.azmm092,l_azmm.azmm093,
              l_azmm.azmm101,l_azmm.azmm102,l_azmm.azmm103,
              l_azmm.azmm111,l_azmm.azmm112,l_azmm.azmm113,
              l_azmm.azmm121,l_azmm.azmm122,l_azmm.azmm123,
              l_azmm.azmm131,l_azmm.azmm132,l_azmm.azmm133
         IF SQLCA.SQLCODE THEN
            CALL cl_err3('ins','azm_file',l_azmm.azmm01,'',SQLCA.sqlcode,'ins azm','',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
END FUNCTION
#No.FUN-790009  --End  
