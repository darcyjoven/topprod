# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aicq026.4gl
# Descriptions...: 批號追蹤查詢
# Date & Author..: No.FUN-7B0075 08/01/17 By Sunyanchun
# Modify.........: No.FUN-830084 08/03/24 By Sunyanchun   加相關文件action 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0070 09/11/10 By wujie 5.2SQL转标准语法
# Modify.........: No.TQC-A10134 10/01/19 By sherry Temp Table 定義的長度不夠
# Modify.........: No.FUN-C30245 12/03/28 By bart 1.單身加顯示DATECODE
#                                                 2.取消單頭QBE,單身需可QBE
# Modify.........: No.TQC-C60024 12/06/12 By Sarah 1.撈資料時應該撈出跟查詢料號有關的資料
#                                                  2.查詢條件只下某個DateCode,卻還抓出跟所下條件完全無關的資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm      RECORD
                wc           STRING,
                estyle       LIKE type_file.chr1
               END RECORD,
       g_lot   LIKE idc_file.idc04,
       g_idc   DYNAMIC ARRAY OF RECORD
                part         LIKE idc_file.idc01,
                idc01        LIKE idc_file.idc01,
	        ima02        LIKE ima_file.ima02,
	        ima021       LIKE ima_file.ima021,
	        idc09        LIKE idc_file.idc09,
	        ima06        LIKE ima_file.ima06,
	        ima08        LIKE ima_file.ima08,
	        idc19        LIKE idc_file.idc19,
                ima02_2      LIKE ima_file.ima02,
	        idc07        LIKE idc_file.idc07,
	        idc02        LIKE idc_file.idc02,
                idc03        LIKE idc_file.idc03,
                idc04        LIKE idc_file.idc04,
                idc11        LIKE idc_file.idc11,    #FUN-C30245
                idc10        LIKE idc_file.idc10,
                idc08        LIKE idc_file.idc08,
                idc12        LIKE idc_file.idc12,
                idc17        LIKE idc_file.idc17
               END RECORD,
       l_ac             LIKE type_file.num5,
       g_argv1          LIKE idc_file.idc01, #料件編號
       g_argv2          LIKE idc_file.idc09, #母體編號
       g_argv3          LIKE idc_file.idc04, #批號
       g_argv4          LIKE idc_file.idc11, #date code
       g_rec_b          LIKE type_file.num5  #單身筆數
DEFINE p_row,p_col      LIKE type_file.num5
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_sql            STRING 
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_row_count      LIKE type_file.num10
DEFINE g_curs_index     LIKE type_file.num10
DEFINE g_jump           LIKE type_file.num10
DEFINE g_no_ask         LIKE type_file.num5
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01 

