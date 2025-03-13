# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
#Pattern name..:"artt302_2.4gl"
#Descriptions..:會員等級促銷維護作業
#Date & Author...: No.FUN-A60044 10/06/20 By Cockroach 
# Modify.........: No.TQC-A90039 10/10/15 By houlia 修改會員等級報錯信息 
# Modify.........: No.TQC-B30183 11/03/25 By huangtao 組合促銷時，不顯示組別 
# Modify.........: No.FUN-BB0056 11/11/17 By pauline GP5.3 artt302 一般促銷單促銷功能優化
# Modify.........: No.FUN-BB0059 12/01/04 By pauline GP5.3 artt304 一般促銷單促銷功能優化調整
# Modify.........: No.FUN-C10008 12/01/04 By pauline GP5.3 artt302 一般促銷單促銷功能優化調整
# Modify.........: No.TQC-C20398 12/02/22 By pauline 會員類型/會員等級/會員卡種 開放可修改 
# Modify.........: No:FUN-D30033 13/04/18 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rap   DYNAMIC ARRAY OF RECORD 
                rap04       LIKE rap_file.rap04,
                rap05       LIKE rap_file.rap05, 
               #rap05_desc  LIKE lpf_file.lpf02, #FUN-BB0056 mark              
                rap05_desc  LIKE lpc_file.lpc02, #FUN-BB0056 add
                rap06       LIKE rap_file.rap06,
                rap07       LIKE rap_file.rap07,
                rap08       LIKE rap_file.rap08,
                rapacti     LIKE rap_file.rapacti
                        END RECORD,
        g_rap_t RECORD
                rap04       LIKE rap_file.rap04,
                rap05       LIKE rap_file.rap05,  
               #rap05_desc  LIKE lpf_file.lpf02, #FUN-BB0056 mark
                rap05_desc  LIKE lpc_file.lpc02, #FUN-BB0056 add              
                rap06       LIKE rap_file.rap06,
                rap07       LIKE rap_file.rap07,
                rap08       LIKE rap_file.rap08,
                rapacti     LIKE rap_file.rapacti
                        END RECORD
DEFINE   g_sql   STRING,
         g_wc   STRING,
         g_rec_b LIKE type_file.num5,
         l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_argv1         LIKE rap_file.rap01,
        g_argv2         LIKE rap_file.rap02,
        g_argv3         LIKE rap_file.rap03,
        g_argv4         LIKE rap_file.rapplant,
        g_argv5         LIKE rab_file.rabconf
DEFINE  g_argv6         LIKE rah_file.rah10  #促銷方式
DEFINE  g_argv7         LIKE rac_file.rac08   #會員促銷方式  #FUN-BB0056 add
DEFINE g_legal LIKE azw_file.azw01
 
#FUNCTION t302_2(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6)      #FUN-BB0056 mark
FUNCTION t302_2(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7)  #FUN-BB0056 add
DEFINE  p_argv1         LIKE rap_file.rap01,
        p_argv2         LIKE rap_file.rap02,
        p_argv3         LIKE rap_file.rap03,
        p_argv4         LIKE rap_file.rapplant,
        p_argv5         LIKE rab_file.rabconf
DEFINE  p_argv6         LIKE rah_file.rah10  #促銷方式
DEFINE  p_argv7         LIKE rac_file.rac08   #會員促銷方式   #FUN-BB0056 add
DEFINE  l_title         LIKE ze_file.ze03     #FUN-BB0056 add
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_argv4 = p_argv4
    LET g_argv5 = p_argv5
    LET g_argv6 = p_argv6
    LET g_argv7 = p_argv7        #FUN-BB0056 add 
    SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_argv4
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t302_2_w AT p_row,p_col WITH FORM "art/42f/artt302_2"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("artt302_2")
#TQC-B30183 ---------------STA
    IF g_argv3 = '2' THEN
       CALL cl_set_comp_visible("rap04",FALSE)
    END IF
#TQC-B30183 ---------------END
    #bnl add beg
#FUN-BB0056 add START
    LET l_title = ' '
    CASE g_argv7
       WHEN '1'
          SELECT ze03 INTO l_title FROM ze_file WHERE ze01= 'art-774' AND ze02= g_lang
       WHEN '2'
          SELECT ze03 INTO l_title FROM ze_file WHERE ze01= 'art-775' AND ze02= g_lang
       WHEN '3'
          SELECT ze03 INTO l_title FROM ze_file WHERE ze01= 'art-776' AND ze02= g_lang
    END CASE
    CALL cl_set_comp_att_text("rap05",l_title) 
