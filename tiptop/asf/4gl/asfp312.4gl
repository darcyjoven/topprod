# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfp312.4gl
# Descriptions...: 工藝調整單維護作業
# Date & Author..: NO.FUN-930105 09/03/24 By lilingyu
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/05 By lilingyu 平行工藝
# Modify.........: No.FUN-A70137 10/07/29 By lilingyu 畫面增加處理"組成用量 底數"等欄位 
# Modify.........: No.TQC-AC0374 10/12/29 By Mengxw 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取  
# Modify.........: No.FUN-B10056 11/02/14 By vealxu 修改制程段號的管控
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y' 
# Modify.........: No.FUN-BB0084 11/12/19 By lixh1 增加數量欄位小數取位
# Modify.........: No.MOD-C30643 12/03/13 By fengrui 轉出單位值給成品生產單位,修改小數取位使用的單位
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No:TQC-D70046 13/07/22 By qirl “工單單號”欄位開窗建議增加料件的品名個規格欄位的顯示 過濾掉作廢工單，結 #                                            案工單。同樣after field該欄位時如果手動錄入作廢工單或者結案工單進行控卡和提示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sho   RECORD LIKE sho_file.*,
    g_sho_t RECORD LIKE sho_file.*,
    g_sho_o RECORD LIKE sho_file.*,
    b_ecm   RECORD LIKE ecm_file.*,
    g_ecm           DYNAMIC ARRAY OF RECORD   
        ecm03           LIKE ecm_file.ecm03,
        ecm04           LIKE ecm_file.ecm04 
                    END RECORD,
    g_t1            LIKE oay_file.oayslip,                    
    g_err_flag      LIKE type_file.num5,          
    g_rec_b         LIKE type_file.num5,          
    l_ac            LIKE type_file.num5,          
    l_sl            LIKE type_file.num5,          #目前處理的SCREEN LINE
    l_ecb44,l_ecb45 LIKE ecb_file.ecb44,          #???
    f_unit_out,r_unit_in LIKE ecm_file.ecm58
DEFINE g_before_input_done  LIKE type_file.num5       
DEFINE g_sql        STRING
DEFINE 
    g_z07,g_s07,g_f07  LIKE sho_file.sho07,
    g_z08,g_s08,g_f08  LIKE sho_file.sho08,
    g_s09,g_f09        LIKE sho_file.sho09,
    g_f10              LIKE sho_file.sho09,     #FUN-A60092   
    g_ecm54            LIKE type_file.chr1,       
    g_item             LIKE sfb_file.sfb05,
    p_row,p_col        LIKE type_file.num5         
 
DEFINE   g_cnt           LIKE type_file.num10           
DEFINE   g_i             LIKE type_file.num5     
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   LET p_row=1 LET p_col=1
   OPEN WINDOW p312_w AT p_row,p_col WITH FORM "asf/42f/asfp312" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()

#FUN-A60092 --begin--
 IF g_sma.sma541 = 'Y' THEN 
    CALL cl_set_comp_visible("sho012,g_f10",TRUE)
 ELSE
	  CALL cl_set_comp_visible("sho012,g_f10",FALSE)
 END IF  
#FUN-A60092 --end--
 
   INITIALIZE g_sho.* TO NULL
   CALL p312()
   CLOSE WINDOW p312_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION p312()
DEFINE li_result    LIKE type_file.num5         
DEFINE l_flag       LIKE type_file.chr1         
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                  
    CALL g_ecm.clear()
    INITIALIZE g_sho.* LIKE sho_file.*
    CALL cl_opmsg('a')
 
    WHILE TRUE
        CLEAR FORM
        CALL g_ecm.clear()
        INITIALIZE g_sho.* TO NULL         
        LET g_z07 = ''
        LET g_z08 = ''
        LET g_s07 = ''
        LET g_s08 = ''
        LET g_s09 = ''
        LET g_f07 = ''
        LET g_f08 = ''
        LET g_f09 = ''
        LET g_f10 = ' ' #FUN-A60092        
        LET g_sho.sho02 = g_today
        LET g_sho.sho10 = g_user
        LET g_sho.sho12 = 'N'      
        LET g_sho.shouser = g_user
        LET g_sho.shodate = g_today
        LET g_sho.shoplant = g_plant #FUN-980008 add
        LET g_sho.sholegal = g_legal #FUN-980008 add
 
#FUN-A60092 --begin--
        IF g_sma.sma541 = 'N' THEN
            LET g_sho.sho012 = ' ' 
        END IF  
#FUN-A60092 --end-- 

        CALL p312_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_ecm.clear()
            EXIT WHILE
        END IF
        IF cl_null(g_sho.sho01) THEN CONTINUE WHILE END IF
       
        IF NOT cl_sure(19,0) THEN CONTINUE WHILE END IF
        BEGIN WORK
        LET g_success='Y' 
        CALL p312_process() 
        CALL s_showmsg()          
                                                                                                         
        CALL s_auto_assign_no("asf",g_sho.sho01,g_today,"","sho_file","sho01","","","") 
        RETURNING li_result,g_sho.sho01                                                    
        IF (NOT li_result) THEN 
           LET g_success='N' 
        END IF	
        DISPLAY BY NAME g_sho.sho01
 
        CASE g_sho.sho06 
             WHEN '1' LET g_sho.sho07 = g_z07 
                      LET g_sho.sho08 = g_z08
                      LET g_sho.sho09 = ''    
             WHEN '2' LET g_sho.sho07 = g_s07 
                      LET g_sho.sho08 = g_s08
                      LET g_sho.sho09 = g_s09 
             WHEN '3' LET g_sho.sho07 = g_f07 
                      LET g_sho.sho08 = g_f08
                      LET g_sho.sho09 = g_f09 
                      LET g_sho.sho112= g_f10    #FUN-A60092
        END CASE
        LET g_sho.shooriu = g_user      #No.FUN-980030 10/01/04
        LET g_sho.shoorig = g_grup      #No.FUN-980030 10/01/04
#FUN-A60092 --begin--        
        IF cl_null(g_sho.sho012) THEN 
           LET g_sho.sho012 = ' ' 
        END IF  
#FUN-A60092 --end--        
        INSERT INTO sho_file VALUES(g_sho.*)     
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('sho01',g_sho.sho01,g_sho.sho01,SQLCA.sqlcode,1)         
           LET g_success='N'
        END IF
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        
            CALL p312_out()   
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag      
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
    END WHILE
END FUNCTION
 
FUNCTION p312_i(p_cmd)
   DEFINE   li_result   LIKE type_file.num5        
#--TQC-D70046--add--star--
   DEFINE   l_sfb04     LIKE sfb_file.sfb04
   DEFINE   l_sfb87     LIKE sfb_file.sfb87
