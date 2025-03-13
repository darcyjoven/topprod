# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abmp626_bom.4gl
# Descriptions...: 多階正式BOM底稿批次產生作業   
# Date & Author..: FUN-870117 08/10/13 By ve007
# Modify.........: 08/10/28 FUN-8A0127 by ve007 屬性不對應的報錯信息的錯誤 
# Modify.........: 08/10/29 FUN-8A0129 by ve007 分隔符的問題
# Modify.........: 08/10/31 FUN-8A0145 by arman 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/17 By douzh 加上栏位为空的判断
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-B30219 11/03/31 By chenmoyan 處理DUAL
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值 
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  
         g_b  DYNAMIC ARRAY OF RECORD 
            b2         LIKE type_file.chr6
                   END RECORD,
         g_b_t         RECORD 
            b2         LIKE type_file.chr6
                   END RECORD,
         g_c  DYNAMIC ARRAY OF RECORD 
            c2         LIKE type_file.chr50
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
DEFINE   g_flag        LIKE type_file.chr1      
DEFINE   g_count       LIKE type_file.num5    
DEFINE   g_count1      LIKE type_file.num5      
DEFINE   g_bmz02       LIKE bmz_file.bmz02 
DEFINE   g_a3          LIKE type_file.chr20 
 

FUNCTION abmp626_bom(p_bmz02,p_a3)    
DEFINE   p_bmz02       LIKE bmz_file.bmz02 
DEFINE   p_a3          LIKE type_file.chr20   

   WHENEVER ERROR CALL cl_err_msg_log

   LET g_bmz02 = p_bmz02
   LET g_a3 = p_a3
     LET g_change_lang = FALSE
     LET g_flag = 'Y'
     CALL g_b.clear()
     CALL g_c.clear()
 
        CALL cl_wait()
        CALL s_showmsg_init()          
        CALL p626()
        IF g_totsuccess="N" THEN                                                     
          LET g_success="N"                                                         
        END IF                                                                       
        CALL s_showmsg()
        SELECT * INTO g_imz.*  FROM tbmt_file 
     CLEAR FORM
     ERROR ""
END FUNCTION
 
FUNCTION p626()
  DEFINE  l_ac_t          LIKE type_file.num5,   
          l_n             LIKE type_file.num5,   
          l_allow_insert  LIKE type_file.num5,   
          l_allow_delete  LIKE type_file.num5    
  DEFINE  l_count1        LIKE type_file.num5     
  DEFINE  l_count4        LIKE type_file.num5    
  DEFINE  l_success       LIKE type_file.chr1  
  DEFINE  z               LIKE type_file.num5  
  DEFINE  l_sql           STRING
  DEFINE  l_i             LIKE type_file.num5
   
  CALL cl_opmsg('s')
  
  LET l_ac_t = 0
  IF g_a3 IS NULL THEN
     LET l_sql = " SELECT UNIQUE bmb09 FROM bmb_file", 
              " WHERE  bmb01='",g_bmz02,"' ",
              "   AND  bmb04<='",g_today,"' ",
              "   AND (bmb05>'",g_today,"' OR bmb05 IS NULL OR bmb05='')"
                           
  ELSE
     LET l_sql = " SELECT UNIQUE bmb09 FROM bmb_file", 
                 " WHERE  bmb01='",g_bmz02,"' ",
                 "   AND  bmb04<='",g_today,"' ",
                 "   AND (bmb05>'",g_today,"' OR bmb05 IS NULL OR bmb05='')",
                 "   AND  bmb29='",g_a3,"' "
  END IF 
  PREPARE p620_b FROM l_sql 
  DECLARE p620_b_curs
       CURSOR WITH HOLD FOR p620_b
  LET l_i = 1
  LET g_count = 1
  FOREACH p620_b_curs INTO  g_b[g_count].* 
     IF SQLCA.sqlcode THEN 
        CALL s_errmsg('','','p620_b_curs',SQLCA.sqlcode,1)
        CONTINUE FOREACH
     ELSE
        LET g_success = 'Y'
     END IF
     IF NOT cl_null(g_b[g_count].b2) THEN 
        LET g_count = g_count + 1 
     END IF
  END FOREACH
  LET g_count = g_count - 1
  LET l_ac_t = 0
  LET l_allow_insert = FALSE
  LET l_allow_delete = FALSE
  
  LET l_sql =" SELECT bma01 FROM bma_file,ima_file ",
             "             WHERE bma01 = ima01     ",
             "               AND bma06 ='",g_a3,"' ",
             "               AND ima151 = 'N'      ",
             "               AND bma01 like '"     
  #No.FUN-8A0129 --begin--  
     IF g_sma.sma46 ='_' THEN 
        LET l_sql = l_sql,g_bmz02 CLIPPED ,"/",g_sma.sma46 CLIPPED,"%' escape '/'"
     ELSE 
     	  LET l_sql = l_sql,g_bmz02 CLIPPED ,g_sma.sma46 CLIPPED,"%' " 
     END IF 
  #No.FUN-8A0129  --end--   	    
  PREPARE p620_c_1 FROM l_sql 
  DECLARE p620_c_1_curs
      CURSOR WITH HOLD FOR p620_c_1
  LET l_i = 1
  LET g_count1 = 1
  FOREACH p620_c_1_curs INTO  g_c[g_count1].* 
    IF SQLCA.sqlcode THEN 
       CALL s_errmsg('','','p620_c_curs',SQLCA.sqlcode,1)          
       CONTINUE FOREACH
    ELSE
       LET g_success = 'Y'
    END IF
    IF NOT cl_null(g_c[g_count1].c2) THEN 
       LET g_count1 = g_count1 + 1 
    END IF
 
  END FOREACH
  LET g_count1 = g_count1 - 1
 
#  CALL p626_create_tbok_file()                         
#  CALL p626_create_tbmb_file() 
 
  FOR z=1 TO g_count1       
    CALL p626_mutil(g_c[z].c2,g_bmz02,0) RETURNING l_success
    IF l_success = 'N' THEN 
       LET g_success = 'N'
       RETURN 
    END IF    
  END FOR 
     
   SELECT COUNT(*) INTO l_count4 FROM bok_file WHERE bok01 = g_c[z].c2 
    IF l_count4 <=0 THEN
       DELETE FROM boj_file where boj01 = g_c[z].c2 
    END IF 
     
END FUNCTION
 
