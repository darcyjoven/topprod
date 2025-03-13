# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: almi110.4gl
# Descriptions...: 樓棟基本資料維護作業
# Date & Author..: FUN-870015 08/07/01 By shiwuying 
# Modify.........: No:FUN-960134 09/06/29 By shiwuying 市場移植
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No:FUN-A60064 10/06/23 By shiwuying 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.MOD-AC0250 10/12/21 By baogc 修改預設上一筆ACTION
# Modify.........: No.FUN-B80141 11/08/23 By fanbj 單檔多欄修改為假雙檔
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_lmb              DYNAMIC ARRAY OF RECORD
          lmbstor            LIKE lmb_file.lmbstore, #No.FUN-960134
          rtz13              LIKE rtz_file.rtz13,    #FUN-A80148 add
          lmblegal           LIKE lmb_file.lmblegal, 
          azt02              LIKE azt_file.azt02,
          lmb02              LIKE lmb_file.lmb02,
          lmb03              LIKE lmb_file.lmb03,
          lmb07              LIKE lmb_file.lmb07,   #FUN-B80141 add
          lmb08              LIKE lmb_file.lmb08,   #FUN-B80141 add
          lmb05              LIKE lmb_file.lmb05,
          lmb09              LIKE lmb_file.lmb09,   #FUN-B80141 add
          lmb04              LIKE lmb_file.lmb04,
          lmb06              LIKE lmb_file.lmb06
                          END RECORD,
      #FUN-B80141--start add-----------------------
       g_lmb_l            DYNAMIC ARRAY OF RECORD   
          lmb02              LIKE lmb_file.lmb02,   
          lmb03              LIKE lmb_file.lmb03,   
          lmb07              LIKE lmb_file.lmb07,   
          lmb08              LIKE lmb_file.lmb08,   
          lmb05              LIKE lmb_file.lmb05,   
          lmb09              LIKE lmb_file.lmb09,   
          lmb04              LIKE lmb_file.lmb04,   
          lmb06              LIKE lmb_file.lmb06    
                          END RECORD,               

       g_lmb_lock         RECORD LIKE lmb_file.*,

      # g_lmb_t            RECORD             
       g_lmb_l_t          RECORD
         # lmbstore          LIKE lmb_file.lmbstore,
         # rtz13             LIKE rtz_file.rtz13,    #FUN-A80148 add   
         # lmblegal          LIKE lmb_file.lmblegal,
         # azt02             LIKE azt_file.azt02,   
       #FUN-B80141--end mark------------------------
           lmb02             LIKE lmb_file.lmb02,
           lmb03             LIKE lmb_file.lmb03,
           lmb07             LIKE lmb_file.lmb07,     #FUN-B80141 add
           lmb08             LIKE lmb_file.lmb08,     #FUN-B80141 add
           lmb05             LIKE lmb_file.lmb05,
           lmb09             LIKE lmb_file.lmb09,     #FUN-B80141 add
           lmb04             LIKE lmb_file.lmb04,
           lmb06             LIKE lmb_file.lmb06
                          END RECORD,

       #FUN-B80141--start add-----------------------
       g_lmbstore            LIKE lmb_file.lmbstore, 
       g_rtz13               LIKE rtz_file.rtz13,    
       g_lmblegal            LIKE lmb_file.lmblegal, 
       g_azt02               LIKE azt_file.azt02,    
       #FUN-B80141--end mark------------------------
       g_lmbstore_t          LIKE lmb_file.lmbstore,
       g_lmblegal_t          LIKE lmb_file.lmblegal, 

       g_wc2,g_sql           STRING, 
       g_wc                  STRING,                  #FUN-B80141 add
       g_cnt2                LIKE type_file.num5,     #FUN-B80141 add
       
       g_rec_b               LIKE type_file.num5,               
       g_rec_b2              LIKE type_file.num5,
       l_ac                  LIKE type_file.num5,
       l_ac2                 LIKE type_file.num5                
 
DEFINE g_forupd_sql          STRING                  
DEFINE g_cnt                 LIKE type_file.num10    
DEFINE g_msg                 LIKE type_file.chr1000 
DEFINE g_before_input_done   LIKE type_file.num5     
DEFINE g_i                   LIKE type_file.num5     
DEFINE g_row_count           LIKE type_file.num10     #FUN-B80141 add
DEFINE g_curs_index          LIKE type_file.num10     #FUN-B80141 add
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask              LIKE type_file.num5
DEFINE g_flag                LIKE type_file.num5      #FUN-B80141 add
DEFINE g_lla                 RECORD LIKE lla_file.*   #FUN-B80141 Add By shi
DEFINE l_i LIKE lpj_file.lpj03

MAIN     
DEFINE l_ze01 like ze_file.ze01
    OPTIONS                              
        INPUT NO WRAP      #No.FUN-9B0136
    #   FIELD ORDER FORM   #No.FUN-9B0136
    DEFER INTERRUPT                    
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
         
    OPEN WINDOW i110_w WITH FORM "alm/42f/almi110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
   
    #FUN-B80141--start add-------------------------------------------
    LET g_forupd_sql = "SELECT * FROM lmb_file  WHERE lmbstore = ? ",
                      " FOR UPDATE "

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_cl CURSOR FROM g_forupd_sql
    #FUN-B80141--end add---------------------------------------------

    #LET g_wc2 = '1=1' CALL i110_b_fill(g_wc2)   #FUN-B80141  mark

    CALL i110_menu()
    CLOSE WINDOW i110_w               
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION i110_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
        EXIT WHILE
      END IF

      CALL i110_bp("G")
      CASE g_action_choice

         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF

         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()
               IF l_ac > 0 THEN
               #  IF cl_chk_mach_auth(g_lmb[l_ac].lmbstore,g_plant) THEN
                     CALL i110_b()
               #  END IF
               ELSE
                  CALL i110_b()
                  LET g_action_choice = NULL
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF

         #FUN-B80141--start add---------

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i110_a()
            END IF
         
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i110_r()
            END IF

         WHEN "invoicefloor"
             IF cl_chk_act_auth() THEN
               CALL i110_invoice()
            END IF

         #FUN-B80141--end add-----------

         WHEN "output" 
            IF cl_chk_act_auth() THEN
               Call i110_out()
            END IF

         WHEN "help" 
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg" 
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lmb_l),base.TypeInfo.create(g_lmb),'')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#FUN-B80141--start mark---
#FUNCTION i110_q()
#   CALL i110_b_askkey()   
#END FUNCTION
#FUN-B80141--end mark----

