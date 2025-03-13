# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: anmr100.4gl
# Descriptions...: 銀行存款余額調節表列印
# Date & Author..: #No.FUN-B30166 11/04/13 By lutingting
# Modify.........: No.FUN-B60095 11/06/20 By lutingting 新增開帳作業anmi004,所以這裡要帶入開帳的資料
DATABASE ds

GLOBALS "../../config/top.global"
   DEFINE g_naf01  LIKE naf_file.naf01 
   DEFINE g_nme    DYNAMIC ARRAY OF RECORD 
              a1      LIKE nmu_file.nmu01,          #交易日期
              a2      LIKE nmu_file.nmu12,          #摘要 
              a3      LIKE nmu_file.nmu10,          #金額
              b1      LIKE nmu_file.nmu01,          #交易日期
              b2      LIKE nmu_file.nmu12,          #摘要
              b3      LIKE nmu_file.nmu10,          #金額 
              c1      LIKE nme_file.nme16,          #日期
              c2      LIKE nme_file.nme05,          #摘要 
              c3      LIKE nme_file.nme08,          #金額
              c4      LIKE type_file.chr1000,       #憑證號碼
              d1      LIKE nme_file.nme16,          #日期
              d2      LIKE nme_file.nme05,          #摘要 
              d3      LIKE nme_file.nme08,          #金額
              d4      LIKE type_file.chr1000        #憑證號碼
                        END RECORD         
   DEFINE l_table     STRING                  
   DEFINE g_sql       STRING                                                                 
   DEFINE g_str       STRING
   DEFINE g_num       LIKE type_file.num10                  
   DEFINE g_naf       RECORD LIKE naf_file.*

MAIN

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
                                                                                                              
   LET g_sql = " num.type_file.num10, ",            #排序字段
               " nmt02.nmt_file.nmt02,",            #开户行
               " nma04.nma_file.nma04,",            #账号
               " nmu11.nmu_file.nmu11,",            #月末银行日记账余额
               " nmp16.nmp_file.nmp16,",            #月末银行对账单余额
               " a1.nmu_file.nmu01,",               # 
               " a2.nmu_file.nmu12,",               # 
               " a3.nmu_file.nmu10,",               #银行已收单位未收  
               " b1.nmu_file.nmu01,",               # 
               " b2.nmu_file.nmu12,",               #
               " b3.nmu_file.nmu10,",               #银行已付单位未付
               " c1.nme_file.nme16,",               #   
               " c2.nme_file.nme05,",               #
               " c3.nme_file.nme08,",               #企業收银行未收
               " c4.type_file.chr1000,",            #凭证编号  
               " d1.nme_file.nme02,",               #   
               " d2.nme_file.nme05,",               #
               " d3.nme_file.nme08,",               #企業已付银行未付  
               " d4.type_file.chr1000 "             #凭证编号 
   LET l_table = cl_prt_temptable('anmr100',g_sql) CLIPPED                                                                  
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                                                                    
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"  
   PREPARE insert_prep FROM g_sql                                                                                           
   IF STATUS THEN                                                                                                           
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                     
   END IF                                                                                                                   
  

   LET g_naf01 = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  

   IF g_bgjob = 'Y' OR g_naf01 IS NOT NULL THEN
      CALL anmr100()
   ELSE
      CALL anmr100_tm(0,0)
   END IF 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION anmr100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,  
       l_cmd          LIKE type_file.chr1000      