#FUN-BB0056 add END

    IF NOT cl_null(g_argv6) THEN
       IF g_argv6 = '1' THEN
          CALL cl_set_comp_visible("rap07,rap08",FALSE)
          CALL cl_set_comp_visible("rap06",TRUE)
       END IF   
       IF g_argv6 = '2' THEN
          CALL cl_set_comp_visible("rap06,rap08",FALSE)
          CALL cl_set_comp_visible("rap07",TRUE)
       END IF   
       IF g_argv6 = '3' THEN
          CALL cl_set_comp_visible("rap06,rap07",FALSE)
          CALL cl_set_comp_visible("rap08",TRUE)
       END IF   
      #FUN-BB0059 add START
       IF g_argv6 = '4' THEN
          CALL cl_set_comp_visible("rap06,rap07",FALSE)
          CALL cl_set_comp_visible("rap08",TRUE)
       END IF
      #FUN-BB0059 add END
    END IF
    #bnl add end
    LET g_wc = " 1=1"
    CALL t302_2_b_fill(g_wc)
    IF g_argv5='N' THEN
       LET l_ac=g_rec_b+1
       IF g_argv1 = g_plant THEN  #FUN-C10008 add
          CALL t302_2_b()
       ELSE  #FUN-C10008 add
          CALL cl_err( '','art-977',0 )    #FUN-C10008 add
       END IF  #FUN-C10008 add
    END IF
    CALL t302_2_menu()
 
    CLOSE WINDOW t302_2_w
END FUNCTION
 
FUNCTION t302_2_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rap TO s_rap.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
 
FUNCTION t302_2_menu()
 
   WHILE TRUE
      CALL t302_2_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t302_2_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t302_2_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rap),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t302_2_q()
 
   CALL t302_2_b_askkey()
   
END FUNCTION
 
FUNCTION t302_2_b_askkey()
 
    CLEAR FORM
  
    CONSTRUCT g_wc ON rap04,rap05,rap06,rap07,rap08,rapacti
                    FROM s_rap[1].rap04,s_rap[1].rap05,s_rap[1].rap06,
                         s_rap[1].rap07,s_rap[1].rap08,s_rap[1].rapacti
 
           ON ACTION controlp
           CASE
              WHEN INFIELD(rap05)
                 CALL cl_init_qry_var()
               #FUN-BB0056 mark START 
               #  LET g_qryparam.form = "q_rap05"
               #  LET g_qryparam.state = "c"
               #  CALL cl_create_qry() RETURNING g_qryparam.multiret
               #FUN-BB0056 mark END
               #FUN-BB0056 add START
                 CASE g_argv7 
                    WHEN "3"
                       LET g_qryparam.form = "q_rap051"
                    WHEN "1"
                       LET g_qryparam.form = "q_lpc02"
                    WHEN "2"
                       LET g_qryparam.form = "q_lpc03"
                 END CASE 
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
               #FUN-BB0056 add END
                 DISPLAY g_qryparam.multiret TO rap05
                 NEXT FIELD rap05
 
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
 
    CALL t302_2_b_fill(g_wc)
    
END FUNCTION

FUNCTION t302_2_rap_entry(p_rap04)
DEFINE p_rap04    LIKE rap_file.rap04
DEFINE l_rac04    LIKE rac_file.rac04


  CASE g_argv3
     WHEN '1'
        SELECT rac04 INTO l_rac04 FROM rac_file
         WHERE rac01=g_argv1 AND rac02=g_argv2
           AND racplant=g_argv4 AND rac03 = p_rap04
           AND racacti='Y' AND rac08='Y'
    #WHEN '2'
     OTHERWISE
        LET l_rac04=' '
  END CASE

          CASE l_rac04
             WHEN '1'
                CALL cl_set_comp_entry("rap06",TRUE)
                CALL cl_set_comp_entry("rap07",FALSE)
                CALL cl_set_comp_entry("rap08",FALSE)
                CALL cl_set_comp_required("rap06",TRUE)
             WHEN '2'
                CALL cl_set_comp_entry("rap06",FALSE)
                CALL cl_set_comp_entry("rap07",TRUE)
                CALL cl_set_comp_entry("rap08",FALSE)
                CALL cl_set_comp_required("rap07",TRUE)
             WHEN '3'
                CALL cl_set_comp_entry("rap06",FALSE)
                CALL cl_set_comp_entry("rap07",FALSE)
                CALL cl_set_comp_entry("rap08",TRUE)
                CALL cl_set_comp_required("rap08",TRUE)
             OTHERWISE
                CALL cl_set_comp_entry("rap06",TRUE)
                CALL cl_set_comp_entry("rap07",TRUE)
                CALL cl_set_comp_entry("rap08",TRUE)
                CALL cl_set_comp_required("rap06",TRUE)
                CALL cl_set_comp_required("rap07",TRUE)
                CALL cl_set_comp_required("rap08",TRUE)
          END CASE
