# Prog. Version..: '5.30.15-14.10.14(00010)'     #
#
# Pattern name...: ghri901.4gl
# Descriptions...: 日产值作业
# Date & Author..:No.FUN-790025 16/04/01 By nihuan

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_hrzx           RECORD LIKE hrzx_file.*,
    g_hrzx_t         RECORD LIKE hrzx_file.*,
    g_hrzx_o         RECORD LIKE hrzx_file.*,
    g_hrzx02_t       LIKE hrzx_file.hrzx02,
    g_hrzx01_t       LIKE hrzx_file.hrzx01,
    g_hrzx03_t       LIKE hrzx_file.hrzx03,
    g_hrzxa           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrzxa02            LIKE hrzxa_file.hrzxa02,
        hrzxa03            LIKE hrzxa_file.hrzxa03,
        hrzxa04            LIKE hrzxa_file.hrzxa04,
        hrzxa04_n          LIKE hrao_file.hrao02,
        hrzxa05            LIKE hrzxa_file.hrzxa05,
        hrzxa06            LIKE hrzxa_file.hrzxa06
                    END RECORD,
    g_hrzxa_t         RECORD                     #程式變數 (舊值)
        hrzxa02            LIKE hrzxa_file.hrzxa02,
        hrzxa03            LIKE hrzxa_file.hrzxa03,
        hrzxa04            LIKE hrzxa_file.hrzxa04,
        hrzxa04_n          LIKE hrao_file.hrao02,
        hrzxa05            LIKE hrzxa_file.hrzxa05,
        hrzxa06            LIKE hrzxa_file.hrzxa06
                    END RECORD,
    g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_sql,g_sql1,g_sql2    STRING,    #TQC-630166        
    g_rec_b1,g_rec_b2    LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    g_t1            LIKE type_file.chr3,                  #No.FUN-680072CHAR(3)
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
 
#主程式開始
DEFINE   p_row,p_col         LIKE type_file.num5        #No.FUN-680072 SMALLINT
#FUN-540036---start
DEFINE  l_action_flag        STRING    
#FUN-540036---end
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE  g_before_input_done  LIKE type_file.num5     #No.FUN-680072 SMALLINT
DEFINE  g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE  g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03            #No.FUN-680072CHAR(72)
DEFINE  g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  g_void          LIKE type_file.chr1          #No.FUN-680072CHAR(1)
DEFINE g_argv1     LIKE hrzx_file.hrzx01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
 
# DEFINE      l_time    LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("GHR")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    LET g_forupd_sql = "SELECT * FROM hrzx_file WHERE hrzx01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i901_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW i901_w33 AT 2,2 WITH FORM "ghr/42f/ghri901"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i901_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i901_a()
            END IF
         OTHERWISE        
            CALL i901_q() 
      END CASE
   END IF
   #--
 
    CALL i901_menu()
 
    CLOSE WINDOW i901_w33
      CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i901_cs()
 DEFINE    l_type          LIKE type_file.chr2       #No.FUN-680072CHAR(2)
 DEFINE    l_hrzx02        LIKE zx_file.zx02
 DEFINE    l_hrat02        LIKE hrat_file.hrat02 
   CLEAR FORM                                      #清除畫面
   CALL g_hrzxa.clear()
   CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
   INITIALIZE g_hrzx.* TO NULL    #No.FUN-750051
  IF g_argv1<>' ' THEN                     #FUN-7C0050
     LET g_wc=" hrzx01='",g_argv1,"'"       #FUN-7C0050
     LET g_wc2=" 1=1"                      #FUN-7C0050
     LET g_wc3=" 1=1"                      #FUN-7C0050
     LET g_wc4=" 1=1"                      #FUN-7C0050
     LET g_wc5=" 1=1"                      #FUN-7C0050
  ELSE
   CONSTRUCT BY NAME g_wc ON
                hrzx01,hrzx02,hrzx03,hrzx04,hrzx05,
                hrzxuser,hrzxgrup,hrzxmodu,hrzxdate,hrzxoriu,hrzxorig
     
    
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(hrzx01)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_zx"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO hrzx01
#             SELECT zx02 IN TO l_zx02 FROM zx_file WHERE zx01=g_qryparam.multiret
#             DISPLAY l_zx02 TO zx02 
            NEXT FIELD hrzx01
         WHEN INFIELD(hrzx02)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_hrat01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO hrzx02

            NEXT FIELD hrzx02
         
         OTHERWISE EXIT CASE
      END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   LET g_wc2 = " 1=1"
   CONSTRUCT g_wc2 ON hrzxa02,hrzxa03,hrzxa04,hrzxa05,hrzxa06
        FROM  s_hrzxa[1].hrzxa02,s_hrzxa[1].hrzxa03,s_hrzxa[1].hrzxa04,s_hrzxa[1].hrzxa05,s_hrzxa[1].hrzxa06
      
      ON ACTION CONTROLP
         CASE 
          WHEN INFIELD(hrzxa04)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_hrao01_1"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO hrzxa04
            NEXT FIELD hrzxa04
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
 
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
  END IF  #FUN-7C0050
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND hrzxuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND hrzxgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND hrzxgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrzxuser', 'hrzxgrup')
   #End:FUN-980030
 
   LET g_wc = cl_replace_str(g_wc,"hrzx02","hrat01")
   LET g_sql  = "SELECT hrzx01,hrzx02,hrzx03 "
   LET g_sql1 = " FROM hrzx_file left join hrat_file on hratid=hrzx02"
   LET g_sql2 = " WHERE ", g_wc CLIPPED
 
   IF g_wc2 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",hrzxa_file"
      LET g_sql2= g_sql2 CLIPPED," AND hrzx01=hrzxa01",
                                 " AND ",g_wc2 CLIPPED
   END IF
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED,' ORDER BY hrzx01'
 
   PREPARE i901_prepare FROM g_sql
   DECLARE i901_cs SCROLL CURSOR WITH HOLD FOR i901_prepare
 
   LET g_sql  = "SELECT COUNT(UNIQUE hrzx01) "
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED
 
   PREPARE i901_precount FROM g_sql
   DECLARE i901_count CURSOR FOR i901_precount
END FUNCTION
 
FUNCTION i901_menu()
DEFINE l_cmd  LIKE type_file.chr1000        #No.FUN-820002
   WHILE TRUE
# NO.FUN-540036--start
#     CALL i901_bp("G")
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "detail")
            CALL i901_bp1("G")
      END CASE
# NO.FUN-540036--end
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i901_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i901_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i901_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i901_copy()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i901_u()
            END IF
#         WHEN "invalid"
#            IF cl_chk_act_auth() THEN
#               CALL i901_x()
#            END IF
#         WHEN "output"
#            IF cl_chk_act_auth()                                           
#               THEN CALL i901_out()                                    
#            END IF                                                         
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#         WHEN "confirm"              #审核
#            IF cl_chk_act_auth() THEN 
#               CALL i901_y()
#            END IF
#         WHEN "undo_confirm"         #取消审核
#            IF cl_chk_act_auth() THEN 
#               CALL i901_z()
#            END IF
         WHEN "detail"              #预估详细
            IF cl_chk_act_auth() THEN
               CALL i901_b1()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_hrzx.hrzx01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrzx01"
                 LET g_doc.value1 = g_hrzx.hrzx01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i901_a()
