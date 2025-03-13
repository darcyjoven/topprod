# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aicp019.4gl
# Descriptions...: ICD料件光罩賬款拋轉應收賬款
# Date & Author..: FUN-7B0015 07/12/26 By lilingyu
# Modify.........: No.MOD-840442 08/04/21 By kim GP5.1顧問測試修改
# Modify.........: No.CHI-930012 09/03/05 By jan 程式無法處理"達累計數退款"的處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0014 09/12/07 By shiwuying s_g_ar加一個參數
# Modify.........: No:FUN-A10104 10/01/20 By shiwuying s_t300_gl
# Modify.........: No:TQC-A10141 10/01/21 By sherry 修改s_auto_assign_no的參數
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 s_g_ar多傳期別參數
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B90112 11/09/28 By zhangweib AFTER FIELD doc1 doc2 doc3 時重新給定帳款類別
# Modify.........: No.FUN-C80022 12/08/07 By xuxz s_g_ar添加了三個參數，故修改

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE l_flag          LIKE type_file.chr1,       
       g_apa01         LIKE apa_file.apa01,   
       g_apa02         LIKE apa_file.apa02,     
       g_apa           RECORD LIKE apa_file.*,     
       g_wc,g_sql      STRING, 
       g_change_lang   LIKE type_file.chr1,    
       g_ics           RECORD LIKE ics_file.* ,  
       doc1            LIKE oay_file.oayslip,    
       doc2            LIKE oay_file.oayslip,     
       doc3            LIKE oay_file.oayslip,     
       rdate           LIKE type_file.dat,
       g_oma00         LIKE oma_file.oma00     
DEFINE g_chr           LIKE type_file.chr1        
DEFINE g_cnt           LIKE type_file.num10      
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose   
DEFINE g_msg           LIKE type_file.chr1000   
DEFINE g_before_input_done  LIKE type_file.num5  
DEFINE p_cmd           LIKE type_file.chr1  
DEFINE g_flag          LIKE type_file.chr1      
 
MAIN
   DEFINE ls_date       STRING  
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_wc           = ARG_VAL(1)       #QBE
   LET doc1           = ARG_VAL(2)       #帳款單別
   LET doc2           = ARG_VAL(3)       #帳款單別
   LET doc3           = ARG_VAL(4)       #帳款單別
   LET ls_date        = ARG_VAL(5)
   LET g_apa.apa02    = cl_batch_bg_date_convert(ls_date)   #帳款日期
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   #NO.FUN-7B0015  --Begin--
   IF NOT s_industry("icd") THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
         CALL p019()
         
         IF cl_sure(18,20) THEN                     #是否確定要執行
            LET g_success = 'Y'
            
            BEGIN WORK
            CALL p019_process()
            CALL s_showmsg()                 
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag     #顯示執行結果，并詢問是否繼續
            ELSE                                    #1.代表成功    2.代表失敗
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p019_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
   END WHILE
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p019()
   DEFINE li_result LIKE type_file.num5     
   DEFINE lc_cmd    LIKE type_file.chr1000
   DEFINE l_ooyacti LIKE ooy_file.ooyacti  
 
   WHILE TRUE
      LET g_action_choice = ""
 
      OPEN WINDOW p019_w WITH FORM "aic/42f/aicp019"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      
      CLEAR FORM
 
      CONSTRUCT BY NAME g_wc ON ima01
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
      
         ON ACTION locale
            LET g_change_lang = TRUE      
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
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
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)        #光罩料號
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state = "c"
               #  #LET g_qryparam.form ="q_ima"
               #   LET g_qryparam.form ="q_imaicd" #MOD-840442
               #   LET g_qryparam.where =" imaicd05='3'"  #MOD-840442
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_imaicd","imaicd05='3'","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01                 
            END CASE                  
                             
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()  
         CONTINUE WHILE    
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p019_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
   
      INITIALIZE g_ics.* TO NULL       
      INITIALIZE g_apa.* TO NULL
#     INITIALIZE g_apb.* TO NULL
  
      LET g_apa01  = NULL    
      LET rdate =g_today 
#     LET g_apa.apa02 = g_today    
#     DISPLAY g_apa.apa02 TO FORMONLY.rdate   
         
      INPUT BY NAME doc1,doc2,doc3,rdate
                 WITHOUT DEFAULTS     
                 
      BEFORE INPUT 
        LET g_apa.apa02 = g_today    
        DISPLAY g_apa.apa02 TO FORMONLY.rdate   
      
      AFTER FIELD doc1
        IF NOT cl_null(doc1) THEN
           LET l_ooyacti = NULL
          SELECT ooyacti INTO l_ooyacti FROM ooy_file
           WHERE ooyslip = doc1
          IF l_ooyacti <> 'Y' THEN
             CALL cl_err(doc1,'aic-061',1)
             NEXT FIELD doc1
          END IF        
