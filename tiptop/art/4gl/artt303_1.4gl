# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name..:"art303_1.4gl"
# Descriptions..:換贈資料維護作業
# Date & Author..: FUN-A60044 10/06/27 By Cockroach
# Modify.........: FUN-A80104 10/08/19 By lixia資料類型改為varchar2(2)
# Modify.........: TQC-A90012 10/10/19 By houlia修改“換贈資料”組別控管
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0033 10/11/09 By wangxin 促銷BUG調整
# Modify.........: No.FUN-B30012 11/03/08 By baogc 換贈BUG修改
# Modify.........: No.FUN-BB0058 11/11/16 By pauline GP5.3 artt303 組合促銷單促銷功能優化 
# Modify.........: No.FUN-C10008 12/01/09 By pauline GP5.3 artt302 一般促銷單促銷功能優化調整
# Modify.........: No.TQC-C10125 12/01/30 By pauline 填寫換贈資料時選"10.券"時,券名稱未出現
# Modify.........: No.FUN-C60041 12/08/08 By huangtao rae28 rae29 不可為空
# Modify.........: No:FUN-D30033 13/04/18 by chenjing 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By chenjing 修改FUN-D30034遺留問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rar   DYNAMIC ARRAY OF RECORD 
                rar04      LIKE rar_file.rar04,     #項次
                rar05      LIKE rar_file.rar05,     #組別
                rar06      LIKE rar_file.rar06,     #數量
                rar07      LIKE rar_file.rar07,     #加價金額
                rar08      LIKE rar_file.rar08,     #會員加價金額
                raracti    LIKE rar_file.raracti    #有效否
                  END RECORD,
        g_rar_t   RECORD 
                rar04      LIKE rar_file.rar04,     #項次
                rar05      LIKE rar_file.rar05,     #組別
                rar06      LIKE rar_file.rar06,     #數量
                rar07      LIKE rar_file.rar07,     #加價金額
                rar08      LIKE rar_file.rar08,     #會員加價金額
                raracti    LIKE rar_file.raracti    #有效否
                  END RECORD,
        g_rar_o   RECORD
                rar04      LIKE rar_file.rar04,     #項次
                rar05      LIKE rar_file.rar05,     #組別
                rar06      LIKE rar_file.rar06,     #數量
                rar07      LIKE rar_file.rar07,     #加價金額
                rar08      LIKE rar_file.rar08,     #會員加價金額
                raracti    LIKE rar_file.raracti    #有效否
                  END RECORD
DEFINE g_ras         DYNAMIC ARRAY OF RECORD
           ras04          LIKE ras_file.ras04,
           ras05          LIKE ras_file.ras05,
           ras06          LIKE ras_file.ras06,
           ras07          LIKE ras_file.ras07,
           ras07_desc     LIKE type_file.chr100,
           ras08          LIKE ras_file.ras08,
           ras08_desc     LIKE gfe_file.gfe02,
           ras09          LIKE ras_file.ras09,   #FUN-BB0058 add
           rasacti        LIKE ras_file.rasacti
                     END RECORD,
       g_ras_t       RECORD
           ras04          LIKE ras_file.ras04,
           ras05          LIKE ras_file.ras05,
           ras06          LIKE ras_file.ras06,
           ras07          LIKE ras_file.ras07,
           ras07_desc     LIKE type_file.chr100,
           ras08          LIKE ras_file.ras08,
           ras08_desc     LIKE gfe_file.gfe02,
           ras09          LIKE ras_file.ras09,   #FUN-BB0058 add
           rasacti        LIKE ras_file.rasacti
                     END RECORD,
       g_ras_o       RECORD
           ras04          LIKE ras_file.ras04,
           ras05          LIKE ras_file.ras05,
           ras06          LIKE ras_file.ras06,
           ras07          LIKE ras_file.ras07,
           ras07_desc     LIKE type_file.chr100,
           ras08          LIKE ras_file.ras08,
           ras08_desc     LIKE gfe_file.gfe02,
           ras09          LIKE ras_file.ras09,   #FUN-BB0058 add
           rasacti        LIKE ras_file.rasacti
                     END RECORD
#FUN-BB0058 add START
DEFINE   g_rae      RECORD 
           rae28          LIKE rae_file.rae28,
           rae29          LIKE rae_file.rae29,
           rae31          LIKE rae_file.rae31
                    END RECORD
#FUN-BB0058 add END
DEFINE   g_sql      STRING,
         g_wc1      STRING,
         g_wc2      STRING,
         g_rec_b    LIKE type_file.num5,
         g_rec_b1   LIKE type_file.num5,
         l_ac1      LIKE type_file.num5,
         l_ac       LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_argv1         LIKE rar_file.rar01,
        g_argv2         LIKE rar_file.rar02,
        g_argv3         LIKE rar_file.rar03,
        g_argv4         LIKE rar_file.rarplant,
        g_argv5         LIKE rae_file.raeconf,
        g_argv6         LIKE rae_file.rae10

DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_legal LIKE azw_file.azw02
DEFINE g_rtz RECORD LIKE rtz_file.*
 
FUNCTION t303_gift(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6)
DEFINE  p_argv1         LIKE rar_file.rar01,
        p_argv2         LIKE rar_file.rar02,
        p_argv3         LIKE rar_file.rar03,
        p_argv4         LIKE rar_file.rarplant,
        p_argv5         LIKE rae_file.raeconf,
        p_argv6         LIKE rae_file.rae10
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_argv4 = p_argv4
    LET g_argv5 = p_argv5
    LET g_argv6 = p_argv6
 
   SELECT * INTO g_rtz.* FROM rtz_file WHERE rtz01 = g_argv4
   SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_argv4
  #SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_argv4
 
   LET p_row = 2 LET p_col = 21
    OPEN WINDOW t303_1 AT p_row,p_col WITH FORM "art/42f/artt303_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("artt303_1")
  #CALL cl_set_comp_visible("rar04,ras04",g_argv3='3')
   CALL t303_1_b(" 1=1") #FUN-BB0058 add  
   CALL t303_gift_b_fill(" 1=1")
   CALL t303_gift_b1_fill(" 1=1")
   IF g_rec_b=0 THEN    #AND g_argv5='N' THEN
      CALL t303_1_updrae()   #FUN-BB0058 add
      CALL t303_gift_b()
      CALL t303_gift_b1()
   END IF
   WHILE TRUE
       #TQC-D40025--str--
        IF g_action_choice = 'detail' THEN
        ELSE   
       #TQC-D40025--end--
            LET g_action_choice = ''   
        END IF     #TQC-D40025
      CALL t303_gift_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t303_gift_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_flag_b='1' THEN
                  CALL t303_gift_b()
               ELSE
                  CALL t303_gift_b1()
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
#FUN-BB0058 add START
         WHEN "modify"         #換贈資料
            IF cl_chk_act_auth() THEN
                  CALL t303_1_updrae() 
            END IF
#FUN-BB0058 add END

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rar),'','')
             END IF        
      END CASE
   END WHILE
   CLOSE WINDOW t303_1
END FUNCTION 
 
FUNCTION t303_gift_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
     #DISPLAY ARRAY g_rar TO s_rar.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      DISPLAY ARRAY g_rar TO s_rar.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
           CALL cl_navigator_setting(0,0)
           
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   

#FUN-BB0058 add START
         ON ACTION modify 
            LET g_action_choice="modify"
            EXIT DIALOG
