# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: afap203.4gl
# Descriptions...: 財簽二FA系統傳票拋轉還原
# Date & Author..: No:FUN-B60140 11/08/23 By xxz "財簽二二次改善"追單
# Modify.........: No:MOD-BB0228 11/11/26 by johung 調整還原方式為作廢時，無法作廢問題
# Modify.........: No:FUN-BC0035 12/01/16 By Sakura 增加g_type=14判斷
# Modify.........: No:CHI-C20017 12/05/30 By wangrr 若g_bgjob='Y'時使用彙總訊息方式呈現
# Modify.........: No:MOD-C90162 12/09/21 By Polly AFTER FIELD g_existno1 的錯誤一律改為NEXT FIELD g_existno1
# Modify.........: No.FUN-D40105 13/06/25 by lujh 憑證編號開窗可多選
# Modify.........: No.TQC-D60072 13/04/28 by lujh 報錯訊息要有憑證編號

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql       string  #No:FUN-580092 HCN
DEFINE g_dbs_gl         LIKE type_file.chr21      
DEFINE p_plant          LIKE type_file.chr20     
DEFINE p_acc            LIKE aaa_file.aaa01    
DEFINE p_acc1           LIKE aaa_file.aaa01   
DEFINE gl_date          LIKE type_file.dat   
DEFINE gl_yy,gl_mm      LIKE type_file.num5  
DEFINE g_existno        LIKE type_file.chr20 
DEFINE g_existno1       LIKE type_file.chr20 
DEFINE g_type           LIKE type_file.num5  
DEFINE g_str            LIKE type_file.chr3  
DEFINE g_mxno           LIKE type_file.chr8  
DEFINE p_row,p_col      LIKE type_file.num5 
DEFINE g_aaz84          LIKE aaz_file.aaz84, #還原方式 1.刪除 2.作廢 no.4868
       g_change_lang    LIKE type_file.chr1                  #是否有做語言切換 

DEFINE   g_msg           LIKE type_file.chr1000  
#FUN-D40105--add--str--
DEFINE g_existno_str     STRING  
DEFINE bst base.StringTokenizer
DEFINE temptext STRING
DEFINE l_errno LIKE type_file.num10
DEFINE g_existno1_str STRING 
DEFINE tm   RECORD
            wc1         STRING
            END RECORD 
#FUN-D40105--add--end--
 
MAIN
DEFINE l_aba19           LIKE aba_file.aba19   
DEFINE l_abapost         LIKE aba_file.abapost 
DEFINE l_abaacti         LIKE aba_file.abaacti 
     DEFINE l_flag      LIKE type_file.chr1   
DEFINE l_aaa07          LIKE aaa_file.aaa07   
DEFINE l_aba20           LIKE aba_file.aba20  


   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant   = ARG_VAL(1)           #
   LET p_acc     = ARG_VAL(2)           #
   LET g_existno = ARG_VAL(3)           #
   LET g_type    = ARG_VAL(4)           #
   LET g_bgjob   = ARG_VAL(5)           #背景作業
   LET p_acc1    = p_acc
   LET g_existno1= g_existno
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

   IF g_faa.faa31 = 'N' THEN
      CALL cl_err('','afa-260',1)
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL cl_opmsg('z')

   LET g_success = 'Y'

   WHILE TRUE
      CALL s_showmsg_init() #CHI-C20017 add
      IF g_bgjob = "N" THEN
         CALL p203_ask()
         #FUN-D40105--add--str--
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE  
         END IF
         IF cl_null(g_type) THEN 
            CALL cl_err('','9033',0)
            CONTINUE WHILE
         END IF 
         #FUN-D40105--add--end--
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            #FUN-D40105--add--str--
            CALL p203_existno_chk()
            IF g_success = 'N' THEN 
                CALL s_showmsg()
                CONTINUE WHILE 
            END IF 
            #FUN-D40105--add--end--
            CALL p203() 
            CALL s_showmsg() #CHI-C20017 add
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
               CLOSE WINDOW p203
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_plant_new=p_plant                                                
         CALL s_getdbs()                                                        
         LET g_dbs_gl=g_dbs_new    

         LET tm.wc1 = "g_existno1 IN ('",g_existno1,"')"  #FUN-D40105  add
         CALL p203_existno_chk()  #FUN-D40105  add
         #FUN-D40105--mark--str--
         #LET g_sql="SELECT aba02,abapost,aba19,abaacti,aba20 ",
         #          #"  FROM ",g_dbs_gl,"aba_file",#FUN-90088 mark
         #          "  FROM ",cl_get_target_table(g_plant_new,'aba_file')  ,#No:FUN-B60140 add
         #          " WHERE aba01 = ? AND aba00 = ? AND aba06='FA'"
         #CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
         #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add 
         #PREPARE p203_t_p11 FROM g_sql
         #DECLARE p203_t_c11 CURSOR FOR p203_t_p11
         #IF STATUS THEN
         #   #CALL cl_err('decl aba_cursor:',STATUS,0) #CHI-C20017 mark
         #   CALL s_errmsg('','','decl aba_cursor:',STATUS,1)  #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN    #CHI-C20017 mark
         #END IF
         #OPEN p203_t_c11 USING g_existno,g_faa.faa02c
         #FETCH p203_t_c11 INTO gl_date,l_abapost,l_aba19,l_abaacti,l_aba20
         #IF STATUS THEN
         #   #CALL cl_err('decl aba_cursor:',STATUS,0) #CHI-C20017 mark
         #   CALL s_errmsg('','','decl aba_cursor:',STATUS,1) #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #IF l_abaacti = 'N' THEN
         #   #CALL cl_err('','mfg8001',1) #CHI-C20017 mark 
         #   CALL s_errmsg('','','','mfg8001',1) #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #IF l_aba20 MATCHES '[Ss1]' THEN
         #   #CALL cl_err('','mfg3557',0) #CHI-C20017 mark
         #   CALL s_errmsg('','','','mfg3557',1) #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #IF l_abapost = 'Y' THEN
         #   #CALL cl_err(g_existno,'aap-130',0) #CHI-C20017 mark
         #   CALL s_errmsg('','',g_existno,'aap-130',1) #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #SELECT aaa07 INTO l_aaa07        
         #   FROM aaa_file                 
         # WHERE aaa01= p_acc              
         #IF gl_date < l_aaa07  THEN       
         #   #CALL cl_err(gl_date,'aap-027',0) #CHI-C20017 mark
         #   CALL s_errmsg('','',gl_date,'aap-027',1) #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #IF l_aba19 ='Y' THEN 
         #   #CALL cl_err(gl_date,'aap-026',0) #CHI-C20017 mark
         #   CALL s_errmsg('','',gl_date,'aap-026',1) #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #FUN-D40105--mark--end--

         BEGIN WORK
         CALL p203() 
         CALL s_showmsg() #CHI-C20017 add
         IF g_success = "Y" THEN
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

