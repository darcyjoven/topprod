# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: ggls101.4gl
# Descriptions...: 合併報表系統參數設定作業
# Date & Author..: NO.FUN-920021 98/02/03 By jamie 從agls103頁籤中獨立成一支程式
# Modify.........: NO.FUN-920094 09/05/20 By jan 
#                                         1.合併帳別aaz01改為require,not null
#                                         2.會科aaz02,aaz04,aaz07,aaz08,aaz13,aaz14 開窗時以目前DB+asz01 開窗合併後會科資料
#                                         3.上述會科AFTER FIELD 時檢核羅輯亦同第2點 
# Modify.........: No.FUN-950060 09/05/22 By lutingting增加欄位aaz10,aaz12
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-990020 10/08/19 by Yiting add aaz05,aaz06
# Modify.........: No.FUN-A70105 10/08/19 BY yiting add aaz03再衡量兌換損失科目
# Modify.........: No.FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No.FUN-B40104 11/05/09 By lutingting aaz_file-->asz_file
# Modify.........: No.MOD-B60229 11/06/27 By Sarah CALL q_m_aag2()的第三個參數應該傳g_plant_asg03
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

DATABASE ds   #FUN-BB0036
 

GLOBALS "../../config/top.global"
    DEFINE
        g_asz_t         RECORD LIKE asz_file.*,    # 預留參數檔
        g_asz_o         RECORD LIKE asz_file.*,    # 預留參數檔
        l_aaa           RECORD LIKE aaa_file.*     # 預留參數檔
DEFINE p_row,p_col      LIKE type_file.num5                                                                                                   
DEFINE g_forupd_sql     STRING                                                   
DEFINE g_msg            LIKE type_file.chr1000                                                    
DEFINE g_dbs_asg03      LIKE asg_file.asg03        #FUN-920094 add                                                    
DEFINE g_plant_asg03    LIKE asg_file.asg03        #FUN-980025 add                                                    
DEFINE g_asz            RECORD LIKE asz_file.*     #FUN-B40104
#FUN-920021 add
MAIN
   DEFINE
      p_row,p_col LIKE type_file.num5          #No.FUN-680098  SMALLINT
 
   OPTIONS 
      INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET p_row = 4 LET p_col = 8
   OPEN WINDOW s101_w AT p_row,p_col
     WITH FORM "ggl/42f/ggls101"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   IF g_aza.aza26 = '2' THEN                                                    
      CALL cl_getmsg('agl-350',g_lang) RETURNING g_msg                          
      CALL cl_set_comp_att_text("aaz31",g_msg CLIPPED)                          
      CALL cl_getmsg('agl-351',g_lang) RETURNING g_msg                          
      CALL cl_set_comp_att_text("aaz32",g_msg CLIPPED)                          
      CALL cl_getmsg('agl-352',g_lang) RETURNING g_msg                          
      CALL cl_set_comp_att_text("aaz33",g_msg CLIPPED)                          
   END IF                                                                       
   CALL s101_show()
 
   LET g_action_choice=""
   CALL s101_menu()
 
   CLOSE WINDOW s101_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN    
 