#         CALL s_check_no("aic",doc1,"","","","","")
         #CALL s_check_no("axr",doc1,"",g_oma00,"","","")    #FUN-B90112   Mark
          CALL s_check_no("axr",doc1,"",'22',"","","")       #FUN-B90112   Add   
            RETURNING li_result,doc1
          IF (NOT li_result) THEN
            LET g_success='N'
            NEXT FIELD doc1
          END IF
          DISPLAY BY NAME doc1
        END IF
       
      AFTER FIELD doc2
         IF NOT cl_null(doc2) THEN
          LET l_ooyacti = NULL
          SELECT ooyacti INTO l_ooyacti FROM ooy_file
           WHERE ooyslip = doc2
            IF l_ooyacti <> 'Y' THEN
              CALL cl_err(doc2,'aic-061',1)
              NEXT FIELD doc2
            END IF        
#           CALL s_check_no("aic",doc2,"","","","","")
           #CALL s_check_no("axr",doc2,"",g_oma00,"","","")   #FUN-B90112   Mark
            CALL s_check_no("axr",doc2,"",'21',"","","")      #FUN-B90112   Add
              RETURNING li_result,doc2
           IF (NOT li_result) THEN
              LET g_success='N'
              NEXT FIELD doc2
          END IF
          DISPLAY BY NAME doc2
         END IF
       
       AFTER FIELD doc3
       IF NOT cl_null(doc3) THEN
          LET l_ooyacti = NULL
          SELECT ooyacti INTO l_ooyacti FROM ooy_file
           WHERE ooyslip = doc3
          IF l_ooyacti <> 'Y' THEN
             CALL cl_err(doc3,'aic-061',1)
             NEXT FIELD doc3
          END IF        
#         CALL s_check_no("aic",doc3,"","","","","")
         #CALL s_check_no("axr",doc3,"",g_oma00,"","","")   #FUN-B90112   Mark
          CALL s_check_no("axr",doc3,"",'14',"","","")      #FUN-B90112   Add
           RETURNING li_result,doc3
          IF (NOT li_result) THEN
            LET g_success='N'
            NEXT FIELD doc3
          END IF
          DISPLAY BY NAME doc3
       END IF
       
       AFTER FIELD rdate
         IF (rdate<g_sma.sma53) THEN
             CALL cl_err(rdate,'aic-062',1)         
             NEXT FIELD rdate
         ELSE
       	    DISPLAY rdate TO FORMONLY.rdate 
#           NEXT FIELD rdate 
         END IF    
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG 
            CALL cl_cmdask()
      
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(doc1) 
                 #CALL q_ooy(FALSE,FALSE,doc1,g_oma00,'AXR') RETURNING doc1   #FUN-B90112   Mark
                  CALL q_ooy(FALSE,FALSE,doc1,'22','AXR') RETURNING doc1      #FUN-B90112   Add 
                  DISPLAY BY NAME doc1
               
              WHEN INFIELD(doc2) 
                 #CALL q_ooy(FALSE,FALSE,doc2,g_oma00,'AXR') RETURNING doc2   #FUN-B90112   Mark
                  CALL q_ooy(FALSE,FALSE,doc2,'21','AXR') RETURNING doc2      #FUN-B90112   Add 
                  DISPLAY BY NAME doc2
               
              WHEN INFIELD(doc3) 
                 #CALL q_ooy(FALSE,FALSE,doc3,g_oma00,'AXR') RETURNING doc3   #FUN-B90112   Mark
                  CALL q_ooy(FALSE,FALSE,doc3,'14','AXR') RETURNING doc3      #FUN-B90112   Add 
                  DISPLAY BY NAME doc3  
                             
            END CASE
      
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about   
            CALL cl_about()   
       
         ON ACTION help      
            CALL cl_show_help() 
       
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
         LET INT_FLAG = 0
         CLOSE WINDOW p019_w        
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
      END IF
    EXIT WHILE
 END WHILE
END FUNCTION
 
FUNCTION p019_process() 
   DEFINE li_result LIKE type_file.num5 
   DEFINE l_oma01   LIKE oma_file.oma01
   DEFINE l_apa01   LIKE apa_file.apa01  
    
