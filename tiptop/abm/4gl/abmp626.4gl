# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmp626.4gl
# Date & Author..: 2008/10/13 #No.FUN-870117 By ve007 
# modify.........: 2008/10/29 #NO.FUN-8A0129 by ve007 修改單別只能為3碼的問題 
# modify.........: 2008/10/31 #NO.FUN-8A0145 by arman 
# Modify.........: No.FUN-8A0151 08/11/01 By Carrier 自動編號錯誤
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70125 10/07/26 By lilingyu 平行工藝
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used（2）
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          bmz01           LIKE bmz_file.bmz01,
          bmz02           LIKE bmz_file.bmz02,
          a3              LIKE type_file.chr20
          END RECORD,
          g_argv1         LIKE bma_file.bma01,
          g_bmz           RECORD  LIKE  bmz_file.*,
          g_bmx           RECORD  LIKE  bmx_file.*,
          g_bmy           RECORD  LIKE  bmy_file.*,
          g_ima           RECORD  LIKE  ima_file.*
DEFINE    g_ima01         LIKE ima_file.ima01
DEFINE    l_ps            LIKE sma_file.sma46
DEFINE    g_chr           LIKE type_file.chr1
DEFINE    g_cnt           LIKE type_file.num10,   #No.FUN-8A0145
          g_cmd           LIKE type_file.chr100   
DEFINE    g_msg           LIKE type_file.chr100,
          l_flag          LIKE type_file.chr1,
          g_change_lang   LIKE type_file.chr1 
DEFINE    g_sma118        LIKE sma_file.sma118 
DEFINE    g_t1            LIKE type_file.chr5   #No.FUN-8A0151
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF

   IF s_shut(0) THEN
      DISPLAY "INFO: System Closed"
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   CALL p626_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p626_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5, #NO.FUN-8A0145 
            l_flag        LIKE type_file.num10   #NO.FUN-8A0145 
   DEFINE   l_n           LIKE type_file.num5 
   DEFINE li_result       LIKE type_file.num5   #NO.FUN-8A0145  
 
   OPEN WINDOW p626_w WITH FORM "abm/42f/abmp999" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

    SELECT sma118 INTO g_sma118 FROM sma_file         
    CALL cl_set_comp_visible("a3",g_sma118='Y')

   WHILE TRUE
      CLEAR FORM 
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      INITIALIZE tm.* TO NULL			# Default condition
      INPUT BY NAME tm.bmz01,tm.bmz02,tm.a3 WITHOUT DEFAULTS 
 
         AFTER FIELD bmz01
            IF tm.bmz01 IS NULL OR tm.bmz01 = ' ' THEN
               NEXT FIELD bmz01
            ELSE
               SELECT COUNT(*) FROM bmz_file
                  WHERE bmz01 = tm.bmz01
               IF sqlca.sqlcode <> 0 THEN
                  CALL cl_err(tm.bmz01,'apj-011',0)
                  NEXT FIELD bmz01
               END IF
            END IF
            
         AFTER FIELD bmz02
            IF tm.bmz02 IS NULL OR tm.bmz02 = ' ' THEN 
               NEXT FIELD bmz02
            ELSE 
               CALL p626_bmz02()
               IF g_chr = 'E' THEN 
                  CALL cl_err(tm.bmz02,'mfg0002',0)
                  NEXT FIELD bmz02
               END IF
               SELECT COUNT(*) FROM bma_file
                  WHERE bma01 = tm.bmz02
                    AND bma05 IS NOT NULL
               IF sqlca.sqlcode <> 0 THEN
                  CALL cl_err(tm.bmz02,'apj-011',0)
                  NEXT FIELD bmz02
               END IF
            END IF
            
         AFTER FIELD a3
         LET l_n = 0 
         IF NOT cl_null(tm.a3)  THEN
            SELECT COUNT(*)  INTO l_n FROM bma_file 
              WHERE bma01 = tm.bmz02   
                AND (bma05 IS NOT NULL AND bma05<=g_today)
                AND bma06=tm.a3
             IF l_n <= 0 THEN
                      CALL cl_err('','abm-618',0)
                      NEXT FIELD a3
             END IF          
         END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
	          CALL cl_cmdask()
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bmz01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bmx1"
                    LET g_qryparam.default1 = tm.bmz01
                    CALL cl_create_qry() RETURNING tm.bmz01
                    DISPLAY BY NAME tm.bmz01
                    NEXT FIELD bmz01
               WHEN INFIELD(bmz02)
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = tm.bmz02 
                 #   CALL cl_create_qry() RETURNING tm.bmz02
                    CALL q_sel_ima(FALSE, "q_ima", "", tm.bmz02, "", "", "", "" ,"",'' )  RETURNING tm.bmz02 