FUNCTION p203()

   LET g_plant_new=p_plant
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new 

   #no.4868 (還原方式為刪除/作廢)
   #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",#FUN-B60140 mark
   LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_new,'aaz_file')  ,#No:FUN-B60140 add
               " WHERE aaz00 = '0' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
   PREPARE aaz84_pre FROM g_sql
   DECLARE aaz84_cs CURSOR FOR aaz84_pre
   OPEN aaz84_cs 
   FETCH aaz84_cs INTO g_aaz84
   IF STATUS THEN 
      #CALL cl_err('sel aaz84',STATUS,1) #CHI-C20017 mark
      #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','sel aaz84',STATUS,1)
         CALL s_showmsg()
      ELSE
         CALL cl_err('sel aaz84',STATUS,1)
      END IF
      #CHI-C20017--add--end
      CALL cl_batch_bg_javamail("N")  
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF

   CALL p203_t_1()

END FUNCTION

FUNCTION p203_ask()
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1     
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   lc_cmd             LIKE type_file.chr1000  
   DEFINE   l_aaa07            LIKE aaa_file.aaa07    
   DEFINE   l_aba20            LIKE aba_file.aba20  

   OPEN WINDOW p203 AT p_row,p_col WITH FORM "afa/42f/afap203"
        ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()

   CALL p203_set_comb()

   CALL cl_set_comp_visible("p_acc,g_existno",FALSE)  

   CALL cl_opmsg('z')
   LET g_bgjob = "N"
   LET p_plant = g_faa.faa02p
   LET p_acc   = g_faa.faa02b
   LET g_existno = NULL
   LET g_type    = NULL
   LET g_existno1= NULL    
   LET p_acc1  = g_faa.faa02c
   DISPLAY BY NAME p_acc1,g_existno1 

   WHILE TRUE
      DIALOG ATTRIBUTES(UNBUFFERED)  #FUN-D40105  add
      #INPUT BY NAME p_plant,p_acc1,g_existno1,g_type,g_bgjob WITHOUT DEFAULTS   #FUN-D40105 mark 
      INPUT BY NAME p_plant,p_acc1 ATTRIBUTE(WITHOUT DEFAULTS=TRUE)   #FUN-D40105 add
 
         ON ACTION locale
            CALL p203_set_comb()
            LET g_change_lang = TRUE
            #EXIT INPUT   #FUN-D40105  mark 
            EXIT DIALOG   #FUN-D40105  add


         AFTER FIELD p_plant
            IF NOT cl_null(p_plant) THEN
              SELECT azp01 FROM azp_file WHERE azp01 = p_plant
              IF STATUS <> 0 THEN 
                 NEXT FIELD p_plant 
              END IF
              LET g_plant_new=p_plant
              CALL s_getdbs()
              LET g_dbs_gl=g_dbs_new 
            END IF

         AFTER FIELD p_acc1
            IF NOT cl_null(p_acc1) THEN
              LET g_faa.faa02c = p_acc1
            END IF

         #FUN-D40105--mark--str--
         #AFTER FIELD g_existno1
         #   IF NOT cl_null(g_existno1) THEN 
         #      DISPLAY BY NAME p_acc1,g_existno1
         #      LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti,aba20 ", 
         #                #"  FROM ",g_dbs_gl,"aba_file",#FUN-B60140 mark
         #                 "  FROM ",cl_get_target_table(g_plant_new,'aba_file')  ,#No:FUN-B60140 add
         #                " WHERE aba01 = ? AND aba00 = ? AND aba06='FA'"
         #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
         #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
         #      PREPARE p203_t_p1_1 FROM g_sql
         #      DECLARE p203_t_c1_1 CURSOR FOR p203_t_p1_1
         #      IF STATUS THEN
         #        #CALL cl_err('decl aba_cursor:',STATUS,0) NEXT FIELD g_type    #MOD-C90162 mark
         #         CALL cl_err('decl aba_cursor:',STATUS,0)                      #MOD-C90162 add
         #         NEXT FIELD g_existno1                                         #MOD-C90162 add
         #      END IF
         #      OPEN p203_t_c1_1 USING g_existno1,g_faa.faa02c
         #      FETCH p203_t_c1_1 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19 ,
         #                             l_abaacti,l_aba20 
         #      IF STATUS THEN
         #        #CALL cl_err('sel aba:',STATUS,0) NEXT FIELD g_type            #MOD-C90162 mark
         #         CALL cl_err('sel aba:',STATUS,0)                              #MOD-C90162 add
         #         NEXT FIELD g_existno1                                         #MOD-C90162 add
         #      END IF
         #      IF l_abaacti = 'N' THEN
         #        #CALL cl_err('','mfg8001',1) NEXT FIELD g_type                 #MOD-C90162 mark
         #         CALL cl_err('','mfg8001',1)                                   #MOD-C90162 add
         #         NEXT FIELD g_existno1                                         #MOD-C90162 add
         #      END IF
         #      IF l_aba20 MATCHES '[Ss1]' THEN
         #         CALL cl_err('','mfg3557',0) 
         #        #NEXT FIELD g_type                                             #MOD-C90162 mark
         #         NEXT FIELD g_existno1                                         #MOD-C90162 add
         #         RETURN   
         #      END IF
         #      IF l_abapost = 'Y' THEN
         #         CALL cl_err(g_existno1,'aap-130',0)
         #        #NEXT FIELD g_type                                             #MOD-C90162 mark
         #         NEXT FIELD g_existno1                                         #MOD-C90162 add
         #      END IF
         #      SELECT aaa07 INTO l_aaa07        
         #        FROM aaa_file                 
         #       WHERE aaa01= p_acc              
         #      IF gl_date < l_aaa07  THEN       
         #         CALL cl_err(gl_date,'aap-027',0)
         #        #LET g_success = 'N'                                           #MOD-C90162 mark
         #        #RETURN                                                        #MOD-C90162 mark
         #         NEXT FIELD g_existno1                                         #MOD-C90162 add
         #      END IF
         #      IF l_aba19 ='Y' THEN 
         #         CALL cl_err(gl_date,'aap-026',0)
         #        #NEXT FIELD g_type                                             #MOD-C90162 mark
         #         NEXT FIELD g_existno1                                         #MOD-C90162 add
         #      END IF
         #   END IF
         #FUN-D40105--mark--end--
         
         AFTER INPUT
            IF INT_FLAG THEN 
               #EXIT INPUT     #FUN-D40105 mark
               EXIT DIALOG     #FUN-D40105 add
            END IF
            # 得出總帳 database name
            # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new    # 得資料庫名稱

         #FUN-D40105--mark--str--
         #ON ACTION CONTROLR
         #   CALL cl_show_req_fields()
         
         #ON ACTION CONTROLG
         #   CALL cl_cmdask()
         
         #ON IDLE g_idle_seconds
         #   CALL cl_on_idle()
         #   CONTINUE INPUT
         
         #ON ACTION about       
         #   CALL cl_about()    
         
         #ON ACTION help         
         #   CALL cl_show_help() 
 

         #ON ACTION exit                            #加離開功能
         #   LET INT_FLAG = 1
         #   EXIT INPUT
         #FUN-D40105--add--end--  

         ON ACTION CONTROLP           #FUN-D40105  add
           BEFORE INPUT
             CALL cl_qbe_init()

         #FUN-D40105--add--str--    
         #ON ACTION qbe_select
         #   CALL cl_qbe_select()

         #ON ACTION qbe_save
         #   CALL cl_qbe_save()
         #FUN-D40105--add--end--   

      END INPUT

      #FUN-D40105--add--str--
      CONSTRUCT BY NAME  tm.wc1 ON g_existno1
         BEFORE CONSTRUCT
           CALL cl_qbe_init()

      AFTER FIELD g_existno1
         IF tm.wc1 = " 1=1" THEN 
            CALL cl_err('','9033',0)
            NEXT FIELD g_existno1 
         END IF  
         CALL p203_existno_chk() 
         IF g_success = 'N' THEN 
            CALL s_showmsg()
            NEXT FIELD g_existno1
         END IF 

        ON ACTION CONTROLP
           CASE 
             WHEN INFIELD(g_existno1)
               LET g_existno_str = ''
               CALL q_aba01_1( TRUE, TRUE, p_plant,p_acc1,' ','FA')
               RETURNING g_existno_str   
               DISPLAY g_existno_str TO g_existno1
               NEXT FIELD g_existno1
           END CASE

     END CONSTRUCT

     INPUT BY NAME g_type,g_bgjob ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
        ON ACTION CONTROLP           
     END INPUT 

     ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION exit 
         LET INT_FLAG = 1
         EXIT DIALOG    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
  
      ON ACTION ACCEPT
         EXIT DIALOG        
       
      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END DIALOG 
   #FUN-D40105--add--end--

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p203
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afap203"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap203','9031',1) 
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",p_plant   CLIPPED,"'",
                         " '",p_acc1    CLIPPED,"'",
                         " '",g_existno1 CLIPPED,"'",
                         " '",g_type    CLIPPED,"'",
                         " '",g_bgjob   CLIPPED,"'"
            CALL cl_cmdat('afap203',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p203
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF

      EXIT WHILE

   END WHILE

END FUNCTION

FUNCTION p203_set_comb()                                                        
  DEFINE comb_value STRING                                                      
  DEFINE comb_item  STRING                                                      
                                                                                
    IF g_aza.aza26 = '2' THEN
       LET comb_value = '1,2,4,5,6,7,8,9,10,11,12,13,14' #FUN-BC0035 add 14
    ELSE
       LET comb_value = '1,2,4,5,6,7,8,9,10,11,12,14' #FUN-BC0035 add 14
    END IF
    CALL cl_getmsg('afa-377',g_lang) RETURNING comb_item

    CALL cl_set_combo_items('g_type',comb_value,comb_item)     
END FUNCTION

FUNCTION p203_t_1()
   DEFINE n1,n2,n3,n4,n5,n6,n7,n8,n9,n11,n14 LIKE type_file.num10 #FUN-BC0035 add n14      
   DEFINE n12                            LIKE type_file.num10     
   DEFINE l_npp             RECORD LIKE npp_file.*
   DEFINE l_cnt        LIKE type_file.num5      #檢查重複用      

   IF g_aaz84 = '2' THEN   #還原方式為作廢 
     # LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",#FUN-B60140 mark
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file')," SET abaacti = 'N' ",#No:FUN-B60140 add
                #" WHERE aba01 = ? AND aba00 = ? "     #FUN-D40105 mark
                " WHERE  aba00 = ? ",                  #FUN-D40105 add
                "   AND ",tm.wc1                       #FUN-D40105 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
      PREPARE p203_updaba_p_1 FROM g_sql
     #EXECUTE p203_updaba_p_1 USING g_existno,g_faa.faa02c    #MOD-BB0228 mark
      #EXECUTE p203_updaba_p_1 USING g_existno1,g_faa.faa02c   #MOD-BB0228   #FUN-D40105 mark
      EXECUTE p203_updaba_p_1 USING g_faa.faa02c   #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)  #CHI-C20017 mark
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
            CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
         #FUN-D40105--add--str--  
         #ELSE
         #   CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF
   ELSE
      IF g_bgjob= 'N' THEN    #FUN-570144 BY 050919
         MESSAGE "Delete GL's Voucher body!"  #-------------------------
         CALL ui.Interface.refresh()
      END IF
      #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?" #FUN-B60140 mark
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")    #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'),
                #"  WHERE abb01=? AND abb00=?" #No:FUN-B60140 add   #FUN-D40105  mark
                " WHERE  abb00 = ? ",            #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql      
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
      PREPARE p203_2_p3_1 FROM g_sql
      #EXECUTE p203_2_p3_1 USING g_existno1,g_faa.faa02c  #FUN-D40105  mark
      EXECUTE p203_2_p3_1 USING g_faa.faa02c              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abb)',SQLCA.sqlcode,1)  #CHI-C20017 mark
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN    #FUN-D40105  mark
            CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
         #FUN-D40105--add--str--     
         #ELSE
         #   CALL cl_err('(del abb)',SQLCA.sqlcode,1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF
      IF g_bgjob= 'N' THEN    #FUN-570144
          MESSAGE "Delete GL's Voucher head!"  #-------------------------
          CALL ui.Interface.refresh()
      END IF
      #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?" #FUN-B60140 mark
      LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")    #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                #" WHERE aba01=? AND aba00=?" #FUN-B60140 add    #FUN-D40105 mark
                " WHERE  aba00 = ? ",            #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
      PREPARE p203_2_p4_1 FROM g_sql
      #EXECUTE p203_2_p4_1 USING g_existno1,g_faa.faa02c  #FUN-D40105 mark 
      EXECUTE p203_2_p4_1 USING g_faa.faa02c              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del aba)',SQLCA.sqlcode,1)  #CHI-C20017 mark
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
            CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
         #FUN-D40105--mark--str--   
         #ELSE
         #   CALL cl_err('(del aba)',SQLCA.sqlcode,1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('(del aba)','aap-161',1)  #CHI-C20017 mark
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
            CALL s_errmsg('','','(del aba)','aap-161',1)
         #FUN-D40105--mark--str--   
         #ELSE
         #   CALL cl_err('(del aba)','aap-161',1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF
      IF g_bgjob= 'N' THEN    #FUN-570144
          MESSAGE "Delete GL's Voucher desp!"  #-------------------------
          CALL ui.Interface.refresh()
      END IF
      #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?" #FUN-B60140 mark
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")     #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'),
                #" WHERE abc01=? AND abc00=?" #FUN-B60140 add   #FUN-D40105 mark
                " WHERE  abc00=?",               #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
      PREPARE p203_2_p5_1 FROM g_sql
      #EXECUTE p203_2_p5_1 USING g_existno1,g_faa.faa02c   #FUN-D40105 mark
      EXECUTE p203_2_p5_1 USING g_faa.faa02c               #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abc)',SQLCA.sqlcode,1)  #CHI-C20017 mark
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN     #FUN-D40105  mark
            CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
         #FUN-D40105--mark--str--   
         #ELSE
         #   CALL cl_err('(del abc)',SQLCA.sqlcode,1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF

   END IF
   IF g_bgjob= 'N' THEN   
       MESSAGE "Delete GL's Voucher detail!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF
   IF g_success = 'N' THEN RETURN END IF

   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  
          VALUES('afap203',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal)

   CASE 
    WHEN g_type = 1    #資本化
         #UPDATE faq_file SET (faq062,faq072)=(NULL,NULL) WHERE faq062=g_existno1 #FUN-B60140 mark
          #UPDATE faq_file SET faq062 = NULL,faq072 = NULL WHERE faq062=g_existno1 #FUN-B60140 add  #FUN-D40105 mark
          #FUN-D40105--add--str--
          IF g_aaz84 = '2' THEN
             LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","faq062")
          ELSE
             LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","faq062")
          END IF    
          LET g_sql = "UPDATE faq_file SET faq062 = NULL,faq072 = NULL ",
                      " WHERE ",tm.wc1     
          PREPARE p203_pre_1 FROM g_sql
          EXECUTE p203_pre_1 
          #FUN-D40105--add--end--
            IF STATUS THEN
               #CALL cl_err3("upd","faq_file",g_existno1,"",STATUS,"","(upd faq)",1)  #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN    #FUN-D40105  mark
                  CALL s_errmsg('','','(upd faq)',STATUS,1)
               #FUN-D40105--mark--str-- 
               #ELSE
               #   CALL cl_err3("upd","faq_file",g_existno1,"",STATUS,"","(upd faq)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n1=SQLCA.SQLERRD[3]
    WHEN g_type = 2    #部門移轉
         #UPDATE fas_file SET (fas072,fas082)=(NULL,NULL) WHERE fas072=g_existno1  #FUN-B60140 mark
         #UPDATE fas_file SET fas072 = NULL,fas082 = NULL WHERE fas072=g_existno1  #FUN-B60140 add    #FUN-D40105 mark
         #FUN-D40105--add--str--
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fas072")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fas072")
         END IF    
         LET g_sql = "UPDATE fas_file SET fas072 = NULL,fas082 = NULL ",
                     " WHERE ",tm.wc1      
         PREPARE p203_pre_2 FROM g_sql
         EXECUTE p203_pre_2 
         #FUN-D40105--add--end--
            IF STATUS THEN
               #CALL cl_err3("upd","fas_file",g_existno1,"",STATUS,"","(upd fas)",1) #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str 
               #IF g_bgjob = 'Y' THEN    #FUN-D40105  mark
                  CALL s_errmsg('','','(upd fas)',STATUS,1)
               #FUN-D40105--mark--str--    
               #ELSE
               #   CALL cl_err3("upd","fas_file",g_existno1,"",STATUS,"","(upd fas)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n11=SQLCA.SQLERRD[3]
    #FUN-BC0035---begin add
    WHEN g_type = 14   #類別異動
         #UPDATE fbx_file SET fbx072 = NULL,fbx082 = NULL WHERE fbx072=g_existno1   #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbx072")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fbx072")
         END IF  
         LET g_sql = "UPDATE fbx_file SET fbx072 = NULL,fbx082 = NULL ",
                     " WHERE ",tm.wc1      
         PREPARE p203_pre_3 FROM g_sql
         EXECUTE p203_pre_3 
         #FUN-D40105--add--end--
            IF STATUS THEN
               #CALL cl_err3("upd","fbx_file",g_existno1,"",STATUS,"","(upd fbx)",1) #CHI-C20017 mark
               LET g_success='N'
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fbx)',STATUS,1)
               #FUN-D40105--mark--str--      
               #ELSE
               #   CALL cl_err3("upd","fbx_file",g_existno1,"",STATUS,"","(upd fbx)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n14=SQLCA.SQLERRD[3]    
    #FUN-BC0035---end add    
    WHEN g_type = 4   #出售
         #UPDATE fbe_file SET (fbe142,fbe152)=(NULL,NULL) WHERE fbe142=g_existno1 #FUN-B60140 mark
         #UPDATE fbe_file SET fbe142 = NULL,fbe152 = NULL WHERE fbe142=g_existno1 #FUN-B60140 add   #FUN-D40105 mark
         #FUN-D40105--add--str--  
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbe142")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fbe142")
         END IF    
         LET g_sql = "UPDATE fbe_file SET fbe142 = NULL,fbe152 = NULL ",
                     " WHERE ",tm.wc1      
         PREPARE p203_pre_4 FROM g_sql
         EXECUTE p203_pre_4 
         #FUN-D40105--add--end--
            IF STATUS THEN
               #CALL cl_err3("upd","fbe_file",g_existno1,"",STATUS,"","(upd fbe)",1) #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN     #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fbe)',STATUS,1)
               #FUN-D40105--mark--str--      
               #ELSE
               #   CALL cl_err3("upd","fbe_file",g_existno1,"",STATUS,"","(upd fbe)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--   
            #CHI-C20017--add--end
            END IF
            LET n2=SQLCA.SQLERRD[3]
    WHEN g_type = 5  OR g_type = 6 #銷帳/報廢
         #UPDATE fbg_file SET (fbg082,fbg092)=(NULL,NULL) WHERE fbg082=g_existno1 #FUN-B60140 mark
         #UPDATE fbg_file SET fbg082 = NULL,fbg092 = NULL WHERE fbg082=g_existno1 #FUN-b60140 add   #FUN-D40105 mark
         #FUN-D40105--add--str--
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbg082")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fbg082")
         END IF     
         LET g_sql = "UPDATE fbg_file SET fbg082 = NULL,fbg092 = NULL ",
                     " WHERE ",tm.wc1      
         PREPARE p203_pre_5 FROM g_sql
         EXECUTE p203_pre_5 
         #FUN-D40105--add--end--
            IF STATUS THEN
               #CALL cl_err3("upd","fbg_file",g_existno1,"",STATUS,"","(upd fbg)",1) #CHI-C20017 mark
               LET g_success='N' 
               #RETURN  #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fbg)',STATUS,1)
               #FUN-D40105--mark--str--      
               #ELSE
               #   CALL cl_err3("upd","fbg_file",g_existno1,"",STATUS,"","(upd fbg)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--   
            #CHI-C20017--add--end
            END IF
            LET n3=SQLCA.SQLERRD[3]
    WHEN g_type = 7   #改良
         #UPDATE fay_file SET (fay062,fay072)=(NULL,NULL) WHERE fay062=g_existno1 #FUN-B60140 mark
         #UPDATE fay_file SET fay062 = NULL,fay072 = NULL WHERE fay062=g_existno1 #FUN-B60140 add   #FUN-D40105 mark
         #FUN-D40105--add--str--
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fay062")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fay062")
         END IF   
         LET g_sql = "UPDATE fay_file SET fay062 = NULL,fay072 = NULL ",
                     " WHERE ",tm.wc1      
         PREPARE p203_pre_6 FROM g_sql
         EXECUTE p203_pre_6 
         #FUN-D40105--add--end--
            IF STATUS THEN
               #CALL cl_err3("upd","fay_file",g_existno1,"",STATUS,"","(upd fay)",1) #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN     #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fay)',STATUS,1)
               #FUN-D40105--mark--str--    
               #ELSE
               #   CALL cl_err3("upd","fay_file",g_existno1,"",STATUS,"","(upd fay)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--   
            #CHI-C20017--add--end
            END IF
            LET n4=SQLCA.SQLERRD[3]
    WHEN g_type = 8   #重估
         #UPDATE fba_file SET (fba062,fba072)=(NULL,NULL) WHERE fba062=g_existno1#FUN-B60140 mark
         #UPDATE fba_file SET fba062 = NULL,fba072 = NULL WHERE fba062=g_existno1#FUN-B60140 add   #FUN-D40105 mark
         #FUN-D40105--add--str--
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fba062")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fba062")
         END IF    
         LET g_sql = "UPDATE fba_file SET fba062 = NULL,fba072 = NULL ",
                     " WHERE ",tm.wc1      
         PREPARE p203_pre_7 FROM g_sql
         EXECUTE p203_pre_7 
         #FUN-D40105--add--end--
            IF STATUS THEN
               #CALL cl_err3("upd","fba_file",g_existno1,"",STATUS,"","(upd fba)",1)  #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fba)',STATUS,1)
               #FUN-D40105--mark--str--      
               #ELSE
               #   CALL cl_err3("upd","fba_file",g_existno1,"",STATUS,"","(upd fba)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end-- 
            #CHI-C20017--add--end
            END IF
            LET n5=SQLCA.SQLERRD[3]
    WHEN g_type = 9   #調整
        #UPDATE fbc_file SET (fbc062,fbc072)=(NULL,NULL) WHERE fbc062=g_existno1 #FUN-B60140 mark
        #UPDATE fbc_file SET fbc062 = NULL,fbc072 = NULL WHERE fbc062=g_existno1 #FUN-B60140 add     #FUN-D40105 mark
        #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbc062")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fbc062")
         END IF       
         LET g_sql = "UPDATE fbc_file SET fbc062 = NULL,fbc072 = NULL ",
                     " WHERE ",tm.wc1      
         PREPARE p203_pre_8 FROM g_sql
         EXECUTE p203_pre_8 
         #FUN-D40105--add--end--
           IF STATUS THEN
              #CALL cl_err3("upd","fbc_file",g_existno1,"",STATUS,"","(upd fbc)",1) #CHI-C20017 mark 
              LET g_success='N' 
              #RETURN   #CHI-C20017 mark
           #CHI-C20017--add--str
              #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                 CALL s_errmsg('','','(upd fbc)',STATUS,1)
              #FUN-D40105--mark--str--         
              #ELSE
              #   CALL cl_err3("upd","fbc_file",g_existno1,"",STATUS,"","(upd fbc)",1)
              #   RETURN
              #END IF
              #FUN-D40105--mark--end-- 
           #CHI-C20017--add--end
           END IF
           LET n6=SQLCA.SQLERRD[3]
    WHEN g_type = 10   #折舊
        LET l_cnt = 0
        #FUN-D40105--mark--str--
        #SELECT COUNT(*) INTO l_cnt
        #  FROM npp_file 
        # WHERE nppglno = g_existno1
        #   AND npp00 = 10
        #   AND npptype = '1' AND npp07 = g_faa.faa02c 
        #FUN-D40105--mark--end--    
        #FUN-D40105--add--str-- 
        IF g_aaz84 = '2' THEN
           LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno")
        ELSE
           LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","nppglno")
        END IF       
        LET g_sql = "SELECT COUNT(*) FROM npp_file ",
                    " WHERE npp00 = 10",
                    "   AND npptype = '1'",
                    "   AND npp07 = '",g_faa.faa02c,"'",
                    "   AND ",tm.wc1
        PREPARE p203_pre_9 FROM g_sql
        EXECUTE p203_pre_9 INTO l_cnt
        #FUN-D40105--add--end--
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
        LET n7 = l_cnt  
    WHEN g_type = 11   #利息資本化
        #UPDATE fcx_file SET (fcx112,fcx122)=(NULL,NULL) WHERE fcx112=g_existno1 #FUN-B60140 mark
        #UPDATE fcx_file SET fcx112 =NULL,fcx122 =NULL WHERE fcx112=g_existno1 #FUN-B60140 add  #FUN-D40105 mark
        #FUN-D40105--add--str-- 
        IF g_aaz84 = '2' THEN
           LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fcx112")
        ELSE
           LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fcx112")
        END IF         
        LET g_sql = "UPDATE fcx_file SET fcx112 =NULL,fcx122 =NULL  ",
                    " WHERE ",tm.wc1      
        PREPARE p203_pre_10 FROM g_sql
        EXECUTE p203_pre_10 
        #FUN-D40105--add--end--
           IF STATUS THEN
              #CALL cl_err3("upd","fcx_file",g_existno1,"",STATUS,"","(upd fcx)",1) #CHI-C20017 mark
              LET g_success='N' 
              #RETURN   #CHI-C20017 mark
           #CHI-C20017--add--str
              #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
                 CALL s_errmsg('','','(upd fcx)',STATUS,1)
              #FUN-D40105--mark--str--          
              #ELSE
              #   CALL cl_err3("upd","fcx_file",g_existno1,"",STATUS,"","(upd fcx)",1)
              #   RETURN
              #END IF
              #FUN-D40105--mark--end-- 
           #CHI-C20017--add--end
           END IF
           LET n8=SQLCA.SQLERRD[3]
    WHEN g_type = 12   #保險       
        #UPDATE fdd_file SET (fdd062,fdd072)=(NULL,NULL) WHERE fdd062=g_existno1 #FUN-B60140 mark
        #UPDATE fdd_file SET fdd062 = NULL,fdd072 = NULL WHERE fdd062=g_existno1 #FUN-B60140 add   #FUN-D40105 mark
        #FUN-D40105--add--str--
        IF g_aaz84 = '2' THEN
           LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fdd062")
        ELSE
           LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fdd062")
        END IF     
        LET g_sql = "UPDATE fdd_file SET fdd062 = NULL,fdd072 = NULL ",
                    " WHERE ",tm.wc1      
        PREPARE p203_pre_11 FROM g_sql
        EXECUTE p203_pre_11 
        #FUN-D40105--add--end--
           IF STATUS THEN
              #CALL cl_err3("upd","fdd_file",g_existno1,"",STATUS,"","(upd fdd)",1) #CHI-C20017 mark
              LET g_success='N' 
              #RETURN   #CHI-C20017 mark
           #CHI-C20017--add--str
              #IF g_bgjob = 'Y' THEN     #FUN-D40105 mark
                 CALL s_errmsg('','','(upd fdd)',STATUS,1)
              #FUN-D40105--mark--str--    
              #ELSE
              #   CALL cl_err3("upd","fdd_file",g_existno1,"",STATUS,"","(upd fdd)",1)
              #   RETURN
              #END IF
              #FUN-D40105--mark--end--
           #CHI-C20017--add--end
           END IF
           LET n9=SQLCA.SQLERRD[3]
    WHEN g_type = 13  #減值準備                                                 
        #UPDATE fbs_file SET fbs042 = NULL, fbs052 = NULL WHERE fbs042=g_existno1  #FUN-D40105 mark
        #FUN-D40105--add--str--
        IF g_aaz84 = '2' THEN
           LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbs042")
        ELSE
           LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","fbs042")
        END IF      
        LET g_sql = "UPDATE fbs_file SET fbs042 = NULL, fbs052 = NULL ",
                    " WHERE ",tm.wc1      
        PREPARE p203_pre_12 FROM g_sql
        EXECUTE p203_pre_12 
        #FUN-D40105--add--end--    
           IF STATUS THEN                                                       
              #CALL cl_err3("upd","fbs_file",g_existno1,"",STATUS,"","(upd fbs)",1) #CHI-C20017 mark 
              LET g_success='N' 
              #RETURN   #CHI-C20017 mark
           #CHI-C20017--add--str
              #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
                 CALL s_errmsg('','','(upd fbs)',STATUS,1)
              #FUN-D40105--mark--str--       
              #ELSE
              #   CALL cl_err3("upd","fbs_file",g_existno1,"",STATUS,"","(upd fbs)",1)
              #   RETURN
              #END IF
              #FUN-D40105--mark--end--
           #CHI-C20017--add--end
           END IF                                                               
           LET n12=SQLCA.SQLERRD[3]                                             

    END CASE
      IF n1+n2+n3+n4+n5+n6+n7+n8+n9+n11+n12+n14 = 0 THEN #FUN-BC0035 add n14
         #CALL cl_err('upd fa?:','aap-161',1) #CHI-C20017 mark
         LET g_success='N' 
         #RETURN   #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
            CALL s_errmsg('','','upd fa?:','aap-161',1)
         #FUN-D40105--mark--str-- 
         #ELSE
         #   CALL cl_err('upd fa?:','aap-161',1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF
   #----------------------------------------------------------------------

   #FUN-D40105--add--str--
   CASE 
     WHEN g_type = 1  
        LET tm.wc1 = cl_replace_str(tm.wc1,"faq062","nppglno")     
     WHEN g_type = 2
        LET tm.wc1 = cl_replace_str(tm.wc1,"fas072","nppglno")    
     WHEN g_type = 14
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbx072","nppglno")  
     WHEN g_type = 4 
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbe142","nppglno")  
     WHEN g_type = 5  OR g_type = 6 
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbg082","nppglno") 
     WHEN g_type = 7
        LET tm.wc1 = cl_replace_str(tm.wc1,"fay062","nppglno")
     WHEN g_type = 8
        LET tm.wc1 = cl_replace_str(tm.wc1,"fba062","nppglno")   
     WHEN g_type = 9
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbc062","nppglno")  
     WHEN g_type = 10
        LET tm.wc1 = cl_replace_str(tm.wc1,"nppglno","nppglno")
     WHEN g_type = 11
        LET tm.wc1 = cl_replace_str(tm.wc1,"fcx112","nppglno")
     WHEN g_type = 12
        LET tm.wc1 = cl_replace_str(tm.wc1,"fdd062","nppglno")
     WHEN g_type = 13 
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbs042","nppglno")
   END CASE 
   #FUN-D40105--add--end--

   #FUN-D40105--mark--str-- 
   #UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,
   #                    npp06 = NULL ,npp07  = NULL 
   # WHERE nppglno=g_existno1
   #   AND npptype='1' AND npp07 = g_faa.faa02c  
   #FUN-D40105--mark--end--

   #FUN-D40105--add--str--   
   LET g_sql = "UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,",
               "                    npp06 = NULL ,npp07  = NULL ",
               " WHERE npptype='1' ",
               "   AND npp07 = '",g_faa.faa02c,"'",
               "   AND ",tm.wc1  
   PREPARE p203_pre_13 FROM g_sql
   EXECUTE p203_pre_13 
   #FUN-D40105--add--end--          
      IF STATUS THEN
         #CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","(upd npp03)",1) #CHI-C20017 mark
         LET g_success='N' 
         #RETURN   #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN    #FUN-D40105 add
            CALL s_errmsg('','','(upd npp03)',STATUS,1)
         #FUN-D40105--mark--str--   
         #ELSE
         #   CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","(upd npp03)",1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF
END FUNCTION
  #No:FUN-B60140

FUNCTION p203_existno_chk() 
   DEFINE   l_chk_bookno       LIKE type_file.num5    
   DEFINE   l_chk_bookno1      LIKE type_file.num5    
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1    
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba01            LIKE aba_file.aba01 
   DEFINE   l_aba00            LIKE aba_file.aba00 
   DEFINE   l_aaa07            LIKE aaa_file.aaa07 
   DEFINE   l_npp00            LIKE npp_file.npp00 
   DEFINE   l_npp01            LIKE npp_file.npp01
   DEFINE   l_npp07            LIKE npp_file.npp07     
   DEFINE   l_nppglno          LIKE npp_file.nppglno   
   DEFINE   l_cnt              LIKE type_file.num5    
   DEFINE   lc_cmd             LIKE type_file.chr1000 
   DEFINE   l_sql              STRING        
   DEFINE   l_cnt1             LIKE type_file.num5     
   DEFINE   l_aba20            LIKE aba_file.aba20 

   CALL s_showmsg_init()
   LET g_existno1 = NULL
   LET g_success = 'Y' 
   LET tm.wc1 = cl_replace_str(tm.wc1,"g_existno1","aba01")
   
   LET g_sql="SELECT aba01,aba02,abapost,aba19,abaacti,aba20 ",
             "  FROM ",cl_get_target_table(g_plant_new,'aba_file')  ,
             " WHERE  aba00 = ? AND aba06='FA'",
             "   AND ",tm.wc1
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   
   PREPARE p203_t_p11 FROM g_sql
   DECLARE p203_t_c11 CURSOR FOR p203_t_p11
   IF STATUS THEN
      CALL s_errmsg('','','decl aba_cursor:',STATUS,1)  
      LET g_success = 'N'                                                 
   END IF
      FOREACH p203_t_c11 USING g_faa.faa02c
                          INTO l_aba01,gl_date,l_abapost,l_aba19,l_abaacti,l_aba20
         IF STATUS THEN
            CALL s_errmsg('',l_aba01,'decl aba_cursor:',STATUS,1)
            LET g_success = 'N'                                                 
         END IF
         IF l_abaacti = 'N' THEN
            CALL s_errmsg('',l_aba01,'','mfg8001',1) 
            LET g_success = 'N'                                                 
         END IF
         IF l_aba20 MATCHES '[Ss1]' THEN
            CALL s_errmsg('',l_aba01,'','mfg3557',1) 
            LET g_success = 'N'                                                 
         END IF
         IF l_abapost = 'Y' THEN
            CALL s_errmsg('',l_aba01,'','aap-130',1) 
            LET g_success = 'N'                                                 
         END IF
         SELECT aaa07 INTO l_aaa07        
           FROM aaa_file                 
          WHERE aaa01= p_acc              
         IF gl_date < l_aaa07  THEN       
            CALL s_errmsg('',l_aba01,gl_date,'aap-027',1) 
            LET g_success = 'N'                                                 
         END IF
         IF l_aba19 ='Y' THEN 
            #CALL s_errmsg('','',gl_date,'aap-026',1)      #TQC-D60072 mark
            CALL s_errmsg('',l_aba01,gl_date,'aap-026',1)  #TQC-D60072 add
            LET g_success = 'N'                                                 
         END IF
      END FOREACH 
END FUNCTION 
