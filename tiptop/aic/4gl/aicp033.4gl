# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: aicp033.4gl 
# Descriptions...: ICD出貨通知單轉出貨單作業
# Date & Author..: FUN-7B0077 07/12/06 By Mike 
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830131 08/03/27 By mike 規格調整
# Modify.........: No.MOD-890023 08/09/04 By chenyu ICD功能修改
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980004 09/08/13 By TSD.danny2000 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AA0124 10/10/21 By sabrina 將TEMP TABLE語法移到BEGIN WORK前
# Modify.........: No.FUN-AB0061 10/11/16 By shenyang 出貨單加基礎單價字段ogb37 
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位無預設值修正
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.TQC-C30062 12/03/03 By bart 出通單不寫入idd_file 須改寫
# Modify.........: No.FUN-C30300 12/04/06 By bart 出通單刪除不會還原idc_file.idc21,造成重做亦無庫存可挑;出通單挑了刻號/BIN之後,出貨單會有挑不到的問題
# Modify.........: No.FUN-C30289 12/04/24 By bart 同步複製產生ogg_file
# Modify.........: No.FUN-C50097 12/06/05 By SunLM 因新增ogb50,51,52的not null欄位,所導致其他作業無法insert into資料的問題修正 
# Modify.........: No.FUN-D30084 13/03/25 By Elise 判斷增加多角出通單
# Modify.........: No.CHI-D30039 13/03/27 By Elise 修正FUN-D30084

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga		 RECORD LIKE oga_file.*
DEFINE g_ogb		 RECORD LIKE ogb_file.*
DEFINE g_no1             LIKE oga_file.oga011
DEFINE g_no2	         LIKE oga_file.oga01
DEFINE g_t1       	 LIKE oay_file.oayslip
DEFINE g_ogd13    	 LIKE ogd_file.ogd13      
DEFINE g_date2    	 LIKE oga_file.oga02
DEFINE g_buf             LIKE type_file.chr2
DEFINE g_oga011_t        LIKE oga_file.oga011
DEFINE g_cnt             LIKE type_file.num10   
DEFINE g_i               LIKE type_file.num5 
DEFINE g_flag            LIKE type_file.chr1
DEFINE g_msg             LIKE type_file.chr1000
DEFINE g_idd             RECORD LIKE idd_file.*
DEFINE g_idb             RECORD LIKE idb_file.*
DEFINE g_change_lang     LIKE type_file.chr1000
  
