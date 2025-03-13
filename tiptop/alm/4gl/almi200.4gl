# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: almi200.4gl
# Descriptions...: 經營小類與攤位關系維護作業 
# Date & Author..: NO.FUN-960058 09/06/12 By  destiny  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A60010 10/07/12 By huangtao 小类代号用產品分類代替
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lml           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        lml01       LIKE lml_file.lml01,        
        lml02       LIKE lml_file.lml02,        
#       lmk02       LIKE lmk_file.lmk02,   
        oba02       LIKE oba_file.oba02,      #FUN-A60010
        lmlstore    LIKE lml_file.lmlstore,   
        rtz13       LIKE rtz_file.rtz13,   #FUN-A80148 add
        lmllegal    LIKE lml_file.lmllegal,
        azt02       LIKE azt_file.azt02,   
        lml04       LIKE lml_file.lml04, 
        lmb03       LIKE lmb_file.lmb03,
        lml05       LIKE lml_file.lml05,
        lmc04       LIKE lmc_file.lmc04,
        lml06       LIKE lml_file.lml06
                    END RECORD,
     g_lml_t         RECORD                #程式變數 (舊值)
        lml01       LIKE lml_file.lml01,   
        lml02       LIKE lml_file.lml02,
#       lmk02       LIKE lmk_file.lmk02,
        oba02       LIKE oba_file.oba02,      #FUN-A60010
        lmlstore    LIKE lml_file.lmlstore,   
        rtz13       LIKE rtz_file.rtz13,   #FUN-A80148 add
        lmllegal    LIKE lml_file.lmllegal,
        azt02       LIKE azt_file.azt02,   
        lml04       LIKE lml_file.lml04, 
        lmb03       LIKE lmb_file.lmb03,
        lml05       LIKE lml_file.lml05,
        lmc04       LIKE lmc_file.lmc04,
        lml06       LIKE lml_file.lml06
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,         
    g_rec_b         LIKE type_file.num5,                #單身筆數     
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        
DEFINE g_before_input_done   LIKE type_file.num5        
 
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
    OPEN WINDOW i200_w WITH FORM "alm/42f/almi200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i200_b_fill(g_wc2)
    CALL i200_menu()
    CLOSE WINDOW i200_w                    #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i200_menu()
 DEFINE l_cmd   LIKE type_file.chr1000 
 DEFINE l_lmlstore LIKE lml_file.lmlstore                                  
   WHILE TRUE
      CALL i200_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()
               IF l_ac > 0 THEN
                  SELECT lmlstore INTO l_lmlstore FROM lml_file
                   WHERE lml01=g_lml[l_ac].lml01
                     AND lml02=g_lml[l_ac].lml02
#                  IF cl_chk_mach_auth(l_lmlstore,g_plant) THEN            
                     CALL i200_b()
#                  END IF    
               ELSE
                  CALL i200_b()
                  LET g_action_choice = NULL
               END IF	
            ELSE 
               LET g_action_choice = NULL
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL i200_out()                                        
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lml[l_ac].lml01 IS NOT NULL THEN
                  LET g_doc.column1 = "lml01"
                  LET g_doc.value1 = g_lml[l_ac].lml01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lml),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i200_q()
   CALL i200_b_askkey()
END FUNCTION
 
FUNCTION i200_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,
   l_n2            LIKE type_file.num5,
   l_n3            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
#   l_lmk05         LIKE lmk_file.lmk05,     #FUN-A60010   
   l_obaacti       LIKE oba_file.obaacti,    #FUN-A60010       
   l_lml02         LIKE lml_file.lml02,
   l_lmf06         LIKE lmf_file.lmf06,
   l_count         LIKE type_file.num5,
