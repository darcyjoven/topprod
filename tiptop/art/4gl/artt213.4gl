# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt213.4gl 
# Descriptions...: 盤點變更單珛
# Date & Author..: FUN-870008 08/09/25 By Mike GP5.2   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30049 10/03/12 By Cockroach ADD oriu/orig
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號的管控
# Modify.........: No.FUN-AB0078 10/11/17 By houlia 倉庫營運中心權限控管審核段控管 
# Modify.........: No.FUN-AB0103 10/11/26 By wangxin 盤點單ruy03控管，已產生盤差單不許新增
# Modify.........: No.TQC-AB0291 10/11/30 By huangtao 
# Modify.........: No.FUN-B30084 11/03/18 By huangtao 增加變更發出功能和狀態碼
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:TQC-BB0125 11/11/24 by pauline 控卡user,group
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/12 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE
    g_ruy           RECORD LIKE ruy_file.*,        
    g_ruy_t         RECORD LIKE ruy_file.*,       
    g_ruy_o         RECORD LIKE ruy_file.*,      
    g_ruy01_t       LIKE ruy_file.ruy01,            
    g_ruyplant_t      LIKE ruy_file.ruyplant,       
    g_t1            LIKE type_file.chr5,                         
    g_ruz           DYNAMIC ARRAY OF RECORD             
        ruz02       LIKE ruz_file.ruz02,  
        ruz03       LIKE ruz_file.ruz03,
        ruz03_desc  LIKE ima_file.ima02,
        ruz04       LIKE ruz_file.ruz04,
        ruz04_desc  LIKE gfe_file.gfe02,     
        ruz05       LIKE ruz_file.ruz05,      
        ruz06       LIKE ruz_file.ruz06,
        ruz07       LIKE ruz_file.ruz07,     
        ruz08       LIKE ruz_file.ruz08,  
        ruz09       LIKE ruz_file.ruz09, 
        ruz10       LIKE ruz_file.ruz10
                       END RECORD,
    g_ruz_t         RECORD              
        ruz02       LIKE ruz_file.ruz02,                                                                                            
        ruz03       LIKE ruz_file.ruz03,                                                                                            
        ruz03_desc  LIKE ima_file.ima02,                                                                                            
        ruz04       LIKE ruz_file.ruz04,                                                                                            
        ruz04_desc  LIKE gfe_file.gfe02,                                                                                            
        ruz05       LIKE ruz_file.ruz05,                                                                                            
        ruz06       LIKE ruz_file.ruz06,                                                                                            
        ruz07       LIKE ruz_file.ruz07,                                                                                            
        ruz08       LIKE ruz_file.ruz08,                                                                                            
        ruz09       LIKE ruz_file.ruz09,                                                                                            
        ruz10       LIKE ruz_file.ruz10                  
                       END RECORD,
    g_ruz_o         RECORD
        ruz02       LIKE ruz_file.ruz02,                                                                                            
        ruz03       LIKE ruz_file.ruz03,                                                                                            
        ruz03_desc  LIKE ima_file.ima02,                                                                                            
        ruz04       LIKE ruz_file.ruz04,                                                                                            
        ruz04_desc  LIKE gfe_file.gfe02,                                                                                            
        ruz05       LIKE ruz_file.ruz05,                                                                                            
        ruz06       LIKE ruz_file.ruz06,                                                                                            
        ruz07       LIKE ruz_file.ruz07,                                                                                            
        ruz08       LIKE ruz_file.ruz08,                                                                                            
        ruz09       LIKE ruz_file.ruz09,                                                                                            
        ruz10       LIKE ruz_file.ruz10                 
                       END RECORD,
    g_sql           STRING,               
    g_wc            STRING,              
    g_wc2           STRING,       
    g_rec_b         LIKE type_file.num5,
    l_ac            LIKE type_file.num5
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_chr2              LIKE type_file.chr1 
DEFINE g_chr3              LIKE type_file.chr1 
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5               #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_curs_index        LIKE type_file.num10 
DEFINE g_row_count         LIKE type_file.num10 
DEFINE g_jump              LIKE type_file.num10 
DEFINE g_no_ask            LIKE type_file.num5  
 
MAIN
 IF FGL_GETENV("FGLGUI")<>"0" THEN
    OPTIONS 
        INPUT NO WRAP
    DEFER INTERRUPT              
 END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM ruy_file WHERE ruy01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t213_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t213_w WITH FORM "art/42f/artt213"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   CALL t213_menu()
   CLOSE WINDOW t213_w    

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t213_cs()
 
 CLEAR FORM                 
 CALL g_ruz.clear()    
 
   CONSTRUCT BY NAME g_wc ON ruy01,ruy02,ruy03,ruy04,ruy05,ruy06,ruy07,
            #                 ruyconf,ruycond,ruyconu,ruymksg,ruy900,ruyplant,ruy08,                        #TQC-AB0291   mark
            #                 ruyconf,ruycond,ruyconu,ruyplant,ruy08,                                       #TQC-AB0291  #FUN-B30084 mark
                             ruyconf,ruycond,ruyconu,ruy900,ruyplant,ruy08,                                              #FUN-B30084 add
                             ruyuser,ruygrup,ruymodu,ruydate,ruyacti,ruycrat
                            ,ruyoriu,ruyorig                                    #TQC-A30049 ADD 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
      ON ACTION controlp
         CASE
            WHEN INFIELD(ruy01)   #盤點變更單號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ruy01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruy01
               NEXT FIELD ruy01
 
            WHEN INFIELD(ruy02)    #所屬盤點計劃
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ruy02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruy02
               NEXT FIELD ruy02
 
           WHEN INFIELD(ruy03) #盤點單號
              CALL cl_init_qry_var()  
              LET g_qryparam.state = 'c'  
              LET g_qryparam.form ="q_ruy03"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ruy03 
              NEXT FIELD ruy03 
 
           WHEN INFIELD(ruy06) #盤點倉庫
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form = "q_ruy06"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ruy06
              NEXT FIELD ruy06  
 
           WHEN INFIELD(ruy07)          #變更人員                                                                            
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.state = 'c'                                                                                            
              LET g_qryparam.form = "q_ruy07"                                                                                       
              CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                    
              DISPLAY g_qryparam.multiret TO ruy07                                                                                  
              NEXT FIELD ruy07        
 
           WHEN INFIELD(ruyconu) #審核人                                                                                          
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.state = 'c'                                                                                            
              LET g_qryparam.form = "q_ruyconu"                                                                              
              CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                    
              DISPLAY g_qryparam.multiret TO ruyconu                                                                               
              NEXT FIELD ruyconu             
            OTHERWISE EXIT CASE
 
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruyuser', 'ruygrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                      
   #      LET g_wc = g_wc clipped," AND ruyuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                    
   #      LET g_wc = g_wc clipped," AND ruygrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
 
   CONSTRUCT g_wc2 ON ruz02,ruz03,ruz04,ruz05,ruz06,ruz07,ruz08,ruz09,ruz10  
                 FROM s_ruz[1].ruz02,s_ruz[1].ruz03,s_ruz[1].ruz04,s_ruz[1].ruz05,
                      s_ruz[1].ruz06,s_ruz[1].ruz07,s_ruz[1].ruz08,s_ruz[1].ruz09,
                      s_ruz[1].ruz10  
 
      ON ACTION CONTROLP 
         CASE 
           WHEN INFIELD(ruz03) #商品編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form ="q_ruz03"
              CALL cl_create_qry() RETURNING g_ruz[1].ruz03
              DISPLAY BY NAME g_ruz[1].ruz03
              NEXT FIELD ruz03
 
             OTHERWISE EXIT CASE
         END CASE
             
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
    
   END CONSTRUCT
   
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN        
      LET g_sql = "SELECT ruy01 FROM ruy_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY ruy01,ruyplant"
   ELSE                              
      LET g_sql = "SELECT UNIQUE ruy01 ",
                  "  FROM ruy_file, ruz_file ",
                  " WHERE ruy01 = ruz01 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY ruy01,ruyplant"
   END IF
 
   PREPARE t213_prepare FROM g_sql
   DECLARE t213_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t213_prepare
 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM ruy_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*) FROM ruy_file,ruz_file WHERE ",
                "ruz01=ruy01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t213_precount FROM g_sql
   DECLARE t213_count CURSOR FOR t213_precount
 
END FUNCTION
 
