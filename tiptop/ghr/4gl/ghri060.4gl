# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri060.4gl
# Descriptions...: 薪资发放周期维护
# Date & Author..: 13/05/09 By yangjian
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_hrct         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        identity     LIKE type_file.chr100,   
        hrct01       LIKE hrct_file.hrct01,   
        hrct02       LIKE hrct_file.hrct02,   
        hrct07       LIKE hrct_file.hrct07,   
        hrct08       LIKE hrct_file.hrct08,   
        hrct04       LIKE hrct_file.hrct04,  
        hrct05       LIKE hrct_file.hrct05, 
        hrct06       LIKE hrct_file.hrct06,  
        hrct09       LIKE hrct_file.hrct09, 
        hrct03       LIKE hrct_file.hrct03, 
        hrct03_desc  LIKE type_file.chr100,
        hrct12       LIKE hrct_file.hrct12
                    END RECORD,
    g_hrct_t         RECORD                 #程式變數 (舊值)
        identity     LIKE type_file.chr100,   
        hrct01       LIKE hrct_file.hrct01,   
        hrct02       LIKE hrct_file.hrct02,   
        hrct07       LIKE hrct_file.hrct07,   
        hrct08       LIKE hrct_file.hrct08,   
        hrct04       LIKE hrct_file.hrct04,  
        hrct05       LIKE hrct_file.hrct05, 
        hrct06       LIKE hrct_file.hrct06,  
        hrct09       LIKE hrct_file.hrct09, 
        hrct03       LIKE hrct_file.hrct03, 
        hrct03_desc  LIKE type_file.chr100,
        hrct12       LIKE hrct_file.hrct12
                    END RECORD,
     g_hrct_a       DYNAMIC ARRAY OF RECORD
        identity_a     LIKE type_file.chr100,   
        hrct01_a       LIKE hrct_file.hrct01,   
        hrct02_a       LIKE hrct_file.hrct02,   
        hrct07_a       LIKE hrct_file.hrct07,   
        hrct08_a       LIKE hrct_file.hrct08,   
        hrct04_a       LIKE hrct_file.hrct04,  
        hrct05_a       LIKE hrct_file.hrct05, 
        hrct06_a       LIKE hrct_file.hrct06,  
        hrct09_a       LIKE hrct_file.hrct09, 
        hrct03_a       LIKE hrct_file.hrct03, 
        hrct03_desc_a  LIKE type_file.chr100,
        hrct12_a       LIKE hrct_file.hrct12
                    END RECORD,
     g_hrct_a_t     RECORD
        identity_a     LIKE type_file.chr100,   
        hrct01_a       LIKE hrct_file.hrct01,   
        hrct02_a       LIKE hrct_file.hrct02,   
        hrct07_a       LIKE hrct_file.hrct07,   
        hrct08_a       LIKE hrct_file.hrct08,   
        hrct04_a       LIKE hrct_file.hrct04,  
        hrct05_a       LIKE hrct_file.hrct05, 
        hrct06_a       LIKE hrct_file.hrct06,  
        hrct09_a       LIKE hrct_file.hrct09, 
        hrct03_a       LIKE hrct_file.hrct03, 
        hrct03_desc_a  LIKE type_file.chr100,
        hrct12_a       LIKE hrct_file.hrct12
                    END RECORD,                    
     g_hrcta        DYNAMIC ARRAY OF RECORD
        hrcta04      LIKE hrcta_file.hrcta04,
        hrcta05      LIKE hrcta_file.hrcta05,
        hrcta06      LIKE hrcta_file.hrcta06,
        hrcta07      LIKE hrcta_file.hrcta07,
        hrcta08      LIKE hrcta_file.hrcta08
                    END RECORD,
     g_hrcta_t      RECORD
        hrcta04      LIKE hrcta_file.hrcta04,
        hrcta05      LIKE hrcta_file.hrcta05,
        hrcta06      LIKE hrcta_file.hrcta06,
        hrcta07      LIKE hrcta_file.hrcta07,
        hrcta08      LIKE hrcta_file.hrcta08
                    END RECORD                   
