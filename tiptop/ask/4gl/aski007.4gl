# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aski007.4gl
# Descriptions...: 裁床表維護作業
# Date & Author..: No.FUN-810016 08/01/17 By ve007
# Modify.........: No.FUN-840178 08/04/02 By ve007  debug 810016
# Modify.........: No.FUN-870117 08/09/09 by ve007  新增自定義欄位
# Modify.........: No.FUN-8A0145 08/10/31 by hongmei 欄位類型修改
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-8C0056 08/12/23 By alex 調整setup參數
# Modify.........: No.TQC-8C0072 09/01/08 By clover 調整語法錯誤
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-940168 09/08/25 By alex 調整cl_used位置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號的管控
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_skf        RECORD LIKE skf_file.*,
   g_skf_t      RECORD LIKE skf_file.*,
   g_skg        DYNAMIC ARRAY OF RECORD
       skg04 LIKE skg_file.skg04,           #項次
       skg05 LIKE skg_file.skg05,           #屬性一
       skg06 LIKE skg_file.skg06,           #屬性二
       skg07 LIKE skg_file.skg07,           #屬性三
       skg12 LIKE skg_file.skg12,           #工單單號    
       skg08 LIKE skg_file.skg08,           #扎號 
       skg09 LIKE skg_file.skg09,           #數量 
       skg10 LIKE skg_file.skg10,           #LOT色 
       skg11 LIKE skg_file.skg11,           #備注
       skgud01  LIKE skg_file.skgud01,
       skgud02  LIKE skg_file.skgud02,
       skgud03  LIKE skg_file.skgud03,
       skgud04  LIKE skg_file.skgud04,
       skgud05  LIKE skg_file.skgud05,
       skgud06  LIKE skg_file.skgud06,
       skgud07  LIKE skg_file.skgud07,
       skgud08  LIKE skg_file.skgud08,
       skgud09  LIKE skg_file.skgud09,
       skgud10  LIKE skg_file.skgud10,
       skgud11  LIKE skg_file.skgud11,
       skgud12  LIKE skg_file.skgud12,
       skgud13  LIKE skg_file.skgud13,
       skgud14  LIKE skg_file.skgud14,
       skgud15  LIKE skg_file.skgud15
       END RECORD,
   g_skg_t       RECORD
       skg04 LIKE skg_file.skg04,                  
       skg05 LIKE skg_file.skg05,                     
       skg06 LIKE skg_file.skg06,           
       skg07 LIKE skg_file.skg07,
       skg12 LIKE skg_file.skg12,                       
       skg08 LIKE skg_file.skg08,
       skg09 LIKE skg_file.skg09,
       skg10 LIKE skg_file.skg10,
       skg11 LIKE skg_file.skg11,
       skgud01  LIKE skg_file.skgud01,
       skgud02  LIKE skg_file.skgud02,
       skgud03  LIKE skg_file.skgud03,
       skgud04  LIKE skg_file.skgud04,
       skgud05  LIKE skg_file.skgud05,
       skgud06  LIKE skg_file.skgud06,
       skgud07  LIKE skg_file.skgud07,
       skgud08  LIKE skg_file.skgud08,
       skgud09  LIKE skg_file.skgud09,
       skgud10  LIKE skg_file.skgud10,
       skgud11  LIKE skg_file.skgud11,
       skgud12  LIKE skg_file.skgud12,
       skgud13  LIKE skg_file.skgud13,
       skgud14  LIKE skg_file.skgud14,
       skgud15  LIKE skg_file.skgud15
       END RECORD,
   g_wc,g_sql,g_wc2  STRING,
   g_rec_b           LIKE type_file.num5,     #單身筆數    
   l_ac              LIKE type_file.num5      #目前處理的ARRAY CNT
DEFINE g_forupd_sql  STRING                   #SELECT ...  FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10
DEFINE g_no_ask        LIKE type_file.num5
DEFINE g_delete        LIKE type_file.chr1
DEFINE g_agb01         LIKE agb_file.agb01
DEFINE g_chr           STRING
DEFINE g_skg12_arg1    STRING
 
MAIN
   DEFINE l_sma124        LIKE sma_file.sma124
 
   OPTIONS                                                            
        INPUT NO WRAP
   DEFER INTERRUPT      
 
   IF (NOT cl_user()) THEN                                             
      EXIT PROGRAM                                                       
   END IF                      
                                                                        
   WHENEVER ERROR CALL cl_err_msg_log 
 
   IF (NOT cl_setup("ASK")) THEN #TQC-8C0056
      EXIT PROGRAM                                                       
   END IF   
   
   IF NOT s_industry('slk') THEN
      CALL cl_err("","-1000",1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #TQC-940168
 
   LET g_forupd_sql = "SELECT * FROM skf_file WHERE skf01 =? AND skf02 = ? AND skf03 = ? FOR UPDATE  "                                                                               
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i007_crl CURSOR FROM g_forupd_sql 
 
   OPEN WINDOW i007_w WITH FORM "ask/42f/aski007"               
      ATTRIBUTE (STYLE = g_win_style CLIPPED)             
                                                                                
   CALL cl_ui_init()      
    
   CALL i007_menu()
                                                                                
   CLOSE WINDOW i007_w                                                         
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION i007_cs()
DEFINE l_i        like type_file.num5
   CLEAR FORM                             #清除畫面 
    CALL cl_set_comp_visible("skg05,skg06,skg07",TRUE)
    FOR l_i=1 TO 3                                                               
        LET g_msg=NULL                                                          
        CASE l_i                                                                
             WHEN '1'  SELECT ze03 INTO g_msg  FROM ze_file                     
                       WHERE ze01='ask-005' AND ze02=g_lang                     
                       CALL cl_set_comp_att_text('skg05',g_msg CLIPPED)         
             WHEN '2'  SELECT ze03 INTO g_msg  FROM ze_file                     
                       WHERE ze01='ask-006' AND ze02=g_lang                     
                       CALL cl_set_comp_att_text('skg06',g_msg CLIPPED)         
             WHEN '3'  SELECT ze03 INTO g_msg  FROM ze_file                     
                       WHERE ze01='ask-007' AND ze02=g_lang                     
                       CALL cl_set_comp_att_text('skg07',g_msg CLIPPED)         
        END CASE                                                                
   END FOR  
   
   CONSTRUCT BY NAME g_wc ON skf01,skf02,skf03,skf04,skf05,skf06,
                             skfacti,skfuser,skfmodu,skfgrup,skfdate
     ON ACTION controlp         #查詢款式料號
          CASE
          WHEN INFIELD(skf01)                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.state="c"                                    
               LET g_qryparam.form="q_skf01"
               LET g_qryparam.default1=g_skf.skf01                            
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
	             DISPLAY g_qryparam.multiret TO skf01 
	        WHEN INFIELD(skf02)                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.state="c"                                    
               LET g_qryparam.form="q_skf02"
               LET g_qryparam.default1=g_skf.skf02                            
               CALL cl_create_qry() RETURNING g_skf.skf02               
	             DISPLAY BY NAME g_skf.skf02
	             CALL i007_skf02('d')  
	        WHEN INFIELD(skf05)                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.state="c"                                    
               LET g_qryparam.form="q_skf05"
               LET g_qryparam.default1=g_skf.skf05                           
               CALL cl_create_qry() RETURNING g_skf.skf05              
	             DISPLAY BY NAME g_skf.skf05
	             CALL i007_skf05('d')                                    
          OTHERWISE                                                             
              EXIT CASE  
              NEXT FIELD skf03
          END CASE 
          
     ON IDLE g_idle_seconds   
         CALL cl_on_idle()                                                 
         CONTINUE CONSTRUCT
         
   END  CONSTRUCT
   
    CONSTRUCT g_wc2 ON skg04,skg05,skg06,skg07,skg12,skg08,skg09,skg10,skg11
                  FROM s_skg[1].skg04,s_skg[1].skg05,s_skg[1].skg06,s_skg[1].skg07,
                       s_skg[1].skg12,s_skg[1].skg08,s_skg[1].skg09,s_skg[1].skg10,
                       s_skg[1].skg11
                       
        ON ACTION controlp        
          CASE                
            WHEN INFIELD(skg12)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_skg12"                           
                 LET g_qryparam.state = "c"                                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET g_skg[1].skg12 = g_qryparam.multiret
                 DISPLAY g_qryparam.multiret  TO skg12 
                 NEXT FIELD skg12       
         END CASE  
                                      
    ON IDLE g_idle_seconds                                                     
         CALL cl_on_idle()                                                      
         CONTINUE CONSTRUCT                                                     
   END  CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT skf01,skf02,skf03 FROM skf_file ",
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY skf01"
    ELSE
      LET g_sql= "SELECT,skf01,skf02,skf03 FROM skf_file,skg_file",
                 " WHERE skf01=skg01 AND skf02=skg02 AND skf03=skg03 AND ", g_wc CLIPPED,
                 " AND ",g_wc2 CLIPPED," ORDER BY skf01 "
    END IF                                             
    PREPARE i007_prepare FROM g_sql      #預備一下                              
    DECLARE i007_b_cs                  #宣告成可卷動的                          
        SCROLL CURSOR WITH HOLD FOR i007_prepare
    IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT  COUNT(*)     ",                                 
              " FROM skf_file WHERE ", g_wc CLIPPED
    ELSE
      LET g_sql="SELECT  COUNT(*)     ",                                        
                " FROM skf_file,skg_file WHERE ", 
                " skf01=skg01 AND skf02=skg02 AND skf03=skg03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i007_precount FROM g_sql                                            
    DECLARE i007_count CURSOR FOR i007_precount                                 
END FUNCTION  
         
FUNCTION i007_menu() 
    WHILE TRUE
      CALL i007_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i007_a()                                                    
            END IF  
                                                                        
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i007_q()                                                    
            END IF 
                                                                         
         WHEN "delete"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i007_r()                                                    
            END IF 
                                                                         
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i007_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF 
            
         WHEN "invalid"                                                         
            IF cl_chk_act_auth() THEN                                           
               CALL i007_x()
               CALL i007_show()                                                
            END IF
            
         WHEN "modify"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i007_u()                                                    
            END IF   
                      
          WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i007_copy()
            END IF
            
         WHEN "confirm"                                                       
           IF cl_chk_act_auth() THEN                                            
              CALL i007_confirm()                                               
              CALL i007_show()                                                  
           END IF                                                               
                                                                                
         WHEN "notconfirm"                                                    
           IF cl_chk_act_auth() THEN                                            
              CALL i007_notconfirm()                                            
              CALL i007_show()                                                  
           END IF 
         
         WHEN "auto_b"                 
           IF cl_chk_act_auth() THEN
             CALL i007_auto_b('u') 
             CALL i007_b() 
           END IF 
                                                                          
         WHEN "help"                                                            
            CALL cl_show_help()  
                                                           
         WHEN "exit"                                                            
            EXIT WHILE 
                                                                     
         WHEN "controlg"                                                        
            CALL cl_cmdask() 
             
         WHEN "exporttoexcel"                                                  
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_skf),'','')                                                             
            END IF
               
      END CASE
    END WHILE