MAIN
   DEFINE ls_date  STRING 
 
   OPTIONS                                          #改變一些系統默認值
      INPUT NO WRAP
   DEFER INTERRUPT                                  #頡取中斷鍵,由程序處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
    
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                                                                    
      CALL cl_err('','aic-999',1)                                                                                                   
      EXIT PROGRAM
   END IF             
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   INITIALIZE g_bgjob_msgfile TO NULL              
   LET g_no1 = ARG_VAL(1)                          
  #SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_no1 AND oga09='1'                   #CHI-D30039 mark
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_no1 AND (oga09='1' OR oga09 = '5')  #CHI-D30039 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   OPEN WINDOW p033_w WITH FORM "aic/42f/aicp033"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_opmsg('z')
 
   WHILE TRUE
       CALL p033_p1()
       IF cl_sure(18,20) THEN
          #因DROP TABLE 此動作會使得TRANSACTION關閉
          #故在此先做
          DROP TABLE w
          DROP TABLE x
          DROP TABLE y
          DROP TABLE z
 
          CALL p033_create()      #MOD-AA0124 add
          BEGIN WORK
          LET g_success = 'Y'
          CALL p033_p2()
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_getmsg('aic-116',g_lang) RETURNING g_msg
             LET g_msg = g_msg CLIPPED,' ',g_no2 CLIPPED,' '
             CALL cl_msgany(10,20,g_msg)
             #產生成功后,自動執行axmt620,供用戶維護
            #LET g_msg="axmt620 '",g_no2,"' ' '"       #No.MOD-890023 mark
            #LET g_msg="axmt620_icd '",g_no2,"' ' '"   #No.MOD-890023 add #CHI-D30039 mark
            #CHI-D30039---add---S
             IF g_oga.oga09 = '2' THEN
                LET g_msg="axmt620_icd '",g_no2,"' ' '"  
             ELSE
                IF g_oga.oga09 = '4' THEN
                   LET g_msg="axmt820_icd '",g_no2,"' ' '"   
                END IF
             END IF
            #CHI-D30039---add---E 
             CALL cl_cmdrun(g_msg CLIPPED)
          ELSE
             ROLLBACK WORK
             CALL cl_err('','abm-020',1)
          END IF
          EXIT WHILE 
       ELSE
          CONTINUE WHILE
       END IF
   END WHILE
   CLOSE WINDOW p033_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p033_p1()
  DEFINE li_result  LIKE type_file.num5 
 
 #LET tm.wc = g_argv1   #No.FUN-830131
  LET g_date2 = TODAY
  LET g_no2 = NULL
 
  WHILE TRUE
      CLEAR FORM
     #No.FUN-830131  --begin
     #DISPLAY tm.wc TO FORMONLY.g_no1
 
     #CONSTRUCT BY NAME tm.wc ON g_no1 
 
        #AFTER FIELD g_no1
           #IF NOT cl_null(g_no1) THEN                                                                                              
              #SELECT * INTO g_oga.* FROM oga_file                                                                                  
              #WHERE oga01=g_no1 AND oga09='1'                                                                                     
              #IF STATUS THEN                                                                                                       
                 #CALL cl_err3("sel","oga_file",g_no1,"",STATUS,"","sel oga",0)                                       
                 #NEXT FIELD g_no1                                                                                                  
              #END IF                                                                                                               
                                                                                                                                    
              #IF g_oga.ogaconf != 'Y' THEN                                                                          
                 #CALL cl_err('ogaconf=N:','axm-184',0)                                                                             
                 #NEXT FIELD g_no1                                                                                                  
              #END IF                                                                                                               
           #END IF                                                                                                                  
        #ON ACTION locale
           #LET g_action_choice="locale"
           #EXIT CONSTRUCT
        #ON ACTION CONTROLP
           #CASE
              #WHEN INFIELD(g_no1)
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form="q_oga100"
                 #LET g_qryparam.state='c'
                 #LET g_qryparam.default1=g_no1
                 #CALL cl_create_qry() RETURNING g_no1
                 #DISPLAY BY NAME g_no1 
                 #NEXT FIELD g_no1
              #OTHERWISE EXIT CASE
           #END CASE
      
        #ON IDLE g_idle_seconds
           #CALL cl_on_idle()
           #CONTINUE CONSTRUCT
       
        #ON ACTION about
           #CALL cl_about()
 
        #ON ACTION help
           #CALL cl_show_help()
 
        #ON ACTION controlg
           #CALL cl_cmdask()
 
        #ON ACTION exit
           #LET INT_FLAG=1
           #EXIT CONSTRUCT
 
     #END CONSTRUCT
 
     #IF g_action_choice="locale" THEN
        #LET g_action_choice=""
        #CALL cl_dynamic_locale()
        #CONTINUE WHILE
    #END IF
 
    #IF INT_FLAG THEN
       #LET INT_FLAG=0
       #CLOSE WINDOW p033_w
       #EXIT PROGRAM 
    #END IF
 
    #IF g_no1="" THEN
       #CALL cl_err('','9046',0)
       #CONTINUE WHILE
    #END IF
    #INPUT BY NAME g_date2,g_no2 WITHOUT DEFAULTS 
     INPUT BY NAME g_no1,g_date2,g_no2 WITHOUT DEFAULTS
    #No.FUN-830131  --END
 
         BEFORE INPUT
            CALL cl_qbe_init()
      
         AFTER FIELD g_date2
           #No.FUN-830131  --BEGIN
           #IF cl_null(g_date2) THEN 
              #NEXT FIELD g_date2
           #END IF
           #No.FUN-830131  --END
 
            IF NOT cl_null(g_date2) THEN
               IF g_date2 <= g_oaz.oaz09 THEN
                  CALL cl_err('','axm-164',0) 
                  NEXT FIELD g_date2  
               END IF
 
               IF g_oaz.oaz03 = 'Y' AND NOT cl_null(g_sma.sma53) AND 
                  g_date2 <= g_sma.sma53 THEN
                  CALL cl_err('','mfg9999',0)
                  NEXT FIELD g_date2 
               END IF
            END IF
 
         AFTER FIELD g_no2
           #No.FUN-830131  --BEGIN
           #IF cl_null(g_no2) THEN
              #NEXT FIELD g_no2
           #END IF
           #No.FUN-830131  --END
           
           IF NOT cl_null(g_no2) THEN    #No.FUN-830131 
              CALL p033_check_no2() RETURNING li_result
              IF li_result=0 THEN
                 NEXT FIELD g_no2
              END IF
           END IF                        #No.FUN-830131  
 
        #No.FUN-830131  --BEGIN
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
        #取號動作應置于AFTER INPUT 以免取不到單號
           #CALL s_check_no(g_sys,g_no2,"",g_buf,"oga_file","oga01","")  #No.FUN-830131
            CALL s_check_no("axm",g_no2,"",g_buf,"oga_file","oga01","")  #No.FUN-830131 
             RETURNING li_result,g_no2
            DISPLAY BY NAME g_no2
            IF (NOT li_result) THEN
               NEXT FIELD g_no2
            END IF
        
           #CALL s_auto_assign_no(g_sys,g_no2,g_date2,g_buf,          #No.FUN-830131
            CALL s_auto_assign_no("axm",g_no2,g_date2,g_buf,          #No.FUN-830131 
                               "oga_file","oga01","","","")
                   RETURNING li_result,g_no2
            IF (NOT li_result) THEN
               CONTINUE WHILE
            END IF
            DISPLAY BY NAME g_no2       
        #---------------------------------------------
        #No.FUN-830131  --end
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
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
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION CONTROLP                  
            CASE
             #No.FUN-830131 --BEGIN
              WHEN INFIELD(g_no1)
                 CALL cl_init_qry_var()                                                                                            
                 LET g_qryparam.form="q_oga"   
                #LET g_qryparam.where= "  (oga09='1') "                #CHI-D30039 mark                                                                   
                 LET g_qryparam.where= "  (oga09='1' OR oga09 ='5') "  #CHI-D30039
                 LET g_qryparam.default1=g_no1                                                                                     
                 CALL cl_create_qry() RETURNING g_no1                                                                              
                 DISPLAY BY NAME g_no1                                                                                             
                 NEXT FIELD g_no1   
             #No.FUN-830131 --end 
              WHEN INFIELD(g_no2)       #查詢單據
                #SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_no1 AND oga09='1' #No.FUN-830131  #CHI-D30039 mark
                 SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_no1 AND (oga09='1' OR oga09='5')  #CHI-D30039
                 LET g_t1=g_no2[1,g_doc_len]  
                 LET g_buf='50'                                                                                                    
                #IF g_oga.oga00 = '3' THEN    #No.FUN-830131
                 IF g_oga.oga00 MATCHES '[37]' THEN  #No.FUN-830131                                                                                        
                    LET g_buf[2,2] = '3'                                                                                           
                 END IF                                                                                                            
                 IF g_oga.oga00 = '4' THEN                                                                                         
                    LET g_buf[2,2] = '4'                                                                                           
                 END IF                                                                                                            
                #IF g_oga.oga00 = '5' THEN   #No.FUN-830131                                                                                      
                   #LET g_buf[2,2] = '6'     #No.FUN-830131                                                                                      
                #END IF                      #No.FUN-830131                                                                                                
                #CALL q_oay(FALSE,FALSE,g_t1,g_buf,'AXM') RETURNING g_t1  #No.FUN-830131
                 CALL q_oay(FALSE,FALSE,g_t1,g_buf,"axm") RETURNING g_t1  #No.FUN-830131 
                 LET g_no2=g_t1                                                                      
                 DISPLAY BY NAME g_no2                                                                                             
                 NEXT FIELD g_no2            
           END CASE
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p033_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION p033_p2()
   DEFINE l_ogc       RECORD LIKE ogc_file.*   
   DEFINE l_ogb04     LIKE ogb_file.ogb04 
   DEFINE l_ogb12     LIKE ogb_file.ogb12     
   DEFINE l_sum_ogb12 LIKE ogb_file.ogb12 
   DEFINE l_sql       STRING                  
   DEFINE l_chr       LIKE type_file.chr1      #是否產生單頭
   DEFINE l_ima04     LIKE ima_file.ima04
   DEFINE l_ima08     LIKE ima_file.ima08
   DEFINE l_ogbi      RECORD LIKE ogbi_file.*  #No.FUN-7B0018
   DEFINE l_flag      LIKE type_file.chr1      #No.FUN-7B0018
   DEFINE l_imaicd04  LIKE imaicd_file.imaicd04  #No.MOD-890023 add
   #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08  #No.MOD-890023 add #FUN-BA0051 mark
   DEFINE l_ogg       RECORD LIKE ogg_file.*  #FUN-C30289      
   DEFINE l_oga09     LIKE oga_file.oga09     #CHI-D30039 add

   #先找出通單單身
   LET l_sql = " SELECT ogb04,ogb12 FROM oga_file,ogb_file ",
               "  WHERE ogb01='",g_no1 CLIPPED,"'",
               "    AND ogb01=oga01 ",
              #"    AND oga09='1'   ",                 #CHI-D30039 mark
               "    AND (oga09='1' OR oga09 = '5')  ", #CHI-D30039 
               "    AND ogaconf<>'X'"
   
   DECLARE p033_foreach CURSOR FROM l_sql
   
   LET l_chr='Y'
   FOREACH p033_foreach INTO l_ogb04,l_ogb12
      IF STATUS THEN
         CALL cl_err('p033_foreach:',STATUS,1)
         LET l_chr='N'  
         EXIT FOREACH   
      END IF
 
      LET l_sum_ogb12 = NULL 
      SELECT SUM(ogb12) INTO l_sum_ogb12
        FROM oga_file,ogb_file 
       WHERE oga011= g_no1 
         AND oga01 = ogb01 
         AND ogb04 = l_ogb04
         AND ogaconf <> 'X'
   
      IF cl_null(l_sum_ogb12) THEN
         LET l_sum_ogb12 = 0
      END IF
 
      IF l_sum_ogb12 < l_ogb12 THEN    #出貨單比出單數量少
         LET l_chr='Y'
         CONTINUE FOREACH              #可再產單頭
      ELSE
         LET l_chr='N'
         EXIT FOREACH
      END IF
   END FOREACH 
 
   IF l_chr='N' THEN  
      CALL cl_err('','axm-123',1)
      LET g_success='N' 
      RETURN 
   END IF
  
   SELECT oga011 INTO g_oga011_t 
     FROM oga_file
    WHERE oga01 = g_no1
 
   UPDATE oga_file SET oga011 = g_no2
    WHERE oga01 = g_no1
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
      CALL cl_err('upd oga011',SQLCA.SQLCODE,1) 
      LET g_success='N'
      RETURN
   END IF
 
   LET g_oga.oga01 = g_no2
   LET g_oga.oga02 = g_date2
   LET g_oga.oga011 = g_no1
  #LET g_oga.oga09 = '2'  #CHI-D30039 mark
  #CHI-D30039---add---S 
  #要依來源單據判斷是不是多角
   LET l_oga09 = ''
   SELECT oga09 INTO l_oga09 FROM oga_file
    WHERE oga01 = g_no1
   IF l_oga09 = '5' THEN
      LET g_oga.oga09 = '4'
   ELSE 
      IF l_oga09 = '1' THEN
         LET g_oga.oga09 = '2'
      END IF
   END IF
  #CHI-D30039---add---E
   LET g_oga.ogaconf = 'N' 
   LET g_oga.ogapost = 'N' 
   LET g_oga.ogaprsw = 0
   LET g_oga.oga55 = '0'
   LET g_oga.oga57 = '1'    #FUN-AC0055 add
   LET g_oga.ogamksg = g_oay.oayapr 
   LET g_oga.oga85 = ' '  #No.FUN-870007
   LET g_oga.oga94 = 'N'  #No.FUN-870007 
 
   LET g_oga.ogaplant = g_plant  #No.FUN-980004  
   LET g_oga.ogalegal = g_legal  #No.FUN-980004 
 
   LET g_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04

   LET g_oga.oga99 = ''    #CHI-D30039 add
   LET g_oga.oga905 = 'N'  #CHI-D30039 add

   INSERT INTO oga_file VALUES (g_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
      CALL cl_err('ins oga',SQLCA.SQLCODE,1)
      LET g_success='N' 
      RETURN
   END IF
   IF cl_null(g_ogb.ogb37) OR g_ogb.ogb37=0 THEN    #FUN-AB0061
      LET g_ogb.ogb37=g_ogb.ogb13                   #FUN-AB0061    
   END IF                               #FUN-AB0061    
 
  #SELECT * FROM ogb_file WHERE ogb01 = g_no1 INTO TEMP w      #MOD-AA0124 mark 
   INSERT INTO w SELECT * FROM ogb_file WHERE ogb01 = g_no1    #MOD-AA0124 add 
   UPDATE w SET ogb01 = g_no2
   #轉出貨單時計價數量需為零
   update w set ogb917 = 0 
    WHERE ogbiicd03 <> '0' 
   #UPDATE w SET ogb50 = '1' WHERE og50 IS NULL    #FUN-AB0096   #FUN-AC0055 mark
    UPDATE w SET ogb50 = 0 WHERE ogb50 is NULL #FUN-C50097
    UPDATE w SET ogb51 = 0 WHERE ogb51 is NULL #FUN-C50097
    UPDATE w SET ogb52 = 0 WHERE ogb52 is NULL #FUN-C50097
    UPDATE w SET ogb53 = 0 WHERE ogb53 is NULL #FUN-C50097
    UPDATE w SET ogb54 = 0 WHERE ogb54 is NULL #FUN-C50097
    UPDATE w SET ogb55 = 0 WHERE ogb55 is NULL #FUN-C50097    
   INSERT INTO ogb_file SELECT * FROM w
   #No.FUN-7B0018 080305 add --begin
   IF NOT s_industry('std') THEN
     #No.MOD-890023 modify --begin
     #SELECT ogb01,ogb03 
     #  INTO l_ogbi.ogbi01,l_ogbi.ogbi03
     #  FROM w
     # WHERE ogb01 = g_no2      
     #LET l_flag = s_ins_ogbi(l_ogbi.*,'')
      DECLARE ins_ogbi CURSOR FOR
       SELECT * FROM ogbi_file WHERE ogbi01 = g_no1
      FOREACH ins_ogbi INTO l_ogbi.*
         IF STATUS THEN
            CALL cl_err('ins_ogbi:',STATUS,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_ogbi.ogbi01=g_no2
         LET l_flag = s_ins_ogbi(l_ogbi.*,'')
      END FOREACH
     #No.MOD-890023 modify --end
   END IF
   #No.FUN-7B0018 080305 add --end  
 
   CALL p033_delall() #若沒有單身數據,就將單頭數據也刪除并將出貨通知單上的出貨單號恢復成舊值 
   IF g_success = 'N' THEN
      RETURN 
   END IF
   #FUN-C30300---begin mark
   ##復制出通單的idd_file給出貨單的idb_file
   #DECLARE p033_idd_cs CURSOR FOR
   #   SELECT * FROM ogb_file WHERE ogb01 = g_no1
   #                          ORDER BY ogb03
   #
   #FOREACH p033_idd_cs INTO g_ogb.*
   #  IF STATUS THEN
   #     CALL cl_err('p033_idd_cs:',STATUS,1)
   #     LET g_success = 'N'
   #     RETURN
   #  END IF
   #
   # #No.MOD-890023 modify --begin
   # #LET l_ima04 = NULL  LET l_ima08 = NULL                             
   # #SELECT ima04,ima08
   # #  INTO l_ima04,l_ima08 
   # #  FROM ima_file   
   # # WHERE ima01 = g_ogb.ogb04      
   # #                                                                           
   # #IF l_ima04 MATCHES '[12]' AND l_ima08 = 'Y' THEN 
   # #FUN-BA0051 --START mark--
   # # LET l_imaicd08 = NULL
   # # SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
   # #  WHERE imaicd01 = g_ogb.ogb04
   # # IF l_imaicd08 = 'Y' THEN
   # #FUN-BA0051 --END mark-- 
   # #No.MOD-890023 modify --begin
   # IF s_icdbin(g_ogb.ogb04) THEN   #FUN-BA0051  
   # #TQC-C30062---begin
   #     #DECLARE p033_idb_cs CURSOR FOR             
   #     # SELECT * FROM idd_file            
   #     #  WHERE idd10 = g_ogb.ogb01      
   #     #    AND idd11 = g_ogb.ogb03     
   #     #    AND idd01 = g_ogb.ogb04    
   #     #                                       
   #     #FOREACH p033_idb_cs INTO g_idd.*          
   #     #   IF STATUS THEN                                 
   #     #      CALL cl_err('p033_idb_cs:',STATUS,0)  
   #     #      LET g_success = 'N'                       
   #     #      RETURN                                   
   #     #   END IF                        
   #
   #     #   INITIALIZE g_idb.* TO NULL 
   #                                         
   #     #   LET g_idb.idb01 = g_idd.idd01     
   #     #   LET g_idb.idb02 = g_idd.idd02    
   #     #   LET g_idb.idb03 = g_idd.idd03   
   #     #   LET g_idb.idb04 = g_idd.idd04  
   #     #   LET g_idb.idb05 = g_idd.idd05 
   #     #   LET g_idb.idb06 = g_idd.idd06   
   #     #   LET g_idb.idb07 = g_no2 
   #     #   LET g_idb.idb08 = g_ogb.ogb03 
   #     #   LET g_idb.idb09 = g_date2      
   #     #   LET g_idb.idb10 = g_idd.idd29    
   #     #   LET g_idb.idb11 = g_idd.idd13   
   #     #   LET g_idb.idb12 = g_idd.idd07  
   #     #   LET g_idb.idb13 = g_idd.idd15 
   #     #   LET g_idb.idb14 = g_idd.idd16     
   #     #   LET g_idb.idb15 = g_idd.idd17    
   #     #   LET g_idb.idb16 = g_idd.idd18   
   #     #   LET g_idb.idb17 = g_idd.idd19  
   #     #   LET g_idb.idb18 = g_idd.idd20                    
   #     #   LET g_idb.idb19 = g_idd.idd21       
   #     #   LET g_idb.idb20 = g_idd.idd22      
   #     #   LET g_idb.idb21 = g_idd.idd23     
   #     #   LET g_idb.idb22 = ''                   
   #     #   LET g_idb.idb23 = ''                   
   #     #   LET g_idb.idb24 = ''                                    
   #     #   LET g_idb.idb25 = g_idd.idd25  
   #                                                          
   #     #   LET g_idb.idbplant = g_plant  #No.FUN-980004  
   #     #   LET g_idb.idblegal = g_legal  #No.FUN-980004
   #
   #     #   INSERT INTO idb_file VALUES(g_idb.*) 
   #     #   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
   #     #      CALL cl_err('ins idb_file:',SQLCA.SQLCODE,0)  
   #     #      LET g_success = 'N' 
   #     #      RETURN             
   #     #   END IF               
   #     #END FOREACH
   #     UPDATE idb_file
   #     SET idb07 = g_no2
   #     WHERE idb07 = g_no1 
   #     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
   #        CALL cl_err('ins idb_file:',SQLCA.SQLCODE,0)  
   #        LET g_success = 'N' 
   #        RETURN             
   #     END IF 
   #  #TQC-C30062---end
   #  END IF
   #END FOREACH
   #FUN-C30300---end mark
   #FUN-C30300---begin
   INSERT INTO b SELECT * FROM idb_file WHERE idb07 = g_no1
   UPDATE b SET idb07=g_no2
   INSERT INTO idb_file SELECT * FROM b
   #FUN-C30300--end

   #若有包裝單抓包裝單數量,否則抓出貨通知單數  
   DECLARE p033_curs CURSOR FOR
      SELECT * FROM ogb_file WHERE ogb01 = g_no2
   IF STATUS THEN
      CALL cl_err('p033_curs:',STATUS,1)
      LET g_success = 'N'
      RETURN 
   END IF
 
   FOREACH p033_curs INTO g_ogb.*
      IF STATUS THEN
         CALL cl_err('p033_curs:',STATUS,1) 
         LET g_success = 'N'
         RETURN
      END IF
 
      LET g_ogd13 = 0
      SELECT SUM(ogd13) INTO g_ogd13 FROM ogd_file 
       WHERE ogd01 = g_no1                  #通知單號
         AND ogd03 = g_ogb.ogb03            #項次
   END FOREACH

   DECLARE ins_ogg CURSOR FOR
      SELECT * FROM ogg_file WHERE ogg01 = g_no1
     FOREACH ins_ogg INTO l_ogg.*
        IF STATUS THEN
           CALL cl_err('ins_ogg:',STATUS,1)
           LET g_success = 'N'
           RETURN
        END IF
        LET l_ogg.ogg01=g_no2
        IF cl_null(l_ogg.ogg13) THEN LET l_ogg.ogg13 = 0 END IF #FUN-C50097
        INSERT INTO ogg_file VALUES(l_ogg.*)
        IF STATUS THEN
           CALL cl_err3("ins","ogg_file",l_ogg.ogg01,"",SQLCA.sqlcode,"","ins ogg",1)
           LET g_success = 'N'
           RETURN
        END IF 
     END FOREACH
 
  #SELECT * FROM ogc_file WHERE ogc01 = g_no1 INTO TEMP x       #MOD-AA0124 mark 
   INSERT INTO x SELECT * FROM ogc_file WHERE ogc01 = g_no1     #MOD-AA0124 add 
   UPDATE x SET ogc01=g_no2
   INSERT INTO ogc_file SELECT * FROM x
   
  #SELECT * FROM oao_file WHERE oao01 = g_no1 INTO TEMP y       #MOD-AA0124 mark  
   INSERT INTO y SELECT * FROM oao_file WHERE oao01 = g_no1     #MOD-AA0124 add 
   UPDATE y SET oao01=g_no2
   INSERT INTO oao_file SELECT * FROM y
   
  #SELECT * FROM oap_file WHERE oap01 = g_no1 INTO TEMP z       #MOD-AA0124 mark  
   INSERT INTO z SELECT * FROM oap_file WHERE oap01 = g_no1     #MOD-AA0124 add 
   UPDATE z SET oap01=g_no2
   INSERT INTO oap_file SELECT * FROM z
 
END FUNCTION
 
FUNCTION p033_delall()
 
   LET g_cnt = 0 
   SELECT COUNT(*) INTO g_cnt
     FROM ogb_file
    WHERE ogb01 = g_no2 
 
   #沒有單身數據,就將單頭數據也刪除
   IF g_cnt <= 0 THEN
      DELETE FROM oga_file WHERE oga01 = g_no2
 
      #將出貨通知單上的出貨單號恢復成舊值
      UPDATE oga_file SET oga011 = g_oga011_t 
       WHERE oga01=g_no1
 
      LET g_no2 = NULL
      DISPLAY g_no2 TO FORMONLY.g_no2
      
      #轉出貨單不成功,因單身無轉出資料
      CALL cl_err('','axm-620',1)
      LET g_success = 'N'
   END IF
   
END FUNCTION
 
FUNCTION p033_check_no2()                                                                                                           
   DEFINE li_result     LIKE type_file.num5        
  
  #SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_no1 AND oga09='1'  #No.FUN-830131 #FUN-D30084 mark                                                                                
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_no1 AND oga09 IN ('1','5')        #FUN-D30084                                                                                 
   LET g_buf='50'                                                                                                                   
  #IF g_oga.oga00 = '3' THEN  #No.FUN-830131
   IF g_oga.oga00 MATCHES '[37]' THEN  #No.FUN-830131                                                                                                        
      LET g_buf[2,2] = '3'                                                                                                          
   END IF                                                                                                                           
   IF g_oga.oga00 = '4' THEN                                                                                                        
      LET g_buf[2,2] = '4'                                                                                                          
   END IF                                                                                                                           
   IF g_oga.oga00 = '5' THEN                                                                                                        
      LET g_buf[2,2] = '6'                                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
   CALL s_check_no("axm",g_no2,"",g_buf,"oga_file","oga01","")
     RETURNING li_result,g_no2                                                                                                      
   IF (NOT li_result) THEN                                                                                                          
      RETURN FALSE                   
   END IF                                                                                                                           
   
  #No.FUN-830131  --BEGIN                                                                                                                                    
  #CALL s_auto_assign_no("axm",g_no2,g_date2,g_buf,"oga_file","oga01","","","")                                                     
   #RETURNING li_result,g_no2                                                                                                      
  #IF (NOT li_result) THEN                                                                                                          
     #RETURN FALSE                                                                                                                  
  #END IF  
  #No.FUN-830131  --END
                                                                                                                         
   RETURN TRUE                                                                                                                      
END FUNCTION
#MOD-AA0124---add---start---
FUNCTION p033_create()

   SELECT * FROM idb_file WHERE 1 <> 1 INTO TEMP b  #FUN-C30300
   
   SELECT * FROM ogb_file WHERE 1 <> 1 INTO TEMP w 

   SELECT * FROM ogc_file WHERE 1 <> 1 INTO TEMP x 
   
   SELECT * FROM oao_file WHERE 1 <> 1 INTO TEMP y
   
   SELECT * FROM oap_file WHERE 1 <> 1 INTO TEMP z
END FUNCTION
#MOD-AA0124---add---end---
 
#No.FUN-7B0077           