FUNCTION s101_show()
 
   SELECT * INTO g_asz.* FROM asz_file WHERE asz00 = '0'
 
   IF SQLCA.sqlcode THEN
      INSERT INTO asz_file(
                           asz00,asz02,asz04,asz07,asz08,asz13,
                           asz14,asz01,asz09,asz11,asz10,asz12,  #FUN-950060 add asz10,asz12  
                           asz05,asz06,asz03    #FUN-990020  #FUN-A70105 add asz03
                           )
           VALUES (
                   '0',g_asz.asz02,g_asz.asz04,                  
                   g_asz.asz07,g_asz.asz08,g_asz.asz13,g_asz.asz14,
                   g_asz.asz01,g_asz.asz09,g_asz.asz11,g_asz.asz10,g_asz.asz12,  #FUN-950060 add asz10,asz12
                   g_asz.asz05,g_asz.asz06,   #FUN-990020
                   g_asz.asz03)                #FUN-A70105
   ELSE
      UPDATE asz_file SET asz02 = g_asz.asz02,            
                          asz04 = g_asz.asz04,            
                          asz07= g_asz.asz07,            
                          asz08= g_asz.asz08,            
                          asz13= g_asz.asz13,            
                          asz14= g_asz.asz14,             
                          asz01= g_asz.asz01,
                          asz09 = g_asz.asz09,
                          asz11 = g_asz.asz11,
                          asz10 = g_asz.asz10,   #FUN-950060 add
                          asz12 = g_asz.asz12,   #FUN-950060 add  
                          asz05 = g_asz.asz05,   #FUN-990020 add
                          asz06 = g_asz.asz06,   #FUN-990020 add
                          asz03 = g_asz.asz03    #FUN-A70105
       WHERE asz00 = '0'
   END IF
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
 
   DISPLAY BY NAME g_asz.asz02,g_asz.asz04,              
                   g_asz.asz07,g_asz.asz08,g_asz.asz13,g_asz.asz14,
                   g_asz.asz01,g_asz.asz09,g_asz.asz11,g_asz.asz10,g_asz.asz12,    #FUN-950060 add asz10,asz12  
                   g_asz.asz05,g_asz.asz06,   #FUN-990020
                   g_asz.asz03                 #FUN-A70105
    CALL cl_show_fld_cont()               
END FUNCTION
 
