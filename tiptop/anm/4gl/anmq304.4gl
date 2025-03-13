# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmq304.4gl
# Descriptions...: 付款指令狀態查詢更新作業
# Date & Author..: No.FUN-740007 07/03/27 By Rayven
# Modify.........: No.MOD-8A0168 08/10/20 By Sarah 抓取azf03時,key值需多串azf02為S,R
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-740007 新增
DEFINE 
    m_nps           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        nps03       LIKE nps_file.nps03,
        nps01       LIKE nps_file.nps01,
        nps05       LIKE nps_file.nps05,
        nps07       LIKE nps_file.nps07,
        nps12       LIKE nps_file.nps12,
        nps13       LIKE nps_file.nps13,
        nps17       LIKE nps_file.nps17,
        nps20       LIKE nps_file.nps20,
        nps21       LIKE nps_file.nps21,
        nps22       LIKE nps_file.nps22,
        nps15       LIKE nps_file.nps15,
        nps16       LIKE nps_file.nps16,
        nps23       LIKE nps_file.nps23,
        nps24       LIKE nps_file.nps24
                    END RECORD,
    m_nps_t         RECORD                 #程式變數 (舊值)
        nps03       LIKE nps_file.nps03,
        nps01       LIKE nps_file.nps01,
        nps05       LIKE nps_file.nps05,
        nps07       LIKE nps_file.nps07,
        nps12       LIKE nps_file.nps12,
        nps13       LIKE nps_file.nps13,
        nps17       LIKE nps_file.nps17,
        nps20       LIKE nps_file.nps20,
        nps21       LIKE nps_file.nps21,
        nps22       LIKE nps_file.nps22,
        nps15       LIKE nps_file.nps15,
        nps16       LIKE nps_file.nps16,
        nps23       LIKE nps_file.nps23,
        nps24       LIKE nps_file.nps24
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,            #單身筆數
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT
DEFINE p_row,p_col  LIKE type_file.num5
DEFINE g_msg1       LIKE ze_file.ze03
DEFINE g_msg2       LIKE ze_file.ze03
DEFINE g_msg3       LIKE ze_file.ze03
DEFINE g_msg4       LIKE ze_file.ze03
DEFINE g_msg5       LIKE ze_file.ze03
DEFINE g_msg6       LIKE ze_file.ze03
DEFINE g_reqnbr     LIKE type_file.chr1000
DEFINE g_nmv        RECORD LIKE nmv_file.*
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose
DEFINE g_cmd        LIKE type_file.chr1000
 