#FUN-AA0059 --End--
                    DISPLAY BY NAME tm.bmz02
                    NEXT FIELD bmz02
               WHEN INFIELD(a3) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_a3'
                    LET g_qryparam.arg1 = tm.bmz02 
                    LET g_qryparam.arg2 = g_today
                    CALL cl_create_qry() RETURNING tm.a3
                    DISPLAY BY NAME tm.a3 
                    NEXT FIELD a3
               OTHERWISE EXIT CASE
             END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about        
            CALL cl_about()    
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                 
            LET g_change_lang = TRUE
            EXIT INPUT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
      IF g_change_lang = TRUE THEN
          CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
      
      LET INT_FLAG = 0 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
         EXIT PROGRAM 
      END IF
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM bmz_file
          WHERE bmz01 = tm.bmz01 AND bmz02 = tm.bmz02
      IF g_cnt <= 0 THEN
         CALL cl_err(tm.bmz01,'apj-011',0)
         CONTINUE WHILE
      END IF
      
      CALL p626_create_pbmb_file()  
      CALL p626_create_tbmt_file()
      CALL p626_create_tbmb1_file()
      CALL p626_create_tbok_file()                         
      CALL p626_create_tbmb_file() 
    
      BEGIN WORK
      IF cl_sure(20,22) THEN
      CALL abmp626_bom(tm.bmz02,tm.a3)
      IF g_success ='N' THEN 
         ROLLBACK WORK 
         RETURN 
      END IF    
         CALL cl_wait()
         CALL abmp626()
         IF g_success = 'Y' THEN
            COMMIT WORK
            LET g_msg = g_bmx.bmx01 CLIPPED
            CALL cl_err(g_msg,'mfg0101',1) 
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN
            CLEAR FORM
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW p626_w

END FUNCTION
 
FUNCTION abmp626()
  DEFINE  
          #l_sql,l_sql1,l_sql2  LIKE type_file.chr1000,	
          l_sql,l_sql1,l_sql2       STRING,      #NO.FUN-910082        
          l_buf  LIKE type_file.chr100, 		         
          l_buf2 LIKE type_file.chr100, 		        
          l_message     LIKe type_file.chr200,           
          l_cnt1,l_cnt2	LIKE type_file.num10   #NO.FUN-8A0145   		
  DEFINE  j,k,i,x       LIKE type_file.num10   #NO.FUN-8A0145 
  DEFINE  l_str         LIKE type_file.chr50,        #No.FUN-8A0145
          l_tax         LIKE type_file.chr50,        #No.FUN-8A0145
          l_col         LIKE type_file.chr50,        #No.FUN-8A0145
          l_item        LIKE type_file.chr50,        #No.FUN-8A0145
          l_size        LIKE type_file.chr50,        #No.FUN-8A0145
          l_tax_desc    LIKE type_file.chr50,        #No.FUN-8A0145
          l_col_desc    LIKE type_file.chr50,        #No.FUN-8A0145
          l_item_desc   LIKE type_file.chr50,        #No.FUN-8A0145
          l_size_desc   LIKE type_file.chr50,        #No.FUN-8A0145
          l_j           LIKE type_file.num5
   DEFINE li_result     LIKE type_file.num5
   DEFINE l_taxb         LIKE type_file.chr50,        #No.FUN-8A0145
          l_colb         LIKE type_file.chr50,        #No.FUN-8A0145
          l_sizeb        LIKE type_file.chr50,        #No.FUN-8A0145
          l_taxb_desc    LIKE type_file.chr50,        #No.FUN-8A0145
          l_colb_desc    LIKE type_file.chr50,        #No.FUN-8A0145
          l_sizeb_desc   LIKE type_file.chr50,        #No.FUN-8A0145
          l_ta_agd001_m  LIKE type_file.num5,
          l_ta_agd001    LIKE type_file.num5,
          l_agd03        LIKE agd_file.agd03,
          l_b            LIKE ima_file.ima02,
          l_bmb03        LIKE bmb_file.bmb03,
          l_imaag        LIKE ima_file.imaag,
          l_imaag2       LIKE ima_file.imaag,
          l_agb03_1       LIKE agb_file.agb03,
          l_agb03_2       LIKE agb_file.agb03,
          l_agb03_3       LIKE agb_file.agb03
 
  DEFINE  l_ima_b   RECORD LIKE ima_file.*,
          l_bma     RECORD LIKE bma_file.*,
          l_bmb     RECORD LIKE bmb_file.*,
          l_pbmb    RECORD LIKE bmb_file.*,
          l_bmb2    RECORD LIKE bmb_file.*,
          l_pbmb2   RECORD LIKE bmb_file.*,
          l_imx     RECORD LIKE imx_file.*,
          g_bmt     RECORD LIKE bmt_file.*,
          l_bmz02   LIKE bmz_file.bmz02,
          l_cnt     LIKE type_file.num5,   #NO.FUN-8A0145  
          l_flag    LIKE type_file.chr1, #No.FUN-8A0145  #判斷是否修改料號資料
          l_flag3   LIKE type_file.chr1, #No.FUN-8A0145     #判斷是否要新增bmx_file
          l_flag2   LIKE type_file.chr1, #No.FUN-8A0145    #判斷是否為新增料號
          l_flag4   LIKE type_file.chr1, #No.FUN-8A0145    #判斷是否需無效料號
          l_flag5   LIKE type_file.chr1  #No.FUN-8A0145      #產生ECN    
  DEFINE  l_tbmt    RECORD LIKE bmt_file.*  
  DEFINE  l_success LIKE type_file.chr1  
  DEFINE  l_n       LIKE type_file.num5
  DEFINE  l_i1      LIKE type_file.num5   #No.FUN-8A0129
  DEFINE  l_bmx01   string                #No.FUN-8A0129
      #產生臨時BOM 
 
      LET l_flag3 = 'N'
      SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01=tm.bmz01
      SELECT * INTO g_bmz.* FROM bmz_file 
         WHERE bmz01=tm.bmz01 AND bmz02 = tm.bmz02 
         
       #No.FUN-8A0151  --Begin