DEFINE l_count        LIKE type_file.num5       

   LET p_row = 3 LET p_col = 11
  
   OPEN WINDOW anmr100_w AT p_row,p_col
        WITH FORM "anm/42f/anmr100" 
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'

   WHILE TRUE
      LET g_num = 0
      INPUT g_naf01 WITHOUT DEFAULTS FROM naf01
  
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
  
         
         AFTER FIELD naf01                                         
            IF NOT cl_null(g_naf01) THEN
               SELECT COUNT(*) INTO l_count FROM naf_file
                WHERE naf01 = g_naf01
               IF l_count <= 0 THEN  
                  CALL cl_err('','anm-542',0)
                  NEXT FIELD naf01
               END IF
            END IF
                  
         ON ACTION controlp
            CASE
               WHEN INFIELD(naf01) #对账单号
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_naf01"
                  LET g_qryparam.default1 = g_naf01
                  CALL cl_create_qry() RETURNING g_naf01
                  DISPLAY BY NAME g_naf01
                  NEXT FIELD naf01 
               OTHERWISE EXIT CASE
            END CASE
         ON ACTION locale
             CALL cl_show_fld_cont()                     #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT INPUT
          
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
  
         ON ACTION about     
            CALL cl_about()     
    
         ON ACTION help         
            CALL cl_show_help()  
   
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT
  
         ON ACTION qbe_save
            CALL cl_qbe_save()
         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()
      END INPUT

      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW anmr100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='anmr100'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('anmr100','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_naf01 CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'", 
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'"
            CALL cl_cmdat('anmr100',g_time,l_cmd)
         END IF
         CLOSE WINDOW anmr100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL anmr100()
      ERROR ""
   END WHILE
   CLOSE WINDOW anmr100_w
END FUNCTION

FUNCTION anmr100()
DEFINE   l_sql        LIKE type_file.chr1000             
DEFINE   l_zo12       LIKE zo_file.zo12,
         l_zx02       LIKE zx_file.zx02,  
         i            LIKE type_file.num5,
         j            LIKE type_file.num5
DEFINE   l_nme12      LIKE nme_file.nme12
DEFINE   l_n          LIKE type_file.num5
DEFINE   ls_sql       LIKE type_file.chr1000             
DEFINE   l_nmu11      LIKE nmu_file.nmu11      #月末銀行日記帳余額
DEFINE   l_nmp16      LIKE nmp_file.nmp16      #月末銀行對帳單余額
DEFINE   l_nmu02      LIKE nmu_file.nmu02
DEFINE   l_nmu01      LIKE nmu_file.nmu01
DEFINE   l_nppglno    LIKE npp_file.nppglno
DEFINE   l_nma02      LIKE nma_file.nma02
DEFINE   l_nma04      LIKE nma_file.nma04
DEFINE   l_year       LIKE type_file.chr4    #FUN-B60095
DEFINE   l_month      LIKE type_file.chr4    #FUN-B60095

   LET g_rlang= g_lang
   SELECT zo02,zo12 INTO g_company,l_zo12 FROM zo_file WHERE zo01 = g_rlang 
   SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=g_user  

   LET l_sql =
        " SELECT DISTINCT nppglno  ",
        "  FROM npp_file,npq_file,aag_file ",
        " WHERE npp00=npq00 AND npp01=npq01 AND  npp011=npq011 ",
        "   AND nppsys=npqsys AND npptype=npqtype ",
        "   AND npq03=aag01 AND aag19='1' ",
        "   AND (CASE WHEN npq23 IS NULL THEN npp01 ELSE npq23 END ) = ?"
  PREPARE anmr100_prenpp FROM l_sql
  DECLARE anmr100_cursnpp CURSOR FOR anmr100_prenpp

   LET g_sql =
   " SELECT MAX(npq04)  ",
   "  FROM npq_file,aag_file ",
   "   WHERE npq03=aag01 AND aag19='1' ",
   "   AND (CASE WHEN npq23 IS NULL THEN npq01 ELSE npq23 END ) = ?"
   PREPARE r100_npq04_pre FROM g_sql
   DECLARE r100_npq04  CURSOR FOR r100_npq04_pre
      

   CALL cl_del_data(l_table)  
 
   SELECT * INTO g_naf.* FROM naf_file WHERE naf01 = g_naf01

   SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = g_naf.naf02   #銀行名稱
   SELECT nma04 INTO l_nma04 FROM nma_file WHERE nma01 = g_naf.naf02   #銀行帳號

   SELECT MAX(nmu01),MAX(nmu02) INTO l_nmu01,l_nmu02 FROM nmu_file
    WHERE YEAR(nmu01) = g_naf.naf03 AND MONTH(nmu01)=g_naf.naf04
      AND nmu03 = g_naf.naf02

   SELECT nmu11 INTO l_nmu11   #月末銀行日記帳餘額
     FROM nmu_file
    WHERE YEAR(nmu01) = g_naf.naf03 AND MONTH(nmu01)=g_naf.naf04 
      AND nmu03 = g_naf.naf02 AND nmu01 = l_nmu01
      AND nmu02 = l_nmu02
   IF cl_null(l_nmu11) THEN LET l_nmu11 = 0 END IF 

   SELECT nmp16 INTO l_nmp16 FROM nmp_file #月末銀行對帳單餘額
    WHERE nmp01 = g_naf.naf02 AND nmp02 = g_naf.naf03
      AND nmp03 = g_naf.naf04
   IF cl_null(l_nmp16) THEN LET l_nmp16 = 0 END IF 

   CALL g_nme.clear()

   #銀行已收企業未收
   LET l_sql = " SELECT nmu01,nmu12,nmu10 FROM nmu_file ",
               "  WHERE nmu09 = '1' ",
               "    AND (nmu24 <>'Y' OR nmu24 IS NULL)",
               "   AND (YEAR(nmu01) = '",g_naf.naf03,"' AND MONTH(nmu01)<='",g_naf.naf04,"' OR YEAR(nmu01)<'",g_naf.naf03,"')",  #10509
               "    AND nmu03 = '",g_naf.naf02,"'",
               "  UNION",    #在本張對帳單之後對上帳的,也要列印
               " SELECT nmu01,nmu12,nmu10 FROM nmu_file,nah_file ",
               #"   LEFT OUTER JOIN nah_file ON nmu23 = nah03 ",  #AND nah01<>'",g_naf.naf01,"'",
               "  WHERE nmu03 = '",g_naf.naf02,"' ",  
               "   AND nmu23 = nah03 ",
               "   AND (YEAR(nmu01) = '",g_naf.naf03,"' AND MONTH(nmu01)<='",g_naf.naf04,"' OR YEAR(nmu01)<'",g_naf.naf03,"')",  #10509
               "   AND nmu24 ='Y' AND nmu09 = '1'"
   IF g_naf.naf04 = '12' THEN   #12期
      LET l_sql = l_sql CLIPPED," AND substr(nah02,1,4)>",g_naf.naf03
   ELSE
      LET l_sql = l_sql CLIPPED," AND substr(nah02,1,4)=",g_naf.naf03,
                                " AND substr(nah02,5,2)>",g_naf.naf04,
                                "  OR substr(nah02,1,4)>",g_naf.naf03
   END IF 
   PREPARE anmr100_prepare2 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM 
   END IF
   DECLARE anmr100_curs2 CURSOR FOR anmr100_prepare2 
   LET i=1  
   LET j=0
   FOREACH anmr100_curs2 INTO g_nme[i].a1,g_nme[i].a2,g_nme[i].a3  
      LET i=i+1                  
   END FOREACH    
#FUN-B60095--ADD--STR--
   LET l_sql = " SELECT substr(nai08,1,8),'',nai06,nai03,nai04 FROM nai_file ",
               "  WHERE nai05 = '1' ",
               "    AND (nai09 <>'Y' OR nai09 IS NULL)",
               "    AND (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
               "    AND nai02 = '",g_naf.naf02,"'",
               "    AND nai01 = '2'",
               "  UNION",    #在本張對帳單之後對上帳的,也要列印
               " SELECT substr(nai08,1,8),'',nai06,nai03,nai04 FROM nai_file,nah_file ",
               "  WHERE nai02 = '",g_naf.naf02,"' ",
               "   AND nai08 = nah03 ",
               "   AND (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
               "   AND nai09 ='Y' AND nai05 = '1'"
   IF g_naf.naf04 = '12' THEN   #12期
      LET l_sql = l_sql CLIPPED," AND substr(nah02,1,4)>",g_naf.naf03
   ELSE
      LET l_sql = l_sql CLIPPED," AND substr(nah02,1,4)=",g_naf.naf03,
                                " AND substr(nah02,5,2)>",g_naf.naf04,
                                "  OR substr(nah02,1,4)>",g_naf.naf03
   END IF
   PREPARE anmr100_nai_prepare2 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE anmr100_nai_curs2 CURSOR FOR anmr100_nai_prepare2
   FOREACH anmr100_nai_curs2 INTO g_nme[i].a1,g_nme[i].a2,g_nme[i].a3,l_year,l_month
      LET g_nme[i].a1=MDY(l_month,01,l_year)
      LET i=i+1
   END FOREACH
#FUN-B60095--ADD--END
   LET i=i-1
   IF i>=j THEN LET j=i END IF 
      
   #銀行已付企業未付
   LET l_sql = " SELECT nmu01,nmu12,nmu10 FROM nmu_file ",
               "  WHERE nmu09 = '-1' ",         
               "    AND (nmu24 <>'Y' OR nmu24 IS NULL)",
               "   AND (YEAR(nmu01) = '",g_naf.naf03,"' AND MONTH(nmu01)<='",g_naf.naf04,"' OR YEAR(nmu01)<'",g_naf.naf03,"')",  #10509
               "    AND nmu03 = '",g_naf.naf02,"'",
               "  UNION",
               " SELECT nmu01,nmu12,nmu10 FROM nmu_file,nah_file ",
               #"   LEFT OUTER JOIN nah_file ON nmu23 = nah03 ",   #AND nah01<>'",g_naf.naf01,"'",
               "  WHERE nmu03 = '",g_naf.naf02,"' ",
               "    AND nmu23 = nah03",
               "   AND (YEAR(nmu01) = '",g_naf.naf03,"' AND MONTH(nmu01)<='",g_naf.naf04,"' OR YEAR(nmu01)<'",g_naf.naf03,"')",  #10509
               "    AND nmu24 ='Y' AND nmu09 = '-1'"
   IF g_naf.naf04  = '12' THEN   #12期
      LET l_sql = l_sql CLIPPED," AND substr(nah02,1,4)>",g_naf.naf03
   ELSE
      LET l_sql = l_sql CLIPPED," AND substr(nah02,1,4)=",g_naf.naf03,
                                " AND substr(nah02,5,2)>",g_naf.naf04,
                                "  OR substr(nah02,1,4)>",g_naf.naf03
   END IF
   PREPARE anmr100_prepare3 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM 
   END IF
   DECLARE anmr100_curs3 CURSOR FOR anmr100_prepare3 
   LET i=1  
   FOREACH anmr100_curs3 INTO g_nme[i].b1,g_nme[i].b2,g_nme[i].b3  
      LET i=i+1         
   END FOREACH    
#FUN-B60095--add--str--
   LET l_sql = " SELECT substr(nai08,1,8),'',nai06,nai03,nai04 FROM nai_file ",
               "  WHERE nai05 = '2' ",
               "    AND (nai09 <>'Y' OR nai09 IS NULL)",
               "    AND (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
               "    AND nai02 = '",g_naf.naf02,"'",
               "    AND nai01 = '2'",
               "  UNION",
               " SELECT substr(nai08,1,8),'',nai06,nai03,nai04 FROM nai_file,nah_file ",
               "  WHERE nai02 = '",g_naf.naf02,"' ",
               "    AND nai08 = nah03",
               "   AND (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
               "    AND nai09 ='Y' AND nai05 = '2'"
   IF g_naf.naf04  = '12' THEN   #12期
      LET l_sql = l_sql CLIPPED," AND substr(nah02,1,4)>",g_naf.naf03
   ELSE
      LET l_sql = l_sql CLIPPED," AND substr(nah02,1,4)=",g_naf.naf03,
                                " AND substr(nah02,5,2)>",g_naf.naf04,
                                "  OR substr(nah02,1,4)>",g_naf.naf03
   END IF
   PREPARE anmr100_nai_prepare3 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE anmr100_nai_curs3 CURSOR FOR anmr100_nai_prepare3
   FOREACH anmr100_nai_curs3 INTO g_nme[i].b1,g_nme[i].b2,g_nme[i].b3,l_year,l_month
      LET g_nme[i].b1=MDY(l_month,01,l_year)
      LET i=i+1
   END FOREACH
#FUN-B60095--add--end
   LET i=i-1
   IF i>=j THEN LET j=i END IF
      
   #企業已收銀行未收
   LET l_sql = "SELECT nme16,nme05,nme08,nme12 ",
               "  FROM nme_file,nmc_file ",
               " WHERE nme03 = nmc01 AND nmc03 = '1'",
               "   AND (nme20<>'Y' OR nme20 IS NULL)",
               "   AND (YEAR(nme16) = '",g_naf.naf03,"' AND MONTH(nme16)<='",g_naf.naf04,"' OR YEAR(nme16)<'",g_naf.naf03,"')",  #110509
               "   AND nme01 = '",g_naf.naf02,"'",
               " UNION ",
               "SELECT nme16,nme05,nme08,nme12 ",
               "  FROM nme_file,nmc_file,nag_file ",
               " WHERE nme01 = '",g_naf.naf02,"' ",   #銀行編號
               "   AND nme03 = nmc01 AND nmc03 = '1'",
               "   AND nme20 ='Y' ",
               "   AND (YEAR(nme16) = '",g_naf.naf03,"' AND MONTH(nme16)<='",g_naf.naf04,"' OR YEAR(nme16)<'",g_naf.naf03,"')",  #110509
               "   AND nme12=nag05 AND nme21=nag06 ",
               #"   AND nag01<>'",g_naf.naf01,"'",
               "   AND nme27=nag03 "
   IF g_naf.naf04 = '12' THEN
      LET l_sql = l_sql CLIPPED," AND substr(nag02,1,4)>",g_naf.naf03
   ELSE
      LET l_sql = l_sql CLIPPED," AND substr(nag02,1,4)=",g_naf.naf03,
                                " AND substr(nag02,5,2)>",g_naf.naf04,
                                "  OR substr(nag02,1,4)>",g_naf.naf03
   END IF 
   PREPARE anmr100_prepare4 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM 
   END IF
   DECLARE anmr100_curs4 CURSOR FOR anmr100_prepare4 
   LET i=1  
   FOREACH anmr100_curs4 INTO g_nme[i].c1,g_nme[i].c2,g_nme[i].c3,l_nme12
     IF cl_null(g_nme[i].c2)  THEN
        EXECUTE r100_npq04 USING l_nme12 INTO g_nme[i].c2
     END IF
     LET l_n = 1
     FOREACH anmr100_cursnpp USING l_nme12 INTO l_nppglno
        IF l_n = 1 THEN  
           LET g_nme[i].c4 = l_nppglno
        ELSE   
           LET g_nme[i].c4 = g_nme[i].c4 + '/'+ l_nppglno
        END IF
        LET l_n = l_n+1
     END FOREACH                 
      LET i=i+1         
   END FOREACH    
#FUN-B60095--add--str--
   LET l_sql = "SELECT substr(nai08,1,8),nai07,nai06,'',nai03,nai04 ",
               "  FROM nai_file ",
               " WHERE nai05 = '1'",
               "   AND (nai09<>'Y' OR nai09 IS NULL)",
               "   AND (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
               "   AND nai02 = '",g_naf.naf02,"'",
               "   AND nai01 = '1'",
               " UNION ",
               "SELECT substr(nai08,1,8),nai07,nai06,'',nai03,nai04 ",
               "  FROM nai_file,nag_file ",
               " WHERE nai02 = '",g_naf.naf02,"' ",   #銀行編號
               "   AND nai05 = '1'",
               "   AND (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
               "   AND nai09 ='Y' ",
               "   AND nai08=nag03 "
   IF g_naf.naf04 = '12' THEN
      LET l_sql = l_sql CLIPPED," AND substr(nag02,1,4)>",g_naf.naf03
   ELSE
      LET l_sql = l_sql CLIPPED," AND substr(nag02,1,4)=",g_naf.naf03,
                                " AND substr(nag02,5,2)>",g_naf.naf04,
                                "  OR substr(nag02,1,4)>",g_naf.naf03
   END IF
   PREPARE anmr100_nai_prepare4 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE anmr100_nai_curs4 CURSOR FOR anmr100_nai_prepare4
   FOREACH anmr100_nai_curs4 INTO g_nme[i].c1,g_nme[i].c2,g_nme[i].c3,l_nme12,l_year,l_month
      LET g_nme[i].c1=MDY(l_month,01,l_year)
      LET i=i+1
   END FOREACH
#FUN-B60095--add--end
   LET i=i-1 
   IF i>=j THEN LET j=i END IF
   
   #企業已付銀行未付
   LET l_sql = "SELECT nme16,nme05,nme08,nme12 ",
               "  FROM nme_file,nmc_file ",
               " WHERE nme03 = nmc01 AND nmc03 = '2'",
               "   AND (nme20<>'Y' OR nme20 IS NULL)",
               "   AND (YEAR(nme16) = '",g_naf.naf03,"' AND MONTH(nme16)<='",g_naf.naf04,"' OR YEAR(nme16)<'",g_naf.naf03,"')",  #110509
               "   AND nme01 = '",g_naf.naf02,"'",
               " UNION ",
               "SELECT nme16,nme05,nme08,nme12 ",
               "  FROM nme_file,nmc_file,nag_file ",
               " WHERE nme01 = '",g_naf.naf02,"' ",   #銀行編號
               "   AND nme03 = nmc01 AND nmc03 = '2'",
               "   AND nme20 ='Y' ",
               "   AND (YEAR(nme16) = '",g_naf.naf03,"' AND MONTH(nme16)<='",g_naf.naf04,"' OR YEAR(nme16)<'",g_naf.naf03,"')",  #110509
               "   AND nme12=nag05 AND nme21=nag06 ",
               #"   AND nag01<>'",g_naf.naf01,"'",
               "   AND nme27=nag03 "
   IF g_naf.naf04 = '12' THEN
      LET l_sql = l_sql CLIPPED," AND substr(nag02,1,4)>",g_naf.naf03
   ELSE
      LET l_sql = l_sql CLIPPED," AND substr(nag02,1,4)=",g_naf.naf03,
                                " AND substr(nag02,5,2)>",g_naf.naf04,
                                "  OR substr(nag02,1,4)>",g_naf.naf03
   END IF
   PREPARE anmr100_prepare5 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM 
   END IF
   DECLARE anmr100_curs5 CURSOR FOR anmr100_prepare5 
   LET i=1  
   FOREACH anmr100_curs5 INTO g_nme[i].d1,g_nme[i].d2,g_nme[i].d3,l_nme12 
     IF cl_null(g_nme[i].d2)  THEN
        EXECUTE r100_npq04 USING l_nme12 INTO g_nme[i].d2
     END IF
     LET l_n = 1
     FOREACH anmr100_cursnpp USING l_nme12 INTO l_nppglno
        IF l_n = 1 THEN  
           LET g_nme[i].d4 = l_nppglno
        ELSE   
           LET g_nme[i].d4 = g_nme[i].d4 + '/'+ l_nppglno
        END IF
        LET l_n = l_n+1
     END FOREACH                 
      LET i=i+1         
   END FOREACH    
#FUN-B60095--add--str--
   LET l_sql = "SELECT substr(nai08,1,8),nai07,nai06,'',nai03,nai04 ",
               "  FROM nai_file",
               " WHERE nai05 = '2'",
               "   AND (nai09<>'Y' OR nai09 IS NULL)",
               "   AND (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
               "   AND nai02 = '",g_naf.naf02,"'",
               "   AND nai01 = '1'",
               " UNION ",
               "SELECT substr(nai08,1,8),nai07,nai06,'',nai03,nai04",
               "  FROM nai_file,nag_file ",
               " WHERE nai02 = '",g_naf.naf02,"' ",   #銀行編號
               "   AND nai05 = '2'",
               "   AND nai09 ='Y' ",
               "   AND (nai03 = '",g_naf.naf03,"' AND nai04<='",g_naf.naf04,"' OR nai03<'",g_naf.naf03,"')",
               "   AND nai09=nag03 "
   IF g_naf.naf04 = '12' THEN
      LET l_sql = l_sql CLIPPED," AND substr(nag02,1,4)>",g_naf.naf03
   ELSE
      LET l_sql = l_sql CLIPPED," AND substr(nag02,1,4)=",g_naf.naf03,
                                " AND substr(nag02,5,2)>",g_naf.naf04,
                                "  OR substr(nag02,1,4)>",g_naf.naf03
   END IF
   PREPARE anmr100_nai_prepare5 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE anmr100_nai_curs5 CURSOR FOR anmr100_nai_prepare5
   FOREACH anmr100_nai_curs5 INTO g_nme[i].d1,g_nme[i].d2,g_nme[i].d3,l_nme12,l_year,l_month
      LET g_nme[i].d1=MDY(l_month,01,l_year)
      LET i=i+1
   END FOREACH
#FUN-B60095--add--end
   LET i=i-1 
   IF i>=j THEN LET j=i END IF 
      		
   FOR i=1 TO j 
      LET g_num = g_num + 1
      EXECUTE insert_prep USING g_num,l_nma02,l_nma04,l_nmu11,l_nmp16,
                                g_nme[i].a1,g_nme[i].a2,g_nme[i].a3,
                                g_nme[i].b1,g_nme[i].b2,g_nme[i].b3,
                                g_nme[i].c1,g_nme[i].c2,g_nme[i].c3,
                                g_nme[i].c4,
                                g_nme[i].d1,g_nme[i].d2,g_nme[i].d3,
                                g_nme[i].d4 
   END FOR                            

 # IF g_zz05 = 'Y' THEN                                                        
 #    CALL cl_wcchp(tm.wc)         
 #         RETURNING tm.wc                                                     
 # END IF
 #  LET g_str = tm.wc,";",l_zo12,";",l_zx02,";",l_tc_npa02 ,";",l_tc_npa03
   LET g_str = g_naf01,";",l_zo12,";",l_zx02,";",g_naf.naf03 ,";",g_naf.naf04
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              

   CALL cl_prt_cs3('anmr100','anmr100',l_sql,g_str)

END FUNCTION
#FUN-B30166
