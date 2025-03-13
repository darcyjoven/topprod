# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
#Pattern name..:"artt402_1.4gl"
#Descriptions..:生效機構變更維護作業
#Date & Author...: No.FUN-A70048 10/07/25 By Cockroach 
# Modify.........: No.FUN-BC0072 11/12/20 By pauline GP5.3 artt402 一般促銷變更單促銷功能優化
# Modify.........: No.TQC-C80087 12/08/14 By yangxf 修改在变更营运中心时直接输入营运中心点确认报-391错误 无法将NULL值插入栏位
# Modify.........: No:FUN-D30033 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rbq   DYNAMIC ARRAY OF RECORD 
                type          LIKE type_file.chr1,
                
                before        LIKE rbq_file.rbq06,
                rbq07_1       LIKE rbq_file.rbq07,
                rbq07_1_desc  LIKE azp_file.azp02,             
                rbq09_1       LIKE rbq_file.rbq09,  #FUN-BC0072 add 
                rbq08_1       LIKE rbq_file.rbq08,
                rbqacti_1     LIKE rbq_file.rbqacti,
                
                after         LIKE rbq_file.rbq06,
                rbq07         LIKE rbq_file.rbq07,
                rbq07_desc    LIKE azp_file.azp02,              
                rbq09         LIKE rbq_file.rbq09,  #FUN-BC0072 add
                rbq08         LIKE rbq_file.rbq08,
                rbqacti       LIKE rbq_file.rbqacti
                        END RECORD,
        g_rbq_t RECORD
                type          LIKE type_file.chr1,
                
                before        LIKE rbq_file.rbq06,
                rbq07_1       LIKE rbq_file.rbq07,
                rbq07_1_desc  LIKE azp_file.azp02,              
                rbq09_1       LIKE rbq_file.rbq09,  #FUN-BC0072 add
                rbq08_1       LIKE rbq_file.rbq08,
                rbqacti_1     LIKE rbq_file.rbqacti,
                
                after         LIKE rbq_file.rbq06,
                rbq07         LIKE rbq_file.rbq07,
                rbq07_desc    LIKE azp_file.azp02,      
                rbq09         LIKE rbq_file.rbq09,  #FUN-BC0072 add        
                rbq08         LIKE rbq_file.rbq08,
                rbqacti       LIKE rbq_file.rbqacti
                        END RECORD
DEFINE   g_sql   STRING,
         g_wc   STRING,
         g_rec_b LIKE type_file.num5,
         l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_argv1         LIKE rbq_file.rbq01,
        g_argv2         LIKE rbq_file.rbq02,
        g_argv3         LIKE rbq_file.rbq03,
        g_argv4         LIKE rbq_file.rbq04,
        g_argv5         LIKE rbq_file.rbqplant,
        g_argv6         LIKE rab_file.rabconf
DEFINE g_legal LIKE azw_file.azw01
#FUN-BC0072 add START
DEFINE g_flag2          LIKE type_file.chr1   #記錄原促銷單的plant下 是否存在其他攤位
DEFINE g_n              LIKE type_file.num5
DEFINE g_string         STRING
#FUN-BC0072 add END 
FUNCTION t402_1(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6)
DEFINE  p_argv1         LIKE rbq_file.rbq01,
        p_argv2         LIKE rbq_file.rbq02,
        p_argv3         LIKE rbq_file.rbq03,
        p_argv4         LIKE rbq_file.rbq04,
        p_argv5         LIKE rbq_file.rbqplant,
        p_argv6         LIKE rab_file.rabconf
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_argv4 = p_argv4
    LET g_argv5 = p_argv5
    LET g_argv6 = p_argv6
    SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_argv5
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t402_1_w AT p_row,p_col WITH FORM "art/42f/artt402_1"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("artt402_1")
     CALL cl_set_comp_required("rbq09",FALSE)   #FUN-BC0072 add
    LET g_wc = " 1=1"
    CALL t402_1_b_fill(g_wc)
    IF g_argv6='N' THEN
    LET l_ac=g_rec_b+1
    CALL t402_1_b()
    END IF
    CALL t402_1_menu()

 
    CLOSE WINDOW t402_1_w
END FUNCTION
 
FUNCTION t402_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rbq TO s_rbq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(0,0)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION query
         LET g_action_choice="query"
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
          CALL cl_show_fld_cont()                  
 
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
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t402_1_menu()
 
   WHILE TRUE
      CALL t402_1_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t402_1_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t402_1_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rbq),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t402_1_q()
 
   CALL t402_1_b_askkey()
   
END FUNCTION
 
FUNCTION t402_1_b_askkey()
 
    CLEAR FORM
  
    CONSTRUCT g_wc ON b.rbq07,b.rbq08,b.rbqacti
                    FROM s_rbq[1].rbq07,s_rbq[1].rbq08,s_rbq[1].rbqacti
 
           ON ACTION controlp
           CASE
              WHEN INFIELD(rbq07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rbq07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rbq07
                 NEXT FIELD rbq07
 
              OTHERWISE
                 EXIT CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    
    IF INT_FLAG THEN 
        RETURN
    END IF
 
    CALL t402_1_b_fill(g_wc)
    
END FUNCTION
 
FUNCTION t402_1_rbq07(p_cmd)         
DEFINE    p_cmd   STRING,
          l_rbq07_desc LIKE azp_file.azp02  #No.FUN-960130
DEFINE l_n LIKE type_file.num5
          
   LET g_errno = ' '
   
   SELECT azp02 INTO l_rbq07_desc FROM azp_file  #No.FUN-960130
    WHERE azp01 = g_rbq[l_ac].rbq07
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002' 
                                 LET l_rbq07_desc = NULL 
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) THEN
     SELECT COUNT(*) INTO l_n FROM azp_file
      WHERE azp01 IN (SELECT azw01 FROM azw_file WHERE azw07=g_argv5 OR azw01=g_argv5)
        AND azp01 = g_rbq[l_ac].rbq07
     IF l_n=0 THEN
        LET g_errno='art-500'
     END IF
  END IF 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rbq[l_ac].rbq07_desc=l_rbq07_desc
     DISPLAY BY NAME g_rbq[l_ac].rbq07_desc
  END IF
 