DEFINE g_wc,g_sql    STRING 
DEFINE g_rec_b               LIKE type_file.num5
DEFINE g_rec_b2              LIKE type_file.num5
DEFINE g_rec_b3              LIKE type_file.num5      #No.FUN-680102 SMALLINT,              #單身筆數
DEFINE l_ac,l_ac2,l_ac3      LIKE type_file.num5      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT 
DEFINE g_forupd_sql          STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                 LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE g_before_input_done   LIKE type_file.num5      #No.FUN-680102 SMALLINT 
MAIN
DEFINE p_row,p_col           LIKE type_file.num5      #No.FUN-680102 SMALLINT
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081
   LET p_row = 5 LET p_col = 22
   OPEN WINDOW i060_w AT p_row,p_col WITH FORM "ghr/42f/ghri060" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
   CALL cl_ui_locale("ghri060")
   CALL i060_b_fill('1=1')
   CALL i060_menu()
   CLOSE WINDOW i060_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i060_menu()
 
   WHILE TRUE
      IF NOT cl_null(g_action_choice) AND g_action_choice="q2" THEN
         CALL i060_bp2("G")
      ELSE 
         CALL i060_bp1("G")
      END IF  
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i060_q()
            END IF 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i060_b()
            END IF 
         WHEN "q1"
            IF cl_chk_act_auth() THEN
               CALL i060_b_fill('1=1')
            END IF 
         WHEN "q2"
            IF cl_chk_act_auth() THEN
               CALL i060_b_fill2()
            END IF 
         WHEN "ghri0601"
            IF cl_chk_act_auth() THEN
               CALL ghri0601()
            END IF 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrct),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i060_q()
   CALL i060_b_askkey()
END FUNCTION

FUNCTION ghri0601()
DEFINE g_hrct   RECORD LIKE hrct_file.*
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_hraa12 LIKE hraa_file.hraa12
DEFINE l_i      LIKE type_file.num5
DEFINE l_n      LIKE type_file.num5
DEFINE l_p      LIKE type_file.num5
DEFINE l_year   LIKE type_file.num5
DEFINE l_hrbl   LIKE type_file.num5
DEFINE l_date   LIKE type_file.chr100
DEFINE l_blmx   LIKE hrbl_file.hrbl02
    OPEN WINDOW i0601_w WITH FORM "ghr/42f/ghri0601"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_locale("ghri0601")
    INPUT BY NAME g_hrct.hrct01,g_hrct.hrct03
#    INPUT BY NAME g_hrct.hrct01,g_hrct.hrct02,g_hrct.hrct07,g_hrct.hrct03,g_hrct.hrct04,g_hrct.hrct05,g_hrct.hrct12
                  WITHOUT DEFAULTS
       BEFORE INPUT
         SELECT nvl(MAX(hrct01),2013)+1 INTO l_year FROM hrct_file
         LET g_hrct.hrct01=l_year
         DISPLAY BY NAME g_hrct.hrct01
         SELECT nvl(MAX(hrbl04),2013)+1 INTO l_hrbl FROM hrbl_file
         IF l_hrbl <= l_year THEN 
            LET l_hrbl = l_year
            SELECT nvl(MAX(hrbl02),0) INTO l_blmx FROM hrbl_file
         ELSE 
            LET l_hrbl = 0
         END IF 
#          LET g_hrct.hrct07=g_today
#          DISPLAY BY NAME g_hrct.hrct07   

#       AFTER FIELD hrct01
#          IF NOT cl_null(g_hrct.hrct03) THEN 
#             SELECT count(*) INTO l_cnt FROM hrct_file
#              WHERE hrcr01=g_hrct.hrct01 AND hrct03=g_hrct.hrct03
#             IF l_cnt>0 THEN 
#                CALL cl_err('','hri-001',0)
#                NEXT FIELD hrct01
#             END IF 
#          END IF 
#          
       AFTER FIELD hrct03
          IF NOT cl_null(g_hrct.hrct01) THEN 