FUNCTION t213_menu()
   DEFINE l_str  LIKE type_file.chr1000
 
   WHILE TRUE
      CALL t213_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t213_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t213_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t213_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t213_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t213_x()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t213_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t213_y_chk()     
               IF g_success = "Y" THEN
                   CALL t213_y_upd()
               END IF
            END IF
         
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN  
               CALL t213_un()
            END IF
         
         WHEN "void"
            IF cl_chk_act_auth() THEN 
               CALL t213_v(1)
            END IF
         
         #FUN-D20039 -----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t213_v(2)
            END IF
         #FUN-D20039 -----------end

#FUN-B30084 --------------STA
         WHEN  "change_post"
            IF cl_chk_act_auth() THEN
               CALL t213_post()
            END IF

#FUN-B30084 --------------END
         
         WHEN "related_document"  #相關文件                                                                                         
            IF cl_chk_act_auth() THEN                                                                                             
               IF g_ruy.ruy01 IS NOT NULL AND g_ruy.ruyplant IS NOT NULL THEN                                                        
                  LET g_doc.column1 = "ruy01"                                                                                     
                  LET g_doc.value1 = g_ruy.ruy01                                                                                  
                  CALL cl_doc()                                                                                                   
               END IF                                                                                                             
            END IF                  
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t213_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_ruz TO s_ruz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      AFTER ROW 
         MESSAGE l_ac
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t213_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION previous
         CALL t213_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION jump
         CALL t213_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION next
         CALL t213_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION last
         CALL t213_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION confirm 
        LET g_action_choice="confirm"
        EXIT DISPLAY
 
     ON ACTION unconfirm                                                                                                     
        LET g_action_choice="unconfirm"                                                                                     
        EXIT DISPLAY      
 
     ON ACTION void                                                                                                              
        LET g_action_choice="void"                                                                                               
        EXIT DISPLAY      
    
     #FUN-D20039 -------------sta
     ON ACTION undo_void
        LET g_action_choice="undo_void"
        EXIT DISPLAY
     #FUN-D20039 -------------end
 
#FUN-B30084 --------------STA
     ON ACTION change_post
        LET g_action_choice="change_post"
        EXIT DISPLAY
#FUN-B30084 --------------END 

     ON ACTION related_document                                                                                              
        LET g_action_choice="related_document"                                                                   
        EXIT DISPLAY      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t213_a()
DEFINE   li_result   LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_ruz.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_ruy.* LIKE ruy_file.*      
   LET g_ruy01_t = NULL
   LET g_ruyplant_t = NULL
   LET g_ruy_t.* = g_ruy.*
   LET g_ruy_o.* = g_ruy.*
   
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ruy.ruy04=g_today
      LET g_ruy.ruy07 = g_user
      LET g_ruy.ruyplant = g_plant
      LET g_data_plant =g_plant     #TQC-A10128 ADD
      LET g_ruy.ruyoriu=g_user      #TQC-A30049 ADD
      LET g_ruy.ruyorig=g_grup      #TQC-A30049 ADD
      LET g_ruy.ruylegal = g_legal
      CALL t213_ruyplant('d')
      LET g_ruy.ruyuser=g_user
      LET g_ruy.ruygrup=g_grup
      LET g_ruy.ruymodu=NULL
      LET g_ruy.ruydate=NULL
      LET g_ruy.ruycrat=g_today
      LET g_ruy.ruyacti='Y' 
      LET g_ruy.ruyconf = 'N'
      LET g_ruy.ruymksg = 'N'      
      LET g_ruy.ruy900 = '0'
      CALL t213_i("a")     
 
      IF INT_FLAG THEN    
         INITIALIZE g_ruy.* TO NULL
         CLEAR FORM  
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ruy.ruy01) THEN   
         CONTINUE WHILE
      END IF
      
      IF cl_null(g_ruy.ruyplant) THEN   
         CONTINUE WHILE
      END IF
 
 
      BEGIN WORK
#     CALL s_auto_assign_no("ART",g_ruy.ruy01,g_today,"8","ruy_file","ruy01","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("ART",g_ruy.ruy01,g_today,"I6","ruy_file","ruy01","","","") #FUN-A70130 mod
           RETURNING li_result,g_ruy.ruy01                                                     
      IF (NOT li_result) THEN                                                                                                       
         ROLLBACK WORK        
         CONTINUE WHILE                                                                                                             
      END IF                                                                                                                        
      DISPLAY BY NAME g_ruy.ruy01
 
      LET g_ruy.ruyoriu = g_user      #No.FUN-980030 10/01/04
      LET g_ruy.ruyorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO ruy_file VALUES (g_ruy.*)
 
      IF SQLCA.sqlcode THEN        
      #   ROLLBACK WORK      #FUN-B80085---回滾放在報錯後---
         CALL cl_err(g_ruy.ruy01,SQLCA.sqlcode,1)   
         ROLLBACK WORK       #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
          COMMIT WORK         
          CALL cl_flow_notify(g_ruy.ruy01,'I')
      END IF
 
      LET g_ruy01_t = g_ruy.ruy01 
      LET g_ruyplant_t = g_ruy.ruyplant 
      
      LET g_ruy_t.* = g_ruy.*
      LET g_ruy_o.* = g_ruy.*
      CALL g_ruz.clear()
 
      LET g_rec_b = 0  
      CALL t213_b()        
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t213_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruy.ruy01 IS NULL OR g_ruy.ruyplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruy.* FROM ruy_file
    WHERE ruy01=g_ruy.ruy01
   IF g_ruy.ruyacti ='N' THEN    
      CALL cl_err(g_ruy.ruy01,'mfg1000',0)
      RETURN
   END IF
   IF g_ruy.ruyconf = 'Y' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t213_cl USING g_ruy.ruy01
   IF STATUS THEN
      CALL cl_err("OPEN t213_cl:", STATUS, 1)
      CLOSE t213_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t213_cl INTO g_ruy.*       
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruy.ruy01,SQLCA.sqlcode,0)    
       CLOSE t213_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t213_show()
 
   WHILE TRUE
      LET g_ruy01_t = g_ruy.ruy01
      LET g_ruy_o.* = g_ruy.*
      LET g_ruy.ruymodu=g_user
      LET g_ruy.ruydate=g_today
 
      CALL t213_i("u")    
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ruy.ruy01 = g_ruy01_t
         LET g_ruy.*=g_ruy_t.*
         CALL t213_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ruy.ruy01 != g_ruy01_t THEN     
         UPDATE ruz_file SET ruz01 = g_ruy.ruy01
          WHERE ruz01 = g_ruy01_t 
         UPDATE ruy_file SET ruy01 = g_ruy.ruy01
          WHERE ruy01 = g_ruy01_t 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ruz_file",g_ruy01_t,"",SQLCA.sqlcode,"","ruz",1) 
            CONTINUE WHILE
         END IF
         LET g_ruy01_t=g_ruy.ruy01
      END IF
 
      UPDATE ruy_file SET ruy_file.* = g_ruy.*
       WHERE ruy01 = g_ruy.ruy01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruy_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t213_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruy.ruy01,'U')
 
END FUNCTION
 
FUNCTION t213_i(p_cmd)
 
DEFINE
   l_n             LIKE type_file.num5,
   p_cmd           LIKE type_file.chr1   
DEFINE   li_result LIKE type_file.num5
DEFINE   l_ruw03   LIKE ruw_file.ruw03 #FUN-AB0103 add
   IF s_shut(0) THEN
      RETURN
   END IF
   
   DISPLAY BY NAME g_ruy.ruy04,g_ruy.ruy07,g_ruy.ruyplant,g_ruy.ruyconf,g_ruy.ruyuser,         
                   g_ruy.ruygrup,g_ruy.ruyacti,g_ruy.ruycrat,g_ruy.ruymodu,g_ruy.ruydate,
    #               g_ruy.ruymksg,g_ruy.ruy900,g_ruy.ruyoriu,g_ruy.ruyorig                   #TQC-A30049 ADD    #TQC-AB0291  mark
    #               g_ruy.ruyoriu,g_ruy.ruyorig                                                     #TQC-AB0291  #FUN-B30084 mark
                   g_ruy.ruy900,g_ruy.ruyoriu,g_ruy.ruyorig                                                      #FUN-B30084 add
   INPUT BY NAME g_ruy.ruy01,g_ruy.ruy02,g_ruy.ruy03,g_ruy.ruy04,g_ruy.ruy07,g_ruy.ruy08
    #             g_ruy.ruymksg                                                                                 #TQC-AB0291  mark
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t213_set_entry(p_cmd)
         CALL t213_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ruy01") 
 
      AFTER FIELD ruy01
         IF NOT cl_null(g_ruy.ruy01) THEN
            IF g_ruy.ruy01 !=g_ruy01_t OR g_ruy01_t IS NULL THEN