#       LET l_bmx01 = g_bmx.bmx01                   #No.FUN-8A0129
#       LET l_i1 = l_bmx01.getIndexOf('-',1)    #No.FUN-8A0129
##       CALL s_auto_assign_no("abm",g_bmx.bmx01[1,4],g_today,"1","bmx_file","bmx01","","","")
#       CALL s_auto_assign_no("abm",g_bmx.bmx01[1,l_i1],g_today,"1","bmx_file","bmx01","","","")      #No.FUN-8A0129
#	                      RETURNING li_result,g_bmx.bmx01
       LET g_t1 = g_bmx.bmx01[1,g_doc_len]
       CALL s_auto_assign_no("abm",g_t1,g_today,"1","bmx_file","bmx01","","","")      #No.FUN-8A0129
	                      RETURNING li_result,g_bmx.bmx01
       #No.FUN-8A0151  --End  
	     LET g_bmx.bmx02  =TODAY
	     LET g_bmx.bmx07  =TODAY  
	     LET g_bmx.bmx04  ='N'
	     LET g_bmx.bmx06  ='2'    
	     LET g_bmx.bmxuser=g_user
	     LET g_bmx.bmxgrup=g_grup
	     LET g_bmx.bmxdate=g_today
	     LET g_bmx.bmxacti='Y'
	     LET g_bmx.bmx09='0'   
 
             #FUN-980001 add plant & legal 
             LET g_bmx.bmxplant = g_plant 
             LET g_bmx.bmxlegal = g_legal 
             #FUN-980001 end
             
	     LET g_bmx.bmxoriu = g_user      #No.FUN-980030 10/01/04
	     LET g_bmx.bmxorig = g_grup      #No.FUN-980030 10/01/04
	     INSERT INTO bmx_file VALUES (g_bmx.*)
	     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
	        CALL cl_err('ins bmx: ',SQLCA.SQLCODE,1)
	        LET g_success = 'N'
	        RETURN
	     END IF   
      #抓取款式料號的所有明細料號
      LET l_sql = "SELECT UNIQUE imx000 FROM imx_file,bma_file ",  
                  "  WHERE imx00='",tm.bmz02,"'",
                  "  AND length(imx000) > 8 ",
                  "  AND bma01 = imx000 ",
                  "  AND bma06 = '",tm.a3,"' "           
      PREPARE p626_precount3 FROM l_sql
      DECLARE p626_count3 CURSOR FOR p626_precount3
    
      #按每一個明細主件料號進行處理
      LET l_flag3 = 'N' 
      FOREACH p626_count3 INTO l_bmz02
          
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM bmy_file,bmx_file
             WHERE bmx04 = 'N'
               AND bmx01 = bmy01
               AND bmy14 = l_bmz02
          IF l_cnt > 0 THEN
             CALL cl_err(l_bmz02,'abm-031',1)
             LET g_success = 'N'
             RETURN
          END IF
          
          CALL p626_ins_bmb1(l_bmz02) RETURNING l_success 
          IF l_success ='N' THEN 
             LET g_success ='N' 
             RETURN 
          END IF 
      END FOREACH    
              
          #抓取明細料號的BOM資料 
          LET l_sql1 = "SELECT * FROM tbmb1_file"      
  
          #抓取臨時BOM資料
          LET l_sql2 = "SELECT * FROM pbmb_file"  
          #組合SQL            
          LET l_sql = "SELECT * FROM ( ", l_sql1," ) tbmb1_file full join ( ",l_sql2," ) pbmb_file",
                      " on tbmb01 = pbmb01 AND tbmb03 = pbmb03 AND tbmb09 = pbmb09 ",
                      " ORDER BY tbmb03,pbmb03,tbmb09,pbmb09 "                    
                                        
                     
          PREPARE p626_precount2 FROM l_sql
          DECLARE p626_count2 CURSOR FOR p626_precount2
          
         
          FOREACH p626_count2 INTO l_bmb.*,l_pbmb.*
             LET l_flag2 = 'N'
             LET l_flag = 'N'
             LET l_flag4 = 'N'             
             LET l_flag5 = 'N'
             IF l_bmb.bmb09 LIKE 'WK003%' OR
                l_pbmb.bmb09 LIKE 'WK003%' THEN
             	  CONTINUE FOREACH
             END IF         
             INITIALIZE g_bmy.* TO NULL
                 #作業編號
                 IF cl_null(l_bmb.bmb09) THEN 
                 	  LET l_bmb.bmb09 = ' ' 
                 END IF
                 IF cl_null(l_pbmb.bmb09) THEN 
                 	  LET l_pbmb.bmb09 = ' ' 
                 END IF
                 
                 #料號
                 IF cl_null(l_bmb.bmb03) THEN 
                 	  LET l_bmb.bmb03 = ' ' 
                 END IF
                 IF cl_null(l_pbmb.bmb03) THEN 
                 	  LET l_pbmb.bmb03 = ' ' 
                 END IF                 
                 
                 IF l_bmb.bmb03 = l_pbmb.bmb03 AND l_bmb.bmb09 = l_pbmb.bmb09 THEN
                    #組成用量
                    IF l_bmb.bmb06 != l_pbmb.bmb06  THEN     
                       LET g_bmy.bmy06 = l_pbmb.bmb06
                       LET l_flag = 'Y'
                    ELSE
                       LET g_bmy.bmy06 = l_bmb.bmb06
                    END IF
                    #底數
                    IF l_bmb.bmb07 != l_pbmb.bmb07  THEN     
                       LET g_bmy.bmy07 = l_pbmb.bmb07
                       LET l_flag = 'Y'
                    ELSE
                       LET g_bmy.bmy07 = l_bmb.bmb07
                    END IF
                    #損耗率
                    IF l_bmb.bmb08 != l_pbmb.bmb08 THEN     
                       LET g_bmy.bmy08 = l_pbmb.bmb08
                       LET l_flag = 'Y'
                    ELSE
                       LET g_bmy.bmy08 = l_bmb.bmb08
                    END IF
                    #發料單位
                    IF l_bmb.bmb10 != l_pbmb.bmb10 THEN
                       LET g_bmy.bmy10 = l_pbmb.bmb10
                       LET g_bmy.bmy10_fac = l_pbmb.bmb10_fac
                       LET g_bmy.bmy10_fac2 = l_pbmb.bmb10_fac2
                       LET l_flag = 'Y' 
                    ELSE 
                       LET g_bmy.bmy10 = l_bmb.bmb10
                       LET g_bmy.bmy10_fac = l_bmb.bmb10_fac
                       LET g_bmy.bmy10_fac2 = l_bmb.bmb10_fac2
                    END IF
                  #工程圖號
                  IF l_bmb.bmb11 != l_pbmb.bmb11 THEN 
                     LET g_bmy.bmy11 = l_pbmb.bmb11
                     LET l_flag = 'Y' 
                  ELSE
                     LET g_bmy.bmy11 = l_bmb.bmb11
                  END IF
                  #插件位置
                  IF l_bmb.bmb13 != l_pbmb.bmb13 THEN
                     LET g_bmy.bmy13 = l_pbmb.bmb13
                     LET l_flag = 'Y'
                  ELSE
                     LET g_bmy.bmy13 = l_bmb.bmb13 
                  END IF
                  
                  #add by grissom on 2007.04.12
                  #展開選項設定
                  IF l_bmb.bmb19 != l_pbmb.bmb19 THEN 
                     LET g_bmy.bmy20 = l_pbmb.bmb19
                     LET l_flag = 'Y' 
                  ELSE
                     LET g_bmy.bmy20 = l_bmb.bmb19
                  END IF   
                  #end add
                                                          
                  #消耗件否                    
                  IF l_bmb.bmb15 != l_pbmb.bmb15 THEN 
                     LET g_bmy.bmy21 = l_pbmb.bmb15
                     LET l_flag = 'Y' 
                  ELSE
                      LET g_bmy.bmy21 = l_bmb.bmb15
                  END IF
                  #替代特性
                  IF l_bmb.bmb16 != l_pbmb.bmb16 THEN
                    LET g_bmy.bmy16 = l_pbmb.bmb16
                    LET l_flag = 'Y' 
                  ELSE
                    LET g_bmy.bmy16 = l_bmb.bmb16
                  END IF
                  #供貨方式
 
                  LET g_bmy.bmy03 = '3'
                  LET g_bmy.bmy05 = l_bmb.bmb03
                  LET g_bmy.bmy14 = l_bmb.bmb01
                  LET g_bmy.bmy18 = 0
                  LET g_bmy.bmy23 = 0
	                LET g_bmy.bmy29 = l_bmb.bmb29
                  LET g_bmy.bmy30 = l_bmb.bmb30
                  LET g_bmy.bmy33 = l_pbmb.bmb02 
                END IF 
                
                #失效
                IF l_bmb.bmb03 != l_pbmb.bmb03 AND l_pbmb.bmb03 = ' ' THEN
                  SELECT COUNT(*) INTO l_n FROM imx_file WHERE imx00 = tm.bmz02 AND imx000 = l_bmb.bmb01
                  IF l_n >0 THEN  
	                  LET l_flag4 = 'Y'	                  
	                  LET g_bmy.bmy03 = '1'
	                  LET g_bmy.bmy05 = l_bmb.bmb03	                  
	                  LET g_bmy.bmy06 = l_bmb.bmb06
	                  LET g_bmy.bmy07 = l_bmb.bmb07
	                  LET g_bmy.bmy08 = l_bmb.bmb08
	                  LET g_bmy.bmy09 = l_bmb.bmb09
	                  LET g_bmy.bmy10 = l_bmb.bmb10
	                  LET g_bmy.bmy10_fac = l_bmb.bmb10_fac
	                  LET g_bmy.bmy10_fac2 = l_bmb.bmb10_fac2
	                  LET g_bmy.bmy11 = l_bmb.bmb11
	                  LET g_bmy.bmy13 = l_bmb.bmb13         
	                  LET g_bmy.bmy14 = l_bmb.bmb01
	                  LET g_bmy.bmy16 = l_bmb.bmb16
	                  LET g_bmy.bmy20 = l_bmb.bmb19
	                  LET g_bmy.bmy21 = l_bmb.bmb15
	                  LET g_bmy.bmy18 = 0
	                  LET g_bmy.bmy23 = 0
	                  LET g_bmy.bmy29 = l_bmb.bmb29                  
	                  LET g_bmy.bmy30 = l_bmb.bmb30                	
                    LET g_bmy.bmy33 = l_bmb.bmb02  
                  END IF         
                END IF
 
                IF l_bmb.bmb03 != l_pbmb.bmb03 AND l_bmb.bmb03 = ' ' THEN
	                  LET l_flag2 = 'Y'	                  
	                  LET g_bmy.bmy03 = '2'
	                  LET g_bmy.bmy05 = l_pbmb.bmb03	                  
	                  LET g_bmy.bmy06 = l_pbmb.bmb06
	                  LET g_bmy.bmy07 = l_pbmb.bmb07
	                  LET g_bmy.bmy08 = l_pbmb.bmb08
	                  LET g_bmy.bmy09 = l_pbmb.bmb09	                  
	                  LET g_bmy.bmy10 = l_pbmb.bmb10
	                  LET g_bmy.bmy10_fac = l_pbmb.bmb10_fac
	                  LET g_bmy.bmy10_fac2 = l_pbmb.bmb10_fac2
	                  LET g_bmy.bmy11 = l_pbmb.bmb11
	                  LET g_bmy.bmy13 = l_pbmb.bmb13         
	                  LET g_bmy.bmy14 = l_pbmb.bmb01	                  
	                  LET g_bmy.bmy20 = l_pbmb.bmb19
	                  LET g_bmy.bmy21 = l_pbmb.bmb15
	                  LET g_bmy.bmy16 = l_pbmb.bmb16
	                  LET g_bmy.bmy18 = 0
	                  LET g_bmy.bmy23 = 0
	                  LET g_bmy.bmy29 = l_pbmb.bmb29                       
	                  LET g_bmy.bmy30 = l_pbmb.bmb30                	
                    LET g_bmy.bmy33 = l_pbmb.bmb02                
                END IF                
                
	        IF l_flag = 'Y' OR l_flag2 = 'Y' OR l_flag4 = 'Y' THEN
	           LET l_flag5 = 'Y'
	        END IF      
	              
	              
	              #寫入bmy_file
	        IF l_flag5 = 'Y' THEN
	           LET g_bmy.bmy01 = g_bmx.bmx01
	           SELECT max(bmy02)+1 INTO g_bmy.bmy02
	             FROM bmy_file WHERE bmy01 = g_bmx.bmx01
	           IF g_bmy.bmy02 IS NULL THEN
	              LET g_bmy.bmy02 = 1
                   END IF
                   IF g_bmy.bmy29 IS NULL THEN
                      LET g_bmy.bmy29 = ' '
                   END IF 
  
                   #FUN-980001 add plant & legal 
                   LET g_bmy.bmyplant = g_plant 
                   LET g_bmy.bmylegal = g_legal 
                   #FUN-980001 end
             
