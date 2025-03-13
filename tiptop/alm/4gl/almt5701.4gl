# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almt5701.4gl
# Descriptions...: 會員卡發卡支付明細作業
# Date & Author..: No.FUN-960058 09/06/12 By destiny 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin
DEFINE 
     g_lpn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        lpn02       LIKE lpn_file.lpn02,   
        lpn03       LIKE lpn_file.lpn03, 
        rxy03       LIKE rxy_file.rxy03,
        rxy05       LIKE rxy_file.rxy05, 
        rxy06       LIKE rxy_file.rxy06,
        rxy20       LIKE rxy_file.rxy20,
        rxy07       LIKE rxy_file.rxy07, 
        rxy08       LIKE rxy_file.rxy08,
        rxy09       LIKE rxy_file.rxy09, 
        rxy10       LIKE rxy_file.rxy10,
        rxy11       LIKE rxy_file.rxy11,
        rxy12       LIKE rxy_file.rxy12,
        rxy13       LIKE rxy_file.rxy13,
        rxy14       LIKE rxy_file.rxy14,
        rxy15       LIKE rxy_file.rxy15,
        rxy16       LIKE rxy_file.rxy16,
        rxy17       LIKE rxy_file.rxy17                                        
                    END RECORD,
     g_lpn_t         RECORD                #程式變數 (舊值)
        lpn02       LIKE lpn_file.lpn02,   
        lpn03       LIKE lpn_file.lpn03, 
        rxy03       LIKE rxy_file.rxy03,
        rxy05       LIKE rxy_file.rxy05, 
        rxy06       LIKE rxy_file.rxy06,
        rxy20       LIKE rxy_file.rxy20,
        rxy07       LIKE rxy_file.rxy07, 
        rxy08       LIKE rxy_file.rxy08,
        rxy09       LIKE rxy_file.rxy09, 
        rxy10       LIKE rxy_file.rxy10,
        rxy11       LIKE rxy_file.rxy11,
        rxy12       LIKE rxy_file.rxy12,
        rxy13       LIKE rxy_file.rxy13,
        rxy14       LIKE rxy_file.rxy14,
        rxy15       LIKE rxy_file.rxy15,
        rxy16       LIKE rxy_file.rxy16,
        rxy17       LIKE rxy_file.rxy17        
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,         
    g_rec_b         LIKE type_file.num5,                #單身筆數     
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
    
DEFINE g_argv1      LIKE lpm_file.lpm01  
DEFINE g_lpn01      LIKE lpn_file.lpn01  
DEFINE g_lpmlegal   LIKE lpm_file.lpmlegal
DEFINE g_lpmplant   LIKE lpm_file.lpmplant
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        
DEFINE g_before_input_done   LIKE type_file.num5     
   
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1 = ARG_VAL(1)
    LET g_lpn01=g_argv1
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
    OPEN WINDOW t5701_w WITH FORM "alm/42f/almt5701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
    
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = "lpn01 = '",g_argv1,"'"                   
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
    SELECT lpmplant,lpmlegal INTO g_lpmplant,g_lpmlegal
      FROM lpm_file 
     WHERE lpm01=g_argv1
    
    CALL t5701_b_fill(g_wc2)
    CALL t5701_menu()
    CLOSE WINDOW t5701_w                    #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t5701_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL t5701_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t5701_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t5701_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lpn[l_ac].lpn02 IS NOT NULL THEN
                  LET g_doc.column1 = "lpn01"
                  LET g_doc.value1 = g_lpn[l_ac].lpn02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t5701_q()
   CALL t5701_b_askkey()
END FUNCTION
 