#              CALL s_check_no('art',g_ruy.ruy01,g_ruy01_t,'K','ruy_file','ruy01','') #FUN-A70130 mark
               CALL s_check_no('art',g_ruy.ruy01,g_ruy01_t,'E2','ruy_file','ruy01','') #FUN-A70130 mod
                    RETURNING li_result,g_ruy.ruy01
               IF (NOT li_result) THEN
                  LET g_ruy.ruy01=g_ruy01_t
                  DISPLAY BY NAME g_ruy.ruy01
                  NEXT FIELD ruy01
               END IF
            END IF
         ELSE
            CALL cl_err('','alm-055',1) 
            LET g_ruy.ruy01=g_ruy01_t
            DISPLAY BY NAME g_ruy.ruy01
            NEXT FIELD ruy01
         END IF
      BEFORE FIELD ruy02
         CALL t213_set_entry(p_cmd)
 
      AFTER FIELD ruy02  
          LET l_n = 0
          IF g_ruy.ruy02 IS NOT NULL THEN
             SELECT COUNT(*) INTO l_n FROM rus_file
              WHERE rus01=g_ruy.ruy02 AND rusconf='Y' 
                AND rus16='N'
             IF l_n=0 THEN
                CALL cl_err('','art-348',0)
                NEXT FIELD ruy02
             END IF 
          END IF
          CALL t213_ruy02('d')
          CALL t213_set_no_entry(p_cmd)
 
      AFTER FIELD ruy03
         IF NOT cl_null(g_ruy.ruy03) THEN
            LET l_n = 0                                                                                                      
            SELECT COUNT(*) INTO l_n FROM ruw_file
             WHERE ruw00='1' AND ruw01=g_ruy.ruy03 
               AND ruw02=g_ruy.ruy02 AND ruwconf='Y'
            IF l_n=0 THEN                                                                                                        
                CALL cl_err('','art-351',0)                                                                                         
                NEXT FIELD ruy03                                                                                                    
            END IF    
            #FUN-AB0103 add ---------------begin-----------------
            SELECT ruw03 INTO l_ruw03 FROM ruw_file
             WHERE ruw00 = '1' AND ruw01 = g_ruy.ruy03
            IF l_ruw03 IS NOT NULL THEN 
               CALL cl_err('','art-592',0)
               LET g_ruy.ruy03 = ''
               NEXT FIELD ruy03
            END IF
            #FUN-AB0103 add ----------------end------------------                                                                                                             
          END IF       
          CALL t213_ruy03('d')
  
      AFTER FIELD ruy07
         IF NOT cl_null(g_ruy.ruy07) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM gen_file
              WHERE gen01=g_ruy.ruy07 AND genacti='Y'
            IF l_n=0 THEN                                                                                                         
                CALL cl_err('','zzz-003',0)                                                                                         
                NEXT FIELD ruy07                                                                                                    
            END IF                                                                                                                  
         END IF             
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF     
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
      ON ACTION controlp
         CASE                   
            WHEN INFIELD(ruy01)
               LET g_t1=s_get_doc_no(g_ruy.ruy01)  
#              CALL q_smy(FALSE,FALSE,g_t1,'art','K')   #FUN-A70130--mark--
               CALL q_oay(FALSE,FALSE,g_t1,'E2','art')   #FUN-A70130--end--
                RETURNING g_t1
               LET g_ruy.ruy01 = g_t1
               DISPLAY BY NAME g_ruy.ruy01
               NEXT FIELD ruy01
                                                                
            WHEN INFIELD(ruy02)                                                                                       
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form ="q_rus01_1"                                   
               LET g_qryparam.default1 = g_ruy.ruy02                      
               CALL cl_create_qry() RETURNING g_ruy.ruy02                 
               DISPLAY g_ruy.ruy02 TO ruy02 
               CALL t213_ruy02('d')  
               NEXT FIELD ruy02
                   
            WHEN INFIELD(ruy03)                                                                                      
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_ruw01"                                                                                    
               LET g_qryparam.default1 = g_ruy.ruy03
               LET g_qryparam.arg1=g_ruy.ruy02
               CALL cl_create_qry() RETURNING g_ruy.ruy03                                                                     
               DISPLAY g_ruy.ruy03 TO ruy03
               CALL t213_ruy03('d')
               NEXT FIELD ruy03            
           
            WHEN INFIELD(ruy07)                                                                                                    
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_gen"                                                                                       
               LET g_qryparam.default1 = g_ruy.ruy07                                                                                
               CALL cl_create_qry() RETURNING g_ruy.ruy07                                                                           
               DISPLAY g_ruy.ruy07 TO ruy07                                                                                         
               CALL t213_ruy07('d')
               NEXT FIELD ruy07
                 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
   END INPUT
 
END FUNCTION
 
FUNCTION t213_ruy02(p_cmd)                                       
   DEFINE p_cmd       LIKE type_file.chr1,                                                 
          l_rus02     LIKE rus_file.rus02                                     
                                                                           
        SELECT rus02                                                            
          INTO l_rus02                                                          
          FROM rus_file 
         WHERE rus01 = g_ruy.ruy02 
           AND rusconf='Y'                         
        IF SQLCA.sqlcode THEN                                                   
            LET l_rus02 = NULL                                                  
        END IF                                                                  
                                                                                
    IF p_cmd = 'd' THEN                                     
       DISPLAY l_rus02 TO FORMONLY.ruy02_desc                                  
    END IF                                                                      
END FUNCTION  
 
FUNCTION t213_ruy03(p_cmd)                                         
    DEFINE p_cmd       LIKE type_file.chr1,                                                 
           l_ruw04     LIKE ruw_file.ruw04,                                     
           l_ruw05     LIKE ruw_file.ruw05                                      
                                                                             
        SELECT ruw04,ruw05                                                            
          INTO l_ruw04,l_ruw05                                                          
          FROM ruw_file 
         WHERE ruw01 = g_ruy.ruy03 AND ruw00='1'                           
                                                                                
        IF SQLCA.sqlcode THEN                                                   
            LET l_ruw04 = NULL
            LET l_ruw05 = NULL                                                  
        END IF                                                                  
                                                                                
    IF p_cmd = 'd' THEN
          LET g_ruy.ruy05=l_ruw04
          LET g_ruy.ruy06=l_ruw05                                     
          DISPLAY BY NAME g_ruy.ruy05,g_ruy.ruy06
          CALL t213_ruy06('d')
    END IF                                                                      
END FUNCTION  
 