#--TQC-D70046--add--end--
   DEFINE   p_cmd       LIKE type_file.chr1,         
            l_flag      LIKE type_file.chr1,            
            l_gen02     LIKE gen_file.gen02,
            l_ima571    LIKE ima_file.ima571, 
            l_cnt       LIKE type_file.num5               
   
   DISPLAY BY NAME g_sho.sho01,g_sho.sho02,g_sho.sho04,g_sho.sho06,
                   g_z07,g_z08,g_s07,g_s08,g_s09,g_f07,g_f08,g_f09,
                   g_f10,         #FUN-A60092 add                   
                   g_sho.sho12,g_sho.sho10,g_sho.sho11
          
   CALL cl_set_head_visible("","YES")  
   
   INPUT BY NAME g_sho.sho01,g_sho.sho02,g_sho.sho04,
                 g_sho.sho012,      #FUN-A60092 add
                 g_sho.sho06,
                 g_z07,g_z08,g_s07,g_s08,g_s09,g_f07,g_f08,g_f09,
                 g_f10,   #FUN-A60092 add                 
                 g_sho.sho12,
                 g_sho.sho62,g_sho.sho63,g_sho.sho64,   #FUN-A70137                    
                 g_sho.sho10,g_sho.sho11
                ,g_sho.sho16,g_sho.sho17   #FUN-A70137                    
   WITHOUT DEFAULTS
   
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
     
        ON ACTION help                                
           LET g_action_choice="help"                 
           CALL cl_show_help()                        
           CONTINUE INPUT                            
           
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p312_set_no_entry(p_cmd)
         CALL p312_set_entry(p_cmd)
         LET g_before_input_done = TRUE                                                                                             
         CALL cl_set_docno_format("sho01")                                                                                        
      
      AFTER FIELD sho01 
         IF g_sho.sho01 != g_sho_t.sho01 OR g_sho_t.sho01 IS NULL THEN                                                                                             
            CALL s_check_no("asf",g_sho.sho01,g_sho_t.sho01,"G","sho_file","sho01","")  
            RETURNING li_result,g_sho.sho01                                                   
            DISPLAY BY NAME g_sho.sho01                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               LET g_sho.sho01=g_sho_o.sho01                                                                                        
               NEXT FIELD sho01                                                                                                     
            END IF
         END IF
 
      AFTER FIELD sho04  
         IF cl_null(g_sho.sho04) THEN
            NEXT FIELD sho04
         END IF        
         SELECT sfb05 INTO g_item FROM sfb_file 
          WHERE sfb01=g_sho.sho04 
         IF STATUS THEN    
            CALL cl_err3("sel","sfb_file",g_sho.sho04,"","asf-046","","",0)    
            NEXT FIELD sho04
#FUN-A60092 --begin--            
#         ELSE
#            CALL p312_b_fill()
#            CALL p312_bp("G")
#FUN-A60092 --end--
         END IF
#TQC-D70046---add---star---
         SELECT sfb04,sfb87 INTO l_sfb04,l_sfb87 FROM sfb_file
          WHERE sfb01=g_sho.sho04
         IF l_sfb04 = '8' OR l_sfb87 = 'X' THEN 
            CALL cl_err(g_sho.sho04,'asf-777',0)
            NEXT FIELD sho04
         END IF 
#TQC-D70046---add---end---
 
         CALL cl_qbe_init()
    
#FUN-A60092 --begin--
      AFTER FIELD sho012
        IF g_sma.sma541 = 'Y' THEN 
           IF cl_null(g_sho.sho012) THEN 
              NEXT FIELD CURRENT 
           END IF 
        ELSE
      	   IF cl_null(g_sho.sho012) THEN 
      	      LET g_sho.sho012 = ' ' 
      	   END IF    
        END IF         
       SELECT COUNT(*) INTO l_cnt FROM ecm_file
        WHERE ecm01 = g_sho.sho04
          AND ecm012= g_sho.sho012
        IF l_cnt = 0 THEN 
           CALL cl_err('','abm-214',0)
           NEXT FIELD CURRENT 
        ELSE
           CALL p312_b_fill()
           CALL p312_bp("G")        	    
        END IF                      
#FUN-A60092 --end--

      BEFORE FIELD sho06
         CALL p312_set_no_entry(p_cmd)
 
      ON CHANGE sho06
         IF NOT cl_null(g_sho.sho06) THEN
            CALL p312_set_no_entry(p_cmd)
            IF g_sho.sho06 NOT MATCHES '[123]' THEN
                NEXT FIELD sho06
            END IF
            CALL p312_set_entry(p_cmd)
         END IF
 
#add      
      AFTER FIELD sho06   
        IF NOT cl_null(g_sho.sho06) THEN 
            CALL p312_set_no_entry(p_cmd)
            IF g_sho.sho06 NOT MATCHES '[123]' THEN
                NEXT FIELD sho06
            END IF 
            CALL p312_set_entry(p_cmd)
        END IF 
#add

#FUN-A70137 --begin--
      AFTER FIELD sho62
        IF NOT cl_null(g_sho.sho62) THEN 
            IF g_sho.sho62 <= 0 THEN 
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT 
            END IF 
         ELSE 
            NEXT FIELD CURRENT 
         END IF 	
               
      AFTER FIELD sho63
         IF NOT cl_null(g_sho.sho63) THEN 
            IF g_sho.sho63 <= 0 THEN 
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT 
            END IF 
         ELSE 
            NEXT FIELD CURRENT 
         END IF 	 
               
      AFTER FIELD sho64
         IF NOT cl_null(g_sho.sho64) THEN 
            IF g_sho.sho64 <= 0 THEN 
               CALL cl_err('','afa-037',0)
               NEXT FIELD CURRENT 
            END IF 
         ELSE 
            NEXT FIELD CURRENT 
         END IF 	
               
      AFTER FIELD sho16
         IF cl_null(g_sho.sho16) THEN 
            NEXT FIELD CURRENT 
         ELSE
         	  IF g_sho.sho16 < 0 THEN 
         	     CALL cl_err('','aim-223',0)
         	     NEXT FIELD CURRENT 
         	  END IF               
         END IF 	
               
      AFTER FIELD sho17
         IF cl_null(g_sho.sho17) THEN 
            NEXT FIELD CURRENT 
         ELSE
         	  IF g_sho.sho17 < 0 THEN 
         	     CALL cl_err('','aim-223',0)
         	     NEXT FIELD CURRENT 
         	  END IF    
         END IF 	       
#FUN-A70137 --end--

      AFTER FIELD g_z07
         IF NOT cl_null(g_z07) THEN
            SELECT ecm54 INTO g_ecm54 FROM ecm_file 
             WHERE ecm01=g_sho.sho04 AND ecm03=g_z07
               AND ecm012=g_sho.sho012   #FUN-A60092 add
            IF STATUS THEN 
               CALL cl_err3("sel","ecm_file",g_sho.sho04,g_z07,"asf-805","","",0)   
               NEXT FIELD g_z07 
            END IF