#FUN-BB0058 add END
         
         ON ACTION query
            LET g_action_choice="query"
           #EXIT DISPLAY
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = 1
           #EXIT DISPLAY
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
           #EXIT DISPLAY
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                  
    
         ON ACTION exit
            LET g_action_choice="exit"
           #EXIT DISPLAY
            EXIT DIALOG
    
         ON ACTION controlg
            LET g_action_choice="controlg"
           #EXIT DISPLAY
            EXIT DIALOG
      
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = ARR_CURR()
           #EXIT DISPLAY
            EXIT DIALOG
      
         ON ACTION cancel
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
           #EXIT DISPLAY
            EXIT DIALOG
      
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
            #CONTINUE DISPLAY
             CONTINUE DIALOG
    
         ON ACTION about         
            CALL cl_about()      
               
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
           #EXIT DISPLAY
            EXIT DIALOG

         AFTER DISPLAY
           #CONTINUE DISPLAY
            CONTINUE DIALOG
       END DISPLAY

      DISPLAY ARRAY g_ras TO s_ras.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
           CALL cl_navigator_setting(0,0)
           
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()                   

#FUN-BB0058 add START
         ON ACTION modify 
            LET g_action_choice="modify"
            EXIT DIALOG
#FUN-BB0058 add END
         
         ON ACTION query
            LET g_action_choice="query"
           #EXIT DISPLAY
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = 1
           #EXIT DISPLAY
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
           #EXIT DISPLAY
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                  
    
         ON ACTION exit
            LET g_action_choice="exit"
           #EXIT DISPLAY
            EXIT DIALOG
    
         ON ACTION controlg
            LET g_action_choice="controlg"
           #EXIT DISPLAY
            EXIT DIALOG
      
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = ARR_CURR()
           #EXIT DISPLAY
            EXIT DIALOG
      
         ON ACTION cancel
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
           #EXIT DISPLAY
            EXIT DIALOG
      
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
            #CONTINUE DISPLAY
             CONTINUE DIALOG
    
         ON ACTION about         
            CALL cl_about()      
               
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
           #EXIT DISPLAY
            EXIT DIALOG

         AFTER DISPLAY
           #CONTINUE DISPLAY
            CONTINUE DIALOG
       END DISPLAY
    END DIALOG
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t303_gift_q()
 
  CALL cl_navigator_setting(0,0)
  CALL cl_opmsg('q')   
  CLEAR FORM 
  CALL g_rar.clear()
  MESSAGE ''
  DISPLAY ' ' TO FORMONLY.cnt
  CONSTRUCT g_wc1 ON rar04,rar05,rar06,rar07,rar08,raracti
                FROM s_rar[1].rar04,s_rar[1].rar05,s_rar[1].rar06,
                     s_rar[1].rar07,s_rar[1].rar08,s_rar[1].raracti
    #ON ACTION controlp
    #      CASE
    #         WHEN INFIELD(rar06)
    #            CALL cl_init_qry_var()
    #            LET g_qryparam.form = "q_rar06"
    #            LET g_qryparam.state = "c"
    #            CALL cl_create_qry() RETURNING g_qryparam.multiret
    #            DISPLAY g_qryparam.multiret TO rar06
    #            NEXT FIELD rar06
    #         OTHERWISE
    #            EXIT CASE
    #      END CASE
 
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
    
    IF INT_FLAG THEN 
        RETURN
    END IF
 
    CONSTRUCT g_wc2 ON ras04,ras05,ras06,ras07,ras08,rasacti
           FROM s_ras[1].ras04,s_ras[1].ras05,s_ras[1].ras06,
                s_ras[1].ras07,s_ras[1].ras08, s_ras[1].rasacti


      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ras07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ras07"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ras07
               NEXT FIELD ras07
            WHEN INFIELD(ras08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ras08"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ras08
               NEXT FIELD ras08
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT

    IF INT_FLAG THEN
       RETURN
    END IF

    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc2 = g_wc2 CLIPPED
    IF cl_null(g_wc1) THEN
       LET g_wc1=" 1=1"
    END IF
    IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"
    END IF
    CALL t303_gift_b_fill(g_wc1)
    CALL t303_gift_b1_fill(g_wc2)
END FUNCTION
 
FUNCTION t303_gift_b()
DEFINE l_n             LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_delete  LIKE type_file.num5
DEFINE l_allow_append  LIKE type_file.num5    
DEFINE l_ac_t          LIKE type_file.num5   #FUN-D30033
    LET g_action_choice = ''   #TQC-D40025 
    LET l_allow_insert=cl_detail_input_auth("insert")
    LET l_allow_delete=cl_detail_input_auth("delete")

    IF g_argv5<>'N' THEN
       CALL cl_err('','apm-267',0)
       RETURN 
    END IF
  #FUN-C10008 add START
    IF g_argv1 <> g_plant THEN
       CALL cl_err( '','art-977',0 )
       RETURN
    END IF
  #FUN-C10008 add END
    LET g_sql = "SELECT rar04,rar05,rar06,rar07,rar08,raracti",
                "  FROM rar_file ",
                " WHERE rar01=? AND rar02=? ",
                "   AND rar03=? AND rar04=? ",
                "   AND rar05=? AND rarplant=?",
                " FOR UPDATE"  
    LET g_sql = cl_forupd_sql(g_sql)    #FUN-9B0060


    DECLARE t303_gift_bcl CURSOR FROM g_sql
    INPUT ARRAY g_rar WITHOUT DEFAULTS FROM s_rar.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                CALL cl_set_comp_visible("rar04",g_argv3='3') 
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
                   LET g_rar_t.*=g_rar[l_ac].*
                   LET g_rar_o.*=g_rar[l_ac].* 

                   IF p_cmd='u' THEN
                      #CALL cl_set_comp_entry("rar04,rar05",FALSE)  
                   ELSE
                      CALL cl_set_comp_entry("rar04,rar05",TRUE)
                   END IF

                   OPEN t303_gift_bcl USING g_argv1,g_argv2,g_argv3,
                                           g_rar_t.rar04,g_rar_t.rar05,g_argv4
                   IF STATUS THEN
                      CALL cl_err("OPEN t303_gift_bcl:",STATUS,1)
                      LET l_lock_sw='Y'
                   ELSE
                      FETCH t303_gift_bcl INTO g_rar[l_ac].*
                      IF SQLCA.sqlcode THEN
                         CALL cl_err(g_rar_t.rar05,SQLCA.sqlcode,1)
                         LET l_lock_sw="Y"
                      END IF
                     #CALL t303_gift_rar06('d')
                      CALL t303_gift_set_entry(p_cmd)
                   END IF
              END IF
      BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rar[l_ac].* TO NULL 
                LET g_rar[l_ac].raracti='Y'
                LET g_rar_t.*=g_rar[l_ac].*
                LET g_rar_o.*=g_rar[l_ac].*
                CALL t303_gift_set_entry(p_cmd)
                CALL cl_show_fld_cont()
                IF g_argv3='2' THEN
                   LET g_rar[l_ac].rar04=0 
                   CALL cl_set_comp_visible("rar04",FALSE) 
                   NEXT FIELD rar05
                ELSE
                   NEXT FIELD rar04
                END IF 
                  
       AFTER INSERT
                IF INT_FLAG THEN
                   CALL cl_err('',9001,0)
                   LET INT_FLAG=0
                   CANCEL INSERT
                END IF
                INSERT INTO rar_file(rar01,rar02,rar03,rar04,rar05,rar06,rar07,
                                     rar08,raracti,rarplant,rarlegal)
                     VALUES(g_argv1,g_argv2,g_argv3,g_rar[l_ac].rar04,
                            g_rar[l_ac].rar05,g_rar[l_ac].rar06,g_rar[l_ac].rar07,
                            g_rar[l_ac].rar08,g_rar[l_ac].raracti,g_argv4,g_legal)                       
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","rar_file",g_argv2,g_rar[l_ac].rar05,SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                     MESSAGE 'INSERT Ok'
                     COMMIT WORK
                     LET g_rec_b=g_rec_b+1
                     DISPLAY g_rec_b To FORMONLY.cn2
                END IF

      BEFORE FIELD rar04
         IF g_argv3='2' THEN
            LET g_rar[l_ac].rar04=0 
            NEXT FIELD rar05
         #FUN-AB0033 mark -----------------start--------------------   
         #ELSE
         #   IF cl_null(g_rar[l_ac].rar04) OR g_rar[l_ac].rar04 = 0 THEN 
         #       SELECT MAX(rar04)+1 INTO g_rar[l_ac].rar04 FROM rar_file
         #        WHERE rar01=g_argv1 AND rar02=g_argv2 
         #          AND rar03=g_argv3 AND rarplant=g_argv4             
         #         #AND rar05=g_rar[l_ac].rar05
         #       IF cl_null(g_rar[l_ac].rar04) THEN
         #          LET g_rar[l_ac].rar04=1
         #       END IF
         #   END IF
         #FUN-AB0033 mark -----------------start--------------------   
         END IF
         
      AFTER FIELD rar04
        IF NOT cl_null(g_rar[l_ac].rar04) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                             g_rar[l_ac].rar04 <> g_rar_t.rar04) THEN
              IF g_rar[l_ac].rar04 < = 0 THEN
                 CALL cl_err(g_rar[l_ac].rar04,'aec-994',0)
                 NEXT FIELD rar04
              #FUN-AB0033 mark -------------------strat------------------   
              #ELSE
              #  SELECT COUNT(*) INTO l_n FROM rar_file
              #   WHERE rar01=g_argv1 AND rar02=g_argv2 
              #     AND rar03=g_argv3 AND rar04=g_rar[l_ac].rar04
              #     AND rarplant=g_argv4
              #  IF l_n>0 THEN
              #      CALL cl_err('',-239,0)
              #      LET g_rar[l_ac].rar04=g_rar_t.rar04
              #      NEXT FIELD rar04
              #  END IF
              #FUN-AB0033 mark --------------------end-------------------
              END IF
           END IF
           #FUN-AB0033 add --------------start----------------
           IF g_argv3 = '3' THEN     #FUN-B30012 ADD
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM rai_file
               WHERE rai03 = g_rar[l_ac].rar04
