# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apjt110.4gl
# Descriptions...: 專案基本資料維護作業
# Date & Author..: No.FUN-790025 07/10/26 By douzh
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830139 08/03/25 By douzh apji700 串ACTION增加接受參數
# Modify.........: No.TQC-840009 08/04/01 By douzh 處理ACTION名稱名稱
# Modify.........: No.TQC-840046 08/04/18 By douzh 邏輯管控加嚴(已審核的資料只可維護ACTION,不可更新資料)
# Modify.........: No.FUN-840141 08/04/21 By rainy 查詢時,單頭欄位只有專案代號可以下條件,太少了~
# Modify.........: No.MOD-840470 08/04/22 By douzh 本層編碼(pjb05)的欄位舊值相等時管控問題
# Modify.........: no.MOD-840479 08/04/28 by yiting pjaconf要己確認才能維護單身
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-8C0079 08/12/15 By clover 開放可查詢"確認"及"結案"狀態
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-920058 09/02/24 By xiaofeizhu 錄入函數處的pjb01改為pja01
# Modify.........: No.FUN-940066 09/04/10 By David Lee 與Microsoft Office Project集成
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-A50007 10/05/14 By Summer abg-503訊息改用amr-100
# Modify.........: No:TQC-A70016 10/07/05 By Carrier 删除功能的提示更改为 lib-357
# Modify.........: No:MOD-A70207 10/07/28 By Sarah 當l_ac>0時才串到apjt110_b
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-C10146 12/02/09 By jt_chen 修正呼叫權限類別公用函式,傳遞參數的錯誤 oea 改為 pja
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE 
    g_pjb01         LIKE pjb_file.pjb01,
    g_pjb01_t       LIKE pjb_file.pjb01,
    g_pja           RECORD   LIKE pja_file.*,
    g_pja_t         RECORD   LIKE pja_file.*,
    g_pjb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    pjb04     LIKE pjb_file.pjb04,
                    pjb05     LIKE pjb_file.pjb05,
                    pjb06     LIKE pjb_file.pjb06,
                    pjb02     LIKE pjb_file.pjb02,
                    pjb03     LIKE pjb_file.pjb03,
                    pjb07     LIKE pjb_file.pjb07,
                    pjb08     LIKE pjb_file.pjb08,
                    pjb09     LIKE pjb_file.pjb09,
                    pjb25     LIKE pjb_file.pjb25,
                    pjb10     LIKE pjb_file.pjb10,
                    pjb11     LIKE pjb_file.pjb11,
                    pjb12     LIKE pjb_file.pjb12,
                    pjb13     LIKE pjb_file.pjb13,
                    pjb14     LIKE pjb_file.pjb14,
                    pjb21     LIKE pjb_file.pjb21,
                    pjbacti   LIKE pjb_file.pjbacti
                    END RECORD,
    g_pjb_t         RECORD    #程式變數(Program Variables)
                    pjb04     LIKE pjb_file.pjb04,
                    pjb05     LIKE pjb_file.pjb05,
                    pjb06     LIKE pjb_file.pjb06,
                    pjb02     LIKE pjb_file.pjb02,
                    pjb03     LIKE pjb_file.pjb03,
                    pjb07     LIKE pjb_file.pjb07,
                    pjb08     LIKE pjb_file.pjb08,
                    pjb09     LIKE pjb_file.pjb09,
                    pjb25     LIKE pjb_file.pjb25,
                    pjb10     LIKE pjb_file.pjb10,
                    pjb11     LIKE pjb_file.pjb11,
                    pjb12     LIKE pjb_file.pjb12,
                    pjb13     LIKE pjb_file.pjb13,
                    pjb14     LIKE pjb_file.pjb14,
                    pjb21     LIKE pjb_file.pjb21,
                    pjbacti   LIKE pjb_file.pjbacti
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,     #NO.TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數  
    g_buf           LIKE pjb_file.pjb01,  
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  
    l_cmd           LIKE type_file.chr1000  
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   
DEFINE g_cnt        LIKE type_file.num10   
DEFINE g_chr        LIKE type_file.chr1   
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose
DEFINE g_msg        LIKE type_file.chr1000 
DEFINE g_row_count  LIKE type_file.num10
DEFINE g_curs_index LIKE type_file.num10 
DEFINE g_jump       LIKE type_file.num10  
DEFINE g_no_ask     LIKE type_file.num5    
DEFINE g_pjz        RECORD LIKE pjz_file.*
DEFINE g_argv1      LIKE pja_file.pja01      #No.FUN-830139
DEFINE g_cn         LIKE type_file.num5      #No.FUN-830139 
DEFINE g_pjb16      LIKE pjb_file.pjb16 

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT * INTO g_pjz.* FROM pjz_file 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                 
 
   LET g_forupd_sql = "SELECT pjb01 FROM pjb_file WHERE pjb01 = ? FOR UPDATE"                                                           
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1 = ARG_VAL(1)                       #No.FUN-830139
 
   OPEN WINDOW t110_w WITH FORM "apj/42f/apjt110"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
        
   IF g_argv1 IS NOT NULL THEN 
      SELECT count(*) INTO g_cn FROM pjb_file WHERE pjb01 = g_argv1
      IF g_cn > 0 THEN
         CALL t110_q()
      ELSE
         CALL t110_pjb01('d')
         CALL t110_b()
      END IF
   END IF
 
   CALL t110_menu()
 
   CLOSE WINDOW t110_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           
