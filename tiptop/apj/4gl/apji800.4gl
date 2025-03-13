# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: apji800.4gl
# Descriptions...: 部門名稱
# Date & Author..: 94/12/19 destiny No.FUN-810069
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980005 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:CHI-CA0060 13/02/23 By Elise TQC-B90211mark處改抓apji010
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
#NO.FUN-810069--begin
GLOBALS "../../config/top.global"
 
DEFINE 
     g_pjx           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pjx01       LIKE pjx_file.pjx01,   #技能代碼
        #cpi02       LIKE cpi_file.cpi02,  #TQC-B90211
       #cpi02       LIKE type_file.chr100, #TQC-B90211 #CHI-CA0060 mark
        pka02       LIKE pka_file.pka02,   #CHI-CA0060
        pjx04       LIKE pjx_file.pjx04,   #直接/間接
        pjx02       LIKE pjx_file.pjx02,   #單位
        pjx03       LIKE pjx_file.pjx03,   #單位費用
        pjxacti     LIKE pjx_file.pjxacti 
                    END RECORD,
     g_pjx_t         RECORD                #程式變數 (舊值)
        pjx01       LIKE pjx_file.pjx01,   #技能代碼
        #cpi02       LIKE cpi_file.cpi02,  #TQC-B90211
       #cpi02       LIKE type_file.chr100, #TQC-B90211 #CHI-CA0060 mark
        pka02       LIKE pka_file.pka02,   #CHI-CA0060
        pjx04       LIKE pjx_file.pjx04,   #直接/間接
        pjx02       LIKE pjx_file.pjx02,   #單位
        pjx03       LIKE pjx_file.pjx03,   #單位費用
        pjxacti     LIKE pjx_file.pjxacti  
                    END RECORD,
    #g_cpiacti      LIKE cpi_file.cpiacti,   #TQC-B90211
     g_pkaacti      LIKE pka_file.pkaacti,   #CHI-CA0060 add
#    g_wc2,g_sql    LIKE type_file.chr1000,
    g_wc2,g_sql    STRING,      #No.FUN-910082            
    g_rec_b        LIKE type_file.num5,                #單身筆數     
    l_ac           LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt        LIKE type_file.num10            
DEFINE g_i          LIKE type_file.num5            
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE l_pjx01      LIKE pjx_file.pjx01
DEFINE l_pjx02      LIKE pjx_file.pjx02
MAIN
 
DEFINE p_row,p_col   LIKE type_file.num5       
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i800_w AT p_row,p_col WITH FORM "apj/42f/apji800"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i800_b_fill(g_wc2)
    CALL i800_menu()
    CLOSE WINDOW i800_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time    
END MAIN
 
FUNCTION i800_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                  
   WHILE TRUE
      CALL i800_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i800_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i800_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i800_out()                                        
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_pjx[l_ac].pjx01 IS NOT NULL THEN
                  LET g_doc.column1 = "pjx01"
                  LET g_doc.value1 = g_pjx[l_ac].pjx01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjx),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i800_q()
   CALL i800_b_askkey()
END FUNCTION
 