FUNCTION t213_ruy06(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,
          l_imd02 LIKE imd_file.imd02
   SELECT imd02 INTO l_imd02 FROM imd_file
    WHERE imd01=g_ruy.ruy06 
      AND imdacti='Y'
   IF SQLCA.sqlcode THEN
      LET l_imd02=NULL
   END IF
   IF p_cmd='d' THEN
      DISPLAY l_imd02 TO FORMONLY.ruy06_desc
   END IF   
END FUNCTION
 
FUNCTION t213_ruy07(p_cmd)                                                                                                          
   DEFINE p_cmd LIKE type_file.chr1,                                                                                                
          l_gen02 LIKE gen_file.gen02                                                                                               
   SELECT gen02 INTO l_gen02 FROM gen_file                                                                                          
    WHERE gen01=g_ruy.ruy07                                                                                                         
      AND genacti='Y'                                                                                                               
   IF SQLCA.sqlcode THEN                                                                                                            
      LET l_gen02=NULL                                                                                                              
   END IF                                                                                                                           
   IF p_cmd='d' THEN                                                                                                                
      DISPLAY l_gen02 TO FORMONLY.ruy07_desc                                                                                        
   END IF                                                                                                                           
END FUNCTION 
 
FUNCTION t213_ruyconu(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1, 
           l_gen02     LIKE gen_file.gen02                                     
                                                                                
        SELECT gen02                                                            
          INTO l_gen02                                                          
          FROM gen_file 
         WHERE gen01 = g_ruy.ruyconu                         
           AND genacti='Y'                                                                      
        IF SQLCA.sqlcode THEN                                                   
            LET l_gen02 = NULL                                             
        END IF                                                                  
                                                                                
    IF p_cmd = 'd' THEN                                     
          DISPLAY l_gen02 TO FORMONLY.ruyconu_desc       
    END IF
END FUNCTION 
 
FUNCTION t213_ruyplant(p_cmd)                                                                                              
    DEFINE p_cmd     LIKE type_file.chr1,                                                 
           l_azp02   LIKE azp_file.azp02                               
                                                                                
        SELECT azp02 INTO l_azp02                                         
          FROM azp_file                                                      
         WHERE azp01=g_ruy.ruyplant
                                                      
        IF SQLCA.sqlcode THEN                                                   
            LET l_azp02 =NULL                                                
        END IF                                                                  
                                                                                
    IF p_cmd = 'd' THEN                                     
          DISPLAY l_azp02 TO FORMONLY.ruyplant_desc                               
    END IF 
END FUNCTION 
 
FUNCTION t213_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_msg("")
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ruz.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t213_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ruy.* TO NULL
      RETURN
   END IF
 
   OPEN t213_cs              
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ruy.* TO NULL
   ELSE
      OPEN t213_count
      FETCH t213_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t213_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t213_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1   
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t213_cs INTO g_ruy.ruy01
      WHEN 'P' FETCH PREVIOUS t213_cs INTO g_ruy.ruy01
      WHEN 'F' FETCH FIRST    t213_cs INTO g_ruy.ruy01
      WHEN 'L' FETCH LAST     t213_cs INTO g_ruy.ruy01
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
      ON ACTION controlg       
         CALL cl_cmdask()      
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t213_cs INTO g_ruy.ruy01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruy.ruy01,SQLCA.sqlcode,0)
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
      DISPLAY g_curs_index TO FORMONLY.cn2                    
   END IF
 
   SELECT * INTO g_ruy.* FROM ruy_file WHERE ruy01 = g_ruy.ruy01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ruy_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_ruy.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_ruy.ruyuser    #TQC-BB0125 add
   LET g_data_group = g_ruy.ruygrup    #TQC-BB0125 add
   LET g_data_plant = g_ruy.ruyplant   #TQC-A10128 ADD 
   CALL t213_show()
 
END FUNCTION
 
FUNCTION t213_show()
   LET g_ruy_t.* = g_ruy.*
   LET g_ruy_o.* = g_ruy.*
   DISPLAY BY NAME g_ruy.ruy01,g_ruy.ruy02,g_ruy.ruy03,
                   g_ruy.ruy04,g_ruy.ruy05,g_ruy.ruy06,
       #            g_ruy.ruy07,g_ruy.ruy08,g_ruy.ruy900,                        #TQC-AB0291  mark
       #            g_ruy.ruyplant,g_ruy.ruyconu,g_ruy.ruymksg,                  #TQC-AB0291  mark
                   g_ruy.ruy07,g_ruy.ruy08,                                      #TQC-AB0291
                   g_ruy.ruy900,                                                 #FUN-B30084  add
                   g_ruy.ruyplant,g_ruy.ruyconu,                                 #TQC-AB0291
                   g_ruy.ruyconf,g_ruy.ruycond,g_ruy.ruycrat,
                   g_ruy.ruyuser,g_ruy.ruygrup,g_ruy.ruymodu,
                   g_ruy.ruydate,g_ruy.ruyacti
                  ,g_ruy.ruyoriu,g_ruy.ruyorig         #TQC-A30049 ADD
   
   CALL t213_ruy02('d')
   CALL t213_ruy03('d') 
   CALL t213_ruy06('d')
   CALL t213_ruy07('d')
   CALL t213_ruyconu('d')
   CALL t213_ruyplant('d') 
   CALL t213_b_fill(g_wc2)  
   CALL t213_pic()
 
END FUNCTION
 
FUNCTION t213_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruy.ruy01 IS NULL OR g_ruy.ruyplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_ruy.ruyconf !='N' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF
   BEGIN WORK
 
   OPEN t213_cl USING g_ruy.ruy01
   IF STATUS THEN
      CALL cl_err("OPEN t213_cl:", STATUS, 1)
      CLOSE t213_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t213_cl INTO g_ruy.*            
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruy.ruy01,SQLCA.sqlcode,0)    
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t213_show()
 
   IF cl_exp(0,0,g_ruy.ruyacti) THEN
      LET g_chr=g_ruy.ruyacti
      IF g_ruy.ruyacti='Y' THEN
         LET g_ruy.ruyacti='N'
      ELSE
         LET g_ruy.ruyacti='Y'
      END IF
 
      UPDATE ruy_file SET ruyacti=g_ruy.ruyacti,
                          ruymodu=g_user,
                          ruydate=g_today
       WHERE ruy01=g_ruy.ruy01 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ruy_file",g_ruy.ruy01,"",SQLCA.sqlcode,"","",1)  
         LET g_ruy.ruyacti=g_chr
         LET g_success ='N' 
      END IF
   END IF
 
   CLOSE t213_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruy.ruy01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT ruyacti,ruymodu,ruydate
     INTO g_ruy.ruyacti,g_ruy.ruymodu,g_ruy.ruydate FROM ruy_file
    WHERE ruy01=g_ruy.ruy01 
   DISPLAY BY NAME g_ruy.ruyacti,g_ruy.ruymodu,g_ruy.ruydate
 
END FUNCTION
 
FUNCTION t213_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruy.ruy01 IS NULL OR g_ruy.ruyplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruy.* FROM ruy_file
    WHERE ruy01=g_ruy.ruy01
   IF g_ruy.ruyacti ='N' THEN    
      CALL cl_err(g_ruy.ruy01,'mfg1000',0)
      RETURN
   END IF
   IF g_ruy.ruyconf = 'Y' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF

   BEGIN WORK
 
   OPEN t213_cl USING g_ruy.ruy01
   IF STATUS THEN
      CALL cl_err("OPEN t213_cl:", STATUS, 1)
      CLOSE t213_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t213_cl INTO g_ruy.*           
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruy.ruy01,SQLCA.sqlcode,0)        
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t213_show()
 
   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ruy01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ruy.ruy01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
      DELETE FROM ruy_file WHERE ruy01 = g_ruy.ruy01 
      DELETE FROM ruz_file WHERE ruz01 = g_ruy.ruy01
      CLEAR FORM
      CALL g_ruz.clear()
      OPEN t213_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t213_cs
         CLOSE t213_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t213_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t213_cs
         CLOSE t213_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t213_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t213_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t213_fetch('/')
      END IF
   END IF
 
   CLOSE t213_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruy.ruy01,'D')
 
END FUNCTION
 