#FUN-B30012 ADD-BEGIN--
                 AND rai01 = g_argv1
                 AND rai02 = g_argv2
                 AND raiplant = g_argv4
#FUN-B30012 ADD-END----
              IF l_n=0 THEN
                 CALL cl_err('','aec-040',0)
                 LET g_rar[l_ac].rar04 = NULL
                 NEXT FIELD rar04
              END IF       
           END IF
           #FUN-AB0033 add ---------------end-----------------     
         END IF

      BEFORE FIELD rar05
        IF cl_null(g_rar[l_ac].rar05) OR g_rar[l_ac].rar05 = 0 THEN
            SELECT MAX(rar05)+1 INTO g_rar[l_ac].rar05 FROM rar_file
             WHERE rar01=g_argv1 AND rar02=g_argv2
               AND rar03=g_argv3 AND rarplant=g_argv4
              #AND rar05=g_rar[l_ac].rar05
               AND rar04=g_rar[l_ac].rar04                 #FUN-B30012 ADD
            IF cl_null(g_rar[l_ac].rar05) THEN
               LET g_rar[l_ac].rar05=1
            END IF
         END IF

      AFTER FIELD rar05
        IF NOT cl_null(g_rar[l_ac].rar05) THEN
           IF p_cmd = 'a' OR (p_cmd = 'u' AND
                             g_rar[l_ac].rar05 <> g_rar_t.rar05) THEN
              IF g_rar[l_ac].rar05 < = 0 THEN
                 CALL cl_err(g_rar[l_ac].rar05,'aec-994',0)
                 NEXT FIELD rar05
              ELSE
                SELECT COUNT(*) INTO l_n FROM rar_file
                 #FUN-AB0033 --------------start-----------------
                 #WHERE rar01=g_argv1 AND rar02=g_argv2 
                 #  AND rar03=g_argv3 AND rar05=g_rar[l_ac].rar05
                 #  AND rarplant=g_argv4
                 WHERE rar04=g_rar[l_ac].rar04 AND rar05=g_rar[l_ac].rar05
                 #FUN-AB0033 ---------------end------------------
                 #FUN-B30012---ADD--BEGIN------
                    AND rar01=g_argv1 AND rar02=g_argv2
                    AND rar03=g_argv3 AND rarplant=g_argv4
                 #FUN-B30012---ADD--END--------
                IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rar[l_ac].rar05=g_rar_t.rar05
                    NEXT FIELD rar05
                END IF
              END IF
           END IF
         END IF         

       AFTER FIELD rar06
           IF NOT cl_null(g_rar[l_ac].rar06) THEN
             #IF g_rar[l_ac].rar06<0 THEN #FUN-BB0058 mark
              IF g_rar[l_ac].rar06 < 1 THEN #FUN-BB0058 add
                 CALL cl_err(g_rar[l_ac].rar06,'art-184',0)
                 NEXT FIELD rar06
              END IF
           END IF
       
       AFTER FIELD rar07,rar08
           IF FGL_DIALOG_GETBUFFER()<0 THEN
              CALL cl_err('','alm-342',0)
              NEXT FIELD CURRENT
           END IF
           
                               
       BEFORE DELETE                      
          #IF g_rar_t.rar04 > 0 AND NOT cl_null(g_rar_t.rar04) THEN
           IF NOT cl_null(g_rar_t.rar04) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              
              SELECT COUNT(*) INTO l_n FROM ras_file
               WHERE ras01=g_argv1 AND ras02=g_argv2 AND ras03=g_argv3
                 AND ras05=g_rar_t.rar05 AND rasplant=g_argv4
                 AND ras04 = g_rar_t.rar04             #FUN-B30012 ADD
              IF l_n>0 THEN
                 CALL cl_err('','art-664',0)
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rar_file
               WHERE rar01=g_argv1 AND rar02=g_argv2 AND rar03=g_argv3
                 AND rar04=g_rar_t.rar04 AND rar05=g_rar_t.rar05
                 AND rarplant=g_argv4
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rar_file",g_rar_t.rar05,'',SQLCA.sqlcode,"","",1)  
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
              LET g_rar[l_ac].* = g_rar_t.*
              CLOSE t303_gift_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rar[l_ac].rar04,-263,1)
              LET g_rar[l_ac].* = g_rar_t.*
           ELSE
           #IF cl_null(g_rar[l_ac].rar06) THEN
           # DELETE FROM rar_file
           #  WHERE rar01=g_argv1 AND rar02=g_argv2 AND rar03=g_argv3
           #    AND rar04=g_rar_t.rar04 AND rar05=g_rar_t.rar05
           #    AND rarplant=g_argv4
           #  IF SQLCA.sqlcode THEN   
           #     CALL cl_err3("del","rar_file",g_rar_t.rar05,'',SQLCA.sqlcode,"","",1)  
           #     ROLLBACK WORK
           #  ELSE
           #     COMMIT WORK
           #     LET g_rec_b = g_rec_b-1
           #     DISPLAY g_rec_b TO FORMONLY.cn2
           #  END IF
           #ELSE
              UPDATE rar_file SET  rar05 = g_rar[l_ac].rar05,
                                   rar06 = g_rar[l_ac].rar06,
                                   rar07 = g_rar[l_ac].rar07,
                                   rar08 = g_rar[l_ac].rar08,
                                   raracti = g_rar[l_ac].raracti
                WHERE rar01=g_argv1 AND rar02=g_argv2 AND rar03=g_argv3
                  AND rar04=g_rar_t.rar04 AND rar05=g_rar_t.rar05
                  AND rarplant=g_argv4
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rar_file",g_rar_t.rar05,'',SQLCA.sqlcode,"","",1) 
                 LET g_rar[l_ac].* = g_rar_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           #END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
       #FUN-D30033--mark--str--
       #   IF cl_null(g_rar[l_ac].rar05) THEN
       #      CALL g_rar.deleteelement(l_ac)
       #   END IF
       #FUN-D30033--mark--end--
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rar[l_ac].* = g_rar_t.*
        #FUN-D30033--add--str--
              ELSE
             #   IF g_flag_b = '1' THEN     #TQC-D40025
                    CALL g_rar.deleteElement(l_ac)
                    IF g_rec_b != 0 THEN
                       LET g_action_choice = "detail"
                       LET l_ac = l_ac_t
                       LET g_flag_b = '1'     #TQC-D40025
                    END IF
             #   END IF                       #TQC-D40025
        #FUN-D30033--add--end--
              END IF
              CLOSE t303_gift_bcl    
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033
           CLOSE t303_gift_bcl  
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF (INFIELD(rar04) OR INFIELD(rar05)) AND l_ac > 1 THEN
              LET g_rar[l_ac].* = g_rar[l_ac-1].*
              IF g_argv3='2' THEN
                 LET g_rar[l_ac].rar04=0 
                 NEXT FIELD rar05
              ELSE
                 LET g_rar[l_ac].rar04 = g_rec_b + 1
                 NEXT FIELD rar04
              END IF 
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
       #ON ACTION controlp                         
       #  CASE
       #    WHEN INFIELD()                     
       #    OTHERWISE EXIT CASE
       #  END CASE
     
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
    END INPUT
    
    CLOSE t303_gift_bcl    
    COMMIT WORK