FUNCTION s101_menu()
 
   MENU ""
   ON ACTION modify 
      LET g_action_choice = "modify"
      IF cl_chk_act_auth() THEN
         CALL s101_u()
      END IF
   ON ACTION help
      CALL cl_show_help()
 
   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()            
 
   ON ACTION exit
      LET g_action_choice = "exit"
      EXIT MENU
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
 
   ON ACTION about                    
      CALL cl_about()                 
 
   ON ACTION controlg                 
      CALL cl_cmdask()                
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION s101_u()
 
   CALL cl_opmsg('u')
   MESSAGE ""
 
   LET g_forupd_sql = "SELECT * FROM asz_file WHERE asz00 = '0' FOR UPDATE"    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE asz_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN asz_curl 
   IF STATUS THEN
      CALL cl_err('OPEN asz_curl',STATUS,1)
      RETURN
   END IF         
 
   FETCH asz_curl INTO g_asz.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   LET g_asz_t.* = g_asz.*
   LET g_asz_o.* = g_asz.*
 
   DISPLAY BY NAME g_asz.asz02,g_asz.asz04,   
                   g_asz.asz07,g_asz.asz08,g_asz.asz13,g_asz.asz14,               #FUN-890071
                   g_asz.asz01,g_asz.asz09,g_asz.asz11,
                   g_asz.asz10,g_asz.asz12,     #FUN-950060 add 
                   g_asz.asz05,g_asz.asz06,      #FUN-990020
                   g_asz.asz03                   #FUN-A70105
   WHILE TRUE
      CALL s101_i()
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_asz.* = g_asz_t.*
         CALL s101_show()
         EXIT WHILE
      END IF
 
      UPDATE asz_file SET 
                          asz02 = g_asz.asz02,             
                          asz04 = g_asz.asz04,             
                          asz07= g_asz.asz07,            
                          asz08= g_asz.asz08,            
                          asz13= g_asz.asz13,            
                          asz14= g_asz.asz14,            
                          asz01= g_asz.asz01,
                          asz09 = g_asz.asz09,
                          asz11 = g_asz.asz11,
                          asz10 = g_asz.asz10,    #FUN-950060 add
                          asz12 = g_asz.asz12,     #FUN-950060 add
                          asz05 = g_asz.asz05,     #FUN-990020
                          asz06 = g_asz.asz06,      #FUN-990020
                          asz03 = g_asz.asz03      #FUN-A70105
       WHERE asz00='0'
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","asz_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660123
         CONTINUE WHILE
      END IF
 
      CLOSE asz_curl
      COMMIT WORK
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION s101_i()
   DEFINE l_aza LIKE type_file.chr1,                                
          l_cmd LIKE type_file.chr50                                 
   DEFINE li_chk_bookno  LIKE type_file.num5                                                 
 
     LET g_plant_new = g_plant      #營運中心
     LET g_plant_asg03 = g_plant    #營運中心  #No.FUN-980025 add
     CALL s_getdbs()
     LET g_dbs_asg03 = g_dbs_new    #所屬DB
 
   #INPUT BY NAME g_asz.asz01,g_asz.asz02,g_asz.asz04,                                                    
   INPUT BY NAME g_asz.asz01,g_asz.asz02,g_asz.asz03,g_asz.asz04,    #FUN-A70105 add asz03                                                 
                 g_asz.asz05,g_asz.asz06,             #FUN-990020
                 g_asz.asz07,g_asz.asz08,g_asz.asz09,g_asz.asz10,  #FUN-950060 add asz10
                 g_asz.asz11,g_asz.asz12,   #FUN-950060 add asz12
                 g_asz.asz13,g_asz.asz14 
      WITHOUT DEFAULTS 
 
 
      AFTER FIELD asz01
         IF NOT cl_null(g_asz.asz01) THEN
            CALL s_check_bookno(g_asz.asz01,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
                 NEXT FIELD asz01 
            END IF 
            SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_asz.asz01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",g_asz.asz01,"","agl-043","","",0)   #No.FUN-660123
               NEXT FIELD asz01
            END IF
        #FUN-920094---mod--str---
         ELSE 
            CALL cl_err('','mfg0037',0)
            NEXT FIELD asz01
        #FUN-920094---mod--end---
         END IF 
 
      AFTER FIELD asz02
         IF NOT cl_null(g_asz.asz02) THEN 
           #CALL s101_aaz31(g_asz.asz02,g_aza.aza81)   #FUN-920094 mark #No.FUN-7300070
            CALL s101_aaz31(g_asz.asz02,g_asz.asz01)  #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz02,'23',g_asz.asz01)  
                    RETURNING g_asz.asz02                 
               #FUN-B20004--end               
               NEXT FIELD asz02
            END IF
         END IF
 
#----FUN-A70105 start--
      AFTER FIELD asz03
         IF NOT cl_null(g_asz.asz03) THEN 
            CALL s101_aaz31(g_asz.asz03,g_asz.asz01)
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz03,'23',g_asz.asz01)  
                    RETURNING g_asz.asz03                 
               #FUN-B20004--end                             
               NEXT FIELD asz03
            END IF
         END IF