END FUNCTION
 
FUNCTION i007_a()
   
    MESSAGE ""                                                                  
    CLEAR FORM                                                                  
    CALL g_skg.clear()
    
    IF s_shut(0) THEN
       RETURN
    END IF
    
    INITIALIZE g_skf.* LIKE skf_file.*
    CALL cl_opmsg('a')
 
    WHILE TRUE
       LET g_skf.skfuser = g_user                                              
       LET g_skf.skfgrup = g_grup               #使用者所屬群                  
       LET g_skf.skfdate = g_today                                             
       LET g_skf.skfacti = 'Y'
       LET g_skf.skf01  = ' '                                                      
       LET g_skf_t.skf01 = ' '                                                        
       LET g_skf.skf02=' '
       LET g_skf_t.skf02 = ' '                                                          
       LET g_skf.skf03  = ' '                                                      
       LET g_skf_t.skf03 = ' ' 
       LET g_skf.skf04=g_today                                                        
       LET g_skf.skf07='N'                                                 
       LET g_skf.skfplant=g_plant #FUN-980008 add
       LET g_skf.skflegal=g_legal #FUN-980008 add
       CALL i007_i("a")
        IF INT_FLAG THEN                   #使用者不玩了                        
            LET INT_FLAG = 0                                                    
            LET g_skf.skf01  = NULL
            LET g_skf.skf02  = NULL 
            LET g_skf.skf03  = NULL                                                
            CALL cl_err('',9001,0)                                              
            EXIT WHILE                                                          
        END IF         
 
        IF cl_null(g_skf.skf01) OR cl_null(g_skf.skf02) OR cl_null(g_skf.skf03)  THEN
               CONTINUE WHILE
        END IF
 
        BEGIN WORK
           LET g_skf.skforiu = g_user      #No.FUN-980030 10/01/04
           LET g_skf.skforig = g_grup      #No.FUN-980030 10/01/04
           INSERT INTO skf_file VALUES(g_skf.*)
           
           IF SQLCA.sqlcode THEN
             CALL cl_err(g_skf.skf01,SQLCA.sqlcode,1)  #FUN-B80030 ADD
              ROLLBACK WORK
             # CALL cl_err(g_skf.skf01,SQLCA.sqlcode,1) #FUN-B80030 MARK 
              CONTINUE WHILE
           ELSE
              LET g_skf_t.skf01 = g_skf.skf01                   #rowid01                # 保存上筆資料 
              LET g_skf_t.skf02 = g_skf.skf02          
              LET g_skf_t.skf03 = g_skf.skf03                                           
              SELECT skf01,skf02,skf03 INTO g_skf.skf01,g_skf.skf02,g_skf.skf03 FROM skf_file                       
                   WHERE skf01 = g_skf.skf01 AND skf02=g_skf.skf02
                   AND skf03=g_skf.skf03
              COMMIT WORK 
           END IF
          
        CALL cl_flow_notify(g_skf.skf01,'I')
        LET g_rec_b=0
        CALL i007_b_fill('1=1')         #單身                                   
        CALL i007_b()                   #輸入單身
        EXIT WHILE 
      END WHILE
END FUNCTION
 
FUNCTION i007_i(p_cmd)  
   DEFINE    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改             
             l_n             LIKE type_file.num5                  #SMALLINT
             
   DISPLAY BY NAME g_skf.skfuser,g_skf.skfgrup,g_skf.skfmodu,g_skf.skfdate,g_skf.skfacti,g_skf.skf01,
                   g_skf.skf02,g_skf.skf03,g_skf.skf04,g_skf.skf07
   INPUT BY NAME g_skf.skf01,g_skf.skf02,g_skf.skf03,g_skf.skf04,
                 g_skf.skf05,g_skf.skf06,g_skf.skf07,  
                 g_skf.skfuser,g_skf.skfgrup,g_skf.skfmodu,g_skf.skfdate,g_skf.skfacti WITHOUT DEFAULTS
 
       BEFORE INPUT
         LET g_before_input_done=FALSE
         CALL i007_set_entry(p_cmd)
         CALL i007_set_no_entry(p_cmd)
         LET g_before_input_done=TRUE
          
      AFTER FIELD skf01
         IF NOT cl_null(g_skf.skf01) THEN                                    
            IF p_cmd ='a' OR (g_skf.skf01 != g_skf_t.skf01 AND p_cmd='u') THEN
            SELECT COUNT(*) INTO g_cnt FROM sfc_file,sfci_file
                  WHERE sfc01=g_skf.skf01 AND sfc_file.sfc01=sfci_file.sfci01 
                  AND sfci_file.sfcislk05 = 'Y' AND sfc_file.sfcacti='Y'
              IF g_cnt=0  THEN
                 CALL cl_err(g_skf.skf01,'ask-008',0)
                 NEXT FIELD skf01
              END IF
            END IF  
            ELSE
               NEXT FIELD skf01
         END IF   
         
       AFTER FIELD skf02
         IF NOT cl_null(g_skf.skf02) THEN                                    
            IF p_cmd ='a' OR (g_skf.skf02 != g_skf_t.skf02 AND p_cmd='u') THEN
            SELECT COUNT(*) INTO g_cnt FROM ima_file,imx_file,sfb_file
                  WHERE ima01=imx_file.imx00 AND imx_file.imx000=sfb_file.sfb05
                  AND sfb_file.sfb85=g_skf.skf01 AND ima_file.ima01=g_skf.skf02
              IF g_cnt=0  THEN 
                 CALL cl_err(g_skf.skf02,'ask-008',0)
                 DISPLAY ' ' TO FORMONLY.skf02_ima02
                 NEXT FIELD skf02
              END IF
            END IF
            CALL i007_skf02('d')  
            ELSE
               NEXT FIELD skf01
         END IF
         
       AFTER FIELD skf05
         IF NOT cl_null(g_skf.skf05) THEN          
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_skf.skf05,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_skf.skf05= g_skf_t.skf05
               NEXT FIELD skf05
            END IF
#FUN-AA0059 ---------------------end-------------------------------                          
            IF p_cmd ='a' OR (g_skf.skf05 != g_skf_t.skf05 AND p_cmd='u') THEN
            SELECT COUNT(*) INTO g_cnt FROM ima_file,imx_file,bmb_file
                  WHERE ima_file.ima01=imx_file.imx000 AND imx00=bmb_file.bmb03
                  AND bmb_file.bmb01=g_skf.skf02 AND ima_file.ima151!='Y'
                  AND ima_file.ima01=g_skf.skf05
              IF g_cnt=0  THEN
                 CALL cl_err(g_skf.skf05,'ask-008',0)
                 DISPLAY ' ' TO FORMONLY.skf05_ima02
                 NEXT FIELD skf05
              END IF
            END IF
            CALL i007_skf05('d')   
            ELSE
               NEXT FIELD skf05
         END IF   
      
       AFTER FIELD  skf03
          IF NOT cl_null(g_skf.skf02) THEN                                    
            IF p_cmd ='a' OR (g_skf.skf02 != g_skf_t.skf02 AND p_cmd='u') THEN
             IF g_skf.skf03<0 THEN
                CALL cl_err(g_skf.skf03,'afa-037',0)
                NEXT FIELD skf03
             END IF
               SELECT COUNT(*) INTO g_cnt FROM skf_file
              WHERE skf01=g_skf.skf01 AND skf02=g_skf.skf02  AND skf03=g_skf.skf03 
            IF  g_cnt>0 THEN
                CALL cl_err('','-239',0) 
                NEXT FIELD skf01 
            END IF 
           END IF 
          ELSE 
             NEXT FIELD skf03
          END IF
       
       AFTER INPUT                                                             
            IF INT_FLAG THEN                                                    
               EXIT INPUT                                                       
            END IF
            IF cl_null(g_skf.skf01) OR cl_null(g_skf.skf02) OR cl_null(g_skf.skf03)  THEN
               NEXT FIELD skf01
            END IF 
 
       ON ACTION controlz
          CALL cl_show_req_fields()
       
       ON ACTION controlg
          CALL cl_cmdask()                                                                 
                                                                                
       ON ACTION controlp
            CASE
              WHEN INFIELD(skf01)
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form     ="q_skf01"                                 
               LET g_qryparam.default1 = g_skf.skf01                          
               CALL cl_create_qry() RETURNING g_skf.skf01
               IF g_skf.skf01 IS NULL THEN                                      
                  DISPLAY g_skf_t.skf01 TO skf01                                    
               ELSE                                                            
                  DISPLAY g_skf.skf01 TO skf01                                      
               END IF 
              WHEN INFIELD(skf02)
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form     ="q_skf02"                                 
               LET g_qryparam.default1 = g_skf.skf02 
               LET g_qryparam.arg1=g_skf.skf01                         
               CALL cl_create_qry() RETURNING g_skf.skf02
               IF g_skf.skf02 IS NULL THEN                                      
                  DISPLAY g_skf_t.skf02 TO skf02                                    
               ELSE                                                            
                  DISPLAY g_skf.skf02 TO skf02                                      
               END IF 
               CALL i007_skf02('d')
              WHEN INFIELD(skf05)
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form     ="q_skf05"                                 
               LET g_qryparam.default1 = g_skf.skf05
                LET g_qryparam.arg1=g_skf.skf02                          
               CALL cl_create_qry() RETURNING g_skf.skf05
               IF g_skf.skf05 IS NULL THEN                                      
                  DISPLAY g_skf_t.skf05 TO skf05                                    
               ELSE                                                            
                  DISPLAY g_skf.skf05 TO skf05                                      
               END IF 
               CALL i007_skf05('d')                                                             
          END CASE                           
      
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT                                                        
                                                                                
    END INPUT                                                                   