END FUNCTION
 
FUNCTION t303_gift_b1()
DEFINE
    l_ac1_t         LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE l_rtz04      LIKE rtz_file.rtz04       #FUN-BB0058 add
DEFINE l_cnt2        LIKE type_file.num5       #FUN-BB0058 add

   LET g_action_choice = ''   #TQC-D40025
    IF g_argv5<>'N' THEN
       CALL cl_err('','apm-267',0)
       RETURN 
    END IF

  #FUN-C10008 add START
    IF g_argv1 <> g_plant THEN
       CALL cl_err( '','art-977',0 )
       RETURN
    END IF
  #FUN-C10008 add END

    CALL s_showmsg_init()

   #LET g_forupd_sql = "SELECT ras04,ras05,ras06,ras07,'',ras08,'',rasacti",  #FUN-BB0058 mark
    LET g_forupd_sql = "SELECT ras04,ras05,ras06,ras07,'',ras08,'',ras09,rasacti",  #FUN-BB0058 add
                       "  FROM ras_file ",
                       " WHERE ras01=? AND ras02=? AND ras03=? ",
                       "   AND ras04=? AND ras05=? AND ras06=? ",
                       "   AND rasplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t3031_gift_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_ras WITHOUT DEFAULTS FROM s_ras.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
           CALL cl_set_comp_visible("ras04",g_argv3='3')

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()

           BEGIN WORK


           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
              LET g_ras_t.* = g_ras[l_ac1].*  #BACKUP
              LET g_ras_o.* = g_ras[l_ac1].*  #BACKUP
              IF p_cmd='u' THEN
                 #CALL cl_set_comp_entry("ras04",FALSE) #FUN-AB0033 mark
              END IF   
###-FUN-B30012 - MARK - BEGIN -----------------------------------------------
#          ELSE
#             #CALL cl_set_comp_entry("ras04",TRUE)     #FUN-AB0033 mark
#             CALL cl_set_comp_entry("ras04,ras05,ras06",TRUE)  #FUN-AB0033 add
#          END IF   
###-FUN-B30012 - MARK -  END  -----------------------------------------------
           
              OPEN t3031_gift_bcl USING g_argv1,g_argv2,g_argv3,g_ras_t.ras04,
                                        g_ras_t.ras05,g_ras_t.ras06,g_argv4
              IF STATUS THEN
                 CALL cl_err("OPEN t3031_gift_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t3031_gift_bcl INTO g_ras[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ras_t.ras05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t303_1_ras07('d',l_ac1)
                 CALL t303_1_ras08('d')
              END IF
###-FUN-B30012 - ADD - BEGIN -----------------------------------------------
           ELSE
              CALL cl_set_comp_entry("ras04,ras05,ras06",TRUE)
           END IF
###-FUN-B30012 - ADD -  END  -----------------------------------------------
          

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ras[l_ac1].* TO NULL

           #LET g_ras[l_ac1].ras06 = '1'            #Body default
           LET g_ras[l_ac1].ras06 = '01'            #FUN-A80104
           LET g_ras[l_ac1].rasacti = 'Y'          #Body default
           LET g_ras_t.* = g_ras[l_ac1].*
           LET g_ras_o.* = g_ras[l_ac1].*
           CALL cl_show_fld_cont()
           IF g_argv3='2' THEN
              LET g_ras[l_ac1].ras04=0 
              NEXT FIELD ras05
           ELSE
              NEXT FIELD ras04
           END IF 

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_ras[l_ac1].ras04) AND 
              NOT cl_null(g_ras[l_ac1].ras05) AND
              NOT cl_null(g_ras[l_ac1].ras06) THEN
              SELECT COUNT(*) INTO l_n FROM ras_file
               WHERE ras01=g_argv1 AND ras02=g_argv2 AND ras03=g_argv3
                 AND ras04=g_ras[l_ac1].ras04 
                 AND ras05=g_ras[l_ac1].ras05
                 AND ras06=g_ras[l_ac1].ras06
                 AND rasplant=g_argv4     
              IF l_n >0 THEN
                 CALL cl_err('','-239',0)
                 NEXT FIELD ras05
              END IF
           END IF 
#FUN-BB0058 add START
           IF g_ras[l_ac1].ras06 <> '11' THEN
              IF cl_null(g_ras[l_ac1].ras09) THEN
                 LET g_ras[l_ac1].ras09 = 0
              END IF
           END IF  