FUNCTION p626_mutil(p_ima01,p_bma01,p_x) 
 DEFINE  l_ac_t          LIKE type_file.num5,   
          l_n            LIKE type_file.num5,   
          l_allow_insert LIKE type_file.num5,   
          l_allow_delete LIKE type_file.num5    
  DEFINE 
         #l_sql           LIKE type_file.chr1000 
         l_sql       STRING      #NO.FUN-910082
  DEFINE l_i             LIKE type_file.num5
  DEFINE l_sum           LIKE type_file.num20_6
  DEFINE l_k             LIKE type_file.num5
  DEFINE l_h             LIKE type_file.num5   
  DEFINE l_m             LIKE type_file.num5
  DEFINE l_x             LIKE type_file.num5
  DEFINE l_y             LIKE type_file.num5 
  DEFINE l_r             LIKE type_file.num5
  DEFINE i               LIKE type_file.num5
  DEFINE j               LIKE type_file.num5
  DEFINE n               LIKE type_file.num5
  DEFINE k               LIKE type_file.num5     
  DEFINE l_bma02         LIKE bma_file.bma02,
         l_bma03         LIKE bma_file.bma03,
         l_bma04         LIKE bma_file.bma04,
         l_bma06         LIKE bma_file.bma06,
         l_bma07         LIKE bma_file.bma07,
         g_bmb           DYNAMIC ARRAY OF  RECORD LIKE bmb_file.*,
         g_bok           RECORD LIKE bok_file.*,
         l_boc           RECORD LIKE boc_file.*, 
         l_bmt           RECORD LIKE bmt_file.*,
         l_ima           RECORD LIKE ima_file.*,
         l_bod           RECORD LIKE bod_file.*,
         l_bmv04         DYNAMIC ARRAY OF LIKE bmv_file.bmv04,
         l_bmv05         DYNAMIC ARRAY OF LIKE bmv_file.bmv05,
         l_tbok01        DYNAMIC ARRAY OF LIKE type_file.chr50,   #No.FUN-8A0145
         l_tbok04        DYNAMIC ARRAY OF LIKE type_file.chr10,   #No.FUN-8A0145 
         l_bod06         DYNAMIC ARRAY OF LIKE type_file.chr10,   #No.FUN-8A0145
         l_bod06_1       DYNAMIC ARRAY OF LIKE type_file.chr10,   #No.FUN-8A0145
         l_tbmb05        DYNAMIC ARRAY OF LIKE type_file.chr10    #No.FUN-8A0145
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
  DEFINE l_boe08_1       STRING                        #FUN-B30219
  DEFINE l_bok03         LIKE bok_file.bok03
  DEFINE l_bok13         LIKE bok_file.bok13   
  DEFINE l_imaag1        LIKE ima_file.imaag
  DEFINE l_sma46         LIKE sma_file.sma46
  DEFINE l_int           LIKE type_file.chr1000
  DEFINE li_result       LIKE abb_file.abb25 
  DEFINE l_f             LIKE agb_file.agb02
  DEFINE l_e             LIKE agb_file.agb02
  DEFINE l_s             LIKE type_file.chr1000
  DEFINE 
         #ls_sql          LIKE type_file.chr1000
         ls_sql,l_sql5,l_sql6,l_sql7       STRING      #NO.FUN-910082
  #DEFINE l_sql5          LIKE type_file.chr1000
  #DEFINE l_sql6          LIKE type_file.chr1000
  #DEFINE l_sql7          LIKE type_file.chr1000
  DEFINE l_str1          LIKE type_file.chr6
  DEFINE l_boe07         LIKE boe_file.boe07
  DEFINE l_boe07_1       STRING                        #FUN-B30219
  DEFINE l_imx00         LIKE imx_file.imx00
  DEFINE l_imaag         LIKE ima_file.imaag
  DEFINE l_agbslk01     LIKE agb_file.agbslk01
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
  DEFINE l_imaicd        RECORD LIKE imaicd_file.*   
  DEFINE l_count         LIKE type_file.num5    
  DEFINE l_count1        LIKE type_file.num5     
  DEFINE l_count3        LIKE type_file.num5   
  DEFINE y               LIKE type_file.num5    
  DEFINE l_str           LIKE type_file.chr1000  
  DEFINE p_flag          LIKE boe_file.boe07     
  DEFINE p_flag_1        LIKE boe_file.boe07     
  DEFINE l_tbok01_t      LIKE bod_file.bod02    
  DEFINE l_tbok04_t      LIKE bod_file.bod06    
  DEFINE l_count4        LIKE type_file.num5    
  DEFINE l_n1            LIKE type_file.num5    
  DEFINE l_n2            LIKE type_file.num5    
  DEFINE l_n3            LIKE type_file.num5   
  DEFINE l_success       LIKE type_file.chr1
  DEFINE l_n4            LIKE type_file.num5    
  DEFINE z               LIKE type_file.num5
  DEFINE p_bma01         LIKE bma_file.bma01
  DEFINE p_ima01         LIKE ima_file.ima01
  DEFINE p_x             LIKE type_file.chr1
  DEFINE l_boj09_1       LIKE boj_file.boj09
  DEFINE l_bmb           DYNAMIC ARRAY OF  RECORD 
                         bmb01   LIKE bmb_file.bmb01,
                         bmb03   LIKE bmb_file.bmb03
                         END RECORD 
  DEFINE o               LIKE type_file.num5
  DEFINE l_i4            LIKE type_file.num5
  DEFINE l_i5            LIKE type_file.num5
  DEFINE l_tot           LIKE type_file.num5
  DEFINE l_ac1            LIKE type_file.num5
                         
  LET l_success ='Y' 
       
  LET l_str = ""
  FOR y = 1 TO g_count             
      LET l_str= l_str,"'",g_b[y].b2,"'",','
  END FOR
  
  IF l_str IS NOT NULL THEN
     LET l_str = l_str[1,length(l_str)-1]   
  END IF
  
  IF p_x = 0 THEN 
    IF g_a3 IS NULL THEN
          LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ", 
                      " WHERE   bmb01=bma01 AND bma01='",p_bma01,"' ",        
                      " AND bmb04<='",g_today,"' AND (bmb05>'",g_today,"' OR bmb05 IS NULL OR bmb05='') ",
                      " AND bmb29 = ' '",       
                      " ORDER BY bmb02 "
     ELSE
         LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ", 
                       " WHERE   bmb01=bma01 AND bma01='",p_bma01,"' AND bmb04<='",g_today,"' ", 
                       " AND (bmb05>'",g_today,"' OR bmb05 IS NULL OR bmb05='') AND bmb29='",g_a3,"' ", 
                       "  AND bmb29 = bma06 ",  
                       " ORDER BY bmb02 "
    END IF
  ELSE
    IF g_a3 IS NULL THEN
       LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ",
                   " WHERE bmb01=bma01 AND bma01='",p_bma01,"' AND bmb04<='",g_today,"' ",
                   " AND (bmb05>'",g_today,"' OR bmb05 IS NULL OR bmb05='') ",
                   " AND bmb29 = ' '",       
                   " ORDER BY bmb02 " 
    ELSE 
       LET l_sql = " SELECT unique bmb_file.* FROM bmb_file,bma_file ",
                         " WHERE bmb01=bma01 AND bma01='",p_bma01,"' AND bmb04<='",g_today,"' AND (bmb05>'",g_today,"' ",
                         "  OR bmb05 IS NULL OR bmb05='') ",
                         "  AND bmb29 = bma06 ",  
                         " AND bmb29='",g_a3,"' ORDER BY bmb02 " 
    END IF                                      
  END IF    
    PREPARE p626_bom FROM l_sql 
    DECLARE p626_bom_curs
      CURSOR WITH HOLD FOR p626_bom
    LET l_ac1 = 1  
    
    FOREACH p626_bom_curs INTO  g_bmb[l_ac1].*
       LET l_ac1=l_ac1 +1
    END FOREACH 
       
    LET l_tot =l_ac1 - 1 
    FOR l_i5 =1 TO l_tot
     
    IF SQLCA.sqlcode THEN 
       CALL s_errmsg('','','p626_bom_curs',SQLCA.sqlcode,1)
       CONTINUE FOR
    END IF
               
    IF g_bmb[l_i5].bmb30 = '4' THEN
       IF NOT s_control(g_bmb[l_i5].bmb01,g_bmb[l_i5].bmb03,g_a3) THEN
          CALL s_errmsg('',p_ima01 CLIPPED ,'','abm-623',1) 
          LET g_totsuccess='N'
          LET g_success = 'N'  
          EXIT FOR
       END IF          
    END IF
               
    IF g_bmb[l_i5].bmb30 = '1' THEN
       CALL cl_err_msg('','abmp_2',g_bmb[l_i5].bmb03 CLIPPED,0)
       SELECT MAX(pbmb02) INTO l_bok02 FROM pbmb_file WHERE pbmb01 = p_ima01                       
       IF l_bok02 IS NULL THEN 
          LET l_bok02 = 0
       END IF
       LET l_bok02 = l_bok02 + g_sma.sma19
       
       IF g_bmb[l_i5].bmb09 IS NULL THEN
            LET g_bmb[l_i5].bmb09 = ' ' 
       END IF
 
       INSERT INTO pbmb_file  
               VALUES  (p_ima01,l_bok02,g_bmb[l_i5].bmb03,g_bmb[l_i5].bmb04,g_bmb[l_i5].bmb05,
                        g_bmb[l_i5].bmb06,g_bmb[l_i5].bmb07,g_bmb[l_i5].bmb08,g_bmb[l_i5].bmb09,g_bmb[l_i5].bmb10,
                        g_bmb[l_i5].bmb10_fac,g_bmb[l_i5].bmb10_fac2,g_bmb[l_i5].bmb11,g_bmb[l_i5].bmb13,
                        g_bmb[l_i5].bmb14,g_bmb[l_i5].bmb15,g_bmb[l_i5].bmb16,g_bmb[l_i5].bmb17,g_bmb[l_i5].bmb18,
                        g_bmb[l_i5].bmb19,g_bmb[l_i5].bmb20,g_bmb[l_i5].bmb21,g_bmb[l_i5].bmb22,g_bmb[l_i5].bmb23,
                        g_bmb[l_i5].bmb24,g_bmb[l_i5].bmb25,g_bmb[l_i5].bmb26,g_bmb[l_i5].bmb27,g_bmb[l_i5].bmb28,
                        g_bmb[l_i5].bmbmodu,g_bmb[l_i5].bmbdate,g_bmb[l_i5].bmbcomm,
                        g_bmb[l_i5].bmb29,'1',g_bmb[l_i5].bmb31)            
       IF SQLCA.sqlcode THEN
          CALL cl_err(p_bma01,SQLCA.sqlcode,0)
          LET l_success = 'N'
          RETURN l_success                 
       END IF 
        
       DECLARE p626_bmt_curs
        CURSOR FOR (SELECT * FROM bmt_file WHERE bmt01= g_bmb[l_i5].bmb01 AND bmt02=g_bmb[l_i5].bmb02 AND bmt03 =g_bmb[l_i5].bmb03 
                    AND bmt04 = g_bmb[l_i5].bmb04 AND bmt08 =g_bmb[l_i5].bmb29) 
          
              FOREACH p626_bmt_curs INTO l_bmt.* 
                IF SQLCA.sqlcode THEN 
                   CALL s_errmsg('','','p626_bmt_curs',SQLCA.sqlcode,1)
                   CONTINUE FOREACH                                                       
                END IF 
                INSERT INTO tbmt_file VALUES(p_ima01,l_bok02,g_bmb[l_i5].bmb03,g_bmb[l_i5].bmb04,l_bmt.bmt05,l_bmt.bmt06,l_bmt.bmt07,g_bmb[l_i5].bmb29)
                IF SQLCA.sqlcode THEN
                   CALL cl_err(p_ima01,SQLCA.sqlcode,0)
                   LET l_success = 'N'
                   RETURN   l_success                
                END IF      
              END FOREACH
    ELSE
       IF g_bmb[l_i5].bmb30 = '4' THEN
          INITIALIZE t_tbmb.* TO NULL      
          CALL cl_err_msg('','abmp_1',g_bmb[l_i5].bmb03 CLIPPED,0)
          DELETE FROM tbok_file
          DELETE FROM tbmb_file      
          DECLARE p626_boc_curs
           CURSOR FOR (SELECT * FROM boc_file WHERE boc01= g_bmb[l_i5].bmb01 AND boc02=g_bmb[l_i5].bmb03)
          FOREACH p626_boc_curs INTO l_boc.* 
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('','','p626_boc_curs',SQLCA.sqlcode,1)
               CONTINUE FOREACH
            END IF
            INITIALIZE l_bod.* TO NULL      
            SELECT agb02 INTO l_a FROM agb_file WHERE agb01 =(SELECT  imaag FROM  ima_file WHERE ima01 = l_boc.boc02)
               AND agb03 = l_boc.boc04
            SELECT agb02 INTO l_b FROM agb_file WHERE agb01 =(SELECT  imaag FROM  ima_file WHERE ima01 = l_boc.boc01)
               AND agb03 = l_boc.boc03    
            IF l_b = '1' THEN
               SELECT imx01 INTO l_boj01a  FROM imx_file  WHERE  imx000=p_ima01  
            END IF 
            IF l_b = '2' THEN
               SELECT imx02 INTO l_boj01a  FROM imx_file  WHERE  imx000=p_ima01 
            END IF
            IF l_b = '3' THEN
               SELECT imx03 INTO l_boj01a  FROM imx_file  WHERE  imx000=p_ima01 
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
             WHERE  bmt01 = g_bmb[l_i5].bmb01
               AND  bmt02 = g_bmb[l_i5].bmb02
               AND  bmt03 = g_bmb[l_i5].bmb03
               AND  bmt04 = g_bmb[l_i5].bmb04
               AND  bmt08 = g_bmb[l_i5].bmb29
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
                  LET l_success = 'N'
                  RETURN  l_success  
               END IF
            END IF       
 
            LET l_sql5= "SELECT * FROM bod_file WHERE bod01='",l_boc.boc01,"' AND bod02='",l_boc.boc02,"' ",
                        "          AND bod03='",l_boc.boc03,"' AND bod04='",l_boc.boc04,"' AND bod05='",l_boj01a CLIPPED,"' " 
                                  
            SELECT COUNT(*) INTO l_count3 FROM bod_file WHERE bod01=l_boc.boc01 AND bod02=l_boc.boc02
               AND bod03=l_boc.boc03 AND bod04=l_boc.boc04 AND bod05=l_boj01a
               AND bod06 = g_bmb[l_i5].bmb13
            IF l_count3 >0 THEN
               LET l_sql5= "SELECT * FROM bod_file WHERE bod01='",l_boc.boc01,"' AND bod02='",l_boc.boc02,"' ",
                           "           AND bod03='",l_boc.boc03,"' AND bod04='",l_boc.boc04,"' AND bod05='",l_boj01a CLIPPED,"' ",
                           "           AND bod06 = '",g_bmb[l_i5].bmb13,"' "
            END IF
 
            PREPARE p626_bod FROM l_sql5 
            DECLARE p626_bod_curs
             CURSOR WITH HOLD FOR p626_bod
            FOREACH p626_bod_curs INTO l_bod.* 
              IF SQLCA.sqlcode THEN 
                 CALL s_errmsg('','','p626_bod_curs',SQLCA.sqlcode,1)
                 CONTINUE FOREACH
              END IF
                                
              IF NOT cl_null(l_bod.bod06) THEN
                 LET l_tbok01_t = l_bod.bod02
                 LET l_tbok04_t = l_bod.bod06
              END IF 
                               
              IF cl_null(g_bmb[l_i5].bmb13) THEN
                 IF cl_null(l_bod.bod06) THEN               
                    INSERT INTO tbok_file VALUES (l_bod.bod02,l_a,l_bod.bod07,' ','2')
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(l_bod.bod02,SQLCA.sqlcode,0)
                       LET l_success = 'N'
                       RETURN l_success                 
                    END IF
                 ELSE
                    CALL s_errmsg('',p_ima01 CLIPPED || "|" || l_boj01a CLIPPED 
                                  || "|" || g_bmb[l_i5].bmb03 CLIPPED || "|" || l_bod.bod06 CLIPPED,'','abm-029',1) 
                    LET g_totsuccess='N'
                    LET l_success = 'N'  
                 END IF
              ELSE
                 IF NOT cl_null(l_bod.bod06) THEN
                    INSERT INTO tbok_file VALUES (l_bod.bod02,l_a,l_bod.bod07,l_bod.bod06,'2')
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(l_bod.bod02,SQLCA.sqlcode,0)
                       LET l_success = 'N'
                       RETURN l_success                  
                    END IF
                 ELSE
                    LET l_sql6= " SELECT bmt06 FROM bmt_file WHERE bmt01='",g_bmb[l_i5].bmb01,"' AND bmt02='",g_bmb[l_i5].bmb02,"' ",
                                " AND bmt03='",g_bmb[l_i5].bmb03,"' AND bmt08='",g_bmb[l_i5].bmb29,"'     ", 
                                " AND bmt06 NOT IN ( SELECT bod06 FROM bod_file WHERE bod01 = '",l_boc.boc01,"' ",
                                " AND bod02 = '",l_boc.boc02,"' AND bod03 = '",l_boc.boc03,"' AND bod04 = '",l_boc.boc04,"' ",
                                " AND bod05 = '",l_boj01a CLIPPED,"' AND (bod06 IS NOT NULL AND bod06 <> ' ')) "
                    PREPARE p626_bod_1 FROM l_sql6 
                    DECLARE p626_bod_curs_1
                     CURSOR WITH HOLD FOR p626_bod_1
                    LET l_z=1
                    FOREACH p626_bod_curs_1 INTO l_bod06[l_z] 
                    IF SQLCA.sqlcode THEN 
                       CALL s_errmsg('','','p626_bod_curs_1',SQLCA.sqlcode,1)
                       CONTINUE FOREACH
                    END IF
                    INSERT INTO tbok_file VALUES (l_bod.bod02,l_a,l_bod.bod07,l_bod06[l_z],'2')
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(l_bod.bod02,SQLCA.sqlcode,0)
                       LET l_success = 'N'
                       RETURN l_success                
                    END IF
                    LET l_z = l_z + 1
                    END FOREACH
                 END IF
              END IF
            END FOREACH   
                                      
            IF l_bod.bod01 IS NULL THEN
                 CALL s_errmsg('',p_ima01 CLIPPED 
                            ||"|"||g_bmb[l_i5].bmb01 CLIPPED||"|"|| g_bmb[l_i5].bmb03 CLIPPED
                            ||"|"||l_boc.boc03 CLIPPED,'','abm-027',1)
               LET g_totsuccess='N'
               LET g_success = 'N'  
            END IF
          END FOREACH
          IF g_a3 IS NULL THEN             
             LET l_sql = " SELECT bmv04,MAX(bmv05) FROM bmv_file  ", 
                         " WHERE bmv01='",g_bmb[l_i5].bmb01,"' AND bmv02='",g_bmb[l_i5].bmb03,"' AND bmv03='",g_bmb[l_i5].bmb29,"' ",
                         " AND bmv05<='",g_today,"' AND (bmv06>'",g_today,"' OR bmv06 IS NULL OR bmv06='') ",
                         " AND bmv04 NOT IN(SELECT boc04 FROM boc_file WHERE boc01= '",g_bmb[l_i5].bmb01,"' ", 
                         " AND boc02='",g_bmb[l_i5].bmb03,"')  ",
                         " AND bmv03 = ' '",                  
                         " GROUP BY bmv04 "
          ELSE
             LET l_sql = " SELECT bmv04,MAX(bmv05) FROM bmv_file  ", 
                         " WHERE bmv01='",g_bmb[l_i5].bmb01,"' AND bmv02='",g_bmb[l_i5].bmb03,"' AND bmv03='",g_bmb[l_i5].bmb29,"' ",
                         " AND bmv05<='",g_today,"' AND (bmv06>'",g_today,"' OR bmv06 IS NULL OR bmv06='') ",
                         " AND bmv04 NOT IN(SELECT boc04 FROM boc_file WHERE boc01= '",g_bmb[l_i5].bmb01,"' ", 
                         " AND boc02='",g_bmb[l_i5].bmb03,"') AND bmv03='",g_a3,"'  GROUP BY bmv04 "
          END IF
          PREPARE p626_bmv FROM l_sql 
          DECLARE p626_bmv_curs
           CURSOR WITH HOLD FOR p626_bmv    
          LET l_x = 1
          FOREACH p626_bmv_curs INTO l_bmv04[l_x],l_bmv05[l_x] 
               IF SQLCA.sqlcode THEN 
                  CALL s_errmsg('','','p626_bmv_curs',SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               END IF
               IF g_a3 IS NULL THEN
                  SELECT bmv04,bmv07  INTO bmv04_l,bmv07_l FROM bmv_file WHERE bmv01=g_bmb[l_i5].bmb01 AND bmv02=g_bmb[l_i5].bmb03 AND bmv03=g_bmb[l_i5].bmb29
                     AND bmv04=l_bmv04[l_x] AND bmv05=l_bmv05[l_x]
                     AND (bmv06>g_today OR bmv06 IS NULL OR bmv06='')
                     AND bmv03  = ' '    
               ELSE
                  SELECT bmv04,bmv07  INTO bmv04_l,bmv07_l FROM bmv_file WHERE bmv01=g_bmb[l_i5].bmb01 AND bmv02=g_bmb[l_i5].bmb03 AND bmv03=g_bmb[l_i5].bmb29
                     AND bmv04=l_bmv04[l_x] AND bmv05=l_bmv05[l_x]
                     AND (bmv06>g_today OR bmv06 IS NULL OR bmv06='')
                     AND bmv03=g_a3
               END IF 
               IF bmv04_l IS NOT NULL THEN
                  SELECT agb02 INTO l_c FROM agb_file,ima_file WHERE agb01= imaag AND ima01=g_bmb[l_i5].bmb03 AND agb03=l_bmv04[l_x]
                  IF g_a3 IS NULL THEN
                     SELECT bmv08 INTO bmv08_l FROM bmv_file WHERE bmv01= g_bmb[l_i5].bmb01 AND bmv02 = g_bmb[l_i5].bmb03 
                        AND bmv04 = l_bmv04[l_x] AND bmv05 = l_bmv05[l_x]
                  ELSE
                     SELECT bmv08 INTO bmv08_l FROM bmv_file WHERE bmv01= g_bmb[l_i5].bmb01 AND bmv02 = g_bmb[l_i5].bmb03 
                        AND bmv04 = l_bmv04[l_x] AND bmv05 = l_bmv05[l_x] AND bmv03 = g_a3
                  END IF
                  IF bmv08_l='1' THEN
                     SELECT agb02 INTO l_d FROM agb_file,ima_file WHERE agb01=imaag AND ima01=g_bmb[l_i5].bmb01 AND agb03=bmv07_l
                     IF l_d = '1' THEN
                        SELECT imx01 INTO l_this FROM imx_file WHERE imx000 = p_ima01 
                     END IF
                     IF l_d = '2' THEN
                        SELECT imx02 INTO l_this FROM imx_file WHERE imx000 = p_ima01 
                     END IF
                     IF l_d = '3' THEN
                        SELECT imx03 INTO l_this FROM imx_file WHERE imx000 = p_ima01 
                     END IF
                  ELSE
                     LET l_this = bmv07_l   
                  END IF 
               END IF
               IF NOT cl_null(g_bmb[l_i5].bmb13) THEN
                  LET l_tbok01_t = g_bmb[l_i5].bmb03
                  LET l_tbok04_t = g_bmb[l_i5].bmb13
               END IF 
               IF NOT cl_null(g_bmb[l_i5].bmb13) THEN
                  LET l_sql6= " SELECT bmt06 FROM bmt_file WHERE bmt01='",g_bmb[l_i5].bmb01,"' AND bmt02='",g_bmb[l_i5].bmb02,"' ",
                              " AND bmt03='",g_bmb[l_i5].bmb03,"' AND bmt04='",g_bmb[l_i5].bmb04,"' AND bmt08='",g_bmb[l_i5].bmb29,"' "
                  PREPARE p626_bod_2 FROM l_sql6 
                  DECLARE p626_bod_curs_2
                   CURSOR WITH HOLD FOR p626_bod_2
                  LET l_o = 1
                  FOREACH p626_bod_curs_2 INTO l_bod06_1[l_o] 
                    IF SQLCA.sqlcode THEN 
                       CALL s_errmsg('','','p626_bod_curs_2',SQLCA.sqlcode,1)
                       CONTINUE FOREACH
                    END IF
                    INSERT INTO tbok_file VALUES (g_bmb[l_i5].bmb03,l_c,l_this,l_bod06_1[l_o],'1')
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bmb[l_i5].bmb03,SQLCA.sqlcode,0)
                       LET l_success = 'N'
                       RETURN  l_success                
                    END IF
                    LET l_o = l_o + 1
                  END FOREACH
               ELSE
                  INSERT INTO tbok_file VALUES (g_bmb[l_i5].bmb03,l_c,l_this,' ','1')
               END IF
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_bod.bod02,SQLCA.sqlcode,0)
                  LET l_success = 'N'
                  RETURN l_success                 
               ELSE       
                  END IF
                  LET l_x = l_x + 1
               END FOREACH
               
               IF l_x = 1  AND cl_null(l_bod.bod01) THEN    #No.FUN-8A0127
                   CALL s_errmsg('',p_ima01 CLIPPED 
                            ||"|"||g_bmb[l_i5].bmb01 CLIPPED||"|"|| g_bmb[l_i5].bmb03 CLIPPED
                            ||"|"||l_boc.boc03 CLIPPED,'','abm-027',1)
                   LET g_totsuccess='N'
                   LET g_success = 'N'  
               END IF
               
               DECLARE p626_tbok_curs
                CURSOR FOR (SELECT DISTINCT tbok01,tbok04 FROM tbok_file)   
               LET l_j = 1  
               LET l_y = 1  
               FOREACH p626_tbok_curs INTO l_tbok01[l_y],l_tbok04[l_y] 
                 IF SQLCA.sqlcode THEN      
                    CALL s_errmsg('','','p626_tbok_curs',SQLCA.sqlcode,1)
                    CONTINUE FOREACH      
                 END IF                   
                 LET l_tbmb[l_j].tbmb01=l_tbok01[l_y]
                 LET l_tbmb[l_j].tbmb05=l_tbok04[l_y]
                 IF l_tbok04[l_y] IS NULL OR l_tbok04[l_y]='' THEN
                    LET l_tbmb[l_j].tbmb02 = '' 
                    LET l_tbmb[l_j].tbmb03 = ''
                    LET l_tbmb[l_j].tbmb04 = '' 
                    SELECT tbok03 INTO l_tbmb[l_j].tbmb02 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=1 
                       AND (tbok04 IS NULL OR tbok04='')
                    SELECT tbok03 INTO l_tbmb[l_j].tbmb03 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=2 
                       AND (tbok04 IS NULL OR tbok04='')
                    SELECT tbok03 INTO l_tbmb[l_j].tbmb04 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=3 
                       AND (tbok04 IS NULL OR tbok04='')
                 ELSE
                    LET l_tbmb[l_j].tbmb02 = ''   
                    SELECT tbok03 INTO l_tbmb[l_j].tbmb02 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=1 
                       AND tbok04=l_tbok04[l_y]
                    IF l_tbmb[l_j].tbmb02 IS NULL then
                       SELECT tbok03 INTO l_tbmb[l_j].tbmb02 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=1 
                          AND (tbok04 IS NULL OR tbok04='')
                    END IF  
                       LET l_tbmb[l_j].tbmb03 = ''   
                    SELECT tbok03 INTO l_tbmb[l_j].tbmb03 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=2 
                       AND tbok04=l_tbok04[l_y]
                    IF l_tbmb[l_j].tbmb03 IS NULL THEN
                       SELECT tbok03 INTO l_tbmb[l_j].tbmb03 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=2 
                          AND (tbok04 IS NULL OR tbok04='')
                    END IF  
                    LET l_tbmb[l_j].tbmb04 = ''   
                    SELECT tbok03 INTO l_tbmb[l_j].tbmb04 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=3 
                       AND tbok04=l_tbok04[l_y]
                    IF l_tbmb[l_j].tbmb04 IS NULL THEN
                       SELECT tbok03 INTO l_tbmb[l_j].tbmb04 FROM tbok_file  WHERE tbok01=l_tbok01[l_y] AND tbok02=3 
                          AND (tbok04 IS NULL OR tbok04='')
                    END IF           
                 END IF
                 LET l_tbmb[l_j].tbmb08=p_ima01
                 INSERT INTO tbmb_file values(l_tbmb[l_j].*)
                        
                 IF SQLCA.sqlcode THEN                             
                    CALL cl_err(l_tbmb[l_j].tbmb01,SQLCA.sqlcode,0)
                    LET l_success = 'N'      
                    RETURN l_success                                                                                                
                 END IF                                            
                 LET l_j=l_j+1
                 LET l_y=l_y+1
               END FOREACH
               
               LET o = 1
               CALL l_bmb.clear()
               DECLARE p626_tbmb_curs                                                                                               
                CURSOR FOR (SELECT DISTINCT tbmb01,tbmb02,tbmb03,tbmb04,'',tbmb06,tbmb07,tbmb08 FROM  tbmb_file)       
               FOREACH p626_tbmb_curs INTO t_tbmb.*                           
                  IF SQLCA.sqlcode THEN                                                   
                      CALL s_errmsg('','','p626_tbok_curs',SQLCA.sqlcode,1)                                                             
                      CONTINUE FOREACH                                                   
                   END IF
 
                   LET l_sql7 = " SELECT tbmb05 FROM tbmb_file WHERE tbmb01 = '",t_tbmb.tbmb01,"' ",           
                                "                              AND (tbmb02 = '",t_tbmb.tbmb02,"' OR tbmb02 IS NULL)  ",              
                                "                              AND (tbmb03 = '",t_tbmb.tbmb03,"' OR tbmb03 IS NULL)  ",              
                                "                              AND (tbmb04 = '",t_tbmb.tbmb04,"' OR tbmb04 IS NULL)  "  
                   PREPARE p626_bod_3 FROM l_sql7 
                   DECLARE p626_bod_curs_3
                   CURSOR WITH HOLD FOR p626_bod_3
                   LET l_p=1
                   LET l_sum=0
                   FOREACH p626_bod_curs_3 INTO l_tbmb05[l_p] 
                     IF SQLCA.sqlcode THEN 
                        CALL s_errmsg('','','p626_bod_curs_1',SQLCA.sqlcode,1)
                        CONTINUE FOREACH
                     END IF  
                     LET t_tbmb.tbmb05 = l_tbmb05[l_p]                                                     
                        
                     SELECT imx00,imaag1  INTO l_imx00,l_imaag  FROM imx_file,ima_file WHERE imx000=ima01  
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
                       SELECT bmt07 INTO g_bmb[l_i5].bmb06 FROM bmt_file WHERE bmt01 = g_bmb[l_i5].bmb01
                                                        AND bmt02 = g_bmb[l_i5].bmb02
                                                        AND bmt03 = g_bmb[l_i5].bmb03
                                                        AND bmt04 = g_bmb[l_i5].bmb04
                                                        AND bmt06 = t_tbmb.tbmb05 
                                                        AND bmt08 = g_bmb[l_i5].bmb29
                     END IF
                     
                     IF l_count1 <= 0 THEN    
                          LET t_tbmb.tbmb06 = g_bmb[l_i5].bmb06
                          LET t_tbmb.tbmb07 = g_bmb[l_i5].bmb08
                     ELSE
                        IF l_boe07 IS NULL OR l_boe07 = ' ' THEN
                            LET t_tbmb.tbmb06 = g_bmb[l_i5].bmb06
                        ELSE