FUNCTION t213_b()
DEFINE
    l_ac_t         LIKE type_file.num5, 
    l_n            LIKE type_file.num5,    
    l_cnt          LIKE type_file.num5,    
    l_lock_sw      LIKE type_file.chr1,
    p_cmd          LIKE type_file.chr1,   
    l_misc         LIKE type_file.chr4,
    l_allow_insert LIKE type_file.num5, 
    l_allow_delete LIKE type_file.num5 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_ruy.ruy01 IS NULL OR g_ruy.ruyplant IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_ruy.* FROM ruy_file
     WHERE ruy01=g_ruy.ruy01
    IF g_ruy.ruyacti ='N' THEN
       CALL cl_err(g_ruy.ruy01,'mfg1000',0)
       RETURN
    END IF
    IF g_ruy.ruyconf = 'Y' 
       THEN CALL cl_err('',9023,0) 
       RETURN 
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ruz02,ruz03,'',ruz04,'',",
                       " ruz05,ruz06,ruz07,ruz08,ruz09,ruz10 ",
                       "  FROM ruz_file",
                       " WHERE ruz01=? AND ruz02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t213_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ruz WITHOUT DEFAULTS FROM s_ruz.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t213_cl USING g_ruy.ruy01
           IF STATUS THEN
              CALL cl_err("OPEN t213_cl:", STATUS, 1)
              CLOSE t213_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t213_cl INTO g_ruy.*       
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ruy.ruy01,SQLCA.sqlcode,0)     
              CLOSE t213_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_ruz_t.* = g_ruz[l_ac].*  #BACKUP
              LET g_ruz_o.* = g_ruz[l_ac].*  #BACKUP
              OPEN t213_bcl USING g_ruy.ruy01,g_ruz_t.ruz02
              IF STATUS THEN
                 CALL cl_err("OPEN t213_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t213_bcl INTO g_ruz[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ruz_t.ruz02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t213_ruz03('d')
              END IF
              CALL t213_set_entry_b(p_cmd)     
              CALL t213_set_no_entry_b(p_cmd)  
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_ruz[l_ac].* TO NULL      
           LET g_ruz_t.* = g_ruz[l_ac].*       
           LET g_ruz_o.* = g_ruz[l_ac].*     
           CALL t213_set_entry_b(p_cmd)    
           CALL t213_set_no_entry_b(p_cmd)
           NEXT FIELD ruz02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO ruz_file(ruz01,ruz02,ruz03,ruz04,ruz05,ruz06,ruz07,ruz08,
                                ruz09,ruz10,ruzplant,ruzlegal)
                VALUES(g_ruy.ruy01,
                       g_ruz[l_ac].ruz02,
                       g_ruz[l_ac].ruz03,
                       g_ruz[l_ac].ruz04,
                       g_ruz[l_ac].ruz05,
                       g_ruz[l_ac].ruz06,
                       g_ruz[l_ac].ruz07,
                       g_ruz[l_ac].ruz08,
                       g_ruz[l_ac].ruz09,
                       g_ruz[l_ac].ruz10,
                       g_ruy.ruyplant,
                       g_ruy.ruylegal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ruz_file",g_ruy.ruy01,g_ruz[l_ac].ruz02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD ruz02       
           IF g_ruz[l_ac].ruz02 IS NULL OR g_ruz[l_ac].ruz02 = 0 THEN
              SELECT max(ruz02)+1
                INTO g_ruz[l_ac].ruz02
                FROM ruz_file
               WHERE ruz01 = g_ruy.ruy01
              IF g_ruz[l_ac].ruz02 IS NULL THEN
                 LET g_ruz[l_ac].ruz02 = 1
              END IF
           END IF
 
        AFTER FIELD ruz02      
           IF NOT cl_null(g_ruz[l_ac].ruz02) THEN
              IF g_ruz[l_ac].ruz02 != g_ruz_t.ruz02
                 OR g_ruz_t.ruz02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM ruz_file
                  WHERE ruz01 = g_ruy.ruy01
                    AND ruz02 = g_ruz[l_ac].ruz02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ruz[l_ac].ruz02 = g_ruz_t.ruz02
                    NEXT FIELD ruz02
                 END IF
              END IF
           END IF
 
       BEFORE FIELD ruz03
          CALL t213_set_entry_b(p_cmd)
 
       AFTER FIELD ruz03
          IF g_ruz[l_ac].ruz03 IS NOT NULL THEN
#FUN-AA0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(g_ruz[l_ac].ruz03,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_ruz[l_ac].ruz03= g_ruz_t.ruz03
                NEXT FIELD ruz03
             END IF
#FUN-AA0059 ---------------------end-------------------------------
             IF p_cmd="a" OR (p_cmd="u" AND g_ruz[l_ac].ruz03 !=g_ruz_t.ruz03) THEN
                SELECT COUNT(*) INTO l_n FROM ruw_file,rux_file
                 WHERE ruw00=rux00 AND ruw01=rux01 
                   AND ruw00='1' AND ruw01=g_ruy.ruy03 
                   AND ruwconf='Y' AND rux03=g_ruz[l_ac].ruz03
                IF l_n=0 THEN
                   CALL cl_err(g_ruz[l_ac].ruz03,'art-363',0)
                   NEXT FIELD ruz03
                END IF
                CALL t213_ruz03('d')
             END IF
          END IF  
          CALL t213_set_no_entry_b(p_cmd)
 
       AFTER FIELD ruz09 
          IF NOT cl_null(g_ruz[l_ac].ruz09) THEN
             IF g_ruz[l_ac].ruz09=0 THEN
                CALL cl_err(g_ruz[l_ac].ruz09,'art-364',0)
                NEXT FIELD ruz09
             END IF
          END IF 
        BEFORE DELETE            
           DISPLAY "BEFORE DELETE"
           IF g_ruz_t.ruz02 > 0 AND g_ruz_t.ruz02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ruz_file
               WHERE ruz01 = g_ruy.ruy01
                 AND ruz02 = g_ruz_t.ruz02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ruz_file",g_ruy.ruy01,g_ruz_t.ruz02,SQLCA.sqlcode,"","",1)   
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ruz[l_ac].* = g_ruz_t.*
              CLOSE t213_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ruz[l_ac].ruz02,-263,1)
              LET g_ruz[l_ac].* = g_ruz_t.*
           ELSE
              UPDATE ruz_file SET ruz02=g_ruz[l_ac].ruz02,
                                  ruz03=g_ruz[l_ac].ruz03,
                                  ruz04=g_ruz[l_ac].ruz04,
                                  ruz05=g_ruz[l_ac].ruz05,
                                  ruz06=g_ruz[l_ac].ruz06,
                                  ruz07=g_ruz[l_ac].ruz07,
                                  ruz08=g_ruz[l_ac].ruz08,
                                  ruz09=g_ruz[l_ac].ruz09,
                                  ruz10=g_ruz[l_ac].ruz10
               WHERE ruz01=g_ruy.ruy01
                 AND ruz02=g_ruz_t.ruz02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ruz_file",g_ruy.ruy01,g_ruz_t.ruz02,SQLCA.sqlcode,"","",1)  
                 LET g_ruz[l_ac].* = g_ruz_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ruz[l_ac].* = g_ruz_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_ruz.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t213_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033 add
           CLOSE t213_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(ruz02) AND l_ac > 1 THEN
              LET g_ruz[l_ac].* = g_ruz[l_ac-1].*
              LET g_ruz[l_ac].ruz02 = g_rec_b + 1
              NEXT FIELD ruz02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ruz03) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_rux03"
                 LET g_qryparam.arg1 = g_ruy.ruy03
                 LET g_qryparam.default1 = g_ruz[l_ac].ruz03
                 CALL cl_create_qry() RETURNING g_ruz[l_ac].ruz03
                 DISPLAY BY NAME g_ruz[l_ac].ruz03
                 CALL t213_ruz03('d')
                 NEXT FIELD ruz03
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
    END INPUT
 
    LET g_ruy.ruymodu = g_user
    LET g_ruy.ruydate = g_today
    UPDATE ruy_file 
       SET ruymodu = g_ruy.ruymodu,
           ruydate = g_ruy.ruydate
     WHERE ruy01 = g_ruy.ruy01
    DISPLAY BY NAME g_ruy.ruymodu,g_ruy.ruydate
    
    CLOSE t213_bcl
    COMMIT WORK
