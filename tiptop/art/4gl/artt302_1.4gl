# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"artt302_1.4gl"
#Descriptions..:生效機構維護作業
#Date & Author...: No.FUN-A60044 10/06/20 By Cockroach 
# Modify.........: No:TQC-AA0109 10/10/19 By lixia 開窗多選
# Modify.........: No:TQC-AB0161 10/11/28 By Cockroach 系统联测bug修改
# Modify.........: No:TQC-AC0326 10/12/24 By wangxin 添加發佈日期，發佈時間兩個欄位
# Modify.........: No:TQC-B20020 11/02/14 By shenyang 改bug 
# Modify.........: No:TQC-B70008 11/07/01 By guoch mark查詢action
# Modify.........: No.FUN-BB0056 11/11/10 By pauline GP5.3 artt302 一般促銷單促銷功能優化
# Modify.........: No.TQC-C40059 12/04/11 By pauline SELECT COUNT 時未將結果放入變數,導致錯誤 
# Modify.........: No:FUN-D30033 13/04/18 by chenjing 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_raq   DYNAMIC ARRAY OF RECORD 
                raq04       LIKE raq_file.raq04,
                raq04_desc  LIKE azp_file.azp02,              
                raq05       LIKE raq_file.raq05,
               #raqacti     LIKE raq_file.raqacti, #FUN-BB0056 mark
                acti        LIKE raq_file.raqacti, #FUN-BB0056 add 
                raq06       LIKE raq_file.raq06, #TQC-AC0326 add
                raq07       LIKE raq_file.raq07  #TQC-AC0326 add
                        END RECORD,
        g_raq_t RECORD
                raq04       LIKE raq_file.raq04,
                raq04_desc  LIKE azp_file.azp02,              
                raq05       LIKE raq_file.raq05,
               #raqacti     LIKE raq_file.raqacti,  #FUN-BB0056 mark
                acti        LIKE raq_file.raqacti,  #FUN-BB0056 add
                raq06       LIKE raq_file.raq06, #TQC-AC0326 add
                raq07       LIKE raq_file.raq07  #TQC-AC0326 add
                        END RECORD
DEFINE   g_sql   STRING,
         g_wc   STRING,
         g_rec_b LIKE type_file.num5,
         l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_argv1         LIKE raq_file.raq01,
        g_argv2         LIKE raq_file.raq02,
        g_argv3         LIKE raq_file.raq03,
        g_argv4         LIKE raq_file.raqplant,
        g_argv5         LIKE rab_file.rabconf
DEFINE g_legal LIKE azw_file.azw01
#FUN-BB0056 add START
DEFINE g_raq2   DYNAMIC ARRAY OF RECORD
                raq08       LIKE raq_file.raq08,
                raqacti     LIKE raq_file.raqacti
                        END RECORD
DEFINE g_raq2_t   RECORD
                raq08       LIKE raq_file.raq08,
                raqacti     LIKE raq_file.raqacti
                  END RECORD

DEFINE g_rec_b2 LIKE type_file.num5,
       l_ac2    LIKE type_file.num5,
       g_cnt2   LIKE type_file.num5, 
       g_b_flag LIKE type_file.chr1,
       g_pos    LIKE rac_file.racpos,
       g_cnt3   LIKE type_file.num10
#FUN-BB0056 add END
FUNCTION t302_1(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5)
DEFINE  p_argv1         LIKE raq_file.raq01,
        p_argv2         LIKE raq_file.raq02,
        p_argv3         LIKE raq_file.raq03,
        p_argv4         LIKE raq_file.raqplant,
        p_argv5         LIKE rab_file.rabconf
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_argv4 = p_argv4
    LET g_argv5 = p_argv5
    SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_argv4
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t302_1_w AT p_row,p_col WITH FORM "art/42f/artt302_1"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("artt302_1")
    LET g_wc = " 1=1"
    CALL t302_1_b_fill(g_wc)
    IF g_argv5='N' THEN
    LET l_ac=g_rec_b+1
    IF g_argv1 = g_plant THEN   #TQC-B20020
       CALL t302_1_b()
    ELSE
       CALL cl_err( '','art-977',0 )             #TQC-B20020
    END IF           #TQC-B20020
    END IF
    CALL t302_1_menu()
 
    CLOSE WINDOW t302_1_w
END FUNCTION
 