END FUNCTION
 
FUNCTION t402_1_b_fill(p_wc)              
DEFINE   p_wc       STRING        
 
   #LET g_sql = "SELECT '',a.rbq06,a.rbq07,'',a.rbq08,a.rbqacti, ",   #FUN-BC0072 mark
   #            "          b.rbq06,b.rbq07,'',b.rbq08,b.rbqacti  ",   #FUN-BC0072 mark
    LET g_sql = "SELECT '',a.rbq06,a.rbq07,'',a.rbq09,a.rbq08,a.rbqacti, ",  #FUN-BC0072add
                "          b.rbq06,b.rbq07,'',b.rbq09,b.rbq08,b.rbqacti  ",  #FUN-BC0072 add
                " FROM rbq_file b LEFT OUTER JOIN rbq_file a  ",
                "      ON (    b.rbq01=a.rbq01 AND b.rbq02=a.rbq02 AND b.rbq03=a.rbq03 AND b.rbqplant=a.rbqplant ",
                "          AND b.rbq04=a.rbq04 AND b.rbq05=a.rbq05 AND b.rbq07=a.rbq07 AND b.rbq06<>a.rbq06 )",
                " WHERE b.rbq01='",g_argv1 CLIPPED,"' AND b.rbq02='",g_argv2 CLIPPED,"'",
                "   AND b.rbq03='",g_argv3 CLIPPED,"' AND b.rbq04='",g_argv4 CLIPPED,"'",
                "   AND b.rbqplant='",g_argv5 CLIPPED,"'" ,
                "   AND b.rbq06='1' "         
                
    IF NOT cl_null(p_wc) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED
    END IF
    LET g_sql = g_sql," ORDER BY b.rbq05"
    PREPARE t402_1_pb FROM g_sql
    DECLARE rbq_cs CURSOR FOR t402_1_pb
 
    CALL g_rbq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rbq_cs INTO g_rbq[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
         
        IF g_rbq[g_cnt].before='0' THEN
           LET g_rbq[g_cnt].type='1'
        ELSE 
           LET g_rbq[g_cnt].type='0'
        END IF
        SELECT azp02 INTO g_rbq[g_cnt].rbq07_desc FROM azp_file  
         WHERE azp01 = g_rbq[g_cnt].rbq07
        SELECT azp02 INTO g_rbq[g_cnt].rbq07_1_desc FROM azp_file  
         WHERE azp01 = g_rbq[g_cnt].rbq07_1
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rbq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t402_1_b()
DEFINE l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_rbq05_curr    LIKE rbq_file.rbq05
#FUN-BC0072 add START
DEFINE l_sql           STRING
DEFINE l_raq08         LIKE raq_file.raq08
#FUN-BC0072 add END 
   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
   IF g_argv6<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN 
   END IF
  #FUN-BC0072 add START
   IF g_argv1 <> g_plant THEN
      CALL cl_err( '','art-977',0 )
      RETURN
   END IF
  #FUN-BC0072 add END 
   CALL cl_opmsg('b')
#modify by lixia ---start---    
#   LET g_forupd_sql="SELECT b.rbq05,'',a.rbq06,a.rbq07,'',a.rbq08,a.rbqacti, ",
#                "                      b.rbq06,b.rbq07,'',b.rbq08,b.rbqacti  ",
#                " FROM rbq_file b LEFT OUTER JOIN rbq_file a  ",
#                "      ON (    b.rbq01=a.rbq01 AND b.rbq02=a.rbq02 AND b.rbq03=a.rbq03 AND b.rbqplant=a.rbqplant ",
#                "          AND b.rbq04=a.rbq04 AND b.rbq05=a.rbq05 AND b.rbq07=a.rbq07 AND b.rbq06<>a.rbq06 )",
#                " WHERE rbq01=? AND rbq02=? ",
#                "   AND rbq03=? AND rbq04=? ",
#                "   AND b.rbq06='1'  ",
#                "   AND rbq07=? ",
#                "   AND rbqplant=? ",
#                " FOR UPDATE"   
    LET g_forupd_sql="SELECT *  ",
                     " FROM rbq_file ",
                     " WHERE rbq01=? AND rbq02=? ",
                     "   AND rbq03=? AND rbq04=? ",
                     "   AND rbq06='1'  AND rbq07=? ",
                     "   AND rbq09 = ?",  #FUN-BC0072 add 
                     "   AND rbqplant=? ",
                     " FOR UPDATE"                  
#modify by lixia ---end---  
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t402_1_bcl CURSOR FROM g_forupd_sql
   
   LET l_allow_insert=cl_detail_input_auth("insert")
   LET l_allow_delete=cl_detail_input_auth("delete")
   
   INPUT ARRAY g_rbq WITHOUT DEFAULTS FROM s_rbq.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
              APPEND ROW= l_allow_insert)
   BEFORE INPUT
      IF g_rec_b !=0 THEN 
         CALL fgl_set_arr_curr(l_ac)
      END IF
   BEFORE ROW
      LET p_cmd =''
      LET l_ac =ARR_CURR()
      LET l_lock_sw ='N'
      LET l_n =ARR_COUNT()
      
      BEGIN WORK 
                  
      IF g_rec_b>=l_ac THEN 
         LET p_cmd ='u'
         LET g_rbq_t.*=g_rbq[l_ac].*
         IF p_cmd='u' THEN
            CALL cl_set_comp_entry("rbq07",FALSE)
         ELSE
            CALL cl_set_comp_entry("rbq07",TRUE)
         END IF
         
         OPEN t402_1_bcl USING g_argv1,g_argv2,g_argv3,g_argv4, 
                               g_rbq_t.rbq07,g_argv5,g_rbq_t.rbq09
         IF STATUS THEN
            CALL cl_err("OPEN t402_1_bcl:",STATUS,1)
            LET l_lock_sw='Y'
         ELSE