#FUN-B80141--start add------------------------------------------
FUNCTION i110_curs()

   CLEAR FORM
   LET g_lmbstore = NULL
   LET g_lmblegal = NULL
   CALL g_lmb.clear()
   CALL g_lmb_l.clear()

   CONSTRUCT g_wc ON lmbstore,lmblegal,lmb02,lmb03,lmb07,
                     lmb08,lmb05,lmb09,lmb04,lmb06 
                FROM lmbstore,lmblegal,s_lmb_l[1].lmb02,s_lmb_l[1].lmb03,
                     s_lmb_l[1].lmb07,s_lmb_l[1].lmb08,s_lmb_l[1].lmb05,
                     s_lmb_l[1].lmb09,s_lmb_l[1].lmb04,s_lmb_l[1].lmb06
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

      ON ACTION controlp
         CASE
            WHEN INFIELD(lmbstore)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_lmbstore"
               LET g_qryparam.where = " lmbstore IN ",g_auth," "   
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmbstore
               NEXT FIELD lmbstore

            WHEN INFIELD(lmb02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmb02"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lmbstore IN ",g_auth," "   
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmb02
               NEXT FIELD lmb02

            WHEN INFIELD(lmblegal)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmblegal"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lmbstore IN ",g_auth," "   
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmblegal
               NEXT FIELD lmblegal
            OTHERWISE EXIT CASE
         END CASE

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT
     
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 

   IF INT_FLAG THEN
     LET g_wc = NULL
     RETURN
   END IF
   
   LET g_sql=" SELECT DISTINCT lmbstore FROM lmb_file WHERE ",g_wc CLIPPED,
             " AND lmbstore IN ",g_auth
   
   PREPARE i110_prepare FROM g_sql
   DECLARE i110_curs SCROLL CURSOR WITH HOLD FOR i110_prepare    
   
   LET g_sql=" SELECT  count( DISTINCT lmbstore) FROM lmb_file WHERE ",g_wc CLIPPED,
             " AND lmbstore IN ",g_auth

   PREPARE i110_precount FROM g_sql
   DECLARE i110_count CURSOR FOR i110_precount

END FUNCTION

FUNCTION i110_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1
   
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i110_curs INTO g_lmbstore 
      WHEN 'P' FETCH PREVIOUS i110_curs INTO g_lmbstore
      WHEN 'F' FETCH FIRST    i110_curs INTO g_lmbstore
      WHEN 'L' FETCH LAST     i110_curs INTO g_lmbstore
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0

            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()

               ON ACTION help
                  CALL cl_show_help()

               ON ACTION controlg
                  CALL cl_cmdask()

               ON ACTION about
                  CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i110_curs INTO g_lmbstore
         LET g_no_ask = FALSE
   END CASE
   
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lmbstore TO NULL
      INITIALIZE g_lmblegal TO NULL
   ELSE
      OPEN i110_count
      FETCH i110_count INTO g_row_count
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.indx
      
   END IF

   SELECT DISTINCT lmblegal INTO g_lmblegal FROM lmb_file
    WHERE lmbstore = g_lmbstore

   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lmb_file",g_lmbstore,"",SQLCA.sqlcode,"","",0)  
   ELSE
      CALL i110_show()             
   END IF
   
END FUNCTION

FUNCTION i110_show()
   LET g_lmbstore_t = g_lmbstore
   LET g_lmblegal_t = g_lmblegal
   
   DISPLAY g_lmbstore,g_lmblegal TO lmbstore,lmblegal

   CALL i110_lmbstore('d') 
   
   CALL i110_b_fill(g_wc)
   CALL i110_b_fill2(g_wc)   

END FUNCTION

FUNCTION i110_q()
   LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

    LET g_lmbstore = NULL
    LET g_lmblegal = NULL
    CLEAR FROM

    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt

    CALL i110_curs()

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_lmbstore TO NULL
        INITIALIZE g_lmb_l_t.* TO NULL
        INITIALIZE g_lmblegal TO NULL
        CLEAR FORM
        CALL g_lmb_l.clear()
        CALL g_lmb.clear()
        CLEAR FORM
        RETURN
    END IF

    MESSAGE "Searching!"
    OPEN i110_count
    FETCH i110_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i110_curs          # 從DB產生合乎條件TEMP(0-30秒)

    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_lmbstore TO NULL
    ELSE
        CALL i110_fetch('F')   # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION

FUNCTION i110_a()
   DEFINE l_n     LIKE type_file.num10

   LET g_wc = NULL

   IF s_shut(0) THEN
      RETURN
   END IF 

   CLEAR FORM
   CALL g_lmb.clear()
   CALL g_lmb_l.clear()   

   #INITIALIZE g_lmbstore LIKE lmb_file.lmbstore
   #INITIALIZE g_lmblegal LIKE lmb_file.lmblegal
   #INITIALIZE g_rtz13    LIKE rtz_file.rtz13
   #INITIALIZE g_azt02    LIKE azt_file.azt02

   CALL cl_opmsg('a')
   
   WHILE TRUE
      LET g_lmbstore = g_plant
      LET g_lmblegal = g_legal
      CALL i110_lmbstore('a')   
  
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,0)
         RETURN
      END IF

      CALL i110_i("a")

      IF INT_FLAG THEN
         LET g_lmbstore = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      
      LET g_rec_b = 0
      LET l_n=0
      LET g_lmbstore_t = g_lmbstore
    
      SELECT count(*) INTO l_n
        FROM lmb_file
       WHERE lmbstore = g_lmbstore
      IF l_n >0 THEN
         CALL i110_b_fill(" 1=1")
         CALL i110_b()
      ELSE
         CALL i110_b()
      END IF
      EXIT WHILE
   END WHILE   
END FUNCTION

