# Prog. Version..: '5.30.06-13.03.28(00005)'     #
#
# Pattern name...: aicq028.4gl
# Descriptions...: 批號追蹤查詢作業
# Date & Author..: NO.FUN-7B0075  08/1/22 By Sunyanchun
# Modify.........: No.FUN-830084  08/03/24 By Sunyanchun   加相關文件action
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-940083 09/05/18 By Cockroach 原可收量(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/22 By vealxu ima26x 調整
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B30192 11/05/05 By shenyang  修改字段icb05
# Modify.........: No.MOD-CB0254 12/12/17 By Elise table串上oebi_file
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_argv1      LIKE type_file.chr1000
DEFINE g_argv2      LIKE type_file.chr1
DEFINE g_wc,g_wc2   STRING
DEFINE g_sql	    STRING
DEFINE g_str	    LIKE type_file.chr1000
DEFINE g_ima01      STRING
DEFINE g_rec_b,g_i  LIKE type_file.num5
DEFINE g_ima  	RECORD
	  ima01	 LIKE ima_file.ima01,
  	  ima02  LIKE ima_file.ima02,
  	  ima021 LIKE ima_file.ima021,
  	  ima25  LIKE ima_file.ima25,
#	  ima262 LIKE ima_file.ima262,             #FUN-A20044
#	  ima26  LIKE ima_file.ima26,              #FUN-A20044
          avl_stk LIKE type_file.num15_3,          #FUN-A20044
          avl_stk_mpsmrp LIKE type_file.num15_3,   #FUN-A20044 
          ima906 LIKE ima_file.ima906,
          ima907 LIKE ima_file.ima907,
          imaicd01 LIKE imaicd_file.imaicd01
                END RECORD
DEFINE g_sr   DYNAMIC ARRAY OF RECORD
          ds_date  DATE,	
          ds_class LIKE type_file.chr20,
          ds_no	   LIKE type_file.chr18,
          ds_cust  LIKE pmm_file.pmm09,
	  ds_qlty  LIKE rpc_file.rpc13,
	  ds_spare LIKE oebi_file.oebi03,
	  ds_total LIKE rpc_file.rpc13,
       #  ds_die   LIKE icb_file.icb05,   #FUN-B30192
          ds_die   LIKE imaicd_file.imaicd14,   #FUN-B30192
	  ds_gross LIKE type_file.num5
       	     END RECORD,
       g_sr_s RECORD
          ds_date  DATE,	
          ds_class LIKE type_file.chr20, 
          ds_no	   LIKE type_file.chr18, 
	  ds_cust  LIKE pmm_file.pmm09,
	  ds_qlty  LIKE rpc_file.rpc13,
	  ds_spare LIKE oebi_file.oebi03,
	  ds_total LIKE rpc_file.rpc13,
	# ds_die   LIKE icb_file.icb05,     #FUN-B30192
          ds_die   LIKE imaicd_file.imaicd14,   #FUN-B30192
	  ds_gross LIKE type_file.num5
       	      END RECORD
DEFINE g_order          LIKE type_file.num5
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_row_count      LIKE type_file.num10
DEFINE g_curs_index     LIKE type_file.num10
DEFINE g_jump           LIKE type_file.num10
DEFINE g_no_ask        LIKE type_file.num5
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   IF cl_null(g_argv1) THEN
      LET g_argv2 = 'n'
   ELSE
      LET g_argv2 = 'y'
   END IF
   CALL q028(g_argv1,g_argv2)
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q028(p_argv1,p_argv2)
   DEFINE p_argv1 STRING
   DEFINE p_argv2 LIKE type_file.chr1
   DEFINE l_time  LIKE type_file.chr8
 
   OPEN WINDOW q028_w WITH FORM "aic/42f/aicq028"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
   IF g_sma.sma122='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
   IF g_sma.sma122='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      LET g_str="'"
      FOR g_i = 1 TO LENGTH(g_argv1) 
         IF g_argv1[g_i,g_i]=',' THEN
            LET g_str=g_str CLIPPED,"'"
            LET g_str=g_str CLIPPED,g_argv1[g_i,g_i]
            LET g_str=g_str CLIPPED,"'"
         ELSE
            LET g_str=g_str CLIPPED,g_argv1[g_i,g_i]
         END IF
      END FOR
      LET g_str=g_str CLIPPED,"'"
      CALL q028_q() 
   END IF
   CALL q028_menu()
   CLOSE WINDOW q028_w
 
END FUNCTION
 
FUNCTION q028_cs()
   DEFINE   l_cnt LIKE type_file.num5
 
   IF NOT cl_null(g_argv1) THEN
     LET g_wc = "ima01 IN","(",g_str,")"
   ELSE
      CLEAR FORM
      CALL g_sr.clear()
      CALL cl_opmsg('q')
      CONSTRUCT BY NAME g_wc ON ima01,imaicd01,ima02,ima25,ima021,imaicd04
 
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
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima09"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
               WHEN INFIELD(imaicd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaicd01
                  NEXT FIELD imaicd01
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
   END IF
   IF g_argv2 = 'n' THEN
      LET g_sql=" SELECT UNIQUE imaicd01 ",
                " FROM imaicd_file ",
                " WHERE imaicd01 IN ",
                "    (SELECT ima01 FROM imaicd_file,ima_file ",
                "      WHERE imaicd01 IS NOT NULL AND ima01=imaicd00",
                "        AND ",g_wc CLIPPED,")"
      LET g_sql=" SELECT imaicd00 ",
                " FROM ima_file ,imaicd_file ",
                " WHERE ima01=imaicd00 AND ",g_wc CLIPPED
   ELSE
      LET g_sql=" SELECT imaicd00 ",
                " FROM ima_file ,imaicd_file ",
                " WHERE ima01=imaicd00 AND ",g_wc CLIPPED
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN
   #      LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY imaicd00"
   PREPARE q028_prepare FROM g_sql
   DECLARE q028_cs SCROLL CURSOR FOR q028_prepare
 
   IF g_argv2 = 'n' THEN
      LET g_sql=" SELECT count(distinct imaicd01) FROM imaicd_file ",
                " WHERE imaicd01 IN ",
                "    (SELECT ima01 FROM ima_file,imaicd_file ",
                "      WHERE imaicd01 IS NOT NULL AND ima01=imaicd00",
                "        AND ",g_wc CLIPPED,")"
      LET g_sql=" SELECT count(*) ",
                " FROM ima_file ,imaicd_file ", 
                " WHERE ima01=imaicd00 AND ",g_wc CLIPPED
   ELSE
      LET g_sql=" SELECT count(*) ",
                " FROM ima_file ,imaicd_file ", 
                " WHERE ima01=imaicd00 AND ",g_wc CLIPPED
   END IF
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN
   #      LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q028_pp  FROM g_sql
   DECLARE q028_cnt CURSOR FOR q028_pp
END FUNCTION
 
FUNCTION q028_menu()
 
   WHILE TRUE
      CALL q028_bp("G")
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "query"
            CALL q028_q()
         WHEN "every_information"
            CALL q028_eve_info()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
 
         WHEN "related_document"                                                
              IF cl_chk_act_auth() THEN                                         
                 IF g_ima.ima01 IS NOT NULL THEN                               
                     LET g_doc.column1 = "ima01"                                
                     LET g_doc.value1 = g_ima.ima01                            
                     CALL cl_doc()                                              
               END IF                                                           
             END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q028_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q028_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   MESSAGE "Waiting!"
   OPEN q028_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('q028_q:',SQLCA.sqlcode,0)
   ELSE
      OPEN q028_cnt
      FETCH q028_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q028_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION q028_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1
         ,l_avl_stk_mpsmrp  LIKE type_file.num15_3    #FUN-A20044
         ,l_unavl_stk       LIKE type_file.num15_3    #FUN-A20044
         ,l_avl_stk         LIKE type_file.num15_3    #FUN-A20044

   CASE p_flag
      WHEN 'N' FETCH NEXT     q028_cs INTO g_ima.ima01
      WHEN 'P' FETCH PREVIOUS q028_cs INTO g_ima.ima01
      WHEN 'F' FETCH FIRST    q028_cs INTO g_ima.ima01
      WHEN 'L' FETCH LAST     q028_cs INTO g_ima.ima01
      WHEN '/'
         IF (NOT g_no_ask) THEN
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
         FETCH ABSOLUTE g_jump q028_cs INTO g_ima.ima01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('Fetch:',SQLCA.sqlcode,0)
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
 
#   SELECT ima01,ima02,ima021,ima25,ima262,ima26,ima906,ima907,  #FUN-A20044
   SELECT ima01,ima02,ima021,ima25,ima906,ima907,                #FUN-A20044
          imaicd01 INTO g_ima.*
     FROM ima_file,imaicd_file 
  WHERE ima01=imaicd00 AND ima01 = g_ima.ima01

#FUN-A20044 ---start---
   CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
   LET g_ima.avl_stk_mpsmrp = l_avl_stk_mpsmrp
   LET g_ima.avl_stk = l_avl_stk
#FUN-A20044 ---end---
 
   CALL q028_show()
END FUNCTION
 
FUNCTION q028_show()
 
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25,
#                   g_ima.ima262,g_ima.ima906,g_ima.ima907,g_ima.imaicd01   #FUN-A20044 
                   g_ima.avl_stk,g_ima.ima906,g_ima.ima907,g_ima.imaicd01   #FUN-A20044
                   
   MESSAGE ' WAIT '
   CALL g_sr.clear()
   DISPLAY ARRAY g_sr TO s_sr.* 
      BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY
   CALL q028_b_fill()
   MESSAGE ''
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION q028_b_fill()              #BODY FILL UP
   DEFINE l_sfb02	LIKE type_file.num5,
          l_temp        LIKE type_file.num20_6,
          l_imaicd04    LIKE imaicd_file.imaicd04,
	  I,J		LIKE type_file.num10,
          m_oeb12       LIKE oeb_file.oeb12,
          m_ogb12       LIKE ogb_file.ogb12,
          l_pmm09       LIKE pmm_file.pmm09,
          l_pmc03       LIKE pmc_file.pmc03,
          l_sfb82       LIKE sfb_file.sfb82,
          l_ima55_fac   LIKE ima_file.ima55_fac,
  qty_1,qty_2,qty_3,qty_4,qty_5,qty_51,qty_6y,qty_6n,qty_7 LIKE type_file.num20_6 
   DEFINE l_msg         STRING  
 
   DECLARE q028_bcs0 CURSOR FOR
   #  SELECT SUM(img10*icb05)      #FUN-B30192 
   #     FROM img_file,imd_file,imaicd_file,icb_file,ima_file      #FUN-B30192
      SELECT SUM(img10*imaicd14)   #FUN-B30192
         FROM img_file,imd_file,imaicd_file,ima_file      #FUN-B30192 
       WHERE img01=g_ima.ima01 
         AND img02=imd01 
         AND imd11='Y'
         AND imaicd04 IN ('1','2') 
     #   AND ima01 = icb01                     #FUN-B30192
         AND ima01 = imaicd00
         AND ima01=img01
       UNION  
      SELECT SUM(img10) FROM img_file,imd_file,imaicd_file,ima_file 
       WHERE img01=g_ima.ima01 
         AND img02=imd01 
         AND imd11='Y'
         AND ima01 = imaicd00
         AND imaicd04 NOT IN('1','2')
         AND ima01=img01
 
   DECLARE q028_bcs6y CURSOR FOR
    # SELECT SUM(img10*icb05)                               #FUN-B30192
    #   FROM img_file,imaicd_file,icb_file ,ima_file        #FUN-B30192
      SELECT SUM(img10*imaicd14)                            #FUN-B30192
        FROM img_file,imaicd_file,ima_file                  #FUN-B30192
       WHERE img01=g_ima.ima01 
         AND img02 NOT IN (SELECT jce02 FROM jce_file WHERE jceacti='Y')
         AND imaicd04 IN ('1','2')
         AND ima01 = imaicd00
    #    AND ima01 = icb01                                   #FUN-B30192
         AND ima01=img01
       UNION
      SELECT SUM(img10) FROM img_file,imaicd_file,ima_file
       WHERE img01=g_ima.ima01
         AND img02 NOT IN (SELECT jce02 FROM jce_file WHERE jceacti='Y')
         AND ima01 = imaicd00
         AND imaicd04 NOT IN ('1','2')
         AND ima01=img01
 
   DECLARE q028_bcs6n CURSOR FOR
    # SELECT SUM(img10*icb05) 
    #   FROM img_file,imaicd_file,icb_file,ima_file
      SELECT SUM(img10*imaicd14)                            #FUN-B30192
        FROM img_file,imaicd_file,ima_file                  #FUN-B30192 
       WHERE img01=g_ima.ima01 
         AND img02 IN (SELECT jce02 FROM jce_file WHERE jceacti='Y')
         AND ima01 = imaicd00
         AND imaicd04 IN ('1','2')
    #    AND ima01 = icb01
         AND ima01=img01
       UNION
      SELECT SUM(img10) FROM img_file,imaicd_file,ima_file
       WHERE img01=g_ima.ima01
         AND img02 IN (SELECT jce02 FROM jce_file WHERE jceacti='Y')
         AND ima01 = imaicd00
         AND imaicd04 NOT IN ('1','2')
         AND ima01=img01
 
   DECLARE q028_bcs1 CURSOR FOR
      SELECT oeb15,'',oeb01,occ02,(oeb12-oeb24+oeb25-oeb26)*oeb05_fac,oebiicd03,0,'',''  
        FROM oeb_file, oea_file,occ_file,oebi_file    #MOD-CB0254 add oebi_file
       WHERE oeb04 = g_ima.ima01
         AND oeb01 = oea01
         AND occ01 = oea03
         AND oebi01= oea01    #MOD-CB0254 add
         AND oea00<>'0'
         AND oeb70 = 'N' 
         AND oeb12-oeb24+oeb25-oeb26 >0  
         AND oeaconf !='X'
       ORDER BY oeb15
 
   SELECT ima55_fac INTO l_ima55_fac
     FROM ima_file
    WHERE ima01 = g_ima.ima01
   IF cl_null(l_ima55_fac) THEN
       LET l_ima55_fac = 1
   END IF
 
   DECLARE q028_bcs2 CURSOR FOR
      SELECT sfb15,'',sfb01,gem02,
             (sfb08-sfb09-sfb10-sfb11-sfb12)*l_ima55_fac,
             '',0,'','',sfb02,sfb82
        #FROM sfb_file,OUTER gem_file              #mark by liuxqa 091020
        FROM sfb_file LEFT OUTER JOIN gem_file ON sfb_file.sfb82=gem_file.gem01  #mod by liuxqa 091020
       WHERE sfb05 = g_ima.ima01
         AND sfb04 !='8' 
         #AND sfb_file.sfb82 = gem_file.gem01   #mark by liuxqa 091020
         AND sfb08 > (sfb09+sfb10+sfb11+sfb12)
         AND sfb87!='X'
       ORDER BY sfb15
 
   DECLARE q028_bcs3 CURSOR FOR
      SELECT pml35,'',pml01,pmc03,(pml20-pml21)*pml09,'',0,'','' 
        #FROM pml_file, pmk_file,OUTER pmc_file   #mark by liuxqa 091020
        FROM pml_file, pmk_file LEFT OUTER JOIN pmc_file ON pmk_file.pmk09=pmc_file.pmc01   #mod by liuxqa 091020
       WHERE pml04 = g_ima.ima01
         AND pml01 = pmk01 
         #AND pmk_file.pmk09 = pmc_file.pmc01  #mark by liuxqa 091020
         AND pml20 > pml21 
         AND pml16<='2'  
         AND pml011 !='SUB'
         AND pmk18 != 'X'
       ORDER BY pml35  
 
   DECLARE q028_bcs4 CURSOR FOR
     #SELECT pmn33,'',pmm01,pmc03,(pmn20-pmn50+pmn55)*pmn09,'',0,'',''    #FUN-940083 MARK
      SELECT pmn33,'',pmm01,pmc03,(pmn20-pmn50+pmn55+pmn58)*pmn09,'',0,'','' #FUN-940083 ADD
        #FROM pmn_file, pmm_file,OUTER pmc_file
        FROM pmn_file, pmm_file LEFT OUTER JOIN pmc_file ON pmm_file.pmm09=pmc_file.pmc01  #mod by liuxqa 091020
       WHERE pmn04 = g_ima.ima01
         AND pmn01 = pmm01 
         #AND pmm_file.pmm09 = pmc_file.pmc01   #mark by liuxqa 091012
       # AND pmn20 -(pmn50-pmn55)>0       #FUN-940083 MARK
         AND pmn20 -(pmn50-pmn55-pmn58)>0 #FUN-940083 ADD
         AND pmn16 <= '2' 
         AND pmn011 !='SUB'
         AND pmm18 != 'X'
       ORDER BY pmn33
 
   DECLARE q028_bcs5 CURSOR FOR
      SELECT rva06,'',rvb01,pmc03,((rvb07-rvb29-rvb30)*pmn09),'',0,'',''
        #FROM rvb_file, rva_file,OUTER pmc_file,OUTER pmn_file,ima_file   #mark by liuxqa 091020
        FROM rvb_file, rva_file LEFT OUTER JOIN pmc_file ON (rva05 = pmc01) LEFT OUTER JOIN  pmn_file ON(rvb04 = pmn01 AND rvb03 = pmn02),ima_file  #mod by liuxqa 091020
       WHERE rvb05 = g_ima.ima01
         AND rvb01 = rva01
         #AND rva_file.rva05 = pmc_file.pmc01  #mark by liuxqa 091020
         #AND rva_file.rvb04 = pmn_file.pmn01  #mark by liuxqa 091020
         #AND rvb_file.rvb03 = pmn_file.pmn02  #mark by liuxqa 091020
         AND rvb07 > (rvb29+rvb30)
         AND rvaconf='Y' 
         AND rva10 !='SUB'
         AND ima01 = rvb05
       ORDER BY rva06
 
   DECLARE q028_bcs51 CURSOR FOR
      SELECT sfb15,'',sfb01,gem02,sfb11,'',0,'','' 
        #FROM sfb_file,OUTER gem_file   #mark by liuxqa 091020
        FROM sfb_file LEFT OUTER JOIN gem_file ON sfb_file.sfb82 = gem_file.gem01   #mod by liuxqa 091020
       WHERE sfb05 = g_ima.ima01
         #AND sfb_file.sfb82 = gem_file.gem01   #mark by liuxqa 091020
         AND sfb02 <> '7'
         AND sfb87!='X'
         AND sfb04 <'8'
         AND sfb11 > 0
 
   DECLARE q028_bcs7 CURSOR FOR
    # SELECT SUM(oeb905*oeb05_fac*icb05)#INTO m_oeb12 
    #   FROM oeb_file,oea_file,imaicd_file,icb_file,ima_file     #FUN-B30192
      SELECT SUM(oeb905*oeb05_fac*imaicd14)                      #FUN-B30192
        FROM oeb_file,oea_file,imaicd_file,ima_file              #FUN-B30192
       WHERE oeb04 = g_ima.ima01
         AND oeb01 = oea01
         AND oea00 <>'0'
         AND oeb19 = 'Y'
         AND oeb70 = 'N'
         AND oeb12 > oeb24
         AND oeaconf != 'X'
         AND ima01 = imaicd00
         AND imaicd04 IN ('1','2')
   #     AND ima01 = icb01
         AND ima01 = oeb04
       UNION
      SELECT SUM(oeb905*oeb05_fac)
        FROM oeb_file,oea_file,imaicd_file,ima_file
       WHERE oeb04 = g_ima.ima01
         AND oeb01 = oea01
         AND oea00 <>'0'
         AND oeb19 = 'Y'
         AND oeb70 = 'N'
         AND oeb12 > oeb24
         AND oeaconf != 'X'
         AND ima01 = imaicd00
         AND imaicd04 NOT IN ('1','2')
         AND ima01 = oeb04
 
   CALL g_sr.clear()
   LET g_cnt = 1
   LET qty_1=0 
   LET qty_2=0
   LET qty_3=0 
   LET qty_4=0
   LET qty_5=0
   LET qty_51=0
   LET qty_6y=0
   LET qty_6n=0
   LET qty_7=0
 
   LET l_temp = 0
#   LET g_ima.ima262 = 0          #FUN-A20044
   LET g_ima.avl_stk = 0          #FUN-A20044
   FOREACH q028_bcs0 INTO l_temp
      IF STATUS THEN CALL cl_err('F0:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(l_temp) THEN LET l_temp = 0 END IF
#      LET g_ima.ima262 = g_ima.ima262 + l_temp        #FUN-A20044
      LET g_ima.avl_stk = g_ima.avl_stk + l_temp       #FUN-A20044 
   END FOREACH
#   DISPLAY BY NAME g_ima.ima262 ATTRIBUTE(REVERSE)     #FUN-A20044
    DISPLAY BY NAME g_ima.avl_stk ATTRIBUTE(REVERSE)    #FUN-A20044
 
   FOREACH q028_bcs1 INTO g_sr[g_cnt].*
      IF STATUS THEN CALL cl_err('F1:',STATUS,1) EXIT FOREACH END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-821',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      LET l_imaicd04 = NULL
      SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
       WHERE imaicd00 = g_ima.ima01
   #FUN-B30192--begin
   #  SELECT icb05 INTO g_sr[g_cnt].ds_die FROM icb_file
   #   WHERE icb01= g_ima.ima01
      CALL s_icdfun_imaicd14(g_ima.ima01)   RETURNING g_sr[g_cnt].ds_die
   #FUN-B30192--end
      IF cl_null(g_sr[g_cnt].ds_die) THEN
         LET g_sr[g_cnt].ds_die = 0
      END IF
      IF l_imaicd04 MATCHES '[12]' THEN
         LET qty_2 = qty_2 + g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
         LET g_sr[g_cnt].ds_gross = g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
      ELSE
         LET qty_2 = qty_2 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_die = g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_gross = NULL
      END IF
      LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN 
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_2 ATTRIBUTE(REVERSE)
 
   FOREACH q028_bcs2 INTO g_sr[g_cnt].*,l_sfb02,l_sfb82
      IF STATUS THEN CALL cl_err('F2:',STATUS,1) EXIT FOREACH END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-822',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      LET l_imaicd04 = NULL
      SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
       WHERE imaicd00 = g_ima.ima01
    #FUN-B30192--begin
    # SELECT icb05 INTO g_sr[g_cnt].ds_die FROM icb_file
    #  WHERE icb01= g_ima.ima01
      CALL s_icdfun_imaicd14(g_ima.ima01)   RETURNING g_sr[g_cnt].ds_die
    #FUN-B30192--end
      IF cl_null(g_sr[g_cnt].ds_die) THEN
         LET g_sr[g_cnt].ds_die = 0
      END IF
      IF l_imaicd04 MATCHES '[12]' THEN
         LET qty_1 = qty_1 + g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
         LET g_sr[g_cnt].ds_gross = g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
      ELSE
         LET qty_1 = qty_1 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_die = g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_gross = NULL
      END IF
      IF cl_null(g_sr[g_cnt].ds_cust) THEN
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 =l_sfb82
         IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
         IF l_sfb02 = '7' AND cl_null(l_pmc03) THEN
            SELECT pmm09,pmc03 INTO l_pmm09,l_pmc03
              FROM pmm_file,pmc_file
             WHERE pmm01 = g_sr[g_cnt].ds_no
               AND pmm09 = pmc01
            IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
         END IF
         LET g_sr[g_cnt].ds_cust = l_pmc03
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_1 ATTRIBUTE(REVERSE)
 
   FOREACH q028_bcs3 INTO g_sr[g_cnt].*
      IF STATUS THEN CALL cl_err('F3:',STATUS,1) EXIT FOREACH END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-823',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      LET l_imaicd04 = NULL
      SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
       WHERE imaicd00 = g_ima.ima01
   #FUN-B30192--begin
   #   SELECT icb05 INTO g_sr[g_cnt].ds_die FROM icb_file
   #    WHERE icb01= g_ima.ima01
      CALL s_icdfun_imaicd14(g_ima.ima01)   RETURNING g_sr[g_cnt].ds_die
   #FUN-B30192--end
      IF cl_null(g_sr[g_cnt].ds_die) THEN
         LET g_sr[g_cnt].ds_die = 0
      END IF
      IF l_imaicd04 MATCHES '[12]' THEN
         LET qty_3 = qty_3 + g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
         LET g_sr[g_cnt].ds_gross = g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
      ELSE
         LET qty_3 = qty_3 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_die = g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_gross = NULL
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_3 ATTRIBUTE(REVERSE)
 
   FOREACH q028_bcs4 INTO g_sr[g_cnt].*
      IF STATUS THEN CALL cl_err('F4:',STATUS,1) EXIT FOREACH END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-824',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      LET l_imaicd04 = NULL
      SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
       WHERE imaicd00 = g_ima.ima01
   #FUN-B30192--begin
   #   SELECT icb05 INTO g_sr[g_cnt].ds_die FROM icb_file
   #    WHERE icb01= g_ima.ima01
   
      CALL s_icdfun_imaicd14(g_ima.ima01)   RETURNING g_sr[g_cnt].ds_die
   #FUN-B30192--end
      IF cl_null(g_sr[g_cnt].ds_die) THEN
         LET g_sr[g_cnt].ds_die = 0
      END IF
      IF l_imaicd04 MATCHES '[12]' THEN
         LET qty_4 = qty_4 + g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
         LET g_sr[g_cnt].ds_gross = g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
      ELSE
         LET qty_4 = qty_4 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_die = g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_gross = NULL
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_4 ATTRIBUTE(REVERSE)
 
   FOREACH q028_bcs5 INTO g_sr[g_cnt].*
      IF STATUS THEN CALL cl_err('F5:',STATUS,1) EXIT FOREACH END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-825',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      LET l_imaicd04 = NULL
      SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
       WHERE imaicd00 = g_ima.ima01 
    #FUN-B30192--begin
    #  SELECT icb05 INTO g_sr[g_cnt].ds_die FROM icb_file
    #   WHERE icb01= g_ima.ima01
      CALL s_icdfun_imaicd14(g_ima.ima01)   RETURNING g_sr[g_cnt].ds_die
    #FUN-B30192--end
      IF cl_null(g_sr[g_cnt].ds_die) THEN
         LET g_sr[g_cnt].ds_die = 0
      END IF
      IF l_imaicd04 MATCHES '[12]' THEN
         LET qty_5 = qty_5 + g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
         LET g_sr[g_cnt].ds_gross = g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
      ELSE
         LET qty_5 = qty_5 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_die = g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_gross = NULL
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_5 ATTRIBUTE(REVERSE)
 
   FOREACH q028_bcs51 INTO g_sr[g_cnt].*
      IF STATUS THEN CALL cl_err('F51:',STATUS,1) EXIT FOREACH END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-826',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      LET l_imaicd04 = NULL
      SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
       WHERE imaicd00 = g_ima.ima01
    #FUN-B30192--begin
    # SELECT icb05 INTO g_sr[g_cnt].ds_die FROM icb_file
    #  WHERE icb01= g_ima.ima01
      CALL s_icdfun_imaicd14(g_ima.ima01)   RETURNING g_sr[g_cnt].ds_die
    #FUN-B30192--end
      IF cl_null(g_sr[g_cnt].ds_die) THEN
         LET g_sr[g_cnt].ds_die = 0
      END IF
      IF l_imaicd04 MATCHES '[12]' THEN
         LET qty_51 = qty_51 + g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
         LET g_sr[g_cnt].ds_gross = g_sr[g_cnt].ds_qlty * g_sr[g_cnt].ds_die
      ELSE
         LET qty_51 = qty_51 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_die = g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_gross = NULL
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_51 ATTRIBUTE(REVERSE)
 
   LET l_temp = 0
   FOREACH q028_bcs6y INTO l_temp
      IF STATUS THEN CALL cl_err('F6y:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(l_temp) THEN LET l_temp = 0 END IF
      LET qty_6y = qty_6y + l_temp
   END FOREACH
   DISPLAY BY NAME qty_6y ATTRIBUTE(REVERSE)
 
   LET l_temp = 0
   FOREACH q028_bcs6n INTO l_temp
      IF STATUS THEN CALL cl_err('F6n:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(l_temp) THEN LET l_temp = 0 END IF
      LET qty_6n = qty_6n + l_temp
   END FOREACH
   DISPLAY BY NAME qty_6n ATTRIBUTE(REVERSE)
 
   LET l_temp = 0
   FOREACH q028_bcs7 INTO l_temp
      IF STATUS THEN CALL cl_err('F7:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(l_temp) THEN LET l_temp = 0 END IF
      LET qty_7 = qty_7 + l_temp
   END FOREACH
   DISPLAY BY NAME qty_7 ATTRIBUTE(REVERSE) 
 
   LET g_cnt = g_cnt - 1		# Get real number of record
   LET g_rec_b = g_cnt  
 
   FOR I= 1 TO g_cnt-1
      FOR J= g_cnt-1 TO I STEP -1
         #---------- COMPARE  & SWAP ------------
         IF (g_sr[J].ds_date > g_sr[J+1].ds_date) OR
            (g_sr[J+1].ds_date IS NULL) THEN
            LET g_sr_s.*= g_sr[J].*
	    LET g_sr[J].* = g_sr[J+1].*
	    LET g_sr[J+1].* = g_sr_s.*	
	 END IF	
      END FOR
   END FOR
 
   FOR I = 1 TO g_cnt
#      LET g_ima.ima26 = g_ima.ima26 + g_sr[I].ds_qlty     #FUN-A20044
#      LET g_sr[I].ds_total = g_ima.ima26                  #FUN-A20044
      LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + g_sr[I].ds_qlty    #FUN-A20044
      LET g_sr[I].ds_total = g_ima.avl_stk_mpsmrp                          #FUN-A20044
   END FOR
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION q028_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()               
 
      ON ACTION first
         CALL q028_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY       
 
 
      ON ACTION previous
         CALL q028_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY           
 
 
      ON ACTION jump
         CALL q028_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
 	 ACCEPT DISPLAY           
 
 
      ON ACTION next
         CALL q028_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY          
 
 
      ON ACTION last
         CALL q028_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY          
 
      ON ACTION every_information
         LET g_action_choice="every_information"
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
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION accept
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
 
      ON ACTION about        
         CALL cl_about()    
      
       ON ACTION related_document                                                
         LET g_action_choice="related_document"                                 
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q028_eve_info()
   DEFINE l_sql   STRING,
          sr RECORD
               bma01 LIKE bma_file.bma01
             END RECORD
   
   IF cl_null(g_ima.ima01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   LET l_sql = "SELECT bma01 ",
               " FROM bma_file, ima_file",
               " WHERE bma01 = ima01",
               "   AND bma01= '",g_ima.ima01,"'",
               "   AND bmaacti='Y'"  
    
   LET g_i = 1
   PREPARE q028_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE q028_curs1 CURSOR FOR q028_prepare1
 
   FOREACH q028_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      CALL q028_bom(sr.bma01)
   END FOREACH 
   LET g_msg = NULL
   LET g_msg = g_prog CLIPPED," '",g_ima01 CLIPPED,"'"
   CALL cl_cmdrun(g_msg)
 
END FUNCTION
 
FUNCTION q028_bom(p_key) 
   DEFINE p_key	    LIKE bma_file.bma01,
          p_key2    LIKE bma_file.bma06, 
          i,j       LIKE type_file.num5,
          l_time    LIKE type_file.num5,
          l_count   LIKE type_file.num5,
          l_count1  LIKE type_file.num5,
          l_sql     STRING,
          sr DYNAMIC ARRAY OF RECORD
               bmb03	LIKE bmb_file.bmb03             
             END RECORD,
          sr1 DYNAMIC ARRAY OF RECORD
                bmd04	LIKE bmd_file.bmd04             
              END RECORD
 
   INITIALIZE sr[600].* TO NULL
 
   LET l_sql="SELECT bmb03",
	     "  FROM bmb_file,ima_file",
             " WHERE bmb01 = '",p_key,"'", 
             "   AND ima01 = bmb03 ",  
             "   AND (bmb04 <= '",g_today,"' OR bmb04 IS NULL)",
             "   AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
             " ORDER BY bmb03"
 
   PREPARE bom_prepare FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('Prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE bom_cs CURSOR FOR bom_prepare
   LET l_count = 1
   FOREACH bom_cs INTO sr[l_count].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('bom_cs',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      IF g_i=1 THEN
         LET g_ima01 = sr[l_count].bmb03 
      ELSE
         LET g_ima01 = g_ima01 CLIPPED,",",sr[l_count].bmb03 
      END IF
 
      LET l_sql="SELECT bmd04",
                "  FROM bmb_file,bmd_file",
                " WHERE bmd01 = '",sr[l_count].bmb03,"'",
                "   AND bmd01 = bmb03 ",
                "   AND bmd02 = '2'",
                "   AND (bmd05 <= '",g_today,"' OR bmd05 IS NULL)",
                "   AND (bmd06 > '",g_today,"' OR bmd06 IS NULL)",
                "   AND bmdacti = 'Y'"                                           #CHI-910021 
             
      LET l_count1=1
      PREPARE bom_prepare1 FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('Prepare1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE bom_cs1 CURSOR FOR bom_prepare1
      FOREACH bom_cs1 INTO sr1[l_count1].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('bom_cs1',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET g_ima01 = g_ima01 CLIPPED,",",sr1[l_count1].bmd04
      END FOREACH
      LET g_i = g_i + 1
      LET l_count = l_count + 1
   END FOREACH			
   LET l_count = l_count - 1
   FOR i = 1 TO l_count
      SELECT bma01 FROM bma_file
       WHERE bma01 = sr[i].bmb03
         AND bmaacti='Y'  
      IF status != NOTFOUND THEN
         CALL q028_bom(sr[i].bmb03)
      END IF
   END FOR
END FUNCTION
#No.FUN-830084---end