#modify by lixia ---start---      
            #FETCH t402_1_bcl INTO l_rbq05_curr,g_rbq[l_ac].*
            SELECT b.rbq05,'',a.rbq06,a.rbq07,'',a.rbq09,a.rbq08,a.rbqacti,   #FUN-BC0072 add rbq09
                   b.rbq06,b.rbq07,'',b.rbq09,b.rbq08,b.rbqacti   #FUN-BC0072 add rbq09
              INTO l_rbq05_curr,g_rbq[l_ac].*   
              FROM rbq_file b LEFT OUTER JOIN rbq_file a  
                ON (  b.rbq01=a.rbq01 AND b.rbq02=a.rbq02 AND b.rbq03=a.rbq03 AND b.rbqplant=a.rbqplant
               AND b.rbq04=a.rbq04 AND b.rbq05=a.rbq05 AND b.rbq07=a.rbq07 AND b.rbq06<>a.rbq06 )
             WHERE b.rbq01=g_argv1 AND b.rbq02=g_argv2 
               AND b.rbq03=g_argv3 AND b.rbq04=g_argv4 
               AND b.rbq06='1'
               AND b.rbq07=g_rbq_t.rbq07
               AND b.rbqplant=g_argv5
               AND b.rbq09 = g_rbq_t.rbq09  #ad
#modify by lixia ---end---                     
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rbq_t.rbq07,SQLCA.sqlcode,1)
               LET l_lock_sw="Y"
            END IF
            IF g_rbq[l_ac].before='0' THEN
               LET g_rbq[l_ac].type ='1'
            ELSE
               LET g_rbq[l_ac].type ='0'
            END IF
#modify by lixia ---start---            
#            SELECT azp02 INTO g_rbq[g_cnt].rbq07_desc FROM azp_file  
#             WHERE azp01 = g_rbq[g_cnt].rbq07
#            SELECT azp02 INTO g_rbq[g_cnt].rbq07_1_desc FROM azp_file
#             WHERE azp01 = g_rbq[g_cnt].rbq07_1
            SELECT azp02 INTO g_rbq[l_ac].rbq07_desc FROM azp_file  
             WHERE azp01 = g_rbq[l_ac].rbq07
            SELECT azp02 INTO g_rbq[l_ac].rbq07_1_desc FROM azp_file
             WHERE azp01 = g_rbq[l_ac].rbq07_1
