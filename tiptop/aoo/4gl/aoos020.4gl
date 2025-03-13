# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aoos020.4gl
# Descriptions...: 會計期間參數設定
# Date & Author..: 91/08/27 By Lin
# Note...........: cl_dtoc & cl_ctod 已經不再使用了
# Modify.........: No.FUN-510027 05/02/22 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-660217 06/07/03 By Sarah 改成在AFTER FIELD azm011裡CALL s020_default2()
# Modify.........: No.TQC-620021 06/07/11 By Smapmin g_azm已定義於top.global
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0023 06/11/13 By baogui 季別未右對齊
# Modify.........: No.CHI-690001 06/11/23 By Claire 期別 default aoos010 (aza02)
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/12 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-790009 07/09/04 By Carrier 去掉_a()/_r(),資料維護入口為aoos021
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50039 11/07/04 By xianghui 增加自訂欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    #g_azm   RECORD LIKE azm_file.*,   #TQC-620021
    g_azm_t  RECORD LIKE azm_file.*,
    g_azm01_t LIKE azm_file.azm01,
    g_azm013_t LIKE azm_file.azm013,
    g_azm023_t LIKE azm_file.azm023,
    g_azm033_t LIKE azm_file.azm033,
    g_azm043_t LIKE azm_file.azm043,
    g_azm053_t LIKE azm_file.azm053,
    g_azm063_t LIKE azm_file.azm063,
    g_azm073_t LIKE azm_file.azm073,
    g_azm083_t LIKE azm_file.azm083,
    g_azm093_t LIKE azm_file.azm093,
    g_azm103_t LIKE azm_file.azm103,
    g_azm113_t LIKE azm_file.azm113,
    g_azm123_t LIKE azm_file.azm123,
    g_azm133_t LIKE azm_file.azm133,
#    g_wc,g_sql       VARCHAR(300)  #NO.TQC-630166  MARK     
    g_wc,g_sql        STRING     #NO.TQC-630166        
DEFINE  g_forupd_sql  STRING      
DEFINE  g_before_input_done    LIKE type_file.num5     #No.FUN-680102 SMALLINT
DEFINE  g_i                    LIKE type_file.num5     #count/index for any purpose   #No.FUN-680102 SMALLINT
DEFINE  g_msg           LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   g_str          STRING                       #No.FUN-760083
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0081
    DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
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
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
    INITIALIZE g_azm.* TO NULL
    INITIALIZE g_azm_t.* TO NULL
    LET g_forupd_sql = "SELECT * FROM azm_file WHERE azm01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s020_curl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col =11
    OPEN WINDOW s020_w AT p_row,p_col
        WITH FORM "aoo/42f/aoos020"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
display 'idle time=',g_idle_seconds
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL s020_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s020_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION s020_curs()
    CLEAR FORM
   INITIALIZE g_azm.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        azm01, azm02, azm011,azm012,azm013,azm021,
        azm022,azm023,azm031,azm032,azm033,azm041,
        azm042,azm043,azm051,azm052,azm053,azm061,
        azm062,azm063,azm071,azm072,azm073,azm081,
        azm082,azm083,azm091,azm092,azm093,azm101,
        azm102,azm103,azm111,azm112,azm113,azm121,
        azm122,azm123,azm131,azm132,azm133,
        #FUN-B50039-add-str--
        azmud01,azmud02,azmud03,azmud04,azmud05,
        azmud06,azmud07,azmud08,azmud09,azmud10,
        azmud11,azmud12,azmud13,azmud14,azmud15
        #FUN-B50039-add-end--
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
{   #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND azmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND azmgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND azmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('azmuser', 'azmgrup')
    #End:FUN-980030
 
}
    LET g_sql="SELECT azm01 FROM azm_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY azm01"
    PREPARE s020_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE s020_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR s020_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM azm_file WHERE ",g_wc CLIPPED
    PREPARE s020_precount FROM g_sql
    DECLARE s020_count CURSOR FOR s020_precount
END FUNCTION
 
FUNCTION s020_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
        #No.FUN-790009  --Begin
        #ON ACTION insert
        #    LET g_action_choice="insert"
        #    IF cl_chk_act_auth() THEN
        #         CALL s020_a()
        #    END IF
        #No.FUN-790009  --End  
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL s020_q()
            END IF
        ON ACTION next
            CALL s020_fetch('N')
        ON ACTION previous
            CALL s020_fetch('P')
        #No.FUN-790009  --Begin
        #ON ACTION delete
        #         CALL s020_r()
        #No.FUN-790009  --End  
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL s020_out()
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
            CALL s020_fetch('/')
        ON ACTION first
            CALL s020_fetch('F')
        ON ACTION last
            CALL s020_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
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
    CLOSE s020_curs