FUNCTION i110_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   DISPLAY g_lmbstore,g_rtz13,g_lmblegal,g_azt02
        TO lmbstore,rtz13,lmblegal,azt02

   CALL cl_set_head_visible("","YES")
   
   INPUT g_lmbstore,g_lmblegal WITHOUT DEFAULTS
    FROM lmbstore,lmblegal

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE   
    
      AFTER FIELD lmbstore
         IF NOT cl_null(g_lmbstore) THEN
            CALL i110_lmbstore('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lmbstore,g_errno,1)
               LET g_lmbstore = g_lmbstore_t
               NEXT FIELD lmbstore             
            END IF
         END IF
        
      ON ACTION controlp
         CASE
            WHEN INFIELD(lmbstore)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz"
               LET g_qryparam.where = " rtz01 IN ",g_auth," "  
               LET g_qryparam.default1 = g_lmbstore
               CALL cl_create_qry() RETURNING g_lmbstore
               DISPLAY BY NAME g_lmbstore
               CALL i110_lmbstore('d')
               NEXT FIELD lmbstore
            OTHERWISE EXIT CASE
         END CASE
      
      ON ACTION controlf         #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                             RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

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

FUNCTION i110_lmbstore(p_cmd)
   DEFINE l_rtz01    LIKE rtz_file.rtz01,
          l_rtz13    LIKE rtz_file.rtz13,
          l_rtz28    LIKE rtz_file.rtz28,
          l_azwacti  LIKE azw_file.azwacti,            
          p_cmd      LIKE type_file.chr1
   DEFINE l_azt02    LIKE azt_file.azt02

   LET g_errno = ' '
   SELECT rtz01,rtz13,rtz28,azwacti                   
     INTO l_rtz01,l_rtz13,l_rtz28,l_azwacti          
     FROM rtz_file INNER JOIN azw_file          
       ON rtz01 = azw01                        
    WHERE rtz01 = g_lmbstore
   CASE
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-001'
                                    LET l_rtz13 = NULL
      WHEN l_azwacti = 'N'          LET g_errno = '9028'      
      WHEN l_rtz28='N'              LET g_errno = 'alm-002'
                                    LET g_lmbstore = ''
                                    LET g_lmblegal = ''
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) or p_cmd = 'd' THEN
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lmblegal

      LET g_azt02 = l_azt02
      LET g_rtz13  = l_rtz13
     # DISPLAY g_rtz13,g_azt02 TO rzt13,azt02
      DISPLAY g_azt02 TO FORMONLY.azt02
      DISPLAY g_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION

FUNCTION i110_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("lmb02",TRUE)
  END IF
END FUNCTION

FUNCTION i110_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lmb02",FALSE)
  END IF
  CALL cl_set_comp_entry("lmbstore",FALSE)
END FUNCTION

FUNCTION i110_r()        
   DEFINE   l_cnt   LIKE type_file.num5,
            l_lmb   RECORD LIKE lmb_file.*,
            l_n     LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_lmbstore) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lmbstore<>g_plant THEN
      CALL cl_err('','alm1023',1)
      RETURN
   END IF

   
   SELECT COUNT(*) INTO l_n FROM lmc_file 
    WHERE lmcstore = g_lmbstore
      AND lmc02 IN ( SELECT lmb02 FROM lmb_file WHERE lmbstore = g_lmbstore)

   IF l_n > 0 THEN
      CALL cl_err('','alm1029',1)
      RETURN
   END IF 

   BEGIN WORK

   LET g_lmbstore_t = g_lmbstore
   OPEN i110_cl USING g_lmbstore
   IF STATUS THEN
      CALL cl_err("OPEN i110_cl:", STATUS, 1)
      CLOSE i110_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i110_cl INTO g_lmb_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmbstore,SQLCA.sqlcode,0)
      CLOSE i110_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i110_show()

   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "lmbstore"
      LET g_doc.value1 = g_lmbstore
      CALL cl_del_doc()

      DELETE FROM lmb_file WHERE lmbstore = g_lmbstore

      CLEAR FORM
      CALL g_lmb_l.clear()

      OPEN i110_count
      FETCH i110_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      OPEN i110_curs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i110_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i110_fetch('/')
      END IF
   ELSE
      CALL i110_b_fill(' 1=1')
   END IF

   CLOSE i110_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lmbstore,'D')
END FUNCTION

