# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axmq630.4gl
# Descriptions...: 出貨序號明細查詢  
# Date & Author..: 99/05/26 By Carol:tiptop 4.0   
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C10084 12/02/09 By jt_chen 增加判斷若沒有走FQC時,直接抓工單序號檔
# Modify.........: No.TQC-C60122 12/06/14 By zhuhao g_action_choice="pqc_quality_recor"，代碼少了一個'd'
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_wc2	STRING  # WHERE CONDICTION  #No.FUN-580092 HCN 
DEFINE g_sql		STRING  #No.FUN-580092 HCN  
DEFINE g_ogb 	RECORD
          ogbb02    LIKE  ogbb_file.ogbb02,
          ogb04     LIKE  ogb_file.ogb04,
          ima02     LIKE  ima_file.ima02,
          ima021    LIKE  ima_file.ima021,
          oga03     LIKE  oga_file.oga03,
          oga032    LIKE  oga_file.oga032,
          ogb01     LIKE  ogb_file.ogb01,
          ogb03     LIKE  ogb_file.ogb03,
          oga14     LIKE  oga_file.oga14,
          gen02     LIKE  gen_file.gen02,
          ogb31     LIKE  ogb_file.ogb31,
          ogb32     LIKE  ogb_file.ogb32,
          oga15     LIKE  oga_file.oga15,
          gem02     LIKE  gem_file.gem02,
          qci01     LIKE  qci_file.qci01,
          qcf13     LIKE  qcf_file.qcf13,
          gen02_q   LIKE  gen_file.gen02,
          qty       LIKE  type_file.num10,         #No.FUN-680137 INTEGER
          sfb01     LIKE  sfb_file.sfb01,
          sfb07     LIKE  sfb_file.sfb07,
          sfb06     LIKE  sfb_file.sfb06
            	END RECORD
DEFINE g_order       LIKE type_file.num5         #No.FUN-680137 SMALLINT            
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5       #No.FUN-680137 SMALLINT
 
MAIN 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW q630_w WITH FORM "axm/42f/axmq630" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL q630_menu()
 
    CLOSE WINDOW q630_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q630_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
      CLEAR FORM #清除畫面
      CALL cl_opmsg('q')
   INITIALIZE g_ogb.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON ogbb02 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
      LET g_sql=" SELECT ogbb02,ogb04,'','',oga03,oga032,ogb01,ogb03,",
                " oga14,'',ogb31,ogb32,oga15,'','','','','','','','' ",
                " FROM ogbb_file,ogb_file,oga_file ",
                " WHERE ",g_wc CLIPPED,
                " AND ogb01= ogbb01 AND ogb03=ogbb012 ",
                " AND oga01= ogb01 ",
                " AND ogaconf != 'X' ", #01/08/20 mandy
                " ORDER BY 1 "  CLIPPED
     PREPARE q630_prepare FROM g_sql
     DECLARE q630_cs SCROLL CURSOR FOR q630_prepare
 
     LET g_sql=" SELECT COUNT(*) ",
               "  FROM ogbb_file,ogb_file,oga_file",
               " WHERE ",g_wc CLIPPED,
               " AND ogb01= ogbb01 AND ogb03=ogbb012 ",
               " AND oga01= ogb01 ",
               " AND ogaconf != 'X' "
     PREPARE q630_pp  FROM g_sql
     DECLARE q630_cnt CURSOR FOR q630_pp
END FUNCTION
 