#  p019_cs: SELECT ics.* FROM ics_file,ima_file where icspost='N' and ics00=ima01 and ima01 in QBE order by ics19,ics00
   LET g_sql = "SELECT ics_file.* FROM ics_file,ima_file",
               " WHERE icspost='N' AND ics00=ima01",
               "   AND ",g_wc CLIPPED,
               " order by ics19,ics00"
  #DISPLAY 'g_sql:',g_sql   #CHI-A70049 mark
 
   PREPARE p019_prepare FROM g_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
      LET g_success = 'N'
      RETURN 
   END IF
 
   DECLARE p019_cs CURSOR WITH HOLD FOR p019_prepare
 
#  LET g_apa.apa01 = NULL
   
   FOREACH p019_cs INTO g_ics.*
   IF STATUS THEN
     CALL s_errmsg('','',"p019_cs FOREACH:",SQLCA.sqlcode,1)
     LET g_success = 'N'
     EXIT FOREACH
   END IF
   
   IF g_success='N' THEN EXIT FOREACH END IF
     CASE g_ics.ics16
         WHEN "1"  #1.預收款 , 達累計數退款
         #IF NOT cl_null(g_ics.ics17) THEN CONTINUE FOREACH END IF  #CHI-930012 
          IF cl_null(g_ics.ics17) THEN                          #CHI-930012 
            #預收款
     #       CALL p019_ins_oma_310(g_ics.*,tm.doc1,22) RETURNING li_result,l_oma01
             CALL p019_ins_oma_310(g_ics.*,doc1,22) RETURNING li_result,l_oma01
 
            IF li_result THEN
               LET g_ics.ics17=l_apa01
               
               UPDATE ics_file set ics17=g_ics.ics17 WHERE ics00=g_ics.ics00
               IF SQLCA.sqlerrd[3]=0 THEN
                  LET g_success='N'
                  CALL cl_err3("upd","ics_file",g_ics.ics00,"",9050,"","",1)
               END IF
            ELSE
               LET g_success='N'
            END IF
          END IF                                                   #CHI-930012
 
            #達累計數退款
            IF (NOT cl_null(g_ics.ics17)) AND 
               ((NOT cl_null(g_ics.ics19)) AND (g_ics.ics19<g_today)) THEN
               IF g_ics.ics15 >= g_ics.ics13 THEN  #累計下單數量>=預計下單數量
#                CALL p019_ins_oma_304(g_ics.*,tm.doc2,21) RETURNING li_result,l_oma01
                 CALL p019_ins_oma_304(g_ics.*,doc2,21) RETURNING li_result,l_oma01
                  IF li_result THEN
                     UPDATE ics_file set icspost='Y' WHERE ics00=g_ics.ics00
               
                     IF SQLCA.sqlerrd[3]=0 THEN
                        LET g_success='N'
                        CALL cl_err3("upd","ics_file",g_ics.ics00,"",9050,"","",1)
                     END IF
                  ELSE
                     #更新失敗,本筆掠過處理
                     LET g_success='N'
                  END IF
               ELSE  #下單量太少,不退錢,單子結案!
                  UPDATE ics_file set icspost='Y' WHERE ics00=g_ics.ics00
                  IF SQLCA.sqlerrd[3]=0 THEN
                     LET g_success='N'
                     CALL cl_err3("upd","ics_file",g_ics.ics00,"",9050,"","",1)
                  END IF
               END IF
            END IF
         WHEN "2"  #2.在期限內 , 未達累計數收款
            IF cl_null(g_ics.ics19) OR (g_ics.ics19>g_today) THEN CONTINUE FOREACH END IF
            IF cl_null(g_ics.ics13) THEN CONTINUE FOREACH END IF
            IF cl_null(g_ics.ics15) THEN LET g_ics.ics15=0 END IF
            IF g_ics.ics15 >= g_ics.ics13 THEN  #累計下單數量>=預計下單數量
               UPDATE ics_file set icspost='Y' WHERE ics00=g_ics.ics00
              
               IF SQLCA.sqlerrd[3]=0 THEN
                  LET g_success='N'
                  CALL cl_err3("upd","ics_file",g_ics.ics00,"",9050,"","",1)
               END IF
            ELSE  #下單量太少,得付錢,單子結案!