#FUN-BB0058 add END      
           INSERT INTO ras_file(ras01,ras02,ras03,ras04,ras05,ras06,ras07,ras08,ras09,  #FUN-BB0058 add ras09
                                rasacti,rasplant,raslegal)
           VALUES(g_argv1,g_argv2,g_argv3,g_ras[l_ac1].ras04,
                  g_ras[l_ac1].ras05,g_ras[l_ac1].ras06,
                  g_ras[l_ac1].ras07,g_ras[l_ac1].ras08,
                  g_ras[l_ac1].ras09,                    #FUN-BB0058 add
                  g_ras[l_ac1].rasacti,g_argv4,g_legal)

           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","ras_file",g_argv2,g_ras[l_ac1].ras05,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF


      BEFORE FIELD ras04
         IF g_argv3='2' THEN
            LET g_ras[l_ac1].ras04=0 
            NEXT FIELD ras05
         #FUN-AB0033 mark --------------------start-------------------   
         #ELSE
         #   IF cl_null(g_ras[l_ac1].ras04) OR g_ras[l_ac1].ras04 = 0 THEN 
         #       SELECT MAX(ras04)+1 INTO g_ras[l_ac1].ras04 FROM ras_file
         #        WHERE ras01=g_argv1 AND ras02=g_argv2 
         #          AND ras03=g_argv3 AND rasplant=g_argv4  
         #         #AND ras05=g_ras[l_ac1].ras05
         #       IF cl_null(g_ras[l_ac1].ras04) THEN
         #          LET g_ras[l_ac1].ras04=1
         #       END IF
         #   END IF
         #FUN-AB0033 mark --------------------start-------------------  
         END IF
         
      AFTER FIELD ras04
        IF NOT cl_null(g_ras[l_ac1].ras04) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                             g_ras[l_ac1].ras04 <> g_ras_t.ras04) THEN
              IF g_ras[l_ac1].ras04 < = 0 THEN
                 CALL cl_err(g_ras[l_ac1].ras04,'aec-994',0)
                 NEXT FIELD ras04
              END IF   
        #  END IF            #FUN-B30012 MARK 
              #FUN-AB003 add ---------------------start------------------   
              #ELSE
              #  SELECT COUNT(*) INTO l_n FROM ras_file
              #   WHERE ras01=g_argv1 AND ras02=g_argv2 
              #     AND ras03=g_argv3 AND ras04=g_ras[l_ac1].ras04
              #     AND rasplant=g_argv4
              #  IF l_n>0 THEN
              #      CALL cl_err('',-239,0)
              #      LET g_ras[l_ac1].ras04=g_ras_t.ras04
              #      NEXT FIELD ras04
              #  END IF
              LET l_n = 0
              IF NOT cl_null(g_ras[l_ac1].ras05) THEN
                 SELECT COUNT(*) INTO l_n FROM rar_file
                  WHERE rar04 = g_ras[l_ac1].ras04
           ##FUN-B30012 ADD ---BEGIN--------
                    AND rar01 = g_argv1
                    AND rar02 = g_argv2
                    AND rar03 = g_argv3
                    AND rar05 = g_ras[l_ac1].ras05
              ELSE
                 SELECT COUNT(*) INTO l_n FROM rar_file
                  WHERE rar04 = g_ras[l_ac1].ras04
                    AND rar01 = g_argv1
                    AND rar02 = g_argv2
                    AND rar03 = g_argv3
              END IF
           ##FUN-B30012 ADD ----END---------
              IF l_n=0 THEN
                 CALL cl_err('','aec-040',0)
                 LET g_ras[l_ac1].ras04 = NULL
                 NEXT FIELD ras04
              END IF       
              #FUN-AB0033 add ----------------------end-------------------  
           END IF            #FUN-B30012
         END IF

      AFTER FIELD ras05
         IF NOT cl_null(g_ras[l_ac1].ras05) THEN
            IF g_ras_o.ras05 IS NULL OR
               (g_ras[l_ac1].ras05 != g_ras_o.ras05 ) THEN
               CALL t303_1_ras05()    #檢查其有效性
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ras[l_ac1].ras05,g_errno,0)
                  LET g_ras[l_ac1].ras05 = g_ras_o.ras05
                  NEXT FIELD ras05
               END IF
            END IF
         END IF

      AFTER FIELD ras06
         IF NOT cl_null(g_ras[l_ac1].ras06) THEN
            CALL t303_1_ras06()   #FUN-BB0058 add
            IF g_ras_o.ras06 IS NULL OR
               (g_ras[l_ac1].ras06 != g_ras_o.ras06 ) THEN
               CALL t303_1_ras06()
               #FUN-AB0033 mark --------------start-----------------
               #IF NOT cl_null(g_errno) THEN
               #   CALL cl_err(g_ras[l_ac1].ras06,g_errno,0)
               #   LET g_ras[l_ac1].ras06 = g_ras_o.ras06
               #   NEXT FIELD ras06
               #END IF
               #FUN-AB0033 mark ---------------end------------------
            END IF
            #FUN-AB0033 --------------start-----------------
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
                             g_ras[l_ac1].ras06 <> g_ras_t.ras06) THEN
               SELECT COUNT(*) INTO l_n FROM ras_file
                  WHERE ras04=g_ras[l_ac1].ras04 AND ras05=g_ras[l_ac1].ras05 
                    AND ras06=g_ras[l_ac1].ras06 
                ##FUN-B30012 ADD  ----BEGIN----
                    AND ras01=g_argv1
                    AND ras02=g_argv2
                    AND ras03=g_argv3
                    AND rasplant=g_argv4
                ##FUN-B30012 ADD  -----END-----
                   
                   IF l_n>0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ras[l_ac1].ras06 = g_ras_o.ras06
                       NEXT FIELD ras06
                   END IF
            END IF       
            #FUN-AB0033 ---------------end------------------   
            #FUN-BB0058 add START
            IF g_ras[l_ac1].ras06 <> '11' THEN
               CALL cl_set_comp_entry("ras09",FALSE) 
            ELSE
               CALL cl_set_comp_entry("ras09",TRUE)
               CALL cl_set_comp_required("ras09",TRUE) 
            END IF
            #FUN-BB0058 add END 
         END IF

      ON CHANGE ras06
         IF NOT cl_null(g_ras[l_ac1].ras06) THEN
            CALL t303_1_ras06()
            LET g_ras[l_ac1].ras07=NULL
            LET g_ras[l_ac1].ras07_desc=NULL
            LET g_ras[l_ac1].ras08=NULL
            LET g_ras[l_ac1].ras08_desc=NULL
            DISPLAY BY NAME g_ras[l_ac1].ras07,g_ras[l_ac1].ras07_desc,
                            g_ras[l_ac1].ras08,g_ras[l_ac1].ras08_desc
         END IF

      BEFORE FIELD ras07,ras08 
         IF NOT cl_null(g_ras[l_ac1].ras06) THEN
            CALL t303_1_ras06()
           #IF g_ras[l_ac1].ras06='1' THEN
           #   CALL cl_set_comp_entry("ras08",TRUE)
           #   CALL cl_set_comp_required("ras08",TRUE)
           #ELSE
           #   CALL cl_set_comp_entry("ras08",FALSE)
           #END IF
         END IF

      AFTER FIELD ras07
         IF NOT cl_null(g_ras[l_ac1].ras07) THEN
            IF g_ras[l_ac1].ras06 = '01' THEN #FUN-AB0033 add
               #FUN-AA0059 ----------------start---------------
               IF NOT s_chk_item_no(g_ras[l_ac1].ras07,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_ras[l_ac1].ras07= g_ras_t.ras07
                  NEXT FIELD ras07
               END IF
               #FUN-AA0059 -----------------end----------------
            END IF  #FUN-AB0033 add
            IF g_ras_o.ras07 IS NULL OR
               (g_ras[l_ac1].ras07 != g_ras_o.ras07 ) THEN
               CALL t303_1_ras07('a',l_ac1)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ras[l_ac1].ras07,g_errno,0)
                  LET g_ras[l_ac1].ras07 = g_ras_o.ras07
                  NEXT FIELD ras07
               END IF
            END IF
       #FUN-BB0058 add START
            IF g_ras[l_ac1].ras06 = '01' THEN       
               SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_plant
               LET l_cnt2 = 0
               IF NOT cl_null(l_rtz04) THEN  
                  SELECT COUNT(*) INTO l_cnt2 FROM rte_file
                    WHERE rte03 = g_ras[l_ac1].ras07 AND rte01 = l_rtz04
                  IF l_cnt2 < 1 OR cl_null(l_cnt2) THEN
                     CALL cl_err('','art-389', 0 )
                     NEXT FIELD ras07
                  END IF
               END IF 
            END IF
       #FUN-BB0058 add END
         END IF

      AFTER FIELD ras08
         IF NOT cl_null(g_ras[l_ac1].ras08) THEN
            IF g_ras_o.ras08 IS NULL OR
               (g_ras[l_ac1].ras08 != g_ras_o.ras08 ) THEN
               CALL t303_1_ras08('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ras[l_ac1].ras08,g_errno,0)
                  LET g_ras[l_ac1].ras08 = g_ras_o.ras08
                  NEXT FIELD ras08
               END IF
            END IF
         END IF

#FUN-BB0058 add START
      AFTER FIELD ras09 
         IF NOT cl_null(g_ras[l_ac1].ras09) AND NOT cl_null(g_ras[l_ac1].ras06)THEN
            IF g_ras[l_ac1].ras06 = '11'THEN
               IF g_ras[l_ac1].ras09 <= 0 THEN
                  CALL cl_err('','art-778',0)
                  NEXT FIELD ras09
               END IF
            END IF
         END IF 
#FUN-BB0058 add END

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_ras_t.ras05 > 0 AND g_ras_t.ras05 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ras_file
               WHERE ras02 = g_argv2 AND ras01 = g_argv1
                 AND ras03 = g_argv3 AND ras04 = g_ras_t.ras04
                 AND ras05 = g_ras_t.ras05 AND ras06 = g_ras_t.ras06
                 AND rasplant = g_argv4
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ras_file",g_argv2,g_ras_t.ras07,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ras[l_ac1].* = g_ras_t.*
              CLOSE t3031_gift_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ras[l_ac1].ras05,-263,1)
              LET g_ras[l_ac1].* = g_ras_t.*
           ELSE
              IF g_ras[l_ac1].ras05<>g_ras_t.ras05 OR
                 g_ras[l_ac1].ras06<>g_ras_t.ras06 THEN
                 SELECT COUNT(*) INTO l_n FROM ras_file
                  WHERE ras01 = g_argv1 AND ras02 = g_argv2
                    AND ras03 = g_argv3  AND rasplant = g_argv4
                    AND ras04 = g_ras[l_ac1].ras04
                    AND ras05 = g_ras[l_ac1].ras05
                    AND ras06 = g_ras[l_ac1].ras06
             
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ras[l_ac1].* = g_ras_t.*
                    CLOSE t3031_gift_bcl
                    ROLLBACK WORK
                    EXIT INPUT
                   #NEXT FIELD ras05 
                 END IF
              END IF
              UPDATE ras_file SET ras05=g_ras[l_ac1].ras05,
                                  ras06=g_ras[l_ac1].ras06,
                                  ras07=g_ras[l_ac1].ras07,
                                  ras08=g_ras[l_ac1].ras08,
                                  ras09=g_ras[l_ac1].ras09,   #FUN-BB0058 add
                                  rasacti=g_ras[l_ac1].rasacti
               WHERE ras02 = g_argv2 AND ras01 = g_argv1
                 AND ras03 = g_argv3 AND ras04 = g_ras_t.ras04
                 AND ras05 = g_ras_t.ras05 AND ras06 = g_ras_t.ras06
                 AND rasplant = g_argv4
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ras_file",g_argv2,g_ras_t.ras07,SQLCA.sqlcode,"","",1)
                 LET g_ras[l_ac1].* = g_ras_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac1 = ARR_CURR()
        #   LET l_ac1_t = l_ac1    #FUN-D30033
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ras[l_ac1].* = g_ras_t.*
          #FUN-D30033--add--str--
              ELSE
              #  IF g_flag_b = '2' THEN             #TQC-D40025
                    CALL g_ras.deleteElement(l_ac1)
                    IF g_rec_b1 != 0 THEN
                       LET g_action_choice = "detail"
                       LET l_ac1 = l_ac1_t
                       LET g_flag_b = '2'           #TQC-D40025
                    END IF                            
              #  END IF                              #TQC-D40025
          #FUN-D30033--add--end--            
              END IF
              CLOSE t3031_gift_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac1_t = l_ac1    #FUN-D30033
          #CALL t303_repeat(g_ras[l_ac1].ras05)  #check
           CLOSE t3031_gift_bcl
           COMMIT WORK

        ON ACTION CONTROLO
           IF (INFIELD(ras04) OR INFIELD(ras05)) AND l_ac1 > 1 THEN
              LET g_ras[l_ac1].* = g_ras[l_ac1-1].*
              IF g_argv3='2' THEN
                 LET g_ras[l_ac1].ras04=0 
                #CALL cl_set_comp_visible("ras04",FALSE)
                 NEXT FIELD ras05
              ELSE
                 LET g_ras[l_ac1].ras04=g_rec_b1+1 
                 NEXT FIELD ras05
              END IF 
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
           CASE
             #WHEN INFIELD()
              WHEN INFIELD(ras07)
                 CALL cl_init_qry_var()
                 CASE g_ras[l_ac1].ras06
                 #   WHEN '1'
                    WHEN '01'   #FUN-A80104
                       IF cl_null(g_rtz.rtz05) THEN
