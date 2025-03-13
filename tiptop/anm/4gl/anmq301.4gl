# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: anmq301.4gl
# Descriptions...: 銀行帳戶信息(余額)查詢作業
# Date & Author..: 07/03/27 By Xufeng
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-870067 08/07/15 By douzh 新增匯豐銀行接口
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nma01          LIKE nma_file.nma01
DEFINE g_nma39          LIKE nma_file.nma39
DEFINE g_sql            STRING
DEFINE g_wc             STRING
DEFINE g_curs_index     LIKE type_file.num5 
DEFINE g_row_count      LIKE type_file.num5   
DEFINE g_msg            STRING  
DEFINE g_jump           LIKE type_file.num10
DEFINE mi_no_ask        LIKE type_file.num5
DEFINE g_str            STRING  
DEFINE g_index          LIKE type_file.num20
DEFINE g_argv1          LIKE nma_file.nma01 
DEFINE g_argv2          LIKE nma_file.nma39                #No.FUN-870067
DEFINE g_tma    RECORD
               tma01 LIKE nma_file.nma01,
               tma02 LIKE nma_file.nma04, 
               tma03 LIKE nma_file.nma02,
               tma04 LIKE nma_file.nma39,
               tma05 LIKE nmt_file.nmt02,
               tma06 LIKE nma_file.nma10,
               tma07 LIKE type_file.chr10,
               tma08 LIKE nma_file.nma29,
               tma09 LIKE nma_file.nma29,
               tma10 LIKE nma_file.nma29,
               tma11 LIKE nma_file.nma29,
               tma12 LIKE nma_file.nma29,
               tma13 LIKE type_file.dat,
               tma14 LIKE type_file.dat,
               tma15 LIKE type_file.chr3,
               tma16 LIKE type_file.chr14,
               tma17 LIKE type_file.chr12,
               tma18 LIKE nmt_file.nmt02,
               tma19 LIKE nmt_file.nmt09,
               tma20 LIKE type_file.chr50  
               END RECORD
DEFINE l_nmt12  LIKE nmt_file.nmt12                #No.FUN-870067
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
  
   IF g_aza.aza73='N' THEN
      CALL cl_err('','anm-980',1)
      EXIT PROGRAM
   END IF
    
#No.FUN-870067--begin
   LET g_argv2=ARG_VAL(2)
   SELECT nmt12 INTO l_nmt12 FROM nmt_file WHERE nmt01 = g_argv2
   IF cl_null(g_aza.aza74) OR g_aza.aza74 != l_nmt12 THEN
      CALL cl_err('','anm-104',1)
      EXIT PROGRAM
   END IF