FUNCTION t302_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_comp_entry("raq06,raq07",FALSE)     #TQC-AC0326 add
   DIALOG ATTRIBUTES(UNBUFFERED)   #FUN-BB0056 add
  #DISPLAY ARRAY g_raq TO s_raq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #FUN-BB0056 mark 
   DISPLAY ARRAY g_raq TO s_raq.* ATTRIBUTE(COUNT=g_rec_b)             #FUN-BB0056 add
      BEFORE DISPLAY
        CALL cl_navigator_setting(0,0)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
       #FUN-BB0056 add START  
         IF NOT cl_null(g_raq[l_ac].raq04) THEN 
            CALL t302_1_fill_1()
         END IF
       #FUN-BB0056 add END
      CALL cl_show_fld_cont()                   
      
    #TQC-B70008 --begin mark
    #  ON ACTION query
    #     LET g_action_choice="query"
    #     EXIT DISPLAY
    #TQC-B70008 --end mark
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
        #EXIT DISPLAY  #FUN-BB0056 mark 
         LET g_b_flag = '1'  #FUN-BB0056 add
         EXIT DIALOG   #FUN-BB0056 add
      ON ACTION help
         LET g_action_choice="help"
        #EXIT DISPLAY  #FUN-BB0056 mark
         EXIT DIALOG   #iFUN-BB0056 add
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
        #EXIT DISPLAY  #FUN-BB0056 mark
         EXIT DIALOG   #FUN-BB0056 add
 
    ON ACTION controlg
      LET g_action_choice="controlg"
     #EXIT DISPLAY   #FUN-BB0056 mark 
      EXIT DIALOG   #FUN-BB0056 add
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
     #EXIT DISPLAY  #FUN-BB0056 mark 
      LET g_b_flag = '1'  #FUN-BB0056 add
      EXIT DIALOG   #FUN-BB0056 add
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
     #EXIT DISPLAY  #FUN-BB0056 mark 
      EXIT DIALOG   #FUN-BB0056 add
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
       #CONTINUE DISPLAY  #FUN-BB0056 mark 
        CONTINUE DIALOG   #FUN-BB0056 add
 
      ON ACTION about         
         CALL cl_about()      
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
        #EXIT DISPLAY  #FUN-BB0056 mark
         EXIT DIALOG   #FUN-BB0056 add
      AFTER DISPLAY
        #CONTINUE DISPLAY  #FUN-BB0056 mark
         CONTINUE DIALOG   #FUN-BB0056 add
 
    END DISPLAY

#FUN-BB0056 add START
   DISPLAY ARRAY g_raq2 TO s_raq2.* ATTRIBUTE(COUNT=g_rec_b)             
      BEFORE DISPLAY
        CALL cl_navigator_setting(0,0)

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
      CALL cl_show_fld_cont()

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
         LET g_b_flag = '2' 
         EXIT DIALOG   
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG  

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG  

    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DIALOG   

    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac2 = ARR_CURR()
      LET g_b_flag = '2'  
      EXIT DIALOG   
    
    ON ACTION cancel
      LET INT_FLAG=FALSE
      LET g_action_choice="exit"
      EXIT DIALOG  

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG   

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG   
      AFTER DISPLAY
         CONTINUE DIALOG   

    END DISPLAY
    END DIALOG
#FUN-BB0056 add END
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t302_1_menu()
 
   WHILE TRUE
      CALL t302_1_bp("G")
      CASE g_action_choice
       #TQC-B70008  --begin mark
       #  WHEN "query"
       #     IF cl_chk_act_auth() THEN
       #        CALL t302_1_q()
       #     END IF
       #TQC-B70008  --end  mark
         WHEN "detail"
            IF cl_chk_act_auth()  THEN    
              IF g_argv1 = g_plant THEN  #TQC-B20020
               IF g_b_flag = '1' THEN
                  CALL t302_1_b()
               ELSE                 #FUN-BB0056 add
                  CALL t302_1_b1()  #FUN-BB0056 add
               END IF               #FUN-BB0056 add 
              ELSE                                       #TQC-B20020
               CALL cl_err( '','art-977',0 )             #TQC-B20020
               LET g_action_choice = NULL                #TQC-B20020
              END IF                                     #TQC-B20020
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_raq),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t302_1_q()
 
   CALL t302_1_b_askkey()
   
END FUNCTION
 
FUNCTION t302_1_b_askkey()
 
    CLEAR FORM
  
   # CONSTRUCT g_wc ON raq04,raq05,raqacti  #FUN-BB0056 mark
   #                 FROM s_raq[1].raq04,s_raq[1].raq05,s_raq[1].raqacti  #FUN-BB0056 mark
    CONSTRUCT g_wc ON raq04,raq05,acti   #FUN-BB0056 add
                    FROM s_raq[1].raq04,s_raq[1].raq05,s_raq[1].acti   #FUN-BB0056 add
 
           ON ACTION controlp
           CASE
              WHEN INFIELD(raq04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_raq04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO raq04
                 NEXT FIELD raq04
 
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
 
    CALL t302_1_b_fill(g_wc)
    
END FUNCTION
 
FUNCTION t302_1_raq04(p_cmd)         
DEFINE    p_cmd   STRING,
          l_raq04_desc LIKE azp_file.azp02  #No.FUN-960130
DEFINE l_n LIKE type_file.num5
          
   LET g_errno = ' '
   
   SELECT azp02 INTO l_raq04_desc FROM azp_file  #No.FUN-960130
    WHERE azp01 = g_raq[l_ac].raq04
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002' 
                                 LET l_raq04_desc = NULL 
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) THEN
     SELECT COUNT(*) INTO l_n FROM azp_file
      WHERE azp01 IN (SELECT azw01 FROM azw_file WHERE azw07=g_argv4 OR azw01=g_argv4)
        AND azp01 = g_raq[l_ac].raq04
     IF l_n=0 THEN
        LET g_errno='art-500'
     END IF
  END IF 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_raq[l_ac].raq04_desc=l_raq04_desc
     DISPLAY BY NAME g_raq[l_ac].raq04_desc
  END IF
 
END FUNCTION
 
