# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: anmp950
# Descriptions...: 內部銀行計息作業
# Date & Author..: 06/10/23 By cl
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/01/18 By Jackho 增加批處理錯誤統整功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-C30748 12/03/16 By wangrr 在s_errmsg后添加g_success=‘'N'
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nac01         LIKE nac_file.nac01,
       g_nac04         LIKE nac_file.nac04,
       g_nae04         LIKE nae_file.nae04,
       g_nae05         LIKE nae_file.nae05,
       g_nae02         LIKE nae_file.nae02
DEFINE g_wc,g_sql      STRING 
# DEFINE g_success       LIKE type_file.chr1 
DEFINE g_cnt           LIKE type_file.num10 
DEFINE g_rec_b         LIKE type_file.num10
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_change_lang   LIKE type_file.chr1 
DEFINE g_msg           STRING
DEFINE g_msg1          STRING 
                
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0082
DEFINE l_flag          LIKE type_file.chr1
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    INITIALIZE g_bgjob_msgfile TO NULL   
    LET g_wc    = ARG_VAL(1)
    LET g_nae04 = ARG_VAL(2)
    LET g_nae05 = ARG_VAL(3)
    LET g_nae02 = ARG_VAL(4)
    LET g_bgjob = ARG_VAL(5)
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = 'N'
    END IF    
       
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
    
    WHILE TRUE
      IF g_bgjob = 'N' THEN
         CALL p950_ask()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL p950()
            CALL s_showmsg()          #No.FUN-710024
            IF g_success = 'Y' AND g_cnt>0 THEN
               LET g_msg1 = g_cnt 
               CALL cl_getmsg("mfg8502",g_lang) RETURNING g_msg
               LET g_msg1 = g_msg CLIPPED , g_msg1 CLIPPED
               CALL cl_getmsg("anm-905",g_lang) RETURNING g_msg
               LET g_msg1 = g_msg1 CLIPPED , g_msg CLIPPED
               MESSAGE g_msg1
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p950
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE   
         END IF        
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p950()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            CALL s_showmsg()  #MOD-C30748
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
    END WHILE
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION p950_ask()
DEFINE   l_cmd       LIKE type_file.chr1000
 
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p340 AT p_row,p_col WITH FORM "anm/42f/anmp950"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   MESSAGE ' '
   
   WHILE TRUE
     CONSTRUCT BY NAME g_wc ON nac01,nac04
     
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
          
       ON ACTION locale
          LET g_change_lang = TRUE
          EXIT CONSTRUCT
       
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
          
       ON ACTION qbe_select
          CALL cl_qbe_select() 
 
       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(nac01)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form  = "q_nac01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nac01
              NEXT FIELD nac01
            WHEN INFIELD(nac04)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form  = "q_azi"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nac04
              NEXT FIELD nac04
          END CASE
          
     END CONSTRUCT
     
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p950
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF 
     
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN 
     #        LET g_wc = g_wc clipped," AND nmauser = '",g_user,"'"
     #     END IF
     
     #     IF g_priv3='4' THEN                           
     #        LET g_wc = g_wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF  
     
     #     IF g_priv3 MATCHES "[5678]" THEN    
     #        LET g_wc = g_wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
     #     END IF   
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
     #End:FUN-980030
     
     LET g_nae04 = g_today
     LET g_nae05 = g_today
     
     DISPLAY BY NAME g_nae04,g_nae05
     
     LET g_bgjob = 'N'
     
     INPUT BY NAME g_nae04,g_nae05,g_nae02,g_bgjob  WITHOUT DEFAULTS 
        
        AFTER FIELD g_nae05
          IF g_nae05<g_nae04 THEN
             CALL cl_err("","anm-042",1)
             LET g_nae05 = NULL 
             NEXT FIELD g_nae05
          END IF
     
        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           
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
           
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
           
        ON ACTION qbe_save
           CALL cl_qbe_save()
           
        ON ACTION locale           
           LET g_change_lang = TRUE 
           EXIT INPUT
     
     END INPUT
     
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p950
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO l_cmd FROM zz_file
         WHERE zz01 = "anmp950"
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmp950','9031',1)   
        ELSE
           LET g_wc=cl_replace_str(g_wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,
                        " '",g_wc CLIPPED ,"'",
                        " '",g_nae04 CLIPPED , "'",
                        " '",g_nae05 CLIPPED , "'",
                        " '",g_nae02 CLIPPED , "'",
                        " '",g_bgjob CLIPPED,"'"
 
           CALL cl_cmdat('anmp950',g_time,l_cmd CLIPPED)
        END IF
        CLOSE WINDOW p950
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     EXIT WHILE          
   END WHILE      
END FUNCTION 
 
FUNCTION p950()
DEFINE l_nae        RECORD LIKE nae_file.* 
DEFINE l_nac05      LIKE nac_file.nac05
DEFINE l_nac01      LIKE nac_file.nac01
DEFINE l_nac04      LIKE nac_file.nac04
DEFINE l_dbs        STRING
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_i          LIKE type_file.num5
DEFINE l_sql        STRING
DEFINE l_azi04      LIKE azi_file.azi04
 
    LET g_success = 'Y'
    LET g_cnt = 0
     
    LET g_sql = " SELECT nae_file.* FROM nae_file,nac_file ",
                "  WHERE ",g_wc CLIPPED,
                "    AND nae01 = nac01 ",
                "    AND nae04 ='",g_nae04,"'",
                "    AND nae05 ='",g_nae05,"'",
                "    AND nae02 ='",g_nae02,"'",
                "    AND nacacti = 'Y' ",
                "  ORDER BY nae01,nae04,nae05 "
                
    PREPARE p950_p1 FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
 
    DECLARE p950_c1 CURSOR FOR p950_p1
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
 
    LET l_sql=" SELECT nac01,nac04,nac05 FROM nac_file ",
              "  WHERE ",g_wc CLIPPED 
 
    PREPARE p950_p7 FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
 
    DECLARE p950_c7 CURSOR FOR p950_p7
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
    
    LET g_sql = " SELECT COUNT(*) FROM nae_file,nac_file ",
                "  WHERE ",g_wc CLIPPED,
                "    AND nae01 = nac01 ",
                "    AND nae04 ='",g_nae04,"'",
                "    AND nae05 ='",g_nae05,"'"
                
    PREPARE p950_p6 FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
 
    DECLARE p950_c6 CURSOR FOR p950_p6
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
    
    OPEN p950_c6
    FETCH  p950_c6 INTO l_i
    IF l_i >0 THEN                          # 資料存在
       CALL s_showmsg_init()   #No.FUN-710024
       FOREACH p950_c1 INTO l_nae.*
#No.FUN-710024--begin
         IF g_success='N' THEN                                                                                                          
             LET g_totsuccess='N'                                                                                                       
             LET g_success="Y"                                                                                                          
         END IF             
         IF SQLCA.sqlcode AND SQLCA.sqlcode!=100 THEN
#            CALL cl_err('',SQLCA.sqlcode,1)
            CALL s_errmsg('','','',SQLCA.sqlcode,1) 
#No.FUN-710024--end
            LET g_success='N'
            EXIT FOREACH
         END IF
 
         IF g_bgjob='N' THEN 
             MESSAGE 'FETCH Bank No.:',l_nae.nae01
             CALL ui.Interface.refresh()
         END IF
         
         IF NOT cl_null(l_nae.nae07) THEN
#No.FUN-710024--begin
#            CALL cl_err("","anm-037",1)
            CALL s_errmsg('','','','anm-037',1) 
            LET g_success = 'N'
#            RETURN
            CONTINUE FOREACH
#No.FUN-710024--end
         END IF
         
         DELETE FROM nae_file 
          WHERE nae01=l_nae.nae01 
            AND nae04=l_nae.nae04
            AND nae05=l_nae.nae05
         IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#            CALL cl_err3("del","nae_file",l_nae.nae01,"",SQLCA.sqlcode,"","",1)
            LET g_showmsg=l_nae.nae01,"/",l_nae.nae04,"/",l_nae.nae05
            CALL s_errmsg('nae01,nae04,nae05',g_showmsg,'',SQLCA.sqlcode,1)
#No.FUN-710024--end
            LET g_success = 'N'  #MOD-C30748
            CONTINUE FOREACH
         END IF
         
         SELECT nac04,nac05 INTO g_nac04,l_nac05 FROM nac_file WHERE nac01=l_nae.nae01
         LET g_plant_new = l_nac05
         CALL s_getdbs() 
         LET l_dbs=g_dbs_new
         
         #CALL p950_accr(l_nae.nae01,l_nae.nae04,l_nae.nae05,l_dbs)
         CALL p950_accr(l_nae.nae01,l_nae.nae04,l_nae.nae05,l_nac05)   #FUN-A50102
              RETURNING l_nae.nae06,l_nae.nae03,l_flag
         IF l_flag = 'N' THEN
            LET g_msg = l_nae.nae01,' error!'
            MESSAGE g_msg
            CONTINUE FOREACH 
         END IF    
         SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=g_nac04
         IF cl_null(l_azi04) THEN
            LET l_azi04 = g_azi04
         END IF 
         CALL cl_digcut(l_nae.nae06,l_azi04)
             RETURNING l_nae.nae06
               
         LET l_nae.naeoriu = g_user      #No.FUN-980030 10/01/04
         LET l_nae.naeorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO nae_file VALUES (l_nae.*)
         IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#            CALL cl_err3("ins","nae_file",l_nae.nae01,"",SQLCA.sqlcode,"","",1)
            CALL s_errmsg('nae01',l_nae.nae01,"",SQLCA.sqlcode,0)
#No.FUN-710024--end
            LET g_success = 'N'  #MOD-C30748
            CONTINUE FOREACH
         END IF     
         
         LET g_cnt = g_cnt+1
       END FOREACH
#No.FUN-710024--begin
       IF g_totsuccess="N" THEN                                                                                                         
          LET g_success="N"                                                                                                             
       END IF 
#No.FUN-710024--end  
    ELSE                                           #資料不存在
       FOREACH p950_c7 INTO l_nac01,l_nac04,l_nac05
#No.FUN-710024--begin
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF             
#No.FUN-710024--end        
 
         LET g_nac04 = l_nac04
         LET g_plant_new = l_nac05
         CALL s_getdbs() 
         LET l_dbs=g_dbs_new
 
         LET l_nae.nae01   = l_nac01
         LET l_nae.nae02   = g_nae02
         LET l_nae.nae04   = g_nae04
         LET l_nae.nae05   = g_nae05
         LET l_nae.nae07   = NUll
         LET l_nae.nae08   = l_nac05
         LET l_nae.naeconf = 'N'
         LET l_nae.naeacti = 'N'
         LET l_nae.naeuser = g_user
         LET l_nae.naegrup = g_grup
         LET l_nae.naemodu = g_user
         LET l_nae.naedate = g_today
         
         #CALL p950_accr(l_nae.nae01,l_nae.nae04,l_nae.nae05,l_dbs)
         CALL p950_accr(l_nae.nae01,l_nae.nae04,l_nae.nae05,l_nac05)   #FUN-A50102
              RETURNING l_nae.nae06,l_nae.nae03,l_flag
         IF l_flag = 'N' THEN
            LET g_msg = l_nae.nae01,' error!'
            MESSAGE g_msg
            CONTINUE FOREACH
         END IF    
         
         SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=g_nac04
         IF cl_null(l_azi04) THEN
            LET l_azi04=g_azi04
         END IF
         CALL cl_digcut(l_nae.nae06,l_azi04)
             RETURNING l_nae.nae06
               
         INSERT INTO nae_file VALUES (l_nae.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nae_file",l_nae.nae01,"",SQLCA.sqlcode,"","",1)
            CONTINUE FOREACH
         END IF     
         
         LET g_cnt = g_cnt+1
       END FOREACH 
#No.FUN-710024--begin
       IF g_totsuccess="N" THEN                                                                                                         
          LET g_success="N"                                                                                                             
       END IF 
#No.FUN-710024--end  
    END IF
 
    CLOSE p950_c6
 
END FUNCTION
 
#利率及計息金額計算函數
#FUNCTION p950_accr(p_nac01,p_nae04,p_nae05,p_dbs)
FUNCTION p950_accr(p_nac01,p_nae04,p_nae05,l_plant)  #FUN-A50102
DEFINE  p_nac01      LIKE nac_file.nac01
DEFINE  p_nae04      LIKE nae_file.nae04
DEFINE  p_nae05      LIKE nae_file.nae05
#DEFINE  p_dbs        LIKE type_file.chr21 #FUN-A50102
DEFINE  l_nme        RECORD LIKE nme_file.*
DEFINE  l_nmp        RECORD LIKE nmp_file.*
DEFINE  l_nac01      LIKE nac_file.nac01
DEFINE  l_nae04      LIKE nae_file.nae04
DEFINE  l_nae05      LIKE nae_file.nae05
#DEFINE  l_dbs        STRING #FUN-A50102
DEFINE  l_i          LIKE type_file.num10
DEFINE  l_nmc03      LIKE nmc_file.nmc03
DEFINE  l_sql2       STRING
DEFINE  l_flag       LIKE type_file.chr1
DEFINE  l_nae06      LIKE nae_file.nae06
DEFINE  l_sum        LIKE nae_file.nae06
DEFINE  l_yyb        LIKE type_file.num5
DEFINE  l_mmb        LIKE type_file.num5
DEFINE  l_ddb        LIKE type_file.num5
DEFINE  l_yye        LIKE type_file.num5
DEFINE  l_mme        LIKE type_file.num5
DEFINE  l_dde        LIKE type_file.num5
DEFINE  l_rate       LIKE nad_file.nad03
DEFINE  l_msg        STRING
DEFINE  l_nad03      LIKE nad_file.nad03
DEFINE  l_day        LIKE nae_file.nae05
DEFINE  l_plant      LIKE type_file.chr21    #FUN-A50102
 
    LET l_nac01 = p_nac01
    LET l_nae04 = p_nae04
    LET l_nae05 = p_nae05
    #LET l_dbs   = p_dbs     #FUN-A50102
    LET l_i     = 0
    LET l_nae06 = 0
    LET l_sum   = 0
    LET l_rate  = 0
    LET l_nad03 = 0
    LET l_flag  = 'Y'
    LET l_msg   = NULL
    LET l_day   = NULL
    
    #LET l_sql2 = " SELECT * FROM ",l_dbs CLIPPED,"nme_file ",
    LET l_sql2 = " SELECT * FROM ",cl_get_target_table(l_plant,'nme_file'), #FUN-A50102
                 "  WHERE nme01='",l_nac01 CLIPPED,"'",
                 "    AND nme02= ? "
                 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2 #FUN-A50102
    PREPARE p950_p2 FROM l_sql2
    IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL s_errmsg('','','prepare:',SQLCA.sqlcode,0)
#No.FUN-710024--end
       LET g_success='N'   #MOD-C30748
       LET l_flag = 'N'
       RETURN l_nae06,l_nad03,l_flag
    END IF
 
    DECLARE p950_c2 CURSOR FOR p950_p2

    IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#       CALL cl_err('declare:',SQLCA.sqlcode,1)
       CALL s_errmsg('','','declare:',SQLCA.sqlcode,0)
#No.FUN-710024--end
       LET g_success='N'   #MOD-C30748
       LET l_flag = 'N'
       RETURN l_nae06,l_nad03,l_flag
    END IF   
 
    #LET l_sql2 = " SELECT * FROM ",l_dbs CLIPPED,"nmp_file ",
    LET l_sql2 = " SELECT * FROM ",cl_get_target_table(l_plant,'nmp_file'), #FUN-A50102
                 "  WHERE nmp01='",l_nac01 CLIPPED,"'",
                 "    AND nmp02=? AND nmp03=? "
                 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2 #FUN-A50102
    PREPARE p950_p3 FROM l_sql2
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
#No.FUN-710024--begin
#       CALL cl_err('declare:',SQLCA.sqlcode,1)
       CALL s_errmsg('','','declare:',SQLCA.sqlcode,0)
#No.FUN-710024--end
       LET g_success='N'   #MOD-C30748
       LET l_flag = 'N'
       RETURN l_nae06,l_nad03,l_flag
    END IF
 
    DECLARE p950_c3 CURSOR FOR p950_p3
    IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#       CALL cl_err('declare:',SQLCA.sqlcode,1)
       CALL s_errmsg('','','declare:',SQLCA.sqlcode,0)
#No.FUN-710024--end
       LET g_success='N'   #MOD-C30748
       LET l_flag = 'N'
       RETURN l_nae06,l_nad03,l_flag
    END IF   
    
    #LET l_sql2 = " SELECT nmc03 FROM ",l_dbs CLIPPED,"nmc_file ",
    LET l_sql2 = " SELECT nmc03 FROM ",cl_get_target_table(l_plant,'nmc_file'), #FUN-A50102
                 "  WHERE nmc01 = ? "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2 #FUN-A50102
    PREPARE p950_p4 FROM l_sql2
    IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL s_errmsg('','','prepare:',SQLCA.sqlcode,0)
#No.FUN-710024--end
       LET g_success='N'   #MOD-C30748
       LET l_flag = 'N'
       RETURN l_nae06,l_nad03,l_flag
    END IF
 
    DECLARE p950_c4 CURSOR FOR p950_p4
    IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#       CALL cl_err('declare:',SQLCA.sqlcode,1)
       CALL s_errmsg('','','declare:',SQLCA.sqlcode,0)
#No.FUN-710024--end
       LET g_success='N'   #MOD-C30748
       LET l_flag = 'N'
       RETURN l_nae06,l_nad03,l_flag
    END IF   
    
    LET l_yyb = YEAR(l_nae04)
    LET l_mmb = MONTH(l_nae04)
    LET l_ddb = DAY(l_nae04)
    LET l_yye = YEAR(l_nae05)
    LET l_mme = MONTH(l_nae05)
    LET l_dde = DAY(l_nae05)
    
    IF l_mme=1 THEN
       LET l_yye = l_yye-1
       LET l_mme = l_mme+11
       OPEN p950_c3 USING l_yye,l_mme
    ELSE
       LET l_mme = l_mme-1
       OPEN p950_c3 USING l_yye,l_mme
    END IF
    
    FETCH p950_c3 INTO l_nmp.*    
    IF SQLCA.sqlcode AND SQLCA.sqlcode!=100 THEN
#No.FUN-710024--begin
#       CALL cl_err('',SQLCA.sqlcode,1)
       CALL s_errmsg('','','',SQLCA.sqlcode,0)
#No.FUN-710024--end
       LET g_success='N'  #MOD-C30748
       LET l_flag = 'N'
       CLOSE p950_c3
       RETURN l_nae06,l_nad03,l_flag
    END IF
    IF SQLCA.sqlcode=100 THEN
      #CALL cl_err('',SQLCA.sqlcode,1)
       LET l_nmp.nmp06 = 0
    END IF
    LET l_nae06 = l_nmp.nmp06
    
    SELECT nad03 INTO l_nad03 FROM nad_file 
     WHERE nad01=g_nac04 and nad02=g_nae02
    IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#       CALL cl_err3("sel","nad_file",g_nac04,"",SQLCA.sqlcode,"","sel nad03",1)
       LET g_showmsg=g_nac04,"/",g_nae02
       CALL s_errmsg('nad01,nad02',g_showmsg,'sel nad03',SQLCA.sqlcode,0)
#No.FUN-710024--end
       LET g_success='N'  #MOD-C30748
       LET l_flag = 'N'
       CLOSE p950_c3
       RETURN l_nae06,l_nad03,l_flag
    END IF
    CASE
      WHEN g_nae02='0'
           LET l_rate = (l_nad03/100)/365
      WHEN g_nae02='1'
           LET l_rate = (l_nad03/100)/365
      WHEN g_nae02='2'
           LET l_rate = (l_nad03/100)/(365*2)
      WHEN g_nae02='3'
           LET l_rate = (l_nad03/100)/(365*3)
      WHEN g_nae02='4'      
           LET l_rate = (l_nad03/100)/(365*4)
    END CASE
    
    #日利息計算
    FOR l_i = 1 TO l_dde                      #止息日期，計算該日期的月份的第一日到截止日。
      LET l_day = l_nae05-(l_dde-l_i)         #計算當前的日號
      OPEN p950_c2 USING l_day
      FETCH p950_c2 INTO l_nme.*
      IF SQLCA.sqlcode AND SQLCA.sqlcode != 100 THEN
         LET l_msg = l_nac01,'',l_nae05-(l_dde-l_i)
#No.FUN-710024--begin
#         CALL cl_err('',SQLCA.sqlcode,1)
         CALL s_errmsg('','','',SQLCA.sqlcode,0)
#No.FUN-710024--end
         LET g_success='N'  #MOD-C30748
         LET l_flag='N'
         CLOSE p950_c2 
         EXIT FOR
      END IF
      IF SQLCA.sqlcode=100 THEN
         CONTINUE FOR
      END IF
      
      OPEN p950_c4 USING l_nme.nme03
      FETCH p950_c4 INTO l_nmc03
      IF SQLCA.sqlcode AND SQLCA.sqlcode!=100 THEN
         LET l_flag='N'
         CLOSE p950_c4
         EXIT FOR
      END IF
      IF SQLCA.sqlcode = 100 THEN
         CONTINUE FOR
      END IF
      
      IF l_nmc03='1' THEN
         LET l_sum = l_sum + l_nme.nme04*l_rate
      END IF
      
      IF l_nmc03='2' THEN
         LET l_sum = l_sum - l_nme.nme04*l_rate
      END IF
      
 
      CLOSE p950_c2
      CLOSE p950_c4
      
    END FOR
    
    LET l_nae06 = l_nae06 + l_sum
   
    CLOSE p950_c3 
    RETURN l_nae06,l_nad03,l_flag
 
END FUNCTION
