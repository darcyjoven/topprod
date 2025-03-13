# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axrp710.4gl
# Descriptions...: 押金轉應收整批刪除作業
# Date & Author..: #TQC-AC0127     10/12/21 chenying
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   tm RECORD
      rxrplant LIKE rxr_file.rxrplant,   #來源營運中心
      rxr00    LIKE rxr_file.rxr00,      #單據別 
      rxr01    LIKE rxr_file.rxr01,      #押金單號 
      rxr05    LIKE rxr_file.rxr05,      #預還日期 
      rxr16    LIKE rxr_file.rxr16,      #賬款單號
      wc       STRING      
   END RECORD 
DEFINE g_sql   STRING   
DEFINE g_change_lang        LIKE type_file.chr1
DEFINE l_dbs                LIKE type_file.chr21

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211   
   CALL p710_cmd()          #condition input
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN


FUNCTION p710_cmd()
DEFINE p_row,p_col	LIKE type_file.num5          #SMALLINT
DEFINE l_flag       LIKE type_file.chr1          #VARCHAR(1)
 
    LET p_row = 5 LET p_col = 20
    OPEN WINDOW p710_w AT p_row,p_col
 	WITH FORM "axr/42f/axrp710" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)  
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
    WHILE TRUE       
       IF s_shut(0) THEN RETURN END IF
       CALL p710()
       IF cl_sure(0,0) THEN
          CALL p710_del()       
       END IF
    END WHILE
    CLOSE WINDOW p710_w
END FUNCTION