#FUN-A60092 --begin--
#            #---- 前一站轉出單位(f_unit_out)
#            SELECT ecm58 INTO f_unit_out FROM ecm_file
#             WHERE ecm01=g_sho.sho04
#               AND ecm03=(SELECT MAX(ecm03) FROM ecm_file
#                           WHERE ecm01=g_sho.sho04 AND ecm03<g_z07)
#            IF STATUS THEN LET f_unit_out=' ' END IF
#          
#            #---- 後一站轉入單位(r_unit_in)
#            SELECT ecm57 INTO r_unit_in FROM ecm_file
#             WHERE ecm01=g_sho.sho04
#               AND ecm03=(SELECT MIN(ecm03) FROM ecm_file
#                           WHERE ecm01=g_sho.sho04 AND ecm03>g_z07)
#            IF STATUS THEN
#               LET r_unit_in=' '
#            END IF
#          
#            IF NOT cl_null(f_unit_out) AND NOT cl_null(r_unit_in) THEN
#               IF f_unit_out!=r_unit_in THEN
#                  CALL cl_err(g_sho.sho04,'asf-925',0)
#                  NEXT FIELD g_z07 
#               END IF
#            END IF
#FUN-A60092 --end--            
            CALL ecm_chk(g_ecm54,g_z07) RETURNING g_err_flag,g_z08
            IF g_err_flag=1 THEN
               CALL cl_err(g_sho.sho04,'asf-912',0)
               NEXT FIELD g_z07 
            ELSE
               DISPLAY g_z08 TO FORMONLY.g_z08 
            END IF
           
            IF NOT cl_null(g_z08) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM shb_file 
                WHERE shb05 = g_sho.sho04
                  AND shb06 = g_z07 
                  AND shb081 = g_z08
                  AND shb012 = g_sho.sho012  #FUN-A60092 add
                  AND shbconf = 'Y'    #FUN-A70095
               IF l_cnt > 0 THEN
                  CALL cl_err(g_z08,'asf-924',1)
                  NEXT FIELD g_z07
               END IF
            END IF
         END IF 
          
      BEFORE FIELD g_s07
         IF g_sho.sho06 MATCHES '[13]' THEN
            NEXT FIELD g_f07
         END IF
 
      AFTER FIELD g_s07
         IF NOT cl_null(g_s07) THEN
            SELECT ecm54 INTO g_ecm54 FROM ecm_file 
             WHERE ecm01=g_sho.sho04 AND ecm03=g_s07
               AND ecm012=g_sho.sho012  #FUN-A60092 add
            IF STATUS THEN 
               CALL cl_err3("sel","ecm_file",g_sho.sho04,g_s07,"asf-805","","",0)    
               NEXT FIELD g_s07 
            END IF
            CALL ecm_chk(g_ecm54,g_s07) RETURNING g_err_flag,g_s08
            IF g_err_flag=1 THEN
               CALL cl_err(g_sho.sho04,'asf-912',0)
               NEXT FIELD g_s07 
            ELSE
               DISPLAY g_s08 TO FORMONLY.g_s08 
            END IF
#FUN-A60092 --begin--       
#            #---- 轉出單位(f_unit_out)
#            SELECT ecm58 INTO f_unit_out FROM ecm_file
#             WHERE ecm01=g_sho.sho04
#               AND ecm03=(SELECT MAX(ecm03) FROM ecm_file
#                           WHERE ecm01=g_sho.sho04 AND ecm03<g_s07)
#            IF STATUS THEN
#               LET f_unit_out=' '
#            END IF
#          
#            #---- 轉入單位(r_unit_in)
#            SELECT ecm57 INTO r_unit_in FROM ecm_file
#             WHERE ecm01=g_sho.sho04 AND ecm03=g_s07
#            IF STATUS THEN
#               LET r_unit_in=' '
#            END IF
#            IF f_unit_out=' ' THEN
#               LET f_unit_out=r_unit_in
#            END IF
#            IF r_unit_in=' ' THEN
#               LET r_unit_in=f_unit_out
#            END IF
#FUN-A60092 --end--
         END IF 
 
      AFTER FIELD g_s09
         IF NOT cl_null(g_s09) THEN
            SELECT COUNT(*) INTO g_cnt FROM ecd_file 
             WHERE ecd01=g_s09
            IF g_cnt=0 THEN 
               CALL cl_err(g_s09,'aec-015',0)
               NEXT FIELD g_s09 
            END IF
         END IF 
 
      BEFORE FIELD g_f07
         IF g_sho.sho06 MATCHES '[12]' THEN
            NEXT FIELD sho12
         END IF
 
      AFTER FIELD g_f07
         IF NOT cl_null(g_f07) THEN
            SELECT ecm54 INTO g_ecm54 FROM ecm_file 
               WHERE ecm01=g_sho.sho04 AND ecm03=g_f07
                 AND ecm012=g_sho.sho012   #FUN-A60092 add
            IF STATUS THEN 
               CALL cl_err3("sel","ecm_file",g_sho.sho04,g_f07,"asf-805","","",0)   
               NEXT FIELD g_f07 
            END IF
            SELECT COUNT(*) INTO g_cnt FROM shb_file
             WHERE shb05 = g_sho.sho04 
               AND shb06=g_f07
               AND shb012= g_sho.sho012   #FUN-A60092 add
               AND shbconf = 'Y'     #FUN-A70095
            IF g_cnt>0 THEN 
               CALL cl_err(g_sho.sho04,'asf-924',0)
               NEXT FIELD g_f07 
            END IF
            CALL ecm_chk(g_ecm54,g_f07) RETURNING g_err_flag,g_f08
            IF g_err_flag=1 THEN
               CALL cl_err(g_sho.sho04,'asf-912',0)
               NEXT FIELD g_f07 
            ELSE
               DISPLAY g_f08 TO FORMONLY.g_f08 
            END IF
            IF NOT cl_null(g_f08) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM shb_file 
                WHERE shb05 = g_sho.sho04
                  AND shb06 = g_f07 
                  AND shb081 = g_f08
                  AND shb012 = g_sho.sho012  #FUN-A60092 add
                  AND shbconf = 'Y'   #FUN-A70095
               IF l_cnt > 0 THEN
                  CALL cl_err(g_f08,'asf-961',1)
                  NEXT FIELD g_f07
               END IF
            END IF
         END IF 

#FUN-A60092 --begin--
      AFTER FIELD g_f10
        IF g_f10 IS NOT NULL THEN 
           LET g_cnt = 0
           SELECT ima571 INTO l_ima571 FROM ima_file
            WHERE ima01=g_item 
            IF l_ima571 IS NULL THEN LET l_ima571=' ' END IF 
            
            SELECT COUNT(*) INTO g_cnt FROM ecu_file
             WHERE ecu01 = l_ima571 
               AND ecu02 = g_f09
               AND ecu012= g_f10 
               AND ecuacti = 'Y'  #CHI-C90006
            IF g_cnt=0 THEN  
               SELECT COUNT(*) INTO g_cnt FROM ecu_file      #FUN-B10056
                WHERE ecu01=g_item AND ecu02=g_f09 AND ecu012=g_f10 #FUN-B10056
                  AND ecuacti = 'Y'  #CHI-C90006
               IF g_cnt = 0 THEN  #FUN-B10056
                  CALL cl_err('','abm-214',0)
                  NEXT FIELD g_f10
               END IF
            END IF
        END IF 