#   CALL t213_delall() #CHI-C30002 mark
    CALL t213_delHeader()     #CHI-C30002 add
 
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION t213_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ruy.ruy01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ruy_file ",
                  "  WHERE ruy01 LIKE '",l_slip,"%' ",
                  "    AND ruy01 > '",g_ruy.ruy01,"'"
      PREPARE t213_pb1 FROM l_sql 
      EXECUTE t213_pb1 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t213_v(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ruy_file WHERE ruy01 = g_ruy.ruy01
         INITIALIZE g_ruy.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t213_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM ruz_file
#    WHERE ruz01 = g_ruy.ruy01
#
#   IF g_cnt = 0 THEN     
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM ruy_file WHERE ruy01 = g_ruy.ruy01 
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t213_ruz03(p_cmd) 
DEFINE p_cmd       LIKE type_file.chr1,
       l_ima02     LIKE ima_file.ima02,
       l_rux04     LIKE rux_file.rux04,
       l_rux05     LIKE rux_file.rux05,
       l_rux06     LIKE rux_file.rux06,
       l_rux07     LIKE rux_file.rux07,
       l_rux08     LIKE rux_file.rux08 
 
   SELECT ima02
     INTO l_ima02
     FROM ima_file
    WHERE ima01 = g_ruz[l_ac].ruz03
      AND imaacti='Y'
   IF SQLCA.sqlcode THEN
      LET l_ima02=NULL
   END IF
   SELECT rux04,rux05,rux06,rux07,rux08
     INTO l_rux04,l_rux05,l_rux06,l_rux07,l_rux08 
     FROM rux_file,ruw_file
    WHERE ruw00=rux00 AND ruw01=rux01 
      AND ruw00='1' AND ruw01=g_ruy.ruy03 
      AND ruwconf='Y' AND rux03=g_ruz[l_ac].ruz03
   IF SQLCA.sqlcode THEN
      LET l_rux04=NULL
      LET l_rux05=NULL
      LET l_rux06=NULL
      LET l_rux07=NULL
      LET l_rux08=NULL 
   END IF
   IF p_cmd = 'd' THEN
      LET g_ruz[l_ac].ruz03_desc=l_ima02
      LET g_ruz[l_ac].ruz04=l_rux04
      LET g_ruz[l_ac].ruz05=l_rux05 
      LET g_ruz[l_ac].ruz06=l_rux06 
      LET g_ruz[l_ac].ruz07=l_rux07 
      LET g_ruz[l_ac].ruz08=l_rux08
      CALL t213_ruz04('d')    
   END IF
  
END FUNCTION 
 
FUNCTION t213_ruz04(p_cmd)
DEFINE p_cmd LIKE type_file.chr1,
       l_gfe02 LIKE gfe_file.gfe02
   SELECT gfe02 INTO l_gfe02 FROM gfe_file
    WHERE gfe01=g_ruz[l_ac].ruz04
      AND gfeacti='Y'
   IF SQLCA.sqlcode THEN
      LET l_gfe02=NULL
   END IF
   IF p_cmd='d' THEN
      LET g_ruz[l_ac].ruz04_desc=l_gfe02
   END IF                        
END FUNCTION
 
FUNCTION t213_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2       STRING
 
    LET g_sql = "SELECT ruz02,ruz03,'',ruz04,'',ruz05,ruz06, ",
                "       ruz07,ruz08,ruz09,ruz10 ",
                " FROM ruz_file",   
                " WHERE ruz01 ='",g_ruy.ruy01,"' ",
                "  AND ",p_wc2 CLIPPED,
                " ORDER BY ruz02"
 
    PREPARE t213_pb FROM g_sql
    DECLARE ruz_cs                       #CURSOR
        CURSOR FOR t213_pb
 
    CALL g_ruz.clear()
    LET g_cnt = 1
 
    FOREACH ruz_cs INTO g_ruz[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima02                                                                                                        
        INTO g_ruz[g_cnt].ruz03_desc                                                                                          
        FROM ima_file 
       WHERE ima01 = g_ruz[g_cnt].ruz03                                                                                  
      SELECT gfe02 INTO g_ruz[g_cnt].ruz04_desc FROM gfe_file                                                                       
       WHERE gfe01=g_ruz[g_cnt].ruz04                                                                   
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ruz.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
#FUNCTION t213_copy()
#DEFINE
#   l_newno         LIKE ruy_file.ruy01,
#   l_newdate       LIKE ruy_file.ruy04,
#   l_n             LIKE type_file.num5,
#   l_tmp           LIKE type_file.chr30,
#   l_oldno         LIKE ruy_file.ruy01
#EFINE   li_result  LIKE type_file.num5,         
 
#   IF s_shut(0) THEN RETURN END IF
#   IF g_ruy.ruy01 IS NULL OR g_ruy.ruyplant IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#  IF g_ruy.ruyconf = 'Y' THEN 
#     CALL cl_err('',9023,0) 
#     RETURN 
#  END IF
#   LET g_before_input_done = FALSE
#   CALL t213_set_entry('a')
#   LET g_before_input_done = TRUE
#   LET l_newdate= NULL                                                                                                             
#                                                                                                                                   
#   INPUT l_newno,l_newdate FROM ruy01,ruy04                                                                                        
#       BEFORE INPUT                                                                                                                
#          CALL cl_set_docno_format("ruy01")  
 
#       AFTER FIELD ruy01                                                                                                        
#         IF l_newno[1,g_doc_len] IS NULL THEN                                                                                      
#             NEXT FIELD ruy01                                                                                                   
#         END IF                                                                                                                    
#         CALL s_check_no("art",l_newno,"","8","ruy_file","ruy01","")                                                         
#             RETURNING li_result,l_newno                                                                                    
#          DISPLAY l_newno TO ruy01                                                                                             
#          IF (NOT li_result) THEN                                                                                                  
#              NEXT FIELD ruy01                                                                                                 
#          END IF                                                                                                                   
#       LET l_tmp='213-',l_newno
#       LET g_ruy.ruy09=l_tmp
#                                                                                                                                   
#      AFTER FIELD ruy02                                                                                                         
#         IF cl_null(l_newdate) THEN                                                                                                
#            NEXT FIELD ruy02                                                                                                   
#         END IF  
#     AFTER FIELD ruy09                                                                                                         
#         IF cl_null(l_newdate) THEN                                                                                                
#            NEXT FIELD ruy09                                                                                                    
#         END IF       
 
#      BEGIN WORK 
#    #     CALL s_auto_assign_no("aim",l_newno,l_newdate,"","ruy_file","ruy01","","","")                                      
#         CALL s_auto_assign_no("art",l_newno,l_newdate,"8","ruy_file","ruy01","","","")                                      
#           RETURNING li_result,l_newno                                                                        
#        IF (NOT li_result) THEN                                                                               
#           NEXT FIELD ruy01                                                                                                    
#        END IF                                                                                                                     
#        DISPLAY l_newno TO ruy01    
#      
#      ON ACTION CONTROLP                                                                                                           
#         CASE                                                                                                                      
#           WHEN INFIELD(ruy01)                                                                                      
#                LET g_t1 = s_get_doc_no(l_newno)                                                                 
#                CALL q_smy(FALSE,FALSE,g_t1,'AIM','H') RETURNING g_t1                                                              
#                LET l_newno=g_t1                                                                 
#                DISPLAY l_newno TO ruy01                                                                                       
#                NEXT FIELD ruy01                                                                                               
#        END CASE            
#          
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#     ON ACTION about          
#        CALL cl_about()       
#
#     ON ACTION help           
#        CALL cl_show_help()   
#
#     ON ACTION controlg       
#        CALL cl_cmdask()      
#
#
#   END INPUT
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      DISPLAY BY NAME g_ruy.ruy01
#      ROLLBACK WORK
#      RETURN
#   END IF
 
#   DROP TABLE y
 
#   SELECT * FROM ruy_file         #等芛葩秶
#       WHERE ruy01=g_ruy.ruy01
#       INTO TEMP y
 
#   UPDATE y
#       SET ruy01=l_newno,    #陔腔瑩硉
#           ruy09=l_tmp,
#           ruy08='0',
#           ruyuser=g_user,   #訧蹋垀衄氪
#           ruygrup=g_grup,   #訧蹋垀衄氪垀扽
#           ruymodu=NULL,     #訧蹋党蜊
#           ruydate=g_today,  #訧蹋膘蕾
#           ruyacti='Y'       #衄虴訧蹋
 
#   INSERT INTO ruy_file
#       SELECT * FROM y
#   IF SQLCA.sqlcode THEN
#       CALL cl_err3("ins","ruy_file","","",SQLCA.sqlcode,"","",1)  
#       ROLLBACK WORK
#       RETURN
#   ELSE
#       COMMIT WORK    #wujie 070820
#   END IF
 
#   DROP TABLE x
 
#   SELECT * FROM ruz_file         #等旯葩秶
#       WHERE ruz01=g_ruy.ruy01
#       INTO TEMP x
#   IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
#       CALL cl_err("",SQLCA.sqlcode,1)  
#       ROLLBACK WORK   #wujie 070820
#       RETURN
#   END IF
 
#   UPDATE x
#       SET ruz01=l_newno
 
#   INSERT INTO ruz_file
#       SELECT * FROM x
#   IF SQLCA.sqlcode THEN
#       ROLLBACK WORK 
#        CALL cl_err3("ins","ruz_file","","",SQLCA.sqlcode,"","",1)  
#       CALL cl_err('',SQLCA.sqlcode,1)  
#       RETURN
#   ELSE
#       COMMIT WORK 
#   END IF
#   LET g_cnt=SQLCA.SQLERRD[3]
#   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
#
#    LET l_oldno = g_ruy.ruy01
#    SELECT ROWID,ruy_file.* INTO g_ruy.ruy01,g_ruy.* FROM ruy_file WHERE ruy01 = l_newno
#    CALL t213_u()
#    CALL t213_b()
#    SELECT ROWID,ruy_file.* INTO g_ruy.ruy01,g_ruy.* FROM ruy_file WHERE ruy01 = l_oldno
#    CALL t213_show()
 
#END FUNCTION 
 
FUNCTION t213_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) AND INFIELD(ruy02) THEN
     CALL cl_set_comp_entry("ruy03,ruy05,ruy06",TRUE)
  END IF
END FUNCTION
 
FUNCTION t213_set_no_entry(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1   
 
  IF p_cmd='a' AND ( NOT g_before_input_done) AND INFIELD(ruy02) THEN
     CALL cl_set_comp_entry("ruy03,ruy05,ruy06",FALSE)
  END IF
 
  IF p_cmd='u' AND g_chkey='N' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ruy01,ruy02,ruy03",FALSE)
  END IF
   
END FUNCTION
 
FUNCTION t213_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",TRUE)
  END IF
END FUNCTION
 
FUNCTION t213_set_no_entry_b(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1  
  IF p_cmd='u' OR p_cmd='a'  AND g_chkey='N' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",FALSE)
  END IF
END FUNCTION   
 
FUNCTION t213_y_chk()
 
   LET g_success = 'Y'
   IF g_ruy.ruy01 IS NULL OR g_ruy.ruyplant IS NULL THEN RETURN END IF
#CHI-C30107 ------------ add -------------- begin
   IF g_ruy.ruyconf='Y' THEN
       CALL cl_err('','9023',0)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_ruy.ruyconf='X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ruy.ruyacti = 'N' THEN
      CALL cl_err('','9028',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
#CHI-C30107 ------------ add -------------- end
    SELECT * INTO g_ruy.* FROM ruy_file
     WHERE ruy01=g_ruy.ruy01
   IF g_ruy.ruyconf='Y' THEN          
       CALL cl_err('','9023',0)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_ruy.ruyconf='X' THEN            
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ruy.ruyacti = 'N' THEN                                                                                                      
      CALL cl_err('','9028',0)                                                                                                      
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF      
END FUNCTION
 
FUNCTION t213_y_upd()
   LET g_success = 'Y'
 
   CALL t213_y()
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_ruy.ruy900='1'      
      CALL cl_flow_notify(g_ruy.ruy01,'Y')
  #   DISPLAY BY NAME g_ruy.ruy900                            #TQC-AB0291  mark
      DISPLAY BY NAME g_ruy.ruy900                            #FUN-B30084  add
   ELSE
      ROLLBACK WORK
      LET g_ruy.ruyconf='N'
      LET g_success = 'N'
   END IF
 
   SELECT * INTO g_ruy.* FROM ruy_file 
    WHERE ruy01 = g_ruy.ruy01 
   CALL t213_pic()
END FUNCTION
 
FUNCTION t213_y()
#DEFINE l_flag  LIKE type_file.num5      #FUN-B30084 mark
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   #add  FUN-AB0078
   IF NOT s_chk_ware(g_ruy.ruy06) THEN #检查仓库是否属于当前门店
      LET g_success='N'
      RETURN
   END IF
   #end  FUN-AB0078
 
#   LET l_flag = 1                        #FUN-B30084 mark
   BEGIN WORK
 
   OPEN t213_cl USING g_ruy.ruy01
   IF STATUS THEN
       CALL cl_err("OPEN t213_cl:", STATUS, 1)
       CLOSE t213_cl
       LET g_success = 'N'
       RETURN
   END IF
    FETCH t213_cl INTO g_ruy.*               # 對DB鎖定
    LET g_ruy.ruyconf = 'Y'
    LET g_ruy.ruycond = g_today
    LET g_ruy.ruyconu = g_user 
    UPDATE ruy_file 
       SET ruyconf = g_ruy.ruyconf,
           ruycond = g_ruy.ruycond,
           ruyconu = g_ruy.ruyconu
     WHERE ruy01 = g_ruy.ruy01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","ruy_file",g_ruy.ruy01,"",SQLCA.sqlcode,"","",0)
       LET g_ruy.ruyconf = 'N'
       LET g_success = 'N'
       RETURN
    END IF
    CLOSE t213_cl
#FUN-B30084 ----------mark----------begin
#   CALL t213_chang_check_data() RETURNING l_flag
#   IF l_flag = 0 THEN 
#      LET g_ruy.ruyconf = 'N'
#      LET g_ruy.ruycond = ''
#      LET g_ruy.ruyconu = ''
#      LET g_success = 'N'
#      RETURN       
#   END IF
#FUN-B30084 ----------mark----------end
    CALL t213_pic()
    DISPLAY BY NAME g_ruy.ruyconf,g_ruy.ruycond,g_ruy.ruyconu
    
END FUNCTION 
 
#FUN-B30084 ------------------STA
FUNCTION t213_post()
DEFINE l_flag  LIKE type_file.num5

   IF g_ruy.ruy01 IS NULL OR g_ruy.ruyplant IS NULL THEN RETURN END IF
   SELECT * INTO g_ruy.* FROM ruy_file
    WHERE ruy01=g_ruy.ruy01
   IF g_ruy.ruyconf <> 'Y' THEN 
      CALL cl_err('','alm-194',0)
      RETURN
   END IF       
   IF g_ruy.ruy900 = '2' THEN
      CALL cl_err('','alm-937',0)
      RETURN
   END IF
   IF g_ruy.ruyacti = 'N' THEN 
      CALL cl_err('','aec-090',0)
      RETURN 
   END IF
   IF NOT cl_confirm('art-859') THEN RETURN END IF
   LET l_flag = 1
   LET g_success = 'Y'
   BEGIN WORK

   OPEN t213_cl USING g_ruy.ruy01
   IF STATUS THEN
       CALL cl_err("OPEN t213_cl:", STATUS, 1)
       CLOSE t213_cl
       LET g_success = 'N'
       RETURN
   END IF
    FETCH t213_cl INTO g_ruy.*               # 對DB鎖定
   cALL t213_chang_check_data() RETURNING l_flag
   IF l_flag = 0 THEN
       LET g_success = 'N'
   ELSE
       UPDATE ruy_file
          SET ruy900 = '2'
        WHERE ruy01 = g_ruy.ruy01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","ruy_file",g_ruy.ruy01,"",SQLCA.sqlcode,"","",0)
          LET g_success = 'N'
       END IF
   END IF
   IF g_success = 'Y' THEN
      CLOSE t213_cl
      COMMIT WORK
   ELSE
      CLOSE t213_cl
      ROLLBACK WORK
   END IF
   SELECT ruy900 INTO g_ruy.ruy900 FROM ruy_file
    WHERE ruy01 = g_ruy.ruy01 
   DISPLAY BY NAME g_ruy.ruy900 
   
END FUNCTION
#FUN-B30084 ------------------END

#根據變更數調整盤點單(審核時調用)
FUNCTION t213_chang_check_data()
DEFINE i,i_min LIKE type_file.num5          
DEFINE l_rux01 LIKE rux_file.rux01,    #盤點單號
       l_rux03 LIKE rux_file.rux03,    #商品編碼
       l_rux07 LIKE rux_file.rux07     #變更數量
DEFINE l_ruw03 LIKE ruw_file.ruw01     #盤差調整單號
 
   LET l_ruw03 = NULL
   #是否可以調整
   SELECT ruw03
     INTO l_ruw03
     FROM ruw_file
    WHERE ruw00 = '1' AND ruw01 = g_ruy.ruy03
   IF l_ruw03 IS NOT NULL THEN 
      CALL cl_err('','art-592',0)
      RETURN 0
   END IF
   LET l_rux01 = g_ruy.ruy03
   LET i_min = 1
   FOR i = i_min TO g_rec_b
      LET l_rux03 = g_ruz[i].ruz03
      LET l_rux07 = g_ruz[i].ruz09
      IF l_rux07 IS NULL THEN LET l_rux07 = 0 END IF
      UPDATE rux_file 
         SET rux07 = rux07 + l_rux07,
             rux08 = rux06+rux07+l_rux07-rux05 
       WHERE rux01 = l_rux01
         AND rux03 = l_rux03
         AND rux00 = '1'
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rux_file",l_rux01,"",SQLCA.sqlcode,"","",1) 
         RETURN 0
      END IF
   END FOR
   CALL cl_msgany(0,0, "盤點單調整完畢....")
   RETURN 1
END FUNCTION
 
FUNCTION t213_un()
#DEFINE l_flag LIKE type_file.chr1         #FUN-B30084 mark
 
#   LET l_flag=1                           #FUN-B30084 mark
 
   IF g_ruy.ruy01 IS NULL OR g_ruy.ruyplant IS NULL THEN RETURN END IF  
#FUN-B30084 ----------mark-------------begin
#  IF g_ruy.ruy900 = 'S' THEN
#     CALL cl_err(g_ruy.ruyplant,'apm-030',1)
#     RETURN
#  END IF
#FUN-B30084 ----------mark-------------end
   IF g_ruy.ruy900 = '2' THEN CALL cl_err('','art-123',0) RETURN END IF       #FUN-B30084 add
   SELECT * INTO g_ruy.* FROM ruy_file WHERE ruy01=g_ruy.ruy01 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ruy_file",g_ruy.ruy01,"",SQLCA.sqlcode,"","sel ruy_file",1)
      RETURN
   END IF
   IF g_ruy.ruyconf='N'             THEN RETURN END IF
   IF g_ruy.ruyconf='X'             THEN CALL cl_err('','9024',0) RETURN END IF
#   IF g_ruy.ruy900 MATCHES '[269]' THEN RETURN END IF    #FUN-B30084  mark
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t213_cl USING g_ruy.ruy01
   IF STATUS THEN
      CALL cl_err("OPEN t213_cl:", STATUS, 1)
      CLOSE t213_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t213_cl INTO g_ruy.*      
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruy.ruy01,SQLCA.sqlcode,0)
      CLOSE t213_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t213_z1()
   CLOSE t213_cl
#FUN-B30084 ----------mark -----------begin
#  CALL t213_chang_check_data_1() RETURNING l_flag
#  IF l_flag=0 THEN
#     LET g_ruy.ruyconf= 'Y'
#     ROLLBACK WORK
#     LET g_success='N'
#     RETURN
#  END IF   
#FUN-B30084 ---------mark ------------end
   IF g_success = 'Y' THEN
     #CHI-D20015 Mark&Add Str
     #LET g_ruy.ruyconu=''
     #LET g_ruy.ruycond=''
      LET g_ruy.ruyconu=g_user
      LET g_ruy.ruycond=g_today
     #CHI-D20015 Mark&Add End
      LET g_ruy.ruyconf='N' COMMIT WORK
      DISPLAY BY NAME g_ruy.ruyconf
      DISPLAY BY NAME g_ruy.ruyconu                                                                                             
      DISPLAY BY NAME g_ruy.ruycond  
      CALL t213_ruyconu('d')                                                                                           
 #     DISPLAY BY NAME g_ruy.ruy900               #TQC-AB0291 mark
   ELSE
      LET g_ruy.ruyconf = 'Y'
      ROLLBACK WORK
   END IF
 
   CALL t213_pic() 
END FUNCTION
 
FUNCTION t213_v(p_type)
   DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废 
   DEFINE l_n       LIKE type_file.num5 
   DEFINE l_ruz02   LIKE ruz_file.ruz02   
 
   IF cl_null(g_ruy.ruy01) THEN RETURN END IF
   IF cl_null(g_ruy.ruyplant) THEN RETURN END IF      
   SELECT * INTO g_ruy.* FROM ruy_file WHERE ruy01=g_ruy.ruy01
   
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_ruy.ruyconf='X' THEN RETURN END IF
    ELSE
       IF g_ruy.ruyconf <>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_ruy.ruyconf ='Y' THEN CALL cl_err('','9023',0) RETURN  END IF
   IF g_ruy.ruy900 NOT MATCHES '[0RW9]' THEN RETURN END IF 
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t213_cl USING g_ruy.ruy01
   IF STATUS THEN
      CALL cl_err("OPEN t213_cl:", STATUS, 1)
      CLOSE t213_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t213_cl INTO g_ruy.*  
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruy.ruy01,SQLCA.sqlcode,0)
      CLOSE t213_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_ruy.ruyconf) THEN
      IF g_ruy.ruyconf ='N' THEN
         LET g_ruy.ruyconf='X'
         LET g_ruy.ruy900='9'
      ELSE
         LET g_ruy.ruyconf='N'
         LET g_ruy.ruy900='0'
      END IF
      UPDATE ruy_file SET
             ruyconf=g_ruy.ruyconf,
             ruy900=g_ruy.ruy900,
             ruymodu=g_user,
             ruydate=g_today
          WHERE ruy01 = g_ruy.ruy01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruy_file",g_ruy.ruy01,"",STATUS,"","x_upd ruyconf",1) 
         LET g_success = 'N' 
      END IF
   END IF
   CLOSE t213_cl
   CALL s_showmsg()      
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruy.ruy01,'V')
   ELSE
      ROLLBACK WORK
   END IF
