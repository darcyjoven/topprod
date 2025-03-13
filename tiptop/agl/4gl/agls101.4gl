# Prog. Version..: '5.30.06-13.04.01(00009)'     #
#
# Pattern name...: agls101.4gl
# Descriptions...: 合併報表系統參數設定作業
# Date & Author..: NO.FUN-920021 98/02/03 By jamie 從agls103頁籤中獨立成一支程式
# Modify.........: NO.FUN-920094 09/05/20 By jan 
#                                         1.合併帳別aaz641改為require,not null
#                                         2.會科aaz86,aaz87,aaz100,aaz101,aaz102,aaz103 開窗時以目前DB+aaz641 開窗合併後會科資料
#                                         3.上述會科AFTER FIELD 時檢核羅輯亦同第2點 
# Modify.........: No.FUN-950060 09/05/22 By lutingting增加欄位aaz111,aaz112
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: NO.FUN-990020 10/08/19 by Yiting add aaz113,aaz114
# Modify.........: NO.FUN-A70105 10/08/19 BY yiting add aaz120再衡量兌換損失科目
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.MOD-B60229 11/06/27 By Sarah CALL q_m_aag2()的第三個參數應該傳g_plant_axz03
# Modify.........: No.FUN-BA0012 11/10/05 By Belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.FUN-B90093 11/10/14 By Belle add aaz130(追單)
# Modify.........: NO.FUN-B80182 11/10/20 By Belle add aaz128,aaz129 少數股權及少數股權淨利(追單)
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
# Modify.........: No.FUN-C10054 12/02/01 By belle  增加累計盈虧欄位
# Modify.........: No.FUN-D20046 13/03/18 By Lori 新增aaz642(關帳日期),aaz643(是否子公司一併關帳)

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0006
    DEFINE
        g_aaz_t         RECORD LIKE aaz_file.*,    # 預留參數檔
        g_aaz_o         RECORD LIKE aaz_file.*,    # 預留參數檔
        l_aaa           RECORD LIKE aaa_file.*     # 預留參數檔
DEFINE p_row,p_col      LIKE type_file.num5                                                                                                   
DEFINE g_forupd_sql     STRING                                                   
DEFINE g_msg            LIKE type_file.chr1000                                                    
DEFINE g_dbs_axz03      LIKE axz_file.axz03        #FUN-920094 add                                                    
DEFINE g_plant_axz03    LIKE axz_file.axz03        #FUN-980025 add                                                    
 
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
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET p_row = 4 LET p_col = 8
   OPEN WINDOW s101_w AT p_row,p_col
     WITH FORM "agl/42f/agls101"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()

#FUN-BC0027 --begin--   
#   IF g_aza.aza26 = '2' THEN                                                    
#      CALL cl_getmsg('agl-350',g_lang) RETURNING g_msg                          
#      CALL cl_set_comp_att_text("aaz31",g_msg CLIPPED)                          
#      CALL cl_getmsg('agl-351',g_lang) RETURNING g_msg                          
#      CALL cl_set_comp_att_text("aaz32",g_msg CLIPPED)                          
#      CALL cl_getmsg('agl-352',g_lang) RETURNING g_msg                          
#      CALL cl_set_comp_att_text("aaz33",g_msg CLIPPED)                          
#   END IF            
#FUN-BC0027 --end--
                                                              
   CALL s101_show()
 
   LET g_action_choice=""
   CALL s101_menu()
 
   CLOSE WINDOW s101_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN    
 
