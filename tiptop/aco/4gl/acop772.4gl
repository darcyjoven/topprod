# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: acop772.4gl
# Descriptions...: 合同進口明細擷取作業(電子帳冊)
# Date & Author..: FUN-930151 09/04/01 BY rainy 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980014 09/08/31 By rainy INSERT加 plant code
# Modify.........: No.FUN-9B0072 09/11/10 By wujie 5.2SQL转标准语法 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-910088 11/12/31 By chenjing  增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ceu    RECORD LIKE ceu_file.*
DEFINE g_t1     LIKE oay_file.oayslip            
DEFINE s_date   LIKE type_file.dat               
DEFINE g_wc,g_wc2,g_sql STRING                   
DEFINE yclose,mclose    LIKE type_file.num5     
DEFINE g_cnt            LIKE type_file.num5    
DEFINE g_msg            LIKE type_file.chr1000   
DEFINE g_i              LIKE type_file.num5      
DEFINE g_change_lang    LIKE type_file.chr1      
 
MAIN
   DEFINE l_flag        LIKE type_file.chr1   
 
   OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   INITIALIZE g_bgjob_msgfile TO NULL
 
   LET g_wc = ARG_VAL(1)  
   LET g_bgjob= ARG_VAL(2)
   IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   WHILE TRUE
     IF g_bgjob="N" THEN
        CALL p772_p1()
        IF g_success='N' THEN    
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag
           IF l_flag THEN
             CONTINUE WHILE
           ELSE
             CLOSE WINDOW p772_w
             EXIT WHILE
           END IF               
        END IF   
        
        
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success='Y'
           BEGIN WORK
           CALL p772_s1()
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p772_w
              EXIT WHILE
           END IF
       ELSE
          CONTINUE WHILE
       END IF
     ELSE
       LET g_success='Y'
       BEGIN WORK
       CALL p772_s1()
       IF g_success="Y" THEN
         COMMIT WORK
       ELSE
         ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
     END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION p772_p1()
  DEFINE p_row,p_col LIKE type_file.num5        
 
  LET p_row = 5  LET p_col =14
  OPEN WINDOW p772_w AT p_row,p_col WITH FORM "aco/42f/acop772"
    ATTRIBUTE(STYLE=g_win_style)
  CALL cl_ui_init()
  CLEAR FORM
 
  CALL cl_opmsg('z')
  LET g_bgjob = "N" 
 
  WHILE TRUE
     CONSTRUCT BY NAME g_wc ON rva09,rva06,rva05  #進口號碼,收貨日期,供應商
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(rva09) #INVOICE號碼
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_rva09"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rva09
               NEXT FIELD rva09
             WHEN INFIELD(rva05) #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_pmc1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rva05
                  NEXT FIELD rva05
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup') #FUN-980030
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p772_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM
      END IF
      
      IF g_wc = ' 1=1' THEN  
        CALL cl_err('',9046,0)
        LET g_success='N'
      ELSE    
        LET g_success='Y'       
      END IF                
 
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS 
        ON ACTION locale
          LET g_change_lang = TRUE                  
          EXIT INPUT                                
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        ON ACTION about         
           CALL cl_about()      
        ON ACTION help          
           CALL cl_show_help()  
        ON ACTION controlg      
           CALL cl_cmdask()     
        BEFORE INPUT
            CALL cl_qbe_init()
            CALL cl_set_comp_entry("g_bgjob",TRUE)  
        ON ACTION qbe_select
           CALL cl_qbe_select()
        ON ACTION qbe_save
           CALL cl_qbe_save()
     END INPUT
 
     IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()                
       CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
           LET INT_FLAG=0
           CLOSE WINDOW p772_w  
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM
     END IF
     EXIT WHILE
   END WHILE
END FUNCTION
 
 
 
FUNCTION p772_s1()
  DEFINE sr RECORD
      rva01  LIKE  rva_file.rva01,   #收貨單號
      rva06  LIKE  rva_file.rva06,   #收貨日期
      rva05  LIKE  rva_file.rva05,   #供應商
      rva09  LIKE  rva_file.rva09,   #進口號碼
      rvb05  LIKE  rvb_file.rvb05,   #料件編號
      rvb07  LIKE  rvb_file.rvb07,   #實收數量
      rvb86  LIKE  rvb_file.rvb86,   #計價單位
      pmc03  LIKE  pmc_file.pmc03,
      rvb02  LIKE  rvb_file.rvb02    #收貨單項次
    END RECORD 
    
  DEFINE l_ceu04  LIKE  ceu_file.ceu04,  #料件編號
         l_ceu10  LIKE  ceu_file.ceu10,  #海關商編
         l_ceu13  LIKE  ceu_file.ceu13,  #異動數量
         l_ceu14  LIKE  ceu_file.ceu14,  #異動單位
         l_ceu15  LIKE  ceu_file.ceu15,  #異動數量(合同)
         l_ceu16  LIKE  ceu_file.ceu16,  #異動單位(合同)
         l_ceu17  LIKE  ceu_file.ceu17,  #海關代號
         l_ceu31  LIKE  ceu_file.ceu31,  #歸併後序號
         l_ceu19  LIKE  ceu_file.ceu19,  #收貨單項次
         l_ceu09  LIKE  ceu_file.ceu09,
         l_cei04  LIKE cei_file.cei04,   #海關商編
         l_cei11  LIKE cei_file.cei11,   #歸併後序號
         l_cnt    LIKE type_file.num5,
         l_sql    STRING
    
  IF cl_null(g_wc) THEN LET g_wc = "1=1" END IF
 
  DROP TABLE p772_tmp