END FUNCTION
 
 
FUNCTION s020_a()
  DEFINE ins_sql LIKE type_file.chr1000     #No.FUN-680102CHAR(40) 
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_azm.* LIKE azm_file.*
    LET g_azm01_t = NULL
    LET g_azm_t.*=g_azm.*
    LET g_azm013_t = ''
    LET g_azm023_t = ''
    LET g_azm033_t = ''
    LET g_azm043_t = ''
    LET g_azm053_t = ''
    LET g_azm063_t = ''
    LET g_azm073_t = ''
    LET g_azm083_t = ''
    LET g_azm093_t = ''
    LET g_azm103_t = ''
    LET g_azm113_t = ''
    LET g_azm123_t = ''
    LET g_azm133_t = ''
 
#%  LET g_azm.xxxx = 0				# DEFAULT
    LET g_azm.azm02=g_aza.aza02
    CALL cl_opmsg('a')
#   DECLARE ins_curs CURSOR FOR INSERT INTO azm_file VALUES (g_azm.*)
#   OPEN ins_curs
 
    WHILE TRUE
        CALL s020_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
#           CLOSE ins_curs
            EXIT WHILE
        END IF
        IF g_azm.azm01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO azm_file VALUES(g_azm.*)       # DISK WRITE
#       FLUSH ins_curs
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_azm.azm01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("ins","azm_file",g_azm.azm01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660131
            CONTINUE WHILE
        ELSE
            LET g_azm_t.* = g_azm.*                # 保存上筆資料
            SELECT azm01 INTO g_azm.azm01 FROM azm_file
                WHERE azm01 = g_azm.azm01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
#  CLOSE ins_curs
END FUNCTION
 
FUNCTION s020_i(p_cmd)
   DEFINE   p_cmd              LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
            l_flag             LIKE type_file.chr1,     #判斷必要欄位之值是否有輸入        #No.FUN-680102 VARCHAR(1)
            l_n                LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
 
   #DISPLAY BY NAME g_azm.azmuser,g_azm.azmgrup,g_azm.azmdate, g_azm.azmacti
 
   DISPLAY BY NAME g_azm.azm02   #CHI-690001 add  
 
   INPUT BY NAME
      g_azm.azm01,               #CHI-690001 mark    g_azm.azm02,
      g_azm.azm011,g_azm.azm012,g_azm.azm013,
      g_azm.azm021,g_azm.azm022,g_azm.azm023,
      g_azm.azm031,g_azm.azm032,g_azm.azm033,
      g_azm.azm041,g_azm.azm042,g_azm.azm043,
      g_azm.azm051,g_azm.azm052,g_azm.azm053,
      g_azm.azm061,g_azm.azm062,g_azm.azm063,
      g_azm.azm071,g_azm.azm072,g_azm.azm073,
      g_azm.azm081,g_azm.azm082,g_azm.azm083,
      g_azm.azm091,g_azm.azm092,g_azm.azm093,
      g_azm.azm101,g_azm.azm102,g_azm.azm103,
      g_azm.azm111,g_azm.azm112,g_azm.azm113,
      g_azm.azm121,g_azm.azm122,g_azm.azm123,
      g_azm.azm131,g_azm.azm132,g_azm.azm133,
      #FUN-B50039-add-str--
      g_azm.azmud01,g_azm.azmud02,g_azm.azmud03,
      g_azm.azmud04,g_azm.azmud05,g_azm.azmud06,
      g_azm.azmud07,g_azm.azmud08,g_azm.azmud09,
      g_azm.azmud10,g_azm.azmud11,g_azm.azmud12,
      g_azm.azmud13,g_azm.azmud14,g_azm.azmud15
      #FUN-B50039-add-end--
      WITHOUT DEFAULTS
 
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL s020_set_entry(p_cmd)
            CALL s020_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
{
      BEFORE FIELD azm01    #判斷是否可更改KEY值
         IF p_cmd='u' AND g_chkey='N' THEN
            NEXT FIELD azm011
         END IF
}
      AFTER FIELD azm01
        IF NOT cl_null(g_azm.azm01) THEN
           IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_azm.azm01 != g_azm01_t) THEN
              SELECT count(*) INTO l_n FROM azm_file WHERE azm01 = g_azm.azm01
              IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err(g_azm.azm01,-239,0)
                 LET g_azm.azm01 = g_azm01_t
                 DISPLAY BY NAME g_azm.azm01
                 NEXT FIELD azm01
              END IF
           END IF
        END IF
 
      AFTER FIELD azm011
         IF NOT cl_null(g_azm.azm011) THEN
            IF g_azm.azm02 ='1' AND g_azm.azm012 IS NULL THEN
               CALL s020_default1()
            END IF
           #start FUN-660217 add
            IF g_azm.azm02 ='2' AND g_azm.azm012 IS NULL THEN
               CALL s020_default2()
            END IF
           #end FUN-660217 add
         END IF
 
      AFTER FIELD azm012
         IF NOT cl_null(g_azm.azm012) THEN
           #start FUN-660217 mark
           #IF g_azm.azm02 ='2' AND g_azm.azm021 IS NULL THEN
           #   CALL s020_default2()
           #END IF
           #end FUN-660217 mark
            IF g_azm.azm012 < g_azm.azm011 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm011
            END IF
         END IF
 
      AFTER FIELD azm013
         IF NOT cl_null(g_azm.azm013) THEN
            IF g_azm.azm013 < 1 OR g_azm.azm013 > 4  OR g_azm.azm013 IS NULL THEN
               LET g_azm.azm013=g_azm013_t
               DISPLAY BY NAME g_azm.azm013
               NEXT FIELD azm013
            END IF
         END IF
         LET g_azm013_t=g_azm.azm013
 
      AFTER FIELD azm022
         IF NOT cl_null(g_azm.azm022) THEN
            IF g_azm.azm022 < g_azm.azm021 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm021
            END IF
         END IF
 
      AFTER FIELD azm023
         IF NOT cl_null(g_azm.azm023) THEN
            IF g_azm.azm023 < 1 OR g_azm.azm023 > 4  OR g_azm.azm023 IS NULL THEN
               LET g_azm.azm023=g_azm023_t
               DISPLAY BY NAME g_azm.azm023
               NEXT FIELD azm023
            END IF
         END IF
         LET g_azm023_t=g_azm.azm023
 
      AFTER FIELD azm032
         IF NOT cl_null(g_azm.azm032) THEN
            IF g_azm.azm032 < g_azm.azm031 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm031
            END IF
         END IF
 
      AFTER FIELD azm033
         IF NOT cl_null(g_azm.azm033) THEN
            IF g_azm.azm033 < 1 OR g_azm.azm033 > 4  OR g_azm.azm033 IS NULL THEN
               LET g_azm.azm033=g_azm033_t
               DISPLAY BY NAME g_azm.azm033
               NEXT FIELD azm033
            END IF
         END IF
         LET g_azm033_t=g_azm.azm033
 
      AFTER FIELD azm042
         IF NOT cl_null(g_azm.azm042) THEN
            IF g_azm.azm042 < g_azm.azm041 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm041
            END IF
         END IF
 
      AFTER FIELD azm043
         IF NOT cl_null(g_azm.azm043) THEN
            IF g_azm.azm043 < 1 OR g_azm.azm043 > 4  OR g_azm.azm043 IS NULL THEN
               LET g_azm.azm043=g_azm043_t
               DISPLAY BY NAME g_azm.azm043
               NEXT FIELD azm043
            END IF
         END IF
         LET g_azm043_t=g_azm.azm043
 
      AFTER FIELD azm052
         IF NOT cl_null(g_azm.azm052) THEN
            IF g_azm.azm052 < g_azm.azm051 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm051
            END IF
         END IF
 
      AFTER FIELD azm053
         IF NOT cl_null(g_azm.azm053) THEN
            IF g_azm.azm053 < 1 OR g_azm.azm053 > 4  OR g_azm.azm053 IS NULL THEN
               LET g_azm.azm053=g_azm053_t
               DISPLAY BY NAME g_azm.azm053
               NEXT FIELD azm053
            END IF
         END IF
         LET g_azm053_t=g_azm.azm053
 
      AFTER FIELD azm062
         IF NOT cl_null(g_azm.azm062) THEN
            IF g_azm.azm062 < g_azm.azm061 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm061
            END IF
         END IF
 
      AFTER FIELD azm063
         IF NOT cl_null(g_azm.azm063) THEN
            IF g_azm.azm063 < 1 OR g_azm.azm063 > 4  OR g_azm.azm063 IS NULL THEN
               LET g_azm.azm063=g_azm063_t
               DISPLAY BY NAME g_azm.azm063
               NEXT FIELD azm063
            END IF
         END IF
         LET g_azm063_t=g_azm.azm063
 
      AFTER FIELD azm072
         IF NOT cl_null(g_azm.azm072) THEN
            IF g_azm.azm072 < g_azm.azm071 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm071
            END IF
         END IF
 
      AFTER FIELD azm073
         IF NOT cl_null(g_azm.azm073) THEN
            IF g_azm.azm073 < 1 OR g_azm.azm073 > 4  OR g_azm.azm073 IS NULL THEN
               LET g_azm.azm073=g_azm073_t
               DISPLAY BY NAME g_azm.azm073
               NEXT FIELD azm073
            END IF
         END IF
         LET g_azm073_t=g_azm.azm073
 
      AFTER FIELD azm082
         IF NOT cl_null(g_azm.azm082) THEN
            IF g_azm.azm082 < g_azm.azm081 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm081
            END IF
         END IF
 
      AFTER FIELD azm083
         IF NOT cl_null(g_azm.azm083) THEN
            IF g_azm.azm083 < 1 OR g_azm.azm083 > 4  THEN
               LET g_azm.azm083=g_azm083_t
               DISPLAY BY NAME g_azm.azm083
               NEXT FIELD azm083
            END IF
         END IF
         LET g_azm083_t=g_azm.azm083
 
      AFTER FIELD azm092
         IF NOT cl_null(g_azm.azm092) THEN
            IF g_azm.azm092 < g_azm.azm091 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm091
            END IF
         END IF
 
      AFTER FIELD azm093
         IF NOT cl_null(g_azm.azm093) THEN
            IF g_azm.azm093 < 1 OR g_azm.azm093 > 4  THEN
               LET g_azm.azm093=g_azm093_t
               DISPLAY BY NAME g_azm.azm093
               NEXT FIELD azm093
            END IF
         END IF
         LET g_azm093_t=g_azm.azm093
 
      AFTER FIELD azm102
         IF NOT cl_null(g_azm.azm102) THEN
            IF g_azm.azm102 < g_azm.azm101 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm101
            END IF
         END IF
 
      AFTER FIELD azm103
         IF NOT cl_null(g_azm.azm103) THEN
            IF g_azm.azm103 < 1 OR g_azm.azm103 > 4  THEN
               LET g_azm.azm103=g_azm103_t
               DISPLAY BY NAME g_azm.azm103
               NEXT FIELD azm103
            END IF
         END IF
         LET g_azm103_t=g_azm.azm103
 
      AFTER FIELD azm112
         IF NOT cl_null(g_azm.azm112) THEN
            IF g_azm.azm112 < g_azm.azm111 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm111
            END IF
         END IF
 
      AFTER FIELD azm113
         IF NOT cl_null(g_azm.azm113) THEN
            IF g_azm.azm113 < 1 OR g_azm.azm113 > 4  THEN
               LET g_azm.azm113=g_azm113_t
               DISPLAY BY NAME g_azm.azm113
               NEXT FIELD azm113
            END IF
         END IF
         LET g_azm113_t=g_azm.azm113
 
      AFTER FIELD azm122
         IF NOT cl_null(g_azm.azm122) THEN
            IF g_azm.azm122 < g_azm.azm121 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm121
            END IF
         END IF
 
      AFTER FIELD azm123
         IF NOT cl_null(g_azm.azm123) THEN
            IF g_azm.azm123 < 1 OR g_azm.azm123 > 4  THEN
               LET g_azm.azm123=g_azm123_t
               DISPLAY BY NAME g_azm.azm123
               NEXT FIELD azm123
            END IF
         END IF
         LET g_azm123_t=g_azm.azm123
 
      BEFORE FIELD azm131
         IF g_azm.azm02 = '1' THEN
            CALL cl_err(g_azm.azm131,'aoo-058',0)
            EXIT INPUT
         END IF
 
      AFTER FIELD azm132
         IF NOT cl_null(g_azm.azm132) THEN
            IF g_azm.azm132 < g_azm.azm131 THEN
               CALL cl_err('','aoo-065',0)
               NEXT FIELD azm131
            END IF
         END IF
 
      AFTER FIELD azm133
         IF NOT cl_null(g_azm.azm133) THEN
            IF g_azm.azm133 < 1 OR g_azm.azm133 > 4  THEN
               LET g_azm.azm133=g_azm133_t
               DISPLAY BY NAME g_azm.azm133
               NEXT FIELD azm133
            END IF
         END IF
         LET g_azm133_t=g_azm.azm133
 
      #FUN-B50039-add-str--
      AFTER FIELD apzud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD azmud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--


      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_azm.azm01 IS NULL  OR g_azm.azm01=' ' THEN #會計年度
            LET l_flag='Y'
            DISPLAY BY NAME g_azm.azm01
         END IF
         IF g_azm.azm02 NOT MATCHES "[12]" OR g_azm.azm02 IS NULL THEN
            LET l_flag='Y'    #會計期間分類方式
            DISPLAY BY NAME g_azm.azm02
         END IF
         IF g_azm.azm011 IS NULL THEN  #第一期起始日期
            LET l_flag='Y'
            DISPLAY BY NAME g_azm.azm011
         END IF
         IF g_azm.azm012 IS NULL THEN  #第一期截止日期
            LET l_flag='Y'
            DISPLAY BY NAME g_azm.azm012
         END IF
         IF g_azm.azm02 ='2' AND g_azm.azm131 IS NULL THEN
            LET l_flag='Y'  #第13期起始日期
            DISPLAY BY NAME g_azm.azm131
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD azm01
         END IF
 
        #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(azm01) THEN
      #      LET g_azm.* = g_azm_t.*
      #      DISPLAY BY NAME g_azm.*
      #      NEXT FIELD azm01
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
FUNCTION s020_set_entry(p_cmd)
    DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("azm01,azm02",TRUE)
    END IF
 