#modify by lixia ---end---             
           #CALL t402_1_rbq07('d')
         END IF
      END IF
      
    BEFORE INSERT
       LET l_n=ARR_COUNT()
       LET p_cmd='a'
       INITIALIZE g_rbq[l_ac].* TO NULL               
       LET g_rbq[l_ac].rbq08='N'
       LET g_rbq[l_ac].rbqacti='Y'
       LET g_rbq_t.*=g_rbq[l_ac].*
            SELECT MAX(rbq05)+1 INTO l_rbq05_curr 
              FROM rbq_file
             WHERE rbq01=g_argv1
               AND rbq02=g_argv2 
               AND rbq03=g_argv3 
               AND rbq04=g_argv4 
               AND rbq06='1'
               AND rbqplant=g_argv5
              IF l_rbq05_curr IS NULL OR l_rbq05_curr=0 THEN
                 LET l_rbq05_curr = 1
              END IF                   
       IF p_cmd='u' THEN
          CALL cl_set_comp_entry("rbq07",FALSE)
       ELSE
          CALL cl_set_comp_entry("rbq07",TRUE)
       END IF
       CALL cl_show_fld_cont()
       NEXT FIELD rbq07
       
       
    AFTER INSERT
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          CANCEL INSERT
       END IF
       IF cl_null(g_rbq[l_ac].rbq09) THEN LET g_rbq[l_ac].rbq09 = ' ' END IF    #FUN-BC0072 add
       IF NOT cl_null(g_rbq[l_ac].rbq07) THEN
          IF g_rbq[l_ac].type= '0' THEN
             INSERT INTO rbq_file(rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  #FUN-BC0072 add rbq09
                VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbq05_curr,g_rbq[l_ac].after,g_rbq[l_ac].rbq07,
                       g_rbq[l_ac].rbq08,g_rbq[l_ac].rbq09,g_rbq[l_ac].rbqacti,g_argv5,g_legal)  #FUN-BC0072 add rba09
                 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rbq_file",g_rbq[l_ac].rbq07,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT Ok'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b To FORMONLY.cn2
             END IF
          ELSE
             INSERT INTO rbq_file(rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  #FUN-BC0072 add rbq09
                VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbq05_curr,g_rbq[l_ac].before,g_rbq[l_ac].rbq07_1,
                       g_rbq[l_ac].rbq08_1,g_rbq[l_ac].rbq09,g_rbq[l_ac].rbqacti_1,g_argv5,g_legal)  #FUN-BC0072 add rbq09
                 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rbq_file",g_rbq[l_ac].rbq07,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT Ok' 
             END IF
{#FUN-BC0072 add START   #若原本的促銷單內有攤位編號,但是變更單未有攤位編號,則將原本的攤位編號設定為無效
             IF g_flag2 = 'Y' THEN
                LET l_sql = " SELECT raq08 FROM raq_file ",
                            " WHERE raq01='",g_argv1,"' AND raq02='",g_argv2,"' AND raq03='",g_argv4,"' ",
                            " AND raqplant='",g_argv5,"' AND raq04 = '",g_rbq[l_ac].rbq07,"' ",
                            " AND (RTRIM(raq08) IS NOT NULL )"
                PREPARE t402_1_prepare FROM g_sql                     #預備一下
                DECLARE raq_cs CURSOR FOR t402_1_prepare             
                FOREACH raq_cs INTO l_raq08
                   INSERT INTO rbq_file(rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  
                      VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbq05_curr,g_rbq[l_ac].before,g_rbq[l_ac].rbq07_1,
                             g_rbq[l_ac].rbq08_1,l_raq08,'N',g_argv5,g_legal) 
   
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","rbq_file",g_rbq[l_ac].rbq07,"",SQLCA.sqlcode,"","",1)
                      CANCEL INSERT
                   ELSE
                      MESSAGE 'INSERT Ok'
                   END IF
                END FOREACH
             END IF
#FUN-BC0072 add END}
             INSERT INTO rbq_file(rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  #FUN-BC0072 add rbq09
                VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbq05_curr,g_rbq[l_ac].after,g_rbq[l_ac].rbq07,
                       g_rbq[l_ac].rbq08,g_rbq[l_ac].rbq09,g_rbq[l_ac].rbqacti,g_argv5,g_legal)  #FUN-BC0072 add rbq09
                 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rbq_file",g_rbq[l_ac].rbq07,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT Ok'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b To FORMONLY.cn2
             END IF
          END IF   
       END IF
         
      AFTER FIELD rbq07
             IF NOT cl_null(g_rbq[l_ac].rbq07) THEN  
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                   g_rbq[l_ac].rbq07 <> g_rbq_t.rbq07) THEN
                #FUN-BC0072 mark START
                #  SELECT COUNT(*) INTO l_n FROM rbq_file
                #   WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3 AND rbq04=g_argv4
                #     AND rbqplant=g_argv5 AND rbq06='1' AND rbq07 = g_rbq[l_ac].rbq07
                #  IF l_n>0 THEN
                #     CALL cl_err('',-239,0)
                #     LET g_rbq[l_ac].rbq07=g_rbq_t.rbq07
                #     NEXT FIELD rbq07
                #  ELSE 
                #FUN-BC0072 mark END 
                      CALL t402_1_rbq07('a')
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('rbq07',g_errno,0)
                         LET g_rbq[l_ac].rbq07 = g_rbq_t.rbq07
                         DISPLAY BY NAME g_rbq[l_ac].rbq07
                         NEXT FIELD rbq07
                      END IF 
                #FUN-BC0072 mark START 
                #  END IF  
                #  #Add or Modify STARTING------
                #  SELECT COUNT(*) INTO l_n FROM raq_file
                #   WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv4
                #     AND raqplant=g_argv5 AND raq04=g_rbq[l_ac].rbq07
                #  IF l_n=0 THEN
                #     IF NOT cl_confirm('art-674') THEN   #新增？
                #        NEXT FIELD rbq07
                #     ELSE
                #        CALL t402_1_init()   
                #     END IF
                #  ELSE
                #     IF NOT cl_confirm('art-675') THEN   #修改？
                #        NEXT FIELD rbq07
                #     ELSE
                #        CALL t402_1_find()   
                #     END IF           
                #  END IF   
                #FUN-BC0072 mark END            
                   LET g_rbq[l_ac].rbq09 = '' #FUN-BC0072 add 
                END IF    
                NEXT FIELD rbq09   #TQC-C80087 add
             END IF
                           
      AFTER FIELD rbq09 
         IF cl_null(g_rbq[l_ac].rbq09) THEN LET g_rbq[l_ac].rbq09 = ' ' END IF      #TQC-C80087 add
         IF p_cmd = 'a' OR
           #(p_cmd = 'u' AND (g_rbq[l_ac].rbq09 <> g_rbq_t.rbq09 OR cl_null(g_rbq[l_ac].rbq09))) THEN   #TQC-C80087 mark
            (p_cmd = 'u' AND (g_rbq[l_ac].rbq09 <> g_rbq_t.rbq09 )) THEN    #TQC-C80087   add
          #FUN-BC0072 add START
           LET l_n = 0 
           IF NOT cl_null(g_rbq[l_ac].rbq09) THEN
              SELECT COUNT(*) INTO l_n FROM lmf_file
                 WHERE lmf01 = g_rbq[l_ac].rbq09 
                   AND lmfstore = g_rbq[l_ac].rbq07 
              IF l_n < 1 THEN
                 CALL cl_err('','art-781',0)
                 NEXT FIELD rbq09
              END IF
           END IF
           LET l_n = 0
           CALL t402_1_chkrbq09(g_rbq[l_ac].rbq07, g_rbq[l_ac].rbq09 ) RETURNING l_n
           IF p_cmd = 'u' AND l_n > 0 THEN LET l_n = l_n - 1 END IF      
           IF l_n > 0 THEN  #判斷是否已存在有相同plant但是未設定攤位編號
              IF NOT cl_null(g_rbq[l_ac].rbq09) THEN
                 CALL cl_err('','art-793',0)
                 NEXT FIELD rbq09
              ELSE
                 CALL cl_err('','art-792',0)
                 NEXT FIELD rbq09
              END IF
           END IF
           LET l_n = 0
           IF NOT cl_null(g_rbq[l_ac].rbq09) THEN
               SELECT COUNT(*) INTO l_n FROM rbq_file
                 WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3 AND rbq04=g_argv4
                   AND rbqplant=g_argv5 AND rbq06='1' AND rbq07 = g_rbq[l_ac].rbq07
                   AND rbq09 = g_rbq[l_ac].rbq09 
           ELSE
              SELECT COUNT(*) INTO l_n FROM rbq_file
               WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3 AND rbq04=g_argv4
                 AND rbqplant=g_argv5 AND rbq06='1' AND rbq07 = g_rbq[l_ac].rbq07
                 AND (RTRIM(rbq09) IS NULL )
           END IF
          #FUN-BC0072 add END
           IF l_n>0 THEN
              CALL cl_err('',-239,0)
             #LET g_rbq[l_ac].rbq07=g_rbq_t.rbq07  #FUN-BC0072 mark
              NEXT FIELD rbq09
           END IF
           LET l_n = 0 
           LET g_n = 0 
           CALL t402_1_rbq09()  #判斷是否存在於原促銷單中 
           LET l_n = g_n
           IF l_n=0 THEN
              IF NOT cl_confirm('art-674') THEN   #新增？
                 NEXT FIELD rbq09
              ELSE
                 CALL t402_1_init()
              END IF
           ELSE
             #FUN-BC0072 add START
              IF g_flag2 = 'Y' THEN
                 IF NOT cl_confirm('art-791') THEN   #原促銷單中有設定該營運中心限定攤位
                    NEXT FIELD rbq07
                 ELSE
             #FUN-BC0072 add END
                    LET g_flag2 = 'Y'
                    CALL t402_1_find()
                 END IF                  
              ELSE
                 IF NOT cl_confirm('art-675') THEN   #修改？
                    NEXT FIELD rbq09
                 ELSE
                    CALL t402_1_find()
                 END IF
              END IF
           END IF
         END IF  


      AFTER FIELD rbq08
             IF NOT cl_null(g_rbq[l_ac].rbq08) THEN  
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                   g_rbq[l_ac].rbq08 <> g_rbq_t.rbq08) THEN
                   IF NOT cl_null(g_rbq[l_ac].rbq08_1) THEN
                      IF g_rbq[l_ac].rbq08=g_rbq[l_ac].rbq08_1 THEN
                         CALL cl_err('','art-680',0)   #當生效機構變更的有效碼與舊值相同時，此筆變更無意義，請更改！
                         LET g_rbq[l_ac].rbq08 = g_rbq_t.rbq08
                         DISPLAY BY NAME g_rbq[l_ac].rbq08
                         NEXT FIELD rbq08
                      END IF
                   END IF
                END IF
             END IF