#No.FUN-9B0072 --begin
  CREATE TEMP TABLE p772_tmp(
     ceu04  LIKE type_file.chr50,    #料件編號
     ceu10  LIKE type_file.chr50,    #海關商品編號
     ceu13  LIKE type_file.num20_6,  #異動數量
     ceu14  LIKE type_file.chr4,     #異動單位
     ceu15  LIKE type_file.num20_6,  #異動數量(合同)
     ceu16  LIKE type_file.chr4,     #異動單位(合同)
     ceu31  LIKE type_file.chr10,    #歸併後序號
     ceu19  LIKE type_file.num5)     #收貨單項次
#  CREATE TEMP TABLE p772_tmp(
#     ceu04  VARCHAR(40),  #料件編號
#     ceu10  VARCHAR(40),  #海關商品編號
#     ceu13  DEC(15,3), #異動數量
#     ceu14  VARCHAR(4),   #異動單位
#     ceu15  DEC(15,3), #異動數量(合同)
#     ceu16  VARCHAR(4),   #異動單位(合同)
#     ceu31  VARCHAR(10),  #歸併後序號
#     ceu19  DEC(5,0)) #收貨單項次
#No.FUN-9B0072 --end
 
  DELETE FROM p772_tmp
  LET l_sql="INSERT INTO p772_tmp ",
            "VALUES(?,?,?,?,?,   ?,?,?)"
  PREPARE insert_p772 FROM l_sql
  IF STATUS THEN
    CALL cl_err('insert_p772:',status,1) 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
    EXIT PROGRAM
  END IF  
 
  BEGIN WORK
  LET g_success='Y'
  #獲取收貨單信息
  LET g_sql ="SELECT rva01,rva06,rva05,rva09 ", #收貨單號，收貨日期，廠商編號，INVOICE
             "  FROM rva_file ",
             " WHERE rvaconf='Y' ",
             "   AND TRIM(rva09) IS NOT NULL ",
             " AND ",g_wc CLIPPED
  DECLARE curs_a CURSOR FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('sel curs_a',SQLCA.sqlcode ,1)
     LET g_success = 'N' 
     RETURN
  END IF
  
  FOREACH curs_a INTO sr.rva01,sr.rva06,sr.rva05,sr.rva09 #收貨單號,收貨日期,廠商編號,INVOICE
     IF STATUS THEN 
        CALL cl_err('foreach curs_a',STATUS,1) 
        LET g_success='N' 
        EXIT FOREACH 
     END IF
     
     SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc01=sr.rva05  #供應商簡稱
 
 
     SELECT COUNT(*) INTO l_cnt FROM ceu_file WHERE ceu01=sr.rva01
     IF l_cnt=0 THEN
        LET l_cnt=1
        DELETE FROM p772_tmp  
 
        LET g_sql ="SELECT rvb05,rvb07,rvb86,rvb02 ", #料號，數量,單位,收貨單項次 
                   "  FROM rvb_file ",  
                   " WHERE rvb01='",sr.rva01,"'"
        DECLARE curs_b CURSOR FROM g_sql
        FOREACH curs_b INTO sr.rvb05,sr.rvb07,sr.rvb86,sr.rvb02   
          IF STATUS THEN 
            CALL cl_err('foreach curs_b',STATUS,1) 
            LET g_success='N' 
            EXIT FOREACH 
         END IF            
         
 
         LET l_ceu04 = sr.rvb05
 
         CALL p772_get_qty(sr.rvb05,sr.rvb07,sr.rvb86)  #料號，數量，單位
            RETURNING l_ceu15,l_ceu16   #數量，單位
         LET l_ceu15 = s_digqty(l_ceu15,l_ceu16)    #FUN-910088--add--
         IF g_success='N' THEN 
           EXIT FOREACH 
         END IF       
         
         SELECT cei04,cei11 
           INTO l_cei04,l_cei11  #商品編號,歸并后序號       
           FROM ima_file,cei_file  
          WHERE ima01=sr.rvb05 
            AND ima1010 = '1' 
            AND imaacti = 'Y'
            AND cei15='Y' 
            AND ima01=cei03
         
         LET l_ceu09 = '1'
 
         EXECUTE insert_p772 USING
             l_ceu04,l_cei04,sr.rvb07,sr.rvb86,l_ceu15,l_ceu16,
             l_cei11,sr.rvb02
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","p772_tmp",l_ceu04,'',SQLCA.sqlcode,"","INS-p772_tmp",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
 
         LET l_cnt=l_cnt+1         
       END FOREACH 
 
       IF g_success = 'Y' THEN
         LET l_cnt=1
     
         LET g_sql = "SELECT ceu04, ceu10, ceu13, ceu14, ceu15,",
                     "       ceu16, ceu31, ceu19 ",
                     "  FROM p772_tmp ",
                     " ORDER BY ceu04 "
                    
         DECLARE p772_curs3 CURSOR FROM g_sql
         FOREACH p772_curs3 INTO l_ceu04,l_ceu10,l_ceu13,l_ceu14,l_ceu15,
                                 l_ceu16,l_ceu31,l_ceu19
            IF STATUS THEN 
              CALL cl_err('foreach curs_b3',STATUS,1) 
              LET g_success='N' 
              EXIT FOREACH 
            END IF
 
            LET l_ceu17 = g_cez.cez03  #海關代號
 
            INSERT INTO ceu_file(ceu01,ceu02,ceu03,ceu04,ceu05,
                                 ceu06,ceu09,ceu10,ceu11,ceu13,
                                 ceu14,ceu15,ceu16,ceu17,
                                 ceu22,ceu31,ceu19,
                                 ceuconf,ceuacti,ceuuser,ceugrup,ceudate,ceuplant,ceulegal,ceuoriu,ceuorig)   #FUN-980014 add plant/legal
                          VALUES(sr.rva01,l_cnt,  sr.rva06,l_ceu04, sr.rva05,
                                 sr.pmc03,l_ceu09,l_ceu10, sr.rva09,sr.rvb07,
                                 l_ceu14 ,l_ceu15,l_ceu16, l_ceu17,
                                 g_today,l_ceu31,l_ceu19,   
                                 'N','Y',g_user,g_grup,g_today,g_plant,g_legal, g_user, g_grup)          #FUN-980014 add plant/legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ceu_file",sr.rva01,sr.rvb05,SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
       END IF
 
       IF g_success='N' THEN
         EXIT FOREACH
       END IF       
     END IF     
  END FOREACH
 
  IF g_success='N' OR cl_null(sr.rva01) THEN
    IF cl_null(sr.rva01) THEN CALL cl_err(sr.rva01,'aco-058',1) END IF
    LET g_success='N'
    ROLLBACK WORK
  ELSE
    COMMIT WORK
  END IF    