END FUNCTION               
 
FUNCTION i007_q()
   
    LET g_row_count = 0                                                         
    LET g_curs_index = 0                                                        
    CALL cl_navigator_setting( g_curs_index, g_row_count )                      
    INITIALIZE g_skf.skf01,g_skf.skf03,g_skf.skf03 TO NULL
    CALL cl_opmsg('q')                                                          
    MESSAGE ""                                                                  
    CLEAR FORM                                                                  
    CALL g_skg.clear() 
    DISPLAY ' ' TO FORMONLY.cnt
                                                             
    CALL i007_cs()
    IF INT_FLAG THEN                         #使用者不玩了                      
        LET INT_FLAG = 0                                                        
        RETURN                                                                  
    END IF                                                                      
    OPEN i007_b_cs                           #從DB產生合乎條件TEMP(0-30秒)      
    IF SQLCA.sqlcode THEN                    #有問題                            
        CALL cl_err('',SQLCA.sqlcode,0)                                         
        INITIALIZE g_skf.skf01,g_skf.skf02,g_skf.skf03 TO NULL                             
    ELSE                                                                        
        OPEN i007_count                                                         
        FETCH i007_count INTO g_row_count                                       
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i007_fetch('F')                 #讀出TEMP第一筆并顯示                                      
    END IF                                                                      
END FUNCTION
 
FUNCTION i007_fetch(p_flag)                                                     
DEFINE                                                                          
    p_flag          LIKE type_file.chr1                  #處理方式
   
    MESSAGE ""                                                                  
    CASE p_flag                                                                 
        WHEN 'N' FETCH NEXT     i007_b_cs INTO g_skf.skf01,
                                               g_skf.skf02,g_skf.skf03         
        WHEN 'P' FETCH PREVIOUS i007_b_cs INTO g_skf.skf01,
                                              #g_skf.skf01,g_skf.skf03     
                                               g_skf.skf02,g_skf.skf03   #TQC-8C0072 
        WHEN 'F' FETCH FIRST    i007_b_cs INTO g_skf.skf01,
                                               #g_skf.skf01,g_skf.skf03     
                                               g_skf.skf02,g_skf.skf03   #TQC-8C0072
        WHEN 'L' FETCH LAST     i007_b_cs INTO g_skf.skf01,
                                               #g_skf.skf01,g_skf.skf03
                                               g_skf.skf02,g_skf.skf03    #TQC-8C0072     
        WHEN '/'                                                                
            IF (NOT g_no_ask) THEN                                             
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg                   
               LET INT_FLAG = 0  ######add for prompt bug                       
               PROMPT g_msg CLIPPED,': ' FOR g_jump                             
                  ON IDLE g_idle_seconds                                        
                     CALL cl_on_idle()                                          
                                                                                
               END PROMPT                                                       
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF               
            END IF                                                              
            FETCH ABSOLUTE g_jump i007_b_cs INTO  g_skf.skf01, g_skf.skf02,
                           g_skf.skf03       
            LET g_no_ask = FALSE                                               
    END CASE 
    
    IF SQLCA.sqlcode THEN                         #有麻煩                       
        CALL cl_err(g_skf.skf01,SQLCA.sqlcode,0)                               
        INITIALIZE g_skf.skf01,g_skf.skf02,g_skf.skf03 TO NULL 
        RETURN                            
    ELSE
        CASE p_flag                                                             
           WHEN 'F' LET g_curs_index = 1                                        
           WHEN 'P' LET g_curs_index = g_curs_index - 1                         
           WHEN 'N' LET g_curs_index = g_curs_index + 1                         
           WHEN 'L' LET g_curs_index = g_row_count                              
           WHEN '/' LET g_curs_index = g_jump                                   
        END CASE
     
        CALL cl_navigator_setting( g_curs_index, g_row_count )                 
    END IF
    SELECT * INTO g_skf.* FROM skf_file WHERE skf01 =g_skf.skf01 AND skf02 = g_skf.skf02 AND skf03 = g_skf.skf03
    IF SQLCA.sqlcode THEN                         #有麻煩                       
        CALL cl_err(g_skf.skf01,SQLCA.sqlcode,0)                                
        INITIALIZE g_skf.skf01,g_skf.skf02,g_skf.skf03 TO NULL                              
        RETURN                                                                  
    END IF
    CALL  i007_show()               
END FUNCTION 
 
#將資料顯示在畫面上                                                             
FUNCTION i007_show()
   
   DISPLAY BY NAME g_skf.skf01,g_skf.skf02,g_skf.skf03,g_skf.skf04,g_skf.skf05,        
                   g_skf.skf06, g_skf.skf07,                                             #單頭
                   g_skf.skfuser,g_skf.skfgrup,g_skf.skfmodu,g_skf.skfdate,g_skf.skfacti
      CALL i007_skf02('d')
      CALL i007_skf05('d')
      CALL i007_b_fill(g_wc2)              #單身 
      CALL i007_show_pic()
      CALL cl_show_fld_cont()                                   
END FUNCTION
 
FUNCTION i007_r()                                                               
  DEFINE                                                                        
    l_skf03      LIKE skf_file.skf03                                            
    IF s_shut(0) THEN RETURN END IF                                             
    IF cl_null(g_skf.skf01) OR cl_null(g_skf.skf03) THEN   
        CALL cl_err('',-400,0)                                                  
        RETURN                                                                  
    END IF    
 
    SELECT * INTO g_skf.* FROM skf_file                                         
        WHERE skf01=g_skf.skf01 
         AND  skf02=g_skf.skf02                                            
         AND  skf03=g_skf.skf03                                              
    IF g_skf.skfacti='N' THEN                                                   
         CALL cl_err(g_skf.skf01,'mfg1000',0)                                   
         RETURN                                                                 
    END IF 
    IF g_skf.skf07='Y' THEN 
         CALL  cl_err('',9023,0)
         RETURN
    END IF
   
    BEGIN WORK
    
    OPEN i007_crl USING g_skf.skf01,g_skf.skf02,g_skf.skf03
    IF STATUS THEN
       CALL cl_err("OPEN i007_cl:",STATUS,1)
       CLOSE i007_crl
       ROLLBACK WORK
       RETURN
    END IF
   
    FETCH i007_crl INTO g_skf.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_skf.skf01,SQLCA.sqlcode,0)
        CLOSE i007_crl
        ROLLBACK WORK
        RETURN
    END IF
    
    CALL i007_show()
                                                                     
    IF cl_delh(0,0) THEN                   #確認一下         
         DELETE FROM skf_file WHERE skf01=g_skf.skf01 AND skf02=g_skf.skf02 AND skf03=g_skf.skf03
         DELETE FROM skg_file WHERE skg01=g_skf.skf01 AND skg02=g_skf.skf02 AND skg03=g_skf.skf03 
         CLEAR FORM
         CALL g_skg.clear()                                                  
         LET g_cnt=SQLCA.SQLERRD[3]                                          
         LET g_delete = 'Y'                                                  
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'                   
         OPEN i007_count                                                     
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i007_b_cs
            CLOSE i007_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i007_count INTO g_row_count                                   
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i007_b_cs
            CLOSE i007_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt                                 
         OPEN i007_b_cs                                                      
         IF g_curs_index = g_row_count + 1 THEN                              
            LET g_jump = g_row_count                                         
         CALL i007_fetch('L')                                             
         ELSE                                                                
           LET g_jump = g_curs_index                                        
           LET g_no_ask = TRUE                                             
           CALL i007_fetch('/')                                             
         END IF    
      END IF
  
   COMMIT WORK                                                                 
   CALL cl_flow_notify(g_skf.skf01,'D')                                            
                                                                                
END FUNCTION      
 