#FUN-A70125 --begin--
                  IF cl_null(g_bmy.bmy012) THEN 
                     LET g_bmy.bmy012 = ' ' 
                  END IF 
                  IF cl_null(g_bmy.bmy013) THEN 
                     LET g_bmy.bmy013 = 0 
                  END IF 
#FUN-A70125 --end--
                   INSERT INTO bmy_file VALUES (g_bmy.*)
                   IF SQLCA.SQLCODE THEN
                      CALL cl_err('ins bmy:',SQLCA.SQLCODE,1)
                      LET g_success = 'N'
                      RETURN 
                   END IF	   
                   DECLARE p626_tbmt_curs
                      CURSOR FOR (SELECT * FROM tbmt_file WHERE tbmt01 = l_pbmb.bmb01 
		       AND tbmt02 = l_pbmb.bmb02
		       AND tbmt03 = l_pbmb.bmb03
		       AND tbmt04 = l_pbmb.bmb04
		       AND tbmt08 = l_pbmb.bmb29) 
                   FOREACH p626_tbmt_curs INTO l_tbmt.* 
                      IF SQLCA.sqlcode THEN 
                         CALL s_errmsg('','','p626_tbmt_curs',SQLCA.sqlcode,1)
                         CONTINUE FOREACH                                                       
                      END IF 
 
	              INSERT INTO bmw_file VALUES (g_bmx.bmx01,g_bmy.bmy02,l_tbmt.bmt05,l_tbmt.bmt06,l_tbmt.bmt07 ,
                                                   g_plant,g_legal)  #FUN-980001 add plant & legal 
    	              IF SQLCA.SQLCODE THEN
		         CALL cl_err('ins bmw:',SQLCA.SQLCODE,1)
		         LET g_success = 'N'
		         RETURN 
		      END IF	
	           END FOREACH 
		END IF
              END FOREACH                  