DEFINE l_sql   string 
#DEFINE l_b     LIKE hrjib_file.hrjib03
#DEFINE l_e     LIKE hrjib_file.hrjib04
DEFINE l_n     LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_hrzxa.clear()
   INITIALIZE g_hrzx.* LIKE hrzx_file.*             #DEFAULT 設定
   LET g_hrzx01_t = NULL
   LET g_hrzx02_t = NULL
   LET g_hrzx03_t = NULL
   #預設值及將數值類變數清成零
   LET g_hrzx.hrzxuser=g_user
   LET g_hrzx.hrzxoriu = g_user #FUN-980030
   LET g_hrzx.hrzxorig = g_grup #FUN-980030
   LET g_hrzx.hrzxgrup=g_grup
   LET g_hrzx.hrzxdate=g_today
#   LET g_hrzx.hrzxacti='Y'              #資料有效
   
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i901_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_hrzx.* TO NULL
         EXIT WHILE
      END IF
      IF g_hrzx.hrzx01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
       SELECT hratid INTO g_hrzx.hrzx02 FROM hrat_file WHERE hrat01=g_hrzx.hrzx02
      INSERT INTO hrzx_file VALUES (g_hrzx.*)
       SELECT hrat01 INTO g_hrzx.hrzx02 FROM hrat_file WHERE hratid=g_hrzx.hrzx02
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#        CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,1)   #No.FUN-660092
         CALL cl_err3("ins","hrzx_file",g_hrzx.hrzx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
#      SELECT hrzx02,hrzx03 INTO g_hrzx.hrzx02,g_hrzx.hrzx03 FROM hrzx_file
#       WHERE hrzx02 = g_hrzx.hrzx02 AND hrzx03 = g_hrzx.hrzx03
#      LET g_hrzx02_t = g_hrzx.hrzx02        #保留舊值
      LET g_hrzx01_t = g_hrzx.hrzx01
      LET g_hrzx_t.* = g_hrzx.*

##############
#      LET l_ac=1 
#      LET l_sql=" select * from (
#                 SELECT HRJIB03, HRJIB04, SALPAY_DATE, SUM(SALPAY_AMOUNT) col1 
#                 FROM (SELECT HRJIA03, HRJIB03, HRJIB04
#                         FROM HRJIA_FILE
#                         LEFT JOIN HRJI_FILE
#                           ON HRJIA01 = HRJI01
#                         LEFT JOIN HRJIB_FILE
#                           ON HRJIB01 = HRJI01
#                        WHERE HRJI07 = 'Y'
#                          AND HRJIA03 = '10250002'
#                          AND TO_DATE('",g_hrzx.hrzx03,"', 'yy/mm/dd') BETWEEN HRJIA06 AND HRJIA07)
#                 LEFT JOIN SALESPAY
#                   ON SALPAY_SALORG = HRJIA03
#                  AND SALPAY_TIME BETWEEN HRJIB03 AND HRJIB04
#                WHERE (SALPAY_DATE = TO_DATE('",g_hrzx.hrzx04,"', 'yy/mm/dd') OR
#                       SALPAY_DATE = TO_DATE('",g_hrzx.hrzx05,"', 'yy/mm/dd') OR
#                       SALPAY_DATE = TO_DATE('",g_hrzx.hrzx06,"', 'yy/mm/dd'))
#                  AND SALPAY_TRNCLS = 'XSDJ'
#                GROUP BY HRJIB03, HRJIB04, SALPAY_DATE) PIVOT (MAX (col1) FOR SALPAY_DATE IN (
#                TO_DATE('",g_hrzx.hrzx04,"', 'yy/mm/dd'),TO_DATE('",g_hrzx.hrzx05,"', 'yy/mm/dd'),TO_DATE('",g_hrzx.hrzx06,"', 'yy/mm/dd'))) order by hrjib03      
#                "
#             PREPARE i901_pb_214_1 FROM l_sql
#             DECLARE hrzxa_curs_214_1 CURSOR WITH HOLD FOR i901_pb_214_1  
#              
#             FOREACH hrzxa_curs_214_1  INTO l_b,l_e,g_hrzxa[l_ac].hrzxa04,g_hrzxa[l_ac].hrzxa05,g_hrzxa[l_ac].hrzxa07
#             IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#             
#             LET g_hrzxa[l_ac].hrzxa03=l_b,"-",l_e
#             LET g_hrzxa[l_ac].hrzxa02=l_ac
#              
#              
#             IF cl_null(g_hrzxa[l_ac].hrzxa04) OR g_hrzxa[l_ac].hrzxa04=0 THEN 
#                LET g_hrzxa[l_ac].hrzxa06=0 
#                LET g_hrzxa[l_ac].hrzxa04=0
#             ELSE IF NOT cl_null(g_hrzxa[l_ac].hrzxa05) OR g_hrzxa[l_ac].hrzxa05!=0 THEN 
#                     LET g_hrzxa[l_ac].hrzxa06=g_hrzxa[l_ac].hrzxa05/g_hrzxa[l_ac].hrzxa04*100,'%'
#                  END IF 
#             END IF 
#             
#             IF cl_null(g_hrzxa[l_ac].hrzxa05) OR g_hrzxa[l_ac].hrzxa05=0 THEN 
#                LET g_hrzxa[l_ac].hrzxa08=0 
#                LET g_hrzxa[l_ac].hrzxa05=0
#             ELSE IF NOT cl_null(g_hrzxa[l_ac].hrzxa07) OR g_hrzxa[l_ac].hrzxa07!=0 THEN 
#                     LET g_hrzxa[l_ac].hrzxa08=g_hrzxa[l_ac].hrzxa07/g_hrzxa[l_ac].hrzxa05*100,'%'
#                  ELSE LET g_hrzxa[l_ac].hrzxa07=0 
#                  	   LET g_hrzxa[l_ac].hrzxa08=0          
#                  END IF 
#             END IF 
#         
#              
#             IF  g_hrzxa[l_ac].hrzxa07!=0 AND g_hrzxa[l_ac].hrzxa05!=0 AND g_hrzxa[l_ac].hrzxa04!=0  THEN  
#                    LET g_hrzxa[l_ac].hrzxa09=(g_hrzxa[l_ac].hrzxa04+g_hrzxa[l_ac].hrzxa05+g_hrzxa[l_ac].hrzxa07)/3 
#             ELSE  IF  g_hrzxa[l_ac].hrzxa07=0 AND NOT g_hrzxa[l_ac].hrzxa05!=0 AND NOT g_hrzxa[l_ac].hrzxa04!=0  THEN
#              	       LET g_hrzxa[l_ac].hrzxa09=(g_hrzxa[l_ac].hrzxa04+g_hrzxa[l_ac].hrzxa05+g_hrzxa[l_ac].hrzxa07)/2
#              	   ELSE  IF  g_hrzxa[l_ac].hrzxa07=0 AND NOT g_hrzxa[l_ac].hrzxa05=0 AND NOT g_hrzxa[l_ac].hrzxa04!=0  THEN
#              	             LET g_hrzxa[l_ac].hrzxa09=(g_hrzxa[l_ac].hrzxa04+g_hrzxa[l_ac].hrzxa05+g_hrzxa[l_ac].hrzxa07) 
#              	         END IF  
#              	   END IF               	       
#             END IF 
#                
#            
#             
#             SELECT COUNT (*) INTO l_n FROM hrzxa_file WHERE hrzxa01=g_hrzx.hrzx01 AND hrzxa02=g_hrzxa[l_ac].hrzxa02 AND hrzxa03=g_hrzxa[l_ac].hrzxa03
#                                                             AND hrzxa04=g_hrzxa[l_ac].hrzxa04 AND hrzxa05=g_hrzxa[l_ac].hrzxa05 AND hrzxa06=g_hrzxa[l_ac].hrzxa06
#                                                             AND hrzxa07=g_hrzxa[l_ac].hrzxa07 AND hrzxa08=g_hrzxa[l_ac].hrzxa08 AND hrzxa09=g_hrzxa[l_ac].hrzxa09
#                                                             AND hrzxa10=g_hrzxa[l_ac].hrzxa10 AND hrzxa11=g_hrzxa[l_ac].hrzxa11 AND hrzxa12=g_hrzxa[l_ac].hrzxa12 AND hrzxa13=g_hrzxa[l_ac].hrzxa13  
#             BEGIN WORK 
#             IF l_n=0 THEN 
#                INSERT INTO hrzxa_file(hrzxa01,hrzxa02,hrzxa03,hrzxa04,hrzxa05,hrzxa06,hrzxa07,hrzxa08,hrzxa09,hrzxa10,hrzxa11,hrzxa12,hrzxa13)
#                                VALUES(g_hrzx.hrzx01,g_hrzxa[l_ac].hrzxa02,g_hrzxa[l_ac].hrzxa03,g_hrzxa[l_ac].hrzxa04,g_hrzxa[l_ac].hrzxa05,g_hrzxa[l_ac].hrzxa06,g_hrzxa[l_ac].hrzxa07,
#                                       g_hrzxa[l_ac].hrzxa08,g_hrzxa[l_ac].hrzxa09,g_hrzxa[l_ac].hrzxa10,g_hrzxa[l_ac].hrzxa11,g_hrzxa[l_ac].hrzxa12,g_hrzxa[l_ac].hrzxa13)
#             ELSE  UPDATE hrzxa_file SET  hrzxa02 = g_hrzxa[l_ac].hrzxa02,
#                                    hrzxa03 = g_hrzxa[l_ac].hrzxa03,
#                                    hrzxa04 = g_hrzxa[l_ac].hrzxa04,
#                                    hrzxa05 = g_hrzxa[l_ac].hrzxa05,
#                                    hrzxa06 = g_hrzxa[l_ac].hrzxa06,
#                                    hrzxa07 = g_hrzxa[l_ac].hrzxa07,
#                                    hrzxa08 = g_hrzxa[l_ac].hrzxa08,
#                                    hrzxa09 = g_hrzxa[l_ac].hrzxa09,
#                                    hrzxa10 = g_hrzxa[l_ac].hrzxa10,
#                                    hrzxa11 = g_hrzxa[l_ac].hrzxa11,
#                                    hrzxa12 = g_hrzxa[l_ac].hrzxa12,
#                                    hrzxa13 = g_hrzxa[l_ac].hrzxa13
#                  WHERE hrzxa01=g_hrzx.hrzx01 AND hrzxa02=g_hrzxa_t.hrzxa02                         
#           
#             END IF 
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("upd","hrzxa_file",g_hrzx.hrzx01,g_hrzxa_t.hrzxa02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
#                LET g_hrzxa[l_ac].* = g_hrzxa_t.*
#                 EXIT FOREACH 
#                ROLLBACK WORK
#             ELSE
#                COMMIT WORK
#             END IF 
#             LET l_ac=l_ac+1 
#             IF l_ac > g_max_rec THEN
#                CALL cl_err( '', 9035, 0 )
#                EXIT FOREACH
#             END IF 
#             END FOREACH  
###########

      CALL i901_b1_fill(" 1=1")                 #單身
#      CALL g_hrzxa.clear()
      LET g_rec_b1=0
      CALL i901_b1()                   #輸入單身-1
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i901_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_hrzx.hrzx02 IS NULL AND g_hrzx.hrzx03 IS NULL THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_hrzx.* FROM hrzx_file
    WHERE hrzx02=g_hrzx.hrzx02 AND hrzx03=g_hrzx.hrzx03
#   IF g_hrzx.hrzxacti ='N' THEN    #檢查資料是否為無效
#      CALL cl_err(g_hrzx.hrzx01,9027,0)
#      RETURN
#   END IF 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrzx01_t = g_hrzx.hrzx01
   LET g_hrzx02_t = g_hrzx.hrzx02
   LET g_hrzx03_t = g_hrzx.hrzx03
   LET g_hrzx_o.* = g_hrzx.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i901_cl USING g_hrzx.hrzx01
   IF STATUS THEN
      CALL cl_err("OPEN i901_cl:", STATUS, 1)
      CLOSE i901_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i901_cl INTO g_hrzx.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i901_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL i901_show()
   WHILE TRUE
      LET g_hrzx01_t = g_hrzx.hrzx01
      LET g_hrzx02_t = g_hrzx.hrzx02
      LET g_hrzx03_t = g_hrzx.hrzx03
      LET g_hrzx.hrzxmodu=g_user
      LET g_hrzx.hrzxdate=g_today 
      CALL i901_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_hrzx.*=g_hrzx_t.*
         CALL i901_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_hrzx.hrzx02 != g_hrzx02_t AND g_hrzx.hrzx03 != g_hrzx03_t THEN            
         UPDATE hrzxa_file SET hrzxa01 = g_hrzx.hrzx01 WHERE hrzxa01 = g_hrzx01_t
      END IF
      UPDATE hrzx_file SET hrzx_file.* = g_hrzx.* WHERE hrzx01 = g_hrzx01_t 
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)   #No.FUN-660092
         CALL cl_err3("upd","hrzx_file",g_hrzx.hrzx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i901_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i901_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680072 VARCHAR(1)
    l_pmc03         LIKE pmc_file.pmc03,
    l_yy,l_mm       LIKE type_file.num5,    #No.FUN-680072SMALLINT
    l_hrao02        LIKE hrao_file.hrao02
DEFINE   l_n        LIKE type_file.num5     #TQC-720052
DEFINE   l_genacti  LIKE gen_file.genacti
DEFINE   g_h1,g_h2,g_m1,g_m2     LIKE type_file.num5
DEFINE   i,j        STRING 
DEFINE l_zx02       LIKE zx_file.zx02
DEFINE l_hrat02     LIKE hrat_file.hrat02    
    LET l_n = 0   #TQC-720052
    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
    INPUT BY NAME 
          g_hrzx.hrzx01,g_hrzx.hrzx02,g_hrzx.hrzx03,g_hrzx.hrzx04,g_hrzx.hrzx05, 
          g_hrzx.hrzxuser,g_hrzx.hrzxgrup,g_hrzx.hrzxmodu,
          g_hrzx.hrzxoriu,g_hrzx.hrzxorig,g_hrzx.hrzxdate
        WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i901_set_entry(p_cmd)
           CALL i901_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
            IF cl_null(g_hrzx.hrzx04) THEN LET g_hrzx.hrzx04='N' END IF   
           IF cl_null(g_hrzx.hrzx05) THEN LET g_hrzx.hrzx05='N' END IF 
       AFTER FIELD hrzx01
          IF NOT cl_null(g_hrzx.hrzx01) THEN 
             SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=g_hrzx.hrzx01
              DISPLAY l_zx02 TO hrzx01_n
          ELSE CALL cl_err('NOT NULL','!',0)
          	   NEXT FIELD hrzx01    
          END IF  
       
       AFTER FIELD hrzx02
          IF NOT cl_null(g_hrzx.hrzx02) THEN
             #SELECT hratid INTO g_hrzx.hrzx02 FROM hrat_file WHERE hrat01=g_hrzx.hrzx02 
             SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01 = g_hrzx.hrzx02
             DISPLAY l_hrat02 TO hrzx02_n
           ELSE CALL cl_err('NOT NULL','!',0)
          	   NEXT FIELD hrzx02  
           END IF 
 
#       AFTER FIELD hrzx03
#           IF NOT cl_null(g_hrzx.hrzx03) THEN
#              IF g_hrzx.hrzx03 != g_hrzx03_t OR g_hrzx03_t IS NULL THEN
#                 SELECT COUNT(*) INTO g_cnt FROM hrzx_file
#                  WHERE hrzx02 = g_hrzx.hrzx02 AND hrzx03 = g_hrzx.hrzx03
#                 IF g_cnt > 0 THEN   #資料重複
#                    CALL cl_err(g_hrzx.hrzx01,-239,0)
#                    LET g_hrzx.hrzx02 = g_hrzx02_t
#                    LET g_hrzx.hrzx03 = g_hrzx03_t
#                    DISPLAY BY NAME g_hrzx.hrzx02
#                    DISPLAY BY NAME g_hrzx.hrzx03
#                    NEXT FIELD hrzx02
#                 END IF
#              END IF
#           END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(hrzx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_hrzx.hrzx01
                 LET g_qryparam.form ="q_zx"
                 CALL cl_create_qry() RETURNING g_hrzx.hrzx01
                 DISPLAY BY NAME g_hrzx.hrzx01
                 NEXT FIELD hrzx01
              WHEN INFIELD(hrzx02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_hrzx.hrzx02
                 LET g_qryparam.form ="q_hrat01"
                 CALL cl_create_qry() RETURNING g_hrzx.hrzx02
                 DISPLAY BY NAME g_hrzx.hrzx02
                 NEXT FIELD hrzx02

              OTHERWISE EXIT CASE
        END CASE
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 #No.MOD-540141--end
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i901_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_hrzx.* TO NULL               #No.FUN-6B0050
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hrzxa.clear()
 
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i901_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN i901_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hrzx.* TO NULL
   ELSE
      OPEN i901_count
      FETCH i901_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i901_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i901_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i901_cs INTO g_hrzx.hrzx01,g_hrzx.hrzx02,g_hrzx.hrzx03
      WHEN 'P' FETCH PREVIOUS i901_cs INTO g_hrzx.hrzx01,g_hrzx.hrzx02,g_hrzx.hrzx03
      WHEN 'F' FETCH FIRST    i901_cs INTO g_hrzx.hrzx01,g_hrzx.hrzx02,g_hrzx.hrzx03
      WHEN 'L' FETCH LAST     i901_cs INTO g_hrzx.hrzx01,g_hrzx.hrzx02,g_hrzx.hrzx03
      WHEN '/'
         IF NOT mi_no_ask THEN
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
 
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i901_cs INTO g_hrzx.hrzx01,g_hrzx.hrzx02,g_hrzx.hrzx03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)
      INITIALIZE g_hrzx.* TO NULL  #TQC-6B0105
      CLEAR FORM
      CALL g_hrzxa.clear()
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
   SELECT * INTO g_hrzx.* FROM hrzx_file WHERE hrzx02 = g_hrzx.hrzx02 AND hrzx01 = g_hrzx.hrzx01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)   #No.FUN-660092
      CALL cl_err3("sel","hrzx_file",g_hrzx.hrzx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
      INITIALIZE g_hrzx.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_hrzx.hrzxuser   #FUN-4C0069
   LET g_data_group = g_hrzx.hrzxgrup   #FUN-4C0069
   CALL i901_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i901_show()
DEFINE l_hrao02   LIKE hrao_file.hrao02
DEFINE l_zx02     LIKE zx_file.zx02
DEFINE l_hrat02   LIKE hrat_file.hrat02
   LET g_hrzx_t.* = g_hrzx.*                #保存單頭舊值
   SELECT hrat01 INTO g_hrzx.hrzx02 FROM hrat_file  WHERE hratid=g_hrzx.hrzx02 
   DISPLAY BY NAME 
          g_hrzx.hrzx01,g_hrzx.hrzx02,g_hrzx.hrzx03,g_hrzx.hrzx04,g_hrzx.hrzx05,  
          g_hrzx.hrzxuser,g_hrzx.hrzxgrup,g_hrzx.hrzxmodu,g_hrzx.hrzxoriu,
          g_hrzx.hrzxorig,g_hrzx.hrzxdate
          
   SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01 = g_hrzx.hrzx02
   DISPLAY l_hrat02 TO hrzx02_n
   SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=g_hrzx.hrzx01
   DISPLAY l_zx02 TO hrzx01_n              
   CALL i901_b1_fill(g_wc2)                 #單身
#   CALL i901_pic()
   CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i901_r()
   IF s_shut(0) THEN RETURN END IF
   IF g_hrzx.hrzx02 IS NULL AND g_hrzx.hrzx03 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_hrzx.* FROM hrzx_file WHERE hrzx02=g_hrzx.hrzx02 AND hrzx03=g_hrzx.hrzx03
   #No.TQC-920110 add --begin
#   IF g_hrzx.hrzxacti = 'N' THEN
#      CALL cl_err('','abm-950',0)
#      RETURN
#   END IF
   #No.TQC-920110 add --end
 
   BEGIN WORK
   OPEN i901_cl USING g_hrzx.hrzx01
   IF STATUS THEN
      CALL cl_err("OPEN i901_cl:", STATUS, 1)         
      CLOSE i901_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i901_cl INTO g_hrzx.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i901_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "hrzx01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_hrzx.hrzx01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM hrzxa_file WHERE hrzxa01 = g_hrzx.hrzx01
      IF STATUS THEN
#        CALL cl_err('del hrzxa:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","hrzxa_file",g_hrzx.hrzx01,"",STATUS,"","del hrzxa:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM hrzx_file WHERE hrzx01 = g_hrzx.hrzx01
      IF STATUS THEN
#        CALL cl_err('del hrzx:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","hrzx_file",g_hrzx.hrzx01,"",STATUS,"","del hrzx:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_hrzx.* TO NULL
      CLEAR FORM
      CALL g_hrzxa.clear()
      OPEN i901_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i901_cs
         CLOSE i901_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i901_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i901_cs
         CLOSE i901_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i901_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i901_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i901_fetch('/')
      END IF
   END IF
   CLOSE i901_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i901_b1()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
   l_exit_sw       LIKE type_file.chr1,                                   #No.FUN-680072 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
   l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680072 SMALLINT
   l_hrao02        LIKE hrao_file.hrao02,
   g_multi_hrzxa03     STRING 
DEFINE l_t1,l_t2,l_k   LIKE type_file.num10 
DEFINE l_sql,l_sql1,l_sql2       string 

   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_hrzx.hrzx02 IS NULL AND g_hrzx.hrzx03 IS NULL THEN RETURN END IF
   SELECT * INTO g_hrzx.* FROM hrzx_file WHERE hrzx02=g_hrzx.hrzx01 AND hrzx03=g_hrzx.hrzx03
#   IF g_hrzx.hrzxacti ='N' THEN CALL cl_err(g_hrzx.hrzx01,'9027',0) RETURN END IF
# 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT hrzxa02,hrzxa03,hrzxa04,'',hrzxa05,hrzxa06",
                      " FROM hrzxa_file ",
                      " WHERE hrzxa01=? AND hrzxa02=? FOR UPDATE"
#                      " WHERE hrzxa01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i901_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   
      INPUT ARRAY g_hrzxa WITHOUT DEFAULTS FROM s_hrzxa.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
   
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
 
          BEGIN WORK
          OPEN i901_cl USING g_hrzx.hrzx01
          IF STATUS THEN
             CALL cl_err("OPEN i901_cl:", STATUS, 1)
             CLOSE i901_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i901_cl INTO g_hrzx.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i901_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b1 >= l_ac THEN
             LET p_cmd='u'
             LET g_hrzxa_t.* = g_hrzxa[l_ac].*  #BACKUP
             OPEN i901_b1_cl USING g_hrzx.hrzx01,g_hrzxa_t.hrzxa02
             IF STATUS THEN
                CALL cl_err("OPEN i901_b1_cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i901_b1_cl INTO g_hrzxa[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrzxa_t.hrzxa02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
              SELECT hrao02 INTO g_hrzxa[l_ac].hrzxa04_n FROM hrao_file WHERE hrao01=g_hrzxa[l_ac].hrzxa04
          END IF
 
       BEFORE INSERT
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_hrzxa[l_ac].* TO NULL      #900423
          LET g_hrzxa_t.* = g_hrzxa[l_ac].*         #新輸入資料
          NEXT FIELD hrzxa02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO hrzxa_file(hrzxa01,hrzxa02,hrzxa03,hrzxa04,hrzxa05,hrzxa06)
          VALUES(g_hrzx.hrzx01,g_hrzxa[l_ac].hrzxa02,g_hrzxa[l_ac].hrzxa03,g_hrzxa[l_ac].hrzxa04,g_hrzxa[l_ac].hrzxa05,g_hrzxa[l_ac].hrzxa06)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_hrzxa[l_ac].hrzxa02,SQLCA.sqlcode,0)   #No.FUN-660092
             CALL cl_err3("ins","hrzxa_file",g_hrzx.hrzx01,g_hrzxa[l_ac].hrzxa02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b1=g_rec_b1+1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             COMMIT WORK
          END IF
           
       BEFORE FIELD hrzxa02
          IF g_hrzxa[l_ac].hrzxa02 IS NULL OR g_hrzxa[l_ac].hrzxa02 = 0 THEN
             SELECT max(hrzxa02)+1
               INTO g_hrzxa[l_ac].hrzxa02
               FROM hrzxa_file
              WHERE hrzxa01 = g_hrzx.hrzx01
             IF g_hrzxa[l_ac].hrzxa02 IS NULL THEN
                LET g_hrzxa[l_ac].hrzxa02 = 1
             END IF
          END IF
 
       AFTER FIELD hrzxa02                        #check 序號是否重複
          IF NOT cl_null(g_hrzxa[l_ac].hrzxa02) THEN
              
             IF g_hrzxa[l_ac].hrzxa02 != g_hrzxa_t.hrzxa02 OR
                g_hrzxa_t.hrzxa02 IS NULL THEN
                SELECT count(*) INTO l_n FROM hrzxa_file
                 WHERE hrzxa01 = g_hrzx.hrzx01
                   AND hrzxa02 = g_hrzxa[l_ac].hrzxa02 
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_hrzxa[l_ac].hrzxa02 = g_hrzxa_t.hrzxa02
                   NEXT FIELD hrzxa02
                END IF
             END IF
          END IF
         
       AFTER FIELD hrzxa04
          IF NOT cl_null(g_hrzxa[l_ac].hrzxa04) THEN 
             SELECT hrao02 INTO g_hrzxa[l_ac].hrzxa04_n FROM hrao_file WHERE hrao01=g_hrzxa[l_ac].hrzxa04
              DISPLAY BY NAME g_hrzxa[l_ac].hrzxa04_n
          END IF   
        
#       AFTER FIELD hrzxa03
#          IF NOT cl_null(g_hrzxa[l_ac].hrzxa03) THEN
#             LET l_sql=" SELECT SUM(salpay_amount)  FROM salespay WHERE salpay_salorg='",g_hrzx.hrzx02,"' AND salpay_date =to_date('", g_hrzx.hrzx04,"','yy/mm/dd') AND salpay_trncls='XSDJ'
#                         AND to_number(substr(salpay_time,1,2))*60+to_number(substr(salpay_time,4,2)) >= to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',1,2))*60+ to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',4,2))
#                         AND to_number(substr(salpay_time,1,2))*60+to_number(substr(salpay_time,4,2)) <= to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',7,2))*60+ to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',10,2))
#                       "
#             PREPARE i901_pb_214_1 FROM l_sql
#             DECLARE hrzxa_curs_214_1 CURSOR FOR i901_pb_214_1
#              
#             FOREACH hrzxa_curs_214_1  INTO g_hrzxa[l_ac].hrzxa04
#                     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#             END FOREACH 
#             
#             LET l_sql1=" SELECT SUM(salpay_amount)  FROM salespay WHERE salpay_salorg='",g_hrzx.hrzx02,"' AND salpay_date =to_date('", g_hrzx.hrzx05,"','yy/mm/dd') AND salpay_trncls='XSDJ'
#                         AND to_number(substr(salpay_time,1,2))*60+to_number(substr(salpay_time,4,2)) >= to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',1,2))*60+ to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',4,2))
#                         AND to_number(substr(salpay_time,1,2))*60+to_number(substr(salpay_time,4,2)) <= to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',7,2))*60+ to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',10,2))
#                       " 
#             PREPARE i901_pb_214_2 FROM l_sql1
#             DECLARE hrzxa_curs_214_2 CURSOR FOR i901_pb_214_2
#              
#             FOREACH hrzxa_curs_214_2  INTO g_hrzxa[l_ac].hrzxa05
#                     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#             END FOREACH  
#              
#             LET l_sql2=" SELECT SUM(salpay_amount)  FROM salespay WHERE salpay_salorg='",g_hrzx.hrzx02,"' AND salpay_date =to_date('", g_hrzx.hrzx06,"','yy/mm/dd') AND salpay_trncls='XSDJ'
#                         AND to_number(substr(salpay_time,1,2))*60+to_number(substr(salpay_time,4,2)) >= to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',1,2))*60+ to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',4,2))
#                         AND to_number(substr(salpay_time,1,2))*60+to_number(substr(salpay_time,4,2)) <= to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',7,2))*60+ to_number(substr('",g_hrzxa[l_ac].hrzxa03,"',10,2))
#                       "
#             PREPARE i901_pb_214_3 FROM l_sql
#             DECLARE hrzxa_curs_214_3 CURSOR FOR i901_pb_214_3
#              
#             FOREACH hrzxa_curs_214_3  INTO g_hrzxa[l_ac].hrzxa07
#                     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#             END FOREACH 
#                              
#             IF cl_null(g_hrzxa[l_ac].hrzxa04) OR g_hrzxa[l_ac].hrzxa04=0 THEN 
#                LET g_hrzxa[l_ac].hrzxa06=0 
#                LET g_hrzxa[l_ac].hrzxa04=0
#             ELSE IF NOT cl_null(g_hrzxa[l_ac].hrzxa05) OR g_hrzxa[l_ac].hrzxa05!=0 THEN 
#                     LET g_hrzxa[l_ac].hrzxa06=g_hrzxa[l_ac].hrzxa05/g_hrzxa[l_ac].hrzxa04*100,'%'
#                  END IF 
#             END IF 
#             
#             IF cl_null(g_hrzxa[l_ac].hrzxa05) OR g_hrzxa[l_ac].hrzxa05=0 THEN 
#                LET g_hrzxa[l_ac].hrzxa08=0 
#                LET g_hrzxa[l_ac].hrzxa05=0
#             ELSE IF NOT cl_null(g_hrzxa[l_ac].hrzxa07) OR g_hrzxa[l_ac].hrzxa07!=0 THEN 
#                     LET g_hrzxa[l_ac].hrzxa08=g_hrzxa[l_ac].hrzxa07/g_hrzxa[l_ac].hrzxa05*100,'%'
#                  ELSE LET g_hrzxa[l_ac].hrzxa07=0           
#                  END IF 
#             END IF 
#         
#              
#             IF  g_hrzxa[l_ac].hrzxa07!=0 AND g_hrzxa[l_ac].hrzxa05!=0 AND g_hrzxa[l_ac].hrzxa04!=0  THEN  
#                    LET g_hrzxa[l_ac].hrzxa09=(g_hrzxa[l_ac].hrzxa04+g_hrzxa[l_ac].hrzxa05+g_hrzxa[l_ac].hrzxa07)/3 
#             ELSE  IF  g_hrzxa[l_ac].hrzxa07=0 AND NOT g_hrzxa[l_ac].hrzxa05!=0 AND NOT g_hrzxa[l_ac].hrzxa04!=0  THEN
#              	       LET g_hrzxa[l_ac].hrzxa09=(g_hrzxa[l_ac].hrzxa04+g_hrzxa[l_ac].hrzxa05+g_hrzxa[l_ac].hrzxa07)/2
#              	   ELSE  IF  g_hrzxa[l_ac].hrzxa07=0 AND NOT g_hrzxa[l_ac].hrzxa05=0 AND NOT g_hrzxa[l_ac].hrzxa04!=0  THEN
#              	             LET g_hrzxa[l_ac].hrzxa09=(g_hrzxa[l_ac].hrzxa04+g_hrzxa[l_ac].hrzxa05+g_hrzxa[l_ac].hrzxa07) 
#              	         END IF  
#              	   END IF               	       
#             END IF 
#           #  DISPLAY BY NAME g_hrzxa[l_ac].hrzxa04
#             NEXT FIELD hrzxa10
#          END IF
          
#       AFTER FIELD hrzxa10
#             IF NOT cl_null(g_hrzxa[l_ac].hrzxa10) THEN 
#                LET g_hrzxa[l_ac].hrzxa11=g_hrzxa[l_ac].hrzxa10+g_hrzxa[l_ac].hrzxa09
#                IF NOT cl_null(g_hrzxa[l_ac].hrzxa09) THEN 
#                LET g_hrzxa[l_ac].hrzxa12=g_hrzxa[l_ac].hrzxa10/g_hrzxa[l_ac].hrzxa09*100,'%'
#             #   ELSE  LET g_hrzxa[l_ac].hrzxa12
#                END IF 	  
#             END IF       
               
       BEFORE DELETE                            #是否取消單身
          IF g_hrzxa_t.hrzxa02 > 0 AND
             g_hrzxa_t.hrzxa02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM hrzxa_file
              WHERE hrzxa01 = g_hrzx.hrzx01
                AND hrzxa02 = g_hrzxa_t.hrzxa02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_hrzxa_t.hrzxa02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("del","hrzxa_file",g_hrzx.hrzx01,g_hrzxa_t.hrzxa02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b1=g_rec_b1-1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             MESSAGE "Delete Ok"
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hrzxa[l_ac].* = g_hrzxa_t.*
             CLOSE i901_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_hrzxa[l_ac].hrzxa02,-263,1)
             LET g_hrzxa[l_ac].* = g_hrzxa_t.*
          ELSE
             UPDATE hrzxa_file SET  hrzxa02 = g_hrzxa[l_ac].hrzxa02,
                                    hrzxa03 = g_hrzxa[l_ac].hrzxa03,
                                    hrzxa04 = g_hrzxa[l_ac].hrzxa04,
                                    hrzxa05 = g_hrzxa[l_ac].hrzxa05,
                                    hrzxa06 = g_hrzxa[l_ac].hrzxa06
              WHERE hrzxa01=g_hrzx.hrzx01 AND hrzxa02=g_hrzxa_t.hrzxa02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_hrzxa[l_ac].hrzxa02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","hrzxa_file",g_hrzx.hrzx01,g_hrzxa_t.hrzxa02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                LET g_hrzxa[l_ac].* = g_hrzxa_t.*
                CLOSE i901_b1_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D40030
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_hrzxa[l_ac].* = g_hrzxa_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_hrzxa.deleteElement(l_ac)
                IF g_rec_b1 != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i901_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D40030
          CLOSE i901_b1_cl
          COMMIT WORK
        
        ON ACTION CONTROLP
         CASE 
          WHEN INFIELD(hrzxa04)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_hrao01_1"
            CALL cl_create_qry() RETURNING g_hrzxa[l_ac].hrzxa04
            DISPLAY BY NAME g_hrzxa[l_ac].hrzxa04 
            NEXT FIELD hrzxa04
          OTHERWISE
               EXIT CASE
         END CASE
       
       ON ACTION CONTROLN
          CALL i901_b1_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(hrzxa01) AND l_ac > 1 THEN
               LET g_hrzxa[l_ac].* = g_hrzxa[l_ac-1].*
               NEXT FIELD hrzxa01
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls        
         CALL cl_set_head_visible("folder01","AUTO")                       
#No.FUN-6B0029--end                   
 
   END INPUT
 
  #start FUN-5A0029
   LET g_hrzx.hrzxmodu = g_user
   LET g_hrzx.hrzxdate = g_today
   UPDATE hrzx_file SET hrzxmodu = g_hrzx.hrzxmodu,hrzxdate = g_hrzx.hrzxdate
    WHERE hrzx02 = g_hrzx.hrzx02 AND hrzx03 = g_hrzx.hrzx03
   DISPLAY BY NAME g_hrzx.hrzxmodu,g_hrzx.hrzxdate
  #end FUN-5A0029
   CALL i901_b1_fill(g_wc)
   CLOSE i901_b1_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i901_b1_askkey()
   #DEFINE l_wc2           VARCHAR(200) #TQC-630166   
    DEFINE l_wc2           STRING    #TQC-630166   
 
    CONSTRUCT l_wc2 ON hrzxa02,hrzxa03,hrzxa04,hrzxa05,hrzxa06
            FROM s_hrzxa[1].hrzxa02,s_hrzxa[1].hrzxa03,s_hrzxa[1].hrzxa04,
                 s_hrzxa[1].hrzxa05,s_hrzxa[1].hrzxa06
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i901_b1_fill(l_wc2)
END FUNCTION
 
FUNCTION i901_b1_fill(p_wc1)
DEFINE
   #p_wc1           VARCHAR(200) #TQC-630166     
    p_wc1           STRING    #TQC-630166     
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
    LET g_sql = "SELECT hrzxa02,hrzxa03,hrzxa04,hrao02,hrzxa05,hrzxa06 ",
                "  FROM hrzxa_file
                   left join hrao_file on hrao01=hrzxa04",
                " WHERE hrzxa01 ='",g_hrzx.hrzx01,"'",
                "   AND ",p_wc1 CLIPPED,
                " ORDER BY hrzxa02"
    PREPARE i901_pb1 FROM g_sql
    DECLARE hrzxa_curs1 CURSOR FOR i901_pb1
 
    CALL g_hrzxa.clear()
    LET l_ac = 1
    FOREACH hrzxa_curs1 INTO g_hrzxa[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_hrzxa.deleteElement(l_ac)
    LET g_rec_b1 = l_ac-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION
 
# NO.FUN-540036--start
FUNCTION i901_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_cmd  LIKE type_file.chr1000         #No.FUN-820002
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN    #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "detail" THEN  #FUN-D40030 add
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrzxa TO s_hrzxa.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     EXIT DISPLAY
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
     EXIT DISPLAY
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
     EXIT DISPLAY

#     ON ACTION confirm
#        LET g_action_choice="confirm"
#        EXIT DISPLAY
#
#     ON ACTION undo_confirm
#        LET g_action_choice="undo_confirm"
#        EXIT DISPLAY 
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
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
         CALL i901_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i901_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i901_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i901_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i901_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
#     ON ACTION xiangxi
#        LET g_action_choice="xiangxi"
#        EXIT DISPLAY
#     ON ACTION canzhao
#        LET g_action_choice="canzhao"
#        EXIT DISPLAY
#     ON ACTION zhiwei
#     ON ACTION gongshi
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end     
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#No.FUN-820002--start--
#FUNCTION i901_out()
#DEFINE
#   l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
#   sr              RECORD
#       hrzx01       LIKE hrzx_file.hrzx01,
#       hrzx02       LIKE hrzx_file.hrzx02,
#       hrzx06       LIKE hrzx_file.hrzx06,
#       hrzx14       LIKE hrzx_file.hrzx14,
#       hrzx15       LIKE hrzx_file.hrzx15,
#       hrzx16       LIKE hrzx_file.hrzx16,
#       hrzx17       LIKE hrzx_file.hrzx17,
#       hrzx10       LIKE hrzx_file.hrzx10,
#       gen02       LIKE gen_file.gen02
#      END RECORD,
#   l_name          LIKE type_file.chr20,          #No.FUN-680072 VARCHAR(20)
 
#   l_za05          LIKE type_file.chr1000         #No.FUN-680072 VARCHAR(40)
#DEFINE l_cmd  LIKE type_file.chr1000
#    IF cl_null(g_wc) AND NOT cl_null(g_hrzx.hrzx01) THEN                          
#       LET g_wc = " hrzx01 = '",g_hrzx.hrzx01,"' "                                 
#    END IF                                                                      
#    IF g_wc IS NULL THEN                                                        
#       CALL cl_err('','9057',0) RETURN                                          
#    END IF                                                                      
#    LET l_cmd = 'p_query "aemi901" "',g_wc CLIPPED,'"'                          
#    CALL cl_cmdrun(l_cmd)
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN
#   END IF
#   IF cl_null(g_wc) AND NOT cl_null(g_hrzx.hrzx01) THEN
#      LET g_wc = " hrzx01 = '",g_hrzx.hrzx01,"' "
#   END IF
#   IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1 " END IF
#   IF cl_null(g_wc3) THEN LET g_wc3 = " 1=1 " END IF
#   IF cl_null(g_wc4) THEN LET g_wc4 = " 1=1 " END IF
#   IF cl_null(g_wc5) THEN LET g_wc5 = " 1=1 " END IF
#   CALL cl_wait()
#   CALL cl_outnam('aemi901') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   LET g_sql="SELECT hrzx01,hrzx02,hrzx06,hrzx14,hrzx15,hrzx16,",
#             "       hrzx17,hrzx10,gen02 ",
#             g_sql1 CLIPPED,",LEFT OUTER JOIN hrzx_file ON hrzx_file.hrzx10 = gen_file.gen02",
#             g_sql2 CLIPPED, 
#             " ORDER BY hrzx01"
#   PREPARE i901_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i901_co CURSOR FOR i901_p1
 
#   START REPORT i901_rep TO l_name
 
#   FOREACH i901_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)             
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i901_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i901_rep
 
#   CLOSE i901_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION

#FUNCTION i901_x()
#   IF s_shut(0) THEN RETURN END IF
#   IF g_hrzx.hrzx01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
#   SELECT * INTO g_hrzx.* FROM hrzx_file
#    WHERE hrzx01=g_hrzx.hrzx01
# 
#   BEGIN WORK
# 
#   OPEN i901_cl USING g_hrzx.hrzx01
#   IF STATUS THEN
#      CALL cl_err("OPEN i901_cl:", STATUS, 1)   
#      CLOSE i901_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH i901_cl INTO g_hrzx.*               # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#       CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)          #資料被他人LOCK
#       ROLLBACK WORK
#       RETURN
#   END IF
#   CALL i901_show()
#   IF cl_exp(0,0,g_hrzx.hrzxacti) THEN                   #確認一下
#       LET g_chr=g_hrzx.hrzxacti
#       IF g_hrzx.hrzxacti='Y' THEN
#           LET g_hrzx.hrzxacti='N'
#       ELSE
#           LET g_hrzx.hrzxacti='Y'
#       END IF
#       UPDATE hrzx_file
#          SET hrzxacti=g_hrzx.hrzxacti, #更改有效碼
#              hrzxmodu=g_user,
#              hrzxdate=g_today
#        WHERE hrzx01=g_hrzx.hrzx01
#       IF SQLCA.sqlcode OR STATUS=100 THEN
#           CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)   
#           LET g_hrzx.hrzxacti=g_chr
#       END IF
#       SELECT hrzxacti,hrzxmodu,hrzxdate
#         INTO g_hrzx.hrzxacti,g_hrzx.hrzxmodu,g_hrzx.hrzxdate
#         FROM hrzx_file
#        WHERE hrzx01=g_hrzx.hrzx01
#       DISPLAY BY NAME g_hrzx.hrzxacti,g_hrzx.hrzxmodu,g_hrzx.hrzxdate
#   END IF
#   CALL i901_pic()
#   CLOSE i901_cl
#   COMMIT WORK
#END FUNCTION
 
FUNCTION i901_copy()
DEFINE
    l_newno        LIKE hrzx_file.hrzx01,
    l_oldno        LIKE hrzx_file.hrzx01,
    l_gen02        LIKE gen_file.gen02
    
    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
    IF s_shut(0) THEN RETURN END IF
    IF g_hrzx.hrzx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i901_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM hrzx01
        AFTER FIELD hrzx01
            IF l_newno IS NULL THEN
                NEXT FIELD hrzx01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM hrzx_file
             WHERE hrzx01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD hrzx01
            END IF
       
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM hrzx_file         #單頭復制
     WHERE hrzx01=g_hrzx.hrzx01
      INTO TEMP y
    UPDATE y
        SET hrzx01=l_newno,     #新的鍵值
            hrzxuser=g_user,    #資料所有者
            hrzxgrup=g_grup,    #資料所有者所屬群
            hrzxdate = g_today
    INSERT INTO hrzx_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
#       CALL  cl_err(l_newno,SQLCA.sqlcode,0)  # No.FUN-660092
        CALL cl_err3("ins","hrzx_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
    END IF
 
    DROP TABLE x
    SELECT * FROM hrzxa_file         #單身復制
     WHERE hrzxa01=g_hrzx.hrzx01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    UPDATE x SET hrzxa01=l_newno
    INSERT INTO hrzxa_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","hrzxa_file",g_hrzx.hrzx01,g_hrzxa_t.hrzxa02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM hrzxa_file WHERE hrzxa01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_hrzx.hrzx01
    SELECT hrzx_file.* INTO g_hrzx.* FROM hrzx_file
     WHERE hrzx01 = l_newno
    CALL i901_u()
    CALL i901_b1()
    #FUN-C30027---begin
    #SELECT hrzx_file.* INTO g_hrzx.* FROM hrzx_file
    # WHERE hrzx01 = l_oldno
    #CALL i901_show()
    #FUN-C30027---end
END FUNCTION
 
FUNCTION i901_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         
END FUNCTION
 
FUNCTION i901_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     
END FUNCTION

#FUNCTION i901_y()
# 
#   IF cl_null(g_hrzx.hrzx01) THEN 
#        CALL cl_err('','apj-003',0) 
#        RETURN 
#   END IF
#   
#   IF g_hrzx.hrzxacti='N' THEN
#        CALL cl_err('','atm-364',0)
#        RETURN
#   END IF
# 
#   IF g_hrzx.hrzx08 = 'Y' THEN
#      CALL cl_err('','9004',0)
#      RETURN
#   END IF
#   
#   IF NOT cl_confirm('axm-108') THEN 
#        RETURN
#   END IF
#   
#   BEGIN WORK
#   LET g_success = 'Y'
# 
#   OPEN i901_cl USING g_hrzx.hrzx02,g_hrzx.hrzx03
#   IF STATUS THEN
#      CALL cl_err("OPEN i901_cl:", STATUS, 1)
#      CLOSE i901_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH i901_cl INTO g_hrzx.*    
#      IF SQLCA.sqlcode THEN
#      CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)      
#      CLOSE i901_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   UPDATE hrzx_file SET hrzx08='Y' 
#    WHERE hrzx02 = g_hrzx.hrzx02 AND hrzx03 = g_hrzx.hrzx03
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("upd","hrzx_file",g_hrzx.hrzx01,"",STATUS,"","",1) 
#      LET g_success = 'N'
#   ELSE
#      IF SQLCA.sqlerrd[3]=0 THEN
#         CALL cl_err3("upd","hrzx_file",g_hrzx.hrzx01,"","9050","","",1) 
#         LET g_success = 'N'
#      ELSE
#         LET g_hrzx.hrzx08 = 'Y'
#         DISPLAY BY NAME g_hrzx.hrzx08
#      END IF
#   END IF
# 
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#   END IF
#   CALL i901_pic()     #圖形顯示   #CHI-BC0031 add
# 
#END FUNCTION
#
#FUNCTION i901_z()
# 
#   IF cl_null(g_hrzx.hrzx01) THEN
#      CALL cl_err('','apj-003',0)
#      RETURN
#   END IF
# 
#   IF g_hrzx.hrzxacti='N' THEN
#        CALL cl_err('','atm-365',0)
#        RETURN
#   END IF
#   
#   IF g_hrzx.hrzx08 = 'N' THEN
#      CALL cl_err('','9002',0)
#      RETURN
#   END IF
# 
#   IF NOT cl_confirm('axm-109') THEN
#      RETURN
#   END IF
# 
#   BEGIN WORK
#   LET g_success = 'Y'
# 
#   OPEN i901_cl USING g_hrzx.hrzx02,g_hrzx.hrzx03
#   IF STATUS THEN
#      CALL cl_err("OPEN i901_cl:", STATUS, 1)
#      CLOSE i901_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH i901_cl INTO g_hrzx.*            
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_hrzx.hrzx01,SQLCA.sqlcode,0)     
#      CLOSE i901_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   UPDATE hrzx_file SET hrzx08='N'
#    WHERE hrzx01 = g_hrzx.hrzx01
#   IF SQLCA.sqlcode  THEN
#      CALL cl_err3("upd","hrzx_file",g_hrzx.hrzx01,"",STATUS,"","",1) 
#      LET g_success = 'N'
#   ELSE
#      IF SQLCA.sqlerrd[3]=0 THEN
#         CALL cl_err3("upd","hrzx_file",g_hrzx.hrzx01,"","9053","","",1) 
#         LET g_success = 'N'
#      ELSE
#         LET g_hrzx.hrzx08 = 'N'
#         DISPLAY BY NAME g_hrzx.hrzx08
#      END IF
#   END IF
# 
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#   END IF
#   CALL i901_pic()     #圖形顯示   #CHI-BC0031 add
# 
#END FUNCTION

#FUNCTION i901_pic()
#   CASE g_hrzx.hrzx08
#        WHEN 'Y'   LET g_confirm = 'Y'
#                   LET g_void = ''
#        WHEN 'N'   LET g_confirm = 'N'
#                   LET g_void = ''
#     OTHERWISE     LET g_confirm = ''
#                   LET g_void = ''
#   END CASE 
#
#   #圖形顯示
#   CALL cl_set_field_pic(g_confirm, "" , "" ,  "" , g_void, g_hrzx.hrzxacti)
#                        #確認碼    #核  #過帳  #結案    #作廢    #有效
#END FUNCTION