MAIN
   OPTIONS                            
     INPUT NO WRAP
   DEFER INTERRUPT
     
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log

   #NO.FUN-7B0075---begin  
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF
   #NO.FUN-7B0075---end
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
   LET g_sql = "SELECT imgg01,imgg02,imgg03,ima02,ima08,imkk09 ",
               " FROM imgg_file LEFT OUTER JOIN ima_file ON(imgg01 = ima01) LEFT OUTER JOIN imkk_file ON(imgg01 = imkk01)", 
               " WHERE  ima01 = imkk01"
   PREPARE q_count_pre FROM g_sql

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW q026_w WITH FORM "aic/42f/aicq026"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)
 
    IF NOT q026_create_tmp() THEN EXIT PROGRAM END IF
 
    IF NOT cl_null(g_argv1)
       THEN CALL q026_q()
    END IF
    CALL q026_menu()
    CLOSE WINDOW q026_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION q026_cs()
   DEFINE   l_cnt LIKE type_file.num5
   DEFINE   l_i   LIKE type_file.num5
 
   CLEAR FORM
   CALL g_idc.clear()
   CALL cl_opmsg('q')       
   INITIALIZE tm.* TO NULL
        
   LET tm.estyle = '3'  #default展開方式為：3.全部
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = " idc01 = '",g_argv1,"' AND " ,
                  " idc09 = '",g_argv2,"' AND " ,
                  " idc04 = '",g_argv3,"' AND " ,
                  " idc11 = '",g_argv4,"' " 
   ELSE 
      INPUT tm.estyle WITHOUT DEFAULTS FROM estyle
          AFTER FIELD estyle
	     IF tm.estyle NOT MATCHES '[123]' THEN
	        NEXT FIELD estyle
             END IF    
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION qbe_select
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
          ON ACTION locale
             CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON ACTION controlg
             CALL cl_cmdask()
      END INPUT
      WHILE TRUE
         #CONSTRUCT tm.wc ON idc01,idc09,idc04,idc11   #FUN-C30245 mark
              #FROM a1,a2,a3,a4       #單頭條件          #FUN-C30245 mark
         CONSTRUCT tm.wc ON idc01,idc09,idc19,idc07,idc02,idc03,idc04,idc11,idc10,idc08,idc12,idc17  #FUN-C30245
                       FROM part,idc09,idc19,idc07,idc02,idc03,idc04,idc11,idc10,idc08,idc12,idc17  #FUN-C30245
           BEFORE CONSTRUCT
             CALL cl_qbe_init()
       
           ON ACTION CONTROLP
              CASE 
   	          #WHEN INFIELD(a1)    #料號  #FUN-C30245
              WHEN INFIELD(part)        #FUN-C30245
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_idc"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   #DISPLAY g_qryparam.multiret TO a1   #FUN-C30245
                   DISPLAY g_qryparam.multiret TO part #FUN-C30245
                   #NEXT FIELD a1     #FUN-C30245
                   NEXT FIELD part   #FUN-C30245
              #WHEN INFIELD(a2)    #母體  #FUN-C30245
              WHEN INFIELD(idc09)        #FUN-C30245
                   CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_idc08"   #FUN-C30245
                   LET g_qryparam.form = "q_imaicd"
                   #LET g_qryparam.arg1 = "0"    #FUN-C30245
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = " imaicd04='0' OR imaicd04='1'" #FUN-C30245
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   #DISPLAY g_qryparam.multiret TO a2   #FUN-C30245
                   DISPLAY g_qryparam.multiret TO idc09 #FUN-C30245
                   #NEXT FIELD a2     #FUN-C30245
                   NEXT FIELD idc09   #FUN-C30245
              #WHEN INFIELD(a3)    #批號  #FUN-C30245
              WHEN INFIELD(idc04)        #FUN-C30245
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_idc09"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   #DISPLAY g_qryparam.multiret TO a3   #FUN-C30245
                   DISPLAY g_qryparam.multiret TO idc04 #FUN-C30245
                   #NEXT FIELD a3       #FUN-C30245
                   NEXT FIELD idc04     #FUN-C30245
              #WHEN INFIELD(a4)    #date code   #FUN-C30245
              WHEN INFIELD(idc11)               #FUN-C30245
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_idc11"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   #DISPLAY g_qryparam.multiret TO a4   #FUN-C30245
                   DISPLAY g_qryparam.multiret TO idc11 #FUN-C30245
                   #NEXT FIELD a4     #FUN-C30245
                   NEXT FIELD idc11   #FUN-C30245
              #FUN-C30245---begin
              WHEN INFIELD(idc02)
                   CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO idc02
                   NEXT FIELD idc02 
                   
              WHEN INFIELD(idc19)
                   CALL q_sel_ima(TRUE, "q_imaicd","","","","","","","",'')
                   RETURNING  g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO idc19
                   NEXT FIELD idc19
              WHEN INFIELD(idc07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO idc07
                   NEXT FIELD idc07
              WHEN INFIELD(idc03)
                   CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                   RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO idc03
                   NEXT FIELD idc03
              WHEN INFIELD(idc10)
                   CALL q_slot(TRUE,TRUE,"","","")
                   RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO idc10
                   NEXT FIELD idc10
              #FUN-C30245--end
              END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
           ON ACTION qbe_select
              CALL cl_qbe_list() RETURNING lc_qbe_sn
              CALL cl_qbe_display_condition(lc_qbe_sn)
 
           ON ACTION locale
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()
 
           ON ACTION help
             CALL cl_show_help()
 
           ON ACTION controlg
             CALL cl_cmdask()
 
         END CONSTRUCT
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
         IF INT_FLAG THEN RETURN END IF
         IF tm.wc = " 1=1" THEN
            CALL cl_err('','9046',0)
            CONTINUE WHILE
         END IF
         EXIT WHILE
      END WHILE
 
      IF INT_FLAG THEN RETURN END IF
   END IF
   MESSAGE ' WAIT ' 
 
   
   LET g_sql = "SELECT DISTINCT idc04 FROM idc_file ",
               " WHERE idc04 IS NOT NULL AND idc10 IS NOT NULL ",
               "   AND idc04 != ' ' AND idc10 != ' ' ",   #TQC-C60024 add
               "   AND ",tm.wc,
               " ORDER BY idc04 "
   PREPARE q026_pre FROM g_sql
   DECLARE q026_cs SCROLL CURSOR WITH HOLD FOR q026_pre
 
   LET g_sql = "SELECT COUNT(DISTINCT idc04) FROM idc_file ",
               " WHERE idc04 IS NOT NULL AND idc10 IS NOT NULL ",
               "   AND idc04 != ' ' AND idc10 != ' ' ",   #TQC-C60024 add
               "   AND ",tm.wc,
               " ORDER BY idc04 "
   PREPARE q026_count_pre FROM g_sql
   DECLARE q026_count_cs SCROLL CURSOR WITH HOLD FOR q026_count_pre
   
END FUNCTION
 
FUNCTION q026_menu()
   WHILE TRUE
      CALL q026_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q026_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                    base.TypeInfo.create(g_idc),'','')
         WHEN "related_document"                                                
              IF cl_chk_act_auth() THEN                                         
                 IF g_idc[l_ac].idc01 IS NOT NULL THEN                               
                     LET g_doc.column1 = "idc01"                                
                     LET g_doc.value1 = g_idc[l_ac].idc01                            
                     CALL cl_doc()                                              
               END IF                                                           
             END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q026_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    LET g_rec_b = 0
    LET g_lot = NULL 
    DELETE FROM q026_tmp
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY ' ',' ' TO FORMONLY.cnt,FORMONLY.cn2
 
    CALL q026_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 RETURN
    END IF
 
    OPEN q026_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q026_count_cs
       FETCH q026_count_cs INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q026_fetch('F') 
    END IF