END FUNCTION 

FUNCTION t302_2_rap04()         
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE l_rac04       LIKE rac_file.rac04
DEFINE l_rac08       LIKE rac_file.rac08

   LET g_errno = ' '
   LET l_n=0
   CASE g_argv3
      WHEN '1'
         SELECT rac04,rac08,racacti INTO l_rac04,l_rac08,l_racacti FROM rac_file
          WHERE rac01=g_argv1 AND rac02=g_argv2
            AND racplant=g_argv4 AND rac03 = g_rap[l_ac].rap04
      WHEN '2'
#TQC-B30183 -----------STA
#        SELECT rae10,rae12,rafacti INTO l_rac04,l_rac08,l_racacti FROM rae_file,raf_file
#         WHERE rae01=g_argv1 AND rae02=g_argv2
#           AND rae01 =raf01  AND rae02 = raf02 
#           AND raeplant = rafplant
#           AND raeplant=g_argv4 AND raf03 = g_rap[l_ac].rap04
         SELECT rae10,rae12,raeacti INTO l_rac04,l_rac08,l_racacti FROM rae_file
          WHERE rae01=g_argv1 AND rae02=g_argv2
            AND raeplant=g_argv4 
#TQC-B30183 -----------END
  #bnl add beg
      WHEN '3'    
         SELECT rah10,rai07,raiacti INTO l_rac04,l_rac08,l_racacti FROM rai_file,rah_file
          WHERE rah01 = rai01 AND rah02 = rai02 AND rahplant = raiplant AND rai01=g_argv1 AND rai02=g_argv2
            AND raiplant=g_argv4 AND rai03 = g_rap[l_ac].rap04
   END CASE
   CASE                          
         WHEN SQLCA.sqlcode=100   LET g_errno = 'art-654' 
         WHEN l_rac08='N'         LET g_errno = 'art-655' 
         WHEN l_racacti='N'       LET g_errno = '9028' 
         OTHERWISE   
         LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE   
   IF l_rac04 = '1' THEN
      CALL cl_set_comp_entry("rap07,rap08",FALSE)
      CALL cl_set_comp_entry("rap06",TRUE)
      CALL cl_set_comp_required("rap06",TRUE)
   END IF   
   IF l_rac04 = '2' THEN
      CALL cl_set_comp_entry("rap06,rap08",FALSE)
      CALL cl_set_comp_entry("rap07",TRUE)
      CALL cl_set_comp_required("rap07",TRUE)
   END IF   
   IF l_rac04 = '3' THEN
      CALL cl_set_comp_entry("rap06,rap07",FALSE)
      CALL cl_set_comp_entry("rap08",TRUE)
      CALL cl_set_comp_required("rap08",TRUE)
   END IF   
  #bnl add end
END FUNCTION

FUNCTION t302_2_rap05(p_cmd)         
DEFINE    p_cmd   STRING,
         #l_rap05_desc LIKE lpf_file.lpf02  #FUN-BB0056 mark 
          l_rap05_desc LIKE lpc_file.lpc02  #FUN-BB0056 add
DEFINE l_n LIKE type_file.num5
          
   LET g_errno = ' '
  #FUN-BB0056 mark START 
  #SELECT lpf02 INTO l_rap05_desc FROM lpf_file
  # WHERE lpf01 = g_rap[l_ac].rap05 AND lpf05='Y'
  #FUN-BB0056 mark END

  #FUN-BB0056 add START
   CASE g_argv7
      WHEN '1'
         SELECT lpc02 INTO l_rap05_desc FROM lpc_file
          WHERE lpc01 = g_rap[l_ac].rap05 AND lpc00 = '6'
      WHEN '2'
         SELECT lpc02 INTO l_rap05_desc FROM lpc_file
          WHERE lpc01 = g_rap[l_ac].rap05 AND lpc00 = '7'
      WHEN '3'
         SELECT lph02 INTO l_rap05_desc FROM lph_file
          WHERE lph01 = g_rap[l_ac].rap05 AND lph24 = 'Y'  AND lphacti = 'Y'
   END CASE
  #FUN-BB0056 add END
  CASE                          
   #    WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002' #TQC-A90039 --mark 
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-138' #TQC-A90039 --add
                                 LET l_rap05_desc = NULL 
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
 #IF cl_null(g_errno) THEN
 #   SELECT COUNT(*) INTO l_n FROM lpf_file
 #    WHERE azp01 IN (SELECT azw01 FROM azw_file WHERE azw07=g_argv4 OR azw01=g_argv4)
 #      AND azp01 = g_rap[l_ac].rap04
 #   IF l_n=0 THEN
 #      LET g_errno='art-500'
 #   END IF
 #END IF 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rap[l_ac].rap05_desc=l_rap05_desc
     DISPLAY BY NAME g_rap[l_ac].rap05_desc
  END IF
 
