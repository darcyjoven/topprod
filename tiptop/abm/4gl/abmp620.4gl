# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmp620.4gl
# Descriptions...: 正式BOM底稿批次產生作業   
# Date & Author..: 07/09/13 By arman
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-810014 08/03/21 By arman
# Modify.........: No.FUN-830116 08/03/21 By arman
# Modify.........: No.FUN-840137 08/04/21 By arman    單身產生空白行
# Modify.........: No.FUN-840155 08/04/22 By arman    增加特性代碼條件產生資料有錯 
                                                     #有單頭沒有單身資料不應該存在
# Modify.........: No.FUN-840178 08/04/24 By arman    如果參數使用特性代碼，要把特性代碼的條件加上去 
# Modify.........: No.FUN-870117 08/08/22 by ve007    
# Modify.........: No.FUN-8A0145 08/10/31 by arman    
# Modify.........: No.CHI-8C0040 09/02/01 by jan 語法修改    
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/17 By douzh 加上栏位为空的判断
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used（2） 
# Modify.........: No.FUN-B30219 11/04/06 By chenmoyan 去除DUAL
# Modify.........: No.FUN-B90075 11/09/09 By zhangll 單號控管改善
# Modify.........: No.TQC-BB0186 11/11/21 By lixiang  對值為空進行控管或賦值
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值 
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm            RECORD         #NO.FUN-810014
            a1         LIKE type_file.chr50,
            a1_ima02   LIKE type_file.chr1000,
            a3         LIKE type_file.chr20,
            a2         LIKE type_file.dat,
            b3         LIKE type_file.chr1,
            a4         LIKE type_file.chr18,
            a5         LIKE type_file.dat
                       END RECORD,
         g_b  DYNAMIC ARRAY OF RECORD 
            b1         LIKE type_file.chr1,
            b2         LIKE type_file.chr6,
            b2_ecd02   LIKE type_file.chr1000
                   END RECORD,
         g_b_t         RECORD 
            b1         LIKE type_file.chr1,
            b2         LIKE type_file.chr6,
            b2_ecd02   LIKE type_file.chr50
                   END RECORD,
         g_c  DYNAMIC ARRAY OF RECORD 
            c1         LIKE type_file.chr1,
            c2         LIKE type_file.chr50,
            c2_ima02   LIKE type_file.chr1000
                   END RECORD,
         g_rec_b       LIKE type_file.num10, 
         l_n           LIKE type_file.num5, 
         l_ac          LIKE type_file.num5,
         l_flag        LIKE type_file.chr1,
         g_change_lang LIKE type_file.chr1,
         g_imz  RECORD LIKE imz_file.*      
DEFINE   g_cnt         LIKE type_file.num10  
DEFINE   g_before_input_done LIKE type_file.num5 
DEFINE   g_sma118      LIKE sma_file.sma118
DEFINE   g_t1          LIKE oay_file.oayslip
DEFINE   g_flag        LIKE type_file.chr1      #No.FUN-830116
DEFINE   g_flag_1        LIKE type_file.chr1    #No.FUN-840137
DEFINE   g_count       LIKE type_file.num5      #No.FUN-830116
DEFINE   g_count1      LIKE type_file.num5      #No.FUN-830116
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	         		# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B30211 

   WHILE TRUE
     BEGIN WORK
     LET g_success = 'N'
     LET g_change_lang = FALSE
     LET g_flag = 'Y'
 
     CALL g_b.clear()
     CALL g_c.clear()
     CALL p620_tm()			
 
     IF g_change_lang = TRUE THEN 
         CONTINUE WHILE
     END IF
     IF g_flag = 'E' THEN
        EXIT WHILE 
     END IF
     
          CALL p620_array_b()
          IF g_flag_1 <> 'Y' THEN
              CONTINUE WHILE
          END IF
          IF g_flag = 'N' THEN
              ROLLBACK WORK
              CONTINUE WHILE
          END IF
          CALL p620_array_c()
          IF g_count1 = 0 THEN
              CONTINUE WHILE
          END IF
          IF g_flag = 'N' THEN
              ROLLBACK WORK
              CONTINUE WHILE
          END IF
          
     IF INT_FLAG THEN LET INT_FLAG = 0  EXIT WHILE END IF
 
     #-->正式資料拋轉
     IF cl_sure(0,0) THEN
        CALL cl_wait()
        CALL s_showmsg_init()           #by arman 080624
        CALL p620()
        IF g_totsuccess="N" THEN                                                     
          LET g_success="N"                                                         
        END IF                                                                       
        CALL s_showmsg()
        IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
        ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
        END IF
        IF l_flag THEN
           CLEAR FORM
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
     END IF
     CLEAR FORM
     ERROR ""
   END WHILE
   CLOSE WINDOW p620_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
END MAIN
   
FUNCTION p620_tm()
DEFINE   p_row,p_col	    LIKE type_file.num5,  
            l_cnt         LIKE type_file.num5,   
            l_sql         STRING,         #NO.FUN-910082
            l_i           LIKE type_file.num5,
            l_n           LIKE type_file.num5,
            l_n1          LIKE type_file.num5
DEFINE li_result LIKE type_file.num5
DEFINE l_ima02   LIKE ima_file.ima02
   LET p_row = 3 LET p_col = 18
 
   OPEN WINDOW p620_w AT p_row,p_col WITH FORM "abm/42f/abmp620" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
   SELECT sma118 INTO g_sma118 FROM sma_file 
   CALL cl_set_comp_visible("a3",g_sma118='Y')
 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL
   LET tm.b3 = 'Y'
   LET tm.a5 = g_today #NO.FUN-840137
   INPUT BY NAME tm.a1,tm.a1_ima02,tm.a3,tm.a2,tm.b3,tm.a4,tm.a5 WITHOUT DEFAULTS 
 
      BEFORE INPUT
      
      AFTER FIELD a1
       IF NOT cl_null(tm.a1) THEN
          SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=tm.a1 AND ima151='Y' AND imaacti='Y'
          IF l_n <= 0 THEN                  
                   CALL cl_err('','abm-081',0)
                   NEXT FIELD a1
          ELSE
          SELECT COUNT(*)  INTO l_n1 FROM bma_file,bmb_file WHERE bma01=bmb01 AND bma01 = tm.a1 
                                      AND (bma05 IS NOT NULL AND bma05<=g_today)    
           IF l_n1 <= 0 THEN                  
                   CALL cl_err('','abm-082',0)
                   NEXT FIELD a1
           END IF
          END IF
          SELECT ima02  INTO l_ima02 FROM ima_file WHERE ima01=tm.a1
          DISPLAY l_ima02 TO a1_ima02
       ELSE
                   NEXT FIELD a1
       END IF
       
      AFTER FIELD  a2
       IF cl_null(tm.a2)  THEN
         NEXT FIELD a2
       END IF 
       IF tm.a3 IS NULL THEN
        LET l_sql = " SELECT UNIQUE '',bmb09,ecd02 FROM bmb_file,OUTER ecd_file", #CHI-8C0040
                                   " WHERE  bmb01='",tm.a1,"' ",
                                   "   AND  bmb04<='",tm.a2,"' ",
                                   "   AND (bmb05>'",tm.a2,"' OR bmb05 IS NULL OR bmb05='')",
                                  #   #CHI-8C0040
                                   "   AND  bmb09=ecd_file.ecd01",      #CHI-8C0040
                                   "   AND  bmb29=' '"         #No.FUN-870117
       ELSE
        LET l_sql = " SELECT UNIQUE '',bmb09,ecd02 FROM bmb_file,OUTER ecd_file",#CHI-8C0040 
                                   " WHERE  bmb01='",tm.a1,"' ",
                                   "   AND  bmb04<='",tm.a2,"' ",
                                   "   AND (bmb05>'",tm.a2,"' OR bmb05 IS NULL OR bmb05='')",
                                  #  #CHI-8C0040
                                   "   AND  bmb09=ecd_file.ecd01",     #CHI-8C0040
                                   "   AND  bmb29='",tm.a3,"' "
       END IF 
       PREPARE p620_b FROM l_sql 
       DECLARE p620_b_curs
              CURSOR WITH HOLD FOR p620_b
       LET l_i = 1
       FOREACH p620_b_curs INTO  g_b[l_i].* 
          IF SQLCA.sqlcode THEN 
               CALL s_errmsg('','','p620_b_curs',SQLCA.sqlcode,1)
               CONTINUE FOREACH
          ELSE
               LET g_flag_1 = 'Y'   #NO.FUN-840137
               LET g_success = 'Y'
          END IF
          IF NOT cl_null(g_b[l_i].b2) THEN 
          LET g_b[l_i].b1 = 'Y'
          LET l_i = l_i + 1 
          END IF
       END FOREACH
       LET g_count = l_i - 1    #No.FUN-830116
       CALL g_b.deleteElement(l_i)
       
      AFTER FIELD a3
      LET l_n = 0 
      IF NOT cl_null(tm.a3)  THEN
         SELECT COUNT(*)  INTO l_n FROM bma_file 
           WHERE bma01=tm.a1 AND (bma05 IS NOT NULL AND bma05<=g_today)  AND bma06=tm.a3
          IF l_n <= 0 THEN
                   CALL cl_err('','abm-618',0)
                   NEXT FIELD a3
          END IF          
       END IF
      AFTER FIELD a4                      #主件料號
          CALL s_auto_assign_no("abm",tm.a4,g_today,"4","","a4","","","")
          RETURNING li_result,tm.a4
          IF (NOT li_result) THEN                                                                                                     
             NEXT FIELD a4                                                                                                          
          END IF                                                                                                                      
          DISPLAY BY NAME tm.a4
            IF NOT cl_null(tm.a4) THEN                                                                                        
              CALL s_check_no("abm",tm.a4,'',"4","","a4","")                                              
              RETURNING li_result,tm.a4                                                                                        
              DISPLAY BY NAME tm.a4
               IF(NOT li_result) THEN                                                                                                  
                  LET tm.a4=tm.a4                                                                                        
                  DISPLAY BY NAME tm.a4                                                                                         
                  NEXT FIELD a4    #FUN-B90075 add
               END IF
            END IF   
      ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(a1) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_a1'
                  LET g_qryparam.default1 = tm.a1
                  LET g_qryparam.arg1 = g_today
                  CALL cl_create_qry() RETURNING tm.a1
                  DISPLAY BY NAME tm.a1 
                  NEXT FIELD a1
               WHEN INFIELD(a3) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_a3'
                  LET g_qryparam.arg1 = tm.a1
                  LET g_qryparam.arg2 = g_today
                  CALL cl_create_qry() RETURNING tm.a3
                  DISPLAY BY NAME tm.a3 
                  NEXT FIELD a3
               WHEN INFIELD(a4)                                                                                           
                  LET g_t1=s_get_doc_no(tm.a4)                                                                              
                  CALL q_smy(FALSE,FALSE,g_t1,'ABM','4') RETURNING g_t1
                  LET tm.a4 = g_t1
                  DISPLAY BY NAME tm.a4                                                                            
                   NEXT FIELD a4
               OTHERWISE EXIT CASE
            END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
      ON ACTION cancel 
         LET g_flag = 'E'
         EXIT INPUT
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                
          LET g_change_lang = TRUE
          EXIT INPUT
      ON ACTION exit                            #加離開功能
          LET g_flag = 'E' 
          EXIT INPUT
   END INPUT