#TQC-C80087 add begin ---
      ON CHANGE rbqacti
         IF g_rbq[l_ac].rbqacti = 'Y' THEN
            LET l_n = 0
            CALL t402_1_chkrbq09(g_rbq[l_ac].rbq07, g_rbq[l_ac].rbq09 ) RETURNING l_n
           #IF p_cmd = 'u' AND l_n > 0 THEN LET l_n = l_n - 1 END IF
            IF l_n > 0 THEN  #判斷是否已存在有相同plant但是未設定攤位編號
               IF NOT cl_null(g_rbq[l_ac].rbq09) THEN
                  CALL cl_err('','art-793',0)
                  LET g_rbq[l_ac].rbqacti = 'N'
                  NEXT FIELD rbqacti 
               ELSE
                  CALL cl_err('','art-792',0)
                  LET g_rbq[l_ac].rbqacti = 'N'
                  NEXT FIELD rbqacti
               END IF
            END IF            
         END IF 
#TQC-C80087 add end -----

       BEFORE DELETE                      
          IF NOT cl_null(g_rbq_t.rbq07) THEN          #TQC-C80087 add
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
             #IF cl_null(g_rbq[l_ac].rbq09) THEN  #FUN-BC0072 add #TQC-C80087 mark
              IF cl_null(g_rbq_t.rbq09) THEN      #TQC-C80087 add
                 DELETE FROM rbq_file
                    WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3 
                      AND rbq04=g_argv4 AND rbqplant=g_argv5 AND rbq07=g_rbq_t.rbq07
                      AND (RTRIM(rbq09)) IS NULL              #TQC-C80087 add  
             #FUN-BC0072 add START
              ELSE 
                 DELETE FROM rbq_file
                    WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3
                      AND rbq04=g_argv4 AND rbqplant=g_argv5 AND rbq07=g_rbq_t.rbq07
                     #AND rbq09 = g_rbq[l_ac].rbq09           #TQC-C80087 mark
                      AND rbq09 = g_rbq_t.rbq09               #TQC-C80087 add
              END IF
             #FUN-BC0072 add END
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rbq_file",g_rbq_t.rbq07,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
           END IF      #TQC-C80087 add

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rbq[l_ac].* = g_rbq_t.*
              CLOSE t402_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rbq[l_ac].rbq07,-263,1)
              LET g_rbq[l_ac].* = g_rbq_t.*
           ELSE
              IF cl_null(g_rbq[l_ac].rbq09) THEN LET g_rbq[l_ac].rbq09 = ' ' END IF 
              IF NOT cl_null(g_rbq[l_ac].rbq07) THEN
                 IF cl_null(g_rbq_t.rbq09) THEN      #TQC-C80087 add
                    UPDATE rbq_file SET  rbq07 = g_rbq[l_ac].rbq07,
                                         rbq08 = g_rbq[l_ac].rbq08,
                                         rbq09 = g_rbq[l_ac].rbq09,   #FUN-BC0072 add
                                         rbqacti = g_rbq[l_ac].rbqacti
                          WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3 
                            AND rbq04=g_argv4 AND rbqplant=g_argv5 
                            AND rbq06='1'     AND rbq07=g_rbq_t.rbq07
                            AND (RTRIM(rbq09)) IS NULL          #TQC-C80087 add
                #TQC-C80087 add begin ---
                 ELSE
                    UPDATE rbq_file SET  rbq07 = g_rbq[l_ac].rbq07,
                                         rbq08 = g_rbq[l_ac].rbq08,
                                         rbq09 = g_rbq[l_ac].rbq09, 
                                         rbqacti = g_rbq[l_ac].rbqacti
                          WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3
                            AND rbq04=g_argv4 AND rbqplant=g_argv5
                            AND rbq06='1'     AND rbq07=g_rbq_t.rbq07
                            AND rbq09 = g_rbq_t.rbq09
                 END IF 
                #TQC-C80087 add end ---
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rbq_file",g_rbq_t.rbq07,'',SQLCA.sqlcode,"","",1) 
                    LET g_rbq[l_ac].* = g_rbq_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #FUN-D30033------Mark---Str
          #LET l_ac_t = l_ac  
          #IF cl_null(g_rbq[l_ac].rbq07) THEN
          #   CALL g_rbq.deleteelement(l_ac)
          #END IF
          #FUN-D30033------Mark---End
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rbq[l_ac].* = g_rbq_t.*
             #TQC-C80087 add begin ---
              ELSE
                 CALL g_rbq.deleteelement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
             #TQC-C80087 add end ----
              END IF
              CLOSE t402_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           CLOSE t402_1_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rbq07) AND l_ac > 1 THEN
              LET g_rbq[l_ac].* = g_rbq[l_ac-1].*
              LET g_rec_b = g_rec_b + 1
             #LET g_rbq[l_ac].rbq08 = g_rec_b + 1
              NEXT FIELD rbq07
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rbq07)                     
               CALL cl_init_qry_var()
              #LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azp" 
               LET g_qryparam.where = " azp01 IN (SELECT azw01 FROM azw_file WHERE azw07='",g_argv5,"' OR azw01='",g_argv5,"')"
               LET g_qryparam.default1 = g_rbq[l_ac].rbq07
               CALL cl_create_qry() RETURNING g_rbq[l_ac].rbq07
              #CALL cl_create_qry() RETURNING g_qryparam.multiret
              #CALL t402_1_create(g_qryparam.multiret)
              #EXIT INPUT          
               DISPLAY BY NAME g_rbq[l_ac].rbq07
               NEXT FIELD rbq07                                  #FUN-C80087 add
            WHEN INFIELD(rbq09)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lmf_2"
               LET g_qryparam.arg1 =g_rbq[l_ac].rbq07
               LET g_qryparam.default1 = g_rbq[l_ac].rbq09
               CALL cl_create_qry() RETURNING g_rbq[l_ac].rbq09 
               DISPLAY BY NAME g_rbq[l_ac].rbq09                 #FUN-C80087 add
               NEXT FIELD rbq09                                  #FUN-C80087 add
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO") 

        #FUN-BC0072 add START
        ON ACTION ins_rbq07
           CALL t402_1_insrbq07rbq09()
        
        #FUN-BC0072 add END 
    END INPUT
  
    CLOSE t402_1_bcl
    COMMIT WORK
    