END FUNCTION
 
FUNCTION t302_2_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT rap04,rap05,'',rap06,rap07,rap08,rapacti FROM rap_file ",
                " WHERE rap01='",g_argv1 CLIPPED,"' AND rap02='",g_argv2 CLIPPED,
                "' AND rap03='",g_argv3 CLIPPED,
                "' AND rapplant='",g_argv4 CLIPPED,"'"
              # "' AND rap03='",g_argv3 CLIPPED,"' AND rap04='",g_argv4 CLIPPED
              # "' AND rapplant='",g_argv4 CLIPPED,"'"
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
#FUN-BB0056 add START
    IF NOT cl_null(g_argv7) THEN 
       LET g_sql = g_sql ," AND rap09 = ",g_argv7
    END IF 
#FUN-BB0056 add END
    LET g_sql = g_sql," ORDER BY rap05"
    PREPARE t302_2_pb FROM g_sql
    DECLARE rap_cs CURSOR FOR t302_2_pb
 
    CALL g_rap.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rap_cs INTO g_rap[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
      #FUN-BB0056 mark START
      # SELECT lpf02 INTO g_rap[g_cnt].rap05_desc FROM lpf_file
      #  WHERE lpf01 = g_rap[g_cnt].rap05
      #FUN-BB0056 mark END
      #FUN-BB0056 add START
        CASE g_argv7
          WHEN '1'
             SELECT lpc02 INTO g_rap[g_cnt].rap05_desc FROM lpc_file
                WHERE lpc01 = g_rap[g_cnt].rap05 AND lpc00 = '6'
          WHEN '2'
             SELECT lpc02 INTO g_rap[g_cnt].rap05_desc FROM lpc_file
                WHERE lpc01 = g_rap[g_cnt].rap05 AND lpc00 = '7'
          WHEN '3'
             SELECT lph02 INTO g_rap[g_cnt].rap05_desc FROM lph_file
                WHERE lph01 = g_rap[g_cnt].rap05 AND lph24 = 'Y'  AND lphacti = 'Y'
        END CASE
      #FUN-BB0056 add END
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rap.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t302_2_b()
DEFINE l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
 
DEFINE l_price         LIKE rap_file.rap06,
       l_discount      LIKE rap_file.rap07
DEFINE l_rac08         LIKE rac_file.rac08   #FUN-BB0056 add 
   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
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
   CALL cl_opmsg('b')
   
   LET g_forupd_sql="SELECT rap04,rap05,'',rap06,rap07,rap08,rapacti ",
                   "   FROM rap_file",
                   "  WHERE rap01=? AND rap02=?",
                   "    AND rap03=? AND rap04=? ",
                   "    AND rap05=? AND rapplant=? ",
                   "    AND rap09 = ? ",   #FUN-BB0056 add 
                   "    FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t302_2_bcl CURSOR FROM g_forupd_sql
   
   LET l_allow_insert=cl_detail_input_auth("insert")
   LET l_allow_delete=cl_detail_input_auth("delete")
   
   INPUT ARRAY g_rap WITHOUT DEFAULTS FROM s_rap.*
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
      DISPLAY BY NAME g_rap[l_ac].rap05
      IF g_argv3 = '2' THEN
         CALL t302_2_rap04() 
      END IF     
      BEGIN WORK 
                  
      IF g_rec_b>=l_ac THEN 
         LET p_cmd ='u'
         LET g_rap_t.*=g_rap[l_ac].*
         CALL t302_2_rap04()                                       #TQC-B30183 add
         IF p_cmd ='u' THEN
           #CALL cl_set_comp_entry("rap04,rap05",FALSE)  #TQC-C20398 mark
            CALL cl_set_comp_entry("rap04",FALSE)  #TQC-C20398 add
         ELSE
           #CALL cl_set_comp_entry("rap04,rap05",TRUE)  #TQC-C20398 mark
            CALL cl_set_comp_entry("rap04",TRUE)  #TQC-C20398 add
         END IF
         
         OPEN t302_2_bcl USING g_argv1,g_argv2,g_argv3,
                               g_rap_t.rap04,g_rap_t.rap05,g_argv4, g_argv7   #FUN-BB0056 add g_argv7
         IF STATUS THEN
            CALL cl_err("OPEN t302_2_bcl:",STATUS,1)
            LET l_lock_sw='Y'
         ELSE
            FETCH t302_2_bcl INTO g_rap[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rap_t.rap04,SQLCA.sqlcode,1)
               LET l_lock_sw="Y"
            END IF
            CALL t302_2_rap05('d')
         END IF
      END IF
      
    BEFORE INSERT
       LET l_n=ARR_COUNT()
       LET p_cmd='a'
       INITIALIZE g_rap[l_ac].* TO NULL               
       LET g_rap_t.*=g_rap[l_ac].*
       LET g_rap[l_ac].rapacti = 'Y'    
       IF p_cmd ='u' THEN
         #CALL cl_set_comp_entry("rap04,rap05",FALSE)  #TQC-C20398 mark
          CALL cl_set_comp_entry("rap04",FALSE)  #TQC-C20398 add
       ELSE
         #CALL cl_set_comp_entry("rap04,rap05",TRUE)  #TQC-C20398 mark
          CALL cl_set_comp_entry("rap04",TRUE)  #TQC-C20398 add
       END IF
       CALL cl_show_fld_cont()
       NEXT FIELD rap04
    AFTER INSERT
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          CANCEL INSERT
       END IF
#TQC-B30183 -----------STA
       IF g_argv3 = '2' THEN
          LET g_rap[l_ac].rap04 = 0
       END IF
#TQC-B30183 -----------END 
       IF NOT cl_null(g_rap[l_ac].rap04) THEN
          IF cl_null(g_rap[l_ac].rap06) THEN LET g_rap[l_ac].rap06 = 0 END IF
          IF cl_null(g_rap[l_ac].rap08) THEN LET g_rap[l_ac].rap08 = 0 END IF
          INSERT INTO rap_file(rap01,rap02,rap03,rap04,rap05,rap06,
                               rap07,rap08,rap09,                    #FUN-BB0056 add rap09
                               rapacti,rapplant,raplegal)
             VALUES(g_argv1,g_argv2,g_argv3,g_rap[l_ac].rap04,
                    g_rap[l_ac].rap05,g_rap[l_ac].rap06,g_rap[l_ac].rap07,
                    g_rap[l_ac].rap08,g_argv7,                       #FUN-BB0056 add g_argv7 
                    g_rap[l_ac].rapacti,g_argv4,g_legal)
                 
          IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","rap_file",g_rap[l_ac].rap04,g_rap[l_ac].rap05,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT Ok'
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b To FORMONLY.cn2
          END IF
       END IF
    # BEFORE FIELD rap05
    #   IF cl_null(g_rap[l_ac].rap05) OR g_rap[l_ac].rap05 = 0 THEN 
    #       SELECT MAX(rap05)+1 INTO g_rap[l_ac].rap05 FROM rap_file
    #        WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv3
    #          AND rap04=g_argv4 AND rapplant=g_argv5
    #       IF cl_null(g_rap[l_ac].rap05) THEN
    #          LET g_rap[l_ac].rap05=1
    #       END IF
    #    END IF
    #    
    # AFTER FIELD rap05
    #   IF NOT cl_null(g_rap[l_ac].rap05) THEN 
    #      IF p_cmd = 'a' OR (p_cmd = 'u' AND 
    #                        g_rap[l_ac].rap05 <> g_rap_t.rap05) THEN
    #         IF g_rap[l_ac].rap05 < = 0 THEN
    #            CALL cl_err(g_rap[l_ac].rap05,'aec-994',0)
    #            NEXT FIELD rap05
    #         ELSE
    #           SELECT COUNT(*) INTO l_n FROM rap_file
    #            WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv3
    #              AND rap04=g_argv4 AND rap05=g_rap[l_ac].rap05
    #           IF l_n>0 THEN
    #               CALL cl_err('',-239,0)
    #               LET g_rap[l_ac].rap05=g_rap_t.rap05
    #               NEXT FIELD rap05
    #           END IF
    #         END IF
    #      END IF
    #    END IF
         
      AFTER FIELD rap04
         IF NOT cl_null(g_rap[l_ac].rap04) THEN
            IF g_rap_t.rap04 IS NULL OR
               (g_rap[l_ac].rap04 != g_rap_t.rap04 ) THEN
               CALL t302_2_rap04()    #檢查其有效性
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rap[l_ac].rap04,g_errno,0)
                  LET g_rap[l_ac].rap04 = g_rap_t.rap04
                  NEXT FIELD rap04
               END IF
            #FUN-BB0056 mark START
            #   IF g_argv3 = '1' THEN
            #      SELECT rac08 INTO l_rac08 FROM rac_file
            #        WHERE rac01 = g_argv1 AND rac02 = g_argv2 
            #          AND rac03 = g_rap[l_ac].rap04
            #      IF l_rac08 <> g_argv7 THEN
            #         CALL cl_err('','art-757',0)
            #         NEXT FIELD rap04 
            #      END IF
            #   END IF
            #FUN-BB0056 mark END
            #FUN-BB0056 add START
              #FUN-C10008 add START
               LET l_n = 0
               IF NOT cl_null(g_rap[l_ac].rap05) THEN
                  SELECT COUNT(*) INTO l_n FROM rap_file
                    WHERE rap01 = g_argv1 AND rap02 = g_argv2
                      AND rap03 = g_argv3 AND rap04 = g_rap[l_ac].rap04
                      AND rap05 = g_rap[l_ac].rap05
                  IF l_n > 0 THEN
                     CALL cl_err('','-239',0)
                     NEXT FIELD rap04
                  END IF
               END IF
              #FUN-C10008 add END
               IF g_argv3 = '1' THEN
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM rac_file
                    WHERE rac01 = g_argv1 AND rac02 = g_argv2
                      AND rac03 = g_rap[l_ac].rap04
                      AND rac08 = g_argv7
                      AND rac03 = g_rap[l_ac].rap04
                  IF l_n < 1 THEN
                     CALL cl_err('','art-757',0) 
                     NEXT FIELD rap04 
                  END IF 
               END IF
            #FUN-BB0056 add START
               IF g_argv3 = '3' THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM rai_file
                    WHERE rai01 = g_argv1 AND rai02 = g_argv2
                      AND rai03 = g_rap[l_ac].rap04
                      AND rai07 = g_argv7
                      AND rai03 = g_rap[l_ac].rap04
                  IF l_n < 1 THEN
                     CALL cl_err('','art-757',0)
                     NEXT FIELD rap04
                  END IF
               END IF
            #iFUN-BB0056 add START
            #FUN-BB0056 add END
            END IF
         END IF

      ON CHANGE rap04
         IF NOT cl_null(g_rap[l_ac].rap04) THEN
            CALL t302_2_rap04()
         END IF
     #FUN-BB0056 mark START
     #AFTER FIELD rap05
     #       IF NOT cl_null(g_rap[l_ac].rap05) THEN  
     #          IF p_cmd = 'a' OR (p_cmd = 'u' AND 
     #                       g_rap[l_ac].rap05 <> g_rap_t.rap05) THEN
     #          SELECT COUNT(*) INTO l_n FROM rap_file
     #           WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv3
     #             AND rapplant=g_argv4 AND rap04 = g_rap[l_ac].rap04
     #             AND rap05 = g_rap[l_ac].rap05
     #            IF l_n>0 THEN
     #                CALL cl_err('',-239,0)
     #                LET g_rap[l_ac].rap05=g_rap_t.rap05
     #                NEXT FIELD rap05
     #            ELSE  
     #              CALL t302_2_rap05('a')
     #              IF NOT cl_null(g_errno) THEN
     #                 CALL cl_err('rap05',g_errno,0)
     #                 LET g_rap[l_ac].rap05 = g_rap_t.rap05
     #                 DISPLAY BY NAME g_rap[l_ac].rap05
     #                 NEXT FIELD rap05
     #              END IF  
     #            END IF  
     #          END IF
     #       END IF
     #FUN-BB0056 mark END
     #FUN-BB0056 add START
      AFTER FIELD rap05
         IF NOT cl_null(g_rap[l_ac].rap05) THEN
            IF p_cmd = 'a' OR   #TQC-C20398 add
               (p_cmd = 'u' AND g_rap[l_ac].rap05 <> g_rap_t.rap05)  THEN  #TQC-C20398 add         
               IF g_argv3 = 2 THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM rap_file
                    WHERE rap01 = g_argv1 AND rap02 = g_argv2
                      AND rap03 = g_argv3 
                      AND rap05 = g_rap[l_ac].rap05
                  IF l_n > 0 THEN
                     CALL cl_err('','-239',0)
                     NEXT FIELD rap05
                  END IF
               ELSE
                 #FUN-C10008 add START
                  LET l_n = 0
                  IF NOT cl_null(g_rap[l_ac].rap05) THEN
                     SELECT COUNT(*) INTO l_n FROM rap_file
                       WHERE rap01 = g_argv1 AND rap02 = g_argv2
                         AND rap03 = g_argv3 AND rap04 = g_rap[l_ac].rap04
                         AND rap05 = g_rap[l_ac].rap05
                     IF l_n > 0 THEN
                        CALL cl_err('','-239',0)
                        NEXT FIELD rap05
                     END IF
                  END IF
               END IF
              #FUN-C10008 add END   
            END IF  #TQC-C20398 add
            LET l_n  = 0            
            CASE g_argv7            
               WHEN '1'             
                 SELECT COUNT(*) INTO l_n FROM lpc_file
                   WHERE lpc00 = '6' AND lpc01 = g_rap[l_ac].rap05 
               WHEN '2'          
                 SELECT COUNT(*) INTO l_n FROM lpc_file
                   WHERE lpc00 = '7' AND lpc01 = g_rap[l_ac].rap05
               WHEN '3'          
                 SELECT COUNT(*) INTO l_n FROM lph_file
                   WHERE lph24 = 'Y' AND lphacti = 'Y' AND lph01 = g_rap[l_ac].rap05
            END CASE             
            IF l_n < 1 THEN      
               CALL cl_err('','art-786',0)
               NEXT FIELD rap05  
            END IF               
            CASE g_argv7         
               WHEN '1'          
                 SELECT lpc02 INTO g_rap[l_ac].rap05_desc FROM lpc_file
                   WHERE lpc00 = '6' AND lpc01 = g_rap[l_ac].rap05
               WHEN '2'          
                 SELECT lpc02 INTO g_rap[l_ac].rap05_desc FROM lpc_file
                   WHERE lpc00 = '7' AND lpc01 = g_rap[l_ac].rap05
               WHEN '3'
                 SELECT lph02 INTO g_rap[l_ac].rap05_desc FROM lph_file  
                   WHERE lph24 = 'Y' AND lphacti = 'Y' AND lph01 = g_rap[l_ac].rap05
            END CASE
            DISPLAY BY NAME g_rap[l_ac].rap05_desc 
         END IF
     #FUN-BB0056 add END
 
      BEFORE FIELD rap06,rap07,rap08
         IF NOT cl_null(g_rap[l_ac].rap04) THEN
            CALL t302_2_rap04()
         END IF

      AFTER FIELD rap06    #會員特賣價
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
            CALL cl_err('','art-180',0)
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rap[l_ac].rap06
         END IF

      AFTER FIELD rap07   #會員折扣率
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rap[l_ac].rap07
           END IF

      AFTER FIELD rap08    #會員折讓額
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
            CALL cl_err('','art-653',0)
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rap[l_ac].rap08
         END IF

                           
       BEFORE DELETE                      
     #      IF g_rap_t.rap04 > 0 AND NOT cl_null(g_rap_t.rap04) THEN    #TQC-B30183  mark
            IF g_rap_t.rap04 >= 0 AND NOT cl_null(g_rap_t.rap04) THEN   #TQC-B30183  add
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rap_file
                     WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv3
                      AND rapplant=g_argv4 AND rap04=g_rap_t.rap04
                      AND rap05=g_rap_t.rap05
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rap_file",g_rap_t.rap04,'',SQLCA.sqlcode,"","",1)  
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
              LET g_rap[l_ac].* = g_rap_t.*
              CLOSE t302_2_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF g_rap[l_ac].rap04<>g_rap_t.rap04 OR
              g_rap[l_ac].rap05<>g_rap_t.rap05 THEN 
              SELECT COUNT(*) INTO l_n FROM rap_file
               WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv3
                 AND rapplant=g_argv4 AND rap04 = g_rap[l_ac].rap04
                 AND rap05 = g_rap[l_ac].rap05
              IF l_n>0 THEN
                  CALL cl_err(g_rap[l_ac].rap04,-239,0)
                  LET g_rap[l_ac].* = g_rap_t.*
                  NEXT FIELD CURRENT
              END IF
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rap[l_ac].rap04,-263,1)
              LET g_rap[l_ac].* = g_rap_t.*
           ELSE
            IF cl_null(g_rap[l_ac].rap04) THEN
             DELETE FROM rap_file
              WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv3
                AND rapplant=g_argv4 AND rap04=g_rap_t.rap04
                AND rap05=g_rap_t.rap05
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rap_file",g_rap_t.rap04,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
              ELSE
                 COMMIT WORK
                 LET g_rec_b=g_rec_b-1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
            ELSE
              UPDATE rap_file SET  rap04 = g_rap[l_ac].rap04,
                                   rap05 = g_rap[l_ac].rap05,
                                   rap06 = g_rap[l_ac].rap06,
                                   rap07 = g_rap[l_ac].rap07,
                                   rap08 = g_rap[l_ac].rap08,
                                   rapacti = g_rap[l_ac].rapacti
                    WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv3
                      AND rapplant=g_argv4 AND rap04=g_rap_t.rap04
                      AND rap05=g_rap_t.rap05
                      AND rap09 = g_argv7           #FUN-BB0056 add
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rap_file",g_rap_t.rap04,'',SQLCA.sqlcode,"","",1) 
                 LET g_rap[l_ac].* = g_rap_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac      #FUN-D30033
           IF cl_null(g_rap[l_ac].rap04) THEN
              CALL g_rap.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rap[l_ac].* = g_rap_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rap.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--              
              END IF
              CLOSE t302_2_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30033
           CLOSE t302_2_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF (INFIELD(rap04) OR INFIELD(rap05)) AND l_ac > 1 THEN
              LET g_rap[l_ac].* = g_rap[l_ac-1].*
             #LET g_rap[l_ac].rap05 = g_rec_b + 1
              NEXT FIELD rap04
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rap05)                     
               CALL cl_init_qry_var()
               #LET g_qryparam.state = "c"
             # LET g_qryparam.form ="q_lpf"   #FUN-BB0056 mark 

               #FUN-BB0056 add START
                 CASE g_argv7
                    WHEN "3"
                       LET g_qryparam.form = "q_lph04"
                    WHEN "1"
                       LET g_qryparam.form = "q_lpc02"
                    WHEN "2"
                       LET g_qryparam.form = "q_lpc03"
                 END CASE
               #FUN-BB0056 add END

             #FUN-BB0056 add START
             # IF g_argv7 = '3' THEN
             #    LET g_qryparam.form ="q_lph04"
             # ELSE 
             #    LET g_qryparam.form ="q_lpf"
             #    IF g_argv7 = '1' THEN
             #       LET g_qryparam.arg1  = '5'
             #    ELSE
             #       LET g_qryparam.arg1 =  '6'
             #    END IF
             # END IF
             #FUN-BB0056 add END
               LET g_qryparam.default1 = g_rap[l_ac].rap05
               CALL cl_create_qry() RETURNING g_rap[l_ac].rap05
               CALL t302_2_rap05('a')
             #FUN-BB0056 add START
               CASE g_argv7
                  WHEN '1'
                     SELECT lpc02 INTO g_rap[l_ac].rap05_desc FROM lpc_file
                       WHERE lpc01 = g_rap[l_ac].rap05 AND lpc00 = '6'
                  WHEN '2'
                     SELECT lpc02 INTO g_rap[l_ac].rap05_desc FROM lpc_file
                       WHERE lpc01 = g_rap[l_ac].rap05 AND lpc00 = '7'
                  WHEN '3'
                     SELECT lph02 INTO g_rap[l_ac].rap05_desc FROM lph_file
                       WHERE lph01 = g_rap[l_ac].rap05 AND lph24 = 'Y'  AND lphacti = 'Y'
               END CASE
               NEXT FIELD rap05
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
    END INPUT
  
    CLOSE t302_2_bcl
    COMMIT WORK
    