END FUNCTION
 
FUNCTION q026_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10 
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     q026_cs INTO g_lot
      WHEN 'P' FETCH PREVIOUS q026_cs INTO g_lot
      WHEN 'F' FETCH FIRST    q026_cs INTO g_lot
      WHEN 'L' FETCH LAST     q026_cs INTO g_lot
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump q026_cs INTO g_lot
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lot,SQLCA.sqlcode,0)
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump 
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL q026_show()
   END IF
END FUNCTION
 
FUNCTION q026_show()
   DISPLAY ' ' TO FORMONLY.a1
   DISPLAY ' ' TO FORMONLY.a2
   DISPLAY g_lot TO FORMONLY.a3
   DISPLAY ' ' TO FORMONLY.a4
   CALL q026_b_fill()
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION q026()
   DEFINE l_sql     STRING,
          l_rec     LIKE type_file.num5
   DEFINE l_data    RECORD
                    idc01 LIKE idc_file.idc01, 
                    idc02 LIKE idc_file.idc02,
                    idc03 LIKE idc_file.idc03,
                    idc04 LIKE idc_file.idc04,
                    lot       LIKE idc_file.idc04,
                    type      LIKE type_file.chr1,
                    seq       LIKE type_file.num5
                    END RECORD
 
   DELETE FROM q026_tmp
  
   CASE 
       WHEN tm.estyle = '1'
            LET l_sql = "INSERT INTO q026_tmp ",
                        "SELECT DISTINCT idc01 part,idc01,idc02, ",
                        "       idc03,idc04,idc04 lot,'1',0 ",
                        "  FROM idc_file ",
                        " WHERE idc04 IS NOT NULL ",
                        "   AND idc10 IS NOT NULL ",
                        "   AND idc04 != ' ' AND idc10 != ' ' ",   #TQC-C60024 add
                        "   AND idc04 = '",g_lot,"' AND ",tm.wc
       WHEN tm.estyle = '2'
            LET l_sql = "INSERT INTO q026_tmp ",
                        "SELECT DISTINCT idc01 part,idc01,idc02, ",
                        "       idc03,idc04,idc10 lot,'2',0 ",
                        "  FROM idc_file ",
                        " WHERE idc04 IS NOT NULL ",
                        "   AND idc10 IS NOT NULL ",
                        "   AND idc04 != ' ' AND idc10 != ' ' ",   #TQC-C60024 add
                        "   AND idc04 = '",g_lot,"' AND ",tm.wc
       WHEN tm.estyle = '3'
            LET l_sql = "INSERT INTO q026_tmp ",
                        "SELECT DISTINCT idc01 part,idc01,idc02, ",
                        "       idc03,idc04,idc04 lot,'1' type,0",
                        "  FROM idc_file ",
                        " WHERE idc04 IS NOT NULL ",
                        "   AND idc10 IS NOT NULL ",
                        "   AND idc04 != ' ' AND idc10 != ' ' ",   #TQC-C60024 add
                        "   AND idc04 = '",g_lot,"' AND ",tm.wc,
                        " UNION ",
                        "SELECT DISTINCT idc01 part,idc01,idc02,",
                        "       idc03,idc04,idc10 lot,'2' type,0",
                        "  FROM idc_file ",
                        " WHERE idc04 IS NOT NULL ",
                        "   AND idc10 IS NOT NULL ",
                        "   AND idc04 != ' ' AND idc10 != ' ' ",   #TQC-C60024 add
                        "   AND idc04 = '",g_lot,"' AND ",tm.wc
   END CASE
   PREPARE q026_ins_pre FROM l_sql
   EXECUTE q026_ins_pre
 
   LET l_sql = "SELECT part,idc02,idc03,idc04,lot,type,seq ",
               "  FROM q026_tmp"
   PREPARE q026_pre1 FROM l_sql
   DECLARE q026_cs1 CURSOR FOR q026_pre1
 
   LET l_rec = 1
   FOREACH q026_cs1 INTO l_data.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH q026_cs1',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      CALL q026_ex(l_data.idc01,l_data.*)
      LET l_rec = l_rec + 1
      IF l_rec > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION q026_ex(p_key,p_data)
   DEFINE #l_sql     LIKE type_file.chr1000
          l_sql      STRING     #NO.FUN-910082
   DEFINE p_key     LIKE idc_file.idc01
   DEFINE p_data    RECORD
                    idc01 LIKE idc_file.idc01,
                    idc02 LIKE idc_file.idc02, 
                    idc03 LIKE idc_file.idc03,
                    idc04 LIKE idc_file.idc04,
                    lot       LIKE idc_file.idc10,
                    type      LIKE type_file.chr1,
                    seq       LIKE type_file.num5
                    END RECORD
   DEFINE l_data    DYNAMIC ARRAY OF RECORD
                    idc01   LIKE idc_file.idc01,
                    idc02   LIKE idc_file.idc02,
                    idc03   LIKE idc_file.idc03,
                    idc04   LIKE idc_file.idc04,
                    lot         LIKE idc_file.idc10,
                    type        LIKE type_file.chr1,
                    seq       LIKE type_file.num5
                    END RECORD
   DEFINE l_rec     LIKE type_file.num5
   DEFINE   l_i   LIKE type_file.num5
 
   CASE p_data.type
        WHEN '1' 
             LET l_sql = "SELECT DISTINCT idc01,idc02,idc03, ",
                         "       idc04,idc04,'1' ",
                         " FROM  idc_file",
                         " WHERE idc10='",p_data.lot,"'",
                         "   AND idc04 IS NOT NULL ",
                         "   AND idc10 IS NOT NULL ",
                         "   AND idc04 != ' ' AND idc10 != ' ' ",   #TQC-C60024 add
                         "   AND(idc01||idc02||idc03||idc04) ",
                         "   NOT IN(SELECT idc01||idc02||idc03||idc04 ",
                         "            FROM q026_tmp ",
                         "           WHERE part = '",p_key,"' )"
        WHEN '2'
             LET l_sql = "SELECT DISTINCT idc01,idc02,idc03, ",
                         "       idc04,idc10,'2' ",
                         " FROM  idc_file",
                         " WHERE idc04='",p_data.lot,"'",
                         "   AND idc04 IS NOT NULL ",
                         "   AND idc10 IS NOT NULL ",
                         "   AND idc04 != ' ' AND idc10 != ' ' ",   #TQC-C60024 add
                         "   AND(idc01||idc02||idc03||idc04) ",
                         "   NOT IN(SELECT idc01||idc02||idc03||idc04 ",
                         "            FROM q026_tmp ",
                         "           WHERE part = '",p_key,"' )"
   END CASE
 
   PREPARE q026_pre2 FROM l_sql
   DECLARE q026_cs2 CURSOR FOR q026_pre2
   LET l_rec = 1
   FOREACH q026_cs2 INTO l_data[l_rec].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH q026_cs2',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF      
       CASE p_data.type
            WHEN '1'  LET l_data[l_rec].seq = p_data.seq + 1
            WHEN '2'  LET l_data[l_rec].seq = p_data.seq - 1
       END CASE
       INSERT INTO q026_tmp VALUES(p_key,
                                   l_data[l_rec].idc01,
                                   l_data[l_rec].idc02,
                                   l_data[l_rec].idc03,
                                   l_data[l_rec].idc04,
                                   l_data[l_rec].lot,
                                   l_data[l_rec].type,
                                   l_data[l_rec].seq)
       LET l_rec = l_rec + 1
       IF l_rec > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL l_data.deleteElement(l_rec)
   LET l_rec = l_rec - 1
 
   FOR l_i = 1 TO l_rec
       CALL q026_ex(p_key,l_data[l_i].*)
   END FOR