FUNCTION s101_show()
 
   SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00 = '0'
 
   IF SQLCA.sqlcode THEN
      INSERT INTO aaz_file(
                           aaz00,aaz86,aaz87,aaz100,aaz101,aaz102,
                           aaz103,aaz641,aaz109,aaz110,aaz111,aaz112,  #FUN-950060 add aaz111,aaz112  
                           aaz113,aaz114,aaz120    #FUN-990020  #FUN-A70105 add aaz120
                          ,aaz128,aaz129            #FUN-B80182 add
                          ,aaz130                   #FUN-B90093 add
                          ,aaz131                   #FUN-C10054 add
                          ,aaz642,aaz643            #FUN-D20046 add
                           )
           VALUES (
                   '0',g_aaz.aaz86,g_aaz.aaz87,                  
                   g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,
                   g_aaz.aaz641,g_aaz.aaz109,g_aaz.aaz110,g_aaz.aaz111,g_aaz.aaz112,  #FUN-950060 add aaz111,aaz112
                   g_aaz.aaz113,g_aaz.aaz114,   #FUN-990020
                   g_aaz.aaz120                 #FUN-A70105
		  ,g_aaz128,g_aaz129            #FUN-B80182 add
                  ,g_aaz130                     #FUN-B90093
                  ,g_aaz131                     #FUN-C10054
                  ,g_aaz.aaz642,g_aaz.aaz643    #FUN-D20046 add
                   )
   ELSE
      UPDATE aaz_file SET aaz86 = g_aaz.aaz86,            
                          aaz87 = g_aaz.aaz87,            
                          aaz100= g_aaz.aaz100,            
                          aaz101= g_aaz.aaz101,            
                          aaz102= g_aaz.aaz102,            
                          aaz103= g_aaz.aaz103,             
                          aaz641= g_aaz.aaz641,
                          aaz109 = g_aaz.aaz109,
                          aaz110 = g_aaz.aaz110,
                          aaz111 = g_aaz.aaz111,   #FUN-950060 add
                          aaz112 = g_aaz.aaz112,   #FUN-950060 add  
                          aaz113 = g_aaz.aaz113,   #FUN-990020 add
                          aaz114 = g_aaz.aaz114,   #FUN-990020 add
                          aaz120 = g_aaz.aaz120    #FUN-A70105
                         ,aaz128 = g_aaz.aaz128    #FUN-B80182 add
                         ,aaz129 = g_aaz.aaz129    #FUN-B80182 add
                         ,aaz130 = g_aaz.aaz130    #FUN-B90093
                         ,aaz131 = g_aaz.aaz131    #FUN-C10054
                         ,aaz642 = g_aaz.aaz642    #FUN-D20046 add
                         ,aaz643 = g_aaz.aaz643    #FUN-D20046 add
       WHERE aaz00 = '0'
   END IF
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
 
   DISPLAY BY NAME g_aaz.aaz86,g_aaz.aaz87,              
                   g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,
                   g_aaz.aaz641,g_aaz.aaz109,g_aaz.aaz110,g_aaz.aaz111,g_aaz.aaz112,    #FUN-950060 add aaz111,aaz112  
                   g_aaz.aaz113,g_aaz.aaz114,   #FUN-990020
                   g_aaz.aaz120                 #FUN-A70105
		  ,g_aaz.aaz128,g_aaz.aaz129    #FUN-B80182 add
                  ,g_aaz.aaz130                 #FUN-B90093
                  ,g_aaz.aaz131                 #FUN-C10054
                  ,g_aaz.aaz642,g_aaz.aaz643    #FUN-D20046 add
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
 
   LET g_forupd_sql = "SELECT * FROM aaz_file WHERE aaz00 = '0' FOR UPDATE"    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aaz_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN aaz_curl 
   IF STATUS THEN
      CALL cl_err('OPEN aaz_curl',STATUS,1)
      RETURN
   END IF         
 
   FETCH aaz_curl INTO g_aaz.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   LET g_aaz_t.* = g_aaz.*
   LET g_aaz_o.* = g_aaz.*
 
   DISPLAY BY NAME g_aaz.aaz86,g_aaz.aaz87,   
                   g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz102,g_aaz.aaz103,               #FUN-890071
                   g_aaz.aaz641,g_aaz.aaz109,g_aaz.aaz110,
                   g_aaz.aaz111,g_aaz.aaz112,     #FUN-950060 add 
                   g_aaz.aaz113,g_aaz.aaz114,      #FUN-990020
                   g_aaz.aaz120                   #FUN-A70105
		  ,g_aaz.aaz128,g_aaz.aaz129       #FUN-B80182 add
                  ,g_aaz.aaz130                    #FUN-B90093
                  ,g_aaz.aaz131                    #FUN-C10054
                  ,g_aaz.aaz642,g_aaz.aaz643       #FUN-D20046 add
   WHILE TRUE
      CALL s101_i()
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_aaz.* = g_aaz_t.*
         CALL s101_show()
         EXIT WHILE
      END IF
 
      UPDATE aaz_file SET 
                          aaz86 = g_aaz.aaz86,             
                          aaz87 = g_aaz.aaz87,             
                          aaz100= g_aaz.aaz100,            
                          aaz101= g_aaz.aaz101,            
                          aaz102= g_aaz.aaz102,            
                          aaz103= g_aaz.aaz103,            
                          aaz641= g_aaz.aaz641,
                          aaz109 = g_aaz.aaz109,
                          aaz110 = g_aaz.aaz110,
                          aaz111 = g_aaz.aaz111,    #FUN-950060 add
                          aaz112 = g_aaz.aaz112,    #FUN-950060 add
                          aaz113 = g_aaz.aaz113,    #FUN-990020
                          aaz114 = g_aaz.aaz114,    #FUN-990020
                          aaz120 = g_aaz.aaz120     #FUN-A70105
                         ,aaz128 = g_aaz.aaz128     #FUN-B80182
                         ,aaz129 = g_aaz.aaz129     #FUN-B80182
                         ,aaz130 = g_aaz.aaz130     #FUN-B90093
                         ,aaz131 = g_aaz.aaz131     #FUN-C10054
                         ,aaz642 = g_aaz.aaz642     #FUN-D20046 add
                         ,aaz643 = g_aaz.aaz643     #FUN-D20046 add
       WHERE aaz00='0'
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","aaz_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660123
         CONTINUE WHILE
      END IF
 
      CLOSE aaz_curl
      COMMIT WORK
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION s101_i()
   DEFINE l_aza LIKE type_file.chr1,                                
          l_cmd LIKE type_file.chr50                                 
   DEFINE li_chk_bookno  LIKE type_file.num5                                                 
 
     LET g_plant_new = g_plant      #營運中心
     LET g_plant_axz03 = g_plant    #營運中心  #No.FUN-980025 add
     CALL s_getdbs()
     LET g_dbs_axz03 = g_dbs_new    #所屬DB
 
   #INPUT BY NAME g_aaz.aaz641,g_aaz.aaz86,g_aaz.aaz87,                                                    
   INPUT BY NAME g_aaz.aaz641,g_aaz.aaz86,g_aaz.aaz120,g_aaz.aaz87,    #FUN-A70105 add aaz120                                                 
                 g_aaz.aaz113,g_aaz.aaz114,             #FUN-990020
                 g_aaz.aaz128,g_aaz.aaz129,             #FUN-B80182 add
                 g_aaz.aaz100,g_aaz.aaz101,g_aaz.aaz109,g_aaz.aaz111,  #FUN-950060 add aaz111
                 g_aaz.aaz110,g_aaz.aaz112,   #FUN-950060 add aaz112
                 g_aaz.aaz102,g_aaz.aaz103 
                ,g_aaz.aaz130                 #FUN-B90093
                ,g_aaz.aaz131                 #FUN-C10054
                ,g_aaz.aaz643                 #FUN-D20046 add
      WITHOUT DEFAULTS 
 
 
      AFTER FIELD aaz641
         IF NOT cl_null(g_aaz.aaz641) THEN
            CALL s_check_bookno(g_aaz.aaz641,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
                 NEXT FIELD aaz641 
            END IF 
            SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_aaz.aaz641
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",g_aaz.aaz641,"","agl-043","","",0)   #No.FUN-660123
               NEXT FIELD aaz641
            END IF
        #FUN-920094---mod--str---
         ELSE 
            CALL cl_err('','mfg0037',0)
            NEXT FIELD aaz641
        #FUN-920094---mod--end---
         END IF 
 
      AFTER FIELD aaz86
         IF NOT cl_null(g_aaz.aaz86) THEN 
           #CALL s101_aaz31(g_aaz.aaz86,g_aza.aza81)   #FUN-920094 mark #No.FUN-7300070
            CALL s101_aaz31(g_aaz.aaz86,g_aaz.aaz641)  #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz86,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz86                 
               #FUN-B20004--end               
               NEXT FIELD aaz86
            END IF
         END IF
 
#----FUN-A70105 start--
      AFTER FIELD aaz120
         IF NOT cl_null(g_aaz.aaz120) THEN 
            CALL s101_aaz31(g_aaz.aaz120,g_aaz.aaz641)
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz120,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz120                 
               #FUN-B20004--end                             
               NEXT FIELD aaz120
            END IF
         END IF
#----FUN-A70105 end----

      AFTER FIELD aaz87
         IF NOT cl_null(g_aaz.aaz87) THEN 
           #CALL s101_aaz31(g_aaz.aaz87,g_aza.aza81)   #FUN-920094 mark 
            CALL s101_aaz31(g_aaz.aaz87,g_aaz.aaz641)  #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz87,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz87                 
               #FUN-B20004--end                             
               NEXT FIELD aaz87
            END IF
         END IF
 
      AFTER FIELD aaz100
         IF NOT cl_null(g_aaz.aaz100) THEN 
           #CALL s101_aaz31(g_aaz.aaz100,g_aza.aza81)   #FUN-920094 mark
            CALL s101_aaz31(g_aaz.aaz100,g_aaz.aaz641)  #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz100,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz100                 
               #FUN-B20004--end                     
               NEXT FIELD aaz100
            END IF
         END IF
      
      AFTER FIELD aaz101
         IF NOT cl_null(g_aaz.aaz101) THEN 
           #CALL s101_aaz31(g_aaz.aaz101,g_aza.aza81)   #FUN-920094 mark
            CALL s101_aaz31(g_aaz.aaz101,g_aaz.aaz641)  #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz101,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz101                 
               #FUN-B20004--end                     
               NEXT FIELD aaz101
            END IF
         END IF
 
      AFTER FIELD aaz102
         IF NOT cl_null(g_aaz.aaz102) THEN 
           #CALL s101_aaz31(g_aaz.aaz102,g_aza.aza81)    #FUN-920094 mark
            CALL s101_aaz31(g_aaz.aaz102,g_aaz.aaz641)   #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz102,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz102                 
               #FUN-B20004--end                   
               NEXT FIELD aaz102
            END IF
         END IF
 
      AFTER FIELD aaz103
         IF NOT cl_null(g_aaz.aaz103) THEN 
           #CALL s101_aaz31(g_aaz.aaz103,g_aza.aza81)    #FUN-920094 mark
            CALL s101_aaz31(g_aaz.aaz103,g_aaz.aaz641)   #FUN-920094 mod
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz103,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz103               
               #FUN-B20004--end                   
               NEXT FIELD aaz103
            END IF
         END IF
 
      AFTER FIELD aaz109                                                                                                           
         IF NOT cl_null(g_aaz.aaz109) THEN                                                                                         
            CALL s101_aaz31(g_aaz.aaz109,g_aaz.aaz641)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                  
               CALL cl_err('',g_errno,0)    
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz109,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz109                 
               #FUN-B20004--end                                                                                                          
               NEXT FIELD aaz109                                                                                                   
            END IF                                                                                                                 
         END IF                                                                                                                    
                                                                                                                                   
      AFTER FIELD aaz110                                                                                                           
         IF NOT cl_null(g_aaz.aaz110) THEN                                                                                         
            CALL s101_aaz31(g_aaz.aaz110,g_aaz.aaz641)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                  
               CALL cl_err('',g_errno,0)    
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz110,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz110                 
               #FUN-B20004--end                                                                                                          
               NEXT FIELD aaz110                                                                                                   
            END IF                                                                                                                 
         END IF    
 
      #FUN-950060--add--start--
      AFTER FIELD aaz111                                                                                                            
         IF NOT cl_null(g_aaz.aaz111) THEN                                                                                          
            CALL s101_aaz31(g_aaz.aaz111,g_aaz.aaz641)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                   
               CALL cl_err('',g_errno,0)     
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz111,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz111                 
               #FUN-B20004--end                                                                                                              
               NEXT FIELD aaz111                                                                                                    
            END IF                                                                                                                  
         END IF
 
      AFTER FIELD aaz112                                                                                                            
         IF NOT cl_null(g_aaz.aaz112) THEN                                                                                          
            CALL s101_aaz31(g_aaz.aaz112,g_aaz.aaz641)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                   
               CALL cl_err('',g_errno,0)    
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz112,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz112                 
               #FUN-B20004--end                                                                                                               
               NEXT FIELD aaz112                                                                                                    
            END IF                                                                                                                  
         END IF
      #FUN-950060--add--end
 
 
#--FUN-A70105 start--
      AFTER FIELD aaz113
         IF NOT cl_null(g_aaz.aaz113) THEN 
            CALL s101_aaz31(g_aaz.aaz113,g_aaz.aaz641)
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz113,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz113                 
               #FUN-B20004--end                       
               NEXT FIELD aaz113
            END IF
         END IF

      AFTER FIELD aaz114
         IF NOT cl_null(g_aaz.aaz114) THEN 
            CALL s101_aaz31(g_aaz.aaz114,g_aaz.aaz641)
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
               CALL cl_err('',g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_aaz.aaz114,'23',g_aaz.aaz641)  
                    RETURNING g_aaz.aaz114                
               #FUN-B20004--end                       
               NEXT FIELD aaz114
            END IF
         END IF
#---FUN-990020 end--------

#---FUN-B80182 start------
      AFTER FIELD aaz128
         IF NOT cl_null(g_aaz.aaz128) THEN                                                                                          
            CALL s101_aaz31(g_aaz.aaz128,g_aaz.aaz641)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                   
               CALL cl_err('',g_errno,0)                                                                                            
               NEXT FIELD aaz128                                                                                                    
            END IF                                                                                                                  
         END IF

      AFTER FIELD aaz129
         IF NOT cl_null(g_aaz.aaz129) THEN                                                                                          
            CALL s101_aaz31(g_aaz.aaz129,g_aaz.aaz641)                                                                              
            IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN                                                                   
               CALL cl_err('',g_errno,0)                                                                                            
               NEXT FIELD aaz129                                                                                                    
            END IF                                                                                                                  
         END IF
#----FUN-B80182 end------- 
#FUN-C10054--Begin--
     AFTER FIELD aaz131
        IF NOT cl_null(g_aaz.aaz131) THEN
          CALL s101_aaz31(g_aaz.aaz131,g_aaz.aaz641)
          IF NOT cl_null(g_errno) AND g_errno <> 'agl-213' THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD aaz131
          END IF
       END IF
#FUN-C10054---End---


      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION mntn_acc_code
          CALL cl_cmdrun('agli102' CLIPPED) 
 
      ON ACTION mntn_doc_type
          CALL cl_cmdrun('agli108 ' CLIPPED) 
     
      ON ACTION controlp                                                          
         CASE                                                                     
            WHEN INFIELD(aaz641)   #合併報表帳別
               CALL cl_init_qry_var()                                             
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_aaz.aaz641
               CALL cl_create_qry() RETURNING g_aaz.aaz641
               DISPLAY BY NAME g_aaz.aaz641
               NEXT FIELD aaz641
            WHEN INFIELD(aaz86)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_aaz.aaz86                              
              #LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
              #CALL cl_create_qry() RETURNING g_aaz.aaz86                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz86,'23',g_aaz.aaz641)    #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz86,'23',g_aaz.aaz641)  #No.FUN-980025 
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz86=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_aaz.aaz86                                        
               NEXT FIELD aaz86                                                   
            WHEN INFIELD(aaz87)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_aaz.aaz87                              
              #LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
              #CALL cl_create_qry() RETURNING g_aaz.aaz87                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz87,'23',g_aaz.aaz641)   #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz87,'23',g_aaz.aaz641) #No.FUN-980025  
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz87=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_aaz.aaz87                                        
               NEXT FIELD aaz87   
            WHEN INFIELD(aaz100)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_aaz.aaz100                              
              #LET g_qryparam.arg1 = g_aza.aza81
              #CALL cl_create_qry() RETURNING g_aaz.aaz100                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz100,'23',g_aaz.aaz641)    #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz100,'23',g_aaz.aaz641)  #No.FUN-980025 
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz100=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_aaz.aaz100                                        
               NEXT FIELD aaz100                                                   
#----FUN-A70105 start---------
            WHEN INFIELD(aaz120)                                                   
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz120,'23',g_aaz.aaz641)  
              #CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaw.aaw03,'23',g_aaw.aaw01)    #FUN-BA0012 #MOD-B60229
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz120,'23',g_aaz.aaz641)  #FUN-BA0012 #MOD-B60229
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz120=g_qryparam.multiret                                      
               DISPLAY BY NAME g_aaz.aaz120                                        
               NEXT FIELD aaz120                                                   