#                           SELECT TRIM(l_boe07) INTO l_s FROM DUAL  #FUN-B30219
#FUN-B30219 --Begin
                            LET l_boe07_1 = l_boe07
                            LET l_boe07_1 = l_boe07_1.trim()
                            LET l_s       = l_boe07_1
#FUN-B30219 --End
                            LET j=1
                            LET n=1
                            LET l_int = g_bmb[l_i5].bmb06  
                            FOR i=1 TO length(l_s)
                             IF i = length(l_s)  THEN
                               IF l_s[j,j+1] = '$$' THEN
                                  LET l_str1 = l_s[j+2,i]   
                                  SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01 AND agb03 = l_str1
                                  IF l_e = '1' THEN
                                     LET p_flag = t_tbmb.tbmb02  
                                  END IF
                                  IF l_e = '2' THEN
                                     LET p_flag = t_tbmb.tbmb03 
                                  END IF
                                  IF l_e = '3' THEN
                                     LET p_flag = t_tbmb.tbmb04  
                                  END IF
                             ELSE
                                IF l_s[j,j] = '$' THEN
                                  LET l_str1 = l_s[j+1,i]   
                                  SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                  IF l_f = '1' THEN
                                     SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = p_ima01  
                                  END IF
                                  IF l_f = '2' THEN
                                     SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = p_ima01 
                                  END IF
                                  IF l_f = '3' THEN
                                     SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = p_ima01   
                                  END IF
                                ELSE
                                  LET l_str1 = l_s[j,i]     
                                  SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1  
                                END IF		
                             END IF
                             LET l_int = l_int,p_flag CLIPPED  
                         END IF  
                         IF l_s[i,i] = '_' THEN
                            IF l_s[j,j+1] = '$$' THEN
                               LET l_str1 = l_s[j+2,i-1]
                               SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                               IF l_e = '1' THEN
                                  LET p_flag = t_tbmb.tbmb02
                               END IF
                               IF l_e = '2' THEN
                                  LET p_flag = t_tbmb.tbmb03
                               END IF
                               IF l_e = '3' THEN
                                  LET p_flag = t_tbmb.tbmb04
                               END IF
                            ELSE
                               IF l_s[j,j] = '$' THEN
                                  LET l_str1 = l_s[j+1,i-1]
                                  SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                  IF l_f = '1' THEN
                                     SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = p_ima01  
                                  END IF
                                  IF l_f = '2' THEN
                                     SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = p_ima01 
                                  END IF
                                  IF l_f = '3' THEN
                                     SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = p_ima01 
                                  END IF
                               ELSE
                                  LET l_str1 = l_s[j,i-1] CLIPPED
                                  IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'
                                     OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN
                                     LET p_flag = l_str1
                                  ELSE
                                     SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1 
                                  END IF
                               END IF		
                            END IF
                            LET j=i+1
                            LET n=n+1
                          ELSE
                            CONTINUE FOR
                          END IF
                          LET l_int = l_int,p_flag CLIPPED  
                        END FOR
                          