#單身                                                                           
FUNCTION i007_b()                                                               
DEFINE                                                                          
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT      
    l_n,l_n1,l_n2   LIKE type_file.num5,                #檢查重復用        
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
    p_cmd           LIKE type_file.chr1,                #處理狀態        
    l_allow_insert  LIKE type_file.num5,                #可新增否
    l_allow_delete  LIKE type_file.num5,                #可刪除否
    l_acti          LIKE skf_file.skfacti,
    l_m             LIKE type_file.num5,
    l_arg1          LIKE type_file.chr1000
   
    
    LET g_action_choice = ""  
    
    IF s_shut(0) OR g_skf.skf07="Y"  THEN RETURN END IF                                                   
               
    IF cl_null(g_skf.skf01) OR cl_null(g_skf.skf02) OR cl_null(g_skf.skf03) THEN               
        RETURN                                                                  
    END IF 
    
    SELECT skfacti INTO l_acti                                                  
           FROM skf_file WHERE skf01 = g_skf.skf01 AND skf02= g_skf.skf02 
                         AND skf03= g_skf.skf03                                  
    IF l_acti = 'N'  OR l_acti = 'n' THEN                                                                               
           CALL cl_err(g_skf.skf01,'mfg1000',0)                                       
    END IF                                                                      
                                                                                
    CALL cl_opmsg('b') 
    
    SELECT COUNT(*) INTO g_cnt FROM skg_file WHERE skg01 = g_skf.skf01
                                               AND skg02 = g_skf.skf02
                                               AND skg03 = g_skf.skf03
    IF g_cnt = 0 THEN                                            
      CALL i007_auto_b('a')  
    END IF 
    
    LET l_allow_insert = cl_detail_input_auth("insert")                         
    LET l_allow_delete = cl_detail_input_auth("delete")                         
                                                                                
    LET g_forupd_sql = "SELECT skg04,skg05,skg06,skg07,skg12,skg08,skg09,skg10,skg11",  
                       " FROM skg_file ",         
                       "  WHERE skg01=  ? AND skg02 = ? AND skg03=?", 
                       " AND skg04=? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i007_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR  
   
    IF g_rec_b=0 THEN CALL g_skg.clear() END IF 
   
    INPUT ARRAY g_skg WITHOUT DEFAULTS FROM s_skg.*                             
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
                    
    BEFORE INPUT                                                            
            IF g_rec_b!=0 THEN                                                  
               CALL fgl_set_arr_curr(l_ac)                                      
            END IF
    CALL cl_set_comp_visible("skg05,skg06,skg07",TRUE)        
    CALL i007_b_title()                            
                
    BEFORE ROW                                                              
            LET p_cmd=''                                                        
            LET l_ac = ARR_CURR()                                               
            LET l_lock_sw = 'N'            #DEFAULT                             
            LET l_n1  = ARR_COUNT()                                              
                                                                                
            BEGIN WORK
            OPEN i007_crl USING g_skf.skf01,g_skf.skf02,g_skf.skf03
            IF STATUS THEN
               CALL cl_err("OPEN i007_crl:",STATUS,1)
               CLOSE i007_crl                                                   
               ROLLBACK WORK                                                    
               RETURN                                                           
            END IF                                                              
                                                                                
            FETCH i007_crl INTO g_skf.*                                         
            IF SQLCA.sqlcode THEN                                               
                CALL cl_err(g_skf.skf01,SQLCA.sqlcode,0)                        
                ROLLBACK WORK 
                CLOSE i007_crl                                                  
                RETURN                                                          
            END IF      
            
            IF g_rec_b >= l_ac THEN                                             
                LET p_cmd='u'                                                   
                LET g_skg_t.* = g_skg[l_ac].*  #BACKUP                          
                OPEN i007_bcl USING g_skf.skf01,g_skf.skf02,g_skf.skf03,g_skg_t.skg04
                IF STATUS THEN
                   CALL cl_err("OPEN i007_bcl:",STATUS,1)                     
                   LET l_lock_sw = "Y"                                          
                ELSE                                                            
                   FETCH i007_bcl INTO g_skg[l_ac].*                            
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_skg_t.skg04,SQLCA.sqlcode,1)               
                       LET l_lock_sw = "Y"                                      
                   END IF
                END IF   
            END IF
        
       BEFORE INSERT                                                           
            LET l_n1 = ARR_COUNT()                                               
            LET p_cmd='a'                                                       
            INITIALIZE g_skg[l_ac].* TO NULL                             
            LET g_skg_t.* = g_skg[l_ac].*         #新輸入資料                 
            CALL cl_show_fld_cont()                            
            NEXT FIELD skg04
 
       AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF
            SELECT count(*)                                                     
                 INTO l_n                                                       
                 FROM skg_file                                    
                              
                 WHERE skg01=g_skf.skf01 
                  AND  skg02=g_skf.skf02                                       
                  AND  skg03=g_skf.skf03                                        
                  AND  skg04=g_skg[l_ac].skg04
               IF l_n>0 THEN                                                    
                  CALL cl_err('',-239,0)                                        
                  LET g_skg[l_ac].skg04=g_skg_t.skg04
                  NEXT FIELD skg04                                              
               END IF
           INSERT INTO skg_file(skg01,skg02,skg03,skg04,skg05,skg06,skg07,skg12,
                                 skg08,skg09,skg10,skg11,skgplant,skglegal) #FUN-980008 add skgplant,skglegal
            VALUES(g_skf.skf01,g_skf.skf02,g_skf.skf03,g_skg[l_ac].skg04,
                   g_skg[l_ac].skg05,g_skg[l_ac].skg06,g_skg[l_ac].skg07,g_skg[l_ac].skg12,
                   g_skg[l_ac].skg08,g_skg[l_ac].skg09,
                   g_skg[l_ac].skg10,g_skg[l_ac].skg11,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cnt2
            END IF
        
        BEFORE FIELD skg04
           IF p_cmd='a'  THEN
              SELECT max(skg04)+1
                 INTO g_skg[l_ac].skg04
                 FROM skg_file
                 WHERE skg01=g_skf.skf01 AND skg02=g_skf.skf02
                 AND skg03=g_skf.skf03
             IF g_skg[l_ac].skg04 IS NULL THEN
                 LET g_skg[l_ac].skg04=1
             END IF
           END IF 
        
        AFTER FIELD skg04
         IF p_cmd='a' OR (p_cmd = 'u' AND g_skg[l_ac].skg04 != g_skg_t.skg04) THEN 
          SELECT COUNT(*) INTO l_n FROM skg_file
             WHERE skg01=g_skf.skf01 AND skg02=g_skf.skf02
                 AND skg03=g_skf.skf03 AND skg04 = g_skg[l_ac].skg04
          IF l_n >0 THEN 
              CALL cl_err('','-239',0)
              LET g_skg[l_ac].skg04 = g_skg_t.skg04
              NEXT FIELD skg04
          END IF 
         END IF 
                     
        AFTER FIELD skg05 
           IF NOT cl_null(g_skg[l_ac].skg05) THEN
              IF p_cmd="a" OR (p_cmd="u" AND g_skg[l_ac].skg05!=g_skg_t.skg05) THEN
               SELECT count(*)
                 INTO l_n
                 FROM agb_file,aga_file,agc_file,agd_file,ima_file
                 WHERE (agd_file.agd02=g_skg[l_ac].skg05 AND agd_file.agd01=agc_file.agc01 
                 AND agc_file.agc04='2' AND agc_file.agc01=agb_file.agb03 
                 AND agb_file.agb02=1 AND agb_file.agb01=aga_file.aga01
                 AND aga_file.aga01=ima_file.imaag AND ima_file.ima01=g_skf.skf02)
                 OR((g_skg[l_ac].skg05 between agc_file.agc05 and agc_file.agc06) 
                 AND agc_file.agc04='3' AND agc_file.agc01=agb_file.agb03 
                 AND agb_file.agb02=1 AND agb_file.agb01=aga_file.aga01
                 AND aga_file.aga01=ima_file.imaag AND ima_file.ima01=g_skf.skf02)
                 OR (agc_file.agc04='1' AND agc_file.agc01=agb_file.agb03 AND agb_file.agb02=1 
                 AND agb_file.agb01=aga_file.aga01 AND aga_file.aga01=ima_file.imaag 
                 AND ima_file.ima01=g_skf.skf02)
               IF l_n=0 THEN
                  CALL cl_err('','ask-008',0)
                  LET g_skg[l_ac].skg05=g_skg_t.skg05
                  NEXT FIELD skg05
               END IF
             END IF
             ELSE
               NEXT FIELD skg05
          END IF 
      
         AFTER FIELD skg06
           IF NOT cl_null(g_skg[l_ac].skg06) THEN
              IF p_cmd="a" OR (p_cmd="u" AND g_skg[l_ac].skg06!=g_skg_t.skg06) THEN
               SELECT count(*)
                 INTO l_n
                 FROM agb_file,aga_file,agc_file,agd_file,ima_file
                 WHERE (agd_file.agd02=g_skg[l_ac].skg06 AND agd_file.agd01=agc_file.agc01 
                 AND agc_file.agc04='2' AND agc_file.agc01=agb_file.agb03 
                 AND agb_file.agb02=2 AND agb_file.agb01=aga_file.aga01
                 AND aga_file.aga01=ima_file.imaag AND ima_file.ima01=g_skf.skf02)
                 OR((g_skg[l_ac].skg06 between agc_file.agc05 and agc_file.agc06) 
                 AND agc_file.agc04='3' AND agc_file.agc01=agb_file.agb03 
                 AND agb_file.agb02=2 AND agb_file.agb01=aga_file.aga01
                 AND aga_file.aga01=ima_file.imaag AND ima_file.ima01=g_skf.skf02)
                 OR (agc_file.agc04='1' AND agc_file.agc01=agb_file.agb03 AND agb_file.agb02=2 
                 AND agb_file.agb01=aga_file.aga01 AND aga_file.aga01=ima_file.imaag 
                 AND ima_file.ima01=g_skf.skf02)
               IF l_n=0 THEN
                  CALL cl_err('','ask-008',0)
                  LET g_skg[l_ac].skg06=g_skg_t.skg06
                  NEXT FIELD skg06
               END IF
             END IF
             ELSE
               NEXT FIELD skg06
          END IF 
          
           AFTER FIELD skg07
           IF NOT cl_null(g_skg[l_ac].skg07) THEN
              IF p_cmd="a" OR (p_cmd="u" AND g_skg[l_ac].skg07!=g_skg_t.skg07) THEN
               SELECT count(*)
                 INTO l_n
                 FROM agb_file,aga_file,agc_file,agd_file,ima_file
                 WHERE (agd_file.agd02=g_skg[l_ac].skg07 AND agd_file.agd01=agc_file.agc01 
                 AND agc_file.agc04='2' AND agc_file.agc01=agb_file.agb03 
                 AND agb_file.agb02=3 AND agb_file.agb01=aga_file.aga01
                 AND aga_file.aga01=ima_file.imaag AND ima_file.ima01=g_skf.skf02)
                 OR((g_skg[l_ac].skg07 between agc_file.agc05 and agc_file.agc06) 
                 AND agc_file.agc04='3' AND agc_file.agc01=agb_file.agb03 
                 AND agb_file.agb02=3 AND agb_file.agb01=aga_file.aga01
                 AND aga_file.aga01=ima_file.imaag AND ima_file.ima01=g_skf.skf02)
                 OR (agc_file.agc04='1' AND agc_file.agc01=agb_file.agb03 AND agb_file.agb02=3
                 AND agb_file.agb01=aga_file.aga01 AND aga_file.aga01=ima_file.imaag 
                 AND ima_file.ima01=g_skf.skf02)
               IF l_n=0 THEN
                  CALL cl_err('','ask-008',0)
                  LET g_skg[l_ac].skg07=g_skg_t.skg07
                  NEXT FIELD skg07
               END IF
             END IF
             ELSE
               NEXT FIELD skg07
          END IF
        
        AFTER FIELD skg12
          CALL i007_skg12_arg1()   RETURNING l_arg1
          IF NOT cl_null(g_skg[l_ac].skg07) THEN
              IF p_cmd="a" OR (p_cmd="u" AND g_skg[l_ac].skg12!=g_skg_t.skg12) THEN
              SELECT COUNT(*)
                 INTO l_n
                 FROM sfb_file,sfa_file     #No.FUN-870117
                 WHERE sfb05=l_arg1 AND sfb_file.sfb85=g_skf.skf01 AND sfb_file.sfb04 !='8'
                 AND sfb_file.sfb87='Y' AND sfb_file.sfbacti='Y' 
                 AND sfb_file.sfb01=g_skg[l_ac].skg12
                 AND sfa01 =sfb01 AND sfa03 = g_skf.skf05  #No.FUN-870117
                 IF l_n=0 THEN
                     CALL cl_err('','ask-008',0)
                  LET g_skg[l_ac].skg12=g_skg_t.skg12
                  NEXT FIELD skg12
                 END IF
                 SELECT COALESCE(SUM(skg09),0) INTO l_n FROM skg_file ,skf_file                                                                     #No.FUN-840001
                   WHERE skg_file.skg12 = g_skg[l_ac].skg12 AND skf_file.skf01 = skg_file.skg01
                     AND skf_file.skf02 = skg_file.skg02 AND skf_file.skf03 = skg_file.skg03 
                     AND skf_file.skfacti = 'Y'                                           
                 SELECT COALESCE((sfb08 - l_n),0) INTO g_skg[l_ac].skg09 from sfb_file WHERE sfb_file.sfb01=g_skg[l_ac].skg12
                 IF g_skg[l_ac].skg09 = 0 THEN 
                    CALL cl_err('','ask-053',0)
                    NEXT FIELD skg12
                 ELSE    
                    DISPLAY BY NAME g_skg[l_ac].skg09
                 END IF     
              END IF
           END IF  
                  
        AFTER FIELD skg08
           IF NOT cl_null(g_skg[l_ac].skg08)  THEN
             IF (g_skg[l_ac].skg08<0)  THEN
                 CALL cl_err(g_skg[l_ac].skg08,'afa-070',0)
                 NEXT FIELD skg08
             END IF         
           END IF
           IF p_cmd='a' OR (p_cmd = 'u' AND g_skg[l_ac].skg08 != g_skg_t.skg08) THEN 
            SELECT COUNT(*) INTO l_n FROM skg_file
               WHERE skg01=g_skf.skf01 AND skg02=g_skf.skf02
                 AND skg03=g_skf.skf03 AND skg08 = g_skg[l_ac].skg08
                 AND skg05 = g_skg[l_ac].skg05  AND skg06 = g_skg[l_ac].skg06
                 AND skg12 = g_skg[l_ac].skg12    
                 AND skg07 = g_skg[l_ac].skg07
               IF l_n >0 THEN 
                  CALL cl_err('','-239',0)
                  LET g_skg[l_ac].skg08 = g_skg_t.skg08
                  NEXT FIELD skg08
               END IF 
           END IF 
        
        AFTER FIELD skg09
           IF NOT cl_null(g_skg[l_ac].skg09)  THEN
               IF (g_skg[l_ac].skg09<=0) THEN
                 CALL cl_err('g_skg[l_ac].skg09','aim-223',0)
                 NEXT FIELD skg09
               END IF
           END IF
          IF g_skg_t.skg09 IS NULL  THEN
             SELECT COALESCE(SUM(skg09)+ g_skg[l_ac].skg09,0) INTO l_n FROM skg_file ,skf_file                                                                     #No.FUN-840001
                   WHERE skg_file.skg12 = g_skg[l_ac].skg12 AND skf_file.skf01 = skg_file.skg01
                     AND skf_file.skf02 = skg_file.skg02 AND skf_file.skf03 = skg_file.skg03 
                     AND skf_file.skfacti = 'Y'
           ELSE 
             SELECT COALESCE(sum(skg09) + g_skg[l_ac].skg09-g_skg_t.skg09,0) INTO l_n FROM skg_file ,skf_file
               WHERE skg_file.skg12 = g_skg[l_ac].skg12 AND skf_file.skf01 = skg_file.skg01
                     AND skf_file.skf02 = skg_file.skg02 AND skf_file.skf03 = skg_file.skg03 
                     AND skf_file.skfacti = 'Y' 
                     AND skf_file.skf05 = g_skf.skf05   #NO.FUN-870117
           END IF    
            
           SELECT COALESCE(sfb08,0) INTO l_m FROM sfb_file
             WHERE sfb01=g_skg[l_ac].skg12
           IF (l_m<l_n) THEN
                CALL cl_err('','ask-009',1)
                LET g_skg[l_ac].skg09 = g_skg_t.skg09
                NEXT FIELD skg09
           END IF
                    
        BEFORE DELETE
          IF g_skg_t.skg04 IS NOT NULL AND g_skg_t.skg05 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
             END IF
             IF l_lock_sw="Y"  THEN
                 CALL cl_err("",-263,1)
                 CANCEL DELETE
             END IF
             DELETE FROM skg_file
                WHERE  skg01=g_skf.skf01 AND skg03=g_skf.skf03                 
                AND skg04=g_skg_t.skg04 AND skg05=g_skg_t.skg05
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                       
                  CALL cl_err('',SQLCA.sqlcode,0)                               
                  ROLLBACK WORK
                  CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1 
             DISPLAY g_rec_b TO FORMONLY.cnt2
          END IF
          COMMIT WORK 
        
        ON ROW CHANGE 
          IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG=0
              LET g_skg[l_ac].*=g_skg_t.*
              CLOSE i007_bcl
              ROLLBACK WORK
              EXIT INPUT
          END IF
          IF l_lock_sw='Y' THEN
              CALL cl_err(g_skg[l_ac].skg04,-263,1)
              LET g_skg[l_ac].*=g_skg_t.* 
          ELSE
              UPDATE skg_file SET skg04=g_skg[l_ac].skg04,
                                  skg05=g_skg[l_ac].skg05,
                                  skg06=g_skg[l_ac].skg06,
                                  skg07=g_skg[l_ac].skg07,
                                  skg12=g_skg[l_ac].skg12,  
                                  skg08=g_skg[l_ac].skg08,
                                  skg09=g_skg[l_ac].skg09,
                                  skg10=g_skg[l_ac].skg10,
                                  skg11=g_skg[l_ac].skg11
              WHERE  skg01=g_skf.skf01 AND skg02=g_skf.skf02
                     AND skg03=g_skf.skf03 AND skg04=g_skg_t.skg04
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_skg[l_ac].*=g_skg_t.* 
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
          LET l_ac=ARR_CURR()
#         LET l_ac_t=l_ac         #FUN-D40030 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             IF p_cmd='u' THEN
                LET g_skg[l_ac].*=g_skg_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_skg.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF  
             CLOSE i007_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac      #FUN-D40030 add
          CLOSE i007_bcl
          COMMIT WORK
 
        ON ACTION CONTROLP
          CASE                                                                  
            WHEN INFIELD(skg05)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_skg05"                           
                 LET g_qryparam.construct = "Y"                                 
                 LET g_qryparam.default1  = g_skg[l_ac].skg05 
                 LET g_qryparam.arg1=g_skf.skf02
                 CALL cl_create_qry() RETURNING g_skg[l_ac].skg05
                 CALL FGL_DIALOG_SETBUFFER(g_skg[l_ac].skg05)
                 NEXT FIELD skg05
            WHEN INFIELD(skg06)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_skg06"                           
                 LET g_qryparam.construct = "Y"                                 
                 LET g_qryparam.default1  = g_skg[l_ac].skg06
                 LET g_qryparam.arg1=g_skf.skf02
                 CALL cl_create_qry() RETURNING g_skg[l_ac].skg06
                 CALL FGL_DIALOG_SETBUFFER(g_skg[l_ac].skg06)
                 NEXT FIELD skg06
            WHEN INFIELD(skg07)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_skg07"                           
                 LET g_qryparam.construct = "Y"                                 
                 LET g_qryparam.default1  = g_skg[l_ac].skg07
                 LET g_qryparam.arg1=g_skf.skf02
                 CALL cl_create_qry() RETURNING g_skg[l_ac].skg07
                 CALL FGL_DIALOG_SETBUFFER(g_skg[l_ac].skg07)
                 NEXT FIELD skg07
            WHEN INFIELD(skg12)                                                 
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form      = "q_skg12"                           
                 LET g_qryparam.construct = "Y"                                 
                 CALL i007_skg12_arg1() RETURNING g_skg12_arg1
                 LET g_qryparam.arg1=g_skg12_arg1
                 LET g_qryparam.arg2=g_skf.skf01
                 LET g_qryparam.arg3=g_skf.skf05
                 CALL cl_create_qry() RETURNING g_skg[l_ac].skg12
                 CALL FGL_DIALOG_SETBUFFER(g_skg[l_ac].skg12)
                 NEXT FIELD skg12
                        
           END CASE
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
        
         ON ACTION CONTROLO
          IF INFIELD (skg04) AND l_ac >1 THEN 
             LET g_skg[l_ac].* = g_skg[l_ac-1].*
             LET g_skg[l_ac].skg04 = g_rec_b+1
             NEXT FIELD  skg04
          END IF    
                                                                                  
        ON ACTION CONTROLG                                                      
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT                                                        
                                                                                
    END INPUT
    
    CLOSE i007_bcl
    COMMIT WORK
    CALL i007_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i007_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM skf_file WHERE skf01 = g_skf.skf01
                                AND skf02 = g_skf.skf02
                                AND skf03 = g_skf.skf03
         INITIALIZE g_skf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i007_b_askkey()                                                        
DEFINE                                                                          
    l_wc           STRING       #NO.FUN-910082 
   
    CONSTRUCT l_wc ON skg04,skg05,skg06,skg07,skg12,skg08,skg09.skg10,skg11
                   FROM  s_skg[1].skg04,s_skg[1].skg05,s_skg[1].skg06,s_skg[1].skg07,
                         s_skg[1].skg12,s_skg[1].skg08,s_skg[1].skg09,s_skg[1].skg10,
                         s_skg[1].skg08,s_skg[1].skg09,s_skg[1].skg10,    
                         s_skg[1].skg11
 
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
      
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('skfuser', 'skfgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF                                              
    CALL i007_b_fill(l_wc)                                                      
                                                                                
END FUNCTION             
 
FUNCTION i007_b_fill(p_wc)              #BODY FILL UP                           
DEFINE                                                                          
    p_wc            STRING,       #NO.FUN-910082 
    l_i             LIKE type_file.num5,
    l_j             LIKE type_file.num5,
    l_msg           LIKE type_file.chr1000,
    l_mag           LIKE type_file.chr1000,
    l_chr           LIKE type_file.chr3
    
    LET g_sql =                                                                 
       " SELECT skg04,skg05,skg06,skg07,skg12,skg08,skg09,skg10,skg11",
       " FROM skg_file",
       " WHERE skg01='",g_skf.skf01,"'",
       " AND skg02='",g_skf.skf02,"'",
       " AND skg03='",g_skf.skf03,"'"
    IF NOT cl_null(p_wc) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED 
    DISPLAY g_sql
 
    PREPARE i007_prepare2 FROM g_sql      #預備一下                             
    DECLARE sgi_cs CURSOR FOR i007_prepare2   
    CALL cl_set_comp_visible("skg05,skg06,skg07",TRUE)
    
    CALL i007_b_title()              
                                                                                
    CALL g_skg.clear()                                                          
                                                                                
    LET g_cnt = 1 
  
    FOREACH sgi_cs INTO g_skg[g_cnt].*   #單身 ARRAY 填充                       
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                             
            EXIT FOREACH                                                        
        END IF 
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN                                              
           CALL cl_err('',9035,0)                                             
           EXIT FOREACH                                                        
        END IF                                                                    
        END FOREACH                                                                 
    CALL g_skg.deleteElement(g_cnt)                                             
    LET g_rec_b=g_cnt-1                                                         
                                                                                
    DISPLAY g_rec_b TO FORMONLY.cnt2                                            
    LET g_cnt = 0                                                               
                                                                                
END FUNCTION 
                  
FUNCTION i007_bp(p_ud)                                                          
   DEFINE   p_ud   LIKE type_file.chr1
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF
 
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_skg TO s_skg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  
   BEFORE DISPLAY                                                            
       CALL cl_navigator_setting( g_curs_index, g_row_count )                 
                                                                                
   BEFORE ROW                                                                
       LET l_ac = ARR_CURR() 
 
   ##########################################################################
   # Standard 4ad ACTION                                                     
   ##########################################################################
    ON ACTION insert                                                          
         LET g_action_choice="insert"                                           
         EXIT DISPLAY                                                           
    ON ACTION query                                                           
         LET g_action_choice="query"                                            
         EXIT DISPLAY                                                           
    ON ACTION delete                                                          
         LET g_action_choice="delete"                                           
         EXIT DISPLAY  
    ON ACTION first                                                           
         CALL i007_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
    ON ACTION previous                                                        
         CALL i007_fetch('P')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY                        
    
    ON ACTION modify                                                          
         LET g_action_choice="modify"                                           
         EXIT DISPLAY
 
    ON ACTION invalid                                                         
         LET g_action_choice="invalid"                                          
         EXIT DISPLAY 
         
    ON ACTION reproduce                                                         
         LET g_action_choice="reproduce"                                          
         EXIT DISPLAY 
          
    ON ACTION jump                                                            
         CALL i007_fetch('/')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1) 
         ACCEPT DISPLAY
 
     ON ACTION next                                                            
         CALL i007_fetch('N')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1) 
         ACCEPT DISPLAY                          
      
     ON ACTION last                                                            
         CALL i007_fetch('L')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(1) 
         ACCEPT DISPLAY                         
                                                                                
      ON ACTION detail                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = 1                                                           
         EXIT DISPLAY  
         
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 
         
      ON ACTION notconfirm                                                      
         LET g_action_choice="notconfirm"                                       
         EXIT DISPLAY  
      
      ON ACTION auto_b                                                     
         LET g_action_choice="auto_b"                                       
         EXIT DISPLAY                                       

      ON ACTION help                                                            
         LET g_action_choice="help"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION locale
         CALL cl_dynamic_locale()
     
      ON ACTION exit                                                            
         LET g_action_choice="exit"                                             
         EXIT DISPLAY 
 
      ##########################################################################
      # Special 4ad ACTION                                                      
      ##########################################################################
      
      ON ACTION controlg                                                        
         LET g_action_choice="controlg"                                         
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel                                                          
         LET INT_FLAG=FALSE                                 
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE DISPLAY  
     
      ON ACTION exporttoexcel                                                   
         LET g_action_choice = 'exporttoexcel'                                  
         EXIT DISPLAY
 
    END DISPLAY                                                                  
    CALL cl_set_act_visible("accept,cancel", TRUE)                               