END FUNCTION
 
FUNCTION q026_b_fill()
   DEFINE l_sql     STRING
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_idc11   STRING                 #TQC-C60024 add
   DEFINE l_lenth   LIKE type_file.num10   #TQC-C60024 add
 
   CALL q026()
   IF tm.estyle = '2' THEN
      LET l_sql = "SELECT DISTINCT part,idc01,idc02, ",
                  "                idc03,idc04,seq ",
                  "  FROM q026_tmp ",
                  " ORDER BY part,seq DESC "
   ELSE
      LET l_sql = "SELECT DISTINCT part,idc01,idc02, ",
                  "                idc03,idc04,seq ",
                  "  FROM q026_tmp ",
                  " ORDER BY part ,seq "
   END IF
   PREPARE q026_bp1_pre FROM l_sql
   DECLARE q026_bp1 CURSOR FOR q026_bp1_pre
 
   CALL g_idc.clear()
   LET l_i = 1
   FOREACH q026_bp1 INTO g_idc[l_i].part,g_idc[l_i].idc01,
                         g_idc[l_i].idc02,g_idc[l_i].idc03,
                         g_idc[l_i].idc04
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF      
 
      SELECT SUM(idc08),SUM(idc12) 
        INTO g_idc[l_i].idc08,g_idc[l_i].idc12
        FROM idc_file
       WHERE idc01 = g_idc[l_i].idc01
         AND idc02 = g_idc[l_i].idc02
         AND idc03 = g_idc[l_i].idc03
         AND idc04 = g_idc[l_i].idc04
 
      DECLARE q026_bp2 CURSOR FOR
       SELECT a.ima02,a.ima021, idc09,a.ima06,a.ima08,idc19,b.ima02,
              idc07,idc11,idc10,idc17    #FUN-C30245 idc11
         FROM idc_file
     #      , OUTER ima_file a, OUTER ima_file b                 #TQC-C60024 mark
         LEFT OUTER JOIN ima_file a ON idc_file.idc01 = a.ima01  #TQC-C60024
         LEFT OUTER JOIN ima_file b ON idc_file.idc19 = b.ima01  #TQC-C60024
        WHERE idc01 = g_idc[l_i].idc01 
          AND idc02 = g_idc[l_i].idc02 
          AND idc03 = g_idc[l_i].idc03 
          AND idc04 = g_idc[l_i].idc04 
     #    AND idc_file.idc01 = a.ima01 AND idc_file.idc19 = b.ima01  #TQC-C60024 mark
      FOREACH q026_bp2 INTO g_idc[l_i].ima02,g_idc[l_i].ima021,
                            g_idc[l_i].idc09,g_idc[l_i].ima06,
                            g_idc[l_i].ima08,g_idc[l_i].idc19,
                            g_idc[l_i].ima02_2,g_idc[l_i].idc07,
                            g_idc[l_i].idc11,   #FUN-C30245
                            g_idc[l_i].idc10,
                            g_idc[l_i].idc17
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH q026_bp2',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF      
        #str TQC-C60024 add
        #將同一料倉儲批的多個Datecode值串在一起,中間用逗號(,)分隔
         DECLARE q026_bp3 CURSOR FOR
          SELECT idc11 FROM idc_file
           WHERE idc01 = g_idc[l_i].idc01
             AND idc02 = g_idc[l_i].idc02
             AND idc03 = g_idc[l_i].idc03
             AND idc04 = g_idc[l_i].idc04
             AND idc11 IS NOT NULL
         FOREACH q026_bp3 INTO g_idc[l_i].idc11
            IF NOT cl_null(g_idc[l_i].idc11) THEN
               LET l_idc11 = l_idc11 , ",",g_idc[l_i].idc11
            END IF
         END FOREACH
         #去除第一個,號
         LET l_lenth = l_idc11.getlength()
         IF l_lenth >= 2 THEN
            LET l_idc11=l_idc11.Substring(2,l_lenth)
         END IF
         LET g_idc[l_i].idc11 = l_idc11
        #end TQC-C60024 add
         EXIT FOREACH
      END FOREACH
      LET l_i = l_i + 1
      IF l_i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_idc.deleteElement(l_i)
   LET g_rec_b = l_i-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   IF g_rec_b != 0 THEN
      CALL fgl_set_arr_curr(1)
   END IF