#  l_tqa06         LIKE tqa_file.tqa06,                #No.FUN-960058
   l_azt02         LIKE azt_file.azt02,
   l_rtz13         LIKE rtz_file.rtz13,    #FUN-A80148 add
   l_n4            LIKE type_file.num5, 
   l_n5            LIKE type_file.num5,        #FUN-A60010
   l_n6            LIKE type_file.num5        #FUN-A60010   
    
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   
#No.FUN-960058--begin   
#   SELECT tqa06 INTO l_tqa06 FROM tqa_file
#    WHERE tqa03 = '14'       	 
#      AND tqaacti = 'Y'
#      AND tqa01 IN(SELECT tqb03 FROM tqb_file
#     	              WHERE tqbacti = 'Y'
#     	                AND tqb09 = '2'
#     	                AND tqb01 = g_plant) 
#   IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
#      CALL cl_err('','alm-600',1)
#      RETURN 
#   END IF 
#No.FUN-960058--end
   
   SELECT COUNT(*) INTO l_count FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
    IF l_count < 1 THEN 
       CALL cl_err('','alm-606',1)
       RETURN 
    END IF
    
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lml01,lml02,'',lmlstore,'',lmllegal,'',lml04,'',lml05,'',lml06",  
                      "  FROM lml_file WHERE lml01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lml WITHOUT DEFAULTS FROM s_lml.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
 
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'                                                
             LET g_before_input_done = FALSE                                    
             LET g_before_input_done = TRUE                                             
             LET g_lml_t.* = g_lml[l_ac].*  #BACKUP
             OPEN i200_bcl USING g_lml_t.lml01
             IF STATUS THEN
                CALL cl_err("OPEN i200_bcl:",STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i200_bcl INTO g_lml[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lml_t.lml01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   CALL i200_oba02('d',l_ac)
                   CALL i200_lml01('d')
                END IF
             END IF
             CALL cl_show_fld_cont()     
             DISPLAY BY NAME g_lml[l_ac].lmllegal
             SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lml[l_ac].lmllegal
             LET g_lml[l_ac].azt02=l_azt02
             DISPLAY BY NAME g_lml[l_ac].azt02
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lml[l_ac].* TO NULL   
          LET g_lml[l_ac].lml06 = 'Y'  
          LET g_lml[l_ac].lmllegal=g_legal
#         LET g_lml[l_ac].lmlstore=g_plant
          DISPLAY BY NAME g_lml[l_ac].lmllegal
#         DISPLAY BY NAME g_lml[l_ac].lmlstore
#         SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lml[l_ac].lmlstore
          SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lml[l_ac].lmllegal  
          LET g_lml[l_ac].azt02=l_azt02
          DISPLAY BY NAME g_lml[l_ac].azt02
#          LET g_lml[l_ac].rtz13=l_rtz13
          LET g_lml_t.* = g_lml[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD lml01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i200_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lml_file(lml01,lml02,lmlstore,lmllegal,lml04,lml05,lml06)   
          VALUES(g_lml[l_ac].lml01,g_lml[l_ac].lml02,g_lml[l_ac].lmlstore,g_lml[l_ac].lmllegal,
                 g_lml[l_ac].lml04,g_lml[l_ac].lml05,g_lml[l_ac].lml06)  
          IF SQLCA.sqlcode THEN   
             CALL cl_err3("ins","lml_file",g_lml[l_ac].lml01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
              
            
       AFTER FIELD lml01                        #check 編號是否重複
          IF NOT cl_null(g_lml[l_ac].lml01) THEN 
             IF g_lml[l_ac].lml01 != g_lml_t.lml01 OR
                g_lml_t.lml01 IS NULL THEN
                SELECT count(*) INTO l_n1 FROM lml_file
                 WHERE lml01 = g_lml[l_ac].lml01     
                 IF l_n1>0 THEN 
                    CALL cl_err('','-239',1)
                    LET g_lml[l_ac].lml01= g_lml_t.lml01                                                                                
                    NEXT FIELD lml01   
                 END IF 
                 CALL i200_lml01('a') 
                 IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_lml[l_ac].lml01 = g_lml_t.lml01
                   NEXT FIELD lml01
                END IF                                                                                          
              END IF      
          ELSE 
       	     LET g_lml[l_ac].lmlstore=''
             DISPLAY BY NAME g_lml[l_ac].lmlstore
             LET g_lml[l_ac].lml04=''
             DISPLAY BY NAME g_lml[l_ac].lml04
             LET g_lml[l_ac].lml05=''
             DISPLAY BY NAME g_lml[l_ac].lml05
             LET g_lml[l_ac].rtz13='' 
             DISPLAY BY NAME g_lml[l_ac].rtz13
             LET g_lml[l_ac].lmb03=''
             DISPLAY BY NAME g_lml[l_ac].lmb03
             LET g_lml[l_ac].lmc04=''
             DISPLAY BY NAME g_lml[l_ac].lmc04 
          END IF
           
        AFTER FIELD lml02
           IF NOT cl_null(g_lml[l_ac].lml02) THEN                          
              IF g_lml[l_ac].lml02 != g_lml_t.lml02 OR
                 g_lml_t.lml02 IS NULL THEN
      #           SELECT count(*) INTO l_n2 FROM lmk_file WHERE lmk01= g_lml[l_ac].lml02        #FUN-A60010
      #FUN-A60010 add--------------start----------------------------------
                 SELECT count(*) INTO l_n5 FROM oba_file 
                  WHERE oba01= g_lml[l_ac].lml02 
                 IF l_n5 >0 THEN
      #FUN-A60010 add -----------end--------------------------------------

               SELECT count(*) INTO l_n2 FROM oba_file 
                 WHERE oba01= g_lml[l_ac].lml02 AND  oba14='0'         #FUN-A60010
                 IF l_n2 = 0 THEN 
       #FUN-A60010 add ---------------start----------------------------------
                    SELECT count(*) INTO l_n6 FROM oba_file 
                    WHERE oba01= g_lml[l_ac].lml02 AND  oba14<>'0'
                    IF l_n6> 0 THEN   
                       CALL cl_err('','alm-846',0)
                       LET g_lml[l_ac].lml02 = g_lml_t.lml02
                       NEXT FIELD lml02
                    ELSE   
       #FUN-A60010  add-------------------------end---------------------------          
                       CALL cl_err('','alm-845',1)                         #FUN-A60010
                       LET g_lml[l_ac].lml02 = g_lml_t.lml02
                       NEXT FIELD lml02
                    END IF
                 ELSE 
      #              SELECT lmk05 INTO l_lmk05 FROM lmk_file WHERE  lmk01= g_lml[l_ac].lml02    #FUN-A60010
                      SELECT obaacti INTO l_obaacti FROM oba_file WHERE  oba01= g_lml[l_ac].lml02  #FUN-A60010
                       IF l_obaacti ='N' THEN                 
                          CALL cl_err('','9028',1)
                          LET g_lml[l_ac].lml02 = g_lml_t.lml02
                          NEXT FIELD lml02
                       END IF
                 END IF
               ELSE
                 CALL cl_err('','alm-845',0)
                 LET g_lml[l_ac].lml02 = g_lml_t.lml02
                 NEXT FIELD lml02
               END IF
               END IF                                          #FUN-A60010
               CALL i200_oba02('d',l_ac)
            ELSE 
       	       LET g_lml[l_ac].oba02=''                        #FUN-A60010
               DISPLAY BY NAME g_lml[l_ac].oba02              #FUN-A60010
            END IF  
          
       AFTER FIELD lml06
          IF NOT cl_null(g_lml[l_ac].lml06) THEN
             IF g_lml[l_ac].lml06 NOT MATCHES '[YN]' THEN 
                LET g_lml[l_ac].lml06 = g_lml_t.lml06
                NEXT FIELD lml06
             END IF
          END IF
          IF NOT cl_null(g_lml[l_ac].lml06) THEN                                                                                    
             IF g_lml[l_ac].lml06 != g_lml_t.lml06 THEN                                                                             
                SELECT COUNT(*) INTO l_n3 FROM lnt_file 
                 WHERE lnt06=g_lml_t.lml01 AND lnt33=g_lml_t.lml02                                                                                                     
                IF l_n3 > 0 THEN                                                                                                    
                   CALL cl_err('','alm-681',1)                                                                                      
                   LET g_lml[l_ac].lml06 = g_lml_t.lml06                                                                            
                   NEXT FIELD lml06                                                                                                 
                END IF                                                                                                              
              END IF                                                                                                                
          END IF 
          
       BEFORE DELETE                            #是否取消單身
          IF g_lml_t.lml01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lml01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lml[l_ac].lml01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             SELECT COUNT(*) INTO l_n4 FROM lnt_file 
               WHERE lnt06=g_lml_t.lml01 AND lnt33=g_lml_t.lml02
             IF l_n4 >0 THEN 
                CALL cl_err('','alm-681',1)
                CANCEL DELETE
             END IF 
             DELETE FROM lml_file WHERE lml01 = g_lml_t.lml01  
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lml_file",g_lml_t.lml01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lml[l_ac].* = g_lml_t.*
             CLOSE i200_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lml[l_ac].lml01,-263,0)
             LET g_lml[l_ac].* = g_lml_t.*
          ELSE
             CALL i200_lml01('a')
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                NEXT FIELD lml01 
             END IF   
             UPDATE lml_file SET lml01=g_lml[l_ac].lml01,
                                 lml02=g_lml[l_ac].lml02,
                                 lml06=g_lml[l_ac].lml06
              WHERE lml01 = g_lml_t.lml01 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lml_file",g_lml_t.lml01,"",SQLCA.sqlcode,"","",1) 
                LET g_lml[l_ac].* = g_lml_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
          LET l_ac_t = l_ac                # 新增
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lml[l_ac].* = g_lml_t.*
             END IF
             CLOSE i200_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF
 
          CLOSE i200_bcl               # 新增
          COMMIT WORK
          
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(lml01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lmf_1"
                 LET g_qryparam.default1 = g_lml[l_ac].lml01
                 LET g_qryparam.where = " lmfstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_lml[l_ac].lml01
                 DISPLAY BY NAME g_lml[l_ac].lml01
                 CALL i200_lml01('d')
                 NEXT FIELD lml01
                    
              WHEN INFIELD(lml02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oba_11"        #FUN-A60010
                 LET g_qryparam.default1 = g_lml[l_ac].lml02
                 CALL cl_create_qry() RETURNING g_lml[l_ac].lml02
                 DISPLAY BY NAME g_lml[l_ac].lml02
                 CALL i200_oba02('d',l_ac)
                 NEXT FIELD lml02   
           END CASE
           
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lml01) AND l_ac > 1 THEN
             LET g_lml[l_ac].* = g_lml[l_ac-1].*
             NEXT FIELD lml01
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
          
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       
   END INPUT
 
   CLOSE i200_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i200_b_askkey()
 
   CLEAR FORM
   CALL g_lml.clear()
   LET l_ac =1
   CONSTRUCT g_wc2 ON lml01,lml02,lmlstore,lmllegal,lml04,lml05,lml06
        FROM s_lml[1].lml01,s_lml[1].lml02,s_lml[1].lmlstore,s_lml[1].lmllegal,
             s_lml[1].lml04,s_lml[1].lml05,s_lml[1].lml06
 
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
         
      ON ACTION CONTROLP
          CASE
            WHEN INFIELD(lml01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lml01"
                 LET g_qryparam.state='c'
                 LET g_qryparam.where = " lmlstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lml01
                 NEXT FIELD lml01
                 
            WHEN INFIELD(lml02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lml_11"              #FUN-A60010
                 LET g_qryparam.state='c'
                 LET g_qryparam.where = " lmlstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lml02
                 NEXT FIELD lml02
                 
            WHEN INFIELD(lmlstore)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lmlstore"
                 LET g_qryparam.state='c'
                 LET g_qryparam.where = " lmlstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmlstore
                 NEXT FIELD lmlstore 
                 
            WHEN INFIELD(lmllegal)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lmllegal"
                 LET g_qryparam.state='c'
                 LET g_qryparam.where = " lmlstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lmllegal
                 NEXT FIELD lmllegal                 
                 
            WHEN INFIELD(lml04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lml04"
                 LET g_qryparam.state='c'
                 LET g_qryparam.where = " lmlstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lml04
                 NEXT FIELD lml04
                 
            WHEN INFIELD(lml05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lml05"
                 LET g_qryparam.state='c'
                 LET g_qryparam.where = " lmlstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lml05
                 NEXT FIELD lml05
          END CASE
   
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b =0 
      RETURN
   END IF
 
   CALL i200_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT lml01,lml02,'',lmlstore,'',lmllegal,'',lml04,'',lml05,'',lml06",   
        " FROM lml_file ",
        " WHERE ", g_wc2 CLIPPED,        #單身
        " AND lmlstore IN",g_auth,       #No.FUN-A10060
        " ORDER BY lml01"
    PREPARE i200_pb FROM g_sql
    DECLARE lml_curs CURSOR FOR i200_pb
 
    CALL g_lml.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lml_curs INTO g_lml[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#        SELECT lmk02 INTO g_lml[g_cnt].lmk02 FROM lmk_file
#           WHERE lmk01 =g_lml[g_cnt].lml02                    #FUN-A60010
        SELECT oba02 INTO g_lml[g_cnt].oba02  FROM oba_file
           WHERE oba01 = g_lml[g_cnt].lml02                   #FUN-A60010
           
        SELECT azt02 INTO g_lml[g_cnt].azt02 FROM azt_file 
         WHERE azt01=g_lml[g_cnt].lmllegal
        SELECT rtz13 INTO g_lml[g_cnt].rtz13 FROM rtz_file 
         WHERE rtz01 = g_lml[g_cnt].lmlstore         
        SELECT azt02 INTO g_lml[g_cnt].azt02 FROM azt_file 
         WHERE azt01 = g_lml[g_cnt].lmllegal        
        SELECT lmb03 INTO g_lml[g_cnt].lmb03 FROM lmb_file 
         WHERE lmbstore = g_lml[g_cnt].lmlstore AND lmb02 = g_lml[g_cnt].lml04
        SELECT lmc04 INTO g_lml[g_cnt].lmc04 FROM lmc_file 
         WHERE lmcstore = g_lml[g_cnt].lmlstore AND lmc02 = g_lml[g_cnt].lml04 AND lmc03 = g_lml[g_cnt].lml05 
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lml.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lml TO s_lml.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
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
 
      ON ACTION about         
         CALL cl_about()    
 
   
 
       ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUNCTION i200_out()
#DEFINE l_cmd LIKE type_file.chr1000
#
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('','9057',0)
#       RETURN
#    END IF
#    LET l_cmd = 'p_query "alml200" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd) 
#    RETURN
#END FUNCTION 
 
FUNCTION i200_oba02(p_cmd,l_cnt)
    DEFINE   p_cmd     LIKE type_file.chr1                                                                                          
    DEFINE   l_cnt     LIKE type_file.num10 
#    DEFINE   l_lmk02   LIKE lmk_file.lmk02       #FUN-A60010
#    DEFINE   l_lmk05   LIKE lmk_file.lmk05       #FUN-A60010
    DEFINE    l_oba02   LIKE oba_file.oba02
    DEFINE    l_obaacti  LIKE oba_file.obaacti
 
 
    LET g_errno = " "    
#    SELECT lmk02,lmk05 INTO l_lmk02,l_lmk05 FROM lmk_file WHERE lmk01=g_lml[l_ac].lml02   #FUN-A60010 
     SELECT oba02,obaacti INTO l_oba02,l_obaacti FROM oba_file WHERE oba01 =g_lml[l_ac].lml02  #FUN-A60010
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='-239'
                                LET l_oba02=NULL                 #FUN-A60010
       WHEN l_obaacti='N'         LET g_errno='9028'             #FUN-A60010
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd ='d' THEN 
 #      LET g_lml[l_cnt].lmk02=l_lmk02                      #FUN-A60010
 #      DISPLAY g_lml[l_cnt].lmk02 TO lmk02                 #FUN-A60010
       LET g_lml[l_cnt].oba02=l_oba02                        #FUN-A60010
        DISPLAY g_lml[l_cnt].oba02 TO oba02                  #FUN-A60010
    END IF
           
END FUNCTION 
 
FUNCTION i200_lml01(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_lmfstore   LIKE lmf_file.lmfstore
DEFINE l_lmf03      LIKE lmf_file.lmf03
DEFINE l_lmf04      LIKE lmf_file.lmf04
DEFINE l_lmf06      LIKE lmf_file.lmf06
DEFINE l_lmfacti    LIKE lmf_file.lmfacti
DEFINE l_azt02      LIKE azt_file.azt02
DEFINE l_n          LIKE type_file.num5    #FUN-A60010
#FUN-A60010-----------------------------START--------------------------------
  SELECT COUNT(lmf01) INTO l_n FROM lmf_file WHERE lmf01=g_lml[l_ac].lml01
  IF l_n >0 THEN
#FUN-A60010-----------------------------------END----------------------------
  SELECT lmfstore,lmf03,lmf04,lmf06,lmfacti 
      INTO l_lmfstore,l_lmf03,l_lmf04,l_lmf06,l_lmfacti
      FROM lmf_file 
     WHERE lmf01=g_lml[l_ac].lml01
      
      CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-009'
                                  LET l_lmfstore=NULL 
                                  LET l_lmf03=NULL 
                                  LET l_lmf04=NULL
                                  LET l_lmf06=NULL 
#          WHEN l_lmfstore <>g_plant LET g_errno='alm-376'
           WHEN l_lmfacti='N'     LET g_errno='9028'
           WHEN l_lmf06='N'       LET g_errno='alm-415'
      OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE 
    IF cl_null(g_errno) OR p_cmd= 'd' THEN   
       LET g_lml[l_ac].lmlstore =l_lmfstore    
       SELECT rtz13 INTO g_lml[l_ac].rtz13 FROM rtz_file 
        WHERE rtz01 = g_lml[l_ac].lmlstore
       LET g_lml[l_ac].lml04=l_lmf03
       SELECT lmb03 INTO g_lml[l_ac].lmb03 FROM lmb_file 
        WHERE lmbstore = g_lml[l_ac].lmlstore AND lmb02 = g_lml[l_ac].lml04
       LET g_lml[l_ac].lml05 =l_lmf04
       SELECT lmc04 INTO g_lml[l_ac].lmc04 FROM lmc_file 
        WHERE lmcstore = g_lml[l_ac].lmlstore AND lmc02 = g_lml[l_ac].lml04 AND lmc03 = g_lml[l_ac].lml05 
         
       SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lml[l_ac].lmllegal  
       LET g_lml[l_ac].azt02=l_azt02     
       DISPLAY BY NAME g_lml[l_ac].azt02  
       DISPLAY BY NAME g_lml[l_ac].lmlstore
       DISPLAY BY NAME g_lml[l_ac].lml04
       DISPLAY BY NAME g_lml[l_ac].lml05 
       DISPLAY g_lml[l_ac].rtz13 TO rtz13
       DISPLAY g_lml[l_ac].lmb03 TO lmb03
       DISPLAY g_lml[l_ac].lmc04 TO lmc04
    END IF 
#FUN-A60010 --------------------START-----------------------
    ELSE
#      CALL cl_err('','-30886',1)
      LET g_errno='-30886'
  END IF
#FUN-A60010-------------------------END-------------------           
END FUNCTION 
 
                                                
FUNCTION i200_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lml01,lml02",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i200_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lml01,lml02",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