FUNCTION i800_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   
   l_n             LIKE type_file.num5,                #檢查重複用  
   l_n1            LIKE type_file.num5,                #檢查重複用  
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否    
   p_cmd           LIKE type_file.chr1,                #處理狀態      
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
   l_gfe01         LIKE gfe_file.gfe01,
   l_gfeacti       LIKE gfe_file.gfeacti
   
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT pjx01,'',pjx04,pjx02,pjx03,pjxacti",   
                      "  FROM pjx_file WHERE pjx01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_pjx WITHOUT DEFAULTS FROM s_pjx.*
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
             CALL i800_set_entry(p_cmd)                                         
             CALL i800_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                             
             LET g_pjx_t.* = g_pjx[l_ac].*  #BACKUP
             OPEN i800_bcl USING g_pjx_t.pjx01
             IF STATUS THEN
                CALL cl_err("OPEN i800_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i800_bcl INTO g_pjx[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_pjx_t.pjx01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   #CALL i800_cpi02('d',l_ac)   #TQC-B90211
                    CALL i010_pka02('d',l_ac)   #CHI-CA0060 add
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          CALL i800_set_entry(p_cmd)                                            
          CALL i800_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_pjx[l_ac].* TO NULL     
          LET g_pjx[l_ac].pjxacti = 'Y'       
          LET g_pjx_t.* = g_pjx[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD pjx01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i800_bcl
             CANCEL INSERT
          END IF
          INSERT INTO pjx_file(pjx01,pjx02,pjx03,pjx04,pjxacti,pjxuser,pjxdate,
                               pjxplant,pjxlegal,pjxoriu,pjxorig) #FUN-980005   
          VALUES(g_pjx[l_ac].pjx01,g_pjx[l_ac].pjx02,g_pjx[l_ac].pjx03,g_pjx[l_ac].pjx04,
                 g_pjx[l_ac].pjxacti,g_user,g_today,
                 g_plant,g_legal, g_user, g_grup)  #FUN-980005         #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","pjx_file",g_pjx[l_ac].pjx01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD pjx01                                 #KEY值不能重復            
          IF NOT cl_null(g_pjx[l_ac].pjx01) THEN 
             #CALL i800_cpi02('d',l_ac)   #TQC-B90211
              CALL i010_pka02('d',l_ac)   #CHI-CA0060 add
             IF g_pjx[l_ac].pjx01 != g_pjx_t.pjx01 OR
                g_pjx_t.pjx01 IS NULL THEN
                SELECT count(*) INTO l_n FROM pjx_file
                 WHERE pjx01 = g_pjx[l_ac].pjx01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_pjx[l_ac].pjx01 = g_pjx_t.pjx01
                   NEXT FIELD pjx01
                END IF
             END IF
             #-----TQC-B90211--------- 
             #SELECT COUNT(*) INTO l_n1 FROM cpi_file
             #  WHERE  cpi01=g_pjx[l_ac].pjx01
             #    AND  cpiacti='Y'
             #IF l_n1 = 0 THEN 
             #   CALL cl_err('','apj-069',1)
             #   LET g_pjx[l_ac].pjx01= g_pjx_t.pjx01  
             #   DISPLAY BY NAME g_pjx[l_ac].pjx01
             #   NEXT FIELD pjx01
             #END IF
             #-----END TQC-B90211-----

             #CHI-CA0060---add---S
              SELECT COUNT(*) INTO l_n1 FROM pka_file
                WHERE  pka01=g_pjx[l_ac].pjx01
                  AND  pkaacti='Y'
              IF l_n1 = 0 THEN
                 CALL cl_err('','apj-069',1)
                 LET g_pjx[l_ac].pjx01= g_pjx_t.pjx01
                 DISPLAY BY NAME g_pjx[l_ac].pjx01
                 NEXT FIELD pjx01
              END IF
             #CHI-CA0060---add---E
          END IF
 
        AFTER FIELD pjx02
          IF NOT cl_null(g_pjx[l_ac].pjx02) THEN 
             SELECT COUNT(*) INTO l_n FROM gfe_file
               WHERE  gfe01=g_pjx[l_ac].pjx02
                 AND  gfeacti='Y'
             IF l_n = 0 THEN 
                CALL cl_err('','apj-070',1)
                 LET g_pjx[l_ac].pjx02= g_pjx_t.pjx02  
                 DISPLAY BY NAME g_pjx[l_ac].pjx02
                 NEXT FIELD pjx02
              END IF
          END IF 
        AFTER FIELD pjx03  
            IF cl_null(g_pjx[l_ac].pjx03) OR g_pjx[l_ac].pjx03 < 0 THEN
                CALL cl_err('','axc-207',0)
                LET g_pjx[l_ac].pjx03=g_pjx_t.pjx03
                NEXT FIELD pjx03
            END IF        
 
       AFTER FIELD pjxacti
          IF NOT cl_null(g_pjx[l_ac].pjxacti) THEN
             IF g_pjx[l_ac].pjxacti NOT MATCHES '[YN]' THEN 
                LET g_pjx[l_ac].pjxacti = g_pjx_t.pjxacti
                NEXT FIELD pjxacti
             END IF
          END IF
       		
       BEFORE DELETE                            #是否取消單身
          IF g_pjx_t.pjx01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "pjx01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_pjx[l_ac].pjx01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM pjx_file WHERE pjx01 = g_pjx_t.pjx01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","pjx_file",g_pjx_t.pjx01,"",SQLCA.sqlcode,"","",1)  
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
             LET g_pjx[l_ac].* = g_pjx_t.*
             CLOSE i800_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_pjx[l_ac].pjx01,-263,0)
             LET g_pjx[l_ac].* = g_pjx_t.*
          ELSE
             UPDATE pjx_file SET pjx01=g_pjx[l_ac].pjx01,
                                 pjx02=g_pjx[l_ac].pjx02,
                                 pjx03=g_pjx[l_ac].pjx03,
                                 pjx04=g_pjx[l_ac].pjx04,
                                 pjxacti=g_pjx[l_ac].pjxacti,
                                 pjxmodu=g_user,
                                 pjxdate=g_today
              WHERE pjx01 = g_pjx_t.pjx01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pjx_file",g_pjx_t.pjx01,"",SQLCA.sqlcode,"","",1) 
                LET g_pjx[l_ac].* = g_pjx_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac   #FUN-D30034 mark 
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_pjx[l_ac].* = g_pjx_t.*
             #FUN-D30034--add--begin--
             ELSE
                CALL g_pjx.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end----
             END IF
             CLOSE i800_bcl                # 新增
             ROLLBACK WORK                 # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30034 add 
          CLOSE i800_bcl                   # 新增
          COMMIT WORK
          
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pjx01)
                 #-----TQC-B90211---------
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_cpi"
                 #LET g_qryparam.default1 = g_pjx[l_ac].pjx01
                 #CALL cl_create_qry() RETURNING g_pjx[l_ac].pjx01
                 #DISPLAY BY NAME g_pjx[l_ac].pjx01
                 #CALL i800_cpi02('d',l_ac)
                 #NEXT FIELD pjx01
                 #-----END TQC-B90211-----

                 #CHI-CA0060---add---S
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pka"
                  LET g_qryparam.default1 = g_pjx[l_ac].pjx01
                  CALL cl_create_qry() RETURNING g_pjx[l_ac].pjx01
                  DISPLAY BY NAME g_pjx[l_ac].pjx01
                  CALL i010_pka02('d',l_ac)
                  NEXT FIELD pjx01
                 #CHI-CA0060---add---E 
              WHEN INFIELD(pjx02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_pjx[l_ac].pjx02
                CALL cl_create_qry() RETURNING g_pjx[l_ac].pjx02
                DISPLAY BY NAME g_pjx[l_ac].pjx02
                NEXT FIELD pjx02
           END CASE 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(pjx01) AND l_ac > 1 THEN
             LET g_pjx[l_ac].* = g_pjx[l_ac-1].*
             NEXT FIELD pjx01
          END IF
 
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
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
 
       
   END INPUT
 
   CLOSE i800_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i800_b_askkey()
 
   CLEAR FORM
   CALL g_pjx.clear()
   CONSTRUCT g_wc2 ON pjx01,pjx04,pjx02,pjx03,pjxacti   
        FROM s_pjx[1].pjx01,s_pjx[1].pjx04,s_pjx[1].pjx02,s_pjx[1].pjx03,
             s_pjx[1].pjxacti  
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(pjx01)
                 #-----TQC-B90211---------
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.state = "c"  
                 #LET g_qryparam.form ="q_cpi"
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #DISPLAY g_qryparam.multiret TO pjx01 
                 #NEXT FIELD pjx01
                 #-----END TQC-B90211-----

                 #CHI-CA0060---add---S
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pka"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjx01
                  NEXT FIELD pjx01
                 #CHI-CA0060---add---E
           WHEN INFIELD(pjx02)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_gfe"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pjx02
                NEXT FIELD pjx02
         END CASE
                 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pjxuser', 'pjxgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i800_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i800_b_fill(p_wc2)              #BODY FILL UP
#DEFINE     p_wc2           LIKE type_file.chr1000  
 DEFINE p_wc2  STRING     #NO.FUN-910082   
 
    LET g_sql =
        "SELECT pjx01,'',pjx04,pjx02,pjx03,pjxacti",  
        " FROM pjx_file ",
        " WHERE ", g_wc2 CLIPPED,                     #單身
        " ORDER BY pjx01"
    PREPARE i800_pb FROM g_sql
    DECLARE pjx_curs CURSOR FOR i800_pb
 
    CALL g_pjx.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pjx_curs INTO g_pjx[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #SELECT cpi02 INTO g_pjx[g_cnt].cpi02 FROM cpi_file   #TQC-B90211
        #   WHERE cpi01 =g_pjx[g_cnt].pjx01   #TQC-B90211
        #CHI-CA0060---add---S
         SELECT pka02 INTO g_pjx[g_cnt].pka02 FROM pka_file
          WHERE pka01 = g_pjx[g_cnt].pjx01
        #CHI-CA0060---add---E
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pjx.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjx TO s_pjx.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
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
 
FUNCTION i800_out()
DEFINE l_cmd LIKE type_file.chr1000
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_cmd = 'p_query "apji800" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd) 
    RETURN
END FUNCTION 
         
#-----TQC-B90211---------
#FUNCTION i800_cpi02(p_cmd,l_cnt)
#    DEFINE   p_cmd     LIKE type_file.chr1                                                                                          
#    DEFINE   l_cnt     LIKE type_file.num10 
#    DEFINE   l_cpi02   LIKE cpi_file.cpi02 
#    
#    LET g_errno = " "    
#    SELECT cpi02,cpiacti INTO l_cpi02,g_cpiacti FROM cpi_file WHERE cpi01=g_pjx[l_ac].pjx01
#    CASE
#       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
#                                LET l_cpi02=NULL
#       WHEN g_cpiacti='N'       LET g_errno='9028'
#       OTHERWISE
#            LET g_errno=SQLCA.sqlcode USING '------'
#    END CASE
#    IF cl_null(g_errno) OR p_cmd ='d' THEN 
#       LET g_pjx[l_cnt].cpi02=l_cpi02
#       DISPLAY g_pjx[l_cnt].cpi02 TO cpi02
#    END IF
#           
#END FUNCTION                                            
#-----END TQC-B90211-----

#CHI-CA0060------add------S
FUNCTION i010_pka02(p_cmd,l_cnt)
    DEFINE   p_cmd     LIKE type_file.chr1
    DEFINE   l_cnt     LIKE type_file.num10
    DEFINE   l_pka02   LIKE pka_file.pka02

    LET g_errno = " "
    SELECT pka02,pkaacti INTO l_pka02,g_pkaacti FROM pka_file WHERE pka01=g_pjx[l_ac].pjx01
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_pka02=NULL
       WHEN g_pkaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    IF cl_null(g_errno) OR p_cmd ='d' THEN
       LET g_pjx[l_cnt].pka02=l_pka02
       DISPLAY g_pjx[l_cnt].pka02 TO pka02
    END IF
END FUNCTION
#CHI-CA0060------add------E

FUNCTION i800_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("pjx01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i800_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("pjx01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION           
#NO.FUN-810069--end--                                                                 