FUNCTION t302_1_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
   #LET g_sql = "SELECT raq04,'',raq05,raqacti,raq06,raq07 FROM raq_file ", #TQC-AC0326 add raq06,raq07  #FUN-BB0056 mark
    LET g_sql = "SELECT DISTINCT raq04,'',raq05,'',raq06,raq07 FROM raq_file ",      #FUN-BB0056 add
                " WHERE raq01='",g_argv1 CLIPPED,"' AND raq02='",g_argv2 CLIPPED,
                "' AND raq03='",g_argv3 CLIPPED,
                "' AND raqplant='",g_argv4 CLIPPED,"'"
              # "' AND raq03='",g_argv3 CLIPPED,"' AND raq04='",g_argv4 CLIPPED
              # "' AND raqplant='",g_argv4 CLIPPED,"'"
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql = g_sql," ORDER BY raq04"
    PREPARE t302_1_pb FROM g_sql
    DECLARE raq_cs CURSOR FOR t302_1_pb
 
    CALL g_raq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH raq_cs INTO g_raq[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        CALL t302_1_acti()   #FUN-BB0056 add 
        SELECT azp02 INTO g_raq[g_cnt].raq04_desc FROM azp_file #No.FUN-960130
         WHERE azp01 = g_raq[g_cnt].raq04
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_raq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t302_1_b()
DEFINE l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_sql           STRING   #FUN-BB0056 add 
   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
   IF g_argv5<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN 
   END IF
   
   CALL cl_opmsg('b')
 #FUN-BB0056 mark START  
 # LET g_forupd_sql="SELECT  raq04,'',raq05,raqacti,raq06,raq07",#TQC-AC0326 add raq06,raq07
 #                 " FROM raq_file",
 #                 " WHERE raq01=? AND raq02=?",
 #                 " AND raq03=? AND raq04=? ",
 #                 " AND raqplant=? ",
 #                 " FOR UPDATE"
 # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
 # DECLARE t302_1_bcl CURSOR FROM g_forupd_sql
 #FUN-BB0056 mark END  
   LET l_allow_insert=cl_detail_input_auth("insert")
   LET l_allow_delete=cl_detail_input_auth("delete")
   
   INPUT ARRAY g_raq WITHOUT DEFAULTS FROM s_raq.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
              APPEND ROW= l_allow_insert)
   BEFORE INPUT
      IF g_rec_b !=0 THEN 
         CALL fgl_set_arr_curr(l_ac)
         CALL cl_set_comp_entry("raq06,raq07",FALSE)     #TQC-AC0326 add
      END IF
   BEFORE ROW
      LET p_cmd =''
      LET l_ac =ARR_CURR()
      LET l_lock_sw ='N'
      LET l_n =ARR_COUNT()
      CALL t302_1_fill_1()
 
      BEGIN WORK 
                  
      IF g_rec_b>=l_ac THEN 
         LET p_cmd ='u'
         LET g_raq_t.*=g_raq[l_ac].*
         IF p_cmd='u' THEN
            CALL cl_set_comp_entry("raq04",FALSE)
         ELSE
            CALL cl_set_comp_entry("raq04",TRUE)
         END IF
       #FUN-BB0056 mark START  
       # OPEN t302_1_bcl USING g_argv1,g_argv2,g_argv3,
       #                       g_raq_t.raq04,g_argv4
       # IF STATUS THEN
       #    CALL cl_err("OPEN t302_1_bcl:",STATUS,1)
       #    LET l_lock_sw='Y'
       # ELSE
       #    FETCH t302_1_bcl INTO g_raq[l_ac].*
       #    IF SQLCA.sqlcode THEN
       #       CALL cl_err(g_raq_t.raq04,SQLCA.sqlcode,1)
       #       LET l_lock_sw="Y"
       #    END IF
       #    CALL t302_1_raq04('d')
       # END IF
       #FUN-BB0056 mark END
      END IF
      
    BEFORE INSERT
       LET l_n=ARR_COUNT()
       LET p_cmd='a'
       INITIALIZE g_raq[l_ac].* TO NULL               
       LET g_raq[l_ac].raq05='N'
      #LET g_raq[l_ac].raqacti='Y'  #FUN-BB0056 mark
       LET g_raq[l_ac].acti='Y'  #FUN-BB0056 add
       LET g_raq_t.*=g_raq[l_ac].*
       IF p_cmd='u' THEN
          CALL cl_set_comp_entry("raq04",FALSE)
       ELSE
          CALL cl_set_comp_entry("raq04",TRUE)
       END IF
       CALL cl_show_fld_cont()
       NEXT FIELD raq04
    AFTER INSERT
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          CANCEL INSERT
       END IF
       IF NOT cl_null(g_raq[l_ac].raq04) THEN
          INSERT INTO raq_file(raq01,raq02,raq03,raq04,raq05,raqacti,raqplant,raqlegal)
             VALUES(g_argv1,g_argv2,g_argv3,g_raq[l_ac].raq04,
                   #g_raq[l_ac].raq05,g_raq[l_ac].raqacti,g_argv4,g_legal)  #FUN-BB0056 mark
                    g_raq[l_ac].raq05,g_raq[l_ac].acti,g_argv4,g_legal)     #FUN-BB0056 add
                 
          IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","raq_file",g_raq[l_ac].raq04,g_raq[l_ac].raq05,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT Ok'
          #FUN-BB0056 add START
             CALL t302_1_pos() #FUN-BB0056 add 
          #FUN-BB0056 add END
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b To FORMONLY.cn2
          END IF
       END IF
    # BEFORE FIELD raq05
    #   IF cl_null(g_raq[l_ac].raq05) OR g_raq[l_ac].raq05 = 0 THEN 
    #       SELECT MAX(raq05)+1 INTO g_raq[l_ac].raq05 FROM raq_file
    #        WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
    #          AND raq04=g_argv4 AND raqplant=g_argv5
    #       IF cl_null(g_raq[l_ac].raq05) THEN
    #          LET g_raq[l_ac].raq05=1
    #       END IF
    #    END IF
    #    
    # AFTER FIELD raq05
    #   IF NOT cl_null(g_raq[l_ac].raq05) THEN 
    #      IF p_cmd = 'a' OR (p_cmd = 'u' AND 
    #                        g_raq[l_ac].raq05 <> g_raq_t.raq05) THEN
    #         IF g_raq[l_ac].raq05 < = 0 THEN
    #            CALL cl_err(g_raq[l_ac].raq05,'aec-994',0)
    #            NEXT FIELD raq05
    #         ELSE
    #           SELECT COUNT(*) INTO l_n FROM raq_file
    #            WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
    #              AND raq04=g_argv4 AND raq05=g_raq[l_ac].raq05
    #           IF l_n>0 THEN
    #               CALL cl_err('',-239,0)
    #               LET g_raq[l_ac].raq05=g_raq_t.raq05
    #               NEXT FIELD raq05
    #           END IF
    #         END IF
    #      END IF
    #    END IF
         
      AFTER FIELD raq04
             IF NOT cl_null(g_raq[l_ac].raq04) THEN  
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                             g_raq[l_ac].raq04 <> g_raq_t.raq04) THEN
                SELECT COUNT(*) INTO l_n FROM raq_file
                 WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                   AND raqplant=g_argv4 AND raq04 = g_raq[l_ac].raq04
                IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_raq[l_ac].raq04=g_raq_t.raq04
                    NEXT FIELD raq04
                ELSE  
                  CALL t302_1_raq04('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('raq04',g_errno,0)
                     LET g_raq[l_ac].raq04 = g_raq_t.raq04
                     DISPLAY BY NAME g_raq[l_ac].raq04
                     NEXT FIELD raq04
                  END IF  
                END IF  
                END IF    
             END IF

    #FUN-BB0056 add START
       ON CHANGE acti
          IF NOT cl_null(g_raq[l_ac].acti) THEN 
             UPDATE raq_file SET raqacti = g_raq[l_ac].acti 
                    WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                      AND raqplant=g_argv4 AND raq04=g_raq_t.raq04
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","raq_file",g_raq_t.raq05,'',SQLCA.sqlcode,"","",1)
                 LET g_raq[l_ac].* = g_raq_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CALL t302_1_pos() #FUN-BB0056 add 
                 COMMIT WORK
                 CALL t302_1_fill_1() 
              END IF

          END IF
           
          
    #FUN-BB0056 add END
                           
       BEFORE DELETE                      
          #IF g_raq_t.raq05 > 0 AND NOT cl_null(g_raq_t.raq05) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM raq_file
                     WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                      AND raqplant=g_argv4 AND raq04=g_raq_t.raq04
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","raq_file",g_raq_t.raq04,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
               CALL t302_1_fill_1()  #FUN-BB0056 add 
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
          #END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_raq[l_ac].* = g_raq_t.*
             #CLOSE t302_1_bcl  #FUN-BB0056 mark
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_raq[l_ac].raq04,-263,1)
              LET g_raq[l_ac].* = g_raq_t.*
           ELSE
            IF cl_null(g_raq[l_ac].raq04) THEN
             DELETE FROM raq_file
              WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                AND raqplant=g_argv4 AND raq04=g_raq_t.raq04
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","raq_file",g_raq_t.raq04,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
              ELSE
                 COMMIT WORK
                 LET g_rec_b=g_rec_b-1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
            ELSE
              UPDATE raq_file SET  raq04 = g_raq[l_ac].raq04,
                                   raq05 = g_raq[l_ac].raq05
                                  #raqacti = g_raq[l_ac].raqacti  #FUN-BB0056 mark
                    WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                      AND raqplant=g_argv4 AND raq04=g_raq_t.raq04
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","raq_file",g_raq_t.raq05,'',SQLCA.sqlcode,"","",1) 
                 LET g_raq[l_ac].* = g_raq_t.*
              ELSE
                 CALL t302_1_pos() #FUN-BB0056 add  
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033
        #FUN-D30033--mark--str
        #  IF cl_null(g_raq[l_ac].raq04) THEN
        #     CALL g_raq.deleteelement(l_ac)
        #  END IF
        #FUN-D30033--mark--end
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_raq[l_ac].* = g_raq_t.*
        #FUN-D30033--add--str--
              ELSE 
                 IF g_b_flag = '1' THEN
                    CALL g_raq.deleteElement(l_ac)
                    IF g_rec_b != 0 THEN
                       LET g_action_choice = "detail"
                       LET l_ac = l_ac_t
                    END IF                     
                 END IF
        #FUN-D30033--add--end--
              END IF
             #CLOSE t302_1_bcl  #FUN-BB0056 mark 
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033
          #CLOSE t302_1_bcl  #FUN-BB0056 mark
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(raq04) AND l_ac > 1 THEN
              LET g_raq[l_ac].* = g_raq[l_ac-1].*
             #LET g_raq[l_ac].raq05 = g_rec_b + 1
              NEXT FIELD raq04
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(raq04)                     
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azp" 
               LET g_qryparam.where = " azp01 IN (SELECT azw01 FROM azw_file WHERE azw07='",g_argv4,"' OR azw01='",g_argv4,"')"
               LET g_qryparam.default1 = g_raq[l_ac].raq04
              # CALL cl_create_qry() RETURNING g_raq[l_ac].raq04
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL t302_1_create(g_qryparam.multiret)
              EXIT INPUT          #TQC-AA0109
               #DISPLAY BY NAME g_raq[l_ac].raq04
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
#FUN-BB0056 add START
        ON ACTION del_all_plant
            CALL t302_1_del_plant()
