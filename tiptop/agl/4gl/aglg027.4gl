# Prog. Version..: '5.30.06-13.04.01(00001)'     #
#
# Pattern name...: aglg027.4gl
# Descriptions...: 合併前總帳科餘檢核表
# Date & Author..: 13/02/26 By apo(FUN-CC0025)

DATABASE ds
#FUN-CC0025

GLOBALS "../../config/top.global"
DEFINE g_axf13      LIKE axf_file.axf13             #族群代號
DEFINE g_axf16      LIKE axf_file.axf16             #合併主體
DEFINE g_axf09      LIKE axf_file.axf09             #來源公司編號
DEFINE g_axf10      LIKE axf_file.axf10             #對沖公司編號
DEFINE tm           RECORD
                    wc      STRING
                   ,yy      LIKE type_file.chr4     #年度
                   ,bm      LIKE type_file.chr2     #期別(起始)
                   ,em      LIKE type_file.chr2     #期別(截止)
                   ,more    LIKE type_file.chr1
                    END RECORD
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table1     STRING

###GENGRE###START
TYPE sr1_t RECORD
    level1 LIKE type_file.num10,
    level2 LIKE type_file.num10,
    level3 LIKE type_file.num10,
    axf13 LIKE axf_file.axf13,
    axf16 LIKE axf_file.axf16,
    axf09 LIKE axf_file.axf09,
    axf10 LIKE axf_file.axf10,
    axf00 LIKE axf_file.axf00,
    axf12 LIKE axf_file.axf12,
    axf011 LIKE axf_file.axf01,
    axf012 LIKE axf_file.axf01,
    axf021 LIKE axf_file.axf02,
    axf022 LIKE axf_file.axf02,
    aag021 LIKE aag_file.aag02,
    aag022 LIKE aag_file.aag02,
    aag023 LIKE aag_file.aag02,
    aag024 LIKE aag_file.aag02,
    misc01 LIKE axf_file.axf01,
    misc02 LIKE axf_file.axf01,
    aeh151 LIKE aeh_file.aeh15,
    aeh152 LIKE aeh_file.aeh15,
    axz051 LIKE axz_file.axz05,
    axz052 LIKE axz_file.axz05,
    azi041 LIKE azi_file.azi04,
    azi042 LIKE azi_file.azi04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET g_rep_user = ARG_VAL(7)
   LET g_rep_clas = ARG_VAL(8)
   LET g_template = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)
   LET g_axf13    = ARG_VAL(11)
   LET g_axf16    = ARG_VAL(12)
   LET g_axf09    = ARG_VAL(13)
   LET g_axf10    = ARG_VAL(14)
   LET tm.yy      = ARG_VAL(15)
   LET tm.bm      = ARG_VAL(16)
   LET tm.em      = ARG_VAL(17)
  
   LET g_sql =  "level1.type_file.num10"
              ,",level2.type_file.num10"
              ,",level3.type_file.num10"
              ,",axf13.axf_file.axf13"
              ,",axf16.axf_file.axf16"
              ,",axf09.axf_file.axf09"
              ,",axf10.axf_file.axf10"
              ,",axf00.axf_file.axf00"
              ,",axf12.axf_file.axf12"
              ,",axf011.axf_file.axf01"
              ,",axf012.axf_file.axf01"
              ,",axf021.axf_file.axf02"
              ,",axf022.axf_file.axf02"
              ,",aag021.aag_file.aag02"
              ,",aag022.aag_file.aag02"
              ,",aag023.aag_file.aag02"
              ,",aag024.aag_file.aag02"
              ,",misc01.axf_file.axf01"
              ,",misc02.axf_file.axf01"
              ,",aeh151.aeh_file.aeh15"
              ,",aeh152.aeh_file.aeh15"
              ,",axz051.axz_file.axz05"
              ,",axz052.axz_file.axz05"
              ,",azi041.azi_file.azi04"
              ,",azi042.azi_file.azi04"
              
   LET l_table1 = cl_prt_temptable('aglg027',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r027_tm()
   ELSE
      CALL r027()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r027_tm()
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000,
       l_cnt          LIKE type_file.num5

   LET p_row = 2 LET p_col = 20
   OPEN WINDOW r027_w AT p_row,p_col WITH FORM "agl/42f/aglg027"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   INITIALIZE tm.* TO NULL

   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.more  = 'N'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON axf13,axf16,axf09,axf10

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(axf13) #族群代號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axa1"
                    LET g_qryparam.default1 = g_axf13
                    CALL cl_create_qry() RETURNING g_axf13
                    DISPLAY g_axf13 TO axf13
                    NEXT FIELD CURRENT

               WHEN INFIELD(axf16) #合併主體
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axz"
                    LET g_qryparam.default1 = g_axf16
                    CALL cl_create_qry() RETURNING g_axf16
                    DISPLAY g_axf16 TO axf16
                    NEXT FIELD CURRENT
                  
               WHEN INFIELD(axf09) #來源公司代碼
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axz"
                    LET g_qryparam.default1 = g_axf09
                    CALL cl_create_qry() RETURNING g_axf09
                    DISPLAY g_axf09 TO axf09
                    NEXT FIELD CURRENT

               WHEN INFIELD(axf10) #對沖公司代碼
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axz"
                    LET g_qryparam.default1 = g_axf10
                    CALL cl_create_qry() RETURNING g_axf10
                    DISPLAY g_axf10 TO axf10
                    NEXT FIELD CURRENT
                    
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

         ON ACTION qbe_save
            CALL cl_qbe_save()
            
      END CONSTRUCT
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r027_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      INPUT BY NAME tm.yy,tm.bm,tm.em,tm.more
            WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_init()

         AFTER FIELD yy
            IF cl_null(tm.yy) OR tm.yy = 0 THEN
               NEXT FIELD CURRENT
            END IF

         AFTER FIELD bm
            IF NOT cl_null(tm.bm) THEN
               IF tm.bm > 13 OR tm.bm < 0 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD CURRENT
               END IF
               IF NOT cl_null(tm.em) THEN
                  IF tm.bm > tm.em THEN
                     CALL cl_err('','agl-157',0)
                     NEXT FIELD CURRENT
                  END IF
               END IF
            END IF
            
         AFTER FIELD em
            IF NOT cl_null(tm.em) THEN
               IF tm.em > 13 OR tm.em < 0 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD CURRENT
               END IF
               IF NOT cl_null(tm.bm) THEN
                  IF tm.bm > tm.em THEN
                     CALL cl_err('','agl-157',0)
                     NEXT FIELD CURRENT
                  END IF
               END IF
            END IF

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            
      END INPUT
  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r027_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='aglg027'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg027','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED
                       ," '",g_pdate CLIPPED,"'"
                       ," '",g_towhom CLIPPED,"'"
                       ," '",g_lang CLIPPED,"'"
                       ," '",g_bgjob CLIPPED,"'"
                       ," '",g_prtway CLIPPED,"'"
                       ," '",g_copies CLIPPED,"'"
                       ," '",g_rep_user CLIPPED,"'"
                       ," '",g_rep_clas CLIPPED,"'"
                       ," '",g_template CLIPPED,"'"
                       ," '",g_rpt_name CLIPPED,"'"
                       ," '",g_axf13 CLIPPED,"'"
                       ," '",g_axf16 CLIPPED,"'"
                       ," '",g_axf09 CLIPPED,"'"
                       ," '",g_axf10 CLIPPED,"'"
                       ," '",tm.yy CLIPPED,"'"
                       ," '",tm.bm CLIPPED,"'"
                       ," '",tm.em CLIPPED,"'"
            CALL cl_cmdat('aglg027',g_time,l_cmd)
         END IF
         CLOSE WINDOW r027_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r027()
      ERROR ""
   END WHILE
   CLOSE WINDOW r027_w
END FUNCTION

FUNCTION r027()
DEFINE l_name       LIKE type_file.chr10
DEFINE rec          RECORD
                    axf13   LIKE axf_file.axf13    #族群代號
                   ,axf16   LIKE axf_file.axf16    #合併主體
                   ,axf09   LIKE axf_file.axf09    #來源公司編號
                   ,axf10   LIKE axf_file.axf10    #對沖公司編號
                   ,axf00   LIKE axf_file.axf00    #來源公司帳別
                   ,axf12   LIKE axf_file.axf12    #對沖公司帳別
                    END RECORD
DEFINE arr          DYNAMIC ARRAY OF RECORD
                    misc01  LIKE axf_file.axf01    #來源公司是否為MISC
                   ,axf011  LIKE axf_file.axf01    #來源公司第一階會科axf01
                   ,axf021  LIKE axf_file.axf02    #來源公司第二階會科axs03
                   ,misc02  LIKE axf_file.axf01    #對沖公司是否為MISC
                   ,axf012  LIKE axf_file.axf01    #對沖公司第一階會科axf02
                   ,axf022  LIKE axf_file.axf02    #對沖公司第二階會科axt03
                    END RECORD
DEFINE l_tok        base.StringTokenizer
DEFINE i            LIKE    type_file.num5
DEFINE l_level1     LIKE    type_file.num5         #公司層數
DEFINE l_level2     LIKE    type_file.num5         #科目層數
DEFINE l_axf01      LIKE    axf_file.axf01
DEFINE l_axf02      LIKE    axf_file.axf02
DEFINE l_axf15      LIKE    axf_file.axf15         #來源公司科餘來源
DEFINE l_axf17      LIKE    axf_file.axf17         #對沖公司科餘來源
DEFINE l_axs03      LIKE    axs_file.axs03
DEFINE l_axz051     LIKE    axz_file.axz05         #來源公司總帳帳別
DEFINE l_axz052     LIKE    axz_file.axz05         #對沖公司總帳帳別 
DEFINE l_azi041     LIKE    azi_file.azi04         #來源公司總帳幣別
DEFINE l_azi042     LIKE    azi_file.azi04         #對沖公司總帳幣別
DEFINE l_aeh151     LIKE    aeh_file.aeh15
DEFINE l_aeh152     LIKE    aeh_file.aeh15
DEFINE l_aag021     LIKE    aag_file.aag02
DEFINE l_aag022     LIKE    aag_file.aag02
DEFINE l_aag023     LIKE    aag_file.aag02
DEFINE l_aag024     LIKE    aag_file.aag02
DEFINE l_str        STRING
DEFINE l_axz031     LIKE    axz_file.axz03
DEFINE l_axz032     LIKE    axz_file.axz03

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED
              ," VALUES(?,?,?,?,? ,?,?,?,?,? "
              ,"       ,?,?,?,?,? ,?,?,?,?,? "
              ,"       ,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_del_data(l_table1)
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglg027'

   #取得科目
   LET g_sql= "SELECT axf01,axf02,axf15,axf17"
             ,"  FROM axf_file "
             ," WHERE axf13 = ? AND axf16 = ?"
             ,"   AND axf09 = ? AND axf10 = ?"
             ,"   AND axf00 = ? AND axf12 = ?"    
             ,"   AND axf14 = 'N'"         
             ," ORDER BY axf01,axf02"
   PREPARE r027_p1 FROM g_sql
   DECLARE r027_c1 CURSOR FOR r027_p1
   
   #取得來源公司MISC下的科目明細-axs_file
   LET g_sql= "SELECT axs03"
             ,"  FROM axs_file "
             ," WHERE axs00 = ? AND axs01 = ?"
             ,"   AND axs09 = ? AND axs10 = ?"
             ,"   AND axs12 = ? AND axs13 = ?"
             ," ORDER BY axs03"
   PREPARE r027_p2 FROM g_sql
   DECLARE r027_c2 CURSOR FOR r027_p2

   #取得對沖公司MISC下的科目明細-axt_file
   LET g_sql= "SELECT axt03"
             ,"  FROM axt_file "
             ," WHERE axt00 = ? AND axt01 = ?"
             ,"   AND axt09 = ? AND axt10 = ?"
             ,"   AND axt12 = ? AND axt13 = ?"
             ," ORDER BY axt03"
   PREPARE r027_p3 FROM g_sql
   DECLARE r027_c3 CURSOR FOR r027_p3
   #取得對應的總帳科目axe04
   LET g_sql= "SELECT UNIQUE axe04"
             ,"  FROM axe_file "
             ," WHERE axe00 = ? AND axe01 = ?"
             ,"   AND axe13 = ? AND axe06 = ?"
             ," ORDER BY axe04"
   PREPARE r027_p4 FROM g_sql
   DECLARE r027_c4 CURSOR FOR r027_p4

   #取得族群下符合的公司
   LET g_sql= "SELECT UNIQUE axf13,axf16,axf09,axf10,axf00,axf12"
             ,"  FROM axf_file "
             ," WHERE ", tm.wc CLIPPED
             ," ORDER BY axf13,axf16,axf09,axf00,axf10,axf12"
   PREPARE r027_pre FROM g_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('r027_pre:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r027_cs CURSOR FOR r027_pre

   LET l_level1 = 0
   #來源/對沖公司
   FOREACH r027_cs INTO rec.*
      LET l_level1 = l_level1 + 1
      LET l_level2 = 0
      #來源/對沖科目axf01<->axf02
      FOREACH r027_c1 USING rec.axf13,rec.axf16,rec.axf09,rec.axf10
                           ,rec.axf00,rec.axf12
                       INTO l_axf01,l_axf02,l_axf15,l_axf17

         LET l_level2 = l_level2 + 1
         #***GL帳別,幣別取位***#
         SELECT axz03,axz05,azi04
           INTO l_axz031,l_axz051,l_azi041
           FROM axz_file,azi_file
          WHERE axz01 = rec.axf09 AND axz06 = azi01
         SELECT axz03,axz05,azi04
           INTO l_axz032,l_axz052,l_azi042
           FROM axz_file,azi_file
          WHERE axz01 = rec.axf10 AND axz06 = azi01

         CALL arr.clear()
         #***來源/對沖公司科目建立對應關係--Start--***#
         #***來源公司***#
         LET i = 1
         IF l_axf01[1,4] = 'MISC' THEN
            #***MISC的科目需取得MISC下的明細科目***#
            FOREACH r027_c2 USING rec.axf00,l_axf01,rec.axf09,rec.axf10,rec.axf12,rec.axf13
                             INTO l_axs03
               #***取總帳會計科目***#
               CALL r027_getaag01(l_axz051,rec.axf09,rec.axf13,l_axs03)
                        RETURNING l_str
               IF NOT cl_null(l_str) THEN
                  LET l_tok = base.StringTokenizer.create(l_str,',')
                  WHILE l_tok.hasMoreTokens()
                     LET arr[i].axf011 = l_axs03
                     LET arr[i].axf012 = l_tok.nextToken()
                     LET arr[i].misc01 = l_axf01 
                     LET i = i+1
                  END WHILE
               ELSE
                  LET arr[i].axf011 = l_axs03
                  LET arr[i].misc01 = l_axf01 
               END IF
            END FOREACH
         ELSE
            CALL r027_getaag01(l_axz051,rec.axf09,rec.axf13,l_axf01)
                     RETURNING l_str
            IF NOT cl_null(l_str) THEN
               LET l_tok = base.StringTokenizer.create(l_str,',')
               WHILE l_tok.hasMoreTokens()
                  LET arr[i].axf011 = l_axf01
                  LET arr[i].axf012 = l_tok.nextToken()
                  LET i = i+1
               END WHILE
            ELSE
               LET arr[i].axf011 = l_axf01
            END IF
         END IF         
         
         #***對沖公司***#
         LET i = 1
         IF l_axf02[1,4] = 'MISC' THEN
            FOREACH r027_c3 USING rec.axf00,l_axf02,rec.axf09,rec.axf10,rec.axf12,rec.axf13
                             INTO l_axs03
               CALL r027_getaag01(l_axz052,rec.axf10,rec.axf13,l_axs03)
                        RETURNING l_str
               IF NOT cl_null(l_str) THEN
                  LET l_tok = base.StringTokenizer.create(l_str,',')
                  WHILE l_tok.hasMoreTokens()
                     LET arr[i].axf021 = l_axs03
                     LET arr[i].axf022 = l_tok.nextToken()
                     LET arr[i].misc02 = l_axf02
                     LET i = i+1
                  END WHILE
               ELSE
                  LET arr[i].axf021 = l_axs03
                  LET arr[i].misc02 = l_axf02
               END IF
            END FOREACH
         ELSE
            CALL r027_getaag01(l_axz052,rec.axf10,rec.axf13,l_axf02)
                     RETURNING l_str
            IF NOT cl_null(l_str) THEN
               LET l_tok = base.StringTokenizer.create(l_str,',')
               WHILE l_tok.hasMoreTokens()
                  LET arr[i].axf021 = l_axf02
                  LET arr[i].axf022 = l_tok.nextToken()
                  LET i = i+1
               END WHILE
            ELSE
               LET arr[i].axf021 = l_axf02
            END IF
         END IF
         #***來源/對沖公司科目建立對應關係---End---***#

         #***寫入tmp table***#
         FOR i = 1 TO arr.getLength()
            LET l_aag021 = ""
            LET l_aag022 = ""
            LET l_aag023 = ""
            LET l_aag024 = ""
 
            #***來源公司***#
            #取axf01的會科名稱
            SELECT aag02 INTO l_aag021
              FROM aag_file
             WHERE aag00 = rec.axf00 AND aag01 = arr[i].axf011
            IF NOT cl_null(arr[i].axf012) THEN
               #對應的總帳會科名稱及科餘
               IF l_axf15 = '1' THEN
                  CALL r027_getaeh15(l_axz031,l_axz051,arr[i].axf012,'')
                           RETURNING l_aeh151,l_aag022 
               ELSE
                  CALL r027_getaeh15(l_axz031,l_axz051,arr[i].axf012,rec.axf10)
                           RETURNING l_aeh151,l_aag022 
               END IF
            END IF

            #***對沖公司***#
            SELECT aag02 INTO l_aag023
              FROM aag_file
             WHERE aag00 = rec.axf12 AND aag01 = arr[i].axf021
            IF NOT cl_null(arr[i].axf022) THEN
               IF l_axf17 = '1' THEN
                  CALL r027_getaeh15(l_axz032,l_axz052,arr[i].axf022,'')
                           RETURNING l_aeh152,l_aag024 
               ELSE
                  CALL r027_getaeh15(l_axz032,l_axz052,arr[i].axf022,rec.axf09)
                           RETURNING l_aeh152,l_aag024 
               END IF
            END IF

            EXECUTE insert_prep USING
                    l_level1     ,l_level2     ,i            ,rec.axf13
                   ,rec.axf16    ,rec.axf09    ,rec.axf10    ,rec.axf00
                   ,rec.axf12    ,arr[i].axf011,arr[i].axf012,arr[i].axf021
                   ,arr[i].axf022,l_aag021     ,l_aag022     ,l_aag023
                   ,l_aag024     ,arr[i].misc01,arr[i].misc02,l_aeh151
                   ,l_aeh152     ,l_axz051     ,l_axz052     ,l_azi041
                   ,l_azi042
         END FOR
      END FOREACH
   END FOREACH

###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
###GENGRE###              ," ORDER BY level1,level2,level3"
              #p1       #p2       #p3
###GENGRE###   LET g_str = tm.wc,";",tm.yy,";",tm.bm,"-",tm.em
   LET l_name = 'aglg027'
###GENGRE###   CALL cl_prt_cs3('aglg027',l_name,g_sql,g_str)
    CALL aglg027_grdata()    ###GENGRE###

END FUNCTION
#總帳科目
FUNCTION r027_getaag01(p_axe00,p_axe01,p_axe13,p_axf01)
DEFINE p_axe00   LIKE axe_file.axe00    #帳別
DEFINE p_axe01   LIKE axe_file.axe01    #公司編號
DEFINE p_axe13   LIKE axe_file.axe13    #族群代號
DEFINE p_axf01   LIKE axf_file.axf01
DEFINE l_axe04   LIKE axe_file.axe04
DEFINE l_str     STRING

   FOREACH r027_c4 USING p_axe00,p_axe01,p_axe13,p_axf01
              INTO l_axe04
      IF cl_null(l_str) THEN 
         LET l_str = l_axe04
      ELSE
         LET l_str = l_str,",",l_axe04
      END IF
   END FOREACH

   RETURN l_str
END FUNCTION
#科目餘額
FUNCTION r027_getaeh15(p_axz03,p_axf00,p_axf01,p_axz01)
DEFINE p_axf00   LIKE axf_file.axf00    #帳別
DEFINE p_axf01   LIKE axf_file.axf01    #科目
DEFINE p_axz01   LIKE axz_file.axz01    #來源/對沖公司
DEFINE l_aag02   LIKE aag_file.aag02    #科目名稱
DEFINE l_aag06   LIKE aag_file.aag06    #餘額型態
DEFINE l_aeh15   LIKE aeh_file.aeh15
DEFINE p_axz03   LIKE axz_file.axz03
DEFINE l_axz08   LIKE axz_file.axz08
DEFINE l_dbs_gl  LIKE azp_file.azp03
DEFINE l_sql     STRING

   LET l_sql= " SELECT aag02,aag06 "
             ,"   FROM ",cl_get_target_table(p_axz03,'aag_file')
             ,"  WHERE aag00 = '",p_axf00,"'"
             ,"    AND aag01 = '",p_axf01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_axz03) RETURNING l_sql
   PREPARE r027_aag_p1 FROM l_sql
   DECLARE r027_aag_c1 CURSOR FOR r027_aag_p1
   OPEN r027_aag_c1
   FETCH r027_aag_c1 INTO l_aag02,l_aag06

   SELECT axz08 INTO l_axz08 
     FROM axz_file
    WHERE axz01 = p_axz01

   IF l_aag06 = '1' THEN
      IF cl_null(p_axz01) THEN
         LET l_sql= "SELECT SUM(aeh15-aeh16) "
                   ,"   FROM ",cl_get_target_table(p_axz03,'aeh_file')
                   ," WHERE aeh00 = '",p_axf00,"'"
                   ,"   AND aeh01 = '",p_axf01,"'"
                   ,"   AND aeh09 = '",tm.yy,"'"
                   ,"   AND aeh10 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
      ELSE
         LET l_sql= "SELECT SUM(aeh15-aeh16) "
                   ,"   FROM ",cl_get_target_table(p_axz03,'aeh_file')
                   ,"  WHERE aeh00 = '",p_axf00,"'"
                   ,"    AND aeh01 = '",p_axf01,"'"
                   ,"    AND aeh37 = '",l_axz08,"'"
                   ,"    AND aeh09 = '",tm.yy,"'"
                   ,"    AND aeh10 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
      END IF
   ELSE
      IF cl_null(p_axz01) THEN
         LET l_sql= "SELECT SUM(aeh16-aeh15) "
                   ,"   FROM ",cl_get_target_table(p_axz03,'aeh_file')
                   ," WHERE aeh00 = '",p_axf00,"'"
                   ,"   AND aeh01 = '",p_axf01,"'"
                   ,"   AND aeh09 = '",tm.yy,"'"
                   ,"   AND aeh10 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
      ELSE
         LET l_sql= "SELECT SUM(aeh16-aeh15) "
                   ,"   FROM ",cl_get_target_table(p_axz03,'aeh_file')
                   ," WHERE aeh00 = '",p_axf00,"'"
                   ,"   AND aeh01 = '",p_axf01,"'"
                   ,"   AND aeh37 = '",l_axz08,"'"
                   ,"   AND aeh09 = '",tm.yy,"'"
                   ,"   AND aeh10 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
      END IF
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_axz03) RETURNING l_sql
   PREPARE r027_aeh_p1 FROM l_sql
   DECLARE r027_aeh_c1 CURSOR FOR r027_aeh_p1
   OPEN r027_aeh_c1
   FETCH r027_aeh_c1 INTO l_aeh15
   FREE r027_aag_c1
   FREE r027_aeh_c1
   RETURN l_aeh15,l_aag02