END FUNCTION
   
FUNCTION p626_bmz02()
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima05   LIKE ima_file.ima05,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_chr = ' '
    IF tm.bmz01 IS NULL THEN
        LET l_ima02=NULL
        LET l_ima021=NULL
        LET l_ima05=NULL
        LET g_chr = 'E'
    ELSE
        SELECT  ima02,ima021,ima05,imaacti
           INTO l_ima02,l_ima021,l_ima05,l_imaacti
           FROM ima_file WHERE ima01 = tm.bmz02
           AND (imaag IS NOT NULL AND imaag <> '@CHILD') 
        IF SQLCA.sqlcode THEN
           LET g_chr = 'E'
           LET l_ima02 = NULL
           LET l_ima021= NULL
           LET l_ima05 = NULL
        ELSE
           IF l_imaacti='N' THEN
              LET g_chr = 'E'
           END IF
        END IF
    END IF
    DISPLAY l_ima02 TO FORMONLY.ima02 
    DISPLAY l_ima021 TO FORMONLY.ima021 
    DISPLAY l_ima05 TO FORMONLY.ima05 
END FUNCTION
 
FUNCTION p626_create_pbmb_file()
 DROP TABLE pbmb_file
 DROP INDEX pbmb_01
 CREATE TEMP TABLE pbmb_file(
      pbmb01 LIKE bmb_file.bmb01,
      pbmb02 LIKE bmb_file.bmb02,
      pbmb03 LIKE bmb_file.bmb03, 
      pbmb04 LIKE bmb_file.bmb04,
      pbmb05 LIKE bmb_file.bmb05, 
      pbmb06 LIKE bmb_file.bmb06,
      pbmb07 LIKE bmb_file.bmb07,  
      pbmb08 LIKE bmb_file.bmb08, 
      pbmb09 LIKE bmb_file.bmb09, 
      pbmb10 LIKE bmb_file.bmb10,
      pbmb10_fac LIKE bmb_file.bmb10_fac, 
      pbmb10_fac2 LIKE bmb_file.bmb10_fac2,
      pbmb11 LIKE bmb_file.bmb11,
      pbmb13 LIKE bmb_file.bmb13,
      pbmb14 LIKE bmb_file.bmb14,
      pbmb15 LIKE bmb_file.bmb15,
      pbmb16 LIKE bmb_file.bmb16,
      pbmb17 LIKE bmb_file.bmb17,
      pbmb18 LIKE bmb_file.bmb18,
      pbmb19 LIKE bmb_file.bmb19,
      pbmb20 LIKE bmb_file.bmb20,
      pbmb21 LIKE bmb_file.bmb21,
      pbmb22 LIKE bmb_file.bmb22,
      pbmb23 LIKE bmb_file.bmb23,
      pbmb24 LIKE bmb_file.bmb24,
      pbmb25 LIKE bmb_file.bmb25,
      pbmb26 LIKE bmb_file.bmb26,
      pbmb27 LIKE bmb_file.bmb27,
      pbmb28 LIKE bmb_file.bmb28,
      pbmbmodu LIKE bmb_file.bmbmodu,
      pbmbdate LIKE bmb_file.bmbdate,  
      pbmbcomm LIKE bmb_file.bmbcomm,
      pbmb29 LIKE bmb_file.bmb29,
      pbmb30 LIKE bmb_file.bmb30,
      pbmb31 LIKE bmb_file.bmb31);
 