FUNCTION t5701_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,                #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
   l_lpmacti       LIKE lpm_file.lpmacti,
   l_lpm10         LIKE lpm_file.lpm10
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   
   IF cl_null(g_argv1) THEN 
      CALL cl_err('','alm-344',1)
      RETURN 
   END IF 
   SELECT lpmacti,lpm10 INTO l_lpmacti,l_lpm10 FROM lpm_file WHERE lpm01=g_argv1
   IF l_lpmacti='N' THEN 
      CALL cl_err('','alm-345',1)
      RETURN 
   END IF 
   IF l_lpm10='Y' THEN 
      CALL cl_err('','alm-346',1)
      RETURN 
   ELSE 
   	  IF l_lpm10='X' THEN 
   	     CALL cl_err('','alm-347',1)
   	     RETURN
   	  END IF 
   END IF 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lpn02,lpn03,'','','','','','','','','','','','','','','' ",  
                      "  FROM lpn_file WHERE lpn01='",g_lpn01,"' ",
                      "   and lpn02 = ? and lpn03= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t5701_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lpn WITHOUT DEFAULTS FROM s_lpn.*
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
             LET g_lpn_t.* = g_lpn[l_ac].*  #BACKUP
             OPEN t5701_bcl USING g_lpn_t.lpn02,g_lpn_t.lpn03
             IF STATUS THEN
                CALL cl_err("OPEN t5701_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t5701_bcl INTO g_lpn[l_ac].* 
                CALL t5701_lpn03()
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lpn_t.lpn02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                                                               
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lpn[l_ac].* TO NULL       
          LET g_lpn_t.* = g_lpn[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD lpn02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t5701_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lpn_file(lpn01,lpn02,lpn03,lpnlegal,lpnplant)   
          VALUES(g_lpn01,g_lpn[l_ac].lpn02,g_lpn[l_ac].lpn03,g_lpmlegal,g_lpmplant)  
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lpn_file",g_lpn[l_ac].lpn02,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          
       AFTER FIELD lpn02 
          IF NOT cl_null(g_lpn[l_ac].lpn02) THEN
             IF p_cmd='a' OR 
                (p_cmd='u' AND g_lpn[l_ac].lpn02 !=g_lpn_t.lpn02) THEN 
                CALL t5701_lpn02()
                SELECT COUNT(*) INTO l_n FROM lpn_file 
                 WHERE lpn01=g_lpn01 
                   AND lpn02=g_lpn[l_ac].lpn02
                   AND lpn03=g_lpn[l_ac].lpn03
                IF l_n>0 AND cl_null(g_errno) THEN 
                   LET g_errno='alm-348'
                END IF 
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_lpn[l_ac].lpn02 = g_lpn_t.lpn02
                   NEXT FIELD lpn02
                END IF
             END IF  
          END IF 
             
       AFTER FIELD lpn03
 
          IF NOT cl_null(g_lpn[l_ac].lpn03) THEN 
             IF cl_null(g_lpn[l_ac].lpn02) THEN 
                CALL cl_err('','alm-349',1)
                NEXT FIELD lpn03
             END IF 
             IF p_cmd='a' OR
                (p_cmd='u' AND g_lpn[l_ac].lpn03 !=g_lpn_t.lpn03) THEN 
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_lpn[l_ac].lpn03 = g_lpn_t.lpn03
                   NEXT FIELD lpn03
                END IF 
                SELECT COUNT(*) INTO l_n1 FROM lpn_file 
                 WHERE lpn01=g_lpn01 
                   AND lpn02=g_lpn[l_ac].lpn02
                   AND lpn03=g_lpn[l_ac].lpn03
                IF l_n1>0 THEN 
                   CALL cl_err('','alm-348',1)
                   LET g_lpn[l_ac].lpn03 = g_lpn_t.lpn03
                   NEXT FIELD lpn03
                END IF 
             END IF 
          END IF       
                  		
       BEFORE DELETE                            #是否取消單身
          IF g_lpn_t.lpn02 IS NOT NULL AND g_lpn_t.lpn03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lpn01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lpn[l_ac].lpn02      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lpn_file WHERE lpn01 = g_argv1 AND lpn02=g_lpn_t.lpn02 
                AND lpn03=g_lpn_t.lpn03 
             
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lpn_file",g_lpn_t.lpn02,"",SQLCA.sqlcode,"","",1)  
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
             LET g_lpn[l_ac].* = g_lpn_t.*
             CLOSE t5701_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lpn[l_ac].lpn02,-263,0)
             LET g_lpn[l_ac].* = g_lpn_t.*
          ELSE
             UPDATE lpn_file SET lpn02=g_lpn[l_ac].lpn02,
                                 lpn03=g_lpn[l_ac].lpn03
              WHERE lpn01 = g_argv1
                AND lpn02 = g_lpn_t.lpn02
                AND lpn03 = g_lpn_t.lpn03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lpn_file",g_lpn_t.lpn02,"",SQLCA.sqlcode,"","",1) 
                LET g_lpn[l_ac].* = g_lpn_t.*
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
                LET g_lpn[l_ac].* = g_lpn_t.*
             END IF
             CLOSE t5701_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF
 
          CLOSE t5701_bcl               # 新增
          COMMIT WORK
          
      ON ACTION controlp
         CASE           
            WHEN INFIELD(lpn02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rxy"
               LET g_qryparam.default1 = g_lpn[l_ac].lpn02
               CALL cl_create_qry() RETURNING g_lpn[l_ac].lpn02
               DISPLAY BY NAME g_lpn[l_ac].lpn02           
               NEXT FIELD lpn02 
          END CASE      
                  
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lpn02) AND l_ac > 1 THEN
             LET g_lpn[l_ac].* = g_lpn[l_ac-1].*
             NEXT FIELD lpn02
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
 
   CLOSE t5701_bcl
   COMMIT WORK
 
END FUNCTION
FUNCTION t5701_lpn02()
DEFINE l_n    LIKE type_file.num5
 
   LET g_errno=''
   SELECT COUNT(*)
     INTO l_n
     FROM rxy_file
    WHERE rxy00 = '23'
      AND rxy01 =g_lpn[l_ac].lpn02
 
   IF l_n =0 THEN 
      LET g_errno='alm-353'
   END IF 
        
END FUNCTION 
FUNCTION t5701_lpn03()
   DEFINE l_rxy05   LIKE rxy_file.rxy05
   DEFINE l_rxy03   LIKE rxy_file.rxy03
   DEFINE l_rxy06   LIKE rxy_file.rxy06
   DEFINE l_rxy07   LIKE rxy_file.rxy07
   DEFINE l_rxy08   LIKE rxy_file.rxy08
   DEFINE l_rxy09   LIKE rxy_file.rxy09
   DEFINE l_rxy10   LIKE rxy_file.rxy10
   DEFINE l_rxy11   LIKE rxy_file.rxy11
   DEFINE l_rxy12   LIKE rxy_file.rxy12
   DEFINE l_rxy13   LIKE rxy_file.rxy13
   DEFINE l_rxy14   LIKE rxy_file.rxy14
   DEFINE l_rxy15   LIKE rxy_file.rxy15
   DEFINE l_rxy16   LIKE rxy_file.rxy16
   DEFINE l_rxy17   LIKE rxy_file.rxy17 
   DEFINE l_rxy20   LIKE rxy_file.rxy20        
   DEFINE p_cmd     LIKE type_file.chr1 
 
   LET g_errno=''
  
   SELECT rxy03,rxy05,rxy06,rxy07,rxy08,rxy09,rxy10,rxy11,rxy12,rxy13,
          rxy14,rxy15,rxy16,rxy17,rxy20
     INTO l_rxy03,l_rxy05,l_rxy06,l_rxy07,l_rxy08,l_rxy09,l_rxy10,l_rxy11,
          l_rxy12,l_rxy13,l_rxy14,l_rxy15,l_rxy16,l_rxy17,l_rxy20
     FROM rxy_file
    WHERE rxy00 = '23'
      AND rxy01 =g_lpn[l_ac].lpn02
      AND rxy02 =g_lpn[l_ac].lpn03
 
    CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-350'
        OTHERWISE               LET g_errno=SQLCA.SQLCODE USING '-------'
    END CASE 
 
      LET g_lpn[l_ac].rxy03=l_rxy03
      LET g_lpn[l_ac].rxy05=l_rxy05
      LET g_lpn[l_ac].rxy06=l_rxy06
      LET g_lpn[l_ac].rxy07=l_rxy07
      LET g_lpn[l_ac].rxy08=l_rxy08
      LET g_lpn[l_ac].rxy09=l_rxy09
      LET g_lpn[l_ac].rxy10=l_rxy10
      LET g_lpn[l_ac].rxy11=l_rxy11
      LET g_lpn[l_ac].rxy12=l_rxy12
      LET g_lpn[l_ac].rxy13=l_rxy13
      LET g_lpn[l_ac].rxy14=l_rxy14
      LET g_lpn[l_ac].rxy15=l_rxy15
      LET g_lpn[l_ac].rxy16=l_rxy16
      LET g_lpn[l_ac].rxy17=l_rxy17 
      LET g_lpn[l_ac].rxy20=l_rxy20 
      DISPLAY BY NAME g_lpn[l_ac].rxy03
      DISPLAY BY NAME g_lpn[l_ac].rxy05
      DISPLAY BY NAME g_lpn[l_ac].rxy06
      DISPLAY BY NAME g_lpn[l_ac].rxy07
      DISPLAY BY NAME g_lpn[l_ac].rxy08
      DISPLAY BY NAME g_lpn[l_ac].rxy09
      DISPLAY BY NAME g_lpn[l_ac].rxy10
      DISPLAY BY NAME g_lpn[l_ac].rxy11
      DISPLAY BY NAME g_lpn[l_ac].rxy12
      DISPLAY BY NAME g_lpn[l_ac].rxy13
      DISPLAY BY NAME g_lpn[l_ac].rxy14
      DISPLAY BY NAME g_lpn[l_ac].rxy15
      DISPLAY BY NAME g_lpn[l_ac].rxy16
      DISPLAY BY NAME g_lpn[l_ac].rxy17 
      DISPLAY BY NAME g_lpn[l_ac].rxy20         
 
END FUNCTION 
 
FUNCTION t5701_b_askkey()
 
   CLEAR FORM
   CALL g_lpn.clear()
   CONSTRUCT g_wc2 ON lpn02,lpn03
        FROM s_lpn[1].lpn02,s_lpn[1].lpn03
 
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
              WHEN INFIELD(lpn02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpn02"
                 LET g_qryparam.arg1=g_lpn01
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO  lpn02
                 NEXT FIELD lpn02
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
 
   CALL t5701_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t5701_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT lpn02,lpn03,'','','','','','','','','','','','','','',''",   
        " FROM lpn_file ",
        " WHERE ", g_wc2 CLIPPED,        #單身
        " and lpn01= '",g_lpn01,"' ",
        " ORDER BY lpn02,lpn03"
    PREPARE t5701_pb FROM g_sql
    DECLARE lpn_curs CURSOR FOR t5701_pb
 
    CALL g_lpn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lpn_curs INTO g_lpn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT rxy03,rxy05,rxy06,rxy20,rxy07,rxy08,rxy09,rxy10,rxy11,rxy12,rxy13,rxy14,
               rxy15,rxy16,rxy17
          INTO g_lpn[g_cnt].rxy03,g_lpn[g_cnt].rxy05,g_lpn[g_cnt].rxy06,g_lpn[g_cnt].rxy20,
               g_lpn[g_cnt].rxy07,g_lpn[g_cnt].rxy08,g_lpn[g_cnt].rxy09,g_lpn[g_cnt].rxy10,
               g_lpn[g_cnt].rxy11,g_lpn[g_cnt].rxy12,g_lpn[g_cnt].rxy13,g_lpn[g_cnt].rxy14,
               g_lpn[g_cnt].rxy15,g_lpn[g_cnt].rxy16,g_lpn[g_cnt].rxy17
          FROM rxy_file
         WHERE rxy00='23'
           AND rxy01=g_lpn[g_cnt].lpn02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lpn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t5701_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lpn TO s_lpn.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
                                                 
                                                                 