END FUNCTION


###GENGRE###START
FUNCTION aglg027_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table1)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg027")
        IF handler IS NOT NULL THEN
            START REPORT aglg027_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " ORDER BY level1,level2,level3"            #FUN-CC025 add
            DECLARE aglg027_datacur1 CURSOR FROM l_sql
            FOREACH aglg027_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg027_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg027_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg027_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_aeh151_1_sum LIKE aeh_file.aeh15
    DEFINE l_aeh152_2_sum LIKE aeh_file.aeh15
    DEFINE l_chk_sum LIKE ze_file.ze03

    
    ORDER EXTERNAL BY sr1.level1,sr1.level2
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.level1
        BEFORE GROUP OF sr1.level2

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.level1
        AFTER GROUP OF sr1.level2
            LET l_aeh152_2_sum = GROUP SUM(sr1.aeh152)
            IF cl_null(l_aeh152_2_sum) THEN LET l_aeh152_2_sum = 0 END IF
            PRINTX l_aeh152_2_sum
            LET l_aeh151_1_sum = GROUP SUM(sr1.aeh151)
            IF cl_null(l_aeh151_1_sum) THEN LET l_aeh151_1_sum = 0 END IF
            PRINTX l_aeh151_1_sum
            LET l_chk_sum = ''
            IF l_aeh152_2_sum = l_aeh151_1_sum THEN
              #金額相符 
               SELECT ze03 INTO l_chk_sum FROM ze_file WHERE ze01 = 'agl1056' AND ze02 = g_lang
            ELSE
              #金額不符 
               SELECT ze03 INTO l_chk_sum FROM ze_file WHERE ze01 = 'agl1057' AND ze02 = g_lang
            END IF   
            PRINTX l_chk_sum
        ON LAST ROW

END REPORT
###GENGRE###END