#FUN-AA0059---------mod------------str-----------------                       
#                          LET g_qryparam.form="q_ima"                        
                         #CALL q_sel_ima(FALSE, "q_ima","",g_ras[l_ac1].ras07,"","","","","",'' )#FUN-BB0058 mark 
                          CALL q_sel_ima(FALSE, "q_ima"," ima154 = 'N' ",g_ras[l_ac1].ras07,"","","","","",'' )#FUN-BB0058 add 
                            RETURNING g_ras[l_ac1].ras07
#FUN-AA0059---------mod------------end-----------------                            
                       ELSE
                          LET g_qryparam.form = "q_rtg03_1"
                          LET g_qryparam.arg1 = g_rtz.rtz05
                       END IF
                  #  WHEN '2'
                    WHEN '02'    #FUN-A80104
                       LET g_qryparam.form ="q_oba01"
                  #  WHEN '3'
                    WHEN '03'    #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '1'
                  #  WHEN '4'
                    WHEN '04'    #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '2'
                  #  WHEN '5'
                    WHEN '05'    #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '3'
                  #  WHEN '6'
                    WHEN '06'    #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '4'
                  #  WHEN '7'
                    WHEN '07'    #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '5'
                  #  WHEN '8'
                    WHEN '08'     #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '6'
                  #  WHEN '9'
                    WHEN '09'     #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '27'
                 #FUN-BB0058 add START 
                    WHEN '10'   
                       LET g_qryparam.form ="q_lpx02"
                 #FUN-BB0058 add END 
                 END CASE
                 IF g_ras[l_ac1].ras06 != '01' OR (g_ras[l_ac1].ras06 = '01' AND NOT cl_null(g_rtz.rtz05)) THEN #FUN-AA0059 ADD
                    LET g_qryparam.default1 = g_ras[l_ac1].ras07
                    CALL cl_create_qry() RETURNING g_ras[l_ac1].ras07
                 END IF                 #FUN-AA0059 ADD 
                 CALL t303_1_ras07('d',l_ac1)
                 NEXT FIELD ras07
              WHEN INFIELD(ras08)
                 SELECT ima25 INTO g_ras[l_ac1].ras08 FROM ima_file
                  WHERE ima01=g_ras[l_ac1].ras07
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe02"
                 LET g_qryparam.arg1 = g_ras[l_ac1].ras08
                 LET g_qryparam.default1 = g_ras[l_ac1].ras08
                 CALL cl_create_qry() RETURNING g_ras[l_ac1].ras08
                 CALL t303_1_ras08('d')
                 NEXT FIELD ras08
              OTHERWISE EXIT CASE
            END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
    END INPUT



    CLOSE t3031_gift_bcl
    COMMIT WORK
    CALL s_showmsg()

END FUNCTION