#No.FUN-870067--end
    
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   CREATE TEMP TABLE tma_temp(
           tma01  LIKE nma_file.nma01,
           tma02  LIKE nma_file.nma04,
           tma03  LIKE nma_file.nma02,
           tma04  LIKE nma_file.nma39,
           tma05  LIKE nmt_file.nmt02,
           tma06  LIKE nma_file.nma10,
           tma07  LIKE type_file.chr10,
           tma08  LIKE nma_file.nma18,
           tma09  LIKE nma_file.nma18,
           tma10  LIKE nma_file.nma18,
           tma11  LIKE nma_file.nma18,
           tma12  LIKE nma_file.nma18,
           tma13  LIKE type_file.dat,
           tma14  LIKE type_file.dat,
           tma15  LIKE type_file.chr3,
           tma16  LIKE type_file.chr14,
           tma17  LIKE type_file.chr12,
           tma18  LIKE nmt_file.nmt12,
           tma19  LIKE nmt_file.nmt09,
           tma20  LIKE type_file.chr50)
   
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW q301_w AT p_row,p_col WITH FORM "anm/42f/anmq301"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   LET g_argv1=ARG_VAL(1)
   LET g_tma.tma01=g_argv1
    
   IF NOT cl_null(g_tma.tma01) THEN
      CALL q301_q()
   END IF
   
   LET g_action_choice = ""
   CALL q301_menu()
   
   CLOSE WINDOW q301_w 
   DROP TABLE tma_temp
  
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q301_cs()
   IF cl_null(g_argv1) THEN  
   INITIALIZE g_tma.* TO NULL    #No.FUN-750051
       CONSTRUCT  g_wc ON nma01,nma39 FROM tma01,tma04
        
            BEFORE CONSTRUCT 
               CALL cl_qbe_init()
            
            ON ACTION controlp
               CASE 
                   WHEN INFIELD(tma01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form="q_nma"
                        LET g_qryparam.state="c"
                        LET g_qryparam.default1=g_tma.tma01
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tma01
                        NEXT FIELD tma01
                   WHEN INFIELD(tma04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form="q_nmt"
                        LET g_qryparam.state="c"
                        LET g_qryparam.default1=g_tma.tma04
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tma04
                        NEXT FIELD tma04
                   OTHERWISE
                        EXIT CASE
               END CASE
 
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
 
       END CONSTRUCT 
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup') #FUN-980030
   ELSE
       LET g_wc ="nma01=","'",g_tma.tma01,"'"
   END IF
    
   LET g_sql="SELECT nma01,nma02,nma04,nma39,nmt02,nmt09,nma10,nmt12 ",
             "FROM nmt_file,nma_file ",
             "WHERE nma39=nmt01 AND ",g_wc CLIPPED
   PREPARE q301_prepare FROM g_sql
   DECLARE q301_cs SCROLL CURSOR WITH HOLD FOR q301_prepare
    
END FUNCTION
 
FUNCTION q301_menu()
 
   MENU ""
       BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
   
       ON ACTION query
          LET g_action_choice="query"
          IF cl_chk_act_auth() THEN
             CALL q301_q()
          END IF
          
       ON ACTION help
          IF cl_chk_act_auth() THEN
             CALL cl_show_help()
          END IF
       
       ON ACTION controlg
          IF cl_chk_act_auth() THEN
             CALL cl_cmdask()      
          END IF
       
       ON ACTION exit    
          IF cl_chk_act_auth() THEN
             EXIT MENU      
          END IF
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE
          LET g_action_choice = "exit"
          EXIT MENU
 
       ON ACTION next
           CALL q301_fetch('N')
 
       ON ACTION previous
           CALL q301_fetch('P')
 
       ON ACTION jump
           CALL q301_fetch('/')
 
       ON ACTION first
           CALL q301_fetch('F')
 
       ON ACTION last
           CALL q301_fetch('L')
   END MENU
    
END FUNCTION
 
FUNCTION q301_q_1(g_tma01)
    DEFINE g_tma01 LIKE nma_file.nma01
    LET g_tma.tma01=g_tma01
    CALL q301_q() 
END FUNCTION
 
FUNCTION q301_q()
    DEFINE tok  base.StringTokenizer
    DEFINE tok1 base.StringTokenizer
    DEFINE k    LIKE type_file.num5
    DEFINE j    LIKE type_file.num5
    DEFINE field_array  Dynamic array OF STRING
    DEFINE field_array1 Dynamic array OF STRING
    DEFINE l_result     STRING                
    DEFINE l_result1    STRING                
    DEFINE l_sql        STRING                
    DEFINE l_nmv03      LIKE nmv_file.nmv03
    DEFINE l_nmv04      LIKE nmv_file.nmv04
    DEFINE l_nmv07      LIKE nmv_file.nmv07
    DEFINE l_para       STRING
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CLEAR FORM
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cn2
    CALL q301_cs()
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLEAR FORM
       RETURN
    END IF
    INITIALIZE g_tma.* TO NULL
    DELETE  FROM tma_temp
    FOREACH q301_cs INTO g_tma.tma01,g_tma.tma03,g_tma.tma02,g_tma.tma04,g_tma.tma05,
                       g_tma.tma19,g_tma.tma06,g_tma.tma18
    IF g_tma.tma18 = g_aza.aza74 THEN
      SELECT nmv03,nmv04,nmv07 INTO l_nmv03,l_nmv04,l_nmv07
        FROM nmv_file 
       WHERE nmv01=g_aza.aza74 AND nmv06 =g_user AND nmv08="ALL"
       LET l_para= "LGNTYP=0 ;LGNNAM=",l_nmv03 CLIPPED," ;LGNPWD=",l_nmv04 CLIPPED," ;ICCPWD=",l_nmv07 CLIPPED
          LET g_sql="BBKNBR=",g_tma.tma19 CLIPPED," ;","ACCNBR=",g_tma.tma02 CLIPPED
          CALL cl_cmbinf(l_para,"GetAccInfoA",g_sql,"|") RETURNING g_str
          CALL cl_err(g_str,'anm1000',1)
     # LET g_str="0|BBKNBR=",g_tma.tma19,";","ACCNBR=",g_tma.tma02,";","ACCBLV=8;STSCOD=12;ONLBLV=34;HLDBLV=7;AVLBLV=00;OPNDAT=06/11/1;MUTDAT=07/1/1;\0"
       LET tok=base.StringTokenizer.create(g_str,"|")
       IF tok.countTokens()>0 THEN
          LET k=0
          WHILE tok.hasMoreTokens()
                LET k=k+1
                LET field_array[k]=tok.nextToken()
          END WHILE
       END IF
       IF field_array[1]!="0" THEN
          LET g_tma.tma20 = field_array[2]
       END IF    
       IF field_array[1] ="0" THEN
          LET tok=base.StringTokenizer.create(field_array[2],";")
          IF tok.countTokens()>0 THEN
             LET k=0
             WHILE tok.hasMoreTokens() 
                   LET k=k+1
                   LET field_array[k]=tok.nextToken()
                   LET tok1=base.StringTokenizer.create(field_array[k],"=")
                   LET j=0
                   WHILE tok1.countTokens() >0 
                         LET j=j+1
                         LET field_array1[j]=tok1.nextToken()
                   END WHILE 
                   CASE field_array1[1]
                        WHEN "ACCNBR"
                             LET g_tma.tma02 = field_array1[2]
                        WHEN "STSCOD"
                             LET g_tma.tma07 = field_array1[2]
                        WHEN "ACCBLV"
                             LET g_tma.tma08 = field_array1[2]
                        WHEN "ONLBLV"
                             LET g_tma.tma09 = field_array1[2]
                        WHEN "HLDBLV"
                             LET g_tma.tma10 = field_array1[2]
                        WHEN "AVLBLV"
                             LET g_tma.tma11 = field_array1[2]
                        WHEN "LMTOVR"
                             LET g_tma.tma12 = field_array1[2]
                        WHEN "OPNDAT"
                             LET g_tma.tma13 = field_array1[2]
                        WHEN "MUTDAT"
                             LET g_tma.tma14 = field_array1[2]
                        WHEN "INTTYP"
                             LET g_tma.tma15 = field_array1[2]
                        WHEN "C_INTRAT"
                             LET g_tma.tma16 = field_array1[2]
                        WHEN "DPSTXT"
                             LET g_tma.tma17 = field_array1[2]
                        WHEN "BBKNBR"
                             LET g_tma.tma19 = field_array1[2]
                        OTHERWISE
                             EXIT CASE
                   END CASE 
             END WHILE
          END IF 
       END IF
    END IF
       INSERT INTO tma_temp VALUES (g_tma.*)
       INITIALIZE g_tma.* TO NULL
    END FOREACH
    LET g_sql="SELECT COUNT(*) FROM tma_temp"
    PREPARE q301_precount FROM g_sql
    DECLARE q301_count CURSOR FOR q301_precount
    OPEN q301_count 
    FETCH q301_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cn2
    
    LET g_sql="SELECT tma02,tma18,tma19 FROM tma_temp"
    PREPARE q301_prep1 FROM g_sql
    DECLARE q301_cs1 SCROLL CURSOR WITH HOLD FOR q301_prep1
    OPEN q301_cs1 
    CALL q301_fetch('F') 
 
END FUNCTION
 
FUNCTION q301_fetch(p_flg)
    DEFINE p_flg    LIKE type_file.chr1
    
    CASE p_flg
         WHEN 'F' FETCH FIRST    q301_cs1 INTO g_tma.tma02,g_tma.tma18,g_tma.tma19
         WHEN 'N' FETCH NEXT     q301_cs1 INTO g_tma.tma02,g_tma.tma18,g_tma.tma19
         WHEN 'P' FETCH PREVIOUS q301_cs1 INTO g_tma.tma02,g_tma.tma18,g_tma.tma19
         WHEN 'L' FETCH LAST     q301_cs1 INTO g_tma.tma02,g_tma.tma18,g_tma.tma19
         WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
               PROMPT g_msg CLIPPED,': ' FOR g_jump
 
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
             
                  ON ACTION about
                     CALL cl_about()
             
                  ON ACTION help
                     CALL cl_show_help()
             
                  ON ACTION controlg
                     CALL cl_cmdask()
             
               END PROMPT
 
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q301_cs1 INTO g_tma.tma02,g_tma.tma18,g_tma.tma19
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tma.tma01,SQLCA.sqlcode,0)
       RETURN
    ELSE
       CASE p_flg  
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       DISPLAY g_curs_index TO FORMONLY.cn1
    END IF
    CALL q301_show()
 
END FUNCTION
 
FUNCTION q301_show()
 
    SELECT * INTO g_tma.* FROM tma_temp  
     WHERE tma02=g_tma.tma02 AND tma18=g_tma.tma18 AND tma19=g_tma.tma19
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    DISPLAY BY NAME g_tma.*
    DISPLAY g_tma.tma01 TO tma01
 
END FUNCTION