#FUN-A60092 --end--
 
      AFTER FIELD g_f09
         IF NOT cl_null(g_f09) THEN           
            LET g_cnt = 0
            SELECT ima571 INTO l_ima571 FROM ima_file
             WHERE ima01=g_item
            IF l_ima571 IS NULL THEN LET l_ima571=' ' END IF 
 
            SELECT COUNT(*) INTO g_cnt FROM ecu_file
             WHERE ecu01=l_ima571 AND ecu02=g_f09
               AND ecuacti = 'Y'  #CHI-C90006
              #AND ecu012=g_sho.sho012   #FUN-A60092 add  #FUN-B10056
 
            IF g_cnt=0 THEN 
               SELECT COUNT(*) INTO g_cnt FROM ecu_file
                WHERE ecu01 = g_item
                  AND ecu02 = g_f09
                  AND ecuacti = 'Y'  #CHI-C90006
                 #AND ecu012= g_sho.sho012   #FUN-A60092 add  #FUN-B10056
               IF g_cnt=0 THEN 
                  CALL cl_err(g_f09,'mfg4030',0)
                  NEXT FIELD g_f09 
               ELSE 
                  LET l_ima571 = g_item
               END IF
            END IF         
#FUN-A60092 --begin--            
#            SELECT ecb44 INTO l_ecb44 FROM ecb_file 
#             WHERE ecb01=l_ima571 
#               AND ecb02=g_f09     
#               AND ecb03=(SELECT MIN(ecb03) FROM ecb_file 
#                           WHERE ecb01=l_ima571 AND ecb02=g_f09)   
#            IF STATUS THEN 
#               LET l_ecb44=' ' 
#            END IF
#           
#            #---- 前一站轉出單位(f_unit_out)
#            SELECT ecm58 INTO f_unit_out FROM ecm_file
#             WHERE ecm01=g_sho.sho04 
#               AND ecm03=(SELECT MAX(ecm03) FROM ecm_file
#                           WHERE ecm01=g_sho.sho04 AND ecm03<g_f07)
#            IF STATUS THEN
#               LET f_unit_out=' '
#            END IF
#            IF NOT cl_null(f_unit_out) THEN
#               IF f_unit_out!=l_ecb44 THEN
#                  CALL cl_err(g_sho.sho04,'asf-925',0)
#                  NEXT FIELD g_f09 
#               END IF
#            END IF
#           
#            SELECT ecb45 INTO l_ecb45 FROM ecb_file 
#             WHERE ecb01=l_ima571
#               AND ecb02=g_f09     
#               AND ecb03=(SELECT MAX(ecb03) FROM ecb_file 
#                           WHERE ecb01=l_ima571 AND ecb02=g_f09)   
#            IF STATUS THEN
#               LET l_ecb45=' '
#            END IF
#           
#            #---- 後一站轉入單位(r_unit_in)
#            SELECT ecm57 INTO r_unit_in FROM ecm_file
#             WHERE ecm01=g_sho.sho04 
#               AND ecm03=g_f07
#            IF STATUS THEN
#               LET r_unit_in=' '
#            END IF
#            IF NOT cl_null(r_unit_in) THEN
#               IF r_unit_in!=l_ecb45 THEN
#                  CALL cl_err(g_sho.sho04,'asf-925',0)
#                  NEXT FIELD g_f09 
#               END IF
#            END IF
#FUN-A60092 --end--
         END IF 
 
      AFTER FIELD sho12 
         IF NOT cl_null(g_sho.sho12) THEN
            IF g_sho.sho12 NOT MATCHES '[YN]' THEN
               NEXT FIELD sho12
            END IF
         END IF
 
      AFTER FIELD sho10 
         LET l_gen02 = NULL  
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_sho.sho10
         IF STATUS THEN 
            CALL cl_err3("sel","gen_file",g_sho.sho10,"","mfg1312","","",0) 
            NEXT FIELD sho10
         ELSE
            DISPLAY l_gen02 TO FORMONLY.gen02 
         END IF 
             
      AFTER INPUT  
         IF INT_FLAG THEN
            EXIT INPUT 
         END IF
         CASE g_sho.sho06 
             WHEN '1' 
                  IF cl_null(g_z07) THEN NEXT FIELD g_z07 END IF
                  IF cl_null(g_z08) THEN NEXT FIELD g_z08 END IF
             WHEN '2' 
                  IF cl_null(g_s07) THEN NEXT FIELD g_s07 END IF
                  IF cl_null(g_s08) THEN NEXT FIELD g_s08 END IF
                  IF cl_null(g_s09) THEN NEXT FIELD g_s09 END IF
             WHEN '3' 
                  IF cl_null(g_f07) THEN NEXT FIELD g_f07 END IF
                  IF cl_null(g_f08) THEN NEXT FIELD g_f08 END IF
                  IF cl_null(g_f09) THEN NEXT FIELD g_f09 END IF   
                  IF cl_null(g_f10) THEN LET g_f10 = ' ' END IF     #FUN-A60092                   
         END CASE
 
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(sho01) 
                 LET g_t1 = s_get_doc_no(g_sho.sho01)     
                 CALL q_smy(FALSE,FALSE,g_t1,'ASF','G') RETURNING g_t1  
                 LET g_sho.sho01 = g_t1                 
                 DISPLAY BY NAME g_sho.sho01 
                 NEXT FIELD sho01
 
              WHEN INFIELD(sho04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sho04"
                 LET g_qryparam.default1 = g_sho.sho04
                 CALL cl_create_qry() RETURNING g_sho.sho04
                 DISPLAY BY NAME g_sho.sho04
                 NEXT FIELD sho04               

#FUN-A60092 --begin--
              WHEN INFIELD(sho012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sho012_1"
                 LET g_qryparam.default1 = g_sho.sho012
                 LET g_qryparam.arg1     = g_sho.sho04
                 CALL cl_create_qry() RETURNING g_sho.sho012
                 DISPLAY BY NAME g_sho.sho012
                 NEXT FIELD sho012             
#FUN-A60092 --end--
            
              WHEN INFIELD(sho10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_sho.sho10
                 CALL cl_create_qry() RETURNING g_sho.sho10
                 DISPLAY BY NAME g_sho.sho10 
                 NEXT FIELD sho10
            END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                     
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit                          
         LET INT_FLAG = 1
         EXIT INPUT
   
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
END FUNCTION
 
FUNCTION p312_set_entry(p_cmd) 
DEFINE p_cmd   LIKE type_file.chr1         
 
   IF NOT g_before_input_done OR INFIELD(sho06) THEN 
      CASE g_sho.sho06 
        WHEN '1' CALL cl_set_comp_entry("g_z07",TRUE) 
                        
        WHEN '2' CALL cl_set_comp_entry("g_s07,g_s09,sho12,sho62,sho63,sho64,sho16,sho17",TRUE) 
                                        #FUN-A70137 add sho62,sho63,sho64,sho16,sho17
#FUN-A70137 --begin--
                 LET g_sho.sho62 = 1
                 LET g_sho.sho63 = 1
                 LET g_sho.sho64 = 1
                 LET g_sho.sho16 = 0
                 LET g_sho.sho17 = 0
                 DISPLAY BY NAME g_sho.sho62,g_sho.sho63,g_sho.sho64,g_sho.sho16,g_sho.sho17
#FUN-A70137 --end--              
        
        WHEN '3' CALL cl_set_comp_entry("g_f07,g_f09,sho12,g_f10",TRUE)  #FUN-A60092 add g_f10
        
      END CASE
   END IF 
 
END FUNCTION
 
FUNCTION p312_set_no_entry(p_cmd) 
DEFINE p_cmd   LIKE type_file.chr1           
 
   IF NOT g_before_input_done OR INFIELD(sho06) THEN 
      CALL cl_set_comp_entry("g_z07,g_s07,g_f07,g_s09,g_f09,sho12,,g_f10,sho62,sho63,sho64,sho16,sho17",FALSE) 
                            #FUN-A70137 add sho62,sho63,sho64,sho16,sho17
                            #FUN-A60092 add g_f10    
#FUN-A70137 --begin--
                 LET g_sho.sho62 = NULL  LET g_sho.sho63 = NULL
                 LET g_sho.sho64 = NULL  LET g_sho.sho16 = NULL 
                 LET g_sho.sho17 = NULL 
                 DISPLAY BY NAME g_sho.sho62,g_sho.sho63,g_sho.sho64,g_sho.sho16,g_sho.sho17
#FUN-A70137 --end--          
   END IF 
  
END FUNCTION
 
FUNCTION ecm_chk(p_chkin,p_ecm03)       
DEFINE p_chkin   LIKE type_file.chr1,         
       p_ecm03   LIKE type_file.num5,         
       l_wos     LIKE sho_file.sho08
 
    LET g_err_flag=0
    IF p_chkin='Y' THEN
       SELECT ecm04 INTO l_wos FROM ecm_file 
        WHERE ecm01 = g_sho.sho04 
          AND ecm03 = p_ecm03
          AND ecm012= g_sho.sho012   #FUN-A60092 
          AND ecm291= 0 
        # AND (ecm291-ecm59*(ecm311+ecm312+ecm313+ecm314+ecm316))=0   #FUN-A60092
          AND (ecm291-(ecm311+ecm312+ecm313+ecm314+ecm316))=0         #FUN-A60092
    ELSE
       SELECT ecm04 INTO l_wos FROM ecm_file 
          WHERE ecm01  = g_sho.sho04 
            AND ecm03  = p_ecm03
            AND ecm012= g_sho.sho012   #FUN-A60092             
            AND ecm291 = 0 
          # AND (ecm301+ecm302+ecm303-ecm59*(ecm311+ecm312+ecm313+ecm314+ecm316))=0  #FUN-A60092
            AND (ecm301+ecm302+ecm303-(ecm311+ecm312+ecm313+ecm314+ecm316))=0  #FUN-A60092
    END IF 
    IF STATUS THEN LET g_err_flag=1 LET l_wos='' END IF
    RETURN g_err_flag,l_wos
END FUNCTION
 
FUNCTION p312_process() 
    DEFINE l_ecm   RECORD LIKE ecm_file.*
    DEFINE l_ecd   RECORD LIKE ecd_file.*
    DEFINE l_ecb   RECORD LIKE ecb_file.*
    DEFINE l_ecm03        LIKE ecm_file.ecm03 
    DEFINE l_cnt          LIKE type_file.num5    
    DEFINE l_sfb08        LIKE sfb_file.sfb08    #FUN-A70137 
    DEFINE l_sfb05        LIKE sfb_file.sfb05    #TQC-AC0374
    DEFINE l_flag         LIKE type_file.num5    #TQC-AC0374  
    DEFINE l_sfb06        LIKE sfb_file.sfb06    #TQC-AC0374

    CALL s_showmsg_init()  
    CASE g_sho.sho06
         WHEN '1'    
              DELETE FROM ecm_file WHERE ecm01 = g_sho.sho04 AND ecm03=g_z07
                                     AND ecm012= g_sho.sho012   #FUN-A60092 add
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN LET g_success='N' END IF
              #------- 後面各站製程序往前挪 1*sma849
              DECLARE ecm_cur1 CURSOR FOR 
               SELECT * FROM ecm_file 
                WHERE ecm01 = g_sho.sho04 AND ecm03>g_z07
                  AND ecm012= g_sho.sho012   #FUN-A60092 add                                  
              FOREACH ecm_cur1 INTO l_ecm.*
                  UPDATE ecm_file SET ecm03=ecm03-g_sma.sma849
                   WHERE ecm01 = g_sho.sho04 AND ecm03=l_ecm.ecm03
                     AND ecm012= g_sho.sho012   #FUN-A60092 add
                  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
                     LET g_success='N' 
                     CONTINUE FOREACH             
                  ELSE
                     UPDATE sgd_file SET sgd03=sgd03-g_sma.sma849
                      WHERE sgd00 = g_sho.sho04 AND sgd03=l_ecm.ecm03
                        AND sgd012= g_sho.sho012  #FUN-A60092 add
                  END IF
              END FOREACH
              
         WHEN '2'    
              #------- 後面各站製程序往後挪 1*sma849
              DECLARE ecm_cur2 CURSOR FOR 
                 SELECT * FROM ecm_file 
                  WHERE ecm01=g_sho.sho04 
                    AND ecm03>=g_s07 
                    AND ecm012=g_sho.sho012   #FUN-A60092 
                    ORDER BY ecm03 DESC
              FOREACH ecm_cur2 INTO l_ecm.*
                  UPDATE ecm_file SET ecm03=ecm03+g_sma.sma849
                      WHERE ecm01=g_sho.sho04 
                        AND ecm03=l_ecm.ecm03
                        AND ecm012=g_sho.sho012   #FUN-A60092 add
                  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
                     LET g_success='N' 
                     CONTINUE FOREACH                
                  ELSE
                     UPDATE sgd_file SET sgd03=sgd03+g_sma.sma849
                      WHERE sgd00=g_sho.sho04 
                        AND sgd03=l_ecm.ecm03
                        AND sgd012=g_sho.sho012   #FUN-A60092 add
                  END IF
              END FOREACH
 
              SELECT * INTO l_ecd.* FROM ecd_file WHERE ecd01=g_s09
 
#FUN-A70137 --begin--
#工单编号，制程段号，制程序，生产数量，固定损耗量，变动损耗率，损耗批量,组成用量/底数,p_QPA
             SELECT sfb08,sfb06 INTO l_sfb08,l_sfb06 FROM sfb_file  #TQC-AC0374
              WHERE sfb01 = g_sho.sho04

             CALL cralc_eck_rate(g_sho.sho04,g_sho.sho012,g_s07,l_sfb08,
                                 g_sho.sho16,g_sho.sho17,g_sho.sho64,
                                 g_sho.sho62/g_sho.sho63,1)              
               RETURNING l_ecm.ecm65   
            #LET l_ecm.ecm65 = s_digqty(l_ecm.ecm65,r_unit_in)     #FUN-BB0084  #MOD-C30643 mark
            LET l_ecm.ecm65 = s_digqty(l_ecm.ecm65,l_ecm.ecm58)                 #MOD-C30643 add
            #FUN-B10056 ------------mod start--------------------
            #CALL s_schdat_sel_ima571(g_sho.sho04) RETURNING l_flag,l_sfb05  #TQC-AC0374 
            # DECLARE ecu012_curs_1 CURSOR FOR 
            # SELECT ecu012 FROM ecu_file
            #  WHERE ecu01 =  l_sfb05      #TQC-AC0374            
            #    AND ecu02 =  l_sfb06      #TQC-AC0374
            #    AND ecu015=  g_sho.sho012
             DECLARE ecu012_curs_1 CURSOR FOR
              SELECT ecm012 FROM ecm_file
               WHERE ecm01 = g_sho.sho04
                 AND ecm015 = g_sho.sho012 
             #FUN-B10056 -----------mod end------------------     
              FOREACH ecu012_curs_1 INTO l_ecm.ecm011
                 EXIT FOREACH 
              END FOREACH                             
#FUN-A70137 --end--

               #LET l_ecd.ecd12 = s_digqty(l_ecd.ecd12,r_unit_in)    #FUN-BB0084 #MOD-C30643 mark
               LET l_ecd.ecd12 = s_digqty(l_ecd.ecd12,l_ecm.ecm58)               #MOD-C30643 add 
               INSERT INTO ecm_file(ecm01,ecm02,ecm03_par,ecm03,ecm04,  
                                   ecm05,ecm06,ecm07,ecm08,ecm09,
                                   ecm10,ecm11,ecm12,ecm121,ecm13,
                                   ecm14,ecm15,ecm16,ecm17,ecm18,
                                   ecm19,ecm20,ecm21,ecm22,ecm23,
                                   ecm24,ecm25,ecm26,ecm27,ecm28,
                                   ecm291,ecm292,ecm301,ecm302,ecm303,
                                   ecm311,ecm312,ecm313,ecm314,ecm315,
                                   ecm316,ecm321,ecm322,ecm34,        ecm35,
                                   ecm36,
                                   ecm37,ecm38,ecm39,ecm40,ecm41,ecm42,ecm43,
                                   ecm45,ecm49,ecm50,ecm51,ecm52,ecm53,ecm54,
                                 # ecm55,ecm56,ecm57,ecm58,ecm59,ecmacti,ecmuser,   #FUN-A60092
                                   ecm55,ecm56,      ecm58,ecm61,ecmacti,ecmuser,   #FUN-A60092  #TQC-AC0374 add ecm61 
                                   ecmgrup,ecmmodu,ecmdate,
                                   ecmplant,ecmlegal,ecmoriu,ecmorig,ecm012,ecm011,ecm62,ecm63,ecm64,ecm65,ecm66) #FUN-980008 add #TQC-B80022 add ecm66
                                          #FUN-A70137 add ecm62,ecm63,ecm64,ecm65
                                                  #FUN-A60092 add ecm012
                                   VALUES(l_ecm.ecm01,l_ecm.ecm02,l_ecm.ecm03_par,g_s07,g_s09,   
                                          l_ecd.ecd06,l_ecd.ecd07,0,0,0,
                                          0,
#                                         l_ecm.ecm11,l_ecd.ecd12,'N',   #FUN-A70137 mark
                                          l_ecm.ecm11,g_sho.sho16,'N',   #FUN-A70137 
                                          l_ecd.ecd16,
                                          
                                          l_ecd.ecd17, l_ecd.ecd18,l_ecd.ecd19,l_ecd.ecd20,0,
                                          0,0,0,0,0,
                                          0,0,0,0,0,
                                          0,0,0,0,0,
                                          0,0,0,0,0,
#                                         0,0,0,0,0,  #FUN-A70137 
                                          0,0,0,g_sho.sho17,0,  #FUN-A70137 
                                          0,l_ecd.ecd24,l_ecd.ecd25,
                                          l_ecd.ecd26,l_ecd.ecd13,
                                          l_ecd.ecd14,l_ecd.ecd09,
                                          l_ecd.ecd11,l_ecd.ecd02,
                                          0,g_today,l_ecm.ecm51,
                                          'N','N','N','','',
                                       #  f_unit_out,r_unit_in,1,  #FUN-A60092
                                       #             r_unit_in,    #FUN-A60092        #MOD-C30643 mark
                                                      l_ecm.ecm58,                    #MOD-C30643 add
                                          'N','Y',g_user,g_grup,'','',  #TQC-AC0374
                                          g_plant,g_legal, g_user, g_grup,l_ecm.ecm012,l_ecm.ecm011,g_sho.sho62,g_sho.sho63,g_sho.sho64,l_ecm.ecm65,'Y') #FUN-980008 add      #No.FUN-980030 10/01/04  insert columns oriu, orig #TQC-B80022 add 'Y'
                                                    #FUN-A70137 add sho62,sho63,sho64,sho65
                                                           #FUN-A60092 add l_ecm.ecm012 
              IF STATUS THEN    
	               CALL s_errmsg('ecd01',g_s09,'ins ecm:',STATUS,1)       
                 LET g_success='N' 
              END IF 
         WHEN '3'
              CALL s_schdat_sel_ima571(g_sho.sho04) RETURNING l_flag,l_sfb05  #TQC-AC0374 
              SELECT COUNT(*) INTO l_cnt FROM ecb_file 
              #WHERE ecb01=g_item  AND ecb02=g_f09  #TQC-AC0374
               WHERE ecb01=l_sfb05 AND ecb02=g_f09  #TQC-AC0374
                 AND ecb012=g_f10     #FUN-A60092 add
              IF l_cnt=0 THEN RETURN END IF
              #------- 後面各站製程序往後挪 n*sma849
              DECLARE ecm_cur3 CURSOR FOR 
                 SELECT * FROM ecm_file 
                  WHERE ecm01=g_sho.sho04 
                    AND ecm03>=g_f07 
                    AND ecm012=g_sho.sho012   #FUN-A60092 add
                    ORDER BY ecm03 DESC
              FOREACH ecm_cur3 INTO l_ecm.*
#                  UPDATE ecm_file SET ecm03 = ecm03+n*g_sma.sma849  #FUN-A60092
                   UPDATE ecm_file SET ecm03 = ecm03+l_cnt*g_sma.sma849  #FUN-A60092
                   WHERE ecm01=g_sho.sho04 
                     AND ecm03=l_ecm.ecm03
                     AND ecm012=g_sho.sho012   #FUN-A60092 add
                  IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
                     LET g_success='N' 
                     CONTINUE FOREACH                
                  ELSE
                     UPDATE sgd_file SET sgd03 = sgd03+n*g_sma.sma849
                      WHERE sgd00 = g_sho.sho04 AND sgd03 = l_ecm.ecm03
                        AND sgd012= g_sho.sho012   #FUN-A60092 add
                  END IF
              END FOREACH
 
              LET l_ecm03=l_ecm.ecm03
              DECLARE ecb_cur CURSOR FOR
                  SELECT * FROM ecb_file
                   WHERE ecb01=l_sfb05   #TQC-AC0374
                     AND ecb02=g_f09 
                      AND ecb012= g_f10  #FUN-A60092       
                     ORDER BY ecb03
              FOREACH ecb_cur INTO l_ecb.*
                 IF g_success='N' THEN                                                                                                          
                    LET g_totsuccess='N'                                                                                                       
                    LET g_success="Y"                                                                                                          
                 END IF                    
#FUN-A60092 --begin--
              LET l_ecm.ecm62 = l_ecb.ecb46  
              LET l_ecm.ecm63 = l_ecb.ecb51
              LET l_ecm.ecm12 = l_ecb.ecb52
              LET l_ecm.ecm34 = l_ecb.ecb14
              LET l_ecm.ecm64 = l_ecb.ecb53
              
#工单编号，制程段号，制程序，生产数量，固定损耗量，变动损耗率，损耗批量,组成用量/底数,p_QPA
             SELECT sfb08,sfb06 INTO l_sfb08,l_sfb06 FROM sfb_file  #TQC-AC0374 add sfb06
              WHERE sfb01 = g_sho.sho04
             CALL cralc_eck_rate(g_sho.sho04,g_sho.sho012,l_ecm03,l_sfb08,
                                 l_ecb.ecb52,l_ecb.ecb14,l_ecb.ecb53,
                                 l_ecb.ecb46/l_ecb.ecb51,1)              
               RETURNING l_ecm.ecm65
             #LET l_ecm.ecm65 = s_digqty(l_ecm.ecm65,l_ecb.ecb45)       #FUN-BB0084  #MOD-C30643 mark
             LET l_ecm.ecm65 = s_digqty(l_ecm.ecm65,l_ecm.ecm58)                     #MOD-C30643 add 
             #FUN-B10056 -------------mod start----------- 
             #DECLARE ecu012_curs CURSOR FOR 
             #SELECT ecu012 FROM ecu_file
             # WHERE ecu01 =  l_sfb05  #TQC-AC0374           
             #   AND ecu02 =  l_sfb06  #TQC-AC0374
             #   AND ecu015=  g_sho.sho012
              DECLARE ecu012_curs CURSOR FOR
               SELECT ecm012 FROM ecm_file 
                WHERE ecm01 = g_sho.sho04
                  AND ecm015 = g_sho.sho012  
             #FUN-B10056 -------------mod end-------------
              FOREACH ecu012_curs INTO l_ecm.ecm011
                 EXIT FOREACH 
              END FOREACH    
#FUN-A60092 --end--    
              INSERT INTO ecm_file(ecm01,ecm02,ecm03_par,ecm03,ecm04,   
                                   ecm05,ecm06,ecm07,ecm08,ecm09,
                                   ecm10,ecm11,ecm12,ecm121,ecm13,
                                   ecm14,ecm15,ecm16,ecm17,ecm18,
                                   ecm19,ecm20,ecm21,ecm22,ecm23,
                                   ecm24,ecm25,ecm26,ecm27,ecm28,
                                   ecm291,ecm292,ecm301,ecm302,ecm303,
                                   ecm311,ecm312,ecm313,ecm314,ecm315,
                                   ecm316,ecm321,ecm322,ecm34,                                   
                                   ecm35,ecm36,
                                   ecm37,ecm38,ecm39,ecm40,ecm41,ecm42,ecm43,
                                   ecm45,ecm49,ecm50,ecm51,ecm52,ecm53,ecm54,
                                 # ecm55,ecm56,ecm57,ecm58,ecm59,ecmacti,ecmuser,    #FUN-A60092
                                   ecm55,ecm56,ecm58,ecmacti,ecmuser,    #FUN-A60092
                                   ecmgrup,ecmmodu,ecmdate,
                                   ecmplant,ecmlegal,ecmoriu,ecmorig,ecm012,ecm011,
                                   ecm62,ecm63,ecm64,ecm65,ecm66,ecm61)   #FUN-980008 add  #TQC-AC0374 #TQC-B80022 add ecm66
                                   #FUN-A70137 add ecm011,ecm62,ecm63,ecm64,ecm65
                                   #FUN-A60092 add ecm012
                                 VALUES(l_ecm.ecm01,l_ecm.ecm02,l_ecm.ecm03_par,l_ecm03,l_ecb.ecb06,
                                        l_ecb.ecb07,l_ecb.ecb08,0,0,0,
                                        0,
#                                             g_f09,l_ecb.ecb14,   #FUN-A60092
                                        g_f09,l_ecm.ecm12,   #FUN-A60092
                                        l_ecb.ecb09,l_ecb.ecb18,
                                        l_ecb.ecb19,l_ecb.ecb20,
                                              l_ecb.ecb21,l_ecb.ecb22,
                                              l_ecb.ecb10,
                                              0,0,0,0,0,
                                              0,0,0,0,0,
                                              0,0,0,0,0,
                                              0,0,0,0,0,
#                                              0,0,0,0,  #FUN-A60092 
                                              0,0,0,l_ecm.ecm34,   #FUN-A60092
                                              0,0,
                                              l_ecb.ecb26,l_ecb.ecb27,
                                              l_ecb.ecb28,l_ecb.ecb15,
                                              l_ecb.ecb16,l_ecb.ecb11,
                                              l_ecb.ecb13,l_ecb.ecb17,
                                              l_ecb.ecb38,g_today,l_ecm.ecm51,
                                              l_ecb.ecb39,l_ecb.ecb40,
                                              l_ecb.ecb41,l_ecb.ecb42,
                                            # l_ecb.ecb43,l_ecb.ecb44,     #FUN-A60092
                                              l_ecb.ecb43,                 #FUN-A60092
                                            # l_ecb.ecb45,l_ecb.ecb46,     #FUN-A60092
                                            #  l_ecb.ecb45,                #FUN-A60092  #MOD-C30643 mark
                                              l_ecm.ecm58,                              #MOD-C30643 add
                                              'Y',g_user,g_grup,'','',
                                              g_plant,g_legal, g_user, g_grup,g_sho.sho012,
                                              l_ecm.ecm011,l_ecm.ecm62,l_ecm.ecm63,l_ecm.ecm64,l_ecm.ecm65,'Y','N'     #FUN-980008 add     #TQC-AC0374  #TQC-B80022 add 'Y'
                                             #No.FUN-980030 10/01/04  insert columns oriu, orig 
                                             #FUN-A60092 add g_sho.sho012                  
                                                 )    
                 IF STATUS THEN 
                      LET g_showmsg=g_item,"/",g_f09                                                       #NO.FUN-710026         
                      CALL s_errmsg('ecb01,ecb02',g_showmsg,'ins ecm:',STATUS,1)                           #NO.FUN-710026
                     LET g_success='N' 
                  END IF
 
                  LET l_ecm03=l_ecm03+g_sma.sma849
              END FOREACH
 
              IF g_totsuccess="N" THEN                                                                                                         
                 LET g_success="N"                                                                                                             
              END IF 
    END CASE
END FUNCTION
 
FUNCTION p312_b_fill()
 
    DECLARE ecm_cur CURSOR FOR
       SELECT ecm03,ecm04 FROM ecm_file 
        WHERE ecm01 = g_sho.sho04
          AND ecm012= g_sho.sho012    #FUN-A60092 add
        ORDER BY ecm03
 
    CALL g_ecm.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH ecm_cur INTO g_ecm[g_cnt].*
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ecm.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt - 1
   
    DISPLAY g_rec_b TO FORMONLY.cnt
 
END FUNCTION
 
FUNCTION p312_bp(p_ud)
DEFINE p_ud            LIKE type_file.chr1        
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
           IF g_rec_b != 0 THEN
           END IF
           ACCEPT DISPLAY                 
 
      ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
      ON ACTION about         
         CALL cl_about()      
       
      ON ACTION controlg      
         CALL cl_cmdask()     
         
      ON ACTION help          
         CALL cl_show_help()  
     
     END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p312_out()
   DEFINE sr       RECORD
                    sho01       LIKE sho_file.sho01, 
                    sho02       LIKE sho_file.sho02, 
                    sho04       LIKE sho_file.sho04, 
                    sho06       LIKE sho_file.sho06, 
                    sho07       LIKE sho_file.sho07, 
                    sho08       LIKE sho_file.sho08, 
                    sho09       LIKE sho_file.sho09, 
                    sho10       LIKE sho_file.sho10, 
                    sho11       LIKE sho_file.sho11, 
                    sho12       LIKE sho_file.sho12,
                    g_z07       LIKE sho_file.sho07, 
                    g_z08       LIKE sho_file.sho08, 
                    g_s07       LIKE sho_file.sho07, 
                    g_s08       LIKE sho_file.sho08, 
                    g_s09       LIKE sho_file.sho09, 
                    g_f07       LIKE sho_file.sho07, 
                    g_f08       LIKE sho_file.sho08, 
                    g_f09       LIKE sho_file.sho09,
                    sho012      LIKE sho_file.sho012   #FUN-A60092 add 
                   END RECORD,
          l_name   LIKE type_file.chr20        
 
    CALL cl_outnam(g_prog) RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    # 組合出 SQL 指令
    LET g_sql = "SELECT sho01,sho02,sho04,sho06,sho07,sho08,sho09,",
                "       sho10,sho11,sho12,'','','','','','','','',sho012 ",  #FUN-A60092 add sho012
                "  FROM sho_file ",
                " WHERE sho01 = '",g_sho.sho01,"'"
    PREPARE p312_pre FROM g_sql                   
    DECLARE p312_cur CURSOR FOR p312_pre
 
    START REPORT p312_rep TO l_name
 
    FOREACH p312_cur INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)  
          LET g_success = 'N'
          EXIT FOREACH
       END IF
 
       CASE sr.sho06 
            WHEN '1' LET sr.g_z07 = sr.sho07 
                     LET sr.g_z08 = sr.sho08
            WHEN '2' LET sr.g_s07 = sr.sho07 
                     LET sr.g_s08 = sr.sho08
                     LET sr.g_s09 = sr.sho09 
            WHEN '3' LET sr.g_f07 = sr.sho07 
                     LET sr.g_f08 = sr.sho08
                     LET sr.g_f09 = sr.sho09 
       END CASE
 
       OUTPUT TO REPORT p312_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p312_rep
 
    CLOSE p312_cur
    ERROR ""
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #NO.FUN-930105
 
END FUNCTION
 
REPORT p312_rep(sr)
   DEFINE sr       RECORD
                    sho01       LIKE sho_file.sho01, 
                    sho02       LIKE sho_file.sho02, 
                    sho04       LIKE sho_file.sho04, 
                    sho06       LIKE sho_file.sho06, 
                    sho07       LIKE sho_file.sho07, 
                    sho08       LIKE sho_file.sho08, 
                    sho09       LIKE sho_file.sho09, 
                    sho10       LIKE sho_file.sho10, 
                    sho11       LIKE sho_file.sho11, 
                    sho12       LIKE sho_file.sho12,
                    g_z07       LIKE sho_file.sho07, 
                    g_z08       LIKE sho_file.sho08, 
                    g_s07       LIKE sho_file.sho07, 
                    g_s08       LIKE sho_file.sho08, 
                    g_s09       LIKE sho_file.sho09, 
                    g_f07       LIKE sho_file.sho07, 
                    g_f08       LIKE sho_file.sho08, 
                    g_f09       LIKE sho_file.sho09,
                    sho012      LIKE sho_file.sho012   #FUN-A60092 add 
                   END RECORD,
          sr2      RECORD
                    ecm03       LIKE ecm_file.ecm03,
                    ecm04       LIKE ecm_file.ecm04
                   END RECORD,
          l_gae04               LIKE gae_file.gae04,
          l_msg                 STRING,
          l_gen02               LIKE gen_file.gen02,
          l_trailer_sw          LIKE type_file.chr1         
 
    OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sho01
 
    FORMAT
       PAGE HEADER
          PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
          LET g_pageno = g_pageno + 1
          LET pageno_total = PAGENO USING '<<<',"/pageno" 
          PRINT g_head CLIPPED,pageno_total     
          PRINT g_dash
          PRINT g_x[11] CLIPPED,sr.sho01 CLIPPED,5 SPACES,      #調整單號
                g_x[12] CLIPPED,sr.sho02                        #調整日期
          PRINT g_x[13] CLIPPED,sr.sho04 CLIPPED                #
          PRINT ' '
          CASE sr.sho06
              WHEN "1"
                 SELECT gae04 INTO l_gae04 FROM gae_file
                  WHERE gae01='asfp312' AND gae02='sho06_1' AND gae03=g_lang
              WHEN "2"
                 SELECT gae04 INTO l_gae04 FROM gae_file
                  WHERE gae01='asfp312' AND gae02='sho06_2' AND gae03=g_lang
              WHEN "3"
                 SELECT gae04 INTO l_gae04 FROM gae_file
                  WHERE gae01='asfp312' AND gae02='sho06_3' AND gae03=g_lang
          END CASE
          LET l_msg = sr.sho06 CLIPPED,':',l_gae04 CLIPPED
          PRINT g_x[14] CLIPPED,l_msg                           #調整項目
          PRINT g_x[15] CLIPPED,COLUMN 26,sr.g_z07 CLIPPED,
                                COLUMN 33,sr.g_z08       
          PRINT g_x[16] CLIPPED,COLUMN 26,sr.g_s07 CLIPPED,
                                COLUMN 33,sr.g_s08 CLIPPED,      
                                COLUMN 40,g_x[17] CLIPPED,sr.g_s09
          PRINT g_x[18] CLIPPED,COLUMN 26,sr.g_f07 CLIPPED,
                                COLUMN 33,sr.g_f08 CLIPPED,      
                                COLUMN 40,g_x[19] CLIPPED,sr.g_f09
          PRINT ' '
          PRINT g_x[20] CLIPPED,sr.sho12                        
          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.sho10
          IF STATUS THEN LET l_gen02 = ' ' END IF
          PRINT g_x[21] CLIPPED,sr.sho10 CLIPPED,1 SPACES,l_gen02
          PRINT g_x[22] CLIPPED,sr.sho11 CLIPPED
          PRINT ' '
          PRINT g_x[31],g_x[32]
          PRINT g_dash1 
          LET l_trailer_sw = 'y'
 
       ON EVERY ROW
          LET g_sql = "SELECT ecm03,ecm04 FROM ecm_file ",
                      " WHERE ecm01 = '",sr.sho04,"'",
                      "   AND ecm012= '",sr.sho012,"'"   #FUN-A60092 add
          PREPARE p312_pre2 FROM g_sql
          DECLARE p312_cur2 CURSOR FOR p312_pre2
          FOREACH p312_cur2 INTO sr2.*
             IF STATUS THEN EXIT FOREACH END IF
 
             #順序     作業編號 
             #-------- -------- 
             #ecm01xxx ecm04xxx
             PRINT COLUMN g_c[31],sr2.ecm03,
                   COLUMN g_c[32],sr2.ecm04
          END FOREACH
 
        ON LAST ROW
           LET l_trailer_sw = 'n'
            
        PAGE TRAILER
           PRINT g_dash
           IF l_trailer_sw = 'y' THEN
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
           ELSE
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
           END IF
END REPORT