END FUNCTION
FUNCTION p620_array_b()
  DEFINE  l_ac_t          LIKE type_file.num5,   
          l_n             LIKE type_file.num5,   
          l_allow_insert  LIKE type_file.num5,   
          l_allow_delete  LIKE type_file.num5    
  DEFINE #l_sql           LIKE type_file.chr1000
         l_sql           STRING         #NO.FUN-910082 
  DEFINE l_i             LIKE type_file.num5
  DEFINE l_k             LIKE type_file.num5
  DEFINE l_tf            LIKE type_file.num5    #NO.FUN-830116
  DEFINE l_count1        LIKE type_file.num5    #NO.FUN-830116
  DEFINE l_count2        LIKE type_file.num5    #NO.FUN-830116
  
      
  CALL cl_opmsg('s')
 
   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   IF g_count = 0 THEN
    IF g_flag_1 ='Y' THEN
      RETURN
    ELSE 
      CALL cl_err('','abm-314',1)
      RETURN
    END IF
   END IF
     INPUT ARRAY g_b WITHOUT DEFAULTS FROM s_b.*
            
      BEFORE INPUT
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          
      BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_n  = ARR_COUNT()
          NEXT FIELD b1     
      AFTER ROW
      ON ROW CHANGE
         LET g_b[l_ac].b1 =g_b[l_ac].b1 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
      ON ACTION cancel
         CLEAR FORM
         CALL g_b.clear()
         CALL g_c.clear()
         LET g_flag = 'N'
         EXIT INPUT
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg
         CALL cl_cmdask()    
 
      ON ACTION controls                                      
   
   END INPUT
END FUNCTION
 