#FUNCTION t303_gift_rar06(p_cmd)
#DEFINE    l_imaacti  LIKE ima_file.imaacti, 
#          l_ima02    LIKE ima_file.ima02,     
#          l_ima25    LIKE ima_file.ima25,
#          p_cmd      LIKE type_file.chr1
#DEFINE l_rte04 LIKE rte_file.rte04
#DEFINE l_rte07 LIKE rte_file.rte07
#          
#   LET g_errno = ' '
#   SELECT ima02,ima25,imaacti 
#     INTO l_ima02,l_ima25,l_imaacti 
#     FROM ima_file
#    WHERE ima01=g_rar[l_ac].rar06
#  CASE                          
#        WHEN SQLCA.sqlcode=100   LET g_errno='art-013' 
#                                 LET l_ima02=NULL 
#        WHEN l_imaacti='N'       LET g_errno='9028'     
#       OTHERWISE   
#       LET g_errno=SQLCA.sqlcode USING '------' 
#  END CASE   
#  IF cl_null(g_errno) THEN
#     SELECT rte07 INTO l_rte07 FROM rte_file
#      WHERE rte01 = g_rtz.rtz04
#        AND rte03 = g_rar[l_ac].rar06
#     CASE
#        WHEN SQLCA.sqlcode=100   LET g_errno='art-389'
#        WHEN l_rte07='N'         LET g_errno='9028'
#        WHEN l_rte04='N'         LET g_errno='art-523'
#       OTHERWISE
#       LET g_errno=SQLCA.sqlcode USING '------'
#     END CASE
#  END IF 
#  IF cl_null(g_errno) OR p_cmd = 'd' THEN
# 
#     LET g_rar[l_ac].rar06_desc = l_ima02
#     LET g_rar[l_ac].ima25 = l_ima25
#     SELECT gfe02 INTO g_rar[l_ac].ima25_desc FROM gfe_file
#      WHERE gfe01=g_rar[l_ac].ima25 AND gfeacti='Y'
#     SELECT rth04,rth05 INTO g_rar[l_ac].rth04,g_rar[l_ac].rth05
#       FROM rth_file
#      WHERE rth01 = g_rar[l_ac].rar06 
#        AND rth02 = g_rar[l_ac].ima25
#        AND rthacti = 'Y'
#     IF cl_null(g_rar[l_ac].rth04) OR cl_null(g_rar[l_ac].rth05) THEN
#        SELECT rtg05,rtg06 INTO g_rar[l_ac].rth04,g_rar[l_ac].rth05
#          FROM rtg_file
#         WHERE rtg01 = g_rtz.rtz05 AND rtg03 = g_rar[l_ac].rar06 AND rtg09 = 'Y'
#     END IF
#     DISPLAY BY NAME g_rar[l_ac].rar06_desc,g_rar[l_ac].ima25,
#                     g_rar[l_ac].ima25_desc
#  END IF
#END FUNCTION
 
