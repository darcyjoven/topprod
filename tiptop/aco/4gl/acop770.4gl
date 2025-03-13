# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: acop770.4gl
# Descriptions...: 出口報關清單擷取作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980014 09/08/31 By rainy INSERT加 plant code
# Modify.........: No.FUN-9B0072 09/11/10 By wujie 5.2SQL转标准语法 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-910088 11/12/31 By chenjing 增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
DEFINE g_cet    RECORD LIKE cet_file.*   #出口異動明細檔
DEFINE g_wc,g_sql  STRING  
DEFINE g_change_lang   LIKE type_file.chr1        
DEFINE g_wc3,g_oga27   STRING  
 
 
MAIN
   DEFINE l_flag         LIKE type_file.chr1               
   OPTIONS                                      
        INPUT NO WRAP
   DEFER INTERRUPT                         
 
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
        CALL p770_p1()  #條件輸入
        IF g_success='N' THEN    
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag
           IF l_flag THEN
             CONTINUE WHILE
           ELSE
             CLOSE WINDOW p770_w
             EXIT WHILE
           END IF               
        END IF         
      
        IF cl_sure(18,20) THEN
           LET g_success = 'Y'
           BEGIN WORK
           CALL p770_s1()  
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p770_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
      ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p770_s1()
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
 
 
FUNCTION p770_p1()
 DEFINE lc_cmd      LIKE type_file.chr1000      
 DEFINE p_row,p_col LIKE type_file.num5        
 
   LET p_row = 6  LET p_col =14
   OPEN WINDOW p770_w AT p_row,p_col WITH FORM "aco/42f/acop770"
        ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_init()
   CLEAR FORM
   CALL cl_opmsg('z')
   LET g_bgjob = "N"
   LET g_oga27 = ''
    
   WHILE TRUE
 
     CONSTRUCT BY NAME g_wc ON oga27,oga01,oga011,oga04
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
                 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oga27) #INVOICE號碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ofa"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga27
                  NEXT FIELD oga27
               WHEN INFIELD(oga01) #出貨通知單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "1"
                  LET g_qryparam.form = "q_oga7"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga01
                  NEXT FIELD oga01
               WHEN INFIELD(oga011) #出貨單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_oga8"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga011
                  NEXT FIELD oga011
               WHEN INFIELD(oga04) #出貨客戶
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_occ"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga04
                  NEXT FIELD oga04
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
 
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS 
         ON ACTION locale
            LET g_change_lang = TRUE       
            EXIT INPUT                                
         ON ACTION CONTROLR
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
 
         BEFORE INPUT
            CALL cl_set_comp_entry("g_bgjob",FALSE)  
            CALL cl_set_comp_entry("g_bgjob",TRUE)   
            CALL cl_qbe_init()
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
         CLOSE WINDOW p770_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "acop770"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('acop770','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED," '", g_wc CLIPPED,"'"
            CALL cl_cmdat('acop770',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p770_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE    
   END WHILE
END FUNCTION
 
 
FUNCTION p770_s1()
  DEFINE sr RECORD 
       ogb03 LIKE ogb_file.ogb03,   #項次
       ogb04 LIKE ogb_file.ogb04,   #料號
       ogb12 LIKE ogb_file.ogb12,   #數量
       ogb05 LIKE ogb_file.ogb05,   #銷售單位
       ogb13 LIKE ogb_file.ogb13,   #單價
       ogb14 LIKE ogb_file.ogb14    #總價
     END RECORD    
     
  DEFINE l_oga01  LIKE  oga_file.oga01,   #出貨/出通單號
         l_oga011 LIKE  oga_file.oga011,  #出貨/出通單號
         l_oga23  LIKE  oga_file.oga23,   #幣別
         l_oga04  LIKE  oga_file.oga04,   #送貨客戶編號
         l_oga02  LIKE  oga_file.oga02,   #出貨日期
         l_oga27  LIKE  oga_file.oga27,   #Invoice No. 
         l_cet04  LIKE  cet_file.cet04,   #料件編號
         l_cet11  LIKE  cet_file.cet11,   #海關代號
         l_cet15  LIKE  cet_file.cet15,   #異動數量(合同)
         l_cet16  LIKE  cet_file.cet16,   #異動單位(合同)
         l_cet31  LIKE  cet_file.cet31,   #法定數量一
         l_sfb95  LIKE  sfb_file.sfb95,   #特性代碼
         l_occ02  LIKE  occ_file.occ02,   #客戶簡稱
         l_cei04  LIKE  cei_file.cei04,   #海關商品編號
         l_cei11  LIKE  cei_file.cei11,   #歸併後序號
         l_ogd14t LIKE ogd_file.ogd14t,   #單位淨重(Kg)
         l_cnt    LIKE type_file.num5,    #
         l_cnt1   LIKE type_file.num5,    #
         l_ima18  LIKE ima_file.ima18,    #單位重量
         l_cei08  LIKE cei_file.cei08,    #申報計量單位 
         l_cei17  LIKE cei_file.cei17,    #第二法定單位
         l_cet32  LIKE cet_file.cet32     #法定數量二
  DEFINE l_sql    STRING       
  
  IF cl_null(g_wc) THEN LET g_wc = "1=1" END IF  
 
  DROP TABLE p770_tmp
#No.FUN-9B0072 --begin
  CREATE TEMP TABLE p770_tmp(
    cet04     LIKE type_file.chr50,    
    cet15     LIKE type_file.num20_6,  
    cet16     LIKE type_file.chr4,     
    cet37     LIKE type_file.num20_6,  
    cet35     LIKE type_file.chr4,     
    cet10     LIKE type_file.chr50,    
    cet17     LIKE type_file.chr20,    
    cet31     LIKE type_file.num20_6,  
    cet33     LIKE type_file.num20_6,  
    cet32     LIKE type_file.num20_6)   
#  CREATE TEMP TABLE p770_tmp(
#    cet04    VARCHAR(40),     #料件編號
#    cet15    DEC(13,3),    #異動數量
#    cet16    VARCHAR(4),      #異動單位
#    cet37    DEC(20,6),    #總價
#    cet35    VARCHAR(4),      #幣別
#    cet10    VARCHAR(40),     #商編
#    cet17    VARCHAR(20),     #BOM版本編號
#    cet31    DEC(13,3),    #法定數量一
#    cet33    DEC(13,3),    #淨重
#    cet32    DEC(13,3))    #法定數量二

#No.FUN-9B0072 --end
  DELETE FROM p770_tmp
 
  LET l_sql="INSERT INTO p770_tmp ",
            "VALUES(?,?,?,?,?,   ?,?,?,?,?)"
  PREPARE insert_p770 FROM l_sql
  IF STATUS THEN
    CALL cl_err('insert_p770:',status,1) 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
    EXIT PROGRAM
  END IF  
 
  BEGIN WORK
  
  
  LET g_success='Y'
 
  #取得出通資料(一般出貨、外銷)
  #oaz67 包裝單,INVOICE的出貨單號來源 1:出通單 2:出貨單
  SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'
  IF g_oaz.oaz67 = '1' THEN  #出通單
     LET g_sql= "SELECT oga01,oga23,oga04,oga02,oga27,oga011 ",  #出通單、幣別、送貨客戶編號,出貨日期,INVOICE,出貨單
                "  FROM oga_file ",
                " WHERE (oga00='1' OR oga00 = '4' ) ",
                "   AND (oga08='2' OR (oga00 = '4' AND oga08 = '3' ) ",
                "                  OR (oga00 = '1' AND oga08 = '3' ))",
                "   AND ogaconf='Y' AND oga09='1' ", 
                "   AND TRIM(oga27) IS NOT NULL ",
                "   AND oga30='Y' ",
                "   AND ", g_wc CLIPPED 
  ELSE  #出貨單
     
     LET g_wc = cl_replace_str(g_wc,'oga011','oga0_1') 
     LET g_wc = cl_replace_str(g_wc,'oga01','oga0_2')
     LET g_wc = cl_replace_str(g_wc,'oga0_1','oga01')
     LET g_wc = cl_replace_str(g_wc,'oga0_2','oga011')
     LET g_sql= "SELECT oga01,oga23,oga04,oga02,oga27,oga011 ",  #出貨單、幣別、送貨客戶編號,出貨日期,INVOICE,出通單
                "  FROM oga_file ",
                " WHERE (oga00='1' OR oga00 = '4' ) ",
                "   AND (oga08='2' OR (oga00 = '4' AND oga08 = '3' ) ",
                "                  OR (oga00 = '1' AND oga08 = '3' ))",
                "   AND ogaconf='Y' AND oga09='2' ", 
                "   AND TRIM(oga27) IS NOT NULL ",
                "   AND oga30='Y' ",
                "   AND ", g_wc CLIPPED 
 
  END IF
  DECLARE p770_curs CURSOR FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('dec curs_b',SQLCA.sqlcode ,1)
     LET g_success = 'N' 
     RETURN
  END IF
 
  FOREACH p770_curs INTO l_oga01,l_oga23,l_oga04,l_oga02,l_oga27,l_oga011  #出通單、幣別、送貨客戶編號,出貨日期,INVOICE
     IF STATUS THEN 
        CALL cl_err('foreach p770_curs',STATUS,1) 
        LET g_success='N' 
        EXIT FOREACH 
     END IF
 
     SELECT occ02 INTO l_occ02 FROM occ_file 
      WHERE occ01=l_oga04      
     
     SELECT COUNT(*) INTO l_cnt FROM cet_file WHERE cet01=l_oga01
     IF l_cnt=0 THEN
        LET l_cnt=1
        DELETE FROM p770_tmp  
 
                           #項次 料號 出貨數量 銷售單位，單價，總價
        LET g_sql ="SELECT ogb03,ogb04,ogb12,   ogb05,  ogb13,ogb14 ", 
                   "FROM ogb_file WHERE ogb01='",l_oga01,"'"                                   
        DECLARE p770_curs2 CURSOR FROM g_sql
        FOREACH p770_curs2 INTO sr.*
           IF STATUS THEN 
             CALL cl_err('foreach curs_b2',STATUS,1) 
             LET g_success='N' 
             EXIT FOREACH 
           END IF         
         
           LET l_cet04 = sr.ogb04
           CALL p770_get_qty(sr.ogb04,sr.ogb12,sr.ogb05)  #料號，數量，單位
              RETURNING l_cet15,l_cet16,l_cet31   #料號,數量，單位,法定數量
           LET l_cet15 = s_digqty(l_cet15,l_cet16)    #FUN-910088--add--
           LET l_cet31 = s_digqty(l_cet31,l_cet16)    #FUN-910088--add--
           IF g_success='N' THEN 
             EXIT FOREACH 
           END IF              
 
         #=====法定數量2進行計算 start ========
                 #淨重,申報單位元,法定二單位
           SELECT ima18,cei08,cei17 
             INTO l_ima18,l_cei08,l_cei17 
             FROM ima_file,cei_file  
            WHERE ima01=sr.ogb04 
              AND ima1010 = '1' 
              AND imaacti = 'Y' 
              AND cei15='Y' 
              AND ima01=cei03 
           IF SQLCA.sqlcode THEN
             CALL cl_err3("sel","ima_file","cei_file","","aco-737","","",1)
             LET g_success='N'
             EXIT FOREACH
           END IF            
  
           IF l_cei17=l_cei08 THEN   #第二法定單位=申報計量單位
             LET l_cet32=l_cet15     #法定數量2=異動數量
           ELSE
             IF l_cei17='KG' THEN
               LET l_cet32=l_cet15 * l_ima18
             ELSE
               LET l_cet32=0
             END IF
           END IF  
           LET l_cet32 = s_digqty(l_cet32,l_cet16)   #FUN-910088--add--
         #=====法定數量2進行計算 end ========
         
      
          #BOM版本預設已歸併的第一個版本 
           #LET l_sfb95 = ' '  #BOM版本暫用空白代入讓user維護
           SELECT MIN(cej02) INTO l_sfb95 FROM cej_file
            WHERE cej04 = sr.ogb04
              AND cej07 = 'Y'
           IF SQLCA.sqlcode OR cl_null(l_sfb95) THEN
              CALL cl_err(sr.ogb04,'aco-742',1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           
    
           SELECT cei04,cei11 INTO l_cei04,l_cei11  #商品編號，歸併後序號
             FROM ima_file,cei_file  
            WHERE ima01=sr.ogb04 
              AND ima1010 = '1' 
              AND imaacti = 'Y'
              AND cei15='Y' 
              AND ima01=cei03
 
           SELECT SUM(ogd14t) INTO l_ogd14t FROM ogd_file     #淨重
            WHERE ogd01=l_oga01
              AND ogd03=sr.ogb03
 
           EXECUTE insert_p770 USING
               l_cet04,l_cet15,l_cet16,sr.ogb14,l_oga23,
               l_cei04,l_sfb95,l_cet31,l_ogd14t,l_cet32                      
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","p770_tmp",l_oga01,sr.ogb04,SQLCA.sqlcode,"","INS-p770_tmp",1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           LET l_cnt=l_cnt+1         
        END FOREACH        
       
 
        IF g_success = 'Y' THEN
          LET l_cnt=1
        
          LET g_sql ="SELECT cet04,cet15,cet16,cet37,cet35,",  #料件編號,異動數量,異動單位,總價,幣別
                     "       cet10,cet17,cet31,cet33,cet32 ",  #商編,BOM版本,法定QTY1,淨重,法定QTY 2
                     "  FROM p770_tmp",
                     " ORDER BY cet04,cet10"
          DECLARE p770_curs3 CURSOR FROM g_sql
          FOREACH p770_curs3 INTO l_cet04,l_cet15,l_cet16,sr.ogb14,l_oga23,
                               l_cei04,l_sfb95,l_cet31,l_ogd14t,l_cet32
             IF STATUS THEN 
               CALL cl_err('foreach curs_b3',STATUS,1) 
               LET g_success='N' 
               EXIT FOREACH 
             END IF
             LET sr.ogb13=sr.ogb14/l_cet15    #單價
             
             LET l_cet11 = g_cez.cez03  #海關代號
 
             INSERT INTO cet_file(cet01,cet02,cet03,cet04,cet05,
                                  cet06,cet09,cet10,cet11,cet13,cet14,
                                  cet15,cet16,cet17,cet22,
                                  cet30,cet31,cet32,cet33,cet34,
                                  cet35,cet36,cet37, 
                                  cetconf,cetacti,cetuser,cetgrup,cetdate,cetplant,cetlegal,cetoriu,cetorig)   #FUN-980014 add plant/legal
                          VALUES (l_oga01,l_cnt,  l_oga02,l_cet04, l_oga04,
                                  l_occ02,'1',    l_cei04,l_cet11, sr.ogb12,sr.ogb05,
                                  l_cet15,l_cet16,l_sfb95,g_today,
                                  l_cei11,l_cet31,l_cet32,l_ogd14t,l_oga27,
                                  l_oga23,sr.ogb13,sr.ogb14,  
                                  'N','Y',g_user,g_grup,g_today,g_plant,g_legal, g_user, g_grup)  #FUN-980014 add plant/legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
            
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","cet_file",l_oga01,sr.ogb04,SQLCA.sqlcode,"","INS-cet_file",1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_cnt=l_cnt+1         
          END FOREACH       
        END IF  
        
        IF g_success='N' THEN
          EXIT FOREACH
        END IF
     ELSE 
        LET g_success='N'
     END IF  
  END FOREACH
 
  IF g_success='N' OR cl_null(l_oga01) THEN
    IF cl_null(l_oga01) THEN CALL cl_err(l_oga01,'aco-058',1) END IF
    LET g_success='N'
    ROLLBACK WORK
  ELSE
    COMMIT WORK
  END IF    
END FUNCTION
 
FUNCTION p770_get_qty(p_ogb04,p_ogb12,p_ogb05)
  DEFINE p_ogb04    LIKE ogb_file.ogb04, #料號
         p_ogb05    LIKE ogb_file.ogb05, #單位
         p_ogb12    LIKE ogb_file.ogb12  #數量
 
  DEFINE l_ima25    LIKE ima_file.ima25,  #庫存單位
         l_cei09    LIKE cei_file.cei09,  #法定計量單位
         l_ima18    LIKE ima_file.ima18,  #單位重量
         l_i        LIKE type_file.num5,
         l_fac      LIKE ima_file.ima31_fac,
         l_fac2     LIKE ima_file.ima31_fac
         
  DEFINE l_qty      LIKE type_file.num26_10, #歸并前數量(申報數量) 
         l_cei08    LIKE cei_file.cei08,     #歸并前單位(申報計量單位)
         l_qty1     LIKE type_file.num20_6   #法一數量
  
  LET l_qty=0
  LET l_cei09=''
  LET l_qty1=0
           
  SELECT ima25,cei08,cei09,ima18
      #庫存單位,申報單位,法定一單位,淨重
      INTO l_ima25,l_cei08,l_cei09,l_ima18
    FROM ima_file,cei_file  
    WHERE ima01=p_ogb04 
      AND ima1010 = '1' 
      AND imaacti = 'Y' 
      AND cei15='Y' 
      AND ima01=cei03
  IF SQLCA.sqlcode THEN
    CALL cl_err3("sel","ima_file",p_ogb04,"","aco-737","","",1)
    LET g_success='N'
  END IF            
  
  CALL s_umfchk(p_ogb04,p_ogb05,l_ima25)  #料號，來源單位，目標單位
    RETURNING l_i,l_fac
  IF l_i=1 THEN   #出現錯誤
    CALL cl_err3("sel","ima_file",p_ogb04,"","abm-731","","",1)
    LET g_success='N'
    RETURN l_qty,l_cei09,l_qty1
  END IF  
 
  CALL s_umfchk(p_ogb04,l_ima25,l_cei08)  #料號，來源單位，目標單位
    RETURNING l_i,l_fac2
  IF l_i=1 THEN   #出現錯誤
    CALL cl_err3("sel","ima_file",p_ogb04,"","abm-731","","",1)
    LET g_success='N'
    RETURN l_qty,l_cei09,l_qty1
  END IF  
  LET l_qty=p_ogb12*(l_fac*l_fac2)
 
  IF l_cei09=l_cei08 THEN
    LET l_qty1=l_qty
  ELSE
    IF l_cei09='KG' THEN
      LET l_qty1=l_qty * l_ima18
    ELSE
      LET l_qty1=0
    END IF
  END IF  
  
  RETURN l_qty,l_cei09,l_qty1
END FUNCTION
#FUN-930151