FUNCTION p710()
DEFINE l_n   LIKE type_file.num5
  
   ERROR ''
   CLEAR FORM 
   INITIALIZE tm.* TO NULL
   INPUT BY NAME tm.rxrplant,tm.rxr00 WITHOUT DEFAULTS
   BEFORE INPUT
      LET tm.rxrplant = g_plant 
      LET tm.rxr00 = '1'
      DISPLAY BY NAME tm.rxrplant,tm.rxr00
      
      AFTER FIELD rxrplant
          IF NOT cl_null(tm.rxrplant) THEN
             SELECT COUNT(*) INTO l_n FROM azw_file,azp_file
                WHERE azw01 = azp01 AND azw01 = tm.rxrplant AND azw02 = g_legal
               IF l_n = 0 THEN
                  CALL cl_err(tm.rxrplant,'axrp701',0)
                  NEXT FIELD rxrplant
               END IF
            ELSE
               NEXT FIELD rxrplant
            END IF

      AFTER FIELD rxr00
         IF cl_null(tm.rxr00) THEN
            NEXT FIELD rxr00
         END IF       

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT

         ON ACTION exit              #加離開功能genero
              LET INT_FLAG = 1
              EXIT INPUT

         
      AFTER INPUT	            #檢查必要欄位是否輸入
         IF INT_FLAG THEN
            EXIT INPUT
         END IF     
         
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rxrplant)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.where = "azw02 = '",g_legal,"' "      
               LET g_qryparam.arg1 = g_legal
               CALL cl_create_qry() RETURNING tm.rxrplant
               DISPLAY BY NAME tm.rxrplant
            OTHERWISE EXIT CASE
         END CASE    
   
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM  
   END IF
   
   
   CONSTRUCT BY NAME tm.wc ON rxr01,rxr05,rxr16
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                    
            EXIT CONSTRUCT
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about          
            CALL cl_about()       
         
         ON ACTION help           
            CALL cl_show_help()   
         
         ON ACTION controlg      
            CALL cl_cmdask()  
            
         ON ACTION CONTROLP
            CASE
             WHEN INFIELD(rxr01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c' 
               LET g_qryparam.form = "q_rxr012"      
               LET g_qryparam.arg1 = tm.rxr00
               LET g_qryparam.arg2 = tm.rxrplant
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rxr01
          
             WHEN INFIELD(rxr16)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c' 
               LET g_qryparam.form = "q_rxr16"      
               LET g_qryparam.default1 = tm.rxr16
               LET g_qryparam.arg1 = tm.rxr00
               LET g_qryparam.arg2 = tm.rxrplant
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY  g_qryparam.multiret TO rxr16 
             OTHERWISE EXIT CASE
            END CASE    
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
  
         ON ACTION qbe_select
            CALL cl_qbe_select()
   END CONSTRUCT
      
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rxruser','rxrgrup') 
   
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM  
   END IF
               
END FUNCTION


FUNCTION p710_del()
DEFINE l_oma55  LIKE oma_file.oma55
DEFINE l_oma57  LIKE oma_file.oma57
DEFINE l_oma19  LIKE oma_file.oma19
DEFINE l_ooa31d LIKE ooa_file.ooa31d   
DEFINE l_ooa32d LIKE ooa_file.ooa32d 
DEFINE l_oob01  LIKE oob_file.oob01    
DEFINE l_rxr16  LIKE rxr_file.rxr16
DEFINE l_azp01  LIKE azp_file.azp01
DEFINE g_flag   LIKE type_file.chr1
DEFINE l_oob06  LIKE oob_file.oob06 
DEFINE l_rxr01  LIKE rxr_file.rxr01
   BEGIN WORK
   LET g_success='Y'
   LET g_flag = 'N'
   CALL s_showmsg_init()
    
   LET g_sql = "SELECT azp01,azp03 FROM azp_file,azw_file ",
               " WHERE azp01 = '",tm.rxrplant,"'",
               "   AND azw01 = azp01 AND azw02 = '",g_legal,"'"

   PREPARE sel_azp03_pre FROM g_sql
   EXECUTE sel_azp03_pre INTO l_azp01,l_dbs
   IF STATUS THEN
      CALL cl_err('p710(ckp#1):',SQLCA.sqlcode,1)
      RETURN
   END IF

   LET g_plant_new = l_azp01

   LET g_sql = "SELECT rxr16 FROM ",cl_get_target_table(g_plant_new,'rxr_file')," WHERE ",tm.wc CLIPPED," AND rxrconf='Y' "
   IF tm.rxr00 = '1' THEN
      LET g_sql = g_sql CLIPPED," AND rxr00 = '1'"
   ELSE
      LET g_sql = g_sql CLIPPED," AND rxr00 = '2'"
   END IF 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p710_pre FROM g_sql
   DECLARE p710_cs CURSOR FOR p710_pre

   FOREACH p710_cs INTO l_rxr16 
      IF STATUS != 0 THEN
         CALL cl_err('foreach:',STATUS,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
     
      LET g_flag = 'Y'  
      IF tm.rxr00 = '1'  THEN  #收取
         SELECT oma19 INTO l_oma19 FROM oma_file WHERE oma01 = l_rxr16 
         SELECT oma55,oma57 INTO l_oma55,l_oma57 FROM oma_file
          WHERE oma01 = l_oma19 AND oma00 = '26' 
         IF l_oma55 = 0 AND l_oma57 = 0 THEN 
             DELETE FROM oma_file WHERE oma01 = l_rxr16
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('oma01',l_rxr16,'DELETE oma_file',SQLCA.SQLCODE,1) 
             END IF 

             DELETE FROM omb_file WHERE omb01 = l_rxr16
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('omb01',l_rxr16,'DELETE omb_file',SQLCA.SQLCODE,1)
             END IF

             DELETE FROM omc_file WHERE omc01 = l_rxr16
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('omc01',l_rxr16,'DELETE omc_file',SQLCA.SQLCODE,1)
             END IF

             DELETE FROM oma_file WHERE oma01 = l_oma19
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('oma01',l_oma19,'DELETE oma_file',SQLCA.SQLCODE,1)  
             END IF   

             DELETE FROM omc_file WHERE omc01 = l_oma19
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('omc01',l_oma19,'DELETE omc_file',SQLCA.SQLCODE,1)     
             END IF    

             DELETE FROM npp_file WHERE npp01 = l_rxr16
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('npp01',l_rxr16,'DELETE npp_file',SQLCA.SQLCODE,1)  
             END IF    

             DELETE FROM npp_file WHERE npp01 = l_oma19
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('npp',l_oma19,'DELETE npp_file',SQLCA.SQLCODE,1)
             END IF    

             DELETE FROM npq_file WHERE npq01 = l_rxr16
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('npq',l_rxr16,'DELETE npq_file',SQLCA.SQLCODE,1) 
             END IF    

             DELETE FROM npq_file WHERE npq01 = l_oma19
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('npq',l_oma19,'DELETE npq_file',SQLCA.SQLCODE,1)
             END IF  
             
                 
          #FUN-B40056--add--str--
             DELETE FROM tic_file WHERE tic04 = l_rxr16
             IF STATUS THEN
                CALL cl_err3("del","tic_file",l_rxr16,"",STATUS,"","del tic:",1)
                LET g_success='N'
             END IF
             
             DELETE FROM tic_file WHERE tic04 = l_oma19
             IF STATUS THEN
                CALL cl_err3("del","tic_file",l_oma19,"",STATUS,"","del tic:",1)
                LET g_success='N'
             END IF
          #FUN-B40056--add--end--

             SELECT UNIQUE oob01 INTO l_oob01 FROM oob_file WHERE oob06 = l_rxr16
             DELETE FROM oob_file WHERE oob06 = l_rxr16
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('oob',l_rxr16,'DELETE oob_file',SQLCA.SQLCODE,1)
             END IF
             DELETE FROM ooa_file WHERE ooa01 = l_oob01
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL s_errmsg('ooa',l_oob01,'DELETE ooa_file',SQLCA.SQLCODE,1)  
             END IF

             IF g_success = 'Y' THEN 
                UPDATE rxr_file SET rxr16 = NULL
                              WHERE rxr16 = l_rxr16
                                AND rxr00 = '1'
                                AND rxrplant = tm.rxrplant  
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
                   CALL cl_err3("upd","rxr_file",tm.rxrplant,l_rxr16,SQLCA.sqlcode,"","",1)
                   LET g_success="N"
                   EXIT FOREACH
                END IF    
             END IF            
          ELSE
             SELECT rxr01 INTO l_rxr01 FROM rxr_file WHERE rxr16 = l_rxr16
             LET g_success = 'N'
             CALL s_errmsg('',l_rxr01,'','axrp702',1) 
          END IF
       END IF   
    	                
       IF tm.rxr00 = '2' THEN  #退還
          SELECT ooa31d,ooa32d INTO l_ooa31d,l_ooa32d FROM ooa_file 
            WHERE ooa01 = l_rxr16 
          SELECT oob06 INTO l_oob06 FROM oob_file WHERE oob01 = l_rxr16 AND oob03 ='1' 
          SELECT oma55,oma57 INTO l_oma55,l_oma57 FROM oma_file
            WHERE oma01 = l_oob06 AND oma00 = '26'
          LET l_oma55 = l_oma55 - l_ooa31d
          LET l_oma57 = l_oma57 - l_ooa32d
          UPDATE oma_file SET oma55 = l_oma55,oma57 = l_oma57 
                        WHERE oma01 = l_oob06
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err3("upd","oma_file",l_oob06,"",SQLCA.sqlcode,"","",1)
             LET g_success="N"
          END IF

          DELETE FROM ooa_file WHERE ooa01 = l_rxr16
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL s_errmsg('ooa01',l_rxr16,'DELETE ooa_file',SQLCA.SQLCODE,1)
          END IF

          DELETE FROM oob_file WHERE oob01 = l_rxr16
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL s_errmsg('oob01',l_rxr16,'DELETE oob_file',SQLCA.SQLCODE,1)
          END IF

          DELETE FROM npp_file WHERE npp01 = l_rxr16
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL s_errmsg('npp01',l_rxr16,'DELETE npp_file',SQLCA.SQLCODE,1)
          END IF

          DELETE FROM npq_file WHERE npq01 = l_rxr16
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL s_errmsg('npq01',l_rxr16,'DELETE npq_file',SQLCA.SQLCODE,1)
          END IF
          
         #FUN-B40056--add--str--
          DELETE FROM tic_file WHERE tic04 = l_rxr16
          IF STATUS THEN
             CALL cl_err3("del","tic_file",l_rxr16,"",STATUS,"","del tic:",1)
             LET g_success='N'
          END IF
          #FUN-B40056--add--end--
          
          IF g_success = 'Y' THEN    
             UPDATE rxr_file SET rxr16 = NULL
                           WHERE rxr16 = l_rxr16
                             AND rxr00 = '2'
                             AND rxrplant = tm.rxrplant
             IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
                CALL cl_err3("upd","rxr_file",tm.rxrplant,l_rxr16,SQLCA.sqlcode,"","",1)
                LET g_success="N"
             END IF                 
         END IF
      END IF
   END FOREACH

   IF g_success = 'Y' AND g_flag = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','mfg1605',1)
   ELSE
      ROLLBACK WORK 
      IF g_flag = 'N' THEN
         CALL cl_err('','mfg3160',1) 
      ELSE
         CALL cl_err('','mfg1604',1)
      END IF 
      CALL s_showmsg()           
   END IF    
END FUNCTION

#TQC-AC0127  ADD 