#----FUN-A70105 end-----------
            WHEN INFIELD(aaz101)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_aaz.aaz101                              
              #LET g_qryparam.arg1 = g_aza.aza81
              #CALL cl_create_qry() RETURNING g_aaz.aaz101                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz101,'23',g_aaz.aaz641)    #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz101,'23',g_aaz.aaz641)  #No.FUN-980025 
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz101=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_aaz.aaz101                                        
               NEXT FIELD aaz101                                                   
            WHEN INFIELD(aaz102)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_aaz.aaz102                              
              #LET g_qryparam.arg1 = g_aza.aza81
              #CALL cl_create_qry() RETURNING g_aaz.aaz102                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz102,'23',g_aaz.aaz641)    #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz102,'23',g_aaz.aaz641)  #No.FUN-980025
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz102=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_aaz.aaz102                                        
               NEXT FIELD aaz102                                                   
            WHEN INFIELD(aaz103)                                                   
              #FUN-920094---mod---str---
              #CALL cl_init_qry_var()                                             
              #LET g_qryparam.form ="q_aag"                                       
              #LET g_qryparam.default1 = g_aaz.aaz103                              
              #LET g_qryparam.arg1 = g_aza.aza81
              #CALL cl_create_qry() RETURNING g_aaz.aaz103                         
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz103,'23',g_aaz.aaz641)     #No.FUN-980025 mark
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz103,'23',g_aaz.aaz641)   #No.FUN-980025 
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz103=g_qryparam.multiret                                      
              #FUN-920094---mod---end---
               DISPLAY BY NAME g_aaz.aaz103                                        
               NEXT FIELD aaz103        
            WHEN INFIELD(aaz109) 
               #FUN-950060---mod--str--                                                                                                   
               #CALL cl_init_qry_var()                                                                                               
               #LET g_qryparam.form ="q_aag"                                                                                         
               #LET g_qryparam.default1 = g_aaz.aaz109                                                                               
               #LET g_qryparam.arg1 = g_aza.aza81                                                                                    
               #CALL cl_create_qry() RETURNING g_aaz.aaz109     
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz109,'23',g_aaz.aaz641)     #No.FUN-980025 mark                                            
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz109,'23',g_aaz.aaz641)   #No.FUN-980025                                              
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_aaz.aaz109=g_qryparam.multiret 
               #FUN-950060---mod--end--                                                                     
               DISPLAY BY NAME g_aaz.aaz109                                                                                         
               NEXT FIELD aaz109                                                                                                    
            WHEN INFIELD(aaz110)                        
               #FUN-950060---mod--str
               #CALL cl_init_qry_var()                                                                                               
               #LET g_qryparam.form ="q_aag"                                                                                         
               #LET g_qryparam.default1 = g_aaz.aaz110                                                                               
               #LET g_qryparam.arg1 = g_aza.aza81                                                                                    
               #CALL cl_create_qry() RETURNING g_aaz.aaz110      
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz110,'23',g_aaz.aaz641)    #No.FUN-980025 mark                                             
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz110,'23',g_aaz.aaz641)  #No.FUN-980025                                                
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_aaz.aaz110=g_qryparam.multiret                                                                                 
               #FUN-950060---mod--end--                                                                    
               DISPLAY BY NAME g_aaz.aaz110                                                                                         
               NEXT FIELD aaz110                               
            #FUN-950060---add--start--
            WHEN INFIELD(aaz111)                                                                                                    
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz111,'23',g_aaz.aaz641)    #No.FUN-980025 mark                                             
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz111,'23',g_aaz.aaz641)  #No.FUN-980025                                                
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_aaz.aaz111=g_qryparam.multiret                                                                                 
               DISPLAY BY NAME g_aaz.aaz111                                                                                         
               NEXT FIELD aaz111
            WHEN INFIELD(aaz112)                                                                                                    