#FUN-BB0056 add END           
    END INPUT
  
   #CLOSE t302_1_bcl  #FUN-BB0056 mark
    COMMIT WORK
    
END FUNCTION                          
                                                   
FUNCTION t302_1_bp_refresh()
 
  DISPLAY ARRAY g_raq TO s_raq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION t302_1_create(p_ret)
DEFINE p_ret STRING
DEFINE l_tok base.StringTokenizer
DEFINE l_raq04   LIKE raq_file.raq04
DEFINE l_raq05   LIKE raq_file.raq05
DEFINE l_raqacti LIKE raq_file.raqacti
DEFINE l_n       LIKE type_file.num5
 
  #LET l_raq05='Y'  #TQC-AB0161 MARK
   LET l_raq05='N'  #TQC-AB0161 ADD
   LET l_tok = base.StringTokenizer.create(p_ret,"|")
  #SELECT MAX(raq05)+1 INTO l_raq05 FROM raq_file
  # WHERE raq01 = g_argv1 AND raq02 = g_argv2
  #   AND raq03 = g_argv3 AND raq04 = g_argv4
  #IF l_raq05 IS NULL THEN LET l_raq05 = 1 END IF
   WHILE l_tok.hasMoreTokens()
      LET l_raq04 = l_tok.nextToken()
      SELECT COUNT(*) INTO l_n FROM raq_file
       WHERE raq01 = g_argv1 AND raq02 = g_argv2
         AND raq03 = g_argv3 AND raq04 = l_raq04
         AND raqplant = g_argv4
      IF l_n = 0 THEN
         INSERT INTO raq_file(raq01,raq02,raq03,raq04,raq05,raqacti,raqplant,raqlegal)
                       VALUES(g_argv1,g_argv2,g_argv3,l_raq04,
                              #l_raq05,l_raqacti,g_argv4,g_legal)
                               l_raq05,'Y',g_argv4,g_legal)  #add TQC-AA0109
        #LET l_raq05 = l_raq05 + 1
      END IF
   END WHILE
   CALL t302_1_pos() #FUN-BB0056 add 
   CALL t302_1_b_fill(" 1=1")