#FUN-B30219 --Begin
#                           LET ls_sql = "SELECT ",l_int," FROM DUAL"
#                           PREPARE power_curs FROM ls_sql                                                                         
#                           EXECUTE power_curs INTO li_result                                                                                                                
#FUN-B30219 --End
                            LET li_result = l_int                #FUN-B30219
 
                            IF li_result IS NULL THEN
                               LET li_result = g_bmb[l_i5].bmb06
                            END IF
                            LET t_tbmb.tbmb06 = li_result
                         END IF
                         IF l_boe08 IS NULL OR l_boe08 = '' THEN
                            LET t_tbmb.tbmb07 = g_bmb[l_i5].bmb08
                         ELSE
#                           SELECT TRIM(l_boe08) INTO l_s FROM DUAL #FUN-B30219
#FUN-B30219 --Begin
                            LET l_boe08_1 = l_boe08
                            LET l_boe08_1 = l_boe08_1.trim()
                            LET l_s       = l_boe08_1
#FUN-B30219 --End
                            LET j=1
                            LET n=1
                            LET l_int = g_bmb[l_i5].bmb08    
                            FOR i=1 TO length(l_s)
                             IF i = length(l_s)  THEN
                              IF l_s[j,j+1] = '$$' THEN
                                LET l_str1 = l_s[j+2,i]     
                                SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                        IF l_e = '1' THEN
                                           LET p_flag_1 = t_tbmb.tbmb02    
                                        END IF
                                        IF l_e = '2' THEN
                                           LET p_flag_1 = t_tbmb.tbmb03   
                                        END IF
                                        IF l_e = '3' THEN
                                           LET p_flag_1  = t_tbmb.tbmb04   
                                        END IF
                              ELSE
                               IF l_s[j,j] = '$' THEN
                                LET l_str1 = l_s[j+1,i]   
                                SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                        IF l_f = '1' THEN
                                           SELECT imx01 INTO p_flag_1  FROM imx_file WHERE imx000 = p_ima01 
                                        END IF
                                        IF l_f = '2' THEN
                                           SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = p_ima01  
                                        END IF
                                        IF l_f = '3' THEN
                                           SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = p_ima01  
                                        END IF
                               ELSE
                                LET l_str1 = l_s[j,i]    
                                SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1    
                               END IF		
                              END IF
                              LET l_int = l_int,p_flag_1 CLIPPED 
                             END IF  
                             IF l_s[i,i] = '_' THEN
                              IF l_s[j,j+1] = '$$' THEN
                                LET l_str1 = l_s[j+2,i-1]
                                SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01 AND agb03 = l_str1
                                        IF l_e = '1' THEN
                                           LET p_flag_1  = t_tbmb.tbmb02    
                                        END IF
                                        IF l_e = '2' THEN
                                           LET p_flag_1  = t_tbmb.tbmb03    
                                        END IF
                                        IF l_e = '3' THEN
                                           LET p_flag_1  = t_tbmb.tbmb04   
                                        END IF
                              ELSE
                               IF l_s[j,j] = '$' THEN
                                LET l_str1 = l_s[j+1,i-1]
                                SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                        IF l_f = '1' THEN
                                           SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = p_ima01     
                                        END IF
                                        IF l_f = '2' THEN
                                           SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = p_ima01     
                                        END IF
                                        IF l_f = '3' THEN
                                           SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = p_ima01    
                                        END IF
                               ELSE
                                LET l_str1 = l_s[j,i-1]
                                
                                IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'
                                   OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN
                                   LET p_flag_1 = l_str1
                                ELSE
                                   SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1
                                END IF
                                
                               END IF		
                              END IF
                                LET j=i+1
                                LET n=n+1
                             ELSE
                                CONTINUE FOR
                             END IF
                             LET l_int = l_int,p_flag_1 CLIPPED  
                            END FOR
 
