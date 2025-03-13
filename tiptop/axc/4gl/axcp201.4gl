# Prog. Version..: '5.30.02-12.08.01(00001)'     #
#
# Pattern name...: axcp201.4gl
# Descriptions...:發出商品檔月統計作業
# Date & Author..:No.FUN-C60036 12/06/18 By xuxz 
# Modify.........: No:MOD-CB0110 12/11/12 By wujie 默认账套带ccz12,默认成本计算类型带ccz28，默认年月带ccz01，ccz02
# Modify.........: No:FUN-C80092 12/09/12 By xujing 成本相關作業程式日誌
# Modify.........: No:FUN-D70058 13/07/10 By wangrr 增加庫存單位科目等欄位,cfc_file改為按照營運中心+客戶+料號+出貨/銷推年月匯總,程式邏輯優化
# Modify.........: No:TQC-D80012 13/08/07 By wangrr cfc20設置默認值‘ ’
# Modify.........: No:CHI-E40001 14/04/01 By SunLM 跨月開票導致轉入發出商品異常
# Modify.........: No:CHI-140414 14/04/14 By SunLM 跨年開票導致轉入發出商品異常,例如13年3月和14年3月的票


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_wc       STRING                   #QBE_1的條件
DEFINE g_sql      STRING                   #組sql

DEFINE tm         RECORD                   #INPUT條件
          yy      LIKE type_file.chr4,
          mm      LIKE type_file.chr2
          END RECORD
DEFINE p_row,p_col      LIKE type_file.num5
DEFINE g_change_lang    LIKE type_file.chr1
#用於比較轉入與轉出
DEFINE g_sum_out        LIKE type_file.num20
DEFINE g_sum_in         LIKE type_file.num20
DEFINE g_cka00          LIKE cka_file.cka00  #FUN-C80092 add
DEFINE g_cka09          LIKE cka_file.cka09  #FUN-C80092 add