MAIN
 
  OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
  DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_aza.aza73 = 'N' THEN
      CALL cl_err('','anm-980',1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
        RETURNING g_time
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q304_w AT p_row,p_col WITH FORM "anm/42f/anmq304"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   CALL q304_menu()
 
   CLOSE WINDOW q304_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
        RETURNING g_time
 
END MAIN
 
FUNCTION q304_menu()
 
   WHILE TRUE
      CALL q304_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q304_q()
            END IF
 
         WHEN "update_payment_status"
            IF cl_chk_act_auth() THEN
               CALL q304_ups()
            END IF
 
         WHEN "query_fund_transaction_record"
            IF cl_chk_act_auth() THEN
               CALL q304_qftr()
            END IF
 
         WHEN "query_private_payment_detail_status"
            IF cl_chk_act_auth() THEN
               IF m_nps[l_ac].nps03 MATCHES 'N03*' THEN
                  CALL q304_qppds()
               ELSE
                  CALL cl_err('','anm-264',1)
               END IF
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q304_q()
 
   CALL q304_b_askkey()
 
END FUNCTION
 
FUNCTION q304_b_askkey()
 
   CLEAR FORM
   CALL m_nps.clear()
 
   CONSTRUCT g_wc2 ON nps03,nps01,nps05,nps07,nps12,nps13,nps17,
                      nps20,nps21,nps22,nps15,nps16,nps23,nps24
           FROM s_nps[1].nps03,s_nps[1].nps01,s_nps[1].nps05,
                s_nps[1].nps07,s_nps[1].nps12,s_nps[1].nps13,
                s_nps[1].nps17,s_nps[1].nps20,s_nps[1].nps21,
                s_nps[1].nps22,s_nps[1].nps15,s_nps[1].nps16,
                s_nps[1].nps23,s_nps[1].nps24
 
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
         
           ON ACTION about
              CALL cl_about()
           
           ON ACTION help
              CALL cl_show_help()
 
           ON ACTION CONTROLP
              IF INFIELD(nps13) THEN
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi3"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nps13
                 NEXT FIELD nps13
              END IF
           
           ON ACTION controlg
              CALL cl_cmdask()
           
           ON ACTION qbe_select
              CALL cl_qbe_select() 
        
           ON ACTION qbe_save
              CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL q304_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION q304_b_fill(p_wc2)
#   DEFINE p_wc2      LIKE type_file.chr1000
   DEFINE p_wc2  STRING     #NO.FUN-910082
   DEFINE l_year     LIKE type_file.chr4
 
   LET g_sql = "SELECT nps03,nps01,nps05,nps07,nps12,nps13,nps17,",
               "       nps20,nps21,nps22,nps15,nps16,nps23,nps24",
               "  FROM nps_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY nps01"
   PREPARE q304_pb FROM g_sql
   DECLARE nps_curs CURSOR FOR q304_pb
 
   CALL m_nps.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH nps_curs INTO m_nps[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF NOT cl_null(m_nps[g_cnt].nps23) THEN
         LET l_year  = YEAR(m_nps[g_cnt].nps23)
         IF l_year = '1899' THEN
            LET m_nps[g_cnt].nps23 = NULL
         END IF
      END IF
      IF NOT cl_null(m_nps[g_cnt].nps24) THEN
         LET l_year  = YEAR(m_nps[g_cnt].nps24)
         IF l_year = '1899' THEN
            LET m_nps[g_cnt].nps24 = NULL
         END IF
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL m_nps.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q304_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF m_nps[1].nps01 IS NULL THEN
      CALL cl_set_act_visible("update_payment_status,query_fund_transaction_record,query_private_payment_detail_status",FALSE)
   ELSE
      CALL cl_set_act_visible("update_payment_status,query_fund_transaction_record,query_private_payment_detail_status",TRUE)
   END IF
   DISPLAY ARRAY m_nps TO s_nps.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION update_payment_status
         LET g_action_choice="update_payment_status"
         EXIT DISPLAY
 
      ON ACTION query_fund_transaction_record
         LET g_action_choice="query_fund_transaction_record"
         EXIT DISPLAY
 
      ON ACTION query_private_payment_detail_status
         LET g_action_choice="query_private_payment_detail_status"
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q304_ups()
  DEFINE l_p        String
  DEFINE l_q        String
  DEFINE l_result   String
  DEFINE l_success  LIKE type_file.chr1
 
    IF cl_null(m_nps[l_ac].nps17) OR m_nps[l_ac].nps17 = '1'
       OR m_nps[l_ac].nps17 = '4' OR m_nps[l_ac].nps17 = '9' THEN
       CALL cl_err('','anm-979',0)
       RETURN
    END IF
 
    IF cl_null(g_aza.aza74) THEN 
       CALL cl_err('','anm-702',1)
       RETURN
    ELSE
      CALL q304_nmv01()
      IF NOT cl_null(g_errno) THEN 
         CALL cl_err('',g_errno,1)
         RETURN
      END IF 
      LET l_q = "LGNTYP=0 ;LGNNAM=",g_nmv.nmv03 CLIPPED," ;LGNPWD=",g_nmv.nmv04 CLIPPED," ;ICCPWD=",g_nmv.nmv07 CLIPPED
    END IF 
 
    IF m_nps[l_ac].nps03 MATCHES 'N02*' THEN
       LET l_p = "BUSCOD=",m_nps[l_ac].nps03," ;DATFLG=B ;BGNDAT=",m_nps[l_ac].nps23 USING "yyyymmdd"," ;ENDDAT=",m_nps[l_ac].nps23 USING "yyyymmdd"," ;YURREF=",m_nps[l_ac].nps01 CLIPPED
       CALL cl_cmbinf(l_q,"GetPaymentInfo",l_p,"|") RETURNING l_result
       CALL q304_s(l_result,'|','a') RETURNING l_success
       IF l_success = 'N' THEN
          CALL cl_err('','abm-020',0)
          RETURN
       END IF
    END IF
    IF m_nps[l_ac].nps03 MATCHES 'N03*' THEN
       LET l_p = "BUSCOD=",m_nps[l_ac].nps03," ;DATFLG=B ;BGNDAT=",m_nps[l_ac].nps23 USING "yyyymmdd"," ;ENDDAT=",m_nps[l_ac].nps23 USING "yyyymmdd"," ;YURREF=",m_nps[l_ac].nps01 CLIPPED
       CALL cl_cmbinf(l_q,"GetAgentInfo",l_p,"|") RETURNING l_result
       CALL q304_s(l_result,'|','b') RETURNING l_success
       IF l_success = 'N' THEN
          CALL cl_err('','abm-020',0)
          RETURN
       END IF
    END IF
 
    CALL q304_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q304_qftr()
  DEFINE l_nme12   LIKE nme_file.nme12
 
    SELECT DISTINCT(nme12) INTO l_nme12 FROM nme_file
     WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) = m_nps[l_ac].nps01
    IF cl_null(l_nme12) THEN
       CALL cl_err('','anm-969',1)
       RETURN
    ELSE
       LET g_cmd = "anmt300 '",l_nme12,"' ''"
       CALL cl_cmdrun(g_cmd)
    END IF
END FUNCTION
 
FUNCTION q304_qppds()
  DEFINE l_p          String
  DEFINE l_q          String
  DEFINE l_result     String
  DEFINE l_success    LIKE type_file.chr1
  DEFINE 
         #l_sql        LIKE type_file.chr1000
         l_sql        STRING       #NO.FUN-910082
  DEFINE l_rec_tmp_b  LIKE type_file.num5
  DEFINE g_tmp        DYNAMIC ARRAY OF RECORD
                      accnbr    LIKE type_file.num20,
                      cltnam    LIKE type_file.chr20,
                      trsamt    LIKE type_file.num20_6,
                      stscod    LIKE type_file.chr8,
                      errdsp    LIKE type_file.chr30,
                      trsdsp    LIKE type_file.chr18
                      END RECORD
 
    IF m_nps[l_ac].nps03 MATCHES 'N03*' THEN
       CALL cl_err('','anm-978',0)
       RETURN
    END IF
    IF cl_null(m_nps[l_ac].nps17) OR m_nps[l_ac].nps17 = '1'
       OR m_nps[l_ac].nps17 = '9' THEN
       CALL cl_err('','anm-979',0)
       RETURN
    END IF
 
    DROP TABLE x
    CREATE TEMP TABLE x
                 (accnbr    LIKE type_file.num20,
                  cltnam    LIKE type_file.chr20,
                  trsamt    LIKE type_file.num20_6,
                  stscod    LIKE type_file.chr8,
                  errdsp    LIKE type_file.chr30,
                  trsdsp    LIKE type_file.chr18);
    DELETE FROM x
 
    IF cl_null(g_aza.aza74) THEN 
       CALL cl_err('','anm-702',1)
       RETURN
    ELSE
      CALL q304_nmv01()
      IF NOT cl_null(g_errno) THEN 
         CALL cl_err('',g_errno,1)
         RETURN
      END IF 
      LET l_q = "LGNTYP=0 ;LGNNAM=",g_nmv.nmv03 CLIPPED," ;LGNPWD=",g_nmv.nmv04 CLIPPED," ;ICCPWD=",g_nmv.nmv07 CLIPPED
    END IF 
 
    LET l_p = "BUSCOD=",m_nps[l_ac].nps03," ;DATFLG=B ;BGNDAT=",m_nps[l_ac].nps23 USING "yyyymmdd"," ;ENDDAT=",m_nps[l_ac].nps23 USING "yyyymmdd"," ;YURREF=",m_nps[l_ac].nps01 CLIPPED
    CALL cl_cmbinf(l_q,"GetAgentInfo",l_p,"|") RETURNING l_result
    CALL q304_s(l_result,'|','c') RETURNING l_success
    IF l_success = 'N' THEN
       CALL cl_err('','abm-020',0)
       RETURN
    END IF
    LET l_p = "REQNBR=",g_reqnbr CLIPPED
    CALL cl_cmbinf(l_q,"GetAgentDetail",l_p,"|") RETURNING l_result
    CALL q304_s(l_result,'|','c') RETURNING l_success
    IF l_success = 'N' THEN
       CALL cl_err('','abm-020',0)
       RETURN
    END IF
 
    OPEN WINDOW q304_1_w AT 12,2 WITH FORM "anm/42f/anmq304_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("anmq304_1")
 
    LET l_sql = "SELECT * FROM x"
    PREPARE q304_1_p FROM l_sql
    DECLARE q304_1_c CURSOR FOR q304_1_p
 
    LET g_cnt = 1
    FOREACH q304_1_c INTO g_tmp[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt+1
    END FOREACH
    CALL g_tmp.deleteElement(g_cnt)
 
    LET l_rec_tmp_b = g_cnt-1
    DISPLAY l_rec_tmp_b TO FORMONLY.cn1
    DISPLAY ARRAY g_tmp TO s_tmp.* ATTRIBUTE(COUNT=l_rec_tmp_b,UNBUFFERED)
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
    END IF
 
    CLOSE WINDOW q304_1_w
END FUNCTION
 
FUNCTION q304_s(param_str,param_delim,p_cmd)
  DEFINE param_str      STRING
  DEFINE param_delim    STRING
  DEFINE p_cmd          LIKE type_file.chr1
  DEFINE l_success      LIKE type_file.chr1
  DEFINE param_array    DYNAMIC ARRAY OF STRING
  DEFINE l_tok_param    base.StringTokenizer
  DEFINE l_cnt_param    LIKE type_file.num5
  DEFINE i              LIKE type_file.num5
  DEFINE j              LIKE type_file.num5
  DEFINE k              LIKE type_file.num5
  DEFINE param_step     LIKE type_file.chr1
  DEFINE data_str       STRING
  DEFINE data_delim     LIKE type_file.chr2
  DEFINE data_array     DYNAMIC ARRAY OF STRING
  DEFINE l_tok_data     base.StringTokenizer
  DEFINE l_cnt_data     LIKE type_file.num5
  DEFINE field_str      STRING
  DEFINE field_array    DYNAMIC ARRAY OF STRING
  DEFINE l_tok_field    base.StringTokenizer 
  DEFINE l_cnt_field    LIKE type_file.num5
  DEFINE l_str          STRING
  DEFINE l_tok_str      base.StringTokenizer 
  DEFINE l_cnt_str      LIKE type_file.num5
  DEFINE str_array      DYNAMIC ARRAY OF STRING
  DEFINE sr             RECORD
                        nps17      LIKE nps_file.nps17,
                        nps21      LIKE nps_file.nps21,
                        nps22      LIKE nps_file.nps22,
                        nps24      LIKE nps_file.nps24,
                        reqsts     LIKE type_file.chr10,
                        rtnflg     LIKE type_file.chr10
                        END RECORD
  DEFINE sr1            RECORD
                        accnbr    LIKE type_file.num20,
                        cltnam    LIKE type_file.chr20,
                        trsamt    LIKE type_file.num20_6,
                        stscod    LIKE type_file.chr8,
                        errdsp    LIKE type_file.chr30,
                        trsdsp    LIKE type_file.chr18
                        END RECORD
  DEFINE l_azf03        LIKE azf_file.azf03
  DEFINE l_azf03_2      LIKE azf_file.azf03
 
    LET l_success ='Y'
    BEGIN WORK
    #先判斷是否成功，若不成功則報錯。
    LET param_delim = param_delim.trimRight()
    LET l_tok_param = base.StringTokenizer.create(param_str,param_delim)
    LET l_cnt_param = l_tok_param.countTokens()
    IF l_cnt_param >0 THEN 
       CALL param_array.clear()
       LET i = 0 
       WHILE l_tok_param.hasMoreTokens()
           LET i=i+1
           LET param_array[i] =l_tok_param.nextToken()
       END WHILE 
    END IF 
    IF param_array[1] != '0' THEN 
       CALL cl_err(param_array[2],'3228',1)
       LET l_success ='N'
       RETURN l_success
    END IF 
    #剝出記錄
    IF param_array[1] = '0' THEN 
      # LET date_delim = "\r\n"
      # LET date_delim = date_delim.trimRight 
       LET data_str = param_array[2]
       IF NOT cl_null(data_str) THEN
          LET l_tok_data = base.StringTokenizer.create(data_str,"\r\n")
          LET l_cnt_data = l_tok_data.countTokens()
          IF l_cnt_data > 0 THEN 
             CALL data_array.clear()
             LET j=0
             WHILE l_tok_data.hasMoreTokens()
                LET j = j+1
                LET data_array[j]=l_tok_data.nextToken()     
             END WHILE
             #剝出字段
             FOR j=1 TO l_cnt_data
                 LET field_str = data_array[j]
                 LET l_tok_field = base.StringTokenizer.create(field_str," ;")
                 LET l_cnt_field = l_tok_field.countTokens()
                 IF l_cnt_field >0 THEN 
                    CALL field_array.clear()
                    LET k=0
                    WHILE l_tok_field.hasMoreTokens()
                       LET k=k+1
                       LET field_array[k]=l_tok_field.nextToken()   
                    END WHILE 
                 END IF 
                 #分析字段
                 FOR k = 1 TO l_cnt_field
                     LET l_str = field_array[k]
                     LET l_tok_str = base.StringTokenizer.create(l_str,"=")
                     LET l_cnt_str = l_tok_str.countTokens()
                     IF l_cnt_str > 0 THEN 
                        CALL str_array.clear()
                        LET i = 0
                        WHILE l_tok_str.hasMoreTokens()
                           LET i = i+1
                           LET str_array[i] = l_tok_str.nextToken()
                        END WHILE 
                        CASE str_array[1]
                          WHEN "OPRDAT"
                            LET sr.nps24 = str_array[2]
                          WHEN "REQSTS"
                            LET sr.reqsts = str_array[2]                       
                          WHEN "RTNFLG"
                            LET sr.rtnflg = str_array[2]
                          WHEN "SUCAMT"
                            LET sr.nps21 = str_array[2]
                          WHEN "SUCNUM"
                            LET sr.nps22 = str_array[2]
                          WHEN "REQNBR"
                            LET g_reqnbr = str_array[2]
                          WHEN "ACCNBR"
                            LET sr1.accnbr = str_array[2]
                          WHEN "CLTNAM"
                            LET sr1.cltnam = str_array[2]
                          WHEN "TRSAMT"
                            LET sr1.trsamt = str_array[2]
                          WHEN "STSCOD"
                            LET sr1.stscod = str_array[2]
                          WHEN "ERRDSP"
                            LET sr1.errdsp = str_array[2]
                          WHEN "TRSDSP"
                            LET sr1.trsdsp = str_array[2]
                          OTHERWISE EXIT CASE 
                        END CASE
                     END IF  
                 END FOR 
                 IF p_cmd = 'c' THEN
                    INSERT INTO x VALUES(sr1.*)
                    IF SQLCA.sqlcode THEN
                       CALL cl_err('insert into temptable:',SQLCA.sqlcode,1)
                       LET l_success ='N'
                       RETURN l_success
                    END IF
                 END IF
             END FOR 
             IF cl_null(sr.reqsts) THEN
                LET sr.nps17 = '2'
             ELSE
                IF sr.reqsts = 'FIN' THEN
                   IF sr.rtnflg = 'S' THEN
                      LET sr.nps17 = '4'
                   ELSE
                      LET sr.nps17 = '1'
                   END IF
                ELSE
                   LET sr.nps17 = '3'
                END IF
             END IF
          ELSE
             LET sr.nps17 = '2'
          END IF
          SELECT azf03 INTO l_azf03 FROM azf_file
           WHERE azf01 = sr.reqsts
             AND azf02 = 'R'   #MOD-8A0168 add   #R:支付業務的請求狀態
          SELECT azf03 INTO l_azf03_2 FROM azf_file
           WHERE azf01 = sr.rtnflg
             AND azf02 = 'S'   #MOD-8A0168 add   #R:支付業務的處理結果
          IF p_cmd = 'a' THEN 
             CALL cl_getmsg('anm-970',g_lang) RETURNING g_msg2
             CALL cl_getmsg('anm-971',g_lang) RETURNING g_msg3
             CALL cl_getmsg('anm-972',g_lang) RETURNING g_msg4
             LET g_msg1 = g_msg2 CLIPPED,sr.reqsts,':',l_azf03,g_msg3 CLIPPED,sr.rtnflg,':',l_azf03_2,g_msg4 CLIPPED
             IF NOT cl_confirm(g_msg1) THEN
                RETURN l_success
             END IF
             UPDATE nps_file SET nps17=sr.nps17,nps24=sr.nps24
              WHERE nps01 = m_nps[l_ac].nps01
             IF SQLCA.sqlcode THEN 
                CALL cl_err3("upd","nps_file",m_nps[l_ac].nps01,"",SQLCA.sqlcode,"","",1)
                LET l_success = 'N'
                ROLLBACK WORK
                RETURN l_success
             END IF 
             UPDATE nme_file SET nme24=sr.nps17,nme02=sr.nps24
              WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) = m_nps[l_ac].nps01
             IF SQLCA.sqlcode THEN 
                CALL cl_err3("upd","nme_file",m_nps[l_ac].nps01,"",SQLCA.sqlcode,"","",1)
                LET l_success = 'N'
                ROLLBACK WORK
                RETURN l_success
             END IF 
          ELSE
             CALL cl_getmsg('anm-970',g_lang) RETURNING g_msg2
             CALL cl_getmsg('anm-971',g_lang) RETURNING g_msg3
             CALL cl_getmsg('anm-973',g_lang) RETURNING g_msg4
             CALL cl_getmsg('anm-974',g_lang) RETURNING g_msg5
             CALL cl_getmsg('anm-972',g_lang) RETURNING g_msg6
             LET g_msg1 = g_msg2 CLIPPED,sr.reqsts,':',l_azf03,g_msg3 CLIPPED,sr.rtnflg,':',l_azf03_2,g_msg4 CLIPPED,sr.nps21,g_msg5 CLIPPED,sr.nps22,g_msg6 CLIPPED
             IF NOT cl_confirm(g_msg1) THEN
                RETURN l_success
             END IF
             IF p_cmd = 'b' THEN
                UPDATE nps_file SET nps17=sr.nps17,nps24=sr.nps24,
                                    nps21=sr.nps21,nps22=sr.nps22
                 WHERE nps01 = m_nps[l_ac].nps01
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("upd","nps_file",m_nps[l_ac].nps01,"",SQLCA.sqlcode,"","",1)
                   LET l_success = 'N'
                   ROLLBACK WORK
                   RETURN l_success
                END IF 
                UPDATE nme_file SET nme24=sr.nps17,nme02=sr.nps24
                 WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) = m_nps[l_ac].nps01
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("upd","nme_file",m_nps[l_ac].nps01,"",SQLCA.sqlcode,"","",1)
                   LET l_success = 'N'
                   ROLLBACK WORK
                   RETURN l_success
                END IF 
             END IF
          END IF 
       END IF 
    END IF 
    
    COMMIT WORK
    RETURN l_success
 
END FUNCTION
 
FUNCTION q304_nmv01() 
DEFINE 
    #l_sql           LIKE type_file.chr1000
    l_sql        STRING       #NO.FUN-910082
 
    LET g_errno = ''
    INITIALIZE g_nmv.* TO NULL 
    LET l_sql="SELECT * FROM nmv_file ",
              " WHERE nmv01=",g_aza.aza74
    PREPARE q304_pre_nmv01 FROM l_sql
    DECLARE q304_cs_nmv01 CURSOR FOR q304_pre_nmv01
    OPEN q304_cs_nmv01
    FETCH q304_cs_nmv01 INTO g_nmv.*
    CLOSE q304_cs_nmv01
    CASE SQLCA.sqlcode
      WHEN 100  LET g_errno = "anm-703"
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-----'
    END CASE 
END FUNCTION 