#----FUN-A70105 end----

      AFTER FIELD asz04
         IF NOT cl_null(g_asz.asz04) THEN 
           #CALL s101_aaz31(g_asz.asz04,g_aza.aza81)   #FUN-920094 mark 
            CALL s101_aaz31(g_asz.asz04,g_asz.asz01)  #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz04,'23',g_asz.asz01)  
                    RETURNING g_asz.asz04                 
               #FUN-B20004--end                             
               NEXT FIELD asz04
            END IF
         END IF
 
      AFTER FIELD asz07
         IF NOT cl_null(g_asz.asz07) THEN 
           #CALL s101_aaz31(g_asz.asz07,g_aza.aza81)   #FUN-920094 mark
            CALL s101_aaz31(g_asz.asz07,g_asz.asz01)  #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz07,'23',g_asz.asz01)  
                    RETURNING g_asz.asz07                 
               #FUN-B20004--end                     
               NEXT FIELD asz07
            END IF
         END IF
      
      AFTER FIELD asz08
         IF NOT cl_null(g_asz.asz08) THEN 
           #CALL s101_aaz31(g_asz.asz08,g_aza.aza81)   #FUN-920094 mark
            CALL s101_aaz31(g_asz.asz08,g_asz.asz01)  #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz08,'23',g_asz.asz01)  
                    RETURNING g_asz.asz08                 
               #FUN-B20004--end                     
               NEXT FIELD asz08
            END IF
         END IF
 
      AFTER FIELD asz13
         IF NOT cl_null(g_asz.asz13) THEN 
           #CALL s101_aaz31(g_asz.asz13,g_aza.aza81)    #FUN-920094 mark
            CALL s101_aaz31(g_asz.asz13,g_asz.asz01)   #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz13,'23',g_asz.asz01)  
                    RETURNING g_asz.asz13                 
               #FUN-B20004--end                   
               NEXT FIELD asz13
            END IF
         END IF
 
      AFTER FIELD asz14
         IF NOT cl_null(g_asz.asz14) THEN 
           #CALL s101_aaz31(g_asz.asz14,g_aza.aza81)    #FUN-920094 mark
            CALL s101_aaz31(g_asz.asz14,g_asz.asz01)   #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz14,'23',g_asz.asz01)  
                    RETURNING g_asz.asz14               
               #FUN-B20004--end                   
               NEXT FIELD asz14
            END IF
         END IF
 
      AFTER FIELD asz09                                                                                                           
         IF NOT cl_null(g_asz.asz09) THEN                                                                                         
            CALL s101_aaz31(g_asz.asz09,g_asz.asz01)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                  
               CALL cl_err('',g_errno,0)    
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz09,'23',g_asz.asz01)  
                    RETURNING g_asz.asz09                 
               #FUN-B20004--end                                                                                                          
               NEXT FIELD asz09                                                                                                   
            END IF                                                                                                                 
         END IF                                                                                                                    
                                                                                                                                   
      AFTER FIELD asz11                                                                                                           
         IF NOT cl_null(g_asz.asz11) THEN                                                                                         
            CALL s101_aaz31(g_asz.asz11,g_asz.asz01)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                  
               CALL cl_err('',g_errno,0)    
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz11,'23',g_asz.asz01)  
                    RETURNING g_asz.asz11                 
               #FUN-B20004--end                                                                                                          
               NEXT FIELD asz11                                                                                                   
            END IF                                                                                                                 
         END IF    
 
      #FUN-950060--add--start--
      AFTER FIELD asz10                                                                                                            
         IF NOT cl_null(g_asz.asz10) THEN                                                                                          
            CALL s101_aaz31(g_asz.asz10,g_asz.asz01)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                   
               CALL cl_err('',g_errno,0)     
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz10,'23',g_asz.asz01)  
                    RETURNING g_asz.asz10                 
               #FUN-B20004--end                                                                                                              
               NEXT FIELD asz10                                                                                                    
            END IF                                                                                                                  
         END IF
 
      AFTER FIELD asz12                                                                                                            
         IF NOT cl_null(g_asz.asz12) THEN                                                                                          
            CALL s101_aaz31(g_asz.asz12,g_asz.asz01)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                   
               CALL cl_err('',g_errno,0)    
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz12,'23',g_asz.asz01)  
                    RETURNING g_asz.asz12                 
               #FUN-B20004--end                                                                                                               
               NEXT FIELD asz12                                                                                                    
            END IF                                                                                                                  
         END IF
      #FUN-950060--add--end
 
 
#--FUN-A70105 start--
      AFTER FIELD asz05
         IF NOT cl_null(g_asz.asz05) THEN 
            CALL s101_aaz31(g_asz.asz05,g_asz.asz01)
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz05,'23',g_asz.asz01)  
                    RETURNING g_asz.asz05                 
               #FUN-B20004--end                       
               NEXT FIELD asz05
            END IF
         END IF

      AFTER FIELD asz06
         IF NOT cl_null(g_asz.asz06) THEN 
            CALL s101_aaz31(g_asz.asz06,g_asz.asz01)
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--beatk
               CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asz.asz06,'23',g_asz.asz01)  
                    RETURNING g_asz.asz06                
               #FUN-B20004--end                       
               NEXT FIELD asz06
            END IF
         END IF