create unique index pbmb_01 on pbmb_file(pbmb01,pbmb02,pbmb03,pbmb04,pbmb29);
END FUNCTION 
 
FUNCTION p626_create_tbmb1_file()
 DROP TABLE tbmb1_file
 DROP INDEX tbmb1_pk
 CREATE TEMP TABLE tbmb1_file(
    tbmb01       LIKE bmb_file.bmb01,
    tbmb02       LIKE bmb_file.bmb02,
    tbmb03       LIKE bmb_file.bmb03,
    tbmb04       LIKE bmb_file.bmb04,
    tbmb05       LIKE bmb_file.bmb05,
    tbmb06       LIKE bmb_file.bmb06,
    tbmb07       LIKE bmb_file.bmb07,
    tbmb08       LIKE bmb_file.bmb08,
    tbmb09       LIKE bmb_file.bmb09,
    tbmb10       LIKE bmb_file.bmb10,
    tbmb10_fac   LIKE bmb_file.bmb10_fac,
    tbmb10_fac2  LIKE bmb_file.bmb10_fac2,
    tbmb11       LIKE bmb_file.bmb11,
    tbmb13       LIKE bmb_file.bmb13,
    tbmb14       LIKE bmb_file.bmb14,
    tbmb15       LIKE bmb_file.bmb15,
    tbmb16       LIKE bmb_file.bmb16,
    tbmb17       LIKE bmb_file.bmb17,
    tbmb18       LIKE bmb_file.bmb18,
    tbmb19       LIKE bmb_file.bmb19,
    tbmb20       LIKE bmb_file.bmb20,
    tbmb21       LIKE bmb_file.bmb21,
    tbmb22       LIKE bmb_file.bmb22,
    tbmb23       LIKE bmb_file.bmb23,
    tbmb24       LIKE bmb_file.bmb24,
    tbmb25       LIKE bmb_file.bmb25,
    tbmb26       LIKE bmb_file.bmb26,
    tbmb27       LIKE bmb_file.bmb27,
    tbmb28       LIKE bmb_file.bmb28,
    tbmbmodu     LIKE bmb_file.bmbmodu,
    tbmbdate     LIKE bmb_file.bmbdate,
    tbmbcomm     LIKE bmb_file.bmbcomm,
    tbmb29       LIKE bmb_file.bmb29,
    tbmb30       LIKE bmb_file.bmb30,
    tbmb31       LIKE bmb_file.bmb31,
    tbmb33       LIKE bmb_file.bmb33,
    tbmbud01     LIKE bmb_file.bmbud01,
    tbmbud02     LIKE bmb_file.bmbud02,
    tbmbud03     LIKE bmb_file.bmbud03,
    tbmbud04     LIKE bmb_file.bmbud04,
    tbmbud05     LIKE bmb_file.bmbud05,
    tbmbud06     LIKE bmb_file.bmbud06,
    tbmbud07     LIKE bmb_file.bmbud07,
    tbmbud08     LIKE bmb_file.bmbud08,
    tbmbud09     LIKE bmb_file.bmbud09,
    tbmbud10     LIKE bmb_file.bmbud10,
    tbmbud11     LIKE bmb_file.bmbud11,
    tbmbud12     LIKE bmb_file.bmbud12,
    tbmbud13     LIKE bmb_file.bmbud13,
    tbmbud14     LIKE bmb_file.bmbud14,
    tbmbud15     LIKE bmb_file.bmbud15);
    
    create unique index tbmb1_pk on tbmb1_file (tbmb01,tbmb02,tbmb03,tbmb04,tbmb29)                                                                          