END MAIN
 
 
FUNCTION t110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
 
  CLEAR FORM                             #清除畫面
  IF cl_null(g_argv1) THEN               #No.FUN-830139 add  by douzh 
    CALL g_pjb.clear()
    CALL cl_set_head_visible("","YES")    
 
    WHILE TRUE
       CONSTRUCT BY NAME g_wc ON pja01,pja03,pja02,pja04,pja05,
                                 pja06,pja08,pja07,pja09,pja10,
                                 pja11,pja12,pja21,pjaconf,pjaclose    #FUN-8C0079
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE
              WHEN INFIELD(pja01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pja"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pja01
                 NEXT FIELD pja07
              WHEN INFIELD(pja07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjq"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pja07
                 NEXT FIELD pja07
              WHEN INFIELD(pja08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pja08
                 NEXT FIELD pja08
              WHEN INFIELD(pja09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pja09
                 NEXT FIELD pja09
            END CASE
       END CONSTRUCT
 
       IF INT_FLAG THEN RETURN END IF
       EXIT WHILE
    END WHILE
              
 
    CONSTRUCT g_wc2 ON 
                      pjb04,pjb05,pjb06,pjb02,pjb03,pjb07,
                      pjb08,pjb09,pjb25,pjb10,pjb11,pjb12,pjb13,
                      pjb14,pjb21,pjbacti
                 FROM 
                      s_pjb[1].pjb04,s_pjb[1].pjb05,s_pjb[1].pjb06,
                      s_pjb[1].pjb02,s_pjb[1].pjb03,s_pjb[1].pjb07,
                      s_pjb[1].pjb08,s_pjb[1].pjb09,s_pjb[1].pjb25,s_pjb[1].pjb10,
                      s_pjb[1].pjb11,s_pjb[1].pjb12,s_pjb[1].pjb13,
                      s_pjb[1].pjb14,s_pjb[1].pjb21,s_pjb[1].pjbacti
     
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
    END CONSTRUCT
  IF INT_FLAG THEN RETURN END IF 
    #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')         #MOD-C10146 mark
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')         #MOD-C10146 add 
  ELSE                                                           #No.FUN-830139
    LET g_wc="pja01='",g_argv1,"'"                               #No.FUN-830139 
    LET g_wc2 = " 1=1"
  END IF                                                         #No.FUN-830139 
 
 
 
  IF INT_FLAG THEN RETURN END IF
 
  IF g_wc2 = " 1=1"  THEN			# 若單身未輸入條件
     LET g_sql = "SELECT  pja01 FROM pja_file",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY pja01"  
  ELSE
     LET g_sql = "SELECT UNIQUE pja_file. pja01 ",
              "  FROM pja_file, pjb_file",
              " WHERE pja01 = pjb01 ",
              "   AND ",g_wc CLIPPED ,
              "   AND ", g_wc2 CLIPPED
  END IF
 
  PREPARE t110_prepare FROM g_sql
  DECLARE t110_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t110_prepare
 
 
  IF g_wc2 = " 1=1"  THEN			# 取合乎條件筆數
     LET g_sql="SELECT COUNT(*) FROM pja_file ",
               " WHERE ", g_wc CLIPPED
  ELSE
     LET g_sql="SELECT COUNT(DISTINCT pja01) ",
               "  FROM pja_file,pjb_file ",
               " WHERE pjb01=pja01 ",
               "   AND ",g_wc CLIPPED,
               "   AND ",g_wc2 CLIPPED
  END IF
 
  PREPARE t110_precount FROM g_sql
  DECLARE t110_count CURSOR FOR t110_precount
 
END FUNCTION
 
FUNCTION t110_menu()
 
   WHILE TRUE
      CALL t110_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t110_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t110_r()
            END IF
 
          WHEN "b_more" 
             IF cl_chk_act_auth() THEN
                IF l_ac > 0 THEN   #MOD-A70207 add
                   IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
                      LET l_cmd="apjt110_b '",g_pjb01,"' "              
                      CALL cl_cmdrun_wait(l_cmd)
                   END IF
                END IF             #MOD-A70207 add
             END IF
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL t110_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjb),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pjb01 IS NOT NULL THEN
                 LET g_doc.column1 = "pjb01"
                 LET g_doc.value1 = g_pjb01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
#Insert 錄入
FUNCTION t110_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_pjb.clear()
 
   INITIALIZE g_pjb01    LIKE pjb_file.pjb01
   INITIALIZE g_pja.*    LIKE pja_file.*
    
   CALL cl_opmsg('a')
 
   WHILE TRUE
 
      CALL t110_i('a')
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_pjb01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      CALL t110_b()                          # 輸入單身
      LET g_pjb01_t=g_pjb01
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
#Query 查詢
FUNCTION t110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
 
    CALL t110_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_pja.* TO NULL
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
    OPEN t110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_pjb01 = NULL 
       INITIALIZE g_pja.* TO NULL
    ELSE
       OPEN t110_count
       FETCH t110_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL t110_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t110_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式  
    l_pjbuser       LIKE pjb_file.pjbuser,  
    l_pjbgrup       LIKE pjb_file.pjbgrup   
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     t110_cs INTO g_pjb01
    WHEN 'P' FETCH PREVIOUS t110_cs INTO g_pjb01
    WHEN 'F' FETCH FIRST    t110_cs INTO g_pjb01
    WHEN 'L' FETCH LAST     t110_cs INTO g_pjb01
    WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0 
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
            FETCH ABSOLUTE g_jump t110_cs INTO g_pjb01
            LET g_no_ask = FALSE
  END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjb01,SQLCA.sqlcode,0)
        INITIALIZE g_pja.* TO NULL            
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT UNIQUE pja01 INTO g_pjb01
      FROM pja_file 
     WHERE pja01 = g_pjb01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","pja_file",g_pjb01,"",SQLCA.sqlcode,"","",1) 
       INITIALIZE g_pjb01 TO NULL
       RETURN
    END IF
    LET g_data_owner = l_pjbuser     
    LET g_data_group = l_pjbgrup    
    CALL t110_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t110_show()
 
    LET g_pja_t.* = g_pja.*                #保存單頭舊值
    DISPLAY g_pjb01
         TO pjb01
                    
    CALL t110_pjb01('d')
    CALL t110_b_fill(g_wc2)                 #單身  #FUN-840141
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t110_pjb01(p_cmd)
DEFINE  
    p_cmd           LIKE type_file.chr1                  #處理狀態 
DEFINE   l_gen02    LIKE gen_file.gen02
DEFINE   l_gem02    LIKE gem_file.gem02
 
    LET g_errno = " "
 
    IF g_argv1 IS NOT NULL THEN
       SELECT * INTO g_pja.* FROM pja_file
        WHERE pja01=g_argv1 AND pjaacti='Y'
    ELSE
       SELECT * INTO g_pja.* FROM pja_file
        WHERE pja01=g_pjb01 AND pjaacti='Y'
    END IF
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
         WHEN g_pja.pjaacti='N' LET g_errno = '9028'
         WHEN g_pja.pjaclose = 'Y' LET g_errno = 'amr-100' #FUN-960038 #CHI-A50007 mod abg-503->amr-100
         OTHERWISE   LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_pja.pja08
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_pja.pja09
 
    IF cl_null(g_errno) OR p_cmd ='d' THEN
       IF g_argv1 IS NOT NULL THEN
          LET g_pjb01 = g_argv1
          DISPLAY g_pjb01 TO pja01                          #TQC-920058
       END IF
       DISPLAY BY NAME g_pja.pja01  #MOD-840429
       DISPLAY BY NAME g_pja.pja02
       DISPLAY BY NAME g_pja.pja03
       DISPLAY BY NAME g_pja.pja04
       DISPLAY BY NAME g_pja.pja05
       DISPLAY BY NAME g_pja.pja06
       DISPLAY BY NAME g_pja.pja07
       DISPLAY BY NAME g_pja.pja08
       DISPLAY l_gen02 TO FORMONLY.gen02
       DISPLAY BY NAME g_pja.pja09
       DISPLAY l_gem02 TO FORMONLY.gem02
       DISPLAY BY NAME g_pja.pja091
       DISPLAY BY NAME g_pja.pja092
       DISPLAY BY NAME g_pja.pja093
       DISPLAY BY NAME g_pja.pja094
       DISPLAY BY NAME g_pja.pja10
       DISPLAY BY NAME g_pja.pja11
       DISPLAY BY NAME g_pja.pja12
       DISPLAY BY NAME g_pja.pja21
       DISPLAY BY NAME g_pja.pjaconf
       DISPLAY BY NAME g_pja.pjaclose
    END IF
 
END FUNCTION
 
FUNCTION t110_i(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  
   DEFINE   l_count      LIKE type_file.num5   
   DEFINE   l_n          LIKE type_file.num5    
 
   DISPLAY g_pjb01,g_pja.pja03,g_pja.pja02,g_pja.pja04,g_pja.pja05,g_pja.pja06,
           g_pja.pja08,g_pja.pja10,g_pja.pja12,g_pja.pjaconf,
           g_pja.pja091,g_pja.pja092,g_pja.pja093,g_pja.pja094,
           g_pja.pja07,g_pja.pja09,g_pja.pja11,g_pja.pjaclose,g_pja.pja21 
        TO pja01,pja03,pja02,pja04,pja05,pja06,pja08,pja10,pja12,pjaconf,                 #TQC-920058 
           pja091,pja092,pja093,pja094,pja07,pja09,pja11,pjaclose,pja21 
 
   INPUT   g_pjb01  WITHOUT DEFAULTS FROM  pja01                                          #TQC-920058
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t110_set_entry(p_cmd)
         CALL t110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD pja01                                                                   #TQC-920058
         IF NOT cl_null(g_pjb01) THEN
            IF g_pjb01 != g_pjb01_t OR cl_null(g_pjb01_t) THEN
               SELECT COUNT(UNIQUE pja01) INTO l_n FROM pja_file
                WHERE pja01=g_pjb01 AND pjaacti='Y'
               IF l_n = 0 THEN
                  CALL cl_err(g_pjb01,'apj-005',0)
                  LET g_pjb01 = g_pjb01_t
                  NEXT FIELD pja01                                                        #TQC-920058 
               END IF
               CALL t110_pjb01('d')
               DISPLAY g_pjb01 TO pja01                                                   #TQC-920058
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pja01)                                                           #TQC-920058
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pja"
               LET g_qryparam.default1= g_pjb01
               CALL cl_create_qry() RETURNING g_pjb01
               CALL t110_pjb01('d')
               NEXT FIELD pja01                                                           #TQC-920058 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t110_r()
   DEFINE   l_cnt   LIKE type_file.num5,          
            l_gav   RECORD LIKE gav_file.*
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pjb01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   IF g_pja.pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t110_cl USING g_pjb01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_pjb01                       # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjb01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   #No.TQC-A70016  --Begin                                                      
   #IF cl_delh(0,0) THEN                   #确认一下                            
   IF cl_confirm('lib-357') THEN                                                
   #No.TQC-A70016  --End    
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjb01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjb01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM pjb_file WHERE pjb01 = g_pjb01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pjb_file",g_pjb01,"",SQLCA.sqlcode,"","BODY DELETE",0)  
      ELSE
         CLEAR FORM
         CALL g_pjb.clear()
         OPEN t110_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t110_cs
            CLOSE t110_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t110_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t110_cs
            CLOSE t110_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t110_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t110_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE         
            CALL t110_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t110_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjb01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION t110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用 
    l_n2            LIKE type_file.num5,                #取字段長度 
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    l_chr           LIKE type_file.chr30,               #數字轉字符中間變量
    p_cmd           LIKE type_file.chr1,                #處理狀態 
    l_pjb04_s       LIKE pjb_file.pjb04,                #錄上層編碼時需檢查的層級
    l_allow_insert  LIKE type_file.num5,                #可新增否
    l_allow_delete  LIKE type_file.num5                 #可刪除否 
DEFINE l_pjb21      LIKE pjb_file.pjb21                 #WBS的審核碼
 
    LET g_action_choice = ""
    IF g_pjb01 IS NULL THEN RETURN END IF
    IF g_pja.pjaconf = 'N' THEN CALL cl_err('','apj-601',0) RETURN END IF   #NO.MOD-840479    
    IF g_pja.pjaclose = 'Y' THEN CALL cl_err('','amr-100',0) RETURN END IF  #No.FUN-960038 #CHI-A50007 mod abg-503->amr-100
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
        " SELECT pjb04,pjb05,pjb06,pjb02,pjb03,pjb07,pjb08,pjb09, ", 
        "        pjb25,pjb10,pjb11,pjb12,pjb13,pjb14,pjb21,pjbacti FROM pjb_file ",  
        " WHERE pjb01 = ? AND pjb02 = ? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pjb WITHOUT DEFAULTS FROM s_pjb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            IF g_pja.pja12 = 'N' THEN
               CALL cl_set_comp_entry("pjb25",FALSE) 
            ELSE
               CALL cl_set_comp_entry("pjb25",TRUE) 
            END IF
 
        BEFORE ROW
            LET p_cmd =''
            LET l_chr =''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_pjb_t.* = g_pjb[l_ac].*  #BACKUP
 
               OPEN t110_cl USING g_pjb01
               IF STATUS THEN
                  CALL cl_err("OPEN t110_cl:", STATUS, 1)
                  CLOSE t110_cl
                  ROLLBACK WORK
                  RETURN
               END IF
 
               FETCH t110_cl INTO g_pjb01     # 對DB鎖定
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjb01,SQLCA.sqlcode,0)
                  CLOSE t110_cl
                  ROLLBACK WORK
                  RETURN
               END IF
 
               LET p_cmd='u' 
 
               OPEN t110_bcl USING g_pjb01,g_pjb_t.pjb02
               IF STATUS THEN
                  CALL cl_err("OPEN t110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t110_bcl INTO g_pjb[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pjb_t.pjb02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF 
               END IF
               CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pjb[l_ac].* TO NULL      #900423
             LET g_pjb[l_ac].pjb08 = '3'          #Default
             LET g_pjb[l_ac].pjb09 = 'Y'          #Default
             LET g_pjb[l_ac].pjb25 = 'N'          #Default
             LET g_pjb[l_ac].pjb10 = 'Y'          #Default
             LET g_pjb[l_ac].pjb11 = 'Y'          #Default
             LET g_pjb[l_ac].pjb13 = '0'          #Default
             LET g_pjb[l_ac].pjb14 =  0           #Default
             LET g_pjb[l_ac].pjb21 = '0'          #Default
             LET g_pjb[l_ac].pjbacti = 'Y'        #Default
             LET g_pjb_t.* = g_pjb[l_ac].*        #新輸入資料
            CALL cl_show_fld_cont()   
 
            NEXT FIELD pjb04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
       IF cl_null(g_pjb[l_ac].pjb02) THEN LET g_pjb[l_ac].pjb02=' ' END IF
            INSERT INTO pjb_file(pjb01,pjb02,pjb03,pjb04,pjb05,
                                 pjb06,pjb07,pjb08,pjb09,pjb10,
                                 pjb11,pjb12,pjb13,pjb14,pjb21,pjb25,
                                 pjbuser,pjbgrup,pjbdate,pjbacti,pjboriu,pjborig) 
                          VALUES(g_pjb01,g_pjb[l_ac].pjb02,
                                 g_pjb[l_ac].pjb03,g_pjb[l_ac].pjb04,
                                 g_pjb[l_ac].pjb05,g_pjb[l_ac].pjb06,
                                 g_pjb[l_ac].pjb07,g_pjb[l_ac].pjb08,
                                 g_pjb[l_ac].pjb09,g_pjb[l_ac].pjb10,
                                 g_pjb[l_ac].pjb11,g_pjb[l_ac].pjb12,
                                 g_pjb[l_ac].pjb13,g_pjb[l_ac].pjb14,
                                 g_pjb[l_ac].pjb21,g_pjb[l_ac].pjb25,
                                 g_user,g_grup, 
                                 g_today,g_pjb[l_ac].pjbacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pjb_file",g_pjb01,g_pjb[l_ac].pjb02,SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b = g_rec_b + 1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
         BEFORE FIELD pjb04                        #default 序號
           IF g_pjb[l_ac].pjb04 IS NULL OR g_pjb[l_ac].pjb04 = 0 THEN
              SELECT max(pjb04)+1
                INTO g_pjb[l_ac].pjb04
                FROM pjb_file
               WHERE pjb01 = g_pjb01
              IF g_pjb[l_ac].pjb04 IS NULL THEN
                 LET g_pjb[l_ac].pjb04 = 1
              END IF
           END IF
 
        AFTER FIELD pjb04                        #check 序號是否重複
           IF NOT cl_null(g_pjb[l_ac].pjb04) THEN
              IF g_pjb[l_ac].pjb04 != g_pjb_t.pjb04
                 OR g_pjb_t.pjb04 IS NULL THEN
                 IF g_pjb[l_ac].pjb04 <=0 THEN 
                    CALL cl_err('','apj-036',0)
                    LET g_pjb[l_ac].pjb04 = g_pjb_t.pjb04
                    NEXT FIELD pjb04
                 END IF
                 IF g_pjb[l_ac].pjb04 >g_pjz.pjz03 THEN 
                    CALL cl_err_msg("","apj-072",g_pjz.pjz03 CLIPPED,0)
                    LET g_pjb[l_ac].pjb04 = g_pjb_t.pjb04
                    NEXT FIELD pjb04
                 END IF
              END IF
              IF g_pjb[l_ac].pjb04 = 1 THEN 
                 LET g_pjb[l_ac].pjb06 = g_pja.pja04
                 DISPLAY BY NAME g_pjb[l_ac].pjb06
                 CALL cl_set_comp_entry("pjb06",FALSE) 
              ELSE
                 CALL cl_set_comp_entry("pjb06",TRUE) 
              END IF
           END IF
 
         AFTER FIELD pjb05 
             IF NOT cl_null(g_pjb[l_ac].pjb05) THEN 
                IF g_pjb[l_ac].pjb05 != g_pjb_t.pjb05 OR g_pjb_t.pjb05 IS NULL THEN  #No.MOD-840470
                   LET l_n2 = length(g_pjb[l_ac].pjb05)
                   IF l_n2 != g_pjz.pjz02 THEN 
                      CALL cl_err_msg("","apj-038",g_pjz.pjz02 CLIPPED,0)
                      LET g_pjb[l_ac].pjb05 = g_pjb_t.pjb05
                      NEXT FIELD pjb05
                   END IF
                END IF                                                               #No.MOD-840470
                IF NOT cl_null(g_pjb[l_ac].pjb04) AND NOT cl_null(g_pjb[l_ac].pjb05)
                    AND NOT cl_null(g_pjb[l_ac].pjb06) THEN
                    IF g_pjb[l_ac].pjb05 != g_pjb_t.pjb05 THEN
                       CALL t110_b_check()
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          NEXT FIELD pjb05
                       END IF
                    END IF
                    IF g_pjb[l_ac].pjb04=1 THEN
                       LET l_chr = g_pjb[l_ac].pjb05
                       LET g_pjb[l_ac].pjb02 = g_pjb[l_ac].pjb06,"-",l_chr
                       DISPLAY BY NAME g_pjb[l_ac].pjb02
                    ELSE
                       SELECT pjb02 INTO l_chr FROM pjb_file 
                       WHERE pjb01 = g_pjb01 
                         AND pjb02 = g_pjb[l_ac].pjb06
                       LET g_pjb[l_ac].pjb02 = l_chr,"-",g_pjb[l_ac].pjb05
                       DISPLAY BY NAME g_pjb[l_ac].pjb02
                    END IF
                END IF
             END IF
 
         AFTER FIELD pjb06
           IF NOT cl_null(g_pjb[l_ac].pjb06) THEN
              IF g_pjb[l_ac].pjb06 != g_pjb_t.pjb06 OR g_pjb_t.pjb06 IS NULL THEN
                 SELECT count(*) INTO l_n2 FROM pjb_file 
                  WHERE pjb01 = g_pjb01 
                    AND pjb02 = g_pjb[l_ac].pjb06
                 IF l_n2 <= 0 THEN
                    CALL cl_err('','apj-051',0)
                    LET g_pjb[l_ac].pjb06 = g_pjb_t.pjb06
                    NEXT FIELD pjb06
                 END IF
                 IF NOT cl_null(g_pjb[l_ac].pjb04) AND NOT cl_null(g_pjb[l_ac].pjb05)
                    AND NOT cl_null(g_pjb[l_ac].pjb06) THEN
                    CALL t110_b_check()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_pjb[l_ac].pjb06 =NULL
                       NEXT FIELD pjb06
                    END IF
                    SELECT pjb02,pjb04 INTO l_chr,l_pjb04_s FROM pjb_file 
                     WHERE pjb01 = g_pjb01 
                       AND pjb02 = g_pjb[l_ac].pjb06
                    IF l_pjb04_s !=g_pjb[l_ac].pjb04-1 THEN
                       CALL cl_err('','apj-073',0)
                       LET g_pjb[l_ac].pjb06 = g_pjb_t.pjb06
                       NEXT FIELD pjb06
                    ELSE
                       LET g_pjb[l_ac].pjb02 = l_chr,"-",g_pjb[l_ac].pjb05
                       DISPLAY BY NAME g_pjb[l_ac].pjb02
                    END IF
                 END IF
              END IF
           END IF
 
         AFTER FIELD pjb07
           IF NOT cl_null(g_pjb[l_ac].pjb07) THEN
              IF g_pjb[l_ac].pjb07 != g_pjb_t.pjb07
                 OR g_pjb_t.pjb07 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM pjr_file
                  WHERE pjr01 = g_pjb[l_ac].pjb07
                    AND pjracti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err('','apj-037',0)
                    LET g_pjb[l_ac].pjb07 = g_pjb_t.pjb07
                    NEXT FIELD pjb07
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_pjb_t.pjb02 IS NOT NULL THEN
               SELECT pjb21 INTO l_pjb21 
                 FROM pjb_file WHERE pjb02 = g_pjb_t.pjb02
               IF l_pjb21 = '1' THEN
                  CALL cl_err(g_pjb[l_ac].pjb02,'apj-084',0)
                  CANCEL DELETE
               END IF
               IF NOT cl_delb(0,0) THEN 
                  CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM pjb_file 
                 WHERE pjb01 = g_pjb01 
                   AND pjb02 = g_pjb_t.pjb02
                IF SQLCA.SQLERRD[3] = 0 THEN
                   CALL cl_err3("del","pjb_file",g_pjb01,g_pjb_t.pjb02,SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                   CANCEL DELETE 
                ELSE
                   LET g_rec_b = g_rec_b -1 
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                   COMMIT WORK
                END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pjb[l_ac].* = g_pjb_t.*
               CLOSE t110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            SELECT pjb21 INTO l_pjb21 
              FROM pjb_file WHERE pjb02 = g_pjb_t.pjb02
            IF l_pjb21 = '1' THEN
               CALL cl_err(g_pjb[l_ac].pjb02,'apj-084',0)
               LET g_pjb[l_ac].* = g_pjb_t.*
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pjb[l_ac].pjb02,-263,1)
               LET g_pjb[l_ac].* = g_pjb_t.*
            ELSE
               UPDATE pjb_file SET pjb02=g_pjb[l_ac].pjb02,
                                   pjb03=g_pjb[l_ac].pjb03,
                                   pjb04=g_pjb[l_ac].pjb04,
                                   pjb05=g_pjb[l_ac].pjb05,
                                   pjb06=g_pjb[l_ac].pjb06,
                                   pjb07=g_pjb[l_ac].pjb07,
                                   pjb08=g_pjb[l_ac].pjb08,
                                   pjb09=g_pjb[l_ac].pjb09,
                                   pjb25=g_pjb[l_ac].pjb25,
                                   pjb10=g_pjb[l_ac].pjb10,
                                   pjb11=g_pjb[l_ac].pjb11,
                                   pjb12=g_pjb[l_ac].pjb12,
                                   pjb13=g_pjb[l_ac].pjb13,
                                   pjb14=g_pjb[l_ac].pjb14,
                                   pjb21=g_pjb[l_ac].pjb21,
                                   pjbmodu=g_user,
                                   pjbdate=g_today,
                                   pjbacti=g_pjb[l_ac].pjbacti
                WHERE pjb01 = g_pjb01 
                  AND pjb02 = g_pjb_t.pjb02  
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","pjb_file",g_pjb01,g_pjb_t.pjb02,SQLCA.sqlcode,"","",1)  
                  LET g_pjb[l_ac].* = g_pjb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pjb[l_ac].* = g_pjb_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_pjb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE t110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE t110_bcl
            COMMIT WORK
 
        ON ACTION controls                             
         CALL cl_set_head_visible("","AUTO")        
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pjb02) AND l_ac > 1 THEN
                LET g_pjb[l_ac].* = g_pjb[l_ac-1].*
                NEXT FIELD pjb04
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(pjb06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjb1"
                   LET g_qryparam.arg1 = g_pjb01
                   LET g_qryparam.arg2 = g_pjb[l_ac].pjb04-1
                   LET g_qryparam.default1 = g_pjb[l_ac].pjb06
                   CALL cl_create_qry() RETURNING g_pjb[l_ac].pjb06
                   DISPLAY g_pjb[l_ac].pjb06 TO pjb06            #No.MOD-490371
                   NEXT FIELD pjb06
 
              WHEN INFIELD(pjb07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjr01"
                   LET g_qryparam.default1 = g_pjb[l_ac].pjb07
                   CALL cl_create_qry() RETURNING g_pjb[l_ac].pjb07
                   DISPLAY g_pjb[l_ac].pjb07 TO pjb07            #No.MOD-490371
                   NEXT FIELD pjb07
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION  memo            #WBS本階備注
         IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
            LET l_cmd="apjt111 '",g_pjb01,"' '",g_pjb[l_ac].pjb02,"' "              
            CALL cl_cmdrun_wait(l_cmd)
         END IF
 
      ON ACTION  detail2         #WBS本階明細
         IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
            LET l_cmd="apjt112 '",g_pjb01,"' '",g_pjb[l_ac].pjb02,"' "              
            CALL cl_cmdrun_wait(l_cmd)
            CLOSE t110_bcl
         END IF
 
      ON ACTION  planmaterial     #WBS本階計劃材料需求   #No.TQC-840009 
         IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
            IF g_pjb[l_ac].pjb09 = 'Y' AND g_pjb[l_ac].pjb11= 'Y' THEN
               LET l_cmd="apjt120 '",g_pjb01,"' '",g_pjb[l_ac].pjb02,"' "              
               CALL cl_cmdrun_wait(l_cmd)
            ELSE
               CALL cl_err(g_pjb[l_ac].pjb02,'apj-089',1)
            END IF
         END IF
 
      ON ACTION  human            #WBS本階人力需求       #No.TQC-840009
         IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
            IF g_pjb[l_ac].pjb09 = 'Y' AND g_pjb[l_ac].pjb11= 'Y' THEN
               LET l_cmd="apjt121 '",g_pjb[l_ac].pjb02,"' "              
               CALL cl_cmdrun_wait(l_cmd)
            ELSE
               CALL cl_err(g_pjb[l_ac].pjb02,'apj-089',1)
            END IF
         END IF
 
      ON ACTION  equipment        #WBS本階設備需求       #No.TQC-840009
         IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
            IF g_pjb[l_ac].pjb09 = 'Y' AND g_pjb[l_ac].pjb11= 'Y' THEN
               LET l_cmd="apjt122 '",g_pjb[l_ac].pjb02,"' "              
               CALL cl_cmdrun_wait(l_cmd)
            ELSE
               CALL cl_err(g_pjb[l_ac].pjb02,'apj-089',1)
            END IF
         END IF
 
      ON ACTION  futurecost       #預估WBS本階費用      #No.TQC-840009 
         IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
            IF g_pjb[l_ac].pjb09 = 'Y' AND g_pjb[l_ac].pjb11= 'Y' THEN
               LET l_cmd="apjt123 '",g_pjb01,"' '",g_pjb[l_ac].pjb02,"' "              
               CALL cl_cmdrun_wait(l_cmd)
            ELSE
               CALL cl_err(g_pjb[l_ac].pjb02,'apj-089',1)
            END IF
         END IF
 
      ON ACTION  confirm       #確認/審核
         IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
            CALL t110_b_y('d',l_ac)
         END IF
 
      ON ACTION  unconfirm     #取消確認/取消審核
         IF NOT cl_null(g_pjb[l_ac].pjb02) THEN
            CALL t110_b_v('d',l_ac)
         END IF
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
    END INPUT
 
    CLOSE t110_bcl
    COMMIT WORK
 
END FUNCTION
 
#檢查資料重復
FUNCTION t110_b_check()
DEFINE p_pjb04  LIKE pjb_file.pjb04
DEFINE p_pjb05  LIKE pjb_file.pjb05
DEFINE p_pjb06  LIKE pjb_file.pjb06
DEFINE l_n      LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
 
  LET g_errno ="" 
 
  SELECT count(*) INTO l_n FROM pjb_file 
   WHERE pjb01 = g_pjb01 
    AND pjb04 = g_pjb[l_ac].pjb04
    AND pjb05 = g_pjb[l_ac].pjb05
    AND pjb06 = g_pjb[l_ac].pjb06
  
  IF l_n > 0 THEN
     LET g_errno = '-239'
  ELSE
     SELECT count(*) INTO l_n2 FROM pjb_file 
      WHERE pjb01 = g_pjb01 
        AND pjb02 = g_pjb[l_ac].pjb06
        AND pjb09 ='Y'
     IF l_n2 > 0 THEN
        LET g_errno = 'apj-078'
     END IF
  END IF
 
END FUNCTION
 
FUNCTION t110_b_askkey()
 DEFINE l_wc    STRING     #NO.FUN-910082
 
    CONSTRUCT l_wc  ON pjb04,pjb05,pjb06,pjb02,pjb03,
                       pjb07,pjb08,pjb09,pjb25,pjb10,pjb11,
                       pjb12,pjb13,pjb14,pjb21,pjbacti 
            FROM s_pjb[1].pjb04, s_pjb[1].pjb05, 
                 s_pjb[1].pjb06, s_pjb[1].pjb02,s_pjb[1].pjb03, 
                 s_pjb[1].pjb07, s_pjb[1].pjb08,s_pjb[1].pjb09,s_pjb[1].pjb25,
                 s_pjb[1].pjb10, s_pjb[1].pjb11,s_pjb[1].pjb12,
                 s_pjb[1].pjb13, s_pjb[1].pjb14,s_pjb[1].pjb21,s_pjb[1].pjbacti
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()   
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t110_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t110_b_fill(p_wc)              #BODY FILL UP
DEFINE  p_wc  STRING     #NO.FUN-910082
 
   LET g_sql = "SELECT pjb04,pjb05,pjb06,pjb02,pjb03,pjb07,pjb08, ",
               "       pjb09,pjb25,pjb10,pjb11,pjb12,pjb13,pjb14,pjb21,pjbacti  ",
               " FROM pjb_file",
               " WHERE pjb01 ='",g_pjb01,"'",               #單頭
               "   AND ",p_wc CLIPPED,                      #單身  
               " ORDER BY pjb02"
 
   PREPARE t110_pb FROM g_sql
   DECLARE pjb_curs CURSOR FOR t110_pb
 
   CALL g_pjb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH pjb_curs INTO g_pjb[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_pjb.deleteElement(g_cnt)
   LET g_rec_b =g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t110_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_pjb TO s_pjb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                  
                              
 
      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                  
                              
 
      ON ACTION jump 
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   
                              
 
      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                  
                              
 
      ON ACTION last 
         CALL t110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                 
                              
      ON ACTION  b_more       #更新單身相關資料
         LET g_action_choice="b_more"
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
 
      ON ACTION controls      
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION related_document            #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t110_b_y(p_cmd,l_cnt)
   DEFINE   p_cmd LIKE type_file.chr1   
   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjb[l_cnt].pjb21 !='0' THEN
      CALL cl_err("",'9021',0)
      RETURN
   END IF
 
   IF cl_confirm('aap-222') THEN
      BEGIN WORK
 
      OPEN t110_cl USING g_pjb01
      IF STATUS THEN
         CALL cl_err("OPEN t110_cl:", STATUS, 1)
         CLOSE t110_cl
         ROLLBACK WORK
         RETURN
      END IF
 
      FETCH t110_cl INTO g_pjb01
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_pjb01,SQLCA.sqlcode,0)          #資料被他人LOCK
         ROLLBACK WORK
         RETURN
      END IF
 
      LET g_success = 'Y'
  
      CALL t110_b_fill(g_wc2)   #FUN-840141
   
      LET g_pjb[l_cnt].pjb21='1'
 
      UPDATE pjb_file SET pjb21=g_pjb[l_cnt].pjb21,
                          pjbmodu=g_user,
                          pjbdate=g_today
                    WHERE pjb01=g_pjb01
                      AND pjb02=g_pjb[l_cnt].pjb02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pjb_file",g_pjb01,g_pjb[l_cnt].pjb02,SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK
      END IF
 
      CLOSE t110_cl
 
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_flow_notify(g_pjb01,'Y')
      ELSE
         ROLLBACK WORK
      END IF
      COMMIT WORK
   END IF
   
END FUNCTION
 
FUNCTION t110_b_v(p_cmd,l_cnt)
   DEFINE   p_cmd   LIKE type_file.chr1   
   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjb[l_cnt].pjb21 !='1' THEN
      CALL cl_err("",'9021',0)
      RETURN
   END IF
   
   IF cl_confirm('aap-224') THEN 
      BEGIN WORK
 
      OPEN t110_cl USING g_pjb01
      IF STATUS THEN
         CALL cl_err("OPEN t110_cl:", STATUS, 1)
         CLOSE t110_cl
         ROLLBACK WORK
         RETURN
      END IF
 
      FETCH t110_cl INTO g_pjb01
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_pjb01,SQLCA.sqlcode,0)          #資料被他人LOCK
         ROLLBACK WORK
         RETURN
      END IF
 
      LET g_success = 'Y'
   
      CALL t110_b_fill(g_wc2)  #FUN-840141
   
      LET g_pjb[l_cnt].pjb21='0'
 
      UPDATE pjb_file SET pjb21=g_pjb[l_cnt].pjb21,
                          pjbmodu=g_user,
                          pjbdate=g_today
                    WHERE pjb01=g_pjb01
                      AND pjb02=g_pjb[l_cnt].pjb02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pjb_file",g_pjb01,g_pjb[l_cnt].pjb02,SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK
      END IF
   
      CLOSE t110_cl
   
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_flow_notify(g_pjb01,'Y')
      ELSE
         ROLLBACK WORK
      END IF
      COMMIT WORK
   END IF 
 
END FUNCTION
 
FUNCTION t110_out()
DEFINE l_i      LIKE type_file.num5,  
       sr       RECORD
                pjb02   LIKE pjb_file.pjb02,
                pjb03   LIKE pjb_file.pjb03,
                pjb04   LIKE pjb_file.pjb04,
                pjb05   LIKE pjb_file.pjb05,
                pjb06   LIKE pjb_file.pjb06,
                pjb09   LIKE pjb_file.pjb09,
                pjb25   LIKE pjb_file.pjb25,
                pjb10   LIKE pjb_file.pjb10,
                pjb11   LIKE pjb_file.pjb11,
                pjb21   LIKE pjb_file.pjb21,
                pjb01   LIKE pjb_file.pjb01,
                pja02   LIKE pja_file.pja02,
                pjb07   LIKE pjb_file.pjb07,
                pjb08   LIKE pjb_file.pjb08,
                pjb12   LIKE pjb_file.pjb12,
                pjb13   LIKE pjb_file.pjb13,
                pjb14   LIKE pjb_file.pjb14 
                END RECORD,
       l_name   LIKE type_file.chr20,  
       l_za05   LIKE type_file.chr1000 
 
    IF g_wc IS NULL THEN
       LET g_wc ="pja01 ='",g_pjb01,"'"
    END IF
 
    CALL cl_wait()
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT pjb02,pjb03,pjb04,pjb05,pjb06,pjb09,pjb25,pjb10,pjb11,pjb21,",
              "       pjb01,pja02,pjb07,pjb08,pjb12,pjb13,pjb14",
              " FROM pjb_file,pja_file",
              " WHERE pjb01 = pja01 ",
              "   AND ",g_wc CLIPPED,
              " ORDER BY pjb02 "
     CALL cl_prt_cs1('apjt110','apjt110',g_sql,'')
 
END FUNCTION
 
FUNCTION t110_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1        
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("pjb01",TRUE) 
   END IF
 
END FUNCTION
 
FUNCTION t110_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("pjb01",FALSE) 
   END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