FUNCTION i110_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,
      l_n             LIKE type_file.num5,
      l_cnt           LIKE type_file.num5,
      l_lock_sw       LIKE type_file.chr1,
      p_cmd           LIKE type_file.chr1,
      l_allow_insert  LIKE type_file.chr1,
      l_allow_delete  LIKE type_file.chr1

   LET g_action_choice = ""
   
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lmbstore IS NULL THEN RETURN END IF

   IF g_lmbstore <> g_plant THEN
      CALL cl_err('','alm1023',1)
      RETURN
   END IF 

   SELECT * INTO g_lla.* FROM lla_file WHERE llastore = g_plant #FUN-B80141

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT lmb02,lmb03,lmb07,lmb08,lmb05,lmb09,lmb04,lmb06 ",
                      " FROM lmb_file WHERE ",
                      " lmbstore = ? AND lmb02=? AND lmblegal=? FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i110_bcl CURSOR FROM g_forupd_sql      

   INPUT ARRAY g_lmb_l WITHOUT DEFAULTS FROM s_lmb_l.*
             ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
             INSERT ROW = l_allow_insert,
             DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_lmb_l_t.* = g_lmb_l[l_ac].*  #BACKUP

            OPEN i110_bcl USING g_lmbstore,g_lmb_l_t.lmb02,g_lmblegal
            IF STATUS THEN
               CALL cl_err("OPEN i110_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i110_bcl INTO g_lmb_l[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_lmbstore_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i110_lmbstore('d')
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
             
      BEFORE INSERT
         LET p_cmd='a'
         LET l_n = ARR_COUNT()
         LET  g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE
         INITIALIZE g_lmb_l[l_ac].* TO NULL

         LET g_lmb_l[l_ac].lmb06 = 'Y'       #Body default
         LET g_lmb_l_t.* = g_lmb_l[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD lmb02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         INSERT INTO lmb_file(lmbstore,lmblegal,lmb02,lmb03,lmb07,lmb08,lmb05,lmb09,lmb04,lmb06)
                       VALUES(g_lmbstore,g_lmblegal,g_lmb_l[l_ac].lmb02,g_lmb_l[l_ac].lmb03,
                              g_lmb_l[l_ac].lmb07,g_lmb_l[l_ac].lmb08,g_lmb_l[l_ac].lmb05,
                              g_lmb_l[l_ac].lmb09,g_lmb_l[l_ac].lmb04,g_lmb_l[l_ac].lmb06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lmb_file",g_lmbstore,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL i110_b_fill2(' 1=1')
         END IF

      AFTER FIELD lmb02
         IF NOT cl_null(g_lmb_l[l_ac].lmb02) THEN
            IF g_lmb_l[l_ac].lmb02 != g_lmb_l_t.lmb02 OR
               g_lmb_l_t.lmb02 IS NULL THEN
               
               SELECT COUNT(*) INTO l_n FROM lmc_file
                WHERE lmcstore = g_lmbstore 
                  AND lmc02 = g_lmb_l_t.lmb02
               
               IF l_n > 0 THEN
                  CALL cl_err('','alm1027',1)
                  LET g_lmb_l[l_ac].lmb02= g_lmb_l_t.lmb02
                  NEXT FIELD lmb02
               END IF

               SELECT count(*) INTO l_n FROM lmb_file
                WHERE lmbstore = g_lmbstore
                  AND lmb02 = g_lmb_l[l_ac].lmb02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lmb_l[l_ac].lmb02 = g_lmb_l_t.lmb02
                  NEXT FIELD lmb02
               END IF
            END IF
         END IF     
      
      AFTER FIELD lmb06
         IF g_lmb_l[l_ac].lmb06 ='N' THEN
            SELECT count(*) INTO l_n FROM lmc_file
             WHERE lmcstore = g_lmbstore
               AND lmc02 = g_lmb_l[l_ac].lmb02
            IF l_n >0 THEN
               CALL cl_err('','alm-019',1)
               LET g_lmb_l[l_ac].lmb06 = 'Y'
               NEXT FIELD lmb06
            END IF
         END IF

      AFTER FIELD lmb07
         IF NOT cl_null(g_lmb_l[l_ac].lmb07) THEN
            IF g_lmb_l[l_ac].lmb07 <0 THEN
               CALL cl_err ('','alm1024',0)
               LET g_lmb_l[l_ac].lmb07=g_lmb_l_t.lmb07
               NEXT FIELD lmb07
            END IF
           #FUN-B80141 Begin--- By shi
            IF cl_null(g_lla.lla03) THEN
               CALL cl_err('','alm1172',0)
               NEXT FIELD lmb07
            ELSE
               LET g_lmb_l[l_ac].lmb07 = cl_digcut(g_lmb_l[l_ac].lmb07,g_lla.lla03)
            END IF
           #FUN-B80141 End-----
         END IF

      AFTER FIELD lmb08
         IF NOT cl_null(g_lmb_l[l_ac].lmb08) THEN
            IF g_lmb_l[l_ac].lmb08 <0 THEN
               CALL cl_err ('','alm1025',0)
               LET g_lmb_l[l_ac].lmb08=g_lmb_l_t.lmb08
               NEXT FIELD lmb08
            END IF
           #FUN-B80141 Begin--- By shi
            IF cl_null(g_lla.lla03) THEN
               CALL cl_err('','alm1172',0)
               NEXT FIELD lmb08
            ELSE
               LET g_lmb_l[l_ac].lmb08 = cl_digcut(g_lmb_l[l_ac].lmb08,g_lla.lla03)
            END IF
           #FUN-B80141 End-----
         END IF  

      BEFORE DELETE

         IF g_lmbstore IS NOT NULL THEN

            SELECT count(*) INTO l_n FROM lmc_file
             WHERE lmcstore = g_lmbstore
               AND lmc02 = g_lmb_l[l_ac].lmb02

            IF l_n >0 THEN
               CALL cl_err('','alm-019',1)
               CANCEL DELETE
            END IF

            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
            END IF
            DELETE FROM lmb_file WHERE lmbstore = g_lmbstore
                                   AND lmb02 = g_lmb_l_t.lmb02
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lmb_file",g_lmbstore_t,"",SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
            END IF

            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            MESSAGE "Delete OK"
            CLOSE i110_bcl
            COMMIT WORK
            CALL i110_b_fill2(' 1=1')
         END IF   

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lmb_l[l_ac].* = g_lmb_l_t.*
            CLOSE i110_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_lmbstore,-263,1)
            LET g_lmb_l[l_ac].* = g_lmb_l_t.*
         ELSE
            UPDATE lmb_file SET 
                                lmb02 = g_lmb_l[l_ac].lmb02,
                                lmb03 = g_lmb_l[l_ac].lmb03,
                                lmb07 = g_lmb_l[l_ac].lmb07,
                                lmb08 = g_lmb_l[l_ac].lmb08,
                                lmb05 = g_lmb_l[l_ac].lmb05,
                                lmb09 = g_lmb_l[l_ac].lmb09,
                                lmb04 = g_lmb_l[l_ac].lmb04,
                                lmb06 = g_lmb_l[l_ac].lmb06
                          WHERE lmbstore = g_lmbstore_t
                            AND lmb02 = g_lmb_l_t.lmb02

            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","lmb_file",g_lmbstore_t,"",SQLCA.sqlcode,"","",1)
               LET g_lmb_l[l_ac].* = g_lmb_l_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i110_bcl
               COMMIT WORK
               CALL i110_b_fill2(' 1=1') 
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac          #FUN-D30033

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0

            IF p_cmd = 'u' THEN
               LET g_lmb_l[l_ac].* = g_lmb_l_t.*
            #FUN-D30033----add--str
            ELSE
               CALL g_lmb_l.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033---add--end
            END IF

            CLOSE i110_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac          #FUN-D30033
         CLOSE i110_bcl
         COMMIT WORK

      ON ACTION CONTROLO
         IF l_ac > 1 THEN                       
            LET g_lmb_l[l_ac].* = g_lmb_l[l_ac-1].*
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode())
               RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about
          CALL cl_about()

      ON ACTION help
          CALL cl_show_help()

   END INPUT
   CLOSE i110_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i110_bp(p_ud)

   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_lmb_l TO s_lmb_l.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
        
         BEFORE ROW
            LET g_flag=1
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
         
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG

         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION first                            # 第一筆
            CALL i110_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT  DIALOG
         
         ON ACTION previous
            CALL i110_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT  DIALOG        
   
         ON ACTION jump                             # 指定筆
            CALL i110_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT  DIALOG

         ON ACTION next                             # N.下筆
            CALL i110_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT  DIALOG

         ON ACTION last                             # 最終筆
            CALL i110_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DIALOG

         ON ACTION invoicefloor
            LET g_action_choice="invoicefloor"
            EXIT DIALOG
  
         
         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG

         #TQC-C30136--mark--str--
         #ON ACTION exporttoexcel
         #   LET g_action_choice = 'exporttoexcel'
         #   EXIT DIALOG  
         #TQC-C30136--mark--end--

         ON ACTION detail
            LET g_action_choice="detail"
            EXIT DIALOG
      END DISPLAY

      DISPLAY ARRAY g_lmb TO s_lmb.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET g_flag=2
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

       ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION accept
         IF g_flag=1 THEN
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
         END IF
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG  

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i110_b_fill(p_wc)
    DEFINE p_wc     LIKE type_file.chr1000

    LET g_sql = "SELECT lmb02,lmb03,lmb07,lmb08,lmb05,lmb09,lmb04,lmb06",
                " FROM lmb_file",
                " WHERE ", p_wc CLIPPED,
                "   AND lmbstore IN ",g_auth, 
                "   AND lmblegal= '",g_lmblegal,"'",
                " ORDER BY lmbstore,lmb02 "
    PREPARE i110_pb FROM g_sql
    DECLARE lmb_curs CURSOR FOR i110_pb

    CALL g_lmb_l.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"

    FOREACH lmb_curs INTO g_lmb_l[g_cnt].*
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1

       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF

    END FOREACH

    CALL g_lmb_l.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i110_b_fill2(p_wc)
   DEFINE p_wc     LIKE type_file.chr1000

    LET g_sql = "SELECT lmbstore,'',lmblegal,'',lmb02,lmb03,lmb07,lmb08,lmb05,lmb09,lmb04,lmb06",
                " FROM lmb_file",
                " WHERE ", p_wc CLIPPED,
                "   AND lmbstore IN ",g_auth, 
                " ORDER BY lmbstore,lmb02 "
    PREPARE i110_pb2 FROM g_sql
    DECLARE lmb_curs2 CURSOR FOR i110_pb2

    CALL g_lmb.clear()
    LET g_cnt2 = 1
    MESSAGE "Searching!"

    FOREACH lmb_curs2 INTO g_lmb[g_cnt2].*
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF

       SELECT rtz13 INTO g_lmb[g_cnt2].rtz13 FROM rtz_file
        WHERE rtz01 = g_lmbstore
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","rtz_file",g_lmb[g_cnt2].rtz13,"",SQLCA.sqlcode,"","",0)
          LET g_rtz13 = NULL
       END IF

       SELECT azt02 INTO g_lmb[g_cnt2].azt02 FROM azt_file
        WHERE azt01 = g_lmblegal
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","azt_file",g_lmb[g_cnt2].azt02,"",SQLCA.sqlcode,"","",0)
          LET g_azt02 = NULL
       END IF

       LET g_cnt2 = g_cnt2 + 1
       IF g_cnt2 > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH

    CALL g_lmb.deleteElement(g_cnt2)
    MESSAGE ""
    LET g_rec_b2 = g_cnt2-1
    DISPLAY g_rec_b2 TO FORMONLY.cn3
    LET g_cnt2 = 0
END FUNCTION

FUNCTION i110_invoice()
   DEFINE l_cmd LIKE type_file.chr1000
  #LET g_wc = " 1=1"
  #CALL i110_show()
   LET l_cmd =  "almi120 '",g_lmbstore,"' '" ,g_lmb[l_ac].lmb02 CLIPPED, "'" 
  #LET l_cmd =  "almi120 " #Mod By shi
   CALL cl_cmdrun(l_cmd)
   RETURN
END FUNCTION

FUNCTION i110_out()
   DEFINE l_cmd LIKE type_file.chr1000

    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_cmd = 'p_query "almi110" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
    RETURN
END FUNCTION

#FUN-B80141--end add--------------------------------------------

#FUN-B80141--start mark----------------------------------------- 
#FUNCTION i110_b()
#DEFINE
#    l_ac_t          LIKE type_file.num5,    
#    l_n             LIKE type_file.num5,     
#    l_cnt           LIKE type_file.num5,
#    l_lock_sw       LIKE type_file.chr1,  
#    p_cmd           LIKE type_file.chr1,   
#    l_allow_insert  LIKE type_file.chr1,   
#    l_allow_delete  LIKE type_file.chr1    
##DEFINE l_tqa06     LIKE tqa_file.tqa06
# 
#    LET g_action_choice = ""
# 
#####判斷當前組織機構是否是門店，只能在門店錄資料######
##  SELECT tqa06 INTO l_tqa06 FROM tqa_file
##   WHERE tqa03 = '14'
##     AND tqaacti = 'Y'
##     AND tqa01 IN(SELECT tqb03 FROM tqb_file
##                   WHERE tqbacti = 'Y'
##                     AND tqb09 = '2'
##                     AND tqb01 = g_plant)
##  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN
##     CALL cl_err('','alm-600',1)
##     CALL g_lmb.clear()
##     RETURN 
##  END IF  
#           
##  SELECT COUNT(*) INTO l_cnt FROM rtz_file
##   WHERE rtz01 = g_plant 
##     AND rtz28 = 'Y'
##  IF l_cnt < 1 THEN
##     CALL cl_err('','alm-606',1)
##     CALL g_lmb.clear()
##     RETURN 
##  END IF
#######################################################
# 
#    IF s_shut(0) THEN RETURN END IF
# 
#    LET l_allow_insert = cl_detail_input_auth('insert')
#    LET l_allow_delete = cl_detail_input_auth('delete')
# 
#    CALL cl_opmsg('b')
# 
#    LET g_forupd_sql = "SELECT lmbstore,'',lmblegal,'',lmb02,lmb03,lmb04,lmb05,lmb06 ",
#                       " FROM lmb_file WHERE ",
#                       " lmbstore = ? AND lmb02=? FOR UPDATE "
# 
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
# 
#    INPUT ARRAY g_lmb WITHOUT DEFAULTS FROM s_lmb.*
#              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#              INSERT ROW = l_allow_insert,
#              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
# 
#        BEFORE INPUT
#            IF g_rec_b != 0 THEN
#              CALL fgl_set_arr_curr(l_ac) 
#            END IF
# 
#        BEFORE ROW
#            LET p_cmd = ''
#            LET l_ac = ARR_CURR()
#            LET l_lock_sw = 'N'            #DEFAULT
#            LET l_n  = ARR_COUNT()
#            IF g_rec_b>=l_ac THEN
#               BEGIN WORK
#               LET p_cmd='u'
#               LET  g_before_input_done = FALSE 
#               CALL i110_set_entry(p_cmd)
#               CALL i110_set_no_entry(p_cmd) 
#               LET  g_before_input_done = TRUE 
# 
#               LET g_lmb_t.* = g_lmb[l_ac].*  #BACKUP
#               OPEN i110_bcl USING g_lmb_t.lmbstore,g_lmb_t.lmb02
#               IF STATUS THEN
#                  CALL cl_err("OPEN i110_bcl:", STATUS, 1)
#                  LET l_lock_sw = "Y"
#               ELSE   
#                  FETCH i110_bcl INTO g_lmb[l_ac].* 
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_lmb_t.lmbstore,SQLCA.sqlcode,1)
#                     LET l_lock_sw = "Y"
#                  ELSE
#                     CALL i110_lmbstore('d')
#                  END IF
#               END IF
#               CALL cl_show_fld_cont()  
#            END IF
# 
#        BEFORE INSERT
#            LET p_cmd='a'
#            LET l_n = ARR_COUNT()
#            LET  g_before_input_done = FALSE
#            CALL i110_set_entry(p_cmd)
#            CALL i110_set_no_entry(p_cmd)
#            LET  g_before_input_done = TRUE
#            INITIALIZE g_lmb[l_ac].* TO NULL
#            LET g_lmb[l_ac].lmbstore = g_plant
#            LET g_lmb[l_ac].lmblegal = g_legal
#            LET g_lmb[l_ac].lmb04 = 0
#            LET g_lmb[l_ac].lmb05 = 0
#            LET g_lmb[l_ac].lmb06 = 'Y'       #Body default
#            LET g_lmb_t.* = g_lmb[l_ac].*
#            CALL cl_show_fld_cont()    
#            NEXT FIELD lmbstore
# 
#        AFTER INSERT
#            IF INT_FLAG THEN
#               CALL cl_err('',9001,0)
#               LET INT_FLAG = 0
#               CANCEL INSERT
#            END IF
#            INSERT INTO lmb_file(lmbstore,lmblegal,lmb02,lmb03,lmb04,lmb05,lmb06)
#                          VALUES(g_lmb[l_ac].lmbstore,g_lmb[l_ac].lmblegal,
#                                 g_lmb[l_ac].lmb02,
#                                 g_lmb[l_ac].lmb03,g_lmb[l_ac].lmb04,
#                                 g_lmb[l_ac].lmb05,g_lmb[l_ac].lmb06)
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("ins","lmb_file",g_lmb[l_ac].lmbstore,"",SQLCA.sqlcode,"","",1)
#               CANCEL INSERT
#            ELSE
#               MESSAGE 'INSERT O.K'
#               COMMIT WORK
#               LET g_rec_b=g_rec_b+1
#               DISPLAY g_rec_b TO FORMONLY.cn2  
#            END IF
# 
#        AFTER FIELD lmbstore
#            IF NOT cl_null(g_lmb[l_ac].lmbstore) THEN
#               CALL i110_lmbstore('a')
#               IF NOT cl_null(g_errno) THEN     
#                  CALL cl_err(g_lmb[l_ac].lmbstore,g_errno,1)
#                  LET g_lmb[l_ac].lmbstore = g_lmb_t.lmbstore
#                  EXIT INPUT
#               END IF
#            END IF
# 
#         AFTER FIELD lmb02                                          
#             IF NOT cl_null(g_lmb[l_ac].lmb02) THEN                                
#                IF g_lmb[l_ac].lmb02 != g_lmb_t.lmb02 OR                           
#                   g_lmb_t.lmb02 IS NULL THEN                                      
#                   SELECT count(*) INTO l_n FROM lmb_file                          
#                    WHERE lmbstore = g_lmb[l_ac].lmbstore                                
#                      AND lmb02 = g_lmb[l_ac].lmb02     
#                   IF l_n > 0 THEN                                                 
#                      CALL cl_err('',-239,0)                                       
#                      LET g_lmb[l_ac].lmb02 = g_lmb_t.lmb02                        
#                      NEXT FIELD lmb02                                             
#                   END IF                                                          
#                END IF                                                             
#             END IF
# 
#        AFTER FIELD lmb06
#           IF g_lmb[l_ac].lmb06 ='N' THEN
#              SELECT count(*) INTO l_n FROM lmc_file 
#               WHERE lmcstore = g_lmb[l_ac].lmbstore
#                 AND lmc02 = g_lmb[l_ac].lmb02
#              IF l_n >0 THEN
#                 CALL cl_err('','alm-019',1)
#                 lET g_lmb[l_ac].lmb06 = 'Y'
#                 NEXT FIELD lmb06
#              END IF
#           END IF
# 
#        BEFORE DELETE 
#            IF g_lmb_t.lmbstore IS NOT NULL THEN
#               SELECT count(*) INTO l_n FROM lmc_file
#                WHERE lmcstore = g_lmb[l_ac].lmbstore
#                  AND lmc02 = g_lmb[l_ac].lmb02
#               IF l_n >0 THEN
#                  CALL cl_err('','alm-019',1)
#                  CANCEL DELETE
#               END IF
#               IF NOT cl_delete() THEN
#                  CANCEL DELETE
#               END IF
#               IF l_lock_sw = "Y" THEN 
#                   CALL cl_err("", -263, 1) 
#                   CANCEL DELETE 
#               END IF 
#               DELETE FROM lmb_file WHERE lmbstore = g_lmb_t.lmbstore
#                                      AND lmb02 = g_lmb_t.lmb02
#               IF SQLCA.sqlcode THEN
#                   CALL cl_err3("del","lmb_file",g_lmb_t.lmbstore,"",SQLCA.sqlcode,"","",1) 
#                   EXIT INPUT
#               END IF
#               LET g_rec_b=g_rec_b-1
#               DISPLAY g_rec_b TO FORMONLY.cn2  
#               MESSAGE "Delete OK"
#               CLOSE i110_bcl 
#               COMMIT WORK
#            END IF
# 
#        ON ROW CHANGE
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              LET g_lmb[l_ac].* = g_lmb_t.*
#              CLOSE i110_bcl
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           IF l_lock_sw = 'Y' THEN
#              CALL cl_err(g_lmb[l_ac].lmbstore,-263,1)
#              LET g_lmb[l_ac].* = g_lmb_t.*
#           ELSE
#              UPDATE lmb_file SET lmbstore = g_lmb[l_ac].lmbstore,
#                                  lmblegal = g_lmb[l_ac].lmblegal,
#                                  lmb02 = g_lmb[l_ac].lmb02,
#                                  lmb03 = g_lmb[l_ac].lmb03,
#                                  lmb04 = g_lmb[l_ac].lmb04,
#                                  lmb05 = g_lmb[l_ac].lmb05,
#                                  lmb06 = g_lmb[l_ac].lmb06
#                            WHERE lmbstore = g_lmb_t.lmbstore 
#                              AND lmb02 = g_lmb_t.lmb02
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err3("upd","lmb_file",g_lmb_t.lmbstore,"",SQLCA.sqlcode,"","",1) 
#                 LET g_lmb[l_ac].* = g_lmb_t.*
#              ELSE
#                 MESSAGE 'UPDATE O.K'
#                 CLOSE i110_bcl
#                 COMMIT WORK
#              END IF
#           END IF
# 
#        AFTER ROW
#            LET l_ac = ARR_CURR()
#            LET l_ac_t = l_ac
#            IF INT_FLAG THEN
#               CALL cl_err('',9001,0)
#               LET INT_FLAG = 0
#               IF p_cmd = 'u' THEN
#                  LET g_lmb[l_ac].* = g_lmb_t.* 
#               END IF
#               CLOSE i110_bcl
#               ROLLBACK WORK
#               EXIT INPUT
#            END IF
#            CLOSE i110_bcl
#            COMMIT WORK 
# 
#        ON ACTION CONTROLO
#        #   IF INFIELD(lmbstore) AND l_ac > 1 THEN #MOD-AC0250 MARK
#            IF l_ac > 1 THEN                       #MOD-AC0250 ADD
#               LET g_lmb[l_ac].* = g_lmb[l_ac-1].* 
#        #      LET g_lmb[l_ac].lmbstore = NULL     #MOD-AC0250 MARK
#        #      NEXT FIELD lmbstore                 #MOD-AC0250 MARK
#            END IF
#            
#        ON ACTION controlp
#         CASE
#            WHEN INFIELD(lmbstore)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_rtz"
#               LET g_qryparam.where = " rtz01 IN ",g_auth," "   #No.FUN-A10060
#               LET g_qryparam.default1 = g_lmb[l_ac].lmbstore
#               CALL cl_create_qry() RETURNING g_lmb[l_ac].lmbstore
#               DISPLAY BY NAME g_lmb[l_ac].lmbstore
#               CALL i110_lmbstore('d')
#               NEXT FIELD lmbstore
#            OTHERWISE EXIT CASE
#         END CASE
# 
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#        ON ACTION CONTROLF
#            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#                 RETURNING g_fld_name,g_frm_name 
#            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
#          
#        ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#        ON ACTION about       
#            CALL cl_about()     
# 
#        ON ACTION help         
#            CALL cl_show_help()
#         
#    END INPUT
#    CLOSE i110_bcl
#    COMMIT WORK
#END FUNCTION
# 
#FUNCTION i110_lmbstore(p_cmd)
#   DEFINE l_rtz01    LIKE rtz_file.rtz01 
#   DEFINE l_rtz13    LIKE rtz_file.rtz13,
#          l_rtz28    LIKE rtz_file.rtz28,
#        # l_rtzacti  LIKE rtz_file.rtzacti,              #FUN-A80148 mark by vealxu
#          l_azwacti  LIKE azw_file.azwacti,              #FUN-A80148 add by vealxu
#          p_cmd      LIKE type_file.chr1
#   DEFINE l_azt02    LIKE azt_file.azt02
# 
#   LET g_errno = ' '
#   SELECT rtz01,rtz13,rtz28,azwacti                     #FUN-A80148 rtzacti --->azwacti mod by vealxu
#     INTO l_rtz01,l_rtz13,l_rtz28,l_azwacti             #FUN-A80148 l_rtzacti -->l_azwacti mod by vealxu
#     FROM rtz_file INNER JOIN azw_file                  #FUN-A80148 add azw_file add by vealxu
#       ON rtz01 = azw01                                 #FUN-A80148 add by vealxu
#    WHERE rtz01 = g_lmb[l_ac].lmbstore 
#   CASE 
#      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-001'
#                                    LET l_rtz13 = NULL
##     WHEN l_rtzacti='N'            LET g_errno = '9028'          #FUN-A80148 mark by vealxu
#      WHEN l_azwacti = 'N'          LET g_errno = '9028'          #FUN-A80148 add  by vealxu
#      WHEN l_rtz28='N'              LET g_errno = 'alm-002'
##     WHEN l_rtz01 <> g_plant       LET g_errno = 'alm-376'
#      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
# 
#   IF cl_null(g_errno) or p_cmd = 'd' THEN
#      SELECT azt02 INTO l_azt02 FROM azt_file
#       WHERE azt01 = g_lmb[l_ac].lmblegal
#      LET g_lmb[l_ac].azt02 = l_azt02
#      LET g_lmb[l_ac].rtz13  = l_rtz13
#      DISPLAY BY NAME g_lmb[l_ac].rtz13,g_lmb[l_ac].azt02
#   END IF
#END FUNCTION
# 
#FUNCTION i110_b_askkey()
#    CLEAR FORM
#    CALL g_lmb.clear()
#    CONSTRUCT g_wc2 ON lmbstore,lmblegal,lmb02,lmb03,lmb04,lmb05,lmb06
#            FROM s_lmb[1].lmbstore,s_lmb[1].lmblegal,s_lmb[1].lmb02,s_lmb[1].lmb03,s_lmb[1].lmb04,
#                 s_lmb[1].lmb05,s_lmb[1].lmb06
# 
#      BEFORE CONSTRUCT
#          CALL cl_qbe_init()
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about       
#         CALL cl_about()     
# 
#      ON ACTION help        
#         CALL cl_show_help()
# 
#      ON ACTION controlg    
#         CALL cl_cmdask() 
#         
#      ON ACTION controlp
#         CASE
#            WHEN INFIELD(lmbstore)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form = "q_lmbstore"
#               LET g_qryparam.where = " lmbstore IN ",g_auth," "   #No.FUN-A10060
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO lmbstore
#               NEXT FIELD lmbstore
#            WHEN INFIELD(lmb02)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_lmb02"
#               LET g_qryparam.state = "c"
#               LET g_qryparam.where = " lmbstore IN ",g_auth," "   #No.FUN-A10060
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO lmb02
#               NEXT FIELD lmb02
#            WHEN INFIELD(lmblegal)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_lmblegal"
#               LET g_qryparam.state = "c"
#               LET g_qryparam.where = " lmbstore IN ",g_auth," "   #No.FUN-A10060
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO lmblegal
#               NEXT FIELD lmblegal
#            OTHERWISE EXIT CASE
#         END CASE
#      
#      ON ACTION qbe_select
#         CALL cl_qbe_select() 
#         
#      ON ACTION qbe_save
#	 CALL cl_qbe_save()
# 
#    END CONSTRUCT
#    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#    
#    IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      LET g_wc2 = NULL
#      LET g_rec_b = 0
#      RETURN
#    END IF
#    CALL i110_b_fill(g_wc2)
#END FUNCTION
# 
#FUNCTION i110_b_fill(p_wc2)
#    DEFINE p_wc2     LIKE type_file.chr1000  
#    LET g_sql = "SELECT lmbstore,'',lmblegal,'',lmb02,lmb03,lmb04,lmb05,lmb06",
#                " FROM lmb_file",
#                " WHERE ", p_wc2 CLIPPED,
#                "   AND lmbstore IN ",g_auth, #No.FUN-A10060
#                " ORDER BY lmbstore,lmb02 "
#    PREPARE i110_pb FROM g_sql
#    DECLARE lmb_curs CURSOR FOR i110_pb
# 
#    CALL g_lmb.clear()
#    LET g_cnt = 1
#    MESSAGE "Searching!" 
#    FOREACH lmb_curs INTO g_lmb[g_cnt].*  
#       IF STATUS THEN 
#          CALL cl_err('foreach:',STATUS,1)
#          EXIT FOREACH
#       END IF
#       SELECT rtz13 INTO g_lmb[g_cnt].rtz13 FROM rtz_file
#        WHERE rtz01 = g_lmb[g_cnt].lmbstore
#       IF SQLCA.sqlcode THEN
#          CALL cl_err3("sel","rtz_file",g_lmb[g_cnt].rtz13,"",SQLCA.sqlcode,"","",0)
#          LET g_lmb[g_cnt].rtz13 = NULL
#       END IF   
#       SELECT azt02 INTO g_lmb[g_cnt].azt02 FROM azt_file
#        WHERE azt01 = g_lmb[g_cnt].lmblegal
#       IF SQLCA.sqlcode THEN
#          CALL cl_err3("sel","azt_file",g_lmb[g_cnt].azt02,"",SQLCA.sqlcode,"","",0)
#          LET g_lmb[g_cnt].azt02 = NULL
#       END IF
#       LET g_cnt = g_cnt + 1
#       IF g_cnt > g_max_rec THEN
#          CALL cl_err( '', 9035, 0 )
#          EXIT FOREACH
#       END IF
#    END FOREACH
#    CALL g_lmb.deleteElement(g_cnt)
#    MESSAGE ""
#    LET g_rec_b = g_cnt-1
#    DISPLAY g_rec_b TO FORMONLY.cn2  
#    LET g_cnt = 0
# 
#END FUNCTION
# 
#FUNCTION i110_bp(p_ud)
# 
#   DEFINE   p_ud   LIKE type_file.chr1    
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
#      RETURN                                                                    
#   END IF                                                                       
#   LET g_action_choice = " "
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_lmb TO s_lmb.* ATTRIBUTE(COUNT=g_rec_b)
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()
#     
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      
#      ON ACTION detail
#         LET g_action_choice="detail"
#         EXIT DISPLAY
#
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
#
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON ACTION controlg 
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#
#      ON ACTION accept                                                          
#         LET g_action_choice="detail"                                           
#         LET l_ac = ARR_CURR()                                                  
#         EXIT DISPLAY                
#                                                                                                                      
#      ON ACTION cancel                                                          
#         LET INT_FLAG=FALSE 		
#         LET g_action_choice="exit"                                             
#         EXIT DISPLAY         
#                                                  
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#
#      ON ACTION about         
#         CALL cl_about() 
#         
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
# 
#FUNCTION i110_set_entry(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1
#  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
#     CALL cl_set_comp_entry("lmbstore,lmb02",TRUE)
#  END IF
#END FUNCTION 
# 
#FUNCTION i110_set_no_entry(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1 
#  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN 
#     CALL cl_set_comp_entry("lmbstore,lmb02",FALSE)
#  END IF
#  CALL cl_set_comp_entry("lmbstore",FALSE)
#END FUNCTION
# 
#FUNCTION i110_out()
#DEFINE l_cmd LIKE type_file.chr1000
# 
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('','9057',0)
#       RETURN
#    END IF
#    LET l_cmd = 'p_query "almi110" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd) 
#    RETURN
#END FUNCTION
##FUN-870015
##FUN-A60064 10/06/23 By shiwuying 非T/S類table中的xxxplant替換成xxxstore
#FUN-B80141--end mark----------------------------------------------------