#--FUN-A70105 end------

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION mntn_acc_code
          CALL cl_cmdrun('agli102' CLIPPED) 
 
      ON ACTION mntn_doc_type
          CALL cl_cmdrun('agli108 ' CLIPPED) 
     
      ON ACTION controlp                                                          
         CASE                                                                     
            WHEN INFIELD(asz01)   #合併報表帳別
               CALL cl_init_qry_var()                                             
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_asz.asz01
               CALL cl_create_qry() RETURNING g_asz.asz01
               DISPLAY BY NAME g_asz.asz01
               NEXT FIELD asz01
            WHEN INFIELD(asz02)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_asz.asz02                              
              #LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
              #CALL cl_create_qry() RETURNING g_asz.asz02                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz02,'23',g_asz.asz01)    #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz02,'23',g_asz.asz01)  #No.FUN-980025 
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz02=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_asz.asz02                                        
               NEXT FIELD asz02                                                   
            WHEN INFIELD(asz04)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_asz.asz04                              
              #LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
              #CALL cl_create_qry() RETURNING g_asz.asz04                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz04,'23',g_asz.asz01)   #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz04,'23',g_asz.asz01) #No.FUN-980025  
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz04=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_asz.asz04                                        
               NEXT FIELD asz04   
            WHEN INFIELD(asz07)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_asz.asz07                              
              #LET g_qryparam.arg1 = g_aza.aza81
              #CALL cl_create_qry() RETURNING g_asz.asz07                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz07,'23',g_asz.asz01)    #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz07,'23',g_asz.asz01)  #No.FUN-980025 
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz07=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_asz.asz07                                        
               NEXT FIELD asz07                                                   
#----FUN-A70105 start---------
            WHEN INFIELD(asz03)                                                   
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz03,'23',g_asz.asz01)    #MOD-B60229 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz03,'23',g_asz.asz01)  #MOD-B60229
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz03=g_qryparam.multiret                                      
               DISPLAY BY NAME g_asz.asz03                                        
               NEXT FIELD asz03                                                   