END FUNCTION 
#FUN-A60044 
                      
 
#FUN-BB0056 add STATR
FUNCTION t302_1_fill_1()
DEFINE l_sql          STRING
DEFINE l_acti         LIKE raq_file.raqacti
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_i            LIKE type_file.num5
   LET l_acti = 'N'
   IF cl_null(g_raq[l_ac].raq04) THEN 
      RETURN 
   END IF
   LET g_cnt2 = 1

   LET l_sql = " SELECT raq08,raqacti FROM raq_file ",
               " WHERE raq01='",g_argv1 CLIPPED,"' AND raq02='",g_argv2 CLIPPED,"'",
               "   AND raq03='",g_argv3 CLIPPED,"'",
               "   AND raqplant='",g_argv4 CLIPPED,"'",
               "   AND raq04 = '",g_raq[l_ac].raq04 CLIPPED,"'",
               "   AND (RTRIM(raq08) IS NOT NULL )"
   PREPARE t302_1_pb1 FROM l_sql
   DECLARE t302_1_curs CURSOR FOR t302_1_pb1 
   CALL g_raq2.clear()
   FOREACH t302_1_curs INTO g_raq2[g_cnt2].*
      IF cl_null(g_raq2[g_cnt2].raq08) THEN
         LET g_raq2[g_cnt2].raqacti = 'N'
      END IF
      LET g_cnt2 = g_cnt2 + 1 
   END FOREACH
   CALL g_raq2.deleteElement(g_cnt2)
   LET g_cnt3 = g_cnt2 - 1 
   LET g_rec_b2= g_cnt2 - 1
   LET g_cnt2 = 0 
   CALL t302_1_raq2_refresh() 

END FUNCTION

FUNCTION t302_1_create1(p_ret)
DEFINE p_ret STRING
DEFINE l_tok base.StringTokenizer
DEFINE p_raq04   LIKE raq_file.raq04
DEFINE l_raq08   LIKE raq_file.raq08
DEFINE l_raqacti LIKE raq_file.raqacti
DEFINE l_n       LIKE type_file.num5

   LET l_tok = base.StringTokenizer.create(p_ret,"|")
   WHILE l_tok.hasMoreTokens()
      LET l_raq08 = l_tok.nextToken()
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM raq_file
        WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
          AND raqplant=g_argv4 AND raq04 = g_raq[l_ac].raq04 AND raq08 = l_raq08
      IF l_n>0 THEN
         CONTINUE WHILE 
      END IF 
      SELECT COUNT(*) INTO l_n FROM raq_file
       WHERE raq01 = g_argv1 AND raq02 = g_argv2
         AND raq03 = g_argv3 AND raq04 = g_raq[l_ac].raq04 
         AND raqplant = g_argv4
         AND (RTRIM(raq08) IS NULL )

      IF l_n < 1 THEN  
         INSERT INTO raq_file(raq01,raq02,raq03,raq04,raq08,raq05,raqacti,raqplant,raqlegal)
                       VALUES(g_argv1,g_argv2,g_argv3,g_raq[l_ac].raq04,l_raq08,
                               'N','Y',g_argv4,g_legal) 
      ELSE
         UPDATE raq_file SET raq08 = l_raq08
            WHERE raq01 = g_argv1 AND raq02 = g_argv2
              AND raq03 = g_argv3 AND raq04 = g_raq[l_ac].raq04  
              AND raqplant = g_argv4
              AND (RTRIM(raq08) IS NULL )   
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","raq_file",l_raq08,'',SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
      ELSE 
         CALL t302_1_pos() #FUN-BB0056 add 
         COMMIT WORK
      END IF
   END WHILE
   CALL t302_1_fill_1()
   CALL t302_1_b1()