#TQC-AB0291 ----------------STA
#  SELECT ruyconf,ruy900,ruymksg
#    INTO g_ruy.ruyconf,g_ruy.ruy900,g_ruy.ruymksg FROM ruy_file
#   WHERE ruy01=g_ruy.ruy01 
#  DISPLAY BY NAME g_ruy.ruyconf,g_ruy.ruy900,g_ruy.ruymksg
   SELECT ruyconf,ruy900 INTO g_ruy.ruyconf,g_ruy.ruy900
     FROM ruy_file
    WHERE ruy01=g_ruy.ruy01
#   DISPLAY BY NAME g_ruy.ruyconf,g_ruy.ruy900           #TQC-AB0291  mark
   DISPLAY BY NAME g_ruy.ruyconf                         #TQC-AB0291
#TQC-AB0291 ----------------END
 
   CALL t213_pic() 
END FUNCTION
 
FUNCTION t213_pic()
   IF g_ruy.ruyconf = 'X' THEN
      LET g_chr = 'Y'
   ELSE
      LET g_chr = 'N'
   END IF
 
   IF g_ruy.ruy900 = '1' OR g_ruy.ruy900 = '2' THEN
      LET g_chr2 = 'Y'
   ELSE
      LET g_chr2 = 'N'
   END IF
 
   IF g_ruy.ruy900 = '6' THEN
      LET g_chr3 = 'Y'
   ELSE
      LET g_chr3 = 'N'
   END IF
 
   CALL cl_set_field_pic(g_ruy.ruyconf,g_chr2,"",g_chr3,g_chr,"")