#FUN-B30219 --Begin
#                           LET ls_sql = "SELECT ",l_int," FROM DUAL"
#                           PREPARE power_cs FROM ls_sql                                                                         
#                           EXECUTE power_cs INTO li_result                                                                                                                
#FUN-B30219 --End mark
                            LET li_result = l_int          #FUN-B30219
                            IF li_result IS NULL THEN  
                               LET li_result =g_bmb[l_i5].bmb08  
                            END IF                         
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
                           LET l_success = 'N'
                          RETURN l_success
                       END IF                                                                        
                   
                   SELECT MAX(pbmb02)  INTO l_bok02 FROM pbmb_file  #FUN-870127
                    WHERE pbmb01 = p_ima01
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
                   INSERT INTO tbmt_file VALUES(p_ima01,l_bok02,l_bok03,g_bmb[l_i5].bmb04,l_p,l_tbmb05[l_p],t_tbmb.tbmb06,g_bmb[l_i5].bmb29)
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(p_ima01,SQLCA.sqlcode,0)
                      LET l_success = 'N'
                      RETURN  l_success                
                   END IF        
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
                     SELECT * INTO l_ima.* FROM ima_file WHERE ima01 = g_bmb[l_i5].bmb03               
                     LET l_ima.ima01 = l_bok03     
                     LET l_ima.imaag = '@CHILD'
                     LET l_ima.imaag1 = l_imaag1
                     LET l_ima.ima151 = 'N'          
                     IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 ='N' END IF                  #No.FUN-9B0099
                     CALL p626_ima02(l_ima.ima01) RETURNING l_ima.ima02
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
                    #FUN-C20065 ----------Begin-----------
                     IF cl_null(l_ima.ima159) THEN
                        LET l_ima.ima159 = '3'
                     END IF 
                    #FUN-C20065 ----------End-------------
                     IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
                     IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
                     INSERT INTO ima_file VALUES (l_ima.*)
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_ima.ima01,SQLCA.sqlcode,0)
                        LET l_success = 'N'                          
                        RETURN  l_success       
                     END IF                           
                     INSERT INTO imx_file(imx000,imx00,imx01,imx02,imx03) 
                     VALUES (l_bok03,t_tbmb.tbmb01,t_tbmb.tbmb02,t_tbmb.tbmb03,t_tbmb.tbmb04) 
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(l_bok03,SQLCA.sqlcode,0)
                        LET l_success = 'N'
                        RETURN  l_success                 
                     END IF 
                  END IF
                
                  LET g_bok.bok01 = p_ima01
                  LET g_bok.bok02 = l_bok02
                  LET g_bok.bok03 = l_bok03
                  IF l_sum <> 0 THEN
                     LET g_bok.bok06 = l_sum
                  ELSE
                     LET g_bok.bok06 = t_tbmb.tbmb06
                  END IF
                  LET g_bok.bok08 = t_tbmb.tbmb07
                  LET g_bok.bok13 = l_bok13 
                  INSERT INTO pbmb_file     
                                 VALUES(g_bok.bok01,g_bok.bok02,g_bok.bok03,g_bmb[l_i5].bmb04,g_bmb[l_i5].bmb05,g_bok.bok06,
                                        g_bmb[l_i5].bmb07,g_bok.bok08,g_bmb[l_i5].bmb09,g_bmb[l_i5].bmb10,
                                        g_bmb[l_i5].bmb10_fac,g_bmb[l_i5].bmb10_fac2,
                                        g_bmb[l_i5].bmb11,g_bok.bok13,g_bmb[l_i5].bmb14,
                                        g_bmb[l_i5].bmb15,g_bmb[l_i5].bmb16,g_bmb[l_i5].bmb17,
                                        g_bmb[l_i5].bmb18,g_bmb[l_i5].bmb19,
                                        g_bmb[l_i5].bmb20,g_bmb[l_i5].bmb21,
                                        g_bmb[l_i5].bmb22,g_bmb[l_i5].bmb23,g_bmb[l_i5].bmb24,
                                        g_bmb[l_i5].bmb25,g_bmb[l_i5].bmb26,g_bmb[l_i5].bmb27,
                                        g_bmb[l_i5].bmb28,g_bmb[l_i5].bmbmodu,g_bmb[l_i5].bmbdate,g_bmb[l_i5].bmbcomm,
                                        g_bmb[l_i5].bmb29,'1',g_bmb[l_i5].bmb31
                                        )
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(p_ima01,SQLCA.sqlcode,0)
                        LET l_success = 'N'
                        RETURN  l_success                       
                     END IF    
                  
                  LET l_bmb[o].bmb01 = t_tbmb.tbmb01
                  LET l_bmb[o].bmb03 = l_bok03
                  LET o = o + 1         
               END FOREACH                                               
       END IF                       
    END IF
    LET o = o-1
    FOR l_i4= 1 TO o 
    SELECT COUNT(*) INTO l_n4 FROM bma_file WHERE bma01 = l_bmb[l_i4].bmb01
     IF l_n4 > 0 THEN 
       CALL p626_mutil(l_bmb[l_i4].bmb03,l_bmb[l_i4].bmb01,1)  RETURNING l_success
       IF l_success = 'N' THEN 
          LET l_success = 'N'   
          RETURN l_success 
       END IF
    ELSE    
       EXIT FOR      
    END IF
    END FOR                            
  END FOR                    
 
   
  RETURN l_success              