END FUNCTION                          
                                                   
FUNCTION t402_1_bp_refresh()
 
  DISPLAY ARRAY g_rbq TO s_rbq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION t402_1_create(p_ret)
DEFINE p_ret STRING
DEFINE l_tok base.StringTokenizer
DEFINE l_rbq07   LIKE rbq_file.rbq07
DEFINE l_rbq08   LIKE rbq_file.rbq08
DEFINE l_rbqacti LIKE rbq_file.rbqacti
DEFINE l_n       LIKE type_file.num5
 
   LET l_rbq08='Y'
   LET l_tok = base.StringTokenizer.create(p_ret,"|")
  #SELECT MAX(rbq08)+1 INTO l_rbq08 FROM rbq_file
  # WHERE rbq01 = g_argv1 AND rbq02 = g_argv2
  #   AND rbq04 = g_argv4 AND rbq07 = g_argv5
  #IF l_rbq08 IS NULL THEN LET l_rbq08 = 1 END IF
   WHILE l_tok.hasMoreTokens()
      LET l_rbq07 = l_tok.nextToken()
      SELECT COUNT(*) INTO l_n FROM rbq_file
       WHERE rbq01 = g_argv1 AND rbq02 = g_argv2
         AND rbq04 = g_argv4 AND rbq07 = l_rbq07
         AND rbqplant = g_argv5
      IF l_n = 0 THEN
         
         INSERT INTO rbq_file(rbq01,rbq02,rbq04,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  #FUN-BC0072 add rbq09
                       VALUES(g_argv1,g_argv2,g_argv4,l_rbq07,
                              l_rbq08,' ',l_rbqacti,g_argv5,g_legal)  #FUN-BC0072 add ''
        #LET l_rbq08 = l_rbq08 + 1
      END IF
   END WHILE   
   CALL t402_1_b_fill(" 1=1")
END FUNCTION 

FUNCTION t402_1_find()
DEFINE l_n           LIKE type_file.num5  #FUN-BC0072 add
 
   LET g_rbq[l_ac].type  ='1'
   LET g_rbq[l_ac].before='0'
   LET g_rbq[l_ac].after ='1'
   IF NOT cl_null(g_rbq[l_ac].rbq09) THEN  
      SELECT raq04,raq05,raq08,raqacti   #FUN-BC0072 add raq08
        INTO g_rbq[l_ac].rbq07_1,g_rbq[l_ac].rbq08_1,g_rbq[l_ac].rbq09_1,g_rbq[l_ac].rbqacti_1  #FUN-BC0072 add rbq09
        FROM raq_file
       WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv4
         AND raqplant=g_argv5 AND raq04=g_rbq[l_ac].rbq07
         AND raq08 = g_rbq[l_ac].rbq09   #FUN-BC0072 add
 #FUN-BC0072 add START
   ELSE
      SELECT DISTINCT raq04,raq05   
        INTO g_rbq[l_ac].rbq07_1,g_rbq[l_ac].rbq08_1
        FROM raq_file
       WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv4
         AND raqplant=g_argv5 AND raq04=g_rbq[l_ac].rbq07
      SELECT COUNT(*) INTO l_n FROM raq_file
       WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv4
         AND raqplant=g_argv5 AND raq04=g_rbq[l_ac].rbq07
         AND raqacti = 'Y'
      IF l_n > 0 THEN
         LET g_rbq[l_ac].rbqacti_1 = 'Y'
      END IF
   END IF
 #FUN-BC0072 add END

   SELECT azp02 INTO g_rbq[l_ac].rbq07_desc FROM azp_file  
    WHERE azp01 = g_rbq[l_ac].rbq07
   SELECT azp02 INTO g_rbq[l_ac].rbq07_1_desc FROM azp_file  
    WHERE azp01 = g_rbq[l_ac].rbq07_1

   DISPLAY BY NAME g_rbq[l_ac].rbq07_1,g_rbq[l_ac].rbq08_1,g_rbq[l_ac].rbq09_1,  #FUN-BC0072 add rbq09_1
           g_rbq[l_ac].rbqacti_1,
           g_rbq[l_ac].rbq07_1_desc
   DISPLAY BY NAME g_rbq[l_ac].rbq07,g_rbq[l_ac].rbq07_desc

END FUNCTION 

FUNCTION t402_1_init()
 
   LET g_rbq[l_ac].type  ='0'
   LET g_rbq[l_ac].before=' '
   LET g_rbq[l_ac].after ='1'

   LET g_rbq[l_ac].rbq07_1=NULL
   LET g_rbq[l_ac].rbq08_1=NULL
   LET g_rbq[l_ac].rbqacti_1=NULL
   LET g_rbq[l_ac].rbq07_1_desc=NULL
   LET g_rbq[l_ac].rbq09_1 = NULL  #FUN-BC0072 add

   DISPLAY BY NAME g_rbq[l_ac].rbq07_1,g_rbq[l_ac].rbq08_1,g_rbq[l_ac].rbqacti_1,
           g_rbq[l_ac].rbq07_1_desc, 
           g_rbq[l_ac].rbq09   #FUN-BC0072 add

  #SELECT  raq04,raq05,raqacti 
  #  INTO  g_rbq[l_ac].rbq07_1,g_rbq[l_ac].rbq08_1,g_rbq[l_ac].rbqacti_1
  #  FROM raq_file
  # WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv4
  #   AND raqplant=g_argv5 AND raq04=g_rbq[l_ac].rbq07
  #SELECT azp02 INTO g_rbq[l_ac].rbq07_desc FROM azp_file  
  # WHERE azp01 = g_rbq[l_ac].rbq07
  #DISPLAY BY NAME g_rbq[l_ac].rbq07,g_rbq[l_ac].rbq07_desc


END FUNCTION 

#FUN-BC0072 add START
FUNCTION t402_1_rbq09()
DEFINE l_n     LIKE type_file.num5
DEFINE l_n2    LIKE type_file.num5
   IF cl_null(g_rbq[l_ac].rbq07) THEN RETURN END IF
   LET g_flag2 = 'N'
   LET l_n = 0
   LET g_n = 0  
   IF cl_null(g_rbq[l_ac].rbq09) THEN  #攤位為空值
      SELECT COUNT(*) INTO l_n FROM raq_file  #判斷plant下是否存在於raq_file
         WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv4 
           AND raqplant=g_argv5 AND raq04 = g_rbq[l_ac].rbq07
      IF l_n > 0 THEN  #此plant存在於原促銷單的raq_file
         SELECT COUNT(*) INTO l_n2 FROM raq_file
            WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv4
              AND raqplant=g_argv5 AND raq04 = g_rbq[l_ac].rbq07
              AND (RTRIM(raq08) IS NULL )
         IF l_n2 = 0 THEN  #原促銷單此plant下有生效攤位
            LET g_flag2 = 'Y' 
         END IF
      END IF
   ELSE
      SELECT COUNT(*) INTO l_n FROM raq_file
         WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv4
           AND raqplant=g_argv5 AND raq04 = g_rbq[l_ac].rbq07
           AND raq08 = g_rbq[l_ac].rbq09
   END IF
   LET g_n = l_n
END FUNCTION
FUNCTION t402_1_chkrbq09(p_rbq07,p_rbq09)
DEFINE l_n      LIKE type_file.num5
DEFINE p_rbq07  LIKE rbq_file.rbq07
DEFINE p_rbq09  LIKE rbq_file.rbq09 
   LET l_n = 0
   IF g_rbq[l_ac].rbqacti = 'N' THEN RETURN l_n  END IF   #TQC-C80087 add
   IF NOT cl_null(p_rbq09) THEN
      SELECT COUNT(*) INTO l_n FROM rbq_file  #判斷是否有同plant但攤位為空值
         WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3 AND rbq04=g_argv4
           AND rbqplant=g_argv5 AND rbq06='1' AND rbq07 = p_rbq07
           AND (RTRIM(rbq09) IS NULL )
           AND rbqacti = 'Y'                 #TQC-C80087 add
   ELSE
      SELECT COUNT(*) INTO l_n FROM rbq_file   #判斷是否有同plant但攤位不為空值   
         WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3 AND rbq04=g_argv4
           AND rbqplant=g_argv5 AND rbq06='1' AND rbq07 = p_rbq07
          #AND (RTRIM(rbq09) IS NOT NULL )   #TQC-C80087 Mark
           AND rbqacti = 'Y'                 #TQC-C80087 add
   END IF
   RETURN l_n
END FUNCTION

FUNCTION t402_1_insrbq07rbq09()

   IF NOT cl_confirm('art-794') THEN   #是否設定生效攤位?
     CALL cl_init_qry_var()
     LET g_qryparam.state = "c"
     LET g_qryparam.form ="q_azp"
     LET g_qryparam.where = " azp01 IN (SELECT azw01 FROM azw_file WHERE azw07='",g_argv5,"' OR azw01='",g_argv5,"')"
     CALL cl_create_qry() RETURNING g_qryparam.multiret
     CALL t402_1_create2(g_qryparam.multiret)
   ELSE
     CALL cl_init_qry_var()
     LET g_qryparam.form = "q_lmf04"
     LET g_qryparam.state = "c"  
     LET g_qryparam.arg1 = g_argv5
     LET g_qryparam.default1 = g_rbq[l_ac].rbq09 
     CALL cl_create_qry() RETURNING g_qryparam.multiret
     CALL t402_1_create1(g_qryparam.multiret)  
   END IF
END FUNCTION

FUNCTION t402_1_create1(p_ret)
DEFINE p_ret             STRING
DEFINE l_tok             base.StringTokenizer
DEFINE l_rbq07           LIKE rbq_file.rbq07
DEFINE l_rbq09           LIKE rbq_file.rbq09
DEFINE l_n               LIKE type_file.num5
DEFINE l_rbq05_curr      LIKE rbq_file.rbq05

   SELECT MAX(rbq05) INTO l_rbq05_curr FROM rbq_file
        WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3
          AND rbqplant=g_argv5 AND rbq04 = g_argv4
   IF l_rbq05_curr = 0 OR cl_null(l_rbq05_curr) THEN
      LET l_rbq05_curr = 1
   ELSE
      LET l_rbq05_curr = l_rbq05_curr +1
   END IF      
   LET l_tok = base.StringTokenizer.create(p_ret,"|")
   WHILE l_tok.hasMoreTokens()
      BEGIN WORK
      LET l_rbq09 = l_tok.nextToken()

      SELECT lmfstore INTO l_rbq07 FROM lmf_file WHERE lmf01 = l_rbq09
      IF cl_null(l_rbq07) THEN CONTINUE WHILE END IF

      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM rbq_file
        WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3
          AND rbqplant=g_argv5 AND rbq04 = g_argv4 AND rbq09 = l_rbq09
          AND rbq07 = l_rbq07
      IF l_n>0 THEN
         CONTINUE WHILE
      END IF

      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rbq_file
        WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3
          AND rbqplant=g_argv5 AND rbq04 = g_argv4 AND RTRIM(rbq09) IS NULL 
          AND rbq07 = l_rbq07
      IF l_n>0 THEN
         CONTINUE WHILE
      END IF

      LET l_n = 0 
      CALL t402_1_chkrbq09(l_rbq07,l_rbq09) RETURNING l_n
      IF l_n > 0 THEN 

         INSERT INTO rbq_file(rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  #FUN-BC0072 add rbq09
            VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbq05_curr,'0',l_rbq07,
                   'N',l_rbq09,'Y',g_argv5,g_legal)
  
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","raq_file",l_rbq09,'',SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            CONTINUE WHILE
         END IF
      END IF
      INSERT INTO rbq_file(rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  #FUN-BC0072 add rbq09
         VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbq05_curr,'1',l_rbq07,
                'N',l_rbq09,'Y',g_argv5,g_legal)  
    
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rbq_file",l_rbq09,'',SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      LET l_rbq05_curr = l_rbq05_curr +1

   END WHILE
   CALL t402_1_b_fill(" 1=1 ")
END FUNCTION

FUNCTION t402_1_create2(p_ret)
DEFINE p_ret             STRING
DEFINE l_tok             base.StringTokenizer
DEFINE l_rbq07           LIKE rbq_file.rbq07
DEFINE l_rbq09           LIKE rbq_file.rbq09
DEFINE l_n               LIKE type_file.num5
DEFINE l_rbq05_curr      LIKE rbq_file.rbq05

   SELECT MAX(rbq05) INTO l_rbq05_curr FROM rbq_file
        WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3
          AND rbqplant=g_argv5 AND rbq04 = g_argv4
   IF l_rbq05_curr = 0 OR cl_null(l_rbq05_curr) THEN
      LET l_rbq05_curr = 1
   ELSE
      LET l_rbq05_curr = l_rbq05_curr +1
   END IF
   LET l_tok = base.StringTokenizer.create(p_ret,"|")
   WHILE l_tok.hasMoreTokens()
      BEGIN WORK
      LET l_rbq07 = l_tok.nextToken()
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rbq_file
        WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3
          AND rbqplant=g_argv5 AND rbq04 = g_argv4 AND RTRIM(rbq09) IS NOT NULL 
          AND rbq07 = l_rbq07
      IF l_n>0 THEN
         CONTINUE WHILE
      END IF

      SELECT COUNT(*) INTO l_n FROM rbq_file
        WHERE rbq01=g_argv1 AND rbq02=g_argv2 AND rbq03=g_argv3
          AND rbqplant=g_argv5 AND rbq04 = g_argv4 AND RTRIM(rbq09) IS NULL
          AND rbq07 = l_rbq07
      IF l_n>0 THEN
         CONTINUE WHILE
      END IF

      LET l_rbq09 = ' '
      LET l_n = 0
      CALL t402_1_chkrbq09(l_rbq07,l_rbq09) RETURNING l_n
      IF l_n > 0 THEN

         INSERT INTO rbq_file(rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  #FUN-BC0072 add rbq09
            VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbq05_curr,'0',l_rbq07,
                   'N',l_rbq09,'Y',g_argv5,g_legal)

         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","raq_file",l_rbq09,'',SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            CONTINUE WHILE
         END IF
      END IF
      INSERT INTO rbq_file(rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq08,rbq09,rbqacti,rbqplant,rbqlegal)  #FUN-BC0072 add rbq09
         VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbq05_curr,'1',l_rbq07,
                'N',l_rbq09,'Y',g_argv5,g_legal)

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rbq_file",l_rbq09,'',SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      LET l_rbq05_curr = l_rbq05_curr +1

   END WHILE
   CALL t402_1_b_fill(" 1=1 ")
END FUNCTION

#FUN-BC0072 add END