END FUNCTION
 
FUNCTION t213_z1()
   DEFINE l_ruz         RECORD LIKE ruz_file.*
 
   LET g_ruy.ruy900=0
   LET g_ruy.ruyconf='N'
   LET g_ruy.ruysseq=0
  #CHI-D20015 Mark&Add Str
  #LET g_ruy.ruyconu=''
  #LET g_ruy.ruycond=''
   LET g_ruy.ruyconu=g_user
   LET g_ruy.ruycond=g_today
  #CHI-D20015 Mark&Add End
   UPDATE ruy_file  SET
          ruyconf=g_ruy.ruyconf,    
          ruy900=g_ruy.ruy900,                                                                                                     
          ruysseq=g_ruy.ruysseq,
          ruyconu=g_ruy.ruyconu,  
          ruycond=g_ruy.ruycond                                                                                                    
       WHERE ruy01 = g_ruy.ruy01 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ruy_file",g_ruy.ruy01,"",STATUS,"","upd ruyconf",1)
      LET g_success = 'N' RETURN
   END IF
   
END FUNCTION 

#FUN-B30084 -------------mark--------------begin 
#根據變更數調整盤點單(取消審核時調用) 
#FUNCTION t213_chang_check_data_1()
#DEFINE i,i_min LIKE type_file.num5                                                                                            
#DEFINE l_rux01 LIKE rux_file.rux01,    #盤點單號                                                                                    
#       l_rux03 LIKE rux_file.rux03     #商品編碼                                                                                    
#DEFINE l_rux07 LIKE rux_file.rux07     #bnl -090205 add
#                                                                                                                                   
#  LET l_rux01 = g_ruy.ruy03                                                                                                        
#  LET i_min = 1                                                                                                                    
#  FOR i = i_min TO g_rec_b                                                                                                         
#     LET l_rux03 = g_ruz[i].ruz03                                                                                                  
#     LET l_rux07 = g_ruz[i].ruz09
#     UPDATE rux_file                                                                                                               
#        SET rux07 = rux07 - l_rux07,  #bnl -090205 mod                                                                                                        
#            rux08 = rux08 - l_rux07   #bnl -090205 mod                                                                                     
#      WHERE rux01 = l_rux01                                                                                                        
#        AND rux03 = l_rux03                                                                                                        
#     IF SQLCA.sqlcode THEN                                                                                                         
#        CALL cl_err3("upd","rux_file",l_rux01,"",SQLCA.sqlcode,"","",1)                                                            
#        ROLLBACK WORK                                                                                                              
#        RETURN 0                                                                                                                   
#     END IF                                                                                                                        
#  END FOR             
#  CALL cl_err('','art-593',0)                                                                                                             
#  RETURN 1                                                                                                                         
#END FUNCTION        
#FUN-B30084 -------------mark--------------end
#FUN-960130
                  