END FUNCTION 
 
FUNCTION p626_create_tbok_file()
 DROP TABLE tbok_file
 DROP INDEX tbok_01
 CREATE TEMP TABLE tbok_file (
     tbok01 LIKE bod_file.bod02,
     tbok02 LIKE type_file.num5,
     tbok03 LIKE type_file.chr20,
     tbok04 LIKE type_file.chr10,
     tbok05 LIKE type_file.chr1);
 
END FUNCTION
 
FUNCTION p626_create_tbmb_file()
 DROP TABLE tbmb_file
 DROP INDEX tbmb_01
 CREATE TEMP TABLE tbmb_file (
      tbmb01 LIKE boe_file.boe02,
      tbmb02 LIKE type_file.chr20,
      tbmb03 LIKE type_file.chr20, 
      tbmb04 LIKE type_file.chr20,
      tbmb05 LIKE type_file.chr10, 
      tbmb06 LIKE bmb_file.bmb06,
      tbmb07 LIKE bmb_file.bmb08,  
      tbmb08 LIKE boj_file.boj01);
CREATE unique index tbmb_01 on tbmb_file(tbmb01,tbmb02,tbmb03,tbmb04,tbmb05);
END FUNCTION
 
FUNCTION p626_create_tbmt_file()
 DROP TABLE tbmt_file
 DROP INDEX tbmt_01
 CREATE TEMP TABLE tbmt_file (                                                                                                                                  
     tbmt01       LIKE bmt_file.bmt01,
     tbmt02       LIKE bmt_file.bmt02,
     tbmt03       LIKE bmt_file.bmt03,
     tbmt04       LIKE bmt_file.bmt04,
     tbmt05       LIKE bmt_file.bmt05,
     tbmt06       LIKE bmt_file.bmt06,
     tbmt07       LIKE bmt_file.bmt07,
     tbmt08       LIKE bmt_file.bmt08);
     
