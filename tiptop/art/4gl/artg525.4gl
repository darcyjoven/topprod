# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: artg525.4gl
# Descriptions...: 產品消化率統計表
# Date & Author..: #FUN-BA0034 11/10/07 by pauline
# Modify ........: FUN-C10036  12/01/19 By xuxz CR轉GR特殊字符調整

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
	      wc      STRING,
	      wc2     STRING,
	      date    LIKE type_file.dat,
	      type    LIKE type_file.chr1,
              azw01   STRING,
	      more    LIKE type_file.chr1       # Input more condition(Y/N)
	      END RECORD

DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   g_sale_out      LIKE tlf_file.tlf10
DEFINE   g_date1         LIKE type_file.dat 
DEFINE   g_date2         LIKE type_file.dat 
DEFINE   g_date3         LIKE type_file.dat 
DEFINE   g_flag2         LIKE type_file.chr100
DEFINE   g_rate          LIKE type_file.num26_10 
DEFINE   g_plant2        STRING
###GENGRE###START
TYPE sr1_t RECORD
    tlf01 LIKE tlf_file.tlf01,
    ima02 LIKE ima_file.ima02,
    all_in LIKE tlf_file.tlf10,
    ima128 LIKE ima_file.ima128,
    in_cost LIKE ima_file.ima128,
    ima125 LIKE ima_file.ima125,
    ccc23 LIKE ccc_file.ccc23,
    act_in_cot LIKE ccc_file.ccc23,
    ima126 LIKE ima_file.ima126,
    fixed_rate LIKE ima_file.ima126,
    sale_out6 LIKE tlf_file.tlf10,
    sale_out5 LIKE tlf_file.tlf10,
    sale_out4 LIKE tlf_file.tlf10,
    sale_out3 LIKE tlf_file.tlf10,
    sale_out2 LIKE tlf_file.tlf10,
    sale_out1 LIKE tlf_file.tlf10,
    sale_out LIKE tlf_file.tlf10,
    area_out LIKE tlf_file.tlf10,
    other_out LIKE tlf_file.tlf10,
    area_out_rate LIKE ima_file.ima126,
    all_out LIKE tlf_file.tlf10,
    stock LIKE tlf_file.tlf10,
    all_rate LIKE ima_file.ima126,
    azi04 LIKE azi_file.azi04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT              


   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.date = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
     EXIT PROGRAM
   END IF
   LET g_sql = "tlf01.tlf_file.tlf01,",
               "ima02.ima_file.ima02,",
               "all_in.tlf_file.tlf10,",
               "ima128.ima_file.ima128,",
               "in_cost.ima_file.ima128,",
               "ima125.ima_file.ima125,",
               "ccc23.ccc_file.ccc23,",
               "act_in_cot.ccc_file.ccc23,",
               "ima126.ima_file.ima126,",
               "fixed_rate.ima_file.ima126,",
               "sale_out6.tlf_file.tlf10,",
               "sale_out5.tlf_file.tlf10,",
               "sale_out4.tlf_file.tlf10,",
               "sale_out3.tlf_file.tlf10,",
               "sale_out2.tlf_file.tlf10,",
               "sale_out1.tlf_file.tlf10,",
               "sale_out.tlf_file.tlf10,",
               "area_out.tlf_file.tlf10,",
               "other_out.tlf_file.tlf10,",
               "area_out_rate.ima_file.ima126,",
               "all_out.tlf_file.tlf10,",
               "stock.tlf_file.tlf10,",
               "all_rate.ima_file.ima126,",
               "azi04.azi_file.azi04"

   LET l_table = cl_prt_temptable('artg525',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,    ? ,? ,? ,? ,?, ",
                       "?, ?, ?, ?, ?,    ? ,? ,? ,? ,?, ",
                       "?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF cl_null(g_bgjob) OR g_bgjob = 'N'     
      THEN CALL artg525_tm(0,0)      
      ELSE CALL artg525()            
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artg525_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000,
       l_str          STRING
DEFINE l_year         STRING
DEFINE l_month        STRING
DEFINE l_tok          base.StringTokenizer
DEFINE l_sql          STRING
DEFINE l_auth         LIKE tlf_file.tlfplant
DEFINE l_cnt          LIKE type_file.num5
   IF p_row = 0 THEN 
      LET p_row = 6 LET p_col = 14 
   END IF

   OPEN WINDOW artg525_w AT p_row,p_col WITH FORM "art/42f/artg525"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
        
   CALL cl_ui_init()
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.type = '1'
   LET g_pdate = g_today #FUN-C10036 add
   WHILE TRUE

   CONSTRUCT tm.wc ON ima01,ima131 FROM ima01,ima131
      BEFORE CONSTRUCT
		     CALL cl_qbe_init()	
				
   ON ACTION controlp
      CASE

         WHEN INFIELD(ima01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
			  
         WHEN INFIELD(ima131)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form = "q_oba_11"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima131 
            NEXT FIELD ima131   
         END CASE

   ON ACTION locale
      CALL cl_show_fld_cont()
      CALL cl_dynamic_locale()
      CONTINUE WHILE

   ON ACTION help
      CALL cl_show_help()
      CONTINUE WHILE
      
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE WHILE

   ON ACTION controlg
      CALL cl_cmdask()

   ON ACTION close
      LET INT_FLAG = 1
      EXIT CONSTRUCT

   ON ACTION exit
      LET INT_FLAG = 1
      EXIT CONSTRUCT

   ON ACTION qbe_select
      CALL cl_qbe_select()

	 END CONSTRUCT
	     
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW artg525_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
      EXIT PROGRAM
   END IF
	      
	    
   INPUT BY NAME tm.azw01,tm.date,tm.type ATTRIBUTES(WITHOUT DEFAULTS=TRUE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         IF cl_null(tm.date) THEN
            LET tm.date = TODAY
         END IF
      AFTER FIELD date
         IF cl_null(tm.date) THEN
            CALL cl_err('','art-878',0)
            NEXT FIELD date
         END IF
                  
      AFTER FIELD type
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF

      AFTER FIELD azw01 
        LET g_plant2 = ''
        IF NOT cl_null(tm.azw01) THEN 
           LET l_tok = base.StringTokenizer.create(tm.azw01,'|')
           WHILE l_tok.hasMoreTokens()
              LET l_auth = l_tok.nextToken()
              SELECT COUNT(*) INTO l_cnt  FROM azw_file
                   WHERE azw02 = ( SELECT azw02 FROM azw_file WHERE azw01 = g_plant )
                     AND azw01 = l_auth
              IF l_cnt > = 1 THEN
                 IF cl_null(g_plant2) THEN
                    LET g_plant2 = "'",l_auth,"'"
                 ELSE
                    LET g_plant2 = g_plant2,",'",l_auth,"'"     
                 END IF
              END IF
           END WHILE 
        END IF     
      AFTER INPUT  
         IF cl_null(tm.date) THEN
            CALL cl_err('','art-878',0)
            NEXT FIELD date
         END IF        
         LET l_month = MONTH(tm.date) 
         LET l_year = YEAR(tm.date)      
         LET g_date1 = MDY(l_month,1,l_year) 
         LET g_date2 = tm.date 
         IF cl_null(g_plant2) THEN
            LET g_plant2 = ' 1=1'
         ELSE
            LET g_plant2 = " tlfplant IN (",g_plant2,")"
         END IF
      ON ACTION locale
         CALL cl_show_fld_cont()
         CALL cl_dynamic_locale()
         CONTINUE WHILE

       ON ACTION controlp
           CASE
              WHEN INFIELD(azw01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azw14"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1  = g_plant
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              LET tm.azw01 = g_qryparam.multiret
              DISPLAY BY NAME tm.azw01
              NEXT FIELD azw01 
           END CASE
         
        ON ACTION help
           CALL cl_show_help()
           CONTINUE WHILE
	    
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE WHILE
		    
        ON ACTION controlg
           CALL cl_cmdask()
		    
        ON ACTION close
           LET INT_FLAG = 1
           EXIT INPUT
		    
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
		    
        ON ACTION qbe_select
           CALL cl_qbe_select()
    END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW g525_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
      EXIT PROGRAM
   END IF

   INPUT BY NAME tm.more ATTRIBUTES(WITHOUT DEFAULTS=TRUE)

      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
            g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION locale
         CALL cl_show_fld_cont()
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      ON ACTION help
         CALL cl_show_help()
         CONTINUE WHILE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE WHILE
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION close
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_select
         CALL cl_qbe_select()
		    
   EXIT INPUT

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW g525_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL artg525()
   ERROR ""
   END WHILE
   CLOSE WINDOW artg525_w
END FUNCTION

FUNCTION artg525()
DEFINE l_sql     STRING
DEFINE l_sql2    STRING
DEFINE l_mm      STRING
DEFINE l_yy      STRING
DEFINE sr        RECORD
	  tlf01         LIKE tlf_file.tlf01,            #料件編號
	  tlf11         LIKE tlf_file.tlf11,            #異動單位
	  tlf907        LIKE tlf_file.tlf907,           #出入庫碼
	  tlf10         LIKE tlf_file.tlf10             #進貨量 

		  END RECORD
			  
DEFINE sr1        RECORD
	  tlf01         LIKE tlf_file.tlf01,            #料件編號
	  tlf11         LIKE tlf_file.tlf11,            #異動單位
	  tlf907        LIKE tlf_file.tlf907,           #出入庫碼
	  tlf10         LIKE tlf_file.tlf10,            #進貨量 
          tlf06         LIKE tlf_file.tlf06,
          tlfplant      LIKE tlf_file.tlfplant
		 END RECORD                  
 
DEFINE l_all_in        LIKE tlf_file.tlf10,           
       l_tlf10_1       LIKE tlf_file.tlf10,
       l_tlf10_2       LIKE tlf_file.tlf10, 
       l_tlf10         LIKE tlf_file.tlf10,           
       l_in_cost       LIKE ima_file.ima128,           #進貨金額
       l_ccc23         LIKE ccc_file.ccc23,            #實際單位成本
       l_act_in_cost   LIKE ccc_file.ccc23,            #實際成本進貨價格 
       l_fixed_rate    LIKE ima_file.ima126,           #原價率
       l_sale_out6     LIKE tlf_file.tlf10,            #前期銷售量
       l_sale_out5     LIKE tlf_file.tlf10,            #前5個月銷量
       l_sale_out4     LIKE tlf_file.tlf10,            #前4個月銷量
       l_sale_out3     LIKE tlf_file.tlf10,            #前3個月銷量
       l_sale_out2     LIKE tlf_file.tlf10,            #前2個月銷量
       l_sale_out1     LIKE tlf_file.tlf10,            #前1個月銷量
       l_sale_out      LIKE tlf_file.tlf10,            #當月銷量
       l_area_out      LIKE tlf_file.tlf10,            #指定範圍總銷量
       l_other_out     LIKE tlf_file.tlf10,            #其他總銷量
       l_area_out_rate LIKE ima_file.ima126,           #指定範圍消化率
       l_all_out       LIKE tlf_file.tlf10,            #總銷量
       l_stock         LIKE tlf_file.tlf10,            #結存數量
       l_all_rate      LIKE ima_file.ima126            #總消化率           
DEFINE l_cnt           LIKE type_file.num5   
DEFINE l_count         LIKE type_file.num5       
DEFINE l_year          LIKE type_file.num5
DEFINE l_month         LIKE type_file.num5
DEFINE l_plant         LIKE azw_file.azw01
DEFINE l_azw02         LIKE azw_file.azw02
DEFINE l_ima128        LIKE ima_file.ima128
DEFINE l_ima125        LIKE ima_file.ima125
DEFINE l_ima126        LIKE ima_file.ima126 
DEFINE l_tlf01         LIKE tlf_file.tlf01
DEFINE l_tlf11         LIKE tlf_file.tlf11
DEFINE l_ima25         LIKE ima_file.ima25
DEFINE l_ima02         LIKE ima_file.ima02
DEFINE l_date1         LIKE type_file.dat
DEFINE l_date2         LIKE type_file.dat
DEFINE l_azp03         LIKE azp_file.azp03
DEFINE l_ima01         LIKE ima_file.ima01
DEFINE l_tlf907        LIKE tlf_file.tlf907
DEFINE l_flag          LIKE type_file.chr100
DEFINE l_azi04         LIKE azi_file.azi04
   CALL cl_del_data(l_table)

   DROP TABLE artg525_tmp
	#存放進貨資料
   CREATE TEMP TABLE artg525_tmp(
      tlf01         LIKE tlf_file.tlf01 ,           #料件編號
      ima           LIKE tlf_file.tlf01 
   )

   DELETE FROM artg525_tmp

   DROP TABLE artg525_tmp1
	#存放進貨資料
   CREATE TEMP TABLE artg525_tmp1(
          tlf01         LIKE tlf_file.tlf01,            #料件編號
          tlf11         LIKE ima_file.ima25,
          tlf907        LIKE tlf_file.tlf907,
          tlf10         LIKE tlf_file.tlf10,            #進貨量 
          ima           LIKE tlf_file.tlf01 
   )

   DELETE FROM artg525_tmp1
	   
   DROP TABLE artg525_tmp2
	#存放銷貨資料
   CREATE TEMP TABLE artg525_tmp2(
         tlf01         LIKE tlf_file.tlf01,            #料件編號
         tlf11         LIKE tlf_file.tlf11,            #前期銷售量
         tlf907        LIKE tlf_file.tlf907,
         tlf10         LIKE tlf_file.tlf10,
         tlf06         LIKE type_file.dat,
         tlfplant      LIKE tlf_file.tlfplant,
         ima           LIKE tlf_file.tlf01 

   )
   DELETE FROM artg525_tmp2	   
{   
   LET l_sql = " SELECT DISTINCT ima01 FROM ima_file WHERE ",tm.wc
   PREPARE sel_ima_pre FROM l_sql
   DECLARE sel_ima_cs CURSOR FOR sel_ima_pre

   FOREACH sel_ima_cs INTO l_ima01
      IF STATUS THEN
         CALL cl_err('IMA:',SQLCA.sqlcode,1)
         RETURN
      END IF
      INSERT INTO artg525_tmp VALUES(l_ima01,'')
   END FOREACH
}
   LET l_sql = " SELECT azw01 ",
               " FROM azw_file ",
               " WHERE azw02 = ( ",
               " SELECT azw02 FROM azw_file ",
               " WHERE azw01 = '",g_plant,"')",
               " AND 1=1 ORDER BY azw01"

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre

   FOREACH sel_azp01_cs INTO l_plant
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_plant
      IF NOT cl_chk_schema_has_built(l_azp03) THEN
         CONTINUE FOREACH
      END IF      

      LET l_sql = " SELECT tlf01 FROM ",cl_get_target_table(g_plant,'tlf_file'),
                  "     JOIN ",cl_get_target_table(g_plant,'ima_file'),
                  "           ON tlf01 = ima01",
                  " WHERE ",tm.wc,
                  "  AND (tlf13 IN ('apmt150','apmt1072','apmt230')",
                  "       OR (tlf13='aomt800' or tlf13 like 'axmt%')  )", 
                  "  AND tlf06  < '",g_date2,"'",
                  "  AND tlfplant = '",l_plant,"'"
      PREPARE sel_ima_pre FROM l_sql
      DECLARE sel_ima_cs CURSOR FOR sel_ima_pre

      FOREACH sel_ima_cs INTO l_ima01
         IF STATUS THEN
            CALL cl_err('IMA:',SQLCA.sqlcode,1)
            RETURN
         END IF
         INSERT INTO artg525_tmp VALUES(l_ima01,'')
      END FOREACH

      LET l_sql = " SELECT tlf01, tlf11, tlf907, SUM(tlf10) ",
                  " FROM ",cl_get_target_table(g_plant,'tlf_file'),
                  "     JOIN ",cl_get_target_table(g_plant,'ima_file'),
                  "           ON tlf01 = ima01",
                  " WHERE tlf13 IN ('apmt150','apmt1072','apmt230') ",
                  "    AND tlf06  < '",g_date2,"'",
                  "    AND tlfplant = '",l_plant,"'",                    
                  "    AND ", tm.wc CLIPPED ,
                  " GROUP BY tlf01, tlf11, tlf907" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql
      PREPARE artg525_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
         EXIT PROGRAM
      END IF
      DECLARE artg525_curs1 CURSOR FOR artg525_prepare1

      FOREACH artg525_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         INSERT INTO artg525_tmp1
            VALUES(sr.tlf01,sr.tlf11,sr.tlf907,sr.tlf10,'')
      END FOREACH
      
      LET l_sql2 = " SELECT tlf01, tlf11, tlf907, SUM(tlf10),",
                   "        tlf06,tlfplant",
                   " FROM ",cl_get_target_table(l_plant,'tlf_file'),
                   "     JOIN ",cl_get_target_table(l_plant,'ima_file'),
                   "           ON tlf01 = ima01",
                   " WHERE (tlf13='aomt800' or tlf13 like 'axmt%') ",
                   "    AND tlf06  <= '",g_date2,"'",
                   "    AND tlfplant = '",l_plant,"'", 
                   "    AND ", tm.wc CLIPPED,
                   " GROUP BY tlf01, tlf11, tlf907,tlf06,tlfplant" 
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
      CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2
      PREPARE artg525_prepare2 FROM l_sql2
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
         EXIT PROGRAM
      END IF
      DECLARE artg525_curs2 CURSOR FOR artg525_prepare2

      FOREACH artg525_curs2 INTO sr1.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

      INSERT INTO artg525_tmp2
         VALUES(sr1.tlf01,sr1.tlf11,sr1.tlf907,sr1.tlf10,sr1.tlf06,sr1.tlfplant,'')   
      END FOREACH
   END FOREACH 
   
   #進貨量
   LET l_sql = "SELECT DISTINCT tlf01 FROM artg525_tmp ORDER BY tlf01"

   PREPARE artg525_prepare3 FROM l_sql
   DECLARE artg525_curs3 CURSOR FOR artg525_prepare3
      FOREACH artg525_curs3 INTO l_tlf01
         SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 
         LET l_tlf10 = 0       
         LET l_sql = "SELECT SUM(tlf10),tlf11 ",
                     " FROM artg525_tmp1 ",
                     " WHERE tlf01 = '",l_tlf01,"'",
                     " AND tlf907 = 1",
                     " GROUP BY tlf11"  
         PREPARE artg525_prepare4 FROM l_sql
         DECLARE artg525_curs4 CURSOR FOR artg525_prepare4
         #進貨
         LET l_tlf10_1 = 0
         FOREACH artg525_curs4 INTO l_tlf10,l_tlf11
            SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_tlf01
            CALL artg525_rate(l_tlf01,l_tlf11,l_ima25)
            LET l_tlf10 = l_tlf10 *g_rate
            LET l_tlf10_1 = l_tlf10_1 + l_tlf10
         END FOREACH

         LET l_tlf10 = 0
         LET l_sql = "SELECT SUM(tlf10),tlf11 ",
                     " FROM artg525_tmp1 ",
                     " WHERE tlf01 = '",l_tlf01,"'",
                     " AND tlf907 = -1",
                     " GROUP BY tlf11"  
         PREPARE artg525_prepare5 FROM l_sql     
         DECLARE artg525_curs5 CURSOR FOR artg525_prepare5    
         LET l_tlf10_2 = 0
         FOREACH artg525_curs5 INTO l_tlf10,l_tlf11
            SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_tlf01
            CALL artg525_rate(l_tlf01,l_tlf11,l_ima25)
            LET l_tlf10 = l_tlf10 *g_rate
            LET l_tlf10_2 = l_tlf10_2+ l_tlf10
         END FOREACH  
         LET l_all_in = 0 
         LET l_all_in = l_tlf10_1 - l_tlf10_2
           

      SELECT ima128,ima125,ima126 
          INTO l_ima128,l_ima125,l_ima126 FROM ima_file 
          WHERE ima01 = l_tlf01
      #本幣含稅定價
      CALL cl_digcut(l_ima128,l_azi04) RETURNING l_ima128
      #單位成本
      CALL cl_digcut(l_ima125,l_azi04) RETURNING l_ima125    
      #定價進貨金額
      LET l_in_cost = 0 
      LET l_in_cost = l_ima128 * l_all_in
      CALL cl_digcut(l_in_cost,l_azi04) RETURNING l_in_cost

      LET l_ccc23 = 0 
      LET l_flag = FALSE
      #判斷axct100是否有資料
      LET l_year = YEAR(tm.date) 
      LET l_month = MONTH(tm.date) 
      SELECT count(*) INTO l_count FROM ccc_file
         WHERE  ccc01 = l_tlf01 
            AND ccc07 = tm.type
      IF l_count  >= 1 THEN
         LET l_flag = TRUE
      END IF
      #判斷axct100有資料,則進入查詢
      IF l_flag THEN
         WHILE TRUE
            SELECT count(*) INTO l_cnt FROM ccc_file
               WHERE ccc01 = l_tlf01 
                  AND ccc07 = tm.type
                  AND ccc02 = l_year
                  AND ccc03 = l_month
            IF l_cnt >= 1 THEN               
               SELECT ccc23 INTO l_ccc23 FROM ccc_file
                  WHERE ccc01 = l_tlf01 
                     AND ccc07 = tm.type
                     AND ccc02 = l_year
                     AND ccc03 = l_month               
                  EXIT WHILE
            ELSE 
               IF l_month = 1  THEN
                  LET l_month = 12
                  LET l_year = l_year - 1
               ELSE               
                  LET l_month = l_month - 1 
               END IF
            END IF
         END WHILE
      END IF

      IF NOT l_flag THEN
         SELECT count(*) INTO l_count FROM cca_file 
            WHERE cca01 = l_tlf01 
               AND cca06 = tm.type
         IF l_count > 0 THEN
            WHILE TRUE
               SELECT count(*) INTO l_cnt FROM cca_file
                  WHERE cca01 = l_tlf01
                     AND cca06 = tm.type
                     AND cca02 = l_year
                     AND cca03 = l_month
               IF l_cnt >= 1 THEN 
                  SELECT cca23 INTO l_ccc23 FROM cca_file
                     WHERE cca01 = l_tlf01
                        AND cca06 = tm.type
                        AND cca02 = l_year
                        AND cca03 = l_month
                        EXIT WHILE
               ELSE
                  IF l_month = 1 THEN
                     LET l_month = 12
                     LET l_year = l_year - 1
                  ELSE               
                     LET l_month = l_month - 1 
                  END IF
               END IF
            END WHILE
         ELSE 
            LET l_ccc23 = 0 
         END IF
      END IF   
      IF cl_null(l_ccc23) THEN
         LET l_ccc23 = 0 
      END IF 
      CALL cl_digcut(l_ccc23,l_azi04) RETURNING l_ccc23
      
      #實際成本進貨金額
      LET l_act_in_cost  = 0 
      LET l_act_in_cost = l_ccc23 * l_all_in
      CALL cl_digcut(l_act_in_cost,l_azi04) RETURNING l_act_in_cost
      #原價率
      LET l_fixed_rate = 0 
      LET l_fixed_rate = ((l_ccc23 * (l_ima126/100))/l_ima128)*100
      LET g_date3 = g_date2
      LET l_yy = YEAR(g_date2)
      LET l_mm = MONTH(g_date2)

      #前一個月銷
      LET l_sale_out1 = 0 
      LET g_date3 = MDY(l_mm,1,l_yy)-1
      CALL artg525_sale(l_tlf01)
      IF cl_null(g_sale_out) THEN
         LET g_sale_out = 0                        
      END IF
      LET l_sale_out1 = g_sale_out
 
      #前二個月銷
      LET l_sale_out2 = 0 
      LET g_date3 = MDY(l_mm-1,1,l_yy)-1 
      CALL artg525_sale(l_tlf01)
      IF cl_null(g_sale_out) THEN
         LET g_sale_out = 0                        
      END IF
      LET l_sale_out2 = g_sale_out

      #前三個月銷
      LET l_sale_out3 = 0
      LET g_date3 = MDY(l_mm-2,1,l_yy)-1 
      CALL artg525_sale(l_tlf01)  
      IF cl_null(g_sale_out) THEN
         LET g_sale_out = 0                        
      END IF
      LET l_sale_out3 = g_sale_out

      #前四個月銷
      LET l_sale_out4 = 0
      LET g_date3 = MDY(l_mm-3,1,l_yy)-1 
      CALL artg525_sale(l_tlf01)  
      IF cl_null(g_sale_out) THEN
         LET g_sale_out = 0                        
      END IF
      LET l_sale_out4 = g_sale_out

      #前五個月銷
      LET l_sale_out5 = 0
      LET g_date3 = MDY(l_mm-4,1,l_yy)-1  
      CALL artg525_sale(l_tlf01)  
      IF cl_null(g_sale_out) THEN
         LET g_sale_out = 0                        
      END IF
      LET l_sale_out5 = g_sale_out 
         
      #前期銷量
      LET l_sale_out6 = 0 
      LET g_flag2 = TRUE
      LET g_date3 = MDY(l_mm-5,1,l_yy)-1  
      CALL artg525_sale(l_tlf01)
      LET l_sale_out6 = g_sale_out 
      IF cl_null(l_sale_out6) THEN
         LET l_sale_out6 = 0 
      END IF   
      LET g_flag2 = FALSE
        
      #總銷量         
      LET l_sql = " SELECT SUM(tlf10),tlf11 FROM artg525_tmp2 ",
                  " WHERE tlf01 = '",l_tlf01,"'",
                  " AND tlf907 = 1",
                  " GROUP BY tlf11"
              
      PREPARE artg525_prepare6 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
         EXIT PROGRAM
      END IF
      DECLARE artg525_curs6 CURSOR FOR artg525_prepare6
      LET l_tlf10_1 = 0
      LET l_tlf10 = 0 
      LET l_tlf11 = ''
      FOREACH artg525_curs6 INTO l_tlf10,l_tlf11
         
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_tlf01
         CALL artg525_rate(l_tlf01,l_tlf11,l_ima25)
         LET l_tlf10 = l_tlf10 *g_rate
         LET l_tlf10_1 = l_tlf10_1 + l_tlf10
         LET l_tlf10 = 0
         LET l_tlf11 = ''
      END FOREACH
      
      LET l_sql = " SELECT SUM(tlf10),tlf11 FROM artg525_tmp2 ",
                  " WHERE tlf01 = '",l_tlf01,"'",
                  " AND tlf907 = -1",
                  " GROUP BY tlf11"
              
      PREPARE artg525_prepare7 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
         EXIT PROGRAM
      END IF
      DECLARE artg525_curs7 CURSOR FOR artg525_prepare7
      LET l_tlf10_2 = 0
      LET l_tlf10 = 0
      LET l_tlf11 = ''
      FOREACH artg525_curs7 INTO l_tlf10,l_tlf11
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_tlf01
         CALL artg525_rate(l_tlf01,l_tlf11,l_ima25)
         LET l_tlf10 = l_tlf10 *g_rate
         LET l_tlf10_2 = l_tlf10_2 + l_tlf10
         LET l_tlf10 = 0
         LET l_tlf11 = ''
      END FOREACH
      LET l_all_out = 0 
      LET l_all_out = (l_tlf10_1 - l_tlf10_2)*(-1)
        
      #指定範圍總銷量
      LET l_area_out = 0
      LET g_flag2 = TRUE
      LET g_date3 = g_date2 
      CALL artg525_sale(l_tlf01)
      LET l_area_out = g_sale_out
      IF cl_null(l_area_out) THEN
         LET l_area_out = 0
      END IF
      LET g_flag2 = FALSE       

      #當月銷量
      LET l_sale_out = 0
      LET g_date3 = g_date2
      CALL artg525_sale(l_tlf01)
      LET l_sale_out = g_sale_out
      IF cl_null(g_sale_out) THEN
         LET g_sale_out = 0
      END IF

      #其他範圍總銷量   
      LET l_other_out = 0       
      LET l_other_out = l_all_out - l_area_out
         
      #結存數量
      LET l_stock = l_all_in - l_all_out 

      #指定範圍消化率
      LET l_area_out_rate = 0
      LET l_area_out_rate = (l_area_out/(l_all_in - l_other_out))*100
         
      #總消化率
      LET l_all_rate = 0 
      LET l_all_rate= (l_all_out/l_all_in)*100
                          
      SELECT ima02  INTO l_ima02 FROM ima_file WHERE ima01 = l_tlf01 
         EXECUTE insert_prep USING
            l_tlf01,l_ima02,l_all_in,l_ima128,l_in_cost,l_ima125,l_ccc23,
            l_act_in_cost,l_ima126,l_fixed_rate,l_sale_out6,l_sale_out5,
            l_sale_out4,l_sale_out3,l_sale_out2,l_sale_out1,l_sale_out,
            l_area_out,l_other_out,l_area_out_rate,l_all_out,l_stock,l_all_rate,l_azi04
   END FOREACH
      
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET l_sql = l_sql," ORDER BY tlf01 "
###GENGRE###   LET g_str = tm.wc
###GENGRE###   CALL cl_prt_cs3('artg525','artg525_1',l_sql,g_str)
    CALL artg525_grdata()    ###GENGRE###
END FUNCTION
#取得庫存單位轉換率
FUNCTION artg525_rate(l_tlf01,l_tlf11,l_ima25)
DEFINE l_tlf01       LIKE tlf_file.tlf01
DEFINE l_tlf11       LIKE tlf_file.tlf11
DEFINE l_ima25       LIKE ima_file.ima25
DEFINE l_rate1       LIKE type_file.num26_10 
DEFINE l_rate        LIKE type_file.num26_10 
DEFINE l_flag        LIKE type_file.num5 
      LET g_rate = 1
      LET l_ima25 = ''
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_tlf01
      IF l_tlf11 <>  l_ima25 THEN
         CALL s_umfchk(l_tlf01,l_tlf11,l_ima25)
         RETURNING l_flag, l_rate1
         #轉換率有資料回傳l_flag = 0  
         IF NOT l_flag AND NOT cl_null(l_rate1)THEN 
            LET l_rate = l_rate1
         ELSE 
             LET l_rate = 1
         END IF
      ELSE 
         LET l_rate = 1
      END IF
      LET g_rate = l_rate      
END FUNCTION

FUNCTION artg525_sale(tlf01)
DEFINE tlf01         LIKE tlf_file.tlf01
DEFINE l_tlf01       LIKE tlf_file.tlf01
DEFINE l_date1       DATE 
DEFINE l_date2       DATE 
DEFINE l_sql         STRING
DEFINE l_sale_out    LIKE tlf_file.tlf10
DEFINE l_year        STRING 
DEFINE l_month       STRING
DEFINE l_date        STRING 
DEFINE l_sale_out1   LIKE tlf_file.tlf10
DEFINE l_sale_out2   LIKE tlf_file.tlf10
DEFINE l_sale_out3   LIKE tlf_file.tlf10
DEFINE l_sale_out4   LIKE tlf_file.tlf10
DEFINE l_sql2        STRING
DEFINE l_flag        LIKE type_file.chr100
DEFINE l_tlf10       LIKE tlf_file.tlf10
DEFINE l_tlf11       LIKE tlf_file.tlf11
DEFINE l_ima25       LIKE ima_file.ima25

   LET l_year = YEAR(g_date3)  
   LET l_month = MONTH(g_date3)
   LET l_tlf01 = tlf01
   LET l_sale_out3 = 0 
   LET l_sale_out4 = 0 

   LET l_date1 =  MDY(l_month,1,l_year) 
   LET l_date2 =  g_date3 
   LET g_sale_out = 0 
   IF g_flag2 THEN
      LET l_sql = " SELECT SUM(tlf10),tlf11 ",
                  " FROM artg525_tmp2",
                  " WHERE tlf01 = '",l_tlf01,"'",
                  "   AND tlf907 = 1",
                  "   AND tlf06 <= '",l_date2,"'",      
                  "   AND ",g_plant2 CLIPPED ,                     
                  "   GROUP BY tlf11"
      LET l_sql2 = " SELECT SUM(tlf10),tlf11  ",
                   " FROM artg525_tmp2",
                   " WHERE tlf01 = '",l_tlf01,"'",
                   "   AND tlf907 = -1",
                   "   AND tlf06 <= '",l_date2,"'",
                   "   AND ",g_plant2 CLIPPED ,
                   "   GROUP BY tlf11"                                     
   ELSE                
      LET l_sql = " SELECT SUM(tlf10),tlf11 ",
                  " FROM artg525_tmp2",
                  " WHERE tlf01 = '",l_tlf01,"'",
                  "   AND tlf06 BETWEEN '",l_date1,"'", 
                             " AND '",l_date2,"'",
                  "   AND tlf907 = 1",
                  "   AND ",g_plant2 CLIPPED ,
                  "   GROUP BY tlf11"
      LET l_sql2 = " SELECT SUM(tlf10),tlf11  ",
                   " FROM artg525_tmp2",
                   " WHERE tlf01 = '",l_tlf01,"'",
                   "   AND tlf06 BETWEEN '",l_date1,"'",
                             " AND '",l_date2,"'",
                   "   AND tlf907 = -1",
                   "   AND ",g_plant2 CLIPPED ,
                   "   GROUP BY tlf11"
   END IF
   PREPARE artg525_prepare8 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
      EXIT PROGRAM
   END IF
   DECLARE artg525_curs8 CURSOR FOR artg525_prepare8

   PREPARE artg525_prepare9 FROM l_sql2
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table) #FUN-C10036 add by xuxz
      EXIT PROGRAM
   END IF
   DECLARE artg525_curs9 CURSOR FOR artg525_prepare9
   
   FOREACH artg525_curs8 INTO l_sale_out1 ,l_tlf11
      CALL artg525_rate(l_tlf01,l_tlf11,l_ima25)
      IF cl_null(l_sale_out1) THEN
         LET l_sale_out1= 0 
      END IF         
      LET l_sale_out1 = l_sale_out1 * g_rate
      LET l_sale_out3 = l_sale_out3 + l_sale_out1            
      LET l_sale_out1 = 0  
   END FOREACH
   
   FOREACH artg525_curs9 INTO l_sale_out1 ,l_tlf11
      CALL artg525_rate(l_tlf01,l_tlf11,l_ima25)
      IF cl_null(l_sale_out1) THEN
         LET l_sale_out1= 0 
      END IF   
      LET l_sale_out1 = l_sale_out1 * g_rate
      LET l_sale_out4 = l_sale_out4 + l_sale_out1  
      LET l_sale_out1 = 0           
   END FOREACH      
  
   IF cl_null(l_sale_out1) THEN
      LET l_sale_out1 = 0 
   END IF

   IF cl_null(l_sale_out2) THEN
      LET l_sale_out2 = 0 
   END IF 

   LET g_sale_out = l_sale_out3 - l_sale_out4
   LET g_sale_out = g_sale_out*(-1)
 
END FUNCTION
#FUN-BA0034

###GENGRE###START
FUNCTION artg525_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg525")
        IF handler IS NOT NULL THEN
            START REPORT artg525_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE artg525_datacur1 CURSOR FROM l_sql
            FOREACH artg525_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg525_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg525_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg525_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
   #FUN-C10036 add by xuxz str
    DEFINE l_ima128_fmt  STRING
    DEFINE l_in_cost_fmt STRING
    DEFINE l_ima125_fmt STRING
    DEFINE l_ccc23_fmt STRING
    DEFINE l_act_in_cot_fmt STRING
   #FU-C10036 add by xuxz end
    
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

           #FUN-C10036 add by xuxz --str
            LET l_ima128_fmt = cl_gr_numfmt('ima_file','ima128',sr1.azi04)
            PRINTX l_ima128_fmt
            LET l_in_cost_fmt = cl_gr_numfmt('ima_file','ima128',sr1.azi04)
            PRINTX l_in_cost_fmt
            LET l_ima125_fmt = cl_gr_numfmt('ima_file','ima125',sr1.azi04)
            PRINTX l_ima125_fmt
            LET l_ccc23_fmt = cl_gr_numfmt('ccc_file','ccc23',sr1.azi04)
            PRINTX l_ccc23_fmt
            LET l_act_in_cot_fmt = cl_gr_numfmt('ccc_file','ccc23',sr1.azi04)
            PRINTX l_act_in_cot_fmt
           #FUN-C10036 add by xuxz --end
            PRINTX sr1.*

          
        ON LAST ROW

END REPORT
###GENGRE###END