END FUNCTION

FUNCTION t302_1_b1()
DEFINE l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5,
       p_raq04         LIKE raq_file.raq04,
       l_raq05         LIKE raq_file.raq05,
       l_raq06         LIKE raq_file.raq06
   IF cl_null(g_raq[l_ac].raq04) THEN
      RETURN
   END IF
   SELECT DISTINCT raq05, raq06 INTO l_raq05, l_raq06 
       FROM raq_file 
       WHERE raq01 = g_argv1 AND raq02 = g_argv2
         AND raq03 = g_argv3
         AND raqplant= g_argv4
         AND raq04 = g_raq[l_ac].raq04 
  
   LET g_action_choice=""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_argv5<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql="SELECT raq08,raqacti "  ,
                   " FROM raq_file",
                   " WHERE raq01=? AND raq02=?",
                   " AND raq03=? AND raq04=? ",
                   " AND raqplant=? ",
                   " AND raq08 = ? ",
                   " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t302_1_bcl2 CURSOR FROM g_forupd_sql

   LET l_allow_insert=cl_detail_input_auth("insert")
   LET l_allow_delete=cl_detail_input_auth("delete")

   INPUT ARRAY g_raq2 WITHOUT DEFAULTS FROM s_raq2.*
      ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
              APPEND ROW= l_allow_insert)

   BEFORE ROW
      LET p_cmd =''
      LET l_ac2 =ARR_CURR()
      LET l_lock_sw ='N'
      LET l_n =ARR_COUNT()
      IF cl_null(g_raq2[l_ac2].raqacti) THEN
         LET g_raq2[l_ac2].raqacti='Y'
      END IF
      BEGIN WORK

      IF g_rec_b2>=l_ac2 THEN
         LET p_cmd ='u'
         LET g_raq2_t.*=g_raq2[l_ac2].*

         OPEN t302_1_bcl2 USING g_argv1,g_argv2,g_argv3,
                               g_raq[l_ac].raq04,g_argv4,
                               g_raq2_t.raq08
         IF STATUS THEN
            CALL cl_err("OPEN t302_1_bcl2:",STATUS,1)
            LET l_lock_sw='Y'
         ELSE
            FETCH t302_1_bcl2 INTO g_raq2[l_ac2].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_raq[l_ac].raq04,SQLCA.sqlcode,1)
               LET l_lock_sw="Y"
            END IF
         END IF
      END IF

    BEFORE INSERT
       LET l_n=ARR_COUNT()
       LET p_cmd='a'
       INITIALIZE g_raq2[l_ac2].* TO NULL
       LET g_raq2[l_ac2].raqacti='Y'  
       LET g_raq2_t.*=g_raq2[l_ac2].*
       CALL cl_show_fld_cont()
       NEXT FIELD raq08

    AFTER INSERT
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          CANCEL INSERT
       END IF
       IF NOT cl_null(g_raq[l_ac].raq04) THEN
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_raq2[l_ac2].raq08,-263,1)
              LET g_raq2[l_ac2].* = g_raq2_t.*
           ELSE
             LET l_n = 0
             SELECT COUNT(*) INTO l_n FROM raq_file
              WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                AND raqplant=g_argv4 AND raq04 = g_raq[l_ac].raq04 AND (RTRIM(raq08) IS NULL  )
             IF l_n = 1 THEN
                UPDATE raq_file SET  raq08 = g_raq2[l_ac2].raq08,
                                     raqacti = g_raq2[l_ac2].raqacti
                       WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                         AND raqplant=g_argv4 AND raq04=g_raq[l_ac].raq04
             ELSE
                INSERT INTO raq_file(raq01,raq02,raq03,raq04,raq05,raq08,raqacti,raqplant,raqlegal)
                    VALUES(g_argv1,g_argv2,g_argv3,g_raq[l_ac].raq04,l_raq05,
                           g_raq2[l_ac2].raq08,g_raq2[l_ac2].raqacti,g_argv4,g_legal)
             END IF
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","raq_file",g_raq2_t.raq08,'',SQLCA.sqlcode,"","",1)
                LET g_raq2[l_ac2].* = g_raq2_t.*
             ELSE
                CALL t302_1_pos() #FUN-BB0056 add  
                MESSAGE 'INSERT O.K'
                COMMIT WORK
             END IF
             LET g_rec_b2 = g_rec_b2 + 1 
          END IF
       END IF 

    AFTER FIELD raq08
       IF NOT cl_null(g_raq2[l_ac2].raq08) THEN
          IF p_cmd = 'a' OR (p_cmd = 'u' AND
                       g_raq2[l_ac2].raq08 <> g_raq2_t.raq08) THEN
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM raq_file
              WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                AND raqplant=g_argv4 AND raq04 = g_raq[l_ac].raq04 AND raq08 = g_raq2[l_ac2].raq08
             IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_raq2[l_ac2].raq08=g_raq2_t.raq08
                 NEXT FIELD raq08
             ELSE
               #CALL t302_1_raq08('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('raq08',g_errno,0)
                  LET g_raq2[l_ac2].raq08 = g_raq2_t.raq08
                  DISPLAY BY NAME g_raq2[l_ac2].raq08
                  NEXT FIELD raq08
               END IF
             END IF
             LET l_n = 0 
            #SELECT COUNT(*) FROM lmf_file   #TQC-C40059 mark 
             SELECT COUNT(*) INTO l_n FROM lmf_file   #TQC-C40059 add
               WHERE lmf06 = 'Y' AND lmfstore = g_raq[l_ac].raq04
             IF l_n < 1 THEN
                CALL cl_err('','art-781',0)
                NEXT FIELD raq08
             END IF
          END IF
        END IF

     BEFORE DELETE
        IF NOT cl_delb(0,0) THEN
           CANCEL DELETE
        END IF
        IF l_lock_sw = "Y" THEN
           CALL cl_err("", -263, 1)
           CANCEL DELETE
        END IF
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM raq_file 
            WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
              AND raqplant=g_argv4 AND raq04=g_raq[l_ac].raq04
              AND raq08 <> g_raq2[l_ac2].raq08
        IF l_cnt > 0 THEN  
           DELETE FROM raq_file
               WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                 AND raqplant=g_argv4 AND raq04=g_raq[l_ac].raq04
                 AND raq08 = g_raq2[l_ac2].raq08
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("del","raq_file",g_raq2_t.raq08,'',SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              CANCEL DELETE
           END IF
           LET g_rec_b2=g_rec_b2-1
        ELSE 
           UPDATE raq_file SET raq08 = ' '
               WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                 AND raqplant=g_argv4 AND raq04=g_raq[l_ac].raq04
           IF SQLCA.sqlcode  OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("del","raq_file",g_raq2_t.raq08,'',SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              CANCEL DELETE
           ELSE
              CALL t302_1_pos() #FUN-BB0056 add  
              COMMIT WORK
           END IF
           LET g_rec_b2=g_rec_b2-1
        END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_raq2[l_ac2].* = g_raq2_t.*
              CLOSE t302_1_bcl2  
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_raq2[l_ac2].raq08,-263,1)
              LET g_raq2[l_ac2].* = g_raq2_t.*
           ELSE
             UPDATE raq_file SET raq08 = g_raq2[l_ac2].raq08,
                                 raqacti = g_raq2[l_ac2].raqacti
                          WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
                            AND raqplant=g_argv4 AND raq04=g_raq[l_ac].raq04
                            AND raq08 = g_raq2_t.raq08
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","raq_file",g_raq2_t.raq08,'',SQLCA.sqlcode,"","",1)
                LET g_raq2[l_ac2].* = g_raq2_t.*
             ELSE
                CALL t302_1_pos() #FUN-BB0056 add  
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
             CALL t302_1_b_fill(" 1=1")
           END IF

        AFTER ROW
           LET l_ac2 = ARR_CURR()
        #  LET l_ac_t = l_ac2    #FUN-D30033
        #  IF cl_null(g_raq2[l_ac2].raq08) THEN   #FUN-D30033 
        #     CALL g_raq2.deleteelement(l_ac2)    #FUN-D30033
        #  END IF                                 #FUN-D30033
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_raq2[l_ac2].* = g_raq2_t.*
        #FUN-D30033--add--str--
              ELSE
                 IF g_b_flag = '2' THEN
                    CALL g_raq.deleteElement(l_ac2)
                    IF g_rec_b2 != 0 THEN
                       LET g_action_choice = "detail"
                       LET l_ac2 = l_ac_t
                    END IF
                 END IF
        #FUN-D30033--add--end--
              END IF
              CLOSE t302_1_bcl2 
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac2    #FUN-D30033
           CLOSE t302_1_bcl2  
           COMMIT WORK

        ON ACTION CONTROLO
           IF INFIELD(raq08) AND l_ac2 > 1 THEN
              LET g_raq2[l_ac2].* = g_raq2[l_ac2-1].*
              NEXT FIELD raq08
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(raq08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_lmf_2"
               LET g_qryparam.arg1 =g_raq[l_ac].raq04 
               LET g_qryparam.default1 = g_raq2[l_ac2].raq08
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL t302_1_create1(g_qryparam.multiret)
               EXIT INPUT          
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

#FUN-BB0056 add START
        ON ACTION del_all_vendor
            CALL t302_1_del_vendor()
#FUN-BB0056 add END
    END INPUT

    CLOSE t302_1_bcl2  
    COMMIT WORK

END FUNCTION
#整批刪除生效營運中心
FUNCTION t302_1_del_plant()
 
   IF NOT cl_confirm('art-772') THEN
      RETURN
   ELSE
      DELETE FROM raq_file 
        WHERE raq01 = g_argv1 AND raq02 = g_argv2
          AND raq03 = g_argv3
          AND raqplant = g_argv4
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","raq_file",g_raq_t.raq05,'',SQLCA.sqlcode,"","",1)
         LET g_raq[l_ac].* = g_raq_t.*
      ELSE
         MESSAGE 'UPDATE O.K'
         COMMIT WORK
      END IF
   END IF    
   LET g_rec_b = 0 
   CALL t302_1_b_fill(" 1=1")
   CALL t302_1_fill_1()
   CALL t302_1_b()
END FUNCTION
#整批刪除生效攤位
FUNCTION t302_1_del_vendor()
DEFINE l_raq08          LIKE raq_file.raq08
DEFINE l_sql            STRING
DEFINE l_cnt            LIKE type_file.num5
   IF NOT cl_confirm('art-773') THEN
         RETURN
   END IF

   SELECT MAX(raq08) INTO l_raq08 FROM raq_file
         WHERE raq01 = g_argv1
           AND raq02 = g_argv2
           AND raq03 = g_argv3
           AND raqplant = g_argv4
           AND raq04 = g_raq[l_ac].raq04

     UPDATE raq_file SET raq08 = ' '
         WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
           AND raqplant=g_argv4 AND raq04=g_raq[l_ac].raq04
           AND raq08 = l_raq08

      IF SQLCA.sqlcode  OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("del","raq_file",g_raq2_t.raq08,'',SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
      ELSE
         CALL t302_1_pos() #FUN-BB0056 add 
         COMMIT WORK
      END IF

    DELETE FROM raq_file 
         WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
           AND raqplant=g_argv4 AND raq04=g_raq[l_ac].raq04
           AND RTRIM(raq08) IS NOT NULL
      IF SQLCA.sqlcode  OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("del","raq_file",g_raq2_t.raq08,'',SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
      ELSE
         CALL t302_1_pos() #FUN-BB0056 add 
         COMMIT WORK
      END IF

 
{   LET l_sql = " SELECT raq08 FROM raq_file",
               " WHERE raq01 = '",g_argv1,"'",
               "   AND raq02 = '",g_argv2,"'",
               "   AND raq03 = '",g_argv3,"'",
               "   AND raqplant = '",g_argv4,"'",
               "   AND raq04 = '",g_raq[l_ac].raq04,"'"

   PREPARE t302_1_pb2 FROM l_sql
   DECLARE raq_cs2 CURSOR FOR t302_1_pb2  
   LET l_raq08 = ' '
   FOREACH raq_cs2 INTO l_raq08 
      SELECT COUNT(*) INTO l_cnt FROM raq_file
        WHERE raq01 = g_argv1 AND raq02 = g_argv2
          AND raq03 = g_argv3
          AND raqplant = g_argv4
          AND raq04 = g_raq[l_ac].raq04 
          AND raq08 <> l_raq08
      IF l_cnt > 0 THEN 
         DELETE FROM raq_file
            WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
              AND raqplant=g_argv4 AND raq04= g_raq[l_ac].raq04
              AND raq08 = l_raq08 
      ELSE  
         UPDATE raq_file SET raq08 = ' '
            WHERE raq01=g_argv1 AND raq02=g_argv2 AND raq03=g_argv3
              AND raqplant=g_argv4 AND raq04=g_raq[l_ac].raq04
              AND raq08 = l_raq08 
      END IF
      IF SQLCA.sqlcode  OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("del","raq_file",g_raq2_t.raq08,'',SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
      ELSE
         UPDATE rac_file SET racpos = g_pos
            WHERE rac01 = g_argv1 AND rac02 = g_argv2 
         COMMIT WORK
      END IF
      LET g_rec_b2=g_rec_b2-1
   END FOREACH
}
   CALL t302_1_fill_1()
END FUNCTION

FUNCTION t302_1_acti()
DEFINE l_cnt      LIKE type_file.num5
   SELECT COUNT(*) INTO l_cnt FROM raq_file
             WHERE raq01 = g_argv1 AND raq02 = g_argv2
               AND raq03 = g_argv3
               AND raqplant= g_argv4
               AND raq04 = g_raq[g_cnt].raq04
               AND raqacti = 'Y'
   IF l_cnt > 0 THEN
      LET g_raq[g_cnt].acti = 'Y'
   ELSE
      LET g_raq[g_cnt].acti = 'N'
   END IF
END FUNCTION
 
FUNCTION t302_1_pos()
DEFINE l_pos            LIKE rac_file.racpos
DEFINE l_sql            STRING  
   CASE g_argv3   
     WHEN '1'    
        LET l_sql = " SELECT DISTINCT racpos FROM rac_file ", 
                    " WHERE rac01 = '",g_argv1,"'",
                    " AND rac02 = '",g_argv2,"'"             
     WHEN '2'  
        LET l_sql = " SELECT DISTINCT raepos FROM rae_file ",         
                    " WHERE rae01 = '",g_argv1,"'",
                    " AND rae02 = '",g_argv2,"'"   
     WHEN '3'
        LET l_sql = " SELECT DISTINCT rahpos FROM rah_file ",         
                    " WHERE rah01 = '",g_argv1,"'",
                    " AND rah02 = '",g_argv2,"'"    
   END CASE
   PREPARE t302_1_prepos FROM l_sql
   DECLARE t302_1_clpos CURSOR FOR t302_1_prepos
   FOREACH t302_1_clpos INTO l_pos
       IF cl_null(l_pos) THEN CONTINUE FOREACH END IF
       IF l_pos <> '1' THEN
          LET g_pos = '2'
       ELSE
          LET g_pos = '1'
       END IF 
       CASE g_argv3 
          WHEN '1'       
             UPDATE rac_file SET racpos = g_pos
                WHERE rac01 = g_argv1 AND rac02 = g_argv2
          WHEN '2'
             UPDATE rae_file SET raepos = g_pos
                WHERE rae01 = g_argv1 AND rae02 = g_argv2
          WHEN '3'
             UPDATE rah_file SET rahpos = g_pos
                WHERE rah01 = g_argv1 AND rah02 = g_argv2
       END CASE
   END FOREACH

END FUNCTION

FUNCTION t302_1_raq2_refresh()

  DISPLAY ARRAY g_raq2 TO s_raq2.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION
#FUN-BB0056 add END
#FUN-A60044 