END FUNCTION
 
 
 
FUNCTION p772_get_qty(p_rvb05,p_rvb07,p_rvb86)
  DEFINE p_rvb05    LIKE rvb_file.rvb05, #料號
         p_rvb86    LIKE rvb_file.rvb86, #單位
         p_rvb07    LIKE rvb_file.rvb07  #數量
 
  DEFINE l_ima25    LIKE ima_file.ima25,  #庫存單位
         l_cei09    LIKE cei_file.cei09,  #法定計量單位
         l_ima18    LIKE ima_file.ima18,  #單位重量
         l_i        LIKE type_file.num5,
         l_fac      LIKE ima_file.ima31_fac,
         l_fac2     LIKE ima_file.ima31_fac
         
  DEFINE l_qty      LIKE type_file.num26_10, #歸并前數量(申報數量) 
         l_cei08    LIKE cei_file.cei08      #歸并前單位(申報計量單位)
  
  LET l_qty=0
  LET l_cei09=''
           
  SELECT ima25,cei08,cei09,ima18
      #庫存單位,申報單位,法定一單位,淨重
      INTO l_ima25,l_cei08,l_cei09,l_ima18
    FROM ima_file,cei_file  
    WHERE ima01=p_rvb05 
      AND ima1010 = '1' 
      AND imaacti = 'Y' 
      AND cei15='Y' 
      AND ima01=cei03
  IF SQLCA.sqlcode THEN
    CALL cl_err3("sel","cei_file",p_rvb05,"","aco-737","","",1)
    LET g_success='N'
    RETURN l_qty,l_cei09
  END IF            
  
  CALL s_umfchk(p_rvb05,p_rvb86,l_ima25)  #料號，來源單位，目標單位
    RETURNING l_i,l_fac
  IF l_i=1 THEN   #出現錯誤
    CALL cl_err3("sel","ima_file",p_rvb05,"","abm-731","","",1)
    LET g_success='N'
    RETURN l_qty,l_cei09
  END IF  
 
  CALL s_umfchk(p_rvb05,l_ima25,l_cei08)  #料號，來源單位，目標單位
    RETURNING l_i,l_fac2
  IF l_i=1 THEN   #出現錯誤
    CALL cl_err3("sel","ima_file",p_rvb05,"","abm-731","","",1)
    LET g_success='N'
    RETURN l_qty,l_cei09
  END IF  
  LET l_qty=p_rvb07*(l_fac*l_fac2)
 
  RETURN l_qty,l_cei09
END FUNCTION
#FUN-930151
 
 