END FUNCTION   
 
FUNCTION i007_x()                                                               
                                                                                
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   IF g_skf.skf01 IS NULL OR g_skf.skf03 IS NULL  THEN                    
      CALL cl_err("",-400,0)                                                    
      RETURN                                                                    
   END IF
   IF g_skf.skf07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF            
   BEGIN WORK                                                                   
                                                                                
   OPEN i007_crl USING g_skf.skf01,g_skf.skf02,g_skf.skf03                                              
   IF STATUS THEN                                                               
      CALL cl_err("OPEN i007_crl:", STATUS, 1)                                  
      CLOSE i007_crl                                                            
      ROLLBACK WORK                                                             
      RETURN                                                                    
   END IF 
 
   FETCH i007_crl INTO g_skf.*             #鎖住將被更改或取消的資料           
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_skf.skf01,SQLCA.sqlcode,0)          #資料被他人LOCK         
      ROLLBACK WORK                                                             
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_success = 'Y'                                                          
                                                                                
   CALL i007_show()
 
   IF cl_exp(0,0,g_skf.skfacti) THEN        #確認一下                           
      LET g_chr=g_skf.skfacti                                                   
      IF g_skf.skfacti='Y' THEN                                                 
         LET g_skf.skfacti='N'                                                  
      ELSE                                                                      
         LET g_skf.skfacti='Y'                                                  
      END IF                                                                    
                                                                                
      UPDATE skf_file SET skfacti=g_skf.skfacti,                                
                          skfmodu=g_user,                                       
                          skfdate=g_today                                       
       WHERE skf01=g_skf.skf01 AND skf03=g_skf.skf03                                                  
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                               
         CALL cl_err3("upd","skf_file",g_skf.skf01,"",SQLCA.sqlcode,"","",1)    
         LET g_skf.skfacti=g_chr                                                
      END IF                                                                    
   END IF
   
   IF g_success = 'Y' THEN                                                      
      COMMIT WORK                                                               
      CALL cl_flow_notify(g_skf.skf01,'V')                                      
   ELSE                                                                         
      ROLLBACK WORK                                                             
   END IF                                                                       
                                                                                
   SELECT skfacti,skfmodu,skfdate                                               
     INTO g_skf.skfacti,g_skf.skfmodu,g_skf.skfdate FROM skf_file               
   WHERE skf01=g_skf.skf01 AND skf03=g_skf.skf03            
   DISPLAY BY NAME g_skf.skfacti,g_skf.skfmodu,g_skf.skfdate                    