#----FUN-A70105 end-----------
            WHEN INFIELD(asz08)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_asz.asz08                              
              #LET g_qryparam.arg1 = g_aza.aza81
              #CALL cl_create_qry() RETURNING g_asz.asz08                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz08,'23',g_asz.asz01)    #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz08,'23',g_asz.asz01)  #No.FUN-980025 
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz08=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_asz.asz08                                        
               NEXT FIELD asz08                                                   
            WHEN INFIELD(asz13)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_asz.asz13                              
              #LET g_qryparam.arg1 = g_aza.aza81
              #CALL cl_create_qry() RETURNING g_asz.asz13                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz13,'23',g_asz.asz01)    #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz13,'23',g_asz.asz01)  #No.FUN-980025
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz13=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_asz.asz13                                        
               NEXT FIELD asz13                                                   
            WHEN INFIELD(asz14)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_asz.asz14                              
              #LET g_qryparam.arg1 = g_aza.aza81
              #CALL cl_create_qry() RETURNING g_asz.asz14                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz14,'23',g_asz.asz01)     #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz14,'23',g_asz.asz01)   #No.FUN-980025 
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz14=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_asz.asz14                                        
               NEXT FIELD asz14        
            WHEN INFIELD(asz09) 
               #FUN-950060---mod--str--                                                                                                   
               #CALL cl_init_qry_var()                                                                                               
               #LET g_qryparam.form ="q_aag"                                                                                         
               #LET g_qryparam.default1 = g_asz.asz09                                                                               
               #LET g_qryparam.arg1 = g_aza.aza81                                                                                    
               #CALL cl_create_qry() RETURNING g_asz.asz09     
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz09,'23',g_asz.asz01)     #No.FUN-980025 mark                                            
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz09,'23',g_asz.asz01)   #No.FUN-980025                                              
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_asz.asz09=g_qryparam.multiret 
               #FUN-950060---mod--end--                                                                     
               DISPLAY BY NAME g_asz.asz09                                                                                         
               NEXT FIELD asz09                                                                                                    
            WHEN INFIELD(asz11)                        
               #FUN-950060---mod--str
               #CALL cl_init_qry_var()                                                                                               
               #LET g_qryparam.form ="q_aag"                                                                                         
               #LET g_qryparam.default1 = g_asz.asz11                                                                               
               #LET g_qryparam.arg1 = g_aza.aza81                                                                                    
               #CALL cl_create_qry() RETURNING g_asz.asz11      
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz11,'23',g_asz.asz01)    #No.FUN-980025 mark                                             
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz11,'23',g_asz.asz01)  #No.FUN-980025                                                
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_asz.asz11=g_qryparam.multiret                                                                                 
               #FUN-950060---mod--end--                                                                    
               DISPLAY BY NAME g_asz.asz11                                                                                         
               NEXT FIELD asz11                               
            #FUN-950060---add--start--
            WHEN INFIELD(asz10)                                                                                                    
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz10,'23',g_asz.asz01)    #No.FUN-980025 mark                                             
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz10,'23',g_asz.asz01)  #No.FUN-980025                                                
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_asz.asz10=g_qryparam.multiret                                                                                 
               DISPLAY BY NAME g_asz.asz10                                                                                         
               NEXT FIELD asz10
            WHEN INFIELD(asz12)                                                                                                    
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz12,'23',g_asz.asz01)    #No.FUN-980025 mark                                             
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz12,'23',g_asz.asz01)  #No.FUN-980025                                                 
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_asz.asz12=g_qryparam.multiret                                                                                 
               DISPLAY BY NAME g_asz.asz12                                                                                         
               NEXT FIELD asz12 
            #FUN-950060---add--end              
#----FUN-990020 start---------
            WHEN INFIELD(asz05)                                                   
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz05,'23',g_asz.asz01)    #MOD-B60229 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz05,'23',g_asz.asz01)  #MOD-B60229
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz05=g_qryparam.multiret                                      
               DISPLAY BY NAME g_asz.asz05                                        
               NEXT FIELD asz05                                                   
            WHEN INFIELD(asz06)                                                   
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_asg03,g_asz.asz06,'23',g_asz.asz01)    #MOD-B60229 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asz.asz06,'23',g_asz.asz01)  #MOD-B60229
                    RETURNING g_qryparam.multiret                  
               LET g_asz.asz06=g_qryparam.multiret                                      
               DISPLAY BY NAME g_asz.asz06                                        
               NEXT FIELD asz06                                                   
#----FUN-990020 end-----------
         END CASE 
     
      ON ACTION CONTROLZ
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
 
   END INPUT
 
END FUNCTION
 
FUNCTION s101_aaz31(p_code,p_bookno)                    
   DEFINE p_code     LIKE aag_file.aag01  
   DEFINE p_bookno   LIKE aag_file.aag00                
   DEFINE l_aagacti  LIKE aag_file.aagacti
   DEFINE l_aag07    LIKE aag_file.aag07  
   DEFINE l_aag03    LIKE aag_file.aag03  
 
   SELECT aag03,aag07,aagacti INTO l_aag03,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01=p_code      
      AND aag00=p_bookno  
 
    CASE WHEN STATUS=100         LET g_errno='agl-001'   
         WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'     LET g_errno = 'agl-015' 
         WHEN l_aag03  = '2'     LET g_errno = 'agl-213' 
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
END FUNCTION
#FUN-B40104 