FUNCTION t303_gift_b1_fill(p_wc2)              
DEFINE   p_wc2       STRING        

  #LET g_sql = "SELECT ras04,ras05,ras06,ras07,'',ras08,'',rasacti",  #FUN-BB0058 add
   LET g_sql = "SELECT ras04,ras05,ras06,ras07,'',ras08,'',ras09,rasacti",  #FUN-BB0058 add 
               "  FROM ras_file",
               " WHERE ras01='",g_argv1,"' AND ras02='",g_argv2,"'",
               "   AND ras03='",g_argv3,"' AND rasplant='",g_argv4,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ras04,ras05 "

   DISPLAY g_sql

   PREPARE t303_pb1 FROM g_sql
   DECLARE ras_cs CURSOR FOR t303_pb1

   CALL g_ras.clear()
   CALL cl_set_comp_visible("ras04",g_argv3='3')
   LET g_cnt = 1

   FOREACH ras_cs INTO g_ras[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL t303_1_ras07('d',g_cnt)
      #CALL t303_1_ras08('d')
       SELECT gfe02 INTO g_ras[g_cnt].ras08_desc FROM gfe_file
           WHERE gfe01 = g_ras[g_cnt].ras08

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ras.deleteElement(g_cnt)

   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

#FUN-BB0058 add START
FUNCTION t303_1_b(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
   IF g_argv3 = '2' THEN
      LET l_sql = " SELECT rae28,rae29,rae31 FROM rae_file ",
                  " WHERE rae01 = '",g_argv1,"' AND rae02 = '",g_argv2,"'",
                  "   AND raeplant = '",g_argv4,"'"
   ELSE
      LET l_sql = " SELECT rah20,rah21,rah23 FROM rah_file",
                  " WHERE rah01 = '",g_argv1,"' AND rah02 = '",g_argv2,"'",
                  "   AND rahplant = '",g_argv4,"'"                  
   END IF
   
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ",p_wc CLIPPED
   END IF
   PREPARE t303_1_b FROM l_sql
   EXECUTE t303_1_b INTO g_rae.*
   DISPLAY BY NAME g_rae.*
   
END FUNCTION

FUNCTION t303_1_updrae()

    IF g_argv5<>'N' THEN
       CALL cl_err('','apm-267',0)
       RETURN
    END IF

  #FUN-C10008 add START
    IF g_argv1 <> g_plant THEN
       CALL cl_err( '','art-977',0 )
       RETURN
    END IF
  #FUN-C10008 add END

   
   DISPLAY BY NAME g_rae.rae28,g_rae.rae29,g_rae.rae31

   CALL cl_set_head_visible("","YES")

#FUN-C60041 -------------STA
   LET g_rae.rae28 ='1'
   LET g_rae.rae29 ='1'
#FUN-C60041 -------------END
   INPUT BY NAME g_rae.rae28,g_rae.rae29,g_rae.rae31
      WITHOUT DEFAULTS

   AFTER INPUT
      IF g_argv3 = '2' THEN  #組合促銷
         UPDATE rae_file SET rae28 = g_rae.rae28, 
                             rae29 = g_rae.rae29,
                             rae31 = g_rae.rae31
                       WHERE rae01 = g_argv1  AND rae02 = g_argv2
                         AND raeplant = g_argv4   
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF 
      END IF
      IF g_argv3 = '3' THEN  #滿額促銷
         UPDATE rah_file SET rah20 = g_rae.rae28,
                             rah21 = g_rae.rae29,
                             rah23 = g_rae.rae31
                       WHERE rah01 = g_argv1  AND rah02 = g_argv2
                         AND rahplant = g_argv4
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
      END IF 

      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION CONTROLF
      CALL cl_set_focus_form(ui.Interface.getRootNode())
         RETURNING g_fld_name,g_frm_name
      CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT

   ON ACTION about
      CALL cl_about()

   ON ACTION HELP
      CALL cl_show_help()

   ON ACTION controls
      CALL cl_set_head_visible("","AUTO")

   END INPUT
END FUNCTION
#FUN-BB0058 add END

FUNCTION t303_gift_b_fill(p_wc1)              
DEFINE   p_wc1       STRING        
DEFINE   l_rtz05 LIKE rtz_file.rtz05
 
    LET g_sql = "SELECT rar04,rar05,rar06,rar07,rar08,raracti",
                "  FROM rar_file ",
                " WHERE rar01='",g_argv1,"' AND rar02='",g_argv2,"'",
                "   AND rar03='",g_argv3,"' AND rarplant='",g_argv4,"' "
   #IF NOT cl_null(g_argv5) THEN
   #   LET g_sql=g_sql CLIPPED," AND rar05=",g_argv5
   #END IF            
    IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY rar04,rar05 "

    DISPLAY g_sql
    
    PREPARE t303_gift_pb FROM g_sql
    DECLARE rar_cs CURSOR FOR t303_gift_pb
 
    CALL g_rar.clear()
    CALL cl_set_comp_visible("rar04",g_argv3='3')
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rar_cs INTO g_rar[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rar.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t303_gift_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
    
   #IF NOT cl_null(g_argv5) THEN
   #   CALL cl_set_comp_entry("rar05",FALSE)
   #   LET g_rar[l_ac].rar05 = g_argv5
   #   DISPLAY BY NAME g_rar[l_ac].rar05
   #ELSE 
       #CALL cl_set_comp_entry("rar05",p_cmd='a')       #FUN-AB0033 mark
       #CALL cl_set_comp_entry("rar04,rar05",p_cmd='a')  #FUN-AB0033  add
   #END IF
END FUNCTION
#No.FUN-870007

FUNCTION t303_1_ras05()
DEFINE l_n     LIKE type_file.num5

   LET g_errno = ' '
   LET l_n=0
   IF NOT cl_null(g_ras[l_ac1].ras04) THEN                #FUN-B30012 ADD

      SELECT COUNT(*) INTO l_n FROM rar_file
       WHERE rar01=g_argv1 AND rar02=g_argv2
#        AND rarplant=g_argv4 AND rar05 = g_ras[l_ac].ras05      #TQC-A90012 modify
         AND rarplant=g_argv4 AND rar05 = g_ras[l_ac1].ras05      #TQC-A90012 修改“換贈資料”組別控管
         AND raracti='Y'   AND rar03=g_argv3
#FUN-B30012 ADD  ----BEGIN----
         AND rar04 = g_ras[l_ac1].ras04
   ELSE
      SELECT COUNT(*) INTO l_n FROM rar_file
       WHERE rar01=g_argv1 AND rar02=g_argv2
         AND rarplant=g_argv4 AND rar05 = g_ras[l_ac1].ras05
         AND raracti='Y'   AND rar03=g_argv3
   END IF
#FUN-B30012 ADD  -----END-----
   IF l_n<1 THEN
      LET g_errno = 'art-654'     #當前組別不在第一單身中
   END IF

END FUNCTION

FUNCTION t303_1_ras06()
   LET g_errno = ' '   #FUN-BB0058 add
   #IF g_ras[l_ac1].ras06='1' THEN
   IF g_ras[l_ac1].ras06='01' THEN      #FUN-A80104
      CALL cl_set_comp_entry("ras08",TRUE)
      CALL cl_set_comp_required("ras08",TRUE)
   ELSE
      CALL cl_set_comp_entry("ras08",FALSE)
   END IF
  #IF g_ras[l_ac1].ras06=g_ras_t.ras06  THEN
  #   LET g_ras[l_ac1].ras07=g_ras_t.ras07
  #   LET g_ras[l_ac1].ras07_desc=g_ras_t.ras07_desc
  #   LET g_ras[l_ac1].ras08=g_ras_t.ras08
  #   LET g_ras[l_ac1].ras08_desc=g_ras_t.ras08_desc
  #ELSE
  #   LET g_ras[l_ac1].ras07=NULL
  #   LET g_ras[l_ac1].ras07_desc=NULL
  #   LET g_ras[l_ac1].ras08=NULL
  #   LET g_ras[l_ac1].ras08_desc=NULL
  #END IF

#FUN-BB0058 add START
  IF g_ras[l_ac1].ras06 = '11' THEN
     LET g_ras[l_ac1].ras07 = 'MISCCARD'
     CALL cl_set_comp_entry("ras07",FALSE)
     CALL cl_set_comp_required("ras09",TRUE)
  ELSE
     CALL cl_set_comp_entry("ras07",TRUE)
     CALL cl_set_comp_required("ras09",FALSE)
  END IF 
#FUN-BB0058 add END
END FUNCTION

FUNCTION t303_1_ras07(p_cmd,p_cnt)
DEFINE l_n         LIKE type_file.num5
DEFINE p_cnt       LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1

DEFINE    l_imaacti  LIKE ima_file.imaacti,
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE    l_ima154   LIKE ima_file.ima154  #FUN-BB0058 add

   LET g_errno = ' '

   CASE g_ras[p_cnt].ras06
      #WHEN '1'
      WHEN '01'      #FUN-A80104
         SELECT DISTINCT ima02,ima25,ima154,imaacti  #FUN-BB0058 add
           INTO l_ima02,l_ima25,l_ima154,l_imaacti   #FUN-BB0058 add
           FROM ima_file
          WHERE ima01=g_ras[p_cnt].ras07
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_ima02=NULL
            WHEN l_imaacti='N'       LET g_errno='9028'
            WHEN l_ima154= 'Y'       LET g_errno = 'art-796'  #FUN-BB0058 add
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '2'
      WHEN '02'      #FUN-A80104
         SELECT DISTINCT oba02,obaacti
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_ras[p_cnt].ras07 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '3'
      WHEN '03'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_ras[p_cnt].ras07 AND tqa03='1' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '4'
      WHEN '04'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_ras[p_cnt].ras07 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '5'
      WHEN '05'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_ras[p_cnt].ras07 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '6'
      WHEN '06'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_ras[p_cnt].ras07 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '7'
      WHEN '07'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_ras[p_cnt].ras07 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '8'
      WHEN '08'      #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_ras[p_cnt].ras07 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '9'
      WHEN '09'      #FUN-A80104
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_ras[p_cnt].ras07 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='art-155'
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_ras[p_cnt].ras06
         #WHEN '1'
         WHEN '01'      #FUN-A80104
            LET g_ras[p_cnt].ras07_desc = l_ima02
            IF cl_null(g_ras[p_cnt].ras08) THEN
               LET g_ras[p_cnt].ras08   = l_ima25
            END IF
            SELECT gfe02 INTO g_ras[p_cnt].ras08_desc FROM gfe_file
             WHERE gfe01=g_ras[p_cnt].ras08 AND gfeacti='Y'
            DISPLAY BY NAME g_ras[p_cnt].ras07_desc,g_ras[p_cnt].ras08,g_ras[p_cnt].ras08_desc
         #WHEN '2'
         WHEN '02'      #FUN-A80104
            LET g_ras[p_cnt].ras07_desc = l_oba02
            DISPLAY BY NAME g_ras[p_cnt].ras07_desc
         #WHEN '9'
         WHEN '09'      #FUN-A80104
            LET g_ras[p_cnt].ras07_desc = l_tqa02 CLIPPED,":",l_tqa05 CLIPPED,"-",l_tqa06 CLIPPED
           #LET g_ras[p_cnt].tqa05 = l_tqa05
           #LET g_ras[p_cnt].tqa06 = l_tqa06
            DISPLAY BY NAME g_ras[p_cnt].ras07_desc
         #TQC-C10125 add START
         WHEN '10'     
            SELECT lpx02 INTO g_ras[p_cnt].ras07_desc FROM lpx_file
             WHERE lpx01=g_ras[p_cnt].ras07 AND lpx15 = 'Y' AND lpx07 = 'Y' 
            DISPLAY BY NAME g_ras[p_cnt].ras07_desc
         #TQC-C10125 add END
         OTHERWISE
            LET g_ras[p_cnt].ras07_desc = l_tqa02
            DISPLAY BY NAME g_ras[p_cnt].ras07_desc
      END CASE
   END IF

END FUNCTION

FUNCTION t303_1_ras08(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac

   LET g_errno = ' '
   #IF g_ras[l_ac1].ras06<>'1' THEN
   IF g_ras[l_ac1].ras06<>'01' THEN    #FUN-A80104
      RETURN
   END IF
   IF cl_null(g_ras[l_ac1].ras07) THEN
      SELECT DISTINCT ima25
        INTO l_ima25
        FROM ima_file
       WHERE ima01=g_ras[l_ac1].ras07

      CALL s_umfchk(g_ras[l_ac1].ras07,l_ima25,g_ras[l_ac1].ras08)
         RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET g_errno = 'ams-823'
         RETURN
      END IF
   END IF
   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_ras[l_ac1].ras08 AND gfeacti = 'Y'
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN
      LET g_ras[l_ac1].ras08_desc=l_gfe02
      DISPLAY BY NAME g_ras[l_ac1].ras08_desc
   END IF
END FUNCTION
#FUN-A60044