END FUNCTION                          
                                                   
FUNCTION t302_2_bp_refresh()
 
  DISPLAY ARRAY g_rap TO s_rap.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
#FUNCTION t302_2_create(p_ret)
#DEFINE p_ret STRING
#DEFINE l_tok base.StringTokenizer
#DEFINE l_rap04   LIKE rap_file.rap04
#DEFINE l_rap05   LIKE rap_file.rap05
#DEFINE l_rapacti LIKE rap_file.rapacti
#DEFINE l_n       LIKE type_file.num5
# 
#   LET l_rap05='Y'
#   LET l_tok = base.StringTokenizer.create(p_ret,"|")
#  #SELECT MAX(rap05)+1 INTO l_rap05 FROM rap_file
#  # WHERE rap01 = g_argv1 AND rap02 = g_argv2
#  #   AND rap03 = g_argv3 AND rap04 = g_argv4
#  #IF l_rap05 IS NULL THEN LET l_rap05 = 1 END IF
#   WHILE l_tok.hasMoreTokens()
#      LET l_rap04 = l_tok.nextToken()
#      SELECT COUNT(*) INTO l_n FROM rap_file
#       WHERE rap01 = g_argv1 AND rap02 = g_argv2
#         AND rap03 = g_argv3 AND rap04 = l_rap04
#         AND rapplant = g_argv4
#      IF l_n = 0 THEN
#         INSERT INTO rap_file(rap01,rap02,rap03,rap04,rap05,rap06,rapplant,raplegal)
#                       VALUES(g_argv1,g_argv2,g_argv3,l_rap04,
#                              l_rap05,l_rapacti,g_argv4,g_legal)
#        #LET l_rap05 = l_rap05 + 1
#      END IF
#   END WHILE   
#   CALL t302_2_b_fill(" 1=1")
#END FUNCTION 
##FUN-A60044