END FUNCTION
 
FUNCTION i007_u()                                                               
                                                                                
   IF s_shut(0) THEN                                                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   IF g_skf.skf01 IS NULL OR g_skf.skf03 IS NULL THEN                    
      CALL cl_err('',-400,0)                                                    
      RETURN                                                                    
   END IF                                                                       
                                                                                
   SELECT * INTO g_skf.* FROM skf_file                                          
    WHERE skf01=g_skf.skf01 AND skf02=g_skf.skf02 AND skf03=g_skf.skf03                         
                                                                                
   IF g_skf.skfacti ='N' THEN    #檢查資料是否為無效                            
      CALL cl_err(g_skf.skf01,'mfg1000',0)                                      
      RETURN                                                                    
   END IF
 
   IF g_skf.skf07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF              
   MESSAGE ""                                                                   
   CALL cl_opmsg('u')                                                           
   LET g_skf_t.skf01 = g_skf.skf01
   LET g_skf_t.skf02 = g_skf.skf02
   LET g_skf_t.skf03 = g_skf.skf03                                                   
   BEGIN WORK                                                                   
                                                                                
   OPEN i007_crl USING g_skf.skf01,g_skf.skf02,g_skf.skf03 
 
   IF STATUS THEN                                                               
      CALL cl_err("OPEN i007_crl:", STATUS, 1)                                  
      CLOSE i007_crl                                                            
      ROLLBACK WORK                                                             
      RETURN                                                                    
   END IF
  
    FETCH i007_crl INTO g_skf.*                      # 鎖住將被更改或取消的資料   
   IF SQLCA.sqlcode THEN                                                        
       CALL cl_err(g_skf.skf01,SQLCA.sqlcode,0)    # 資料被他人LOCK             
       CLOSE i007_crl                                                           
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
                                                                                
   CALL i007_show()                                                             
                                                                                
   WHILE TRUE                                                                   
                                            
      LET g_skf.skfmodu=g_user                                                  
      LET g_skf.skfdate=g_today                                                 
                                                                                
      CALL i007_i("u") 
      
      IF g_skf.skf01!=g_skf_t.skf01  THEN
         UPDATE  skf_file SET skf01=g_skf.skf01
            WHERE skf01=g_skf01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","skf_file",g_skf_t.skf01,"",SQLCA.sqlcode,"","sgh",1)
            CONTINUE WHILE
         END IF
      END IF
      
      IF g_skf.skf02!=g_skf_t.skf02  THEN
         UPDATE  skf_file SET skf01=g_skf.skf02
            WHERE skf01=g_skf02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","skf_file",g_skf_t.skf02,"",SQLCA.sqlcode,"","sgh",1)
            CONTINUE WHILE
         END IF
      END IF
      
      IF g_skf.skf03!=g_skf_t.skf03  THEN                                           
         UPDATE  skf_file SET skf03=g_skf.skf03                                 
            WHERE skf03=g_skf03_t                                               
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                            
            CALL cl_err3("upd","skf_file",g_skf_t.skf03,"",SQLCA.sqlcode,"","sgh",1)
            CONTINUE WHILE                                                      
         END IF                                                                 
      END IF        
     IF INT_FLAG THEN                                                          
         LET INT_FLAG = 0                                                       
         LET g_skf.*=g_skf_t.*                                                  
         CALL i007_show()                                                       
         CALL cl_err('','9001',0)                                               
         EXIT WHILE                                                             
      END IF                                                                    
                                                                                
      UPDATE skf_file SET skf_file.* = g_skf.*                                  
       WHERE skf01 =g_skf_t.skf01 AND skf02 = g_skf_t.skf02 AND skf03 = g_skf_t.skf03
                                                                                
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                             
         CALL cl_err3("upd","skf_file","","",SQLCA.sqlcode,"","",1)             
         CONTINUE WHILE                                                         
      END IF                                                                    
      EXIT WHILE                                                                
   END WHILE                                                                    
                                                                                
   CLOSE i007_crl                                                               
   COMMIT WORK                                                                  
   CALL cl_flow_notify(g_skf.skf01,'U')                                         
                                                                                