FUNCTION p620()
  DEFINE  l_ac_t          LIKE type_file.num5,   
          l_n             LIKE type_file.num5,   
          l_allow_insert  LIKE type_file.num5,   
          l_allow_delete  LIKE type_file.num5    
  DEFINE #l_sql            LIKE type_file.chr1000 
         l_sql,l_sql8,l_sql5,l_sql6,l_sql7     STRING         #NO.FUN-910082
  DEFINE l_i              LIKE type_file.num5
  DEFINE l_sum            LIKE type_file.num20_6
  DEFINE l_k              LIKE type_file.num5
  DEFINE l_h              LIKE type_file.num5   #by arman 080623
  DEFINE l_m              LIKE type_file.num5
  DEFINE l_x              LIKE type_file.num5
  DEFINE l_y              LIKE type_file.num5 
  DEFINE l_r              LIKE type_file.num5
  DEFINE i                LIKE type_file.num5
  DEFINE j                LIKE type_file.num5
  DEFINE n                LIKE type_file.num5
  DEFINE k                LIKE type_file.num5
  DEFINE z               LIKE type_file.num5       #No.FUN-830116
  DEFINE l_bma02         LIKE bma_file.bma02,
         l_bma03         LIKE bma_file.bma03,
         l_bma04         LIKE bma_file.bma04,
         l_bma06         LIKE bma_file.bma06,
         l_bma07         LIKE bma_file.bma07,
         g_bmb           RECORD LIKE bmb_file.*,
         g_bok           RECORD LIKE bok_file.*,
         l_boc           RECORD LIKE boc_file.*, 
         l_bmt           RECORD LIKE bmt_file.*,
         l_ima           RECORD LIKE ima_file.*,
         l_bod           RECORD LIKE bod_file.*,
         l_bmv04         DYNAMIC ARRAY OF LIKE bmv_file.bmv04,
         l_bmv05         DYNAMIC ARRAY OF LIKE bmv_file.bmv05,
         l_tbok01        DYNAMIC ARRAY OF LIKE type_file.chr50,  #No.FUN-8A0145
         l_tbok04        DYNAMIC ARRAY OF LIKE type_file.chr50,  #No.FUN-8A0145 
         l_bod06         DYNAMIC ARRAY OF LIKE type_file.chr10,  #No.FUN-8A0145
         l_bod06_1       DYNAMIC ARRAY OF LIKE type_file.chr10,  #No.FUN-8A0145
         l_tbmb05        DYNAMIC ARRAY OF LIKE type_file.chr10   #No.FUN-8A0145
  DEFINE l_a             LIKE agb_file.agb02
  DEFINE l_b             LIKE agb_file.agb02
  DEFINE l_c             LIKE agb_file.agb02
  DEFINE l_d             LIKE agb_file.agb02
  DEFINE l_j             LIKE type_file.num5
  DEFINE l_z             LIKE type_file.num5
  DEFINE l_o             LIKE type_file.num5
  DEFINE l_p             LIKE type_file.num5
  DEFINE l_imx01         LIKE imx_file.imx01
  DEFINE l_imx02         LIKE imx_file.imx02
  DEFINE l_imx03         LIKE imx_file.imx03
  DEFINE l_max_bok32     LIKE bok_file.bok32
  DEFINE l_bok02         LIKE bok_file.bok02
  DEFINE l_boj01a        LIKE boj_file.boj01
  DEFINE l_boe08         LIKE boe_file.boe08
  DEFINE l_bok03         LIKE bok_file.bok03
  DEFINE l_bok13         LIKE bok_file.bok13   #by arman 080604
  DEFINE l_imaag1        LIKE ima_file.imaag
  DEFINE l_sma46         LIKE sma_file.sma46
  DEFINE l_int           LIKE type_file.chr1000
  DEFINE li_result       LIKE abb_file.abb25 
  DEFINE l_f             LIKE agb_file.agb02
  DEFINE l_e             LIKE agb_file.agb02
  DEFINE l_s             LIKE type_file.chr1000
  DEFINE ls_sql          LIKE type_file.chr1000
  DEFINE l_str1          LIKE type_file.chr6    #varchar(06)
  DEFINE l_boe07         LIKE boe_file.boe07
  DEFINE l_boe07_1       STRING                 #FUN-B30219
  DEFINE l_boe08_1       STRING                 #FUN-B30219
  DEFINE l_imx00         LIKE imx_file.imx00
  DEFINE l_imaag         LIKE ima_file.imaag
  DEFINE l_agbslk01      LIKE agb_file.agbslk01
  DEFINE bmv04_l         LIKE bmv_file.bmv04
  DEFINE bmv07_l         LIKE bmv_file.bmv07
  DEFINE bmv08_l         LIKE bmv_file.bmv08
  DEFINE l_this          LIKE imx_file.imx01
  DEFINE l_tbmb          ARRAY[100] OF RECORD
                         tbmb01 LIKE boe_file.boe02,   #varchar(40),
                         tbmb02 LIKE type_file.chr20,  #varchar(20),
                         tbmb03 LIKE type_file.chr20,  #varchar(20), 
                         tbmb04 LIKE type_file.chr20,  #varchar(20), 
                         tbmb05 LIKE type_file.chr10,  #varchar(10),  
                         tbmb06 LIKE bmb_file.bmb06,
                         tbmb07 LIKE bmb_file.bmb08,
                         tbmb08 LIKE boj_file.boj01
                         END RECORD
  DEFINE t_tbmb          RECORD
                         tbmb01 LIKE boe_file.boe02,   #varchar(40),
                         tbmb02 LIKE type_file.chr20,  #varchar(20),
                         tbmb03 LIKE type_file.chr20,  #varchar(20), 
                         tbmb04 LIKE type_file.chr20,  #varchar(20), 
                         tbmb05 LIKE type_file.chr10,  #varchar(10),
                         tbmb06 LIKE bmb_file.bmb06,
                         tbmb07 LIKE bmb_file.bmb08,
                         tbmb08 LIKE boj_file.boj01    #varchar(40)
                         END RECORD  
  DEFINE l_imaicd        RECORD LIKE imaicd_file.*   #No.FUN-7B0018
  DEFINE l_count         LIKE type_file.num5     #No.FUN-830116
  DEFINE l_count1        LIKE type_file.num5     #No.FUN-830116
  DEFINE l_count3        LIKE type_file.num5     #No.FUN-830116
  DEFINE y               LIKE type_file.num5     #No.FUN-830116
  DEFINE l_str           LIKE type_file.chr1000  #No.FUN-830116
  DEFINE p_flag          LIKE boe_file.boe07     #NO.FUN-830116 
  DEFINE p_flag_1        LIKE boe_file.boe07     #NO.FUN-830116 
  DEFINE l_tbok01_t      LIKE bod_file.bod02     #No.FUN-830116
  DEFINE l_tbok04_t      LIKE bod_file.bod06     #No.FUN-830116
  DEFINE l_count4        LIKE type_file.num5     #No.FUN-840115
  DEFINE l_n1            LIKE type_file.num5     #by arman 080620 
  DEFINE l_n2            LIKE type_file.num5     #by arman 080620 
  DEFINE l_n3            LIKE type_file.num5     #by arman 080620 
  CALL cl_opmsg('s')
 
   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

           CALL p620_create_tbok_file()     #No.FUN-870117                      
           CALL p620_create_tbmb_file()     #No.FUN-870117
         FOR z=1 TO g_count1
          IF g_c[z].c1 = 'Y' THEN
          IF tm.a3 IS NULL THEN 
           SELECT bma02,bma03,bma04,bma06,bma07  INTO l_bma02,l_bma03,l_bma04,l_bma06,l_bma07 
           FROM bma_file WHERE bma01 = tm.a1         #AND bma06 IS NULL    #NO.FUN-830116
           AND bma06 = ' '           #No.FUN-870117
          ELSE
           SELECT bma02,bma03,bma04,bma06,bma07  INTO l_bma02,l_bma03,l_bma04,l_bma06,l_bma07 
           FROM bma_file WHERE bma01 = tm.a1 AND bma06 = tm.a3
          END IF
          SELECT COUNT(*)  INTO l_n FROM boj_file  WHERE boj01 = g_c[z].c2 AND boj09 = tm.a4  #by arman 080623
          IF l_n <=0 THEN
          INSERT INTO boj_file(boj01,boj02,boj03,boj04,boj05,boj06,boj07,boj08,boj09,boj10,boj11,bojacti,bojdate,bojgrup,bojmodu,bojuser,bojoriu,bojorig)
          VALUES(g_c[z].c2,l_bma02,l_bma03,l_bma04,'',l_bma06,l_bma07,' ',tm.a4,0,tm.a5,'Y',g_today,g_grup,'',g_user, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_c[z].c2,SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN                  #No.FUN-870117
      
            END IF
            LET l_str = ""                      #by arman 080619
            FOR y = 1 TO g_count                #by arman 080619
            IF g_b[y].b1 = 'Y' THEN 
               LET l_str= l_str,"'",g_b[y].b2,"'",','
            END IF
            END FOR
            IF l_str IS NOT NULL THEN
             LET l_str = l_str[1,length(l_str)-1]   #by arman 080623
            END IF
               IF tm.b3 ='N' THEN    #by arman 080623
                 IF tm.a3 IS NULL THEN
                  IF l_str IS NULL THEN
                    LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ", 
                               #" WHERE  bmb09 IS NULL ",      #TQC-BB0186
                                " WHERE  bmb09 IS NULL OR bmb09 = ' ' ",   #TQC-BB0186
                                " AND bmb01=bma01 AND bma01='",tm.a1,"' ",        
                                " AND bmb04<='",tm.a2,"' AND (bmb05>'",tm.a2,"' OR bmb05 IS NULL OR bmb05='') ",
                                " AND bmb29 = ' '",       #No.FUN-870117
                                " ORDER BY bmb02 "
                  ELSE
                    LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ", 
                                " WHERE  bmb09 IN (",l_str,") ", 
                                " AND bmb01=bma01 AND bma01='",tm.a1,"' ",        
                                " AND bmb04<='",tm.a2,"' AND (bmb05>'",tm.a2,"' OR bmb05 IS NULL OR bmb05='') ",
                                " AND bmb29 = ' '",       #No.FUN-870117
                                " ORDER BY bmb02 "
                  END IF
                 ELSE
                  IF l_str IS NULL THEN
                    LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ", 
                                " WHERE  bmb09 IS NULL  ",  
                                " AND bmb01=bma01 AND bma01='",tm.a1,"' AND bmb04<='",tm.a2,"' ", 
                                " AND (bmb05>'",tm.a2,"' OR bmb05 IS NULL OR bmb05='') AND bmb29='",tm.a3,"' ", 
                                "  AND bmb29 = bma06 ",   #No.FUN-840155
                                " ORDER BY bmb02 "
                  ELSE
                    LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ", 
                                " WHERE  bmb09 IN (",l_str,") ",  
                                " AND bmb01=bma01 AND bma01='",tm.a1,"' AND bmb04<='",tm.a2,"' ", 
                                " AND (bmb05>'",tm.a2,"' OR bmb05 IS NULL OR bmb05='') AND bmb29='",tm.a3,"' ", 
                                "  AND bmb29 = bma06 ",   #No.FUN-840155
                                " ORDER BY bmb02 "
                  END IF
                 END IF
               ELSE
                 IF tm.a3 IS NULL THEN
                  IF l_str IS NULL THEN
                    LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ",
                                " WHERE (bmb09 IS NULL OR bmb09 = ' ') ",  
                                " AND bmb01=bma01 AND bma01='",tm.a1,"' AND bmb04<='",tm.a2,"' ",
                                " AND (bmb05>'",tm.a2,"' OR bmb05 IS NULL OR bmb05='') ",
                                " AND bmb29 = ' '",       #No.FUN-870117 
                                " ORDER BY bmb02 "
                  ELSE
                    LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ",
                                " WHERE (bmb09 IN (",l_str,") OR bmb09 IS NULL OR bmb09 = ' ') ",  
                                " AND bmb01=bma01 AND bma01='",tm.a1,"' AND bmb04<='",tm.a2,"' ",
                                " AND (bmb05>'",tm.a2,"' OR bmb05 IS NULL OR bmb05='') ",   
                                " AND bmb29 = ' '",       #No.FUN-870117  
                                " ORDER BY bmb02 "
                  END IF
                 ELSE
                  IF l_str IS NULL THEN
                    LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ",
                                " WHERE (bmb09 IS NULL OR bmb09 = ' ') ",  
                                " AND bmb01=bma01 AND bma01='",tm.a1,"' AND bmb04<='",tm.a2,"' AND (bmb05>'",tm.a2,"' ",
                                "  OR bmb05 IS NULL OR bmb05='') ",
                                "  AND bmb29 = bma06 ",   #No.FUN-840155
                                " AND bmb29='",tm.a3,"' ORDER BY bmb02 "                         
                  ELSE
                    LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ",
                                " WHERE (bmb09 IN (",l_str,") OR bmb09 IS NULL OR bmb09 = ' ') ",  
                                " AND bmb01=bma01 AND bma01='",tm.a1,"' AND bmb04<='",tm.a2,"' AND (bmb05>'",tm.a2,"' ",
                                "  OR bmb05 IS NULL OR bmb05='') ",
                                "  AND bmb29 = bma06 ",   #No.FUN-840155
                                " AND bmb29='",tm.a3,"' ORDER BY bmb02 "                         
                  END IF
                 END IF
               END IF
               PREPARE p620_bom FROM l_sql 
               DECLARE p620_bom_curs
                   CURSOR WITH HOLD FOR p620_bom
               FOREACH p620_bom_curs INTO  g_bmb.* 
               IF SQLCA.sqlcode THEN 
                     CALL s_errmsg('','','p620_bom_curs',SQLCA.sqlcode,1)
                     CONTINUE FOREACH
               END IF
               IF cl_null(tm.a3) THEN
                SELECT COUNT(*) INTO l_count FROM  bmb_file,bma_file
                                           WHERE bmb01=bma01
                                             AND bmb01=g_c[z].c2
                                             AND bmb09=g_bmb.bmb09
                                             AND bmb29 = ' '           #No.FUN-870117
               ELSE
                SELECT COUNT(*) INTO l_count FROM  bmb_file,bma_file
                                           WHERE bmb01=bma01
                                             AND bmb01=g_c[z].c2
                                             AND bmb09=g_bmb.bmb09
                                             AND bmb29=tm.a3
                                             AND bmb29=bma06
               END IF
               IF l_count >0 THEN
                 CONTINUE FOREACH
               END IF
               IF g_bmb.bmb30 = '4' THEN
               IF NOT s_control(g_bmb.bmb01,g_bmb.bmb03,tm.a3) THEN
                   CALL s_errmsg('',g_c[z].c2 CLIPPED ,'','abm-623',1) 
                   LET g_totsuccess='N'
                   LET g_success = 'N'  
                   EXIT FOREACH
               END IF          
               END IF
               IF g_bmb.bmb30 = '1' THEN
                   CALL cl_err_msg('','abmp_2',g_bmb.bmb03 CLIPPED,0)
                   SELECT MAX(bok32) INTO l_max_bok32 FROM bok_file WHERE bok01 = g_c[z].c2 AND bok31 = tm.a4   #NO.FUN-830116 add bok01
                   IF l_max_bok32 IS NULL THEN
                     LET l_max_bok32 = 0  
                   END IF
                   LET l_max_bok32 = l_max_bok32+1  
                   SELECT MAX(bok02)  INTO l_bok02 FROM bok_file
                    WHERE bok01 = g_c[z].c2                     
                       IF l_bok02 IS NULL THEN 
                             LET l_bok02 = 0
                       END IF
                       LET l_bok02 = l_bok02 + g_sma.sma19

                    IF g_bmb.bmb09 IS NULL THEN
                     IF tm.a3 IS NULL THEN 
                       SELECT COUNT(*) INTO l_h FROM bok_file
                         WHERE bok01 = g_c[z].c2 AND bok03 = g_bmb.bmb03 AND bok09 IS NULL  
                           AND bok29 = ' '
                      ELSE 
                       SELECT COUNT(*) INTO l_h FROM bok_file
                         WHERE bok01 = g_c[z].c2 AND bok03 = g_bmb.bmb03 AND bok09 IS NULL  
                           AND bok29 = tm.a3	 
                       END IF           
                    ELSE
                    	IF tm.a3 IS NULL THEN 
                        SELECT COUNT(*) INTO l_h FROM bok_file 
                          WHERE bok01 = g_c[z].c2 AND bok03 = g_bmb.bmb03 AND bok09 = g_bmb.bmb09 
                            AND bok29 = ' '
                      ELSE 
                      	SELECT COUNT(*) INTO l_h FROM bok_file 
                          WHERE bok01 = g_c[z].c2 AND bok03 = g_bmb.bmb03 AND bok09 = g_bmb.bmb09 
                            AND bok29 = tm.a3
                      END IF              
                    END IF
                    IF l_h <=0 THEN
                    INSERT INTO bok_file(bok31,bok32,bok01,bok02,bok03,bok04,bok05,bok06,bok07,bok08,bok09,bok10,bok10_fac,bok10_fac2,
                                        bok11,bok13,bok14,bok15,bok16,bok17,bok18,bok19,bok20,bok21,bok22,bok23,bok24,bok25,
                                        bok26,bok27,bok28,bokmodu,bokdate,bokcomm,bok29,bok30,bok33,bok34)    #No.FUN-830116 add bok34
                        VALUES  (tm.a4,l_max_bok32,g_c[z].c2,l_bok02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb05,
                                               g_bmb.bmb06,g_bmb.bmb07,g_bmb.bmb08,g_bmb.bmb09,g_bmb.bmb10,
                                               g_bmb.bmb10_fac,g_bmb.bmb10_fac2,g_bmb.bmb11,g_bmb.bmb13,
                                               g_bmb.bmb14,g_bmb.bmb15,g_bmb.bmb16,g_bmb.bmb17,g_bmb.bmb18,
                                               g_bmb.bmb19,g_bmb.bmb20,g_bmb.bmb21,g_bmb.bmb22,g_bmb.bmb23,
                                               g_bmb.bmb24,g_bmb.bmb25,g_bmb.bmb26,g_bmb.bmb27,g_bmb.bmb28,
                                               g_bmb.bmbmodu,g_bmb.bmbdate,g_bmb.bmbcomm,
 
                                               g_bmb.bmb29,'1',g_bmb.bmb02,g_bmb.bmb31)              #NO.FUN-830116
                    IF SQLCA.sqlcode THEN
                         CALL cl_err(tm.a4,SQLCA.sqlcode,0)
                         LET g_success = 'N'
                         RETURN                  #No.FUN-870117
                    END IF 
                   DECLARE p620_bmt_curs
                      CURSOR FOR (SELECT * FROM bmt_file WHERE bmt01= g_bmb.bmb01 AND bmt02=g_bmb.bmb02 AND bmt03 =g_bmb.bmb03 
                                                               AND bmt04 = g_bmb.bmb04 AND bmt08 =g_bmb.bmb29) 
                      FOREACH p620_bmt_curs INTO l_bmt.* 
                         IF SQLCA.sqlcode THEN 
                            CALL s_errmsg('','','p620_bmt_curs',SQLCA.sqlcode,1)
                            CONTINUE FOREACH                                                       
                         END IF 
                         INSERT INTO bmh_file VALUES(g_c[z].c2,l_bok02,g_bmb.bmb03,g_bmb.bmb04,l_bmt.bmt05,l_bmt.bmt06,l_bmt.bmt07,g_bmb.bmb29,tm.a4,l_max_bok32)
                          IF SQLCA.sqlcode THEN
                             CALL cl_err(g_c[z].c2,SQLCA.sqlcode,0)
                             LET g_success = 'N'
                             RETURN                 
                          END IF      
                      END FOREACH
                    END IF
               ELSE
                 IF g_bmb.bmb30 = '4' THEN
                    INITIALIZE t_tbmb.* TO NULL       #NO.FUN-840155
                    CALL cl_err_msg('','abmp_1',g_bmb.bmb03 CLIPPED,0)
                    DELETE FROM tbok_file
                    DELETE FROM tbmb_file      
                      DECLARE p620_boc_curs
                         CURSOR FOR (SELECT * FROM boc_file WHERE boc01= g_bmb.bmb01 AND boc02=g_bmb.bmb03)
                      FOREACH p620_boc_curs INTO l_boc.* 
                         IF SQLCA.sqlcode THEN 
                            CALL s_errmsg('','','p620_boc_curs',SQLCA.sqlcode,1)
                            CONTINUE FOREACH
                         END IF
                         INITIALIZE l_bod.* TO NULL      #by arman 080623
                         SELECT agb02 INTO l_a FROM agb_file WHERE agb01 =(SELECT  imaag FROM  ima_file WHERE ima01 = l_boc.boc02)
                                                      AND agb03 = l_boc.boc04
                         SELECT agb02 INTO l_b FROM agb_file WHERE agb01 =(SELECT  imaag FROM  ima_file WHERE ima01 = l_boc.boc01)
                                                      AND agb03 = l_boc.boc03    
                         IF l_b = '1' THEN
                               SELECT imx01 INTO l_boj01a  FROM imx_file  WHERE  imx000=g_c[z].c2   #NO.FUN-830116
                         END IF 
                         IF l_b = '2' THEN
                               SELECT imx02 INTO l_boj01a  FROM imx_file  WHERE  imx000=g_c[z].c2 
                         END IF
                         IF l_b = '3' THEN
                               SELECT imx03 INTO l_boj01a  FROM imx_file  WHERE  imx000=g_c[z].c2 
                         END IF
                         LET l_n1 = 0
                         LET l_n2 = 0
                         LET l_n3 = 0
                         SELECT  COUNT(*) INTO l_n1 FROM bod_file
                           WHERE bod01 = l_boc.boc01
                             AND bod02 = l_boc.boc02
                             AND bod03 = l_boc.boc03
                             AND bod04 = l_boc.boc04
                             AND bod05 = l_boj01a
                             AND bod06 = ' ' 
                         SELECT  COUNT(*) INTO l_n2 FROM bmt_file
                           WHERE  bmt01 = g_bmb.bmb01
                             AND  bmt02 = g_bmb.bmb02
                             AND  bmt03 = g_bmb.bmb03
                             AND  bmt04 = g_bmb.bmb04
                             AND  bmt08 = g_bmb.bmb29
                         SELECT  COUNT(*) INTO l_n3 FROM bod_file
                           WHERE bod01 = l_boc.boc01
                             AND bod02 = l_boc.boc02
                             AND bod03 = l_boc.boc03
                             AND bod04 = l_boc.boc04
                             AND bod05 = l_boj01a
                             AND bod06 IS NOT NULL 
                         IF l_n1 = 0 THEN
                          IF l_n2 != l_n3 AND l_n2 >0 AND l_n3 >0  THEN 
                             CALL cl_err('','abm-026',1)
                             LET g_success = 'N'
                             RETURN  
                          END IF
                         END IF       
                         LET l_sql5= "SELECT * FROM bod_file WHERE bod01='",l_boc.boc01,"' AND bod02='",l_boc.boc02,"' ",
                                     "          AND bod03='",l_boc.boc03,"' AND bod04='",l_boc.boc04,"' AND bod05='",l_boj01a CLIPPED,"' " 
                                  
                         SELECT COUNT(*) INTO l_count3 FROM bod_file WHERE bod01=l_boc.boc01 AND bod02=l_boc.boc02
                                                       AND bod03=l_boc.boc03 AND bod04=l_boc.boc04 AND bod05=l_boj01a
                                                       AND bod06 = g_bmb.bmb13
                          IF l_count3 >0 THEN
                                                      #NO.FUN-830116 --end
                          LET l_sql5= "SELECT * FROM bod_file WHERE bod01='",l_boc.boc01,"' AND bod02='",l_boc.boc02,"' ",
                                    "           AND bod03='",l_boc.boc03,"' AND bod04='",l_boc.boc04,"' AND bod05='",l_boj01a CLIPPED,"' ",
                                    "           AND bod06 = '",g_bmb.bmb13,"' "
                          END IF
                         PREPARE p620_bod FROM l_sql5 
                            DECLARE p620_bod_curs
                            CURSOR WITH HOLD FOR p620_bod
                           FOREACH p620_bod_curs INTO l_bod.* 
                                IF SQLCA.sqlcode THEN 
                                 CALL s_errmsg('','','p620_bod_curs',SQLCA.sqlcode,1)
                                 CONTINUE FOREACH
                                  END IF
                                IF NOT cl_null(l_bod.bod06) THEN
                                   LET l_tbok01_t = l_bod.bod02
                                   LET l_tbok04_t = l_bod.bod06
                                END IF 
                                IF cl_null(g_bmb.bmb13) THEN
                                 IF cl_null(l_bod.bod06) THEN               #by arman 080702
                                 INSERT INTO tbok_file VALUES (l_bod.bod02,l_a,l_bod.bod07,' ','2')
                                   IF SQLCA.sqlcode THEN
                                     CALL cl_err(l_bod.bod02,SQLCA.sqlcode,0)
                                      LET g_success = 'N'
                                      RETURN                 
                                   END IF
                                 ELSE
                                     CALL s_errmsg('',g_c[z].c2 CLIPPED || "|" || l_boj01a CLIPPED 
                                                   || "|" || g_bmb.bmb03 CLIPPED || "|" || l_bod.bod06 CLIPPED,'','abm-029',1) 
                                     LET g_totsuccess='N'
                                     LET g_success = 'N'  
                                 END IF
                                ELSE
                                IF NOT cl_null(l_bod.bod06) THEN
                                 INSERT INTO tbok_file VALUES (l_bod.bod02,l_a,l_bod.bod07,l_bod.bod06,'2')
                                 IF SQLCA.sqlcode THEN
                                     CALL cl_err(l_bod.bod02,SQLCA.sqlcode,0)
                                      LET g_success = 'N'
                                      RETURN                  #No.FUN-870117 
                                 END IF
                                ELSE
                                 LET l_sql6= " SELECT bmt06 FROM bmt_file WHERE bmt01='",g_bmb.bmb01,"' AND bmt02='",g_bmb.bmb02,"' ",
                                             "           AND bmt03='",g_bmb.bmb03,"' AND bmt08='",g_bmb.bmb29,"'     ", 
                                             "           AND bmt06 NOT IN ( SELECT bod06 FROM bod_file WHERE bod01 = '",l_boc.boc01,"' ",
                                             "           AND bod02 = '",l_boc.boc02,"' AND bod03 = '",l_boc.boc03,"' AND bod04 = '",l_boc.boc04,"' ",
                                             "           AND bod05 = '",l_boj01a CLIPPED,"' AND (bod06 IS NOT NULL AND bod06 <> ' ')) "
                                 PREPARE p620_bod_1 FROM l_sql6 
                                   DECLARE p620_bod_curs_1
                                   CURSOR WITH HOLD FOR p620_bod_1
                                  LET l_z=1
                                  FOREACH p620_bod_curs_1 INTO l_bod06[l_z] 
                                       IF SQLCA.sqlcode THEN 
                                        CALL s_errmsg('','','p620_bod_curs_1',SQLCA.sqlcode,1)
                                        CONTINUE FOREACH
                                       END IF
                                       INSERT INTO tbok_file VALUES (l_bod.bod02,l_a,l_bod.bod07,l_bod06[l_z],'2')
                                        IF SQLCA.sqlcode THEN
                                            CALL cl_err(l_bod.bod02,SQLCA.sqlcode,0)
                                             LET g_success = 'N'
                                             RETURN                
                                        END IF
                                       LET l_z = l_z + 1
                                  END FOREACH
                                  
                                END IF
                                END IF
                           END FOREACH   
                                      
                           IF l_bod.bod01 IS NULL THEN
                             CALL s_errmsg('',g_c[z].c2 CLIPPED || "|" || l_boj01a CLIPPED 
                                           || "|" || g_bmb.bmb03 CLIPPED || "|" || g_bmb.bmb13 CLIPPED,'','abm-027',1) 
                             LET g_totsuccess='N'
                             LET g_success = 'N'  
                           END IF
                      END FOREACH
                      IF tm.a3 IS NULL THEN             
                        LET l_sql = " SELECT bmv04,MAX(bmv05) FROM bmv_file  ", 
                                    " WHERE bmv01='",g_bmb.bmb01,"' AND bmv02='",g_bmb.bmb03,"' AND bmv03='",g_bmb.bmb29,"' ",
                                    " AND bmv05<='",tm.a2,"' AND (bmv06>'",tm.a2,"' OR bmv06 IS NULL OR bmv06='') ",
                                    " AND bmv04 NOT IN(SELECT boc04 FROM boc_file WHERE boc01= '",g_bmb.bmb01,"' ", 
                                    " AND boc02='",g_bmb.bmb03,"')  ",
                                    " AND bmv03 = ' '",                  #No.FUN-870117
                                    "GROUP BY bmv04 "
                      ELSE
                        LET l_sql = " SELECT bmv04,MAX(bmv05) FROM bmv_file  ", 
                                    " WHERE bmv01='",g_bmb.bmb01,"' AND bmv02='",g_bmb.bmb03,"' AND bmv03='",g_bmb.bmb29,"' ",
                                    " AND bmv05<='",tm.a2,"' AND (bmv06>'",tm.a2,"' OR bmv06 IS NULL OR bmv06='') ",
                                    " AND bmv04 NOT IN(SELECT boc04 FROM boc_file WHERE boc01= '",g_bmb.bmb01,"' ", 
                                    " AND boc02='",g_bmb.bmb03,"') AND bmv03='",tm.a3,"'  GROUP BY bmv04 "
                      END IF
                      PREPARE p620_bmv FROM l_sql 
                          DECLARE p620_bmv_curs
                            CURSOR WITH HOLD FOR p620_bmv
                            LET l_x = 1
                            FOREACH p620_bmv_curs INTO l_bmv04[l_x],l_bmv05[l_x] 
                              IF SQLCA.sqlcode THEN 
                                CALL s_errmsg('','','p620_bmv_curs',SQLCA.sqlcode,1)
                                CONTINUE FOREACH
                             END IF
                              IF tm.a3 IS NULL THEN
                               SELECT bmv04,bmv07  INTO bmv04_l,bmv07_l FROM bmv_file WHERE bmv01=g_bmb.bmb01 AND bmv02=g_bmb.bmb03 AND bmv03=g_bmb.bmb29
                                                   AND bmv04=l_bmv04[l_x] AND bmv05=l_bmv05[l_x]
                                                   AND (bmv06>tm.a2 OR bmv06 IS NULL OR bmv06='')
                                                   AND bmv03  = ' '     #No.FUN-870117
                              ELSE
                               SELECT bmv04,bmv07  INTO bmv04_l,bmv07_l FROM bmv_file WHERE bmv01=g_bmb.bmb01 AND bmv02=g_bmb.bmb03 AND bmv03=g_bmb.bmb29
                                                   AND bmv04=l_bmv04[l_x] AND bmv05=l_bmv05[l_x]
                                                   AND (bmv06>tm.a2 OR bmv06 IS NULL OR bmv06='')
                                                   AND bmv03=tm.a3
                              END IF 
                              IF bmv04_l IS NOT NULL THEN
                                  SELECT agb02 INTO l_c FROM agb_file,ima_file WHERE agb01= imaag AND ima01=g_bmb.bmb03 AND agb03=l_bmv04[l_x]
                                IF tm.a3 IS NULL THEN
                                  SELECT bmv08 INTO bmv08_l FROM bmv_file WHERE bmv01= g_bmb.bmb01 AND bmv02 = g_bmb.bmb03 
                                                                            AND bmv04 = l_bmv04[l_x] AND bmv05 = l_bmv05[l_x]
                                ELSE
                                  SELECT bmv08 INTO bmv08_l FROM bmv_file WHERE bmv01= g_bmb.bmb01 AND bmv02 = g_bmb.bmb03 
                                                                            AND bmv04 = l_bmv04[l_x] AND bmv05 = l_bmv05[l_x] AND bmv03 = tm.a3
                                END IF
                                 IF bmv08_l='1' THEN
                                    SELECT agb02 INTO l_d FROM agb_file,ima_file WHERE agb01=imaag AND ima01=g_bmb.bmb01 AND agb03=bmv07_l
                                    IF l_d = '1' THEN
                                       SELECT imx01 INTO l_this FROM imx_file WHERE imx000 = g_c[z].c2 
                                    END IF
                                    IF l_d = '2' THEN
                                       SELECT imx02 INTO l_this FROM imx_file WHERE imx000 = g_c[z].c2 
                                    END IF
                                    IF l_d = '3' THEN
                                       SELECT imx03 INTO l_this FROM imx_file WHERE imx000 = g_c[z].c2 
                                    END IF
                                 ELSE
                                    LET l_this = bmv07_l   
                                 END IF 
                              END IF
                              IF NOT cl_null(g_bmb.bmb13) THEN
                                 LET l_tbok01_t = g_bmb.bmb03
                                 LET l_tbok04_t = g_bmb.bmb13
                              END IF 
                              IF NOT cl_null(g_bmb.bmb13) THEN
                                 LET l_sql6= " SELECT bmt06 FROM bmt_file WHERE bmt01='",g_bmb.bmb01,"' AND bmt02='",g_bmb.bmb02,"' ",
                                             "           AND bmt03='",g_bmb.bmb03,"' AND bmt04='",g_bmb.bmb04,"' AND bmt08='",g_bmb.bmb29,"' "
                                 PREPARE p620_bod_2 FROM l_sql6 
                                   DECLARE p620_bod_curs_2
                                   CURSOR WITH HOLD FOR p620_bod_2
                                   LET l_o = 1
                                  FOREACH p620_bod_curs_2 INTO l_bod06_1[l_o] 
                                       IF SQLCA.sqlcode THEN 
                                        CALL s_errmsg('','','p620_bod_curs_2',SQLCA.sqlcode,1)
                                        CONTINUE FOREACH
                                       END IF
                                       INSERT INTO tbok_file VALUES (g_bmb.bmb03,l_c,l_this,l_bod06_1[l_o],'1')
                                        IF SQLCA.sqlcode THEN
                                            CALL cl_err(g_bmb.bmb03,SQLCA.sqlcode,0)
                                             LET g_success = 'N'
                                             RETURN                
                                        END IF
                                       LET l_o = l_o + 1
                                  END FOREACH
                              ELSE
                                 INSERT INTO tbok_file VALUES (g_bmb.bmb03,l_c,l_this,' ','1')
                              END IF
                                 IF SQLCA.sqlcode THEN
                                     CALL cl_err(l_bod.bod02,SQLCA.sqlcode,0)
                                      LET g_success = 'N'
                                     RETURN                  #No.FUN-870117 
                                 ELSE
                                 END IF
                                 LET l_x = l_x + 1
                            END FOREACH

                       
                       DECLARE p620_tbok_curs
                         CURSOR FOR (SELECT DISTINCT tbok01,tbok04 FROM tbok_file)   
                       LET l_j = 1  
                       LET l_y = 1  
                       FOREACH p620_tbok_curs INTO l_tbok01[l_y],l_tbok04[l_y] 
                         IF SQLCA.sqlcode THEN      
                            CALL s_errmsg('','','p620_tbok_curs',SQLCA.sqlcode,1)
                            CONTINUE FOREACH    
                         END IF                   
                         LET l_tbmb[l_j].tbmb01=l_tbok01[l_y]
                         LET l_tbmb[l_j].tbmb05=l_tbok04[l_y]
                         IF l_tbok04[l_y] IS NULL OR l_tbok04[l_y]='' THEN
                           LET l_tbmb[l_j].tbmb02 = '' #NO.FUN-830116
                           LET l_tbmb[l_j].tbmb03 = '' #NO.FUN-830116
                           LET l_tbmb[l_j].tbmb04 = '' #NO.FUN-830116
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb02 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=1 
                                                                                AND (tbok04 IS NULL OR tbok04='')
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb03 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=2 
                                                                                AND (tbok04 IS NULL OR tbok04='')
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb04 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=3 
                                                                                AND (tbok04 IS NULL OR tbok04='')
                         ELSE
                           LET l_tbmb[l_j].tbmb02 = ''   #NO.FUN-830116
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb02 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=1 
                                                                                AND tbok04=l_tbok04[l_y]
                           IF l_tbmb[l_j].tbmb02 IS NULL then
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb02 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=1 
                                                                                AND (tbok04 IS NULL OR tbok04='')
                           END IF  
                           LET l_tbmb[l_j].tbmb03 = ''    #NO.FUN-830116
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb03 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=2 
                                                                                AND tbok04=l_tbok04[l_y]
                           IF l_tbmb[l_j].tbmb03 IS NULL THEN
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb03 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=2 
                                                                                AND (tbok04 IS NULL OR tbok04='')
                           END IF  
                           LET l_tbmb[l_j].tbmb04 = ''    #NO.FUN-830116
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb04 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=3 
                                                                                AND tbok04=l_tbok04[l_y]
                           IF l_tbmb[l_j].tbmb04 IS NULL THEN
                           SELECT tbok03 INTO l_tbmb[l_j].tbmb04 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=3 
                                                                                AND (tbok04 IS NULL OR tbok04='')
                           END IF           
                         END IF
                         LET l_tbmb[l_j].tbmb08=g_c[z].c2
                         INSERT INTO tbmb_file values(l_tbmb[l_j].*)
                        
                         IF SQLCA.sqlcode THEN                             
                             CALL cl_err(l_tbmb[l_j].tbmb01,SQLCA.sqlcode,0)
                              LET g_success = 'N'      
                              RETURN                  #No.FUN-870117                                                             
                    
                         END IF                                            
                         LET l_j=l_j+1
                         LET l_y=l_y+1
                       END FOREACH
                                                           
                 LET l_sql8 = " SELECT DISTINCT tbmb01,tbmb02,tbmb03,tbmb04,'', ",
                              " tbmb06,tbmb07,tbmb08 FROM  tbmb_file  "                                              
                 PREPARE p620_curs FROM l_sql8
                 DECLARE p620_tbmb_curs 
                     CURSOR WITH HOLD FOR p620_curs 
                 FOREACH p620_tbmb_curs INTO t_tbmb.*                           
                   IF SQLCA.sqlcode THEN                                                   
                      CALL s_errmsg('','','p620_tbok_curs',SQLCA.sqlcode,1)                
                      CONTINUE FOREACH         
                                       
                   END IF
                   #by arman 080621 ---begin

                   LET l_sql7 = " SELECT tbmb05 FROM tbmb_file WHERE tbmb01 = '",t_tbmb.tbmb01,"' ",           
                                "                              AND (tbmb02 = '",t_tbmb.tbmb02,"' OR tbmb02 IS NULL)  ",              
                                "                              AND (tbmb03 = '",t_tbmb.tbmb03,"' OR tbmb03 IS NULL)  ",              
                                "                              AND (tbmb04 = '",t_tbmb.tbmb04,"' OR tbmb04 IS NULL)  "  #No.FUN-870117  
                   PREPARE p620_bod_3 FROM l_sql7 
                     DECLARE p620_bod_curs_3
                     CURSOR WITH HOLD FOR p620_bod_3
                      LET l_p=1
                      LET l_sum=0
                      FOREACH p620_bod_curs_3 INTO l_tbmb05[l_p] 
                       IF SQLCA.sqlcode THEN 
                          CALL s_errmsg('','','p620_bod_curs_1',SQLCA.sqlcode,1)
                          CONTINUE FOREACH
                       END IF  
                       LET t_tbmb.tbmb05 = l_tbmb05[l_p]   #by arman 080624                                                    
                       SELECT imx00,imaag1  INTO l_imx00,l_imaag  FROM imx_file,ima_file WHERE imx000=ima01   #No.FUN-830116 
                                                                 AND ima01=t_tbmb.tbmb08
                       SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 1       
                        IF l_agbslk01='Y'  THEN                                             
                           SELECT imx01 INTO l_imx01 FROM imx_file  WHERE imx000=t_tbmb.tbmb08 
                        END IF                                                               
                        SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 2      
                        IF l_agbslk01='Y' THEN                                              
                           SELECT imx02 INTO l_imx02 FROM imx_file  WHERE imx000=t_tbmb.tbmb08 
                        END IF                                                               
                        SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 3      
                        IF l_agbslk01='Y' THEN                                              
                           SELECT imx03 INTO l_imx03 FROM imx_file  WHERE imx000=t_tbmb.tbmb08 
                        END IF                                                               
                        IF t_tbmb.tbmb05 IS NULL THEN
                           LET t_tbmb.tbmb05 = ' '
                        END IF
                        IF l_imx01 IS NULL THEN
                           LET l_imx01  = ' '
                        END IF
                        IF l_imx02 IS NULL THEN
                           LET l_imx02  = ' '
                        END IF
                        IF l_imx03 IS NULL THEN
                           LET l_imx03  = ' '
                        END IF
                       SELECT COUNT(*)  INTO l_count1 FROM boe_file WHERE boe01=l_imx00 and boe02=t_tbmb.tbmb01
                        AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                        AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                        AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                        AND boe06=t_tbmb.tbmb05
                       IF l_count1 <=0 THEN
                       SELECT COUNT(*)  INTO l_count1 FROM boe_file WHERE boe01=l_imx00 and boe02=t_tbmb.tbmb01
                        AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                        AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                        AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                        AND (boe06 IS NULL OR boe06 = ' ') 
                       END IF
                       LET l_boe07 = ''
                       LET l_boe08 = ''
                       SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_imx00 and boe02=t_tbmb.tbmb01
                        AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                        AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                        AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                        AND boe06=t_tbmb.tbmb05
                       IF (l_boe07 IS NULL OR l_boe07 = ' ') AND (l_boe08 IS NULL OR l_boe08 = ' ') THEN
                       SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_imx00 and boe02=t_tbmb.tbmb01
                        AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                        AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                        AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                        AND (boe06 IS NULL OR boe06 = ' ')
                       END IF
                       IF NOT cl_null(t_tbmb.tbmb05) THEN 
                       SELECT bmt07 INTO g_bmb.bmb06 FROM bmt_file WHERE bmt01 = g_bmb.bmb01
                                                        AND bmt02 = g_bmb.bmb02
                                                        AND bmt03 = g_bmb.bmb03
                                                        AND bmt04 = g_bmb.bmb04
                                                        AND bmt06 = t_tbmb.tbmb05 
                                                        AND bmt08 = g_bmb.bmb29
                       END IF
                       IF l_count1 <= 0 THEN     #NO.FUN-830116
                          LET t_tbmb.tbmb06 = g_bmb.bmb06
                          LET t_tbmb.tbmb07 = g_bmb.bmb08
                       ELSE
                         IF l_boe07 IS NULL OR l_boe07 = ' ' THEN
                            LET t_tbmb.tbmb06 = g_bmb.bmb06
                         ELSE
#                           SELECT TRIM(l_boe07) INTO l_s FROM DUAL #FUN-B30219 mark
#FUN-B30219 --Begin
                            LET l_boe07_1 = l_boe07
                            LET l_boe07_1 = l_boe07_1.trim()
                            LET l_s       = l_boe07_1
#FUN-B30219 --End
                            LET j=1
                            LET n=1
                            LET l_int = g_bmb.bmb06   #NO.FUN-830116
                            FOR i=1 TO length(l_s)
                             IF i = length(l_s)  THEN
                              IF l_s[j,j+1] = '$$' THEN
                              LET l_str1 = l_s[j+2,i]   #NO.FUN-830116
                                SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01 AND agb03 = l_str1
                                        IF l_e = '1' THEN
                                           LET p_flag = t_tbmb.tbmb02  #NO.FUN-830116
                                        END IF
                                        IF l_e = '2' THEN
                                           LET p_flag = t_tbmb.tbmb03  #NO.FUN-830116
                                        END IF
                                        IF l_e = '3' THEN
                                           LET p_flag = t_tbmb.tbmb04  #NO.FUN-830116
                                        END IF
                              ELSE
                               IF l_s[j,j] = '$' THEN
                               LET l_str1 = l_s[j+1,i]    #NO.FUN-830116
                                SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                        IF l_f = '1' THEN
                                           SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = g_c[z].c2  #NO.FUN-830116
                                        END IF
                                        IF l_f = '2' THEN
                                           SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = g_c[z].c2  #NO.FUN-830116
                                        END IF
                                        IF l_f = '3' THEN
                                           SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = g_c[z].c2   #NO.FUN-830116
                                        END IF
                               ELSE
                                LET l_str1 = l_s[j,i]     #No.FUN-830116
                                SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1  #NO.FUN-830116
                               END IF		
                              END IF
                              LET l_int = l_int,p_flag CLIPPED  #NO.FUN-830116
                             END IF  
                             IF l_s[i,i] = '_' THEN
                              IF l_s[j,j+1] = '$$' THEN
                                LET l_str1 = l_s[j+2,i-1]
                                SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                        IF l_e = '1' THEN
                                           LET p_flag = t_tbmb.tbmb02
                                        END IF
                                        IF l_e = '2' THEN
                                           LET p_flag = t_tbmb.tbmb03  #NO.FUN-830116
                                        END IF
                                        IF l_e = '3' THEN
                                           LET p_flag = t_tbmb.tbmb04  #NO.FUN-830116
                                        END IF
                              ELSE
                               IF l_s[j,j] = '$' THEN
                                LET l_str1 = l_s[j+1,i-1]
                                SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                        IF l_f = '1' THEN
                                           SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = g_c[z].c2  #NO.FUN-830116
                                        END IF
                                        IF l_f = '2' THEN
                                           SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = g_c[z].c2 END IF #NO.FUN-830116
                                        IF l_f = '3' THEN
                                           SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = g_c[z].c2 #NO.FUN-830116
                                        END IF
                               ELSE
                                LET l_str1 = l_s[j,i-1] CLIPPED
                                IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'
                                   OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN
                                   LET p_flag = l_str1
                                ELSE
                                   SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1 #NO.FUN-830116
                                END IF
                               END IF		
                              END IF
                                LET j=i+1
                                LET n=n+1
                             ELSE
                                CONTINUE FOR
                             END IF
                             LET l_int = l_int,p_flag CLIPPED  #NO.FUN-830116
                            END FOR

#FUN-B30219 --Begin mark
#                           LET ls_sql = "SELECT ",l_int," FROM DUAL"
#                           PREPARE power_curs FROM ls_sql                                                                         
#                           EXECUTE power_curs INTO li_result                                                                                                                
#FUN-B30219 --End mark
                            LET li_result = l_int
                            IF li_result IS NULL THEN
                               LET li_result = g_bmb.bmb06
                            END IF
                            LET t_tbmb.tbmb06 = li_result
                         END IF
                         IF l_boe08 IS NULL OR l_boe08 = '' THEN
                            LET t_tbmb.tbmb07 = g_bmb.bmb08
                         ELSE
#                           SELECT TRIM(l_boe08) INTO l_s FROM DUAL #FUN-B30219 mark
#FUN-B30219 --Begin
                            LET l_boe08_1 = l_boe08
                            LET l_s = l_boe08_1.trim()
#FUN-B30219 --End
                            LET j=1
                            LET n=1
                            LET l_int = g_bmb.bmb08    #No.FUN-830116
                            FOR i=1 TO length(l_s)
                             IF i = length(l_s)  THEN
                              IF l_s[j,j+1] = '$$' THEN
                                LET l_str1 = l_s[j+2,i]     #NO.FUN-830116
                                SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                        IF l_e = '1' THEN
                                           LET p_flag_1 = t_tbmb.tbmb02    #NO.FUN-830116
                                        END IF
                                        IF l_e = '2' THEN
                                           LET p_flag_1 = t_tbmb.tbmb03    #No.FUN-830116
                                        END IF
                                        IF l_e = '3' THEN
                                           LET p_flag_1  = t_tbmb.tbmb04   #NO.FUN-830116
                                        END IF
                              ELSE
                               IF l_s[j,j] = '$' THEN
                                LET l_str1 = l_s[j+1,i]    #No.FUN-830116
                                SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                        IF l_f = '1' THEN
                                           SELECT imx01 INTO p_flag_1  FROM imx_file WHERE imx000 = g_c[z].c2 #No.FUN-830116
                                        END IF
                                        IF l_f = '2' THEN
                                           SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[z].c2  #No.FUN-830116
                                        END IF
                                        IF l_f = '3' THEN
                                           SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[z].c2  #No.FUN-830116
                                        END IF
                               ELSE
                                LET l_str1 = l_s[j,i]    #NO.FUN-830116
                                SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1    #No.FUN-830116
                               END IF		
                              END IF
                              LET l_int = l_int,p_flag_1 CLIPPED  #NO.FUN-830116
                             END IF  
                             IF l_s[i,i] = '_' THEN
                              IF l_s[j,j+1] = '$$' THEN
                                LET l_str1 = l_s[j+2,i-1]
                                SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01 AND agb03 = l_str1
                                        IF l_e = '1' THEN
                                           LET p_flag_1  = t_tbmb.tbmb02    #No.FUN-830116
                                        END IF
                                        IF l_e = '2' THEN
                                           LET p_flag_1  = t_tbmb.tbmb03    #No.FUN-830116
                                        END IF
                                        IF l_e = '3' THEN
                                           LET p_flag_1  = t_tbmb.tbmb04    #No.FUN-830116
                                        END IF
                              ELSE
                               IF l_s[j,j] = '$' THEN
                                LET l_str1 = l_s[j+1,i-1]
                                SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                        IF l_f = '1' THEN
                                           SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[z].c2     #No.FUN-830116
                                        END IF
                                        IF l_f = '2' THEN
                                           SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[z].c2     #No.FUN-830116
                                        END IF
                                        IF l_f = '3' THEN
                                           SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[z].c2     #No.FUN-830116
                                        END IF
                               ELSE
                                LET l_str1 = l_s[j,i-1]
                                IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'
                                   OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN
                                   LET p_flag_1 = l_str1
                                ELSE
                                   SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1 #NO.FUN-830116
                                END IF
                               END IF		
                              END IF
                                LET j=i+1
                                LET n=n+1
                             ELSE
                                CONTINUE FOR
                             END IF
                             LET l_int = l_int,p_flag_1 CLIPPED  #NO.FUN-830116
                            END FOR

#FUN-B30219 --Begin
#                           LET ls_sql = "SELECT ",l_int," FROM DUAL"
#                           PREPARE power_cs FROM ls_sql                                                                         
#                           EXECUTE power_cs INTO li_result                                                                                                                
#FUN-B30219 --End mark
                            LET li_result = l_int      #FUN-B30219
                            IF li_result IS NULL THEN  #No.FUN-830116
                               LET li_result =g_bmb.bmb08  #No.FUN-830116
                            END IF                         #No.FUN-830116
                            LET t_tbmb.tbmb07 = li_result
                         END IF
                       END IF
                       UPDATE tbmb_file SET tbmb06 = t_tbmb.tbmb06,
                                            tbmb07 = t_tbmb.tbmb07 
                       WHERE  tbmb01 = t_tbmb.tbmb01
                         AND  tbmb02 = t_tbmb.tbmb02
                         AND  tbmb03 = t_tbmb.tbmb03
                         AND  tbmb04 = t_tbmb.tbmb04
                         AND  tbmb05 = t_tbmb.tbmb05
                       IF STATUS OR SQLCA.SQLCODE THEN 
                          CALL cl_err3("upd","tbmb_file","t_tbmb.tbmb01",SQLCA.sqlcode,"","updtbmb","",0)  
                           LET g_success = 'N'
                          RETURN                  #No.FUN-870117
                       END IF                                                                        
                        COMMIT WORK #ve007
                   SELECT MAX(bok32) INTO l_max_bok32 FROM bok_file WHERE bok01 = g_c[z].c2 AND bok31 = tm.a4    #NO.FUN-830116 add bok01
                   IF l_max_bok32 IS NULL THEN
                      LET l_max_bok32 = 0
                   END IF
                   LET l_max_bok32 = l_max_bok32+1  

                   IF tm.a3 IS NULL THEN 
                    SELECT MAX(bok02)  INTO l_bok02 FROM bok_file
                      WHERE bok01 = g_c[z].c2 AND bok29 = ' '
                   ELSE 
                    SELECT MAX(bok02)  INTO l_bok02 FROM bok_file
                      WHERE bok01 = g_c[z].c2 AND bok29 = tm.a3
                   END IF
                   SELECT sma46 INTO l_sma46 FROM sma_file                     
                       IF l_bok02 IS NULL THEN 
                        LET l_bok02 = 0
                       END IF
                        LET l_bok02 = l_bok02 + g_sma.sma19
                        LET l_bok03=t_tbmb.tbmb01
                       IF t_tbmb.tbmb02 IS NOT NULL THEN
                        LET l_bok03=l_bok03,l_sma46,t_tbmb.tbmb02
                       END IF
                       IF t_tbmb.tbmb03 IS NOT NULL THEN
                        LET l_bok03=l_bok03,l_sma46,t_tbmb.tbmb03
                       END IF
                       IF t_tbmb.tbmb04 IS NOT NULL THEN
                        LET l_bok03=l_bok03,l_sma46,t_tbmb.tbmb04
                       END IF
                       LET l_sum = l_sum + t_tbmb.tbmb06
                       IF NOT cl_null(l_tbmb05[l_p]) THEN   #TQC-BB0186 add
                          INSERT INTO bmh_file VALUES(g_c[z].c2,l_bok02,l_bok03,g_bmb.bmb04,l_p,l_tbmb05[l_p],t_tbmb.tbmb06,g_bmb.bmb29,tm.a4,l_max_bok32)
                          IF SQLCA.sqlcode THEN
                             CALL cl_err(g_c[z].c2,SQLCA.sqlcode,0)
                             LET g_success = 'N'
                             RETURN                 
                          END IF   
                       END IF  #TQC-BB0186 add    
                       IF l_p = 1 THEN                                                            
                            LET l_bok13 = l_tbmb05[1]
                       ELSE    
                            IF (Length(l_bok13) + Length(l_tbmb05[l_p])) > 8 THEN  
                               LET j = 10 - Length(l_bok13)    
                               FOR i=1 TO j                                                         
                                   LET l_bok13 = l_bok13 CLIPPED , '.'     
                               END FOR       
                               EXIT FOREACH                                                         
                            ELSE                                                                    
                               LET l_bok13= l_bok13 CLIPPED , ',', l_tbmb05[l_p]  
                            END IF  
                       END IF 
                       LET l_p = l_p + 1
                      END FOREACH
                       SELECT COUNT(*) INTO l_m FROM ima_file WHERE ima01=l_bok03
                       IF l_m <= 0 THEN
                          SELECT imaag INTO l_imaag1 FROM ima_file WHERE ima01 = t_tbmb.tbmb01
                          SELECT * INTO l_ima.* FROM ima_file WHERE ima01 = g_bmb.bmb03               #No.FUN-830116
                          LET l_ima.ima01 = l_bok03
                           
                          LET l_ima.imaag = '@CHILD'
                          LET l_ima.imaag1 = l_imaag1
                          LET l_ima.ima151 = 'N'           #No.FUN-830116
                          IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 ='N' END IF                  #No.FUN-9B0099
                          CALL p620_ima02(l_ima.ima01) RETURNING l_ima.ima02
                          LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
                          LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
                         #FUN-A80150---add---start---
                          IF cl_null(l_ima.ima156) THEN 
                             LET l_ima.ima156 = 'N'
                          END IF
                          IF cl_null(l_ima.ima158) THEN 
                             LET l_ima.ima158 = 'N'
                          END IF
                         #FUN-A80150---add---end---
                          LET l_ima.ima927='N'   #No:FUN-AA0014
                          #FUN-C20065 ---------Begin------------
                          IF cl_null(l_ima.ima159) THEN
                             LET l_ima.ima159 = '3' 
                          END IF    
                          #FUN-C20065 ---------End--------------
                          IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
                          IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
                          INSERT INTO ima_file VALUES (l_ima.*)
                          IF SQLCA.sqlcode THEN
                             CALL cl_err(l_ima.ima01,SQLCA.sqlcode,0)
                             LET g_success = 'N'
                             RETURN                  #No.FUN-870117
                          ELSE

                             LET g_success = 'Y'
                             MESSAGE 'INSERT O.K'            
                          END IF                           
                          INSERT INTO imx_file(imx000,imx00,imx01,imx02,imx03) 
                          VALUES (l_bok03,t_tbmb.tbmb01,t_tbmb.tbmb02,t_tbmb.tbmb03,t_tbmb.tbmb04) 
                          IF SQLCA.sqlcode THEN
                            CALL cl_err(l_bok03,SQLCA.sqlcode,0)
                             LET g_success = 'N'
                            RETURN                  #No.FUN-870117
       
                          END IF 
                       END IF

                       IF g_bmb.bmb09 IS NULL THEN
                         IF tm.a3 IS NULL THEN
                          SELECT COUNT(*) INTO l_k FROM bok_file 
                               WHERE bok01 = g_c[z].c2 AND bok03 = l_bok03 AND bok09  IS NULL AND bok29 = ' '
                         ELSE 
                          SELECT COUNT(*) INTO l_k FROM bok_file 
                               WHERE bok01 = g_c[z].c2 AND bok03 = l_bok03 AND bok09  IS NULL AND bok29 = tm.a3 	     
                         END IF        
                       ELSE
                       	 IF tm.a3 IS NULL THEN
                          SELECT COUNT(*) INTO l_k FROM bok_file 
                            WHERE bok01 = g_c[z].c2 AND bok03 = l_bok03 AND bok09 = g_bmb.bmb09  AND bok29 = ' '
                         ELSE
                         	SELECT COUNT(*) INTO l_k FROM bok_file 
                            WHERE bok01 = g_c[z].c2 AND bok03 = l_bok03 AND bok09 = g_bmb.bmb09  AND bok29 = tm.a3
                         END IF      
                       END IF
                       IF l_k <= 0 THEN
                            LET g_bok.bok01 = g_c[z].c2
                            LET g_bok.bok02 = l_bok02
                            LET g_bok.bok03 = l_bok03
                            IF l_sum <> 0 THEN
                            LET g_bok.bok06 = l_sum
                            ELSE
                            LET g_bok.bok06 = t_tbmb.tbmb06
                            END IF
                            LET g_bok.bok08 = t_tbmb.tbmb07
                            LET g_bok.bok13 = l_bok13       #by arman 080604
                            LET g_bok.bok31 = tm.a4
                            LET g_bok.bok32 = l_max_bok32
                            LET g_bok.bok33 = g_bmb.bmb02
                            IF  g_bmb.bmb09 IS NULL THEN
                              LET g_bmb.bmb09 = ' '
                            END IF 
                            INSERT INTO bok_file(bok31,bok32,bok01,bok02,bok03,bok04,bok05,bok06,bok07,bok08,bok09,bok10,bok10_fac,bok10_fac2,
                                        bok11,bok13,bok14,bok15,bok16,bok17,bok18,bok19,bok20,bok21,bok22,bok23,bok24,bok25,
                                        bok26,bok27,bok28,bokmodu,bokdate,bokcomm,bok29,bok30,bok33,bok34)  #NO.FUN-830116 add bok34
                             VALUES(g_bok.bok31,g_bok.bok32,g_bok.bok01,g_bok.bok02,g_bok.bok03,g_bmb.bmb04,g_bmb.bmb05,g_bok.bok06,
                                                        g_bmb.bmb07,g_bok.bok08,g_bmb.bmb09,g_bmb.bmb10,g_bmb.bmb10_fac,g_bmb.bmb10_fac2,
                                                        g_bmb.bmb11,g_bok.bok13,g_bmb.bmb14,g_bmb.bmb15,g_bmb.bmb16,g_bmb.bmb17,
                                                        g_bmb.bmb18,g_bmb.bmb19,g_bmb.bmb20,g_bmb.bmb21,g_bmb.bmb22,g_bmb.bmb23,g_bmb.bmb24,
                                                        g_bmb.bmb25,g_bmb.bmb26,g_bmb.bmb27,g_bmb.bmb28,g_bmb.bmbmodu,g_bmb.bmbdate,g_bmb.bmbcomm,
                                                        g_bmb.bmb29,'1',g_bok.bok33,g_bmb.bmb31            #NO.FUN-830116 add bmb31
                                                        )
                            IF SQLCA.sqlcode THEN
                                 CALL cl_err(g_c[z].c2,SQLCA.sqlcode,0)
                                 LET g_success = 'N'
                                  RETURN                  #No.FUN-870117
                            END IF
                       ELSE 
                       	 CALL cl_err(g_c[z].c2,-239,0)
                       	 LET g_success= 'N'  
                       	 RETURN
                       END IF
                       
                   
                 END FOREACH                    #by arman 080619                              
                 END IF                         #by arman 080619 
               END IF                          
               END FOREACH             
          END IF   
         END IF       #NO.FUN-830116
         SELECT COUNT(*) INTO l_count4 FROM bok_file WHERE bok01 = g_c[z].c2  AND bok31 = tm.a4
         IF l_count4 <=0 THEN
            DELETE FROM boj_file where boj01 = g_c[z].c2 AND boj09 = tm.a4
         END IF 
         END FOR       #NO.FUN-830116
END FUNCTION
 
FUNCTION p620_array_c()
  DEFINE  l_ac_t          LIKE type_file.num5,    #No.FUN-680096
          l_cnt           LIKE type_file.num5,    #No.FUN-680096 
          l_allow_insert  LIKE type_file.num5,    #No.FUN-680096 
          l_allow_delete  LIKE type_file.num5     #No.FUN-680096 
   DEFINE #l_sql           LIKE type_file.chr1000  #MOD-540142
          l_sql           STRING         #NO.FUN-910082
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_tf            LIKE type_file.num5    #NO.FUN-830116
   DEFINE l_count1        LIKE type_file.num5    #NO.FUN-830116
   DEFINE l_count2        LIKE type_file.num5    #NO.FUN-830116
   DEFINE l_k             LIKE type_file.num5    #NO.FUN-840137
   CALL cl_opmsg('s')
 
   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

         LET l_sql = " SELECT '',ima01,ima02 FROM ima_file,imx_file ",
                     "  WHERE imaacti='Y' ",
                     "    AND ima01=imx000 ",
                     "    AND imx00='",tm.a1,"'  ORDER BY ima01"
         PREPARE p620_c_1 FROM l_sql 
         DECLARE p620_c_1_curs
               CURSOR WITH HOLD FOR p620_c_1
         LET l_i = 1
         FOREACH p620_c_1_curs INTO  g_c[l_i].* 
           LET l_tf = 0
           IF SQLCA.sqlcode THEN 
                CALL s_errmsg('','','p620_c_curs',SQLCA.sqlcode,1)
                CONTINUE FOREACH
           ELSE
            FOR l_k=1 TO g_count 
             IF tm.a3 IS NULL THEN
                SELECT COUNT(*)  INTO l_count1 FROM  bmb_file,bma_file 
                                              WHERE  bmb01=bma01 
                                                AND  bmb01 = g_c[l_i].c2
                                                AND  bmb09 = g_b[l_k].b2
                                                AND  bma06 = ' '     #No.FUN-870117
             ELSE
                SELECT COUNT(*)  INTO l_count1 FROM  bmb_file,bma_file 
                                              WHERE  bmb01=bma01 
                                                AND  bmb01 = g_c[l_i].c2
                                                AND  bmb09 = g_b[l_k].b2
                                                AND  bma06 = tm.a3
             END IF 
             IF l_count1 <= 0 THEN
               LET l_tf = 0 
               EXIT FOR
             ELSE
               LET l_tf = 1
             END IF
            END FOR 
            IF tm.b3 = 'Y' THEN
               IF tm.a3 IS NULL THEN
                SELECT COUNT(*) INTO l_count2 FROM  bmb_file,bma_file 
                               WHERE  bmb01= bma01
                                 AND  bmb01= g_c[l_i].c2
                                 AND  (bmb09 =' ' OR bmb09 IS NULL)
                                 AND  bma06 = ' '      #No.FUN-870117
               ELSE
                SELECT COUNT(*) INTO l_count2 FROM  bmb_file,bma_file 
                               WHERE  bmb01= bma01
                                 AND  bmb01= g_c[l_i].c2
                                 AND  (bmb09 =' ' OR bmb09 IS NULL)
                                 AND  bma06 = tm.a3 
               END IF
               IF l_count2 <= 0 THEN
                 LET l_tf = 0 
               ELSE
                 LET l_tf = 1
               END IF
            END IF      
            LET g_success = 'Y'
            IF l_tf = 1 THEN
             LET l_i = l_i 
            ELSE
             LET g_c[l_i].c1 = 'N' 
             DISPLAY BY NAME g_c[l_i].c1
             DISPLAY BY NAME g_c[l_i].c2
             DISPLAY BY NAME g_c[l_i].c2_ima02
             LET l_i = l_i+1
            END IF
           END IF
          END FOREACH
          LET g_count1 = l_i - 1
          CALL g_c.deleteElement(l_i)
     IF g_count1 = 0 THEN
        CALL cl_err('','abm-324',1)
        RETURN
     END IF
     INPUT ARRAY g_c WITHOUT DEFAULTS FROM s_c.*
            
      BEFORE INPUT
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          
      BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_n  = ARR_COUNT()
          NEXT FIELD c1     
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT END IF
      ON ROW CHANGE
         LET g_c[l_ac].c1 =g_c[l_ac].c1 
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
      ON ACTION cancel
         CLEAR FORM
         CALL g_b.clear()
         CALL g_c.clear()
         LET g_flag = 'N'
         EXIT INPUT
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg
         CALL cl_cmdask()    
 
      ON ACTION controls                                      
   
   END INPUT
END FUNCTION
 
FUNCTION p620_create_tbok_file()
 DROP TABLE tbok_file
 DROP INDEX tbok_01
 CREATE TEMP TABLE tbok_file (
     tbok01 LIKE bod_file.bod02,
     tbok02 LIKE type_file.num5,
     tbok03 LIKE type_file.chr20,
     tbok04 LIKE type_file.chr10,
     tbok05 LIKE type_file.chr1);
 
CREATE unique INDEX tbok_01 on tbok_file(tbok01,tbok02,tbok04,tbok05);
END FUNCTION
 
FUNCTION p620_create_tbmb_file()
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
 
FUNCTION p620_ima02(p_ima01)
DEFINE p_ima01    LIKE ima_file.ima01,
       l_ps       LIKE sma_file.sma46,
       l_agd03    LIKE agd_file.agd03,
       l_ima02    LIKE ima_file.ima02
DEFINE field_array  DYNAMIC ARRAY OF LIKE type_file.chr1000
DEFINE i,k          LIKE type_file.num5
DEFINE l_tok        base.stringTokenizer
 
 SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps = ' '
    END IF
 
    IF NOT cl_null(p_ima01) THEN
       LET l_tok = base.StringTokenizer.createExt(p_ima01,l_ps,'',TRUE)
           IF l_tok.countTokens() > 0 THEN
              LET k=0
              WHILE l_tok.hasMoreTokens()
                    LET k=k+1
                    LET field_array[k] = l_tok.nextToken()
              END WHILE
           END IF
   END IF         
    
   FOR i =1 TO k
     IF i=1 THEN 
       SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = field_array[i]
     ELSE  
       SELECT agd03 INTO l_agd03 FROM agb_file,agd_file,ima_file                    #080522 by arman
                                WHERE ima01 = field_array[1] AND imaag = agb01 AND agb03= agd01   #080522 by arman
                                  AND agd02 = field_array[i] AND agb02 = i-1                      #080522 by arman
     END IF 
     IF l_agd03 IS NULL THEN
        LET l_ima02 = l_ima02 
     ELSE 
     	  LET l_ima02 = l_ima02 CLIPPED,l_ps,l_agd03
     END  IF 	       
   END FOR
   
   RETURN l_ima02
END FUNCTION    
#No:FUN-9C0077