CREATE unique index tbmt_01 on bmt_file (tbmt01,tbmt02,tbmt03,tbmt04,tbmt05,tbmt08); 
END FUNCTION
 
FUNCTION p626_ins_bmb1(p_bmz02)
DEFINE l_sql     string
DEFINE l_z       LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
DEFINE l_bmb     DYNAMIC ARRAY OF RECORD LIKE bmb_file.*
DEFINE l_n       LIKE type_file.num5 
DEFINE l_success LIKE type_file.chr1
DEFINE p_bmz02   LIKE bmz_file.bmz02
     
           LET l_success = 'Y'
           LET l_sql = "SELECT * FROM bmb_file ",
                       "  WHERE bmb01 = '",p_bmz02,"'",
                       "    AND (bmb04 <='",g_today,"' OR bmb04 IS NULL )",
                       "    AND (bmb05 >  '",g_today,"' OR bmb05 IS NULL )",
                       "    AND bmb29 = '",tm.a3,"' ",      
                       "    AND bmb06 != 0 "
           PREPARE p626_ins_bmb1  FROM l_sql 
           DECLARE p626_ins1_bmb1 CURSOR  FOR  p626_ins_bmb1 
           
           LET l_z =1 
           FOREACH p626_ins1_bmb1 INTO l_bmb[l_z].*
            
             INSERT INTO tbmb1_file VALUES (l_bmb[l_z].*)
             IF SQLCA.sqlcode THEN 
                LET l_success ='N'
                RETURN l_success
             END IF 
              LET l_z =l_z+1    
           END FOREACH
           
           LET l_z =l_z -1 
           FOR l_i = 1 TO l_z 
               SELECT COUNT(*) INTO l_n FROM bma_file WHERE bma01 = l_bmb[l_i].bmb03 
               IF l_n > 0 THEN   
                  CALL p626_ins_bmb1(l_bmb[l_i].bmb03)  RETURNING l_success 
                  IF l_success = 'N' THEN 
                     RETURN l_success
                  END IF 
               END IF       
           END FOR 
           RETURN l_success                   
END FUNCTION 
#No.FUN-870117