#              CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz112,'23',g_aaz.aaz641)    #No.FUN-980025 mark                                             
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz112,'23',g_aaz.aaz641)  #No.FUN-980025                                                 
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_aaz.aaz112=g_qryparam.multiret                                                                                 
               DISPLAY BY NAME g_aaz.aaz112                                                                                         
               NEXT FIELD aaz112 
            #FUN-950060---add--end              
#----FUN-990020 start---------
            WHEN INFIELD(aaz113)                                                   
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz113,'23',g_aaz.aaz641)    #MOD-B60229
              #CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaw.aaw05,'23',g_aaw.aaw01)    #FUN-BA0012 #MOD-B60229
			   CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz113,'23',g_aaz.aaz641)  #FUN-BA0012
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz113=g_qryparam.multiret                                      
               DISPLAY BY NAME g_aaz.aaz113                                        
               NEXT FIELD aaz113                                                   
            WHEN INFIELD(aaz114)                                                   
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_aaz.aaz114,'23',g_aaz.aaz641)
              #CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaw.aaw06,'23',g_aaw.aaw01)    #FUN-BA0012 #MOD-B60229
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz114,'23',g_aaz.aaz641)  #FUN-BA0012
                    RETURNING g_qryparam.multiret                  
               LET g_aaz.aaz114=g_qryparam.multiret                                      
               DISPLAY BY NAME g_aaz.aaz114                                        
               NEXT FIELD aaz114                                                   
#-----FUN-990020 end-------------
#-----FUN-B80182 start---
            WHEN INFIELD(aaz128)                                                                                                    
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz128,'23',g_aaz.aaz641)                                                 
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_aaz.aaz128=g_qryparam.multiret                                                                                 
               DISPLAY BY NAME g_aaz.aaz128                                                                                         
               NEXT FIELD aaz128 
            WHEN INFIELD(aaz129)                                                                                                    
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz129,'23',g_aaz.aaz641)                                                 
                    RETURNING g_qryparam.multiret                                                                                   
               LET g_aaz.aaz129=g_qryparam.multiret                                                                                 
               DISPLAY BY NAME g_aaz.aaz129                                                                                         
               NEXT FIELD aaz129 
#----FUN-B80182 end -----
#FUN-C10054--begin--
           WHEN INFIELD(aaz131)
              CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_aaz.aaz131,'23',g_aaz.aaz641)
                   RETURNING g_qryparam.multiret
              LET g_aaz.aaz131=g_qryparam.multiret
              DISPLAY BY NAME g_aaz.aaz131
              NEXT FIELD aaz131
#FUN-C10054---end---

         END CASE 
     
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
 