FUNCTION q630_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
           CALL q630_q()
 
        #@ON ACTION 原物料查詢  
        ON ACTION query_raw_material
           LET g_action_choice="query_raw_material"
           IF cl_chk_act_auth() AND
              ( g_ogb.ogb04 IS NOT NULL OR g_ogb.ogb04 !=' ' ) THEN
              LET g_msg="axmq631 '",g_ogb.ogbb02,"'"
              CALL cl_cmdrun(g_msg)
           END IF
 
        #@ON ACTION PQC品質記錄查詢            
        ON ACTION pqc_quality_record
          #LET g_action_choice="pqc_quality_recor"                #TQC-C60122 mark
           LET g_action_choice="pqc_quality_record"                #TQC-C60122 add
           IF cl_chk_act_auth() AND
              ( g_ogb.sfb01 IS NOT NULL OR g_ogb.sfb01 !=' ' ) THEN
              LET g_msg="aqcq512 '",g_ogb.sfb01,"' '",g_ogb.ogb04,"'"
              CALL cl_cmdrun(g_msg)
           END IF
 
        #@ON ACTION PQC品質記錄彙總查詢  
        ON ACTION pqc_quality_summary
           LET g_action_choice="pqc_quality_summary"
           IF cl_chk_act_auth() AND
              ( g_ogb.sfb01 IS NOT NULL OR g_ogb.sfb01 !=' ' ) THEN
              LET g_msg="aqcq514 '",g_ogb.ogb04,"'"
              CALL cl_cmdrun(g_msg)
           END IF
 
        ON ACTION next
           CALL q630_fetch('N')
 
        ON ACTION previous
           CALL q630_fetch('P')
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
            LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL q630_fetch('/')
 
        ON ACTION first
           CALL q630_fetch('F')
 
        ON ACTION last
           CALL q630_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION q630_q()
 DEFINE x  LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1) 
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   #DISPLAY '   ' TO FORMONLY.cnt  
    CALL q630_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "Waiting!" 
    OPEN q630_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('q630_q:',SQLCA.sqlcode,0)
    ELSE
        OPEN q630_cnt
        FETCH q630_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt 
        CALL q630_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q630_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q630_cs INTO g_ogb.*
        WHEN 'P' FETCH PREVIOUS q630_cs INTO g_ogb.*
        WHEN 'F' FETCH FIRST    q630_cs INTO g_ogb.*
        WHEN 'L' FETCH LAST     q630_cs INTO g_ogb.*
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump q630_cs INTO g_ogb.*
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err('Fetch:',SQLCA.sqlcode,0)
        INITIALIZE g_ogb.* TO NULL  #TQC-6B0105
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
 
    CALL q630_show()
 
END FUNCTION
 
FUNCTION q630_show()
    DEFINE l_qcf02 LIKE qcf_file.qcf02
 
    #01/08/13 mandy
    SELECT qci01,qcf13,qcf02,qcf22-qcf091 
      INTO g_ogb.qci01,g_ogb.qcf13,l_qcf02,g_ogb.qty
      FROM qci_file,qcf_file
     WHERE qci01 = qcf01
       AND qci02 = g_ogb.ogbb02
       AND qcf021= g_ogb.ogb04
       AND qcf14 != 'X' 
          
    IF STATUS  THEN  
        LET g_ogb.qci01='' 
        LET g_ogb.qcf13=''
        LET g_ogb.qty=0
        LET l_qcf02 = ''
    END IF
    #--  MOD-C10084 add start--
    IF cl_null(l_qcf02) THEN
       SELECT sfb01
         INTO l_qcf02
         FROM she_file,sfb_file
        WHERE she01 = sfb01
          AND she02 = g_ogb.ogbb02
          AND sfb05= g_ogb.ogb04
          AND sfb87 != 'X'
       IF cl_null(l_qcf02) THEN
          LET l_qcf02 = ''
       END IF
    END IF
    #--  MOD-C10084 add end-- 
    SELECT ima02,ima021 INTO g_ogb.ima02,g_ogb.ima021 FROM ima_file
     WHERE ima01=g_ogb.ogb04
    IF STATUS  THEN  LET g_ogb.ima02 = '' LET g_ogb.ima021='' END IF
 
    SELECT gen02 INTO g_ogb.gen02 FROM gen_file
     WHERE gen01=g_ogb.oga14
    IF STATUS  THEN  LET g_ogb.gen02 = '' END IF
 
    SELECT gen02 INTO g_ogb.gen02_q FROM gen_file
     WHERE gen01=g_ogb.qcf13
    IF STATUS  THEN  LET g_ogb.gen02_q = '' END IF
 
    SELECT gem02 INTO g_ogb.gem02 FROM gem_file
     WHERE gem01=g_ogb.oga15
    IF STATUS  THEN  LET g_ogb.gem02 = '' END IF
 
    IF NOT cl_null(l_qcf02) THEN
        SELECT sfb01,sfb06,sfb07 
          INTO g_ogb.sfb01,g_ogb.sfb06,g_ogb.sfb07
          FROM sfb_file
         WHERE sfb01 = l_qcf02
        IF STATUS  THEN  
            LET g_ogb.sfb01 = ''
            LET g_ogb.sfb06 = ''
            LET g_ogb.sfb07 = ''
        END IF
    END IF
    DISPLAY BY NAME g_ogb.*
    MESSAGE ''
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