END FUNCTION
 
FUNCTION q026_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_idc TO s_idc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL q026_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL q026_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL q026_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next 
         CALL q026_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL q026_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION related_document                                                
         LET g_action_choice="related_document"                                 
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q026_create_tmp()
   DROP TABLE q026_tmp
#No.FUN-9B0070 --begin
   #TQC-A10134---Begin
   #CREATE TEMP TABLE q026_tmp(
   # part   LIKE type_file.chr30,
   # idc01  LIKE type_file.chr30,
   # idc02  LIKE type_file.chr10,
   # idc03  LIKE type_file.chr10,
   # idc04  LIKE type_file.chr30,
   # lot    LIKE type_file.chr30,
   # type   LIKE type_file.chr1,
   # seq    LIKE type_file.num5  )
   CREATE TEMP TABLE q026_tmp(
    part   LIKE ima_file.ima01,
    idc01  LIKE idc_file.idc01,
    idc02  LIKE idc_file.idc02,
    idc03  LIKE idc_file.idc03,
    idc04  LIKE idc_file.idc04,
    lot    LIKE idc_file.idc04,
    type   LIKE type_file.chr1,
    seq    LIKE type_file.num5  )
    #TQC-A10134---End
#No.FUN-9B0070 --end

   IF SQLCA.sqlcode THEN 
      RETURN 0
   ELSE
      RETURN 1
   END IF
END FUNCTION
#FUN-830084---END