END FUNCTION
  
FUNCTION i007_set_entry(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr10
  
  IF p_cmd='a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("skf01,skf02,skf03",TRUE)
  END IF
END FUNCTION
 
FUNCTION i007_set_no_entry(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr10
  
  IF p_cmd='u' AND g_chkey='N' AND (NOT g_before_input_done) THEN 
     CALL cl_set_comp_entry("skf01,skf02,skf03",FALSE)
  END IF                                                                        
END FUNCTION
 
FUNCTION i007_skf02(p_cmd)
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_imaacti LIKE ima_file.imaacti,
          p_cmd     like type_file.chr1
 
   LET g_errno=''
   SELECT ima02,imaacti INTO l_ima02,l_imaacti FROM ima_file
          WHERE ima_file.ima01=g_skf.skf02
   
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                          LET l_ima02=NULL
        WHEN l_imaacti='N' LET g_errno='9028'
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_ima02 TO skf02_ima02 
   END IF
END FUNCTION
 
FUNCTION i007_skf05(p_cmd)
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_imaacti LIKE ima_file.imaacti,
          p_cmd     like type_file.chr1
 
   LET g_errno=''
   SELECT ima02,imaacti INTO l_ima02,l_imaacti FROM ima_file
          WHERE ima_file.ima01=g_skf.skf05
   
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                           LET l_ima02=NULL
        WHEN l_imaacti='N' LET g_errno='9028'                   
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_ima02 TO skf05_ima02 
   END IF
END FUNCTION
 
FUNCTION i007_show_pic() 
  DEFINE l_chr   LIKE type_file.chr1                                                       
      LET l_chr='N'                                                             
      IF g_skf.skf07='Y' THEN                                               
         LET l_chr="Y"                                                          
      END IF                                                                    
      CALL cl_set_field_pic1(l_chr,"","","","",g_skf.skfacti,"","")             
END FUNCTION
 
FUNCTION i007_confirm()  
            
#CHI-C30107 ----------------- add ---------------------- begin
    IF cl_null(g_skf.skf01) OR cl_null(g_skf.skf03) THEN
     CALL cl_err('',-400,0)
     RETURN
   END IF
    IF g_skf.skf07="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_skf.skfacti="N" THEN
       CALL cl_err("",'aim-153',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-222') THEN  RETURN END IF
    SELECT * INTO g_skf.* FROM skf_file
                         WHERE skf01=g_skf.skf01
                           AND skf02=g_skf.skf02
                           AND skf03=g_skf.skf03
#CHI-C30107 ----------------- add ---------------------- end
    IF cl_null(g_skf.skf01) OR cl_null(g_skf.skf03) THEN                      
     CALL cl_err('',-400,0)                                                     
     RETURN                                                                     
   END IF                                                                       
    IF g_skf.skf07="Y" THEN                                                 
       CALL cl_err("",9023,1)                                                   
       RETURN                                                                   
    END IF   
    IF g_skf.skfacti="N" THEN                                                   
       CALL cl_err("",'aim-153',1)                                              
    ELSE                                                                        
#       IF cl_confirm('aap-222') THEN                                            #CHI-C30107 
            BEGIN WORK                                                          
            UPDATE skf_file                                                     
            SET skf07="Y"                                                   
            WHERE skf01=g_skf.skf01
              AND skf02=g_skf.skf02
              AND skf03=g_skf.skf03
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err3("upd","skf_file",g_skf.skf01,"",SQLCA.sqlcode,"","skf07",1)
            ROLLBACK WORK                                                       
        ELSE                                                                    
            COMMIT WORK                                                         
            LET g_skf.skf07="Y"                                             
            DISPLAY BY NAME g_skf.skf04                                     
        END IF                                                                  
#       END IF                                                                   #CHI-C30107 mark
     END IF                                                                     
END FUNCTION
 
 
FUNCTION i007_notconfirm() 
DEFINE l_n      LIKE type_file.num5 
 
   IF cl_null(g_skf.skf01) OR cl_null(g_skf.skf03) THEN                      
     CALL cl_err('',-400,0)                                                     
     RETURN                                                                     
   END IF
       IF g_skf.skf07 = 'N'  THEN 
        CALL cl_err('','9025',0)
        RETURN 
     END IF 
   SELECT COUNT(*) INTO l_n FROM skh_file 
      WHERE skh02=g_skf.skf01 AND skh03=g_skf.skf02 AND skh04=g_skf.skf03
   IF l_n>0 THEN
      CALL cl_err('' ,'ask-010' ,1)
      RETURN
   END IF                                                                        
    IF g_skf.skf07="N" OR g_skf.skfacti="N" THEN                            
       CALL cl_err("",'atm-365',1)                                            
    ELSE                                                                        
        IF cl_confirm('aap-224') THEN                                           
            BEGIN WORK                                                          
            UPDATE skf_file                                                     
            SET skf07="N"                                                       
            WHERE skf01=g_skf.skf01
              AND skf02=g_skf.skf02                                            
              AND skf03=g_skf.skf03                                             
        IF SQLCA.sqlcode THEN                                                   
            CALL cl_err3("upd","skf_file",g_skf.skf01,"",SQLCA.sqlcode,"","skf07",1)
            ROLLBACK WORK                                                       
        ELSE
            COMMIT WORK                                                         
            LET g_skf.skf07="N"                                                 
            DISPLAY BY NAME g_skf.skf07                                         
        END IF                                                                  
        END IF                                                                  
     END IF                                                                     
END FUNCTION  
 
FUNCTION i007_skg12_arg1()
DEFINE l_sma46 LIKE sma_file.sma46
      SELECT sma46 INTO l_sma46 from sma_file              
      LET g_skg12_arg1=g_skf.skf02,l_sma46,g_skg[l_ac].skg05,l_sma46,g_skg[l_ac].skg06,
                  l_sma46,g_skg[l_ac].skg07
      RETURN  g_skg12_arg1
END FUNCTION       
 
FUNCTION i007_b_title()
DEFINE 
    l_i             LIKE type_file.num5,
    l_j             LIKE type_file.num5,
    l_msg           LIKE type_file.chr1000,
    l_mag           LIKE type_file.chr1000,
    l_chr           LIKE type_file.chr3,
    g_agb02         LIKE agb_file.agb02
    
    LET g_agb02 = NULL
    
    SELECT DISTINCT agb01 INTO g_agb01
    FROM agb_file,ima_file
    WHERE ima01=g_skf.skf02
    AND imaag=agb01
      
    FOR l_i = 1 TO 3
      LET l_chr = l_i + 4
      LET l_msg = "skg0",l_chr CLIPPED
      SELECT agb02 INTO g_agb02 FROM agb_file,ima_file 
        WHERE ima01=g_skf.skf02 AND agb02 = l_i
          AND imaag=agb01  
      IF  cl_null(g_agb02)  THEN  
          CALL cl_set_comp_visible(l_msg,FALSE)
      ELSE
      	 SELECT agc02 INTO l_mag FROM agb_file,agc_file WHERE agb02=l_i
            AND agb01=g_agb01
            AND agc_file.agc01=agb03 
         CALL cl_set_comp_att_text(l_msg,l_mag CLIPPED) 
      END IF 
      LET g_agb02 = NULL        
      END FOR                  
    
END FUNCTION    
 
FUNCTION i007_auto_b(p_cmd)
DEFINE 
     p_cmd           LIKE type_file.chr1, 
     l_sfb           DYNAMIC ARRAY OF RECORD
        sfb05        LIKE sfb_file.sfb05,
        sfb08        LIKE sfb_file.sfb08,
        sfb01        LIKE sfb_file.sfb01
                     END RECORD,
     sr              DYNAMIC ARRAY OF RECORD
        skg01        LIKE skg_file.skg01,
        skg02        LIKE skg_file.skg02,
        skg03        LIKE skg_file.skg03,
        skg04        LIKE skg_file.skg04,
        skg05        LIKE skg_file.skg05,
        skg06        LIKE skg_file.skg06,
        skg07        LIKE skg_file.skg07,
        skg08        LIKE skg_file.skg08,
        skg09        LIKE skg_file.skg09,
        skg10        LIKE skg_file.skg10,
        skg12        LIKE skg_file.skg12    
                     END RECORD,
     l_imx01         LIKE imx_file.imx01,
     l_imx02         LIKE imx_file.imx02,
     l_imx03         LIKE imx_file.imx03,
     l_sma46         LIKE sma_file.sma46,
     l_str           LIKE type_file.chr1000,
     l_n1,l_n        LIKE type_file.num5,
     l_skg09         LIKE skg_file.skg09
    
     
     IF g_skf.skf07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
                    
     IF cl_null(g_skf.skf01) OR cl_null(g_skf.skf02) THEN 
       RETURN                                                                   
     END IF								
     LET g_cnt = 0  
     SELECT sma46 INTO l_sma46 from sma_file
     IF p_cmd = 'u'  THEN  
       SELECT COUNT(*) INTO l_n FROM skg_file WHERE  skg01=g_skf.skf01 AND skg02=g_skf.skf02 AND skg03=g_skf.skf03
       IF l_n >0 THEN 
         IF cl_confirm('ask-011') THEN
           DELETE  FROM skg_file WHERE  skg01=g_skf.skf01 AND skg02=g_skf.skf02 AND skg03=g_skf.skf03 
         ELSE 
           RETURN
         END IF
       END IF 
     END IF    
     
     DECLARE i007_auto_b_c1 CURSOR FOR                                               
     SELECT  unique sfb05,sfb08,sfb01
     FROM sfb_file,ima_file,imx_file,sfa_file    #No.FUN-870117 --add sfa_file
     WHERE sfb_file.sfb85=g_skf.skf01 AND sfb_file.sfb05=ima_file.ima01 
     AND ima_file.ima01=imx_file.imx000 AND imx_file.imx00=g_skf.skf02 
     AND sfb_file.sfb87='Y' AND sfb_file.sfbacti='Y'
     AND sfb_file.sfb04 ! ='8'
     AND sfa_file.sfa01 = sfb01 AND sfa03 = g_skf.skf05
     
     LET l_ac =1
     LET l_n1 =0
     FOREACH i007_auto_b_c1 INTO l_sfb[l_ac].sfb05,l_sfb[l_ac].sfb08,l_sfb[l_ac].sfb01
       IF STATUS THEN
       EXIT FOREACH                                  		
       END IF              	
       LET sr[l_ac].skg01=g_skf.skf01 					
       LET sr[l_ac].skg02=g_skf.skf02
       LET sr[l_ac].skg03=g_skf.skf03
       LET sr[l_ac].skg04=l_ac
       SELECT imx01,imx02,imx03 INTO l_imx01,l_imx02,l_imx03 
       FROM imx_file
       WHERE imx000 =l_sfb[l_ac].sfb05
       LET sr[l_ac].skg05=l_imx01
       LET sr[l_ac].skg06=l_imx02
       LET sr[l_ac].skg07=l_imx03
       LET sr[l_ac].skg08=1
       LET l_str = g_skf.skf02,l_sma46,sr[l_ac].skg05,l_sma46,sr[l_ac].skg06,l_sma46,sr[l_ac].skg07
       LET sr[l_ac].skg12 = l_sfb[l_ac].sfb01    
 
       SELECT  COALESCE(SUM(skg09),0) INTO  l_skg09 from skg_file,skf_file 
         WHERE skg_file.skg12= sr[l_ac].skg12
           AND skf_file.skf01=skg_file.skg01 
           AND skf_file.skf02=skg_file.skg02 and skf_file.skf03=skg_file.skg03
           AND skf_file.skfacti='Y'
           AND skf_file.skf05 =  g_skf.skf05        #No.FUN-870117
       LET sr[l_ac].skg09=l_sfb[l_ac].sfb08 - l_skg09 
       IF sr[l_ac].skg09 <= 0 THEN 
          CONTINUE FOREACH 
       END IF    
       LET sr[l_ac].skg10=" "    
       INSERT INTO skg_file(skg01,skg02,skg03,skg04,skg05,skg06,skg07,skg08,skg09,skg10,skg11,skg12,skgplant,skglegal) #FUN-980008 add skgplant,skglegal
        VALUES(sr[l_ac].skg01,sr[l_ac].skg02,sr[l_ac].skg03,sr[l_ac].skg04,sr[l_ac].skg05,
               sr[l_ac].skg06,sr[l_ac].skg07,sr[l_ac].skg08,sr[l_ac].skg09,sr[l_ac].skg10
               ,'',sr[l_ac].skg12,g_plant,g_legal) #FUN-980008 add g_plant,g_legal
       IF SQLCA.SQLCODE  THEN 
          CALL cl_err('ins skg',SQLCA.SQLCODE,1)
       END IF
       LET l_ac=l_ac+1
       LET l_n1= l_n1 + SQLCA.SQLERRD[3]
       CALL i007_show()
     END FOREACH
     IF  l_n1=0 THEN 
         CALL cl_err('','ask-054',0)
     END IF    	
	
END FUNCTION	
 
FUNCTION i007_copy()
   DEFINE l_skf01     LIKE skf_file.skf01,
          l_skf02     LIKE skf_file.skf02,
          l_skf03     LIKE skf_file.skf03,
          l_oskf01    LIKE skf_file.skf01,
          l_oskf02    LIKE skf_file.skf02,
          l_oskf03    LIKE skf_file.skf03
   DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   
   IF (g_skf.skf01 IS NULL) OR (g_skf.skf02 IS NULL) OR (g_skf.skf03 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i007_set_entry('a')
   DISPLAY ' ' TO FORMONLY.skf02_ima02
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_skf01,l_skf02,l_skf03 FROM skf01,skf02,skf03  
   
   AFTER FIELD skf01
         IF NOT cl_null(l_skf01) THEN                                    
            SELECT COUNT(*) INTO g_cnt FROM sfc_file,sfci_file
                  WHERE sfc01=l_skf01 AND sfci_file.sfci01 = sfc_file.sfc01
                  AND sfcislk05='Y' AND sfcacti='Y'
              IF g_cnt=0  THEN
                 CALL cl_err(l_skf01,'ask-008',0)
                 NEXT FIELD skf01
              END IF  
         ELSE
               NEXT FIELD skf01
         END IF   
         
   AFTER FIELD skf02
         IF NOT cl_null(l_skf02) THEN                                    
            SELECT COUNT(*) INTO g_cnt FROM ima_file,imx_file,sfb_file
                  WHERE ima01=imx_file.imx00 AND imx_file.imx000=sfb_file.sfb05
                  AND sfb_file.sfb85=l_skf01 AND ima_file.ima01=l_skf02
              IF g_cnt=0  THEN 
                 CALL cl_err(l_skf02,'ask-008',0)
                 DISPLAY ' ' TO FORMONLY.skf02_ima02
                 NEXT FIELD skf02
              END IF 
         ELSE
               NEXT FIELD skf01
         END IF
         
   AFTER FIELD skf03
       BEGIN WORK
       SELECT COUNT(*) INTO g_cnt FROM  skf_file WHERE skf01=l_skf01
             AND skf02=l_skf02 
             AND skf03=l_skf03 
       IF g_cnt>0 THEN
            CALL cl_err('',-239,0)
            DISPLAY ' ' TO g_skf.skf02
            DISPLAY ' ' TO g_skf.skf03
            NEXT FIELD skf01
       END IF              
       
       ON ACTION controlp
            CASE
              WHEN INFIELD(skf01)
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form     ="q_skf01"                                                          
               CALL cl_create_qry() RETURNING l_skf01  
               DISPLAY l_skf01 TO skf01  
               NEXT FIELD skf01                                    
              WHEN INFIELD(skf02)
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form     ="q_skf02"                                 
               LET g_qryparam.arg1=g_skf.skf01                         
               CALL cl_create_qry() RETURNING l_skf02 
               DISPLAY BY NAME l_skf02 
               CALL i007_skf02('d')
               NEXT FIELD skf02   
              OTHERWISE EXIT CASE
           END CASE
 
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about 
        CALL cl_about()
 
     ON ACTION help 
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_skf.skf01
      DISPLAY BY NAME g_skf.skf02
      DISPLAY BY NAME g_skf.skf03
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM skf_file         #單頭複製
       WHERE skf01=g_skf.skf01
       AND skf02=g_skf.skf02
       AND skf03=g_skf.skf03
       INTO TEMP y
 
   UPDATE y
       SET skf01=l_skf01,    #新的鍵值
           skf02=l_skf02,    #新的鍵值
           skf03=l_skf03,    #新的鍵值
           skf07='N',
           skfuser=g_user,   #資料所有者
           skfgrup=g_grup,   #資料所有者所屬群
           skfmodu=NULL,     #資料修改日期
           skfdate=g_today,  #資料建立日期
           skfacti='Y'       #有效資料
 
   INSERT INTO skf_file SELECT * FROM y
 
   DROP TABLE x
 
   SELECT * FROM skg_file         #單身複製
       WHERE skg01=g_skf.skf01
       AND skg02=g_skf.skf02
       AND skg03=g_skf.skf03
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET skg01=l_skf01,
                skg02=l_skf02,
                skg03=l_skf03
 
   INSERT INTO skg_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","skg_file","","",SQLCA.sqlcode,"","",1) #FUN-B80030 ADD
      ROLLBACK WORK
      #CALL cl_err3("ins","skg_file","","",SQLCA.sqlcode,"","",1)  #FUN-B80030 MARK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_skf01,') O.K'
 
   LET l_oskf01 = g_skf.skf01
   LET l_oskf02 = g_skf.skf02
   LET l_oskf03 = g_skf.skf03
   SELECT skf_file.* INTO g_skf.* FROM skf_file WHERE skf01 = l_skf01 AND skf02=l_skf02 AND skf03=l_skf03
   CALL i007_u()
   CALL i007_b()
   #SELECT skf_file.* INTO g_skf.* FROM skf_file WHERE skf01 = l_oskf01 AND skf02=l_oskf02 AND skf03=l_oskf03  #FUN-C80046
   #CALL i007_show()  #FUN-C80046
 
END FUNCTION					                 
#No.FUN-9C0072 精簡程式碼