#              CALL p019_ins_oma_310(g_ics.*,tm.doc3,14) RETURNING li_result,l_oma01
               CALL p019_ins_oma_310(g_ics.*,doc3,14) RETURNING li_result,l_oma01
               IF li_result THEN
                  UPDATE ics_file set icspost='Y' WHERE ics00=g_ics.ics00
                  IF SQLCA.sqlerrd[3]=0 THEN
                     LET g_success='N'
                     CALL cl_err3("upd","ics_file",g_ics.ics00,"",9050,"","",1)
                  END IF
               ELSE
                  #更新失敗,本筆掠過處理
                  LET g_success='N'
               END IF
            END IF
      END CASE
   END FOREACH
END FUNCTION
 
#RETURN li_result(TRUE更新成功/FALSE失敗) , l_oma01 (產生的應收單號)
#待抵/應收
FUNCTION p019_ins_oma_310(l_ics,l_slip,l_oma00)  #參考axrp310而來
    DEFINE l_ics         RECORD LIKE ics_file.*
    DEFINE l_oma00              LIKE oma_file.oma00
    DEFINE l_slip               LIKE type_file.chr5
    DEFINE l_oma01              LIKE oma_file.oma01
    DEFINE l_start,l_end        LIKE type_file.dat
    DEFINE l_mask               LIKE type_file.chr18
    DEFINE li_result            LIKE type_file.num5
 
#   CALL s_auto_assign_no("axr",l_slip,tm.rdate,l_oma00,"","","","","")
    #CALL s_auto_assign_no("aic",l_slip,rdate,l_oma00,"","","","","")   #TQC-A10141
    CALL s_auto_assign_no("axr",l_slip,rdate,l_oma00,"","","","","")   #TQC-A10141
       RETURNING li_result,l_oma01
       
   IF (NOT li_result) THEN
        LET g_success = 'N'
        RETURN FALSE,NULL
   END IF
 
   LET l_mask='MASK-',g_today
#  CALL s_g_ar(l_mask,'12',g_today,g_today,'1',l_oma01,'',g_plant)    #No.FUN-9C0014
   CALL s_g_ar(l_mask,0,'12',g_today,g_today,'1',l_oma01,'',g_plant,'','','','') #No.FUN-9C0014    #No:FUN-A50103#FUN-C80022 add ,'','',''
         RETURNING l_start,l_end
 
   IF g_ooy.ooydmy1='Y' THEN    #依單別判斷是否產生分錄
      CALL s_t300_gl(l_oma01,'0')       #No.FUN-9C0014 #No.FUN-A10104
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #使用多帳套功能
         CALL s_t300_gl(l_oma01,'1')    #No.FUN-9C0014 #No.FUN-A10104
      END IF
   END IF
END FUNCTION
 
#RETURN li_result(TRUE更新成功/FALSE失敗) , l_oma01 (產生的應收單號)
#待抵折讓
FUNCTION p019_ins_oma_304(l_ics,l_slip,l_oma00)  #參考axrp304而來
   DEFINE l_ics       RECORD LIKE ics_file.*
   DEFINE l_oma00            LIKE oma_file.oma00
   DEFINE l_slip             LIKE type_file.chr5
   DEFINE l_oma01            LIKE oma_file.oma01
   DEFINE l_mask             LIKE type_file.chr18
   DEFINE l_start,l_end      LIKE type_file.dat
   DEFINE li_result          LIKE type_file.num5
 
#  CALL s_auto_assign_no("axr",l_slip,tm.rdate,l_oma00,"oma_file","oma01","","","")
   #CALL s_auto_assign_no("aic",l_slip,rdate,l_oma00,"oma_file","oma01","","","")    #TQC-A10141
   CALL s_auto_assign_no("axr",l_slip,rdate,l_oma00,"oma_file","oma01","","","")   #TQC-A10141
        RETURNING li_result,l_oma01
         
   IF (NOT li_result) THEN
        LET g_success = 'N'
        RETURN FALSE,NULL
   END IF
   
   LET l_mask='MASK-',g_today
#  CALL s_g_ar(l_mask,l_oma00,g_today,g_today,'',l_oma01,g_ooz.ooz08,g_plant)   #No.FUN-9C0014
   CALL s_g_ar(l_mask,0,l_oma00,g_today,g_today,'',l_oma01,g_ooz.ooz08,g_plant,'','','','')#No.FUN-9C0014    #No:FUN-A50103#FUN-C80022 add ,'','',''
        RETURNING l_start,l_end
        
   IF g_ooy.ooydmy1='Y' THEN    #依單別判斷是否產生分錄
      CALL s_t300_gl(l_oma01,'0')       #No.FUN-9C0014 #No.FUN-A10104
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_t300_gl(l_oma01,'1')    #No.FUN-9C0014 #No.FUN-A10104
      END IF
   END IF
END FUNCTION