END FUNCTION
 
#FUNCTION p626_create_tbok_file()
# DROP TABLE tbok_file
# DROP INDEX tbok_01
# CREATE TEMP TABLE tbok_file (
#     tbok01 varchar(40),
#     tbok02 numeric(05),
#     tbok03 varchar(20), 
#     tbok04 varchar(10),
#     tbok05 varchar(01)
#     )
#
#END FUNCTION
#
#FUNCTION p626_create_tbmb_file()
# DROP TABLE tbmb_file
# DROP INDEX tbmb_01
# CREATE TEMP TABLE tbmb_file (
#      tbmb01 varchar(40),
#      tbmb02 varchar(20),
#      tbmb03 varchar(20), 
#      tbmb04 varchar(20),
#      tbmb05 varchar(10), 
#      tbmb06 numeric(16,8),
#      tbmb07 numeric(6,3),  
#      tbmb08 varchar(40)  
#     )
#create unique index tbmb_01 on tbmb_file(tbmb01,tbmb02,tbmb03,tbmb04,tbmb05);
#END FUNCTION
 
FUNCTION p626_ima02(p_ima01)
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
       SELECT agd03 INTO l_agd03 FROM agb_file,agd_file,ima_file                    
                                WHERE ima01 = field_array[1] AND imaag = agb01 AND agb03= agd01   
                                  AND agd02 = field_array[i] AND agb02 = i-1                      
     END IF 
     IF l_agd03 IS NULL THEN
        LET l_ima02 = l_ima02 
     ELSE 
     	  LET l_ima02 = l_ima02 CLIPPED,l_ps,l_agd03
     END  IF 	       
   END FOR
   
   RETURN l_ima02
END FUNCTION    
#No.FUN-870117   