MAIN 
   DEFINE l_flag  LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   INITIALIZE tm.* TO NULL
   LET g_wc = ARG_VAL(1)          #QBE條件
   LET g_wc = cl_replace_str(g_wc, "\\\"", "'")   #'
   LET tm.yy = ARG_VAL(2)         #年度
   LET tm.mm = ARG_VAL(3)         #期別
   LET g_bgjob = ARG_VAL(4)       #背景作業否

   IF cl_null(g_bgjob) THEN 
      LET g_bgjob ="N"
   END IF 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log 
   
   IF (NOT cl_setup("AXC")) THEN 
      EXIT PROGRAM 
   END IF 
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p201_tm()
         IF cl_sure(18,20) THEN 
            LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm,";g_bgjob='",g_bgjob,"'"     #FUN-C80092 add
            CALL s_log_ins(g_prog,tm.yy,tm.mm,g_wc,g_cka09) RETURNING g_cka00   #FUN-C80092 add
            LET g_success = 'Y'
            CALL s_showmsg_init()
           #CALL p201()  #FUN-D70058 mark
            CALL p201_t() #FUN-D70058
            CALL s_showmsg() 
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p201_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm,";g_bgjob='",g_bgjob,"'"     #FUN-C80092 add
         CALL s_log_ins(g_prog,tm.yy,tm.mm,g_wc,g_cka09) RETURNING g_cka00   #FUN-C80092 add
         LET g_success = 'Y'
         CALL s_showmsg_init()
         #CALL p201()  #FUN-D70058 mark
         CALL p201_t() #FUN-D70058
         CALL s_showmsg()
         IF g_success = "Y" THEN
            COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
         ELSE
            ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         END IF
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p201_tm()
   DEFINE  p_row,p_col     LIKE type_file.num5    
   DEFINE  lc_cmd          LIKE type_file.chr1000   

   LET p_row = 4 LET p_col = 26

   OPEN WINDOW axcp201_w AT p_row,p_col WITH FORM "axc/42f/axcp201" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   CLEAR FORM
   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM 
   INITIALIZE tm.* TO NULL			
   LET g_bgjob = 'N'

   DIALOG attributes(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON cfb07,cfb11
      
         BEFORE CONSTRUCT 
            CALL cl_qbe_init()
      END CONSTRUCT 

      INPUT BY NAME tm.yy,tm.mm,g_bgjob
#No.MOD-CB0110 --begin
         BEFORE INPUT 
            LET tm.yy = g_ccz.ccz01
            LET tm.mm = g_ccz.ccz02
            DISPLAY BY NAME tm.yy,tm.mm
#No.MOD-CB0110 --end

         AFTER FIELD yy
            IF cl_null(tm.yy) THEN 
               CALL cl_err('','ask-003',0)
               NEXT FIELD yy
            END IF 
            IF NOT cl_null(tm.yy) THEN 
               IF tm.yy  < 0 THEN 
                  CALL cl_err('','ask-003',0)
                  NEXT FIELD yy
               END IF 
               IF length(tm.yy) <>'4' THEN 
                  CALL cl_err('','ask-003',0)
                  NEXT FIELD yy
               END IF 
            END IF 
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN 
               CALL cl_err('','agl-013',0)
               NEXT FIELD mm
            END IF 
            IF NOT cl_null(tm.mm) THEN 
               IF tm.mm >13 THEN 
                  CALL cl_err('','agl-013',0)
                  NEXT FIELD mm
               END IF 
               IF tm.mm < 1 THEN
                  CALL cl_err('','agl-013',0)
                  NEXT FIELD mm 
               END IF 
            END IF 
      END INPUT

      ON ACTION controlp
         CASE 
            WHEN INFIELD(cfb07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_cfb07"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cfb07
               NEXT FIELD cfb07
            WHEN INFIELD(cfb11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_cfb11"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cfb11
               NEXT FIELD cfb11
            OTHERWISE
               EXIT CASE
         END CASE
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
                
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
                 
      ON ACTION about         
         CALL cl_about()      
                  
      ON ACTION help          
         CALL cl_show_help()  
                  
      ON ACTION controlg      
         CALL cl_cmdask()     
              
      ON ACTION ACCEPT
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF 
         IF cl_null(tm.mm) THEN NEXT FIELD mm END IF 
         EXIT DIALOG
         
      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG
             
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION locale 
         LET g_change_lang = TRUE
         CALL cl_dynamic_locale()    
         CALL cl_show_fld_cont()
            
   END DIALOG

   IF INT_FLAG THEN
      CLOSE WINDOW p201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'axcp201'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('axcp201','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " ''",
                      " '",g_wc CLIPPED,"'",
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.mm CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axcp201',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW axcp201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
END FUNCTION 

FUNCTION p201()
   DEFINE l_date      LIKE type_file.dat,
          l_date_last LIKE type_file.dat,
          l_cnt       LIKE type_file.num10,
          l_tab       LIKE type_file.num5,
          l_wc        STRING
   DEFINE l_cfb04     LIKE cfb_file.cfb04,
          l_cfb05     LIKE cfb_file.cfb05,
          l_cfb03     LIKE cfb_file.cfb03,
          l_cfb00     LIKE cfb_file.cfb00
   DEFINE l_cfc       RECORD LIKE cfc_file.*,
          l_cfb       RECORD LIKE cfb_file.*,
          l_cfb_out   RECORD 
              cfb00      LIKE cfb_file.cfb00,
              cfb01      LIKE cfb_file.cfb01,
              cfb03      LIKE cfb_file.cfb03,
              cfb04      LIKE cfb_file.cfb04,
              cfb05      LIKE cfb_file.cfb05,
              cfb15      LIKE cfb_file.cfb15
                       END RECORD 
                       
   #根據tm.mm和tm.yy組合出日期
   BEGIN WORK
   LET l_date=MDY(tm.mm,1,tm.yy)
   LET l_date_last = s_last(l_date)
   
   LET l_wc= cl_replace_str(g_wc,'cfb07','cfc07')
   LET l_wc= cl_replace_str(l_wc,'cfb11','cfc11')
   LET g_sql = "DELETE FROM cfc_file",
               " WHERE cfc05 = '",tm.yy,"'",
               "   AND cfc06 = '",tm.mm,"'",
               "   AND cfc01 = '1' ",      #CHI-E40001 add         
               "   AND ",l_wc CLIPPED 
   PREPARE p201_del FROM g_sql
   EXECUTE p201_del
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('cfc05,cfc06','','DELETE cfc_file',SQLCA.sqlcode,1)
     LET g_success = 'N'
   END IF 
#CHI-E40001 add begin-------------------
#删除方向为-1的开票档案
   LET g_sql = "DELETE FROM cfc_file",
               " WHERE cfc21 = '",tm.yy,"'",
               "   AND cfc22 = '",tm.mm,"'",
               "   AND cfc01 = '-1' ",               
               "   AND ",l_wc CLIPPED 
   PREPARE p201_del2 FROM g_sql
   EXECUTE p201_del2
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('cfc05,cfc06','','DELETE cfc_file -1',SQLCA.sqlcode,1)
     LET g_success = 'N'
   END IF 
#CHI-E40001 add end-----------------------      
   #判斷有無符合條件之資料
   LET g_sql = " SELECT COUNT(*)  FROM cfb_file ",
               "  WHERE cfb06 <= '",l_date_last,"'",
               "    AND ",g_wc
   PREPARE p201_pre_count FROM g_sql
   LET l_cnt = 0 
   EXECUTE p201_pre_count INTO l_cnt
   IF l_cnt = 0 THEN 
      CALL s_errmsg('','','','aic-024',1)
      LET g_success = 'N' 
      RETURN
   END IF
   LET l_cnt = 0 
   #本批處理主SQL
   LET g_sql = " SELECT DISTINCT cfb00,cfb03,cfb04,cfb05 FROM cfb_file ",
               "  WHERE cfb06 <= '",l_date_last,"'",
               "    AND ",g_wc,
               "  ORDER BY cfb03,cfb04,cfb05 "
   PREPARE p201_pre_cfb FROM g_sql
   DECLARE p201_cs_cfb CURSOR FOR p201_pre_cfb

   #查詢轉入資料的SQL，
   LET g_sql = " SELECT DISTINCT * FROM cfb_file ",
               "  WHERE cfb01 = 1 ",
               "    AND cfb00 = ? ",
               "    AND cfb03 = ? ",
               "    AND cfb04 = ? ",
               "    AND cfb05 = ? ",
               "    AND MONTH(cfb06) = ? ",
               "    AND YEAR(cfb06) = ? " #CHI-140414
   PREPARE p201_pre_1  FROM g_sql
   DECLARE p201_cs_cfb_1 CURSOR FOR p201_pre_1

   #查詢轉出資料的SQL，cfb15匯總
   LET g_sql = " SELECT cfb00,cfb01,cfb03,cfb04,cfb05,SUM(cfb15) ",
               "   FROM cfb_file ",
               "  WHERE cfb01 = -1 ",
               "    AND cfb00 = ? ",
               "    AND cfb03 = ? ",
               "    AND cfb04 = ? ",
               "    AND cfb05 = ? ",
               "    AND MONTH(cfb061) = ? ",  #cfb06--->cfb061  CHI-E40001
               "    AND YEAR(cfb061) = ? ",# #CHI-140414
               "  GROUP BY cfb00,cfb01,cfb03,cfb04,cfb05 "
   PREPARE p201_pre_2  FROM g_sql
   DECLARE p201_cs_cfb_2 CURSOR FOR p201_pre_2
   
   LET l_cfb04 = ''
   LET l_cfb05 = ''
    
   
   FOREACH p201_cs_cfb INTO l_cfb00,l_cfb03,l_cfb04,l_cfb05
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','',SQLCA.sqlcode,1)
         LET g_success='N' RETURN                             
      END IF
      
      #g_sum_in g_sum_out
      LET g_sum_in = NULL 
      LET g_sum_out = NULL
      
      LET g_sql = " SELECT SUM(cfb15)  FROM cfb_file ",
                  "  WHERE cfb01 = 1 AND cfb06 < '",l_date,"'",
                  "    AND cfb00 = '",l_cfb00,"'",
                  "    AND cfb03 = '",l_cfb03,"'",
                  "    AND cfb04 = '",l_cfb04,"'",
                  "    AND cfb05 = '",l_cfb05,"'"
      PREPARE p201_pre_cfb15_1 FROM g_sql
      EXECUTE p201_pre_cfb15_1 INTO g_sum_in

      LET g_sql = " SELECT SUM(cfb15)  FROM cfb_file ",
                  "  WHERE cfb01 = -1 AND cfb06 < '",l_date,"'",
                  "    AND cfb00 = '",l_cfb00,"'",
                  "    AND cfb03 = '",l_cfb03,"'",
                  "    AND cfb04 = '",l_cfb04,"'",
                  "    AND cfb05 = '",l_cfb05,"'"
      PREPARE p201_pre_cfb15_2 FROM g_sql
      EXECUTE p201_pre_cfb15_2 INTO g_sum_out
      LET l_tab = 0 
      IF cl_null(g_sum_in) AND cl_null(g_sum_out) THEN
         LET l_tab = 1
      ELSE
         LET l_tab = 0
      END IF 
      IF cl_null(g_sum_in) THEN LET g_sum_in = 0 END IF
      IF cl_null(g_sum_out) THEN LET g_sum_out = 0 END IF
      
      #插入操作insert into cfc_file
      IF g_sum_in - g_sum_out > 0 OR l_tab = 1 OR (l_cfb00 = '3' AND g_sum_in - g_sum_out < 0 )THEN 
         INITIALIZE l_cfc.* TO NULL
         INITIALIZE l_cfb.* TO NULL
         
         #轉入資料
         FOREACH p201_cs_cfb_1 USING l_cfb00,l_cfb03,l_cfb04,l_cfb05,tm.mm,tm.yy INTO l_cfb.*  #add tm.yy#CHI-140414
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','',SQLCA.sqlcode,1)
               LET g_success='N' RETURN                             
            END IF
            
            #賦值
            LET l_cfc.cfc00 = l_cfb.cfb00
            LET l_cfc.cfc01 = l_cfb.cfb01
            LET l_cfc.cfc02 = l_cfb.cfb03
	        LET l_cfc.cfc03 = l_cfb.cfb04
            LET l_cfc.cfc04 = l_cfb.cfb05
	        #LET l_cfc.cfc05 = tm.yy  #CHI-E40001
	        #LET l_cfc.cfc06 = tm.mm   #CHI-E40001
	        LET l_cfc.cfc05 = YEAR(l_cfb.cfb06) #CHI-E40001 add
	        LET l_cfc.cfc06 = MONTH(l_cfb.cfb06) #CHI-E40001 add
	        LET l_cfc.cfc07 = l_cfb.cfb07
	        LET l_cfc.cfc08 = l_cfb.cfb08
	        LET l_cfc.cfc09 = l_cfb.cfb09
	        LET l_cfc.cfc10 = l_cfb.cfb10
	        LET l_cfc.cfc11 = l_cfb.cfb11
	        LET l_cfc.cfc12 = l_cfb.cfb12
	        LET l_cfc.cfc13 = l_cfb.cfb13
	        LET l_cfc.cfc14 = l_cfb.cfb14
	        LET l_cfc.cfc141 = l_cfb.cfb141
	        LET l_cfc.cfc142 = l_cfb.cfb142
	        LET l_cfc.cfc15 = l_cfb.cfb15
            
           ##先對表進行刪除操作，然後在insert，用意：相同條件多次拋轉
           #LET l_cnt = 0
           #SELECT count(*) INTO l_cnt FROM cfc_file
           # WHERE cfc00 = l_cfb.cfb00
           #   AND cfc01 = l_cfb.cfb01
	   #       AND cfc02 = l_cfb.cfb03
	   #       AND cfc03 = l_cfb.cfb04
	   #       AND cfc04 = l_cfb.cfb05
	   #       AND cfc05 = tm.yy
	   #       AND cfc06 = tm.mm
           #IF l_cnt = 1 THEN 
           #   DELETE FROM cfc_file
           #    WHERE cfc00 = l_cfb.cfb00
           #      AND cfc01 = l_cfb.cfb01
	   #          AND cfc02 = l_cfb.cfb03
	   #          AND cfc03 = l_cfb.cfb04
	   #          AND cfc04 = l_cfb.cfb05
	   #          AND cfc05 = tm.yy
	   #          AND cfc06 = tm.mm
           #END IF 
               
            #插入insert
            INSERT INTO cfc_file values(l_cfc.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=l_cfc.cfc00,"/",l_cfc.cfc01,"/",l_cfc.cfc02,
                             "/",l_cfc.cfc03,"/",l_cfc.cfc04,"/",l_cfc.cfc05,
                             "/",l_cfc.cfc06
               CALL s_errmsg('cfc00,cfc01,cfc02,cfc03,cfc04,cfc05,cfc06',g_showmsg,'ins_cfc',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         END FOREACH 
         
         #轉出資料
         INITIALIZE l_cfc.* TO NULL
         INITIALIZE l_cfb.* TO NULL 
         INITIALIZE l_cfb_out.* TO NULL
         FOREACH p201_cs_cfb_2 USING l_cfb00,l_cfb03,l_cfb04,l_cfb05,tm.mm,tm.yy INTO l_cfb_out.*  #add tm.yy#CHI-140414
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','',SQLCA.sqlcode,1)
               LET g_success='N' RETURN                             
            END IF
            #查詢出cfb的其他字段資料
            SELECT DISTINCT * INTO l_cfb.* FROM cfb_file 
             WHERE cfb00 = l_cfb_out.cfb00
               AND cfb01 = l_cfb_out.cfb01
               AND cfb03 = l_cfb_out.cfb03
               AND cfb04 = l_cfb_out.cfb04
               AND cfb05 = l_cfb_out.cfb05
               
            #cfb15重新赋值操作
            LET l_cfb.cfb15 = l_cfb_out.cfb15
            
            #赋值
            LET l_cfc.cfc00 = l_cfb.cfb00
            LET l_cfc.cfc01 = l_cfb.cfb01
	        LET l_cfc.cfc02 = l_cfb.cfb03
	        LET l_cfc.cfc03 = l_cfb.cfb04
	        LET l_cfc.cfc04 = l_cfb.cfb05
	        #LET l_cfc.cfc05 = tm.yy
	        #LET l_cfc.cfc06 = tm.mm #CHI-E40001
	        LET l_cfc.cfc05 = YEAR(l_cfb.cfb06) #CHI-E40001 add
	        LET l_cfc.cfc06 = MONTH(l_cfb.cfb06) #CHI-E40001 add
	        LET l_cfc.cfc07 = l_cfb.cfb07
	        LET l_cfc.cfc08 = l_cfb.cfb08
	        LET l_cfc.cfc09 = l_cfb.cfb09
	        LET l_cfc.cfc10 = l_cfb.cfb10
            LET l_cfc.cfc11 = l_cfb.cfb11
	        LET l_cfc.cfc12 = l_cfb.cfb12
	        LET l_cfc.cfc13 = l_cfb.cfb13
   	        LET l_cfc.cfc14 = l_cfb.cfb14
	        LET l_cfc.cfc141 = l_cfb.cfb141
	        LET l_cfc.cfc142 = l_cfb.cfb142
	        LET l_cfc.cfc15 = l_cfb.cfb15
            
            #先對表進行刪除操作，然後在insert，用意：相同條件多次拋轉
            LET l_cnt = 0
            SELECT count(*) INTO l_cnt FROM cfc_file
             WHERE cfc00 = l_cfb.cfb00
               AND cfc01 = l_cfb.cfb01
	           AND cfc02 = l_cfb.cfb03
	           AND cfc03 = l_cfb.cfb04
	           AND cfc04 = l_cfb.cfb05
	           #AND cfc05 = tm.yy #CHI-E40001
	           #AND cfc06 = tm.mm #CHI-E40001
	           AND cfc05 = YEAR(l_cfb.cfb06) #CHI-E40001
	           AND cfc06 = MONTH(l_cfb.cfb06) #CHI-E40001
            IF l_cnt = 1 THEN 
               DELETE FROM cfc_file
                WHERE cfc00 = l_cfb.cfb00
                  AND cfc01 = l_cfb.cfb01
	              AND cfc02 = l_cfb.cfb03
	              AND cfc03 = l_cfb.cfb04
	              AND cfc04 = l_cfb.cfb05
	              #AND cfc05 = tm.yy
	              #AND cfc06 = tm.mm #CHI-E40001
	              AND cfc05 = YEAR(l_cfb.cfb06) #CHI-E40001
	              AND cfc06 = MONTH(l_cfb.cfb06) #CHI-E40001
            END IF
               
            #插入cfc_file
            INSERT INTO cfc_file values(l_cfc.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=l_cfc.cfc00,"/",l_cfc.cfc01,"/",l_cfc.cfc02,
                             "/",l_cfc.cfc03,"/",l_cfc.cfc04,"/",l_cfc.cfc05,
                             "/",l_cfc.cfc06
               CALL s_errmsg('cfc00,cfc01,cfc02,cfc03,cfc04,cfc05,cfc06',g_showmsg,'ins_cfc',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         END FOREACH 
      END IF 
   END FOREACH 
END FUNCTION 
#FUN-C60036

#FUN-D70058--add--str--
FUNCTION p201_t()
   DEFINE l_date      LIKE type_file.dat,
          l_date_last LIKE type_file.dat,
          l_cnt       LIKE type_file.num10,
          l_wc        STRING
   DEFINE l_cfc       RECORD LIKE cfc_file.*
   
   #根據tm.mm和tm.yy組合出日期
   BEGIN WORK
   LET l_date=MDY(tm.mm,1,tm.yy)
   LET l_date_last = s_last(l_date)
   
   LET l_wc= cl_replace_str(g_wc,'cfb07','cfc07')
   LET l_wc= cl_replace_str(l_wc,'cfb11','cfc11')
   LET g_sql = "DELETE FROM cfc_file",
               " WHERE cfc05 = '",tm.yy,"'",
               "   AND cfc06 = '",tm.mm,"'",
               "   AND cfc01 = '1' ",  
               "   AND ",l_wc CLIPPED 
   PREPARE p201_del_pr FROM g_sql
   EXECUTE p201_del_pr
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('cfc05,cfc06','','DELETE cfc_file',SQLCA.sqlcode,1)
     LET g_success = 'N'
   END IF 
#CHI-E40001 add begin-------------------
#删除方向为-1的开票档案
   LET g_sql = "DELETE FROM cfc_file",
               " WHERE cfc21 = '",tm.yy,"'",
               "   AND cfc22 = '",tm.mm,"'",
               "   AND cfc01 = '-1' ",               
               "   AND ",l_wc CLIPPED 
   PREPARE p201_del3 FROM g_sql
   EXECUTE p201_del3
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('cfc05,cfc06','','DELETE cfc_file -1',SQLCA.sqlcode,1)
     LET g_success = 'N'
   END IF 
#CHI-E40001 add end-----------------------       
   #判斷有無符合條件之資料
   LET g_sql = " SELECT COUNT(*)  FROM cfb_file ",
               "  WHERE cfb06 <= '",l_date_last,"'",
               "    AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
               "    AND ",g_wc
   PREPARE p201_cnt_pr FROM g_sql
   LET l_cnt = 0 
   EXECUTE p201_cnt_pr INTO l_cnt
   IF l_cnt = 0 THEN 
      CALL s_errmsg('','','','aic-024',1)
      LET g_success = 'N' 
      RETURN
   END IF

   LET g_sql="INSERT INTO cfc_file(cfc00,cfc01,cfc02,cfc03,cfc04,cfc05,cfc06,",
             "                     cfc07,cfc11,cfc12,cfc17,cfc19,cfc21,cfc22,",
             "                     cfc15,cfc20) ", #TQC-D80012 add cfc20
             "SELECT cfb00,cfb01,cfb03,' ',0,YEAR(cfb06),MONTH(cfb06),",
             "       NVL(cfb07,' '),NVL(cfb11,' '),NVL(cfb12,' '),NVL(cfb17,' '),",
             "       NVL(cfb19,' '),NVL(YEAR(cfb061),0),NVL(MONTH(cfb061),0),",
             "       SUM(NVL(cfb15,0)),' '", #TQC-D80012 add ' '
             "  FROM cfb_file",
             " WHERE cfb06 <= '",l_date_last,"'",
            # "   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm, #CHI-E40001 mark
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add
             "   AND ",g_wc,
             " GROUP BY cfb00,cfb01,cfb03,YEAR(cfb06),MONTH(cfb06),cfb07,",
             "          cfb11,cfb12,cfb17,cfb19,YEAR(cfb061),MONTH(cfb061) "
   PREPARE p201_ins_pr FROM g_sql
   EXECUTE p201_ins_pr
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','ins cfc_file',SQLCA.sqlcode,1)
      LET g_success='N' RETURN  
   END IF
   IF SQLCA.SQLERRD[3]>0 THEN
      LET g_sql="UPDATE cfc_file SET cfc08=( ",
                "  SELECT DISTINCT cfb08 FROM cfb_file ",
                " WHERE (cfc07=cfb07 OR (cfc07=' ' AND cfb07 IS NULL)) ",
                "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06) ",
                "  AND cfb06 <= '",l_date_last,"'",
                #"   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add                
                "   AND ",g_wc," AND rownum<=1 )",
                #" WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add                
                "   AND ",l_wc
      PREPARE p201_upd_cfc08_pr FROM g_sql
      EXECUTE p201_upd_cfc08_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc08',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF
   
     LET g_sql=" UPDATE cfc_file SET cfc09=(",
               " SELECT DISTINCT cfb09 FROM cfb_file ",
               "  WHERE cfc00=cfb00 AND cfc01=cfb01 ",
               "   AND (cfc02=cfb03 OR (cfc02=' ' AND cfb03 IS NULL))",
               "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06)",
               "   AND (cfc07=cfb07 OR (cfc07=' ' AND cfb07 IS NULL))",
               "   AND (cfc11=cfb11 OR (cfc11=' ' AND cfb11 IS NULL))",
               "   AND (cfc12=cfb12 OR (cfc12=' ' AND cfb12 IS NULL))",
               "   AND (cfc17=cfb17 OR (cfc17=' ' AND cfb17 IS NULL))",
               "   AND (cfc19=cfb19 OR (cfc19=' ' AND cfb19 IS NULL))",
               "   AND (cfc21=YEAR(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND (cfc22=MONTH(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND cfb06 <= '",l_date_last,"'",
               #"   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add               
               "   AND ",g_wc," AND rownum<=1)",
               #" WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add
             "   AND ",l_wc
      PREPARE p201_upd_cfc09_pr FROM g_sql
      EXECUTE p201_upd_cfc09_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc09',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF
           
      LET g_sql=" UPDATE cfc_file SET cfc10=(",
               " SELECT DISTINCT cfb10 FROM cfb_file ",
               "  WHERE cfc00=cfb00 AND cfc01=cfb01 ",
               "   AND (cfc02=cfb03 OR (cfc02=' ' AND cfb03 IS NULL))",
               "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06)",
               "   AND (cfc07=cfb07 OR (cfc07=' ' AND cfb07 IS NULL))",
               "   AND (cfc11=cfb11 OR (cfc11=' ' AND cfb11 IS NULL))",
               "   AND (cfc12=cfb12 OR (cfc12=' ' AND cfb12 IS NULL))",
               "   AND (cfc17=cfb17 OR (cfc17=' ' AND cfb17 IS NULL))",
               "   AND (cfc19=cfb19 OR (cfc19=' ' AND cfb19 IS NULL))",
               "   AND (cfc21=YEAR(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND (cfc22=MONTH(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND cfb06 <= '",l_date_last,"'",
               #"   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add               
               "   AND ",g_wc," AND rownum<=1 )",
               #" WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",l_wc
      PREPARE p201_upd_cfc10_pr FROM g_sql
      EXECUTE p201_upd_cfc10_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc10',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF
           
      LET g_sql="UPDATE cfc_file SET cfc13=( ",
                "  SELECT DISTINCT cfb13 FROM cfb_file ",
                " WHERE (cfc11=cfb11 OR (cfc11=' ' AND cfb11 IS NULL)) ",
                "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06) ",
                "  AND cfb06 <= '",l_date_last,"'",
                #"   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add
                "   AND ",g_wc," AND rownum<=1 )",
               # " WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add
                "   AND ",l_wc
      PREPARE p201_upd_cfc13_pr FROM g_sql
      EXECUTE p201_upd_cfc13_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc13',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF
         
      LET g_sql=" UPDATE cfc_file SET cfc14=(",
               " SELECT DISTINCT cfb14 FROM cfb_file ",
               "  WHERE cfc00=cfb00 AND cfc01=cfb01 ",
               "   AND (cfc02=cfb03 OR (cfc02=' ' AND cfb03 IS NULL))",
               "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06)",
               "   AND (cfc07=cfb07 OR (cfc07=' ' AND cfb07 IS NULL))",
               "   AND (cfc11=cfb11 OR (cfc11=' ' AND cfb11 IS NULL))",
               "   AND (cfc12=cfb12 OR (cfc12=' ' AND cfb12 IS NULL))",
               "   AND (cfc17=cfb17 OR (cfc17=' ' AND cfb17 IS NULL))",
               "   AND (cfc19=cfb19 OR (cfc19=' ' AND cfb19 IS NULL))",
               "   AND (cfc21=YEAR(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND (cfc22=MONTH(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND cfb06 <= '",l_date_last,"'",
               #"   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add               
               "   AND ",g_wc," AND rownum<=1)",
               #" WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",l_wc
      PREPARE p201_upd_cfc14_pr FROM g_sql
      EXECUTE p201_upd_cfc14_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc14',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF

      LET g_sql=" UPDATE cfc_file SET cfc141=(",
               " SELECT DISTINCT cfb141 FROM cfb_file ",
               "  WHERE cfc00=cfb00 AND cfc01=cfb01 ",
               "   AND (cfc02=cfb03 OR (cfc02=' ' AND cfb03 IS NULL))",
               "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06)",
               "   AND (cfc07=cfb07 OR (cfc07=' ' AND cfb07 IS NULL))",
               "   AND (cfc11=cfb11 OR (cfc11=' ' AND cfb11 IS NULL))",
               "   AND (cfc12=cfb12 OR (cfc12=' ' AND cfb12 IS NULL))",
               "   AND (cfc17=cfb17 OR (cfc17=' ' AND cfb17 IS NULL))",
               "   AND (cfc19=cfb19 OR (cfc19=' ' AND cfb19 IS NULL))",
               "   AND (cfc21=YEAR(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND (cfc22=MONTH(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND cfb06 <= '",l_date_last,"'",
               #"   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",g_wc,"AND rownum<=1)",
               #" WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",l_wc
      PREPARE p201_upd_cfc141_pr FROM g_sql
      EXECUTE p201_upd_cfc141_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc141',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF
      
      LET g_sql=" UPDATE cfc_file SET cfc142=(",
               " SELECT DISTINCT cfb142 FROM cfb_file ",
               "  WHERE cfc00=cfb00 AND cfc01=cfb01 ",
               "   AND (cfc02=cfb03 OR (cfc02=' ' AND cfb03 IS NULL))",
               "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06)",
               "   AND (cfc07=cfb07 OR (cfc07=' ' AND cfb07 IS NULL))",
               "   AND (cfc11=cfb11 OR (cfc11=' ' AND cfb11 IS NULL))",
               "   AND (cfc12=cfb12 OR (cfc12=' ' AND cfb12 IS NULL))",
               "   AND (cfc17=cfb17 OR (cfc17=' ' AND cfb17 IS NULL))",
               "   AND (cfc19=cfb19 OR (cfc19=' ' AND cfb19 IS NULL))",
               "   AND (cfc21=YEAR(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND (cfc22=MONTH(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND cfb06 <= '",l_date_last,"'",
               #"   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",g_wc,"AND rownum<=1)",
               #" WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",l_wc
      PREPARE p201_upd_cfc142_pr FROM g_sql
      EXECUTE p201_upd_cfc142_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc142',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF
      
    LET g_sql=" UPDATE cfc_file SET cfc18=(",
               " SELECT DISTINCT cfb18 FROM cfb_file ",
               "  WHERE cfc00=cfb00 AND cfc01=cfb01 ",
               "   AND (cfc02=cfb03 OR (cfc02=' ' AND cfb03 IS NULL))",
               "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06)",
               "   AND (cfc07=cfb07 OR (cfc07=' ' AND cfb07 IS NULL))",
               "   AND (cfc11=cfb11 OR (cfc11=' ' AND cfb11 IS NULL))",
               "   AND (cfc12=cfb12 OR (cfc12=' ' AND cfb12 IS NULL))",
               "   AND (cfc17=cfb17 OR (cfc17=' ' AND cfb17 IS NULL))",
               "   AND (cfc19=cfb19 OR (cfc19=' ' AND cfb19 IS NULL))",
               "   AND (cfc21=YEAR(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND (cfc22=MONTH(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND cfb06 <= '",l_date_last,"'",
               #"   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",g_wc," AND rownum<=1)",
#               " WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",l_wc
      PREPARE p201_upd_cfc18_pr FROM g_sql
      EXECUTE p201_upd_cfc18_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc18',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF
           
      LET g_sql=" UPDATE cfc_file SET cfc20=(",
               " SELECT DISTINCT cfb20 FROM cfb_file ",
               "  WHERE cfc00=cfb00 AND cfc01=cfb01 ",
               "   AND (cfc02=cfb03 OR (cfc02=' ' AND cfb03 IS NULL))",
               "   AND cfc05=YEAR(cfb06) AND cfc06=MONTH(cfb06)",
               "   AND (cfc07=cfb07 OR (cfc07=' ' AND cfb07 IS NULL))",
               "   AND (cfc11=cfb11 OR (cfc11=' ' AND cfb11 IS NULL))",
               "   AND (cfc12=cfb12 OR (cfc12=' ' AND cfb12 IS NULL))",
               "   AND (cfc17=cfb17 OR (cfc17=' ' AND cfb17 IS NULL))",
               "   AND (cfc19=cfb19 OR (cfc19=' ' AND cfb19 IS NULL))",
               "   AND (cfc21=YEAR(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND (cfc22=MONTH(cfb061) OR (cfc21=0 AND cfb061 IS NULL))",
               "   AND cfb06 <= '",l_date_last,"'",
#               "   AND YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,
             "    AND ((YEAR(cfb06)=",tm.yy," AND MONTH(cfb06)=",tm.mm,") OR (YEAR(cfb061)=",tm.yy," AND MONTH(cfb061)=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",g_wc,
               "   AND rownum<=1 )",
#               " WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "    WHERE ((cfc05=",tm.yy," AND cfc06=",tm.mm,") OR (cfc21=",tm.yy," AND cfc22=",tm.mm,"))",  #CHI-E40001 add
               "   AND ",l_wc
      PREPARE p201_upd_cfc20_pr FROM g_sql
      EXECUTE p201_upd_cfc20_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc20',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF
         
      #zhouxm160112 add start
           LET g_sql=" UPDATE cfc_file SET cfc05 = '2015' ,cfc06 = '5' ",
             "    WHERE cfc21=",tm.yy," AND cfc22=",tm.mm," AND (cfc05 <'2015' OR (cfc05='2015' AND cfc06<4)) "
      PREPARE p201_upd_cfcZZ_pr FROM g_sql
      EXECUTE p201_upd_cfcZZ_pr
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd cfc05',SQLCA.sqlcode,1)
         LET g_success='N' RETURN  
      END IF    
    #zhouxm160112 add end      

   END IF
END FUNCTION 
#FUN-D70058--add--end