END FUNCTION
FUNCTION s020_set_no_entry(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("azm01,azm02",FALSE)
    END IF
 
 
END FUNCTION
FUNCTION s020_default1()  #預設會計期間
    DEFINE i  LIKE type_file.num5,          #No.FUN-680102 SMALLINT
           j  LIKE type_file.num5,          #No.FUN-680102 SMALLINT
           b_date LIKE type_file.chr8,              #No.FUN-680102CHAR(8)
           l_date  ARRAY[12] OF LIKE type_file.dat,            #No.FUN-680102DATE
           l_date2 ARRAY[12] OF LIKE type_file.dat             #No.FUN-680102DATE
 
    #輸入'1' 表示一年分12期, 每期以月為單位.
 #  CALL cl_dtoc(g_azm.azm011) RETURNING b_date
    LET b_date=g_azm.azm011 USING "yyyymmdd"
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
    LET g_azm.azm012=l_date2[1]
    LET g_azm.azm021=l_date[1]
    LET g_azm.azm022=l_date2[2]
    LET g_azm.azm031=l_date[2]
    LET g_azm.azm032=l_date2[3]
    LET g_azm.azm041=l_date[3]
    LET g_azm.azm042=l_date2[4]
    LET g_azm.azm051=l_date[4]
    LET g_azm.azm052=l_date2[5]
    LET g_azm.azm061=l_date[5]
    LET g_azm.azm062=l_date2[6]
    LET g_azm.azm071=l_date[6]
    LET g_azm.azm072=l_date2[7]
    LET g_azm.azm081=l_date[7]
    LET g_azm.azm082=l_date2[8]
    LET g_azm.azm091=l_date[8]
    LET g_azm.azm092=l_date2[9]
    LET g_azm.azm101=l_date[9]
    LET g_azm.azm102=l_date2[10]
    LET g_azm.azm111=l_date[10]
    LET g_azm.azm112=l_date2[11]
    LET g_azm.azm121=l_date[11]
    LET g_azm.azm122=l_date2[12]
  # LET g_azm.azm131=l_date[12]
  # LET g_azm.azm132=l_date2[13]
    LET g_azm.azm013=1
    LET g_azm.azm023=1
    LET g_azm.azm033=1
    LET g_azm.azm043=2
    LET g_azm.azm053=2
    LET g_azm.azm063=2
    LET g_azm.azm073=3
    LET g_azm.azm083=3
    LET g_azm.azm093=3
    LET g_azm.azm103=4
    LET g_azm.azm113=4
    LET g_azm.azm123=4
  # LET g_azm.azm133=4
 
    DISPLAY BY NAME g_azm.azm011,g_azm.azm012,g_azm.azm013,
                    g_azm.azm021,g_azm.azm022,g_azm.azm023,
                    g_azm.azm031,g_azm.azm032,g_azm.azm033,
                    g_azm.azm041,g_azm.azm042,g_azm.azm043,
                    g_azm.azm051,g_azm.azm052,g_azm.azm053,
                    g_azm.azm061,g_azm.azm062,g_azm.azm063,
                    g_azm.azm071,g_azm.azm072,g_azm.azm073,
                    g_azm.azm081,g_azm.azm082,g_azm.azm083,
                    g_azm.azm091,g_azm.azm092,g_azm.azm093,
                    g_azm.azm101,g_azm.azm102,g_azm.azm103,
                    g_azm.azm111,g_azm.azm112,g_azm.azm113,
                    g_azm.azm121,g_azm.azm122,g_azm.azm123,
                    g_azm.azm131,g_azm.azm132,g_azm.azm133
 
END FUNCTION
 
FUNCTION s020_default2()    #預設會計期間
    DEFINE l_date LIKE type_file.chr8,           #No.FUN-680102CHAR(8),
           f_date LIKE type_file.dat             #No.FUN-680102DATE
 
    #輸入'2' 表示一年分13期, 每期以 4週為單位.
    LET g_azm.azm012=g_azm.azm011+27   #FUN-660217 add
    LET g_azm.azm021=g_azm.azm012+1
    LET g_azm.azm022=g_azm.azm021+27
    LET g_azm.azm031=g_azm.azm022+1
    LET g_azm.azm032=g_azm.azm031+27
    LET g_azm.azm041=g_azm.azm032+1
    LET g_azm.azm042=g_azm.azm041+27
    LET g_azm.azm051=g_azm.azm042+1
    LET g_azm.azm052=g_azm.azm051+27
    LET g_azm.azm061=g_azm.azm052+1
    LET g_azm.azm062=g_azm.azm061+27
    LET g_azm.azm071=g_azm.azm062+1
    LET g_azm.azm072=g_azm.azm071+27
    LET g_azm.azm081=g_azm.azm072+1
    LET g_azm.azm082=g_azm.azm081+27
    LET g_azm.azm091=g_azm.azm082+1
    LET g_azm.azm092=g_azm.azm091+27
    LET g_azm.azm101=g_azm.azm092+1
    LET g_azm.azm102=g_azm.azm101+27
    LET g_azm.azm111=g_azm.azm102+1
    LET g_azm.azm112=g_azm.azm111+27
    LET g_azm.azm121=g_azm.azm112+1
    LET g_azm.azm122=g_azm.azm121+27
    LET g_azm.azm131=g_azm.azm122+1
  # CALL cl_dtoc(g_azm.azm011) RETURNING l_date
    LET l_date=g_azm.azm011 USING "yyyymmdd"
         LET l_date=l_date[1,4]+1 USING '&&&&',l_date[5,6],l_date[7,8]
    LET f_date=MDY(l_date[5,6],l_date[7,8],l_date[1,4])
    LET g_azm.azm132=f_date-1   #最後一期截止日期為第一期起始日期加一年減一天
    LET g_azm.azm013=1
    LET g_azm.azm023=1
    LET g_azm.azm033=1
    LET g_azm.azm043=2
    LET g_azm.azm053=2
    LET g_azm.azm063=2
    LET g_azm.azm073=3
    LET g_azm.azm083=3
    LET g_azm.azm093=3
    LET g_azm.azm103=4
    LET g_azm.azm113=4
    LET g_azm.azm123=4
    LET g_azm.azm133=4
 
    DISPLAY BY NAME g_azm.azm011,g_azm.azm012,g_azm.azm013,
                    g_azm.azm021,g_azm.azm022,g_azm.azm023,
                    g_azm.azm031,g_azm.azm032,g_azm.azm033,
                    g_azm.azm041,g_azm.azm042,g_azm.azm043,
                    g_azm.azm051,g_azm.azm052,g_azm.azm053,
                    g_azm.azm061,g_azm.azm062,g_azm.azm063,
                    g_azm.azm071,g_azm.azm072,g_azm.azm073,
                    g_azm.azm081,g_azm.azm082,g_azm.azm083,
                    g_azm.azm091,g_azm.azm092,g_azm.azm093,
                    g_azm.azm101,g_azm.azm102,g_azm.azm103,
                    g_azm.azm111,g_azm.azm112,g_azm.azm113,
                    g_azm.azm121,g_azm.azm122,g_azm.azm123,
                    g_azm.azm131,g_azm.azm132,g_azm.azm133
 
END FUNCTION
 
FUNCTION s020_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s020_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN s020_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azm.azm01,SQLCA.sqlcode,0)
        INITIALIZE g_azm.* TO NULL
    ELSE
       OPEN s020_count
       FETCH s020_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL s020_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION s020_fetch(p_flazm)
    DEFINE
        p_flazm         LIKE type_file.chr1,         #No.FUN-680102CHAR(01),
        l_abso          LIKE type_file.num10         #No.FUN-680102 INTEGER
 
    CASE p_flazm
        WHEN 'N' FETCH NEXT     s020_curs INTO g_azm.azm01
        WHEN 'P' FETCH PREVIOUS s020_curs INTO g_azm.azm01
        WHEN 'F' FETCH FIRST    s020_curs INTO g_azm.azm01
        WHEN 'L' FETCH LAST     s020_curs INTO g_azm.azm01
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
            FETCH ABSOLUTE g_jump s020_curs INTO g_azm.azm01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azm.azm01,SQLCA.sqlcode,0)
        INITIALIZE g_azm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flazm
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_azm.* FROM azm_file            # 重讀DB,因TEMP有不被更新特性
       WHERE azm01 = g_azm.azm01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_azm.azm01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("sel","azm_file",g_azm.azm01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660131
    ELSE
 
        CALL s020_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION s020_show()
    LET g_azm_t.* = g_azm.*
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_azm.*  
   DISPLAY BY NAME g_azm.azm01,g_azm.azm02,g_azm.azm011,g_azm.azm012,g_azm.azm013,g_azm.azm021,g_azm.azm022,g_azm.azm023,
                   g_azm.azm031,g_azm.azm032,g_azm.azm033,g_azm.azm041,g_azm.azm042,g_azm.azm043,g_azm.azm051,g_azm.azm052,g_azm.azm053,
                   g_azm.azm061,g_azm.azm062,g_azm.azm063,g_azm.azm071,g_azm.azm072,g_azm.azm073,g_azm.azm081,g_azm.azm082,g_azm.azm083,
                   g_azm.azm091,g_azm.azm092,g_azm.azm093,g_azm.azm101,g_azm.azm102,g_azm.azm103,g_azm.azm111,g_azm.azm112,g_azm.azm113,
                   g_azm.azm121,g_azm.azm122,g_azm.azm123,g_azm.azm131,g_azm.azm132,
                   #FUN-B50039-add-str--
                   g_azm.azmud01,g_azm.azmud12,g_azm.azmud03,g_azm.azmud04,g_azm.azmud05,
                   g_azm.azmud06,g_azm.azmud07,g_azm.azmud08,g_azm.azmud09,g_azm.azmud10,
                   g_azm.azmud11,g_azm.azmud12,g_azm.azmud13,g_azm.azmud14,g_azm.azmud15
                   #FUN-B50039-add-end--
   #No.FUN-9A0024--end     
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s020_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF g_azm.azm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN s020_curl USING g_azm.azm01
    IF STATUS  THEN CALL cl_err('OPEN s020_curl',STATUS,1) RETURN END IF
    FETCH s020_curl INTO g_azm.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_azm.azm01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL s020_show()
    IF cl_delete() THEN
        DELETE
            FROM azm_file
                  WHERE azm01=g_azm.azm01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_azm.azm01,SQLCA.sqlcode,0)   #No.FUN-660131
           CALL cl_err3("del","azm_file",g_azm.azm01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660131
         # LET g_azm.azmacti=g_chr
        ELSE
           CLEAR FORM
           OPEN s020_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE s020_curl
              CLOSE s020_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH s020_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE s020_curl
              CLOSE s020_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN s020_curs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL s020_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL s020_fetch('/')
           END IF
        END IF
    END IF
    CLOSE s020_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION s020_out()
    DEFINE
        l_i             LIKE type_file.num5,                 #No.FUN-680102 SMALLINT
        sr RECORD LIKE azm_file.*,
        l_name          LIKE type_file.chr20,                 # External(Disk) file name   #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,               #No.FUN-680102 VARCHAR(40)
        l_chr           LIKE type_file.chr1                   #No.FUN-680102 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
       LET g_wc=" azm01='",g_azm.azm01,"'"
    END IF
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 's020.out'
    CALL cl_outnam('aoos020') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM azm_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
#No.FUN-760083 --BEGIN--
{
    PREPARE s020_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE s020_curo                         # SCROLL CURSOR
         CURSOR FOR s020_p1
 
    START REPORT s020_rep TO l_name
 
    FOREACH s020_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT s020_rep(sr.*)
    END FOREACH
 
    FINISH REPORT s020_rep
 
    CLOSE s020_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
}
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05='Y' THEN 
       CALL cl_wcchp(g_wc,'azm01,azm02,azm011,azm012,azm013,azm021,
                           azm022,azm023,azm031,azm032,azm033,azm041, 
                           azm042,azm043,azm051,azm052,azm053,azm061,
                           azm062,azm063,azm071,azm072,azm073,azm081,
                           azm082,azm083,azm091,azm092,azm093,azm101,  
                           azm102,azm103,azm111,azm112,azm113,azm121,
                           azm122,azm123,azm131,azm132,azm133')                                                          
       RETURNING g_wc
    END IF
    LET g_str=g_wc
    CALL cl_prt_cs1("aoos020","aoos020",g_sql,g_str)
#No.FUN-760083  --end--
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT s020_rep(sr)
    DEFINE
        i               LIKE type_file.num5,    #No.FUN-680102 SMALLINT
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE azm_file.*,
        l_chr           LIKE type_file.chr1     #No.FUN-680102 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.azm01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT g_dash[1,g_len]
            SKIP 2 LINE
            PRINT g_x[11] CLIPPED,
                  COLUMN 6,sr.azm01,
                  COLUMN 15,g_x[12] CLIPPED,
                  COLUMN 48,sr.azm02
            SKIP 2 LINE
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
            PRINT g_dash1
            SKIP 1 LINE
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.azm01
           IF (PAGENO>1 OR LINENO>9) THEN
              SKIP TO TOP OF PAGE
           END IF
        ON EVERY ROW
           PRINT COLUMN (g_c[31]+4),' 1',
                 COLUMN g_c[32],sr.azm011,
                 COLUMN g_c[33],sr.azm012,
                 COLUMN g_c[34],cl_numfor(sr.azm013,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 2',
                 COLUMN g_c[32],sr.azm021,
                 COLUMN g_c[33],sr.azm022,
                 COLUMN g_c[34],cl_numfor(sr.azm023,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 3',
                 COLUMN g_c[32],sr.azm031,
                 COLUMN g_c[33],sr.azm032,
                 COLUMN g_c[34],cl_numfor(sr.azm033,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 4',
                 COLUMN g_c[32],sr.azm041,
                 COLUMN g_c[33],sr.azm042,
                 COLUMN g_c[34],cl_numfor(sr.azm043,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 5',
                 COLUMN g_c[32],sr.azm051,
                 COLUMN g_c[33],sr.azm052,
                 COLUMN g_c[34],cl_numfor(sr.azm053,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 6',
                 COLUMN g_c[32],sr.azm061,
                 COLUMN g_c[33],sr.azm062,
                 COLUMN g_c[34],cl_numfor(sr.azm063,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 7',
                 COLUMN g_c[32],sr.azm071,
                 COLUMN g_c[33],sr.azm072,
                 COLUMN g_c[34],cl_numfor(sr.azm073,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 8',
                 COLUMN g_c[32],sr.azm081,
                 COLUMN g_c[33],sr.azm082,
                 COLUMN g_c[34],cl_numfor(sr.azm083,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),' 9',
                 COLUMN g_c[32],sr.azm091,
                 COLUMN g_c[33],sr.azm092,
                 COLUMN g_c[34],cl_numfor(sr.azm093,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),'10',
                 COLUMN g_c[32],sr.azm101,
                 COLUMN g_c[33],sr.azm102,
                 COLUMN g_c[34],cl_numfor(sr.azm103,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),'11',
                 COLUMN g_c[32],sr.azm111,
                 COLUMN g_c[33],sr.azm112,
                 COLUMN g_c[34],cl_numfor(sr.azm113,34,0)    #TQC-6B0023
           SKIP 1 LINE
           PRINT COLUMN (g_c[31]+4),'12',
                 COLUMN g_c[32],sr.azm121,
                 COLUMN g_c[33],sr.azm122,
                 COLUMN g_c[34],cl_numfor(sr.azm123,34,0)    #TQC-6B0023
           SKIP 1 LINE
           IF sr.azm02='2' THEN
           PRINT COLUMN (g_c[31]+4),'13',
                 COLUMN g_c[32],sr.azm131,
                 COLUMN g_c[33],sr.azm132,
                 COLUMN g_c[34],cl_numfor(sr.azm133,34,0)    #TQC-6B0023
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
#No.FUN-760083  --end--