#             SELECT count(*) INTO l_cnt FROM hrct_file
#              WHERE hrcr01=g_hrct.hrct01 AND hrct03=g_hrct.hrct03
#             IF l_cnt>0 THEN 
#                CALL cl_err('','hri-001',0)
#                NEXT FIELD hrct03
#             END IF 
#          END IF 
#          SELECT count(*) INTO l_cnt FROM hraa_file
#           WHERE hraa01=g_hrct.hrct03
#          IF l_cnt=0 THEN
#              CALL cl_err('','hri-002',0)
#             NEXT FIELD hrct03
#          ELSE
             SELECT NVL(hraa02,hraa12) INTO l_hraa12 FROM hraa_file WHERE hraa01=g_hrct.hrct03
             DISPLAY l_hraa12 TO hraa12
          END IF 
#
#       AFTER FIELD hrct04
#          IF NOT cl_null(g_hrct.hrct05) THEN
#             SELECT count(*) INTO l_cnt FROM hrac_file
#              WHERE hrac01=g_hrct.hrct04 AND hrac02=g_hrct.hrct05
#             IF l_cnt=0 THEN 
#                CALL cl_err('','hri-003',0)
#                NEXT FIELD hrct04
#             END IF 
#          END IF 
#          
#       AFTER FIELD hrct05
#          IF NOT cl_null(g_hrct.hrct04) THEN
#             SELECT count(*) INTO l_cnt FROM hrac_file
#              WHERE hrac01=g_hrct.hrct04 AND hrac02=g_hrct.hrct05
#             IF l_cnt=0 THEN 
#                CALL cl_err('','hri-003',0)
#                NEXT FIELD hrct05
#             END IF 
#          END IF 
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121


       ON ACTION controlp
           CASE
              WHEN INFIELD(hrct03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hraa01"
                   CALL cl_create_qry() RETURNING g_hrct.hrct03
                   DISPLAY BY NAME g_hrct.hrct03
                   NEXT FIELD hrct03
              WHEN INFIELD(hrct04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrac01"
                   CALL cl_create_qry() RETURNING g_hrct.hrct04
                   DISPLAY BY NAME g_hrct.hrct04
                   NEXT FIELD hrct04
              WHEN INFIELD(hrct05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrac02_1"
                   LET g_qryparam.arg1 = g_hrct.hrct04
                   CALL cl_create_qry() RETURNING g_hrct.hrct05
                   DISPLAY BY NAME g_hrct.hrct05
                   NEXT FIELD hrct05
           END CASE
    END INPUT

    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW i0601_w
       RETURN
    END IF
    CLOSE WINDOW i0601_w
    LET l_p=g_hrct.hrct05
#    SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01='0000'
    FOR l_i=1 TO 12
         LET g_hrct.hrct02=l_i
         LET g_hrct.hrct11=g_hrct.hrct01,'-',g_hrct.hrct02,'(',l_hraa12,')'
         CASE l_i
            WHEN 1 
               LET l_date=g_hrct.hrct01,'/01/01'
               SELECT to_date(l_date,'yyyy/mm/dd') INTO g_hrct.hrct07 FROM dual
               LET l_date=g_hrct.hrct01,'/01/31'
               SELECT to_date(l_date,'yyyy/mm/dd') INTO g_hrct.hrct08 FROM dual
           # WHEN 2
           #    LET g_hrct.hrct07=g_hrct.hrct08+1
           #    LET l_date=g_hrct.hrct01,'/02/26'
           #    SELECT to_date(l_date,'yyyy/mm/dd') INTO g_hrct.hrct08 FROM dual
           # WHEN 12
           #    LET g_hrct.hrct07=g_hrct.hrct08+1
           #    LET l_date=g_hrct.hrct01,'/12/31'
           #    SELECT to_date(l_date,'yyyy/mm/dd') INTO g_hrct.hrct08 FROM dual
            OTHERWISE
               SELECT add_months(g_hrct.hrct07,1) INTO g_hrct.hrct07 FROM dual
               SELECT add_months(g_hrct.hrct08,1) INTO g_hrct.hrct08 FROM dual
             #  LET g_hrct.hrct07=g_hrct.hrct08+1
             #  LET l_date=g_hrct.hrct01,'/',g_hrct.hrct02,'/28'
             #  SELECT to_date(l_date,'yyyy/mm/dd') INTO g_hrct.hrct08 FROM dual
         END CASE 
#         添加薪资月信息
         INSERT INTO hrct_file(hrct01,hrct02,hrct03,hrct04,hrct05,hrct06,hrct07,hrct08,
                               hrct09,hrct10,hrct11,hrct12,hrctuser,hrctgrup,hrctmodu,
                               hrctdate,hrctacti,hrctoriu,hrctorig)
                           VALUES(g_hrct.hrct01,g_hrct.hrct02,g_hrct.hrct03,g_hrct.hrct01,
                               g_hrct.hrct02,'N',g_hrct.hrct07,g_hrct.hrct08,'N','N',
                               g_hrct.hrct11,g_hrct.hrct12,g_user,g_grup,g_user,g_today,'Y',g_user,g_grup)
#         添加薪资月明细信息
         INSERT INTO hrcta_file(hrcta01,hrcta02,hrcta03,hrcta04,hrcta05,hrcta06,hrcta07,hrcta08)
                        VALUES (g_hrct.hrct01,g_hrct.hrct02,g_hrct.hrct03,1,'N',g_hrct.hrct07,
                                g_hrct.hrct08,g_hrct.hrct12)
         IF l_hrbl >0 THEN 
            LET l_blmx=l_blmx+1
#         添加考勤区间信息
            INSERT INTO hrbl_file(hrbl01,hrbl02,hrbl03,hrbl04,hrbl05,hrbl06,hrbl07,hrbl08,hrbluser,hrblgrup,hrblmodu,
                               hrbldate,hrblacti,hrbloriu,hrblorig)
                        VALUES (g_hrct.hrct03,l_blmx,g_hrct.hrct11,g_hrct.hrct01,g_hrct.hrct02,g_hrct.hrct07,g_hrct.hrct08,'N',
                                 g_user,g_grup,g_user,g_today,'Y',g_user,g_grup)
#         添加考勤区间明细信息
            INSERT INTO hrbla_file(hrbla01,hrbla02,hrbla03,hrbla04,hrbla05,hrbla06)
                        VALUES ('1',l_blmx,'N',g_hrct.hrct07,g_hrct.hrct08,g_hrct.hrct12)
         END IF 
#        LET l_n=g_hrct.hrct02 
#        IF l_i<l_n THEN
#           CONTINUE FOR 
#        ELSE
#           LET g_hrct.hrct02=l_i
#        END IF
#        IF l_p > 12THEN
#           EXIT FOR
#        END IF
#        LET g_hrct.hrct05=l_p
#        LET g_hrct.hrct11=g_hrct.hrct01,'-',g_hrct.hrct02,'(',l_hraa12,')'
#        INSERT INTO hrct_file(hrct01,hrct02,hrct03,hrct04,hrct05,hrct06,hrct07,hrct08,
#                              hrct09,hrct10,hrct11,hrct12,hrctuser,hrctgrup,hrctmodu,
#                              hrctdate,hrctacti,hrctoriu,hrctorig)
#                          VALUES(g_hrct.hrct01,g_hrct.hrct02,g_hrct.hrct03,g_hrct.hrct04,
#                              g_hrct.hrct05,'N',g_hrct.hrct07,g_hrct.hrct08,'N','N',
#                              g_hrct.hrct11,g_hrct.hrct12,g_user,g_grup,g_user,g_today,'Y',g_user,g_grup)
#        INSERT INTO hrcta_file(hrcta01,hrcta02,hrcta03,hrcta04,hrcta05,hrcta06,hrcta07,hrcta08)
#                       VALUES (g_hrct.hrct01,g_hrct.hrct02,g_hrct.hrct03,1,'N',g_hrct.hrct07,
#                               g_hrct.hrct08,g_hrct.hrct12)
        LET l_p=l_p+1
    END FOR 
    CALL i060_b_fill('1=1')
END FUNCTION

FUNCTION i060_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,     
    l_allow_insert  LIKE type_file.chr1,     
    l_allow_delete  LIKE type_file.chr1,
    l_sql           STRING, 
    l_hrcta06       LIKE hrcta_file.hrcta06,
    l_hrcta07       LIKE hrcta_file.hrcta07
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrcta04,hrcta05,hrcta06,hrcta07,hrcta08",
                       " FROM hrcta_file",
                       " WHERE hrcta01=? AND hrcta02=? AND hrcta03=? AND hrcta04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i060_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hrcta WITHOUT DEFAULTS FROM s_hrcta.*
      ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac3)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac3 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b3>=l_ac3 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE                                       
               LET g_before_input_done = TRUE                                   
               LET g_hrcta_t.* = g_hrcta[l_ac3].*  #BACKUP
               OPEN i060_bcl USING g_hrct[l_ac].hrct01,g_hrct[l_ac].hrct02,g_hrct[l_ac].hrct03,g_hrcta_t.hrcta04
               IF STATUS THEN
                  CALL cl_err("OPEN i060_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i060_bcl INTO g_hrcta[l_ac3].hrcta04,g_hrcta[l_ac3].hrcta05,
                                      g_hrcta[l_ac3].hrcta06,g_hrcta[l_ac3].hrcta07,g_hrcta[l_ac3].hrcta08
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrct_t.hrct01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF NOT cl_null(p_cmd) AND p_cmd='u' THEN 
               LET l_sql="SELECT hrcta06,hrcta07 FROM hrcta_file",
                         " WHERE hrcta01='",g_hrct[l_ac].hrct01,"'",
                         "   AND hrcta02='",g_hrct[l_ac].hrct02,"'",
                         "   AND hrcta03='",g_hrct[l_ac].hrct03,"'",
                         "   AND hrcta04<>'",g_hrcta_t.hrcta04,"'"
            ELSE 
               LET l_sql="SELECT hrcta06,hrcta07 FROM hrcta_file",
                         " WHERE hrcta01='",g_hrct[l_ac].hrct01,"'",
                         "   AND hrcta02='",g_hrct[l_ac].hrct02,"'",
                         "   AND hrcta03='",g_hrct[l_ac].hrct03,"'"
            END IF 
            PREPARE j_p FROM l_sql
            DECLARE j_c CURSOR FOR j_p
            
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'     
           CALL cl_show_fld_cont() 
           LET g_hrcta[l_ac3].hrcta05='Y'
           SELECT MAX(hrcta04)+1 INTO g_hrcta[l_ac3].hrcta04 FROM hrcta_file
            WHERE hrcta01 = g_hrct[l_ac].hrct01 
              AND hrcta02 = g_hrct[l_ac].hrct02
              AND hrcta03 = g_hrct[l_ac].hrct03
           IF cl_null(g_hrcta[l_ac3].hrcta04) THEN LET g_hrcta[l_ac3].hrcta04=1 END IF
           DISPLAY BY NAME g_hrcta[l_ac3].hrcta04,g_hrcta[l_ac3].hrcta05
           NEXT FIELD hrcta06
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i060_bcl
              CANCEL INSERT
           END IF
           IF cl_null(g_hrcta[l_ac3].hrcta04) THEN NEXT FIELD hrcta04 END IF
           IF cl_null(g_hrcta[l_ac3].hrcta05) THEN NEXT FIELD hrcta05 END IF
           IF cl_null(g_hrcta[l_ac3].hrcta06) THEN NEXT FIELD hrcta06 END IF
           IF cl_null(g_hrcta[l_ac3].hrcta07) THEN NEXT FIELD hrcta07 END IF
           IF g_hrcta[l_ac3].hrcta05='N' AND 
             (g_hrcta[l_ac3].hrcta06<>g_hrct[l_ac].hrct07 OR g_hrcta[l_ac3].hrcta07<>g_hrct[l_ac].hrct08)
           THEN 
              CALL cl_err('','hri-004',0)
              NEXT FIELD hrcta05
           END IF 
           BEGIN WORK
           INSERT INTO hrcta_file(hrcta01,hrcta02,hrcta03,hrcta04,hrcta05,hrcta06,hrcta07,hrcta08)
                         VALUES(g_hrct[l_ac].hrct01,g_hrct[l_ac].hrct02,g_hrct[l_ac].hrct03,g_hrcta[l_ac3].hrcta04,
                                g_hrcta[l_ac3].hrcta05,g_hrcta[l_ac3].hrcta06,g_hrcta[l_ac3].hrcta07,
                                g_hrcta[l_ac3].hrcta08)
           IF SQLCA.sqlcode THEN
               ROLLBACK WORK           	
               CALL cl_err3("ins","hrcta_file",g_hrct[l_ac].hrct01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b3=g_rec_b3+1
              DISPLAY g_rec_b3 TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD hrcta06
            FOREACH j_c INTO l_hrcta06,l_hrcta07
               IF g_hrcta[l_ac3].hrcta06>=l_hrcta06 AND g_hrcta[l_ac3].hrcta06<=l_hrcta07 THEN 
                  CALL cl_err('','hri-005',0)
                  NEXT FIELD hrcta06
               END IF
               IF g_hrcta[l_ac3].hrcta06<l_hrcta06 AND not cl_null(g_hrcta[l_ac3].hrcta07) AND g_hrcta[l_ac3].hrcta07>l_hrcta07 THEN
                  CALL cl_err('','hri-005',0)
                  NEXT FIELD hrcta06
               END IF 
            END FOREACH
            IF g_hrcta[l_ac3].hrcta06<g_hrct[l_ac].hrct07 OR g_hrcta[l_ac3].hrcta06>g_hrct[l_ac].hrct08 THEN
               CALL cl_err('','hri-006',0)
               NEXT FIELD hrcta06
            END IF

        AFTER FIELD hrcta07
            FOREACH j_c INTO l_hrcta06,l_hrcta07
               IF g_hrcta[l_ac3].hrcta07>=l_hrcta06 AND g_hrcta[l_ac3].hrcta07<=l_hrcta07 THEN 
                  CALL cl_err('','hri-005',0)
                  NEXT FIELD hrcta07
               END IF
               IF g_hrcta[l_ac3].hrcta06<l_hrcta06 AND not cl_null(g_hrcta[l_ac3].hrcta06) AND g_hrcta[l_ac3].hrcta07>l_hrcta07 THEN
                  CALL cl_err('','hri-005',0)
                  NEXT FIELD hrcta07 
               END IF 
            END FOREACH 
            IF g_hrcta[l_ac3].hrcta07<g_hrct[l_ac].hrct07 OR g_hrcta[l_ac3].hrcta07>g_hrct[l_ac].hrct08 THEN
               CALL cl_err('','hri-006',0)
               NEXT FIELD hrcta07
            END IF          
          
        BEFORE DELETE            
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN 
              CALL cl_err("", -263, 1) 
              CANCEL DELETE 
           END IF 
           DELETE FROM hrcta_file WHERE hrcta01 = g_hrct[l_ac].hrct01
                                    AND hrcta02 = g_hrct[l_ac].hrct02
                                    AND hrcta03 = g_hrct[l_ac].hrct03
                                    AND hrcta04 = g_hrcta_t.hrcta04
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrcta_file",g_hrct[l_ac].hrct01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b3=g_rec_b3-1
           DISPLAY g_rec_b3 TO FORMONLY.cn2  
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrcta[l_ac3].* = g_hrcta_t.*
              CLOSE i060_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_hrcta[l_ac3].hrcta04) THEN NEXT FIELD hrcta04 END IF
           IF cl_null(g_hrcta[l_ac3].hrcta05) THEN NEXT FIELD hrcta05 END IF
           IF cl_null(g_hrcta[l_ac3].hrcta06) THEN NEXT FIELD hrcta06 END IF
           IF cl_null(g_hrcta[l_ac3].hrcta07) THEN NEXT FIELD hrcta07 END IF
           IF g_hrcta[l_ac3].hrcta05='N' AND 
             (g_hrcta[l_ac3].hrcta06<>g_hrct[l_ac].hrct07 OR g_hrcta[l_ac3].hrcta07<>g_hrct[l_ac].hrct08)
           THEN 
              CALL cl_err('','hri-004',0)
              NEXT FIELD hrcta05
           END IF 
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrct[l_ac].hrct01,-263,0)
               LET g_hrcta[l_ac3].* = g_hrcta_t.*
           ELSE
               UPDATE hrcta_file SET hrcta04=g_hrcta[l_ac3].hrcta04,
                                     hrcta05=g_hrcta[l_ac3].hrcta05,
                                     hrcta06=g_hrcta[l_ac3].hrcta06,
                                     hrcta07=g_hrcta[l_ac3].hrcta07,
                                     hrcta08=g_hrcta[l_ac3].hrcta08
                               WHERE hrcta01 = g_hrct[l_ac].hrct01
                                 AND hrcta02 = g_hrct[l_ac].hrct02
                                 AND hrcta03 = g_hrct[l_ac].hrct03
                                 AND hrcta04 = g_hrcta_t.hrcta04
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrcta_file",g_hrct[l_ac].hrct01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrcta[l_ac3].* = g_hrcta_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac3 = ARR_CURR()        # 新增
           LET l_ac_t = l_ac3            # 新增
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrcta[l_ac3].* = g_hrcta_t.*
              END IF
              CLOSE i060_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i060_bcl
           COMMIT WORK

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
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121 
           CALL cl_show_help()  #MOD-4C0121
        
    END INPUT
    CLOSE i060_bcl
    COMMIT WORK
END FUNCTION

 
FUNCTION i060_b_askkey()
 
    CONSTRUCT g_wc ON hrct01,hrct02,hrct07,hrct08,hrct04,hrct05,hrct06,hrct09,hrct03,hrct12
         FROM s_hrct[1].hrct01,s_hrct[1].hrct02,s_hrct[1].hrct07,s_hrct[1].hrct08,s_hrct[1].hrct04,
              s_hrct[1].hrct05,s_hrct[1].hrct06,s_hrct[1].hrct09,s_hrct[1].hrct03,s_hrct[1].hrct12
 
     BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE WHEN INFIELD(hrct01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrbm03"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_hrct[1].hrct01            
             WHEN INFIELD(hrct09)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrat03"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_hrct[1].hrct09 
         OTHERWISE
             EXIT CASE
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
		     CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrctuser', 'hrctgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
 
   CALL i060_b_fill(g_wc)
END FUNCTION
 
FUNCTION i060_b_fill(p_wc)
DEFINE p_wc  LIKE type_file.chr1000 
    LET g_sql =
        "SELECT hrct11,hrct01,hrct02,hrct07,hrct08,hrct04,hrct05,hrct06,hrct09,hrct03,hraa12,hrct12 ",
        "  FROM hrct_file,hraa_file ",
        " WHERE ",p_wc CLIPPED,
        "   AND hrct06='N'",
        "   AND hraa01=hrct03 ",
        " ORDER BY hrct01,hrct02,hrct03"
    PREPARE i060_pb FROM g_sql
    DECLARE hrct_curs CURSOR FOR i060_pb
 
    CALL g_hrct.clear()
    CALL g_hrcta.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrct_curs INTO g_hrct[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrct.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION i060_b_fill1()
    LET g_sql =
        "SELECT hrcta04,hrcta05,hrcta06,hrcta07,hrcta08 ",
        "  FROM hrcta_file",
        " WHERE hrcta01='",g_hrct[l_ac].hrct01,"'",
        "   AND hrcta02='",g_hrct[l_ac].hrct02,"'",
        "   AND hrcta03='",g_hrct[l_ac].hrct03,"'",
        " ORDER BY hrcta04"
    PREPARE i060_pb1 FROM g_sql
    DECLARE hrct_curs1 CURSOR FOR i060_pb1
    CALL g_hrcta.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrct_curs1 INTO g_hrcta[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcta.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cn2
END FUNCTION

FUNCTION i060_b_fill2()
    LET g_sql =
        "SELECT '',hrct01,hrct02,hrct07,hrct08,hrct04,hrct05,hrct06,hrct09,hrct03,hraa12,hrct12 ",
        "  FROM hrct_file,hraa_file ",
        " WHERE hrct06='Y'",
        "   AND hraa01=hrct03 ",
        " ORDER BY hrct01,hrct02,hrct03"
    PREPARE i060_pb2 FROM g_sql
    DECLARE hrct_curs2 CURSOR FOR i060_pb2
 
    CALL g_hrct_a.clear()
    CALL g_hrcta.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrct_curs2 INTO g_hrct_a[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_hrct_a[g_cnt].identity_a=g_hrct_a[g_cnt].hrct01_a,'-',g_hrct_a[g_cnt].hrct02_a,'(',g_hrct_a[g_cnt].hrct03_desc_a,')'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrct_a.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cnt
END FUNCTION

FUNCTION i060_b_fill3()
    LET g_sql =
        "SELECT hrcta04,hrcta05,hrcta06,hrcta07,hrcta08 ",
        "  FROM hrcta_file",
        " WHERE hrcta01='",g_hrct_a[l_ac2].hrct01_a,"'",
        "   AND hrcta02='",g_hrct_a[l_ac2].hrct02_a,"'",
        "   AND hrcta03='",g_hrct_a[l_ac2].hrct03_a,"'",
        " ORDER BY hrcta04"
    PREPARE i060_pb3 FROM g_sql
    DECLARE hrct_curs3 CURSOR FOR i060_pb3
    CALL g_hrcta.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrct_curs3 INTO g_hrcta[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcta.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cn2
END FUNCTION

FUNCTION i060_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_hrct TO s_hrct.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i060_b_fill1()
      END DISPLAY
      
      DISPLAY ARRAY g_hrcta TO s_hrcta.* ATTRIBUTE(COUNT=g_rec_b3)
 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION q2
         LET g_action_choice="q2"
         EXIT DIALOG
      ON ACTION ghri0601
         LET g_action_choice="ghri0601"
         EXIT DIALOG 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION close 
         LET g_action_choice="close"
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
      ON ACTION ACCEPT
         LET g_action_choice="detail"
         EXIT DIALOG 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i060_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_hrct_a TO s_hrct_a.* ATTRIBUTE(COUNT=g_rec_b2)
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i060_b_fill3()
      END DISPLAY
      
      DISPLAY ARRAY g_hrcta TO s_hrcta.* ATTRIBUTE(COUNT=g_rec_b3)
 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION q1
         LET g_action_choice="q1"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION close 
         LET g_action_choice="close"
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  
      ON ACTION about
         CALL cl_about() 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
        
FUNCTION i060_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hrct01,hrct02,hrct03",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i060_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("hrct01,hrct02,hrct03",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    

